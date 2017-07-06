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

module axi_dacfifo_rd #(

  parameter   AXI_DATA_WIDTH = 512,
  parameter   AXI_SIZE = 2,
  parameter   AXI_LENGTH = 15,
  parameter   AXI_ADDRESS = 32'h00000000) (

 // xfer last for read/write synchronization

  input                   axi_xfer_req,
  input       [31:0]      axi_last_raddr,
  input       [ 7:0]      axi_last_beats,

  // axi read address and read data channels

  input                   axi_clk,
  input                   axi_resetn,
  output  reg             axi_arvalid,
  output      [ 3:0]      axi_arid,
  output      [ 1:0]      axi_arburst,
  output                  axi_arlock,
  output      [ 3:0]      axi_arcache,
  output      [ 2:0]      axi_arprot,
  output      [ 3:0]      axi_arqos,
  output      [ 3:0]      axi_aruser,
  output      [ 7:0]      axi_arlen,
  output      [ 2:0]      axi_arsize,
  output  reg [31:0]      axi_araddr,
  input                   axi_arready,
  input                   axi_rvalid,
  input       [ 3:0]      axi_rid,
  input       [ 3:0]      axi_ruser,
  input       [ 1:0]      axi_rresp,
  input                   axi_rlast,
  input       [(AXI_DATA_WIDTH-1):0]  axi_rdata,
  output  reg             axi_rready,

  // axi status

  output  reg             axi_rerror,

  // fifo interface

  output  reg             axi_dvalid,
  output  reg [(AXI_DATA_WIDTH-1):0]  axi_ddata,
  input                   axi_dready,
  output  reg             axi_dlast);

  localparam  AXI_BYTE_WIDTH = AXI_DATA_WIDTH/8;
  localparam  AXI_AWINCR = (AXI_LENGTH + 1) * AXI_BYTE_WIDTH;

  // internal registers

  reg                             axi_rnext = 1'b0;
  reg                             axi_ractive = 1'b0;
  reg     [ 31:0]                 axi_araddr_prev = 32'b0;
  reg     [ 1:0]                  axi_xfer_req_m = 2'b0;
  reg     [ 7:0]                  axi_last_beats_cntr = 8'b0;

  // internal signals

  wire                            axi_ready_s;
  wire                            axi_xfer_req_init;
  wire                            axi_dvalid_s;
  wire                            axi_dlast_s;
  wire    [ 8:0]                  axi_last_beats_s;

  assign axi_ready_s = (~axi_arvalid | axi_arready) & axi_dready;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_rnext <= 1'b0;
      axi_ractive <= 1'b0;
      axi_xfer_req_m <= 2'b0;
    end else begin
      if (axi_ractive == 1'b1) begin
        axi_rnext <= 1'b0;
        if ((axi_rvalid == 1'b1) && (axi_rlast == 1'b1)) begin
          axi_ractive <= 1'b0;
        end
      end else if ((axi_ready_s == 1'b1)) begin
        axi_rnext <= axi_xfer_req;
        axi_ractive <= axi_xfer_req;
      end
    axi_xfer_req_m <= {axi_xfer_req_m[0], axi_xfer_req};
    end
  end

  assign axi_xfer_req_init = axi_xfer_req_m[0] & ~axi_xfer_req_m[1];

  always @(posedge axi_clk) begin
    if ((axi_resetn == 1'b0) || (axi_xfer_req == 1'b0)) begin
      axi_last_beats_cntr <= 0;
    end else begin
      if ((axi_rready == 1'b1) && (axi_rvalid == 1'b1)) begin
        axi_last_beats_cntr <= (axi_rlast == 1'b1) ? 0 : axi_last_beats_cntr +  1;
      end
    end
  end

  // address channel

  assign axi_arid = 4'b0000;
  assign axi_arburst = 2'b01;
  assign axi_arlock = 1'b0;
  assign axi_arcache = 4'b0010;
  assign axi_arprot = 3'b000;
  assign axi_arqos = 4'b0000;
  assign axi_aruser = 4'b0001;
  assign axi_arlen = AXI_LENGTH;
  assign axi_arsize = AXI_SIZE;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_arvalid <= 'd0;
      axi_araddr <= AXI_ADDRESS;
      axi_araddr_prev <= AXI_ADDRESS;
    end else begin
      if (axi_arvalid == 1'b1) begin
        if (axi_arready == 1'b1) begin
          axi_arvalid <= 1'b0;
        end
      end else begin
        if (axi_rnext == 1'b1) begin
          axi_arvalid <= 1'b1;
        end
      end
      if ((axi_xfer_req == 1'b1) &&
          (axi_arvalid == 1'b1) &&
          (axi_arready == 1'b1)) begin
        axi_araddr <= (axi_araddr >= axi_last_raddr) ? AXI_ADDRESS : axi_araddr + AXI_AWINCR;
        axi_araddr_prev <= axi_araddr;
      end
    end
  end

  // read data channel

  assign axi_last_beats_s = {1'b0, axi_last_beats} - 1;
  assign axi_dvalid_s = ((axi_last_beats_cntr > axi_last_beats_s) && (axi_araddr_prev == axi_last_raddr)) ? 0 : axi_rvalid & axi_rready;
  assign axi_dlast_s = (axi_araddr_prev == axi_last_raddr) ? 1 : 0;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_ddata <= 'd0;
      axi_rready <= 1'b0;
      axi_dvalid <= 1'b0;
    end else begin
      axi_ddata <= axi_rdata;
      axi_dvalid <= axi_dvalid_s;
      axi_dlast <= axi_dlast_s;
      if (axi_xfer_req == 1'b1) begin
        axi_rready <= axi_rvalid;
      end
    end
  end

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_rerror <= 'd0;
    end else begin
      axi_rerror <= axi_rvalid & axi_rresp[1];
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************

