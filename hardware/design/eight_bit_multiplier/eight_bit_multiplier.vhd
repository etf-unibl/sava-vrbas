-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:     EIGHT-BIT MULTIPLIER
--
-- description:
--
--  This file implements logic of multiplying two eight-bit numbers.
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
USE ieee.numeric_std.ALL;

ENTITY eight_bit_multiplier IS
  PORT (
      A_i   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      B_i   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      RES_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END eight_bit_multiplier;

ARCHITECTURE arch OF eight_bit_multiplier IS
BEGIN

  multipler : PROCESS (B_i, A_i)
    VARIABLE temp_product, temp_b_shift : unsigned (15 DOWNTO 0);
  BEGIN
    temp_product := "0000000000000000";
    temp_b_shift := unsigned("00000000" & B_i);
    FOR i IN 0 TO 7 LOOP
      IF A_i(i) = '1' THEN
        temp_product := temp_product + temp_b_shift;
      END IF;
      temp_b_shift := temp_b_shift(14 DOWNTO 0) & '0';
    END LOOP;
    RES_o <= STD_LOGIC_VECTOR(temp_product);
  END PROCESS multipler;
END ARCHITECTURE arch;
