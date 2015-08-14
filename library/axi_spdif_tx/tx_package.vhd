----------------------------------------------------------------------
----                                                              ----
---- WISHBONE SPDIF IP Core                                       ----
----                                                              ----
---- This file is part of the SPDIF project                       ----
---- http://www.opencores.org/cores/spdif_interface/              ----
----                                                              ----
---- Description                                                  ----
---- SPDIF transmitter component package.                         ----
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
-- Revision 1.2  2004/07/14 17:58:49  gedra
-- Added new components.
--
-- Revision 1.1  2004/07/13 18:30:25  gedra
-- Transmitter component declarations.
--
-- 
--

library ieee;
use ieee.std_logic_1164.all; 

package tx_package is

    component tx_encoder 
        generic 
        (
            DATA_WIDTH: integer range 16 to 32 := 32
        ); 
        port 
        (
            up_clk: in std_logic;                                       -- clock
            data_clk : in std_logic;                                    -- data clock
            resetn : in std_logic;                                      -- resetn
            conf_mode: in std_logic_vector(3 downto 0);                 -- sample format
            conf_ratio: in std_logic_vector(7 downto 0);                -- clock divider
            conf_txdata: in std_logic;                                  -- sample data enable
            conf_txen: in std_logic;                                    -- spdif signal enable
            chstat_freq: in std_logic_vector(1 downto 0);               -- sample freq.
            chstat_gstat: in std_logic;                                 -- generation status
            chstat_preem: in std_logic;                                 -- preemphasis status
            chstat_copy: in std_logic;                                  -- copyright bit
            chstat_audio: in  std_logic;                                -- data format
            sample_data: in std_logic_vector(DATA_WIDTH - 1 downto 0);  -- audio data
            sample_data_ack : out std_logic;                            -- sample buffer read
            channel: out std_logic;
            spdif_tx_o: out std_logic
        );
    end component;

end tx_package;
