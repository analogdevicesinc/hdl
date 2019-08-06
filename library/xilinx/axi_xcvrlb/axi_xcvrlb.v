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

`timescale 1ns/1ps

module axi_xcvrlb #(

  // parameters

  parameter   CPLL_FBDIV = 1,
  parameter   CPLL_FBDIV_4_5 = 5,
  parameter   NUM_OF_LANES = 1,
  parameter   XCVR_TYPE = 2) (

  // transceiver interface

  input                         ref_clk,
  input   [(NUM_OF_LANES-1):0]  rx_p,
  input   [(NUM_OF_LANES-1):0]  rx_n,
  output  [(NUM_OF_LANES-1):0]  tx_p,
  output  [(NUM_OF_LANES-1):0]  tx_n,

  // axi interface

  input                         s_axi_aclk,
  input                         s_axi_aresetn,
  input                         s_axi_awvalid,
  input   [15:0]                s_axi_awaddr,
  input   [ 2:0]                s_axi_awprot,
  output                        s_axi_awready,
  input                         s_axi_wvalid,
  input   [31:0]                s_axi_wdata,
  input   [ 3:0]                s_axi_wstrb,
  output                        s_axi_wready,
  output                        s_axi_bvalid,
  output  [ 1:0]                s_axi_bresp,
  input                         s_axi_bready,
  input                         s_axi_arvalid,
  input   [15:0]                s_axi_araddr,
  input   [ 2:0]                s_axi_arprot,
  output                        s_axi_arready,
  output                        s_axi_rvalid,
  output  [ 1:0]                s_axi_rresp,
  output  [31:0]                s_axi_rdata,
  input                         s_axi_rready);

  // internal registers

  reg                           up_wack = 'd0;
  reg     [31:0]                up_scratch = 'd0;
  reg                           up_resetn = 'd0;
  reg     [31:0]                up_status = 'd0;
  reg     [31:0]                up_pll_locked = 'd0;
  reg                           up_rack = 'd0;
  reg     [31:0]                up_rdata = 'd0;

  // internal signals

  wire                          up_rstn;
  wire                          up_clk;
  wire                          up_wreq_s;
  wire    [ 7:0]                up_waddr_s;
  wire    [31:0]                up_wdata_s;
  wire                          up_rreq_s;
  wire    [ 7:0]                up_raddr_s;
  wire    [31:0]                up_status_s;
  wire    [31:0]                up_pll_locked_s;

  // parameters

  localparam  [31:0]  VERSION = 32'h00100161;

  // defaults

  assign up_rstn = s_axi_aresetn;
  assign up_clk = s_axi_aclk;
  assign up_status_s[31:NUM_OF_LANES] = 'd0;
  assign up_pll_locked_s[31:NUM_OF_LANES] = 'd0;

  // register access

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_resetn <= 'd0;
      up_status <= 'd0;
      up_pll_locked <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h02)) begin
        up_scratch <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h04)) begin
        up_resetn <= up_wdata_s[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h05)) begin
        up_status <= up_status_s | (up_status & ~up_wdata_s);
      end else begin
        up_status <= up_status_s | up_status;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h06)) begin
        up_pll_locked <= up_pll_locked_s | (up_pll_locked & ~up_wdata_s);
      end else begin
        up_pll_locked <= up_pll_locked_s | up_pll_locked;
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr_s)
          10'h000: up_rdata <= VERSION;
          10'h002: up_rdata <= up_scratch;
          10'h004: up_rdata <= {31'd0, up_resetn};
          10'h005: up_rdata <= up_status;
          10'h006: up_rdata <= up_pll_locked;
          default: up_rdata <= 32'd0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // instantiations

  genvar n;
  generate
  for (n = 0; n < NUM_OF_LANES; n = n + 1) begin: g_lanes
  axi_xcvrlb_1 #(
    .XCVR_TYPE (XCVR_TYPE),
    .CPLL_FBDIV_4_5(CPLL_FBDIV_4_5),
    .CPLL_FBDIV(CPLL_FBDIV))
  i_xcvrlb_1 (
    .ref_clk (ref_clk),
    .rx_p (rx_p[n]),
    .rx_n (rx_n[n]),
    .tx_p (tx_p[n]),
    .tx_n (tx_n[n]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_resetn (up_resetn),
    .up_status (up_status_s[n]),
    .up_pll_locked (up_pll_locked_s[n])
    );
  end
  endgenerate

  up_axi #(.AXI_ADDRESS_WIDTH (10)) i_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************

