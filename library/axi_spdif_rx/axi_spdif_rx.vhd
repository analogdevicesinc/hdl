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
    s_axi_aclk          : in  std_logic;
    s_axi_aresetn       : in  std_logic;
    s_axi_awaddr        : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_awvalid       : in  std_logic;
    s_axi_wdata         : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    s_axi_wstrb         : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    s_axi_wvalid        : in  std_logic;
    s_axi_bready        : in  std_logic;
    s_axi_araddr        : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_arvalid       : in  std_logic;
    s_axi_rready        : in  std_logic;
    s_axi_arready       : out std_logic;
    s_axi_rdata         : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    s_axi_rresp         : out std_logic_vector(1 downto 0);
    s_axi_rvalid        : out std_logic;
    s_axi_wready        : out std_logic;
    s_axi_bresp         : out std_logic_vector(1 downto 0);
    s_axi_bvalid        : out std_logic;
    s_axi_awready       : out std_logic;
    s_axi_awprot        : in  std_logic_vector(2 downto 0);
    s_axi_arprot        : in  std_logic_vector(2 downto 0);


    --AXI STREAM interface
    m_axis_aclk         : in  std_logic;
    m_axis_tready       : in  std_logic;
    m_axis_tdata        : out std_logic_vector(31 downto 0);
    m_axis_tlast        : out std_logic;
    m_axis_tvalid       : out std_logic;
    m_axis_tkeep        : out std_logic_vector(3 downto 0);

    --PL330 DMA interface
    dma_req_aclk        : in  std_logic;
    dma_req_rstn        : in  std_logic;
    dma_req_davalid     : in  std_logic;
    dma_req_datype      : in  std_logic_vector(1 downto 0);
    dma_req_daready     : out std_logic;
    dma_req_drvalid     : out std_logic;
    dma_req_drtype      : out std_logic_vector(1 downto 0);
    dma_req_drlast      : out std_logic;
    dma_req_drready     : in  std_logic
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
        clk            => s_axi_aclk,
        resetn         => s_axi_aresetn,
        fifo_reset     => fifo_reset,

        enable         => enable,
        period_len     => 11,

        m_axis_aclk    => m_axis_aclk,
        m_axis_tready  => m_axis_tready,
        m_axis_tdata   => m_axis_tdata,
        m_axis_tlast   => m_axis_tlast,
        m_axis_tvalid  => m_axis_tvalid,
        m_axis_tkeep   => m_axis_tkeep,

        -- Write port
        in_stb         => sample_wr,
        in_ack         => sample_ack,
        in_data        => sample_din
      );
  end generate;

  no_streaming_dma_gen: if C_DMA_TYPE /= 0 generate
    m_axis_tvalid <= '0';
    m_axis_tlast <= '0';
    m_axis_tkeep <= "0000";
    m_axis_tdata <= (others => '0');
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
        clk         => s_axi_aclk,
        resetn      => s_axi_aresetn,
        fifo_reset  => fifo_reset,
        enable      => enable,

        in_data     => sample_din,
        in_stb      => sample_wr,

        out_ack     => tx_fifo_stb,
        out_data    => sampled_data,

        dclk        => dma_req_aclk,
        dresetn     => dma_req_rstn,
        davalid     => dma_req_davalid,
        daready     => dma_req_daready,
        datype      => dma_req_datype,
        drvalid     => dma_req_drvalid,
        drready     => dma_req_drready,
        drtype      => dma_req_drtype,
        drlast      => dma_req_drlast
      );
  end generate;

  no_pl330_dma_gen: if C_DMA_TYPE /= 1 generate
        dma_req_daready <= '0';
        dma_req_drvalid <= '0';
        dma_req_drtype <= (others => '0');
        dma_req_drlast <= '0';
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
        up_clk          => s_axi_aclk,
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
        up_clk => s_axi_aclk,
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
        up_clk => s_axi_aclk,
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
      s_axi_aclk         => s_axi_aclk,
      s_axi_aresetn      => s_axi_aresetn,
      s_axi_awaddr       => s_axi_awaddr,
      s_axi_awvalid      => s_axi_awvalid,
      s_axi_wdata        => s_axi_wdata,
      s_axi_wstrb        => s_axi_wstrb,
      s_axi_wvalid       => s_axi_wvalid,
      s_axi_bready       => s_axi_bready,
      s_axi_araddr       => s_axi_araddr,
      s_axi_arvalid      => s_axi_arvalid,
      s_axi_rready       => s_axi_rready,
      s_axi_arready      => s_axi_arready,
      s_axi_rdata        => s_axi_rdata,
      s_axi_rresp        => s_axi_rresp,
      s_axi_rvalid       => s_axi_rvalid,
      s_axi_wready       => s_axi_wready,
      s_axi_bresp        => s_axi_bresp,
      s_axi_bvalid       => s_axi_bvalid,
      s_axi_awready      => s_axi_awready,

      rd_addr            => rd_addr,
      rd_data            => rd_data,
      rd_ack             => rd_ack,
      rd_stb             => '1',

      wr_addr            => wr_addr,
      wr_data            => wr_data,
      wr_ack             => '1',
      wr_stb             => wr_stb
    );

  process (s_axi_aclk)
  begin
    if rising_edge(s_axi_aclk) then
      if s_axi_aresetn = '0' then
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
