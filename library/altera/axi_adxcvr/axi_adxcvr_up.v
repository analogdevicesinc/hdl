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
  parameter   integer TX_OR_RX_N = 0,
  parameter   integer NUM_OF_LANES = 4) (

  // xcvr, lane-pll and ref-pll are shared

  output                        up_rst,
  input                         up_pll_locked,
  input   [(NUM_OF_LANES-1):0]  up_ready,

  // bus interface

  input                         up_rstn,
  input                         up_clk,
  input                         up_wreq,
  input   [ 9:0]                up_waddr,
  input   [31:0]                up_wdata,
  output                        up_wack,
  input                         up_rreq,
  input   [ 9:0]                up_raddr,
  output  [31:0]                up_rdata,
  output                        up_rack);

  // parameters

  localparam  [31:0]  VERSION = 32'h00100161;

  // internal registers

  reg                           up_wreq_d = 'd0;
  reg     [31:0]                up_scratch = 'd0;
  reg                           up_resetn = 'd0;
  reg     [ 3:0]                up_rst_cnt = 'd8;
  reg                           up_status_int = 'd0;
  reg                           up_rreq_d = 'd0;
  reg     [31:0]                up_rdata_d = 'd0;

  // internal signals

  wire                          up_ready_s;
  wire    [31:0]                up_status_32_s;
  wire    [31:0]                up_rparam_s;

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

  assign up_rst = up_rst_cnt[3];
  assign up_ready_s = & up_status_32_s[NUM_OF_LANES:1];
  assign up_status_32_s[31:(NUM_OF_LANES+1)] = 'd0;
  assign up_status_32_s[NUM_OF_LANES] = up_pll_locked;
  assign up_status_32_s[(NUM_OF_LANES-1):0] = up_ready;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rst_cnt <= 4'h8;
      up_status_int <= 1'b0;
    end else begin
      if (up_resetn == 1'b0) begin
        up_rst_cnt <= 4'h8;
      end else if (up_rst_cnt[3] == 1'b1) begin
        up_rst_cnt <= up_rst_cnt + 1'b1;
      end
      if (up_resetn == 1'b0) begin
        up_status_int <= 1'b0;
      end else if (up_ready_s == 1'b1) begin
        up_status_int <= 1'b1;
      end
    end
  end

  // altera specific

  assign up_rparam_s[31:24] = 8'd0;

  // xilinx specific

  assign up_rparam_s[23:16] = 8'd0;

  // generic

  assign up_rparam_s[15: 9] = 7'd0;
  assign up_rparam_s[ 8: 8] = (TX_OR_RX_N == 0) ? 1'b0 : 1'b1;
  assign up_rparam_s[ 7: 0] = NUM_OF_LANES;

  // read interface

  assign up_rack = up_rreq_d;
  assign up_rdata = up_rdata_d;

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
          10'h006: up_rdata_d <= up_status_32_s;
          10'h009: up_rdata_d <= up_rparam_s;
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
