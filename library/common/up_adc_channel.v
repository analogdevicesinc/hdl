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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module up_adc_channel (

  // adc interface

  adc_clk,
  adc_rst,
  adc_enable,
  adc_iqcor_enb,
  adc_dcfilt_enb,
  adc_dfmt_se,
  adc_dfmt_type,
  adc_dfmt_enable,
  adc_dcfilt_offset,
  adc_dcfilt_coeff,
  adc_iqcor_coeff_1,
  adc_iqcor_coeff_2,
  adc_pnseq_sel,
  adc_data_sel,
  adc_pn_err,
  adc_pn_oos,
  adc_or,
  up_adc_pn_err,
  up_adc_pn_oos,
  up_adc_or,

  // user controls

  up_usr_datatype_be,
  up_usr_datatype_signed,
  up_usr_datatype_shift,
  up_usr_datatype_total_bits,
  up_usr_datatype_bits,
  up_usr_decimation_m,
  up_usr_decimation_n,
  adc_usr_datatype_be,
  adc_usr_datatype_signed,
  adc_usr_datatype_shift,
  adc_usr_datatype_total_bits,
  adc_usr_datatype_bits,
  adc_usr_decimation_m,
  adc_usr_decimation_n,

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

  parameter ADC_CHANNEL_ID = 4'h0;

  // adc interface

  input           adc_clk;
  input           adc_rst;
  output          adc_enable;
  output          adc_iqcor_enb;
  output          adc_dcfilt_enb;
  output          adc_dfmt_se;
  output          adc_dfmt_type;
  output          adc_dfmt_enable;
  output  [15:0]  adc_dcfilt_offset;
  output  [15:0]  adc_dcfilt_coeff;
  output  [15:0]  adc_iqcor_coeff_1;
  output  [15:0]  adc_iqcor_coeff_2;
  output  [ 3:0]  adc_pnseq_sel;
  output  [ 3:0]  adc_data_sel;
  input           adc_pn_err;
  input           adc_pn_oos;
  input           adc_or;
  output          up_adc_pn_err;
  output          up_adc_pn_oos;
  output          up_adc_or;

  // user controls

  output          up_usr_datatype_be;
  output          up_usr_datatype_signed;
  output  [ 7:0]  up_usr_datatype_shift;
  output  [ 7:0]  up_usr_datatype_total_bits;
  output  [ 7:0]  up_usr_datatype_bits;
  output  [15:0]  up_usr_decimation_m;
  output  [15:0]  up_usr_decimation_n;
  input           adc_usr_datatype_be;
  input           adc_usr_datatype_signed;
  input   [ 7:0]  adc_usr_datatype_shift;
  input   [ 7:0]  adc_usr_datatype_total_bits;
  input   [ 7:0]  adc_usr_datatype_bits;
  input   [15:0]  adc_usr_decimation_m;
  input   [15:0]  adc_usr_decimation_n;

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

  reg             up_wack = 'd0;
  reg             up_adc_lb_enb = 'd0;
  reg             up_adc_pn_sel = 'd0;
  reg             up_adc_iqcor_enb = 'd0;
  reg             up_adc_dcfilt_enb = 'd0;
  reg             up_adc_dfmt_se = 'd0;
  reg             up_adc_dfmt_type = 'd0;
  reg             up_adc_dfmt_enable = 'd0;
  reg             up_adc_pn_type = 'd0;
  reg             up_adc_enable = 'd0;
  reg             up_adc_pn_err = 'd0;
  reg             up_adc_pn_oos = 'd0;
  reg             up_adc_or = 'd0;
  reg     [15:0]  up_adc_dcfilt_offset = 'd0;
  reg     [15:0]  up_adc_dcfilt_coeff = 'd0;
  reg     [15:0]  up_adc_iqcor_coeff_1 = 'd0;
  reg     [15:0]  up_adc_iqcor_coeff_2 = 'd0;
  reg     [ 3:0]  up_adc_pnseq_sel = 'd0;
  reg     [ 3:0]  up_adc_data_sel = 'd0;
  reg             up_usr_datatype_be = 'd0;
  reg             up_usr_datatype_signed = 'd0;
  reg     [ 7:0]  up_usr_datatype_shift = 'd0;
  reg     [ 7:0]  up_usr_datatype_total_bits = 'd0;
  reg     [ 7:0]  up_usr_datatype_bits = 'd0;
  reg     [15:0]  up_usr_decimation_m = 'd0;
  reg     [15:0]  up_usr_decimation_n = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg     [15:0]  up_adc_iqcor_coeff_tc_1 = 'd0;
  reg     [15:0]  up_adc_iqcor_coeff_tc_2 = 'd0;
  reg     [ 3:0]  up_adc_pnseq_sel_m = 'd0;
  reg     [ 3:0]  up_adc_data_sel_m = 'd0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire            up_adc_pn_err_s;
  wire            up_adc_pn_oos_s;
  wire            up_adc_or_s;

  // 2's complement function

  function [15:0] sm2tc;
    input [15:0]  din;
    reg   [15:0]  dp;
    reg   [15:0]  dn;
    reg   [15:0]  dout;
    begin
      dp = {1'b0, din[14:0]};
      dn = ~dp + 1'b1;
      dout = (din[15] == 1'b1) ? dn : dp;
      sm2tc = dout;
    end
  endfunction

  // decode block select

  assign up_wreq_s = ((up_waddr[13:8] == 6'h01) && (up_waddr[7:4] == ADC_CHANNEL_ID)) ? up_wreq : 1'b0;
  assign up_rreq_s = ((up_raddr[13:8] == 6'h01) && (up_raddr[7:4] == ADC_CHANNEL_ID)) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_adc_lb_enb <= 'd0;
      up_adc_pn_sel <= 'd0;
      up_adc_iqcor_enb <= 'd0;
      up_adc_dcfilt_enb <= 'd0;
      up_adc_dfmt_se <= 'd0;
      up_adc_dfmt_type <= 'd0;
      up_adc_dfmt_enable <= 'd0;
      up_adc_pn_type <= 'd0;
      up_adc_enable <= 'd0;
      up_adc_pn_err <= 'd0;
      up_adc_pn_oos <= 'd0;
      up_adc_or <= 'd0;
      up_adc_dcfilt_offset <= 'd0;
      up_adc_dcfilt_coeff <= 'd0;
      up_adc_iqcor_coeff_1 <= 'd0;
      up_adc_iqcor_coeff_2 <= 'd0;
      up_adc_pnseq_sel <= 'd0;
      up_adc_data_sel <= 'd0;
      up_usr_datatype_be <= 'd0;
      up_usr_datatype_signed <= 'd0;
      up_usr_datatype_shift <= 'd0;
      up_usr_datatype_total_bits <= 'd0;
      up_usr_datatype_bits <= 'd0;
      up_usr_decimation_m <= 'd0;
      up_usr_decimation_n <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_adc_lb_enb <= up_wdata[11];
        up_adc_pn_sel <= up_wdata[10];
        up_adc_iqcor_enb <= up_wdata[9];
        up_adc_dcfilt_enb <= up_wdata[8];
        up_adc_dfmt_se <= up_wdata[6];
        up_adc_dfmt_type <= up_wdata[5];
        up_adc_dfmt_enable <= up_wdata[4];
        up_adc_pn_type <= up_wdata[1];
        up_adc_enable <= up_wdata[0];
      end
      if (up_adc_pn_err_s == 1'b1) begin
        up_adc_pn_err <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_adc_pn_err <= up_adc_pn_err & ~up_wdata[2];
      end
      if (up_adc_pn_oos_s == 1'b1) begin
        up_adc_pn_oos <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_adc_pn_oos <= up_adc_pn_oos & ~up_wdata[1];
      end
      if (up_adc_or_s == 1'b1) begin
        up_adc_or <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_adc_or <= up_adc_or & ~up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h4)) begin
        up_adc_dcfilt_offset <= up_wdata[31:16];
        up_adc_dcfilt_coeff <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h5)) begin
        up_adc_iqcor_coeff_1 <= up_wdata[31:16];
        up_adc_iqcor_coeff_2 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h6)) begin
        up_adc_pnseq_sel <= up_wdata[19:16];
        up_adc_data_sel <= up_wdata[3:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h8)) begin
        up_usr_datatype_be <= up_wdata[25];
        up_usr_datatype_signed <= up_wdata[24];
        up_usr_datatype_shift <= up_wdata[23:16];
        up_usr_datatype_total_bits <= up_wdata[15:8];
        up_usr_datatype_bits <= up_wdata[7:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h9)) begin
        up_usr_decimation_m <= up_wdata[31:16];
        up_usr_decimation_n <= up_wdata[15:0];
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
        case (up_raddr[3:0])
          4'h0: up_rdata <= {20'd0, up_adc_lb_enb, up_adc_pn_sel,
                              up_adc_iqcor_enb, up_adc_dcfilt_enb,
                              1'd0, up_adc_dfmt_se, up_adc_dfmt_type, up_adc_dfmt_enable,
                              2'd0, up_adc_pn_type, up_adc_enable};
          4'h1: up_rdata <= {29'd0, up_adc_pn_err, up_adc_pn_oos, up_adc_or};
          4'h4: up_rdata <= {up_adc_dcfilt_offset, up_adc_dcfilt_coeff};
          4'h5: up_rdata <= {up_adc_iqcor_coeff_1, up_adc_iqcor_coeff_2};
          4'h6: up_rdata <= {12'd0, up_adc_pnseq_sel, 12'd0, up_adc_data_sel};
          4'h8: up_rdata <= {6'd0, adc_usr_datatype_be, adc_usr_datatype_signed,
                              adc_usr_datatype_shift, adc_usr_datatype_total_bits,
                              adc_usr_datatype_bits};
          4'h9: up_rdata <= {adc_usr_decimation_m, adc_usr_decimation_n};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // change coefficients to 2's complements

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_iqcor_coeff_tc_1 <= 16'd0;
      up_adc_iqcor_coeff_tc_2 <= 16'd0;
    end else begin
      up_adc_iqcor_coeff_tc_1 <= sm2tc(up_adc_iqcor_coeff_1);
      up_adc_iqcor_coeff_tc_2 <= sm2tc(up_adc_iqcor_coeff_2);
    end
  end

  // data/pn sources

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_pnseq_sel_m <= 4'd0;
      up_adc_data_sel_m <= 4'd0;
    end else begin
      case ({up_adc_pn_type, up_adc_pn_sel})
        2'b10: up_adc_pnseq_sel_m <= 4'h1;
        2'b01: up_adc_pnseq_sel_m <= 4'h9;
        default: up_adc_pnseq_sel_m <= up_adc_pnseq_sel;
      endcase
      if (up_adc_lb_enb == 1'b1) begin
        up_adc_data_sel_m <= 4'h1;
      end else begin
        up_adc_data_sel_m <= up_adc_data_sel;
      end
    end
  end

  // adc control & status

  up_xfer_cntrl #(.DATA_WIDTH(78)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_adc_iqcor_enb,
                      up_adc_dcfilt_enb,
                      up_adc_dfmt_se,
                      up_adc_dfmt_type,
                      up_adc_dfmt_enable,
                      up_adc_enable,
                      up_adc_dcfilt_offset,
                      up_adc_dcfilt_coeff,
                      up_adc_iqcor_coeff_tc_1,
                      up_adc_iqcor_coeff_tc_2,
                      up_adc_pnseq_sel_m,
                      up_adc_data_sel_m}),
    .up_xfer_done (),
    .d_rst (adc_rst),
    .d_clk (adc_clk),
    .d_data_cntrl ({  adc_iqcor_enb,
                      adc_dcfilt_enb,
                      adc_dfmt_se,
                      adc_dfmt_type,
                      adc_dfmt_enable,
                      adc_enable,
                      adc_dcfilt_offset,
                      adc_dcfilt_coeff,
                      adc_iqcor_coeff_1,
                      adc_iqcor_coeff_2,
                      adc_pnseq_sel,
                      adc_data_sel}));

  up_xfer_status #(.DATA_WIDTH(3)) i_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_adc_pn_err_s,
                      up_adc_pn_oos_s,
                      up_adc_or_s}),
    .d_rst (adc_rst),
    .d_clk (adc_clk),
    .d_data_status ({ adc_pn_err,
                      adc_pn_oos,
                      adc_or}));

endmodule

// ***************************************************************************
// ***************************************************************************
