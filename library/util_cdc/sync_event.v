// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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
    .in_bits(in_toggle_d1),
    .out_clk(out_clk),
    .out_resetn(1'b1),
    .out_bits(out_toggle));

  sync_bits i_sync_in (
    .in_bits(out_toggle_d1),
    .out_clk(in_clk),
    .out_resetn(1'b1),
    .out_bits(in_toggle));

  wire in_ready = in_toggle == in_toggle_d1;
  wire load_out = out_toggle ^ out_toggle_d1;

  reg [NUM_OF_EVENTS-1:0] in_event_sticky = 'h00;
  wire [NUM_OF_EVENTS-1:0] pending_events = in_event_sticky | in_event;
  wire [NUM_OF_EVENTS-1:0] out_event_s;

  always @(posedge in_clk) begin
    if (in_ready == 1'b1) begin
      in_event_sticky <= {NUM_OF_EVENTS{1'b0}};
      if (|pending_events == 1'b1) begin
        in_toggle_d1 <= ~in_toggle_d1;
      end
    end else begin
      in_event_sticky <= pending_events;
    end
  end

  if (NUM_OF_EVENTS > 1) begin
    reg [NUM_OF_EVENTS-1:0] cdc_hold = 'h00;

    always @(posedge in_clk) begin
      if (in_ready == 1'b1) begin
        cdc_hold <= pending_events;
      end
    end

    assign out_event_s = cdc_hold;
  end else begin
    // When there is only one event, we know that it is set.
    assign out_event_s = 1'b1;
  end

  always @(posedge out_clk) begin
    if (load_out == 1'b1) begin
      out_event <= out_event_s;
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
