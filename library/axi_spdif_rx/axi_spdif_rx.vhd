------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Copyright 2011-2013(c) Analog Devices, Inc.
--
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--       - Redistributions of source code must retain the above copyright
--         notice, this list of conditions and the following disclaimer.
--       - Redistributions in binary form must reproduce the above copyright
--         notice, this list of conditions and the following disclaimer in
--         the documentation and/or other materials provided with the
--         distribution.
--       - Neither the name of Analog Devices, Inc. nor the names of its
--         contributors may be used to endorse or promote products derived
--         from this software without specific prior written permission.
--       - The use of this software may or may not infringe the patent rights
--         of one or more patent holders.  This license does not release you
--         from the requirement that you obtain separate licenses from these
--         patent holders to use this software.
--       - Use of the software either in source or binary form, must be run
--         on or directly connected to an Analog Devices Inc. component.
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
-- istvan.csomortani@analog.com (c) Analog Devices Inc.
------------------------------------------------------------------------------
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.rx_package.all;
use work.axi_ctrlif;
use work.axi_streaming_dma_rx_fifo;
use work.pl330_dma_fifo;

entity axi_spdif_rx is
  generic
  (
    C_S_AXI_DATA_WIDTH  : integer  := 32;
    C_S_AXI_ADDR_WIDTH  : integer  := 32;
    C_DMA_TYPE          : integer  := 0
  );
  port
  (
    --SPDIF ports
    rx_int_o            : out std_logic;
    spdif_rx_i          : in std_logic;
    spdif_rx_i_dbg      : out std_logic;

    --AXI Lite inter    face
    S_AXI_ACLK          : in  std_logic;
    S_AXI_ARESETN       : in  std_logic;
    S_AXI_AWADDR        : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID       : in  std_logic;
    S_AXI_WDATA         : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB         : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID        : in  std_logic;
    S_AXI_BREADY        : in  std_logic;
    S_AXI_ARADDR        : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID       : in  std_logic;
    S_AXI_RREADY        : in  std_logic;
    S_AXI_ARREADY       : out std_logic;
    S_AXI_RDATA         : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP         : out std_logic_vector(1 downto 0);
    S_AXI_RVALID        : out std_logic;
    S_AXI_WREADY        : out std_logic;
    S_AXI_BRESP         : out std_logic_vector(1 downto 0);
    S_AXI_BVALID        : out std_logic;
    S_AXI_AWREADY       : out std_logic;
    S_AXI_AWPROT        : in  std_logic_vector(2 downto 0);
    S_AXI_ARPROT        : in  std_logic_vector(2 downto 0);


    --AXI STREAM interface
    M_AXIS_ACLK         : in  std_logic;
    M_AXIS_TREADY       : in  std_logic;
    M_AXIS_TDATA        : out std_logic_vector(31 downto 0);
    M_AXIS_TLAST        : out std_logic;
    M_AXIS_TVALID       : out std_logic;
    M_AXIS_TKEEP        : out std_logic_vector(3 downto 0);

    --PL330 DMA interface
    DMA_REQ_ACLK        : in  std_logic;
    DMA_REQ_RSTN        : in  std_logic;
    DMA_REQ_DAVALID     : in  std_logic;
    DMA_REQ_DATYPE      : in  std_logic_vector(1 downto 0);
    DMA_REQ_DAREADY     : out std_logic;
    DMA_REQ_DRVALID     : out std_logic;
    DMA_REQ_DRTYPE      : out std_logic_vector(1 downto 0);
    DMA_REQ_DRLAST      : out std_logic;
    DMA_REQ_DRREADY     : in  std_logic
  );
end entity axi_spdif_rx;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_spdif_rx is

  signal wr_data          : std_logic_vector(31 downto 0);
  signal rd_data          : std_logic_vector(31 downto 0);
  signal wr_addr          : integer range 0 to 3;
  signal rd_addr          : integer range 0 to 3;
  signal wr_stb           : std_logic;
  signal rd_ack           : std_logic;

  signal version_reg      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal control_reg      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal chstatus_reg     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

  signal sampled_data     : std_logic_vector(31 downto 0);

  signal sample_ack       : std_logic;
  signal sample_din       : std_logic_vector(31 downto 0);
  signal sample_wr        : std_logic;

  signal conf_rxen        : std_logic;
  signal conf_sample      : std_logic;
  signal conf_chas        : std_logic;
  signal conf_valid       : std_logic;
  signal conf_blken       : std_logic;
  signal conf_valen       : std_logic;
  signal conf_useren      : std_logic;
  signal conf_staten      : std_logic;
  signal conf_paren       : std_logic;
  signal config_rd        : std_logic;
  signal config_wr        : std_logic;

  signal conf_mode        : std_logic_vector(3 downto 0);
  signal conf_bits        : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
  signal conf_dout        : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);

  signal fifo_data_out    : std_logic_vector(31 downto 0);
  signal fifo_data_ack    : std_logic;
  signal fifo_reset       : std_logic;
  signal tx_fifo_stb      : std_logic;

  signal enable           : boolean;

  signal lock             : std_logic;

  signal rx_data          : std_logic;
  signal rx_data_en       : std_logic;
  signal rx_block_start   : std_logic;
  signal rx_channel_a     : std_logic;
  signal rx_error         : std_logic;
  signal lock_evt         : std_logic;
  signal ud_a_en          : std_logic;
  signal ud_b_en          : std_logic;
  signal cs_a_en          : std_logic;
  signal cs_b_en          : std_logic;
  signal rx_frame_start   : std_logic;

  signal istat_lsbf       : std_logic;
  signal istat_hsbf       : std_logic;
  signal istat_paritya    : std_logic;
  signal istat_parityb    : std_logic;

  signal sbuf_wr_adr      : std_logic_vector(C_S_AXI_ADDR_WIDTH - 2 downto 0);

begin

  -------------------------------------------------------------------------------
  -- Version Register
  -------------------------------------------------------------------------------
  version_reg(31 downto 20) <= (others => '0');
  version_reg(19 downto 16) <= "0001";
  version_reg(15 downto 12) <= (others => '0');
  version_reg(11 downto 5)  <= std_logic_vector(to_unsigned(C_S_AXI_ADDR_WIDTH,7));
  version_reg(4)            <= '1';
  version_reg(3 downto 0)   <= "0001";
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- Control Register
  --------------------------------------------------------------------------------
  conf_mode(3 downto 0)     <= control_reg(23 downto 20);
  conf_paren                <= control_reg(19);
  conf_staten               <= control_reg(18);
  conf_useren               <= control_reg(17);
  conf_valen                <= control_reg(16);
  conf_blken                <= control_reg(5);
  conf_valid                <= control_reg(4);
  conf_chas                 <= control_reg(3);
  conf_sample               <= control_reg(1);
  conf_rxen                 <= control_reg(0);
  --------------------------------------------------------------------------------

  fifo_reset <= not conf_sample;
  enable <= conf_sample = '1';

  streaming_dma_gen: if C_DMA_TYPE = 0 generate
    fifo: entity axi_streaming_dma_rx_fifo
      generic map (
        RAM_ADDR_WIDTH => 3,
        FIFO_DWIDTH    => 32
      )
      port map (
        clk            => S_AXI_ACLK,
        resetn         => S_AXI_ARESETN,
        fifo_reset     => fifo_reset,

        enable         => enable,
        period_len     => 11,

        M_AXIS_ACLK    => M_AXIS_ACLK,
        M_AXIS_TREADY  => M_AXIS_TREADY,
        M_AXIS_TDATA   => M_AXIS_TDATA,
        M_AXIS_TLAST   => M_AXIS_TLAST,
        M_AXIS_TVALID  => M_AXIS_TVALID,
        M_AXIS_TKEEP   => M_AXIS_TKEEP,

        -- Write port
        in_stb         => sample_wr,
        in_ack         => sample_ack,
        in_data        => sample_din
      );
  end generate;

  no_streaming_dma_gen: if C_DMA_TYPE /= 0 generate
    M_AXIS_TVALID <= '0';
    M_AXIS_TLAST <= '0';
    M_AXIS_TKEEP <= "0000";
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
        clk         => S_AXI_ACLK,
        resetn      => S_AXI_ARESETN,
        fifo_reset  => fifo_reset,
        enable      => enable,

        in_data     => sample_din,
        in_stb      => sample_wr,

        out_ack     => tx_fifo_stb,
        out_data    => sampled_data,

        dclk        => DMA_REQ_ACLK,
        dresetn     => DMA_REQ_RSTN,
        davalid     => DMA_REQ_DAVALID,
        daready     => DMA_REQ_DAREADY,
        datype      => DMA_REQ_DATYPE,
        drvalid     => DMA_REQ_DRVALID,
        drready     => DMA_REQ_DRREADY,
        drtype      => DMA_REQ_DRTYPE,
        drlast      => DMA_REQ_DRLAST
      );
  end generate;

  no_pl330_dma_gen: if C_DMA_TYPE /= 1 generate
        DMA_REQ_DAREADY <= '0';
        DMA_REQ_DRVALID <= '0';
        DMA_REQ_DRTYPE <= (others => '0');
        DMA_REQ_DRLAST <= '0';
  end generate;

  --------------------------------------------------------------------------------
  -- Status Register
  --------------------------------------------------------------------------------
  STAT: rx_status_reg
    generic map
    (
        DATA_WIDTH => C_S_AXI_DATA_WIDTH
    )
    port map
    (
        up_clk          => S_AXI_ACLK,
        status_rd       => rd_ack,
        lock            => lock,
        chas            => conf_chas,
        rx_block_start  => rx_block_start,
        ch_data         => rx_data,
        cs_a_en         => cs_a_en,
        cs_b_en         => cs_b_en,
        status_dout     => chstatus_reg
    );
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- Phase decoder
  --------------------------------------------------------------------------------
  PDET: rx_phase_det
    generic map
    (
        AXI_FREQ => 100   -- WishBone frequency in MHz
    )
    port map
    (
        up_clk => S_AXI_ACLK,
        rxen => conf_rxen,
        spdif => spdif_rx_i,
        lock => lock,
        lock_evt => lock_evt,
        rx_data => rx_data,
        rx_data_en => rx_data_en,
        rx_block_start => rx_block_start,
        rx_frame_start => rx_frame_start,
        rx_channel_a => rx_channel_a,
        rx_error => rx_error,
        ud_a_en => ud_a_en,
        ud_b_en => ud_b_en,
        cs_a_en => cs_a_en,
        cs_b_en => cs_b_en
    );
    spdif_rx_i_dbg <= spdif_rx_i;
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- Rx Decoder
  --------------------------------------------------------------------------------
  FDEC: rx_decode
    generic map
    (
        DATA_WIDTH => C_S_AXI_DATA_WIDTH,
        ADDR_WIDTH => C_S_AXI_ADDR_WIDTH
    )
    port map
    (
        up_clk => S_AXI_ACLK,
        conf_rxen => conf_rxen,
        conf_sample => conf_sample,
        conf_valid => conf_valid,
        conf_mode => conf_mode,
        conf_blken => conf_blken,
        conf_valen => conf_valen,
        conf_useren => conf_useren,
        conf_staten => conf_staten,
        conf_paren => conf_paren,
        lock => lock,
        rx_data => rx_data,
        rx_data_en => rx_data_en,
        rx_block_start => rx_block_start,
        rx_frame_start => rx_frame_start,
        rx_channel_a => rx_channel_a,
        wr_en => sample_wr,
        wr_addr => sbuf_wr_adr,
        wr_data => sample_din,
        stat_paritya => istat_paritya,
        stat_parityb => istat_parityb,
        stat_lsbf => istat_lsbf,
        stat_hsbf => istat_hsbf
    );
    rx_int_o <= sample_wr;

  ctrlif: entity axi_ctrlif
    generic map (
      C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
      C_NUM_REG => 4
    )
    port map(
      S_AXI_ACLK         => S_AXI_ACLK,
      S_AXI_ARESETN      => S_AXI_ARESETN,
      S_AXI_AWADDR       => S_AXI_AWADDR,
      S_AXI_AWVALID      => S_AXI_AWVALID,
      S_AXI_WDATA        => S_AXI_WDATA,
      S_AXI_WSTRB        => S_AXI_WSTRB,
      S_AXI_WVALID       => S_AXI_WVALID,
      S_AXI_BREADY       => S_AXI_BREADY,
      S_AXI_ARADDR       => S_AXI_ARADDR,
      S_AXI_ARVALID      => S_AXI_ARVALID,
      S_AXI_RREADY       => S_AXI_RREADY,
      S_AXI_ARREADY      => S_AXI_ARREADY,
      S_AXI_RDATA        => S_AXI_RDATA,
      S_AXI_RRESP        => S_AXI_RRESP,
      S_AXI_RVALID       => S_AXI_RVALID,
      S_AXI_WREADY       => S_AXI_WREADY,
      S_AXI_BRESP        => S_AXI_BRESP,
      S_AXI_BVALID       => S_AXI_BVALID,
      S_AXI_AWREADY      => S_AXI_AWREADY,

      rd_addr            => rd_addr,
      rd_data            => rd_data,
      rd_ack             => rd_ack,
      rd_stb             => '1',

      wr_addr            => wr_addr,
      wr_data            => wr_data,
      wr_ack             => '1',
      wr_stb             => wr_stb
    );

  process (S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        control_reg <= (others => '0');
      else
        if wr_stb = '1' then
          case wr_addr is
            when 1 => control_reg <= wr_data;
            when others => null;
          end case;
        end if;
      end if;
    end if;
  end process;

  process (rd_addr, version_reg, control_reg, chstatus_reg, sampled_data)
  begin
    case rd_addr is
      when 0 => rd_data <= version_reg;
      when 1 => rd_data <= control_reg;
      when 2 => rd_data <= chstatus_reg;
      when 3 => rd_data <= sampled_data;
      when others => rd_data <= (others => '0');
    end case;
  end process;

end IMP;
