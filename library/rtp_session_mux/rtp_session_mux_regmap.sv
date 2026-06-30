// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

module rtp_session_mux_regmap (

  // control signals

  output                  start_video_transfer,

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

  localparam VERSION = 32'h00010000;

  // internal registers

  reg             up_start_video_transfer = 1'b0;

  always @(posedge up_clk) begin
    if (!up_rstn) begin
      up_start_video_transfer <= 1'b0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h1)) begin
        up_start_video_transfer <= up_wdata[0];
      end
    end
  end

  always @(posedge up_clk) begin
    if (!up_rstn) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq) begin
        if (up_raddr[13:5] == 10'd0) begin
          case (up_raddr) inside
            14'h0: up_rdata <= VERSION;
            14'h1: up_rdata <= up_start_video_transfer;
            default: up_rdata <= 0;
          endcase
        end else begin
          up_rdata <= 32'd0;
        end
      end
    end
  end

  assign start_video_transfer = up_start_video_transfer;

endmodule
