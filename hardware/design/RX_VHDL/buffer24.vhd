library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buffer24 is
  port (
    clk_i        : in  std_logic;
    write_enable : in  std_logic;
    data_in      : in  std_logic_vector (23 downto 0);
    data_out     : out std_logic_vector (23 downto 0));
end entity;

architecture behavioral of buffer24 is
begin
  process (clk_i, write_enable)
  begin
    if (rising_edge(clk_i) and write_enable = '1') then
      data_out <= data_in;
    end if;
  end process;
end architecture;