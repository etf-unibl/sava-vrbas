library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (clk, reset, enable : in std_logic;
          count : out std_logic_vector (4 downto 0));
end counter;

architecture arch of counter is
  signal count_pom : unsigned (4 downto 0);
begin
    process (clk, reset)
    begin
        if (reset = '1') then
            count_pom <= (others => '0');
        elsif (clk'event and clk = '1' and enable = '1') then
				if(count_pom = 24) then
				   count_pom <= (others => '0');
				else
					count_pom <= count_pom + 1;
				end if;
        end if;
    end process;
	 count <= std_logic_vector(count_pom);
end arch;