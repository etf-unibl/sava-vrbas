-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:    RIGHT-SHIFTER VUNIT TESTBENCH
--
-- description:
--
--  This file implements right-shifter testbench, following  VUnit testbench form.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2022 Faculty of Electrical Engineering
-----------------------------------------------------------------------------
-- The MIT License
-----------------------------------------------------------------------------
-- Copyright 2022 Faculty of Electrical Engineering
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom
-- the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
-- THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_1164;

library vunit_lib;
context vunit_lib.vunit_context;

use vunit_lib.run_pkg.all;
use vunit_lib.check_pkg.all;

library common_lib;

entity tb_example is
generic (runner_cfg : STRING);
end entity;

architecture tb of tb_example is

  signal A_i : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  signal AMT_i : INTEGER;
  signal Y_o : STD_LOGIC_VECTOR(7 downto 0);

begin

  uut : entity common_lib.right_shifter
     port map (
      A_i   => A_i,
      AMT_i => AMT_i,
      Y_o   => Y_o);

  test_runner : process
  begin

    test_runner_setup(runner, runner_cfg);

     while test_suite loop

       if run("no_shift") then
         info("Performing first test!");
         A_i <= "00101110";
         AMT_i <= 0;
         wait for 10 ns;
         check_equal(Y_o, STD_LOGIC_VECTOR'("00101110"));
       elsif run("shift_right") then
         info("Performing second test!");
         A_i <= "00101110";
         AMT_i <= 3;
         wait for 10 ns;
         check_equal(Y_o, STD_LOGIC_VECTOR'("00000101"));
       elsif run("shift_amount_overflow") then
         info("Performing third test!");
         A_i <= "00101110";
         AMT_i <= 8;
         wait for 10 ns;
         check_equal(Y_o, STD_LOGIC_VECTOR'("00101110"));
       end if;
     end loop;

    test_runner_cleanup(runner);
  end process;
end architecture;
