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
use work.tx_package.all;
use work.axi_ctrlif;
use work.axi_streaming_dma_tx_fifo;
use work.pl330_dma_fifo;

entity axi_spdif_tx is
	generic (
		S_AXI_DATA_WIDTH	: integer		:= 32;
		S_AXI_ADDRESS_WIDTH	: integer		:= 32;
		DEVICE_FAMILY		: string		:= "virtex6";
		DMA_TYPE		: integer		:= 0
	);
	port (
		--SPDIF ports
		spdif_data_clk	: in  std_logic;
		spdif_tx_o	: out std_logic;

		--AXI Lite interface
		s_axi_aclk	: in  std_logic;
		s_axi_aresetn	: in  std_logic;
		s_axi_awaddr	: in  std_logic_vector(S_AXI_ADDRESS_WIDTH-1 downto 0);
    s_axi_awprot  : in  std_logic_vector(2 downto 0);
		s_axi_awvalid	: in  std_logic;
		s_axi_wdata	: in  std_logic_vector(S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb	: in  std_logic_vector((S_AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wvalid	: in  std_logic;
		s_axi_bready	: in  std_logic;
		s_axi_araddr	: in  std_logic_vector(S_AXI_ADDRESS_WIDTH-1 downto 0);
    s_axi_arprot  : in  std_logic_vector(2 downto 0);
		s_axi_arvalid	: in  std_logic;
		s_axi_rready	: in  std_logic;
		s_axi_arready	: out std_logic;
		s_axi_rdata	: out std_logic_vector(S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp	: out std_logic_vector(1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_wready	: out std_logic;
		s_axi_bresp	: out std_logic_vector(1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_awready	: out std_logic;

		--axi streaming interface
		s_axis_aclk	: in  std_logic;
		s_axis_aresetn	: in  std_logic;
		s_axis_tready	: out std_logic;
		s_axis_tdata	: in  std_logic_vector(31 downto 0);
		s_axis_tlast	: in  std_logic;
		s_axis_tvalid	: in  std_logic;

		--PL330 DMA interface
		dma_req_aclk    : in  std_logic;
		dma_req_rstn    : in  std_logic;
		dma_req_davalid : in  std_logic;
		dma_req_datype  : in  std_logic_vector(1 downto 0);
		dma_req_daready : out std_logic;
		dma_req_drvalid : out std_logic;
		dma_req_drtype  : out std_logic_vector(1 downto 0);
		dma_req_drlast  : out std_logic;
		dma_req_drready : in  std_logic
		);
end entity axi_spdif_tx;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_spdif_tx is
	------------------------------------------
	-- SPDIF signals
	------------------------------------------
	signal config_reg : std_logic_vector(S_AXI_DATA_WIDTH-1 downto 0);
	signal chstatus_reg : std_logic_vector(S_AXI_DATA_WIDTH-1 downto 0);

	signal chstat_freq : std_logic_vector(1 downto 0);
	signal chstat_gstat, chstat_preem, chstat_copy, chstat_audio : std_logic;
	signal sample_data_ack : std_logic;
	signal sample_data: std_logic_vector(15 downto 0);
	signal conf_mode : std_logic_vector(3 downto 0);
	signal conf_ratio : std_logic_vector(7 downto 0);
	signal conf_tinten, conf_txdata, conf_txen : std_logic;
	signal channel : std_logic;
	signal enable : boolean;

	signal fifo_data_out : std_logic_vector(31 downto 0);
	signal fifo_data_ack : std_logic;
	signal fifo_reset : std_logic;
	signal tx_fifo_stb : std_logic;

	-- Register access
	signal wr_data : std_logic_vector(31 downto 0);
	signal rd_data : std_logic_vector(31 downto 0);
	signal wr_addr : integer range 0 to 3;
	signal rd_addr : integer range 0 to 3;
	signal wr_stb : std_logic;
	signal rd_ack : std_logic;
begin

	fifo_reset <= not conf_txdata;
	enable <= conf_txdata = '1';
	fifo_data_ack <= channel and sample_data_ack;

	streaming_dma_gen: if DMA_TYPE = 0 generate
		fifo: entity axi_streaming_dma_tx_fifo
			generic map (
				RAM_ADDR_WIDTH	=> 3,
				FIFO_DWIDTH	=> 32
			)
			port map (
				clk		=> s_axi_aclk,
				resetn		=> s_axi_aresetn,
				fifo_reset	=> fifo_reset,
				enable		=> enable,
				s_axis_aclk	=> s_axis_aclk,
				s_axis_tready	=> s_axis_tready,
				s_axis_tdata	=> s_axis_tdata,
				s_axis_tvalid	=> s_axis_tlast,
				s_axis_tlast	=> s_axis_tvalid,

				out_ack		=> fifo_data_ack,
				out_data	=> fifo_data_out
			);
	end generate;

	no_streaming_dma_gen: if DMA_TYPE /= 0 generate
		s_axis_tready <= '0';
	end generate;

	pl330_dma_gen: if DMA_TYPE = 1 generate
		tx_fifo_stb <= '1' when wr_addr = 3 and wr_stb = '1' else '0';

		fifo: entity pl330_dma_fifo
			generic map(
				RAM_ADDR_WIDTH => 3,
				FIFO_DWIDTH => 32,
				FIFO_DIRECTION => 0
			)
			port map (
				clk		=> s_axi_aclk,
				resetn		=> s_axi_aresetn,
				fifo_reset	=> fifo_reset,
				enable		=> enable,

				in_data		=> wr_data,
				in_stb		=> tx_fifo_stb,

				out_ack		=> fifo_data_ack,
				out_data	=> fifo_data_out,

				dclk		=> dma_req_aclk,
				dresetn		=> dma_req_rstn,
				davalid		=> dma_req_davalid,
				daready		=> dma_req_daready,
				datype		=> dma_req_datype,
				drvalid		=> dma_req_drvalid,
				drready		=> dma_req_drreadY,
				drtype		=> dma_req_drtype,
				drlast		=> dma_req_drlast
			);
	end generate;

	no_pl330_dma_gen: if DMA_TYPE /= 1 generate
		dma_req_daready <= '0';
		dma_req_drvalid <= '0';
		dma_req_drtype <= (others => '0');
		dma_req_drlast <= '0';
	end generate;

	sample_data_mux: process (fifo_data_out, channel) is
	begin
		if channel = '0' then
			sample_data <= fifo_data_out(15 downto 0);
		else
			sample_data <= fifo_data_out(31 downto 16);
		end if;
	end process;

	-- Configuration signals update
	conf_mode(3 downto 0)  <= config_reg(23 downto 20);
	conf_ratio(7 downto 0) <= config_reg(15 downto 8);
	conf_tinten <= config_reg(2);
	conf_txdata <= config_reg(1);
	conf_txen   <= config_reg(0);

	-- Channel status signals update
	chstat_freq(1 downto 0) <= chstatus_reg(7 downto 6);
	chstat_gstat <= chstatus_reg(3);
	chstat_preem <= chstatus_reg(2);
	chstat_copy <= chstatus_reg(1);
	chstat_audio <= chstatus_reg(0);

	-- Transmit encoder
	TENC: tx_encoder
		generic map (
			DATA_WIDTH => 16
		)
		port map (
			up_clk		=> s_axi_aclk,
			data_clk	=> spdif_data_clk,  -- data clock
			resetn		=> s_axi_aresetn,   -- resetn
			conf_mode	=> conf_mode,	    -- sample format
			conf_ratio	=> conf_ratio,	    -- clock divider
			conf_txdata	=> conf_txdata,	    -- sample data enable
			conf_txen	=> conf_txen,	    -- spdif signal enable
			chstat_freq	=> chstat_freq,	    -- sample freq.
			chstat_gstat	=> chstat_gstat,    -- generation status
			chstat_preem	=> chstat_preem,    -- preemphasis status
			chstat_copy	=> chstat_copy,	    -- copyright bit
			chstat_audio	=> chstat_audio,    -- data format
			sample_data	=> sample_data,	    -- audio data
			sample_data_ack => sample_data_ack, -- sample buffer read
			channel		=> channel,	    -- which channel should be read
			spdif_tx_o	=> spdif_tx_o	    -- SPDIF output signal
		);

	ctrlif: entity axi_ctrlif
		generic map (
			C_S_AXI_ADDR_WIDTH => S_AXI_ADDRESS_WIDTH,
			C_S_AXI_DATA_WIDTH => S_AXI_DATA_WIDTH,
			C_NUM_REG => 4
		)
		port map(
			s_axi_aclk		=> s_axi_aclk,
			s_axi_aresetn		=> s_axi_aresetn,
			s_axi_awaddr		=> s_axi_awaddr,
			s_axi_awvalid		=> s_axi_awvalid,
			s_axi_wdata		=> s_axi_wdata,
			s_axi_wstrb		=> s_axi_wstrb,
			s_axi_wvalid		=> s_axi_wvalid,
			s_axi_bready		=> s_axi_bready,
			s_axi_araddr		=> s_axi_araddr,
			s_axi_arvalid		=> s_axi_arvalid,
			s_axi_rready		=> s_axi_rready,
			s_axi_arready		=> s_axi_arready,
			s_axi_rdata		=> s_axi_rdata,
			s_axi_rresp		=> s_axi_rresp,
			s_axi_rvalid		=> s_axi_rvalid,
			s_axi_wready		=> s_axi_wready,
			s_axi_bresp		=> s_axi_bresp,
			s_axi_bvalid		=> s_axi_bvalid,
			s_axi_awready		=> s_axi_awready,

			rd_addr			=> rd_addr,
			rd_data			=> rd_data,
			rd_ack			=> rd_ack,
			rd_stb			=> '1',

			wr_addr			=> wr_addr,
			wr_data			=> wr_data,
			wr_ack			=> '1',
			wr_stb			=> wr_stb
		);

	process (s_axi_aclk)
	begin
		if rising_edge(s_axi_aclk) then
			if s_axi_aresetn = '0' then
				config_reg <= (others => '0');
				chstatus_reg <= (others => '0');
			else
				if wr_stb = '1' then
					case wr_addr is
						when 0 => config_reg <= wr_data;
						when 1 => chstatus_reg <= wr_data;
						when others => null;
					end case;
				end if;
			end if;
		end if;
	end process;

	process (rd_addr, config_reg, chstatus_reg)
	begin
		case rd_addr is
			when 0 => rd_data <= config_reg;
			when 1 => rd_data <= chstatus_reg;
			when others => rd_data <= (others => '0');
		end case;
	end process;

end IMP;
