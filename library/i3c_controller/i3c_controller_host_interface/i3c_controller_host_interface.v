// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_host_interface #(
  parameter DATA_WIDTH = 32, // Const
  parameter DEFAULT_CLK_DIV = 0
) (
  // I3C basic signals

  input  wire clk,
  input  wire resetn,

  // I3C control signals

  output wire reg cmd_ready,
  input  wire cmd_valid,
  input  wire [DATA_WIDTH-1:0] cmd,

  input  wire cmdr_ready,
  output wire cmdr_valid,
  output wire [DATA_WIDTH-1:0] cmd_data,

  output wire reg sdo_ready,
  input  wire sdo_valid,
  input  wire [DATA_WIDTH:0] sdo,

  input  wire sdi_ready,
  output wire sdi_valid,
  output wire [DATA_WIDTH-1:0] sdi_data,

  input  wire ibi_ready,
  output wire ibi_valid,
  output wire [DATA_WIDTH-1:0] ibi_data,
);

  i3c_controller_read_byte #(
    .DATA_WIDTH(DATA_WIDTH)
  ) i_read_byte (
    .clk(clk),
    .resetn(resetn),

    .u32_ready(sdo_ready),
    .u32_valid(sdo_valid),
    .u32(sdo),

    .u8_len_ready(sdo_len_ready_s),
    .u8_len_valid(sdo_len_valid_s),
    .u8_len(sdo_length_s),

    .u8_ready(sdo_byte_ready_s),
    .u8_valid(sdo_byte_valid_s),
    .u8(sdo_byte_s)
  );

endmodule
