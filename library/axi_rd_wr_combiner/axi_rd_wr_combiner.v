// ***************************************************************************
// ***************************************************************************
// Copyright 2017(c) Analog Devices, Inc.
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

/*
 * Helper module to combine a read-only and a write-only AXI interface into a
 * single read-write AXI interface. Only supports AXI3 at the moment.
 */

module axi_rd_wr_combiner (
  input                         clk,

  // Master write address
  output [31:0]                 m_axi_awaddr,
  output [ 3:0]                 m_axi_awlen,
  output [ 2:0]                 m_axi_awsize,
  output [ 1:0]                 m_axi_awburst,
  output [ 2:0]                 m_axi_awprot,
  output [ 3:0]                 m_axi_awcache,
  output                        m_axi_awvalid,
  input                         m_axi_awready,

  // Master write data
  output [63:0]                 m_axi_wdata,
  output [ 7:0]                 m_axi_wstrb,
  input                         m_axi_wready,
  output                        m_axi_wvalid,
  output                        m_axi_wlast,

  // Master write response
  input                         m_axi_bvalid,
  input  [ 1:0]                 m_axi_bresp,
  output                        m_axi_bready,

  // Master read address
  output                        m_axi_arvalid,
  output [31:0]                 m_axi_araddr,
  output [ 3:0]                 m_axi_arlen,
  output [ 2:0]                 m_axi_arsize,
  output [ 1:0]                 m_axi_arburst,
  output [ 3:0]                 m_axi_arcache,
  output [ 2:0]                 m_axi_arprot,
  input                         m_axi_arready,

  // Master read response + data
  input                         m_axi_rvalid,
  input  [ 1:0]                 m_axi_rresp,
  input  [63:0]                 m_axi_rdata,
  output                        m_axi_rready,

  // Slave write address
  input [31:0]                  s_wr_axi_awaddr,
  input [ 3:0]                  s_wr_axi_awlen,
  input [ 2:0]                  s_wr_axi_awsize,
  input [ 1:0]                  s_wr_axi_awburst,
  input [ 2:0]                  s_wr_axi_awprot,
  input [ 3:0]                  s_wr_axi_awcache,
  input                         s_wr_axi_awvalid,
  output                        s_wr_axi_awready,

  // Salve write data
  input [63:0]                  s_wr_axi_wdata,
  input [ 7:0]                  s_wr_axi_wstrb,
  output                        s_wr_axi_wready,
  input                         s_wr_axi_wvalid,
  input                         s_wr_axi_wlast,

  // Slave write response
  output                        s_wr_axi_bvalid,
  output  [ 1:0]                s_wr_axi_bresp,
  input                         s_wr_axi_bready,

  // Slave read address
  input                         s_rd_axi_arvalid,
  input [31:0]                  s_rd_axi_araddr,
  input [ 3:0]                  s_rd_axi_arlen,
  input [ 2:0]                  s_rd_axi_arsize,
  input [ 1:0]                  s_rd_axi_arburst,
  input [ 3:0]                  s_rd_axi_arcache,
  input [ 2:0]                  s_rd_axi_arprot,
  output                        s_rd_axi_arready,

  // Slave read response + data
  output                        s_rd_axi_rvalid,
  output  [ 1:0]                s_rd_axi_rresp,
  output  [63:0]                s_rd_axi_rdata,
  input                         s_rd_axi_rready
);

assign m_axi_awaddr = s_wr_axi_awaddr;
assign m_axi_awlen = s_wr_axi_awlen;
assign m_axi_awsize = s_wr_axi_awsize;
assign m_axi_awburst = s_wr_axi_awburst;
assign m_axi_awprot = s_wr_axi_awprot;
assign m_axi_awcache = s_wr_axi_awcache;
assign m_axi_awvalid = s_wr_axi_awvalid;
assign s_wr_axi_awready = m_axi_awready;

assign m_axi_wdata = s_wr_axi_wdata;
assign m_axi_wstrb = s_wr_axi_wstrb;
assign s_wr_axi_wready = m_axi_wready;
assign m_axi_wvalid = s_wr_axi_wvalid;
assign m_axi_wlast = s_wr_axi_wlast;

assign s_wr_axi_bvalid = m_axi_bvalid;
assign s_wr_axi_bresp = m_axi_bresp;
assign m_axi_bready = s_wr_axi_bready;

assign m_axi_arvalid = s_rd_axi_arvalid;
assign m_axi_araddr = s_rd_axi_araddr;
assign m_axi_arlen = s_rd_axi_arlen;
assign m_axi_arsize = s_rd_axi_arsize;
assign m_axi_arburst = s_rd_axi_arburst;
assign m_axi_arcache = s_rd_axi_arcache;
assign m_axi_arprot = s_rd_axi_arprot;
assign s_rd_axi_arready = m_axi_arready;

assign s_rd_axi_rvalid = m_axi_rvalid;
assign s_rd_axi_rresp = m_axi_rresp;
assign s_rd_axi_rdata = m_axi_rdata;
assign m_axi_rready = s_rd_axi_rready;

endmodule
