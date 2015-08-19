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
// dac vdma read

module ad_axis_dma_tx (

  // vdma interface

  dma_clk,
  dma_rst,
  dma_fs,
  dma_valid,
  dma_data,
  dma_ready,
  dma_ovf,
  dma_unf,

  // dac interface 

  dac_clk,
  dac_rst,
  dac_rd,
  dac_valid,
  dac_data,

  // processor interface

  dma_frmcnt);

  // parameters

  parameter       DATA_WIDTH = 64;
  localparam      DW = DATA_WIDTH - 1;
  localparam      BUF_THRESHOLD_LO = 6'd3;
  localparam      BUF_THRESHOLD_HI = 6'd60;
  localparam      RDY_THRESHOLD_LO = 6'd40;
  localparam      RDY_THRESHOLD_HI = 6'd50;

  // vdma interface

  input           dma_clk;
  input           dma_rst;
  output          dma_fs;
  input           dma_valid;
  input   [DW:0]  dma_data;
  output          dma_ready;
  output          dma_ovf;
  output          dma_unf;

  // dac interface

  input           dac_clk;
  input           dac_rst;
  input           dac_rd;
  output          dac_valid;
  output  [DW:0]  dac_data;

  // processor interface

  input   [31:0]  dma_frmcnt;

  // internal registers

  reg             dac_start_m1 = 'd0;
  reg             dac_start = 'd0;
  reg             dac_resync_m1 = 'd0;
  reg             dac_resync = 'd0;
  reg     [ 5:0]  dac_raddr = 'd0;
  reg     [ 5:0]  dac_raddr_g = 'd0;
  reg             dac_rd_d = 'd0;
  reg             dac_rd_2d = 'd0;
  reg             dac_valid = 'd0;
  reg     [DW:0]  dac_data = 'd0;
  reg     [31:0]  dma_clkcnt = 'd0;
  reg             dma_fs = 'd0;
  reg     [ 5:0]  dma_raddr_g_m1 = 'd0;
  reg     [ 5:0]  dma_raddr_g_m2 = 'd0;
  reg     [ 5:0]  dma_raddr = 'd0;
  reg     [ 5:0]  dma_addr_diff = 'd0;
  reg             dma_ready = 'd0;
  reg             dma_almost_full = 'd0;
  reg             dma_almost_empty = 'd0;
  reg             dma_ovf = 'd0;
  reg             dma_unf = 'd0;
  reg             dma_resync = 'd0;
  reg             dma_start = 'd0;
  reg             dma_wr = 'd0;
  reg     [ 5:0]  dma_waddr = 'd0;
  reg     [DW:0]  dma_wdata = 'd0;

  // internal signals

  wire            dma_wr_s;
  wire    [ 6:0]  dma_addr_diff_s;
  wire            dma_ovf_s;
  wire            dma_unf_s;
  wire    [DW:0]  dac_rdata_s;

  // binary to grey coversion

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

  // dac read interface

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_start_m1 <= 'd0;
      dac_start <= 'd0;
      dac_resync_m1 <= 'd0;
      dac_resync <= 'd0;
    end else begin
      dac_start_m1 <= dma_start;
      dac_start <= dac_start_m1;
      dac_resync_m1 <= dma_resync;
      dac_resync <= dac_resync_m1;
    end
    if ((dac_start == 1'b0) || (dac_resync == 1'b1) || (dac_rst == 1'b1)) begin
      dac_raddr <= 6'd0;
    end else if (dac_rd == 1'b1) begin
      dac_raddr <= dac_raddr + 1'b1;
    end
    dac_raddr_g <= b2g(dac_raddr);
    dac_rd_d <= dac_rd;
    dac_rd_2d <= dac_rd_d;
    dac_valid <= dac_rd_2d;
    dac_data <= dac_rdata_s;
  end
    
  // generate fsync

  always @(posedge dma_clk) begin
    if ((dma_resync == 1'b1) || (dma_rst == 1'b1) || (dma_clkcnt >= dma_frmcnt)) begin
      dma_clkcnt <= 16'd0;
    end else begin
      dma_clkcnt <= dma_clkcnt + 1'b1;
    end
    if (dma_clkcnt == 32'd1) begin
      dma_fs <= 1'b1;
    end else begin
      dma_fs <= 1'b0;
    end
  end

  // overflow or underflow status

  assign dma_addr_diff_s = {1'b1, dma_waddr} - dma_raddr;
  assign dma_ovf_s = (dma_addr_diff < BUF_THRESHOLD_LO) ? dma_almost_full : 1'b0;
  assign dma_unf_s = (dma_addr_diff > BUF_THRESHOLD_HI) ? dma_almost_empty : 1'b0;

  always @(posedge dma_clk) begin
    if (dma_rst == 1'b1) begin
      dma_raddr_g_m1 <= 'd0;
      dma_raddr_g_m2 <= 'd0;
    end else begin
      dma_raddr_g_m1 <= dac_raddr_g;
      dma_raddr_g_m2 <= dma_raddr_g_m1;
    end
    dma_raddr <= g2b(dma_raddr_g_m2);
    dma_addr_diff <= dma_addr_diff_s[5:0];
    if (dma_addr_diff >= RDY_THRESHOLD_HI) begin
      dma_ready <= 1'b0;
    end else if (dma_addr_diff <= RDY_THRESHOLD_LO) begin
      dma_ready <= 1'b1;
    end
    if (dma_addr_diff > BUF_THRESHOLD_HI) begin
      dma_almost_full <= 1'b1;
    end else begin
      dma_almost_full <= 1'b0;
    end
    if (dma_addr_diff < BUF_THRESHOLD_LO) begin
      dma_almost_empty <= 1'b1;
    end else begin
      dma_almost_empty <= 1'b0;
    end
    dma_ovf <= dma_ovf_s;
    dma_unf <= dma_unf_s;
    dma_resync <= dma_ovf | dma_unf;
  end

  // vdma write

  assign dma_wr_s = dma_valid & dma_ready;

  always @(posedge dma_clk) begin
    if (dma_rst == 1'b1) begin
      dma_start <= 1'b0;
    end else if (dma_wr_s == 1'b1) begin
      dma_start <= 1'b1;
    end
    dma_wr <= dma_wr_s;
    if ((dma_resync == 1'b1) || (dma_rst == 1'b1)) begin
      dma_waddr <= 6'd0;
    end else if (dma_wr == 1'b1) begin
      dma_waddr <= dma_waddr + 1'b1;
    end
    dma_wdata <= dma_data;
  end

  // memory

  ad_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDRESS_WIDTH(6)) i_mem (
    .clka (dma_clk),
    .wea (dma_wr),
    .addra (dma_waddr),
    .dina (dma_wdata),
    .clkb (dac_clk),
    .addrb (dac_raddr),
    .doutb (dac_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
