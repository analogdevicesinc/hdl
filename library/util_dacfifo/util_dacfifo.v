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

  // clock signals

  wr_clk,                   // should connect to the dac clock
  rd_clk,                   // should connect to a lower system clock
  rd_rst,

  // read interface

  rd_en,
  rd_valid,
  rd_data,
  rd_underflow,
  rd_xfer_req,

  // write interface

  wr_valid,
  wr_sync,
  wr_data
);

  // parameters

  // depth of the FIFO
  parameter       FIFO_WADDR_WIDTH = 6;
  // read/write interface data width
  parameter       FIFO_RDATA_WIDTH = 64;      // should be less or equal to FIFO_WDATA_WIDTH
  parameter       FIFO_WDATA_WIDTH = 128;

  // local parameters

  // supported ratios with the write interface are 1:1, 1:2, 1:4, 1:8
  localparam      IF_RATIO = FIFO_WDATA_WIDTH/FIFO_RDATA_WIDTH;

  // port definitions

  input                                         wr_clk;
  input                                         rd_clk;
  input                                         rd_rst;

  output                                        rd_en;
  input                                         rd_valid;
  input   [(FIFO_RDATA_WIDTH-1):0]              rd_data;
  input                                         rd_underflow;
  input                                         rd_xfer_req;

  input                                         wr_valid;
  input                                         wr_sync;
  output  [(FIFO_WDATA_WIDTH-1):0]              wr_data;


  // internal registers

  reg     [FIFO_WADDR_WIDTH-1:0]                fifo_waddr = 'h0;
  reg     [(FIFO_RDATA_WIDTH*IF_RATIO)-1:0]     fifo_rdata = 'h0;

  reg     [FIFO_WDATA_WIDTH-1:0]                wr_data = 'h0;
  reg                                           rd_en = 1'b0;

  reg                                           fifo_ren = 1'b0;
  reg     [FIFO_WADDR_WIDTH-1:0]                fifo_maxraddr = 'h0;
  reg     [FIFO_WADDR_WIDTH-1:0]                fifo_raddr = 'h0;
  reg     [FIFO_WADDR_WIDTH-1:0]                fifo_raddr_ff = 'h0;

  reg     [ 2:0]                                fifo_rdata_count = 'h0;

  // internal wires

  wire    [FIFO_WDATA_WIDTH-1:0]                fifo_wdata_s;

  // read interface

  always @(posedge rd_clk) begin
    if(rd_rst == 1'b1) begin
      rd_en <= 1'b0;
    end else begin
      // try to drive the interface with maximum throughput
      rd_en <= (rd_underflow == 0) ? 1'b1 : 1'b0;
    end
  end

  // read counter

  always @(posedge rd_clk) begin
    if (rd_rst == 1'b1) begin
      fifo_rdata_count = 'h0;
    end else if((rd_valid == 1'b1) && (rd_en == 1'b1) && (rd_xfer_req == 1'b1)) begin
      if(IF_RATIO > 1) begin
        fifo_rdata[((IF_RATIO * FIFO_RDATA_WIDTH)-1):((IF_RATIO-1)*FIFO_RDATA_WIDTH)] <= rd_data;
        fifo_rdata[((IF_RATIO-1)*FIFO_RDATA_WIDTH-1): 0] <= fifo_rdata[((IF_RATIO * FIFO_RDATA_WIDTH)-1):FIFO_RDATA_WIDTH];
      end else begin
        fifo_rdata <= rd_data;
      end
      fifo_rdata_count <= (fifo_rdata_count  < (IF_RATIO - 1)) ? (fifo_rdata_count + 1) : 3'h0;
    end
  end

  always @(posedge rd_clk) begin
    if(rd_rst == 1'b1) begin
      fifo_raddr <= 'b0;
      fifo_ren <= 'b0;
      fifo_maxraddr <= {FIFO_WADDR_WIDTH{1'b1}};
      fifo_raddr_ff <= 'b0;
    end else begin

      fifo_ren <= (fifo_rdata_count == (IF_RATIO - 1)) ? (rd_valid & rd_xfer_req) : 1'b0;

      if(rd_xfer_req == 1'b1) begin
        fifo_raddr <= (fifo_ren && rd_xfer_req) ? (fifo_raddr + 1) : fifo_raddr;
      end else begin
        fifo_raddr <= 'h0;
      end
      fifo_raddr_ff <= fifo_raddr;

      fifo_maxraddr <= ((rd_xfer_req == 1'b0) && (fifo_raddr > 'b0)) ?
                      fifo_raddr_ff :
                      fifo_maxraddr;
    end
  end

  // write interface

  always @(posedge wr_clk) begin
    if(wr_valid == 1'b1) begin
      fifo_waddr <= (fifo_waddr < fifo_maxraddr) ? (fifo_waddr + 'b1) : 'b0;
    end
    wr_data <= fifo_wdata_s;
  end

  // instantiations

  ad_mem #(
    .ADDR_WIDTH (FIFO_WADDR_WIDTH),
    .DATA_WIDTH (FIFO_WDATA_WIDTH))
  i_mem_fifo (
    .clka (rd_clk),
    .wea (fifo_ren),
    .addra (fifo_raddr_ff),
    .dina (fifo_rdata),
    .clkb (wr_clk),
    .addrb (fifo_waddr),
    .doutb (fifo_wdata_s));

endmodule
