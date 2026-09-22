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

// Both crossings the pack chain needs when cpack runs on a clock derived from,
// but not phase-related to, the device clock.
//
// device_resetn holds the gearbox in reset between DMA bursts so no partial
// beat survives a burst boundary. xfer_req is a level in the DMA clock domain,
// asserted while the DMA wants data; data_offload uses it the same way on its
// own read path. It is synchronised here rather than in the block design
// because a proc_sys_reset would stretch it into the start of the burst.
//
// enable_out carries the converter enable mask into the pack clock. The mask is
// quasi-static - software writes it through the TPL register map - so the two
// flop synchroniser costs nothing that matters.

module util_pack_cdc #(

  parameter NUM_OF_ENABLES = 2
) (
  input                        device_clk,
  input                        device_aresetn,
  input                        adc_rst,
  input                        xfer_req,
  output                       device_resetn,

  input                        pack_clk,
  input                        pack_aresetn,
  input  [NUM_OF_ENABLES-1:0]  enable_in,
  output [NUM_OF_ENABLES-1:0]  enable_out
);

  wire xfer_req_s;

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_xfer_req_sync (
    .in_bits (xfer_req),
    .out_clk (device_clk),
    .out_resetn (device_aresetn),
    .out_bits (xfer_req_s));

  assign device_resetn = device_aresetn & ~adc_rst & xfer_req_s;

  sync_bits #(
    .NUM_OF_BITS (NUM_OF_ENABLES),
    .ASYNC_CLK (1)
  ) i_enable_sync (
    .in_bits (enable_in),
    .out_clk (pack_clk),
    .out_resetn (pack_aresetn),
    .out_bits (enable_out));

endmodule
