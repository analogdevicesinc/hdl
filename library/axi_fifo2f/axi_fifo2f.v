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

module axi_fifo2f (

  adc_rst,
  adc_clk,
  adc_wr,
  adc_wdata,
  adc_wovf,

  dma_rstn,
  dma_clk,
  dma_wr,
  dma_wdata,
  dma_wready,
  dma_wovf,
  dma_xfer_req,
  dma_xfer_status,

  fifo_rst,
  fifo_wr,
  fifo_wdata,
  fifo_wfull,
  fifo_wovf,
  fifo_rd,
  fifo_rdata,
  fifo_rempty);

  // parameters

  parameter ADC_DATA_WIDTH = 32;
  parameter DMA_DATA_WIDTH = 64;
  parameter DMA_READY_ENABLE = 0;
  parameter MEM_ADDRLIMIT = 32'h00100000;
 
  // adc write

  input                           adc_rst;
  input                           adc_clk;
  input                           adc_wr;
  input   [ADC_DATA_WIDTH-1:0]    adc_wdata;
  output                          adc_wovf;

  // dma read

  input                           dma_rstn;
  input                           dma_clk;
  output                          dma_wr;
  output  [DMA_DATA_WIDTH-1:0]    dma_wdata;
  input                           dma_wready;
  input                           dma_wovf;
  input                           dma_xfer_req;
  output  [  4:0]                 dma_xfer_status;

  // fifo interface

  output                          fifo_rst;
  output                          fifo_wr;
  output  [ADC_DATA_WIDTH-1:0]    fifo_wdata;
  input                           fifo_wfull;
  input                           fifo_wovf;
  output                          fifo_rd;
  input   [DMA_DATA_WIDTH-1:0]    fifo_rdata;
  input                           fifo_rempty;

  // internal registers

  reg     [  2:0]                 adc_xfer_req_m = 'd0;
  reg                             adc_xfer_init = 'd0;
  reg     [ 31:0]                 adc_xfer_addr = 'd0;
  reg                             adc_xfer_enable = 'd0;
  reg                             adc_wovf_m1 = 'd0;
  reg                             adc_wovf_m2 = 'd0;
  reg                             adc_wovf = 'd0;
  reg                             fifo_rst = 'd0;
  reg                             fifo_wr = 'd0;
  reg     [ADC_DATA_WIDTH-1:0]    fifo_wdata = 'd0;
  reg                             dma_rst = 'd0;
  reg                             dma_wr_int = 'd0;

  // internal signals

  wire                            adc_wovf_s;
  wire                            fifo_wr_s;
  wire    [ADC_DATA_WIDTH-1:0]    fifo_wdata_s;
  wire    [DMA_DATA_WIDTH-1:0]    dma_wdata_s;
  wire                            dma_wready_s;

  // write when dma is active and within limits

  assign adc_wovf_s = dma_wovf | fifo_wovf;
  assign fifo_wr_s = adc_wr & adc_xfer_enable;

  genvar m;
  generate
  for (m = 0; m < ADC_DATA_WIDTH; m = m + 1) begin: g_wdata
  assign fifo_wdata_s[m] = adc_wdata[(ADC_DATA_WIDTH-1)-m];
  end
  endgenerate

  always @(posedge adc_clk or posedge adc_rst) begin
    if (adc_rst == 1'b1) begin
      adc_xfer_req_m <= 3'd0;
      adc_xfer_init <= 1'd0;
      adc_xfer_addr <= 32'd0;
      adc_xfer_enable <= 1'd0;
      adc_wovf_m1 <= 1'b0;
      adc_wovf_m2 <= 1'b0;
      adc_wovf <= 1'b0;
    end else begin
      adc_xfer_req_m <= {adc_xfer_req_m[1:0], dma_xfer_req};
      adc_xfer_init <= adc_xfer_req_m[1] & ~adc_xfer_req_m[2];
      if (adc_xfer_init == 1'b1) begin
        adc_xfer_addr <= 32'd0;
      end else if ((fifo_wr == 1'b1) && (adc_xfer_addr < MEM_ADDRLIMIT)) begin
        adc_xfer_addr <= adc_xfer_addr + 1'b1;
      end
      if (adc_xfer_init == 1'b1) begin
        adc_xfer_enable <= 1'b1;
      end else if (adc_xfer_addr >= MEM_ADDRLIMIT) begin
        adc_xfer_enable <= 1'b0;
      end
      adc_wovf_m1 <= adc_wovf_s;
      adc_wovf_m2 <= adc_wovf_m1;
      adc_wovf <= adc_wovf_m2;
    end
  end

  always @(posedge adc_clk) begin
    fifo_rst <= ~adc_xfer_req_m[1];
    fifo_wr <= fifo_wr_s;
    fifo_wdata <= fifo_wdata_s;
  end

  // read is non-destructive

  assign dma_xfer_status = 5'd0;
  assign fifo_rd = dma_wready & ~fifo_rempty;

  always @(posedge dma_clk or negedge dma_rstn) begin
    if (dma_rstn == 1'b0) begin
      dma_rst <= 1'b1;
      dma_wr_int <= 1'b0;
    end else begin
      dma_rst <= 1'b0;
      dma_wr_int <= fifo_rd;
    end
  end
  
  genvar s;
  generate
  for (s = 0; s < DMA_DATA_WIDTH; s = s + 1) begin: g_rdata
  assign dma_wdata_s[s] = fifo_rdata[(DMA_DATA_WIDTH-1)-s];
  end
  endgenerate

  assign dma_wready_s = (DMA_READY_ENABLE == 0) ? 1'b1 : dma_wready;

  ad_axis_inf_rx #(.DATA_WIDTH(DMA_DATA_WIDTH)) i_axis_inf (
    .clk (dma_clk),
    .rst (dma_rst),
    .valid (dma_wr_int),
    .last (1'd0),
    .data (dma_wdata_s),
    .inf_valid (dma_wr),
    .inf_last (),
    .inf_data (dma_wdata),
    .inf_ready (dma_wready_s));

endmodule

// ***************************************************************************
// ***************************************************************************
