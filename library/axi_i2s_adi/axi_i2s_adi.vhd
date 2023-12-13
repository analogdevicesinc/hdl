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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.i2s_controller;

library work;
use work.axi_streaming_dma_rx_fifo;
use work.axi_streaming_dma_tx_fifo;
use work.pl330_dma_fifo;
use work.axi_ctrlif;

entity axi_i2s_adi is
	generic
	(
		-- ADD USER GENERICS BELOW THIS LINE ---------------
		SLOT_WIDTH		: integer := 24;
		LRCLK_POL		: integer := 0;		-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
		BCLK_POL		: integer := 0; 	-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
		-- ADD USER GENERICS ABOVE THIS LINE ---------------

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol parameters, do not add to or delete
		S_AXI_DATA_WIDTH	: integer			:= 32;
		S_AXI_ADDRESS_WIDTH	: integer			:= 32;
		DEVICE_FAMILY		: string			:= "virtex6";
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
		DMA_TYPE		: integer			:= 0;
		NUM_OF_CHANNEL		: integer			:= 1;
		HAS_TX		: integer			:= 1;
		HAS_RX		: integer			:= 1
	);
	port
	(
		-- Serial Data interface
		data_clk_i		: in  std_logic;
		bclk_o			: out std_logic_vector(NUM_OF_CHANNEL - 1 downto 0);
		lrclk_o			: out std_logic_vector(NUM_OF_CHANNEL - 1 downto 0);
		sdata_o			: out std_logic_vector(NUM_OF_CHANNEL - 1 downto 0);
		sdata_i			: in  std_logic_vector(NUM_OF_CHANNEL - 1 downto 0);

		-- AXI Streaming DMA TX interface
		s_axis_aclk		: in  std_logic;
		s_axis_aresetn		: in  std_logic;
		s_axis_tready		: out std_logic;
		s_axis_tdata		: in  std_logic_vector(31 downto 0);
		s_axis_tlast		: in  std_logic;
		s_axis_tvalid		: in  std_logic;

		-- AXI Streaming DMA RX interface
		m_axis_aclk		: in  std_logic;
		m_axis_tready		: in  std_logic;
		m_axis_tdata		: out std_logic_vector(31 downto 0);
		m_axis_tlast		: out std_logic;
		m_axis_tvalid		: out std_logic;
		m_axis_tkeep		: out std_logic_vector(3 downto 0);

		--PL330 DMA TX interface
		dma_req_tx_aclk    : in  std_logic;
		dma_req_tx_rstn    : in  std_logic;
		dma_req_tx_davalid : in  std_logic;
		dma_req_tx_datype  : in  std_logic_vector(1 downto 0);
		dma_req_tx_daready : out std_logic;
		dma_req_tx_drvalid : out std_logic;
		dma_req_tx_drtype  : out std_logic_vector(1 downto 0);
		dma_req_tx_drlast  : out std_logic;
		dma_req_tx_drready : in  std_logic;

		-- PL330 DMA RX interface
		dma_req_rx_aclk    : in  std_logic;
		dma_req_rx_rstn    : in  std_logic;
		dma_req_rx_davalid : in  std_logic;
		dma_req_rx_datype  : in  std_logic_vector(1 downto 0);
		dma_req_rx_daready : out std_logic;
		dma_req_rx_drvalid : out std_logic;
		dma_req_rx_drtype  : out std_logic_vector(1 downto 0);
		dma_req_rx_drlast  : out std_logic;
		dma_req_rx_drready : in  std_logic;

		-- AXI bus interface
		s_axi_aclk		: in  std_logic;
		s_axi_aresetn		: in  std_logic;
		s_axi_awaddr		: in  std_logic_vector(S_AXI_ADDRESS_WIDTH-1 downto 0);
		s_axi_awvalid		: in  std_logic;
		s_axi_wdata		: in  std_logic_vector(S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb		: in  std_logic_vector((S_AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wvalid		: in  std_logic;
		s_axi_bready		: in  std_logic;
		s_axi_araddr		: in  std_logic_vector(S_AXI_ADDRESS_WIDTH-1 downto 0);
		s_axi_arvalid		: in  std_logic;
		s_axi_rready		: in  std_logic;
		s_axi_arready		: out std_logic;
		s_axi_rdata		: out std_logic_vector(S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp		: out std_logic_vector(1 downto 0);
		s_axi_rvalid		: out std_logic;
		s_axi_wready		: out std_logic;
		s_axi_bresp		: out std_logic_vector(1 downto 0);
		s_axi_bvalid		: out std_logic;
		s_axi_awready		: out std_logic;
    s_axi_awprot  : in  std_logic_vector(2 downto 0);
    s_axi_arprot  : in  std_logic_vector(2 downto 0)

	);
end entity axi_i2s_adi;

architecture Behavioral of axi_i2s_adi is

------------------------------------------
-- Signals for user logic slave model s/w accessible register example
------------------------------------------
signal i2s_reset			: std_logic;
signal tx_fifo_reset			: std_logic;
signal tx_enable			: Boolean;
signal tx_data				: std_logic_vector(SLOT_WIDTH - 1 downto 0);
signal tx_ack				: std_logic;
signal tx_stb				: std_logic;

signal rx_enable			: Boolean;
signal rx_fifo_reset			: std_logic;
signal rx_data				: std_logic_vector(SLOT_WIDTH - 1 downto 0);
signal rx_ack				: std_logic;
signal rx_stb				: std_logic;

signal const_1      : std_logic;

signal bclk_div_rate			: natural range 0 to 255;
signal lrclk_div_rate			: natural range 0 to 255;

signal period_len			: integer range 0 to 65535;

signal I2S_RESET_REG			: std_logic_vector(31 downto 0);
signal I2S_CONTROL_REG			: std_logic_vector(31 downto 0);
signal I2S_CLK_CONTROL_REG		: std_logic_vector(31 downto 0);
signal PERIOD_LEN_REG			: std_logic_vector(31 downto 0);

constant FIFO_AWIDTH			: integer := integer(ceil(log2(real(NUM_OF_CHANNEL * 8))));

-- Audio samples FIFO
constant RAM_ADDR_WIDTH			: integer := 7;
type RAM_TYPE is array (0 to (2**RAM_ADDR_WIDTH - 1)) of std_logic_vector(31 downto 0);

-- RX FIFO signals
signal audio_fifo_rx			: RAM_TYPE;
signal audio_fifo_rx_wr_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal audio_fifo_rx_rd_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal tvalid				: std_logic := '0';
signal rx_tlast				: std_logic;
signal drain_tx_dma			: std_logic;

signal rx_sample			: std_logic_vector(23 downto 0);

signal wr_data : std_logic_vector(31 downto 0);
signal rd_data : std_logic_vector(31 downto 0);
signal wr_addr : integer range 0 to 11;
signal rd_addr : integer range 0 to 11;
signal wr_stb : std_logic;
signal rd_ack : std_logic;
signal tx_fifo_stb : std_logic;
signal rx_fifo_ack : std_logic;
signal cnt : integer range 0 to 2**16-1;
begin

  const_1 <= '1';

	process (s_axi_aclk)
	begin
		if rising_edge(s_axi_aclk) then
			if s_axi_aresetn = '0' then
				cnt <= 0;
			else
				cnt <= (cnt + 1) mod 2**16;
			end if;
		end if;
	end process;

	streaming_dma_tx_gen: if DMA_TYPE = 0 and HAS_TX = 1 generate
		tx_fifo : entity axi_streaming_dma_tx_fifo
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24
			)
			port map(
				clk => s_axi_aclk,
				resetn => s_axi_aresetn,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				s_axis_aclk => s_axis_aclk,
				s_axis_tready => s_axis_tready,
				s_axis_tdata => s_axis_tdata(31 downto 8),
				s_axis_tlast => s_axis_tlast,
				s_axis_tvalid => s_axis_tvalid,

				out_stb => tx_stb,
				out_ack => tx_ack,
				out_data => tx_data
			);
	end generate;

	no_streaming_dma_tx_gen: if DMA_TYPE /= 0 or HAS_TX /= 1 generate
		s_axis_tready <= '0';
	end generate;

	streaming_dma_rx_gen: if DMA_TYPE = 0 and HAS_RX = 1 generate
		rx_fifo : entity axi_streaming_dma_rx_fifo
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24
			)
			port map(
				clk => s_axi_aclk,
				resetn => s_axi_aresetn,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				period_len => period_len,

				in_stb => rx_stb,
				in_ack => rx_ack,
				in_data => rx_data,

				m_axis_aclk => m_axis_aclk,
				m_axis_tready => m_axis_tready,
				m_axis_tdata => m_axis_tdata(31 downto 8),
				m_axis_tlast => m_axis_tlast,
				m_axis_tvalid => m_axis_tvalid,
				m_axis_tkeep => m_axis_tkeep
			);

			m_axis_tdata(7 downto 0) <= (others => '0');
	end generate;

	no_streaming_dma_rx_gen: if DMA_TYPE /= 0 or HAS_RX /= 1 generate
		m_axis_tdata <= (others => '0');
		m_axis_tlast <= '0';
		m_axis_tvalid <= '0';
		m_axis_tkeep <= (others => '0');
	end generate;



	pl330_dma_tx_gen: if DMA_TYPE = 1 and HAS_TX = 1 generate
		tx_fifo_stb <= '1' when wr_addr = 11 and wr_stb = '1' else '0';

		tx_fifo: entity pl330_dma_fifo
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24,
				FIFO_DIRECTION => 0
			)
			port map (
				clk => s_axi_aclk,
				resetn => s_axi_aresetn,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				in_data => wr_data(31 downto 8),
				in_stb => tx_fifo_stb,

				out_ack => tx_ack,
				out_stb => tx_stb,
				out_data => tx_data,

				dclk => dma_req_tx_aclk,
				dresetn => dma_req_tx_rstn,
				davalid => dma_req_tx_davalid,
				daready => dma_req_tx_daready,
				datype => dma_req_tx_datype,
				drvalid => dma_req_tx_drvalid,
				drready => dma_req_tx_drready,
				drtype => dma_req_tx_drtype,
				drlast => dma_req_tx_drlast
			);
	end generate;

	no_pl330_dma_tx_gen: if DMA_TYPE /= 1 or HAS_TX /= 1 generate
		dma_req_tx_daready <= '0';
		dma_req_tx_drvalid <= '0';
		dma_req_tx_drtype <= (others => '0');
		dma_req_tx_drlast <= '0';
	end generate;

	pl330_dma_rx_gen: if DMA_TYPE = 1 and HAS_RX = 1 generate
		rx_fifo_ack <= '1' when rd_addr = 10 and rd_ack = '1' else '0';

		rx_fifo: entity pl330_dma_fifo
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24,
				FIFO_DIRECTION => 1
			)
			port map (
				clk => s_axi_aclk,
				resetn => s_axi_aresetn,
				fifo_reset => rx_fifo_reset,
				enable => rx_enable,

				in_ack => rx_ack,
				in_stb => rx_stb,
				in_data => rx_data,

				out_data => rx_sample,
				out_ack => rx_fifo_ack,

				dclk => dma_req_rx_aclk,
				dresetn => dma_req_rx_rstn,
				davalid => dma_req_rx_davalid,
				daready => dma_req_rx_daready,
				datype => dma_req_rx_datype,
				drvalid => dma_req_rx_drvalid,
				drready => dma_req_rx_drready,
				drtype => dma_req_rx_drtype,
				drlast => dma_req_rx_drlast
			);

	end generate;

	no_pl330_dma_rx_gen: if DMA_TYPE /= 1 or HAS_RX /= 1 generate
		dma_req_rx_daready <= '0';
		dma_req_rx_drvalid <= '0';
		dma_req_rx_drtype <= (others => '0');
		dma_req_rx_drlast <= '0';
	end generate;

	ctrl : entity i2s_controller
		generic map (
			C_SLOT_WIDTH => SLOT_WIDTH,
			C_BCLK_POL => BCLK_POL,
			C_LRCLK_POL => LRCLK_POL,
			C_NUM_CH => NUM_OF_CHANNEL,
			C_HAS_TX => HAS_TX,
			C_HAS_RX => HAS_RX
		)
		port map (
			clk => s_axi_aclk,
			resetn => s_axi_aresetn,

			data_clk => data_clk_i,
			bclk_o => bclk_o,
			lrclk_o => lrclk_o,
			sdata_o => sdata_o,
			sdata_i => sdata_i,

			tx_enable => tx_enable,
			tx_ack => tx_ack,
			tx_stb => tx_stb,
			tx_data => tx_data,

			rx_enable => rx_enable,
			rx_ack => rx_ack,
			rx_stb => rx_stb,
			rx_data => rx_data,

			bclk_div_rate => bclk_div_rate,
			lrclk_div_rate => lrclk_div_rate
		);

	i2s_reset		<= I2S_RESET_REG(0);
	tx_fifo_reset		<= I2S_RESET_REG(1);
	rx_fifo_reset		<= I2S_RESET_REG(2);
	tx_enable		<= I2S_CONTROL_REG(0) = '1';
	rx_enable		<= I2S_CONTROL_REG(1) = '1';
	bclk_div_rate		<= to_integer(unsigned(I2S_CLK_CONTROL_REG(7 downto 0)));
	lrclk_div_rate		<= to_integer(unsigned(I2S_CLK_CONTROL_REG(23 downto 16)));
	period_len		<= to_integer(unsigned(PERIOD_LEN_REG(15 downto 0)));

	ctrlif: entity axi_ctrlif
		generic map (
			C_S_AXI_ADDR_WIDTH => S_AXI_ADDRESS_WIDTH,
			C_S_AXI_DATA_WIDTH => S_AXI_DATA_WIDTH,
			C_NUM_REG => 12
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
			rd_ack		=> rd_ack,
			rd_stb			=> const_1,

			wr_addr			=> wr_addr,
			wr_data			=> wr_data,
			wr_ack			=> const_1,
			wr_stb			=> wr_stb
		);

	process(rd_addr, I2S_CONTROL_REG, I2S_CLK_CONTROL_REG, PERIOD_LEN_REG, rx_sample, cnt)
	begin
		case rd_addr is
			when 1 => rd_data <=  I2S_CONTROL_REG and x"00000003";
			when 2 => rd_data <=  I2S_CLK_CONTROL_REG and x"00ff00ff";
			when 6 => rd_data <= PERIOD_LEN_REG and x"0000ffff";
			when 10 => rd_data <= rx_sample & std_logic_vector(to_unsigned(cnt, 8));
			when others => rd_data <= (others => '0');
		end case;
	end process;

	process(s_axi_aclk) is
	begin
		if rising_edge(s_axi_aclk) then
			if s_axi_aresetn = '0' then
				I2S_RESET_REG <= (others => '0');
				I2S_CONTROL_REG <= (others => '0');
				I2S_CLK_CONTROL_REG <= (others => '0');
				PERIOD_LEN_REG <= (others => '0');
			else
				-- Auto-clear the Reset Register bits
				I2S_RESET_REG(0) <= '0';
				I2S_RESET_REG(1) <= '0';
				I2S_RESET_REG(2) <= '0';
				if wr_stb = '1' then
					case wr_addr is
						when 0 => I2S_RESET_REG <= wr_data;
						when 1 => I2S_CONTROL_REG <= wr_data;
						when 2 => I2S_CLK_CONTROL_REG <= wr_data;
						when 6 => PERIOD_LEN_REG <= wr_data;
						when others => null;
					end case;
				end if;
			end if;
		end if;
	end process;

end Behavioral;
