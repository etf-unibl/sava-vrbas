-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name: shift_register
--
-- description:
--
--   This file implements 24-bit shift register
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
--! @brief 24-bit shifter
-----------------------------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Entity for 24-bit shift register
--! @details This entity contains clock, enable and data inputs
--! and data output.
entity shift_register is
  port (
           clk_i    : in  STD_LOGIC; --! Input clock signal
           rst_i    : in std_logic; --! Input reset signal
           enable_i : in  STD_LOGIC; --! Input enable signal
           data_i   : in  STD_LOGIC; --! Input data
           data_o   : out STD_LOGIC_VECTOR (23 downto 0)); --! Output data
end shift_register;

--! @brief Architecture definition of 24-bit shift register
--! @details This design is used for realisation of I2S RX module
architecture arch of shift_register is
  signal reg : std_logic_vector(23 downto 0);
begin
  shifting : process (clk_i, rst_i)
    begin
      if rst_i = '1' then
        reg <= (others => '0');
      elsif rising_edge(clk_i) then
        if enable_i = '1' then
          reg <= reg(22 downto 0) & data_i;
        end if;
      end if;
  end process shifting;
  data_o <= reg;
end arch;
