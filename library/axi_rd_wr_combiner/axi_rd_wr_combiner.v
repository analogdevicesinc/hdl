// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

/*
 * Helper module to combine a read-only and a write-only AXI interface into a
 * single read-write AXI interface. Only supports AXI3 at the moment.
 */

`timescale 1ns/100ps

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
  input                         m_axi_rlast,
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
  output                        s_rd_axi_rlast,
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
  assign s_rd_axi_rlast = m_axi_rlast;
  assign m_axi_rready = s_rd_axi_rready;

endmodule
