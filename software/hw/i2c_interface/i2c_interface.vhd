library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_interface is
	port
	(
		-- Input ports
		clk_i			: in  std_logic;
		rpi_sda_io	: inout  std_logic_vector(0 downto 0);
		scl_i			: in  std_logic;
		scl_o			: out	std_logic;
		codec_sda_io	: inout	std_logic_vector(0 downto 0)
	);
end i2c_interface;



architecture arch of i2c_interface is

type t_state is (idle, codec_low, rpi_low);
signal state_reg  : t_state;
signal state_next : t_state;

signal codec_sda_o			:   STD_LOGIC_VECTOR (0 DOWNTO 0);
signal codec_oe				:   STD_LOGIC_VECTOR (0 DOWNTO 0);

signal rpi_sda_o				:   STD_LOGIC_VECTOR (0 DOWNTO 0);
signal rpi_oe					:   STD_LOGIC_VECTOR (0 DOWNTO 0);

signal codec_edge				:	 std_logic;
signal rpi_edge				:	 std_logic;

component altiobuf_o IS
	PORT
	(
		datain		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		oe		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		dataio		: INOUT STD_LOGIC_VECTOR (0 DOWNTO 0);
		dataout		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

  component dual_edge_detector
    port(
      clk_i      : in   std_logic;
      rst_i      : in   std_logic;
      strobe_i   : in   std_logic;
      p_o        : out  std_logic
    );
  end component;

begin

codec_altiobuf : altiobuf_o 
PORT MAP (
		datain	 => rpi_sda_o,
		oe	       => codec_oe,
		dataio	 => codec_sda_io,
		dataout	 => codec_sda_o
	);

	
rpi_altiobuf : altiobuf_o 
PORT MAP (
		datain	 => codec_sda_o,
		oe	 		 => rpi_oe,
		dataio	 => rpi_sda_io,
		dataout	 => rpi_sda_o
	);
	
codec_edge_detector : dual_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => codec_sda_o(0),
           p_o      => codec_edge);
			  
rpi_edge_detector : dual_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => rpi_sda_o(0),
           p_o      => rpi_edge);

-- state register
  process(clk_i) is
  begin
    if rising_edge(clk_i) then
		state_reg <= state_next;
	 end if;
  end process;
  
  
  -- next state logic
  process(state_reg,rpi_edge,codec_edge) is
  begin
   case state_reg is
		when idle =>
			if rpi_edge = '1' then
				state_next <= rpi_low;
			elsif codec_edge = '1' then
				state_next <= codec_low;
			else
				state_next <= idle;
			end if;
		when rpi_low =>
			if rpi_edge = '1' then
				state_next <= idle;
			else
				state_next <= rpi_low;
			end if;
		when codec_low =>
			if codec_edge = '1' then
				state_next <= idle;
			else
				state_next <= codec_low;
			end if;
	end case;
  end process;
  
  
  -- output logic
  process(state_reg) is
  begin
	case state_reg is
		when idle =>
			codec_oe <= (others => '1');
			rpi_oe	<= (others => '1');
		when rpi_low =>
			codec_oe <= (others => '0');
			rpi_oe 	<= (others => '1');
		when codec_low =>
			codec_oe <= (others => '1');
			rpi_oe 	<= (others => '0');
	end case;
  end process;
  
  -- concurrent
  scl_o 				<= scl_i;
end arch;
