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

`timescale 1ns/1ps

module axi_adxcvr #(

  // parameters

  parameter   integer ID = 0,
  parameter   integer TX_OR_RX_N = 0,
  parameter   integer NUM_OF_LANES = 4) (

  // xcvr, lane-pll and ref-pll are shared

  output                        up_rst,
  input                         up_pll_locked,
  input   [(NUM_OF_LANES-1):0]  up_ready,

  input                         s_axi_aclk,
  input                         s_axi_aresetn,
  input                         s_axi_awvalid,
  input   [31:0]                s_axi_awaddr,
  input   [ 2:0]                s_axi_awprot,
  output                        s_axi_awready,
  input                         s_axi_wvalid,
  input   [31:0]                s_axi_wdata,
  input   [ 3:0]                s_axi_wstrb,
  output                        s_axi_wready,
  output                        s_axi_bvalid,
  output  [ 1:0]                s_axi_bresp,
  input                         s_axi_bready,
  input                         s_axi_arvalid,
  input   [31:0]                s_axi_araddr,
  input   [ 2:0]                s_axi_arprot,
  output                        s_axi_arready,
  output                        s_axi_rvalid,
  output  [ 1:0]                s_axi_rresp,
  output  [31:0]                s_axi_rdata,
  input                         s_axi_rready);

  // internal signals

  wire                          up_rstn;
  wire                          up_clk;
  wire                          up_wreq;
  wire    [ 9:0]                up_waddr;
  wire    [31:0]                up_wdata;
  wire                          up_wack;
  wire                          up_rreq;
  wire    [ 9:0]                up_raddr;
  wire    [31:0]                up_rdata;
  wire                          up_rack;

  // clk & rst

  assign up_rstn = s_axi_aresetn;
  assign up_clk = s_axi_aclk;

  // instantiations

  axi_adxcvr_up #(
    .ID (ID),
    .TX_OR_RX_N (TX_OR_RX_N),
    .NUM_OF_LANES (NUM_OF_LANES))
  i_up (
    .up_rst (up_rst),
    .up_pll_locked (up_pll_locked),
    .up_ready (up_ready),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  up_axi #(.ADDRESS_WIDTH (10)) i_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************

