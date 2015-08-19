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

module up_axis_dma_rx (

  // adc interface

  adc_clk,
  adc_rst,

  // dma interface

  dma_clk,
  dma_rst,
  dma_start,
  dma_stream,
  dma_count,
  dma_ovf,
  dma_unf,
  dma_status,
  dma_bw,

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

  localparam  PCORE_VERSION = 32'h00050063;
  parameter   ID = 0;

  // adc interface

  input           adc_clk;
  output          adc_rst;

  // dma interface

  input           dma_clk;
  output          dma_rst;
  output          dma_start;
  output          dma_stream;
  output  [31:0]  dma_count;
  input           dma_ovf;
  input           dma_unf;
  input           dma_status;
  input   [31:0]  dma_bw;

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

  reg             up_preset = 'd0;
  reg             up_wack = 'd0;
  reg     [31:0]  up_scratch = 'd0;
  reg             up_resetn = 'd0;
  reg             up_dma_stream = 'd0;
  reg             up_dma_start = 'd0;
  reg     [31:0]  up_dma_count = 'd0;
  reg             up_dma_ovf = 'd0;
  reg             up_dma_unf = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             dma_start_d = 'd0;
  reg             dma_start_2d = 'd0;
  reg             dma_start = 'd0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire            up_dma_ovf_s;
  wire            up_dma_unf_s;
  wire            up_dma_status_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == 6'h00) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_waddr[13:8] == 6'h00) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_preset <= 1'd1;
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_resetn <= 'd0;
      up_dma_stream <= 'd0;
      up_dma_start <= 'd0;
      up_dma_count <= 'd0;
      up_dma_ovf <= 'd0;
      up_dma_unf <= 'd0;
    end else begin
      up_preset <= 1'd0;
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h10)) begin
        up_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h20)) begin
        up_dma_stream <= up_wdata[1];
        up_dma_start <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h21)) begin
        up_dma_count <= up_wdata;
      end
      if (up_dma_ovf_s == 1'b1) begin
        up_dma_ovf <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h22)) begin
        up_dma_ovf <= up_dma_ovf & ~up_wdata[2];
      end
      if (up_dma_unf_s == 1'b1) begin
        up_dma_unf <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h22)) begin
        up_dma_unf <= up_dma_unf & ~up_wdata[1];
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
          8'h01: up_rdata <= ID;
          8'h02: up_rdata <= up_scratch;
          8'h10: up_rdata <= {31'd0, up_resetn};
          8'h20: up_rdata <= {30'd0, up_dma_stream, up_dma_start};
          8'h21: up_rdata <= up_dma_count;
          8'h22: up_rdata <= {29'd0, up_dma_ovf, up_dma_unf, up_dma_status_s};
          8'h23: up_rdata <= dma_bw;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // resets

  ad_rst i_adc_rst_reg (.preset(up_preset), .clk(adc_clk), .rst(adc_rst));
  ad_rst i_dma_rst_reg (.preset(up_preset), .clk(dma_clk), .rst(dma_rst));

  // dma control & status

  up_xfer_cntrl #(.DATA_WIDTH(34)) i_dma_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_dma_start,
                      up_dma_stream,
                      up_dma_count}),
    .d_rst (dma_rst),
    .d_clk (dma_clk),
    .d_data_cntrl ({  dma_start_s,
                      dma_stream,
                      dma_count}));

  up_xfer_status #(.DATA_WIDTH(3)) i_dma_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_dma_ovf_s,
                      up_dma_unf_s,
                      up_dma_status_s}),
    .d_rst (dma_rst),
    .d_clk (dma_clk),
    .d_data_status ({ dma_ovf,
                      dma_unf,
                      dma_status}));

  // start needs to be a pulse

  always @(posedge dma_clk) begin
    dma_start_d <= dma_start_s;
    dma_start_2d <= dma_start_d;
    dma_start <= dma_start_d & ~dma_start_2d;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
