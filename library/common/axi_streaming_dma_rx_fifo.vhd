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

entity axi_streaming_dma_rx_fifo is
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

		period_len	: in integer range 0 to 65535;

		-- Read port
		m_axis_aclk	: in std_logic;
		m_axis_tready	: in std_logic;
		m_axis_tdata	: out std_logic_vector(FIFO_DWIDTH-1 downto 0);
		m_axis_tlast	: out std_logic;
		m_axis_tvalid	: out std_logic;
		m_axis_tkeep	: out std_logic_vector(3 downto 0);

		-- Write port
		in_stb		: in std_logic;
		in_ack		: out std_logic;
		in_data		: in std_logic_vector(FIFO_DWIDTH-1 downto 0)
	);
end;

architecture imp of axi_streaming_dma_rx_fifo is
	signal out_stb : std_logic;

	signal period_count		: integer range 0 to 65535;
	signal last			: std_logic;
begin

	m_axis_tvalid <= out_stb;

	fifo: entity dma_fifo
		generic map (
			RAM_ADDR_WIDTH => RAM_ADDR_WIDTH,
			FIFO_DWIDTH => FIFO_DWIDTH
		)
		port map (
			clk => clk,
			resetn => resetn,
			fifo_reset => fifo_reset,
			in_stb => in_stb,
			in_ack => in_ack,
			in_data => in_data,
			out_stb => out_stb,
			out_ack => m_axis_tready,
			out_data => m_axis_tdata
		);

	m_axis_tkeep <= "1111";
	m_axis_tlast <= '1' when period_count = 0 else '0';

	period_counter: process(m_axis_aclk) is
	begin
		if rising_edge(m_axis_aclk) then
			if resetn = '0' then
				period_count <= period_len;
			else
				if out_stb = '1' and m_axis_tready = '1' then
					if period_count = 0 then
						period_count <= period_len;
					else
						period_count <= period_count - 1;
					end if;
				end if;
			end if;
		end if;
	end process;
end;
