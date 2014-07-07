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

module axi_fifo2s_wr (

  // request and synchronization

  axi_xfer_req,
  axi_rd_req,
  axi_rd_addr,

  // fifo interface

  m_rst,
  m_clk,
  m_wr,
  m_wdata,

  // axi interface

  axi_clk,
  axi_resetn,
  axi_awvalid,
  axi_awid,
  axi_awburst,
  axi_awlock,
  axi_awcache,
  axi_awprot,
  axi_awqos,
  axi_awuser,
  axi_awlen,
  axi_awsize,
  axi_awaddr,
  axi_awready,
  axi_wvalid,
  axi_wdata,
  axi_wstrb,
  axi_wlast,
  axi_wuser,
  axi_wready,
  axi_bvalid,
  axi_bid,
  axi_bresp,
  axi_buser,
  axi_bready,

  // axi status

  axi_dwovf,
  axi_dwunf,
  axi_werror);

  // parameters

  parameter   DATA_WIDTH = 32;
  parameter   AXI_SIZE = 2;
  parameter   AXI_LENGTH = 16;
  parameter   AXI_ADDRESS = 32'h00000000;
  parameter   AXI_ADDRLIMIT = 32'h00000000;
  localparam  AXI_AWINCR = (AXI_LENGTH * DATA_WIDTH)/8;
  localparam  BUF_THRESHOLD_LO = 8'd6;
  localparam  BUF_THRESHOLD_HI = 8'd250;

  // request and synchronization

  input                           axi_xfer_req;
  output                          axi_rd_req;
  output  [ 31:0]                 axi_rd_addr;

  // fifo interface

  input                           m_rst;
  input                           m_clk;
  input                           m_wr;
  input   [DATA_WIDTH-1:0]        m_wdata;

  // axi interface

  input                           axi_clk;
  input                           axi_resetn;
  output                          axi_awvalid;
  output  [  3:0]                 axi_awid;
  output  [  1:0]                 axi_awburst;
  output                          axi_awlock;
  output  [  3:0]                 axi_awcache;
  output  [  2:0]                 axi_awprot;
  output  [  3:0]                 axi_awqos;
  output  [  3:0]                 axi_awuser;
  output  [  7:0]                 axi_awlen;
  output  [  2:0]                 axi_awsize;
  output  [ 31:0]                 axi_awaddr;
  input                           axi_awready;
  output                          axi_wvalid;
  output  [DATA_WIDTH-1:0]        axi_wdata;
  output  [(DATA_WIDTH/8)-1:0]    axi_wstrb;
  output                          axi_wlast;
  output  [  3:0]                 axi_wuser;
  input                           axi_wready;
  input                           axi_bvalid;
  input   [  3:0]                 axi_bid;
  input   [  1:0]                 axi_bresp;
  input   [  3:0]                 axi_buser;
  output                          axi_bready;

  // axi status

  output                          axi_dwovf;
  output                          axi_dwunf;
  output                          axi_werror;

  // internal registers

  reg     [  2:0]                 m_xfer_req_m = 'd0;
  reg                             m_xfer_init = 'd0;
  reg                             m_xfer_limit = 'd0;
  reg                             m_xfer_enable = 'd0;
  reg     [ 31:0]                 m_xfer_addr = 'd0;
  reg     [  7:0]                 m_waddr = 'd0;
  reg     [  7:0]                 m_waddr_g = 'd0;
  reg                             m_rel_enable = 'd0;
  reg                             m_rel_toggle = 'd0;
  reg     [  7:0]                 m_rel_waddr = 'd0;
  reg     [  2:0]                 axi_rel_toggle_m = 'd0;
  reg     [  7:0]                 axi_rel_waddr = 'd0;
  reg     [  7:0]                 axi_waddr_m1 = 'd0;
  reg     [  7:0]                 axi_waddr_m2 = 'd0;
  reg     [  7:0]                 axi_waddr = 'd0;
  reg     [  7:0]                 axi_addr_diff = 'd0;
  reg                             axi_almost_full = 'd0;
  reg                             axi_dwunf = 'd0;
  reg                             axi_almost_empty = 'd0;
  reg                             axi_dwovf = 'd0;
  reg     [  2:0]                 axi_xfer_req_m = 'd0;
  reg                             axi_xfer_init = 'd0;
  reg     [  7:0]                 axi_raddr = 'd0;
  reg                             axi_rd = 'd0;
  reg                             axi_rlast = 'd0;
  reg                             axi_rd_d = 'd0;
  reg                             axi_rlast_d = 'd0;
  reg     [DATA_WIDTH-1:0]        axi_rdata_d = 'd0;
  reg                             axi_rd_req = 'd0;
  reg     [ 31:0]                 axi_rd_addr = 'd0;
  reg                             axi_awvalid = 'd0;
  reg     [ 31:0]                 axi_awaddr = 'd0;
  reg                             axi_werror = 'd0;
  reg                             axi_reset = 'd0;

  // internal signals

  wire                            axi_rel_toggle_s;
  wire    [  8:0]                 axi_addr_diff_s;
  wire                            axi_wready_s;
  wire                            axi_rd_s;
  wire                            axi_req_s;
  wire                            axi_rlast_s;
  wire    [DATA_WIDTH-1:0]        axi_rdata_s;

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

  // fifo interface

  always @(posedge m_clk) begin
    if (m_rst == 1'b1) begin
      m_waddr <= 'd0;
      m_waddr_g <= 'd0;
      m_xfer_req_m <= 'd0;
      m_xfer_init <= 'd0;
      m_xfer_limit <= 'd0;
      m_xfer_enable <= 'd0;
      m_xfer_addr <= 'd0;
      m_rel_enable <= 'd0;
      m_rel_toggle <= 'd0;
      m_rel_waddr <= 'd0;
    end else begin
      if ((m_wr == 1'b1) && (m_xfer_enable == 1'b1)) begin
        m_waddr <= m_waddr + 1'b1;
      end
      m_waddr_g <= b2g(m_waddr);
      m_xfer_req_m <= {m_xfer_req_m[1:0], axi_xfer_req};
      m_xfer_init <= m_xfer_req_m[1] & ~m_xfer_req_m[2];
      if (m_xfer_init == 1'b1) begin
        m_xfer_limit <= 1'd1;
      end else if (m_xfer_addr >= AXI_ADDRLIMIT) begin
        m_xfer_limit <= 1'd0;
      end
      if (m_xfer_init == 1'b1) begin
        m_xfer_enable <= 1'b1;
        m_xfer_addr <= AXI_ADDRESS;
      end else if ((m_waddr[1:0] == 2'h3) && (m_wr == 1'b1)) begin
        m_xfer_enable <= m_xfer_req_m[2] & m_xfer_limit;
        m_xfer_addr <= m_xfer_addr + AXI_AWINCR;
      end
      if (m_waddr[1:0] == 2'h3) begin
        m_rel_enable <= m_wr;
      end else begin
        m_rel_enable <= 1'd0;
      end
      if (m_rel_enable == 1'b1) begin
        m_rel_toggle <= ~m_rel_toggle;
        m_rel_waddr <= m_waddr;
      end
    end
  end

  // fifo signals on axi side

  assign axi_rel_toggle_s = axi_rel_toggle_m[2] ^ axi_rel_toggle_m[1];

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_rel_toggle_m <= 'd0;
      axi_rel_waddr <= 'd0;
      axi_waddr_m1 <= 'd0;
      axi_waddr_m2 <= 'd0;
      axi_waddr <= 'd0;
    end else begin
      axi_rel_toggle_m <= {axi_rel_toggle_m[1:0], m_rel_toggle};
      if (axi_rel_toggle_s == 1'b1) begin
        axi_rel_waddr <= m_rel_waddr;
      end
      axi_waddr_m1 <= m_waddr_g;
      axi_waddr_m2 <= axi_waddr_m1;
      axi_waddr <= g2b(axi_waddr_m2);
    end
  end

  // overflow (no underflow possible)

  assign axi_addr_diff_s = {1'b1, axi_waddr} - axi_raddr;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_addr_diff <= 'd0;
      axi_almost_full <= 'd0;
      axi_dwunf <= 'd0;
      axi_almost_empty <= 'd0;
      axi_dwovf <= 'd0;
    end else begin
      axi_addr_diff <= axi_addr_diff_s[7:0];
      if (axi_addr_diff > BUF_THRESHOLD_HI) begin
        axi_almost_full <= 1'b1;
        axi_dwunf <= axi_almost_empty;
      end else begin
        axi_almost_full <= 1'b0;
        axi_dwunf <= 1'b0;
      end
      if (axi_addr_diff < BUF_THRESHOLD_LO) begin
        axi_almost_empty <= 1'b1;
        axi_dwovf <= axi_almost_full;
      end else begin
        axi_almost_empty <= 1'b0;
        axi_dwovf <= 1'b0;
      end
    end
  end

  // transfer request is required to keep things in sync

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_xfer_req_m <= 'd0;
      axi_xfer_init <= 'd0;
    end else begin
      axi_xfer_req_m <= {axi_xfer_req_m[1:0], axi_xfer_req};
      axi_xfer_init <= axi_xfer_req_m[1] & ~axi_xfer_req_m[2];
    end
  end

  // read is initiated if xfer enabled

  assign axi_wready_s = ~axi_wvalid | axi_wready;
  assign axi_rd_s = (axi_rel_waddr == axi_raddr) ? 1'b0 : axi_wready_s;
  assign axi_req_s = (axi_raddr[1:0] == 2'h0) ? axi_rd_s : 1'b0;
  assign axi_rlast_s = (axi_raddr[1:0] == 2'h3) ? axi_rd_s : 1'b0;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_raddr <= 'd0;
      axi_rd <= 'd0;
      axi_rlast <= 'd0;
      axi_rd_d <= 'd0;
      axi_rlast_d <= 'd0;
      axi_rdata_d <= 'd0;
    end else begin
      if (axi_rd_s == 1'b1) begin
        axi_raddr <= axi_raddr + 1'b1;
      end
      axi_rd <= axi_rd_s;
      axi_rlast <= axi_rlast_s;
      axi_rd_d <= axi_rd;
      axi_rlast_d <= axi_rlast;
      axi_rdata_d <= axi_rdata_s;
    end
  end

  // send read request for every burst about to be completed

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_rd_req <= 'd0;
      axi_rd_addr <= 'd0;
    end else begin
      axi_rd_req <= axi_rlast_s;
      if (axi_xfer_init == 1'b1) begin
        axi_rd_addr <= AXI_ADDRESS;
      end else if (axi_rd_req == 1'b1) begin
        axi_rd_addr <= axi_rd_addr + AXI_AWINCR;
      end
    end
  end

  // address channel

  assign axi_awid = 4'b0000;
  assign axi_awburst = 2'b01;
  assign axi_awlock = 1'b0;
  assign axi_awcache = 4'b0010;
  assign axi_awprot = 3'b000;
  assign axi_awqos = 4'b0000;
  assign axi_awuser = 4'b0001;
  assign axi_awlen = AXI_LENGTH - 1;
  assign axi_awsize = AXI_SIZE;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_awvalid <= 'd0;
      axi_awaddr <= 'd0;
    end else begin
      if (axi_awvalid == 1'b1) begin
        if (axi_awready == 1'b1) begin
          axi_awvalid <= 1'b0;
        end
      end else begin
        if (axi_req_s == 1'b1) begin
          axi_awvalid <= 1'b1;
        end
      end
      if (axi_xfer_init == 1'b1) begin
        axi_awaddr <= AXI_ADDRESS;
      end else if ((axi_awvalid == 1'b1) && (axi_awready == 1'b1)) begin
        axi_awaddr <= axi_awaddr + AXI_AWINCR;
      end
    end
  end

  // write channel
  
  assign axi_wstrb = {(DATA_WIDTH/8){1'b1}};
  assign axi_wuser = 4'b0000;

  // response channel

  assign axi_bready = 1'b1;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_werror <= 'd0;
    end else begin
      axi_werror <= axi_bvalid & axi_bready & axi_bresp[1];
    end
  end

  // fifo needs a reset

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_reset <= 1'b1;
    end else begin
      axi_reset <= 1'b0;
    end
  end

  // interface handler

  ad_axis_inf_rx #(.DATA_WIDTH(DATA_WIDTH)) i_axis_inf (
    .clk (axi_clk),
    .rst (axi_reset),
    .valid (axi_rd_d),
    .last (axi_rlast_d),
    .data (axi_rdata_d),
    .inf_valid (axi_wvalid),
    .inf_last (axi_wlast),
    .inf_data (axi_wdata),
    .inf_ready (axi_wready));

  // buffer

  ad_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(8)) i_mem (
    .clka (m_clk),
    .wea (m_wr),
    .addra (m_waddr),
    .dina (m_wdata),
    .clkb (axi_clk),
    .addrb (axi_raddr),
    .doutb (axi_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
