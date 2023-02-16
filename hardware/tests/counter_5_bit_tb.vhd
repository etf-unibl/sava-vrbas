-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:     5-BIT COUNTER VUNIT TESTBENCH
--
-- description:
--
-- This file implements 5-bit counter testbench, following  VUnit testbench form.
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

entity tb_counter is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_counter is
  signal clk_i, rst_i, enable_i : std_logic;
  signal count_o : std_logic_vector(4 downto 0);
  signal differ : unsigned(4 downto 0);

begin

  uut : entity common_lib.counter_5_bit

    port map(
      clk_i => clk_i,
      rst_i => rst_i,
      enable_i => enable_i,
      count_o => count_o);

  clock_stimulus : process
  begin
    clk_i <= '0';
    wait for 10 ns;
    clk_i <= not clk_i;
    wait for 10 ns;

  end process;

  test_runner : process
  begin

    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      differ <= (others => '0'); -- otherwise, it will stay as NaN
      if run("reset_counter") then
        info("Performing test reset_counter");
        rst_i <= '1';
        wait for 10 ns;
        rst_i <= '0';
        check_equal(count_o, std_logic_vector'("00000"));

      elsif run ("check_enable_count_up") then
        info("Performing test check_enable_count_up");
        enable_i <= '1';
        rst_i <= '0';
        while differ < 24 loop
          wait until rising_edge(clk_i);
          wait for 2 ns;
          differ <= differ + 1;
          wait for 2 ns;
          check_equal(count_o, differ);
        end loop;
        enable_i <= '0';

      elsif run("check_counter_overflow") then
        info("Performing  test check_counter_overflow");
        enable_i <= '1';
        rst_i <= '0';
        while differ <= 24 loop
          wait until rising_edge(clk_i);
          wait for 2 ns;
          differ <= differ + 1;
        check_equal(count_o, std_logic_vector'("10000"));
      end loop;

    end if;
  end loop;

  test_runner_cleanup(runner);
end process;
end architecture;
