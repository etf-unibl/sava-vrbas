library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity i2c is
  port(
    clk_i : in std_logic;
	 codec_clk_xck_o, codec_clk_bclk_o : out std_logic;
	 clk_12_o : out std_logic;
    i2c_data_i, i2c_clk_i : inout std_logic;
	 i2c_data_o, i2c_clk_o : inout std_logic
  );
end i2c;

architecture arch of i2c is

  component clock_12MHz is
		port (
			refclk   : in  std_logic; -- clk
			rst      : in  std_logic; -- reset
			outclk_0 : out std_logic; -- clk
			locked   : out std_logic  -- export
		);
	end component clock_12MHz;
  signal clk_12MHz, locked : std_logic;
  signal counter : integer range 0 to 7 := 0;
  type states is (start, write1, read1, stop);
  signal state_reg, state_next : states;
begin
  clock_12mhz_inst : component clock_12MHz
		port map (
			refclk   => clk_i,     --  refclk.clk
			rst      => '0',       --   reset.reset
			outclk_0 => clk_12MHz, -- outclk0.clk
			locked   => locked     --  locked.export
		);
		
-- for demonstrating propagation of CLK
  i2c_clk_o <= i2c_clk_i;
-- set to High Impedance for using bus without fpga interfering
  i2c_data_o <= 'Z';
  
  codec_clk_xck_o <= clk_12MHz;
  clk_12_o <= clk_12MHz;
  codec_clk_bclk_o <= clk_12MHz;
end arch;