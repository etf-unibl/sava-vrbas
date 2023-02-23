-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:    FIXED-POINT MULTIPLIER VUNIT TESTBENCH
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

entity tb_fixed_point_multiplier is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_fixed_point_multiplier is
  signal CLK_i    : std_logic;
  signal A_i, B_i : std_logic_vector(23 downto 0);
  signal RES_o    : std_logic_vector(23 downto 0);
  signal i        : integer := 0;
  -- signal product : std_logic_vector(47 downto 0);
  -- signal check : std_logic_vector(1 downto 0) := "00";

  type t_test_vector is record
    A_dec : std_logic_vector(23 downto 0);
    A_inc : std_logic_vector(23 downto 0);
  end record t_test_vector;

  type t_test_vector_array is array (natural range <>) of t_test_vector;

  constant c_test_vectors : t_test_vector_array := ( -- A_dec, A_inc
                                                   ("001110011001100110011000", "010001100110011001101000"),
                                                   ("001100110011001100110100", "010011001100110011001100"),
                                                   ("001011001100110011001100", "010100110011001100110100"),
                                                   ("001001100110011001101000", "010110011001100110011000"),
                                                   ("001000000000000000000000", "011000000000000000000000"),
                                                   ("000110011001100110011000", "011001100110011001101000"),
                                                   ("000100110011001100110100", "011011001100110011001100"),
                                                   ("000011001100110011001100", "011100110011001100110100"),
                                                   ("000001100110011001101000", "011110011001100110011000"),
                                                   ("000000000000000000000000", "100000000000000000000000")
                                                   );
begin
  invdut : entity common_lib.multiplier
    port map(
      CLK_i   => CLK_i,
      A_i     => A_i,
      B_i     => B_i,
      RES_o   => RES_o);

  test_runner : process
    variable check   : std_logic_vector(1 downto 0) := "00";
    variable product : std_logic_vector(47 downto 0);

  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      if run("check_decrementation") then
        info("Performing test check_decrementation");
        for j in 0 to 255 loop
          B_i <= std_logic_vector(to_unsigned(j, 24));
          wait for 2 ns;
          for i in c_test_vectors'range loop
            A_i <= c_test_vectors(i).A_dec;
            wait for 2 ns;
            product := std_logic_vector(unsigned(A_i) * unsigned(B_i));
            check := product(47 downto 46);
            wait for 5 ns;

            if check = "00" then
              wait for 5 ns;
              check_equal(RES_o, product(45 downto 22));

            else
              wait for 5 ns;
              check_equal(RES_o, std_logic_vector'("111111111111111111111111"));

            end if;
          end loop;
        end loop;

      elsif run("check_incrementation") then
        info("Performing test check_incrementation");
        for j in 0 to 255 loop
          B_i <= std_logic_vector(to_unsigned(j, 24));
          wait for 2 ns;
          for i in c_test_vectors'range loop
            A_i <= c_test_vectors(i).A_inc;
            wait for 2 ns;
            product := std_logic_vector(unsigned(A_i) * unsigned(B_i));
            check := product(47 downto 46);

            if check = "00" then
              check_equal(RES_o, product(45 downto 22));
              wait for 2 ns;
            else
              check_equal(RES_o, std_logic_vector'("111111111111111111111111"));
              wait for 2 ns;
            end if;
            wait for 2 ns;
          end loop;
        end loop;
      end if;

      info("Testing for all the values is done.");
    end loop;
    test_runner_cleanup(runner);
    wait;
  end process;
end architecture;
