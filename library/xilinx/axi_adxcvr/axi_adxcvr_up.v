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

module axi_adxcvr_up #(

  // parameters

  parameter   integer ID = 0,
  parameter   integer NUM_OF_LANES = 8,
  parameter   integer GTH_OR_GTX_N = 0,
  parameter   integer TX_OR_RX_N = 0,
  parameter   integer QPLL_ENABLE = 1,
  parameter           LPM_OR_DFE_N = 1,
  parameter   [ 2:0]  RATE = 3'd0,
  parameter   [ 1:0]  SYS_CLK_SEL = 2'd3,
  parameter   [ 2:0]  OUT_CLK_SEL = 3'd4) (

  // common

  output  [ 7:0]  up_cm_sel,
  output          up_cm_enb,
  output  [11:0]  up_cm_addr,
  output          up_cm_wr,
  output  [15:0]  up_cm_wdata,
  input   [15:0]  up_cm_rdata,
  input           up_cm_ready,

  // channel

  input           up_ch_pll_locked,
  output          up_ch_rst,
  output          up_ch_user_ready,
  input           up_ch_rst_done,
  output          up_ch_lpm_dfe_n,
  output  [ 2:0]  up_ch_rate,
  output  [ 1:0]  up_ch_sys_clk_sel,
  output  [ 2:0]  up_ch_out_clk_sel,
  output  [ 7:0]  up_ch_sel,
  output          up_ch_enb,
  output  [11:0]  up_ch_addr,
  output          up_ch_wr,
  output  [15:0]  up_ch_wdata,
  input   [15:0]  up_ch_rdata,
  input           up_ch_ready,

  // eye-scan

  output  [ 7:0]  up_es_sel,
  output          up_es_req,
  input           up_es_ack,
  output  [ 4:0]  up_es_pscale,
  output  [ 1:0]  up_es_vrange,
  output  [ 7:0]  up_es_vstep,
  output  [ 7:0]  up_es_vmax,
  output  [ 7:0]  up_es_vmin,
  output  [11:0]  up_es_hmax,
  output  [11:0]  up_es_hmin,
  output  [11:0]  up_es_hstep,
  output  [31:0]  up_es_saddr,
  input           up_es_status,

  // status

  output          up_status,
  output          up_pll_rst,

  // bus interface

  input           up_rstn,
  input           up_clk,
  input           up_wreq,
  input   [ 9:0]  up_waddr,
  input   [31:0]  up_wdata,
  output          up_wack,
  input           up_rreq,
  input   [ 9:0]  up_raddr,
  output  [31:0]  up_rdata,
  output          up_rack);

  // parameters

  localparam  [31:0]  VERSION = 32'h00100161;

  // internal registers

  reg             up_wreq_d = 'd0;
  reg     [31:0]  up_scratch = 'd0;
  reg             up_resetn = 'd0;
  reg     [ 3:0]  up_pll_rst_cnt = 'd0;
  reg     [ 3:0]  up_rst_cnt = 'd0;
  reg     [ 6:0]  up_user_ready_cnt = 'd0;
  reg             up_status_int = 'd0;
  reg             up_lpm_dfe_n = 'd0;
  reg     [ 2:0]  up_rate = 'd0;
  reg     [ 1:0]  up_sys_clk_sel = 'd0;
  reg     [ 2:0]  up_out_clk_sel = 'd0;
  reg     [ 7:0]  up_icm_sel = 'd0;
  reg             up_icm_enb = 'd0;
  reg             up_icm_wr = 'd0;
  reg     [28:0]  up_icm_data = 'd0;
  reg     [15:0]  up_icm_rdata = 'd0;
  reg             up_icm_busy = 'd0;
  reg     [ 7:0]  up_ich_sel = 'd0;
  reg             up_ich_enb = 'd0;
  reg             up_ich_wr = 'd0;
  reg     [28:0]  up_ich_data = 'd0;
  reg     [15:0]  up_ich_rdata = 'd0;
  reg             up_ich_busy = 'd0;
  reg     [ 7:0]  up_ies_sel = 'd0;
  reg             up_ies_req = 'd0;
  reg     [ 4:0]  up_ies_prescale = 'd0;
  reg     [ 1:0]  up_ies_voffset_range = 'd0;
  reg     [ 7:0]  up_ies_voffset_step = 'd0;
  reg     [ 7:0]  up_ies_voffset_max = 'd0;
  reg     [ 7:0]  up_ies_voffset_min = 'd0;
  reg     [11:0]  up_ies_hoffset_max = 'd0;
  reg     [11:0]  up_ies_hoffset_min = 'd0;
  reg     [11:0]  up_ies_hoffset_step = 'd0;
  reg     [31:0]  up_ies_start_addr = 'd0;
  reg             up_ies_status = 'd0;
  reg             up_rreq_d = 'd0;
  reg     [31:0]  up_rdata_d = 'd0;

  // internal signals

  wire    [31:0]  up_rparam_s;

  // defaults

  assign up_wack = up_wreq_d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wreq_d <= 'd0;
      up_scratch <= 'd0;
    end else begin
      up_wreq_d <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 10'h002)) begin
        up_scratch <= up_wdata;
      end
    end
  end

  // reset-controller

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_resetn <= 'd0;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == 10'h004)) begin
        up_resetn <= up_wdata[0];
      end
    end
  end

  assign up_pll_rst = up_pll_rst_cnt[3];
  assign up_ch_rst = up_rst_cnt[3];
  assign up_ch_user_ready = up_user_ready_cnt[6];
  assign up_status = up_status_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_pll_rst_cnt <= 4'h8;
      up_rst_cnt <= 4'h8;
      up_user_ready_cnt <= 7'h00;
      up_status_int <= 1'b0;
    end else begin
      if (up_resetn == 1'b0) begin
        up_pll_rst_cnt <= 4'h8;
      end else if (up_pll_rst_cnt[3] == 1'b1) begin
        up_pll_rst_cnt <= up_pll_rst_cnt + 1'b1;
      end
      if ((up_resetn == 1'b0) || (up_pll_rst_cnt[3] == 1'b1) ||
        (up_ch_pll_locked == 1'b0)) begin
        up_rst_cnt <= 4'h8;
      end else if (up_rst_cnt[3] == 1'b1) begin
        up_rst_cnt <= up_rst_cnt + 1'b1;
      end
      if ((up_resetn == 1'b0) || (up_rst_cnt[3] == 1'b1)) begin
        up_user_ready_cnt <= 7'h00;
      end else if (up_user_ready_cnt[6] == 1'b0) begin
        up_user_ready_cnt <= up_user_ready_cnt + 1'b1;
      end
      if (up_resetn == 1'b0) begin
        up_status_int <= 1'b0;
      end else if (up_ch_rst_done == 1'b1) begin
        up_status_int <= 1'b1;
      end
    end
  end

  // control signals

  assign up_ch_lpm_dfe_n = up_lpm_dfe_n;
  assign up_ch_rate = up_rate;
  assign up_ch_sys_clk_sel = up_sys_clk_sel;
  assign up_ch_out_clk_sel = up_out_clk_sel;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_lpm_dfe_n <= LPM_OR_DFE_N;
      up_rate <= RATE;
      up_sys_clk_sel <= SYS_CLK_SEL;
      up_out_clk_sel <= OUT_CLK_SEL;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == 10'h008)) begin
        up_lpm_dfe_n <= up_wdata[12];
        up_rate <= up_wdata[10:8];
        up_sys_clk_sel <= up_wdata[5:4];
        up_out_clk_sel <= up_wdata[2:0];
      end
    end
  end

  // common access

  assign up_cm_sel = up_icm_sel;
  assign up_cm_enb = up_icm_enb;
  assign up_cm_wr = up_icm_wr;
  assign up_cm_addr = up_icm_data[27:16];
  assign up_cm_wdata = up_icm_data[15:0];

  generate
  if (QPLL_ENABLE == 0) begin
  always @(posedge up_clk) begin
    up_icm_sel <= 'd0;
    up_icm_enb <= 'd0;
    up_icm_wr <= 'd0;
    up_icm_data <= 'd0;
    up_icm_rdata <= 'd0;
    up_icm_busy <= 'd0;
  end
  end else begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_icm_sel <= 'd0;
      up_icm_enb <= 'd0;
      up_icm_wr <= 'd0;
      up_icm_data <= 'd0;
      up_icm_rdata <= 'd0;
      up_icm_busy <= 'd0;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == 10'h010)) begin
        up_icm_sel <= up_wdata[7:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h011)) begin
        up_icm_enb <= 1'b1;
        up_icm_wr <= up_wdata[28];
      end else begin
        up_icm_enb <= 1'b0;
        up_icm_wr <= 1'b0;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h011)) begin
        up_icm_data <= up_wdata[28:0];
      end
      if (up_cm_ready == 1'b1) begin
        up_icm_rdata <= up_cm_rdata;
        up_icm_busy <= 1'b0;
      end else if ((up_wreq == 1'b1) && (up_waddr == 10'h011)) begin
        up_icm_rdata <= 16'd0;
        up_icm_busy <= 1'b1;
      end
    end
  end
  end
  endgenerate

  // channel access

  assign up_ch_sel = up_ich_sel;
  assign up_ch_enb = up_ich_enb;
  assign up_ch_wr = up_ich_wr;
  assign up_ch_addr = up_ich_data[27:16];
  assign up_ch_wdata = up_ich_data[15:0];

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_ich_sel <= 'd0;
      up_ich_enb <= 'd0;
      up_ich_wr <= 'd0;
      up_ich_data <= 'd0;
      up_ich_rdata <= 'd0;
      up_ich_busy <= 'd0;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == 10'h018)) begin
        up_ich_sel <= up_wdata[7:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h019)) begin
        up_ich_enb <= 1'b1;
        up_ich_wr <= up_wdata[28];
      end else begin
        up_ich_enb <= 1'b0;
        up_ich_wr <= 1'b0;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h019)) begin
        up_ich_data <= up_wdata[28:0];
      end
      if (up_ch_ready == 1'b1) begin
        up_ich_rdata <= up_ch_rdata;
        up_ich_busy <= 1'b0;
      end else if ((up_wreq == 1'b1) && (up_waddr == 10'h019)) begin
        up_ich_rdata <= 16'd0;
        up_ich_busy <= 1'b1;
      end
    end
  end

  // eye-scan

  assign up_es_sel = up_ies_sel;
  assign up_es_req = up_ies_req;
  assign up_es_pscale = up_ies_prescale;
  assign up_es_vrange = up_ies_voffset_range;
  assign up_es_vstep = up_ies_voffset_step;
  assign up_es_vmax = up_ies_voffset_max;
  assign up_es_vmin = up_ies_voffset_min;
  assign up_es_hmax = up_ies_hoffset_max;
  assign up_es_hmin = up_ies_hoffset_min;
  assign up_es_hstep = up_ies_hoffset_step;
  assign up_es_saddr = up_ies_start_addr;

  generate
  if (TX_OR_RX_N == 1) begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_ies_sel <= 'd0;
      up_ies_req <= 'd0;
      up_ies_prescale <= 'd0;
      up_ies_voffset_range <= 'd0;
      up_ies_voffset_step <= 'd0;
      up_ies_voffset_max <= 'd0;
      up_ies_voffset_min <= 'd0;
      up_ies_hoffset_max <= 'd0;
      up_ies_hoffset_min <= 'd0;
      up_ies_hoffset_step <= 'd0;
      up_ies_start_addr <= 'd0;
      up_ies_status <= 'd0;
    end else begin
      up_ies_sel <= 'd0;
      up_ies_req <= 'd0;
      up_ies_prescale <= 'd0;
      up_ies_voffset_range <= 'd0;
      up_ies_voffset_step <= 'd0;
      up_ies_voffset_max <= 'd0;
      up_ies_voffset_min <= 'd0;
      up_ies_hoffset_max <= 'd0;
      up_ies_hoffset_min <= 'd0;
      up_ies_hoffset_step <= 'd0;
      up_ies_start_addr <= 'd0;
      up_ies_status <= 'd0;
    end
  end
  end else begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_ies_sel <= 'd0;
      up_ies_req <= 'd0;
      up_ies_prescale <= 'd0;
      up_ies_voffset_range <= 'd0;
      up_ies_voffset_step <= 'd0;
      up_ies_voffset_max <= 'd0;
      up_ies_voffset_min <= 'd0;
      up_ies_hoffset_max <= 'd0;
      up_ies_hoffset_min <= 'd0;
      up_ies_hoffset_step <= 'd0;
      up_ies_start_addr <= 'd0;
      up_ies_status <= 'd0;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == 10'h020)) begin
        up_ies_sel <= up_wdata[7:0];
      end
      if (up_es_ack == 1'b1) begin
        up_ies_req <= 1'b0;
      end else if ((up_wreq == 1'b1) && (up_waddr == 10'h028)) begin
        up_ies_req <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h029)) begin
        up_ies_prescale <= up_wdata[4:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h02a)) begin
        up_ies_voffset_range <= up_wdata[25:24];
        up_ies_voffset_step <= up_wdata[23:16];
        up_ies_voffset_max <= up_wdata[15:8];
        up_ies_voffset_min <= up_wdata[7:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h02b)) begin
        up_ies_hoffset_max <= up_wdata[27:16];
        up_ies_hoffset_min <= up_wdata[11:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h02c)) begin
        up_ies_hoffset_step <= up_wdata[11:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 10'h02d)) begin
        up_ies_start_addr <= up_wdata;
      end
      if (up_es_status == 1'b1) begin
        up_ies_status <= 1'b1;
      end else if ((up_wreq == 1'b1) && (up_waddr == 10'h02e)) begin
        up_ies_status <= up_ies_status & ~up_wdata[0];
      end
    end
  end
  end
  endgenerate

  // read interface

  assign up_rack = up_rreq_d;
  assign up_rdata = up_rdata_d;

  // altera specific

  assign up_rparam_s[31:24] = 8'd0;

  // xilinx specific
 
  assign up_rparam_s[23:21] = 3'd0;
  assign up_rparam_s[20:20] = (QPLL_ENABLE == 0) ? 1'b0 : 1'b1;
  assign up_rparam_s[19:16] = (GTH_OR_GTX_N == 0) ? 1'b0 : 1'b1;

  // generic

  assign up_rparam_s[15: 9] = 7'd0;
  assign up_rparam_s[ 8: 8] = (TX_OR_RX_N == 0) ? 1'b0 : 1'b1;
  assign up_rparam_s[ 7: 0] = NUM_OF_LANES;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rreq_d <= 'd0;
      up_rdata_d <= 'd0;
    end else begin
      up_rreq_d <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          10'h000: up_rdata_d <= VERSION;
          10'h001: up_rdata_d <= ID;
          10'h002: up_rdata_d <= up_scratch;
          10'h004: up_rdata_d <= {31'd0, up_resetn};
          10'h005: up_rdata_d <= {31'd0, up_status_int};
          10'h006: up_rdata_d <= {17'd0, up_user_ready_cnt, up_rst_cnt, up_pll_rst_cnt};
          10'h008: up_rdata_d <= {19'd0, up_lpm_dfe_n, 1'd0, up_rate, 2'd0, up_sys_clk_sel, 1'd0, up_out_clk_sel};
          10'h009: up_rdata_d <= up_rparam_s;
          10'h010: up_rdata_d <= {24'd0, up_icm_sel};
          10'h011: up_rdata_d <= {3'd0, up_icm_data};
          10'h012: up_rdata_d <= {15'd0, up_icm_busy, up_icm_rdata};
          10'h018: up_rdata_d <= {24'd0, up_ich_sel};
          10'h019: up_rdata_d <= {3'd0, up_ich_data};
          10'h01a: up_rdata_d <= {15'd0, up_ich_busy, up_ich_rdata};
          10'h020: up_rdata_d <= {24'd0, up_ies_sel};
          10'h028: up_rdata_d <= {31'd0, up_ies_req};
          10'h029: up_rdata_d <= {27'd0, up_ies_prescale};
          10'h02a: up_rdata_d <= {6'd0, up_ies_voffset_range, up_ies_voffset_step, up_ies_voffset_max, up_ies_voffset_min};
          10'h02b: up_rdata_d <= {4'd0, up_ies_hoffset_max, 4'd0, up_ies_hoffset_min};
          10'h02c: up_rdata_d <= {20'd0, up_ies_hoffset_step};
          10'h02d: up_rdata_d <= up_ies_start_addr;
          10'h02e: up_rdata_d <= {31'd0, up_es_status};
          default: up_rdata_d <= 32'd0;
        endcase
      end else begin
        up_rdata_d <= 32'd0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
