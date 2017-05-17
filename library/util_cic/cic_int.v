// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

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
