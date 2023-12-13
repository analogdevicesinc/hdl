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

module util_axis_syncgen #(

  parameter ASYNC_SYNC = 1
) (
  input      s_axis_aclk,
  input      s_axis_aresetn,
  input      s_axis_ready,
  input      s_axis_valid,

  input      ext_sync,
  output     s_axis_sync
);

  wire       sync_int_s;
  wire       sync_ack_s;
  wire       sync_ack_int_s;
  reg        synced = 1'b0;
  reg        sync_int_d = 1'b0;
  reg        s_axis_sync_int = 1'b0;

  // generate CDC for external sync

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (ASYNC_SYNC)
  ) i_axis_ext_sync (
    .in_bits (ext_sync),
    .out_clk (s_axis_aclk),
    .out_resetn (s_axis_aresetn),
    .out_bits (sync_int_s));

  // generate the sync signal

  assign sync_ack_s = sync_int_s & s_axis_ready & s_axis_valid;
  assign sync_ack_int_s = s_axis_sync_int & s_axis_ready & s_axis_valid;

  always @(posedge s_axis_aclk) begin
    if (s_axis_aresetn == 1'b0) begin
      sync_int_d <= 1'b0;
      s_axis_sync_int <= 1'b0;
      synced <= 1'b0;
    end else begin
      sync_int_d <= sync_int_s;
      if (sync_int_s && ~sync_int_d) begin
        s_axis_sync_int <= 1'b1;
        synced <= 1'b0;
      end
      if (sync_ack_int_s) begin
        synced <= 1'b1;
        s_axis_sync_int <= 1'b0;
      end
    end
  end

  assign s_axis_sync = s_axis_sync_int | (sync_ack_s & ~synced);

endmodule
