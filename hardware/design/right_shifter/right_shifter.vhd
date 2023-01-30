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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY right_shifter IS
   PORT (
      A_i   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      AMT_i : IN INTEGER;
      Y_o   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END right_shifter;

ARCHITECTURE rtl OF right_shifter IS
   SIGNAL added : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
   added <= "00000000";
   WITH AMT_i SELECT
     Y_o <= added(6 DOWNTO 0) & A_i(7) WHEN 7,
            added(5 DOWNTO 0) & A_i(7 DOWNTO 6) WHEN 6,
            added(4 DOWNTO 0) & A_i(7 DOWNTO 5) WHEN 5,
            added(3 DOWNTO 0) & A_i(7 DOWNTO 4) WHEN 4,
            added(2 DOWNTO 0) & A_i(7 DOWNTO 3) WHEN 3,
            added(1 DOWNTO 0) & A_i(7 DOWNTO 2) WHEN 2,
            added(0) & A_i(7 DOWNTO 1) WHEN 1,
            A_i WHEN OTHERS;
END ARCHITECTURE;
