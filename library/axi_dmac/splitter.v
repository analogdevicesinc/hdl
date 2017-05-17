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


module splitter (
  input clk,
  input resetn,

  input s_valid,
  output s_ready,

  output [NUM_M-1:0] m_valid,
  input [NUM_M-1:0] m_ready
);

parameter NUM_M = 2;

reg [NUM_M-1:0] acked;

assign s_ready = &(m_ready | acked);
assign m_valid = s_valid ? ~acked : {NUM_M{1'b0}};

always @(posedge clk)
begin
  if (resetn == 1'b0) begin
    acked <= {NUM_M{1'b0}};
  end else begin
    if (s_valid & s_ready)
      acked <= {NUM_M{1'b0}};
    else
      acked <= acked | (m_ready & m_valid);
  end
end

endmodule
