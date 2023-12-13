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
use ieee.numeric_std.all;

entity dma_fifo is
	generic (
		RAM_ADDR_WIDTH : integer := 3;
		FIFO_DWIDTH : integer := 32
	);
	port (
		clk		: in  std_logic;
		resetn		: in  std_logic;
		fifo_reset	: in  std_logic;

		-- Write port
		in_stb		: in  std_logic;
		in_ack		: out std_logic;
		in_data		: in  std_logic_vector(FIFO_DWIDTH-1 downto 0);

		-- Read port
		out_stb		: out std_logic;	
		out_ack		: in  std_logic;
		out_data	: out std_logic_vector(FIFO_DWIDTH-1 downto 0)
	);
end;

architecture imp of dma_fifo is

	constant FIFO_MAX		: natural := 2**RAM_ADDR_WIDTH -1;
	type MEM is array (0 to FIFO_MAX) of std_logic_vector(FIFO_DWIDTH - 1 downto 0);
	signal data_fifo		: MEM;
	signal wr_addr			: natural range 0 to FIFO_MAX;
	signal rd_addr			: natural range 0 to FIFO_MAX;
	signal not_full, not_empty	: Boolean;

begin
	in_ack <= '1' when not_full else '0';

	out_stb <= '1' when not_empty else '0';
	out_data <= data_fifo(rd_addr);

	fifo_data: process (clk) is
	begin
		if rising_edge(clk) then
			if not_full then
				data_fifo(wr_addr) <= in_data;
			end if;
		end if;
	end process;

	fifo_ctrl: process (clk) is
		variable free_cnt : integer range 0 to FIFO_MAX + 1;
	begin
		if rising_edge(clk) then
			if (resetn = '0') or (fifo_reset = '1') then
				wr_addr <= 0;
				rd_addr <= 0;
				free_cnt := FIFO_MAX + 1;
				not_empty <= False;
				not_full <= True;
			else
				if in_stb = '1' and not_full then
					wr_addr <= (wr_addr + 1) mod (FIFO_MAX + 1);
					free_cnt := free_cnt - 1;
				end if;

				if out_ack = '1' and not_empty then
					rd_addr <= (rd_addr + 1) mod (FIFO_MAX + 1);
					free_cnt := free_cnt + 1;
				end if;

				not_full <= not (free_cnt = 0);
				not_empty <= not (free_cnt = FIFO_MAX + 1);
			end if;
		end if;
	end process;
end;
