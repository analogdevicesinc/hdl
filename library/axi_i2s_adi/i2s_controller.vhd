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
use work.fifo_synchronizer;
use work.i2s_clkgen;
use work.i2s_tx;
use work.i2s_rx;

entity i2s_controller is
	generic(
		C_SLOT_WIDTH		: integer := 24;	-- Width of one Slot
		C_BCLK_POL		: integer := 0;		-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_LRCLK_POL		: integer := 0;		-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_NUM_CH		: integer := 1;
		C_HAS_TX		: integer := 1;
		C_HAS_RX		: integer := 1
	);
	port(
		clk			: in  std_logic;	-- System clock
		resetn			: in  std_logic; 	-- System reset

		data_clk		: in  std_logic;	-- Data clock should be less than clk / 4
		bclk_o			: out std_logic_vector(C_NUM_CH - 1 downto 0); 	-- Bit Clock
		lrclk_o			: out std_logic_vector(C_NUM_CH - 1 downto 0);	-- Frame Clock
		sdata_o			: out std_logic_vector(C_NUM_CH - 1 downto 0);	-- Serial Data Output
		sdata_i			: in  std_logic_vector(C_NUM_CH - 1 downto 0);	-- Serial Data Input

		tx_enable		: in  Boolean;	-- Enable TX
		tx_ack			: out std_logic;	-- Request new Slot Data
		tx_stb			: in  std_logic;	-- Request new Slot Data
		tx_data			: in  std_logic_vector(C_SLOT_WIDTH-1 downto 0); 	-- Slot Data in
	
		rx_enable		: in  Boolean;	-- Enable RX
		rx_ack			: in  std_logic;
		rx_stb			: out std_logic;	-- Valid Slot Data
		rx_data			: out std_logic_vector(C_SLOT_WIDTH-1 downto 0);	-- Slot Data out

		-- Runtime parameter
		bclk_div_rate		: in  natural range 0 to 255;
		lrclk_div_rate		: in  natural range 0 to 255
	);
end i2s_controller;

architecture Behavioral of i2s_controller is
constant NUM_TX			: integer := C_HAS_TX * C_NUM_CH;
constant NUM_RX			: integer := C_HAS_RX * C_NUM_CH;

signal enable			: Boolean;

signal cdc_sync_stage0_tick	: std_logic := '0';
signal cdc_sync_stage1_tick	: std_logic;
signal cdc_sync_stage2_tick	: std_logic;
signal cdc_sync_stage3_tick	: std_logic;

signal BCLK_O_int		: std_logic;
signal LRCLK_O_int		: std_logic;

signal tx_bclk			: std_logic;
signal tx_lrclk			: std_logic;
signal tx_sdata			: std_logic_vector(C_NUM_CH - 1 downto 0);
signal tx_tick			: std_logic;
signal tx_channel_sync		: std_logic;
signal tx_frame_sync		: std_logic;

signal const_1      : std_logic;
signal bclk_tick		: std_logic;

signal rx_bclk			: std_logic;
signal rx_lrclk			: std_logic;
signal rx_sdata			: std_logic_vector(NUM_RX - 1 downto 0);
signal rx_channel_sync		: std_logic;
signal rx_frame_sync		: std_logic;

signal tx_sync_fifo_out : std_logic_vector(3 + NUM_TX downto 0);
signal tx_sync_fifo_in : std_logic_vector(3 + NUM_TX downto 0);
signal rx_sync_fifo_out : std_logic_vector(3 + NUM_RX downto 0);
signal rx_sync_fifo_in : std_logic_vector(3 + NUM_RX downto 0);

signal data_resetn : std_logic;
signal data_reset_vec : std_logic_vector(2 downto 0);

begin
	enable <= rx_enable or tx_enable;

  const_1 <= '1';
	process (data_clk, resetn)
	begin
		if resetn = '0' then
			data_reset_vec <= (others => '1');
		elsif rising_edge(data_clk) then
			data_reset_vec(2 downto 1) <= data_reset_vec(1 downto 0);
			data_reset_vec(0) <= '0';
		end if;
	end process;

	data_resetn <= not data_reset_vec(2);

	-- Generate tick signal in the DATA_CLK_I domain
	process (data_clk)
	begin
		if rising_edge(data_clk) then
			cdc_sync_stage0_tick <= not cdc_sync_stage0_tick;
		end if;
	end process;

	process (clk)
	begin
		if rising_edge(clk) then
			cdc_sync_stage1_tick <= cdc_sync_stage0_tick;
			cdc_sync_stage2_tick <= cdc_sync_stage1_tick;
			cdc_sync_stage3_tick <= cdc_sync_stage2_tick;
		end if;
	end process;

	tx_tick <= cdc_sync_stage2_tick xor cdc_sync_stage3_tick;

	tx_sync_fifo_in(0) <= tx_channel_sync;
	tx_sync_fifo_in(1) <= tx_frame_sync;
	tx_sync_fifo_in(2) <= tx_bclk;
	tx_sync_fifo_in(3) <= tx_lrclk;
	tx_sync_fifo_in(3 + NUM_TX downto 4) <= tx_sdata;


	process (data_clk)
	begin
		if rising_edge(data_clk) then
			if data_resetn = '0' then
				bclk_o <= (others => '1');
				lrclk_o <= (others => '1');
				sdata_o <= (others => '0');
			else
				if C_BCLK_POL = 0 then
					bclk_o <= (others => tx_sync_fifo_out(2));
				else
					bclk_o <= (others => not tx_sync_fifo_out(2));
				end if;

				if C_LRCLK_POL = 0 then
					lrclk_o <= (others => tx_sync_fifo_out(3));
				else
					lrclk_o <= (others => not tx_sync_fifo_out(3));
				end if;

				if C_HAS_TX = 1 then
					sdata_o <= tx_sync_fifo_out(3 + NUM_TX downto 4);
				end if;
	
				if  C_HAS_RX = 1 then
					rx_sync_fifo_in(3 downto 0) <= tx_sync_fifo_out(3 downto 0);
					rx_sync_fifo_in(3 + NUM_RX downto 4) <= sdata_i;
				end if;
			end if;
		end if;
	end process;

	tx_sync: entity fifo_synchronizer
		generic map (
			DEPTH => 4,
			WIDTH => NUM_TX + 4
		)
		port map (
			in_resetn => resetn,
			in_clk => clk,
			in_data => tx_sync_fifo_in,
			in_tick => tx_tick,

			out_resetn => data_resetn,
			out_clk => data_clk,
			out_data => tx_sync_fifo_out
		);

	clkgen: entity i2s_clkgen
		port map(
			clk => clk,
			resetn => resetn,
			enable => enable,
			tick => tx_tick,

			bclk_div_rate => bclk_div_rate,
			lrclk_div_rate => lrclk_div_rate,

			channel_sync => tx_channel_sync,
			frame_sync => tx_frame_sync,
			
			bclk => tx_bclk,
			lrclk => tx_lrclk
		);

	tx_gen: if C_HAS_TX = 1 generate
		tx: entity i2s_tx
			generic map (
				C_SLOT_WIDTH => C_SLOT_WIDTH,
				C_NUM => NUM_TX
			)
			port map (
				clk => clk,
				resetn => resetn,
				enable => tx_enable,

				channel_sync => tx_channel_sync,
				frame_sync => tx_frame_sync,
				bclk => tx_bclk,
				sdata => tx_sdata,
				
				ack => tx_ack,
				stb => tx_stb,
				data => tx_data
			);
	end generate;

	rx_gen: if C_HAS_RX = 1 generate
		rx: entity i2s_rx
			generic map (
				C_SLOT_WIDTH => C_SLOT_WIDTH,
				C_NUM => NUM_RX
			)
			port map (
				clk => clk,
				resetn => resetn,
				enable => rx_enable,

				channel_sync => rx_channel_sync,
				frame_sync => rx_frame_sync,
				bclk => rx_bclk,
				sdata => rx_sdata,
				
				ack => rx_ack,
				stb => rx_stb,
				data => rx_data
			);

		rx_channel_sync <= rx_sync_fifo_out(0);
		rx_frame_sync <= rx_sync_fifo_out(1);
		rx_bclk <= rx_sync_fifo_out(2);
		rx_lrclk <= rx_sync_fifo_out(3);
		rx_sdata <= rx_sync_fifo_out(3 + NUM_RX downto 4);

		rx_sync: entity fifo_synchronizer
			generic map (
				DEPTH => 4,
				WIDTH => NUM_RX + 4
			)
			port map (
				in_resetn => data_resetn,
				in_clk => data_clk,
				in_data => rx_sync_fifo_in,
				in_tick => const_1,

				out_resetn => resetn,
				out_clk => clk,
				out_data => rx_sync_fifo_out
			);

	end generate;

end Behavioral;
