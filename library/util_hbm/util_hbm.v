// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_hbm #(
  parameter SRC_DATA_WIDTH = 512,
  parameter SRC_ADDR_WIDTH = 8,
  parameter DST_DATA_WIDTH = 128,
  parameter DST_ADDR_WIDTH = 7,

  parameter AXI_DATA_WIDTH = 256,
  parameter AXI_ADDR_WIDTH = 32,

  parameter AXI_ID_WIDTH = 6,

  parameter NUM_M = SRC_DATA_WIDTH <= AXI_DATA_WIDTH ? 1 :
                   (SRC_DATA_WIDTH / AXI_DATA_WIDTH) 
) (
  input                                       fifo_src_clk,
  input                                       fifo_src_resetn,
  input                                       fifo_src_wen,
  input       [SRC_ADDR_WIDTH-1:0]            fifo_src_waddr,
  input       [SRC_DATA_WIDTH-1:0]            fifo_src_wdata,
  input                                       fifo_src_wlast,

  input                                       fifo_dst_clk,
  input                                       fifo_dst_resetn,
  input                                       fifo_dst_ren,
  input       [DST_ADDR_WIDTH-1:0]            fifo_dst_raddr,
  output      [DST_DATA_WIDTH-1:0]            fifo_dst_rdata,

  // Signal to the controller, that the bridge is ready to push data to the
  // destination
  output                                      fifo_dst_ready,

  // Status signals
  output                                      fifo_src_full,    // FULL asserts when SOURCE data rate (e.g. ADC) is higher than DDR data rate
  output                                      fifo_dst_empty,   // EMPTY asserts when DESTINATION data rate (e.g. DAC) is higher than DDR data rate


  // Master AXI3 interface
  input                                    m_axi_aclk,
  input                                    m_axi_aresetn,

  // Write address
  output [NUM_M*AXI_ADDR_WIDTH-1:0]        m_axi_awaddr,
  output [NUM_M*4-1:0]                     m_axi_awlen,
  output [NUM_M*3-1:0]                     m_axi_awsize,
  output [NUM_M*2-1:0]                     m_axi_awburst,
  output [NUM_M-1:0]                       m_axi_awvalid,
  input  [NUM_M-1:0]                       m_axi_awready,
  output [NUM_M*AXI_ID_WIDTH-1:0]          m_axi_awid,

  // Write data
  output [NUM_M*AXI_DATA_WIDTH-1:0]        m_axi_wdata,
  output [NUM_M*(AXI_DATA_WIDTH/8)-1:0]    m_axi_wstrb,
  input  [NUM_M-1:0]                       m_axi_wready,
  output [NUM_M-1:0]                       m_axi_wvalid,
  output [NUM_M-1:0]                       m_axi_wlast,
  output [NUM_M*AXI_ID_WIDTH-1:0]          m_axi_wid,

  // Write response
  input  [NUM_M-1:0]                       m_axi_bvalid,
  input  [NUM_M*2-1:0]                     m_axi_bresp,
  output [NUM_M-1:0]                       m_axi_bready,
  input  [NUM_M*AXI_ID_WIDTH-1:0]          m_axi_bid,

  // Read address
  input  [NUM_M-1:0]                       m_axi_arready,
  output [NUM_M-1:0]                       m_axi_arvalid,
  output [NUM_M*AXI_ADDR_WIDTH-1:0]        m_axi_araddr,
  output [NUM_M*4-1:0]                     m_axi_arlen,
  output [NUM_M*3-1:0]                     m_axi_arsize,
  output [NUM_M*2-1:0]                     m_axi_arburst,
  output [NUM_M*AXI_ID_WIDTH-1:0]          m_axi_arid,

  // Read data and response
  input  [NUM_M*AXI_DATA_WIDTH-1:0]        m_axi_rdata,
  output [NUM_M-1:0]                       m_axi_rready,
  input  [NUM_M-1:0]                       m_axi_rvalid,
  input  [NUM_M*2-1:0]                     m_axi_rresp,
  input  [NUM_M*AXI_ID_WIDTH-1:0]          m_axi_rid,
  input  [NUM_M-1:0]                       m_axi_rlast

);


endmodule


