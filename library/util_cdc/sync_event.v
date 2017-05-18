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

module sync_event #(
  parameter NUM_OF_EVENTS = 1,
  parameter ASYNC_CLK = 1
) (
  input in_clk,
  input [NUM_OF_EVENTS-1:0] in_event,
  input out_clk,
  output reg [NUM_OF_EVENTS-1:0] out_event
);

generate
if (ASYNC_CLK == 1) begin

wire out_toggle;
wire in_toggle;

reg out_toggle_d1 = 1'b0;
reg in_toggle_d1 = 1'b0;

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

wire in_ready = in_toggle == in_toggle_d1;
wire load_out = out_toggle ^ out_toggle_d1;

reg [NUM_OF_EVENTS-1:0] cdc_hold = 'h00;
reg [NUM_OF_EVENTS-1:0] in_event_sticky = 'h00;
wire [NUM_OF_EVENTS-1:0] pending_events = in_event_sticky | in_event;

always @(posedge in_clk) begin
  if (in_ready == 1'b1) begin
    cdc_hold <= pending_events;
    in_event_sticky <= {NUM_OF_EVENTS{1'b0}};
    if (|pending_events == 1'b1) begin
      in_toggle_d1 <= ~in_toggle_d1;
    end
  end else begin
    in_event_sticky <= pending_events;
  end
end

always @(posedge out_clk) begin
  if (load_out == 1'b1) begin
    // When there is only one event, we know that it is set.
    out_event <= NUM_OF_EVENTS == 1 ? 1'b1 : cdc_hold;
  end else begin
    out_event <= {NUM_OF_EVENTS{1'b0}};
  end
  out_toggle_d1 <= out_toggle;
end

end else begin
  always @(*) begin
    out_event <= in_event;
  end
end
endgenerate

endmodule
