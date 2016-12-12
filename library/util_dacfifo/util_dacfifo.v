// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
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

module util_dacfifo (

  // DMA interface

  dma_clk,
  dma_rst,
  dma_valid,
  dma_data,
  dma_ready,
  dma_xfer_req,
  dma_xfer_last,

  // DAC interface

  dac_clk,
  dac_valid,
  dac_data,
  dac_xfer_out,

  dac_fifo_bypass
);

  // depth of the FIFO

  parameter       ADDRESS_WIDTH = 6;
  parameter       DATA_WIDTH = 128;

  // port definitions

  // DMA interface

  input                               dma_clk;
  input                               dma_rst;
  input                               dma_valid;
  input   [(DATA_WIDTH-1):0]          dma_data;
  output                              dma_ready;
  input                               dma_xfer_req;
  input                               dma_xfer_last;

  // DAC interface

  input                               dac_clk;
  input                               dac_valid;
  output  [(DATA_WIDTH-1):0]          dac_data;
  output                              dac_xfer_out;

  input                               dac_fifo_bypass;

  // internal registers

  reg     [(ADDRESS_WIDTH-1):0]       dma_waddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_lastaddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_lastaddr_d = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_lastaddr_2d = 'b0;
  reg                                 dma_xfer_req_ff = 1'b0;
  reg                                 dma_ready_d = 1'b0;

  reg     [(ADDRESS_WIDTH-1):0]       dac_raddr = 'b0;
  reg                                 dma_xfer_out = 1'b0;
  reg     [ 2:0]                      dac_xfer_out_m = 3'b0;

  // internal wires

  wire                                dma_wren;
  wire    [(DATA_WIDTH-1):0]          dac_data_s;

  // write interface

  always @(posedge dma_clk) begin
    if(dma_rst == 1'b1) begin
      dma_ready_d <= 1'b0;
      dma_xfer_req_ff <= 1'b0;
    end else begin
      dma_ready_d <= 1'b1;                                // Fifo is always ready
      dma_xfer_req_ff <= dma_xfer_req;
    end
  end

  always @(posedge dma_clk) begin
    if(dma_rst == 1'b1) begin
      dma_waddr <= 'b0;
      dma_lastaddr <= 'b0;
      dma_xfer_out <= 1'b0;
    end else begin
      if (dma_valid && dma_xfer_req) begin
        dma_waddr <= dma_waddr + 1;
        dma_xfer_out <= 1'b0;
      end
      if (dma_xfer_last) begin
        dma_lastaddr <= dma_waddr;
        dma_waddr <= 'b0;
        dma_xfer_out <= 1'b1;
      end
    end
  end

  assign dma_wren = dma_valid & dma_xfer_req;

  // sync lastaddr to dac clock domain

  always @(posedge dac_clk) begin
    dac_lastaddr_d <= dma_lastaddr;
    dac_lastaddr_2d <= dac_lastaddr_d;
    dac_xfer_out_m <= {dac_xfer_out_m[1:0], dma_xfer_out};
  end

  assign dac_xfer_out = dac_xfer_out_m[2];

  // generate dac read address

  always @(posedge dac_clk) begin
    if(dac_valid == 1'b1) begin
      if (dac_lastaddr_2d == 'h0) begin
        dac_raddr <= dac_raddr + 1;
      end else begin
        dac_raddr <= (dac_raddr < dac_lastaddr_2d) ? (dac_raddr + 1) : 'b0;
      end
    end
  end

  // memory instantiation

  ad_mem #(
    .ADDRESS_WIDTH (ADDRESS_WIDTH),
    .DATA_WIDTH (DATA_WIDTH))
  i_mem_fifo (
    .clka (dma_clk),
    .wea (dma_wren),
    .addra (dma_waddr),
    .dina (dma_data),
    .clkb (dac_clk),
    .addrb (dac_raddr),
    .doutb (dac_data_s));

  // output logic

  assign dac_data = (dac_fifo_bypass) ? dma_data : dac_data_s;
  assign dma_ready = (dac_fifo_bypass) ? dac_valid : dma_ready_d;

endmodule

