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

`timescale 1ns/100ps

module system_top (

  // clock and resets

  sys_clk,

  // hps

  ddr3_a,
  ddr3_ba,
  ddr3_ck_p,
  ddr3_ck_n,
  ddr3_cke,
  ddr3_cs_n,
  ddr3_ras_n,
  ddr3_cas_n,
  ddr3_we_n,
  ddr3_reset_n,
  ddr3_dq,
  ddr3_dqs_p,
  ddr3_dqs_n,
  ddr3_odt,
  ddr3_dm,
  ddr3_oct_rzqin,
  eth1_tx_clk,
  eth1_tx_ctl,
  eth1_txd0,
  eth1_txd1,
  eth1_txd2,
  eth1_txd3,
  eth1_rx_clk,
  eth1_rx_ctl,
  eth1_rxd0,
  eth1_rxd1,
  eth1_rxd2,
  eth1_rxd3,
  eth1_mdc,
  eth1_mdio,
  qspi_ss0,
  qspi_clk,
  qspi_io0,
  qspi_io1,
  qspi_io2,
  qspi_io3,
  sdio_clk,
  sdio_cmd,
  sdio_d0,
  sdio_d1,
  sdio_d2,
  sdio_d3,
  usb1_clk,
  usb1_stp,
  usb1_dir,
  usb1_nxt,
  usb1_d0,
  usb1_d1,
  usb1_d2,
  usb1_d3,
  usb1_d4,
  usb1_d5,
  usb1_d6,
  usb1_d7,
  spim1_ss0,
  spim1_clk,
  spim1_mosi,
  spim1_miso,
  uart0_rx,
  uart0_tx,

  // board gpio

  led,
  push_buttons,
  dip_switches,

  // display

  vga_clk,
  vga_blank_n,
  vga_sync_n,
  vga_hs,
  vga_vs,
  vga_r,
  vga_g,
  vga_b,

  // data interface

  rx_clk_in,
  rx_frame_in,
  rx_data_in,
  tx_clk_out,
  tx_frame_out,
  tx_data_out,

  // gpio interface

  ad9361_resetb,
  ad9361_en_agc,
  ad9361_sync,
  ad9361_enable,
  ad9361_txnrx,

  // spi

  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso);

  // clock and resets

  input             sys_clk;

  // hps

  output  [ 14:0]   ddr3_a;
  output  [  2:0]   ddr3_ba;
  output            ddr3_ck_p;
  output            ddr3_ck_n;
  output            ddr3_cke;
  output            ddr3_cs_n;
  output            ddr3_ras_n;
  output            ddr3_cas_n;
  output            ddr3_we_n;
  output            ddr3_reset_n;
  inout   [ 31:0]   ddr3_dq;
  inout   [  3:0]   ddr3_dqs_p;
  inout   [  3:0]   ddr3_dqs_n;
  output            ddr3_odt;
  output  [  3:0]   ddr3_dm;
  input             ddr3_oct_rzqin;
  output            eth1_tx_clk;
  output            eth1_tx_ctl;
  output            eth1_txd0;
  output            eth1_txd1;
  output            eth1_txd2;
  output            eth1_txd3;
  input             eth1_rx_clk;
  input             eth1_rx_ctl;
  input             eth1_rxd0;
  input             eth1_rxd1;
  input             eth1_rxd2;
  input             eth1_rxd3;
  output            eth1_mdc;
  inout             eth1_mdio;
  output            qspi_ss0;
  output            qspi_clk;
  inout             qspi_io0;
  inout             qspi_io1;
  inout             qspi_io2;
  inout             qspi_io3;
  output            sdio_clk;
  inout             sdio_cmd;
  inout             sdio_d0;
  inout             sdio_d1;
  inout             sdio_d2;
  inout             sdio_d3;
  input             usb1_clk;
  output            usb1_stp;
  input             usb1_dir;
  input             usb1_nxt;
  inout             usb1_d0;
  inout             usb1_d1;
  inout             usb1_d2;
  inout             usb1_d3;
  inout             usb1_d4;
  inout             usb1_d5;
  inout             usb1_d6;
  inout             usb1_d7;
  output            spim1_ss0;
  output            spim1_clk;
  output            spim1_mosi;
  input             spim1_miso;
  input             uart0_rx;
  output            uart0_tx;

  // board gpio

  output  [  3:0]   led;
  input   [  3:0]   push_buttons;
  input   [  3:0]   dip_switches;

  // display

  output            vga_clk;
  output            vga_blank_n;
  output            vga_sync_n;
  output            vga_hs;
  output            vga_vs;
  output  [  7:0]   vga_r;
  output  [  7:0]   vga_g;
  output  [  7:0]   vga_b;

  // data interface

  input             rx_clk_in;
  input             rx_frame_in;
  input   [  5:0]   rx_data_in;
  output            tx_clk_out;
  output            tx_frame_out;
  output  [  5:0]   tx_data_out;

  // gpio interface

  output            ad9361_resetb;
  output            ad9361_en_agc;
  output            ad9361_sync;
  output            ad9361_enable;
  output            ad9361_txnrx;

  // spi interface

  output            spi_csn;
  output            spi_clk;
  output            spi_mosi;
  input             spi_miso;

  // internal clocks and resets

  wire    [ 31:0]   gpio_open;
  wire              sys_resetn;
  wire              clk;

  // internal signals

  wire              adc_enable_i0;
  wire              adc_enable_q0;
  wire              adc_enable_i1;
  wire              adc_enable_q1;
  wire              adc_valid_i0;
  wire              adc_valid_q0;
  wire              adc_valid_i1;
  wire              adc_valid_q1;
  wire              adc_dwr;
  wire              adc_dsync;
  wire    [ 15:0]   adc_chan_i0;
  wire    [ 15:0]   adc_chan_q0;
  wire    [ 15:0]   adc_chan_i1;
  wire    [ 15:0]   adc_chan_q1;
  wire    [ 63:0]   adc_ddata;
  wire              adc_dovf;
  wire              dac_enable_i0;
  wire              dac_enable_q0;
  wire              dac_enable_i1;
  wire              dac_enable_q1;
  wire              dac_valid_i0;
  wire              dac_valid_q0;
  wire              dac_valid_i1;
  wire              dac_valid_q1;
  wire    [ 15:0]   dac_data_i0;
  wire    [ 15:0]   dac_data_q0;
  wire    [ 15:0]   dac_data_i1;
  wire    [ 15:0]   dac_data_q1;
  wire    [ 63:0]   dac_ddata;
  wire              dac_dunf;
  wire              dac_rd_en;
  wire              dac_fifo_valid;  
  wire              vga_pixel_clock;
  wire              vid_v_sync;
  wire              vid_h_sync;
  wire    [7:0]     vid_r,vid_g,vid_b;

  // defaults
  
  assign vga_clk = vga_pixel_clock;
  assign vga_blank_n = 1'b1;
  assign vga_sync_n = 1'b0;
  assign vga_hs = vid_h_sync;
  assign vga_vs = vid_v_sync;
  assign {vga_b,vga_g,vga_r} =  {vid_b,vid_g,vid_r};

  // instantiations

  sld_signaltap #(
    .sld_advanced_trigger_entity ("basic,1,"),
    .sld_data_bits (64),
    .sld_data_bit_cntr_bits (7),
    .sld_enable_advanced_trigger (0),
    .sld_mem_address_bits (10),
    .sld_node_crc_bits (32),
    .sld_node_crc_hiword (13323),
    .sld_node_crc_loword (24084),
    .sld_node_info (1076736),
    .sld_ram_block_type ("AUTO"),
    .sld_sample_depth (1024),
    .sld_storage_qualifier_gap_record (0),
    .sld_storage_qualifier_mode ("OFF"),
    .sld_trigger_bits (1),
    .sld_trigger_in_enabled (0),
    .sld_trigger_level (1),
    .sld_trigger_level_pipeline (1))
  i_ila_adc (
    .acq_clk (clk),
    .acq_data_in (adc_ddata),
    .acq_trigger_in (adc_valid_i0));

  system_bd i_system_bd (
    .clk_clk (sys_clk),
    .reset_reset_n (sys_resetn),
    .sys_hps_memory_mem_a (ddr3_a),
    .sys_hps_memory_mem_ba (ddr3_ba),
    .sys_hps_memory_mem_ck (ddr3_ck_p),
    .sys_hps_memory_mem_ck_n (ddr3_ck_n),
    .sys_hps_memory_mem_cke (ddr3_cke),
    .sys_hps_memory_mem_cs_n (ddr3_cs_n),
    .sys_hps_memory_mem_ras_n (ddr3_ras_n),
    .sys_hps_memory_mem_cas_n (ddr3_cas_n),
    .sys_hps_memory_mem_we_n (ddr3_we_n),
    .sys_hps_memory_mem_reset_n (ddr3_reset_n),
    .sys_hps_memory_mem_dq (ddr3_dq),
    .sys_hps_memory_mem_dqs (ddr3_dqs_p),
    .sys_hps_memory_mem_dqs_n (ddr3_dqs_n),
    .sys_hps_memory_mem_odt (ddr3_odt),
    .sys_hps_memory_mem_dm (ddr3_dm),
    .sys_hps_memory_oct_rzqin (ddr3_oct_rzqin),
    .sys_hps_hps_io_hps_io_emac1_inst_TX_CLK (eth1_tx_clk),
    .sys_hps_hps_io_hps_io_emac1_inst_TXD0 (eth1_txd0),
    .sys_hps_hps_io_hps_io_emac1_inst_TXD1 (eth1_txd1),
    .sys_hps_hps_io_hps_io_emac1_inst_TXD2 (eth1_txd2),
    .sys_hps_hps_io_hps_io_emac1_inst_TXD3 (eth1_txd3),
    .sys_hps_hps_io_hps_io_emac1_inst_RXD0 (eth1_rxd0),
    .sys_hps_hps_io_hps_io_emac1_inst_MDIO (eth1_mdio),
    .sys_hps_hps_io_hps_io_emac1_inst_MDC (eth1_mdc),
    .sys_hps_hps_io_hps_io_emac1_inst_RX_CTL (eth1_rx_ctl),
    .sys_hps_hps_io_hps_io_emac1_inst_TX_CTL (eth1_tx_ctl),
    .sys_hps_hps_io_hps_io_emac1_inst_RX_CLK (eth1_rx_clk),
    .sys_hps_hps_io_hps_io_emac1_inst_RXD1 (eth1_rxd1),
    .sys_hps_hps_io_hps_io_emac1_inst_RXD2 (eth1_rxd2),
    .sys_hps_hps_io_hps_io_emac1_inst_RXD3 (eth1_rxd3),
    .sys_hps_hps_io_hps_io_qspi_inst_IO0 (qspi_io0),
    .sys_hps_hps_io_hps_io_qspi_inst_IO1 (qspi_io1),
    .sys_hps_hps_io_hps_io_qspi_inst_IO2 (qspi_io2),
    .sys_hps_hps_io_hps_io_qspi_inst_IO3 (qspi_io3),
    .sys_hps_hps_io_hps_io_qspi_inst_SS0 (qspi_ss0),
    .sys_hps_hps_io_hps_io_qspi_inst_CLK (qspi_clk),
    .sys_hps_hps_io_hps_io_sdio_inst_CMD (sdio_cmd),
    .sys_hps_hps_io_hps_io_sdio_inst_D0 (sdio_d0),
    .sys_hps_hps_io_hps_io_sdio_inst_D1 (sdio_d1),
    .sys_hps_hps_io_hps_io_sdio_inst_CLK (sdio_clk),
    .sys_hps_hps_io_hps_io_sdio_inst_D2 (sdio_d2),
    .sys_hps_hps_io_hps_io_sdio_inst_D3 (sdio_d3),
    .sys_hps_hps_io_hps_io_usb1_inst_D0 (usb1_d0),
    .sys_hps_hps_io_hps_io_usb1_inst_D1 (usb1_d1),
    .sys_hps_hps_io_hps_io_usb1_inst_D2 (usb1_d2),
    .sys_hps_hps_io_hps_io_usb1_inst_D3 (usb1_d3),
    .sys_hps_hps_io_hps_io_usb1_inst_D4 (usb1_d4),
    .sys_hps_hps_io_hps_io_usb1_inst_D5 (usb1_d5),
    .sys_hps_hps_io_hps_io_usb1_inst_D6 (usb1_d6),
    .sys_hps_hps_io_hps_io_usb1_inst_D7 (usb1_d7),
    .sys_hps_hps_io_hps_io_usb1_inst_CLK (usb1_clk),
    .sys_hps_hps_io_hps_io_usb1_inst_STP (usb1_stp),
    .sys_hps_hps_io_hps_io_usb1_inst_DIR (usb1_dir),
    .sys_hps_hps_io_hps_io_usb1_inst_NXT (usb1_nxt),
    .sys_hps_hps_io_hps_io_spim1_inst_CLK (spim1_clk),
    .sys_hps_hps_io_hps_io_spim1_inst_MOSI (spim1_mosi),
    .sys_hps_hps_io_hps_io_spim1_inst_MISO (spim1_miso),
    .sys_hps_hps_io_hps_io_spim1_inst_SS0 (spim1_ss0),
    .sys_hps_hps_io_hps_io_uart0_inst_RX (uart0_rx),
    .sys_hps_hps_io_hps_io_uart0_inst_TX (uart0_tx),
    .sys_gpio_external_connection_in_port ({16'd0, 4'd0, led, push_buttons, dip_switches}),
    .sys_gpio_external_connection_out_port ({gpio_open[31:16], gpio_open[15:12], led, gpio_open[7:0]}),
    .sys_hps_h2f_reset_reset_n (sys_resetn),
		.sys_hps_spim0_txd (),
		.sys_hps_spim0_rxd (),
		.sys_hps_spim0_ss_in_n (1'b1),
		.sys_hps_spim0_ssi_oe_n (),
		.sys_hps_spim0_ss_0_n (),
		.sys_hps_spim0_ss_1_n (),
		.sys_hps_spim0_ss_2_n (),
		.sys_hps_spim0_ss_3_n (),
		.sys_hps_spim0_sclk_out_clk (),
		.axi_ad9361_device_clock_clk (clk),
		.axi_ad9361_device_if_rx_clk_in_p (rx_clk_in),
		.axi_ad9361_device_if_rx_clk_in_n (1'b0),
		.axi_ad9361_device_if_rx_frame_in_p (rx_frame_in),
		.axi_ad9361_device_if_rx_frame_in_n (1'b0),
		.axi_ad9361_device_if_rx_data_in_p (rx_data_in),
		.axi_ad9361_device_if_rx_data_in_n (6'd0),
		.axi_ad9361_device_if_tx_clk_out_p (tx_clk_out),
		.axi_ad9361_device_if_tx_clk_out_n (),
		.axi_ad9361_device_if_tx_frame_out_p (tx_frame_out),
		.axi_ad9361_device_if_tx_frame_out_n (),
		.axi_ad9361_device_if_tx_data_out_p (tx_data_out),
		.axi_ad9361_device_if_tx_data_out_n (),
		.axi_ad9361_master_if_l_clk (clk),
		.axi_ad9361_master_if_dac_sync_in (1'b0),
		.axi_ad9361_master_if_dac_sync_out (),
		.axi_ad9361_dma_if_adc_enable_i0 (adc_enable_i0),
		.axi_ad9361_dma_if_adc_valid_i0 (adc_valid_i0),
		.axi_ad9361_dma_if_adc_data_i0 (adc_chan_i0),
		.axi_ad9361_dma_if_adc_enable_q0 (adc_enable_q0),
		.axi_ad9361_dma_if_adc_valid_q0 (adc_valid_q0),
		.axi_ad9361_dma_if_adc_data_q0 (adc_chan_q0),
		.axi_ad9361_dma_if_adc_enable_i1 (adc_enable_i1),
		.axi_ad9361_dma_if_adc_valid_i1 (adc_valid_i1),
		.axi_ad9361_dma_if_adc_data_i1 (adc_chan_i1),
		.axi_ad9361_dma_if_adc_enable_q1 (adc_enable_q1),
		.axi_ad9361_dma_if_adc_valid_q1 (adc_valid_q1),
		.axi_ad9361_dma_if_adc_data_q1 (adc_chan_q1),
		.axi_ad9361_dma_if_adc_dovf (adc_dovf),
		.axi_ad9361_dma_if_adc_dunf (),
		.axi_ad9361_dma_if_dac_enable_i0 (dac_enable_i0),
		.axi_ad9361_dma_if_dac_valid_i0 (dac_valid_i0),
		.axi_ad9361_dma_if_dac_data_i0 (dac_data_i0),
		.axi_ad9361_dma_if_dac_enable_q0 (dac_enable_q0),
		.axi_ad9361_dma_if_dac_valid_q0 (dac_valid_q0),
		.axi_ad9361_dma_if_dac_data_q0 (dac_data_q0),
		.axi_ad9361_dma_if_dac_enable_i1 (dac_enable_i1),
		.axi_ad9361_dma_if_dac_valid_i1 (dac_valid_i1),
		.axi_ad9361_dma_if_dac_data_i1 (dac_data_i1),
		.axi_ad9361_dma_if_dac_enable_q1 (dac_enable_q1),
		.axi_ad9361_dma_if_dac_valid_q1 (dac_valid_q1),
		.axi_ad9361_dma_if_dac_data_q1 (dac_data_q1),
		.axi_ad9361_dma_if_dac_dovf (),
		.axi_ad9361_dma_if_dac_dunf (dac_dunf),
		.axi_dmac_dac_if_fifo_rd_clk_clk (clk),
		.axi_dmac_dac_if_fifo_rd_en_dac_valid (dac_rd_en),
		.axi_dmac_dac_if_fifo_rd_valid_dma_valid (dac_fifo_valid),
		.axi_dmac_dac_if_fifo_rd_dout_dac_data (dac_ddata),
		.axi_dmac_dac_if_fifo_rd_underflow_dac_dunf (dac_dunf),
		.axi_dmac_dac_if_fifo_rd_xfer_req_dma_xfer_req (),
		.axi_dmac_adc_if_fifo_wr_clk_clk (clk),
		.axi_dmac_adc_if_fifo_wr_overflow_adc_dovf (adc_dovf),
		.axi_dmac_adc_if_fifo_wr_en_adc_valid (adc_dwr),
		.axi_dmac_adc_if_fifo_wr_din_adc_data (adc_ddata),
		.axi_dmac_adc_if_fifo_wr_sync_adc_sync (adc_dsync),
		.axi_dmac_adc_if_fifo_wr_xfer_req_dma_xfer_req (),
		.spi_ad9361_external_MISO (spi_miso),
		.spi_ad9361_external_MOSI (spi_mosi),
		.spi_ad9361_external_SCLK (spi_clk),
		.spi_ad9361_external_SS_n (spi_csn),
		.vga_pixel_clock_bridge_out_clk_clk (vga_pixel_clock),
		.vga_clock_video_output_clocked_video_vid_clk (vga_pixel_clock),
		.vga_clock_video_output_clocked_video_vid_data ({vid_r,vid_g,vid_b}),
		.vga_clock_video_output_clocked_video_underflow (),
		.vga_clock_video_output_clocked_video_vid_datavalid (),
		.vga_clock_video_output_clocked_video_vid_v_sync (vid_v_sync),
		.vga_clock_video_output_clocked_video_vid_h_sync (vid_h_sync),
		.vga_clock_video_output_clocked_video_vid_f (),
		.vga_clock_video_output_clocked_video_vid_h (),
		.vga_clock_video_output_clocked_video_vid_v (),
		.adc_pack_data_clock_clk (clk),
		.adc_pack_channels_data_chan_enable_0 (adc_enable_i0),
		.adc_pack_channels_data_chan_valid_0 (adc_valid_i0),
		.adc_pack_channels_data_chan_data_0 (adc_chan_i0),
		.adc_pack_channels_data_chan_enable_1 (adc_enable_q0),
		.adc_pack_channels_data_chan_valid_1 (adc_valid_q0),
		.adc_pack_channels_data_chan_data_1 (adc_chan_q0),
		.adc_pack_channels_data_chan_enable_2 (adc_enable_i1),
		.adc_pack_channels_data_chan_valid_2 (adc_valid_i1),
		.adc_pack_channels_data_chan_data_2 (adc_chan_i1),
		.adc_pack_channels_data_chan_enable_3 (adc_enable_q1),
		.adc_pack_channels_data_chan_valid_3 (adc_valid_q1),
		.adc_pack_channels_data_chan_data_3 (adc_chan_q1),
		.adc_pack_channels_data_dvalid (adc_dwr),
		.adc_pack_channels_data_dsync (adc_dsync),
		.adc_pack_channels_data_ddata (adc_ddata),
		.util_dac_unpack_data_clock_clk (clk),
		.util_dac_unpack_channels_data_dac_enable_00 (dac_enable_i0),
		.util_dac_unpack_channels_data_dac_valid_00 (dac_valid_i0),
		.util_dac_unpack_channels_data_dac_data_00 (dac_data_i0),
		.util_dac_unpack_channels_data_dac_enable_01 (dac_enable_q0),
		.util_dac_unpack_channels_data_dac_valid_01 (dac_valid_q0),
		.util_dac_unpack_channels_data_dac_data_01 (dac_data_q0),
		.util_dac_unpack_channels_data_dac_enable_02 (dac_enable_i1),
		.util_dac_unpack_channels_data_dac_valid_02 (dac_valid_i1),
		.util_dac_unpack_channels_data_dac_data_02 (dac_data_i1),
		.util_dac_unpack_channels_data_dac_enable_03 (dac_enable_q1),
		.util_dac_unpack_channels_data_dac_valid_03 (dac_valid_q1),
		.util_dac_unpack_channels_data_dac_data_03 (dac_data_q1),
		.util_dac_unpack_channels_data_fifo_valid (dac_fifo_valid),
		.util_dac_unpack_channels_data_dma_rd (dac_rd_en),
		.util_dac_unpack_channels_data_dma_data (dac_ddata),
    .gpio_external_connection_export ({ad9361_resetb, ad9361_en_agc, ad9361_sync, ad9361_enable, ad9361_txnrx})
	);

endmodule

// ***************************************************************************
// ***************************************************************************
