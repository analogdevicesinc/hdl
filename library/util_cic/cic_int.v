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

module cic_int #(
  parameter DATA_WIDTH = 12,
  parameter STAGE_WIDTH = 1,
  parameter NUM_STAGES = 1
) (
  input clk,
  input [NUM_STAGES-1:0] ce,
  input [DATA_WIDTH-1:0] data_in,
  output [DATA_WIDTH-1:0] data_out
);

reg [DATA_WIDTH-1:0] state = 'h00;
wire [DATA_WIDTH-1:0] sum;
wire [DATA_WIDTH-1:0] mask;

assign data_out = state;
assign sum = (data_in & mask) + (state & mask);
generate
genvar i;

for (i = 0; i < NUM_STAGES; i = i + 1) begin
  localparam j = NUM_STAGES - i - 1;
  localparam H = DATA_WIDTH - STAGE_WIDTH * i - 1;
  localparam L = j == 0 ? 0 : DATA_WIDTH - STAGE_WIDTH * (i+1);

  assign mask[H:L] = {{H-L{1'b1}},j != 0 ? ce[j] : 1'b1};

  always @(posedge clk) begin
    if (ce[j] == 1'b1) begin
      state[H:L] <= sum[H:L];
    end
  end
end

endgenerate

endmodule
