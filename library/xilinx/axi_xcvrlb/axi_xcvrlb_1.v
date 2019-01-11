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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ps

module axi_xcvrlb_1 (

  // transceiver interface

  input           ref_clk,
  input           rx_p,
  input           rx_n,
  output          tx_p,
  output          tx_n,

  // processor interface

  input           up_rstn,
  input           up_clk,
  input           up_resetn,
  output          up_status);

  // internal registers

  reg     [ 3:0]  rx_kcount = 'd0;
  reg             rx_calign = 'd0;
  reg     [31:0]  rx_data = 'd0;
  reg     [31:0]  rx_pn_data = 'd0;
  reg             tx_charisk = 'd0;
  reg     [31:0]  tx_data = 'd0;
  reg     [31:0]  tx_pn_data = 'd0;
  reg     [ 3:0]  up_pll_rst_cnt = 'd0;
  reg     [ 3:0]  up_rst_cnt = 'd0;
  reg     [ 6:0]  up_user_ready_cnt = 'd0;
  reg             up_status_int = 'd1;

  // internal signals

  wire            clk;
  wire            rx_status_s;
  wire    [31:0]  rx_pn_data_s;
  wire            rx_pn_oos_s;
  wire            rx_pn_err_s;
  wire    [ 3:0]  rx_charisk_s;
  wire    [ 7:0]  rx_error_s;
  wire    [31:0]  rx_data_s;
  wire            up_pll_rst_s;
  wire            up_rst_s;
  wire            up_user_ready_s;
  wire            up_pll_locked_s;
  wire            up_rst_done_s;
  wire            up_pn_oos_s;
  wire            up_pn_err_s;
  wire            up_rx_pll_locked_s;
  wire            up_rx_rst_done_s;
  wire            up_tx_pll_locked_s;
  wire            up_tx_rst_done_s;

  // pn31 function

  function [31:0] pn31;
    input [31:0] din;
    reg   [31:0] dout;
    begin
      dout[31] = din[31] ^ din[28];
      dout[30] = din[30] ^ din[27];
      dout[29] = din[29] ^ din[26];
      dout[28] = din[28] ^ din[25];
      dout[27] = din[27] ^ din[24];
      dout[26] = din[26] ^ din[23];
      dout[25] = din[25] ^ din[22];
      dout[24] = din[24] ^ din[21];
      dout[23] = din[23] ^ din[20];
      dout[22] = din[22] ^ din[19];
      dout[21] = din[21] ^ din[18];
      dout[20] = din[20] ^ din[17];
      dout[19] = din[19] ^ din[16];
      dout[18] = din[18] ^ din[15];
      dout[17] = din[17] ^ din[14];
      dout[16] = din[16] ^ din[13];
      dout[15] = din[15] ^ din[12];
      dout[14] = din[14] ^ din[11];
      dout[13] = din[13] ^ din[10];
      dout[12] = din[12] ^ din[ 9];
      dout[11] = din[11] ^ din[ 8];
      dout[10] = din[10] ^ din[ 7];
      dout[ 9] = din[ 9] ^ din[ 6];
      dout[ 8] = din[ 8] ^ din[ 5];
      dout[ 7] = din[ 7] ^ din[ 4];
      dout[ 6] = din[ 6] ^ din[ 3];
      dout[ 5] = din[ 5] ^ din[ 2];
      dout[ 4] = din[ 4] ^ din[ 1];
      dout[ 3] = din[ 3] ^ din[ 0];
      dout[ 2] = din[ 2] ^ din[31] ^ din[28];
      dout[ 1] = din[ 1] ^ din[30] ^ din[27];
      dout[ 0] = din[ 0] ^ din[29] ^ din[26];
      pn31 = dout;
    end
  endfunction

  // receive

  assign rx_status_s = ~(| rx_error_s);
  assign rx_pn_data_s = (rx_pn_oos_s == 1'b1) ? rx_data : rx_pn_data;

  always @(posedge clk) begin
    if (rx_status_s == 1'b0) begin
      rx_kcount <= 4'd0;
      rx_calign <= 1'd1;
    end else if ((rx_charisk_s == 4'hf) && (rx_data_s == {4{8'hbc}})) begin
      rx_kcount <= rx_kcount + 1'b1;
      if (rx_kcount == 4'hf) begin
        rx_calign <= 1'd0;
      end
    end
  end

  always @(posedge clk) begin
    if (rx_status_s == 1'b1) begin
      rx_data[31:24] = rx_data_s[ 7: 0];
      rx_data[23:16] = rx_data_s[15: 8];
      rx_data[15: 8] = rx_data_s[23:16];
      rx_data[ 7: 0] = rx_data_s[31:24];
    end else begin
      rx_data[31:24] = 8'hff;
      rx_data[23:16] = 8'hff;
      rx_data[15: 8] = 8'hff;
      rx_data[ 7: 0] = 8'hff;
    end
    rx_pn_data <= pn31(rx_pn_data_s);
  end

  // transmit

  always @(posedge clk) begin
    if (rx_calign == 1'b0) begin
      tx_charisk <= 1'd0;
      tx_data[31:24] <= tx_pn_data[ 7: 0];
      tx_data[23:16] <= tx_pn_data[15: 8];
      tx_data[15: 8] <= tx_pn_data[23:16];
      tx_data[ 7: 0] <= tx_pn_data[31:24];
      tx_pn_data <= pn31(tx_pn_data);
    end else begin
      tx_charisk <= 1'd1;
      tx_data[31:24] <= 8'hbc;
      tx_data[23:16] <= 8'hbc;
      tx_data[15: 8] <= 8'hbc;
      tx_data[ 7: 0] <= 8'hbc;
      tx_pn_data <= {32{1'b1}};
    end
  end

  // reset & init

  assign up_status = up_status_int;
  assign up_pll_rst_s = up_pll_rst_cnt[3];
  assign up_rst_s = up_rst_cnt[3];
  assign up_user_ready_s = up_user_ready_cnt[6];
  assign up_pll_locked_s = up_rx_pll_locked_s & up_tx_pll_locked_s;
  assign up_rst_done_s = up_rx_rst_done_s & up_tx_rst_done_s;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_pll_rst_cnt <= 4'h8;
      up_rst_cnt <= 4'h8;
      up_user_ready_cnt <= 7'h00;
      up_status_int <= 1'b1;
    end else begin
      if (up_resetn == 1'b0) begin
        up_pll_rst_cnt <= 4'h8;
      end else if (up_pll_rst_cnt[3] == 1'b1) begin
        up_pll_rst_cnt <= up_pll_rst_cnt + 1'b1;
      end
      if ((up_resetn == 1'b0) || (up_pll_rst_cnt[3] == 1'b1) ||
        (up_pll_locked_s == 1'b0)) begin
        up_rst_cnt <= 4'h8;
      end else if (up_rst_cnt[3] == 1'b1) begin
        up_rst_cnt <= up_rst_cnt + 1'b1;
      end
      if ((up_resetn == 1'b0) || (up_rst_cnt[3] == 1'b1)) begin
        up_user_ready_cnt <= 7'h00;
      end else if (up_user_ready_cnt[6] == 1'b0) begin
        up_user_ready_cnt <= up_user_ready_cnt + 1'b1;
      end
      if ((up_resetn == 1'b0) || (up_rst_done_s == 1'b0)) begin
        up_status_int <= 1'b1;
      end else begin
        up_status_int <= up_pn_oos_s | up_pn_err_s;
      end
    end
  end

  // instantiations

  ad_pnmon #(.DATA_WIDTH(32)) i_pnmon (
    .adc_clk (clk),
    .adc_valid_in (1'b1),
    .adc_data_in (rx_data),
    .adc_data_pn (rx_pn_data),
    .adc_pn_oos (rx_pn_oos_s),
    .adc_pn_err (rx_pn_err_s));

  up_xfer_status #(.DATA_WIDTH(2)) i_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_pn_err_s, up_pn_oos_s}),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_status ({rx_pn_err_s, rx_pn_oos_s}));

  util_adxcvr_xch #(
    .XCVR_TYPE (2),
    .CPLL_FBDIV (2),
    .CPLL_FBDIV_4_5 (5),
    .TX_OUT_DIV (1),
    .TX_CLK25_DIV (10),
    .RX_OUT_DIV (1),
    .RX_CLK25_DIV (10),
    .RX_DFE_LPM_CFG (16'h0904),
    .RX_PMA_CFG ('h00018480),
    .RX_CDR_CFG ('h03000023ff10200020))
  i_xch (
    .qpll2ch_clk (1'b0),
    .qpll2ch_ref_clk (1'b0),
    .qpll2ch_locked (1'b1),
    .cpll_ref_clk (ref_clk),
    .up_cpll_rst (up_pll_rst_s),
    .rx_p (rx_p),
    .rx_n (rx_n),
    .rx_out_clk (clk),
    .rx_clk (clk),
    .rx_charisk (rx_charisk_s),
    .rx_disperr (rx_error_s[3:0]),
    .rx_notintable (rx_error_s[7:4]),
    .rx_data (rx_data_s),
    .rx_calign (rx_calign),
    .tx_p (tx_p),
    .tx_n (tx_n),
    .tx_out_clk (),
    .tx_clk (clk),
    .tx_charisk ({4{tx_charisk}}),
    .tx_data (tx_data),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_es_enb (1'd0),
    .up_es_addr (12'd0),
    .up_es_wr (1'd0),
    .up_es_wdata (16'd0),
    .up_es_rdata (),
    .up_es_ready (),
    .up_rx_pll_locked (up_rx_pll_locked_s),
    .up_rx_rst (up_rst_s),
    .up_rx_user_ready (up_user_ready_s),
    .up_rx_rst_done (up_rx_rst_done_s),
    .up_rx_lpm_dfe_n (1'd0),
    .up_rx_rate (3'd0),
    .up_rx_sys_clk_sel (2'd0),
    .up_rx_out_clk_sel (3'd2),
    .up_rx_enb (1'd0),
    .up_rx_addr (12'd0),
    .up_rx_wr (1'd0),
    .up_rx_wdata (16'd0),
    .up_rx_rdata (),
    .up_rx_ready (),
    .up_tx_pll_locked (up_tx_pll_locked_s),
    .up_tx_rst (up_rst_s),
    .up_tx_user_ready (up_user_ready_s),
    .up_tx_rst_done (up_tx_rst_done_s),
    .up_tx_lpm_dfe_n (1'd0),
    .up_tx_rate (3'd0),
    .up_tx_sys_clk_sel (2'd0),
    .up_tx_out_clk_sel (3'd2),
    .up_tx_enb (1'd0),
    .up_tx_addr (12'd0),
    .up_tx_wr (1'd0),
    .up_tx_wdata (16'd0),
    .up_tx_rdata (),
    .up_tx_ready ());

endmodule

// ***************************************************************************
// ***************************************************************************

