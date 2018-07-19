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

module axi_adcfifo_dma #(

  parameter   AXI_DATA_WIDTH = 512,
  parameter   DMA_DATA_WIDTH =  64,
  parameter   DMA_READY_ENABLE = 1) (

  input                   axi_clk,
  input                   axi_drst,
  input                   axi_dvalid,
  input       [AXI_DATA_WIDTH-1:0]  axi_ddata,
  output  reg             axi_dready,
  input       [ 3:0]      axi_xfer_status,

  input                   dma_clk,
  output                  dma_wr,
  output      [DMA_DATA_WIDTH-1:0]  dma_wdata,
  input                   dma_wready,
  input                   dma_xfer_req,
  output      [ 3:0]      dma_xfer_status);


  localparam  DMA_MEM_RATIO = AXI_DATA_WIDTH/DMA_DATA_WIDTH;
  localparam  DMA_ADDRESS_WIDTH = 8;
  localparam  AXI_ADDRESS_WIDTH = (DMA_MEM_RATIO == 2) ? (DMA_ADDRESS_WIDTH - 1) :
    ((DMA_MEM_RATIO == 4) ? (DMA_ADDRESS_WIDTH - 2) : (DMA_ADDRESS_WIDTH - 3));


  // internal registers

  reg     [AXI_ADDRESS_WIDTH-1:0]    axi_waddr = 'd0;
  reg     [  2:0]                 axi_waddr_rel_count = 'd0;
  reg                             axi_waddr_rel_t = 'd0;
  reg     [AXI_ADDRESS_WIDTH-1:0]    axi_waddr_rel = 'd0;
  reg     [  2:0]                 axi_raddr_rel_t_m = 'd0;
  reg     [DMA_ADDRESS_WIDTH-1:0]    axi_raddr_rel = 'd0;
  reg     [DMA_ADDRESS_WIDTH-1:0]    axi_addr_diff = 'd0;
  reg                             dma_rst = 'd0;
  reg     [  2:0]                 dma_waddr_rel_t_m = 'd0;
  reg     [AXI_ADDRESS_WIDTH-1:0]    dma_waddr_rel = 'd0;
  reg                             dma_rd = 'd0;
  reg                             dma_rd_d = 'd0;
  reg     [DMA_DATA_WIDTH-1:0]    dma_rdata_d = 'd0;
  reg     [DMA_ADDRESS_WIDTH-1:0]    dma_raddr = 'd0;
  reg     [  2:0]                 dma_raddr_rel_count = 'd0;
  reg                             dma_raddr_rel_t = 'd0;
  reg     [DMA_ADDRESS_WIDTH-1:0]    dma_raddr_rel = 'd0;

  // internal signals

  wire    [DMA_ADDRESS_WIDTH:0]      axi_addr_diff_s;
  wire                            axi_raddr_rel_t_s;
  wire    [DMA_ADDRESS_WIDTH-1:0]    axi_waddr_s;
  wire                            dma_waddr_rel_t_s;
  wire    [DMA_ADDRESS_WIDTH-1:0]    dma_waddr_rel_s;
  wire                            dma_wready_s;
  wire                            dma_rd_s;
  wire    [DMA_DATA_WIDTH-1:0]    dma_rdata_s;

  // write interface

  always @(posedge axi_clk) begin
    if (axi_drst == 1'b1) begin
      axi_waddr <= 'd0;
      axi_waddr_rel_count <= 'd0;
      axi_waddr_rel_t <= 'd0;
      axi_waddr_rel <= 'd0;
    end else begin
      if (axi_dvalid == 1'b1) begin
        axi_waddr <= axi_waddr + 1'b1;
      end
      axi_waddr_rel_count <= axi_waddr_rel_count + 1'b1;
      if (axi_waddr_rel_count == 3'd7) begin
        axi_waddr_rel_t <= ~axi_waddr_rel_t;
        axi_waddr_rel <= axi_waddr;
      end
    end
  end

  assign axi_addr_diff_s = {1'b1, axi_waddr_s} - axi_raddr_rel;
  assign axi_raddr_rel_t_s = axi_raddr_rel_t_m[2] ^ axi_raddr_rel_t_m[1];
  assign axi_waddr_s = (DMA_MEM_RATIO == 2) ? {axi_waddr, 1'd0} :
    ((DMA_MEM_RATIO == 4) ? {axi_waddr, 2'd0} : {axi_waddr, 3'd0});

  always @(posedge axi_clk) begin
    if (axi_drst == 1'b1) begin
      axi_raddr_rel_t_m <= 'd0;
      axi_raddr_rel <= 'd0;
      axi_addr_diff <= 'd0;
      axi_dready <= 'd0;
    end else begin
      axi_raddr_rel_t_m <= {axi_raddr_rel_t_m[1:0], dma_raddr_rel_t};
      if (axi_raddr_rel_t_s == 1'b1) begin
        axi_raddr_rel <= dma_raddr_rel;
      end
      axi_addr_diff <= axi_addr_diff_s[DMA_ADDRESS_WIDTH-1:0];
      if (axi_addr_diff >= 180) begin
        axi_dready <= 1'b0;
      end else if (axi_addr_diff <= 8) begin
        axi_dready <= 1'b1;
      end
    end
  end

  // read interface

  assign dma_waddr_rel_t_s = dma_waddr_rel_t_m[2] ^ dma_waddr_rel_t_m[1];
  assign dma_waddr_rel_s = (DMA_MEM_RATIO == 2) ? {dma_waddr_rel, 1'd0} :
    ((DMA_MEM_RATIO == 4) ? {dma_waddr_rel, 2'd0} : {dma_waddr_rel, 3'd0});

  always @(posedge dma_clk) begin
    if (dma_xfer_req == 1'b0) begin
      dma_rst <= 1'b1;
      dma_waddr_rel_t_m <= 'd0;
      dma_waddr_rel <= 'd0;
    end else begin
      dma_rst <= 1'b0;
      dma_waddr_rel_t_m <= {dma_waddr_rel_t_m[1:0], axi_waddr_rel_t};
      if (dma_waddr_rel_t_s == 1'b1) begin
        dma_waddr_rel <= axi_waddr_rel;
      end
    end
  end

  assign dma_wready_s = (DMA_READY_ENABLE == 0) ? 1'b1 : dma_wready;
  assign dma_rd_s = (dma_raddr == dma_waddr_rel_s) ? 1'b0 : dma_wready_s;

  always @(posedge dma_clk) begin
    if (dma_xfer_req == 1'b0) begin
      dma_rd <= 'd0;
      dma_rd_d <= 'd0;
      dma_rdata_d <= 'd0;
      dma_raddr <= 'd0;
      dma_raddr_rel_count <= 'd0;
      dma_raddr_rel_t <= 'd0;
      dma_raddr_rel <= 'd0;
    end else begin
      dma_rd <= dma_rd_s;
      dma_rd_d <= dma_rd;
      dma_rdata_d <= dma_rdata_s;
      if (dma_rd_s == 1'b1) begin
        dma_raddr <= dma_raddr + 1'b1;
      end
      dma_raddr_rel_count <= dma_raddr_rel_count + 1'b1;
      if (dma_raddr_rel_count == 3'd7) begin
        dma_raddr_rel_t <= ~dma_raddr_rel_t;
        dma_raddr_rel <= dma_raddr;
      end
    end
  end

  // instantiations

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (AXI_ADDRESS_WIDTH),
    .A_DATA_WIDTH (AXI_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DMA_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DMA_DATA_WIDTH))
  i_mem_asym (
    .clka (axi_clk),
    .wea (axi_dvalid),
    .addra (axi_waddr),
    .dina (axi_ddata),
    .clkb (dma_clk),
    .reb (1'b1),
    .addrb (dma_raddr),
    .doutb (dma_rdata_s));

  ad_axis_inf_rx #(.DATA_WIDTH(DMA_DATA_WIDTH)) i_axis_inf (
    .clk (dma_clk),
    .rst (dma_rst),
    .valid (dma_rd_d),
    .last (1'd0),
    .data (dma_rdata_d),
    .inf_valid (dma_wr),
    .inf_last (),
    .inf_data (dma_wdata),
    .inf_ready (dma_wready));

  up_xfer_status #(.DATA_WIDTH(4)) i_xfer_status (
    .up_rstn (~dma_rst),
    .up_clk (dma_clk),
    .up_data_status (dma_xfer_status),
    .d_rst (axi_drst),
    .d_clk (axi_clk),
    .d_data_status (axi_xfer_status));

endmodule

// ***************************************************************************
// ***************************************************************************
