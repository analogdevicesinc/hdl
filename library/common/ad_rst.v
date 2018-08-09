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

module ad_rst (

  // clock reset

  input                   rst_async,
  input                   clk,
  output                  rstn,
  output  reg             rst);

  // internal registers
  reg             rst_async_d1 = 1'd1;
  reg             rst_async_d2 = 1'd1;
  reg             rst_sync = 1'd1;
  reg             rst_sync_d = 1'd1;

  // simple reset synchronizer
  always @(posedge clk or posedge rst_async) begin
    if (rst_async) begin
      rst_async_d1 <= 1'b1;
      rst_async_d2 <= 1'b1;
      rst_sync <= 1'b1;
    end else begin
      rst_async_d1 <= 1'b0;
      rst_async_d2 <= rst_async_d1;
      rst_sync <= rst_async_d2;
    end
  end

  // two-stage synchronizer to prevent metastability on the falling edge
  always @(posedge clk) begin
    rst_sync_d <= rst_sync;
    rst <= rst_sync_d;
  end

  assign rstn = ~rst;

endmodule

// ***************************************************************************
// ***************************************************************************
