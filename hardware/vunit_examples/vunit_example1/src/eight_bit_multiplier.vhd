library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity eight_bit_multiplier is
  port (
    A_i   : in  std_logic_vector(7 downto 0);
    B_i   : in  std_logic_vector(7 downto 0);
    RES_o : out std_logic_vector(15 downto 0)
);
end eight_bit_multiplier;

architecture arch of eight_bit_multiplier is
begin

  multipler : process ( B_i, A_i)
    variable temp_product, temp_b_shift : unsigned (15 downto 0);
  begin
    temp_product := "0000000000000000";
    temp_b_shift := unsigned("00000000" & B_i);
    for i in 0 to 7 loop
      if A_i(i) = '1' then
        temp_product := temp_product + temp_b_shift;
      end if;
      temp_b_shift := temp_b_shift(14 downto 0) & '0';
    end loop;
    RES_o <= std_logic_vector(temp_product);
  end process multipler;
end architecture arch;
