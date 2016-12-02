// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
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

module axi_ad7616_control (

  // control signals

  cnvst,
  busy,

  up_read_data,
  up_read_valid,
  up_write_data,
  up_read_req,
  up_write_req,

  up_burst_length,
  end_of_conv,

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
  up_rack

);

  parameter   ID = 0;
  parameter   IF_TYPE = 0;

  localparam  PCORE_VERSION = 'h0001001;
  localparam  POS_EDGE = 0;
  localparam  NEG_EDGE = 1;
  localparam  SERIAL = 0;
  localparam  PARALLEL = 1;

  output          cnvst;
  input           busy;

  output          end_of_conv;
  output  [ 4:0]  up_burst_length;

  input   [15:0]  up_read_data;
  input           up_read_valid;
  output  [15:0]  up_write_data;
  output          up_read_req;
  output          up_write_req;

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

  reg     [31:0]  up_scratch = 32'b0;
  reg             up_resetn = 1'b0;
  reg             up_cnvst_en = 1'b0;
  reg             up_wack = 1'b0;
  reg             up_rack = 1'b0;
  reg     [31:0]  up_rdata = 32'b0;
  reg     [31:0]  up_conv_rate = 32'b0;
  reg     [ 4:0]  up_burst_length = 5'h0;
  reg     [15:0]  up_write_data = 16'h0;

  reg     [31:0]  cnvst_counter = 32'b0;
  reg     [ 3:0]  pulse_counter = 8'b0;
  reg             cnvst_buf = 1'b0;
  reg             cnvst_pulse = 1'b0;
  reg     [ 2:0]  chsel_ff = 3'b0;

  wire            up_rst;
  wire            up_rreq_s;
  wire            up_rack_s;
  wire            up_wreq_s;

  wire    [31:0]  up_read_data_s;
  wire            up_read_valid_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == 6'h01) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == 6'h01) ? up_rreq : 1'b0;

  // the up_[read/write]_data interfaces are valid just in parallel mode

  assign up_read_valid_s = (IF_TYPE == PARALLEL) ? up_read_valid : 1'b1;
  assign up_read_data_s = (IF_TYPE == PARALLEL) ? {16'h0, up_read_data} : {2{16'hDEAD}};

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 1'h0;
      up_scratch <= 32'b0;
      up_resetn <= 1'b0;
      up_cnvst_en <= 1'b0;
      up_conv_rate <= 32'b0;
      up_burst_length <= 5'h0;
      up_write_data <= 16'h0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h10)) begin
        up_resetn <= up_wdata[0];
        up_cnvst_en <= up_wdata[1];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h11)) begin
        up_conv_rate <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h12)) begin
        up_burst_length <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h14)) begin
        up_write_data <= up_wdata;
      end
    end
  end

  assign up_write_req = (up_waddr[7:0] == 8'h14) ? up_wreq_s : 1'h0;

  // processor read interface

  assign up_rack_s = (up_raddr[7:0] == 8'h13) ? up_read_valid_s : up_rreq_s;
  assign up_read_req = (up_raddr[7:0] == 8'h13) ? up_rreq_s : 1'b0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 1'b0;
      up_rdata <= 32'b0;
    end else begin
      up_rack <= up_rack_s;
      if (up_rack_s == 1'b1) begin
        case (up_raddr[7:0])
          8'h00 : up_rdata = PCORE_VERSION;
          8'h01 : up_rdata = ID;
          8'h02 : up_rdata = up_scratch;
          8'h03 : up_rdata = IF_TYPE;
          8'h10 : up_rdata = {29'b0, up_cnvst_en, up_resetn};
          8'h11 : up_rdata = up_conv_rate;
          8'h12 : up_rdata = {27'b0, up_burst_length};
          8'h13 : up_rdata = up_read_data_s;
        endcase
      end
    end
  end

  // instantiations

  assign up_rst = ~up_rstn;

  ad_edge_detect #(
    .EDGE(NEG_EDGE)
  ) i_ad_edge_detect (
    .clk (up_clk),
    .rst (up_rst),
    .in (busy),
    .out (end_of_conv)
  );

  // convertion start generator
  // NOTE: + The minimum convertion cycle is 1 us
  //       + The rate of the cnvst must be defined in a way,
  //          to not lose any data. cnvst_rate >= t_conversion + t_aquisition
  //  See the AD7616 datasheet for more information.

  always @(posedge up_clk) begin
    if(up_resetn == 1'b0) begin
      cnvst_counter <= 32'b0;
    end else begin
      cnvst_counter <= (cnvst_counter < up_conv_rate) ? cnvst_counter + 1 : 32'b0;
    end
  end

  always @(cnvst_counter, up_conv_rate) begin
    cnvst_pulse <= (cnvst_counter == up_conv_rate) ? 1'b1 : 1'b0;
  end

  always @(posedge up_clk) begin
    if(up_resetn == 1'b0) begin
      pulse_counter <= 3'b0;
      cnvst_buf <= 1'b0;
    end else begin
      pulse_counter <= (cnvst == 1'b1) ? pulse_counter + 1 : 3'b0;
      if(cnvst_pulse == 1'b1) begin
        cnvst_buf <= 1'b1;
      end else if (pulse_counter[2] == 1'b1) begin
        cnvst_buf <= 1'b0;
      end
    end
  end

  assign cnvst = (up_cnvst_en == 1'b1) ? cnvst_buf : 1'b0;

endmodule

