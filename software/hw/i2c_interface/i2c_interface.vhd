-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/sava-vrbas/
-----------------------------------------------------------------------------
--
-- unit name: i2c_interface
--
-- description:
--
--   This file implements interface for i2c communication between CODEC and Raspberry Pi.
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_interface is
  port (
    -- Input ports
    clk_i       : in    std_logic;
    rpi_sda_b   : inout std_logic_vector(0 downto 0);
    scl_i       : in    std_logic;
    scl_o       : out   std_logic;
    codec_sda_b : inout std_logic_vector(0 downto 0);
    codec_xck_o : out   std_logic

  );
end i2c_interface;

architecture arch of i2c_interface is

  type t_state is (codec, rpi, idle1, idle2);
  signal state_reg  : t_state;
  signal state_next : t_state;

  signal codec_sda_o : std_logic_vector (0 downto 0);
  signal codec_oe    : std_logic_vector (0 downto 0);

  signal rpi_sda_o : std_logic_vector (0 downto 0);
  signal rpi_oe    : std_logic_vector (0 downto 0);

  signal rpi_rising_edge  : std_logic;
  signal rpi_falling_edge : std_logic;

  signal codec_clk : std_logic; -- outclk0.clk
  signal locked    : std_logic; --  locked.export
  component pll_12MHz is
    port (
      refclk   : in  std_logic := '0'; --  refclk.clk
      rst      : in  std_logic := '0'; --   reset.reset
      outclk_0 : out std_logic; -- outclk0.clk
      locked   : out std_logic --  locked.export
    );
  end component;

  component altiobuf_o is
    port (
      datain  : in    std_logic_vector (0 downto 0);
      oe      : in    std_logic_vector (0 downto 0);
      dataio  : inout std_logic_vector (0 downto 0);
      dataout : out   std_logic_vector (0 downto 0)
    );
  end component;

  component rising_edge_detector
    port (
      clk_i    : in  std_logic;
      rst_i    : in  std_logic;
      strobe_i : in  std_logic;
      p_o      : out std_logic
    );
  end component;

  component falling_edge_detector
    port (
      clk_i    : in  std_logic;
      rst_i    : in  std_logic;
      strobe_i : in  std_logic;
      p_o      : out std_logic
    );
  end component;

begin

  codec_xck_inst : pll_12MHz
  port map(
    refclk   => clk_i,
    rst      => '0',
    outclk_0 => codec_clk,
    locked   => locked
  );

  codec_altiobuf : altiobuf_o
  port map(
    datain  => rpi_sda_o,
    oe      => codec_oe,
    dataio  => codec_sda_b,
    dataout => codec_sda_o
  );

  rpi_altiobuf : altiobuf_o
  port map(
    datain  => codec_sda_o,
    oe      => rpi_oe,
    dataio  => rpi_sda_b,
    dataout => rpi_sda_o
  );

  rpi_rising_edge_detector : rising_edge_detector
  port map(
    clk_i    => clk_i,
    rst_i    => '0',
    strobe_i => rpi_sda_b(0),
    p_o      => rpi_rising_edge);

  rpi_falling_edge_detector : falling_edge_detector
  port map(
    clk_i    => clk_i,
    rst_i    => '0',
    strobe_i => rpi_sda_b(0),
    p_o      => rpi_falling_edge);

  -- state register
  process (clk_i) is
  begin
    if rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;

  -- next state logic
  process (state_reg, rpi_rising_edge, rpi_falling_edge) is
  begin
    case state_reg is
      when idle1 =>
        state_next <= idle2;
      when idle2 =>
        state_next <= codec;
      when rpi =>
        if rpi_rising_edge = '1' then
          state_next <= idle1;
        else
          state_next <= rpi;
        end if;
      when codec =>
        if rpi_falling_edge = '1' then
          state_next <= rpi;
        else
          state_next <= codec;
        end if;
    end case;
  end process;

  -- output logic
  process (state_reg) is
  begin
    case state_reg is
      when idle1 =>
        codec_oe <= (others => '0');
        rpi_oe   <= (others => '1');
      when idle2 =>
        codec_oe <= (others => '0');
        rpi_oe   <= (others => '1');
      when rpi =>
        codec_oe <= (others => '1');
        rpi_oe   <= (others => '0');
      when codec =>
        codec_oe <= (others => '0');
        rpi_oe   <= (others => '1');
    end case;
  end process;

  -- concurrent
  scl_o       <= scl_i;
  codec_xck_o <= codec_clk;
end arch;