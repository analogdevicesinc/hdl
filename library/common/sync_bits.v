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

/*
 * Helper module for synchronizing bit signals from one clock domain to another.
 * It uses the standard approach of 2 FF in series.
 * Note, that while the module allows to synchronize multiple bits at once it is
 * only able to synchronize multi-bit signals where at max one bit changes per
 * clock cycle (e.g. a gray counter).
 */
module sync_bits
(
  input [NUM_OF_BITS-1:0] in,
  input out_resetn,
  input out_clk,
  output [NUM_OF_BITS-1:0] out
);

// Number of bits to synchronize
parameter NUM_OF_BITS = 1;
// Whether input and output clocks are asynchronous, if 0 the synchronizer will
// be bypassed and the output signal equals the input signal.
parameter ASYNC_CLK = 1;

reg [NUM_OF_BITS-1:0] cdc_sync_stage1 = 'h0;
reg [NUM_OF_BITS-1:0] cdc_sync_stage2 = 'h0;

always @(posedge out_clk)
begin
  if (out_resetn == 1'b0) begin
    cdc_sync_stage1 <= 'b0;
    cdc_sync_stage2 <= 'b0;
  end else begin
    cdc_sync_stage1 <= in;
    cdc_sync_stage2 <= cdc_sync_stage1;
  end
end

assign out = ASYNC_CLK ? cdc_sync_stage2 : in;

endmodule
