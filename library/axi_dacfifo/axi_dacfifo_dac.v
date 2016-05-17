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

module axi_dacfifo_dac (

  axi_clk,
  axi_dvalid,
  axi_ddata,
  axi_dready,
  axi_xfer_req,

  dac_clk,
  dac_rst,
  dac_valid,
  dac_data,
  dac_xfer_out,
  dac_dunf,
  dac_dovf

);

  // parameters

  parameter   AXI_DATA_WIDTH = 512;
  parameter   DAC_DATA_WIDTH =  64;

  localparam  MEM_RATIO = AXI_DATA_WIDTH/DAC_DATA_WIDTH;
  localparam  DAC_ADDRESS_WIDTH = 8;
  localparam  AXI_ADDRESS_WIDTH = (MEM_RATIO == 1) ? DAC_ADDRESS_WIDTH :
                                  (MEM_RATIO == 2) ? (DAC_ADDRESS_WIDTH - 1) :
                                  (MEM_RATIO == 4) ? (DAC_ADDRESS_WIDTH - 2) :
                                                     (DAC_ADDRESS_WIDTH - 3);
  localparam  BUF_THRESHOLD_LO = 8'd32;
  localparam  BUF_THRESHOLD_HI = 8'd240;

  // dma write

  input                               axi_clk;
  input                               axi_dvalid;
  input   [(AXI_DATA_WIDTH-1):0]      axi_ddata;
  output                              axi_dready;
  input                               axi_xfer_req;

  // dac read

  input                               dac_clk;
  input                               dac_rst;
  input                               dac_valid;
  output  [(DAC_DATA_WIDTH-1):0]      dac_data;
  output                              dac_xfer_out;
  output                              dac_dunf;
  output                              dac_dovf;

  // internal registers

  reg     [(AXI_ADDRESS_WIDTH-1):0]   axi_waddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_waddr_g = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_raddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_raddr_m = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_addr_diff = 'd0;
  reg                                 axi_dready = 'd0;
  reg                                 axi_almost_full = 1'b0;
  reg                                 axi_dwunf = 1'b0;
  reg                                 axi_almost_empty  = 1'b0;
  reg                                 axi_dwovf = 1'b0;

  reg                                 dac_rd = 'd0;
  reg                                 dac_rd_d = 'd0;
  reg     [(DAC_DATA_WIDTH-1):0]      dac_rdata_d = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_raddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_raddr_g = 'd0;

  reg     [ 2:0]                      dac_dunf_m = 3'b0;
  reg     [ 2:0]                      dac_dovf_m = 3'b0;
  reg     [ 2:0]                      dac_xfer_req_m = 3'b0;

  // internal signals

  wire    [DAC_ADDRESS_WIDTH:0]       axi_addr_diff_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0]   axi_waddr_s;
  wire                                dac_wready_s;
  wire                                dac_rd_s;
  wire    [(DAC_DATA_WIDTH-1):0]      dac_rdata_s;

  wire                                dac_valid_s;

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

  // write interface

  always @(posedge axi_clk) begin
    if (axi_xfer_req == 1'b0) begin
      axi_waddr <= 'd0;
      axi_waddr_g <= 'd0;
    end else begin
      if (axi_dvalid == 1'b1) begin
        axi_waddr <= axi_waddr + 1'b1;
      end
      axi_waddr_g <= b2g(axi_waddr_s);
    end
  end

  // underflow / overflow

  assign axi_addr_diff_s = {1'b1, axi_waddr_s} - axi_raddr;
  assign axi_waddr_s = (MEM_RATIO == 1) ? axi_waddr :
                       (MEM_RATIO == 2) ? {axi_waddr, 1'd0} :
                       (MEM_RATIO == 4) ? {axi_waddr, 2'd0} :
                                          {axi_waddr, 3'd0};

  always @(posedge axi_clk) begin
    if (axi_xfer_req == 1'b0) begin
      axi_addr_diff <= 'd0;
      axi_raddr <= 'd0;
      axi_raddr_m <= 'd0;
      axi_dready <= 'd0;
      axi_almost_full <= 1'b0;
      axi_dwunf <= 1'b0;
      axi_almost_empty <= 1'b0;
      axi_dwovf <= 1'b0;
    end else begin
      axi_raddr_m <= g2b(dac_raddr_g);
      axi_raddr <= axi_raddr_m;
      axi_addr_diff <= axi_addr_diff_s[DAC_ADDRESS_WIDTH-1:0];
      if (axi_addr_diff >= BUF_THRESHOLD_HI) begin
        axi_dready <= 1'b0;
      end else if (axi_addr_diff <= BUF_THRESHOLD_LO) begin
        axi_dready <= 1'b1;
      end
      if (axi_addr_diff > BUF_THRESHOLD_HI) begin
        axi_almost_full <= 1'b1;
      end else begin
        axi_almost_full <= 1'b0;
      end
      if (axi_addr_diff < BUF_THRESHOLD_LO) begin
        axi_almost_empty <= 1'b1;
      end else begin
        axi_almost_empty <= 1'b0;
      end
      axi_dwunf <= (axi_addr_diff == 0) ? 1'b1 : 1'b0;
      axi_dwovf <= (axi_addr_diff == {(DAC_ADDRESS_WIDTH){1'b1}}) ? 1'b1 : 1'b0;
    end
  end

  always @(posedge dac_clk) begin
    dac_dunf_m <= {dac_dunf_m[1:0], axi_dwunf};
    dac_dovf_m <= {dac_dovf_m[1:0], axi_dwovf};
    dac_xfer_req_m <= {dac_xfer_req_m[1:0], axi_xfer_req};
  end

  assign dac_dovf = dac_dovf_m[2];
  assign dac_dunf = dac_dunf_m[2];
  assign dac_xfer_out = dac_xfer_req_m[2];

  // read interface

  assign dac_rd_s = dac_xfer_out & dac_valid;

  always @(posedge dac_clk) begin
    if (dac_xfer_out == 1'b0) begin
      dac_rd <= 'd0;
      dac_rd_d <= 'd0;
      dac_rdata_d <= 'd0;
      dac_raddr <= 'd0;
      dac_raddr_g <= 'd0;
    end else begin
      dac_rd <= dac_rd_s;
      dac_rd_d <= dac_rd;
      dac_rdata_d <= dac_rdata_s;
      if (dac_rd_s == 1'b1) begin
        dac_raddr <= dac_raddr + 1'b1;
      end
      dac_raddr_g <= b2g(dac_raddr);
    end
  end

  // instantiations

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (AXI_ADDRESS_WIDTH),
    .A_DATA_WIDTH (AXI_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DAC_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DAC_DATA_WIDTH))
  i_mem_asym (
    .clka (axi_clk),
    .wea (axi_dvalid),
    .addra (axi_waddr),
    .dina (axi_ddata),
    .clkb (dac_clk),
    .addrb (dac_raddr),
    .doutb (dac_rdata_s));

  ad_axis_inf_rx #(.DATA_WIDTH(DAC_DATA_WIDTH)) i_axis_inf (
    .clk (dac_clk),
    .rst (dac_rst),
    .valid (dac_rd_d),
    .last (1'd0),
    .data (dac_rdata_d),
    .inf_valid (dac_valid_s),
    .inf_last (),
    .inf_data (dac_data),
    .inf_ready (dac_valid));

endmodule

// ***************************************************************************
// ***************************************************************************

