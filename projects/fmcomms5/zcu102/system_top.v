// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  inout       [20:0]      gpio_bd,

  input                   rx_clk_in_0_p,
  input                   rx_clk_in_0_n,
  input                   rx_frame_in_0_p,
  input                   rx_frame_in_0_n,
  input       [ 5:0]      rx_data_in_0_p,
  input       [ 5:0]      rx_data_in_0_n,
  output                  tx_clk_out_0_p,
  output                  tx_clk_out_0_n,
  output                  tx_frame_out_0_p,
  output                  tx_frame_out_0_n,
  output      [ 5:0]      tx_data_out_0_p,
  output      [ 5:0]      tx_data_out_0_n,
  inout       [ 7:0]      gpio_status_0,
  inout       [ 3:0]      gpio_ctl_0,
  inout                   gpio_en_agc_0,
  output  reg             mcs_sync,
  inout                   gpio_resetb_0,
  output                  enable_0,
  output                  txnrx_0,
  inout                   gpio_debug_1_0,
  inout                   gpio_debug_2_0,
  inout                   gpio_calsw_1_0,
  inout                   gpio_calsw_2_0,
  inout                   gpio_ad5355_rfen,
  inout                   gpio_ad5355_lock,

  input                   rx_clk_in_1_p,
  input                   rx_clk_in_1_n,
  input                   rx_frame_in_1_p,
  input                   rx_frame_in_1_n,
  input       [ 5:0]      rx_data_in_1_p,
  input       [ 5:0]      rx_data_in_1_n,
  output                  tx_clk_out_1_p,
  output                  tx_clk_out_1_n,
  output                  tx_frame_out_1_p,
  output                  tx_frame_out_1_n,
  output      [ 5:0]      tx_data_out_1_p,
  output      [ 5:0]      tx_data_out_1_n,
  inout       [ 7:0]      gpio_status_1,
  inout       [ 3:0]      gpio_ctl_1,
  inout                   gpio_en_agc_1,
  inout                   gpio_resetb_1,
  output                  enable_1,
  output                  txnrx_1,
  inout                   gpio_debug_3_1,
  inout                   gpio_debug_4_1,
  inout                   gpio_calsw_3_1,
  inout                   gpio_calsw_4_1,

  output                  spi_ad9361_0,
  output                  spi_ad9361_1,
  output                  spi_ad5355,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  input                   ref_clk_p,
  input                   ref_clk_n);

  // internal registers

  reg         [ 2:0]      mcs_sync_m = 'd0;

  // internal signals

  wire                    sys_100m_resetn;
  wire                    ref_clk_s;
  wire                    ref_clk;
  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire                    gpio_sync;
  wire                    gpio_open_44_44;
  wire                    gpio_open_15_15;
  wire        [2:0]       spi0_csn;
  wire                    spi0_clk;
  wire                    spi0_mosi;
  wire                    spi0_miso;
  wire        [2:0]       spi1_csn;
  wire                    spi1_clk;
  wire                    spi1_mosi;
  wire                    spi1_miso;

  // multi-chip synchronization

  always @(posedge ref_clk or negedge sys_100m_resetn) begin
    if (sys_100m_resetn == 1'b0) begin
      mcs_sync_m <= 3'd0;
      mcs_sync <= 1'd0;
    end else begin
      mcs_sync_m <= {mcs_sync_m[1:0], gpio_sync};
      mcs_sync <= mcs_sync_m[2] & ~mcs_sync_m[1];
    end
  end

  // instantiations

  IBUFGDS i_ref_clk_ibuf (
    .I (ref_clk_p),
    .IB (ref_clk_n),
    .O (ref_clk_s));

  BUFR #(.BUFR_DIVIDE("BYPASS")) i_ref_clk_rbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (ref_clk_s),
    .O (ref_clk));

  ad_iobuf #(.DATA_WIDTH(44)) i_iobuf (
    .dio_t (gpio_t[59:16]),
    .dio_i (gpio_o[59:16]),
    .dio_o (gpio_i[59:16]),
    .dio_p ({ gpio_resetb_1,    // 59
              gpio_ad5355_lock, // 58
              gpio_ad5355_rfen, // 57
              gpio_calsw_4_1,   // 56
              gpio_calsw_3_1,   // 55
              gpio_calsw_2_0,   // 54
              gpio_calsw_1_0,   // 53
              gpio_txnrx_1,     // 52
              gpio_enable_1,    // 51
              gpio_en_agc_1,    // 50
              gpio_txnrx_0,     // 49
              gpio_enable_0,    // 48
              gpio_en_agc_0,    // 47
              gpio_resetb_0,    // 46
              gpio_open_45_45,  // 45
              gpio_open_44_44,  // 44
              gpio_debug_4_1,   // 43
              gpio_debug_3_1,   // 42
              gpio_debug_2_0,   // 41
              gpio_debug_1_0,   // 40
              gpio_ctl_1,       // 36
              gpio_ctl_0,       // 32
              gpio_status_1,    // 24
              gpio_status_0})); // 16

  assign gpio_i[94:69] = gpio_o[94:69];
  assign gpio_i[63:60] = gpio_o[63:60];

  ad_iobuf #(.DATA_WIDTH(21)) i_iobuf_bd (
    .dio_t ({gpio_t[68:64], gpio_t[15:0]}),
    .dio_i ({gpio_o[68:64], gpio_o[15:0]}),
    .dio_o ({gpio_i[68:64], gpio_i[15:0]}),
    .dio_p (gpio_bd));

  assign spi_ad9361_0 = spi0_csn[0];
  assign spi_ad9361_1 = spi0_csn[1];
  assign spi_ad5355   = spi0_csn[2];
  assign spi_clk = spi0_clk;
  assign spi_mosi = spi0_mosi;
  assign spi0_miso = spi_miso;
  assign spi1_miso = 1'b0;

  system_wrapper i_system_wrapper (
    .enable_0 (enable_0),
    .enable_1 (enable_1),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .ps_intr_00 (1'b0),
    .ps_intr_01 (1'b0),
    .ps_intr_02 (1'b0),
    .ps_intr_03 (1'b0),
    .ps_intr_04 (1'b0),
    .ps_intr_05 (1'b0),
    .ps_intr_06 (1'b0),
    .ps_intr_07 (1'b0),
    .ps_intr_08 (1'b0),
    .ps_intr_09 (1'b0),
    .ps_intr_10 (1'b0),
    .ps_intr_11 (1'b0),
    .ps_intr_14 (1'b0),
    .ps_intr_15 (1'b0),
    .rx_clk_in_0_n (rx_clk_in_0_n),
    .rx_clk_in_0_p (rx_clk_in_0_p),
    .rx_clk_in_1_n (rx_clk_in_1_n),
    .rx_clk_in_1_p (rx_clk_in_1_p),
    .rx_data_in_0_n (rx_data_in_0_n),
    .rx_data_in_0_p (rx_data_in_0_p),
    .rx_data_in_1_n (rx_data_in_1_n),
    .rx_data_in_1_p (rx_data_in_1_p),
    .rx_frame_in_0_n (rx_frame_in_0_n),
    .rx_frame_in_0_p (rx_frame_in_0_p),
    .rx_frame_in_1_n (rx_frame_in_1_n),
    .rx_frame_in_1_p (rx_frame_in_1_p),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi0_miso),
    .spi0_mosi (spi0_mosi),
    .spi0_sclk (spi0_clk),
    .spi1_csn (spi1_csn),
    .spi1_miso (spi1_miso),
    .spi1_mosi (spi1_mosi),
    .spi1_sclk (spi1_clk),
    .sys_100m_resetn (sys_100m_resetn),
    .tx_clk_out_0_n (tx_clk_out_0_n),
    .tx_clk_out_0_p (tx_clk_out_0_p),
    .tx_clk_out_1_n (tx_clk_out_1_n),
    .tx_clk_out_1_p (tx_clk_out_1_p),
    .tx_data_out_0_n (tx_data_out_0_n),
    .tx_data_out_0_p (tx_data_out_0_p),
    .tx_data_out_1_n (tx_data_out_1_n),
    .tx_data_out_1_p (tx_data_out_1_p),
    .tx_frame_out_0_n (tx_frame_out_0_n),
    .tx_frame_out_0_p (tx_frame_out_0_p),
    .tx_frame_out_1_n (tx_frame_out_1_n),
    .tx_frame_out_1_p (tx_frame_out_1_p),
    .txnrx_0 (txnrx_0),
    .txnrx_1 (txnrx_1),
    .up_enable_0 (gpio_enable_0),
    .up_enable_1 (gpio_enable_1),
    .up_txnrx_0 (gpio_txnrx_0),
    .up_txnrx_1 (gpio_txnrx_1));

endmodule

// ***************************************************************************
// ***************************************************************************
