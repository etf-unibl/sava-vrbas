-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:     FIXED-POINT MULTIPLIER
--
-- description:
--
--  This file implements logic of multiplying two 24-bit numbers.
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
--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief 24-bit multiplier entity description

entity multiplier is
  port (
    CLK_i   : in  std_logic;
    A_i     : in  std_logic_vector(23 downto 0); --! Multiplicand
    B_i     : in  std_logic_vector(23 downto 0); --! Multiplier
    RES_o   : out std_logic_vector(23 downto 0) --! Product
  );
end multiplier;

--! @brief Architecture definition of 24-bit multiplier

architecture arch of multiplier is
  signal temp_check   : std_logic := '0';
  signal temp_product : unsigned (47 downto 0);
begin
  temp_product <= unsigned(B_i) * unsigned(A_i);
  temp_check <= temp_product(47) or temp_product(46);
  RES_o <= std_logic_vector(temp_product(45 downto 22)) when temp_check = '0' else
           "111111111111111111111111";
end architecture arch;
