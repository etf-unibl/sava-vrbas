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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

use vunit_lib.run_pkg.all;
use vunit_lib.check_pkg.all;

library common_lib;

entity tb_with_test_cases is
generic (runner_cfg : STRING);
end entity;

architecture tb of tb_with_test_cases is
   signal A_i, B_i : STD_LOGIC_VECTOR(7 downto 0);
   signal RES_o : STD_LOGIC_VECTOR(15 downto 0);

begin
   invdut : entity common_lib.eight_bit_multiplier
     port map (
      A_i   => A_i,
      B_i   => B_i,
      RES_o => RES_o);

   test_runner : process
   begin
     test_runner_setup(runner, runner_cfg);

       for i in 0 to 255 loop -- 16 multiplier values
         A_i <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
         for j in 1 to 255 loop -- 16 multiplicand values
           B_i <= STD_LOGIC_VECTOR(to_unsigned(j, 8));
           wait for 10 ns;
           info("Testing multiplying for: A_i = to_string(unsigned(A_i)) and to_string(unsigned(B_i))");
           check_equal(RES_o, STD_LOGIC_VECTOR(unsigned(A_i) * unsigned(B_i)));
           wait for 10 ns;
         end loop;
       end loop;

     test_runner_cleanup(runner);
     wait;
   end process;
end architecture;
