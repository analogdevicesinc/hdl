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

module util_adcfifo (

  // fifo interface

  adc_rst,
  adc_clk,
  adc_wr,
  adc_wdata,
  adc_wovf,

  // dma interface

  dma_clk,
  dma_wr,
  dma_wdata,
  dma_wready,
  dma_xfer_req,
  dma_xfer_status);

  // parameters

  parameter   ADC_DATA_WIDTH = 256;
  parameter   DMA_DATA_WIDTH =  64;
  parameter   DMA_READY_ENABLE = 1;
  parameter   DMA_ADDR_WIDTH =  10;

  localparam  DMA_MEM_RATIO = ADC_DATA_WIDTH/DMA_DATA_WIDTH;
  localparam  ADC_ADDR_WIDTH = (DMA_MEM_RATIO == 2) ? (DMA_ADDR_WIDTH - 1) :
    ((DMA_MEM_RATIO == 4) ? (DMA_ADDR_WIDTH - 2) : (DMA_ADDR_WIDTH - 3));
  localparam  ADC_ADDR_LIMIT = (2**ADC_ADDR_WIDTH)-1;
 
  // adc interface

  input                           adc_rst;
  input                           adc_clk;
  input                           adc_wr;
  input   [ADC_DATA_WIDTH-1:0]    adc_wdata;
  output                          adc_wovf;

  // dma interface

  input                           dma_clk;
  output                          dma_wr;
  output  [DMA_DATA_WIDTH-1:0]    dma_wdata;
  input                           dma_wready;
  input                           dma_xfer_req;
  output  [  3:0]                 dma_xfer_status;

  // internal registers

  reg     [  2:0]                 adc_xfer_req_m = 'd0;
  reg                             adc_xfer_init = 'd0;
  reg                             adc_xfer_enable = 'd0;
  reg                             adc_wr_int = 'd0;
  reg     [ADC_DATA_WIDTH-1:0]    adc_wdata_int = 'd0;
  reg     [ADC_ADDR_WIDTH-1:0]    adc_waddr_int = 'd0;
  reg                             adc_waddr_rel_t = 'd0;
  reg     [ADC_ADDR_WIDTH-1:0]    adc_waddr_rel = 'd0;
  reg                             dma_rst = 'd0;
  reg     [  2:0]                 dma_waddr_rel_t_m = 'd0;
  reg     [ADC_ADDR_WIDTH-1:0]    dma_waddr_rel = 'd0;
  reg                             dma_rd = 'd0;
  reg                             dma_rd_d = 'd0;
  reg     [DMA_DATA_WIDTH-1:0]    dma_rdata_d = 'd0;
  reg     [DMA_ADDR_WIDTH-1:0]    dma_raddr = 'd0;

  // internal signals

  wire                            dma_waddr_rel_t_s;
  wire    [DMA_ADDR_WIDTH-1:0]    dma_waddr_rel_s;
  wire                            dma_wready_s;
  wire                            dma_rd_s;
  wire    [DMA_DATA_WIDTH-1:0]    dma_rdata_s;

  // write interface

  assign adc_wovf = 1'd0;

  always @(posedge adc_clk or posedge adc_rst) begin
    if (adc_rst == 1'b1) begin
      adc_xfer_req_m <= 'd0;
      adc_xfer_init <= 'd0;
      adc_xfer_enable <= 'd0;
    end else begin
      adc_xfer_req_m <= {adc_xfer_req_m[1:0], dma_xfer_req};
      adc_xfer_init <= adc_xfer_req_m[1] & ~adc_xfer_req_m[2];
      if (adc_xfer_init == 1'b1) begin
        adc_xfer_enable <= 1'b1;
      end else if ((adc_waddr_int >= ADC_ADDR_LIMIT) ||
        (adc_xfer_req_m[2] == 1'b0)) begin
        adc_xfer_enable <= 1'b0;
      end
    end
  end

  always @(posedge adc_clk or posedge adc_rst) begin
    if (adc_rst == 1'b1) begin
      adc_wr_int <= 'd0;
      adc_wdata_int <= 'd0;
      adc_waddr_int <= 'd0;
    end else begin
      if (adc_xfer_init == 1'b1) begin
        adc_wr_int <= 'd0;
        adc_wdata_int <= 'd0;
        adc_waddr_int <= 'd0;
      end else begin
        adc_wr_int <= adc_wr & adc_xfer_enable;
        adc_wdata_int <= adc_wdata;
        if (adc_wr_int == 1'b1) begin
          adc_waddr_int <= adc_waddr_int + 1'b1;
        end
      end
    end
  end

  always @(posedge adc_clk or posedge adc_rst) begin
    if (adc_rst == 1'b1) begin
      adc_waddr_rel_t <= 'd0;
      adc_waddr_rel <= 'd0;
    end else begin
      if ((adc_wr_int == 1'b1) && (adc_waddr_int[2:0] == 3'd7)) begin
        adc_waddr_rel_t <= ~adc_waddr_rel_t;
        adc_waddr_rel <= adc_waddr_int;
      end
    end
  end

  // read interface

  assign dma_xfer_status = 4'd0;
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
      dma_waddr_rel_t_m <= {dma_waddr_rel_t_m[1:0], adc_waddr_rel_t};
      if (dma_waddr_rel_t_s == 1'b1) begin
        dma_waddr_rel <= adc_waddr_rel;
      end
    end
  end
  
  assign dma_wready_s = (DMA_READY_ENABLE == 0) ? 1'b1 : dma_wready;
  assign dma_rd_s = (dma_raddr >= dma_waddr_rel_s) ? 1'b0 : dma_wready_s;

  always @(posedge dma_clk) begin
    if (dma_xfer_req == 1'b0) begin
      dma_rd <= 'd0;
      dma_rd_d <= 'd0;
      dma_rdata_d <= 'd0;
      dma_raddr <= 'd0;
    end else begin
      dma_rd <= dma_rd_s;
      dma_rd_d <= dma_rd;
      dma_rdata_d <= dma_rdata_s;
      if (dma_rd_s == 1'b1) begin
        dma_raddr <= dma_raddr + 1'b1;
      end
    end
  end

  // instantiations

  ad_mem_asym #(
    .ADDR_WIDTH_A (ADC_ADDR_WIDTH),
    .DATA_WIDTH_A (ADC_DATA_WIDTH),
    .ADDR_WIDTH_B (DMA_ADDR_WIDTH),
    .DATA_WIDTH_B (DMA_DATA_WIDTH))
  i_mem_asym (
    .clka (adc_clk),
    .wea (adc_wr_int),
    .addra (adc_waddr_int),
    .dina (adc_wdata_int),
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

endmodule

// ***************************************************************************
// ***************************************************************************
