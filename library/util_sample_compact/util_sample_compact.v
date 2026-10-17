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

// Slot compactor for block designs. See ad_sample_compact.

`timescale 1ns/100ps

module util_sample_compact #(
  parameter SLOT_W           = 16,
  parameter IN_SLOTS         = 2,
  parameter OUT_SLOTS        = 2,
  parameter ASYNC_RESET      = 0,
  parameter ROT_IMPL         = 0,
  parameter PIPE_STAGES      = -1,
  parameter LEVEL_BUDGET     = 0,
  parameter [63:0] PIPE_MASK = 64'd0
) (
  input                              clk,
  input                              reset,

  input      [IN_SLOTS*SLOT_W-1:0]   idata,
  input      [IN_SLOTS-1:0]          ikeep,

  output     [OUT_SLOTS*SLOT_W-1:0]  odata,
  output                             ovalid
);

  ad_sample_compact #(
    .SLOT_W (SLOT_W),
    .IN_SLOTS (IN_SLOTS),
    .OUT_SLOTS (OUT_SLOTS),
    .ASYNC_RESET (ASYNC_RESET),
    .ROT_IMPL (ROT_IMPL),
    .PIPE_STAGES (PIPE_STAGES),
    .LEVEL_BUDGET (LEVEL_BUDGET),
    .PIPE_MASK (PIPE_MASK)
  ) i_compact (
    .clk (clk),
    .reset (reset),
    .idata (idata),
    .ikeep (ikeep),
    .odata (odata),
    .ovalid (ovalid));

endmodule
