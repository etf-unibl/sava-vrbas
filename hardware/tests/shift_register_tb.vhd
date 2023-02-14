-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:     SHIFT REGISTER VUNIT TESTBENCH
-- description:
--
-- This file implements 24-bit shift register testbench, following  VUnit testbench form.
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

entity tb_shifter is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_shifter is

  signal clk_i, enable_i, data_i : std_logic;
  signal data_o : std_logic_vector(23 downto 0);
  signal data : std_logic_vector(23 downto 0) := "111011010100010101011101";
  signal output : std_logic_vector(23 downto 0) := "000000000000000000000000";

begin

  uut : entity common_lib.shift_register
    port map(
      clk_i  => clk_i,
      enable_i   => enable_i,
      data_i => data_i,
      data_o => data_o);

  clk_stimulus : process
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

      if run("shifting_2") then
        info("Performing  test shifting_2");
        enable_i <= '1';
        data_i <= '1';
        wait until rising_edge(clk_i);
        wait for 2 ns;
        data_i <= '1';
        wait until rising_edge(clk_i);
        wait for 2 ns;
        check_equal(data_o, std_logic_vector'("000000000000000000000011"));
      elsif run("no_shifting") then
        info("Performing test no_shifting!");
        enable_i <= '0';
        data_i <= '1';
        wait until rising_edge(clk_i);
        check_equal(data_o, std_logic_vector'("000000000000000000000000"));
      elsif run("shift_input_combo") then
        info("Performing test shift_input_combo!");
        for i in data'length - 1 to 0 loop
          data_i <= data(i);
          wait until rising_edge(clk_i);
          wait for 2 ns;
          check_equal(data_o, std_logic_vector'(output(22 downto 0) & data_i));
        end loop;
      end if;
    end loop;
    test_runner_cleanup(runner);
  end process;
end architecture;
