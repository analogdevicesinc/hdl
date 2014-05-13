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

module axi_fifo2s_rd (

  // request and synchronization

  axi_xfer_req,
  axi_rd_req,
  axi_rd_addr,
  axi_rd_status,

  // axi interface

  axi_clk,
  axi_resetn,
  axi_arvalid,
  axi_arid,
  axi_arburst,
  axi_arlock,
  axi_arcache,
  axi_arprot,
  axi_arqos,
  axi_aruser,
  axi_arlen,
  axi_arsize,
  axi_araddr,
  axi_arready,
  axi_rvalid,
  axi_rid,
  axi_ruser,
  axi_rresp,
  axi_rlast,
  axi_rdata,
  axi_rready,

  // fifo interface

  axi_mwr,
  axi_mwdata,
  axi_mwovf,
  axi_mwpfull);

  // parameters

  parameter   DATA_WIDTH = 32;
  parameter   AXI_SIZE = 2;
  parameter   AXI_LENGTH = 16;
  localparam  BUF_THRESHOLD_LO = 6'd3;
  localparam  BUF_THRESHOLD_HI = 6'd60;

  // request and synchronization

  input                           axi_xfer_req;
  input                           axi_rd_req;
  input   [ 31:0]                 axi_rd_addr;
  output                          axi_rd_status;

  // axi interface

  input                           axi_clk;
  input                           axi_resetn;
  output                          axi_arvalid;
  output  [  3:0]                 axi_arid;
  output  [  1:0]                 axi_arburst;
  output                          axi_arlock;
  output  [  3:0]                 axi_arcache;
  output  [  2:0]                 axi_arprot;
  output  [  3:0]                 axi_arqos;
  output  [  3:0]                 axi_aruser;
  output  [  7:0]                 axi_arlen;
  output  [  2:0]                 axi_arsize;
  output  [ 31:0]                 axi_araddr;
  input                           axi_arready;
  input                           axi_rvalid;
  input   [  3:0]                 axi_rid;
  input   [  3:0]                 axi_ruser;
  input   [  1:0]                 axi_rresp;
  input                           axi_rlast;
  input   [DATA_WIDTH-1:0]        axi_rdata;
  output                          axi_rready;

  // fifo interface

  output                          axi_mwr;
  output  [DATA_WIDTH-1:0]        axi_mwdata;
  input                           axi_mwovf;
  input                           axi_mwpfull;

  // internal registers

  reg     [  5:0]                 axi_waddr = 'd0;
  reg     [  5:0]                 axi_raddr = 'd0;
  reg                             axi_rd = 'd0;
  reg                             axi_rd_d = 'd0;
  reg     [ 31:0]                 axi_rdata_d = 'd0;
  reg     [  5:0]                 axi_addr_diff = 'd0;
  reg                             axi_almost_full = 'd0;
  reg                             axi_unf = 'd0;
  reg                             axi_almost_empty = 'd0;
  reg                             axi_ovf = 'd0;
  reg                             axi_arerror = 'd0;
  reg                             axi_arvalid = 'd0;
  reg     [ 31:0]                 axi_araddr = 'd0;
  reg                             axi_mwr = 'd0;
  reg     [DATA_WIDTH-1:0]        axi_mwdata = 'd0;
  reg                             axi_rready = 'd0;
  reg                             axi_rerror = 'd0;
  reg                             axi_reset = 'd0;
  reg                             axi_rd_status = 'd0;

  // internal signals

  wire                            axi_wr_s;
  wire    [ 31:0]                 axi_wdata_s;
  wire                            axi_arready_s;
  wire                            axi_fifo_ready_s;
  wire                            axi_rd_s;
  wire    [  6:0]                 axi_addr_diff_s;
  wire    [ 31:0]                 axi_rdata_s;

  // queue requests

  assign axi_wr_s = axi_rd_req;
  assign axi_wdata_s = axi_rd_addr;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_waddr <= 'd0;
    end else begin
      if (axi_wr_s == 1'b1) begin
        axi_waddr <= axi_waddr + 1'b1;
      end
    end
  end

  // read queue

  assign axi_arready_s = ~axi_arvalid | axi_arready;
  assign axi_fifo_ready_s = ~axi_xfer_req | ~axi_mwpfull;
  assign axi_rd_s = (axi_waddr == axi_raddr) ? 1'b0 : (axi_arready_s & axi_fifo_ready_s);

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_raddr <= 'd0;
      axi_rd <= 'd0;
      axi_rd_d <= 'd0;
      axi_rdata_d <= 'd0;
    end else begin
      if (axi_rd_s == 1'b1) begin
        axi_raddr <= axi_raddr + 1'b1;
      end
      axi_rd <= axi_rd_s;
      axi_rd_d <= axi_rd;
      axi_rdata_d <= axi_rdata_s;
    end
  end

  // overflow (no underflow possible)

  assign axi_addr_diff_s = {1'b1, axi_waddr} - axi_raddr;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_addr_diff <= 'd0;
      axi_almost_full <= 'd0;
      axi_unf <= 'd0;
      axi_almost_empty <= 'd0;
      axi_ovf <= 'd0;
    end else begin
      axi_addr_diff <= axi_addr_diff_s[5:0];
      if (axi_addr_diff > BUF_THRESHOLD_HI) begin
        axi_almost_full <= 1'b1;
        axi_unf <= axi_almost_empty;
      end else begin
        axi_almost_full <= 1'b0;
        axi_unf <= 1'b0;
      end
      if (axi_addr_diff < BUF_THRESHOLD_LO) begin
        axi_almost_empty <= 1'b1;
        axi_ovf <= axi_almost_full;
      end else begin
        axi_almost_empty <= 1'b0;
        axi_ovf <= 1'b0;
      end
    end
  end

  // address channel

  assign axi_arid  = 4'b0000;
  assign axi_arburst  = 2'b01;
  assign axi_arlock  = 1'b0;
  assign axi_arcache  = 4'b0010;
  assign axi_arprot  = 3'b000;
  assign axi_arqos  = 4'b0000;
  assign axi_aruser  = 4'b0001;
  assign axi_arlen  = AXI_LENGTH - 1;
  assign axi_arsize  = AXI_SIZE;

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_arerror <= 'd0;
      axi_arvalid <= 'd0;
      axi_araddr <= 'd0;
    end else begin
      axi_arerror <= axi_rd_d & axi_arvalid;
      if (axi_arvalid == 1'b1) begin
        if (axi_arready == 1'b1) begin
          axi_arvalid <= 1'b0;
        end
      end else begin
        if (axi_rd_d == 1'b1) begin
          axi_arvalid <= 1'b1;
        end
      end
      if ((axi_rd_d == 1'b1) && (axi_arvalid == 1'b0)) begin
        axi_araddr <= axi_rdata_d;
      end
    end
  end

  // read data channel

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_mwr <= 'd0;
      axi_mwdata <= 'd0;
      axi_rready <= 'd0;
    end else begin
      axi_mwr <= axi_rvalid & axi_rready;
      axi_mwdata <= axi_rdata;
      axi_rready <= axi_fifo_ready_s;
    end
  end

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_rerror <= 'd0;
    end else begin
      axi_rerror <= axi_rvalid & axi_rready & axi_rresp[1];
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

  // combined status

  always @(posedge axi_clk or negedge axi_resetn) begin
    if (axi_resetn == 1'b0) begin
      axi_rd_status <= 'd0;
    end else begin
      axi_rd_status <= axi_mwovf | axi_ovf | axi_unf | axi_arerror | axi_rerror;
    end
  end

  // buffer

  ad_mem #(.DATA_WIDTH(32), .ADDR_WIDTH(6)) i_mem (
    .clka (axi_clk),
    .wea (axi_wr_s),
    .addra (axi_waddr),
    .dina (axi_wdata_s),
    .clkb (axi_clk),
    .addrb (axi_raddr),
    .doutb (axi_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
