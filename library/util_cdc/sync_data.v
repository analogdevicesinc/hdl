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
  .in(in_toggle_d1),
  .out_clk(out_clk),
  .out_resetn(1'b1),
  .out(out_toggle)
);

sync_bits i_sync_in (
  .in(out_toggle_d1),
  .out_clk(in_clk),
  .out_resetn(1'b1),
  .out(in_toggle)
);

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
