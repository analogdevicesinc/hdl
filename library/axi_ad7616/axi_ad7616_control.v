// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad7616_control #(

  parameter   ID = 0
) (

  // control signals

  input       [15:0]      up_read_data,
  input                   up_read_valid,
  output  reg [15:0]      up_write_data,
  output                  up_read_req,
  output                  up_write_req,

  output  reg [ 4:0]      up_burst_length,

  // bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output  reg             up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output  reg [31:0]      up_rdata,
  output  reg             up_rack
);

  localparam  PCORE_VERSION = 'h00001002;
  localparam  POS_EDGE = 0;
  localparam  NEG_EDGE = 1;

  // internal signals

  reg     [31:0]  up_scratch = 32'b0;
  reg             up_resetn = 1'b0;
  reg             up_cnvst_en = 1'b0;
  reg     [31:0]  up_conv_rate = 32'b0;

  reg     [31:0]  cnvst_counter = 32'b0;
  reg     [ 3:0]  pulse_counter = 8'b0;
  reg             cnvst_buf = 1'b0;
  reg             cnvst_pulse = 1'b0;
  reg     [ 2:0]  chsel_ff = 3'b0;

  wire            up_rst;
  wire            up_rack_s;

  wire    [31:0]  up_read_data_s;
  wire            up_read_valid_s;

  // the up_[read/write]_data interfaces are valid just in parallel mode

  assign up_read_valid_s = up_read_valid;
  assign up_read_data_s = {16'h0, up_read_data};

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
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr[8:0] == 9'h102)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[8:0] == 9'h110)) begin
        up_resetn <= up_wdata[0];
        up_cnvst_en <= up_wdata[1];
      end
      if ((up_wreq == 1'b1) && (up_waddr[8:0] == 9'h111)) begin
        up_conv_rate <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[8:0] == 9'h112)) begin
        up_burst_length <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[8:0] == 9'h114)) begin
        up_write_data <= up_wdata;
      end
    end
  end

  assign up_write_req = (up_waddr[8:0] == 9'h114) ? up_wreq : 1'h0;

  // processor read interface

  assign up_rack_s = (up_raddr[8:0] == 9'h113) ? up_read_valid_s : up_rreq;
  assign up_read_req = (up_raddr[8:0] == 9'h113) ? up_rreq : 1'b0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 1'b0;
      up_rdata <= 32'b0;
    end else begin
      up_rack <= up_rack_s;
      if (up_rack_s == 1'b1) begin
        case (up_raddr[8:0])
          9'h100 : up_rdata <= PCORE_VERSION;
          9'h101 : up_rdata <= ID;
          9'h102 : up_rdata <= up_scratch;
          9'h110 : up_rdata <= {29'b0, up_cnvst_en, up_resetn};
          9'h111 : up_rdata <= up_conv_rate;
          9'h112 : up_rdata <= {27'b0, up_burst_length};
          9'h113 : up_rdata <= up_read_data_s;
          default : up_rdata <= 'h0;
        endcase
      end
    end
  end

  // instantiations

  assign up_rst = ~up_rstn;

endmodule
