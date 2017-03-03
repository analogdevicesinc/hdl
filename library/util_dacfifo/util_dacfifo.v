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
  dac_rst,
  dac_valid,
  dac_data,
  dac_dunf,
  dac_xfer_out,

  bypass
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
  input                               dac_rst;
  input                               dac_valid;
  output  [(DATA_WIDTH-1):0]          dac_data;
  output                              dac_dunf;
  output                              dac_xfer_out;

  input                               bypass;

  localparam  FIFO_THRESHOLD_HI = {(ADDRESS_WIDTH){1'b1}} - 4;

  // internal registers

  reg     [(ADDRESS_WIDTH-1):0]       dma_waddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_waddr_g = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_lastaddr_g = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_raddr_m1 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_raddr_m2 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_raddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_addr_diff = 'b0;
  reg                                 dma_ready = 1'b0;
  reg                                 dma_ready_fifo = 1'b0;
  reg                                 dma_ready_bypass = 1'b0;
  reg                                 dma_bypass = 1'b0;
  reg                                 dma_bypass_m1 = 1'b0;
  reg                                 dma_xfer_out_fifo = 1'b0;
  reg                                 dma_xfer_out_bypass = 1'b0;

  reg     [(ADDRESS_WIDTH-1):0]       dac_raddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_raddr_g = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_waddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_waddr_m1 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_waddr_m2 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_addr_diff = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_lastaddr_m1 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_lastaddr_m2 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_lastaddr = 'b0;
  reg     [(DATA_WIDTH-1):0]          dac_data = 'b0;
  reg                                 dac_mem_ready = 1'b0;
  reg                                 dac_xfer_out = 1'b0;
  reg                                 dac_xfer_out_fifo = 1'b0;
  reg                                 dac_xfer_out_fifo_m1 = 1'b0;
  reg                                 dac_xfer_out_bypass = 1'b0;
  reg                                 dac_xfer_out_bypass_m1 = 1'b0;
  reg                                 dac_bypass = 1'b0;
  reg                                 dac_bypass_m1 = 1'b0;
  reg                                 dac_dunf = 1'b0;

  // internal wires

  wire                                dma_wren_s;
  wire    [(DATA_WIDTH-1):0]          dac_data_s;
  wire    [(ADDRESS_WIDTH):0]         dma_addr_diff_s;
  wire    [(ADDRESS_WIDTH):0]         dac_addr_diff_s;

  // binary to grey conversion

  function [9:0] b2g;
    input [9:0] b;
    reg   [9:0] g;
    begin
      g[9] = b[9];
      g[8] = b[9] ^ b[8];
      g[7] = b[8] ^ b[7];
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

  function [9:0] g2b;
    input [9:0] g;
    reg   [9:0] b;
    begin
      b[9] = g[9];
      b[8] = b[9] ^ g[8];
      b[7] = b[8] ^ g[7];
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

  // DMA / Write interface

  // fifo is always ready, if it's not in bypass mode

  always @(posedge dma_clk) begin
    if(dma_rst == 1'b1) begin
      dma_ready_fifo <= 1'b0;
    end else begin
      dma_ready_fifo <= 1'b1;
    end
  end

  // if bypass is enabled, fifo request data until reaches the high threshold.

  assign dma_addr_diff_s = {1'b1, dma_waddr} - dma_raddr;

  always @(posedge dma_clk) begin
    if (dma_rst == 1'b1) begin
      dma_addr_diff <= 'b0;
      dma_raddr_m1 <= 'b0;
      dma_raddr_m2 <= 'b0;
      dma_raddr <= 'b0;
      dma_ready_bypass <= 1'b0;
    end else begin
      dma_raddr_m1 <= dac_raddr_g;
      dma_raddr_m2 <= dma_raddr_m1;
      dma_raddr <= g2b(dma_raddr_m2);
      dma_addr_diff <= dma_addr_diff_s[ADDRESS_WIDTH-1:0];
      if (dma_addr_diff >= FIFO_THRESHOLD_HI) begin
        dma_ready_bypass <= 1'b0;
      end else begin
        dma_ready_bypass <= 1'b1;
      end
    end
  end

  // write address generation

  assign dma_wren_s = dma_valid & dma_xfer_req & dma_ready;

  always @(posedge dma_clk) begin
    if(dma_rst == 1'b1) begin
      dma_waddr <= 'b0;
      dma_waddr_g <= 'b0;
      dma_xfer_out_fifo <= 1'b0;
      dma_xfer_out_bypass <= 1'b0;
    end else begin
      if (dma_wren_s == 1'b1) begin
        dma_waddr <= dma_waddr + 1;
        dma_xfer_out_fifo <= 1'b0;
      end
      if (dma_xfer_last == 1'b1) begin
        dma_waddr <= 'b0;
        dma_xfer_out_fifo <= 1'b1;
      end
      dma_waddr_g <= b2g(dma_waddr);
      dma_xfer_out_bypass <= dma_xfer_req;
    end
  end

  // save the last write address

  always @(posedge dma_clk) begin
    if (dma_rst == 1'b1) begin
      dma_lastaddr_g <= 'b0;
    end else begin
      if (dma_bypass == 1'b0) begin
        dma_lastaddr_g <= (dma_xfer_last == 1'b1)? b2g(dma_waddr) : dma_lastaddr_g;
      end
    end
  end

  // DAC / Read interface

  // The memory module is ready if it's not empty

  assign dac_addr_diff_s = {1'b1, dac_waddr} - dac_raddr;

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_addr_diff <= 'b0;
      dac_waddr_m1 <= 'b0;
      dac_waddr_m2 <= 'b0;
      dac_waddr <= 'b0;
      dac_mem_ready <= 1'b0;
    end else begin
      dac_waddr_m1 <= dma_waddr_g;
      dac_waddr_m2 <= dac_waddr_m1;
      dac_waddr <= g2b(dac_waddr_m2);
      dac_addr_diff <= dac_addr_diff_s[ADDRESS_WIDTH-1:0];
      if (dac_addr_diff > 0) begin
        dac_mem_ready <= 1'b1;
      end else begin
        dac_mem_ready <= 1'b0;
      end
    end
  end

  // sync lastaddr to dac clock domain

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_lastaddr_m1 <= 1'b0;
      dac_lastaddr_m2 <= 1'b0;
      dac_xfer_out_fifo_m1 <= 1'b0;
      dac_xfer_out_fifo <= 1'b0;
      dac_xfer_out_bypass_m1 <= 1'b0;
      dac_xfer_out_bypass <= 1'b0;
    end else begin
      dac_lastaddr_m1 <= dma_lastaddr_g;
      dac_lastaddr_m2 <= dac_lastaddr_m1;
      dac_lastaddr <= g2b(dac_lastaddr_m2);
      dac_xfer_out_fifo_m1 <= dma_xfer_out_fifo;
      dac_xfer_out_fifo <= dac_xfer_out_fifo_m1;
      dac_xfer_out_bypass_m1 <= dma_xfer_out_bypass;
      dac_xfer_out_bypass <= dac_xfer_out_bypass_m1;
    end
  end

  // generate dac read address

  assign dac_mem_ren_s = (dac_bypass == 1'b1) ? (dac_valid & dac_mem_ready) : (dac_valid & dac_xfer_out_fifo);

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_raddr <= 'b0;
      dac_raddr_g <= 'b0;
    end else begin
      if (dac_mem_ren_s == 1'b1) begin
        if (dac_lastaddr == 'b0) begin
          dac_raddr <= dac_raddr + 1;
        end else begin
          dac_raddr <= (dac_raddr < dac_lastaddr) ? (dac_raddr + 1) : 'b0;
        end
      end
      dac_raddr_g <= b2g(dac_raddr);
    end
  end

  // memory instantiation

  ad_mem #(
    .ADDRESS_WIDTH (ADDRESS_WIDTH),
    .DATA_WIDTH (DATA_WIDTH))
  i_mem_fifo (
    .clka (dma_clk),
    .wea (dma_wren_s),
    .addra (dma_waddr),
    .dina (dma_data),
    .clkb (dac_clk),
    .addrb (dac_raddr),
    .doutb (dac_data_s));

  // define underflow
  // underflow make sense just if bypass is enabled

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_dunf <= 1'b0;
    end else begin
      dac_dunf <= (dac_bypass == 1'b1) ? (dac_valid & dac_xfer_out_bypass & ~dac_mem_ren_s) : 1'b0;
    end
  end

  // output logic

  always @(posedge dma_clk) begin
    dma_bypass_m1 <= bypass;
    dma_bypass <= dma_bypass_m1;
  end

  always @(posedge dac_clk) begin
    dac_bypass_m1 <= bypass;
    dac_bypass <= dac_bypass_m1;
  end

  always @(posedge dma_clk) begin
    dma_ready <= (dma_bypass == 1'b1) ? dma_ready_bypass : dma_ready_fifo;
  end

  always @(posedge dac_clk) begin
    dac_data <= dac_data_s;
    dac_xfer_out <= (dac_bypass == 1'b1) ? dac_xfer_out_bypass : dac_xfer_out_fifo;
  end

endmodule

