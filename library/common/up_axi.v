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

module up_axi #(

  parameter   AXI_ADDRESS_WIDTH = 16) (

  // reset and clocks

  input                             up_rstn,
  input                             up_clk,

  // axi4 interface

  input                             up_axi_awvalid,
  input   [(AXI_ADDRESS_WIDTH-1):0] up_axi_awaddr,
  output                            up_axi_awready,
  input                             up_axi_wvalid,
  input   [31:0]                    up_axi_wdata,
  input   [ 3:0]                    up_axi_wstrb,
  output                            up_axi_wready,
  output                            up_axi_bvalid,
  output  [ 1:0]                    up_axi_bresp,
  input                             up_axi_bready,
  input                             up_axi_arvalid,
  input   [(AXI_ADDRESS_WIDTH-1):0] up_axi_araddr,
  output                            up_axi_arready,
  output                            up_axi_rvalid,
  output  [ 1:0]                    up_axi_rresp,
  output  [31:0]                    up_axi_rdata,
  input                             up_axi_rready,

  // pcore interface

  output                            up_wreq,
  output  [(AXI_ADDRESS_WIDTH-3):0] up_waddr,
  output  [31:0]                    up_wdata,
  input                             up_wack,
  output                            up_rreq,
  output  [(AXI_ADDRESS_WIDTH-3):0] up_raddr,
  input   [31:0]                    up_rdata,
  input                             up_rack);

  // internal registers

  reg                               up_axi_awready_int = 'd0;
  reg                               up_axi_wready_int = 'd0;
  reg                               up_axi_bvalid_int = 'd0;
  reg                               up_wack_d = 'd0;
  reg                               up_wsel = 'd0;
  reg                               up_wreq_int = 'd0;
  reg     [(AXI_ADDRESS_WIDTH-3):0] up_waddr_int = 'd0;
  reg     [31:0]                    up_wdata_int = 'd0;
  reg     [ 4:0]                    up_wcount = 'd0;
  reg                               up_axi_arready_int = 'd0;
  reg                               up_axi_rvalid_int = 'd0;
  reg     [31:0]                    up_axi_rdata_int = 'd0;
  reg                               up_rack_d = 'd0;
  reg     [31:0]                    up_rdata_d = 'd0;
  reg                               up_rsel = 'd0;
  reg                               up_rreq_int = 'd0;
  reg     [(AXI_ADDRESS_WIDTH-3):0] up_raddr_int = 'd0;
  reg     [ 4:0]                    up_rcount = 'd0;

  // internal signals

  wire                              up_wack_s;
  wire                              up_rack_s;
  wire    [31:0]                    up_rdata_s;

  // write channel interface

  assign up_axi_awready = up_axi_awready_int;
  assign up_axi_wready = up_axi_wready_int;
  assign up_axi_bvalid = up_axi_bvalid_int;
  assign up_axi_bresp = 2'd0;

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_axi_awready_int <= 'd0;
      up_axi_wready_int <= 'd0;
      up_axi_bvalid_int <= 'd0;
    end else begin
      if (up_axi_awready_int == 1'b1) begin
        up_axi_awready_int <= 1'b0;
      end else if (up_wack_s == 1'b1) begin
        up_axi_awready_int <= 1'b1;
      end
      if (up_axi_wready_int == 1'b1) begin
        up_axi_wready_int <= 1'b0;
      end else if (up_wack_s == 1'b1) begin
        up_axi_wready_int <= 1'b1;
      end
      if ((up_axi_bready == 1'b1) && (up_axi_bvalid_int == 1'b1)) begin
        up_axi_bvalid_int <= 1'b0;
      end else if (up_wack_d == 1'b1) begin
        up_axi_bvalid_int <= 1'b1;
      end
    end
  end

  assign up_wreq = up_wreq_int;
  assign up_waddr = up_waddr_int;
  assign up_wdata = up_wdata_int;
  assign up_wack_s = (up_wcount == 5'h1f) ? 1'b1 : (up_wcount[4] & up_wack);

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wack_d <= 'd0;
      up_wsel <= 'd0;
      up_wreq_int <= 'd0;
      up_waddr_int <= 'd0;
      up_wdata_int <= 'd0;
      up_wcount <= 'd0;
    end else begin
      up_wack_d <= up_wack_s;
      if (up_wsel == 1'b1) begin
        if ((up_axi_bready == 1'b1) && (up_axi_bvalid_int == 1'b1)) begin
          up_wsel <= 1'b0;
        end
        up_wreq_int <= 1'b0;
      end else begin
        up_wsel <= up_axi_awvalid & up_axi_wvalid;
        up_wreq_int <= up_axi_awvalid & up_axi_wvalid;
        up_waddr_int <= up_axi_awaddr[(AXI_ADDRESS_WIDTH-1):2];
        up_wdata_int <= up_axi_wdata;
      end
      if (up_wack_s == 1'b1) begin
        up_wcount <= 5'h00;
      end else if (up_wcount[4] == 1'b1) begin
        up_wcount <= up_wcount + 1'b1;
      end else if (up_wreq_int == 1'b1) begin
        up_wcount <= 5'h10;
      end
    end
  end

  // read channel interface

  assign up_axi_arready = up_axi_arready_int;
  assign up_axi_rvalid = up_axi_rvalid_int;
  assign up_axi_rdata = up_axi_rdata_int;
  assign up_axi_rresp = 2'd0;

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_axi_arready_int <= 'd0;
      up_axi_rvalid_int <= 'd0;
      up_axi_rdata_int <= 'd0;
    end else begin
      if (up_axi_arready_int == 1'b1) begin
        up_axi_arready_int <= 1'b0;
      end else if (up_rack_s == 1'b1) begin
        up_axi_arready_int <= 1'b1;
      end
      if ((up_axi_rready == 1'b1) && (up_axi_rvalid_int == 1'b1)) begin
        up_axi_rvalid_int <= 1'b0;
        up_axi_rdata_int <= 32'd0;
      end else if (up_rack_d == 1'b1) begin
        up_axi_rvalid_int <= 1'b1;
        up_axi_rdata_int <= up_rdata_d;
      end
    end
  end

  assign up_rreq = up_rreq_int;
  assign up_raddr = up_raddr_int;
  assign up_rack_s = (up_rcount == 5'h1f) ? 1'b1 : (up_rcount[4] & up_rack);
  assign up_rdata_s = (up_rcount == 5'h1f) ? {2{16'hdead}} : up_rdata;

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rack_d <= 'd0;
      up_rdata_d <= 'd0;
      up_rsel <= 'd0;
      up_rreq_int <= 'd0;
      up_raddr_int <= 'd0;
      up_rcount <= 'd0;
    end else begin
      up_rack_d <= up_rack_s;
      up_rdata_d <= up_rdata_s;
      if (up_rsel == 1'b1) begin
        if ((up_axi_rready == 1'b1) && (up_axi_rvalid_int == 1'b1)) begin
          up_rsel <= 1'b0;
        end
        up_rreq_int <= 1'b0;
      end else begin
        up_rsel <= up_axi_arvalid;
        up_rreq_int <= up_axi_arvalid;
        up_raddr_int <= up_axi_araddr[(AXI_ADDRESS_WIDTH-1):2];
      end
      if (up_rack_s == 1'b1) begin
        up_rcount <= 5'h00;
      end else if (up_rcount[4] == 1'b1) begin
        up_rcount <= up_rcount + 1'b1;
      end else if (up_rreq_int == 1'b1) begin
        up_rcount <= 5'h10;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
