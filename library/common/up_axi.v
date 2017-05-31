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
// freedoms and responsabilities that he or she has by using this source/core.
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

module up_axi #(

  parameter   ADDRESS_WIDTH = 14,
  parameter   AXI_ADDRESS_WIDTH = 32) (

  // reset and clocks

  input                   up_rstn,
  input                   up_clk,

  // axi4 interface

  input                   up_axi_awvalid,
  input       [AXI_AW:0]  up_axi_awaddr,
  output  reg             up_axi_awready,
  input                   up_axi_wvalid,
  input       [31:0]      up_axi_wdata,
  input       [ 3:0]      up_axi_wstrb,
  output  reg             up_axi_wready,
  output  reg             up_axi_bvalid,
  output      [ 1:0]      up_axi_bresp,
  input                   up_axi_bready,
  input                   up_axi_arvalid,
  input       [AXI_AW:0]  up_axi_araddr,
  output  reg             up_axi_arready,
  output  reg             up_axi_rvalid,
  output      [ 1:0]      up_axi_rresp,
  output  reg [31:0]      up_axi_rdata,
  input                   up_axi_rready,

  // pcore interface

  output  reg             up_wreq,
  output  reg [AW:0]      up_waddr,
  output  reg [31:0]      up_wdata,
  input                   up_wack,
  output  reg             up_rreq,
  output  reg [AW:0]      up_raddr,
  input       [31:0]      up_rdata,
  input                   up_rack);

  localparam  AXI_AW = AXI_ADDRESS_WIDTH - 1;
  localparam  AW = ADDRESS_WIDTH - 1;

  // internal registers

  reg             up_wack_d = 'd0;
  reg             up_wsel = 'd0;
  reg     [ 4:0]  up_wcount = 'd0;
  reg             up_rack_d = 'd0;
  reg     [31:0]  up_rdata_d = 'd0;
  reg             up_rsel = 'd0;
  reg     [ 4:0]  up_rcount = 'd0;

  // internal signals

  wire            up_wack_s;
  wire            up_rack_s;
  wire    [31:0]  up_rdata_s;

  // write channel interface

  assign up_axi_bresp = 2'd0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_axi_awready <= 'd0;
      up_axi_wready <= 'd0;
      up_axi_bvalid <= 'd0;
    end else begin
      if (up_axi_awready == 1'b1) begin
        up_axi_awready <= 1'b0;
      end else if (up_wack_s == 1'b1) begin
        up_axi_awready <= 1'b1;
      end
      if (up_axi_wready == 1'b1) begin
        up_axi_wready <= 1'b0;
      end else if (up_wack_s == 1'b1) begin
        up_axi_wready <= 1'b1;
      end
      if ((up_axi_bready == 1'b1) && (up_axi_bvalid == 1'b1)) begin
        up_axi_bvalid <= 1'b0;
      end else if (up_wack_d == 1'b1) begin
        up_axi_bvalid <= 1'b1;
      end
    end
  end

  assign up_wack_s = (up_wcount == 5'h1f) ? 1'b1 : (up_wcount[4] & up_wack);

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wack_d <= 'd0;
      up_wsel <= 'd0;
      up_wreq <= 'd0;
      up_waddr <= 'd0;
      up_wdata <= 'd0;
      up_wcount <= 'd0;
    end else begin
      up_wack_d <= up_wack_s;
      if (up_wsel == 1'b1) begin
        if ((up_axi_bready == 1'b1) && (up_axi_bvalid == 1'b1)) begin
          up_wsel <= 1'b0;
        end
        up_wreq <= 1'b0;
        up_waddr <= up_waddr;
        up_wdata <= up_wdata;
      end else begin
        up_wsel <= up_axi_awvalid & up_axi_wvalid;
        up_wreq <= up_axi_awvalid & up_axi_wvalid;
        up_waddr <= up_axi_awaddr[AW+2:2];
        up_wdata <= up_axi_wdata;
      end
      if (up_wack_s == 1'b1) begin
        up_wcount <= 5'h00;
      end else if (up_wcount[4] == 1'b1) begin
        up_wcount <= up_wcount + 1'b1;
      end else if (up_wreq == 1'b1) begin
        up_wcount <= 5'h10;
      end
    end
  end

  // read channel interface

  assign up_axi_rresp = 2'd0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_axi_arready <= 'd0;
      up_axi_rvalid <= 'd0;
      up_axi_rdata <= 'd0;
    end else begin
      if (up_axi_arready == 1'b1) begin
        up_axi_arready <= 1'b0;
      end else if (up_rack_s == 1'b1) begin
        up_axi_arready <= 1'b1;
      end
      if ((up_axi_rready == 1'b1) && (up_axi_rvalid == 1'b1)) begin
        up_axi_rvalid <= 1'b0;
        up_axi_rdata <= 32'd0;
      end else if (up_rack_d == 1'b1) begin
        up_axi_rvalid <= 1'b1;
        up_axi_rdata <= up_rdata_d;
      end
    end
  end

  assign up_rack_s = (up_rcount == 5'h1f) ? 1'b1 : (up_rcount[4] & up_rack);
  assign up_rdata_s = (up_rcount == 5'h1f) ? {2{16'hdead}} : up_rdata;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rack_d <= 'd0;
      up_rdata_d <= 'd0;
      up_rsel <= 'd0;
      up_rreq <= 'd0;
      up_raddr <= 'd0;
      up_rcount <= 'd0;
    end else begin
      up_rack_d <= up_rack_s;
      up_rdata_d <= up_rdata_s;
      if (up_rsel == 1'b1) begin
        if ((up_axi_rready == 1'b1) && (up_axi_rvalid == 1'b1)) begin
          up_rsel <= 1'b0;
        end
        up_rreq <= 1'b0;
        up_raddr <= up_raddr;
      end else begin
        up_rsel <= up_axi_arvalid;
        up_rreq <= up_axi_arvalid;
        up_raddr <= up_axi_araddr[AW+2:2];
      end
      if (up_rack_s == 1'b1) begin
        up_rcount <= 5'h00;
      end else if (up_rcount[4] == 1'b1) begin
        up_rcount <= up_rcount + 1'b1;
      end else if (up_rreq == 1'b1) begin
        up_rcount <= 5'h10;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
