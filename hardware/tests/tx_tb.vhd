-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name: I2S TRANSMITTER VUNIT TESTBENCH
--
-- description:
--
--   This file implements I2S transmitter testbench, following  VUnit testbench form.
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

entity tb_tx is
  generic (runner_cfg : string);
end entity;

architecture arch of tb_tx is
  signal clk_i    : std_logic := '0';
  signal scl_i    : std_logic := '0';
  signal ws_i     : std_logic := '0';
  signal data_l_i : std_logic_vector(23 downto 0);
  signal data_r_i : std_logic_vector(23 downto 0);
  signal sd_o     : std_logic;

begin
  invdut : entity common_lib.tx
    port map(
      clk_i    => clk_i,
      scl_i    => scl_i,
      ws_i     => ws_i,
      sd_o     => sd_o,
      data_r_i => data_r_i,
      data_l_i => data_l_i);

  clock : process
  begin
   clk_i <= not clk_i;
   wait for 1 ns;
  end process;

  clocking : process
  begin
    scl_i <= not scl_i;
    wait for 10 ns;
  end process;

  stimulus : process
  begin
    ws_i <= '0';
    wait for 500 ns;
    ws_i <= '1';
    wait for 500 ns;
  end process;

    test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
        if run("left_channel") then
          info("Performing test left_channel");
          data_l_i <= "101010101010101010101010";
          wait for 2 ns;
          wait until ws_i = '0';
          wait for 2 ns;
          check_equal(sd_o, data_l_i(0));
        elsif run("right_channel") then
          info("Performing test right_channel");
          data_r_i <= "101010101010101010101010";
          wait for 2 ns;
          wait until ws_i = '1';
          wait for 2 ns;
          check_equal(sd_o, data_r_i(0));
          wait for 1000 ns;
        end if;
    end loop;

    test_runner_cleanup(runner);

  end process;
end architecture;
