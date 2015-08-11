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

module axi_jesd_gt #(

  parameter   integer ID = 0,
  parameter   integer NUM_OF_LANES = 8,
  parameter   integer GTH_GTX_N = 0,
  parameter   integer QPLL0_ENABLE = 1,
  parameter   integer QPLL0_REFCLK_DIV = 1,
  parameter   [26:0]  QPLL0_CFG = 27'h0680181,
  parameter   integer QPLL0_FBDIV_RATIO = 1'b1,
  parameter   [ 9:0]  QPLL0_FBDIV = 10'b0000110000,
  parameter   integer QPLL1_ENABLE = 1,
  parameter   integer QPLL1_REFCLK_DIV = 1,
  parameter   [26:0]  QPLL1_CFG = 27'h0680181,
  parameter   integer QPLL1_FBDIV_RATIO = 1'b1,
  parameter   [ 9:0]  QPLL1_FBDIV = 10'b0000110000,

  parameter   [31:0]  PMA_RSV_0 = 32'h001E7080,
  parameter   integer CPLL_FBDIV_0  = 2,
  parameter   [31:0]  PMA_RSV_1 = 32'h001E7080,
  parameter   integer CPLL_FBDIV_1  = 2,
  parameter   [31:0]  PMA_RSV_2 = 32'h001E7080,
  parameter   integer CPLL_FBDIV_2  = 2,
  parameter   [31:0]  PMA_RSV_3 = 32'h001E7080,
  parameter   integer CPLL_FBDIV_3  = 2,
  parameter   [31:0]  PMA_RSV_4 = 32'h001E7080,
  parameter   integer CPLL_FBDIV_4  = 2,
  parameter   [31:0]  PMA_RSV_5 = 32'h001E7080,
  parameter   integer CPLL_FBDIV_5  = 2,
  parameter   [31:0]  PMA_RSV_6 = 32'h001E7080,
  parameter   integer CPLL_FBDIV_6  = 2,
  parameter   [31:0]  PMA_RSV_7 = 32'h001E7080,
  parameter   integer CPLL_FBDIV_7  = 2,

  parameter   integer RX_NUM_OF_LANES = 8,
  parameter   integer RX_OUT_DIV_0  = 1,
  parameter   integer RX_CLK25_DIV_0  = 20,
  parameter   integer RX_CLKBUF_ENABLE_0 = 1,
  parameter   [71:0]  RX_CDR_CFG_0  = 72'h0b000023ff10400020,
  parameter   integer RX_OUT_DIV_1  = 1,
  parameter   integer RX_CLK25_DIV_1  = 20,
  parameter   integer RX_CLKBUF_ENABLE_1 = 1,
  parameter   [71:0]  RX_CDR_CFG_1  = 72'h0b000023ff10400020,
  parameter   integer RX_OUT_DIV_2  = 1,
  parameter   integer RX_CLK25_DIV_2  = 20,
  parameter   integer RX_CLKBUF_ENABLE_2 = 1,
  parameter   [71:0]  RX_CDR_CFG_2  = 72'h0b000023ff10400020,
  parameter   integer RX_OUT_DIV_3  = 1,
  parameter   integer RX_CLK25_DIV_3  = 20,
  parameter   integer RX_CLKBUF_ENABLE_3 = 1,
  parameter   [71:0]  RX_CDR_CFG_3  = 72'h0b000023ff10400020,
  parameter   integer RX_OUT_DIV_4  = 1,
  parameter   integer RX_CLK25_DIV_4  = 20,
  parameter   integer RX_CLKBUF_ENABLE_4 = 1,
  parameter   [71:0]  RX_CDR_CFG_4  = 72'h0b000023ff10400020,
  parameter   integer RX_OUT_DIV_5  = 1,
  parameter   integer RX_CLK25_DIV_5  = 20,
  parameter   integer RX_CLKBUF_ENABLE_5 = 1,
  parameter   [71:0]  RX_CDR_CFG_5  = 72'h0b000023ff10400020,
  parameter   integer RX_OUT_DIV_6  = 1,
  parameter   integer RX_CLK25_DIV_6  = 20,
  parameter   integer RX_CLKBUF_ENABLE_6 = 1,
  parameter   [71:0]  RX_CDR_CFG_6  = 72'h0b000023ff10400020,
  parameter   integer RX_OUT_DIV_7  = 1,
  parameter   integer RX_CLK25_DIV_7  = 20,
  parameter   integer RX_CLKBUF_ENABLE_7 = 1,
  parameter   [71:0]  RX_CDR_CFG_7  = 72'h0b000023ff10400020,

  parameter   integer TX_NUM_OF_LANES = 8,
  parameter   integer TX_OUT_DIV_0  = 1,
  parameter   integer TX_CLK25_DIV_0  = 20,
  parameter   integer TX_CLKBUF_ENABLE_0 = 1,
  parameter   integer TX_DATA_SEL_0 = 0,
  parameter   integer TX_OUT_DIV_1  = 1,
  parameter   integer TX_CLK25_DIV_1  = 20,
  parameter   integer TX_CLKBUF_ENABLE_1 = 1,
  parameter   integer TX_DATA_SEL_1 = 1,
  parameter   integer TX_OUT_DIV_2  = 1,
  parameter   integer TX_CLK25_DIV_2  = 20,
  parameter   integer TX_CLKBUF_ENABLE_2 = 1,
  parameter   integer TX_DATA_SEL_2 = 2,
  parameter   integer TX_OUT_DIV_3  = 1,
  parameter   integer TX_CLK25_DIV_3  = 20,
  parameter   integer TX_CLKBUF_ENABLE_3 = 1,
  parameter   integer TX_DATA_SEL_3 = 3,
  parameter   integer TX_OUT_DIV_4  = 1,
  parameter   integer TX_CLK25_DIV_4  = 20,
  parameter   integer TX_CLKBUF_ENABLE_4 = 1,
  parameter   integer TX_DATA_SEL_4 = 4,
  parameter   integer TX_OUT_DIV_5  = 1,
  parameter   integer TX_CLK25_DIV_5  = 20,
  parameter   integer TX_CLKBUF_ENABLE_5 = 1,
  parameter   integer TX_DATA_SEL_5 = 5,
  parameter   integer TX_OUT_DIV_6  = 1,
  parameter   integer TX_CLK25_DIV_6  = 20,
  parameter   integer TX_CLKBUF_ENABLE_6 = 1,
  parameter   integer TX_DATA_SEL_6 = 6,
  parameter   integer TX_OUT_DIV_7  = 1,
  parameter   integer TX_CLK25_DIV_7  = 20,
  parameter   integer TX_CLKBUF_ENABLE_7 = 1,
  parameter   integer TX_DATA_SEL_7 = 7)

 (

  // pll clocks

  input                                       qpll0_rst,
  input                                       qpll0_ref_clk_in,
  input                                       qpll1_rst,
  input                                       qpll1_ref_clk_in,

  // pll resets

  output                                      pll_rst_0,
  input                                       cpll_rst_m_0,
  input                                       cpll_ref_clk_in_0,
  output                                      pll_rst_1,
  input                                       cpll_rst_m_1,
  input                                       cpll_ref_clk_in_1,
  output                                      pll_rst_2,
  input                                       cpll_rst_m_2,
  input                                       cpll_ref_clk_in_2,
  output                                      pll_rst_3,
  input                                       cpll_rst_m_3,
  input                                       cpll_ref_clk_in_3,
  output                                      pll_rst_4,
  input                                       cpll_rst_m_4,
  input                                       cpll_ref_clk_in_4,
  output                                      pll_rst_5,
  input                                       cpll_rst_m_5,
  input                                       cpll_ref_clk_in_5,
  output                                      pll_rst_6,
  input                                       cpll_rst_m_6,
  input                                       cpll_ref_clk_in_6,
  output                                      pll_rst_7,
  input                                       cpll_rst_m_7,
  input                                       cpll_ref_clk_in_7,

  // channel interface (rx)

  input                                       rx_0_p,
  input                                       rx_0_n,
  output                                      rx_rst_0,
  input                                       rx_rst_m_0,
  output                                      rx_gt_rst_0,
  input                                       rx_gt_rst_m_0,
  output                                      rx_pll_locked_0,
  input                                       rx_pll_locked_m_0,
  output                                      rx_user_ready_0,
  input                                       rx_user_ready_m_0,
  output                                      rx_rst_done_0,
  input                                       rx_rst_done_m_0,
  output                                      rx_out_clk_0,
  input                                       rx_clk_0,
  input                                       rx_sysref_0,
  output                                      rx_sync_0,
  output                                      rx_sof_0,
  output  [31:0]                              rx_data_0,
  output  [ 3:0]                              rx_gt_charisk_0,
  output  [ 3:0]                              rx_gt_disperr_0,
  output  [ 3:0]                              rx_gt_notintable_0,
  output  [31:0]                              rx_gt_data_0,
  input                                       rx_gt_comma_align_enb_0,
  output  [ 3:0]                              rx_gt_ilas_f_0,
  output  [ 3:0]                              rx_gt_ilas_q_0,
  output  [ 3:0]                              rx_gt_ilas_a_0,
  output  [ 3:0]                              rx_gt_ilas_r_0,
  output  [ 3:0]                              rx_gt_cgs_k_0,
  output                                      rx_ip_rst_0,
  input   [ 3:0]                              rx_ip_sof_0,
  input   [31:0]                              rx_ip_data_0,
  output                                      rx_ip_sysref_0,
  input                                       rx_ip_sync_0,
  output                                      rx_ip_rst_done_0,

  input                                       rx_1_p,
  input                                       rx_1_n,
  output                                      rx_rst_1,
  input                                       rx_rst_m_1,
  output                                      rx_gt_rst_1,
  input                                       rx_gt_rst_m_1,
  output                                      rx_pll_locked_1,
  input                                       rx_pll_locked_m_1,
  output                                      rx_user_ready_1,
  input                                       rx_user_ready_m_1,
  output                                      rx_rst_done_1,
  input                                       rx_rst_done_m_1,
  output                                      rx_out_clk_1,
  input                                       rx_clk_1,
  input                                       rx_sysref_1,
  output                                      rx_sync_1,
  output                                      rx_sof_1,
  output  [31:0]                              rx_data_1,
  output  [ 3:0]                              rx_gt_charisk_1,
  output  [ 3:0]                              rx_gt_disperr_1,
  output  [ 3:0]                              rx_gt_notintable_1,
  output  [31:0]                              rx_gt_data_1,
  input                                       rx_gt_comma_align_enb_1,
  output  [ 3:0]                              rx_gt_ilas_f_1,
  output  [ 3:0]                              rx_gt_ilas_q_1,
  output  [ 3:0]                              rx_gt_ilas_a_1,
  output  [ 3:0]                              rx_gt_ilas_r_1,
  output  [ 3:0]                              rx_gt_cgs_k_1,
  output                                      rx_ip_rst_1,
  input   [ 3:0]                              rx_ip_sof_1,
  input   [31:0]                              rx_ip_data_1,
  output                                      rx_ip_sysref_1,
  input                                       rx_ip_sync_1,
  output                                      rx_ip_rst_done_1,

  input                                       rx_2_p,
  input                                       rx_2_n,
  output                                      rx_rst_2,
  input                                       rx_rst_m_2,
  output                                      rx_gt_rst_2,
  input                                       rx_gt_rst_m_2,
  output                                      rx_pll_locked_2,
  input                                       rx_pll_locked_m_2,
  output                                      rx_user_ready_2,
  input                                       rx_user_ready_m_2,
  output                                      rx_rst_done_2,
  input                                       rx_rst_done_m_2,
  output                                      rx_out_clk_2,
  input                                       rx_clk_2,
  input                                       rx_sysref_2,
  output                                      rx_sync_2,
  output                                      rx_sof_2,
  output  [31:0]                              rx_data_2,
  output  [ 3:0]                              rx_gt_charisk_2,
  output  [ 3:0]                              rx_gt_disperr_2,
  output  [ 3:0]                              rx_gt_notintable_2,
  output  [31:0]                              rx_gt_data_2,
  input                                       rx_gt_comma_align_enb_2,
  output  [ 3:0]                              rx_gt_ilas_f_2,
  output  [ 3:0]                              rx_gt_ilas_q_2,
  output  [ 3:0]                              rx_gt_ilas_a_2,
  output  [ 3:0]                              rx_gt_ilas_r_2,
  output  [ 3:0]                              rx_gt_cgs_k_2,
  output                                      rx_ip_rst_2,
  input   [ 3:0]                              rx_ip_sof_2,
  input   [31:0]                              rx_ip_data_2,
  output                                      rx_ip_sysref_2,
  input                                       rx_ip_sync_2,
  output                                      rx_ip_rst_done_2,

  input                                       rx_3_p,
  input                                       rx_3_n,
  output                                      rx_rst_3,
  input                                       rx_rst_m_3,
  output                                      rx_gt_rst_3,
  input                                       rx_gt_rst_m_3,
  output                                      rx_pll_locked_3,
  input                                       rx_pll_locked_m_3,
  output                                      rx_user_ready_3,
  input                                       rx_user_ready_m_3,
  output                                      rx_rst_done_3,
  input                                       rx_rst_done_m_3,
  output                                      rx_out_clk_3,
  input                                       rx_clk_3,
  input                                       rx_sysref_3,
  output                                      rx_sync_3,
  output                                      rx_sof_3,
  output  [31:0]                              rx_data_3,
  output  [ 3:0]                              rx_gt_charisk_3,
  output  [ 3:0]                              rx_gt_disperr_3,
  output  [ 3:0]                              rx_gt_notintable_3,
  output  [31:0]                              rx_gt_data_3,
  input                                       rx_gt_comma_align_enb_3,
  output  [ 3:0]                              rx_gt_ilas_f_3,
  output  [ 3:0]                              rx_gt_ilas_q_3,
  output  [ 3:0]                              rx_gt_ilas_a_3,
  output  [ 3:0]                              rx_gt_ilas_r_3,
  output  [ 3:0]                              rx_gt_cgs_k_3,
  output                                      rx_ip_rst_3,
  input   [ 3:0]                              rx_ip_sof_3,
  input   [31:0]                              rx_ip_data_3,
  output                                      rx_ip_sysref_3,
  input                                       rx_ip_sync_3,
  output                                      rx_ip_rst_done_3,

  input                                       rx_4_p,
  input                                       rx_4_n,
  output                                      rx_rst_4,
  input                                       rx_rst_m_4,
  output                                      rx_gt_rst_4,
  input                                       rx_gt_rst_m_4,
  output                                      rx_pll_locked_4,
  input                                       rx_pll_locked_m_4,
  output                                      rx_user_ready_4,
  input                                       rx_user_ready_m_4,
  output                                      rx_rst_done_4,
  input                                       rx_rst_done_m_4,
  output                                      rx_out_clk_4,
  input                                       rx_clk_4,
  input                                       rx_sysref_4,
  output                                      rx_sync_4,
  output                                      rx_sof_4,
  output  [31:0]                              rx_data_4,
  output  [ 3:0]                              rx_gt_charisk_4,
  output  [ 3:0]                              rx_gt_disperr_4,
  output  [ 3:0]                              rx_gt_notintable_4,
  output  [31:0]                              rx_gt_data_4,
  input                                       rx_gt_comma_align_enb_4,
  output  [ 3:0]                              rx_gt_ilas_f_4,
  output  [ 3:0]                              rx_gt_ilas_q_4,
  output  [ 3:0]                              rx_gt_ilas_a_4,
  output  [ 3:0]                              rx_gt_ilas_r_4,
  output  [ 3:0]                              rx_gt_cgs_k_4,
  output                                      rx_ip_rst_4,
  input   [ 3:0]                              rx_ip_sof_4,
  input   [31:0]                              rx_ip_data_4,
  output                                      rx_ip_sysref_4,
  input                                       rx_ip_sync_4,
  output                                      rx_ip_rst_done_4,

  input                                       rx_5_p,
  input                                       rx_5_n,
  output                                      rx_rst_5,
  input                                       rx_rst_m_5,
  output                                      rx_gt_rst_5,
  input                                       rx_gt_rst_m_5,
  output                                      rx_pll_locked_5,
  input                                       rx_pll_locked_m_5,
  output                                      rx_user_ready_5,
  input                                       rx_user_ready_m_5,
  output                                      rx_rst_done_5,
  input                                       rx_rst_done_m_5,
  output                                      rx_out_clk_5,
  input                                       rx_clk_5,
  input                                       rx_sysref_5,
  output                                      rx_sync_5,
  output                                      rx_sof_5,
  output  [31:0]                              rx_data_5,
  output  [ 3:0]                              rx_gt_charisk_5,
  output  [ 3:0]                              rx_gt_disperr_5,
  output  [ 3:0]                              rx_gt_notintable_5,
  output  [31:0]                              rx_gt_data_5,
  input                                       rx_gt_comma_align_enb_5,
  output  [ 3:0]                              rx_gt_ilas_f_5,
  output  [ 3:0]                              rx_gt_ilas_q_5,
  output  [ 3:0]                              rx_gt_ilas_a_5,
  output  [ 3:0]                              rx_gt_ilas_r_5,
  output  [ 3:0]                              rx_gt_cgs_k_5,
  output                                      rx_ip_rst_5,
  input   [ 3:0]                              rx_ip_sof_5,
  input   [31:0]                              rx_ip_data_5,
  output                                      rx_ip_sysref_5,
  input                                       rx_ip_sync_5,
  output                                      rx_ip_rst_done_5,

  input                                       rx_6_p,
  input                                       rx_6_n,
  output                                      rx_rst_6,
  input                                       rx_rst_m_6,
  output                                      rx_gt_rst_6,
  input                                       rx_gt_rst_m_6,
  output                                      rx_pll_locked_6,
  input                                       rx_pll_locked_m_6,
  output                                      rx_user_ready_6,
  input                                       rx_user_ready_m_6,
  output                                      rx_rst_done_6,
  input                                       rx_rst_done_m_6,
  output                                      rx_out_clk_6,
  input                                       rx_clk_6,
  input                                       rx_sysref_6,
  output                                      rx_sync_6,
  output                                      rx_sof_6,
  output  [31:0]                              rx_data_6,
  output  [ 3:0]                              rx_gt_charisk_6,
  output  [ 3:0]                              rx_gt_disperr_6,
  output  [ 3:0]                              rx_gt_notintable_6,
  output  [31:0]                              rx_gt_data_6,
  input                                       rx_gt_comma_align_enb_6,
  output  [ 3:0]                              rx_gt_ilas_f_6,
  output  [ 3:0]                              rx_gt_ilas_q_6,
  output  [ 3:0]                              rx_gt_ilas_a_6,
  output  [ 3:0]                              rx_gt_ilas_r_6,
  output  [ 3:0]                              rx_gt_cgs_k_6,
  output                                      rx_ip_rst_6,
  input   [ 3:0]                              rx_ip_sof_6,
  input   [31:0]                              rx_ip_data_6,
  output                                      rx_ip_sysref_6,
  input                                       rx_ip_sync_6,
  output                                      rx_ip_rst_done_6,

  input                                       rx_7_p,
  input                                       rx_7_n,
  output                                      rx_rst_7,
  input                                       rx_rst_m_7,
  output                                      rx_gt_rst_7,
  input                                       rx_gt_rst_m_7,
  output                                      rx_pll_locked_7,
  input                                       rx_pll_locked_m_7,
  output                                      rx_user_ready_7,
  input                                       rx_user_ready_m_7,
  output                                      rx_rst_done_7,
  input                                       rx_rst_done_m_7,
  output                                      rx_out_clk_7,
  input                                       rx_clk_7,
  input                                       rx_sysref_7,
  output                                      rx_sync_7,
  output                                      rx_sof_7,
  output  [31:0]                              rx_data_7,
  output  [ 3:0]                              rx_gt_charisk_7,
  output  [ 3:0]                              rx_gt_disperr_7,
  output  [ 3:0]                              rx_gt_notintable_7,
  output  [31:0]                              rx_gt_data_7,
  input                                       rx_gt_comma_align_enb_7,
  output  [ 3:0]                              rx_gt_ilas_f_7,
  output  [ 3:0]                              rx_gt_ilas_q_7,
  output  [ 3:0]                              rx_gt_ilas_a_7,
  output  [ 3:0]                              rx_gt_ilas_r_7,
  output  [ 3:0]                              rx_gt_cgs_k_7,
  output                                      rx_ip_rst_7,
  input   [ 3:0]                              rx_ip_sof_7,
  input   [31:0]                              rx_ip_data_7,
  output                                      rx_ip_sysref_7,
  input                                       rx_ip_sync_7,
  output                                      rx_ip_rst_done_7,

  // channel interface (tx)

  output                                      tx_0_p,
  output                                      tx_0_n,
  output                                      tx_rst_0,
  input                                       tx_rst_m_0,
  output                                      tx_gt_rst_0,
  input                                       tx_gt_rst_m_0,
  output                                      tx_pll_locked_0,
  input                                       tx_pll_locked_m_0,
  output                                      tx_user_ready_0,
  input                                       tx_user_ready_m_0,
  output                                      tx_rst_done_0,
  input                                       tx_rst_done_m_0,
  output                                      tx_out_clk_0,
  input                                       tx_clk_0,
  input                                       tx_sysref_0,
  input                                       tx_sync_0,
  input   [31:0]                              tx_data_0,
  input   [ 3:0]                              tx_gt_charisk_0,
  input   [31:0]                              tx_gt_data_0,
  output                                      tx_ip_rst_0,
  output  [31:0]                              tx_ip_data_0,
  output                                      tx_ip_sysref_0,
  output                                      tx_ip_sync_0,
  output                                      tx_ip_rst_done_0,

  output                                      tx_1_p,
  output                                      tx_1_n,
  output                                      tx_rst_1,
  input                                       tx_rst_m_1,
  output                                      tx_gt_rst_1,
  input                                       tx_gt_rst_m_1,
  output                                      tx_pll_locked_1,
  input                                       tx_pll_locked_m_1,
  output                                      tx_user_ready_1,
  input                                       tx_user_ready_m_1,
  output                                      tx_rst_done_1,
  input                                       tx_rst_done_m_1,
  output                                      tx_out_clk_1,
  input                                       tx_clk_1,
  input                                       tx_sysref_1,
  input                                       tx_sync_1,
  input   [31:0]                              tx_data_1,
  input   [ 3:0]                              tx_gt_charisk_1,
  input   [31:0]                              tx_gt_data_1,
  output                                      tx_ip_rst_1,
  output  [31:0]                              tx_ip_data_1,
  output                                      tx_ip_sysref_1,
  output                                      tx_ip_sync_1,
  output                                      tx_ip_rst_done_1,

  output                                      tx_2_p,
  output                                      tx_2_n,
  output                                      tx_rst_2,
  input                                       tx_rst_m_2,
  output                                      tx_gt_rst_2,
  input                                       tx_gt_rst_m_2,
  output                                      tx_pll_locked_2,
  input                                       tx_pll_locked_m_2,
  output                                      tx_user_ready_2,
  input                                       tx_user_ready_m_2,
  output                                      tx_rst_done_2,
  input                                       tx_rst_done_m_2,
  output                                      tx_out_clk_2,
  input                                       tx_clk_2,
  input                                       tx_sysref_2,
  input                                       tx_sync_2,
  input   [31:0]                              tx_data_2,
  input   [ 3:0]                              tx_gt_charisk_2,
  input   [31:0]                              tx_gt_data_2,
  output                                      tx_ip_rst_2,
  output  [31:0]                              tx_ip_data_2,
  output                                      tx_ip_sysref_2,
  output                                      tx_ip_sync_2,
  output                                      tx_ip_rst_done_2,

  output                                      tx_3_p,
  output                                      tx_3_n,
  output                                      tx_rst_3,
  input                                       tx_rst_m_3,
  output                                      tx_gt_rst_3,
  input                                       tx_gt_rst_m_3,
  output                                      tx_pll_locked_3,
  input                                       tx_pll_locked_m_3,
  output                                      tx_user_ready_3,
  input                                       tx_user_ready_m_3,
  output                                      tx_rst_done_3,
  input                                       tx_rst_done_m_3,
  output                                      tx_out_clk_3,
  input                                       tx_clk_3,
  input                                       tx_sysref_3,
  input                                       tx_sync_3,
  input   [31:0]                              tx_data_3,
  input   [ 3:0]                              tx_gt_charisk_3,
  input   [31:0]                              tx_gt_data_3,
  output                                      tx_ip_rst_3,
  output  [31:0]                              tx_ip_data_3,
  output                                      tx_ip_sysref_3,
  output                                      tx_ip_sync_3,
  output                                      tx_ip_rst_done_3,

  output                                      tx_4_p,
  output                                      tx_4_n,
  output                                      tx_rst_4,
  input                                       tx_rst_m_4,
  output                                      tx_gt_rst_4,
  input                                       tx_gt_rst_m_4,
  output                                      tx_pll_locked_4,
  input                                       tx_pll_locked_m_4,
  output                                      tx_user_ready_4,
  input                                       tx_user_ready_m_4,
  output                                      tx_rst_done_4,
  input                                       tx_rst_done_m_4,
  output                                      tx_out_clk_4,
  input                                       tx_clk_4,
  input                                       tx_sysref_4,
  input                                       tx_sync_4,
  input   [31:0]                              tx_data_4,
  input   [ 3:0]                              tx_gt_charisk_4,
  input   [31:0]                              tx_gt_data_4,
  output                                      tx_ip_rst_4,
  output  [31:0]                              tx_ip_data_4,
  output                                      tx_ip_sysref_4,
  output                                      tx_ip_sync_4,
  output                                      tx_ip_rst_done_4,

  output                                      tx_5_p,
  output                                      tx_5_n,
  output                                      tx_rst_5,
  input                                       tx_rst_m_5,
  output                                      tx_gt_rst_5,
  input                                       tx_gt_rst_m_5,
  output                                      tx_pll_locked_5,
  input                                       tx_pll_locked_m_5,
  output                                      tx_user_ready_5,
  input                                       tx_user_ready_m_5,
  output                                      tx_rst_done_5,
  input                                       tx_rst_done_m_5,
  output                                      tx_out_clk_5,
  input                                       tx_clk_5,
  input                                       tx_sysref_5,
  input                                       tx_sync_5,
  input   [31:0]                              tx_data_5,
  input   [ 3:0]                              tx_gt_charisk_5,
  input   [31:0]                              tx_gt_data_5,
  output                                      tx_ip_rst_5,
  output  [31:0]                              tx_ip_data_5,
  output                                      tx_ip_sysref_5,
  output                                      tx_ip_sync_5,
  output                                      tx_ip_rst_done_5,

  output                                      tx_6_p,
  output                                      tx_6_n,
  output                                      tx_rst_6,
  input                                       tx_rst_m_6,
  output                                      tx_gt_rst_6,
  input                                       tx_gt_rst_m_6,
  output                                      tx_pll_locked_6,
  input                                       tx_pll_locked_m_6,
  output                                      tx_user_ready_6,
  input                                       tx_user_ready_m_6,
  output                                      tx_rst_done_6,
  input                                       tx_rst_done_m_6,
  output                                      tx_out_clk_6,
  input                                       tx_clk_6,
  input                                       tx_sysref_6,
  input                                       tx_sync_6,
  input   [31:0]                              tx_data_6,
  input   [ 3:0]                              tx_gt_charisk_6,
  input   [31:0]                              tx_gt_data_6,
  output                                      tx_ip_rst_6,
  output  [31:0]                              tx_ip_data_6,
  output                                      tx_ip_sysref_6,
  output                                      tx_ip_sync_6,
  output                                      tx_ip_rst_done_6,

  output                                      tx_7_p,
  output                                      tx_7_n,
  output                                      tx_rst_7,
  input                                       tx_rst_m_7,
  output                                      tx_gt_rst_7,
  input                                       tx_gt_rst_m_7,
  output                                      tx_pll_locked_7,
  input                                       tx_pll_locked_m_7,
  output                                      tx_user_ready_7,
  input                                       tx_user_ready_m_7,
  output                                      tx_rst_done_7,
  input                                       tx_rst_done_m_7,
  output                                      tx_out_clk_7,
  input                                       tx_clk_7,
  input                                       tx_sysref_7,
  input                                       tx_sync_7,
  input   [31:0]                              tx_data_7,
  input   [ 3:0]                              tx_gt_charisk_7,
  input   [31:0]                              tx_gt_data_7,
  output                                      tx_ip_rst_7,
  output  [31:0]                              tx_ip_data_7,
  output                                      tx_ip_sysref_7,
  output                                      tx_ip_sync_7,
  output                                      tx_ip_rst_done_7,

  // axi - clock & reset

  input                                       axi_aclk,
  input                                       axi_aresetn,

  // axi interface

  input                                       s_axi_awvalid,
  input   [ 31:0]                             s_axi_awaddr,
  output                                      s_axi_awready,
  input                                       s_axi_wvalid,
  input   [ 31:0]                             s_axi_wdata,
  input   [  3:0]                             s_axi_wstrb,
  output                                      s_axi_wready,
  output                                      s_axi_bvalid,
  output  [  1:0]                             s_axi_bresp,
  input                                       s_axi_bready,
  input                                       s_axi_arvalid,
  input   [ 31:0]                             s_axi_araddr,
  output                                      s_axi_arready,
  output                                      s_axi_rvalid,
  output  [ 31:0]                             s_axi_rdata,
  output  [  1:0]                             s_axi_rresp,
  input                                       s_axi_rready,

  // master interface

  output                                      m_axi_awvalid,
  output  [ 31:0]                             m_axi_awaddr,
  output  [  2:0]                             m_axi_awprot,
  input                                       m_axi_awready,
  output                                      m_axi_wvalid,
  output  [ 31:0]                             m_axi_wdata,
  output  [  3:0]                             m_axi_wstrb,
  input                                       m_axi_wready,
  input                                       m_axi_bvalid,
  input   [  1:0]                             m_axi_bresp,
  output                                      m_axi_bready,
  output                                      m_axi_arvalid,
  output  [ 31:0]                             m_axi_araddr,
  output  [  2:0]                             m_axi_arprot,
  input                                       m_axi_arready,
  input                                       m_axi_rvalid,
  input   [ 31:0]                             m_axi_rdata,
  input   [  1:0]                             m_axi_rresp,
  output                                      m_axi_rready);

  // post-processing
  
  localparam  [31:0]  PMA_RSV[7:0] = {PMA_RSV_7, PMA_RSV_6, PMA_RSV_5, PMA_RSV_4,
    PMA_RSV_3, PMA_RSV_2, PMA_RSV_1, PMA_RSV_0};
  localparam  integer CPLL_FBDIV[7:0] = {CPLL_FBDIV_7, CPLL_FBDIV_6, CPLL_FBDIV_5, CPLL_FBDIV_4,
    CPLL_FBDIV_3, CPLL_FBDIV_2, CPLL_FBDIV_1, CPLL_FBDIV_0};

  localparam  integer RX_OUT_DIV[7:0] = {RX_OUT_DIV_7, RX_OUT_DIV_6, RX_OUT_DIV_5,
    RX_OUT_DIV_4, RX_OUT_DIV_3, RX_OUT_DIV_2, RX_OUT_DIV_1, RX_OUT_DIV_0};
  localparam  integer RX_CLK25_DIV[7:0] = {RX_CLK25_DIV_7, RX_CLK25_DIV_6, RX_CLK25_DIV_5,
    RX_CLK25_DIV_4, RX_CLK25_DIV_3, RX_CLK25_DIV_2, RX_CLK25_DIV_1, RX_CLK25_DIV_0};
  localparam  integer RX_CLKBUF_ENABLE[7:0] = {RX_CLKBUF_ENABLE_7, RX_CLKBUF_ENABLE_6,
    RX_CLKBUF_ENABLE_5, RX_CLKBUF_ENABLE_4, RX_CLKBUF_ENABLE_3,
    RX_CLKBUF_ENABLE_2, RX_CLKBUF_ENABLE_1, RX_CLKBUF_ENABLE_0};
  localparam  [71:0] RX_CDR_CFG[7:0] = {RX_CDR_CFG_7, RX_CDR_CFG_6, RX_CDR_CFG_5,
    RX_CDR_CFG_4, RX_CDR_CFG_3, RX_CDR_CFG_2, RX_CDR_CFG_1, RX_CDR_CFG_0};

  localparam  integer TX_OUT_DIV[7:0] = {TX_OUT_DIV_7, TX_OUT_DIV_6, TX_OUT_DIV_5,
    TX_OUT_DIV_4, TX_OUT_DIV_3, TX_OUT_DIV_2, TX_OUT_DIV_1, TX_OUT_DIV_0};
  localparam  integer TX_CLK25_DIV[7:0] = {TX_CLK25_DIV_7, TX_CLK25_DIV_6, TX_CLK25_DIV_5,
    TX_CLK25_DIV_4, TX_CLK25_DIV_3, TX_CLK25_DIV_2, TX_CLK25_DIV_1, TX_CLK25_DIV_0};
  localparam  integer TX_CLKBUF_ENABLE[7:0] = {TX_CLKBUF_ENABLE_7, TX_CLKBUF_ENABLE_6,
    TX_CLKBUF_ENABLE_5, TX_CLKBUF_ENABLE_4, TX_CLKBUF_ENABLE_3,
    TX_CLKBUF_ENABLE_2, TX_CLKBUF_ENABLE_1, TX_CLKBUF_ENABLE_0};
  localparam  integer TX_DATA_SEL[7:0] = {TX_DATA_SEL_7, TX_DATA_SEL_6, TX_DATA_SEL_5,
    TX_DATA_SEL_4, TX_DATA_SEL_3, TX_DATA_SEL_2, TX_DATA_SEL_1, TX_DATA_SEL_0};

  // internal registers

  reg                                         up_wack_d = 'd0;
  reg                                         up_rack_d = 'd0;
  reg     [ 31:0]                             up_rdata_d = 'd0;

  // internal signals

  wire    [(( 1*8)-1):0]                      qpll_clk;
  wire    [(( 1*8)-1):0]                      qpll_ref_clk;
  wire    [(( 1*8)-1):0]                      qpll_locked;
  wire    [(( 1*8)-1):0]                      pll_rst;
  wire    [(( 1*8)-1):0]                      cpll_rst_m;
  wire    [(( 1*8)-1):0]                      cpll_ref_clk_in;
  wire    [(( 1*8)-1):0]                      rx_p;
  wire    [(( 1*8)-1):0]                      rx_n;
  wire    [(( 1*8)-1):0]                      rx_out_clk;
  wire    [(( 1*8)-1):0]                      rx_clk;
  wire    [(( 1*8)-1):0]                      rx_rst;
  wire    [(( 1*8)-1):0]                      rx_sof;
  wire    [((32*8)-1):0]                      rx_data;
  wire    [(( 1*8)-1):0]                      rx_sysref;
  wire    [(( 1*8)-1):0]                      rx_sync;
  wire    [(( 4*8)-1):0]                      rx_gt_charisk;
  wire    [(( 4*8)-1):0]                      rx_gt_disperr;
  wire    [(( 4*8)-1):0]                      rx_gt_notintable;
  wire    [((32*8)-1):0]                      rx_gt_data;
  wire    [(( 1*8)-1):0]                      rx_gt_comma_align_enb;
  wire    [(( 4*8)-1):0]                      rx_gt_ilas_f;
  wire    [(( 4*8)-1):0]                      rx_gt_ilas_q;
  wire    [(( 4*8)-1):0]                      rx_gt_ilas_a;
  wire    [(( 4*8)-1):0]                      rx_gt_ilas_r;
  wire    [(( 4*8)-1):0]                      rx_gt_cgs_k;
  wire    [(( 1*8)-1):0]                      rx_ip_rst;
  wire    [(( 4*8)-1):0]                      rx_ip_sof;
  wire    [((32*8)-1):0]                      rx_ip_data;
  wire    [(( 1*8)-1):0]                      rx_ip_sysref;
  wire    [(( 1*8)-1):0]                      rx_ip_sync;
  wire    [(( 1*8)-1):0]                      rx_ip_rst_done;
  wire    [(( 1*8)-1):0]                      rx_rst_m;
  wire    [(( 1*8)-1):0]                      rx_gt_rst;
  wire    [(( 1*8)-1):0]                      rx_gt_rst_m;
  wire    [(( 1*8)-1):0]                      rx_user_ready;
  wire    [(( 1*8)-1):0]                      rx_rst_done_m;
  wire    [(( 1*8)-1):0]                      rx_pll_locked_m;
  wire    [(( 1*8)-1):0]                      rx_user_ready_m;
  wire    [(( 1*8)-1):0]                      rx_rst_done;
  wire    [(( 1*8)-1):0]                      rx_pll_locked;
  wire    [(( 1*8)-1):0]                      tx_p;
  wire    [(( 1*8)-1):0]                      tx_n;
  wire    [(( 1*8)-1):0]                      tx_out_clk;
  wire    [(( 1*8)-1):0]                      tx_clk;
  wire    [(( 1*8)-1):0]                      tx_rst;
  wire    [((32*8)-1):0]                      tx_data;
  wire    [(( 1*8)-1):0]                      tx_sysref;
  wire    [(( 1*8)-1):0]                      tx_sync;
  wire    [(( 4*8)-1):0]                      tx_gt_charisk;
  wire    [((32*8)-1):0]                      tx_gt_data;
  wire    [(( 1*8)-1):0]                      tx_ip_rst;
  wire    [((32*8)-1):0]                      tx_ip_data;
  wire    [(( 1*8)-1):0]                      tx_ip_sysref;
  wire    [(( 1*8)-1):0]                      tx_ip_sync;
  wire    [(( 1*8)-1):0]                      tx_ip_rst_done;
  wire    [(( 1*8)-1):0]                      tx_rst_m;
  wire    [(( 1*8)-1):0]                      tx_gt_rst;
  wire    [(( 1*8)-1):0]                      tx_gt_rst_m;
  wire    [(( 1*8)-1):0]                      tx_user_ready;
  wire    [(( 1*8)-1):0]                      tx_rst_done_m;
  wire    [(( 1*8)-1):0]                      tx_pll_locked_m;
  wire    [(( 1*8)-1):0]                      tx_user_ready_m;
  wire    [(( 1*8)-1):0]                      tx_rst_done;
  wire    [(( 1*8)-1):0]                      tx_pll_locked;
  wire                                        up_rstn;
  wire                                        up_clk;
  wire                                        up_wreq;
  wire    [((14*1)-1):0]                      up_waddr;
  wire    [((32*1)-1):0]                      up_wdata;
  wire    [(( 1*9)-1):0]                      up_wack;
  wire                                        up_rreq;
  wire    [((14*1)-1):0]                      up_raddr;
  wire    [((32*9)-1):0]                      up_rdata;
  wire    [(( 1*9)-1):0]                      up_rack;
  wire    [(( 1*8)-1):0]                      up_es_dma_req;
  wire    [((32*8)-1):0]                      up_es_dma_addr;
  wire    [((32*8)-1):0]                      up_es_dma_data;
  wire    [(( 1*8)-1):0]                      up_es_dma_ack;
  wire    [(( 1*8)-1):0]                      up_es_dma_err;

  // signal name changes

  assign up_rstn = axi_aresetn;
  assign up_clk = axi_aclk;

  // pll 

  assign pll_rst_0 = pll_rst[0];
  assign cpll_rst_m[0] = cpll_rst_m_0;
  assign cpll_ref_clk_in[0] = cpll_ref_clk_in_0; 

  assign pll_rst_1 = pll_rst[1];
  assign cpll_rst_m[1] = cpll_rst_m_1;
  assign cpll_ref_clk_in[1] = cpll_ref_clk_in_1;

  assign pll_rst_2 = pll_rst[2];
  assign cpll_rst_m[2] = cpll_rst_m_2;
  assign cpll_ref_clk_in[2] = cpll_ref_clk_in_2;

  assign pll_rst_3 = pll_rst[3];
  assign cpll_rst_m[3] = cpll_rst_m_3;
  assign cpll_ref_clk_in[3] = cpll_ref_clk_in_3;

  assign pll_rst_4 = pll_rst[4];
  assign cpll_rst_m[4] = cpll_rst_m_4;
  assign cpll_ref_clk_in[4] = cpll_ref_clk_in_4;

  assign pll_rst_5 = pll_rst[5];
  assign cpll_rst_m[5] = cpll_rst_m_5;
  assign cpll_ref_clk_in[5] = cpll_ref_clk_in_5;

  assign pll_rst_6 = pll_rst[6];
  assign cpll_rst_m[6] = cpll_rst_m_6;
  assign cpll_ref_clk_in[6] = cpll_ref_clk_in_6;

  assign pll_rst_7 = pll_rst[7];
  assign cpll_rst_m[7] = cpll_rst_m_7;
  assign cpll_ref_clk_in[7] = cpll_ref_clk_in_7;

  // split-up interfaces

  assign rx_out_clk_0 = rx_out_clk[0];
  assign rx_rst_0 = rx_rst[0];
  assign rx_sof_0 = rx_sof[0];
  assign rx_data_0 = rx_data[((32*0)+31):(32*0)];
  assign rx_sync_0 = rx_sync[0];
  assign rx_gt_charisk_0 = rx_gt_charisk[((4*0)+3):(4*0)];
  assign rx_gt_disperr_0 = rx_gt_disperr[((4*0)+3):(4*0)];
  assign rx_gt_notintable_0 = rx_gt_notintable[((4*0)+3):(4*0)];
  assign rx_gt_data_0 = rx_gt_data[((32*0)+31):(32*0)];
  assign rx_gt_ilas_f_0 = rx_gt_ilas_f[((4*0)+3):(4*0)];
  assign rx_gt_ilas_q_0 = rx_gt_ilas_q[((4*0)+3):(4*0)];
  assign rx_gt_ilas_a_0 = rx_gt_ilas_a[((4*0)+3):(4*0)];
  assign rx_gt_ilas_r_0 = rx_gt_ilas_r[((4*0)+3):(4*0)];
  assign rx_gt_cgs_k_0 = rx_gt_cgs_k[((4*0)+3):(4*0)];
  assign rx_ip_rst_0 = rx_ip_rst[0];
  assign rx_ip_sysref_0 = rx_ip_sysref[0];
  assign rx_ip_rst_done_0 = rx_ip_rst_done[0];
  assign rx_rst_0 = rx_rst[0];
  assign rx_gt_rst_0 = rx_gt_rst[0];
  assign rx_pll_locked_0 = rx_pll_locked[0];
  assign rx_user_ready_0 = rx_user_ready[0];
  assign rx_rst_done_0 = rx_rst_done[0];

  assign rx_p[0] = rx_0_p;
  assign rx_n[0] = rx_0_n;
  assign rx_clk[0] = rx_clk_0;
  assign rx_sysref[0] = rx_sysref_0;
  assign rx_gt_comma_align_enb[0] = rx_gt_comma_align_enb_0;
  assign rx_ip_sof[((4*0)+3):(4*0)] = rx_ip_sof_0;
  assign rx_ip_data[((32*0)+31):(32*0)] = rx_ip_data_0;
  assign rx_ip_sync[0] = rx_ip_sync_0;
  assign rx_rst_m[0] = rx_rst_m_0;
  assign rx_gt_rst_m[0] = rx_gt_rst_m_0;
  assign rx_pll_locked_m[0] = rx_pll_locked_m_0;
  assign rx_user_ready_m[0] = rx_user_ready_m_0;
  assign rx_rst_done_m[0] = rx_rst_done_m_0;

  assign rx_out_clk_1 = rx_out_clk[1];
  assign rx_rst_1 = rx_rst[1];
  assign rx_sof_1 = rx_sof[1];
  assign rx_data_1 = rx_data[((32*1)+31):(32*1)];
  assign rx_sync_1 = rx_sync[1];
  assign rx_gt_charisk_1 = rx_gt_charisk[((4*1)+3):(4*1)];
  assign rx_gt_disperr_1 = rx_gt_disperr[((4*1)+3):(4*1)];
  assign rx_gt_notintable_1 = rx_gt_notintable[((4*1)+3):(4*1)];
  assign rx_gt_data_1 = rx_gt_data[((32*1)+31):(32*1)];
  assign rx_gt_ilas_f_1 = rx_gt_ilas_f[((4*1)+3):(4*1)];
  assign rx_gt_ilas_q_1 = rx_gt_ilas_q[((4*1)+3):(4*1)];
  assign rx_gt_ilas_a_1 = rx_gt_ilas_a[((4*1)+3):(4*1)];
  assign rx_gt_ilas_r_1 = rx_gt_ilas_r[((4*1)+3):(4*1)];
  assign rx_gt_cgs_k_1 = rx_gt_cgs_k[((4*1)+3):(4*1)];
  assign rx_ip_rst_1 = rx_ip_rst[1];
  assign rx_ip_sysref_1 = rx_ip_sysref[1];
  assign rx_ip_rst_done_1 = rx_ip_rst_done[1];
  assign rx_rst_1 = rx_rst[1];
  assign rx_gt_rst_1 = rx_gt_rst[1];
  assign rx_pll_locked_1 = rx_pll_locked[1];
  assign rx_user_ready_1 = rx_user_ready[1];
  assign rx_rst_done_1 = rx_rst_done[1];

  assign rx_p[1] = rx_1_p;
  assign rx_n[1] = rx_1_n;
  assign rx_clk[1] = rx_clk_1;
  assign rx_sysref[1] = rx_sysref_1;
  assign rx_gt_comma_align_enb[1] = rx_gt_comma_align_enb_1;
  assign rx_ip_sof[((4*1)+3):(4*1)] = rx_ip_sof_1;
  assign rx_ip_data[((32*1)+31):(32*1)] = rx_ip_data_1;
  assign rx_ip_sync[1] = rx_ip_sync_1;
  assign rx_rst_m[1] = rx_rst_m_1;
  assign rx_gt_rst_m[1] = rx_gt_rst_m_1;
  assign rx_pll_locked_m[1] = rx_pll_locked_m_1;
  assign rx_user_ready_m[1] = rx_user_ready_m_1;
  assign rx_rst_done_m[1] = rx_rst_done_m_1;

  assign rx_out_clk_2 = rx_out_clk[2];
  assign rx_rst_2 = rx_rst[2];
  assign rx_sof_2 = rx_sof[2];
  assign rx_data_2 = rx_data[((32*2)+31):(32*2)];
  assign rx_sync_2 = rx_sync[2];
  assign rx_gt_charisk_2 = rx_gt_charisk[((4*2)+3):(4*2)];
  assign rx_gt_disperr_2 = rx_gt_disperr[((4*2)+3):(4*2)];
  assign rx_gt_notintable_2 = rx_gt_notintable[((4*2)+3):(4*2)];
  assign rx_gt_data_2 = rx_gt_data[((32*2)+31):(32*2)];
  assign rx_gt_ilas_f_2 = rx_gt_ilas_f[((4*2)+3):(4*2)];
  assign rx_gt_ilas_q_2 = rx_gt_ilas_q[((4*2)+3):(4*2)];
  assign rx_gt_ilas_a_2 = rx_gt_ilas_a[((4*2)+3):(4*2)];
  assign rx_gt_ilas_r_2 = rx_gt_ilas_r[((4*2)+3):(4*2)];
  assign rx_gt_cgs_k_2 = rx_gt_cgs_k[((4*2)+3):(4*2)];
  assign rx_ip_rst_2 = rx_ip_rst[2];
  assign rx_ip_sysref_2 = rx_ip_sysref[2];
  assign rx_ip_rst_done_2 = rx_ip_rst_done[2];
  assign rx_rst_2 = rx_rst[2];
  assign rx_gt_rst_2 = rx_gt_rst[2];
  assign rx_pll_locked_2 = rx_pll_locked[2];
  assign rx_user_ready_2 = rx_user_ready[2];
  assign rx_rst_done_2 = rx_rst_done[2];

  assign rx_p[2] = rx_2_p;
  assign rx_n[2] = rx_2_n;
  assign rx_clk[2] = rx_clk_2;
  assign rx_sysref[2] = rx_sysref_2;
  assign rx_gt_comma_align_enb[2] = rx_gt_comma_align_enb_2;
  assign rx_ip_sof[((4*2)+3):(4*2)] = rx_ip_sof_2;
  assign rx_ip_data[((32*2)+31):(32*2)] = rx_ip_data_2;
  assign rx_ip_sync[2] = rx_ip_sync_2;
  assign rx_rst_m[2] = rx_rst_m_2;
  assign rx_gt_rst_m[2] = rx_gt_rst_m_2;
  assign rx_pll_locked_m[2] = rx_pll_locked_m_2;
  assign rx_user_ready_m[2] = rx_user_ready_m_2;
  assign rx_rst_done_m[2] = rx_rst_done_m_2;

  assign rx_out_clk_3 = rx_out_clk[3];
  assign rx_rst_3 = rx_rst[3];
  assign rx_sof_3 = rx_sof[3];
  assign rx_data_3 = rx_data[((32*3)+31):(32*3)];
  assign rx_sync_3 = rx_sync[3];
  assign rx_gt_charisk_3 = rx_gt_charisk[((4*3)+3):(4*3)];
  assign rx_gt_disperr_3 = rx_gt_disperr[((4*3)+3):(4*3)];
  assign rx_gt_notintable_3 = rx_gt_notintable[((4*3)+3):(4*3)];
  assign rx_gt_data_3 = rx_gt_data[((32*3)+31):(32*3)];
  assign rx_gt_ilas_f_3 = rx_gt_ilas_f[((4*3)+3):(4*3)];
  assign rx_gt_ilas_q_3 = rx_gt_ilas_q[((4*3)+3):(4*3)];
  assign rx_gt_ilas_a_3 = rx_gt_ilas_a[((4*3)+3):(4*3)];
  assign rx_gt_ilas_r_3 = rx_gt_ilas_r[((4*3)+3):(4*3)];
  assign rx_gt_cgs_k_3 = rx_gt_cgs_k[((4*3)+3):(4*3)];
  assign rx_ip_rst_3 = rx_ip_rst[3];
  assign rx_ip_sysref_3 = rx_ip_sysref[3];
  assign rx_ip_rst_done_3 = rx_ip_rst_done[3];
  assign rx_rst_3 = rx_rst[3];
  assign rx_gt_rst_3 = rx_gt_rst[3];
  assign rx_pll_locked_3 = rx_pll_locked[3];
  assign rx_user_ready_3 = rx_user_ready[3];
  assign rx_rst_done_3 = rx_rst_done[3];

  assign rx_p[3] = rx_3_p;
  assign rx_n[3] = rx_3_n;
  assign rx_clk[3] = rx_clk_3;
  assign rx_sysref[3] = rx_sysref_3;
  assign rx_gt_comma_align_enb[3] = rx_gt_comma_align_enb_3;
  assign rx_ip_sof[((4*3)+3):(4*3)] = rx_ip_sof_3;
  assign rx_ip_data[((32*3)+31):(32*3)] = rx_ip_data_3;
  assign rx_ip_sync[3] = rx_ip_sync_3;
  assign rx_rst_m[3] = rx_rst_m_3;
  assign rx_gt_rst_m[3] = rx_gt_rst_m_3;
  assign rx_pll_locked_m[3] = rx_pll_locked_m_3;
  assign rx_user_ready_m[3] = rx_user_ready_m_3;
  assign rx_rst_done_m[3] = rx_rst_done_m_3;

  assign rx_out_clk_4 = rx_out_clk[4];
  assign rx_rst_4 = rx_rst[4];
  assign rx_sof_4 = rx_sof[4];
  assign rx_data_4 = rx_data[((32*4)+31):(32*4)];
  assign rx_sync_4 = rx_sync[4];
  assign rx_gt_charisk_4 = rx_gt_charisk[((4*4)+3):(4*4)];
  assign rx_gt_disperr_4 = rx_gt_disperr[((4*4)+3):(4*4)];
  assign rx_gt_notintable_4 = rx_gt_notintable[((4*4)+3):(4*4)];
  assign rx_gt_data_4 = rx_gt_data[((32*4)+31):(32*4)];
  assign rx_gt_ilas_f_4 = rx_gt_ilas_f[((4*4)+3):(4*4)];
  assign rx_gt_ilas_q_4 = rx_gt_ilas_q[((4*4)+3):(4*4)];
  assign rx_gt_ilas_a_4 = rx_gt_ilas_a[((4*4)+3):(4*4)];
  assign rx_gt_ilas_r_4 = rx_gt_ilas_r[((4*4)+3):(4*4)];
  assign rx_gt_cgs_k_4 = rx_gt_cgs_k[((4*4)+3):(4*4)];
  assign rx_ip_rst_4 = rx_ip_rst[4];
  assign rx_ip_sysref_4 = rx_ip_sysref[4];
  assign rx_ip_rst_done_4 = rx_ip_rst_done[4];
  assign rx_rst_4 = rx_rst[4];
  assign rx_gt_rst_4 = rx_gt_rst[4];
  assign rx_pll_locked_4 = rx_pll_locked[4];
  assign rx_user_ready_4 = rx_user_ready[4];
  assign rx_rst_done_4 = rx_rst_done[4];

  assign rx_p[4] = rx_4_p;
  assign rx_n[4] = rx_4_n;
  assign rx_clk[4] = rx_clk_4;
  assign rx_sysref[4] = rx_sysref_4;
  assign rx_gt_comma_align_enb[4] = rx_gt_comma_align_enb_4;
  assign rx_ip_sof[((4*4)+3):(4*4)] = rx_ip_sof_4;
  assign rx_ip_data[((32*4)+31):(32*4)] = rx_ip_data_4;
  assign rx_ip_sync[4] = rx_ip_sync_4;
  assign rx_rst_m[4] = rx_rst_m_4;
  assign rx_gt_rst_m[4] = rx_gt_rst_m_4;
  assign rx_pll_locked_m[4] = rx_pll_locked_m_4;
  assign rx_user_ready_m[4] = rx_user_ready_m_4;
  assign rx_rst_done_m[4] = rx_rst_done_m_4;

  assign rx_out_clk_5 = rx_out_clk[5];
  assign rx_rst_5 = rx_rst[5];
  assign rx_sof_5 = rx_sof[5];
  assign rx_data_5 = rx_data[((32*5)+31):(32*5)];
  assign rx_sync_5 = rx_sync[5];
  assign rx_gt_charisk_5 = rx_gt_charisk[((4*5)+3):(4*5)];
  assign rx_gt_disperr_5 = rx_gt_disperr[((4*5)+3):(4*5)];
  assign rx_gt_notintable_5 = rx_gt_notintable[((4*5)+3):(4*5)];
  assign rx_gt_data_5 = rx_gt_data[((32*5)+31):(32*5)];
  assign rx_gt_ilas_f_5 = rx_gt_ilas_f[((4*5)+3):(4*5)];
  assign rx_gt_ilas_q_5 = rx_gt_ilas_q[((4*5)+3):(4*5)];
  assign rx_gt_ilas_a_5 = rx_gt_ilas_a[((4*5)+3):(4*5)];
  assign rx_gt_ilas_r_5 = rx_gt_ilas_r[((4*5)+3):(4*5)];
  assign rx_gt_cgs_k_5 = rx_gt_cgs_k[((4*5)+3):(4*5)];
  assign rx_ip_rst_5 = rx_ip_rst[5];
  assign rx_ip_sysref_5 = rx_ip_sysref[5];
  assign rx_ip_rst_done_5 = rx_ip_rst_done[5];
  assign rx_rst_5 = rx_rst[5];
  assign rx_gt_rst_5 = rx_gt_rst[5];
  assign rx_pll_locked_5 = rx_pll_locked[5];
  assign rx_user_ready_5 = rx_user_ready[5];
  assign rx_rst_done_5 = rx_rst_done[5];

  assign rx_p[5] = rx_5_p;
  assign rx_n[5] = rx_5_n;
  assign rx_clk[5] = rx_clk_5;
  assign rx_sysref[5] = rx_sysref_5;
  assign rx_gt_comma_align_enb[5] = rx_gt_comma_align_enb_5;
  assign rx_ip_sof[((4*5)+3):(4*5)] = rx_ip_sof_5;
  assign rx_ip_data[((32*5)+31):(32*5)] = rx_ip_data_5;
  assign rx_ip_sync[5] = rx_ip_sync_5;
  assign rx_rst_m[5] = rx_rst_m_5;
  assign rx_gt_rst_m[5] = rx_gt_rst_m_5;
  assign rx_pll_locked_m[5] = rx_pll_locked_m_5;
  assign rx_user_ready_m[5] = rx_user_ready_m_5;
  assign rx_rst_done_m[5] = rx_rst_done_m_5;

  assign rx_out_clk_6 = rx_out_clk[6];
  assign rx_rst_6 = rx_rst[6];
  assign rx_sof_6 = rx_sof[6];
  assign rx_data_6 = rx_data[((32*6)+31):(32*6)];
  assign rx_sync_6 = rx_sync[6];
  assign rx_gt_charisk_6 = rx_gt_charisk[((4*6)+3):(4*6)];
  assign rx_gt_disperr_6 = rx_gt_disperr[((4*6)+3):(4*6)];
  assign rx_gt_notintable_6 = rx_gt_notintable[((4*6)+3):(4*6)];
  assign rx_gt_data_6 = rx_gt_data[((32*6)+31):(32*6)];
  assign rx_gt_ilas_f_6 = rx_gt_ilas_f[((4*6)+3):(4*6)];
  assign rx_gt_ilas_q_6 = rx_gt_ilas_q[((4*6)+3):(4*6)];
  assign rx_gt_ilas_a_6 = rx_gt_ilas_a[((4*6)+3):(4*6)];
  assign rx_gt_ilas_r_6 = rx_gt_ilas_r[((4*6)+3):(4*6)];
  assign rx_gt_cgs_k_6 = rx_gt_cgs_k[((4*6)+3):(4*6)];
  assign rx_ip_rst_6 = rx_ip_rst[6];
  assign rx_ip_sysref_6 = rx_ip_sysref[6];
  assign rx_ip_rst_done_6 = rx_ip_rst_done[6];
  assign rx_rst_6 = rx_rst[6];
  assign rx_gt_rst_6 = rx_gt_rst[6];
  assign rx_pll_locked_6 = rx_pll_locked[6];
  assign rx_user_ready_6 = rx_user_ready[6];
  assign rx_rst_done_6 = rx_rst_done[6];

  assign rx_p[6] = rx_6_p;
  assign rx_n[6] = rx_6_n;
  assign rx_clk[6] = rx_clk_6;
  assign rx_sysref[6] = rx_sysref_6;
  assign rx_gt_comma_align_enb[6] = rx_gt_comma_align_enb_6;
  assign rx_ip_sof[((4*6)+3):(4*6)] = rx_ip_sof_6;
  assign rx_ip_data[((32*6)+31):(32*6)] = rx_ip_data_6;
  assign rx_ip_sync[6] = rx_ip_sync_6;
  assign rx_rst_m[6] = rx_rst_m_6;
  assign rx_gt_rst_m[6] = rx_gt_rst_m_6;
  assign rx_pll_locked_m[6] = rx_pll_locked_m_6;
  assign rx_user_ready_m[6] = rx_user_ready_m_6;
  assign rx_rst_done_m[6] = rx_rst_done_m_6;

  assign rx_out_clk_7 = rx_out_clk[7];
  assign rx_rst_7 = rx_rst[7];
  assign rx_sof_7 = rx_sof[7];
  assign rx_data_7 = rx_data[((32*7)+31):(32*7)];
  assign rx_sync_7 = rx_sync[7];
  assign rx_gt_charisk_7 = rx_gt_charisk[((4*7)+3):(4*7)];
  assign rx_gt_disperr_7 = rx_gt_disperr[((4*7)+3):(4*7)];
  assign rx_gt_notintable_7 = rx_gt_notintable[((4*7)+3):(4*7)];
  assign rx_gt_data_7 = rx_gt_data[((32*7)+31):(32*7)];
  assign rx_gt_ilas_f_7 = rx_gt_ilas_f[((4*7)+3):(4*7)];
  assign rx_gt_ilas_q_7 = rx_gt_ilas_q[((4*7)+3):(4*7)];
  assign rx_gt_ilas_a_7 = rx_gt_ilas_a[((4*7)+3):(4*7)];
  assign rx_gt_ilas_r_7 = rx_gt_ilas_r[((4*7)+3):(4*7)];
  assign rx_gt_cgs_k_7 = rx_gt_cgs_k[((4*7)+3):(4*7)];
  assign rx_ip_rst_7 = rx_ip_rst[7];
  assign rx_ip_sysref_7 = rx_ip_sysref[7];
  assign rx_ip_rst_done_7 = rx_ip_rst_done[7];
  assign rx_rst_7 = rx_rst[7];
  assign rx_gt_rst_7 = rx_gt_rst[7];
  assign rx_pll_locked_7 = rx_pll_locked[7];
  assign rx_user_ready_7 = rx_user_ready[7];
  assign rx_rst_done_7 = rx_rst_done[7];

  assign rx_p[7] = rx_7_p;
  assign rx_n[7] = rx_7_n;
  assign rx_clk[7] = rx_clk_7;
  assign rx_sysref[7] = rx_sysref_7;
  assign rx_gt_comma_align_enb[7] = rx_gt_comma_align_enb_7;
  assign rx_ip_sof[((4*7)+3):(4*7)] = rx_ip_sof_7;
  assign rx_ip_data[((32*7)+31):(32*7)] = rx_ip_data_7;
  assign rx_ip_sync[7] = rx_ip_sync_7;
  assign rx_rst_m[7] = rx_rst_m_7;
  assign rx_gt_rst_m[7] = rx_gt_rst_m_7;
  assign rx_pll_locked_m[7] = rx_pll_locked_m_7;
  assign rx_user_ready_m[7] = rx_user_ready_m_7;
  assign rx_rst_done_m[7] = rx_rst_done_m_7;

  assign tx_0_p = tx_p[0];
  assign tx_0_n = tx_n[0];
  assign tx_out_clk_0 = tx_out_clk[0];
  assign tx_rst_0 = tx_rst[0];
  assign tx_ip_rst_0 = tx_ip_rst[0];
  assign tx_ip_data_0 = tx_ip_data[((32*0)+31):(32*0)];
  assign tx_ip_sysref_0 = tx_ip_sysref[0];
  assign tx_ip_sync_0 = tx_ip_sync[0];
  assign tx_ip_rst_done_0 = tx_ip_rst_done[0];
  assign tx_rst_0 = tx_rst[0];
  assign tx_gt_rst_0 = tx_gt_rst[0];
  assign tx_pll_locked_0 = tx_pll_locked[0];
  assign tx_user_ready_0 = tx_user_ready[0];
  assign tx_rst_done_0 = tx_rst_done[0];

  assign tx_clk[0] = tx_clk_0;
  assign tx_data[((32*0)+31):(32*0)] = tx_data_0;
  assign tx_sysref[0] = tx_sysref_0;
  assign tx_sync[0] = tx_sync_0;
  assign tx_gt_charisk[((4*0)+3):(4*0)] = tx_gt_charisk_0;
  assign tx_gt_data[((32*0)+31):(32*0)] = tx_gt_data_0;
  assign tx_rst_m[0] = tx_rst_m_0;
  assign tx_gt_rst_m[0] = tx_gt_rst_m_0;
  assign tx_pll_locked_m[0] = tx_pll_locked_m_0;
  assign tx_user_ready_m[0] = tx_user_ready_m_0;
  assign tx_rst_done_m[0] = tx_rst_done_m_0;

  assign tx_1_p = tx_p[1];
  assign tx_1_n = tx_n[1];
  assign tx_out_clk_1 = tx_out_clk[1];
  assign tx_rst_1 = tx_rst[1];
  assign tx_ip_rst_1 = tx_ip_rst[1];
  assign tx_ip_data_1 = tx_ip_data[((32*1)+31):(32*1)];
  assign tx_ip_sysref_1 = tx_ip_sysref[1];
  assign tx_ip_sync_1 = tx_ip_sync[1];
  assign tx_ip_rst_done_1 = tx_ip_rst_done[1];
  assign tx_rst_1 = tx_rst[1];
  assign tx_gt_rst_1 = tx_gt_rst[1];
  assign tx_pll_locked_1 = tx_pll_locked[1];
  assign tx_user_ready_1 = tx_user_ready[1];
  assign tx_rst_done_1 = tx_rst_done[1];

  assign tx_clk[1] = tx_clk_1;
  assign tx_data[((32*1)+31):(32*1)] = tx_data_1;
  assign tx_sysref[1] = tx_sysref_1;
  assign tx_sync[1] = tx_sync_1;
  assign tx_gt_charisk[((4*1)+3):(4*1)] = tx_gt_charisk_1;
  assign tx_gt_data[((32*1)+31):(32*1)] = tx_gt_data_1;
  assign tx_rst_m[1] = tx_rst_m_1;
  assign tx_gt_rst_m[1] = tx_gt_rst_m_1;
  assign tx_pll_locked_m[1] = tx_pll_locked_m_1;
  assign tx_user_ready_m[1] = tx_user_ready_m_1;
  assign tx_rst_done_m[1] = tx_rst_done_m_1;

  assign tx_2_p = tx_p[2];
  assign tx_2_n = tx_n[2];
  assign tx_out_clk_2 = tx_out_clk[2];
  assign tx_rst_2 = tx_rst[2];
  assign tx_ip_rst_2 = tx_ip_rst[2];
  assign tx_ip_data_2 = tx_ip_data[((32*2)+31):(32*2)];
  assign tx_ip_sysref_2 = tx_ip_sysref[2];
  assign tx_ip_sync_2 = tx_ip_sync[2];
  assign tx_ip_rst_done_2 = tx_ip_rst_done[2];
  assign tx_rst_2 = tx_rst[2];
  assign tx_gt_rst_2 = tx_gt_rst[2];
  assign tx_pll_locked_2 = tx_pll_locked[2];
  assign tx_user_ready_2 = tx_user_ready[2];
  assign tx_rst_done_2 = tx_rst_done[2];

  assign tx_clk[2] = tx_clk_2;
  assign tx_data[((32*2)+31):(32*2)] = tx_data_2;
  assign tx_sysref[2] = tx_sysref_2;
  assign tx_sync[2] = tx_sync_2;
  assign tx_gt_charisk[((4*2)+3):(4*2)] = tx_gt_charisk_2;
  assign tx_gt_data[((32*2)+31):(32*2)] = tx_gt_data_2;
  assign tx_rst_m[2] = tx_rst_m_2;
  assign tx_gt_rst_m[2] = tx_gt_rst_m_2;
  assign tx_pll_locked_m[2] = tx_pll_locked_m_2;
  assign tx_user_ready_m[2] = tx_user_ready_m_2;
  assign tx_rst_done_m[2] = tx_rst_done_m_2;

  assign tx_3_p = tx_p[3];
  assign tx_3_n = tx_n[3];
  assign tx_out_clk_3 = tx_out_clk[3];
  assign tx_rst_3 = tx_rst[3];
  assign tx_ip_rst_3 = tx_ip_rst[3];
  assign tx_ip_data_3 = tx_ip_data[((32*3)+31):(32*3)];
  assign tx_ip_sysref_3 = tx_ip_sysref[3];
  assign tx_ip_sync_3 = tx_ip_sync[3];
  assign tx_ip_rst_done_3 = tx_ip_rst_done[3];
  assign tx_rst_3 = tx_rst[3];
  assign tx_gt_rst_3 = tx_gt_rst[3];
  assign tx_pll_locked_3 = tx_pll_locked[3];
  assign tx_user_ready_3 = tx_user_ready[3];
  assign tx_rst_done_3 = tx_rst_done[3];

  assign tx_clk[3] = tx_clk_3;
  assign tx_data[((32*3)+31):(32*3)] = tx_data_3;
  assign tx_sysref[3] = tx_sysref_3;
  assign tx_sync[3] = tx_sync_3;
  assign tx_gt_charisk[((4*3)+3):(4*3)] = tx_gt_charisk_3;
  assign tx_gt_data[((32*3)+31):(32*3)] = tx_gt_data_3;
  assign tx_rst_m[3] = tx_rst_m_3;
  assign tx_gt_rst_m[3] = tx_gt_rst_m_3;
  assign tx_pll_locked_m[3] = tx_pll_locked_m_3;
  assign tx_user_ready_m[3] = tx_user_ready_m_3;
  assign tx_rst_done_m[3] = tx_rst_done_m_3;

  assign tx_4_p = tx_p[4];
  assign tx_4_n = tx_n[4];
  assign tx_out_clk_4 = tx_out_clk[4];
  assign tx_rst_4 = tx_rst[4];
  assign tx_ip_rst_4 = tx_ip_rst[4];
  assign tx_ip_data_4 = tx_ip_data[((32*4)+31):(32*4)];
  assign tx_ip_sysref_4 = tx_ip_sysref[4];
  assign tx_ip_sync_4 = tx_ip_sync[4];
  assign tx_ip_rst_done_4 = tx_ip_rst_done[4];
  assign tx_rst_4 = tx_rst[4];
  assign tx_gt_rst_4 = tx_gt_rst[4];
  assign tx_pll_locked_4 = tx_pll_locked[4];
  assign tx_user_ready_4 = tx_user_ready[4];
  assign tx_rst_done_4 = tx_rst_done[4];

  assign tx_clk[4] = tx_clk_4;
  assign tx_data[((32*4)+31):(32*4)] = tx_data_4;
  assign tx_sysref[4] = tx_sysref_4;
  assign tx_sync[4] = tx_sync_4;
  assign tx_gt_charisk[((4*4)+3):(4*4)] = tx_gt_charisk_4;
  assign tx_gt_data[((32*4)+31):(32*4)] = tx_gt_data_4;
  assign tx_rst_m[4] = tx_rst_m_4;
  assign tx_gt_rst_m[4] = tx_gt_rst_m_4;
  assign tx_pll_locked_m[4] = tx_pll_locked_m_4;
  assign tx_user_ready_m[4] = tx_user_ready_m_4;
  assign tx_rst_done_m[4] = tx_rst_done_m_4;

  assign tx_5_p = tx_p[5];
  assign tx_5_n = tx_n[5];
  assign tx_out_clk_5 = tx_out_clk[5];
  assign tx_rst_5 = tx_rst[5];
  assign tx_ip_rst_5 = tx_ip_rst[5];
  assign tx_ip_data_5 = tx_ip_data[((32*5)+31):(32*5)];
  assign tx_ip_sysref_5 = tx_ip_sysref[5];
  assign tx_ip_sync_5 = tx_ip_sync[5];
  assign tx_ip_rst_done_5 = tx_ip_rst_done[5];
  assign tx_rst_5 = tx_rst[5];
  assign tx_gt_rst_5 = tx_gt_rst[5];
  assign tx_pll_locked_5 = tx_pll_locked[5];
  assign tx_user_ready_5 = tx_user_ready[5];
  assign tx_rst_done_5 = tx_rst_done[5];

  assign tx_clk[5] = tx_clk_5;
  assign tx_data[((32*5)+31):(32*5)] = tx_data_5;
  assign tx_sysref[5] = tx_sysref_5;
  assign tx_sync[5] = tx_sync_5;
  assign tx_gt_charisk[((4*5)+3):(4*5)] = tx_gt_charisk_5;
  assign tx_gt_data[((32*5)+31):(32*5)] = tx_gt_data_5;
  assign tx_rst_m[5] = tx_rst_m_5;
  assign tx_gt_rst_m[5] = tx_gt_rst_m_5;
  assign tx_pll_locked_m[5] = tx_pll_locked_m_5;
  assign tx_user_ready_m[5] = tx_user_ready_m_5;
  assign tx_rst_done_m[5] = tx_rst_done_m_5;

  assign tx_6_p = tx_p[6];
  assign tx_6_n = tx_n[6];
  assign tx_out_clk_6 = tx_out_clk[6];
  assign tx_rst_6 = tx_rst[6];
  assign tx_ip_rst_6 = tx_ip_rst[6];
  assign tx_ip_data_6 = tx_ip_data[((32*6)+31):(32*6)];
  assign tx_ip_sysref_6 = tx_ip_sysref[6];
  assign tx_ip_sync_6 = tx_ip_sync[6];
  assign tx_ip_rst_done_6 = tx_ip_rst_done[6];
  assign tx_rst_6 = tx_rst[6];
  assign tx_gt_rst_6 = tx_gt_rst[6];
  assign tx_pll_locked_6 = tx_pll_locked[6];
  assign tx_user_ready_6 = tx_user_ready[6];
  assign tx_rst_done_6 = tx_rst_done[6];

  assign tx_clk[6] = tx_clk_6;
  assign tx_data[((32*6)+31):(32*6)] = tx_data_6;
  assign tx_sysref[6] = tx_sysref_6;
  assign tx_sync[6] = tx_sync_6;
  assign tx_gt_charisk[((4*6)+3):(4*6)] = tx_gt_charisk_6;
  assign tx_gt_data[((32*6)+31):(32*6)] = tx_gt_data_6;
  assign tx_rst_m[6] = tx_rst_m_6;
  assign tx_gt_rst_m[6] = tx_gt_rst_m_6;
  assign tx_pll_locked_m[6] = tx_pll_locked_m_6;
  assign tx_user_ready_m[6] = tx_user_ready_m_6;
  assign tx_rst_done_m[6] = tx_rst_done_m_6;

  assign tx_7_p = tx_p[7];
  assign tx_7_n = tx_n[7];
  assign tx_out_clk_7 = tx_out_clk[7];
  assign tx_rst_7 = tx_rst[7];
  assign tx_ip_rst_7 = tx_ip_rst[7];
  assign tx_ip_data_7 = tx_ip_data[((32*7)+31):(32*7)];
  assign tx_ip_sysref_7 = tx_ip_sysref[7];
  assign tx_ip_sync_7 = tx_ip_sync[7];
  assign tx_ip_rst_done_7 = tx_ip_rst_done[7];
  assign tx_rst_7 = tx_rst[7];
  assign tx_gt_rst_7 = tx_gt_rst[7];
  assign tx_pll_locked_7 = tx_pll_locked[7];
  assign tx_user_ready_7 = tx_user_ready[7];
  assign tx_rst_done_7 = tx_rst_done[7];

  assign tx_clk[7] = tx_clk_7;
  assign tx_data[((32*7)+31):(32*7)] = tx_data_7;
  assign tx_sysref[7] = tx_sysref_7;
  assign tx_sync[7] = tx_sync_7;
  assign tx_gt_charisk[((4*7)+3):(4*7)] = tx_gt_charisk_7;
  assign tx_gt_data[((32*7)+31):(32*7)] = tx_gt_data_7;
  assign tx_rst_m[7] = tx_rst_m_7;
  assign tx_gt_rst_m[7] = tx_gt_rst_m_7;
  assign tx_pll_locked_m[7] = tx_pll_locked_m_7;
  assign tx_user_ready_m[7] = tx_user_ready_m_7;
  assign tx_rst_done_m[7] = tx_rst_done_m_7;

  // up signals

  always @(posedge up_clk or negedge up_rstn) begin
    if (up_rstn == 1'b0) begin
      up_wack_d <= 1'd0;
      up_rack_d <= 1'd0;
      up_rdata_d <= 32'd0;
    end else begin
      up_wack_d <= | up_wack;
      up_rack_d <= | up_rack;
      up_rdata_d <= up_rdata[((32*0)+31):(32*0)] |
        up_rdata[((32*1)+31):(32*1)] |
        up_rdata[((32*2)+31):(32*2)] |
        up_rdata[((32*3)+31):(32*3)] |
        up_rdata[((32*4)+31):(32*4)] |
        up_rdata[((32*5)+31):(32*5)] |
        up_rdata[((32*6)+31):(32*6)] |
        up_rdata[((32*7)+31):(32*7)] |
        up_rdata[((32*8)+31):(32*8)];
    end
  end

  // instantiations

  genvar n;
  generate

  if (NUM_OF_LANES < 8) begin
  for (n = NUM_OF_LANES; n < 8; n = n + 1) begin: g_unused_1
  assign pll_rst[n] = 1'd0;
  assign rx_rst[n] = 1'd0;
  assign rx_gt_rst[n] = 1'd0;
  assign rx_pll_locked[n] = 1'd0;
  assign rx_user_ready[n] = 1'd0;
  assign rx_rst_done[n] = 1'd0;
  assign rx_out_clk[n] = 1'd0;
  assign rx_rst[n] = 1'd0;
  assign rx_sync[n] = 1'd0;
  assign rx_sof[n] = 1'd0;
  assign rx_data[((32*n)+31):(32*n)] = 32'd0;
  assign rx_gt_charisk[((4*n)+3):(4*n)] = 4'd0;
  assign rx_gt_disperr[((4*n)+3):(4*n)] = 4'd0;
  assign rx_gt_notintable[((4*n)+3):(4*n)] = 4'd0;
  assign rx_gt_data[((32*n)+31):(32*n)] = 32'd0;
  assign rx_gt_ilas_f[((4*n)+3):(4*n)] = 4'd0;
  assign rx_gt_ilas_q[((4*n)+3):(4*n)] = 4'd0;
  assign rx_gt_ilas_a[((4*n)+3):(4*n)] = 4'd0;
  assign rx_gt_ilas_r[((4*n)+3):(4*n)] = 4'd0;
  assign rx_gt_cgs_k[((4*n)+3):(4*n)] = 4'd0;
  assign rx_ip_rst[n] = 1'd0;
  assign rx_ip_sysref[n] = 1'd0;
  assign rx_ip_rst_done[n] = 1'd0;
  assign tx_p[n] = 1'd0;
  assign tx_n[n] = 1'd1;
  assign tx_rst[n] = 1'd0;
  assign tx_gt_rst[n] = 1'd0;
  assign tx_pll_locked[n] = 1'd0;
  assign tx_user_ready[n] = 1'd0;
  assign tx_rst_done[n] = 1'd0;
  assign tx_out_clk[n] = 1'd0;
  assign tx_rst[n] = 1'd0;
  assign tx_ip_rst[n] = 1'd0;
  assign tx_ip_data[((32*n)+31):(32*n)] = 32'd0;
  assign tx_ip_sysref[n] = 1'd0;
  assign tx_ip_sync[n] = 1'd0;
  assign tx_ip_rst_done[n] = 1'd0;
  end
  end

  for (n = 0; n < NUM_OF_LANES; n = n + 1) begin: g_lane_1
  ad_gt_channel_1 #(
    .ID (n),
    .GTH_GTX_N (GTH_GTX_N),
    .PMA_RSV (PMA_RSV[n]),
    .CPLL_FBDIV (CPLL_FBDIV[n]),
    .RX_OUT_DIV (RX_OUT_DIV[n]),
    .RX_CLK25_DIV (RX_CLK25_DIV[n]),
    .RX_CLKBUF_ENABLE (RX_CLKBUF_ENABLE[n]),
    .RX_CDR_CFG (RX_CDR_CFG[n]),
    .TX_OUT_DIV (TX_OUT_DIV[n]),
    .TX_CLK25_DIV (TX_CLK25_DIV[n]),
    .TX_CLKBUF_ENABLE (TX_CLKBUF_ENABLE[n]))
  i_channel (
    .cpll_rst_m (cpll_rst_m[n]),
    .cpll_ref_clk_in (cpll_ref_clk_in[n]),
    .qpll_ref_clk (qpll_ref_clk[n]),
    .qpll_locked (qpll_locked[n]),
    .qpll_clk (qpll_clk[n]),
    .pll_rst (pll_rst[n]),
    .rx_p (rx_p[n]),
    .rx_n (rx_n[n]),
    .rx_out_clk (rx_out_clk[n]),
    .rx_clk (rx_clk[n]),
    .rx_rst (rx_rst[n]),
    .rx_rst_m (rx_rst_m[n]),
    .rx_sof (rx_sof[n]),
    .rx_data (rx_data[((32*n)+31):(32*n)]),
    .rx_sysref (rx_sysref[n]),
    .rx_sync (rx_sync[n]),
    .rx_gt_rst (rx_gt_rst[n]),
    .rx_gt_rst_m (rx_gt_rst_m[n]),
    .rx_gt_charisk (rx_gt_charisk[((4*n)+3):(4*n)]),
    .rx_gt_disperr (rx_gt_disperr[((4*n)+3):(4*n)]),
    .rx_gt_notintable (rx_gt_notintable[((4*n)+3):(4*n)]),
    .rx_gt_data (rx_gt_data[((32*n)+31):(32*n)]),
    .rx_gt_comma_align_enb (rx_gt_comma_align_enb[n]),
    .rx_gt_ilas_f (rx_gt_ilas_f[((4*n)+3):(4*n)]),
    .rx_gt_ilas_q (rx_gt_ilas_q[((4*n)+3):(4*n)]),
    .rx_gt_ilas_a (rx_gt_ilas_a[((4*n)+3):(4*n)]),
    .rx_gt_ilas_r (rx_gt_ilas_r[((4*n)+3):(4*n)]),
    .rx_gt_cgs_k (rx_gt_cgs_k[((4*n)+3):(4*n)]),
    .rx_ip_rst (rx_ip_rst[n]),
    .rx_ip_sof (rx_ip_sof[((4*n)+3):(4*n)]),
    .rx_ip_data (rx_ip_data[((32*n)+31):(32*n)]),
    .rx_ip_sysref (rx_ip_sysref[n]),
    .rx_ip_sync (rx_ip_sync[n]),
    .rx_ip_rst_done (rx_ip_rst_done[n]),
    .rx_pll_locked (rx_pll_locked[n]),
    .rx_user_ready (rx_user_ready[n]),
    .rx_rst_done (rx_rst_done[n]),
    .rx_pll_locked_m (rx_pll_locked_m[n]),
    .rx_user_ready_m (rx_user_ready_m[n]),
    .rx_rst_done_m (rx_rst_done_m[n]),
    .tx_p (tx_p[n]),
    .tx_n (tx_n[n]),
    .tx_out_clk (tx_out_clk[n]),
    .tx_clk (tx_clk[n]),
    .tx_rst (tx_rst[n]),
    .tx_rst_m (tx_rst_m[n]),
    .tx_data (tx_data[((32*n)+31):(32*n)]),
    .tx_sysref (tx_sysref[n]),
    .tx_sync (tx_sync[n]),
    .tx_gt_rst (tx_gt_rst[n]),
    .tx_gt_rst_m (tx_gt_rst_m[n]),
    .tx_gt_charisk (tx_gt_charisk[((4*TX_DATA_SEL[n])+3):(4*TX_DATA_SEL[n])]),
    .tx_gt_data (tx_gt_data[((32*TX_DATA_SEL[n])+31):(32*TX_DATA_SEL[n])]),
    .tx_ip_rst (tx_ip_rst[n]),
    .tx_ip_data (tx_ip_data[((32*n)+31):(32*n)]),
    .tx_ip_sysref (tx_ip_sysref[n]),
    .tx_ip_sync (tx_ip_sync[n]),
    .tx_ip_rst_done (tx_ip_rst_done[n]),
    .tx_pll_locked (tx_pll_locked[n]),
    .tx_user_ready (tx_user_ready[n]),
    .tx_rst_done (tx_rst_done[n]),
    .tx_pll_locked_m (tx_pll_locked_m[n]),
    .tx_user_ready_m (tx_user_ready_m[n]),
    .tx_rst_done_m (tx_rst_done_m[n]),
    .up_es_dma_req (up_es_dma_req[n]),
    .up_es_dma_addr (up_es_dma_addr[((32*n)+31):(32*n)]),
    .up_es_dma_data (up_es_dma_data[((32*n)+31):(32*n)]),
    .up_es_dma_ack (up_es_dma_ack[n]),
    .up_es_dma_err (up_es_dma_err[n]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack[n]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata[((32*n)+31):(32*n)]),
    .up_rack (up_rack[n]));
  end
  endgenerate

  ad_gt_common_1 #(
    .ID (0),
    .GTH_GTX_N (GTH_GTX_N),
    .QPLL0_ENABLE (QPLL0_ENABLE),
    .QPLL0_REFCLK_DIV (QPLL0_REFCLK_DIV),
    .QPLL0_CFG (QPLL0_CFG),
    .QPLL0_FBDIV_RATIO (QPLL0_FBDIV_RATIO),
    .QPLL0_FBDIV (QPLL0_FBDIV),
    .QPLL1_ENABLE (QPLL1_ENABLE),
    .QPLL1_REFCLK_DIV (QPLL1_REFCLK_DIV),
    .QPLL1_CFG (QPLL1_CFG),
    .QPLL1_FBDIV_RATIO (QPLL1_FBDIV_RATIO),
    .QPLL1_FBDIV (QPLL1_FBDIV))
  i_common (
    .qpll0_rst (qpll0_rst),
    .qpll0_ref_clk_in (qpll0_ref_clk_in),
    .qpll1_rst (qpll1_rst),
    .qpll1_ref_clk_in (qpll1_ref_clk_in),
    .qpll_clk (qpll_clk),
    .qpll_ref_clk (qpll_ref_clk),
    .qpll_locked (qpll_locked),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack[8]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata[((32*8)+31):(32*8)]),
    .up_rack (up_rack[8]));

  ad_gt_es_axi i_es_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_es_dma_req_0 (up_es_dma_req[0]),
    .up_es_dma_addr_0 (up_es_dma_addr[((32*0)+31):(32*0)]),
    .up_es_dma_data_0 (up_es_dma_data[((32*0)+31):(32*0)]),
    .up_es_dma_ack_0 (up_es_dma_ack[0]),
    .up_es_dma_err_0 (up_es_dma_err[0]),
    .up_es_dma_req_1 (up_es_dma_req[1]),
    .up_es_dma_addr_1 (up_es_dma_addr[((32*1)+31):(32*1)]),
    .up_es_dma_data_1 (up_es_dma_data[((32*1)+31):(32*1)]),
    .up_es_dma_ack_1 (up_es_dma_ack[1]),
    .up_es_dma_err_1 (up_es_dma_err[1]),
    .up_es_dma_req_2 (up_es_dma_req[2]),
    .up_es_dma_addr_2 (up_es_dma_addr[((32*2)+31):(32*2)]),
    .up_es_dma_data_2 (up_es_dma_data[((32*2)+31):(32*2)]),
    .up_es_dma_ack_2 (up_es_dma_ack[2]),
    .up_es_dma_err_2 (up_es_dma_err[2]),
    .up_es_dma_req_3 (up_es_dma_req[3]),
    .up_es_dma_addr_3 (up_es_dma_addr[((32*3)+31):(32*3)]),
    .up_es_dma_data_3 (up_es_dma_data[((32*3)+31):(32*3)]),
    .up_es_dma_ack_3 (up_es_dma_ack[3]),
    .up_es_dma_err_3 (up_es_dma_err[3]),
    .up_es_dma_req_4 (up_es_dma_req[4]),
    .up_es_dma_addr_4 (up_es_dma_addr[((32*4)+31):(32*4)]),
    .up_es_dma_data_4 (up_es_dma_data[((32*4)+31):(32*4)]),
    .up_es_dma_ack_4 (up_es_dma_ack[4]),
    .up_es_dma_err_4 (up_es_dma_err[4]),
    .up_es_dma_req_5 (up_es_dma_req[5]),
    .up_es_dma_addr_5 (up_es_dma_addr[((32*5)+31):(32*5)]),
    .up_es_dma_data_5 (up_es_dma_data[((32*5)+31):(32*5)]),
    .up_es_dma_ack_5 (up_es_dma_ack[5]),
    .up_es_dma_err_5 (up_es_dma_err[5]),
    .up_es_dma_req_6 (up_es_dma_req[6]),
    .up_es_dma_addr_6 (up_es_dma_addr[((32*6)+31):(32*6)]),
    .up_es_dma_data_6 (up_es_dma_data[((32*6)+31):(32*6)]),
    .up_es_dma_ack_6 (up_es_dma_ack[6]),
    .up_es_dma_err_6 (up_es_dma_err[6]),
    .up_es_dma_req_7 (up_es_dma_req[7]),
    .up_es_dma_addr_7 (up_es_dma_addr[((32*7)+31):(32*7)]),
    .up_es_dma_data_7 (up_es_dma_data[((32*7)+31):(32*7)]),
    .up_es_dma_ack_7 (up_es_dma_ack[7]),
    .up_es_dma_err_7 (up_es_dma_err[7]),
    .axi_awvalid (m_axi_awvalid),
    .axi_awaddr (m_axi_awaddr),
    .axi_awprot (m_axi_awprot),
    .axi_awready (m_axi_awready),
    .axi_wvalid (m_axi_wvalid),
    .axi_wdata (m_axi_wdata),
    .axi_wstrb (m_axi_wstrb),
    .axi_wready (m_axi_wready),
    .axi_bvalid (m_axi_bvalid),
    .axi_bresp (m_axi_bresp),
    .axi_bready (m_axi_bready),
    .axi_arvalid (m_axi_arvalid),
    .axi_araddr (m_axi_araddr),
    .axi_arprot (m_axi_arprot),
    .axi_arready (m_axi_arready),
    .axi_rvalid (m_axi_rvalid),
    .axi_rresp (m_axi_rresp),
    .axi_rdata (m_axi_rdata),
    .axi_rready (m_axi_rready));

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_d),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_d),
    .up_rack (up_rack_d));

endmodule

// ***************************************************************************
// ***************************************************************************
