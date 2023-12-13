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

entity i2s_rx is
	generic(
		C_SLOT_WIDTH	: integer := 24;	-- Width of one Slot
		C_NUM		: integer := 1
	);
	port(
		clk		: in  std_logic; 	-- System clock 
		resetn		: in  std_logic; 	-- System reset
		enable		: in  Boolean;		-- Enable RX

		bclk		: in  std_logic;	-- Bit Clock
		channel_sync	: in  std_logic;	-- Channel Sync
		frame_sync	: in  std_logic;	-- Frame Sync
		sdata		: in std_logic_vector(C_NUM - 1 downto 0);		-- Serial Data Output

		stb		: out std_logic;	-- Data available
		ack		: in  std_logic;	-- Data has been consumed
		data		: out  std_logic_vector(C_SLOT_WIDTH-1 downto 0) 	-- Slot Data in
	);
end i2s_rx;

architecture Behavioral of i2s_rx is
	type mem is array (0 to C_NUM - 1) of std_logic_vector(31 downto 0);
	type mem_latched is array (0 to C_NUM - 1) of std_logic_vector(C_SLOT_WIDTH - 1 downto 0);
	signal data_int : mem;
	signal data_latched : mem_latched;
	signal reset_int : Boolean;
	signal enable_int : Boolean;

	signal bit_sync : std_logic;
	signal channel_sync_int : std_logic;
	signal frame_sync_int : std_logic;

	signal bclk_d1 : std_logic;

	type sequencer_state_type is (IDLE, ACTIVE);
	signal sequencer_state : sequencer_state_type;
	signal seq : natural range 0 to C_NUM - 1;

	signal ovf_frame_cnt : natural range 0 to 1;
begin

	reset_int <= (resetn = '0') or not enable;

	process (clk)
	begin
		if rising_edge(clk) then
			if resetn = '0' then
				bclk_d1 <= '0';
			else
				bclk_d1 <= bclk;
			end if;
	    end if;
	end process;

	bit_sync <= (bclk xor bclk_d1) and bclk;
	channel_sync_int <= channel_sync and bit_sync;
	frame_sync_int <= frame_sync and bit_sync;

	stb <= '1' when sequencer_state = ACTIVE else '0';
	
	sequencer: process (clk)
	begin
		if rising_edge(clk) then
			if reset_int or not enable_int then
				sequencer_state <= IDLE;
				ovf_frame_cnt <= 0;
				seq <= 0;
			else
				case sequencer_state is
				when IDLE =>
					if channel_sync_int = '1' then
						if ovf_frame_cnt = 0 then
						    sequencer_state <= ACTIVE;
						else
						    ovf_frame_cnt <= (ovf_frame_cnt + 1) mod 2;
						end if;
					end if;
				when ACTIVE =>
					-- The unlikely event the last ack came in in the same clock
					-- cyclce as the channel sync signal will still be treated
					-- as an overflow. This keeps the logic simple
					if ack = '1' then
						if seq = C_NUM - 1 then
							sequencer_state <= IDLE;
							seq <= 0;
						else
							seq <= seq + 1;
						end if;
					end if;
					if channel_sync_int = '1' then
						ovf_frame_cnt <= (ovf_frame_cnt + 1) mod 2;
					end if;
				end case;
			end if;
		end if;
	end process;

	data <= data_latched(seq);

	gen: for i in 0 to C_NUM - 1 generate

		unserialize_data: process(clk)
		begin
			if rising_edge(clk) then
				if reset_int then
					data_int(i) <= (others => '0');
				elsif bit_sync = '1' then
					if channel_sync = '1' then
						if sequencer_state = IDLE then
						    data_latched(i) <= data_int(i)(31 downto 32 - C_SLOT_WIDTH);
--						    data_latched(i) <= data_int(i)(31 downto 32 -
--							C_SLOT_WIDTH + 8) &
--									std_logic_vector(to_unsigned(i+1,8));
						end if;
					end if;
					data_int(i) <= data_int(i)(30 downto 0) & sdata(i);
				end if;
			end if;
		end process unserialize_data;
	end generate;

	enable_sync: process (clk)
	begin
		if rising_edge(clk) then
			if reset_int then
				enable_int <= False;
			else
				if enable and frame_sync_int = '1' then
					enable_int <= True;
				elsif not enable then
					enable_int <= False;
				end if;
			end if;
		end if;
	end process enable_sync;

end Behavioral;
