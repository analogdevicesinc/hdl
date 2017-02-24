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

module axi_dacfifo_bypass #(

  parameter   DAC_DATA_WIDTH = 64,
  parameter   DMA_DATA_WIDTH = 64) (

  // dma fifo interface

  input                               dma_clk,
  input       [(DMA_DATA_WIDTH-1):0]  dma_data,
  input                               dma_ready,
  output  reg                         dma_ready_out,
  input                               dma_valid,

  // request and syncronizaiton

  input                               dma_xfer_req,

  // dac fifo interface

  input                               dac_clk,
  input                               dac_rst,
  input                               dac_valid,
  output  reg [(DAC_DATA_WIDTH-1):0]  dac_data,
  output  reg                         dac_dunf
);

  // suported ratios: 1:1 / 1:2 / 1:4 / 1:8 / 2:1 / 4:1 / 8:1

  localparam  MEM_RATIO = (DMA_DATA_WIDTH > DAC_DATA_WIDTH) ? DMA_DATA_WIDTH/DAC_DATA_WIDTH :
                                                              DAC_DATA_WIDTH/DMA_DATA_WIDTH;
  localparam  DAC_ADDRESS_WIDTH = 10;
  localparam  DMA_ADDRESS_WIDTH = (MEM_RATIO == 1) ? DAC_ADDRESS_WIDTH :
                                  (MEM_RATIO == 2) ? ((DMA_DATA_WIDTH > DAC_DATA_WIDTH) ? (DAC_ADDRESS_WIDTH - 1) : (DAC_ADDRESS_WIDTH + 1)) :
                                  (MEM_RATIO == 4) ? ((DMA_DATA_WIDTH > DAC_DATA_WIDTH) ? (DAC_ADDRESS_WIDTH - 2) : (DAC_ADDRESS_WIDTH + 2)) :
                                                     ((DMA_DATA_WIDTH > DAC_DATA_WIDTH) ? (DAC_ADDRESS_WIDTH - 3) : (DAC_ADDRESS_WIDTH + 3));
  localparam  DMA_BUF_THRESHOLD_HI = {(DMA_ADDRESS_WIDTH){1'b1}} - 4;
  localparam  DAC_BUF_THRESHOLD_LO = 4;

  reg     [(DMA_ADDRESS_WIDTH-1):0]     dma_mem_waddr = 'd0;
  reg     [(DMA_ADDRESS_WIDTH-1):0]     dma_mem_waddr_g = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]     dac_mem_raddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]     dac_mem_raddr_g = 'd0;
  reg                                   dma_rst_m1 = 1'b0;
  reg                                   dma_rst = 1'b0;
  reg     [DMA_ADDRESS_WIDTH-1:0]       dma_mem_addr_diff = 1'b0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]     dma_mem_raddr_m1 = 1'b0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]     dma_mem_raddr_m2 = 1'b0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]     dma_mem_raddr = 1'b0;
  reg     [DAC_ADDRESS_WIDTH-1:0]       dac_mem_addr_diff = 1'b0;
  reg     [(DMA_ADDRESS_WIDTH-1):0]     dac_mem_waddr_m1 = 1'b0;
  reg     [(DMA_ADDRESS_WIDTH-1):0]     dac_mem_waddr_m2 = 1'b0;
  reg     [(DMA_ADDRESS_WIDTH-1):0]     dac_mem_waddr = 1'b0;
  reg                                   dac_mem_ready = 1'b0;
  reg                                   dac_xfer_out = 1'b0;
  reg                                   dac_xfer_out_m1 = 1'b0;

  // internal signals

  wire                                  dma_mem_last_read_s;
  wire    [(DMA_ADDRESS_WIDTH):0]       dma_mem_addr_diff_s;
  wire    [(DAC_ADDRESS_WIDTH):0]       dac_mem_addr_diff_s;
  wire    [(DMA_ADDRESS_WIDTH-1):0]     dma_mem_raddr_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0]     dac_mem_waddr_s;
  wire                                  dma_mem_wea_s;
  wire                                  dac_mem_rea_s;
  wire    [(DAC_DATA_WIDTH-1):0]        dac_mem_rdata_s;
  wire    [DMA_ADDRESS_WIDTH:0]         dma_address_diff_s;
  wire    [DAC_ADDRESS_WIDTH:0]         dac_address_diff_s;

  // binary to grey conversion

  function [7:0] b2g;
    input [7:0] b;
    reg   [7:0] g;
    begin
      g[7] = b[7];
      g[6] = b[7] ^ b[6];
      g[5] = b[6] ^ b[5];
      g[4] = b[5] ^ b[4];
      g[3] = b[4] ^ b[3];
      g[2] = b[3] ^ b[2];
      g[1] = b[2] ^ b[1];
      g[0] = b[1] ^ b[0];
      b2g = g;
    end
  endfunction

  // grey to binary conversion

  function [7:0] g2b;
    input [7:0] g;
    reg   [7:0] b;
    begin
      b[7] = g[7];
      b[6] = b[7] ^ g[6];
      b[5] = b[6] ^ g[5];
      b[4] = b[5] ^ g[4];
      b[3] = b[4] ^ g[3];
      b[2] = b[3] ^ g[2];
      b[1] = b[2] ^ g[1];
      b[0] = b[1] ^ g[0];
      g2b = b;
    end
  endfunction

  // An asymmetric memory to transfer data from DMAC interface to DAC interface

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (DMA_ADDRESS_WIDTH),
    .A_DATA_WIDTH (DMA_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DAC_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DAC_DATA_WIDTH))
  i_mem_asym (
    .clka (dma_clk),
    .wea (dma_mem_wea_s),
    .addra (dma_mem_waddr),
    .dina (dma_data),
    .clkb (dac_clk),
    .addrb (dac_mem_raddr),
    .doutb (dac_mem_rdata_s));

  // dma reset is brought from dac domain

  always @(posedge dma_clk) begin
    dma_rst_m1 <= dac_rst;
    dma_rst <= dma_rst_m1;
  end

  // Write address generation for the asymmetric memory

  assign dma_mem_wea_s = dma_xfer_req & dma_valid & dma_ready;

  always @(posedge dma_clk) begin
    if (dma_rst == 1'b1) begin
      dma_mem_waddr <= 'h0;
      dma_mem_waddr_g <= 'h0;
    end else begin
      if (dma_mem_wea_s == 1'b1) begin
        dma_mem_waddr <= dma_mem_waddr + 1;
      end
      dma_mem_waddr_g <= b2g(dma_mem_waddr);
    end
  end

  // The memory module request data until reaches the high threshold.

  always @(posedge dma_clk) begin
    if (dma_rst == 1'b1) begin
      dma_mem_addr_diff <= 'b0;
      dma_mem_raddr_m1 <= 'b0;
      dma_mem_raddr_m2 <= 'b0;
      dma_mem_raddr <= 'b0;
      dma_ready_out <= 1'b0;
    end else begin
      dma_mem_raddr_m1 <= dac_mem_raddr_g;
      dma_mem_raddr_m2 <= dma_mem_raddr_m1;
      dma_mem_raddr <= g2b(dma_mem_raddr_m2);
      dma_mem_addr_diff <= dma_address_diff_s[DMA_ADDRESS_WIDTH-1:0];
      if (dma_mem_addr_diff >= DMA_BUF_THRESHOLD_HI) begin
        dma_ready_out <= 1'b0;
      end else begin
        dma_ready_out <= 1'b1;
      end
    end
  end

  // relative address offset on dma domain
  assign dma_address_diff_s = {1'b1, dma_mem_waddr} - dma_mem_raddr_s;
  assign dma_mem_raddr_s = (DMA_DATA_WIDTH>DAC_DATA_WIDTH) ?
                                ((MEM_RATIO == 1) ? (dma_mem_raddr) :
                                 (MEM_RATIO == 2) ? (dma_mem_raddr[(DAC_ADDRESS_WIDTH-1):1]) :
                                 (MEM_RATIO == 4) ? (dma_mem_raddr[(DAC_ADDRESS_WIDTH-1):2]) : (dma_mem_raddr[(DAC_ADDRESS_WIDTH-1):3])) :
                                ((MEM_RATIO == 1) ? (dma_mem_raddr) :
                                 (MEM_RATIO == 2) ? ({dma_mem_raddr, 1'b0}) :
                                 (MEM_RATIO == 4) ? ({dma_mem_raddr, 2'b0}) : ({dma_mem_raddr, 3'b0}));


  // relative address offset on dac domain
  assign dac_address_diff_s = {1'b1, dac_mem_raddr} - dac_mem_waddr_s;
  assign dac_mem_waddr_s = (DAC_DATA_WIDTH>DMA_DATA_WIDTH) ?
                                ((MEM_RATIO == 1) ? (dac_mem_waddr) :
                                 (MEM_RATIO == 2) ? (dac_mem_waddr[(DMA_ADDRESS_WIDTH-1):1]) :
                                 (MEM_RATIO == 4) ? (dac_mem_waddr[(DMA_ADDRESS_WIDTH-1):2]) : (dac_mem_waddr[(DMA_ADDRESS_WIDTH-1):3])) :
                                ((MEM_RATIO == 1) ? (dac_mem_waddr) :
                                 (MEM_RATIO == 2) ? ({dac_mem_waddr, 1'b0}) :
                                 (MEM_RATIO == 4) ? ({dac_mem_waddr, 2'b0}) : ({dac_mem_waddr, 3'b0}));

  // Read address generation for the asymmetric memory

  assign dac_mem_rea_s = dac_valid & dac_mem_ready;

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_mem_raddr <= 'h0;
      dac_mem_raddr_g <= 'h0;
    end else begin
      if (dac_mem_rea_s == 1'b1) begin
        dac_mem_raddr <= dac_mem_raddr + 1;
      end
      dac_mem_raddr_g <= b2g(dac_mem_raddr);
    end
  end

  // The memory module is ready if it's not empty

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_mem_addr_diff <= 'b0;
      dac_mem_waddr_m1 <= 'b0;
      dac_mem_waddr_m2 <= 'b0;
      dac_mem_waddr <= 'b0;
      dac_mem_ready <= 1'b0;
    end else begin
      dac_mem_waddr_m1 <= dma_mem_waddr_g;
      dac_mem_waddr_m2 <= dac_mem_waddr_m1;
      dac_mem_waddr <= g2b(dac_mem_waddr_m2);
      dac_mem_addr_diff <= dac_address_diff_s[DAC_ADDRESS_WIDTH-1:0];
      if (dac_mem_addr_diff > 0) begin
        dac_mem_ready <= 1'b1;
      end else begin
        dac_mem_ready <= 1'b0;
      end
    end
  end

  // define underflow

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_xfer_out_m1 <= 1'b0;
      dac_xfer_out <= 1'b0;
      dac_dunf <= 1'b0;
    end else begin
      dac_xfer_out_m1 <= dma_xfer_req;
      dac_xfer_out <= dac_xfer_out_m1;
      dac_dunf <= (dac_valid == 1'b1) ? (dac_xfer_out & ~dac_mem_ready) : dac_dunf;
    end
  end

  // DAC data output logic

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_data <= 0;
    end else begin
      dac_data <= dac_mem_rdata_s;
    end
  end

endmodule

