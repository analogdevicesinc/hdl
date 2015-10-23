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

module up_gt_channel (

  // gt interface

  lpm_dfe_n,
  cpll_pd,

  // receive interface

  rx_pll_rst,
  rx_sys_clk_sel,
  rx_out_clk_sel,
  rx_clk,
  rx_gt_rst,
  rx_rst,
  rx_rst_m,
  rx_ip_rst,
  rx_sysref,
  rx_ip_sysref,
  rx_ip_sync,
  rx_sync,
  rx_rst_done,
  rx_rst_done_m,
  rx_pll_locked,
  rx_pll_locked_m,
  rx_user_ready,
  rx_ip_rst_done,

  // transmit interface

  tx_pll_rst,
  tx_sys_clk_sel,
  tx_out_clk_sel,
  tx_clk,
  tx_gt_rst,
  tx_rst,
  tx_rst_m,
  tx_ip_rst,
  tx_sysref,
  tx_ip_sysref,
  tx_sync,
  tx_ip_sync,
  tx_rst_done,
  tx_rst_done_m,
  tx_pll_locked,
  tx_pll_locked_m,
  tx_user_ready,
  tx_ip_rst_done,

  // drp interface

  up_drp_sel,
  up_drp_wr,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,
  up_drp_rxrate,

  // es interface

  up_es_drp_sel,
  up_es_drp_wr,
  up_es_drp_addr,
  up_es_drp_wdata,
  up_es_drp_rdata,
  up_es_drp_ready,
  up_es_start,
  up_es_stop,
  up_es_init,
  up_es_prescale,
  up_es_voffset_range,
  up_es_voffset_step,
  up_es_voffset_max,
  up_es_voffset_min,
  up_es_hoffset_max,
  up_es_hoffset_min,
  up_es_hoffset_step,
  up_es_start_addr,
  up_es_sdata0,
  up_es_sdata1,
  up_es_sdata2,
  up_es_sdata3,
  up_es_sdata4,
  up_es_qdata0,
  up_es_qdata1,
  up_es_qdata2,
  up_es_qdata3,
  up_es_qdata4,
  up_es_dma_err,
  up_es_status,

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

  localparam  [31:0]  VERSION = 32'h00070161;
  parameter   integer ID = 0;

  // gt interface

  output          lpm_dfe_n;
  output          cpll_pd;

  // receive interface

  output          rx_pll_rst;
  output  [ 1:0]  rx_sys_clk_sel;
  output  [ 2:0]  rx_out_clk_sel;
  input           rx_clk;
  output          rx_gt_rst;
  output          rx_rst;
  input           rx_rst_m;
  output          rx_ip_rst;
  input           rx_sysref;
  output          rx_ip_sysref;
  input           rx_ip_sync;
  output          rx_sync;
  input           rx_rst_done;
  input           rx_rst_done_m;
  input           rx_pll_locked;
  input           rx_pll_locked_m;
  output          rx_user_ready;
  output          rx_ip_rst_done;

  // transmit interface

  output          tx_pll_rst;
  output  [ 1:0]  tx_sys_clk_sel;
  output  [ 2:0]  tx_out_clk_sel;
  input           tx_clk;
  output          tx_gt_rst;
  output          tx_rst;
  input           tx_rst_m;
  output          tx_ip_rst;
  input           tx_sysref;
  output          tx_ip_sysref;
  input           tx_sync;
  output          tx_ip_sync;
  input           tx_rst_done;
  input           tx_rst_done_m;
  input           tx_pll_locked;
  input           tx_pll_locked_m;
  output          tx_user_ready;
  output          tx_ip_rst_done;

  // drp interface

  output          up_drp_sel;
  output          up_drp_wr;
  output  [11:0]  up_drp_addr;
  output  [15:0]  up_drp_wdata;
  input   [15:0]  up_drp_rdata;
  input           up_drp_ready;
  input   [ 7:0]  up_drp_rxrate;

  // es interface

  input           up_es_drp_sel;
  input           up_es_drp_wr;
  input   [11:0]  up_es_drp_addr;
  input   [15:0]  up_es_drp_wdata;
  output  [15:0]  up_es_drp_rdata;
  output          up_es_drp_ready;
  output          up_es_start;
  output          up_es_stop;
  output          up_es_init;
  output  [ 4:0]  up_es_prescale;
  output  [ 1:0]  up_es_voffset_range;
  output  [ 7:0]  up_es_voffset_step;
  output  [ 7:0]  up_es_voffset_max;
  output  [ 7:0]  up_es_voffset_min;
  output  [11:0]  up_es_hoffset_max;
  output  [11:0]  up_es_hoffset_min;
  output  [11:0]  up_es_hoffset_step;
  output  [31:0]  up_es_start_addr;
  output  [15:0]  up_es_sdata0;
  output  [15:0]  up_es_sdata1;
  output  [15:0]  up_es_sdata2;
  output  [15:0]  up_es_sdata3;
  output  [15:0]  up_es_sdata4;
  output  [15:0]  up_es_qdata0;
  output  [15:0]  up_es_qdata1;
  output  [15:0]  up_es_qdata2;
  output  [15:0]  up_es_qdata3;
  output  [15:0]  up_es_qdata4;
  input           up_es_dma_err;
  input           up_es_status;

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

  // internal registers

  reg             up_rx_pll_preset = 'd1;
  reg             up_rx_gt_preset = 'd1;
  reg             up_rx_preset = 'd1;
  reg             up_tx_pll_preset = 'd1;
  reg             up_tx_gt_preset = 'd1;
  reg             up_tx_preset = 'd1;
  reg             up_wack = 'd0;
  reg             up_lpm_dfe_n = 'd0;
  reg             up_cpll_pd = 'd0;
  reg             up_drp_resetn = 'd0;
  reg             up_rx_gt_resetn = 'd0;
  reg             up_rx_resetn = 'd0;
  reg     [ 1:0]  up_rx_sys_clk_sel = 'd0;
  reg     [ 2:0]  up_rx_out_clk_sel = 'd0;
  reg             up_rx_sysref_sel = 'd0;
  reg             up_rx_sysref = 'd0;
  reg             up_rx_sync = 'd0;
  reg             up_rx_user_ready = 'd0;
  reg             up_rx_pll_resetn = 'd0;
  reg             up_tx_gt_resetn = 'd0;
  reg             up_tx_resetn = 'd0;
  reg     [ 1:0]  up_tx_sys_clk_sel = 'd0;
  reg     [ 2:0]  up_tx_out_clk_sel = 'd0;
  reg             up_tx_sysref_sel = 'd0;
  reg             up_tx_sysref = 'd0;
  reg             up_tx_sync = 'd0;
  reg             up_tx_user_ready = 'd0;
  reg             up_tx_pll_resetn = 'd0;
  reg             up_drp_sel_int = 'd0;
  reg             up_drp_wr_int = 'd0;
  reg             up_drp_status = 'd0;
  reg             up_drp_rwn = 'd0;
  reg     [11:0]  up_drp_addr_int = 'd0;
  reg     [15:0]  up_drp_wdata_int = 'd0;
  reg     [15:0]  up_drp_rdata_hold = 'd0;
  reg             up_es_init = 'd0;
  reg             up_es_stop = 'd0;
  reg             up_es_stop_hold = 'd0;
  reg             up_es_start = 'd0;
  reg             up_es_start_hold = 'd0;
  reg     [ 4:0]  up_es_prescale = 'd0;
  reg     [ 1:0]  up_es_voffset_range = 'd0;
  reg     [ 7:0]  up_es_voffset_step = 'd0;
  reg     [ 7:0]  up_es_voffset_max = 'd0;
  reg     [ 7:0]  up_es_voffset_min = 'd0;
  reg     [11:0]  up_es_hoffset_max = 'd0;
  reg     [11:0]  up_es_hoffset_min = 'd0;
  reg     [11:0]  up_es_hoffset_step = 'd0;
  reg     [31:0]  up_es_start_addr = 'd0;
  reg     [15:0]  up_es_sdata1 = 'd0;
  reg     [15:0]  up_es_sdata0 = 'd0;
  reg     [15:0]  up_es_sdata3 = 'd0;
  reg     [15:0]  up_es_sdata2 = 'd0;
  reg     [15:0]  up_es_sdata4 = 'd0;
  reg     [15:0]  up_es_qdata1 = 'd0;
  reg     [15:0]  up_es_qdata0 = 'd0;
  reg     [15:0]  up_es_qdata3 = 'd0;
  reg     [15:0]  up_es_qdata2 = 'd0;
  reg     [15:0]  up_es_qdata4 = 'd0;
  reg             up_es_dma_err_hold = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_rx_rst_done_m1 = 'd0;
  reg             up_rx_rst_done = 'd0;
  reg             up_rx_rst_done_m_m1 = 'd0;
  reg             up_rx_rst_done_m = 'd0;
  reg             up_rx_pll_locked_m1 = 'd0;
  reg             up_rx_pll_locked = 'd0;
  reg             up_rx_pll_locked_m_m1 = 'd0;
  reg             up_rx_pll_locked_m = 'd0;
  reg             up_rx_status_m1 = 'd0;
  reg             up_rx_status = 'd0;
  reg             up_tx_rst_done_m1 = 'd0;
  reg             up_tx_rst_done = 'd0;
  reg             up_tx_rst_done_m_m1 = 'd0;
  reg             up_tx_rst_done_m = 'd0;
  reg             up_tx_pll_locked_m1 = 'd0;
  reg             up_tx_pll_locked = 'd0;
  reg             up_tx_pll_locked_m_m1 = 'd0;
  reg             up_tx_pll_locked_m = 'd0;
  reg             up_tx_status_m1 = 'd0;
  reg             up_tx_status = 'd0;
  reg             up_drp_sel = 'd0;
  reg             up_drp_wr = 'd0;
  reg     [11:0]  up_drp_addr = 'd0;
  reg     [15:0]  up_drp_wdata = 'd0;
  reg     [15:0]  up_es_drp_rdata = 'd0;
  reg             up_es_drp_ready = 'd0;
  reg     [15:0]  up_drp_rdata_int = 'd0;
  reg             up_drp_ready_int = 'd0;
  reg             rx_sysref_sel_m1 = 'd0;
  reg             rx_sysref_sel = 'd0;
  reg             rx_up_sysref_m1 = 'd0;
  reg             rx_up_sysref = 'd0;
  reg             rx_ip_sysref = 'd0;
  reg             rx_up_sync_m1 = 'd0;
  reg             rx_up_sync = 'd0;
  reg             rx_sync = 'd0;
  reg             tx_sysref_sel_m1 = 'd0;
  reg             tx_sysref_sel = 'd0;
  reg             tx_up_sysref_m1 = 'd0;
  reg             tx_up_sysref = 'd0;
  reg             tx_ip_sysref = 'd0;
  reg             tx_up_sync_m1 = 'd0;
  reg             tx_up_sync = 'd0;
  reg             tx_ip_sync = 'd0;
  reg     [31:0]  up_scratch = 'd0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == ID) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == ID) ? up_rreq : 1'b0;

  // user ready & ip reset done

  assign lpm_dfe_n = up_lpm_dfe_n;
  assign cpll_pd = up_cpll_pd;

  assign rx_sys_clk_sel = up_rx_sys_clk_sel;
  assign rx_out_clk_sel = up_rx_out_clk_sel;
  assign rx_user_ready = up_rx_user_ready;
  assign rx_ip_rst_done = up_rx_rst_done_m;

  assign tx_sys_clk_sel = up_tx_sys_clk_sel;
  assign tx_out_clk_sel = up_tx_out_clk_sel;
  assign tx_user_ready = up_tx_user_ready;
  assign tx_ip_rst_done = up_tx_rst_done_m;

  // resets

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rx_pll_preset <= 1'b1;
      up_rx_gt_preset <= 1'b1;
      up_rx_preset <= 1'b1;
      up_tx_pll_preset <= 1'b1;
      up_tx_gt_preset <= 1'b1;
      up_tx_preset <= 1'b1;
    end else begin
      up_rx_pll_preset <= ~up_rx_pll_resetn;
      up_rx_gt_preset <= ~(up_rx_pll_resetn &
        up_rx_pll_locked_m & up_rx_gt_resetn);
      up_rx_preset <= ~(up_rx_pll_resetn & up_rx_pll_locked_m &
        up_rx_rst_done_m & up_rx_gt_resetn & up_rx_resetn);
      up_tx_pll_preset <= ~up_tx_pll_resetn;
      up_tx_gt_preset <= ~(up_tx_pll_resetn &
        up_tx_pll_locked_m & up_tx_gt_resetn);
      up_tx_preset <= ~(up_tx_pll_resetn & up_tx_pll_locked_m &
        up_tx_rst_done_m & up_tx_gt_resetn & up_tx_resetn);
    end
  end

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_lpm_dfe_n <= 'd0;
      up_cpll_pd <= 'd1;
      up_drp_resetn <= 'd0;
      up_rx_gt_resetn <= 'd0;
      up_rx_resetn <= 'd0;
      up_rx_sys_clk_sel <= 2'b11;
      up_rx_out_clk_sel <= 3'b010;
      up_rx_sysref_sel <= 'd0;
      up_rx_sysref <= 'd0;
      up_rx_sync <= 'd0;
      up_rx_user_ready <= 'd0;
      up_rx_pll_resetn <= 'd0;
      up_tx_gt_resetn <= 'd0;
      up_tx_resetn <= 'd0;
      up_tx_sys_clk_sel <= 2'b11;
      up_tx_out_clk_sel <= 3'b010;
      up_tx_sysref_sel <= 'd0;
      up_tx_sysref <= 'd0;
      up_tx_sync <= 'd0;
      up_tx_user_ready <= 'd0;
      up_tx_pll_resetn <= 'd0;
      up_drp_sel_int <= 'd0;
      up_drp_wr_int <= 'd0;
      up_drp_status <= 'd0;
      up_drp_rwn <= 'd0;
      up_drp_addr_int <= 'd0;
      up_drp_wdata_int <= 'd0;
      up_drp_rdata_hold <= 'd0;
      up_es_init <= 'd0;
      up_es_stop <= 'd0;
      up_es_stop_hold <= 'd0;
      up_es_start <= 'd0;
      up_es_start_hold <= 'd0;
      up_es_prescale <= 'd0;
      up_es_voffset_range <= 'd0;
      up_es_voffset_step <= 'd0;
      up_es_voffset_max <= 'd0;
      up_es_voffset_min <= 'd0;
      up_es_hoffset_max <= 'd0;
      up_es_hoffset_min <= 'd0;
      up_es_hoffset_step <= 'd0;
      up_es_start_addr <= 'd0;
      up_es_sdata1 <= 'd0;
      up_es_sdata0 <= 'd0;
      up_es_sdata3 <= 'd0;
      up_es_sdata2 <= 'd0;
      up_es_sdata4 <= 'd0;
      up_es_qdata1 <= 'd0;
      up_es_qdata0 <= 'd0;
      up_es_qdata3 <= 'd0;
      up_es_qdata2 <= 'd0;
      up_es_qdata4 <= 'd0;
      up_es_dma_err_hold <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h04)) begin
        up_lpm_dfe_n <= up_wdata[1];
        up_cpll_pd <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h05)) begin
        up_drp_resetn <= up_wdata[1];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h08)) begin
        up_rx_gt_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h09)) begin
        up_rx_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h0a)) begin
        up_rx_sys_clk_sel <= up_wdata[5:4];
        up_rx_out_clk_sel <= up_wdata[2:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h0b)) begin
        up_rx_sysref_sel <= up_wdata[1];
        up_rx_sysref <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h0c)) begin
        up_rx_sync <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h0e)) begin
        up_rx_user_ready <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h0f)) begin
        up_rx_pll_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h18)) begin
        up_tx_gt_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h19)) begin
        up_tx_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h1a)) begin
        up_tx_sys_clk_sel <= up_wdata[5:4];
        up_tx_out_clk_sel <= up_wdata[2:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h1b)) begin
        up_tx_sysref_sel <= up_wdata[1];
        up_tx_sysref <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h1c)) begin
        up_tx_sync <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h1e)) begin
        up_tx_user_ready <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h1f)) begin
        up_tx_pll_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h24)) begin
        up_drp_sel_int <= 1'b1;
        up_drp_wr_int <= ~up_wdata[28];
      end else begin
        up_drp_sel_int <= 1'b0;
        up_drp_wr_int <= 1'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h24)) begin
        up_drp_status <= 1'b1;
      end else if (up_drp_ready == 1'b1) begin
        up_drp_status <= 1'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h24)) begin
        up_drp_rwn <= up_wdata[28];
        up_drp_addr_int <= up_wdata[27:16];
        up_drp_wdata_int <= up_wdata[15:0];
      end
      if (up_drp_ready_int == 1'b1) begin
        up_drp_rdata_hold <= up_drp_rdata_int;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h28)) begin
        up_es_init <= up_wdata[2];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h28)) begin
        up_es_stop <= up_wdata[1];
        up_es_stop_hold <= up_wdata[1];
      end else begin
        up_es_stop <= 1'd0;
        up_es_stop_hold <= up_es_stop_hold;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h28)) begin
        up_es_start <= up_wdata[0];
        up_es_start_hold <= up_wdata[0];
      end else begin
        up_es_start <= 1'd0;
        up_es_start_hold <= up_es_start_hold;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h29)) begin
        up_es_prescale <= up_wdata[4:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h2a)) begin
        up_es_voffset_range <= up_wdata[25:24];
        up_es_voffset_step <= up_wdata[23:16];
        up_es_voffset_max <= up_wdata[15:8];
        up_es_voffset_min <= up_wdata[7:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h2b)) begin
        up_es_hoffset_max <= up_wdata[27:16];
        up_es_hoffset_min <= up_wdata[11:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h2c)) begin
        up_es_hoffset_step <= up_wdata[11:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h2d)) begin
        up_es_start_addr <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h2e)) begin
        up_es_sdata1 <= up_wdata[31:16];
        up_es_sdata0 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h2f)) begin
        up_es_sdata3 <= up_wdata[31:16];
        up_es_sdata2 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h30)) begin
        up_es_sdata4 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h31)) begin
        up_es_qdata1 <= up_wdata[31:16];
        up_es_qdata0 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h32)) begin
        up_es_qdata3 <= up_wdata[31:16];
        up_es_qdata2 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h33)) begin
        up_es_qdata4 <= up_wdata[15:0];
      end
      if (up_es_dma_err == 1'b1) begin
        up_es_dma_err_hold <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h38)) begin
        up_es_dma_err_hold <= up_es_dma_err_hold & ~up_wdata[1];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[7:0])
          8'h00: up_rdata <= VERSION;
          8'h01: up_rdata <= ID;
          8'h02: up_rdata <= up_scratch;
          8'h04: up_rdata <= {30'd0, up_lpm_dfe_n, up_cpll_pd};
          8'h05: up_rdata <= {30'd0, up_drp_resetn, 1'd0};
          8'h08: up_rdata <= {31'd0, up_rx_gt_resetn};
          8'h09: up_rdata <= {31'd0, up_rx_resetn};
          8'h0a: up_rdata <= {24'd0, 2'd0, up_rx_sys_clk_sel, 1'd0, up_rx_out_clk_sel};
          8'h0b: up_rdata <= {30'd0, up_rx_sysref_sel, up_rx_sysref};
          8'h0c: up_rdata <= {31'd0, up_rx_sync};
          8'h0d: up_rdata <= {15'd0, up_rx_status,
                              6'h3f, up_rx_rst_done_m, up_rx_rst_done,
                              6'h3f, up_rx_pll_locked_m, up_rx_pll_locked};
          8'h0e: up_rdata <= {31'd0, up_rx_user_ready};
          8'h0f: up_rdata <= {31'd0, up_rx_pll_resetn};
          8'h18: up_rdata <= {31'd0, up_tx_gt_resetn};
          8'h19: up_rdata <= {31'd0, up_tx_resetn};
          8'h1a: up_rdata <= {24'd0, 2'd0, up_tx_sys_clk_sel, 1'd0, up_tx_out_clk_sel};
          8'h1b: up_rdata <= {30'd0, up_tx_sysref_sel, up_tx_sysref};
          8'h1c: up_rdata <= {31'd0, up_tx_sync};
          8'h1d: up_rdata <= {15'd0, up_tx_status,
                              6'h3f, up_tx_rst_done_m, up_tx_rst_done,
                              6'h3f, up_tx_pll_locked_m, up_tx_pll_locked};
          8'h1e: up_rdata <= {31'd0, up_tx_user_ready};
          8'h1f: up_rdata <= {31'd0, up_tx_pll_resetn};
          8'h24: up_rdata <= {3'd0, up_drp_rwn, up_drp_addr_int, up_drp_wdata_int};
          8'h25: up_rdata <= {15'd0, up_drp_status, up_drp_rdata_int};
          8'h28: up_rdata <= {29'd0, up_es_init, up_es_stop_hold, up_es_start_hold};
          8'h29: up_rdata <= {27'd0, up_es_prescale};
          8'h2a: up_rdata <= {6'd0, up_es_voffset_range, up_es_voffset_step,
                              up_es_voffset_max, up_es_voffset_min};
          8'h2b: up_rdata <= {4'd0, up_es_hoffset_max, 4'd0, up_es_hoffset_min};
          8'h2c: up_rdata <= {20'd0, up_es_hoffset_step};
          8'h2d: up_rdata <= up_es_start_addr;
          8'h2e: up_rdata <= {up_es_sdata1, up_es_sdata0};
          8'h2f: up_rdata <= {up_es_sdata3, up_es_sdata2};
          8'h30: up_rdata <= up_es_sdata4;
          8'h31: up_rdata <= {up_es_qdata1, up_es_qdata0};
          8'h32: up_rdata <= {up_es_qdata3, up_es_qdata2};
          8'h33: up_rdata <= up_es_qdata4;
          8'h38: up_rdata <= {30'd0, up_es_dma_err_hold, up_es_status};
          8'h39: up_rdata <= {24'd0, up_drp_rxrate};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // resets

  ad_rst i_rx_pll_rst_reg (.preset(up_rx_pll_preset), .clk(up_clk), .rst(rx_pll_rst));
  ad_rst i_rx_gt_rst_reg  (.preset(up_rx_gt_preset),  .clk(up_clk), .rst(rx_gt_rst));
  ad_rst i_rx_ip_rst_reg  (.preset(up_rx_preset),     .clk(up_clk), .rst(rx_ip_rst));
  ad_rst i_rx_rst_reg     (.preset(up_rx_preset),     .clk(rx_clk), .rst(rx_rst));
  ad_rst i_tx_pll_rst_reg (.preset(up_tx_pll_preset), .clk(up_clk), .rst(tx_pll_rst));
  ad_rst i_tx_gt_rst_reg  (.preset(up_tx_gt_preset),  .clk(up_clk), .rst(tx_gt_rst));
  ad_rst i_tx_ip_rst_reg  (.preset(up_tx_preset),     .clk(up_clk), .rst(tx_ip_rst));
  ad_rst i_tx_rst_reg     (.preset(up_tx_preset),     .clk(tx_clk), .rst(tx_rst));

  // reset done & pll locked

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rx_rst_done_m1 <= 'd0;
      up_rx_rst_done <= 'd0;
      up_rx_rst_done_m_m1 <= 'd0;
      up_rx_rst_done_m <= 'd0;
      up_rx_pll_locked_m1 <= 'd0;
      up_rx_pll_locked <= 'd0;
      up_rx_pll_locked_m_m1 <= 'd0;
      up_rx_pll_locked_m <= 'd0;
      up_rx_status_m1 <= 'd0;
      up_rx_status <= 'd0;
      up_tx_rst_done_m1 <= 'd0;
      up_tx_rst_done <= 'd0;
      up_tx_rst_done_m_m1 <= 'd0;
      up_tx_rst_done_m <= 'd0;
      up_tx_pll_locked_m1 <= 'd0;
      up_tx_pll_locked <= 'd0;
      up_tx_pll_locked_m_m1 <= 'd0;
      up_tx_pll_locked_m <= 'd0;
      up_tx_status_m1 <= 'd0;
      up_tx_status <= 'd0;
    end else begin
      up_rx_rst_done_m1 <= rx_rst_done;
      up_rx_rst_done <= up_rx_rst_done_m1;
      up_rx_rst_done_m_m1 <= rx_rst_done_m;
      up_rx_rst_done_m <= up_rx_rst_done_m_m1;
      up_rx_pll_locked_m1 <= rx_pll_locked;
      up_rx_pll_locked <= up_rx_pll_locked_m1;
      up_rx_pll_locked_m_m1 <= rx_pll_locked_m;
      up_rx_pll_locked_m <= up_rx_pll_locked_m_m1;
      up_rx_status_m1 <= rx_sync;
      up_rx_status <= up_rx_status_m1;
      up_tx_rst_done_m1 <= tx_rst_done;
      up_tx_rst_done <= up_tx_rst_done_m1;
      up_tx_rst_done_m_m1 <= tx_rst_done_m;
      up_tx_rst_done_m <= up_tx_rst_done_m_m1;
      up_tx_pll_locked_m1 <= tx_pll_locked;
      up_tx_pll_locked <= up_tx_pll_locked_m1;
      up_tx_pll_locked_m_m1 <= tx_pll_locked_m;
      up_tx_pll_locked_m <= up_tx_pll_locked_m_m1;
      up_tx_status_m1 <= tx_ip_sync;
      up_tx_status <= up_tx_status_m1;
    end
  end

  // drp mux

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_drp_sel <= 'd0;
      up_drp_wr <= 'd0;
      up_drp_addr <= 'd0;
      up_drp_wdata <= 'd0;
      up_es_drp_rdata <= 'd0;
      up_es_drp_ready <= 'd0;
      up_drp_rdata_int <= 'd0;
      up_drp_ready_int <= 'd0;
    end else begin
      if (up_es_status == 1'b1) begin
        up_drp_sel <= up_es_drp_sel;
        up_drp_wr <= up_es_drp_wr;
        up_drp_addr <= up_es_drp_addr;
        up_drp_wdata <= up_es_drp_wdata;
        up_es_drp_rdata <= up_drp_rdata;
        up_es_drp_ready <= up_drp_ready;
        up_drp_rdata_int <= 16'd0;
        up_drp_ready_int <= 1'd0;
      end else begin
        up_drp_sel <= up_drp_sel_int;
        up_drp_wr <= up_drp_wr_int;
        up_drp_addr <= up_drp_addr_int;
        up_drp_wdata <= up_drp_wdata_int;
        up_es_drp_rdata <= 16'd0;
        up_es_drp_ready <= 1'd0;
        up_drp_rdata_int <= up_drp_rdata;
        up_drp_ready_int <= up_drp_ready;
      end
    end
  end

  // rx sysref & sync

  always @(posedge rx_clk or posedge rx_rst_m) begin
    if (rx_rst_m == 1'b1) begin
      rx_sysref_sel_m1 <= 'd0;
      rx_sysref_sel <= 'd0;
      rx_up_sysref_m1 <= 'd0;
      rx_up_sysref <= 'd0;
      rx_ip_sysref <= 'd0;
      rx_up_sync_m1 <= 'd0;
      rx_up_sync <= 'd0;
      rx_sync <= 'd0;
    end else begin
      rx_sysref_sel_m1 <= up_rx_sysref_sel;
      rx_sysref_sel <= rx_sysref_sel_m1;
      rx_up_sysref_m1 <= up_rx_sysref;
      rx_up_sysref <= rx_up_sysref_m1;
      if (rx_sysref_sel_m1 == 1'b1) begin
        rx_ip_sysref <= rx_sysref;
      end else begin
        rx_ip_sysref <= rx_up_sysref;
      end
      rx_up_sync_m1 <= up_rx_sync;
      rx_up_sync <= rx_up_sync_m1;
      rx_sync <= rx_up_sync & rx_ip_sync;
    end
  end

  // tx sysref & sync

  always @(posedge tx_clk or posedge tx_rst_m) begin
    if (tx_rst_m == 1'b1) begin
      tx_sysref_sel_m1 <= 'd0;
      tx_sysref_sel <= 'd0;
      tx_up_sysref_m1 <= 'd0;
      tx_up_sysref <= 'd0;
      tx_ip_sysref <= 'd0;
      tx_up_sync_m1 <= 'd0;
      tx_up_sync <= 'd0;
      tx_ip_sync <= 'd0;
    end else begin
      tx_sysref_sel_m1 <= up_tx_sysref_sel;
      tx_sysref_sel <= tx_sysref_sel_m1;
      tx_up_sysref_m1 <= up_tx_sysref;
      tx_up_sysref <= tx_up_sysref_m1;
      if (tx_sysref_sel_m1 == 1'b1) begin
        tx_ip_sysref <= tx_sysref;
      end else begin
        tx_ip_sysref <= tx_up_sysref;
      end
      tx_up_sync_m1 <= up_tx_sync;
      tx_up_sync <= tx_up_sync_m1;
      tx_ip_sync <= tx_up_sync & tx_sync;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
