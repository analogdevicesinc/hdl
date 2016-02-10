----------------------------------------------------------------------
----                                                              ----
---- WISHBONE SPDIF IP Core                                       ----
----                                                              ----
---- This file is part of the SPDIF project                       ----
---- http://www.opencores.org/cores/spdif_interface/              ----
----                                                              ----
---- Description                                                  ----
---- SPDIF receiver component package.                            ----
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
-- Revision 1.8  2004/06/27 16:16:55  gedra
-- Signal renaming and bug fix.
--
-- Revision 1.7  2004/06/26 14:14:47  gedra
-- Converted to numeric_std and fixed a few bugs.
--
-- Revision 1.6  2004/06/23 18:10:17  gedra
-- Added Wishbone bus cycle decoder.
--
-- Revision 1.5  2004/06/16 19:03:45  gedra
-- Changed status reg. declaration
--
-- Revision 1.4  2004/06/13 18:08:09  gedra
-- Added frame decoder and sample extractor
--
-- Revision 1.3  2004/06/10 18:57:36  gedra
-- Cleaned up lint warnings.
--
-- Revision 1.2  2004/06/09 19:24:50  gedra
-- Added dual port ram.
--
-- Revision 1.1  2004/06/07 18:06:00  gedra
-- Receiver component declarations.
--
--
 
library IEEE;
use IEEE.std_logic_1164.all; 

package rx_package is

-- type declarations
  type bus_array is array (0 to 7) of std_logic_vector(31 downto 0);

-- components
  component rx_ver_reg  
    generic (DATA_WIDTH: integer := 32;
             ADDR_WIDTH: integer := 8;
             CH_ST_CAPTURE: integer := 1);
    port (
      ver_rd: in std_logic; -- version register read
      ver_dout: out std_logic_vector(DATA_WIDTH - 1 downto 0)); -- read data
  end component;

  component gen_control_reg 	 
    generic (DATA_WIDTH: integer;
             -- note that this vector is (0 to xx), reverse order
             ACTIVE_BIT_MASK: std_logic_vector); 
    port (
      clk: in std_logic;	 -- clock  
      rst: in std_logic; -- reset
      ctrl_wr: in std_logic; -- control register write	
      ctrl_rd: in std_logic; -- control register read
      ctrl_din: in std_logic_vector(DATA_WIDTH - 1 downto 0); 
      ctrl_dout: out std_logic_vector(DATA_WIDTH - 1 downto 0); 
      ctrl_bits: out std_logic_vector(DATA_WIDTH - 1 downto 0)); 
  end component;

  component rx_status_reg 	 
    generic (DATA_WIDTH: integer := 32);
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
  end component;

  component gen_event_reg 	 
    generic (DATA_WIDTH: integer := 32);	
    port (
      clk: in std_logic;	 -- clock  
      rst: in std_logic; -- reset
      evt_wr: in std_logic; -- event register write	
      evt_rd: in std_logic; -- event register read
      evt_din: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- write data
      event: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- event vector
      evt_mask: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- irq mask
      evt_en: in std_logic;               -- irq enable
      evt_dout: out std_logic_vector(DATA_WIDTH - 1 downto 0); -- read data
      evt_irq: out std_logic); -- interrupt  request
  end component;

  component rx_cap_reg 	 
    port (
      clk: in std_logic;                  -- clock
      rst: in std_logic; -- reset
      --cap_ctrl_wr: in std_logic; -- control register write	
      --cap_ctrl_rd: in std_logic; -- control register read
      --cap_data_rd: in std_logic;          -- data register read
      cap_reg: in std_logic_vector(31 downto 0);
      cap_din: in std_logic_vector(31 downto 0); -- write data
      rx_block_start: in std_logic; -- start of block signal
      ch_data: in std_logic;  -- channel status/user data
      ud_a_en: in std_logic;            -- user data ch. A enable
      ud_b_en: in std_logic;              -- user data ch. B enable
      cs_a_en: in std_logic;              -- channel status ch. A enable
      cs_b_en: in std_logic;              -- channel status ch. B enable
      cap_dout: out std_logic_vector(31 downto 0); -- read data
      cap_evt: out std_logic);             -- capture event (interrupt)
  end component;

  component rx_phase_det
    generic (AXI_FREQ: natural := 33);   -- WishBone frequency in MHz
    port (
      up_clk: in std_logic;
      rxen: in std_logic;
      spdif: in std_logic;
      lock: out std_logic;
      lock_evt: out std_logic;            -- lock status change event
      rx_data: out std_logic;
      rx_data_en: out std_logic;
      rx_block_start: out std_logic;
      rx_frame_start: out std_logic;
      rx_channel_a: out std_logic;
      rx_error: out std_logic;
      ud_a_en: out std_logic;              -- user data ch. A enable
      ud_b_en: out std_logic;              -- user data ch. B enable
      cs_a_en: out std_logic;              -- channel status ch. A enable
      cs_b_en: out std_logic);             -- channel status ch. B enable);            
  end component;

  component dpram
    generic (DATA_WIDTH: positive := 32;
             RAM_WIDTH: positive := 8);
    port (
      clk: in std_logic;
      rst: in std_logic; -- reset is optional, not used here
      din: in std_logic_vector(DATA_WIDTH - 1 downto 0);
      wr_en: in std_logic;
      rd_en: in std_logic;
      wr_addr: in std_logic_vector(RAM_WIDTH - 1 downto 0);
      rd_addr: in std_logic_vector(RAM_WIDTH - 1 downto 0);
      dout: out std_logic_vector(DATA_WIDTH - 1 downto 0));
  end component;

  component rx_decode 
    generic (DATA_WIDTH: integer range 16 to 32 := 32;
             ADDR_WIDTH: integer range 8 to 64 := 8);   
    port (
      up_clk: in std_logic;
      conf_rxen: in std_logic;
      conf_sample: in std_logic;
      conf_valid: in std_logic;
      conf_mode: in std_logic_vector(3 downto 0);
      conf_blken: in std_logic;
      conf_valen: in std_logic;
      conf_useren: in std_logic;
      conf_staten: in std_logic;
      conf_paren: in std_logic;
      lock: in std_logic;
      rx_data: in std_logic;
      rx_data_en: in std_logic;
      rx_block_start: in std_logic;
      rx_frame_start: in std_logic;
      rx_channel_a: in std_logic; 
      wr_en: out std_logic;
      wr_addr: out std_logic_vector(ADDR_WIDTH - 2 downto 0);
      wr_data: out std_logic_vector(DATA_WIDTH - 1 downto 0);
      stat_paritya: out std_logic;
      stat_parityb: out std_logic;
      stat_lsbf: out std_logic;
      stat_hsbf: out std_logic);
  end component;

  component rx_wb_decoder
    generic (DATA_WIDTH: integer := 32;
             ADDR_WIDTH: integer := 8);
    port (
      up_clk: in std_logic;             -- wishbone clock
      wb_rst_i: in std_logic;             -- reset signal
      wb_sel_i: in std_logic;             -- select input
      wb_stb_i: in std_logic;             -- strobe input
      wb_we_i: in std_logic;              -- write enable
      wb_cyc_i: in std_logic;             -- cycle input
      wb_bte_i: in std_logic_vector(1 downto 0);  -- burts type extension
      wb_adr_i: in std_logic_vector(ADDR_WIDTH - 1 downto 0);  -- address
      wb_cti_i: in std_logic_vector(2 downto 0);  -- cycle type identifier
      data_out: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- internal bus
      wb_ack_o: out std_logic;            -- acknowledge
      wb_dat_o: out std_logic_vector(DATA_WIDTH - 1 downto 0);  -- data out
      version_rd: out std_logic;          -- Version register read 
      config_rd: out std_logic;           -- Config register read
      config_wr: out std_logic;           -- Config register write
      status_rd: out std_logic;           -- Status register read
      intmask_rd: out std_logic;          -- Interrupt mask register read
      intmask_wr: out std_logic;          -- Interrupt mask register write
      intstat_rd: out std_logic;          -- Interrupt status register read
      intstat_wr: out std_logic;          -- Interrupt status register read
      mem_rd: out std_logic;              -- Sample memory read
      mem_addr: out std_logic_vector(ADDR_WIDTH - 2 downto 0);  -- memory addr.
      ch_st_cap_rd: out std_logic_vector(7 downto 0);  -- Ch. status cap. read
      ch_st_cap_wr: out std_logic_vector(7 downto 0);  -- Ch. status cap. write
      ch_st_data_rd: out std_logic_vector(7 downto 0)); -- Ch. status data read
  end component;

end rx_package;
