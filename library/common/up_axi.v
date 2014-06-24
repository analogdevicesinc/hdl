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

module up_axi (

  // reset and clocks

  up_rstn,
  up_clk,

  // axi4 interface

  up_axi_awvalid,
  up_axi_awaddr,
  up_axi_awready,
  up_axi_wvalid,
  up_axi_wdata,
  up_axi_wstrb,
  up_axi_wready,
  up_axi_bvalid,
  up_axi_bresp,
  up_axi_bready,
  up_axi_arvalid,
  up_axi_araddr,
  up_axi_arready,
  up_axi_rvalid,
  up_axi_rresp,
  up_axi_rdata,
  up_axi_rready,

  // pcore interface

  up_sel,
  up_wr,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack);

  // parameters

  parameter   PCORE_BASEADDR = 32'hffffffff;
  parameter   PCORE_HIGHADDR = 32'h00000000;

  // reset and clocks

  input           up_rstn;
  input           up_clk;

  // axi4 interface

  input           up_axi_awvalid;
  input   [31:0]  up_axi_awaddr;
  output          up_axi_awready;
  input           up_axi_wvalid;
  input   [31:0]  up_axi_wdata;
  input   [ 3:0]  up_axi_wstrb;
  output          up_axi_wready;
  output          up_axi_bvalid;
  output  [ 1:0]  up_axi_bresp;
  input           up_axi_bready;
  input           up_axi_arvalid;
  input   [31:0]  up_axi_araddr;
  output          up_axi_arready;
  output          up_axi_rvalid;
  output  [ 1:0]  up_axi_rresp;
  output  [31:0]  up_axi_rdata;
  input           up_axi_rready;

  // pcore interface

  output          up_sel;
  output          up_wr;
  output  [13:0]  up_addr;
  output  [31:0]  up_wdata;
  input   [31:0]  up_rdata;
  input           up_ack;

  // internal registers

  reg             up_axi_awready = 'd0;
  reg             up_axi_wready = 'd0;
  reg             up_axi_arready = 'd0;
  reg             up_axi_bvalid = 'd0;
  reg             up_axi_rvalid = 'd0;
  reg     [31:0]  up_axi_rdata = 'd0;
  reg             up_axi_access = 'd0;
  reg             up_sel = 'd0;
  reg             up_wr = 'd0;
  reg     [13:0]  up_addr = 'd0;
  reg     [31:0]  up_wdata = 'd0;
  reg             up_access = 'd0;
  reg     [ 2:0]  up_access_count = 'd0;
  reg             up_access_ack = 'd0;
  reg     [31:0]  up_access_rdata = 'd0;

  // internal wires

  wire            up_axi_wr_s;
  wire            up_axi_rd_s;
  wire    [31:0]  up_rdata_s;
  wire            up_ack_s;

  // responses are always okay

  assign up_axi_bresp = 2'd0;
  assign up_axi_rresp = 2'd0;

  // wait for awvalid and wvalid before asserting awready and wready

  assign up_axi_wr_s = ((up_axi_awaddr >= PCORE_BASEADDR) && (up_axi_awaddr <= PCORE_HIGHADDR)) ?
    (up_axi_awvalid & up_axi_wvalid & ~up_axi_access) : 1'b0;

  assign up_axi_rd_s = ((up_axi_araddr >= PCORE_BASEADDR) && (up_axi_araddr <= PCORE_HIGHADDR)) ?
    (up_axi_arvalid & ~up_axi_access) : 1'b0;

  // return address and data channel ready right away, response depends on ack
 
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_axi_awready <= 'd0;
      up_axi_wready <= 'd0;
      up_axi_arready <= 'd0;
      up_axi_bvalid <= 'd0;
      up_axi_rvalid <= 'd0;
      up_axi_rdata <= 'd0;
    end else begin
      if ((up_axi_awready == 1'b1) && (up_axi_awvalid == 1'b1)) begin
        up_axi_awready <= 1'b0;
      end else if (up_axi_wr_s == 1'b1) begin
        up_axi_awready <= 1'b1;
      end
      if ((up_axi_wready == 1'b1) && (up_axi_wvalid == 1'b1)) begin
        up_axi_wready <= 1'b0;
      end else if (up_axi_wr_s == 1'b1) begin
        up_axi_wready <= 1'b1;
      end
      if ((up_axi_arready == 1'b1) && (up_axi_arvalid == 1'b1)) begin
        up_axi_arready <= 1'b0;
      end else if (up_axi_rd_s == 1'b1) begin
        up_axi_arready <= 1'b1;
      end
      if ((up_axi_bready == 1'b1) && (up_axi_bvalid == 1'b1)) begin
        up_axi_bvalid <= 1'b0;
      end else if ((up_axi_access == 1'b1) && (up_ack_s == 1'b1) && (up_wr == 1'b1)) begin
        up_axi_bvalid <= 1'b1;
      end
      if ((up_axi_rready == 1'b1) && (up_axi_rvalid == 1'b1)) begin
        up_axi_rvalid <= 1'b0;
        up_axi_rdata <= 32'd0;
      end else if ((up_axi_access == 1'b1) && (up_ack_s == 1'b1) && (up_wr == 1'b0)) begin
        up_axi_rvalid <= 1'b1;
        up_axi_rdata <= up_rdata_s;
      end
    end
  end       

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_axi_access <= 'd0;
      up_sel <= 'd0;
      up_wr <= 'd0;
      up_addr <= 'd0;
      up_wdata <= 'd0;
    end else begin
      if (up_axi_access == 1'b1) begin
        if (up_ack_s == 1'b1) begin
          up_axi_access <= 1'b0;
        end
        up_sel <= 1'b0;
      end else begin
        up_axi_access <= up_axi_wr_s | up_axi_rd_s;
        up_sel <= up_axi_wr_s | up_axi_rd_s;
      end
      if (up_axi_access == 1'b0) begin
        up_wr <= up_axi_wr_s;
        if (up_axi_wr_s == 1'b1) begin
          up_addr <= up_axi_awaddr[15:2];
          up_wdata <= up_axi_wdata;
        end else begin
          up_addr <= up_axi_araddr[15:2];
          up_wdata <= 32'd0;
        end
      end
    end
  end

  // combine up read and ack from all the blocks

  assign up_rdata_s = up_rdata | up_access_rdata;
  assign up_ack_s = up_ack | up_access_ack;

  // 8 clock cycles access time out to release bus

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_access <= 'd0;
      up_access_count <= 'd0;
      up_access_ack <= 'd0;
      up_access_rdata <= 'd0;
    end else begin
      if (up_sel == 1'b1) begin
        up_access <= 1'b1;
      end else if (up_ack_s == 1'b1) begin
        up_access <= 1'b0;
      end
      if (up_access == 1'b1) begin
        up_access_count <= up_access_count + 1'b1;
      end else begin
        up_access_count <= 3'd0;
      end
      if ((up_access_count == 3'h7) && (up_ack_s == 1'b0)) begin
        up_access_ack <= 1'b1;
        up_access_rdata <= {2{16'hdead}};
      end else begin
        up_access_ack <= 1'b0;
        up_access_rdata <= 32'd0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
