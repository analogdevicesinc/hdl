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

module util_jesd_gt #(

  parameter   integer QPLL0_ENABLE = 1,
  parameter   integer QPLL1_ENABLE = 1,
  parameter   integer NUM_OF_LANES = 8,
  parameter   integer RX_ENABLE = 1,
  parameter   integer RX_NUM_OF_LANES = 8,
  parameter   integer TX_ENABLE = 1,
  parameter   integer TX_NUM_OF_LANES = 8)

 (

  // pll clocks & resets

  input                                       qpll_ref_clk,
  input                                       cpll_ref_clk,

  output                                      qpll0_rst,
  output                                      qpll0_ref_clk_in,
  output                                      qpll1_rst,
  output                                      qpll1_ref_clk_in,

  input                                       pll_rst_0,
  output                                      cpll_rst_m_0,
  output                                      cpll_ref_clk_in_0,
  input                                       pll_rst_1,
  output                                      cpll_rst_m_1,
  output                                      cpll_ref_clk_in_1,
  input                                       pll_rst_2,
  output                                      cpll_rst_m_2,
  output                                      cpll_ref_clk_in_2,
  input                                       pll_rst_3,
  output                                      cpll_rst_m_3,
  output                                      cpll_ref_clk_in_3,
  input                                       pll_rst_4,
  output                                      cpll_rst_m_4,
  output                                      cpll_ref_clk_in_4,
  input                                       pll_rst_5,
  output                                      cpll_rst_m_5,
  output                                      cpll_ref_clk_in_5,
  input                                       pll_rst_6,
  output                                      cpll_rst_m_6,
  output                                      cpll_ref_clk_in_6,
  input                                       pll_rst_7,
  output                                      cpll_rst_m_7,
  output                                      cpll_ref_clk_in_7,

  // channel interface (rx)
  
  input   [((RX_NUM_OF_LANES* 1)-1):0]        rx_p,
  input   [((RX_NUM_OF_LANES* 1)-1):0]        rx_n,
  input                                       rx_sysref,
  output                                      rx_sync,

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

  output                                      rx_1_p,
  output                                      rx_1_n,
  input                                       rx_rst_1,
  output                                      rx_rst_m_1,
  input                                       rx_gt_rst_1,
  output                                      rx_gt_rst_m_1,
  input                                       rx_pll_locked_1,
  output                                      rx_pll_locked_m_1,
  input                                       rx_user_ready_1,
  output                                      rx_user_ready_m_1,
  input                                       rx_rst_done_1,
  output                                      rx_rst_done_m_1,
  input                                       rx_out_clk_1,
  output                                      rx_clk_1,
  output                                      rx_sysref_1,
  input                                       rx_sync_1,
  input                                       rx_sof_1,
  input   [31:0]                              rx_data_1,
  input                                       rx_ip_rst_1,
  output  [ 3:0]                              rx_ip_sof_1,
  output  [31:0]                              rx_ip_data_1,
  input                                       rx_ip_sysref_1,
  output                                      rx_ip_sync_1,
  input                                       rx_ip_rst_done_1,

  output                                      rx_2_p,
  output                                      rx_2_n,
  input                                       rx_rst_2,
  output                                      rx_rst_m_2,
  input                                       rx_gt_rst_2,
  output                                      rx_gt_rst_m_2,
  input                                       rx_pll_locked_2,
  output                                      rx_pll_locked_m_2,
  input                                       rx_user_ready_2,
  output                                      rx_user_ready_m_2,
  input                                       rx_rst_done_2,
  output                                      rx_rst_done_m_2,
  input                                       rx_out_clk_2,
  output                                      rx_clk_2,
  output                                      rx_sysref_2,
  input                                       rx_sync_2,
  input                                       rx_sof_2,
  input   [31:0]                              rx_data_2,
  input                                       rx_ip_rst_2,
  output  [ 3:0]                              rx_ip_sof_2,
  output  [31:0]                              rx_ip_data_2,
  input                                       rx_ip_sysref_2,
  output                                      rx_ip_sync_2,
  input                                       rx_ip_rst_done_2,

  output                                      rx_3_p,
  output                                      rx_3_n,
  input                                       rx_rst_3,
  output                                      rx_rst_m_3,
  input                                       rx_gt_rst_3,
  output                                      rx_gt_rst_m_3,
  input                                       rx_pll_locked_3,
  output                                      rx_pll_locked_m_3,
  input                                       rx_user_ready_3,
  output                                      rx_user_ready_m_3,
  input                                       rx_rst_done_3,
  output                                      rx_rst_done_m_3,
  input                                       rx_out_clk_3,
  output                                      rx_clk_3,
  output                                      rx_sysref_3,
  input                                       rx_sync_3,
  input                                       rx_sof_3,
  input   [31:0]                              rx_data_3,
  input                                       rx_ip_rst_3,
  output  [ 3:0]                              rx_ip_sof_3,
  output  [31:0]                              rx_ip_data_3,
  input                                       rx_ip_sysref_3,
  output                                      rx_ip_sync_3,
  input                                       rx_ip_rst_done_3,

  output                                      rx_4_p,
  output                                      rx_4_n,
  input                                       rx_rst_4,
  output                                      rx_rst_m_4,
  input                                       rx_gt_rst_4,
  output                                      rx_gt_rst_m_4,
  input                                       rx_pll_locked_4,
  output                                      rx_pll_locked_m_4,
  input                                       rx_user_ready_4,
  output                                      rx_user_ready_m_4,
  input                                       rx_rst_done_4,
  output                                      rx_rst_done_m_4,
  input                                       rx_out_clk_4,
  output                                      rx_clk_4,
  output                                      rx_sysref_4,
  input                                       rx_sync_4,
  input                                       rx_sof_4,
  input   [31:0]                              rx_data_4,
  input                                       rx_ip_rst_4,
  output  [ 3:0]                              rx_ip_sof_4,
  output  [31:0]                              rx_ip_data_4,
  input                                       rx_ip_sysref_4,
  output                                      rx_ip_sync_4,
  input                                       rx_ip_rst_done_4,

  output                                      rx_5_p,
  output                                      rx_5_n,
  input                                       rx_rst_5,
  output                                      rx_rst_m_5,
  input                                       rx_gt_rst_5,
  output                                      rx_gt_rst_m_5,
  input                                       rx_pll_locked_5,
  output                                      rx_pll_locked_m_5,
  input                                       rx_user_ready_5,
  output                                      rx_user_ready_m_5,
  input                                       rx_rst_done_5,
  output                                      rx_rst_done_m_5,
  input                                       rx_out_clk_5,
  output                                      rx_clk_5,
  output                                      rx_sysref_5,
  input                                       rx_sync_5,
  input                                       rx_sof_5,
  input   [31:0]                              rx_data_5,
  input                                       rx_ip_rst_5,
  output  [ 3:0]                              rx_ip_sof_5,
  output  [31:0]                              rx_ip_data_5,
  input                                       rx_ip_sysref_5,
  output                                      rx_ip_sync_5,
  input                                       rx_ip_rst_done_5,

  output                                      rx_6_p,
  output                                      rx_6_n,
  input                                       rx_rst_6,
  output                                      rx_rst_m_6,
  input                                       rx_gt_rst_6,
  output                                      rx_gt_rst_m_6,
  input                                       rx_pll_locked_6,
  output                                      rx_pll_locked_m_6,
  input                                       rx_user_ready_6,
  output                                      rx_user_ready_m_6,
  input                                       rx_rst_done_6,
  output                                      rx_rst_done_m_6,
  input                                       rx_out_clk_6,
  output                                      rx_clk_6,
  output                                      rx_sysref_6,
  input                                       rx_sync_6,
  input                                       rx_sof_6,
  input   [31:0]                              rx_data_6,
  input                                       rx_ip_rst_6,
  output  [ 3:0]                              rx_ip_sof_6,
  output  [31:0]                              rx_ip_data_6,
  input                                       rx_ip_sysref_6,
  output                                      rx_ip_sync_6,
  input                                       rx_ip_rst_done_6,

  output                                      rx_7_p,
  output                                      rx_7_n,
  input                                       rx_rst_7,
  output                                      rx_rst_m_7,
  input                                       rx_gt_rst_7,
  output                                      rx_gt_rst_m_7,
  input                                       rx_pll_locked_7,
  output                                      rx_pll_locked_m_7,
  input                                       rx_user_ready_7,
  output                                      rx_user_ready_m_7,
  input                                       rx_rst_done_7,
  output                                      rx_rst_done_m_7,
  input                                       rx_out_clk_7,
  output                                      rx_clk_7,
  output                                      rx_sysref_7,
  input                                       rx_sync_7,
  input                                       rx_sof_7,
  input   [31:0]                              rx_data_7,
  input                                       rx_ip_rst_7,
  output  [ 3:0]                              rx_ip_sof_7,
  output  [31:0]                              rx_ip_data_7,
  input                                       rx_ip_sysref_7,
  output                                      rx_ip_sync_7,
  input                                       rx_ip_rst_done_7,

  // channel interface (tx)

  output  [((TX_NUM_OF_LANES* 1)-1):0]        tx_p,
  output  [((TX_NUM_OF_LANES* 1)-1):0]        tx_n,
  input                                       tx_sysref,
  input                                       tx_sync,

  output                                      tx_out_clk,
  input                                       tx_clk,
  output                                      tx_rst,
  input   [((TX_NUM_OF_LANES*32)-1):0]        tx_data,

  output                                      tx_ip_rst,
  output                                      tx_ip_rst_done,
  output                                      tx_ip_sysref,
  output                                      tx_ip_sync,
  output  [((TX_NUM_OF_LANES*32)-1):0]        tx_ip_data,

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
  input                                       tx_ip_rst_done_0,

  input                                       tx_1_p,
  input                                       tx_1_n,
  input                                       tx_rst_1,
  output                                      tx_rst_m_1,
  input                                       tx_gt_rst_1,
  output                                      tx_gt_rst_m_1,
  input                                       tx_pll_locked_1,
  output                                      tx_pll_locked_m_1,
  input                                       tx_user_ready_1,
  output                                      tx_user_ready_m_1,
  input                                       tx_rst_done_1,
  output                                      tx_rst_done_m_1,
  input                                       tx_out_clk_1,
  output                                      tx_clk_1,
  output                                      tx_sysref_1,
  output                                      tx_sync_1,
  output  [31:0]                              tx_data_1,
  input                                       tx_ip_rst_1,
  input   [31:0]                              tx_ip_data_1,
  input                                       tx_ip_sysref_1,
  input                                       tx_ip_sync_1,
  input                                       tx_ip_rst_done_1,

  input                                       tx_2_p,
  input                                       tx_2_n,
  input                                       tx_rst_2,
  output                                      tx_rst_m_2,
  input                                       tx_gt_rst_2,
  output                                      tx_gt_rst_m_2,
  input                                       tx_pll_locked_2,
  output                                      tx_pll_locked_m_2,
  input                                       tx_user_ready_2,
  output                                      tx_user_ready_m_2,
  input                                       tx_rst_done_2,
  output                                      tx_rst_done_m_2,
  input                                       tx_out_clk_2,
  output                                      tx_clk_2,
  output                                      tx_sysref_2,
  output                                      tx_sync_2,
  output  [31:0]                              tx_data_2,
  input                                       tx_ip_rst_2,
  input   [31:0]                              tx_ip_data_2,
  input                                       tx_ip_sysref_2,
  input                                       tx_ip_sync_2,
  input                                       tx_ip_rst_done_2,

  input                                       tx_3_p,
  input                                       tx_3_n,
  input                                       tx_rst_3,
  output                                      tx_rst_m_3,
  input                                       tx_gt_rst_3,
  output                                      tx_gt_rst_m_3,
  input                                       tx_pll_locked_3,
  output                                      tx_pll_locked_m_3,
  input                                       tx_user_ready_3,
  output                                      tx_user_ready_m_3,
  input                                       tx_rst_done_3,
  output                                      tx_rst_done_m_3,
  input                                       tx_out_clk_3,
  output                                      tx_clk_3,
  output                                      tx_sysref_3,
  output                                      tx_sync_3,
  output  [31:0]                              tx_data_3,
  input                                       tx_ip_rst_3,
  input   [31:0]                              tx_ip_data_3,
  input                                       tx_ip_sysref_3,
  input                                       tx_ip_sync_3,
  input                                       tx_ip_rst_done_3,

  input                                       tx_4_p,
  input                                       tx_4_n,
  input                                       tx_rst_4,
  output                                      tx_rst_m_4,
  input                                       tx_gt_rst_4,
  output                                      tx_gt_rst_m_4,
  input                                       tx_pll_locked_4,
  output                                      tx_pll_locked_m_4,
  input                                       tx_user_ready_4,
  output                                      tx_user_ready_m_4,
  input                                       tx_rst_done_4,
  output                                      tx_rst_done_m_4,
  input                                       tx_out_clk_4,
  output                                      tx_clk_4,
  output                                      tx_sysref_4,
  output                                      tx_sync_4,
  output  [31:0]                              tx_data_4,
  input                                       tx_ip_rst_4,
  input   [31:0]                              tx_ip_data_4,
  input                                       tx_ip_sysref_4,
  input                                       tx_ip_sync_4,
  input                                       tx_ip_rst_done_4,

  input                                       tx_5_p,
  input                                       tx_5_n,
  input                                       tx_rst_5,
  output                                      tx_rst_m_5,
  input                                       tx_gt_rst_5,
  output                                      tx_gt_rst_m_5,
  input                                       tx_pll_locked_5,
  output                                      tx_pll_locked_m_5,
  input                                       tx_user_ready_5,
  output                                      tx_user_ready_m_5,
  input                                       tx_rst_done_5,
  output                                      tx_rst_done_m_5,
  input                                       tx_out_clk_5,
  output                                      tx_clk_5,
  output                                      tx_sysref_5,
  output                                      tx_sync_5,
  output  [31:0]                              tx_data_5,
  input                                       tx_ip_rst_5,
  input   [31:0]                              tx_ip_data_5,
  input                                       tx_ip_sysref_5,
  input                                       tx_ip_sync_5,
  input                                       tx_ip_rst_done_5,

  input                                       tx_6_p,
  input                                       tx_6_n,
  input                                       tx_rst_6,
  output                                      tx_rst_m_6,
  input                                       tx_gt_rst_6,
  output                                      tx_gt_rst_m_6,
  input                                       tx_pll_locked_6,
  output                                      tx_pll_locked_m_6,
  input                                       tx_user_ready_6,
  output                                      tx_user_ready_m_6,
  input                                       tx_rst_done_6,
  output                                      tx_rst_done_m_6,
  input                                       tx_out_clk_6,
  output                                      tx_clk_6,
  output                                      tx_sysref_6,
  output                                      tx_sync_6,
  output  [31:0]                              tx_data_6,
  input                                       tx_ip_rst_6,
  input   [31:0]                              tx_ip_data_6,
  input                                       tx_ip_sysref_6,
  input                                       tx_ip_sync_6,
  input                                       tx_ip_rst_done_6,

  input                                       tx_7_p,
  input                                       tx_7_n,
  input                                       tx_rst_7,
  output                                      tx_rst_m_7,
  input                                       tx_gt_rst_7,
  output                                      tx_gt_rst_m_7,
  input                                       tx_pll_locked_7,
  output                                      tx_pll_locked_m_7,
  input                                       tx_user_ready_7,
  output                                      tx_user_ready_m_7,
  input                                       tx_rst_done_7,
  output                                      tx_rst_done_m_7,
  input                                       tx_out_clk_7,
  output                                      tx_clk_7,
  output                                      tx_sysref_7,
  output                                      tx_sync_7,
  output  [31:0]                              tx_data_7,
  input                                       tx_ip_rst_7,
  input   [31:0]                              tx_ip_data_7,
  input                                       tx_ip_sysref_7,
  input                                       tx_ip_sync_7,
  input                                       tx_ip_rst_done_7);

  // internal signals

  wire    [(( 1*8)-1):0]                      rx_all_p;
  wire    [(( 1*8)-1):0]                      rx_all_n;
  wire    [(( 1*8)-1):0]                      rx_pll_locked_all;
  wire    [(( 1*8)-1):0]                      rx_user_ready_all;
  wire    [(( 1*8)-1):0]                      rx_rst_done_all;
  wire    [(( 1*8)-1):0]                      rx_ip_rst_done_all;
  wire    [((32*8)-1):0]                      rx_data_all;
  wire    [((32*8)-1):0]                      rx_ip_data_all;
  wire    [(( 1*8)-1):0]                      tx_all_p;
  wire    [(( 1*8)-1):0]                      tx_all_n;
  wire    [(( 1*8)-1):0]                      tx_pll_locked_all;
  wire    [(( 1*8)-1):0]                      tx_user_ready_all;
  wire    [(( 1*8)-1):0]                      tx_rst_done_all;
  wire    [(( 1*8)-1):0]                      tx_ip_rst_done_all;
  wire    [((32*8)-1):0]                      tx_ip_data_all;
  wire    [((32*8)-1):0]                      tx_data_all;

  // pll clocks & resets

  assign qpll0_rst = pll_rst_0;
  assign qpll0_ref_clk_in = qpll_ref_clk;
  assign qpll1_rst = pll_rst_0;
  assign qpll1_ref_clk_in = qpll_ref_clk;
  assign cpll_rst_m_0 = pll_rst_0;
  assign cpll_ref_clk_in_0 = cpll_ref_clk;
  assign cpll_rst_m_1 = pll_rst_0;
  assign cpll_ref_clk_in_1 = cpll_ref_clk;
  assign cpll_rst_m_2 = pll_rst_0;
  assign cpll_ref_clk_in_2 = cpll_ref_clk;
  assign cpll_rst_m_3 = pll_rst_0;
  assign cpll_ref_clk_in_3 = cpll_ref_clk;
  assign cpll_rst_m_4 = pll_rst_0;
  assign cpll_ref_clk_in_4 = cpll_ref_clk;
  assign cpll_rst_m_5 = pll_rst_0;
  assign cpll_ref_clk_in_5 = cpll_ref_clk;
  assign cpll_rst_m_6 = pll_rst_0;
  assign cpll_ref_clk_in_6 = cpll_ref_clk;
  assign cpll_rst_m_7 = pll_rst_0;
  assign cpll_ref_clk_in_7 = cpll_ref_clk;

  // channel interface (rx)

  generate
  if (RX_NUM_OF_LANES < 8) begin
  assign rx_all_p[((8* 1)-1):(RX_NUM_OF_LANES* 1)] = 'd0;
  assign rx_all_n[((8* 1)-1):(RX_NUM_OF_LANES* 1)] = 'd0;
  end
  endgenerate

  assign rx_all_p[((RX_NUM_OF_LANES* 1)-1):0] = rx_p;
  assign rx_all_n[((RX_NUM_OF_LANES* 1)-1):0] = rx_n;

  assign rx_pll_locked_all[0] = (RX_NUM_OF_LANES >= 1) ? rx_pll_locked_0 : 1'b1;
  assign rx_user_ready_all[0] = (RX_NUM_OF_LANES >= 1) ? rx_user_ready_0 : 1'b1;
  assign rx_rst_done_all[0] = (RX_NUM_OF_LANES >= 1) ? rx_rst_done_0 : 1'b1;
  assign rx_ip_rst_done_all[0] = (RX_NUM_OF_LANES >= 1) ? rx_ip_rst_done_0 : 1'b1;
  assign rx_data_all[((32*0)+31):(32*0)] = rx_data_0;

  assign rx_pll_locked_all[1] = (RX_NUM_OF_LANES >= 2) ? rx_pll_locked_1 : 1'b1;
  assign rx_user_ready_all[1] = (RX_NUM_OF_LANES >= 2) ? rx_user_ready_1 : 1'b1;
  assign rx_rst_done_all[1] = (RX_NUM_OF_LANES >= 2) ? rx_rst_done_1 : 1'b1;
  assign rx_ip_rst_done_all[1] = (RX_NUM_OF_LANES >= 2) ? rx_ip_rst_done_1 : 1'b1;
  assign rx_data_all[((32*1)+31):(32*1)] = rx_data_1;

  assign rx_pll_locked_all[2] = (RX_NUM_OF_LANES >= 3) ? rx_pll_locked_2 : 1'b1;
  assign rx_user_ready_all[2] = (RX_NUM_OF_LANES >= 3) ? rx_user_ready_2 : 1'b1;
  assign rx_rst_done_all[2] = (RX_NUM_OF_LANES >= 3) ? rx_rst_done_2 : 1'b1;
  assign rx_ip_rst_done_all[2] = (RX_NUM_OF_LANES >= 3) ? rx_ip_rst_done_2 : 1'b1;
  assign rx_data_all[((32*2)+31):(32*2)] = rx_data_2;

  assign rx_pll_locked_all[3] = (RX_NUM_OF_LANES >= 4) ? rx_pll_locked_3 : 1'b1;
  assign rx_user_ready_all[3] = (RX_NUM_OF_LANES >= 4) ? rx_user_ready_3 : 1'b1;
  assign rx_rst_done_all[3] = (RX_NUM_OF_LANES >= 4) ? rx_rst_done_3 : 1'b1;
  assign rx_ip_rst_done_all[3] = (RX_NUM_OF_LANES >= 4) ? rx_ip_rst_done_3 : 1'b1;
  assign rx_data_all[((32*3)+31):(32*3)] = rx_data_3;

  assign rx_pll_locked_all[4] = (RX_NUM_OF_LANES >= 5) ? rx_pll_locked_4 : 1'b1;
  assign rx_user_ready_all[4] = (RX_NUM_OF_LANES >= 5) ? rx_user_ready_4 : 1'b1;
  assign rx_rst_done_all[4] = (RX_NUM_OF_LANES >= 5) ? rx_rst_done_4 : 1'b1;
  assign rx_ip_rst_done_all[4] = (RX_NUM_OF_LANES >= 5) ? rx_ip_rst_done_4 : 1'b1;
  assign rx_data_all[((32*4)+31):(32*4)] = rx_data_4;

  assign rx_pll_locked_all[5] = (RX_NUM_OF_LANES >= 6) ? rx_pll_locked_5 : 1'b1;
  assign rx_user_ready_all[5] = (RX_NUM_OF_LANES >= 6) ? rx_user_ready_5 : 1'b1;
  assign rx_rst_done_all[5] = (RX_NUM_OF_LANES >= 6) ? rx_rst_done_5 : 1'b1;
  assign rx_ip_rst_done_all[5] = (RX_NUM_OF_LANES >= 6) ? rx_ip_rst_done_5 : 1'b1;
  assign rx_data_all[((32*5)+31):(32*5)] = rx_data_5;

  assign rx_pll_locked_all[6] = (RX_NUM_OF_LANES >= 7) ? rx_pll_locked_6 : 1'b1;
  assign rx_user_ready_all[6] = (RX_NUM_OF_LANES >= 7) ? rx_user_ready_6 : 1'b1;
  assign rx_rst_done_all[6] = (RX_NUM_OF_LANES >= 7) ? rx_rst_done_6 : 1'b1;
  assign rx_ip_rst_done_all[6] = (RX_NUM_OF_LANES >= 7) ? rx_ip_rst_done_6 : 1'b1;
  assign rx_data_all[((32*6)+31):(32*6)] = rx_data_6;

  assign rx_pll_locked_all[7] = (RX_NUM_OF_LANES >= 8) ? rx_pll_locked_7 : 1'b1;
  assign rx_user_ready_all[7] = (RX_NUM_OF_LANES >= 8) ? rx_user_ready_7 : 1'b1;
  assign rx_rst_done_all[7] = (RX_NUM_OF_LANES >= 8) ? rx_rst_done_7 : 1'b1;
  assign rx_ip_rst_done_all[7] = (RX_NUM_OF_LANES >= 8) ? rx_ip_rst_done_7 : 1'b1;
  assign rx_data_all[((32*7)+31):(32*7)] = rx_data_7;

  generate
  if (RX_NUM_OF_LANES < 8) begin
  assign rx_ip_data_all[((8*32)-1):(RX_NUM_OF_LANES*32)] = 'd0;
  end
  endgenerate

  assign rx_ip_data_all[((RX_NUM_OF_LANES*32)-1):0] = rx_ip_data;

  assign rx_sync = rx_sync_0;

  assign rx_out_clk = rx_out_clk_0;
  assign rx_rst = rx_rst_0;
  assign rx_sof = rx_sof_0;
  assign rx_data = rx_data_all[((RX_NUM_OF_LANES*32)-1):0];

  assign rx_ip_rst = rx_ip_rst_0;
  assign rx_ip_rst_done = & rx_ip_rst_done_all;
  assign rx_ip_sysref = rx_ip_sysref_0;

  assign rx_0_p = rx_all_p[0];
  assign rx_0_n = rx_all_n[0];
  assign rx_rst_m_0 = rx_rst_0;
  assign rx_gt_rst_m_0 = rx_gt_rst_0;
  assign rx_pll_locked_m_0 = & rx_pll_locked_all;
  assign rx_user_ready_m_0 = & rx_user_ready_all;
  assign rx_rst_done_m_0 = & rx_rst_done_all;
  assign rx_clk_0 = rx_clk;
  assign rx_sysref_0 = rx_sysref;
  assign rx_ip_sof_0 = rx_ip_sof;
  assign rx_ip_data_0 = rx_ip_data_all[((32*0)+31):(32*0)];
  assign rx_ip_sync_0 = rx_ip_sync;

  assign rx_1_p = rx_all_p[1];
  assign rx_1_n = rx_all_n[1];
  assign rx_rst_m_1 = rx_rst_0;
  assign rx_gt_rst_m_1 = rx_gt_rst_0;
  assign rx_pll_locked_m_1 = & rx_pll_locked_all;
  assign rx_user_ready_m_1 = & rx_user_ready_all;
  assign rx_rst_done_m_1 = & rx_rst_done_all;
  assign rx_clk_1 = rx_clk;
  assign rx_sysref_1 = rx_sysref;
  assign rx_ip_sof_1 = rx_ip_sof;
  assign rx_ip_data_1 = rx_ip_data_all[((32*1)+31):(32*1)];
  assign rx_ip_sync_1 = rx_ip_sync;

  assign rx_2_p = rx_all_p[2];
  assign rx_2_n = rx_all_n[2];
  assign rx_rst_m_2 = rx_rst_0;
  assign rx_gt_rst_m_2 = rx_gt_rst_0;
  assign rx_pll_locked_m_2 = & rx_pll_locked_all;
  assign rx_user_ready_m_2 = & rx_user_ready_all;
  assign rx_rst_done_m_2 = & rx_rst_done_all;
  assign rx_clk_2 = rx_clk;
  assign rx_sysref_2 = rx_sysref;
  assign rx_ip_sof_2 = rx_ip_sof;
  assign rx_ip_data_2 = rx_ip_data_all[((32*2)+31):(32*2)];
  assign rx_ip_sync_2 = rx_ip_sync;

  assign rx_3_p = rx_all_p[3];
  assign rx_3_n = rx_all_n[3];
  assign rx_rst_m_3 = rx_rst_0;
  assign rx_gt_rst_m_3 = rx_gt_rst_0;
  assign rx_pll_locked_m_3 = & rx_pll_locked_all;
  assign rx_user_ready_m_3 = & rx_user_ready_all;
  assign rx_rst_done_m_3 = & rx_rst_done_all;
  assign rx_clk_3 = rx_clk;
  assign rx_sysref_3 = rx_sysref;
  assign rx_ip_sof_3 = rx_ip_sof;
  assign rx_ip_data_3 = rx_ip_data_all[((32*3)+31):(32*3)];
  assign rx_ip_sync_3 = rx_ip_sync;

  assign rx_4_p = rx_all_p[4];
  assign rx_4_n = rx_all_n[4];
  assign rx_rst_m_4 = rx_rst_0;
  assign rx_gt_rst_m_4 = rx_gt_rst_0;
  assign rx_pll_locked_m_4 = & rx_pll_locked_all;
  assign rx_user_ready_m_4 = & rx_user_ready_all;
  assign rx_rst_done_m_4 = & rx_rst_done_all;
  assign rx_clk_4 = rx_clk;
  assign rx_sysref_4 = rx_sysref;
  assign rx_ip_sof_4 = rx_ip_sof;
  assign rx_ip_data_4 = rx_ip_data_all[((32*4)+31):(32*4)];
  assign rx_ip_sync_4 = rx_ip_sync;

  assign rx_5_p = rx_all_p[5];
  assign rx_5_n = rx_all_n[5];
  assign rx_rst_m_5 = rx_rst_0;
  assign rx_gt_rst_m_5 = rx_gt_rst_0;
  assign rx_pll_locked_m_5 = & rx_pll_locked_all;
  assign rx_user_ready_m_5 = & rx_user_ready_all;
  assign rx_rst_done_m_5 = & rx_rst_done_all;
  assign rx_clk_5 = rx_clk;
  assign rx_sysref_5 = rx_sysref;
  assign rx_ip_sof_5 = rx_ip_sof;
  assign rx_ip_data_5 = rx_ip_data_all[((32*5)+31):(32*5)];
  assign rx_ip_sync_5 = rx_ip_sync;

  assign rx_6_p = rx_all_p[6];
  assign rx_6_n = rx_all_n[6];
  assign rx_rst_m_6 = rx_rst_0;
  assign rx_gt_rst_m_6 = rx_gt_rst_0;
  assign rx_pll_locked_m_6 = & rx_pll_locked_all;
  assign rx_user_ready_m_6 = & rx_user_ready_all;
  assign rx_rst_done_m_6 = & rx_rst_done_all;
  assign rx_clk_6 = rx_clk;
  assign rx_sysref_6 = rx_sysref;
  assign rx_ip_sof_6 = rx_ip_sof;
  assign rx_ip_data_6 = rx_ip_data_all[((32*6)+31):(32*6)];
  assign rx_ip_sync_6 = rx_ip_sync;

  assign rx_7_p = rx_all_p[7];
  assign rx_7_n = rx_all_n[7];
  assign rx_rst_m_7 = rx_rst_0;
  assign rx_gt_rst_m_7 = rx_gt_rst_0;
  assign rx_pll_locked_m_7 = & rx_pll_locked_all;
  assign rx_user_ready_m_7 = & rx_user_ready_all;
  assign rx_rst_done_m_7 = & rx_rst_done_all;
  assign rx_clk_7 = rx_clk;
  assign rx_sysref_7 = rx_sysref;
  assign rx_ip_sof_7 = rx_ip_sof;
  assign rx_ip_data_7 = rx_ip_data_all[((32*7)+31):(32*7)];
  assign rx_ip_sync_7 = rx_ip_sync;


  // channel interface (tx)

  assign tx_all_p[0] = tx_0_p;
  assign tx_all_n[0] = tx_0_n;
  assign tx_pll_locked_all[0] = (TX_NUM_OF_LANES >= 1) ? tx_pll_locked_0 : 1'b1;
  assign tx_user_ready_all[0] = (TX_NUM_OF_LANES >= 1) ? tx_user_ready_0 : 1'b1;
  assign tx_rst_done_all[0] = (TX_NUM_OF_LANES >= 1) ? tx_rst_done_0 : 1'b1;
  assign tx_ip_rst_done_all[0] = (TX_NUM_OF_LANES >= 1) ? tx_ip_rst_done_0 : 1'b1;
  assign tx_ip_data_all[((32*0)+31):(32*0)] = tx_ip_data_0;

  assign tx_all_p[1] = tx_1_p;
  assign tx_all_n[1] = tx_1_n;
  assign tx_pll_locked_all[1] = (TX_NUM_OF_LANES >= 2) ? tx_pll_locked_1 : 1'b1;
  assign tx_user_ready_all[1] = (TX_NUM_OF_LANES >= 2) ? tx_user_ready_1 : 1'b1;
  assign tx_rst_done_all[1] = (TX_NUM_OF_LANES >= 2) ? tx_rst_done_1 : 1'b1;
  assign tx_ip_rst_done_all[1] = (TX_NUM_OF_LANES >= 2) ? tx_ip_rst_done_1 : 1'b1;
  assign tx_ip_data_all[((32*1)+31):(32*1)] = tx_ip_data_1;

  assign tx_all_p[2] = tx_2_p;
  assign tx_all_n[2] = tx_2_n;
  assign tx_pll_locked_all[2] = (TX_NUM_OF_LANES >= 3) ? tx_pll_locked_2 : 1'b1;
  assign tx_user_ready_all[2] = (TX_NUM_OF_LANES >= 3) ? tx_user_ready_2 : 1'b1;
  assign tx_rst_done_all[2] = (TX_NUM_OF_LANES >= 3) ? tx_rst_done_2 : 1'b1;
  assign tx_ip_rst_done_all[2] = (TX_NUM_OF_LANES >= 3) ? tx_ip_rst_done_2 : 1'b1;
  assign tx_ip_data_all[((32*2)+31):(32*2)] = tx_ip_data_2;

  assign tx_all_p[3] = tx_3_p;
  assign tx_all_n[3] = tx_3_n;
  assign tx_pll_locked_all[3] = (TX_NUM_OF_LANES >= 4) ? tx_pll_locked_3 : 1'b1;
  assign tx_user_ready_all[3] = (TX_NUM_OF_LANES >= 4) ? tx_user_ready_3 : 1'b1;
  assign tx_rst_done_all[3] = (TX_NUM_OF_LANES >= 4) ? tx_rst_done_3 : 1'b1;
  assign tx_ip_rst_done_all[3] = (TX_NUM_OF_LANES >= 4) ? tx_ip_rst_done_3 : 1'b1;
  assign tx_ip_data_all[((32*3)+31):(32*3)] = tx_ip_data_3;

  assign tx_all_p[4] = tx_4_p;
  assign tx_all_n[4] = tx_4_n;
  assign tx_pll_locked_all[4] = (TX_NUM_OF_LANES >= 5) ? tx_pll_locked_4 : 1'b1;
  assign tx_user_ready_all[4] = (TX_NUM_OF_LANES >= 5) ? tx_user_ready_4 : 1'b1;
  assign tx_rst_done_all[4] = (TX_NUM_OF_LANES >= 5) ? tx_rst_done_4 : 1'b1;
  assign tx_ip_rst_done_all[4] = (TX_NUM_OF_LANES >= 5) ? tx_ip_rst_done_4 : 1'b1;
  assign tx_ip_data_all[((32*4)+31):(32*4)] = tx_ip_data_4;

  assign tx_all_p[5] = tx_5_p;
  assign tx_all_n[5] = tx_5_n;
  assign tx_pll_locked_all[5] = (TX_NUM_OF_LANES >= 6) ? tx_pll_locked_5 : 1'b1;
  assign tx_user_ready_all[5] = (TX_NUM_OF_LANES >= 6) ? tx_user_ready_5 : 1'b1;
  assign tx_rst_done_all[5] = (TX_NUM_OF_LANES >= 6) ? tx_rst_done_5 : 1'b1;
  assign tx_ip_rst_done_all[5] = (TX_NUM_OF_LANES >= 6) ? tx_ip_rst_done_5 : 1'b1;
  assign tx_ip_data_all[((32*5)+31):(32*5)] = tx_ip_data_5;

  assign tx_all_p[6] = tx_6_p;
  assign tx_all_n[6] = tx_6_n;
  assign tx_pll_locked_all[6] = (TX_NUM_OF_LANES >= 7) ? tx_pll_locked_6 : 1'b1;
  assign tx_user_ready_all[6] = (TX_NUM_OF_LANES >= 7) ? tx_user_ready_6 : 1'b1;
  assign tx_rst_done_all[6] = (TX_NUM_OF_LANES >= 7) ? tx_rst_done_6 : 1'b1;
  assign tx_ip_rst_done_all[6] = (TX_NUM_OF_LANES >= 7) ? tx_ip_rst_done_6 : 1'b1;
  assign tx_ip_data_all[((32*6)+31):(32*6)] = tx_ip_data_6;

  assign tx_all_p[7] = tx_7_p;
  assign tx_all_n[7] = tx_7_n;
  assign tx_pll_locked_all[7] = (TX_NUM_OF_LANES >= 8) ? tx_pll_locked_7 : 1'b1;
  assign tx_user_ready_all[7] = (TX_NUM_OF_LANES >= 8) ? tx_user_ready_7 : 1'b1;
  assign tx_rst_done_all[7] = (TX_NUM_OF_LANES >= 8) ? tx_rst_done_7 : 1'b1;
  assign tx_ip_rst_done_all[7] = (TX_NUM_OF_LANES >= 8) ? tx_ip_rst_done_7 : 1'b1;
  assign tx_ip_data_all[((32*7)+31):(32*7)] = tx_ip_data_7;

  generate
  if (TX_NUM_OF_LANES < 8) begin
  assign tx_data_all[((8*32)-1):(TX_NUM_OF_LANES*32)] = 'd0;
  end
  endgenerate

  assign tx_data_all[((TX_NUM_OF_LANES*32)-1):0] = tx_data;

  assign tx_p = tx_all_p[((TX_NUM_OF_LANES* 1)-1):0];
  assign tx_n = tx_all_n[((TX_NUM_OF_LANES* 1)-1):0];

  assign tx_out_clk = tx_out_clk_0;
  assign tx_rst = tx_rst_0;

  assign tx_ip_rst = tx_ip_rst_0;
  assign tx_ip_rst_done = & tx_ip_rst_done_all;
  assign tx_ip_sysref = tx_ip_sysref_0;
  assign tx_ip_sync = tx_ip_sync_0;
  assign tx_ip_data = tx_ip_data_all[((TX_NUM_OF_LANES*32)-1):0];

  assign tx_rst_m_0 = tx_rst_0;
  assign tx_gt_rst_m_0 = tx_gt_rst_0;
  assign tx_pll_locked_m_0 = & tx_pll_locked_all;
  assign tx_user_ready_m_0 = & tx_user_ready_all;
  assign tx_rst_done_m_0 = & tx_rst_done_all;
  assign tx_clk_0 = tx_clk;
  assign tx_sysref_0 = tx_sysref;
  assign tx_sync_0 = tx_sync;
  assign tx_data_0 = tx_data_all[((32*0)+31):(32*0)];

  assign tx_rst_m_1 = tx_rst_0;
  assign tx_gt_rst_m_1 = tx_gt_rst_0;
  assign tx_pll_locked_m_1 = & tx_pll_locked_all;
  assign tx_user_ready_m_1 = & tx_user_ready_all;
  assign tx_rst_done_m_1 = & tx_rst_done_all;
  assign tx_clk_1 = tx_clk;
  assign tx_sysref_1 = tx_sysref;
  assign tx_sync_1 = tx_sync;
  assign tx_data_1 = tx_data_all[((32*1)+31):(32*1)];

  assign tx_rst_m_2 = tx_rst_0;
  assign tx_gt_rst_m_2 = tx_gt_rst_0;
  assign tx_pll_locked_m_2 = & tx_pll_locked_all;
  assign tx_user_ready_m_2 = & tx_user_ready_all;
  assign tx_rst_done_m_2 = & tx_rst_done_all;
  assign tx_clk_2 = tx_clk;
  assign tx_sysref_2 = tx_sysref;
  assign tx_sync_2 = tx_sync;
  assign tx_data_2 = tx_data_all[((32*2)+31):(32*2)];

  assign tx_rst_m_3 = tx_rst_0;
  assign tx_gt_rst_m_3 = tx_gt_rst_0;
  assign tx_pll_locked_m_3 = & tx_pll_locked_all;
  assign tx_user_ready_m_3 = & tx_user_ready_all;
  assign tx_rst_done_m_3 = & tx_rst_done_all;
  assign tx_clk_3 = tx_clk;
  assign tx_sysref_3 = tx_sysref;
  assign tx_sync_3 = tx_sync;
  assign tx_data_3 = tx_data_all[((32*3)+31):(32*3)];

  assign tx_rst_m_4 = tx_rst_0;
  assign tx_gt_rst_m_4 = tx_gt_rst_0;
  assign tx_pll_locked_m_4 = & tx_pll_locked_all;
  assign tx_user_ready_m_4 = & tx_user_ready_all;
  assign tx_rst_done_m_4 = & tx_rst_done_all;
  assign tx_clk_4 = tx_clk;
  assign tx_sysref_4 = tx_sysref;
  assign tx_sync_4 = tx_sync;
  assign tx_data_4 = tx_data_all[((32*4)+31):(32*4)];

  assign tx_rst_m_5 = tx_rst_0;
  assign tx_gt_rst_m_5 = tx_gt_rst_0;
  assign tx_pll_locked_m_5 = & tx_pll_locked_all;
  assign tx_user_ready_m_5 = & tx_user_ready_all;
  assign tx_rst_done_m_5 = & tx_rst_done_all;
  assign tx_clk_5 = tx_clk;
  assign tx_sysref_5 = tx_sysref;
  assign tx_sync_5 = tx_sync;
  assign tx_data_5 = tx_data_all[((32*5)+31):(32*5)];

  assign tx_rst_m_6 = tx_rst_0;
  assign tx_gt_rst_m_6 = tx_gt_rst_0;
  assign tx_pll_locked_m_6 = & tx_pll_locked_all;
  assign tx_user_ready_m_6 = & tx_user_ready_all;
  assign tx_rst_done_m_6 = & tx_rst_done_all;
  assign tx_clk_6 = tx_clk;
  assign tx_sysref_6 = tx_sysref;
  assign tx_sync_6 = tx_sync;
  assign tx_data_6 = tx_data_all[((32*6)+31):(32*6)];

  assign tx_rst_m_7 = tx_rst_0;
  assign tx_gt_rst_m_7 = tx_gt_rst_0;
  assign tx_pll_locked_m_7 = & tx_pll_locked_all;
  assign tx_user_ready_m_7 = & tx_user_ready_all;
  assign tx_rst_done_m_7 = & tx_rst_done_all;
  assign tx_clk_7 = tx_clk;
  assign tx_sysref_7 = tx_sysref;
  assign tx_sync_7 = tx_sync;
  assign tx_data_7 = tx_data_all[((32*7)+31):(32*7)];

endmodule

// ***************************************************************************
// ***************************************************************************
