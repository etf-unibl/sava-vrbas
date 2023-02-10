-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:     24-BIT COUNTER VUNIT TESTBENCH
--
-- description:
--
-- This file implements 24-bit counter testbench, following  VUnit testbench form.
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
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

use vunit_lib.run_pkg.all;
use vunit_lib.check_pkg.all;

library common_lib;

entity tb_example is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_example is
  signal clk_i, rst_i, en_i : std_logic := '0';
  signal cnt_o : std_logic_vector(23 downto 0) := "000000000000000000000000";

begin

  uut : entity common_lib.counter

    port map(
      clk_i => clk_i,
      rst_i => rst_i,
      en_i => en_i,
      cnt_o => cnt_o);

  clk : process
  begin
    clk_i <= '0';
    wait for 10 ns;
    clk_i <= '1';
    wait for 10 ns;

  end process;

  test_runner : process
  begin

    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      if run("reset_counter") then
        info("Performing first test");
        rst_i <= '1';
        en_i <= '0';
        wait for 20 ns;
        check_equal(cnt_o, std_logic_vector'("0000000000000000000000000"));

      elsif run ("check_enable") then
        info("Performing second test");
       -- When enabled, counter  performs counting from 0 (intended at the beginnning) to some value
       -- Check if output cnt_o and the expected value are equal  

      elsif run("check_counter_overflow") then
        info("Performing third test");
      -- Test which will demonstrate how after counting to 24 counter is again at its default value, zero
      -- Loop the values and check at the end whether the output is as expected

      end if;
    end loop;

    test_runner_cleanup(runner);
  end process;
end architecture;