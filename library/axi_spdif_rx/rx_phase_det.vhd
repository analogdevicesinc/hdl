----------------------------------------------------------------------
----                                                              ----
---- WISHBONE SPDIF IP Core                                       ----
----                                                              ----
---- This file is part of the SPDIF project                       ----
---- http://www.opencores.org/cores/spdif_interface/              ----
----                                                              ----
---- Description                                                  ----
---- Oversampling phase detector. Decodes bi-phase mark encoded   ----
---- signal. Clock must be at least 8 times higher than bit rate. ----
---- The SPDIF bitrate must be minimum 100kHz.                    ----
----                                                              ----
---- To Do:                                                       ----
---- -                                                            ----
----                                                              ----
---- Author(s):                                                   ----
---- - Geir Drange, gedra@opencores.org                           ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2004 Authors and OPENCORES.ORG                 ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU Lesser General   ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.1 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE. See the GNU Lesser General Public License for more  ----
---- details.                                                     ----
----                                                              ----
---- You should have received a copy of the GNU Lesser General    ----
---- Public License along with this source; if not, download it   ----
---- from http://www.opencores.org/lgpl.shtml                     ----
----                                                              ----
----------------------------------------------------------------------
--
-- CVS Revision History
--
-- $Log: not supported by cvs2svn $
-- Revision 1.5  2004/07/19 16:58:37  gedra
-- Fixed bug.
--
-- Revision 1.4  2004/07/12 17:06:41  gedra
-- Fixed bug with lock event generation.
--
-- Revision 1.3  2004/07/11 16:19:50  gedra
-- Bug-fix.
--
-- Revision 1.2  2004/06/13 18:08:50  gedra
-- Renamed generic and cleaned some lint's
--
-- Revision 1.1  2004/06/06 15:43:02  gedra
-- Early version of the bi-phase mark decoder.
--
--

library ieee;
use ieee.std_logic_1164.all;

entity rx_phase_det is             
  generic (AXI_FREQ: natural := 100);   -- WishBone frequency in MHz
  port (
    up_clk: in std_logic;             -- wishbone clock
    rxen: in std_logic;                 -- phase detector enable
    spdif: in std_logic;                -- SPDIF input signal
    lock: out std_logic;                -- true if locked to spdif input
    lock_evt: out std_logic;            -- lock status change event
    rx_data: out std_logic;             -- recevied data
    rx_data_en: out std_logic;          -- received data enable
    rx_block_start: out std_logic;      -- start-of-block pulse
    rx_frame_start: out std_logic;      -- start-of-frame pulse
    rx_channel_a: out std_logic;        -- 1 if channel A frame is recevied
    rx_error: out std_logic;            -- signal error was detected
    ud_a_en: out std_logic;             -- user data ch. A enable
    ud_b_en: out std_logic;             -- user data ch. B enable
    cs_a_en: out std_logic;             -- channel status ch. A enable
    cs_b_en: out std_logic);            -- channel status ch. B enable);            
end rx_phase_det;

architecture rtl of rx_phase_det is

  constant TRANSITIONS : integer := 70;
  constant FRAMES_FOR_LOCK : integer := 3;
  signal maxpulse, maxp, mp_cnt: integer range 0 to 16 * AXI_FREQ;
  signal last_cnt, max_thres : integer range 0 to 16 * AXI_FREQ;
  signal minpulse, minp, min_thres: integer range 0 to 8 * AXI_FREQ;
  signal zspdif, spdif_in, zspdif_in, trans, ztrans : std_logic;
  signal trans_cnt : integer range 0 to TRANSITIONS;
  signal valid, p_long, p_short: std_logic;
  type pulse_type is (ZERO, SHORT, MED, LONG);
  type pulse_array is array (0 to 3) of pulse_type;
  signal preamble: pulse_array;
  signal new_pulse, short_idx, ilock: std_logic;
  type frame_state is (IDLE, HUNT, FRAMESTART, FRAME_RX);
  signal framerx : frame_state;
  signal frame_cnt : integer range 0 to FRAMES_FOR_LOCK;
  signal bit_cnt : integer range 0 to 63;
  signal pre_cnt : integer range 0 to 7;
  type preamble_types is (NONE, PRE_X, PRE_Y, PRE_Z);
  signal new_preamble, last_preamble : preamble_types;
  signal irx_channel_a, zilock : std_logic;
  
begin

  -- Pulse width analyzer
  PHDET: process (up_clk, rxen)
  begin
    if rxen = '0' then            -- reset by configuration register bit
      maxpulse <= 0;
      maxp <= 0;
      mp_cnt <= 0;
      zspdif <= '0';
      zspdif_in <= '0';
      spdif_in <= '0';
      trans_cnt <= 0;
      minpulse <= 0;
      minp <= 8 * AXI_FREQ;
      last_cnt <= 0;
      trans <= '0';
      valid <= '0';
      preamble <= (ZERO, ZERO, ZERO, ZERO);
      max_thres <= 0;
      min_thres <= 0;
      new_preamble <= NONE;
      ztrans <= '0';
      new_pulse <= '0';
    else
      if rising_edge(up_clk) then
        -- sync spdif signal to wishbone clock
        zspdif <= spdif;
        spdif_in <= zspdif;
        -- find the longest pulse, which is the bi-phase violation
        -- also find the shortest pulse
        zspdif_in <= spdif_in;
        if zspdif_in /= spdif_in then   -- input transition
          mp_cnt <= 0;
          trans <= '1';
          last_cnt <= mp_cnt;
          if trans_cnt > 0 then
            if mp_cnt > maxp then
              maxp <= mp_cnt;
            end if;
            if mp_cnt < minp then
              minp <= mp_cnt;
            end if;
          end if;
        else
          trans <= '0';
          if mp_cnt < 16 * AXI_FREQ then
            mp_cnt <= mp_cnt + 1;
          end if;
        end if;
        -- transition counting
        if trans = '1' then            
          if trans_cnt < TRANSITIONS then
            trans_cnt <= trans_cnt + 1;
          else
            -- the max/min pulse length is updated after given # of transitions
            trans_cnt <= 0;
            maxpulse <= maxp;
            maxp <= 0;
            minpulse <= minp;
            minp <= 8 * AXI_FREQ;
            min_thres <= maxp / 2;
            if maxp < 11 then
              max_thres <= maxp - 1;
            else
              max_thres <= maxp - 3;
            end if;
          end if;
        end if;
        -- detection of valid SPDIF signal
        if maxpulse > 6 then
          valid <= '1';
        else
          valid <= '0';
        end if;
        -- bit decoding
        if trans = '1' then
          if (last_cnt < min_thres) and (last_cnt > 0) then
            p_short <= '1';
            preamble(0) <= SHORT;
          else
            p_short <= '0';
          end if;
          if last_cnt >= max_thres then
            p_long <= '1';
            preamble(0) <= LONG;
          else
            p_long <= '0';
          end if;
          if last_cnt = 0 then
            preamble(0) <= ZERO;
          end if;
          if (last_cnt < max_thres) and (last_cnt >= min_thres) then
            preamble(0) <= MED;
          end if;
          preamble(3) <= preamble(2);
          preamble(2) <= preamble(1);
          preamble(1) <= preamble(0); 
        end if;
        -- preamble detection
        if preamble(3) = LONG and preamble(2) = LONG and preamble(1) = SHORT
          and preamble(0) = SHORT then
          new_preamble <= PRE_X;
        elsif preamble(3) = LONG and preamble(2) = MED and preamble(1) = SHORT
          and preamble(0) = MED then
          new_preamble <= PRE_Y;
        elsif preamble(3) = LONG and preamble(2) = SHORT and preamble(1) = SHORT
          and preamble(0) = LONG then
          new_preamble <= PRE_Z;
        else
          new_preamble <= NONE;
        end if;
        -- delayed transition pulse for the state machine
        ztrans <= trans;
        new_pulse <= ztrans;
      end if;
    end if;
  end process;

  lock <= ilock;
  rx_channel_a <= irx_channel_a;
    
  -- State machine that hunt for and lock onto sub-frames
  FRX: process (up_clk, rxen)
  begin  
    if rxen = '0' then                  
      framerx <= IDLE;
      ilock <= '0';
      zilock <= '0';
      rx_data <= '0';
      rx_data_en <= '0';
      rx_block_start <= '0';
      rx_frame_start <= '0';
      irx_channel_a <= '0';
      ud_a_en <= '0';
      ud_b_en <= '0';
      cs_a_en <= '0';
      cs_b_en <= '0';
      rx_error <= '0';
      lock_evt <= '0';
      bit_cnt <= 0;
      pre_cnt <= 0;
      short_idx <= '0';
      frame_cnt <= 0;
      last_preamble <= NONE;
    elsif rising_edge(up_clk) then
      zilock <= ilock;
      if zilock /= ilock then           -- generate event for event reg.
        lock_evt <= '1';
      else
        lock_evt <= '0';
      end if;
      case framerx is
        when  IDLE =>                   -- wait for recevier to be enabled
          if valid = '1' then
            framerx <= HUNT;
          end if;
        when HUNT =>                    -- wait for preamble detection
          frame_cnt <= 0;
          ilock <= '0';
          rx_error <= '0';
          if new_pulse = '1' then
            if new_preamble /= NONE then
              framerx <= FRAMESTART;
            end if;
          end if;
        when FRAMESTART =>              -- reset sub-frame bit counter
          bit_cnt <= 0;
          pre_cnt <= 0;
          if frame_cnt < FRAMES_FOR_LOCK then
            frame_cnt <= frame_cnt + 1;
          else
            ilock <= '1';
          end if;
          last_preamble <= new_preamble;
          short_idx <= '0';
          rx_frame_start <= '1';
          rx_block_start <= '0';
          framerx <= FRAME_RX;
        when FRAME_RX =>                -- receive complete sub-frame
          if new_pulse = '1' then
            if bit_cnt < 28 then
              case preamble(0) is
                when ZERO =>
                  short_idx <= '0';
                when SHORT =>
                  if short_idx = '0' then
                    short_idx <= '1';
                  else
                    -- two short pulses is a logical '1'
                    bit_cnt <= bit_cnt + 1;
                    short_idx <= '0';
                    rx_data <= '1';
                    rx_data_en <= ilock;
                    -- user data enable for the capture register
                    if bit_cnt = 25 and ilock = '1' then
                      ud_a_en <= irx_channel_a;
                      ud_b_en <= not irx_channel_a;
                    end if;
                    -- channel status enable for the capture register
                    if bit_cnt = 26 and ilock = '1' then
                      cs_a_en <= irx_channel_a;
                      cs_b_en <= not irx_channel_a;
                    end if;
                  end if;
                when MED =>
                  -- medium pulse is logical '0'
                  bit_cnt <= bit_cnt + 1;
                  rx_data <= '0';
                  rx_data_en <= ilock;
                  short_idx <= '0';
                  -- user data enable for the capture register
                  if bit_cnt = 25 and ilock = '1' then
                    ud_a_en <= irx_channel_a;
                    ud_b_en <= not irx_channel_a;
                  end if;
                  -- channel status enable for the capture register
                  if bit_cnt = 26 and ilock = '1' then
                    cs_a_en <= irx_channel_a;
                    cs_b_en <= not irx_channel_a;
                  end if;
                when LONG =>
                  short_idx <= '0';
                when others =>
                  framerx <= HUNT;
              end case;
            else
              -- there should be 4 pulses in preamble
              if pre_cnt < 7 then
                pre_cnt <= pre_cnt + 1;
              else
                rx_error <= '1';
                framerx <= HUNT;
              end if;
              -- check for correct preamble here
              if pre_cnt = 3 then
                case last_preamble is
                  when PRE_X =>
                    if new_preamble = PRE_Y then
                      framerx <= FRAMESTART;
                      irx_channel_a <= '0';
                    else
                      rx_error <= '1';
                      framerx <= HUNT;
                    end if;
                  when PRE_Y =>
                    if new_preamble = PRE_X or new_preamble = PRE_Z then
                      irx_channel_a <= '1';
                      -- start of new block?
                      if new_preamble = PRE_Z then
                        rx_block_start <= '1';
                      end if;
                      framerx <= FRAMESTART;
                    else
                      rx_error <= '1';
                      framerx <= HUNT;
                    end if;
                  when PRE_Z =>
                    if new_preamble = PRE_Y then
                      irx_channel_a <= '0';
                      framerx <= FRAMESTART;
                    else
                      rx_error <= '1';
                      framerx <= HUNT;
                    end if;
                  when others =>
                    rx_error <= '1';
                    framerx <= HUNT;
                end case;
              end if;
            end if;
          else
            rx_data_en <= '0';
            rx_block_start <= '0';
            rx_frame_start <= '0';
            ud_a_en <= '0';
            ud_b_en <= '0';
            cs_a_en <= '0';
            cs_b_en <= '0';
          end if;
        when others =>
          framerx <= IDLE;
      end case;
    end if;
  end process FRX;

end rtl;
