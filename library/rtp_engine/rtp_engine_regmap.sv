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

  // control and status signals

  output     [15:0]       seq_number_h,
  output     [15:0]       seq_number_l,
  output                  start_transfer,
  output                  stop_transfer,
  input      [31:0]       f_32b_rtp_h,
  input      [31:0]       m_32b_rtp_h,
  input      [31:0]       l_32b_rtp_h,
  input      [31:0]       f_32b_rtpp_h,
  input      [31:0]       l_32b_rtpp_h,
  input      [31:0]       f_32b_tdata,
  input      [31:0]       l_32b_tdata,

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

  reg     [31:0]  up_seq_number = 'h0; // initial random-based sequence number assigned at the start of the transfer
  reg             up_start_transfer  = 'h0;
  reg             up_stop_transfer  = 'h0;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_seq_number <= 'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h1)) begin
        up_seq_number <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h2)) begin
        up_start_transfer <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h3)) begin
        up_stop_transfer <= up_wdata;
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
            14'h1: up_rdata <= up_seq_number;
            14'h2: up_rdata <= up_start_transfer;
            14'h3: up_rdata <= up_stop_transfer;
	    14'h4: up_rdata <= f_32b_rtp_h;
	    14'h5: up_rdata <= m_32b_rtp_h;
	    14'h6: up_rdata <= l_32b_rtp_h;
	    14'h7: up_rdata <= f_32b_rtpp_h;
	    14'h8: up_rdata <= l_32b_rtpp_h;
	    14'h9: up_rdata <= f_32b_tdata;
	    14'hA: up_rdata <= l_32b_tdata;
            default: up_rdata <= 0;
          endcase
        end else begin
          up_rdata <= 32'd0;
        end
      end
    end
  end

  assign seq_number_h = up_seq_number[31:16]; // high part of sequence number in rtp payload header - rfc4175 payload for raw data
  assign seq_number_l = up_seq_number[15:0]; //low part of sequence number in the rtp header
  assign start_transfer = up_start_transfer;
  assign stop_transfer = up_stop_transfer;

endmodule
