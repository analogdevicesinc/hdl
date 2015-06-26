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

module up_gt (

  // gt interface

  gt_pll_rst,
  gt_rx_rst,
  gt_tx_rst,
  up_lpm_dfe_n,
  up_cpll_pd,
  up_rx_sys_clk_sel,
  up_rx_out_clk_sel,
  up_tx_sys_clk_sel,
  up_tx_out_clk_sel,

  // receive interface

  rx_clk,
  rx_rst,
  rx_jesd_rst,
  rx_ext_sysref,
  rx_sysref,
  rx_ip_sync,
  rx_sync,
  rx_rst_done,
  rx_pll_locked,
  rx_error,
  rx_rst_done_up,

  // transmit interface

  tx_clk,
  tx_rst,
  tx_jesd_rst,
  tx_ext_sysref,
  tx_sysref,
  tx_sync,
  tx_ip_sync,
  tx_rst_done,
  tx_pll_locked,
  tx_error,
  tx_rst_done_up,

  // drp interface

  up_drp_sel,
  up_drp_wr,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,
  up_drp_lanesel,
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
  up_es_dmaerr,
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

  localparam  PCORE_VERSION = 32'h00060162;
  parameter   PCORE_ID = 0;
  parameter   PCORE_DEVICE_TYPE = 0;

  // gt interface

  output          gt_pll_rst;
  output          gt_rx_rst;
  output          gt_tx_rst;
  output          up_lpm_dfe_n;
  output          up_cpll_pd;
  output  [ 1:0]  up_rx_sys_clk_sel;
  output  [ 2:0]  up_rx_out_clk_sel;
  output  [ 1:0]  up_tx_sys_clk_sel;
  output  [ 2:0]  up_tx_out_clk_sel;

  // receive interface

  input           rx_clk;
  output          rx_rst;
  output          rx_jesd_rst;
  input           rx_ext_sysref;
  output          rx_sysref;
  input           rx_ip_sync;
  output          rx_sync;
  input   [ 7:0]  rx_rst_done;
  input   [ 7:0]  rx_pll_locked;
  input           rx_error;
  output          rx_rst_done_up;

  // transmit interface

  input           tx_clk;
  output          tx_rst;
  output          tx_jesd_rst;
  input           tx_ext_sysref;
  output          tx_sysref;
  input           tx_sync;
  output          tx_ip_sync;
  input   [ 7:0]  tx_rst_done;
  input   [ 7:0]  tx_pll_locked;
  input           tx_error;
  output          tx_rst_done_up;

  // drp interface

  output          up_drp_sel;
  output          up_drp_wr;
  output  [11:0]  up_drp_addr;
  output  [15:0]  up_drp_wdata;
  input   [15:0]  up_drp_rdata;
  input           up_drp_ready;
  output  [ 7:0]  up_drp_lanesel;
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
  input           up_es_dmaerr;
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

  reg             up_gt_pll_preset = 'd1;
  reg             up_gt_rx_preset = 'd1;
  reg             up_gt_tx_preset = 'd1;
  reg             up_rx_preset = 'd1;
  reg             up_tx_preset = 'd1;
  reg             up_wack = 'd0;
  reg     [31:0]  up_scratch = 'd0;
  reg             up_lpm_dfe_n = 'd0;
  reg             up_cpll_pd = 'd0;
  reg             up_drp_resetn = 'd0;
  reg             up_gt_pll_resetn = 'd0;
  reg             up_gt_rx_resetn = 'd0;
  reg             up_rx_resetn = 'd0;
  reg     [ 1:0]  up_rx_sys_clk_sel = 'd0;
  reg     [ 2:0]  up_rx_out_clk_sel = 'd0;
  reg             up_rx_sysref_sel = 'd0;
  reg             up_rx_sysref = 'd0;
  reg             up_rx_sync = 'd0;
  reg             up_gt_tx_resetn = 'd0;
  reg             up_tx_resetn = 'd0;
  reg     [ 1:0]  up_tx_sys_clk_sel = 'd0;
  reg     [ 2:0]  up_tx_out_clk_sel = 'd0;
  reg             up_tx_sysref_sel = 'd0;
  reg             up_tx_sysref = 'd0;
  reg             up_tx_sync = 'd0;
  reg     [ 7:0]  up_drp_lanesel = 'd0;
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
  reg             up_es_dmaerr_hold = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg     [ 7:0]  up_rx_rst_done_m1 = 'd0;
  reg     [ 7:0]  up_rx_pll_locked_m1 = 'd0;
  reg     [ 7:0]  up_tx_rst_done_m1 = 'd0;
  reg     [ 7:0]  up_tx_pll_locked_m1 = 'd0;
  reg     [ 7:0]  up_rx_rst_done = 'd0;
  reg     [ 7:0]  up_rx_pll_locked = 'd0;
  reg     [ 7:0]  up_tx_rst_done = 'd0;
  reg     [ 7:0]  up_tx_pll_locked = 'd0;
  reg             rx_sysref_m1 = 'd0;
  reg             rx_sysref_m2 = 'd0;
  reg             rx_sysref_m3 = 'd0;
  reg             rx_sysref = 'd0;
  reg             rx_sync_m1 = 'd0;
  reg             rx_sync_m2 = 'd0;
  reg             rx_sync = 'd0;
  reg             tx_sysref_m1 = 'd0;
  reg             tx_sysref_m2 = 'd0;
  reg             tx_sysref_m3 = 'd0;
  reg             tx_sysref = 'd0;
  reg             tx_ip_sync_m1 = 'd0;
  reg             tx_ip_sync_m2 = 'd0;
  reg             tx_ip_sync = 'd0;
  reg             up_rx_status_m1 = 'd0;
  reg             up_rx_status = 'd0;
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

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire            up_rx_rst_done_s;
  wire            up_rx_pll_locked_s;
  wire            up_tx_rst_done_s;
  wire            up_tx_pll_locked_s;
  wire            rx_sysref_s;
  wire            tx_sysref_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == 6'h00) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == 6'h00) ? up_rreq : 1'b0;

  // status inputs

  assign up_rx_rst_done_s = & up_rx_rst_done;
  assign up_rx_pll_locked_s = & up_rx_pll_locked;

  assign up_tx_rst_done_s = & up_tx_rst_done;
  assign up_tx_pll_locked_s = & up_tx_pll_locked;

  // resets

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_gt_pll_preset <= 1'b1;
      up_gt_rx_preset <= 1'b1;
      up_gt_tx_preset <= 1'b1;
      up_rx_preset <= 1'b1;
      up_tx_preset <= 1'b1;
    end else begin
      up_gt_pll_preset <= ~up_gt_pll_resetn;
      up_gt_rx_preset <= ~(up_gt_pll_resetn & up_gt_rx_resetn & up_rx_pll_locked_s);
      up_gt_tx_preset <= ~(up_gt_pll_resetn & up_gt_tx_resetn & up_tx_pll_locked_s);
      up_rx_preset <= ~(up_gt_pll_resetn & up_gt_rx_resetn & up_rx_resetn & up_rx_pll_locked_s & up_rx_rst_done_s);
      up_tx_preset <= ~(up_gt_pll_resetn & up_gt_tx_resetn & up_tx_resetn & up_tx_pll_locked_s & up_tx_rst_done_s);
    end
  end

  // up clock domain reset done

  assign rx_rst_done_up  = up_rx_rst_done_s;
  assign tx_rst_done_up  = up_tx_rst_done_s;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_lpm_dfe_n <= 'd0;
      up_cpll_pd <= 'd1;
      up_drp_resetn <= 'd0;
      up_gt_pll_resetn <= 'd0;
      up_gt_rx_resetn <= 'd0;
      up_rx_resetn <= 'd0;
      up_rx_sys_clk_sel <= 2'b11;
      up_rx_out_clk_sel <= 3'b010;
      up_rx_sysref_sel <= 'd0;
      up_rx_sysref <= 'd0;
      up_rx_sync <= 'd0;
      up_gt_tx_resetn <= 'd0;
      up_tx_resetn <= 'd0;
      up_tx_sys_clk_sel <= 2'b11;
      up_tx_out_clk_sel <= 3'b010;
      up_tx_sysref_sel <= 'd0;
      up_tx_sysref <= 'd0;
      up_tx_sync <= 'd0;
      up_drp_lanesel <= 'd0;
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
      up_es_dmaerr_hold <= 'd0;
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
        up_gt_pll_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h08)) begin
        up_gt_rx_resetn <= up_wdata[0];
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
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h18)) begin
        up_gt_tx_resetn <= up_wdata[0];
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
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h23)) begin
        up_drp_lanesel <= up_wdata[7:0];
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
      if (up_es_dmaerr == 1'b1) begin
        up_es_dmaerr_hold <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h38)) begin
        up_es_dmaerr_hold <= up_es_dmaerr_hold & ~up_wdata[1];
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
          8'h00: up_rdata <= PCORE_VERSION;
          8'h01: up_rdata <= PCORE_ID;
          8'h02: up_rdata <= up_scratch;
          8'h04: up_rdata <= {30'd0, up_lpm_dfe_n, up_cpll_pd};
          8'h05: up_rdata <= {30'd0, up_drp_resetn, up_gt_pll_resetn};
          8'h08: up_rdata <= {31'd0, up_gt_rx_resetn};
          8'h09: up_rdata <= {31'd0, up_rx_resetn};
          8'h0a: up_rdata <= {24'd0, 2'd0, up_rx_sys_clk_sel, 1'd0, up_rx_out_clk_sel};
          8'h0b: up_rdata <= {30'd0, up_rx_sysref_sel, up_rx_sysref};
          8'h0c: up_rdata <= {31'd0, up_rx_sync};
          8'h0d: up_rdata <= {15'd0, up_rx_status, up_rx_rst_done, up_rx_pll_locked};
          8'h18: up_rdata <= {31'd0, up_gt_tx_resetn};
          8'h19: up_rdata <= {31'd0, up_tx_resetn};
          8'h1a: up_rdata <= {24'd0, 2'd0, up_tx_sys_clk_sel, 1'd0, up_tx_out_clk_sel};
          8'h1b: up_rdata <= {30'd0, up_tx_sysref_sel, up_tx_sysref};
          8'h1c: up_rdata <= {31'd0, up_tx_sync};
          8'h1d: up_rdata <= {15'd0, up_tx_status, up_tx_rst_done, up_tx_pll_locked};
          8'h23: up_rdata <= {24'd0, up_drp_lanesel};
          8'h24: up_rdata <= {3'd0, up_drp_rwn, up_drp_addr_int, up_drp_wdata_int};
          8'h25: up_rdata <= {15'd0, up_drp_status, up_drp_rdata_int};
          8'h28: up_rdata <= {29'd0, up_es_init, up_es_stop_hold, up_es_start_hold};
          8'h29: up_rdata <= {27'd0, up_es_prescale};
          8'h2a: up_rdata <= {6'd0, up_es_voffset_range, up_es_voffset_step, up_es_voffset_max, up_es_voffset_min};
          8'h2b: up_rdata <= {4'd0, up_es_hoffset_max, 4'd0, up_es_hoffset_min};
          8'h2c: up_rdata <= {20'd0, up_es_hoffset_step};
          8'h2d: up_rdata <= up_es_start_addr;
          8'h2e: up_rdata <= {up_es_sdata1, up_es_sdata0};
          8'h2f: up_rdata <= {up_es_sdata3, up_es_sdata2};
          8'h30: up_rdata <= up_es_sdata4;
          8'h31: up_rdata <= {up_es_qdata1, up_es_qdata0};
          8'h32: up_rdata <= {up_es_qdata3, up_es_qdata2};
          8'h33: up_rdata <= up_es_qdata4;
          8'h38: up_rdata <= {30'd0, up_es_dmaerr_hold, up_es_status};
          8'h39: up_rdata <= {24'd0, up_drp_rxrate};
          8'h3a: up_rdata <= PCORE_DEVICE_TYPE;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // resets

  ad_rst i_gt_pll_rst_reg (.preset(up_gt_pll_preset), .clk(up_clk),   .rst(gt_pll_rst));
  ad_rst i_gt_rx_rst_reg  (.preset(up_gt_rx_preset),  .clk(up_clk),   .rst(gt_rx_rst));
  ad_rst i_gt_tx_rst_reg  (.preset(up_gt_tx_preset),  .clk(up_clk),   .rst(gt_tx_rst));
  ad_rst i_rx_rst_reg     (.preset(up_rx_preset),     .clk(rx_clk),   .rst(rx_rst));
  ad_rst i_j_rx_rst_reg   (.preset(up_rx_preset),     .clk(up_clk),   .rst(rx_jesd_rst));
  ad_rst i_tx_rst_reg     (.preset(up_tx_preset),     .clk(tx_clk),   .rst(tx_rst));
  ad_rst i_j_tx_rst_reg   (.preset(up_tx_preset),     .clk(up_clk),   .rst(tx_jesd_rst));

  // reset done & pll locked
  
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rx_rst_done_m1 <= 'd0;
      up_rx_pll_locked_m1 <= 'd0;
      up_tx_rst_done_m1 <= 'd0;
      up_tx_pll_locked_m1 <= 'd0;
      up_rx_rst_done <= 'd0;
      up_rx_pll_locked <= 'd0;
      up_tx_rst_done <= 'd0;
      up_tx_pll_locked <= 'd0;
    end else begin
      up_rx_rst_done_m1 <= rx_rst_done;
      up_rx_pll_locked_m1 <= rx_pll_locked;
      up_tx_rst_done_m1 <= tx_rst_done;
      up_tx_pll_locked_m1 <= tx_pll_locked;
      up_rx_rst_done <= up_rx_rst_done_m1;
      up_rx_pll_locked <= up_rx_pll_locked_m1;
      up_tx_rst_done <= up_tx_rst_done_m1;
      up_tx_pll_locked <= up_tx_pll_locked_m1;
    end
  end

  // rx sysref & sync

  assign rx_sysref_s = (up_rx_sysref_sel == 1'b1) ? rx_ext_sysref : up_rx_sysref;

  always @(posedge rx_clk) begin
    if (rx_rst == 1'b1) begin
      rx_sysref_m1 <= 'd0;
      rx_sysref_m2 <= 'd0;
      rx_sysref_m3 <= 'd0;
      rx_sysref <= 'd0;
      rx_sync_m1 <= 'd0;
      rx_sync_m2 <= 'd0;
      rx_sync <= 'd0;
    end else begin
      rx_sysref_m1 <= rx_sysref_s;
      rx_sysref_m2 <= rx_sysref_m1;
      rx_sysref_m3 <= rx_sysref_m2;
      rx_sysref <= rx_sysref_m2 & ~rx_sysref_m3;
      rx_sync_m1 <= up_rx_sync & rx_ip_sync;
      rx_sync_m2 <= rx_sync_m1;
      rx_sync <= rx_sync_m2;
    end
  end

  // tx sysref & sync

  assign tx_sysref_s = (up_tx_sysref_sel == 1'b1) ? tx_ext_sysref : up_tx_sysref;

  always @(posedge tx_clk) begin
    if (tx_rst == 1'b1) begin
      tx_sysref_m1 <= 'd0;
      tx_sysref_m2 <= 'd0;
      tx_sysref_m3 <= 'd0;
      tx_sysref <= 'd0;
      tx_ip_sync_m1 <= 'd0;
      tx_ip_sync_m2 <= 'd0;
      tx_ip_sync <= 'd0;
    end else begin
      tx_sysref_m1 <= tx_sysref_s;
      tx_sysref_m2 <= tx_sysref_m1;
      tx_sysref_m3 <= tx_sysref_m2;
      tx_sysref <= tx_sysref_m2 & ~tx_sysref_m3;
      tx_ip_sync_m1 <= up_tx_sync & tx_sync;
      tx_ip_sync_m2 <= tx_ip_sync_m1;
      tx_ip_sync <= tx_ip_sync_m2;
    end
  end

  // status

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rx_status_m1 <= 'd0;
      up_rx_status <= 'd0;
      up_tx_status_m1 <= 'd0;
      up_tx_status <= 'd0;
    end else begin
      up_rx_status_m1 <= rx_sync & ~rx_error;
      up_rx_status <= up_rx_status_m1;
      up_tx_status_m1 <= tx_ip_sync & ~tx_error;
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

endmodule

// ***************************************************************************
// ***************************************************************************
