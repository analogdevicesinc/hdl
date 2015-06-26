-- ***************************************************************************
-- ***************************************************************************
-- Copyright 2013(c) Analog Devices, Inc.
--  Author: Lars-Peter Clausen <lars-peter.clausen@analog.com>
-- 
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--     - Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     - Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in
--       the documentation and/or other materials provided with the
--       distribution.
--     - Neither the name of Analog Devices, Inc. nor the names of its
--       contributors may be used to endorse or promote products derived
--       from this software without specific prior written permission.
--     - The use of this software may or may not infringe the patent rights
--       of one or more patent holders.  This license does not release you
--       from the requirement that you obtain separate licenses from these
--       patent holders to use this software.
--     - Use of the software either in source or binary form, must be run
--       on or directly connected to an Analog Devices Inc. component.
--    
-- THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED.
--
-- IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
-- RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
-- BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
-- STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
-- THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

	signal cdc_sync_stage0_tick : std_logic;
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
