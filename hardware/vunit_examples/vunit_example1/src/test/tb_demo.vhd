library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library vunit_lib;
context vunit_lib.vunit_context;

use vunit_lib.run_pkg.all;
use vunit_lib.check_pkg.all;

library multiplier_lib;

entity tb_with_test_cases is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_with_test_cases is
 signal A_i, B_i : std_logic_vector(7 downto 0);
  signal RES_o : std_logic_vector(15 downto 0);

  begin
      invdut : entity multiplier_lib.eight_bit_multiplier port map (A_i => A_i, B_i => B_i, RES_o => RES_o);

  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);

    for i in 0 to 255 loop -- 16 multiplier values
      A_i <= std_logic_vector(to_unsigned(i,8));
      for j in 1 to 255 loop -- 16 multiplicand values
        B_i <= std_logic_vector(to_unsigned(j,8));
        wait for 10 ns;
        check_equal(RES_o, std_logic_vector(unsigned(A_i)*unsigned(B_i)));
        wait for 10 ns;
      end loop;
    end loop;
    info("Testing for all the values is done.");
    test_runner_cleanup(runner);
    wait;
  end process;
end architecture;
