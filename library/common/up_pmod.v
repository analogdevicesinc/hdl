// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

module up_pmod #(

  parameter       ID = 0) (

  input                   pmod_clk,
  output                  pmod_rst,
  input       [31:0]      pmod_signal_freq,

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
  output  reg             up_rack);

  localparam      PCORE_VERSION = 32'h00010001;

  // internal registers

  reg     [31:0]  up_scratch = 'd0;
  reg             up_resetn = 'd0;

  // internal signals

  wire    [31:0]  up_pmod_signal_freq_s;
  wire            up_wreq_s;
  wire            up_rreq_s;

  // decode block select

  assign up_wreq_s   = (up_waddr[13:8] == 6'h00) ? up_wreq : 1'b0;
  assign up_rreq_s   = (up_raddr[13:8] == 6'h00) ? up_rreq : 1'b0;
  assign up_preset_s = ~up_resetn;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_resetn <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h10)) begin
        up_resetn <= up_wdata[0];
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
          8'h00:  up_rdata <= PCORE_VERSION;
          8'h01:  up_rdata <= ID;
          8'h02:  up_rdata <= up_scratch;
          8'h03:  up_rdata <= up_pmod_signal_freq_s;
          8'h10:  up_rdata <= up_resetn;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // resets

  ad_rst i_adc_rst_reg (.rst_async(up_preset_s), .clk(pmod_clk), .rstn(), .rst(pmod_rst));

  // adc control & status

  up_xfer_status #(.DATA_WIDTH(32)) i_pmod_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status (up_pmod_signal_freq_s),
    .d_rst (pmod_rst),
    .d_clk (pmod_clk),
    .d_data_status (pmod_signal_freq));

endmodule

// ***************************************************************************
// ***************************************************************************
