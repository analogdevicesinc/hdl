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

/*
 * Helper module for synchronizing bit signals from one clock domain to another.
 * It uses the standard approach of 2 FF in series.
 * Note, that while the module allows to synchronize multiple bits at once it is
 * only able to synchronize multi-bit signals where at max one bit changes per
 * clock cycle (e.g. a gray counter).
 */

`timescale 1ns/100ps

module sync_bits #(

  // Number of bits to synchronize
  parameter NUM_OF_BITS = 1,
  // Whether input and output clocks are asynchronous, if 0 the synchronizer will
  // be bypassed and the output signal equals the input signal.
  parameter ASYNC_CLK = 1)(

  input [NUM_OF_BITS-1:0] in_bits,
  input out_resetn,
  input out_clk,
  output [NUM_OF_BITS-1:0] out_bits);

generate if (ASYNC_CLK == 1) begin
  reg [NUM_OF_BITS-1:0] cdc_sync_stage1 = 'h0;
  reg [NUM_OF_BITS-1:0] cdc_sync_stage2 = 'h0;

  always @(posedge out_clk)
  begin
    if (out_resetn == 1'b0) begin
      cdc_sync_stage1 <= 'b0;
      cdc_sync_stage2 <= 'b0;
    end else begin
      cdc_sync_stage1 <= in_bits;
      cdc_sync_stage2 <= cdc_sync_stage1;
    end
  end

  assign out_bits = cdc_sync_stage2;
end else begin
  assign out_bits = in_bits;
end endgenerate

endmodule
