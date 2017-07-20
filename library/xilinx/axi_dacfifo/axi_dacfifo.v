// ***************************************************************************
// ***************************************************************************
// Copyright 2016(c) Analog Devices, Inc.
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

  // dma interface (AXI Stream)

  dma_clk,
  dma_valid,
  dma_data,
  dma_ready,
  dma_xfer_req,
  dma_xfer_last,

  // dac interface

  dac_clk,
  dac_rst,
  dac_valid,
  dac_data,
  dac_dunf,
  dac_xfer_out,

  bypass,

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

  parameter   DAC_DATA_WIDTH = 64;
  parameter   DMA_DATA_WIDTH = 64;
  parameter   AXI_DATA_WIDTH = 512;
  parameter   AXI_SIZE = 2;
  parameter   AXI_LENGTH = 15;
  parameter   AXI_ADDRESS = 32'h00000000;
  parameter   AXI_ADDRESS_LIMIT = 32'hffffffff;

  localparam  FIFO_BYPASS = (DAC_DATA_WIDTH == DMA_DATA_WIDTH) ? 1 : 0;

  // dma interface

  input                               dma_clk;
  input                               dma_valid;
  input   [(DMA_DATA_WIDTH-1):0]      dma_data;
  output                              dma_ready;
  input                               dma_xfer_req;
  input                               dma_xfer_last;

  // dac interface

  input                               dac_clk;
  input                               dac_rst;
  input                               dac_valid;
  output  [(DAC_DATA_WIDTH-1):0]      dac_data;
  output                              dac_dunf;
  output                              dac_xfer_out;

  input                               bypass;

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
  output  [(AXI_DATA_WIDTH-1):0]      axi_wdata;
  output  [(AXI_DATA_WIDTH/8-1):0]    axi_wstrb;
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
  input   [(AXI_DATA_WIDTH-1):0]      axi_rdata;
  output                              axi_rready;

  reg                                 dma_ready = 1'b0;
  reg                                 dma_bypass_m1 = 1'b0;
  reg                                 dma_bypass = 1'b0;
  reg                                 dac_bypass_m1 = 1'b0;
  reg                                 dac_bypass = 1'b0;
  reg                                 dac_xfer_out = 1'b0;
  reg                                 dac_xfer_out_m1 = 1'b0;
  reg                                 dac_xfer_out_bypass = 1'b0;
  reg                                 dac_dunf = 1'b0;
  reg     [(DAC_DATA_WIDTH-1):0]      dac_data = 'b0;

  // internal signals

  wire    [(AXI_DATA_WIDTH-1):0]      axi_rd_data_s;
  wire                                axi_rd_ready_s;
  wire                                axi_rd_valid_s;
  wire                                axi_xfer_req_s;
  wire    [31:0]                      axi_last_addr_s;
  wire    [ 3:0]                      axi_last_beats_s;
  wire                                axi_dlast_s;
  wire    [ 3:0]                      dma_last_beats_s;
  wire    [(DAC_DATA_WIDTH-1):0]      dac_data_fifo_s;
  wire    [(DAC_DATA_WIDTH-1):0]      dac_data_bypass_s;
  wire                                dac_xfer_fifo_out_s;
  wire                                dac_dunf_fifo_s;
  wire                                dac_dunf_bypass_s;
  wire                                dma_ready_wr_s;

  axi_dacfifo_wr #(
    .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
    .DMA_DATA_WIDTH (DMA_DATA_WIDTH),
    .AXI_SIZE (AXI_SIZE),
    .AXI_LENGTH (AXI_LENGTH),
    .AXI_ADDRESS (AXI_ADDRESS),
    .AXI_ADDRESS_LIMIT (AXI_ADDRESS_LIMIT)
  ) i_wr (
    .dma_clk (dma_clk),
    .dma_data (dma_data),
    .dma_ready (dma_ready),
    .dma_ready_out (dma_ready_wr_s),
    .dma_valid (dma_valid),
    .dma_xfer_req (dma_xfer_req),
    .dma_xfer_last (dma_xfer_last),
    .dma_last_beats (dma_last_beats_s),
    .axi_last_addr (axi_last_addr_s),
    .axi_last_beats (axi_last_beats_s),
    .axi_xfer_out (axi_xfer_req_s),
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
    .axi_werror (axi_werror));

  axi_dacfifo_rd #(
    .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
    .AXI_SIZE (AXI_SIZE),
    .AXI_LENGTH (AXI_LENGTH),
    .AXI_ADDRESS (AXI_ADDRESS)
  ) i_rd (
    .axi_xfer_req (axi_xfer_req_s),
    .axi_last_raddr (axi_last_addr_s),
    .axi_last_beats (axi_last_beats_s),
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
    .axi_rerror (axi_rerror),
    .axi_dvalid (axi_rd_valid_s),
    .axi_ddata (axi_rd_data_s),
    .axi_dready (axi_rd_ready_s),
    .axi_dlast (axi_dlast_s));

  axi_dacfifo_dac #(
    .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
    .AXI_LENGTH(AXI_LENGTH),
    .DAC_DATA_WIDTH (DAC_DATA_WIDTH)
  ) i_dac (
    .axi_clk (axi_clk),
    .axi_dvalid (axi_rd_valid_s),
    .axi_ddata (axi_rd_data_s),
    .axi_dready (axi_rd_ready_s),
    .axi_dlast (axi_dlast_s),
    .axi_xfer_req (axi_xfer_req_s),
    .dma_last_beats (dma_last_beats_s),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid),
    .dac_data (dac_data_fifo_s),
    .dac_xfer_out (dac_xfer_fifo_out_s),
    .dac_dunf (dac_dunf_fifo_s));

  // bypass logic -- supported if DAC_DATA_WIDTH == DMA_DATA_WIDTH

  generate
  if (FIFO_BYPASS) begin

    axi_dacfifo_bypass #(
      .DAC_DATA_WIDTH (DAC_DATA_WIDTH),
      .DMA_DATA_WIDTH (DMA_DATA_WIDTH)
    ) i_dacfifo_bypass (
      .dma_clk(dma_clk),
      .dma_data(dma_data),
      .dma_ready(dma_ready),
      .dma_ready_out(dma_ready_bypass_s),
      .dma_valid(dma_valid),
      .dma_xfer_req(dma_xfer_req),
      .dac_clk(dac_clk),
      .dac_rst(dac_rst),
      .dac_valid(dac_valid),
      .dac_data(dac_data_bypass_s),
      .dac_dunf(dac_dunf_bypass_s)
    );

    always @(posedge dma_clk) begin
      dma_bypass_m1 <= bypass;
      dma_bypass <= dma_bypass_m1;
    end

    always @(posedge dac_clk) begin
      dac_bypass_m1 <= bypass;
      dac_bypass <= dac_bypass_m1;
      dac_xfer_out_m1 <= dma_xfer_req;
      dac_xfer_out_bypass <= dac_xfer_out_m1;
    end

    // mux for the dma_ready

    always @(posedge dma_clk) begin
      dma_ready <= (dma_bypass) ? dma_ready_wr_s : dma_ready_bypass_s;
    end

    // mux for dac data

    always @(posedge dac_clk) begin
      if (dac_valid) begin
        dac_data <= (dac_bypass) ? dac_data_bypass_s : dac_data_fifo_s;
      end
      dac_xfer_out <= (dac_bypass) ? dac_xfer_out_bypass : dac_xfer_fifo_out_s;
      dac_dunf <= (dac_bypass) ? dac_dunf_bypass_s : dac_dunf_fifo_s;
    end

  end else begin /* if (~FIFO_BYPASS) */

    always @(posedge dma_clk) begin
      dma_ready <= dma_ready_wr_s;
    end
    always @(posedge dac_clk) begin
      if (dac_valid) begin
        dac_data <= dac_data_fifo_s;
      end
      dac_xfer_out <= dac_xfer_fifo_out_s;
      dac_dunf <= dac_dunf_fifo_s;
    end

  end
  endgenerate

endmodule

