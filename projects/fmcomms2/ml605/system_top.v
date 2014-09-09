// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  // board interface

  sys_rst,
  sys_clk_p,
  sys_clk_n,
  ddr3_a13,
  ddr3_we_n,
  ddr3_ras_n,
  ddr3_odt,
  ddr3_dqs_n,
  ddr3_dqs,
  ddr3_dq,
  ddr3_dm,
  ddr3_rst,
  ddr3_cs_n,
  ddr3_clk_n,
  ddr3_clk,
  ddr3_cke,
  ddr3_cas_n,
  ddr3_ba,
  ddr3_addr,
  uart_tx,
  uart_rx,
  phy_rstn,
  phy_mdc,
  phy_mdio,
  phy_crs,
  phy_col,
  phy_tx_clk,
  phy_tx_en,
  phy_tx_d,
  phy_rx_clk,
  phy_rx_dv,
  phy_rx_d,
  phy_rx_er,
  iic_scl,
  iic_sda,
  lcd,
  sw,
  led,

  // ad9361 interface

  rx_clk_in_p,
  rx_clk_in_n,
  rx_frame_in_p,
  rx_frame_in_n,
  rx_data_in_p,
  rx_data_in_n,
  tx_clk_out_p,
  tx_clk_out_n,
  tx_frame_out_p,
  tx_frame_out_n,
  tx_data_out_p,
  tx_data_out_n,

  gpio_txnrx,
  gpio_enable,
  gpio_resetb,
  gpio_sync,
  gpio_en_agc,
  gpio_ctl,
  gpio_status,
  
  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso);

  // board interface

  input             sys_rst;
  input             sys_clk_p;
  input             sys_clk_n;
  output            ddr3_a13;
  output            ddr3_we_n;
  output            ddr3_ras_n;
  output            ddr3_odt;
  inout   [  7:0]   ddr3_dqs_n;
  inout   [  7:0]   ddr3_dqs;
  inout   [ 63:0]   ddr3_dq;
  output  [  7:0]   ddr3_dm;
  output            ddr3_rst;
  output            ddr3_cs_n;
  output            ddr3_clk_n;
  output            ddr3_clk;
  output            ddr3_cke;
  output            ddr3_cas_n;
  output  [  2:0]   ddr3_ba;
  output  [ 12:0]   ddr3_addr;
  output            uart_tx;
  input             uart_rx;
  output            phy_rstn;
  output            phy_mdc;
  inout             phy_mdio;
  input             phy_crs;
  input             phy_col;
  input             phy_tx_clk;
  output            phy_tx_en;
  output  [  3:0]   phy_tx_d;
  input             phy_rx_clk;
  input             phy_rx_dv;
  input   [  3:0]   phy_rx_d;
  input             phy_rx_er;
  inout             iic_scl;
  inout             iic_sda;
  inout   [  6:0]   lcd;
  inout   [ 12:0]   sw;
  inout   [ 12:0]   led;

  // ad9361 interface

  input             rx_clk_in_p;
  input             rx_clk_in_n;
  input             rx_frame_in_p;
  input             rx_frame_in_n;
  input   [  5:0]   rx_data_in_p;
  input   [  5:0]   rx_data_in_n;
  output            tx_clk_out_p;
  output            tx_clk_out_n;
  output            tx_frame_out_p;
  output            tx_frame_out_n;
  output  [  5:0]   tx_data_out_p;
  output  [  5:0]   tx_data_out_n;

  inout             gpio_txnrx;
  inout             gpio_enable;
  inout             gpio_resetb;
  inout             gpio_sync;
  inout             gpio_en_agc;
  inout   [  3:0]   gpio_ctl;
  inout   [  7:0]   gpio_status;
  
  output            spi_csn;
  output            spi_clk;
  output            spi_mosi;
  input             spi_miso;

  // internal signals

  wire    [ 31:0]   axi_gpio_fmc_i0;
  wire    [ 31:0]   axi_gpio_fmc_o0;
  wire    [ 31:0]   axi_gpio_fmc_t0;
  wire    [ 31:0]   axi_gpio_fmc_i1;
  wire    [ 31:0]   axi_gpio_fmc_o1;
  wire    [ 31:0]   axi_gpio_fmc_t1;
  wire              axi_spi_fmc_sel;
  wire    [  7:0]   axi_spi_fmc_csn_i;
  wire    [  7:0]   axi_spi_fmc_csn_o;
  wire              axi_spi_fmc_csn_t;
  wire              axi_spi_fmc_clk_i;
  wire              axi_spi_fmc_clk_o;
  wire              axi_spi_fmc_clk_t;
  wire              axi_spi_fmc_mosi_i;
  wire              axi_spi_fmc_mosi_o;
  wire              axi_spi_fmc_mosi_t;
  wire              axi_spi_fmc_miso_i;
  wire              axi_spi_fmc_miso_o;
  wire              axi_spi_fmc_miso_t;
  wire              axi_dma_tx_axil_aclk;
  wire              axi_dma_tx_axil_aresetn;
  wire              axi_dma_tx_axil_awvalid;
  wire    [ 31:0]   axi_dma_tx_axil_awaddr;
  wire              axi_dma_tx_axil_awready;
  wire              axi_dma_tx_axil_wvalid;
  wire    [ 31:0]   axi_dma_tx_axil_wdata;
  wire    [  3:0]   axi_dma_tx_axil_wstrb;
  wire              axi_dma_tx_axil_wready;
  wire              axi_dma_tx_axil_bvalid;
  wire    [  1:0]   axi_dma_tx_axil_bresp;
  wire              axi_dma_tx_axil_bready;
  wire              axi_dma_tx_axil_arvalid;
  wire    [ 31:0]   axi_dma_tx_axil_araddr;
  wire              axi_dma_tx_axil_arready;
  wire              axi_dma_tx_axil_rvalid;
  wire    [ 31:0]   axi_dma_tx_axil_rdata;
  wire    [  1:0]   axi_dma_tx_axil_rresp;
  wire              axi_dma_tx_axil_rready;
  wire              axi_dma_tx_axim_s_aclk;
  wire              axi_dma_tx_axim_s_aresetn;
  wire    [ 31:0]   axi_dma_tx_axim_s_araddr;
  wire    [  7:0]   axi_dma_tx_axim_s_arlen;
  wire    [  2:0]   axi_dma_tx_axim_s_arsize;
  wire    [  1:0]   axi_dma_tx_axim_s_arburst;
  wire    [  2:0]   axi_dma_tx_axim_s_arprot;
  wire    [  3:0]   axi_dma_tx_axim_s_arcache;
  wire              axi_dma_tx_axim_s_arready;
  wire              axi_dma_tx_axim_s_arvalid;
  wire    [  1:0]   axi_dma_tx_axim_s_rresp;
  wire    [ 63:0]   axi_dma_tx_axim_s_rdata;
  wire              axi_dma_tx_axim_s_rready;
  wire              axi_dma_tx_axim_s_rvalid;
  wire              axi_dma_tx_axim_irq;
  wire              axi_dma_rx_axil_aclk;
  wire              axi_dma_rx_axil_aresetn;
  wire              axi_dma_rx_axil_awvalid;
  wire    [ 31:0]   axi_dma_rx_axil_awaddr;
  wire              axi_dma_rx_axil_awready;
  wire              axi_dma_rx_axil_wvalid;
  wire    [ 31:0]   axi_dma_rx_axil_wdata;
  wire    [  3:0]   axi_dma_rx_axil_wstrb;
  wire              axi_dma_rx_axil_wready;
  wire              axi_dma_rx_axil_bvalid;
  wire    [  1:0]   axi_dma_rx_axil_bresp;
  wire              axi_dma_rx_axil_bready;
  wire              axi_dma_rx_axil_arvalid;
  wire    [ 31:0]   axi_dma_rx_axil_araddr;
  wire              axi_dma_rx_axil_arready;
  wire              axi_dma_rx_axil_rvalid;
  wire    [ 31:0]   axi_dma_rx_axil_rdata;
  wire    [  1:0]   axi_dma_rx_axil_rresp;
  wire              axi_dma_rx_axil_rready;
  wire              axi_dma_rx_axim_d_aclk;
  wire              axi_dma_rx_axim_d_aresetn;
  wire    [ 31:0]   axi_dma_rx_axim_d_awaddr;
  wire    [  7:0]   axi_dma_rx_axim_d_awlen;
  wire    [  2:0]   axi_dma_rx_axim_d_awsize;
  wire    [  1:0]   axi_dma_rx_axim_d_awburst;
  wire    [  2:0]   axi_dma_rx_axim_d_awprot;
  wire    [  3:0]   axi_dma_rx_axim_d_awcache;
  wire              axi_dma_rx_axim_d_awvalid;
  wire              axi_dma_rx_axim_d_awready;
  wire    [ 63:0]   axi_dma_rx_axim_d_wdata;
  wire    [  7:0]   axi_dma_rx_axim_d_wstrb;
  wire              axi_dma_rx_axim_d_wready;
  wire              axi_dma_rx_axim_d_wvalid;
  wire              axi_dma_rx_axim_d_wlast;
  wire              axi_dma_rx_axim_d_bready;
  wire    [  1:0]   axi_dma_rx_axim_d_bresp;
  wire              axi_dma_rx_axim_d_bvalid;
  wire              axi_dma_rx_axim_irq;
  wire              axi_dev_tx_axil_aclk;
  wire              axi_dev_tx_axil_aresetn;
  wire              axi_dev_tx_axil_awvalid;
  wire    [ 31:0]   axi_dev_tx_axil_awaddr;
  wire              axi_dev_tx_axil_awready;
  wire              axi_dev_tx_axil_wvalid;
  wire    [ 31:0]   axi_dev_tx_axil_wdata;
  wire    [  3:0]   axi_dev_tx_axil_wstrb;
  wire              axi_dev_tx_axil_wready;
  wire              axi_dev_tx_axil_bvalid;
  wire    [  1:0]   axi_dev_tx_axil_bresp;
  wire              axi_dev_tx_axil_bready;
  wire              axi_dev_tx_axil_arvalid;
  wire    [ 31:0]   axi_dev_tx_axil_araddr;
  wire              axi_dev_tx_axil_arready;
  wire              axi_dev_tx_axil_rvalid;
  wire    [ 31:0]   axi_dev_tx_axil_rdata;
  wire    [  1:0]   axi_dev_tx_axil_rresp;
  wire              axi_dev_tx_axil_rready;
  wire              axi_dev_rx_axil_aclk;
  wire              axi_dev_rx_axil_aresetn;
  wire              axi_dev_rx_axil_awvalid;
  wire    [ 31:0]   axi_dev_rx_axil_awaddr;
  wire              axi_dev_rx_axil_awready;
  wire              axi_dev_rx_axil_wvalid;
  wire    [ 31:0]   axi_dev_rx_axil_wdata;
  wire    [  3:0]   axi_dev_rx_axil_wstrb;
  wire              axi_dev_rx_axil_wready;
  wire              axi_dev_rx_axil_bvalid;
  wire    [  1:0]   axi_dev_rx_axil_bresp;
  wire              axi_dev_rx_axil_bready;
  wire              axi_dev_rx_axil_arvalid;
  wire    [ 31:0]   axi_dev_rx_axil_araddr;
  wire              axi_dev_rx_axil_arready;
  wire              axi_dev_rx_axil_rvalid;
  wire    [ 31:0]   axi_dev_rx_axil_rdata;
  wire    [  1:0]   axi_dev_rx_axil_rresp;
  wire              axi_dev_rx_axil_rready;
  wire              sys_200m_clk;
  wire              clk;
  wire              adc_dwr;
  wire    [ 63:0]   adc_ddata;
  wire              adc_dsync;
  wire              adc_dovf;
  wire              dac_drd;
  wire    [ 63:0]   dac_ddata;
  wire              dac_dunf;

  // gpio interface

  IOBUF i_iobuf_gpio_txnrx (
    .I (axi_gpio_fmc_o0[16]),
    .O (axi_gpio_fmc_i0[16]),
    .T (axi_gpio_fmc_t0[16]),
    .IO (gpio_txnrx));

  IOBUF i_iobuf_gpio_enable (
    .I (axi_gpio_fmc_o0[15]),
    .O (axi_gpio_fmc_i0[15]),
    .T (axi_gpio_fmc_t0[15]),
    .IO (gpio_enable));

  IOBUF i_iobuf_gpio_resetb (
    .I (axi_gpio_fmc_o0[14]),
    .O (axi_gpio_fmc_i0[14]),
    .T (axi_gpio_fmc_t0[14]),
    .IO (gpio_resetb));

  IOBUF i_iobuf_gpio_sync (
    .I (axi_gpio_fmc_o0[13]),
    .O (axi_gpio_fmc_i0[13]),
    .T (axi_gpio_fmc_t0[13]),
    .IO (gpio_sync));

  IOBUF i_iobuf_gpio_en_agc (
    .I (axi_gpio_fmc_o0[12]),
    .O (axi_gpio_fmc_i0[12]),
    .T (axi_gpio_fmc_t0[12]),
    .IO (gpio_en_agc));

  genvar n;
  generate
  for (n = 0; n <= 3; n = n + 1) begin: g_iobuf_gpio_ctl
  IOBUF i_iobuf_gpio_ctl (
    .I (axi_gpio_fmc_o0[8+n]),
    .O (axi_gpio_fmc_i0[8+n]),
    .T (axi_gpio_fmc_t0[8+n]),
    .IO (gpio_ctl[n]));
  end
  for (n = 0; n <= 7; n = n + 1) begin: g_iobuf_gpio_status
  IOBUF i_iobuf_gpio_status (
    .I (axi_gpio_fmc_o0[0+n]),
    .O (axi_gpio_fmc_i0[0+n]),
    .T (axi_gpio_fmc_t0[0+n]),
    .IO (gpio_status[n]));
  end
  endgenerate
  
  // spi interface

  assign spi_csn = axi_spi_fmc_csn_o[0];
  assign spi_clk = axi_spi_fmc_clk_o;
  assign spi_mosi = axi_spi_fmc_mosi_o;
  assign axi_spi_fmc_miso_i = spi_miso;

  // instantiations

  axi_ad9361 #(
    .PCORE_BUFTYPE (1),
    .C_BASEADDR (32'h00000000),
    .C_HIGHADDR (32'hffffffff))
  i_axi_ad9361 (
    .rx_clk_in_p (rx_clk_in_p),
    .rx_clk_in_n (rx_clk_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .adc_start_in (1'd0),
    .adc_start_out (),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_data_out_n (tx_data_out_n),
    .dac_enable_in (1'd0),
    .dac_enable_out (),
    .delay_clk (sys_200m_clk),
    .clk (clk),
    .adc_dwr (adc_dwr),
    .adc_ddata (adc_ddata),
    .adc_dsync (adc_dsync),
    .adc_dovf (adc_dovf),
    .adc_dunf (1'd0),
    .dac_drd (dac_drd),
    .dac_ddata (dac_ddata),
    .dac_dovf (1'd0),
    .dac_dunf (dac_dunf),
    .s_axi_aclk (axi_dev_tx_axil_aclk),
    .s_axi_aresetn (axi_dev_tx_axil_aresetn),
    .s_axi_awvalid (axi_dev_tx_axil_awvalid),
    .s_axi_awaddr (axi_dev_tx_axil_awaddr),
    .s_axi_awready (axi_dev_tx_axil_awready),
    .s_axi_wvalid (axi_dev_tx_axil_wvalid),
    .s_axi_wdata (axi_dev_tx_axil_wdata),
    .s_axi_wstrb (axi_dev_tx_axil_wstrb),
    .s_axi_wready (axi_dev_tx_axil_wready),
    .s_axi_bvalid (axi_dev_tx_axil_bvalid),
    .s_axi_bresp (axi_dev_tx_axil_bresp),
    .s_axi_bready (axi_dev_tx_axil_bready),
    .s_axi_arvalid (axi_dev_tx_axil_arvalid),
    .s_axi_araddr (axi_dev_tx_axil_araddr),
    .s_axi_arready (axi_dev_tx_axil_arready),
    .s_axi_rvalid (axi_dev_tx_axil_rvalid),
    .s_axi_rdata (axi_dev_tx_axil_rdata),
    .s_axi_rresp (axi_dev_tx_axil_rresp),
    .s_axi_rready (axi_dev_tx_axil_rready),
    .adc_mon_valid (),
    .adc_mon_data ());

  axi_dmac #(
    .C_BASEADDR (32'h00000000),
    .C_HIGHADDR (32'hffffffff),
    .C_DMA_TYPE_SRC (0),
    .C_DMA_TYPE_DEST (2),
    .C_CYCLIC (1),
    .C_SYNC_TRANSFER_START (0),
    .C_AXI_SLICE_SRC (0),
    .C_AXI_SLICE_DEST (1),
    .C_CLKS_ASYNC_DEST_REQ (1),
    .C_CLKS_ASYNC_SRC_DEST (1),
    .C_CLKS_ASYNC_REQ_SRC (1),
    .C_2D_TRANSFER (0))
  i_axi_dmac_tx (
    .s_axi_aclk (axi_dma_tx_axil_aclk),
    .s_axi_aresetn (axi_dma_tx_axil_aresetn),
    .s_axi_awvalid (axi_dma_tx_axil_awvalid),
    .s_axi_awaddr (axi_dma_tx_axil_awaddr),
    .s_axi_awready (axi_dma_tx_axil_awready),
    .s_axi_wvalid (axi_dma_tx_axil_wvalid),
    .s_axi_wdata (axi_dma_tx_axil_wdata),
    .s_axi_wstrb (axi_dma_tx_axil_wstrb),
    .s_axi_wready (axi_dma_tx_axil_wready),
    .s_axi_bvalid (axi_dma_tx_axil_bvalid),
    .s_axi_bresp (axi_dma_tx_axil_bresp),
    .s_axi_bready (axi_dma_tx_axil_bready),
    .s_axi_arvalid (axi_dma_tx_axil_arvalid),
    .s_axi_araddr (axi_dma_tx_axil_araddr),
    .s_axi_arready (axi_dma_tx_axil_arready),
    .s_axi_rvalid (axi_dma_tx_axil_rvalid),
    .s_axi_rready (axi_dma_tx_axil_rready),
    .s_axi_rresp (axi_dma_tx_axil_rresp),
    .s_axi_rdata (axi_dma_tx_axil_rdata),
    .irq (axi_dma_tx_axim_irq),
    .m_dest_axi_aclk (),
    .m_dest_axi_aresetn (),
    .m_src_axi_aclk (axi_dma_tx_axim_s_aclk),
    .m_src_axi_aresetn (axi_dma_tx_axim_s_aresetn),
    .m_dest_axi_awaddr (),
    .m_dest_axi_awlen (),
    .m_dest_axi_awsize (),
    .m_dest_axi_awburst (),
    .m_dest_axi_awprot (),
    .m_dest_axi_awcache (),
    .m_dest_axi_awvalid (),
    .m_dest_axi_awready (),
    .m_dest_axi_wdata (),
    .m_dest_axi_wstrb (),
    .m_dest_axi_wready (),
    .m_dest_axi_wvalid (),
    .m_dest_axi_wlast (),
    .m_dest_axi_bvalid (),
    .m_dest_axi_bresp (),
    .m_dest_axi_bready (),
    .m_src_axi_arready (axi_dma_tx_axim_s_arready),
    .m_src_axi_arvalid (axi_dma_tx_axim_s_arvalid),
    .m_src_axi_araddr (axi_dma_tx_axim_s_araddr),
    .m_src_axi_arlen (axi_dma_tx_axim_s_arlen),
    .m_src_axi_arsize (axi_dma_tx_axim_s_arsize),
    .m_src_axi_arburst (axi_dma_tx_axim_s_arburst),
    .m_src_axi_arprot (axi_dma_tx_axim_s_arprot),
    .m_src_axi_arcache (axi_dma_tx_axim_s_arcache),
    .m_src_axi_rdata (axi_dma_tx_axim_s_rdata),
    .m_src_axi_rready (axi_dma_tx_axim_s_rready),
    .m_src_axi_rvalid (axi_dma_tx_axim_s_rvalid),
    .m_src_axi_rresp (axi_dma_tx_axim_s_rresp),
    .s_axis_aclk (),
    .s_axis_ready (),
    .s_axis_valid (),
    .s_axis_data (),
    .s_axis_user (),
    .m_axis_aclk (),
    .m_axis_ready (),
    .m_axis_valid (),
    .m_axis_data (),
    .fifo_wr_clk (),
    .fifo_wr_en (),
    .fifo_wr_din (),
    .fifo_wr_overflow (),
    .fifo_wr_sync (),
    .fifo_rd_clk (clk),
    .fifo_rd_en (dac_drd),
    .fifo_rd_valid (),
    .fifo_rd_dout (dac_ddata),
    .fifo_rd_underflow (dac_dunf));

  axi_dmac #(
    .C_BASEADDR (32'h00000000),
    .C_HIGHADDR (32'hffffffff),
    .C_DMA_TYPE_SRC (2),
    .C_DMA_TYPE_DEST (0),
    .C_CYCLIC (0),
    .C_SYNC_TRANSFER_START (1),
    .C_AXI_SLICE_SRC (0),
    .C_AXI_SLICE_DEST (0),
    .C_CLKS_ASYNC_DEST_REQ (1),
    .C_CLKS_ASYNC_SRC_DEST (1),
    .C_CLKS_ASYNC_REQ_SRC (1),
    .C_2D_TRANSFER (0))
  i_axi_dmac_rx (
    .s_axi_aclk (axi_dma_rx_axil_aclk),
    .s_axi_aresetn (axi_dma_rx_axil_aresetn),
    .s_axi_awvalid (axi_dma_rx_axil_awvalid),
    .s_axi_awaddr (axi_dma_rx_axil_awaddr),
    .s_axi_awready (axi_dma_rx_axil_awready),
    .s_axi_wvalid (axi_dma_rx_axil_wvalid),
    .s_axi_wdata (axi_dma_rx_axil_wdata),
    .s_axi_wstrb (axi_dma_rx_axil_wstrb),
    .s_axi_wready (axi_dma_rx_axil_wready),
    .s_axi_bvalid (axi_dma_rx_axil_bvalid),
    .s_axi_bresp (axi_dma_rx_axil_bresp),
    .s_axi_bready (axi_dma_rx_axil_bready),
    .s_axi_arvalid (axi_dma_rx_axil_arvalid),
    .s_axi_araddr (axi_dma_rx_axil_araddr),
    .s_axi_arready (axi_dma_rx_axil_arready),
    .s_axi_rvalid (axi_dma_rx_axil_rvalid),
    .s_axi_rready (axi_dma_rx_axil_rready),
    .s_axi_rresp (axi_dma_rx_axil_rresp),
    .s_axi_rdata (axi_dma_rx_axil_rdata),
    .irq (axi_dma_rx_axim_irq),
    .m_dest_axi_aclk (axi_dma_rx_axim_d_aclk),
    .m_dest_axi_aresetn (axi_dma_rx_axim_d_aresetn),
    .m_src_axi_aclk (),
    .m_src_axi_aresetn (),
    .m_dest_axi_awaddr (axi_dma_rx_axim_d_awaddr),
    .m_dest_axi_awlen (axi_dma_rx_axim_d_awlen),
    .m_dest_axi_awsize (axi_dma_rx_axim_d_awsize),
    .m_dest_axi_awburst (axi_dma_rx_axim_d_awburst),
    .m_dest_axi_awprot (axi_dma_rx_axim_d_awprot),
    .m_dest_axi_awcache (axi_dma_rx_axim_d_awcache),
    .m_dest_axi_awvalid (axi_dma_rx_axim_d_awvalid),
    .m_dest_axi_awready (axi_dma_rx_axim_d_awready),
    .m_dest_axi_wdata (axi_dma_rx_axim_d_wdata),
    .m_dest_axi_wstrb (axi_dma_rx_axim_d_wstrb),
    .m_dest_axi_wready (axi_dma_rx_axim_d_wready),
    .m_dest_axi_wvalid (axi_dma_rx_axim_d_wvalid),
    .m_dest_axi_wlast (axi_dma_rx_axim_d_wlast),
    .m_dest_axi_bvalid (axi_dma_rx_axim_d_bvalid),
    .m_dest_axi_bresp (axi_dma_rx_axim_d_bresp),
    .m_dest_axi_bready (axi_dma_rx_axim_d_bready),
    .m_src_axi_arready (),
    .m_src_axi_arvalid (),
    .m_src_axi_araddr (),
    .m_src_axi_arlen (),
    .m_src_axi_arsize (),
    .m_src_axi_arburst (),
    .m_src_axi_arprot (),
    .m_src_axi_arcache (),
    .m_src_axi_rdata (),
    .m_src_axi_rready (),
    .m_src_axi_rvalid (),
    .m_src_axi_rresp (),
    .s_axis_aclk (),
    .s_axis_ready (),
    .s_axis_valid (),
    .s_axis_data (),
    .s_axis_user (),
    .m_axis_aclk (),
    .m_axis_ready (),
    .m_axis_valid (),
    .m_axis_data (),
    .fifo_wr_clk (clk),
    .fifo_wr_en (adc_dwr),
    .fifo_wr_din (adc_ddata),
    .fifo_wr_overflow (adc_dovf),
    .fifo_wr_sync (adc_dsync),
    .fifo_rd_clk (),
    .fifo_rd_en (),
    .fifo_rd_valid (),
    .fifo_rd_dout (),
    .fifo_rd_underflow ());

  system_stub i_system_stub (
    .sys_rst (sys_rst),
    .sys_clk_p (sys_clk_p),
    .sys_clk_n (sys_clk_n),
    .ddr3_a13 (ddr3_a13),
    .ddr3_we_n (ddr3_we_n),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_odt (ddr3_odt),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs (ddr3_dqs),
    .ddr3_dq (ddr3_dq),
    .ddr3_dm (ddr3_dm),
    .ddr3_rst (ddr3_rst),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_clk_n (ddr3_clk_n),
    .ddr3_clk (ddr3_clk),
    .ddr3_cke (ddr3_cke),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ba (ddr3_ba),
    .ddr3_addr (ddr3_addr),
    .uart_tx (uart_tx),
    .uart_rx (uart_rx),
    .phy_rstn (phy_rstn),
    .phy_mdc (phy_mdc),
    .phy_mdio (phy_mdio),
    .phy_crs (phy_crs),
    .phy_col (phy_col),
    .phy_tx_clk (phy_tx_clk),
    .phy_tx_en (phy_tx_en),
    .phy_tx_d (phy_tx_d),
    .phy_rx_clk (phy_rx_clk),
    .phy_rx_dv (phy_rx_dv),
    .phy_rx_d (phy_rx_d),
    .phy_rx_er (phy_rx_er),
    .iic_scl (iic_scl),
    .iic_sda (iic_sda),
    .lcd (lcd),
    .sw (sw),
    .led (led),
    .axi_gpio_fmc_i0 (axi_gpio_fmc_i0),
    .axi_gpio_fmc_o0 (axi_gpio_fmc_o0),
    .axi_gpio_fmc_t0 (axi_gpio_fmc_t0),
    .axi_gpio_fmc_i1 (axi_gpio_fmc_i1),
    .axi_gpio_fmc_o1 (axi_gpio_fmc_o1),
    .axi_gpio_fmc_t1 (axi_gpio_fmc_t1),
    .axi_spi_fmc_sel (axi_spi_fmc_sel),
    .axi_spi_fmc_csn_i (axi_spi_fmc_csn_i),
    .axi_spi_fmc_csn_o (axi_spi_fmc_csn_o),
    .axi_spi_fmc_csn_t (axi_spi_fmc_csn_t),
    .axi_spi_fmc_clk_i (axi_spi_fmc_clk_i),
    .axi_spi_fmc_clk_o (axi_spi_fmc_clk_o),
    .axi_spi_fmc_clk_t (axi_spi_fmc_clk_t),
    .axi_spi_fmc_mosi_i (axi_spi_fmc_mosi_i),
    .axi_spi_fmc_mosi_o (axi_spi_fmc_mosi_o),
    .axi_spi_fmc_mosi_t (axi_spi_fmc_mosi_t),
    .axi_spi_fmc_miso_i (axi_spi_fmc_miso_i),
    .axi_spi_fmc_miso_o (axi_spi_fmc_miso_o),
    .axi_spi_fmc_miso_t (axi_spi_fmc_miso_t),
    .axi_dma_tx_axil_aclk (axi_dma_tx_axil_aclk),
    .axi_dma_tx_axil_aresetn (axi_dma_tx_axil_aresetn),
    .axi_dma_tx_axil_awvalid (axi_dma_tx_axil_awvalid),
    .axi_dma_tx_axil_awaddr (axi_dma_tx_axil_awaddr),
    .axi_dma_tx_axil_awready (axi_dma_tx_axil_awready),
    .axi_dma_tx_axil_wvalid (axi_dma_tx_axil_wvalid),
    .axi_dma_tx_axil_wdata (axi_dma_tx_axil_wdata),
    .axi_dma_tx_axil_wstrb (axi_dma_tx_axil_wstrb),
    .axi_dma_tx_axil_wready (axi_dma_tx_axil_wready),
    .axi_dma_tx_axil_bvalid (axi_dma_tx_axil_bvalid),
    .axi_dma_tx_axil_bresp (axi_dma_tx_axil_bresp),
    .axi_dma_tx_axil_bready (axi_dma_tx_axil_bready),
    .axi_dma_tx_axil_arvalid (axi_dma_tx_axil_arvalid),
    .axi_dma_tx_axil_araddr (axi_dma_tx_axil_araddr),
    .axi_dma_tx_axil_arready (axi_dma_tx_axil_arready),
    .axi_dma_tx_axil_rvalid (axi_dma_tx_axil_rvalid),
    .axi_dma_tx_axil_rdata (axi_dma_tx_axil_rdata),
    .axi_dma_tx_axil_rresp (axi_dma_tx_axil_rresp),
    .axi_dma_tx_axil_rready (axi_dma_tx_axil_rready),
    .axi_dma_tx_axim_s_aclk (axi_dma_tx_axim_s_aclk),
    .axi_dma_tx_axim_s_aresetn (axi_dma_tx_axim_s_aresetn),
    .axi_dma_tx_axim_s_araddr (axi_dma_tx_axim_s_araddr),
    .axi_dma_tx_axim_s_arlen (axi_dma_tx_axim_s_arlen),
    .axi_dma_tx_axim_s_arsize (axi_dma_tx_axim_s_arsize),
    .axi_dma_tx_axim_s_arburst (axi_dma_tx_axim_s_arburst),
    .axi_dma_tx_axim_s_arprot (axi_dma_tx_axim_s_arprot),
    .axi_dma_tx_axim_s_arcache (axi_dma_tx_axim_s_arcache),
    .axi_dma_tx_axim_s_arready (axi_dma_tx_axim_s_arready),
    .axi_dma_tx_axim_s_arvalid (axi_dma_tx_axim_s_arvalid),
    .axi_dma_tx_axim_s_rresp (axi_dma_tx_axim_s_rresp),
    .axi_dma_tx_axim_s_rdata (axi_dma_tx_axim_s_rdata),
    .axi_dma_tx_axim_s_rready (axi_dma_tx_axim_s_rready),
    .axi_dma_tx_axim_s_rvalid (axi_dma_tx_axim_s_rvalid),
    .axi_dma_tx_axim_irq (axi_dma_tx_axim_irq),
    .axi_dma_rx_axil_aclk (axi_dma_rx_axil_aclk),
    .axi_dma_rx_axil_aresetn (axi_dma_rx_axil_aresetn),
    .axi_dma_rx_axil_awvalid (axi_dma_rx_axil_awvalid),
    .axi_dma_rx_axil_awaddr (axi_dma_rx_axil_awaddr),
    .axi_dma_rx_axil_awready (axi_dma_rx_axil_awready),
    .axi_dma_rx_axil_wvalid (axi_dma_rx_axil_wvalid),
    .axi_dma_rx_axil_wdata (axi_dma_rx_axil_wdata),
    .axi_dma_rx_axil_wstrb (axi_dma_rx_axil_wstrb),
    .axi_dma_rx_axil_wready (axi_dma_rx_axil_wready),
    .axi_dma_rx_axil_bvalid (axi_dma_rx_axil_bvalid),
    .axi_dma_rx_axil_bresp (axi_dma_rx_axil_bresp),
    .axi_dma_rx_axil_bready (axi_dma_rx_axil_bready),
    .axi_dma_rx_axil_arvalid (axi_dma_rx_axil_arvalid),
    .axi_dma_rx_axil_araddr (axi_dma_rx_axil_araddr),
    .axi_dma_rx_axil_arready (axi_dma_rx_axil_arready),
    .axi_dma_rx_axil_rvalid (axi_dma_rx_axil_rvalid),
    .axi_dma_rx_axil_rdata (axi_dma_rx_axil_rdata),
    .axi_dma_rx_axil_rresp (axi_dma_rx_axil_rresp),
    .axi_dma_rx_axil_rready (axi_dma_rx_axil_rready),
    .axi_dma_rx_axim_d_aclk (axi_dma_rx_axim_d_aclk),
    .axi_dma_rx_axim_d_aresetn (axi_dma_rx_axim_d_aresetn),
    .axi_dma_rx_axim_d_awaddr (axi_dma_rx_axim_d_awaddr),
    .axi_dma_rx_axim_d_awlen (axi_dma_rx_axim_d_awlen),
    .axi_dma_rx_axim_d_awsize (axi_dma_rx_axim_d_awsize),
    .axi_dma_rx_axim_d_awburst (axi_dma_rx_axim_d_awburst),
    .axi_dma_rx_axim_d_awprot (axi_dma_rx_axim_d_awprot),
    .axi_dma_rx_axim_d_awcache (axi_dma_rx_axim_d_awcache),
    .axi_dma_rx_axim_d_awvalid (axi_dma_rx_axim_d_awvalid),
    .axi_dma_rx_axim_d_awready (axi_dma_rx_axim_d_awready),
    .axi_dma_rx_axim_d_wdata (axi_dma_rx_axim_d_wdata),
    .axi_dma_rx_axim_d_wstrb (axi_dma_rx_axim_d_wstrb),
    .axi_dma_rx_axim_d_wready (axi_dma_rx_axim_d_wready),
    .axi_dma_rx_axim_d_wvalid (axi_dma_rx_axim_d_wvalid),
    .axi_dma_rx_axim_d_wlast (axi_dma_rx_axim_d_wlast),
    .axi_dma_rx_axim_d_bready (axi_dma_rx_axim_d_bready),
    .axi_dma_rx_axim_d_bresp (axi_dma_rx_axim_d_bresp),
    .axi_dma_rx_axim_d_bvalid (axi_dma_rx_axim_d_bvalid),
    .axi_dma_rx_axim_irq (axi_dma_rx_axim_irq),
    .axi_dev_tx_axil_aclk (axi_dev_tx_axil_aclk),
    .axi_dev_tx_axil_aresetn (axi_dev_tx_axil_aresetn),
    .axi_dev_tx_axil_awvalid (axi_dev_tx_axil_awvalid),
    .axi_dev_tx_axil_awaddr (axi_dev_tx_axil_awaddr),
    .axi_dev_tx_axil_awready (axi_dev_tx_axil_awready),
    .axi_dev_tx_axil_wvalid (axi_dev_tx_axil_wvalid),
    .axi_dev_tx_axil_wdata (axi_dev_tx_axil_wdata),
    .axi_dev_tx_axil_wstrb (axi_dev_tx_axil_wstrb),
    .axi_dev_tx_axil_wready (axi_dev_tx_axil_wready),
    .axi_dev_tx_axil_bvalid (axi_dev_tx_axil_bvalid),
    .axi_dev_tx_axil_bresp (axi_dev_tx_axil_bresp),
    .axi_dev_tx_axil_bready (axi_dev_tx_axil_bready),
    .axi_dev_tx_axil_arvalid (axi_dev_tx_axil_arvalid),
    .axi_dev_tx_axil_araddr (axi_dev_tx_axil_araddr),
    .axi_dev_tx_axil_arready (axi_dev_tx_axil_arready),
    .axi_dev_tx_axil_rvalid (axi_dev_tx_axil_rvalid),
    .axi_dev_tx_axil_rdata (axi_dev_tx_axil_rdata),
    .axi_dev_tx_axil_rresp (axi_dev_tx_axil_rresp),
    .axi_dev_tx_axil_rready (axi_dev_tx_axil_rready),
    .axi_dev_rx_axil_aclk (axi_dev_rx_axil_aclk),
    .axi_dev_rx_axil_aresetn (axi_dev_rx_axil_aresetn),
    .axi_dev_rx_axil_awvalid (axi_dev_rx_axil_awvalid),
    .axi_dev_rx_axil_awaddr (axi_dev_rx_axil_awaddr),
    .axi_dev_rx_axil_awready (axi_dev_rx_axil_awready),
    .axi_dev_rx_axil_wvalid (axi_dev_rx_axil_wvalid),
    .axi_dev_rx_axil_wdata (axi_dev_rx_axil_wdata),
    .axi_dev_rx_axil_wstrb (axi_dev_rx_axil_wstrb),
    .axi_dev_rx_axil_wready (axi_dev_rx_axil_wready),
    .axi_dev_rx_axil_bvalid (axi_dev_rx_axil_bvalid),
    .axi_dev_rx_axil_bresp (axi_dev_rx_axil_bresp),
    .axi_dev_rx_axil_bready (axi_dev_rx_axil_bready),
    .axi_dev_rx_axil_arvalid (axi_dev_rx_axil_arvalid),
    .axi_dev_rx_axil_araddr (axi_dev_rx_axil_araddr),
    .axi_dev_rx_axil_arready (axi_dev_rx_axil_arready),
    .axi_dev_rx_axil_rvalid (axi_dev_rx_axil_rvalid),
    .axi_dev_rx_axil_rdata (axi_dev_rx_axil_rdata),
    .axi_dev_rx_axil_rresp (axi_dev_rx_axil_rresp),
    .axi_dev_rx_axil_rready (axi_dev_rx_axil_rready),
    .sys_200m_clk (sys_200m_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
