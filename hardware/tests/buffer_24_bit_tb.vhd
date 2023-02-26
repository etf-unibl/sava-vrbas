-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:    24-BIT BUFFER VUNIT TESTBENCH
--
-- description:
--
--  This file implements 24-bit buffer testbench, following  VUnit testbench form.
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

entity tb_buffer is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_buffer is
  signal clk_i : std_logic;
  signal write_enable_i : std_logic;
  signal data_i : std_logic_vector(23 downto 0) := (others => '0');
  signal data_o : std_logic_vector(23 downto 0);

begin
  invdut : entity common_lib.buffer_24_bit
    port map(
      clk_i  => clk_i,
      write_enable_i => write_enable_i,
      data_i => data_i,
      data_o => data_o);

  write_enable : process
  begin
    write_enable_i <= '1';
    wait for 200 ns;
    write_enable_i <= not(write_enable_i);
    wait for 200 ns;
  end process;

  clock_stimulus : process
  begin
    clk_i <= '1';
    wait for 10 ns;
    clk_i <= '0';
    wait for 10 ns;
  end process;

  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      for i in 0 to 100 loop
        if run("writing_to_buffer") then
          info("Performing test writing_to_buffer");
          data_i <= std_logic_vector(to_unsigned(i, 24));
          wait for 2 ns;
          wait until write_enable_i = '1' and rising_edge(clk_i);
          wait for 4 ns;
          check_equal(data_o, data_i);
          wait for 10 ns;
        end if;
        wait for 2 ns;
      end loop;
    end loop;

    test_runner_cleanup(runner);

  end process;
end architecture;
