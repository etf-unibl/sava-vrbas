-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name: counter_5_bit
--
-- description:
--
--   This file implements 5-bit counter
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
--! @file
--! @brief 5-bit counter
-----------------------------------------------------------------------------
--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Entity for 24-bit counter
--! @details This entity contains clock, enable and reset inputs
--! and output signal.
entity tx_counter_5_bit is
  port (
    clk_i    : in  std_logic; --! Input clock signal
    rst_i    : in  std_logic; --! Input reset signal
    enable_i : in  std_logic; --! Input enable signal
    count_o  : out std_logic_vector (4 downto 0)); --! Output signal for counting
end tx_counter_5_bit;

--! @brief Architecture definition of 5-bit counter
--! @details This design is used for realisation of I2S RX module,
--! it checks if registers are full.
architecture arch of tx_counter_5_bit is
  signal count_pom : unsigned (4 downto 0); --! Temp signal for counting
begin
  counting : process (clk_i, rst_i)
  begin
    if rst_i = '1' then
      count_pom <= (others => '0');
    elsif clk_i'event and clk_i = '1' and enable_i = '1' then
      if count_pom = 24 then
        count_pom <= (0 => '1', others => '0');
      else
        count_pom <= count_pom + 1;
      end if;
    end if;
  end process counting;
  count_o <= std_logic_vector(count_pom);
end arch;