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
  uart0_rx,
  uart0_tx,

  // board gpio

  led,
  push_buttons,
  dip_switches,

  // hdmi

  hdmi_out_clk,
  hdmi_data,
  hdmi_scl,
  hdmi_sda,
  hdmi_rstn,

  // lane interface

  ref_clk,
  rx_data,
  rx_sync,
  rx_sysref,

  // spi

  spi_csn,
  spi_clk,
  spi_sdio);

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
  inout   [ 39:0]   ddr3_dq;
  inout   [  4:0]   ddr3_dqs_p;
  inout   [  4:0]   ddr3_dqs_n;
  output            ddr3_odt;
  output  [  4:0]   ddr3_dm;
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
  input             uart0_rx;
  output            uart0_tx;

  // board gpio

  output  [  3:0]   led;
  input   [  3:0]   push_buttons;
  input   [  3:0]   dip_switches;

  // hdmi

  output            hdmi_out_clk;
  output  [ 15:0]   hdmi_data;
  inout             hdmi_scl;
  inout             hdmi_sda;
  output            hdmi_rstn;

  // lane interface

  input             ref_clk;
  input   [  3:0]   rx_data;
  output            rx_sync;
  output            rx_sysref;

  // spi

  output            spi_csn;
  output            spi_clk;
  inout             spi_sdio;

  // internal registers

  reg               rx_sysref_m1 = 'd0;
  reg               rx_sysref_m2 = 'd0;
  reg               rx_sysref_m3 = 'd0;
  reg               rx_sysref = 'd0;
  reg               dma0_wr = 'd0;
  reg     [ 63:0]   dma0_wdata = 'd0;
  reg               dma1_wr = 'd0;
  reg     [ 63:0]   dma1_wdata = 'd0;

  // internal clocks and resets

  wire              sys_resetn;
  wire              rx_clk;
  wire              adc0_clk;
  wire              adc1_clk;

  // internal signals

  wire              spi_mosi;
  wire              spi_miso;
  wire              hdmi_scl_oe;
  wire              hdmi_sda_oe;
  wire              adc0_enable_a_s;
  wire    [ 31:0]   adc0_data_a_s;
  wire              adc0_enable_b_s;
  wire    [ 31:0]   adc0_data_b_s;
  wire              adc0_dovf_s;
  wire              adc1_enable_a_s;
  wire    [ 31:0]   adc1_data_a_s;
  wire              adc1_enable_b_s;
  wire    [ 31:0]   adc1_data_b_s;
  wire              adc1_dovf_s;
  wire    [  3:0]   rx_ip_sof_s;
  wire    [127:0]   rx_ip_data_s;
  wire    [127:0]   rx_data_s;
  wire              rx_sw_rstn_s;
  wire              rx_sysref_s;
  wire              rx_err_s;
  wire              rx_ready_s;
  wire    [  3:0]   rx_rst_state_s;
  wire              rx_lane_aligned_s;
  wire    [  3:0]   rx_analog_reset_s;
  wire    [  3:0]   rx_digital_reset_s;
  wire    [  3:0]   rx_cdr_locked_s;
  wire    [  3:0]   rx_cal_busy_s;
  wire              rx_pll_locked_s;
  wire    [ 15:0]   rx_xcvr_status_s;

  // instantiations

  always @(posedge rx_clk) begin
    rx_sysref_m1 <= rx_sysref_s;
    rx_sysref_m2 <= rx_sysref_m1;
    rx_sysref_m3 <= rx_sysref_m2;
    rx_sysref <= rx_sysref_m2 & ~rx_sysref_m3;
  end

  always @(posedge rx_clk) begin
    dma0_wr <= adc0_enable_a_s & adc0_enable_b_s;
    dma0_wdata <= { adc0_data_b_s[31:16],
                    adc0_data_a_s[31:16],
                    adc0_data_b_s[15: 0],
                    adc0_data_a_s[15: 0]};
    dma1_wr <= adc1_enable_a_s & adc1_enable_b_s;
    dma1_wdata <= { adc1_data_b_s[31:16],
                    adc1_data_a_s[31:16],
                    adc1_data_b_s[15: 0],
                    adc1_data_a_s[15: 0]};
  end

  sld_signaltap #(
    .sld_advanced_trigger_entity ("basic,1,"),
    .sld_data_bits (130),
    .sld_data_bit_cntr_bits (8),
    .sld_enable_advanced_trigger (0),
    .sld_mem_address_bits (10),
    .sld_node_crc_bits (32),
    .sld_node_crc_hiword (10311),
    .sld_node_crc_loword (14297),
    .sld_node_info (1076736),
    .sld_ram_block_type ("AUTO"),
    .sld_sample_depth (1024),
    .sld_storage_qualifier_gap_record (0),
    .sld_storage_qualifier_mode ("OFF"),
    .sld_trigger_bits (2),
    .sld_trigger_in_enabled (0),
    .sld_trigger_level (1),
    .sld_trigger_level_pipeline (1))
  i_signaltap (
    .acq_clk (rx_clk),
    .acq_data_in ({ rx_sysref,
                    rx_sync,
                    adc1_data_b_s,
                    adc1_data_a_s,
                    adc0_data_b_s,
                    adc0_data_a_s}),
    .acq_trigger_in ({rx_sysref, rx_sync}));

  genvar n;
  generate
  for (n = 0; n < 4; n = n + 1) begin: g_align_1
  ad_jesd_align i_jesd_align (
    .rx_clk (rx_clk),
    .rx_sof (rx_ip_sof_s),
    .rx_ip_data (rx_ip_data_s[n*32+31:n*32]),
    .rx_data (rx_data_s[n*32+31:n*32]));
  end
  endgenerate

  assign rx_xcvr_status_s[15:15] = 1'd0;
  assign rx_xcvr_status_s[14:14] = rx_sync;
  assign rx_xcvr_status_s[13:13] = rx_ready_s;
  assign rx_xcvr_status_s[12:12] = rx_pll_locked_s;
  assign rx_xcvr_status_s[11: 8] = rx_rst_state_s;
  assign rx_xcvr_status_s[ 7: 4] = rx_cdr_locked_s;
  assign rx_xcvr_status_s[ 3: 0] = rx_cal_busy_s;

  ad_xcvr_rx_rst #(.NUM_OF_LANES (4)) i_xcvr_rx_rst (
    .rx_clk (rx_clk),
    .rx_rstn (sys_resetn),
    .rx_sw_rstn (rx_sw_rstn_s),
    .rx_pll_locked (rx_pll_locked_s),
    .rx_cal_busy (rx_cal_busy_s),
    .rx_cdr_locked (rx_cdr_locked_s),
    .rx_analog_reset (rx_analog_reset_s),
    .rx_digital_reset (rx_digital_reset_s),
    .rx_ready (rx_ready_s),
    .rx_rst_state (rx_rst_state_s));

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  assign hdmi_rstn = 1'b1;
  assign hdmi_scl = (hdmi_scl_oe == 1'b1) ? 1'b0 : 1'bz;
  assign hdmi_sda = (hdmi_sda_oe == 1'b1) ? 1'b0 : 1'bz;

  system_bd i_system_bd (
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
    .clk_clk (sys_clk),
    .reset_reset_n (sys_resetn),
    .axi_ad9250_0_xcvr_clk_clk (rx_clk),
    .axi_ad9250_0_xcvr_data_data (rx_data_s[63:0]),
    .axi_ad9250_0_adc_clock_clk (adc0_clk),
    .axi_ad9250_0_adc_dma_if_adc_valid_a (),
    .axi_ad9250_0_adc_dma_if_adc_enable_a (adc0_enable_a_s),
    .axi_ad9250_0_adc_dma_if_adc_data_a (adc0_data_a_s),
    .axi_ad9250_0_adc_dma_if_adc_valid_b (),
    .axi_ad9250_0_adc_dma_if_adc_enable_b (adc0_enable_b_s),
    .axi_ad9250_0_adc_dma_if_adc_data_b (adc0_data_b_s),
    .axi_ad9250_0_adc_dma_if_adc_dovf (adc0_dovf_s),
    .axi_ad9250_0_adc_dma_if_adc_dunf (1'b0),
    .axi_dmac_0_fifo_wr_clock_clk (adc0_clk),
    .axi_dmac_0_fifo_wr_if_ovf (adc0_dovf_s),
    .axi_dmac_0_fifo_wr_if_wren (dma0_wr),
    .axi_dmac_0_fifo_wr_if_data (dma0_wdata),
    .axi_dmac_0_fifo_wr_if_sync (1'b1),
    .axi_ad9250_1_xcvr_clk_clk (rx_clk),
    .axi_ad9250_1_xcvr_data_data (rx_data_s[127:64]),
    .axi_ad9250_1_adc_clock_clk (adc1_clk),
    .axi_ad9250_1_adc_dma_if_adc_valid_a (),
    .axi_ad9250_1_adc_dma_if_adc_enable_a (adc1_enable_a_s),
    .axi_ad9250_1_adc_dma_if_adc_data_a (adc1_data_a_s),
    .axi_ad9250_1_adc_dma_if_adc_valid_b (),
    .axi_ad9250_1_adc_dma_if_adc_enable_b (adc1_enable_b_s),
    .axi_ad9250_1_adc_dma_if_adc_data_b (adc1_data_b_s),
    .axi_ad9250_1_adc_dma_if_adc_dovf (adc1_dovf_s),
    .axi_ad9250_1_adc_dma_if_adc_dunf (1'b0),
    .axi_dmac_1_fifo_wr_clock_clk (adc1_clk),
    .axi_dmac_1_fifo_wr_if_ovf (adc1_dovf_s),
    .axi_dmac_1_fifo_wr_if_wren (dma1_wr),
    .axi_dmac_1_fifo_wr_if_data (dma1_wdata),
    .axi_dmac_1_fifo_wr_if_sync (1'b1),
    .sys_jesd204b_s1_ref_clk_in_clk_clk (ref_clk),
    .sys_jesd204b_s1_rx_clk_out_clk_clk (rx_clk),
    .sys_jesd204b_s1_jesd204_rx_link_data (rx_ip_data_s),
    .sys_jesd204b_s1_jesd204_rx_link_valid (),
    .sys_jesd204b_s1_jesd204_rx_link_ready (1'b1),
    .sys_jesd204b_s1_alldev_lane_aligned_export (rx_lane_aligned_s),
    .sys_jesd204b_s1_sysref_export (rx_sysref),
    .sys_jesd204b_s1_jesd204_rx_frame_error_export (rx_err_s),
    .sys_jesd204b_s1_dev_lane_aligned_export (rx_lane_aligned_s),
    .sys_jesd204b_s1_dev_sync_n_export (rx_sync),
    .sys_jesd204b_s1_sof_export (rx_ip_sof_s),
    .sys_jesd204b_s1_rx_serial_data_rx_serial_data (rx_data),
    .sys_jesd204b_s1_rx_analogreset_rx_analogreset (rx_analog_reset_s),
    .sys_jesd204b_s1_rx_digitalreset_rx_digitalreset (rx_digital_reset_s),
    .sys_jesd204b_s1_rx_islockedtodata_export (rx_cdr_locked_s),
    .sys_jesd204b_s1_rx_cal_busy_export (rx_cal_busy_s),
    .sys_hps_spim0_txd (spi_mosi),
    .sys_hps_spim0_rxd (spi_miso),
    .sys_hps_spim0_ss_in_n (1'b1),
    .sys_hps_spim0_ssi_oe_n (spi_csn),
    .sys_hps_spim0_ss_0_n (),
    .sys_hps_spim0_ss_1_n (),
    .sys_hps_spim0_ss_2_n (),
    .sys_hps_spim0_ss_3_n (),
    .sys_jesd204b_s1_pll_locked_export (rx_pll_locked_s),
    .sys_hps_spim0_sclk_out_clk (spi_clk),
    .sys_hps_io_hps_io_emac1_inst_TX_CLK (eth1_tx_clk),
    .sys_hps_io_hps_io_emac1_inst_TXD0 (eth1_txd0),
    .sys_hps_io_hps_io_emac1_inst_TXD1 (eth1_txd1),
    .sys_hps_io_hps_io_emac1_inst_TX_CTL (eth1_tx_ctl),
    .sys_hps_io_hps_io_emac1_inst_RXD0 (eth1_rxd0),
    .sys_hps_io_hps_io_emac1_inst_RXD1 (eth1_rxd1),
    .sys_hps_io_hps_io_emac1_inst_TXD2 (eth1_txd2),
    .sys_hps_io_hps_io_emac1_inst_TXD3 (eth1_txd3),
    .sys_hps_io_hps_io_emac1_inst_MDIO (eth1_mdio),
    .sys_hps_io_hps_io_emac1_inst_MDC (eth1_mdc),
    .sys_hps_io_hps_io_emac1_inst_RX_CTL (eth1_rx_ctl),
    .sys_hps_io_hps_io_emac1_inst_RX_CLK (eth1_rx_clk),
    .sys_hps_io_hps_io_emac1_inst_RXD2 (eth1_rxd2),
    .sys_hps_io_hps_io_emac1_inst_RXD3 (eth1_rxd3),
    .sys_hps_io_hps_io_qspi_inst_IO0 (qspi_io0),
    .sys_hps_io_hps_io_qspi_inst_IO1 (qspi_io1),
    .sys_hps_io_hps_io_qspi_inst_IO2 (qspi_io2),
    .sys_hps_io_hps_io_qspi_inst_IO3 (qspi_io3),
    .sys_hps_io_hps_io_qspi_inst_SS0 (qspi_ss0),
    .sys_hps_io_hps_io_qspi_inst_CLK (qspi_clk),
    .sys_hps_io_hps_io_sdio_inst_CMD (sdio_cmd),
    .sys_hps_io_hps_io_sdio_inst_D0 (sdio_d0),
    .sys_hps_io_hps_io_sdio_inst_D1 (sdio_d1),
    .sys_hps_io_hps_io_sdio_inst_CLK (sdio_clk),
    .sys_hps_io_hps_io_sdio_inst_D2 (sdio_d2),
    .sys_hps_io_hps_io_sdio_inst_D3 (sdio_d3),
    .sys_hps_io_hps_io_usb1_inst_D0 (usb1_d0),
    .sys_hps_io_hps_io_usb1_inst_D1 (usb1_d1),
    .sys_hps_io_hps_io_usb1_inst_D2 (usb1_d2),
    .sys_hps_io_hps_io_usb1_inst_D3 (usb1_d3),
    .sys_hps_io_hps_io_usb1_inst_D4 (usb1_d4),
    .sys_hps_io_hps_io_usb1_inst_D5 (usb1_d5),
    .sys_hps_io_hps_io_usb1_inst_D6 (usb1_d6),
    .sys_hps_io_hps_io_usb1_inst_D7 (usb1_d7),
    .sys_hps_io_hps_io_usb1_inst_CLK (usb1_clk),
    .sys_hps_io_hps_io_usb1_inst_STP (usb1_stp),
    .sys_hps_io_hps_io_usb1_inst_DIR (usb1_dir),
    .sys_hps_io_hps_io_usb1_inst_NXT (usb1_nxt),
    .sys_hps_io_hps_io_uart0_inst_RX (uart0_rx),
    .sys_hps_io_hps_io_uart0_inst_TX (uart0_tx),
    .sys_hps_h2f_reset_reset_n (sys_resetn),
    .sys_gpio_external_connection_in_port ({rx_xcvr_status_s, 4'd0, push_buttons, 4'd0, dip_switches}),
    .sys_gpio_external_connection_out_port ({14'd0, rx_sw_rstn_s, rx_sysref_s, 12'd0, led}),
    .axi_hdmi_tx_0_hdmi_if_h_clk (hdmi_out_clk),
    .axi_hdmi_tx_0_hdmi_if_h16_hsync (),
    .axi_hdmi_tx_0_hdmi_if_h16_vsync (),
    .axi_hdmi_tx_0_hdmi_if_h16_data_e (),
    .axi_hdmi_tx_0_hdmi_if_h16_data (),
    .axi_hdmi_tx_0_hdmi_if_h16_es_data (hdmi_data),
    .axi_hdmi_tx_0_hdmi_if_h24_hsync (),
    .axi_hdmi_tx_0_hdmi_if_h24_vsync (),
    .axi_hdmi_tx_0_hdmi_if_h24_data_e (),
    .axi_hdmi_tx_0_hdmi_if_h24_data (),
    .axi_hdmi_tx_0_hdmi_if_h36_hsync (),
    .axi_hdmi_tx_0_hdmi_if_h36_vsync (),
    .axi_hdmi_tx_0_hdmi_if_h36_data_e (),
    .axi_hdmi_tx_0_hdmi_if_h36_data (),
		.sys_hps_i2c0_scl_in_clk (hdmi_scl),
		.sys_hps_i2c0_clk_clk (hdmi_scl_oe),
		.sys_hps_i2c0_out_data (hdmi_sda_oe),
		.sys_hps_i2c0_sda (hdmi_sda));

endmodule

// ***************************************************************************
// ***************************************************************************
