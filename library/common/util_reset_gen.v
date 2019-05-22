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

module util_reset_gen #(

  parameter ASYNC_CLK = 1) (

  input           clk,

  input           sync_ext_in,
  output          sync_ext_out,

  output  reg     reset,
  output          resetn);

  reg   [ 2:0]    sync_ext_int = 3'd0;

  wire            sync_ext_int_s;

  // generate CDC for external sync

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (ASYNC_CLK))
  i_axis_ext_sync (
    .in_bits (sync_ext_in),
    .out_clk (clk),
    .out_resetn (1'b0),
    .out_bits (sync_ext_int_s));

  // latch the sync signal

  always @(posedge clk) begin
    sync_ext_int <= {sync_ext_int[1:0], sync_ext_int_s};
  end

  // generate reset at the positive edge of sync

  always @(posedge clk) begin
    reset <= sync_ext_int_s & ~sync_ext_int[0];
  end

  assign resetn = ~reset;
  assign sync_ext_out = sync_ext_int[2];

endmodule

