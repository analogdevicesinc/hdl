// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module sync_data #(
  parameter NUM_OF_BITS = 1,
  parameter ASYNC_CLK = 1
) (
  input in_clk,
  input [NUM_OF_BITS-1:0] in_data,
  input out_clk,
  output reg [NUM_OF_BITS-1:0] out_data
);

  generate
  if (ASYNC_CLK == 1) begin

  wire out_toggle;
  wire in_toggle;

  reg out_toggle_d1 = 1'b0;
  reg in_toggle_d1 = 1'b0;

  reg [NUM_OF_BITS-1:0] cdc_hold;

  sync_bits i_sync_out (
    .in_bits(in_toggle_d1),
    .out_clk(out_clk),
    .out_resetn(1'b1),
    .out_bits(out_toggle));

  sync_bits i_sync_in (
    .in_bits(out_toggle_d1),
    .out_clk(in_clk),
    .out_resetn(1'b1),
    .out_bits(in_toggle));

  wire in_load = in_toggle == in_toggle_d1;
  wire out_load = out_toggle ^ out_toggle_d1;

  always @(posedge in_clk) begin
    if (in_load == 1'b1) begin
      cdc_hold <= in_data;
      in_toggle_d1 <= ~in_toggle_d1;
    end
  end

  always @(posedge out_clk) begin
    if (out_load == 1'b1) begin
      out_data <= cdc_hold;
    end
    out_toggle_d1 <= out_toggle;
  end

  end else begin
    always @(*) begin
      out_data <= in_data;
    end
  end
  endgenerate

endmodule
