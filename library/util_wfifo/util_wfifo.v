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
// allows conversions between the adc (or similar) interface to the dma (or similar).
//    * asymmetric bus widths in the range allowed by the fifo
//    * frequency -- dma can run slower at reduced channels
//    * drop or add channels -- post processing samples
//    * interface axis -- allows axi-stream interface
//
// in all cases bandwidth requirements must be met (read >= write).
//
// axis-interface support
//    * set DMA_READY_ENABLE parameter to 1.
//    * connect dma_wr as axis_valid, dma_wready as axis_ready
//    * make sure read bandwidth >= write bandwidth (or drop samples)
//    * some axis interface requires last (use a counter or such externally).
//
// the fifo is external- connect all the fifo_* signals to a fifo generator IP.
// configure the IP to match the buswidths & clocks.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_wfifo (

  // adc interface

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
  dma_wovf,

  // fifo interface

  fifo_rst,
  fifo_rstn,
  fifo_wr,
  fifo_wdata,
  fifo_wovf,
  fifo_rd,
  fifo_rdata,
  fifo_rempty);

  // parameters

  parameter ADC_DATA_WIDTH = 32;
  parameter DMA_DATA_WIDTH = 64;
  parameter DMA_READY_ENABLE = 0;
 
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
  input                           dma_wovf;

  // fifo interface

  output                          fifo_rst;
  output                          fifo_rstn;
  output                          fifo_wr;
  output  [ADC_DATA_WIDTH-1:0]    fifo_wdata;
  input                           fifo_wovf;
  output                          fifo_rd;
  input   [DMA_DATA_WIDTH-1:0]    fifo_rdata;
  input                           fifo_rempty;

  // internal registers

  reg     [ 1:0]                  adc_wovf_m = 'd0;
  reg                             adc_wovf = 'd0;
  reg                             dma_wr_int = 'd0;
  reg                             fifo_rst = 'd0;
  reg                             fifo_rst_p = 'd0;
  reg                             fifo_rstn = 'd0;

  // internal signals

  wire                            dma_wready_s;
  wire    [DMA_DATA_WIDTH-1:0]    dma_wdata_s;

  // adc overflow

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      adc_wovf_m <= 2'd0;
      adc_wovf <= 1'b0;
    end else begin
      adc_wovf_m[0] <= dma_wovf | fifo_wovf;
      adc_wovf_m[1] <= adc_wovf_m[0];
      adc_wovf <= adc_wovf_m[1];
    end
  end

  // write

  assign fifo_wr = adc_wr;

  genvar m;
  generate
  for (m = 0; m < ADC_DATA_WIDTH; m = m + 1) begin: g_wdata
  assign fifo_wdata[m] = adc_wdata[(ADC_DATA_WIDTH-1)-m];
  end
  endgenerate

  // read

  assign dma_wready_s = (DMA_READY_ENABLE == 0) ? 1'b1 : dma_wready;
  assign fifo_rd = ~fifo_rempty & dma_wready_s;

  always @(posedge dma_clk) begin
    dma_wr_int <= fifo_rd;
  end
  
  genvar s;
  generate
  for (s = 0; s < DMA_DATA_WIDTH; s = s + 1) begin: g_rdata
  assign dma_wdata_s[s] = fifo_rdata[(DMA_DATA_WIDTH-1)-s];
  end
  endgenerate

  // reset & resetn

  always @(posedge dma_clk or posedge adc_rst) begin
    if (adc_rst == 1'b1) begin
      fifo_rst_p <= 1'd1;
      fifo_rst <= 1'd1;
      fifo_rstn <= 1'd0;
    end else begin
      fifo_rst_p <= 1'b0;
      fifo_rst <= fifo_rst_p;
      fifo_rstn <= ~fifo_rst_p;
    end
  end

  // axis

  ad_axis_inf_rx #(.DATA_WIDTH(DMA_DATA_WIDTH)) i_axis_inf (
    .clk (dma_clk),
    .rst (fifo_rst),
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
