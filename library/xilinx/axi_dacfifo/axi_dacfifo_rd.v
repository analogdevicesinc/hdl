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

module axi_dacfifo_rd (

 // xfer last for read/write synchronization

  axi_xfer_req,
  axi_last_raddr,
  axi_last_beats,

  // axi read address and read data channels

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

  // axi status

  axi_rerror,

  // fifo interface

  axi_dvalid,
  axi_ddata,
  axi_dready,
  axi_dlast);

  // parameters

  parameter   AXI_DATA_WIDTH = 512;
  parameter   AXI_SIZE = 2;
  parameter   AXI_LENGTH = 15;
  parameter   AXI_ADDRESS = 32'h00000000;
  localparam  AXI_BYTE_WIDTH = AXI_DATA_WIDTH/8;
  localparam  AXI_AWINCR = (AXI_LENGTH + 1) * AXI_BYTE_WIDTH;

  // xfer last for read/write synchronization

  input                           axi_xfer_req;
  input   [31:0]                 axi_last_raddr;
  input   [ 3:0]                 axi_last_beats;

  // axi interface

  input                           axi_clk;
  input                           axi_resetn;
  output                          axi_arvalid;
  output  [ 3:0]                  axi_arid;
  output  [ 1:0]                  axi_arburst;
  output                          axi_arlock;
  output  [ 3:0]                  axi_arcache;
  output  [ 2:0]                  axi_arprot;
  output  [ 3:0]                  axi_arqos;
  output  [ 3:0]                  axi_aruser;
  output  [ 7:0]                  axi_arlen;
  output  [ 2:0]                  axi_arsize;
  output  [31:0]                  axi_araddr;
  input                           axi_arready;
  input                           axi_rvalid;
  input   [ 3:0]                  axi_rid;
  input   [ 3:0]                  axi_ruser;
  input   [ 1:0]                  axi_rresp;
  input                           axi_rlast;
  input   [(AXI_DATA_WIDTH-1):0]  axi_rdata;
  output                          axi_rready;

  // axi status

  output                          axi_rerror;

  // fifo interface

  output                          axi_dvalid;
  output  [(AXI_DATA_WIDTH-1):0]  axi_ddata;
  input                           axi_dready;
  output                          axi_dlast;

  // internal registers

  reg                             axi_rnext = 1'b0;
  reg                             axi_ractive = 1'b0;
  reg                             axi_arvalid = 1'b0;
  reg     [ 31:0]                 axi_araddr = 32'b0;
  reg     [ 31:0]                 axi_araddr_prev = 32'b0;
  reg     [(AXI_DATA_WIDTH-1):0]  axi_ddata = 'b0;
  reg                             axi_dvalid = 1'b0;
  reg                             axi_dlast = 1'b0;
  reg                             axi_rready = 1'b0;
  reg                             axi_rerror = 1'b0;
  reg     [ 1:0]                  axi_xfer_req_m = 2'b0;
  reg     [ 4:0]                  axi_last_beats_cntr = 16'b0;

  // internal signals

  wire                            axi_ready_s;
  wire                            axi_xfer_req_init;
  wire                            axi_dvalid_s;
  wire                            axi_dlast_s;
  wire    [ 4:0]                  axi_last_beats_s;

  assign axi_ready_s = (~axi_arvalid | axi_arready) & axi_dready;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_rnext <= 1'b0;
      axi_ractive <= 1'b0;
      axi_xfer_req_m <= 2'b0;
    end else begin
      if (axi_ractive == 1'b1) begin
        axi_rnext <= 1'b0;
        if ((axi_rvalid == 1'b1) && (axi_rlast == 1'b1)) begin
          axi_ractive <= 1'b0;
        end
      end else if ((axi_ready_s == 1'b1)) begin
        axi_rnext <= axi_xfer_req;
        axi_ractive <= axi_xfer_req;
      end
    axi_xfer_req_m <= {axi_xfer_req_m[0], axi_xfer_req};
    end
  end

  assign axi_xfer_req_init = axi_xfer_req_m[0] & ~axi_xfer_req_m[1];

  always @(posedge axi_clk) begin
    if ((axi_resetn == 1'b0) || (axi_xfer_req == 1'b0)) begin
      axi_last_beats_cntr <= 0;
    end else begin
      if ((axi_rready == 1'b1) && (axi_rvalid == 1'b1)) begin
        axi_last_beats_cntr <= (axi_rlast == 1'b1) ? 0 : axi_last_beats_cntr +  1;
      end
    end
  end

  // address channel

  assign axi_arid = 4'b0000;
  assign axi_arburst = 2'b01;
  assign axi_arlock = 1'b0;
  assign axi_arcache = 4'b0010;
  assign axi_arprot = 3'b000;
  assign axi_arqos = 4'b0000;
  assign axi_aruser = 4'b0001;
  assign axi_arlen = AXI_LENGTH;
  assign axi_arsize = AXI_SIZE;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_arvalid <= 'd0;
      axi_araddr <= AXI_ADDRESS;
      axi_araddr_prev <= AXI_ADDRESS;
    end else begin
      if (axi_arvalid == 1'b1) begin
        if (axi_arready == 1'b1) begin
          axi_arvalid <= 1'b0;
        end
      end else begin
        if (axi_rnext == 1'b1) begin
          axi_arvalid <= 1'b1;
        end
      end
      if ((axi_xfer_req == 1'b1) &&
          (axi_arvalid == 1'b1) &&
          (axi_arready == 1'b1)) begin
        axi_araddr <= (axi_araddr >= axi_last_raddr) ? AXI_ADDRESS : axi_araddr + AXI_AWINCR;
        axi_araddr_prev <= axi_araddr;
      end
    end
  end

  // read data channel

  assign axi_last_beats_s = {1'b0, axi_last_beats} - 1;
  assign axi_dvalid_s = ((axi_last_beats_cntr > axi_last_beats_s) && (axi_araddr_prev == axi_last_raddr)) ? 0 : axi_rvalid & axi_rready;
  assign axi_dlast_s = (axi_araddr_prev == axi_last_raddr) ? 1 : 0;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_ddata <= 'd0;
      axi_rready <= 1'b0;
      axi_dvalid <= 1'b0;
    end else begin
      axi_ddata <= axi_rdata;
      axi_dvalid <= axi_dvalid_s;
      axi_dlast <= axi_dlast_s;
      if (axi_xfer_req == 1'b1) begin
        axi_rready <= axi_rvalid;
      end
    end
  end

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_rerror <= 'd0;
    end else begin
      axi_rerror <= axi_rvalid & axi_rresp[1];
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************

