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

module axi_adcfifo #(

  parameter   ADC_DATA_WIDTH = 128,
  parameter   DMA_DATA_WIDTH = 64,
  parameter   AXI_DATA_WIDTH = 512,
  parameter   DMA_READY_ENABLE = 1,
  parameter   AXI_SIZE = 2,
  parameter   AXI_LENGTH = 16,
  parameter   AXI_ADDRESS = 32'h00000000,
  parameter   AXI_ADDRESS_LIMIT = 32'hffffffff) (

  // fifo interface

  input                   adc_rst,
  input                   adc_clk,
  input                   adc_wr,
  input       [ADC_DATA_WIDTH-1:0]  adc_wdata,
  output                  adc_wovf,

  // dma interface

  input                   dma_clk,
  output                  dma_wr,
  output      [DMA_DATA_WIDTH-1:0]  dma_wdata,
  input                   dma_wready,
  input                   dma_xfer_req,
  output      [ 3:0]      dma_xfer_status,

  // axi interface

  input                   axi_clk,
  input                   axi_resetn,
  output                  axi_awvalid,
  output      [ 3:0]      axi_awid,
  output      [ 1:0]      axi_awburst,
  output                  axi_awlock,
  output      [ 3:0]      axi_awcache,
  output      [ 2:0]      axi_awprot,
  output      [ 3:0]      axi_awqos,
  output      [ 3:0]      axi_awuser,
  output      [ 7:0]      axi_awlen,
  output      [ 2:0]      axi_awsize,
  output      [ 31:0]     axi_awaddr,
  input                   axi_awready,
  output                  axi_wvalid,
  output      [AXI_DATA_WIDTH-1:0]  axi_wdata,
  output      [(AXI_DATA_WIDTH/8)-1:0]  axi_wstrb,
  output                  axi_wlast,
  output      [ 3:0]      axi_wuser,
  input                   axi_wready,
  input                   axi_bvalid,
  input       [ 3:0]      axi_bid,
  input       [ 1:0]      axi_bresp,
  input       [ 3:0]      axi_buser,
  output                  axi_bready,
  output                  axi_arvalid,
  output      [ 3:0]      axi_arid,
  output      [ 1:0]      axi_arburst,
  output                  axi_arlock,
  output      [ 3:0]      axi_arcache,
  output      [ 2:0]      axi_arprot,
  output      [ 3:0]      axi_arqos,
  output      [ 3:0]      axi_aruser,
  output      [ 7:0]      axi_arlen,
  output      [ 2:0]      axi_arsize,
  output      [ 31:0]     axi_araddr,
  input                   axi_arready,
  input                   axi_rvalid,
  input       [ 3:0]      axi_rid,
  input       [ 3:0]      axi_ruser,
  input       [ 1:0]      axi_rresp,
  input                   axi_rlast,
  input       [AXI_DATA_WIDTH-1:0]  axi_rdata,
  output                  axi_rready);


  // internal signals

  wire                            adc_dwr_s;
  wire    [AXI_DATA_WIDTH-1:0]    adc_ddata_s;
  wire                            axi_rd_req_s;
  wire    [ 31:0]                 axi_rd_addr_s;
  wire    [  3:0]                 axi_xfer_status_s;
  wire                            axi_drst_s;
  wire                            axi_dvalid_s;
  wire    [AXI_DATA_WIDTH-1:0]    axi_ddata_s;
  wire                            axi_dready_s;

  // instantiations

  axi_adcfifo_adc #(
    .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
    .ADC_DATA_WIDTH (ADC_DATA_WIDTH))
  i_adc_if (
    .adc_rst (adc_rst),
    .adc_clk (adc_clk),
    .adc_wr (adc_wr),
    .adc_wdata (adc_wdata),
    .adc_wovf (adc_wovf),
    .adc_dwr (adc_dwr_s),
    .adc_ddata (adc_ddata_s),
    .axi_drst (axi_drst_s),
    .axi_clk (axi_clk),
    .axi_xfer_status (axi_xfer_status_s));

  axi_adcfifo_wr #(
    .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
    .AXI_SIZE (AXI_SIZE),
    .AXI_LENGTH (AXI_LENGTH),
    .AXI_ADDRESS (AXI_ADDRESS),
    .AXI_ADDRESS_LIMIT (AXI_ADDRESS_LIMIT))
  i_wr (
    .dma_xfer_req (dma_xfer_req),
    .axi_rd_req (axi_rd_req_s),
    .axi_rd_addr (axi_rd_addr_s),
    .adc_rst (adc_rst),
    .adc_clk (adc_clk),
    .adc_wr (adc_dwr_s),
    .adc_wdata (adc_ddata_s),
    .axi_clk (axi_clk),
    .axi_resetn (axi_resetn),
    .axi_awvalid (axi_awvalid),
    .axi_awid (axi_awid),
    .axi_awburst (axi_awburst),
    .axi_awlock (axi_awlock),
    .axi_awcache (axi_awcache),
    .axi_awprot (axi_awprot),
    .axi_awqos (axi_awqos),
    .axi_awuser (axi_awuser),
    .axi_awlen (axi_awlen),
    .axi_awsize (axi_awsize),
    .axi_awaddr (axi_awaddr),
    .axi_awready (axi_awready),
    .axi_wvalid (axi_wvalid),
    .axi_wdata (axi_wdata),
    .axi_wstrb (axi_wstrb),
    .axi_wlast (axi_wlast),
    .axi_wuser (axi_wuser),
    .axi_wready (axi_wready),
    .axi_bvalid (axi_bvalid),
    .axi_bid (axi_bid),
    .axi_bresp (axi_bresp),
    .axi_buser (axi_buser),
    .axi_bready (axi_bready),
    .axi_dwovf (axi_xfer_status_s[0]),
    .axi_dwunf (axi_xfer_status_s[1]),
    .axi_werror (axi_xfer_status_s[2]));

  axi_adcfifo_rd #(
    .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
    .AXI_SIZE (AXI_SIZE),
    .AXI_LENGTH (AXI_LENGTH),
    .AXI_ADDRESS (AXI_ADDRESS),
    .AXI_ADDRESS_LIMIT (AXI_ADDRESS_LIMIT))
  i_rd (
    .dma_xfer_req (dma_xfer_req),
    .axi_rd_req (axi_rd_req_s),
    .axi_rd_addr (axi_rd_addr_s),
    .axi_clk (axi_clk),
    .axi_resetn (axi_resetn),
    .axi_arvalid (axi_arvalid),
    .axi_arid (axi_arid),
    .axi_arburst (axi_arburst),
    .axi_arlock (axi_arlock),
    .axi_arcache (axi_arcache),
    .axi_arprot (axi_arprot),
    .axi_arqos (axi_arqos),
    .axi_aruser (axi_aruser),
    .axi_arlen (axi_arlen),
    .axi_arsize (axi_arsize),
    .axi_araddr (axi_araddr),
    .axi_arready (axi_arready),
    .axi_rvalid (axi_rvalid),
    .axi_rid (axi_rid),
    .axi_ruser (axi_ruser),
    .axi_rresp (axi_rresp),
    .axi_rlast (axi_rlast),
    .axi_rdata (axi_rdata),
    .axi_rready (axi_rready),
    .axi_rerror (axi_xfer_status_s[3]),
    .axi_drst (axi_drst_s),
    .axi_dvalid (axi_dvalid_s),
    .axi_ddata (axi_ddata_s),
    .axi_dready (axi_dready_s));

  axi_adcfifo_dma #(
    .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
    .DMA_DATA_WIDTH (DMA_DATA_WIDTH),
    .DMA_READY_ENABLE (DMA_READY_ENABLE))
  i_dma_if (
    .axi_clk (axi_clk),
    .axi_drst (axi_drst_s),
    .axi_dvalid (axi_dvalid_s),
    .axi_ddata (axi_ddata_s),
    .axi_dready (axi_dready_s),
    .axi_xfer_status (axi_xfer_status_s),
    .dma_clk (dma_clk),
    .dma_wr (dma_wr),
    .dma_wdata (dma_wdata),
    .dma_wready (dma_wready),
    .dma_xfer_req (dma_xfer_req),
    .dma_xfer_status (dma_xfer_status));

endmodule

// ***************************************************************************
// ***************************************************************************
