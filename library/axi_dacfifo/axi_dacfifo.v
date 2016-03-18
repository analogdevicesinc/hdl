// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_dacfifo (

  // dma interface

  dma_clk,
  dma_rst,
  dma_valid,
  dma_data,
  dma_ready,
  dma_xfer_req,
  dma_xfer_last,

  // dac interface

  dac_clk,
  dac_valid,
  dac_data

  // axi interface

  axi_clk,
  axi_resetn,
  axi_awvalid,
  axi_awid,
  axi_awburst,
  axi_awlock,
  axi_awcache,
  axi_awprot,
  axi_awqos,
  axi_awuser,
  axi_awlen,
  axi_awsize,
  axi_awaddr,
  axi_awready,
  axi_wvalid,
  axi_wdata,
  axi_wstrb,
  axi_wlast,
  axi_wuser,
  axi_wready,
  axi_bvalid,
  axi_bid,
  axi_bresp,
  axi_buser,
  axi_bready,
  axi_arvalid,
  axi_arid,
  axi_arburst,
  axi_arlock,
  axi_arcache,
  axi_arprot,
  axi_arqos,
  axi_aruser,
  axi_arlen,
  axi_arsize,
  axi_araddr,
  axi_arready,
  axi_rvalid,
  axi_rid,
  axi_ruser,
  axi_rresp,
  axi_rlast,
  axi_rdata,
  axi_rready);

  // parameters

  parameter   ADC_DATA_WIDTH = 128;
  parameter   DMA_DATA_WIDTH = 64;
  parameter   AXI_DATA_WIDTH = 512;
  parameter   DMA_READY_ENABLE = 1;
  parameter   AXI_SIZE = 2;
  parameter   AXI_LENGTH = 16;
  parameter   AXI_ADDRESS = 32'h00000000;
  parameter   AXI_ADDRESS_LIMIT = 32'hffffffff;
  parameter   AXI_BYTE_WIDTH = AXI_DATA_WIDTH/8;

  // dma interface

  input                               dma_clk;
  input                               dma_rst;
  input                               dma_valid;
  input   [(DMA_DATA_WIDTH-1):0]      dma_data;
  output                              dma_ready;
  input                               dma_xfer_req;
  input                               dma_xfer_last;

  // dac interface

  input                               dac_clk;
  input                               dac_valid;
  output  [(DMA_DATA_WIDTH-1):0]      dac_data;


  // axi interface

  input                               axi_clk;
  input                               axi_resetn;
  output                              axi_awvalid;
  output  [  3:0]                     axi_awid;
  output  [  1:0]                     axi_awburst;
  output                              axi_awlock;
  output  [  3:0]                     axi_awcache;
  output  [  2:0]                     axi_awprot;
  output  [  3:0]                     axi_awqos;
  output  [  3:0]                     axi_awuser;
  output  [  7:0]                     axi_awlen;
  output  [  2:0]                     axi_awsize;
  output  [ 31:0]                     axi_awaddr;
  input                               axi_awready;
  output                              axi_wvalid;
  output  [AXI_DATA_WIDTH-1:0]        axi_wdata;
  output  [AXI_BYTE_WIDTH-1:0]        axi_wstrb;
  output                              axi_wlast;
  output  [  3:0]                     axi_wuser;
  input                               axi_wready;
  input                               axi_bvalid;
  input   [  3:0]                     axi_bid;
  input   [  1:0]                     axi_bresp;
  input   [  3:0]                     axi_buser;
  output                              axi_bready;
  output                              axi_arvalid;
  output  [  3:0]                     axi_arid;
  output  [  1:0]                     axi_arburst;
  output                              axi_arlock;
  output  [  3:0]                     axi_arcache;
  output  [  2:0]                     axi_arprot;
  output  [  3:0]                     axi_arqos;
  output  [  3:0]                     axi_aruser;
  output  [  7:0]                     axi_arlen;
  output  [  2:0]                     axi_arsize;
  output  [ 31:0]                     axi_araddr;
  input                               axi_arready;
  input                               axi_rvalid;
  input   [  3:0]                     axi_rid;
  input   [  3:0]                     axi_ruser;
  input   [  1:0]                     axi_rresp;
  input                               axi_rlast;
  input   [AXI_DATA_WIDTH-1:0]        axi_rdata;
  output                              axi_rready;



endmodule

