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
--      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
--      This will allow to generate bit files and not release the source code,
--      as long as it attaches to an ADI device.
--
-- ***************************************************************************
-- ***************************************************************************

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.dma_fifo;

entity axi_streaming_dma_tx_fifo is
	generic (
		RAM_ADDR_WIDTH : integer := 3;
		FIFO_DWIDTH : integer := 32 
	);
	port (
		clk		: in std_logic;
		resetn		: in std_logic;
		fifo_reset	: in std_logic;

		-- Enable DMA interface
		enable		: in Boolean;

		-- Write port
		s_axis_aclk	: in std_logic;
		s_axis_tready	: out std_logic;
		s_axis_tdata	: in std_logic_vector(FIFO_DWIDTH-1 downto 0);
		s_axis_tlast	: in std_logic;
		s_axis_tvalid	: in std_logic;

		-- Read port
		out_stb		: out std_logic;
		out_ack		: in std_logic;
		out_data	: out std_logic_vector(FIFO_DWIDTH-1 downto 0)
	);
end;

architecture imp of axi_streaming_dma_tx_fifo is
	signal in_ack			: std_logic;
	signal drain_dma		: Boolean;
begin

	fifo: entity dma_fifo
		generic map (
			RAM_ADDR_WIDTH => RAM_ADDR_WIDTH,
			FIFO_DWIDTH => FIFO_DWIDTH
		)
		port map (
			clk => clk,
			resetn => resetn,
			fifo_reset => fifo_reset,
			in_stb => s_axis_tvalid,
			in_ack => in_ack,
			in_data => s_axis_tdata,
			out_stb => out_stb,
			out_ack => out_ack,
			out_data => out_data
		);

	drain_process: process (s_axis_aclk) is
		variable enable_d1 : Boolean;
	begin
		if rising_edge(s_axis_aclk) then
			if resetn = '0' then
				drain_dma <= False;
			else
				if s_axis_tlast = '1' then
					drain_dma <= False;
				elsif not enable_d1 and enable then
					drain_dma <= False;
				elsif enable_d1 and not enable then
					drain_dma <= True;
				end if;
				enable_d1 := enable;
			end if;
		end if;
	end process;

	s_axis_tready <= '1' when in_ack = '1' or drain_dma else '0';
end;
