-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name:     AUDIO PROCESSING MODULE
--
-- description:
--
--  This file implements logic of module responsible for audio processing.
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

--! @brief Audio processing module entity description
entity audio_processing is
  port (
    clk_i        : in  std_logic; --! Input clock signal
    data_i       : in  std_logic_vector(23 downto 0); --! Input data to manipulate
    button_inc_i : in  std_logic; --! Button to increase gain
    button_dec_i : in  std_logic; --! Button to decrease gain
    data_o       : out std_logic_vector(23 downto 0) --! Output data, processed
    );
end audio_processing;

--! @brief Architecture definition of Audio processing module
--! @brief Fixed-point multiplier is included in this architecture,
--! @brief as it returns the data manipulated (multiplied) with coefficients
--! @brief to increase or decrease gain

architecture arch of audio_processing is
  component multiplier
    port (
      CLK_i  : in  std_logic;
      A_i    : in  std_logic_vector(23 downto 0);
      B_i    : in  std_logic_vector(23 downto 0);
      RES_o  : out std_logic_vector(23 downto 0)
    );
  end component;

  signal coeff : std_logic_vector(23 downto 0);  --! Coefficients represent fixed-point values, multipliers in case of multiplier
  signal i : integer := 9;
  type t_my_lut_type is array (natural range <>) of std_logic_vector(23 downto 0);

  --! @brief Coefficient values go from 0.0 to 2.0 (increment+/decrement- with  0.1)
  --! @brief All of them, used in this module're entered into LUT (look-up table) below
  constant c_TEST_VECTOR  : t_my_lut_type := (
                                          "000000000000000000000000", "000001100110011001101000", "000011001100110011001100",
                                          "000100110011001100110100", "000110011001100110011000", "001000000000000000000000",
                                          "001001100110011001101000", "001011001100110011001100", "001100110011001100110100",
                                          "001110011001100110011000", "010000000000000000000000", "010001100110011001101000",
                                          "010011001100110011001100", "010100110011001100110100", "010110011001100110011000",
                                          "011000000000000000000000", "011001100110011001101000", "011011001100110011001100",
                                          "011100110011001100110100", "011110011001100110011000", "100000000000000000000000");

begin

  coeff <= c_TEST_VECTOR(i);
  fixed_point_multiplier : multiplier
  port map(
    clk_i => clk_i,
    A_i   => data_i,
    B_i   => coeff,
    RES_o => data_o);

-- Process to decide whether to increment or decrement
  process (clk_i, button_inc_i, button_dec_i)
    variable i_pom : integer;
  begin
    i_pom := i;
    if button_inc_i = '0' then
      if i_pom < 20 then
        i_pom := i_pom + 1;
      end if;
    elsif button_dec_i = '0' then
      if i_pom > 0 then
        i_pom := i_pom - 1;
      end if;
    end if;
    i <= i_pom;
  end process;

end arch;
