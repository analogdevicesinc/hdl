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

module axi_dev (

  // external interface

  axil_aclk,
  axil_aresetn,
  axil_awvalid,
  axil_awaddr,
  axil_awready,
  axil_wvalid,
  axil_wdata,
  axil_wstrb,
  axil_wready,
  axil_bvalid,
  axil_bresp,
  axil_bready,
  axil_arvalid,
  axil_araddr,
  axil_arready,
  axil_rvalid,
  axil_rdata,
  axil_rresp,
  axil_rready,

  // axi interface

  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rdata,
  s_axi_rresp,
  s_axi_rready);

  // parameters

  parameter   C_S_AXI_MIN_SIZE = 32'hffff;
  parameter   C_BASEADDR = 32'hffffffff;
  parameter   C_HIGHADDR = 32'h00000000;

  // external interface

  output          axil_aclk;
  output          axil_aresetn;
  output          axil_awvalid;
  output  [31:0]  axil_awaddr;
  input           axil_awready;
  output          axil_wvalid;
  output  [31:0]  axil_wdata;
  output  [ 3:0]  axil_wstrb;
  input           axil_wready;
  input           axil_bvalid;
  input   [ 1:0]  axil_bresp;
  output          axil_bready;
  output          axil_arvalid;
  output  [31:0]  axil_araddr;
  input           axil_arready;
  input           axil_rvalid;
  input   [31:0]  axil_rdata;
  input   [ 1:0]  axil_rresp;
  output          axil_rready;

  // axi interface

  input           s_axi_aclk;
  input           s_axi_aresetn;
  input           s_axi_awvalid;
  input   [31:0]  s_axi_awaddr;
  output          s_axi_awready;
  input           s_axi_wvalid;
  input   [31:0]  s_axi_wdata;
  input   [ 3:0]  s_axi_wstrb;
  output          s_axi_wready;
  output          s_axi_bvalid;
  output  [ 1:0]  s_axi_bresp;
  input           s_axi_bready;
  input           s_axi_arvalid;
  input   [31:0]  s_axi_araddr;
  output          s_axi_arready;
  output          s_axi_rvalid;
  output  [31:0]  s_axi_rdata;
  output  [ 1:0]  s_axi_rresp;
  input           s_axi_rready;

  // assignments

  assign axil_aclk = s_axi_aclk;
  assign axil_aresetn = s_axi_aresetn;
  assign axil_awvalid = s_axi_awvalid;
  assign axil_awaddr = s_axi_awaddr;
  assign axil_wvalid = s_axi_wvalid;
  assign axil_wdata = s_axi_wdata;
  assign axil_wstrb = s_axi_wstrb;
  assign axil_bready = s_axi_bready;
  assign axil_arvalid = s_axi_arvalid;
  assign axil_araddr = s_axi_araddr;
  assign axil_rready = s_axi_rready;

  assign s_axi_awready = axil_awready;
  assign s_axi_wready = axil_wready;
  assign s_axi_bvalid = axil_bvalid;
  assign s_axi_bresp = axil_bresp;
  assign s_axi_arready = axil_arready;
  assign s_axi_rvalid = axil_rvalid;
  assign s_axi_rdata = axil_rdata;
  assign s_axi_rresp = axil_rresp;

endmodule

// ***************************************************************************
// ***************************************************************************
