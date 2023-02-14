-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:    dual_edge_detector_tb
--
-- description:
--
--  This file implements dual-edge detector testbench, following  VUnit testbench form.
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

entity tb_detector is
  generic (runner_cfg : string);
end entity;

architecture arch of tb_detector is
  signal clk_i : std_logic;
  signal rst_i : std_logic;
  signal strobe_i : std_logic;
  signal p_o : std_logic;
  signal p_comp : std_logic;
  signal i : integer := 0;

  type t_moore_test_vector is record
    strobe_v : std_logic;
    p_v : std_logic;
  end record t_moore_test_vector;

  type t_moore_test_vector_array is array (natural range <>) of t_moore_test_vector;

  constant c_MOORE_TEST_VECTORS : t_moore_test_vector_array := (
                                                               ('0', '0'),
                                                               ('1', '1'),
                                                               ('1', '0'),
                                                               ('1', '0'),
                                                               ('1', '0'),
                                                               ('0', '1'),
                                                               ('0', '0')
                                                               );

begin
  invdut : entity common_lib.dual_edge_detector
    port map(
      clk_i     => clk_i,
      rst_i     => rst_i,
      strobe_i  => strobe_i,
      p_o       => p_o);

  clock_stimulus : process
  begin
    clk_i <= '1';
    wait for 10 ns;
    clk_i <= '0';
    wait for 10 ns;
    if i = c_MOORE_TEST_VECTORS'length then
      wait;
    end if;
  end process;

  reseting : process
  begin
    rst_i <= '1';
    wait for 10 ns;
    rst_i <= '0';
    wait;
  end process;

  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      if run("check_edge_detection") then
        info("Performing test check_edge_detection");
        strobe_i <= c_MOORE_TEST_VECTORS(i).strobe_v;
        p_comp <= c_MOORE_TEST_VECTORS(i).p_v;
        wait for 10 ns;
        if i < c_MOORE_TEST_VECTORS'length then
          i <= i + 1;
        else
          wait;
        end if;
        wait until clk_i'event;
        wait for 5 ns;
        check_equal(p_o, p_comp);
        wait for 10 ns;
      end if;
      wait for 2 ns;
    end loop;

    test_runner_cleanup(runner);

  end process;
end architecture;
