-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name: i2s_rx
--
-- description:
--
--   This file implements I2S receiver
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
--! @brief rx_i2s
-----------------------------------------------------------------------------
--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Entity for I2S recevier
--! @details This entity contains clock, word select and serial data inputs
--! and output signal for left and right channel.
entity rx is
  port (
    clk_i    : in  std_logic; --! Input clock signal
    scl_i    : in  std_logic; --! Input i2s clock signal
    ws_i     : in  std_logic; --! Input word select signal
    sd_i     : in  std_logic; --! Inpu serial data signal
    data_l_o : out std_logic_vector(23 downto 0); --! Output signal for left channel
    data_r_o : out std_logic_vector(23 downto 0) --! Output signal for right channel
  );
end rx;

--! @brief Architecture definition of I2S recevier
--! @details This design is implemented using structural description,
--! it contains 24-bit counter, shift register and two buffers.
architecture arch of rx is --! Required components
  component dual_edge_detector
    port(
      clk_i      : in   std_logic;
      rst_i      : in   std_logic;
      strobe_i   : in   std_logic;
      p_o        : out  std_logic
    );
  end component;
  component buffer_24_bit
    port (
      clk_i          : in std_logic;
      write_enable_i : in std_logic;
      data_i         : in std_logic_vector (23 downto 0);
      data_o         : out std_logic_vector (23 downto 0)
    );
  end component;
  component counter_5_bit
    port (
      clk_i, rst_i, enable_i : in std_logic;
      count_o : out std_logic_vector (4 downto 0)
    );
  end component;
  component shift_register
    port (
      clk_i    : in std_logic;
      rst_i    : in std_logic;
      enable_i : in std_logic;
      data_i   : in std_logic;
      data_o   : out std_logic_vector(23 downto 0)
    );
  end component;
  signal data, data_l, data_r : std_logic_vector(23 downto 0) := (others => '0'); --! Temp signal for data input
  signal count_c : std_logic_vector(4 downto 0) := (others => '0'); --! Temp signal for counter
  signal counter_s_s : std_logic := '0'; --! Temp signal for counter state
  signal enable_e, enable_e_temp : std_logic := '0'; --! Temp enable signal
  signal reset_r : std_logic := '1'; --! Temp reset signal
  signal enable_l, enable_r : std_logic; --! Temp enable signals for left and right channels
begin

  ws_edge_detector : dual_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => ws_i,
           p_o      => enable_e_temp);
  scl_edge_detector : dual_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => scl_i,
           p_o      => enable_e);

  receiving : process (clk_i, enable_e_temp)
  begin
    if(enable_e_temp = '1') then
      reset_r <= '0';
    end if;
  end process receiving;

  counter_s_s <= '1' when count_c = "00010" else --! Checking if registers are full
                 '0';

  enable_l <= (not ws_i) and counter_s_s; --! Writing to left channel buffer
  enable_r <= ws_i and counter_s_s; --! Writing to right channel buffer

  shift_reg : shift_register --! Instantiation of required components
  port map(clk_i    => clk_i,
           rst_i    => reset_r,
           enable_i => enable_e,
           data_i   => sd_i,
           data_o   => data);

  counter_count : counter_5_bit
  port map(clk_i    => clk_i,
           rst_i    => reset_r,
           enable_i => enable_e,
           count_o  => count_c);

  left_buffer : buffer_24_bit
  port map(clk_i    => clk_i,
           write_enable_i => enable_l,
           data_i         => data,
           data_o         => data_l);

  right_buffer : buffer_24_bit
  port map(clk_i    => clk_i,
           write_enable_i => enable_r,
           data_i => data,
           data_o => data_r);

  data_l_o <= data_l;
  data_r_o <= data_r;
end arch;
