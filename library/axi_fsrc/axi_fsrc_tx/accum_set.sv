// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

// Accumulator with set and overflow. The overflow tests add_val; the
// accumulator advances by step_val.

`default_nettype none

module accum_set #(
  parameter WIDTH = 32
)(
  input  wire               clk,

  input  wire  [WIDTH-1:0]  set_val,
  input  wire               set,

  input  wire  [WIDTH-1:0]  add_val,
  input  wire  [WIDTH-1:0]  step_val,
  input  wire               add,

  output logic [WIDTH-1:0]  accum,
  output logic              overflow
);

  always_ff @(posedge clk) begin
    if(set) begin
      accum <= set_val;
      overflow <= 1'b0;
    end else if(add) begin
      overflow <= ({1'b0, accum} + {1'b0, add_val}) >> WIDTH;
      accum <= accum + step_val;
    end
  end

endmodule

`default_nettype wire
