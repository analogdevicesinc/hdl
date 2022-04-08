// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module util_ext_sync #(
  parameter ENABLED = 1
) (
  input clk,

  input ext_sync_arm,
  input ext_sync_disarm,

  input sync_in,

  output reg sync_armed = 1'b0
);

  reg sync_in_d1 = 1'b0;
  reg sync_in_d2 = 1'b0;
  reg ext_sync_arm_d1 = 1'b0;
  reg ext_sync_disarm_d1 = 1'b0;

  // External sync
  always @(posedge clk) begin
    ext_sync_arm_d1 <= ext_sync_arm;
    ext_sync_disarm_d1 <= ext_sync_disarm;

    sync_in_d1 <= sync_in ;
    sync_in_d2 <= sync_in_d1;

    if (ENABLED == 1'b0) begin
      sync_armed <= 1'b0;
    end else if (~ext_sync_disarm_d1 & ext_sync_disarm) begin
      sync_armed <= 1'b0;
    end else if (~ext_sync_arm_d1 & ext_sync_arm) begin
      sync_armed <= 1'b1;
    end else if (~sync_in_d2 & sync_in_d1) begin
      sync_armed <= 1'b0;
    end
  end

endmodule
