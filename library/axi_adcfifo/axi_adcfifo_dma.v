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

module axi_adcfifo_dma (

  axi_clk,
  axi_drst,
  axi_dvalid,
  axi_ddata,
  axi_dready,
  axi_xfer_status,

  dma_clk,
  dma_wr,
  dma_wdata,
  dma_wready,
  dma_xfer_req,
  dma_xfer_status);

  // parameters

  parameter   AXI_DATA_WIDTH = 512;
  parameter   DMA_DATA_WIDTH =  64;
  parameter   DMA_READY_ENABLE = 1;

  localparam  DMA_MEM_RATIO = AXI_DATA_WIDTH/DMA_DATA_WIDTH;
  localparam  DMA_ADDR_WIDTH = 8;
  localparam  AXI_ADDR_WIDTH = (DMA_MEM_RATIO == 2) ? (DMA_ADDR_WIDTH - 1) :
    ((DMA_MEM_RATIO == 4) ? (DMA_ADDR_WIDTH - 2) : (DMA_ADDR_WIDTH - 3));
 
  // adc write

  input                           axi_clk;
  input                           axi_drst;
  input                           axi_dvalid;
  input   [AXI_DATA_WIDTH-1:0]    axi_ddata;
  output                          axi_dready;
  input   [  3:0]                 axi_xfer_status;

  // dma read

  input                           dma_clk;
  output                          dma_wr;
  output  [DMA_DATA_WIDTH-1:0]    dma_wdata;
  input                           dma_wready;
  input                           dma_xfer_req;
  output  [  3:0]                 dma_xfer_status;

  // internal registers

  reg     [AXI_ADDR_WIDTH-1:0]    axi_waddr = 'd0;
  reg     [  2:0]                 axi_waddr_rel_count = 'd0;
  reg                             axi_waddr_rel_t = 'd0;
  reg     [AXI_ADDR_WIDTH-1:0]    axi_waddr_rel = 'd0;
  reg     [  2:0]                 axi_raddr_rel_t_m = 'd0;
  reg     [DMA_ADDR_WIDTH-1:0]    axi_raddr_rel = 'd0;
  reg     [DMA_ADDR_WIDTH-1:0]    axi_addr_diff = 'd0;
  reg                             axi_dready = 'd0;
  reg                             dma_rst = 'd0;
  reg     [  2:0]                 dma_waddr_rel_t_m = 'd0;
  reg     [AXI_ADDR_WIDTH-1:0]    dma_waddr_rel = 'd0;
  reg                             dma_rd = 'd0;
  reg                             dma_rd_d = 'd0;
  reg     [DMA_DATA_WIDTH-1:0]    dma_rdata_d = 'd0;
  reg     [DMA_ADDR_WIDTH-1:0]    dma_raddr = 'd0;
  reg     [  2:0]                 dma_raddr_rel_count = 'd0;
  reg                             dma_raddr_rel_t = 'd0;
  reg     [DMA_ADDR_WIDTH-1:0]    dma_raddr_rel = 'd0;

  // internal signals

  wire    [DMA_ADDR_WIDTH:0]      axi_addr_diff_s;
  wire                            axi_raddr_rel_t_s;
  wire    [DMA_ADDR_WIDTH-1:0]    axi_waddr_s;
  wire                            dma_waddr_rel_t_s;
  wire    [DMA_ADDR_WIDTH-1:0]    dma_waddr_rel_s;
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
      axi_addr_diff <= axi_addr_diff_s[DMA_ADDR_WIDTH-1:0];
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
    .ADDR_WIDTH_A (AXI_ADDR_WIDTH),
    .DATA_WIDTH_A (AXI_DATA_WIDTH),
    .ADDR_WIDTH_B (DMA_ADDR_WIDTH),
    .DATA_WIDTH_B (DMA_DATA_WIDTH))
  i_mem_asym (
    .clka (axi_clk),
    .wea (axi_dvalid),
    .addra (axi_waddr),
    .dina (axi_ddata),
    .clkb (dma_clk),
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
