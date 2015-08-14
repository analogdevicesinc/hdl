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

module ad_axis_dma_rx (

  // dma interface

  dma_clk,
  dma_rst,
  dma_valid,
  dma_last,
  dma_data,
  dma_ready,
  dma_ovf,
  dma_unf,
  dma_status,
  dma_bw,

  // data interface

  adc_clk,
  adc_rst,
  adc_valid,
  adc_data,

  // processor interface

  dma_start,
  dma_stream,
  dma_count);

  // parameters

  parameter       DATA_WIDTH = 64;
  localparam      DW = DATA_WIDTH - 1;
  localparam      BUF_THRESHOLD_LO = 6'd3;
  localparam      BUF_THRESHOLD_HI = 6'd60;
  localparam      DATA_WIDTH_IN_BYTES = DATA_WIDTH/8;

  // dma interface

  input           dma_clk;
  input           dma_rst;
  output          dma_valid;
  output          dma_last;
  output  [DW:0]  dma_data;
  input           dma_ready;
  output          dma_ovf;
  output          dma_unf;
  output          dma_status;
  output  [31:0]  dma_bw;

  // data interface

  input           adc_clk;
  input           adc_rst;
  input           adc_valid;
  input   [DW:0]  adc_data;

  // processor interface

  input           dma_start;
  input           dma_stream;
  input   [31:0]  dma_count;

  // internal registers

  reg             dma_valid_int = 'd0;
  reg             dma_last_int = 'd0;
  reg     [DW:0]  dma_data_int = 'd0;
  reg             dma_capture_enable = 'd0;
  reg     [31:0]  dma_capture_count = 'd0;
  reg             dma_rd = 'd0;
  reg     [ 5:0]  dma_raddr = 'd0;
  reg             dma_release_toggle_m1 = 'd0;
  reg             dma_release_toggle_m2 = 'd0;
  reg             dma_release_toggle_m3 = 'd0;
  reg     [ 5:0]  dma_release_waddr = 'd0;
  reg     [ 5:0]  dma_waddr_m1 = 'd0;
  reg     [ 5:0]  dma_waddr_m2 = 'd0;
  reg     [ 5:0]  dma_waddr = 'd0;
  reg     [ 5:0]  dma_addr_diff = 'd0;
  reg             dma_almost_full = 'd0;
  reg             dma_almost_empty = 'd0;
  reg             dma_ovf = 'd0;
  reg             dma_unf = 'd0;
  reg             dma_resync = 'd0;
  reg             adc_wr = 'd0;
  reg     [ 5:0]  adc_waddr = 'd0;
  reg     [ 5:0]  adc_waddr_g = 'd0;
  reg     [ 3:0]  adc_release_count = 'd0;
  reg     [DW:0]  adc_wdata = 'd0;
  reg             adc_release_toggle = 'd0;
  reg     [ 5:0]  adc_release_waddr = 'd0;
  reg             adc_resync_m1 = 'd0;
  reg             adc_resync_m2 = 'd0;
  reg             adc_resync = 'd0;

  // internal signals

  wire            dma_rd_valid_s;
  wire            dma_last_s;
  wire            dma_ready_s;
  wire            dma_rd_s;
  wire            dma_release_s;
  wire    [ 6:0]  dma_addr_diff_s;
  wire            dma_ovf_s;
  wire            dma_unf_s;
  wire    [DW:0]  dma_rdata_s;

  // binary to grey conversion

  function [5:0] b2g;
    input [5:0] b;
    reg   [5:0] g;
    begin
      g[5] = b[5];
      g[4] = b[5] ^ b[4];
      g[3] = b[4] ^ b[3];
      g[2] = b[3] ^ b[2];
      g[1] = b[2] ^ b[1];
      g[0] = b[1] ^ b[0];
      b2g = g;
    end
  endfunction

  // grey to binary conversion

  function [5:0] g2b;
    input [5:0] g;
    reg   [5:0] b;
    begin
      b[5] = g[5];
      b[4] = b[5] ^ g[4];
      b[3] = b[4] ^ g[3];
      b[2] = b[3] ^ g[2];
      b[1] = b[2] ^ g[1];
      b[0] = b[1] ^ g[0];
      g2b = b;
    end
  endfunction

  // dma read- user interface

  assign dma_bw = DATA_WIDTH_IN_BYTES;
  assign dma_status = dma_capture_enable;

  always @(posedge dma_clk) begin
    dma_valid_int <= dma_rd_valid_s;
    dma_last_int <= dma_last_s;
    dma_data_int <= dma_rdata_s;
  end

  // dma read- capture control signals

  assign dma_rd_valid_s = dma_capture_enable & dma_rd;
  assign dma_last_s = (dma_capture_count == dma_count) ? dma_rd_valid_s : 1'b0;

  always @(posedge dma_clk) begin
    if ((dma_stream == 1'b0) && (dma_last_s == 1'b1)) begin
      dma_capture_enable <= 1'b0;
    end else if (dma_start == 1'b1) begin
      dma_capture_enable <= 1'b1;
    end
    if ((dma_capture_enable == 1'b0) || (dma_last_s == 1'b1)) begin
      dma_capture_count <= dma_bw;
    end else if (dma_rd == 1'b1) begin
      dma_capture_count <= dma_capture_count + dma_bw;
    end
  end

  // dma read- read data always and pass it to the external memory

  assign dma_ready_s = (~dma_capture_enable) | dma_ready;
  assign dma_rd_s = (dma_release_waddr == dma_raddr) ? 1'b0 : dma_ready_s;

  always @(posedge dma_clk) begin
    dma_rd <= dma_rd_s;
    if ((dma_resync == 1'b1) || (dma_rst == 1'b1)) begin
      dma_raddr <= 6'd0;
    end else if (dma_rd_s == 1'b1) begin
      dma_raddr <= dma_raddr + 1'b1;
    end
  end

  // dma read- get bursts of adc data from the other side

  assign dma_release_s = dma_release_toggle_m3 ^ dma_release_toggle_m2;

  always @(posedge dma_clk) begin
    if (dma_rst == 1'b1) begin
      dma_release_toggle_m1 <= 'd0;
      dma_release_toggle_m2 <= 'd0;
      dma_release_toggle_m3 <= 'd0;
    end else begin
      dma_release_toggle_m1 <= adc_release_toggle;
      dma_release_toggle_m2 <= dma_release_toggle_m1;
      dma_release_toggle_m3 <= dma_release_toggle_m2;
    end
    if (dma_resync == 1'b1) begin
      dma_release_waddr <= 6'd0;
    end else if (dma_release_s == 1'b1) begin
      dma_release_waddr <= adc_release_waddr;
    end
  end

  // dma read- get free running write address for ovf/unf checking

  assign dma_addr_diff_s = {1'b1, dma_waddr} - dma_raddr;
  assign dma_ovf_s = (dma_addr_diff < BUF_THRESHOLD_LO) ? dma_almost_full : 1'b0;
  assign dma_unf_s = (dma_addr_diff > BUF_THRESHOLD_HI) ? dma_almost_empty : 1'b0;

  always @(posedge dma_clk) begin
    if (dma_rst == 1'b1) begin
      dma_waddr_m1 <= 'd0;
      dma_waddr_m2 <= 'd0;
    end else begin
      dma_waddr_m1 <= adc_waddr_g;
      dma_waddr_m2 <= dma_waddr_m1;
    end
    dma_waddr <= g2b(dma_waddr_m2);
    dma_addr_diff <= dma_addr_diff_s[5:0];
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

  // adc write- used here to simply transfer data to the dma side
  // address is released with a free running counter

  always @(posedge adc_clk) begin
    adc_wr <= adc_valid;
    if ((adc_resync == 1'b1) || (adc_rst == 1'b1)) begin
      adc_waddr <= 6'd0;
    end else if (adc_wr == 1'b1) begin
      adc_waddr <= adc_waddr + 1'b1;
    end
    adc_waddr_g <= b2g(adc_waddr);
    adc_wdata <= adc_data;
    adc_release_count <= adc_release_count + 1'b1;
    if (adc_release_count == 4'hf) begin
      adc_release_toggle <= ~adc_release_toggle;
      adc_release_waddr <= adc_waddr;
    end
    if (adc_rst == 1'b1) begin
      adc_resync_m1 <= 'd0;
      adc_resync_m2 <= 'd0;
    end else begin
      adc_resync_m1 <= dma_resync;
      adc_resync_m2 <= adc_resync_m1;
    end
    adc_resync <= adc_resync_m2;
  end

  // interface handler for ready

  ad_axis_inf_rx #(.DATA_WIDTH(DATA_WIDTH)) i_axis_inf (
    .clk (dma_clk),
    .rst (dma_rst),
    .valid (dma_valid_int),
    .last (dma_last_int),
    .data (dma_data_int),
    .inf_valid (dma_valid),
    .inf_last (dma_last),
    .inf_data (dma_data),
    .inf_ready (dma_ready));

  // buffer (mainly for clock domain transfer)

  ad_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(6)) i_mem (
    .clka (adc_clk),
    .wea (adc_wr),
    .addra (adc_waddr),
    .dina (adc_wdata),
    .clkb (dma_clk),
    .addrb (dma_raddr),
    .doutb (dma_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
