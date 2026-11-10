// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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
// ORs an external link pause request into the MRMAC global pause request
// (bit 8 of the {lfc, pfc[7:0]} vector). The MRMAC sends pause frames while
// the bit is set and ctl_tx_pause_enable[8] is set (ethtool -A tx on).

module corundum_pause_merge (
  input  wire       clk,
  input  wire       pause_in,
  input  wire [8:0] req_in,
  output wire [8:0] req_out
);

  wire pause_sync;

  xpm_cdc_single #(
    .DEST_SYNC_FF (3),
    .SRC_INPUT_REG (0)
  ) i_pause_sync (
    .src_clk (1'b0),
    .src_in (pause_in),
    .dest_clk (clk),
    .dest_out (pause_sync));

  assign req_out = req_in | {pause_sync, 8'd0};

endmodule
