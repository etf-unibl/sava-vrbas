-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:     RIGHT-SHIFTER
--
-- description:
--
-- This file implements  logic of shifting an eight-bit data to right.
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
-------------------------------------------------------
--! @file right_shifter.vhd
--! @brief  This file implements Right-shifter logic.
--! @author SAVA-VRBAS team
-------------------------------------------------------
--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! @brief Right-shifter entity description

entity right_shifter is
   port (
      A_i   : in STD_LOGIC_VECTOR(7 downto 0); --! Input data
      AMT_i : in INTEGER;                      --! Amount of bits to shift
      Y_o   : out STD_LOGIC_VECTOR(7 downto 0) --! Output or shifted data
);
end right_shifter;

--! @brief Architecture definition of Right-shifter
--! @details Following architecture describes logical shift to right
--! @details Depending on value of AMT_i shifting to right is performed by filling with zeros
--! @details For any value rather than within range from 0 to 7, output data is equal to input data, no shifting is performed

architecture rtl of right_shifter is
   signal added : STD_LOGIC_VECTOR(7 downto 0);
begin
   added <= "00000000";
   with AMT_i select
     Y_o <= added(6 downto 0) & A_i(7) when 7,
            added(5 downto 0) & A_i(7 downto 6) when 6,
            added(4 downto 0) & A_i(7 downto 5) when 5,
            added(3 downto 0) & A_i(7 downto 4) when 4,
            added(2 downto 0) & A_i(7 downto 3) when 3,
            added(1 downto 0) & A_i(7 downto 2) when 2,
            added(0) & A_i(7 downto 1) when 1,
            A_i when others;
end architecture;
