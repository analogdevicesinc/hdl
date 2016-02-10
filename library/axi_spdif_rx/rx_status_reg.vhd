----------------------------------------------------------------------
----                                                              ----
---- WISHBONE SPDIF IP Core                                       ----
----                                                              ----
---- This file is part of the SPDIF project                       ----
---- http://www.opencores.org/cores/spdif_interface/              ----
----                                                              ----
---- Description                                                  ----
---- SPDIF receiver status register                               ----
----                                                              ----
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
-- Revision 1.4  2004/06/27 16:16:55  gedra
-- Signal renaming and bug fix.
--
-- Revision 1.3  2004/06/26 14:14:47  gedra
-- Converted to numeric_std and fixed a few bugs.
--
-- Revision 1.2  2004/06/16 19:03:10  gedra
-- Added channel status decoding.
--
-- Revision 1.1  2004/06/05 17:17:12  gedra
-- Recevier status register
--
--

library ieee;
use ieee.std_logic_1164.all; 

entity rx_status_reg is	 
  generic (DATA_WIDTH: integer);
  port (
    up_clk: in std_logic;             -- clock
    status_rd: in std_logic;            -- status register read
    lock: in std_logic;                 -- signal lock status
    chas: in std_logic;                 -- channel A or B select
    rx_block_start: in std_logic;       -- start of block signal
    ch_data: in std_logic;              -- channel status/user data
    cs_a_en: in std_logic;              -- channel status ch. A enable
    cs_b_en: in std_logic;              -- channel status ch. B enable
    status_dout: out std_logic_vector(DATA_WIDTH - 1 downto 0));
end rx_status_reg;

architecture rtl of rx_status_reg is

  signal status_vector : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal cur_pos : integer range 0 to 255;
  signal pro_mode : std_logic;
  
begin
	
  status_dout <= status_vector when status_rd = '1' else (others => '0');

  D32: if DATA_WIDTH = 32 generate
    status_vector(31 downto 16) <= (others => '0');
  end generate D32;

  status_vector(0) <= lock;
  status_vector(15 downto 7) <= (others => '0');
  
-- extract channel status bits to be used
  CDAT: process (up_clk, lock)
    begin
      if lock = '0' then
        cur_pos <= 0;
        pro_mode <= '0';
        status_vector(6 downto 1) <= (others => '0');
      else
        if rising_edge(up_clk) then
          -- bit counter, 0 to 191
          if rx_block_start = '1' then
            cur_pos <= 0;
          elsif cs_b_en = '1' then -- ch. status #2 comes last, count then
            cur_pos <= cur_pos + 1;
          end if;
          -- extract status bits used in status register
          if (chas = '0' and cs_b_en = '1') or
            (chas = '1' and cs_a_en = '1') then
            case cur_pos is
              when 0 =>                 -- PRO bit
                status_vector(1) <= ch_data;
                pro_mode <= ch_data;
              when 1 =>                 -- AUDIO bit
                status_vector(2) <= not ch_data;
              when 2 =>                 -- emphasis/copy bit
                if pro_mode = '1' then
                  status_vector(5) <= ch_data;
                else
                  status_vector(6) <= ch_data;
                end if;
              when 3 =>                 -- emphasis
                if pro_mode = '1'  then
                  status_vector(4) <= ch_data;
                else
                  status_vector(5) <= ch_data;
                end if;
              when 4 =>                 -- emphasis
                if pro_mode = '1'  then
                  status_vector(3) <= ch_data;
                else
                  status_vector(4) <= ch_data;
                end if;
              when 5 =>                 -- emphasis
                if pro_mode = '0' then
                  status_vector(3) <= ch_data;
                end if;
              when others =>
                null;
            end case;
          end if;
        end if;
      end if;
    end process CDAT;
    
end rtl;
