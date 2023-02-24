-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name: SAVA TOP LEVEL DESIGN UNIT
--
-- description:
--
--   This file implements top module for TX and RX
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
--! @brief
-----------------------------------------------------------------------------
--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief
--! @details
entity top_module is
  port (
    clk_i        : in    std_logic; --! Input clock signal
    scl_i        : in    std_logic; --! Input i2s clock signal
    ws_i         : in    std_logic; --! Input word select signal
	 button_inc_i : in    std_logic;
	 button_dec_i : in    std_logic;
    ws_o         : out   std_logic;
    scl_o        : out   std_logic;
    sd_i         : in    std_logic; --! Input serial data signal
    rpi_sda_b    : inout std_logic_vector(0 downto 0);
    i2c_scl_i    : in    std_logic;
    i2c_scl_o    : out   std_logic;
    codec_sda_b  : inout std_logic_vector(0 downto 0);
    codec_xck_o  : out   std_logic;
    sd_o         : out   std_logic --! Output serial data signal
  );
end top_module;

--! @brief
--! @details
architecture arch of top_module is
  component i2c_interface
    port (
      -- Input ports
      clk_i       : in    std_logic;
      rpi_sda_b   : inout std_logic_vector(0 downto 0);
      scl_i       : in    std_logic;
      scl_o       : out   std_logic;
      codec_sda_b : inout std_logic_vector(0 downto 0);
      codec_xck_o : out   std_logic

    );
  end component;
  component rx
    port (
      clk_i    : in  std_logic; --! Input clock signal
      scl_i    : in  std_logic; --! Input i2s clock signal
      ws_i     : in  std_logic; --! Input word select signal
      sd_i     : in  std_logic; --! Inpu serial data signal
      data_l_o : out std_logic_vector(23 downto 0); --! Output signal for left channel
      data_r_o : out std_logic_vector(23 downto 0) --! Output signal for right channel
    );
  end component;
  component audio_processing
    port (
      clk_i        : in  std_logic; --! Input clock signal
      data_i       : in  std_logic_vector(23 downto 0); --! Input data to manipulate
      button_inc_i : in  std_logic; --! Button to increase gain
      button_dec_i : in  std_logic; --! Button to decrease gain
      data_o       : out std_logic_vector(23 downto 0) --! Output data, processed
    );
  end component;
  component tx
    port (
      clk_i    : in  std_logic; --! Input clock signal
      scl_i    : in  std_logic; --! Input i2s clock signal
      ws_i     : in  std_logic; --! Input word select signal
      data_l_i : in  std_logic_vector(23 downto 0); --! Input buffer for left channel
      data_r_i : in  std_logic_vector(23 downto 0); --! Input buffer for right channel
      sd_o     : out std_logic --! Output serial data signal
    );
  end component;

  signal data_l, data_r, data_l_processed, data_r_processed : std_logic_vector(23 downto 0) := (others => '0');
begin
  i2c : i2c_interface
  port map(
    clk_i       => clk_i,
    rpi_sda_b   => rpi_sda_b,
    scl_i       => i2c_scl_i,
    scl_o       => i2c_scl_o,
    codec_sda_b => codec_sda_b,
    codec_xck_o => codec_xck_o);

  receiver : rx
  port map(
    clk_i    => clk_i,
    scl_i    => scl_i,
    ws_i     => ws_i,
    sd_i     => sd_i,
    data_l_o => data_l,
    data_r_o => data_r);
	
  audio_left : audio_processing
  port map(
    clk_i      => clk_i,
    data_i     => data_l,
	 button_inc_i => button_inc_i,
	 button_dec_i => button_dec_i,
	 data_o     => data_l_processed);
	 
  audio_right : audio_processing
  port map(
    clk_i      => clk_i,
    data_i     => data_r,
	 button_inc_i => button_inc_i,
	 button_dec_i => button_dec_i,
	 data_o     => data_r_processed);

  transmitter : tx
  port map(
    clk_i    => clk_i,
    scl_i    => scl_i,
    ws_i     => ws_i,
    data_l_i => data_l_processed,
    data_r_i => data_r_processed,
    sd_o     => sd_o);
  ws_o  <= ws_i;
  scl_o <= scl_i;
end arch;
