-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name: tx
--
-- description:
--
--   This file implements I2S transmitter
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
--! @brief tx_i2s
-----------------------------------------------------------------------------
--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;

--! @brief Entity for I2S transmitter
--! @details This entity contains clock, word select and serial data inputs
--! and output signal for left and right channel.
entity tx is
  port (
    clk_i   : in  std_logic; --! Input clock signal
    scl_i    : in  std_logic; --! Input i2s clock signal
    ws_i     : in  std_logic; --! Input word select signal
    data_l_i : in std_logic_vector(23 downto 0); --! Input buffer for left channel
    data_r_i : in std_logic_vector(23 downto 0); --! Input buffer for right channel
    sd_o     : out  std_logic --! Output serial data signal
  );
end tx;

--! @brief Architecture definition of I2S transmitter
--! @details This design is implemented using structural description,
--! it contains 24-bit counter, shift register and two buffers.
architecture arch of tx is --! Required components
  component tx_edge_detector
    port(
      clk_i      : in   std_logic;
      rst_i      : in   std_logic;
      strobe_i   : in   std_logic;
      p_o        : out  std_logic
    );
  end component;
  component tx_buffer_24_bit 
    port (
      clk_i : in std_logic;
      write_enable_i : in std_logic;
      data_i : in std_logic_vector (23 downto 0);
      data_o : out std_logic_vector (23 downto 0)
    );
  end component;
  component tx_counter_5_bit
    port (
      clk_i, rst_i, enable_i : in std_logic;
      count_o : out std_logic_vector (4 downto 0)
    );
  end component;
  component tx_shift_register
    port (
      clk_i : in std_logic;
      rst_i : in std_logic;
      enable_i : in std_logic;
      data_i : in std_logic_vector(23 downto 0);
      data_o : out std_logic
    );
  end component;
  signal data : std_logic_vector(23 downto 0) := (others => '0'); --! Temp signal for data input
  signal count_c : std_logic_vector(4 downto 0) := (others => '0'); --! Temp signal for counter
  signal counter_s_s, sd_o_l, sd_o_r: std_logic := '0'; --! Temp signal for counter state
  signal enable_e, enable_e_temp: std_logic := '0'; --! Temp enable signal
  signal reset_r : std_logic := '1'; --! Temp reset signal
  signal enable_l, enable_r : std_logic; --! Temp enable signals for left and right channels
begin

  ws_edge_detector : tx_edge_detector
  port map(clk_i    => clk_i,
           rst_i    => '0',
           strobe_i => ws_i, 
           p_o      => enable_e_temp);
			  
  scl_edge_detector : tx_edge_detector
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

  counter_s_s <= '1' when count_c = "00001" else --! Checking if registers are full
                 '0';

  enable_l <= (not ws_i) and enable_e; --! Reading from left channel buffer
  enable_r <= ws_i and enable_e; --! Reading from right channel buffer

  right_shift_reg : tx_shift_register --! Instantiation of required components
  port map(clk_i    => clk_i,
           rst_i    => reset_r,
           enable_i => enable_r,
           data_i   => data_r_i,
           data_o   => sd_o_r);

  left_shift_reg : tx_shift_register
  port map(clk_i    => clk_i,
           rst_i    => reset_r,
           enable_i => enable_l,
           data_i   => data_l_i,
           data_o   => sd_o_l);

  counter_count : tx_counter_5_bit
  port map(clk_i    => clk_i,
           rst_i    => reset_r,
           enable_i => enable_e,
           count_o  => count_c);

  sd_o <= sd_o_l when enable_l = '1' else
          sd_o_r when enable_r = '1';

end arch;
