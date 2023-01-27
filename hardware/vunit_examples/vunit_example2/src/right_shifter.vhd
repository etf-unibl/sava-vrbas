library ieee;
use ieee.std_logic_1164.all;

entity right_shifter is
    port (
        A_i   : in  std_logic_vector(7 downto 0);
        AMT_i : in integer;
        Y_o   : out std_logic_vector(7 downto 0)
    );
end right_shifter;

architecture rtl of right_shifter is
signal added: std_logic_vector(7 downto 0);
begin
	added <= "00000000";
	with AMT_i select 
		Y_o <= added(6 downto 0) & A_i(7) when 7,
				added(5 downto 0) & A_i(7 downto 6) when 6,
				added(4 downto 0) & A_i(7 downto 5) when 5,
				added(3 downto 0) & A_i(7 downto 4) when 4,
				added(2 downto 0) & A_i(7 downto 3) when 3,
				added(1 downto 0) & A_i(7 downto 2) when 2,
				added(0) & A_i(7 downto 1) when 1,
				A_i when others;
end architecture;