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

library work;
use work.dma_fifo;

entity pl330_dma_fifo is
	generic (
		RAM_ADDR_WIDTH : integer := 3;
		FIFO_DWIDTH : integer := 32;
		FIFO_DIRECTION : integer := 0 -- 0 = write FIFO, 1 = read FIFO
	);
	port (
		clk		: in  std_logic;
		resetn		: in  std_logic;
		fifo_reset	: in  std_logic;

		-- Enable DMA interface
		enable		: in  Boolean;

		-- Write port
		in_stb		: in  std_logic;
		in_ack		: out std_logic;
		in_data		: in  std_logic_vector(FIFO_DWIDTH-1 downto 0);

		-- Read port
		out_stb		: out std_logic;	
		out_ack		: in  std_logic;
		out_data	: out std_logic_vector(FIFO_DWIDTH-1 downto 0);

		-- PL330 DMA interface
		dclk		: in  std_logic;
		dresetn		: in  std_logic;
		davalid		: in  std_logic;
		daready		: out std_logic;
		datype		: in  std_logic_vector(1 downto 0);
		drvalid		: out std_logic;
		drready		: in  std_logic;
		drtype		: out std_logic_vector(1 downto 0);
		drlast		: out std_logic;

		DBG			: out std_logic_vector(7 downto 0)
	);
end;

architecture imp of pl330_dma_fifo is
	signal request_data		: Boolean;

	type state_type is (IDLE, REQUEST, WAITING, FLUSH);
	signal state			: state_type;
	signal i_in_ack			: std_logic;
	signal i_out_stb			: std_logic;
begin

	in_ack <= i_in_ack;
	out_stb <= i_out_stb;

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
			in_ack => i_in_ack,
			in_data => in_data,
			out_stb => i_out_stb,
			out_ack => out_ack,
			out_data => out_data
		);

	request_data <= i_in_ack = '1' when FIFO_DIRECTION = 0 else i_out_stb = '1';

	drlast <= '0';
	daready <= '1';

	drvalid <= '1' when (state = REQUEST) or (state = FLUSH) else '0';
	drtype <= "00" when state = REQUEST else "10";

	DBG(0) <= davalid;
	DBG(2 downto 1) <= datype;
	DBG(3) <= '1' when request_data else '0';

	process (state)
	begin
		case state is
			when IDLE => DBG(5 downto 4) <= "00";
			when REQUEST => DBG(5 downto 4) <= "01";
			when WAITING => DBG(5 downto 4) <= "10";
			when FLUSH => DBG(5 downto 4) <= "11";
		end case;
	end process;

	pl330_req_fsm: process (dclk) is
	begin
		if rising_edge(dclk) then
			if dresetn = '0' then
				state <= IDLE;
			else
				-- The controller may send a FLUSH request at any time and it won't
				-- respond to any of our requests until we've ack the FLUSH request.
				-- The FLUSH request is also supposed to reset our state machine, so
				-- go back to idle after having acked the FLUSH.
				if davalid = '1' and datype = "10" then
					state <= FLUSH;
				else
					case state is
					-- Nothing to do, wait for the fifo to run empty
					when IDLE =>
						if request_data and enable then
							state <= REQUEST;
						end if;
					-- Send out a request to the PL330
					when REQUEST =>
						if drready = '1' then
							state <= WAITING;
						end if;
					-- Wait for a ACK from the PL330 that it did transfer the data
					when WAITING =>
						if fifo_reset = '1' then
							state <= IDLE;
						elsif davalid = '1' then
							if datype = "00" then
								state <= IDLE;
							end if;
						end if;
					-- Send out an ACK for the flush
					when FLUSH =>
						if drready = '1' then
							state <= IDLE;
						end if;
					end case;
				end if;
			end if;
		end if;
	end process;
end;
