library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_tb is
end rx_tb;

architecture testbench of rx_tb is
  signal bclk_i : std_logic := '0';
  signal ws_i : std_logic := '0';
  signal sd_i : std_logic := '0';
  signal data_l_o : std_logic_vector(23 downto 0);
  signal count_o : std_logic_vector(23 downto 0);
  signal data_r_o : std_logic_vector(23 downto 0);
  signal data_o : std_logic_vector(23 downto 0);
  signal counter_s : std_logic;
  signal enable_ee : std_logic;
  signal enable_ll : std_logic;
  signal enable_rr : std_logic;
  
  component rx is
    port(
      bclk_i : in std_logic;
      ws_i : in std_logic;
      sd_i : in std_logic;
      data_l_o : out std_logic_vector(23 downto 0);
		count_o : out std_logic_vector(23 downto 0);
		data_o : out std_logic_vector(23 downto 0);
		counter_s : out std_logic;
		enable_ee : out std_logic;
		enable_ll : out std_logic;
		enable_rr : out std_logic;
      data_r_o : out std_logic_vector(23 downto 0)
    );
  end component;

begin
  dut: rx
    port map(
      bclk_i => bclk_i,
      ws_i => ws_i,
      sd_i => sd_i,
      data_l_o => data_l_o,
		count_o => count_o,
		data_o => data_o,
      counter_s => counter_s,
		enable_ee => enable_ee,
		enable_ll => enable_ll,
		enable_rr => enable_rr,
      data_r_o => data_r_o
    );

  clocking: process
  begin
    bclk_i <= not bclk_i;
    wait for 10 ns;
  end process;

  sd: process
  begin
    sd_i <= '0';
    wait for 40 ns;
	 sd_i <= '1';
	 wait for 20 ns;
  end process;
  
  stimulus: process
  begin
    ws_i <= '0';
    wait for 500 ns;
    ws_i <= '1';
    wait for 500 ns;
  end process;
end testbench;