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

module util_gtlb (

  // receive interface

  rx_clk,
  rx_rst,
  rx_commaalign,
  rx_charisk,
  rx_disperr,
  rx_notintable,
  rx_data,

  // transmit interface

  tx_clk,
  tx_rst,
  tx_charisk,
  tx_data,

  // up interface

  up_clk,
  up_rstn,
  up_rx_sync,
  up_rx_pn_err,
  up_rx_pn_oos);

  // pll clocks & resets

  input                                       qpll_ref_clk,
  input                                       cpll_ref_clk,

  output                                      qpll0_rst,
  output                                      qpll0_ref_clk_in,

  input                                       pll_rst_0,
  output                                      cpll_rst_m_0,
  output                                      cpll_ref_clk_in_0,

  // channel interface (rx)
  
  input                                       rx_p,
  input                                       rx_n,

  input   [ 3:0]                              rx_gt_charisk;
  input   [ 3:0]                              rx_gt_disperr;
  input   [ 3:0]                              rx_gt_notintable;
  input   [31:0]                              rx_gt_data;

  output                                      rx_out_clk,
  input                                       rx_clk,
  output                                      rx_rst,
  output                                      rx_sof,
  output  [((RX_NUM_OF_LANES*32)-1):0]        rx_data,

  output                                      rx_ip_rst,
  output                                      rx_ip_rst_done,
  output                                      rx_ip_sysref,
  input                                       rx_ip_sync,
  input   [  3:0]                             rx_ip_sof,
  input   [((RX_NUM_OF_LANES*32)-1):0]        rx_ip_data,

  output                                      rx_0_p,
  output                                      rx_0_n,
  input                                       rx_rst_0,
  output                                      rx_rst_m_0,
  input                                       rx_gt_rst_0,
  output                                      rx_gt_rst_m_0,
  input                                       rx_pll_locked_0,
  output                                      rx_pll_locked_m_0,
  input                                       rx_user_ready_0,
  output                                      rx_user_ready_m_0,
  input                                       rx_rst_done_0,
  output                                      rx_rst_done_m_0,
  input                                       rx_out_clk_0,
  output                                      rx_clk_0,
  output                                      rx_sysref_0,
  input                                       rx_sync_0,
  input                                       rx_sof_0,
  input   [31:0]                              rx_data_0,
  input                                       rx_ip_rst_0,
  output  [ 3:0]                              rx_ip_sof_0,
  output  [31:0]                              rx_ip_data_0,
  input                                       rx_ip_sysref_0,
  output                                      rx_ip_sync_0,
  input                                       rx_ip_rst_done_0,

  // channel interface (tx)

  output                                      tx_p,
  output                                      tx_n,

  output  [ 3:0]                              tx_gt_charisk,
  output  [31:0]                              tx_gt_data,

  input                                       tx_0_p,
  input                                       tx_0_n,
  input                                       tx_rst_0,
  output                                      tx_rst_m_0,
  input                                       tx_gt_rst_0,
  output                                      tx_gt_rst_m_0,
  input                                       tx_pll_locked_0,
  output                                      tx_pll_locked_m_0,
  input                                       tx_user_ready_0,
  output                                      tx_user_ready_m_0,
  input                                       tx_rst_done_0,
  output                                      tx_rst_done_m_0,
  input                                       tx_out_clk_0,
  output                                      tx_clk_0,
  output                                      tx_sysref_0,
  output                                      tx_sync_0,
  output  [31:0]                              tx_data_0,
  input                                       tx_ip_rst_0,
  input   [31:0]                              tx_ip_data_0,
  input                                       tx_ip_sysref_0,
  input                                       tx_ip_sync_0,
  input                                       tx_ip_rst_done_0);


  assign qpll0_rst = pll_rst_0;
  assign qpll0_ref_clk_in = qpll_ref_clk;
  assign cpll_rst_m_0 = pll_rst_0;
  assign cpll_ref_clk_in_0 = cpll_ref_clk;


  assign rx_0_p = rx_p;
  assign rx_0_n = rx_n;
  assign rx_rst_m_0 = rx_rst_0;
  assign rx_gt_rst_m_0 = rx_gt_rst_0;
  assign rx_pll_locked_m_0 = rx_pll_locked_0;
  assign rx_user_ready_m_0 = rx_user_ready_0;
  assign rx_rst_done_m_0 = & rx_rst_done_0;
  assign rx_clk_0 = rx_clk;
  assign rx_sysref_0 = 1'd0;
  assign rx_ip_sof_0 = 4'hf;
  assign rx_ip_data_0 = rx_gt_data_0;
  assign rx_ip_sync_0 = ?;

  assign tx_p = tx_0_p;
  assign tx_n = tx_0_n;

  assign tx_gt_charisk = ?;
  assign tx_gt_data = tx_ip_data_0;

  assign tx_rst_m_0 = tx_rst_0;
  assign tx_gt_rst_m_0 = tx_gt_rst_0;
  assign tx_pll_locked_m_0 = tx_pll_locked_0;
  assign tx_user_ready_m_0 = tx_user_ready_0;
  assign tx_rst_done_m_0 = tx_rst_done_0;
  assign tx_clk_0 = tx_clk;
  assign tx_sysref_0 = 1'd0;
  assign tx_sync_0 = ?;
  assign tx_data_0 = ?;


  // receive interface

  input           rx_clk;
  input           rx_rst;
  output          rx_commaalign;
  input   [ 3:0]  rx_charisk;
  input   [ 3:0]  rx_disperr;
  input   [ 3:0]  rx_notintable;
  input   [31:0]  rx_data;

  // transmit interface

  input           tx_clk;
  input           tx_rst;
  output  [ 3:0]  tx_charisk;
  output  [31:0]  tx_data;

  // up interface

  input           up_clk;
  input           up_rstn;
  output          up_rx_sync;
  output          up_rx_pn_err;
  output          up_rx_pn_oos;

  // internal registers

  reg             tx_sync_m1 = 'd0;
  reg             tx_sync_m2 = 'd0;
  reg             tx_sync = 'd0;
  reg     [31:0]  tx_pn_data = 'd0;
  reg             tx_charisk_1 = 'd0;
  reg     [31:0]  tx_data = 'd0;
  reg             rx_commaalign = 'd0;
  reg     [ 3:0]  rx_kcount = 'd0;
  reg             rx_sync = 'd0;
  reg     [31:0]  rx_pn_data = 'd0;
  reg             rx_pn_match_d = 'd0;
  reg             rx_pn_match_z = 'd0;
  reg             rx_pn_err = 'd0;
  reg             rx_pn_oos = 'd0;
  reg     [ 3:0]  rx_pn_oos_count = 'd0;
  reg             up_rx_sync_m1 = 'd0;
  reg             up_rx_sync_m2 = 'd0;
  reg             up_rx_sync = 'd0;
  reg             up_rx_pn_err_m1 = 'd0;
  reg             up_rx_pn_err_m2 = 'd0;
  reg             up_rx_pn_err = 'd0;
  reg             up_rx_pn_oos_m1 = 'd0;
  reg             up_rx_pn_oos_m2 = 'd0;
  reg             up_rx_pn_oos = 'd0;

  // internal signals

  wire    [31:0]  rx_pn_data_s;
  wire            rx_pn_match_d_s;
  wire            rx_pn_match_z_s;
  wire            rx_pn_match_s;
  wire            rx_pn_update_s;
  wire            rx_pn_err_s;

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

  // gt loop back

  assign tx_charisk = {4{tx_charisk_1}};

  always @(posedge tx_clk or posedge tx_rst) begin
    if (tx_rst == 1'b1) begin
      tx_sync_m1 <= 1'd0;
      tx_sync_m2 <= 1'd0;
      tx_sync <= 1'd0;
      tx_pn_data <= 32'hffffffff;
      tx_charisk_1 <= 1'd0;
      tx_data <= 32'd0;
    end else begin
      tx_sync_m1 <= rx_sync;
      tx_sync_m2 <= tx_sync_m1;
      tx_sync <= tx_sync_m2;
      tx_pn_data <= pn31(tx_pn_data);
      if (tx_sync == 1'b1) begin
        tx_charisk_1 <= 1'd0;
        tx_data <= tx_pn_data;
      end else begin
        tx_charisk_1 <= 1'd1;
        tx_data <= 32'hbcbcbcbc;
      end
    end
  end

  always @(posedge rx_clk or posedge rx_rst) begin
    if (rx_rst == 1'b1) begin
      rx_commaalign <= 1'd0;
      rx_kcount <= 4'd0;
      rx_sync <= 1'd0;
    end else begin
      rx_commaalign <= ~rx_sync;
      if ((rx_disperr == 0) && (rx_notintable == 0)) begin
        if ((rx_charisk == 4'hf) && (rx_data == 32'hbcbcbcbc)) begin
          rx_kcount <= rx_kcount + 1'b1;
          if (rx_kcount == 4'hf) begin
            rx_sync <= 1'b1;
          end
        end else begin
          rx_kcount <= 4'd0;
          rx_sync <= rx_sync;
        end
      end else begin
        rx_kcount <= 4'd0;
        rx_sync <= 1'd0;
      end
    end
  end

  assign rx_pn_data_s = (rx_pn_oos == 1'b1) ? rx_data : rx_pn_data;
  assign rx_pn_match_d_s = (rx_data == rx_pn_data) ? 1'b1 : 1'b0;
  assign rx_pn_match_z_s = (rx_data == 'd0) ? 1'b0 : 1'b1;
  assign rx_pn_match_s = rx_pn_match_d & rx_pn_match_z;
  assign rx_pn_update_s = ~(rx_pn_oos ^ rx_pn_match_s);
  assign rx_pn_err_s = ~(rx_pn_oos | rx_pn_match_s);

  always @(posedge rx_clk or posedge rx_rst) begin
    if (rx_rst == 1'b1) begin
      rx_pn_data <= 32'd0;
      rx_pn_match_d <= 'd0;
      rx_pn_match_z <= 'd0;
      rx_pn_err <= 'd0;
      rx_pn_oos <= 'd0;
      rx_pn_oos_count <= 'd0;
    end else begin
      rx_pn_data <= pn31(rx_pn_data_s);
      rx_pn_match_d <= rx_pn_match_d_s;
      rx_pn_match_z <= rx_pn_match_z_s;
      if ((rx_disperr == 0) && (rx_notintable == 0) && (rx_charisk == 0)) begin
        rx_pn_err <= rx_pn_err_s;
        if ((rx_pn_update_s == 1'b1) && (rx_pn_oos_count >= 15)) begin
          rx_pn_oos <= ~rx_pn_oos;
        end
        if (rx_pn_update_s == 1'b1) begin
          rx_pn_oos_count <= rx_pn_oos_count + 1'b1;
        end else begin
          rx_pn_oos_count <= 'd0;
        end
      end else begin
        rx_pn_err <= 1'd0;
        rx_pn_oos <= 1'd1;
        rx_pn_oos_count <= 'd0;
      end
    end
  end

  // up clock

  always @(posedge up_clk or negedge up_rstn) begin
    if (up_rstn == 1'b0) begin
      up_rx_sync_m1 <= 'd0;
      up_rx_sync_m2 <= 'd0;
      up_rx_sync <= 'd0;
      up_rx_pn_err_m1 <= 'd0;
      up_rx_pn_err_m2 <= 'd0;
      up_rx_pn_err <= 'd0;
      up_rx_pn_oos_m1 <= 'd0;
      up_rx_pn_oos_m2 <= 'd0;
      up_rx_pn_oos <= 'd0;
    end else begin
      up_rx_sync_m1 <= rx_sync;
      up_rx_sync_m2 <= up_rx_sync_m1;
      up_rx_sync <= up_rx_sync_m2;
      up_rx_pn_err_m1 <= rx_pn_err;
      up_rx_pn_err_m2 <= up_rx_pn_err_m1;
      up_rx_pn_err <= up_rx_pn_err_m2;
      up_rx_pn_oos_m1 <= rx_pn_oos;
      up_rx_pn_oos_m2 <= up_rx_pn_oos_m1;
      up_rx_pn_oos <= up_rx_pn_oos_m2;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************

