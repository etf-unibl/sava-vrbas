library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_interface is
	port
	(
		-- Input ports
		clk_i				: in  	std_logic;
		rpi_sda_io		: inout  std_logic_vector(0 downto 0);
		scl_i				: in  	std_logic;
		scl_o				: out		std_logic;
		codec_sda_io	: inout	std_logic_vector(0 downto 0);
		codec_xck		: out		std_logic
	);
end i2c_interface;



architecture arch of i2c_interface is

type t_state is (codec, rpi,idle);
signal state_reg  : t_state;
signal state_next : t_state;

signal codec_sda_o			:   STD_LOGIC_VECTOR (0 DOWNTO 0);
signal codec_oe				:   STD_LOGIC_VECTOR (0 DOWNTO 0);

signal rpi_sda_o				:   STD_LOGIC_VECTOR (0 DOWNTO 0);
signal rpi_oe					:   STD_LOGIC_VECTOR (0 DOWNTO 0);

signal codec_edge_falling				:	 std_logic;
signal rpi_edge_falling				:	 std_logic;
signal codec_edge_rising				:	 std_logic;
signal rpi_edge_rising				:	 std_logic;



signal		codec_clk :  std_logic;        -- outclk0.clk
signal		locked   :  std_logic;         --  locked.export
component pll_12MHz is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		locked   : out std_logic         --  locked.export
	);
end component;


component altiobuf_o IS
	PORT
	(
		datain		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		oe		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		dataout		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

component altiobuf_i IS
	PORT
	(
		datain		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		dataout		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

  component rising_edge_detector
    port(
      clk_i      : in   std_logic;
      rst_i      : in   std_logic;
      strobe_i   : in   std_logic;
      p_o        : out  std_logic
    );
  end component;
  
  component falling_edge_detector
    port(
      clk_i      : in   std_logic;
      rst_i      : in   std_logic;
      strobe_i   : in   std_logic;
      p_o        : out  std_logic
    );
  end component;

begin

codec_xck_inst : pll_12MHz
port map(
	refclk 	=> clk_i,
	rst 		=> '0',
	outclk_0 => codec_clk,
	locked	=> locked
	);

output_codec : altiobuf_o PORT MAP (
		datain	 => rpi_sda_o,
		oe	 => codec_oe,
		dataout	 => codec_sda_io
	);
	
output_rpi : altiobuf_o PORT MAP (
		datain	 => codec_sda_o,
		oe	 => rpi_oe,
		dataout	 => rpi_sda_io
	);
	
input_rpi : altiobuf_i PORT MAP (
		datain	 => rpi_sda_io,
		dataout	 => rpi_sda_o
	);

input_codec : altiobuf_i PORT MAP (
		datain	 => codec_sda_io,
		dataout	 => codec_sda_o
	);
	
codec_edge_detector_rising : rising_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => codec_sda_o(0),
           p_o      => codec_edge_rising);
			  
rpi_edge_detector_rising : rising_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => rpi_sda_o(0),
           p_o      => rpi_edge_rising);
			  
codec_edge_detector_falling : falling_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => codec_sda_o(0),
           p_o      => codec_edge_falling);
			  
rpi_edge_detector_falling : falling_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => rpi_sda_o(0),
           p_o      => rpi_edge_falling);

-- state register
  process(clk_i) is
  begin
    if rising_edge(clk_i) then
		state_reg <= state_next;
	 end if;
  end process;
  
  
  -- next state logic
  process(state_reg,rpi_edge_rising,rpi_edge_falling) is
  begin
   case state_reg is
		when codec =>
			if rpi_edge_falling = '1' then
				state_next <= rpi;
			else
				state_next <= codec;
			end if;
		when rpi =>
			if rpi_edge_rising = '1' then
				state_next <= idle;
			else
				state_next <= rpi;
			end if;
		when idle =>
			state_next <= codec;
	end case;
  end process;
  
  
  -- output logic
  process(state_reg) is
  begin
	case state_reg is
		when rpi =>
			codec_oe <= (others => '1');
			rpi_oe 	<= (others => '0');
		when codec =>
			codec_oe <= (others => '0');
			rpi_oe 	<= (others => '1');
		when idle =>
			codec_oe <= (others => '0');
			rpi_oe 	<= (others => '1');
			
	end case;
  end process;

--codec_oe <= (others => '1');
--rpi_oe	<= (others => '0');
  
  -- concurrent
  scl_o 				<= scl_i;
  codec_xck			<= codec_clk;
end arch;
