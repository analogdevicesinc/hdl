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

  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack);

  // parameters

  parameter   PCORE_ADDR_WIDTH = 14;
  localparam  AW = PCORE_ADDR_WIDTH - 1;

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

  output          up_wreq;
  output  [AW:0]  up_waddr;
  output  [31:0]  up_wdata;
  input           up_wack;
  output          up_rreq;
  output  [AW:0]  up_raddr;
  input   [31:0]  up_rdata;
  input           up_rack;

  // internal registers

  reg             up_axi_awready = 'd0;
  reg             up_axi_wready = 'd0;
  reg             up_axi_bvalid = 'd0;
  reg             up_wsel = 'd0;
  reg             up_wreq = 'd0;
  reg     [AW:0]  up_waddr = 'd0;
  reg     [31:0]  up_wdata = 'd0;
  reg     [ 2:0]  up_wcount = 'd0;
  reg             up_wack_int = 'd0;
  reg             up_axi_arready = 'd0;
  reg             up_axi_rvalid = 'd0;
  reg     [31:0]  up_axi_rdata = 'd0;
  reg             up_rsel = 'd0;
  reg             up_rreq = 'd0;
  reg     [AW:0]  up_raddr = 'd0;
  reg     [ 3:0]  up_rcount = 'd0;
  reg             up_rack_int = 'd0;
  reg     [31:0]  up_rdata_int = 'd0;
  reg             up_rack_int_d = 'd0;
  reg     [31:0]  up_rdata_int_d = 'd0;

  // write channel interface
 
  assign up_axi_bresp = 2'd0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_axi_awready <= 'd0;
      up_axi_wready <= 'd0;
      up_axi_bvalid <= 'd0;
    end else begin
      if (up_axi_awready == 1'b1) begin
        up_axi_awready <= 1'b0;
      end else if (up_wack_int == 1'b1) begin
        up_axi_awready <= 1'b1;
      end
      if (up_axi_wready == 1'b1) begin
        up_axi_wready <= 1'b0;
      end else if (up_wack_int == 1'b1) begin
        up_axi_wready <= 1'b1;
      end
      if ((up_axi_bready == 1'b1) && (up_axi_bvalid == 1'b1)) begin
        up_axi_bvalid <= 1'b0;
      end else if (up_wack_int == 1'b1) begin
        up_axi_bvalid <= 1'b1;
      end
    end
  end       

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wsel <= 'd0;
      up_wreq <= 'd0;
      up_waddr <= 'd0;
      up_wdata <= 'd0;
      up_wcount <= 'd0;
    end else begin
      if (up_wsel == 1'b1) begin
        if ((up_axi_bready == 1'b1) && (up_axi_bvalid == 1'b1)) begin
          up_wsel <= 1'b0;
        end
        up_wreq <= 1'b0;
        up_waddr <= up_waddr;
        up_wdata <= up_wdata;
        up_wcount <= up_wcount + 1'b1;
      end else begin
        up_wsel <= up_axi_awvalid & up_axi_wvalid;
        up_wreq <= up_axi_awvalid & up_axi_wvalid;
        up_waddr <= up_axi_awaddr[AW+2:2];
        up_wdata <= up_axi_wdata;
        up_wcount <= 3'd0;
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack_int <= 'd0;
    end else begin
      if ((up_wcount == 3'h7) && (up_wack == 1'b0)) begin
        up_wack_int <= 1'b1;
      end else if (up_wsel == 1'b1) begin
        up_wack_int <= up_wack;
      end
    end
  end

  // read channel interface

  assign up_axi_rresp = 2'd0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_axi_arready <= 'd0;
      up_axi_rvalid <= 'd0;
      up_axi_rdata <= 'd0;
    end else begin
      if (up_axi_arready == 1'b1) begin
        up_axi_arready <= 1'b0;
      end else if (up_rack_int == 1'b1) begin
        up_axi_arready <= 1'b1;
      end
      if ((up_axi_rready == 1'b1) && (up_axi_rvalid == 1'b1)) begin
        up_axi_rvalid <= 1'b0;
        up_axi_rdata <= 32'd0;
      end else if (up_rack_int_d == 1'b1) begin
        up_axi_rvalid <= 1'b1;
        up_axi_rdata <= up_rdata_int_d;
      end
    end
  end       

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rsel <= 'd0;
      up_rreq <= 'd0;
      up_raddr <= 'd0;
      up_rcount <= 'd0;
    end else begin
      if (up_rsel == 1'b1) begin
        if ((up_axi_rready == 1'b1) && (up_axi_rvalid == 1'b1)) begin
          up_rsel <= 1'b0;
        end
        up_rreq <= 1'b0;
        up_raddr <= up_raddr;
      end else begin
        up_rsel <= up_axi_arvalid;
        up_rreq <= up_axi_arvalid;
        up_raddr <= up_axi_araddr[AW+2:2];
      end
      if (up_rack_int == 1'b1) begin
        up_rcount <= 4'd0;
      end else if (up_rcount[3] == 1'b1) begin
        up_rcount <= up_rcount + 1'b1;
      end else if (up_rreq == 1'b1) begin
        up_rcount <= 4'd8;
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
      up_rack_int_d <= 'd0;
      up_rdata_int_d <= 'd0;
    end else begin
      if ((up_rcount == 4'hf) && (up_rack == 1'b0)) begin
        up_rack_int <= 1'b1;
        up_rdata_int <= {2{16'hdead}};
      end else begin
        up_rack_int <= up_rack;
        up_rdata_int <= up_rdata;
      end
      up_rack_int_d <= up_rack_int;
      up_rdata_int_d <= up_rdata_int;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
