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

module axi_adcfifo_rd #(

  parameter   AXI_DATA_WIDTH = 512,
  parameter   AXI_SIZE = 2,
  parameter   AXI_LENGTH = 16,
  parameter   AXI_ADDRESS = 32'h00000000,
  parameter   AXI_ADDRESS_LIMIT = 32'h00000000) (

  // request and synchronization

  input                   dma_xfer_req,

  // read interface

  input                   axi_rd_req,
  input       [ 31:0]     axi_rd_addr,

  // axi interface

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
  output  reg [ 31:0]     axi_araddr,
  input                   axi_arready,
  input                   axi_rvalid,
  input       [ 3:0]      axi_rid,
  input       [ 3:0]      axi_ruser,
  input       [ 1:0]      axi_rresp,
  input                   axi_rlast,
  input       [AXI_DATA_WIDTH-1:0]  axi_rdata,
  output  reg             axi_rready,

  // axi status

  output  reg             axi_rerror,

  // fifo interface

  output  reg             axi_drst,
  output  reg             axi_dvalid,
  output  reg [AXI_DATA_WIDTH-1:0]  axi_ddata,
  input                   axi_dready);

  localparam  AXI_BYTE_WIDTH = AXI_DATA_WIDTH/8;
  localparam  AXI_AWINCR = AXI_LENGTH * AXI_BYTE_WIDTH;
  localparam  BUF_THRESHOLD_LO = 6'd3;
  localparam  BUF_THRESHOLD_HI = 6'd60;

  // internal registers

  reg     [ 31:0]                 axi_rd_addr_h = 'd0;
  reg                             axi_rd = 'd0;
  reg                             axi_rd_active = 'd0;
  reg     [  2:0]                 axi_xfer_req_m = 'd0;
  reg                             axi_xfer_init = 'd0;
  reg                             axi_xfer_enable = 'd0;

  // internal signals

  wire                            axi_ready_s;

  // read is way too slow- buffer mode

  assign axi_ready_s = (~axi_arvalid | axi_arready) & axi_dready;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_rd_addr_h <= 'd0;
      axi_rd <= 'd0;
      axi_rd_active <= 'd0;
      axi_xfer_req_m <= 'd0;
      axi_xfer_init <= 'd0;
      axi_xfer_enable <= 'd0;
    end else begin
      if (axi_xfer_init == 1'b1) begin
        axi_rd_addr_h <= AXI_ADDRESS;
      end else if (axi_rd_req == 1'b1) begin
        axi_rd_addr_h <= axi_rd_addr;
      end
      if (axi_rd_active == 1'b1) begin
        axi_rd <= 1'b0;
        if ((axi_rvalid == 1'b1) && (axi_rlast == 1'b1)) begin
          axi_rd_active <= 1'b0;
        end
      end else if ((axi_ready_s == 1'b1) && (axi_araddr < axi_rd_addr_h)) begin
        axi_rd <= axi_xfer_enable;
        axi_rd_active <= axi_xfer_enable;
      end
      axi_xfer_req_m <= {axi_xfer_req_m[1:0], dma_xfer_req};
      axi_xfer_init <= axi_xfer_req_m[1] & ~axi_xfer_req_m[2];
      axi_xfer_enable <= axi_xfer_req_m[2];
    end
  end

  // address channel

  assign axi_arid  = 4'b0000;
  assign axi_arburst  = 2'b01;
  assign axi_arlock  = 1'b0;
  assign axi_arcache  = 4'b0010;
  assign axi_arprot  = 3'b000;
  assign axi_arqos  = 4'b0000;
  assign axi_aruser  = 4'b0001;
  assign axi_arlen  = AXI_LENGTH - 1;
  assign axi_arsize  = AXI_SIZE;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_arvalid <= 'd0;
      axi_araddr <= 'd0;
    end else begin
      if (axi_arvalid == 1'b1) begin
        if (axi_arready == 1'b1) begin
          axi_arvalid <= 1'b0;
        end
      end else begin
        if (axi_rd == 1'b1) begin
          axi_arvalid <= 1'b1;
        end
      end
      if (axi_xfer_init == 1'b1) begin
        axi_araddr <= AXI_ADDRESS;
      end else if ((axi_arvalid == 1'b1) && (axi_arready == 1'b1)) begin
        axi_araddr <= axi_araddr + AXI_AWINCR;
      end
    end
  end

  // read data channel

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_drst <= 'd1;
      axi_dvalid <= 'd0;
      axi_ddata <= 'd0;
      axi_rready <= 'd0;
    end else begin
      axi_drst <= ~axi_xfer_req_m[1];
      axi_dvalid <= axi_rvalid;
      axi_ddata <= axi_rdata;
      axi_rready <= 1'b1;
    end
  end

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_rerror <= 'd0;
    end else begin
      axi_rerror <= axi_rvalid & axi_rresp[1];
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
