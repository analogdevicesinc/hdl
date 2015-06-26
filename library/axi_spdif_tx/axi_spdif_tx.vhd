------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Copyright 2011-2013(c) Analog Devices, Inc.
-- 
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--	 - Redistributions of source code must retain the above copyright
--	   notice, this list of conditions and the following disclaimer.
--	 - Redistributions in binary form must reproduce the above copyright
--	   notice, this list of conditions and the following disclaimer in
--	   the documentation and/or other materials provided with the
--	   distribution.
--	 - Neither the name of Analog Devices, Inc. nor the names of its
--	   contributors may be used to endorse or promote products derived
--	   from this software without specific prior written permission.
--	 - The use of this software may or may not infringe the patent rights
--	   of one or more patent holders.  This license does not release you
--	   from the requirement that you obtain separate licenses from these
--	   patent holders to use this software.
--	 - Use of the software either in source or binary form, must be run
--	   on or directly connected to an Analog Devices Inc. component.
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
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- andrei.cozma@analog.com (c) Analog Devices Inc.
------------------------------------------------------------------------------
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.tx_package.all;
use work.axi_ctrlif;
use work.axi_streaming_dma_tx_fifo;
use work.pl330_dma_fifo;

entity axi_spdif_tx is
	generic (
		C_S_AXI_DATA_WIDTH	: integer		:= 32;
		C_S_AXI_ADDR_WIDTH	: integer		:= 32;
		C_FAMILY		: string		:= "virtex6";
		C_DMA_TYPE		: integer		:= 0
	);
	port (
		--SPDIF ports
		spdif_data_clk	: in  std_logic;
		spdif_tx_o	: out std_logic;

		--AXI Lite interface
		S_AXI_ACLK	: in  std_logic;
		S_AXI_ARESETN	: in  std_logic;
		S_AXI_AWADDR	: in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWVALID	: in  std_logic;
		S_AXI_WDATA	: in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in  std_logic;
		S_AXI_BREADY	: in  std_logic;
		S_AXI_ARADDR	: in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARVALID	: in  std_logic;
		S_AXI_RREADY	: in  std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_AWREADY	: out std_logic;
		
		--AXI streaming interface
		S_AXIS_ACLK	: in  std_logic;
		S_AXIS_ARESETN	: in  std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in  std_logic_vector(31 downto 0);
		S_AXIS_TLAST	: in  std_logic;
		S_AXIS_TVALID	: in  std_logic;

		--PL330 DMA interface
		DMA_REQ_ACLK    : in  std_logic;
		DMA_REQ_RSTN    : in  std_logic;
		DMA_REQ_DAVALID : in  std_logic;
		DMA_REQ_DATYPE  : in  std_logic_vector(1 downto 0);
		DMA_REQ_DAREADY : out std_logic;
		DMA_REQ_DRVALID : out std_logic;
		DMA_REQ_DRTYPE  : out std_logic_vector(1 downto 0);
		DMA_REQ_DRLAST  : out std_logic;
		DMA_REQ_DRREADY : in  std_logic
		);
end entity axi_spdif_tx;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_spdif_tx is
	------------------------------------------
	-- SPDIF signals
	------------------------------------------
	signal config_reg : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal chstatus_reg : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

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

	streaming_dma_gen: if C_DMA_TYPE = 0 generate
		fifo: entity axi_streaming_dma_tx_fifo
			generic map (
				RAM_ADDR_WIDTH	=> 3,
				FIFO_DWIDTH	=> 32
			)
			port map (
				clk		=> S_AXI_ACLK,
				resetn		=> S_AXI_ARESETN,
				fifo_reset	=> fifo_reset,
				enable		=> enable,
				S_AXIS_ACLK	=> S_AXIS_ACLK,
				S_AXIS_TREADY	=> S_AXIS_TREADY,
				S_AXIS_TDATA	=> S_AXIS_TDATA,
				S_AXIS_TVALID	=> S_AXIS_TLAST,
				S_AXIS_TLAST	=> S_AXIS_TVALID,

				out_ack		=> fifo_data_ack,
				out_data	=> fifo_data_out
			);
	end generate;

	no_streaming_dma_gen: if C_DMA_TYPE /= 0 generate
		S_AXIS_TREADY <= '0';
	end generate;

	pl330_dma_gen: if C_DMA_TYPE = 1 generate
		tx_fifo_stb <= '1' when wr_addr = 3 and wr_stb = '1' else '0';

		fifo: entity pl330_dma_fifo
			generic map(
				RAM_ADDR_WIDTH => 3,
				FIFO_DWIDTH => 32,
				FIFO_DIRECTION => 0
			)
			port map (
				clk		=> S_AXI_ACLK,
				resetn		=> S_AXI_ARESETN,
				fifo_reset	=> fifo_reset,
				enable		=> enable,

				in_data		=> wr_data,
				in_stb		=> tx_fifo_stb,

				out_ack		=> fifo_data_ack,
				out_data	=> fifo_data_out,

				dclk		=> DMA_REQ_ACLK,
				dresetn		=> DMA_REQ_RSTN,
				davalid		=> DMA_REQ_DAVALID,
				daready		=> DMA_REQ_DAREADY,
				datype		=> DMA_REQ_DATYPE,
				drvalid		=> DMA_REQ_DRVALID,
				drready		=> DMA_REQ_DRREADY,
				drtype		=> DMA_REQ_DRTYPE,
				drlast		=> DMA_REQ_DRLAST
			);
	end generate;

	no_pl330_dma_gen: if C_DMA_TYPE /= 1 generate
		DMA_REQ_DAREADY <= '0';
		DMA_REQ_DRVALID <= '0';
		DMA_REQ_DRTYPE <= (others => '0');
		DMA_REQ_DRLAST <= '0';
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
			up_clk		=> S_AXI_ACLK,
			data_clk	=> spdif_data_clk,  -- data clock
			resetn		=> S_AXI_ARESETN,   -- resetn
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
			C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
			C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
			C_NUM_REG => 4
		)
		port map(
			S_AXI_ACLK		=> S_AXI_ACLK,
			S_AXI_ARESETN		=> S_AXI_ARESETN,
			S_AXI_AWADDR		=> S_AXI_AWADDR,
			S_AXI_AWVALID		=> S_AXI_AWVALID,
			S_AXI_WDATA		=> S_AXI_WDATA,
			S_AXI_WSTRB		=> S_AXI_WSTRB,
			S_AXI_WVALID		=> S_AXI_WVALID,
			S_AXI_BREADY		=> S_AXI_BREADY,
			S_AXI_ARADDR		=> S_AXI_ARADDR,
			S_AXI_ARVALID		=> S_AXI_ARVALID,
			S_AXI_RREADY		=> S_AXI_RREADY,
			S_AXI_ARREADY		=> S_AXI_ARREADY,
			S_AXI_RDATA		=> S_AXI_RDATA,
			S_AXI_RRESP		=> S_AXI_RRESP,
			S_AXI_RVALID		=> S_AXI_RVALID,
			S_AXI_WREADY		=> S_AXI_WREADY,
			S_AXI_BRESP		=> S_AXI_BRESP,
			S_AXI_BVALID		=> S_AXI_BVALID,
			S_AXI_AWREADY		=> S_AXI_AWREADY,

			rd_addr			=> rd_addr,
			rd_data			=> rd_data,
			rd_ack			=> rd_ack,
			rd_stb			=> '1',

			wr_addr			=> wr_addr,
			wr_data			=> wr_data,
			wr_ack			=> '1',
			wr_stb			=> wr_stb
		);

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
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
