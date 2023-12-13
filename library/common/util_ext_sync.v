// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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
