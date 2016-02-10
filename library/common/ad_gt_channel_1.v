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

`timescale 1ns/1ps

module ad_gt_channel_1 (

  // channel interface (pll)

  cpll_rst_m,
  cpll_ref_clk_in,
  qpll_ref_clk,
  qpll_locked,
  qpll_clk,

  // channel interface (rx)

  rx_p,
  rx_n,

  rx_out_clk,
  rx_clk,
  rx_rst,
  rx_rst_m,
  rx_sof,
  rx_data,
  rx_sysref,
  rx_sync,

  rx_pll_rst,
  rx_gt_rst,
  rx_gt_rst_m,
  rx_gt_charisk,
  rx_gt_disperr,
  rx_gt_notintable,
  rx_gt_data,
  rx_gt_comma_align_enb,
  rx_gt_ilas_f,
  rx_gt_ilas_q,
  rx_gt_ilas_a,
  rx_gt_ilas_r,
  rx_gt_cgs_k,

  rx_ip_rst,
  rx_ip_sof,
  rx_ip_data,
  rx_ip_sysref,
  rx_ip_sync,
  rx_ip_rst_done,

  rx_pll_locked,
  rx_user_ready,
  rx_rst_done,

  rx_pll_locked_m,
  rx_user_ready_m,
  rx_rst_done_m,

  // channel interface (tx)

  tx_p,
  tx_n,

  tx_out_clk,
  tx_clk,
  tx_rst,
  tx_rst_m,
  tx_data,
  tx_sysref,
  tx_sync,

  tx_pll_rst,
  tx_gt_rst,
  tx_gt_rst_m,
  tx_gt_charisk,
  tx_gt_data,

  tx_ip_rst,
  tx_ip_data,
  tx_ip_sysref,
  tx_ip_sync,
  tx_ip_rst_done,

  tx_pll_locked,
  tx_user_ready,
  tx_rst_done,

  tx_pll_locked_m,
  tx_user_ready_m,
  tx_rst_done_m,

  // dma interface

  up_es_dma_req,
  up_es_dma_addr,
  up_es_dma_data,
  up_es_dma_ack,
  up_es_dma_err,

  // bus interface

  up_rstn,
  up_clk,
  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack);

  // parameters

  parameter   integer ID = 0;
  parameter   integer GTH_OR_GTX_N = 0;
  parameter   [31:0]  PMA_RSV = 32'h00018480;
  parameter   integer CPLL_FBDIV = 2;
  parameter   integer RX_OUT_DIV = 1;
  parameter   integer RX_CLK25_DIV = 10;
  parameter   integer RX_CLKBUF_ENABLE = 0;
  parameter   [72:0]  RX_CDR_CFG = 72'h03000023ff20400020;
  parameter   integer TX_OUT_DIV = 1;
  parameter   integer TX_CLK25_DIV = 10;
  parameter   integer TX_CLKBUF_ENABLE = 0;

  // channel interface (pll)

  input           cpll_rst_m;
  input           cpll_ref_clk_in;
  input           qpll_ref_clk;
  input           qpll_locked;
  input           qpll_clk;

  // channel interface (rx)

  input           rx_p;
  input           rx_n;

  output          rx_out_clk;
  input           rx_clk;
  output          rx_rst;
  input           rx_rst_m;
  output          rx_sof;
  output  [31:0]  rx_data;
  input           rx_sysref;
  output          rx_sync;

  output          rx_pll_rst;
  output          rx_gt_rst;
  input           rx_gt_rst_m;
  output  [ 3:0]  rx_gt_charisk;
  output  [ 3:0]  rx_gt_disperr;
  output  [ 3:0]  rx_gt_notintable;
  output  [31:0]  rx_gt_data;
  input           rx_gt_comma_align_enb;
  output  [ 3:0]  rx_gt_ilas_f;
  output  [ 3:0]  rx_gt_ilas_q;
  output  [ 3:0]  rx_gt_ilas_a;
  output  [ 3:0]  rx_gt_ilas_r;
  output  [ 3:0]  rx_gt_cgs_k;

  output          rx_ip_rst;
  input   [ 3:0]  rx_ip_sof;
  input   [31:0]  rx_ip_data;
  output          rx_ip_sysref;
  input           rx_ip_sync;
  output          rx_ip_rst_done;

  output          rx_pll_locked;
  output          rx_user_ready;
  output          rx_rst_done;

  input           rx_pll_locked_m;
  input           rx_user_ready_m;
  input           rx_rst_done_m;

  // channel interface (tx)

  output          tx_p;
  output          tx_n;

  output          tx_out_clk;
  input           tx_clk;
  output          tx_rst;
  input           tx_rst_m;
  input   [31:0]  tx_data;
  input           tx_sysref;
  input           tx_sync;

  output          tx_pll_rst;
  output          tx_gt_rst;
  input           tx_gt_rst_m;
  input   [ 3:0]  tx_gt_charisk;
  input   [31:0]  tx_gt_data;

  output          tx_ip_rst;
  output  [31:0]  tx_ip_data;
  output          tx_ip_sysref;
  output          tx_ip_sync;
  output          tx_ip_rst_done;

  output          tx_pll_locked;
  output          tx_user_ready;
  output          tx_rst_done;

  input           tx_pll_locked_m;
  input           tx_user_ready_m;
  input           tx_rst_done_m;

  // dma interface

  output          up_es_dma_req;
  output  [31:0]  up_es_dma_addr;
  output  [31:0]  up_es_dma_data;
  input           up_es_dma_ack;
  input           up_es_dma_err;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           up_wreq;
  input   [13:0]  up_waddr;
  input   [31:0]  up_wdata;
  output          up_wack;
  input           up_rreq;
  input   [13:0]  up_raddr;
  output  [31:0]  up_rdata;
  output          up_rack;

  // internal signals

  wire            lpm_dfe_n_s;
  wire            cpll_pd_s;
  wire    [ 1:0]  rx_sys_clk_sel_s;
  wire    [ 2:0]  rx_out_clk_sel_s;
  wire    [ 1:0]  tx_sys_clk_sel_s;
  wire    [ 2:0]  tx_out_clk_sel_s;
  wire            up_drp_sel_s;
  wire            up_drp_wr_s;
  wire    [11:0]  up_drp_addr_s;
  wire    [15:0]  up_drp_wdata_s;
  wire    [15:0]  up_drp_rdata_s;
  wire            up_drp_ready_s;
  wire    [ 7:0]  up_drp_rxrate_s;
  wire            up_es_drp_sel_s;
  wire            up_es_drp_wr_s;
  wire    [11:0]  up_es_drp_addr_s;
  wire    [15:0]  up_es_drp_wdata_s;
  wire    [15:0]  up_es_drp_rdata_s;
  wire            up_es_drp_ready_s;
  wire            up_es_start_s;
  wire            up_es_stop_s;
  wire            up_es_init_s;
  wire    [ 4:0]  up_es_prescale_s;
  wire    [ 1:0]  up_es_voffset_range_s;
  wire    [ 7:0]  up_es_voffset_step_s;
  wire    [ 7:0]  up_es_voffset_max_s;
  wire    [ 7:0]  up_es_voffset_min_s;
  wire    [11:0]  up_es_hoffset_max_s;
  wire    [11:0]  up_es_hoffset_min_s;
  wire    [11:0]  up_es_hoffset_step_s;
  wire    [31:0]  up_es_start_addr_s;
  wire    [15:0]  up_es_sdata0_s;
  wire    [15:0]  up_es_sdata1_s;
  wire    [15:0]  up_es_sdata2_s;
  wire    [15:0]  up_es_sdata3_s;
  wire    [15:0]  up_es_sdata4_s;
  wire    [15:0]  up_es_qdata0_s;
  wire    [15:0]  up_es_qdata1_s;
  wire    [15:0]  up_es_qdata2_s;
  wire    [15:0]  up_es_qdata3_s;
  wire    [15:0]  up_es_qdata4_s;
  wire            up_es_status_s;

  // nothing to do for now

  assign tx_ip_data = tx_data;

  // instantiations

  ad_jesd_align i_align (
    .rx_clk (rx_clk),
    .rx_ip_sof (rx_ip_sof),
    .rx_ip_data (rx_ip_data),
    .rx_sof (rx_sof),
    .rx_data (rx_data));

  ad_gt_channel #(
    .GTH_OR_GTX_N (GTH_OR_GTX_N),
    .PMA_RSV (PMA_RSV),
    .CPLL_FBDIV (CPLL_FBDIV),
    .RX_OUT_DIV (RX_OUT_DIV),
    .TX_OUT_DIV (TX_OUT_DIV),
    .RX_CLK25_DIV (RX_CLK25_DIV),
    .TX_CLK25_DIV (TX_CLK25_DIV),
    .RX_CLKBUF_ENABLE (RX_CLKBUF_ENABLE),
    .TX_CLKBUF_ENABLE (TX_CLKBUF_ENABLE),
    .RX_CDR_CFG (RX_CDR_CFG))
  i_gt (
    .lpm_dfe_n (lpm_dfe_n_s),
    .cpll_ref_clk_in (cpll_ref_clk_in),
    .cpll_pd (cpll_pd_s),
    .cpll_rst (cpll_rst_m),
    .qpll_clk (qpll_clk),
    .qpll_ref_clk (qpll_ref_clk),
    .qpll_locked (qpll_locked),
    .rx_gt_rst_m (rx_gt_rst_m),
    .rx_p (rx_p),
    .rx_n (rx_n),
    .rx_sys_clk_sel (rx_sys_clk_sel_s),
    .rx_out_clk_sel (rx_out_clk_sel_s),
    .rx_out_clk (rx_out_clk),
    .rx_rst_done (rx_rst_done),
    .rx_pll_locked (rx_pll_locked),
    .rx_user_ready_m (rx_user_ready_m),
    .rx_clk (rx_clk),
    .rx_gt_charisk (rx_gt_charisk),
    .rx_gt_disperr (rx_gt_disperr),
    .rx_gt_notintable (rx_gt_notintable),
    .rx_gt_data (rx_gt_data),
    .rx_gt_comma_align_enb (rx_gt_comma_align_enb),
    .rx_gt_ilas_f (rx_gt_ilas_f),
    .rx_gt_ilas_q (rx_gt_ilas_q),
    .rx_gt_ilas_a (rx_gt_ilas_a),
    .rx_gt_ilas_r (rx_gt_ilas_r),
    .rx_gt_cgs_k (rx_gt_cgs_k),
    .tx_gt_rst_m (tx_gt_rst_m),
    .tx_p (tx_p),
    .tx_n (tx_n),
    .tx_sys_clk_sel (tx_sys_clk_sel_s),
    .tx_out_clk_sel (tx_out_clk_sel_s),
    .tx_out_clk (tx_out_clk),
    .tx_rst_done (tx_rst_done),
    .tx_pll_locked (tx_pll_locked),
    .tx_user_ready_m (tx_user_ready_m),
    .tx_clk (tx_clk),
    .tx_gt_charisk (tx_gt_charisk),
    .tx_gt_data (tx_gt_data),
    .up_clk (up_clk),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_s),
    .up_drp_ready (up_drp_ready_s),
    .up_drp_rxrate (up_drp_rxrate_s));

  ad_gt_es #(
    .GTH_OR_GTX_N (GTH_OR_GTX_N))
  i_es (
    .lpm_dfe_n (lpm_dfe_n_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_es_drp_sel (up_es_drp_sel_s),
    .up_es_drp_wr (up_es_drp_wr_s),
    .up_es_drp_addr (up_es_drp_addr_s),
    .up_es_drp_wdata (up_es_drp_wdata_s),
    .up_es_drp_rdata (up_es_drp_rdata_s),
    .up_es_drp_ready (up_es_drp_ready_s),
    .up_es_dma_req (up_es_dma_req),
    .up_es_dma_addr (up_es_dma_addr),
    .up_es_dma_data (up_es_dma_data),
    .up_es_dma_ack (up_es_dma_ack),
    .up_es_start (up_es_start_s),
    .up_es_stop (up_es_stop_s),
    .up_es_init (up_es_init_s),
    .up_es_sdata0 (up_es_sdata0_s),
    .up_es_sdata1 (up_es_sdata1_s),
    .up_es_sdata2 (up_es_sdata2_s),
    .up_es_sdata3 (up_es_sdata3_s),
    .up_es_sdata4 (up_es_sdata4_s),
    .up_es_qdata0 (up_es_qdata0_s),
    .up_es_qdata1 (up_es_qdata1_s),
    .up_es_qdata2 (up_es_qdata2_s),
    .up_es_qdata3 (up_es_qdata3_s),
    .up_es_qdata4 (up_es_qdata4_s),
    .up_es_prescale (up_es_prescale_s),
    .up_es_hoffset_min (up_es_hoffset_min_s),
    .up_es_hoffset_max (up_es_hoffset_max_s),
    .up_es_hoffset_step (up_es_hoffset_step_s),
    .up_es_voffset_min (up_es_voffset_min_s),
    .up_es_voffset_max (up_es_voffset_max_s),
    .up_es_voffset_step (up_es_voffset_step_s),
    .up_es_voffset_range (up_es_voffset_range_s),
    .up_es_start_addr (up_es_start_addr_s),
    .up_es_status (up_es_status_s));

  up_gt_channel #(
    .ID (ID))
  i_up (
    .lpm_dfe_n (lpm_dfe_n_s),
    .cpll_pd (cpll_pd_s),
    .rx_pll_rst (rx_pll_rst),
    .rx_sys_clk_sel (rx_sys_clk_sel_s),
    .rx_out_clk_sel (rx_out_clk_sel_s),
    .rx_clk (rx_clk),
    .rx_gt_rst (rx_gt_rst),
    .rx_rst (rx_rst),
    .rx_rst_m (rx_rst_m),
    .rx_ip_rst (rx_ip_rst),
    .rx_sysref (rx_sysref),
    .rx_ip_sysref (rx_ip_sysref),
    .rx_ip_sync (rx_ip_sync),
    .rx_sync (rx_sync),
    .rx_rst_done (rx_rst_done),
    .rx_rst_done_m (rx_rst_done_m),
    .rx_pll_locked (rx_pll_locked),
    .rx_pll_locked_m (rx_pll_locked_m),
    .rx_user_ready (rx_user_ready),
    .rx_ip_rst_done (rx_ip_rst_done),
    .tx_pll_rst (tx_pll_rst),
    .tx_sys_clk_sel (tx_sys_clk_sel_s),
    .tx_out_clk_sel (tx_out_clk_sel_s),
    .tx_clk (tx_clk),
    .tx_gt_rst (tx_gt_rst),
    .tx_rst (tx_rst),
    .tx_rst_m (tx_rst_m),
    .tx_ip_rst (tx_ip_rst),
    .tx_sysref (tx_sysref),
    .tx_ip_sysref (tx_ip_sysref),
    .tx_sync (tx_sync),
    .tx_ip_sync (tx_ip_sync),
    .tx_rst_done (tx_rst_done),
    .tx_rst_done_m (tx_rst_done_m),
    .tx_pll_locked (tx_pll_locked),
    .tx_pll_locked_m (tx_pll_locked_m),
    .tx_user_ready (tx_user_ready),
    .tx_ip_rst_done (tx_ip_rst_done),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_s),
    .up_drp_ready (up_drp_ready_s),
    .up_drp_rxrate (up_drp_rxrate_s),
    .up_es_drp_sel (up_es_drp_sel_s),
    .up_es_drp_wr (up_es_drp_wr_s),
    .up_es_drp_addr (up_es_drp_addr_s),
    .up_es_drp_wdata (up_es_drp_wdata_s),
    .up_es_drp_rdata (up_es_drp_rdata_s),
    .up_es_drp_ready (up_es_drp_ready_s),
    .up_es_start (up_es_start_s),
    .up_es_stop (up_es_stop_s),
    .up_es_init (up_es_init_s),
    .up_es_prescale (up_es_prescale_s),
    .up_es_voffset_range (up_es_voffset_range_s),
    .up_es_voffset_step (up_es_voffset_step_s),
    .up_es_voffset_max (up_es_voffset_max_s),
    .up_es_voffset_min (up_es_voffset_min_s),
    .up_es_hoffset_max (up_es_hoffset_max_s),
    .up_es_hoffset_min (up_es_hoffset_min_s),
    .up_es_hoffset_step (up_es_hoffset_step_s),
    .up_es_start_addr (up_es_start_addr_s),
    .up_es_sdata0 (up_es_sdata0_s),
    .up_es_sdata1 (up_es_sdata1_s),
    .up_es_sdata2 (up_es_sdata2_s),
    .up_es_sdata3 (up_es_sdata3_s),
    .up_es_sdata4 (up_es_sdata4_s),
    .up_es_qdata0 (up_es_qdata0_s),
    .up_es_qdata1 (up_es_qdata1_s),
    .up_es_qdata2 (up_es_qdata2_s),
    .up_es_qdata3 (up_es_qdata3_s),
    .up_es_qdata4 (up_es_qdata4_s),
    .up_es_dma_err (up_es_dma_err),
    .up_es_status (up_es_status_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************

