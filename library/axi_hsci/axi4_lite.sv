// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ns
interface axi4_lite #(
   DATA_WIDTH = 32,
   ADDR_WIDTH = 32
);

  localparam WSTRB_WIDTH = DATA_WIDTH/8;

  // Write address channel
  logic                   awvalid;
  logic                   awready;
  logic [2:0]             awprot;
  logic [ADDR_WIDTH-1:0]  awaddr;

  // Write data channel
  logic                   wvalid;
  logic                   wready;
  logic [WSTRB_WIDTH-1:0] wstrb;
  logic [DATA_WIDTH-1:0]  wdata;

  // Write response channel
  logic                   bvalid;
  logic                   bready;
  logic [1:0]             bresp;

  // Read address channel
  logic                   arvalid;
  logic                   arready;
  logic [2:0]             arprot;
  logic [ADDR_WIDTH-1:0]  araddr;

  // Read response channel
  logic                   rvalid;
  logic                   rready;
  logic [1:0]             rresp;
  logic [DATA_WIDTH-1:0]  rdata;

  modport master (
    output awvalid, awprot, awaddr, wvalid, wstrb, wdata, bready, arvalid, arprot, araddr, rready,
    input awready, wready, bvalid, bresp, arready, rvalid, rresp, rdata
  );

  modport slave (
    output awready, wready, bvalid, bresp, arready, rvalid, rresp, rdata,
    input awvalid, awprot, awaddr, wvalid, wstrb, wdata, bready, arvalid, arprot, araddr, rready
  );

endinterface
