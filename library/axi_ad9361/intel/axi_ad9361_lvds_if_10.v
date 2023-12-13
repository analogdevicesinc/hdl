// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9361_lvds_if_10  #(

  parameter   RX_NODPA = 0
) (

  // physical interface (receive)

  input               rx_clk_in_p,
  input               rx_clk_in_n,
  input               rx_frame_in_p,
  input               rx_frame_in_n,
  input   [ 5:0]      rx_data_in_p,
  input   [ 5:0]      rx_data_in_n,

  // physical interface (transmit)

  output              tx_clk_out_p,
  output              tx_clk_out_n,
  output              tx_frame_out_p,
  output              tx_frame_out_n,
  output  [ 5:0]      tx_data_out_p,
  output  [ 5:0]      tx_data_out_n,

  // ensm control

  output              enable,
  output              txnrx,

  // clock (common to both receive and transmit)

  output              clk,

  // receive data path interface

  output  [ 3:0]      rx_frame,
  output  [ 5:0]      rx_data_0,
  output  [ 5:0]      rx_data_1,
  output  [ 5:0]      rx_data_2,
  output  [ 5:0]      rx_data_3,

  // transmit data path interface

  input   [ 3:0]      tx_frame,
  input   [ 5:0]      tx_data_0,
  input   [ 5:0]      tx_data_1,
  input   [ 5:0]      tx_data_2,
  input   [ 5:0]      tx_data_3,
  input               tx_enable,
  input               tx_txnrx,

  // locked (status)

  output              locked,

  // delay interface

  input               up_clk,
  input               up_rstn
);

  // internal registers

  reg                 pll_rst = 1'd1;
  reg                 locked_int = 'd0;

  // internal signals

  wire    [27:0]      rx_data_s;
  wire    [ 6:0]      rx_data_locked_s;
  wire    [ 6:0]      rx_delay_locked_s;
  wire    [27:0]      tx_data_s;
  wire                locked_s;
  wire                lvds_clk;
  wire                lvds_loaden;
  wire    [ 7:0]      lvds_phase;
  wire                rx_clk;

  // pll reset

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      pll_rst <= 1'b1;
    end else begin
      pll_rst <= 1'b0;
    end
  end

  assign locked = locked_int;

  always @(posedge clk) begin
    locked_int <= locked_s & (& rx_data_locked_s) &
      (& rx_delay_locked_s);
  end

  // receive

  assign rx_frame[3] = rx_data_s[24];
  assign rx_frame[2] = rx_data_s[25];
  assign rx_frame[1] = rx_data_s[26];
  assign rx_frame[0] = rx_data_s[27];

  assign rx_data_3[5] = rx_data_s[20];
  assign rx_data_3[4] = rx_data_s[16];
  assign rx_data_3[3] = rx_data_s[12];
  assign rx_data_3[2] = rx_data_s[ 8];
  assign rx_data_3[1] = rx_data_s[ 4];
  assign rx_data_3[0] = rx_data_s[ 0];
  assign rx_data_2[5] = rx_data_s[21];
  assign rx_data_2[4] = rx_data_s[17];
  assign rx_data_2[3] = rx_data_s[13];
  assign rx_data_2[2] = rx_data_s[ 9];
  assign rx_data_2[1] = rx_data_s[ 5];
  assign rx_data_2[0] = rx_data_s[ 1];
  assign rx_data_1[5] = rx_data_s[22];
  assign rx_data_1[4] = rx_data_s[18];
  assign rx_data_1[3] = rx_data_s[14];
  assign rx_data_1[2] = rx_data_s[10];
  assign rx_data_1[1] = rx_data_s[ 6];
  assign rx_data_1[0] = rx_data_s[ 2];
  assign rx_data_0[5] = rx_data_s[23];
  assign rx_data_0[4] = rx_data_s[19];
  assign rx_data_0[3] = rx_data_s[15];
  assign rx_data_0[2] = rx_data_s[11];
  assign rx_data_0[1] = rx_data_s[ 7];
  assign rx_data_0[0] = rx_data_s[ 3];

  // transmit

  assign tx_clk_out_n = 1'd0;
  assign tx_frame_out_n = 1'd0;
  assign tx_data_out_n = 6'd0;

  assign tx_data_s[24] = tx_frame[3];
  assign tx_data_s[25] = tx_frame[2];
  assign tx_data_s[26] = tx_frame[1];
  assign tx_data_s[27] = tx_frame[0];

  assign tx_data_s[20] = tx_data_3[5];
  assign tx_data_s[16] = tx_data_3[4];
  assign tx_data_s[12] = tx_data_3[3];
  assign tx_data_s[ 8] = tx_data_3[2];
  assign tx_data_s[ 4] = tx_data_3[1];
  assign tx_data_s[ 0] = tx_data_3[0];
  assign tx_data_s[21] = tx_data_2[5];
  assign tx_data_s[17] = tx_data_2[4];
  assign tx_data_s[13] = tx_data_2[3];
  assign tx_data_s[ 9] = tx_data_2[2];
  assign tx_data_s[ 5] = tx_data_2[1];
  assign tx_data_s[ 1] = tx_data_2[0];
  assign tx_data_s[22] = tx_data_1[5];
  assign tx_data_s[18] = tx_data_1[4];
  assign tx_data_s[14] = tx_data_1[3];
  assign tx_data_s[10] = tx_data_1[2];
  assign tx_data_s[ 6] = tx_data_1[1];
  assign tx_data_s[ 2] = tx_data_1[0];
  assign tx_data_s[23] = tx_data_0[5];
  assign tx_data_s[19] = tx_data_0[4];
  assign tx_data_s[15] = tx_data_0[3];
  assign tx_data_s[11] = tx_data_0[2];
  assign tx_data_s[ 7] = tx_data_0[1];
  assign tx_data_s[ 3] = tx_data_0[0];

  // instantiations

  genvar i;
  generate
  for (i = 0; i < 6; i = i + 1) begin: g_rx_data
    if (RX_NODPA == 0) begin
      axi_ad9361_serdes_in i_rx_data (
        .data_in_export (rx_data_in_p[i]),
        .clk_export (lvds_clk),
        .loaden_export (lvds_loaden),
        .div_clk_export (clk),
        .hs_phase_export (lvds_phase),
        .locked_export (rx_data_locked_s[i]),
        .data_s_export (rx_data_s[((i*4)+3):(i*4)]),
        .delay_locked_export (rx_delay_locked_s[i]));
    end else begin
      axi_ad9361_serdes_in i_rx_data (
        .data_in_export (rx_data_in_p[i]),
        .clk_export (lvds_clk),
        .loaden_export (lvds_loaden),
        .div_clk_export (clk),
        .data_s_export (rx_data_s[((i*4)+3):(i*4)]));

      assign rx_data_locked_s[i] = 1'b1;
      assign rx_delay_locked_s[i] = 1'b1;

    end
  end

    if (RX_NODPA == 0) begin

      axi_ad9361_serdes_in i_rx_frame (
        .data_in_export (rx_frame_in_p),
        .clk_export (lvds_clk),
        .loaden_export (lvds_loaden),
        .div_clk_export (clk),
        .hs_phase_export (lvds_phase),
        .locked_export (rx_data_locked_s[6]),
        .data_s_export (rx_data_s[27:24]),
        .delay_locked_export (rx_delay_locked_s[6]));

      assign rx_clk = rx_clk_in_p;

    end else begin

      axi_ad9361_serdes_in i_rx_frame (
        .data_in_export (rx_frame_in_p),
        .clk_export (lvds_clk),
        .loaden_export (lvds_loaden),
        .div_clk_export (clk),
        .data_s_export (rx_data_s[27:24]) );

      assign rx_data_locked_s[6] = 1'b1;
      assign rx_delay_locked_s[6] = 1'b1;

      clk_buffer clk_buf (
        .inclk (rx_clk_in_p),
        .outclk (rx_clk));

    end
  endgenerate

  generate
  for (i = 0; i < 6; i = i + 1) begin: g_tx_data
  axi_ad9361_serdes_out i_tx_data (
    .data_out_export (tx_data_out_p[i]),
    .clk_export (lvds_clk),
    .loaden_export (lvds_loaden),
    .div_clk_export (clk),
    .data_s_export (tx_data_s[((i*4)+3):(i*4)]));
  end
  endgenerate

  axi_ad9361_serdes_out i_tx_frame (
    .data_out_export (tx_frame_out_p),
    .clk_export (lvds_clk),
    .loaden_export (lvds_loaden),
    .div_clk_export (clk),
    .data_s_export (tx_data_s[27:24]));

  axi_ad9361_serdes_out i_tx_clk (
    .data_out_export (tx_clk_out_p),
    .clk_export (lvds_clk),
    .loaden_export (lvds_loaden),
    .div_clk_export (clk),
    .data_s_export (4'b1010));

  axi_ad9361_data_out i_enable (
    .ck (clk),
    .din ({tx_enable, tx_enable}),
    .pad_out (enable));

  axi_ad9361_data_out i_txnrx (
    .ck (clk),
    .din ({tx_txnrx, tx_txnrx}),
    .pad_out (txnrx));

  axi_ad9361_serdes_clk i_clk (
    .rst_reset (pll_rst),
    .ref_clk_clk (rx_clk),
    .locked_export (locked_s),
    .hs_phase_phout (lvds_phase),
    .hs_clk_lvds_clk (lvds_clk),
    .loaden_loaden (lvds_loaden),
    .ls_clk_clk (clk));

endmodule
