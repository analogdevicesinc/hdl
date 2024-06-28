// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/100ps

module rtp_engine_regmap #(
  parameter         VERSION = 1
  ) (

  // control signals

  output      [11:0]      num_lines,
  output      [11:0]      num_px_p_line,
  output                  custom_timestamp,
  output                  custom_timestamp_96b,
  output                  timestamp_s_eof,

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output reg              up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output reg  [31:0]      up_rdata,
  output reg              up_rack
);

  // internal registers

  reg  [11:0]     up_num_lines = 'h0;
  reg  [11:0]     up_num_px_p_line = 'h0;
  reg             up_custom_timestamp = 1'b0;
  reg             up_custom_timestamp_96b = 1'b0;
  reg             up_timestamp_s_eof = 1'b0;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_num_lines <= 'h0;
      up_num_px_p_line <= 'h0;
      up_custom_timestamp <= 1'b0;
      up_custom_timestamp_96b <= 1'b0;
      up_timestamp_s_eof <= 1'b0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h1)) begin
        up_num_lines <= up_wdata[11:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h2)) begin
        up_num_px_p_line <= up_wdata[11:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h3)) begin
        up_custom_timestamp <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h4)) begin
        up_custom_timestamp_96b <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h5)) begin
        up_timestamp_s_eof <= up_wdata[0];
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        if (up_raddr[13:4] == 10'd0) begin
          case (up_raddr)
            14'h0: up_rdata <= VERSION;
            14'h1: up_rdata <= {20'd0, up_num_lines};
            14'h2: up_rdata <= {20'd0, up_num_px_p_line};
            14'h3: up_rdata <= {31'd0, up_custom_timestamp};
            14'h4: up_rdata <= {31'd0, up_custom_timestamp_96b};
            14'h5: up_rdata <= {31'd0, up_timestamp_s_eof};
            default: up_rdata <= 0;
          endcase
        end else begin
          up_rdata <= 32'd0;
        end
      end
    end
  end

  assign num_lines = up_num_lines;
  assign num_px_p_line = up_num_px_p_line;
  assign custom_timestamp = up_custom_timestamp;
  assign custom_timestamp_96b = up_custom_timestamp_96b;
  assign timestamp_s_eof = up_timestamp_s_eof;

endmodule
