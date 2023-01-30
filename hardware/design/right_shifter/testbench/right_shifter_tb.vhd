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
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_1164;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

USE vunit_lib.run_pkg.ALL;
USE vunit_lib.check_pkg.ALL;

LIBRARY common_lib;

ENTITY tb_example IS
GENERIC (runner_cfg : STRING);
END ENTITY;

ARCHITECTURE tb OF tb_example IS

  SIGNAL A_i : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL AMT_i : INTEGER;
  SIGNAL Y_o : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
-- Instantiate the right shifter
  uut : ENTITY common_lib.right_shifter
     PORT MAP (
      A_i   => A_i,
      AMT_i => AMT_i,
      Y_o   => Y_o);

  test_runner : PROCESS
  BEGIN
-- Test runner configuration
    test_runner_setup(runner, runner_cfg);

     WHILE test_suite LOOP

       IF run("no_shift") THEN
         info("Performing first test!");
         A_i <= "00101110";
         AMT_i <= 0;
         WAIT FOR 10 ns;
         check_equal(Y_o, STD_LOGIC_VECTOR'("00101110"));
       ELSIF run("shift_right") THEN
         info("Performing second test!");
         A_i <= "00101110";
         AMT_i <= 3;
         WAIT FOR 10 ns;
         check_equal(Y_o, STD_LOGIC_VECTOR'("00000101"));
       ELSIF run("shift_amount_overflow") THEN
         info("Performing third test!");
         A_i <= "00101110";
         AMT_i <= 8;
         WAIT FOR 10 ns;
         check_equal(Y_o, STD_LOGIC_VECTOR'("00101110"));
       END IF;
     END LOOP;

    test_runner_cleanup(runner);
  END PROCESS;
END ARCHITECTURE;
