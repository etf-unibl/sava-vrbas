library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_1164;

library vunit_lib;
context vunit_lib.vunit_context;

use vunit_lib.run_pkg.all;
use vunit_lib.check_pkg.all;

library common_lib;

entity tb_example is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_example is
     
  signal A_i : std_logic_vector(7 downto 0) := (others => '0');
  signal AMT_i : integer;
  signal Y_o : std_logic_vector(7 downto 0);

begin
  -- Instantiate the right shifter
  uut: entity common_lib.right_shifter port map(A_i => A_i, AMT_i => AMT_i, Y_o => Y_o);

test_runner : process
begin
-- Test runner configuration
test_runner_setup(runner, runner_cfg);

while test_suite loop

 if run("no_shift") then
   info("Performing first test!");
   A_i <= "00101110";
   AMT_i <= 0;
   wait for 10 ns;
   check_equal(Y_o, std_logic_vector'("00101110"));

 elsif run("shift_right") then
   info("Performing second test!");
   A_i <= "00101110";
   AMT_i <= 3;
   wait for 10 ns;
   check_equal(Y_o, std_logic_vector'("00000101"));

 elsif run("shift_amount_overflow") then
   info("Performing third test!");
   A_i <= "00101110";
   AMT_i <= 8;
   wait for 10 ns;
   check_equal(Y_o, std_logic_vector'("00101110"));
   end if;
   end loop;

 test_runner_cleanup(runner);
end process;
end architecture;