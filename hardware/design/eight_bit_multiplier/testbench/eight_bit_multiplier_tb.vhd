-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:    EIGHT-BIT MULTIPLIER VUNIT TESTBENCH
--
-- description:
--
-- This file implements eight bit multiplier testbench, following  VUnit testbench form.
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

USE vunit_lib.run_pkg.ALL;
USE vunit_lib.check_pkg.ALL;

LIBRARY common_lib;

ENTITY tb_with_test_cases IS
GENERIC (runner_cfg : STRING);
END ENTITY;

ARCHITECTURE tb OF tb_with_test_cases IS
   SIGNAL A_i, B_i : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL RES_o : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
   invdut : ENTITY common_lib.eight_bit_multiplier
     PORT MAP (
      A_i => A_i,
      B_i => B_i,
      RES_o => RES_o);

   test_runner : PROCESS
   BEGIN
     test_runner_setup(runner, runner_cfg);

-- Put common test case setup code here
       FOR i IN 0 TO 255 LOOP -- 16 multiplier values
         A_i <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
         FOR j IN 1 TO 255 LOOP -- 16 multiplicand values
           B_i <= STD_LOGIC_VECTOR(to_unsigned(j, 8));
           WAIT FOR 10 ns;
           info("Testing multiplying for: A_i = to_string(unsigned(A_i)) and to_string(unsigned(B_i))");
           check_equal(RES_o, STD_LOGIC_VECTOR(unsigned(A_i) * unsigned(B_i)));
           WAIT FOR 10 ns;
         END LOOP;
       END LOOP;

     test_runner_cleanup(runner);
     WAIT;
   END PROCESS;
END ARCHITECTURE;
