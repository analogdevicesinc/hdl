-- ***************************************************************************
-- ***************************************************************************
-- Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
--
-- In this HDL repository, there are many different and unique modules, consisting
-- of various HDL (Verilog or VHDL) components. The individual modules are
-- developed independently, and may be accompanied by separate and unique license
-- terms.
--
-- The user should read each of these license terms, and understand the
-- freedoms and responsibilities that he or she has by using this source/core.
--
-- This core is distributed in the hope that it will be useful, but WITHOUT ANY
-- WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
-- A PARTICULAR PURPOSE.
--
-- Redistribution and use of source or resulting binaries, with or without modification
-- of this file, are permitted under one of the following two license terms:
--
--   1. The GNU General Public License version 2 as published by the
--      Free Software Foundation, which can be found in the top level directory
--      of this repository (LICENSE_GPL2), and also online at:
--      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
--
-- OR
--
--   2. An ADI specific BSD license, which can be found in the top level directory
--      of this repository (LICENSE_ADIBSD), and also on-line at:
--      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
--      This will allow to generate bit files and not release the source code,
--      as long as it attaches to an ADI device.
--
-- ***************************************************************************
-- ***************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity fifo_synchronizer is
	generic (
		DEPTH		: integer := 4;
		WIDTH		: integer := 2
	);
	port (

		in_clk	    : in std_logic;
		in_resetn   : in std_logic;
		in_data	    : in std_logic_vector(WIDTH - 1 downto 0);
		in_tick	    : in std_logic;

		out_clk	    : in std_logic;
		out_resetn  : in std_logic;
		out_data    : out std_logic_vector(WIDTH - 1 downto 0);
		out_tick    : out std_logic
	);

end fifo_synchronizer;

architecture impl of fifo_synchronizer is
	type DATA_SYNC_FIFO_TYPE is array (0 to DEPTH - 1) of std_logic_vector(WIDTH - 1 downto 0);
	signal fifo: DATA_SYNC_FIFO_TYPE;

	signal rd_addr : natural range 0 to DEPTH - 1;
	signal wr_addr : natural range 0 to DEPTH - 1;

	signal cdc_sync_stage0_tick : std_logic := '0';
	signal cdc_sync_stage1_tick : std_logic;
	signal cdc_sync_stage2_tick : std_logic;
	signal cdc_sync_stage3_tick : std_logic;
	signal tick : std_logic;
begin

	process (in_clk)
	begin
		if rising_edge(in_clk) then
			if in_tick = '1' then
				cdc_sync_stage0_tick <= not cdc_sync_stage0_tick;
				fifo(wr_addr) <= in_data;
			end if;
		end if;
	end process;

	process (in_clk)
	begin
		if rising_edge(in_clk) then
			if in_resetn = '0' then
				wr_addr <= 0;
			else
				if in_tick = '1' then
					wr_addr <= (wr_addr + 1) mod DEPTH;
				end if;
			end if;
		end if;
	end process;

	process (out_clk)
	begin
		if rising_edge(out_clk) then
			cdc_sync_stage1_tick <= cdc_sync_stage0_tick;
			cdc_sync_stage2_tick <= cdc_sync_stage1_tick;
			cdc_sync_stage3_tick <= cdc_sync_stage2_tick;
		end if;
	end process;

	tick <= cdc_sync_stage2_tick xor cdc_sync_stage3_tick;
	out_tick <= tick;

	process (out_clk)
	begin
		if rising_edge(out_clk) then
			if tick = '1' then
				out_data <= fifo(rd_addr);
			end if;
		end if;
	end process;

	process (out_clk)
	begin
		if rising_edge(out_clk) then
			if out_resetn = '0' then
				rd_addr <= 0;
			else
				if tick = '1' then
					rd_addr <= (rd_addr + 1) mod DEPTH;
				end if;
			end if;
		end if;
	end process;
end;
