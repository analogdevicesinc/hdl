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
// allows conversions between the dac (or similar) interface to the dma (or similar).
//    * asymmetric bus widths in the range allowed by the fifo
//    * frequency -- dma can run slower at reduced channels
//    * drop or add channels -- pre processing samples
//    * interface axis -- allows axi-stream interface
//
// in all cases bandwidth requirements must be met (read <= write).
//
// axis-interface support
//    * connect dma_rd as axis_ready, make sure data is present (use dma_rd as
//        enable for the data pipe line). leave axis_valid open!
//    * make sure read bandwidth <= write bandwidth (or interpolate samples)
//
// the fifo is external- connect all the fifo_* signals to a fifo generator IP.
// configure the IP to match the buswidths & clocks.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_rfifo (

  // dac interface

  dac_clk,
  dac_rd,
  dac_rdata,
  dac_runf,

  // dma interface

  dma_clk,
  dma_rd,
  dma_rdata,
  dma_runf,

  // fifo interface

  fifo_rst,
  fifo_rstn,
  fifo_wr,
  fifo_wdata,
  fifo_wfull,
  fifo_rd,
  fifo_rdata,
  fifo_rempty,
  fifo_runf);

  // parameters

  parameter DAC_DATA_WIDTH = 32;
  parameter DMA_DATA_WIDTH = 64;
 
  // dac interface

  input                           dac_clk;
  input                           dac_rd;
  output  [DAC_DATA_WIDTH-1:0]    dac_rdata;
  output                          dac_runf;

  // dma interface

  input                           dma_clk;
  output                          dma_rd;
  input   [DMA_DATA_WIDTH-1:0]    dma_rdata;
  input                           dma_runf;

  // fifo interface

  output                          fifo_rst;
  output                          fifo_rstn;
  output                          fifo_wr;
  output  [DMA_DATA_WIDTH-1:0]    fifo_wdata;
  input                           fifo_wfull;
  output                          fifo_rd;
  input   [DAC_DATA_WIDTH-1:0]    fifo_rdata;
  input                           fifo_rempty;
  input                           fifo_runf;

  // internal registers

  reg     [ 1:0]                  dac_runf_m = 'd0;
  reg                             dac_runf = 'd0;
  reg                             dma_rd = 'd0;

  // dac underflow

  always @(posedge dac_clk) begin
    dac_runf_m[0] <= dma_runf | fifo_runf;
    dac_runf_m[1] <= dac_runf_m[0];
    dac_runf <= dac_runf_m[1];
  end

  // dma read

  always @(posedge dma_clk) begin
    dma_rd <= ~fifo_wfull;
  end

  // write

  assign fifo_wr = dma_rd;

  genvar s;
  generate
  for (s = 0; s < DMA_DATA_WIDTH; s = s + 1) begin: g_wdata
  assign fifo_wdata[s] = dma_rdata[(DMA_DATA_WIDTH-1)-s];
  end
  endgenerate

  // read

  assign fifo_rd = ~fifo_rempty & dac_rd;

  genvar m;
  generate
  for (m = 0; m < DAC_DATA_WIDTH; m = m + 1) begin: g_rdata
  assign dac_rdata[m] = fifo_rdata[(DAC_DATA_WIDTH-1)-m];
  end
  endgenerate

  // reset & resetn

  assign fifo_rst = 1'b0;
  assign fifo_rstn = 1'b1;

endmodule

// ***************************************************************************
// ***************************************************************************
