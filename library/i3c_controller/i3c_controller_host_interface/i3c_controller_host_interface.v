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
  input  wire reset_n,

  // I3C control signals

  output wire cmd_ready,
  input  wire cmd_valid,
  input  wire [DATA_WIDTH-1:0] cmd,

  input  wire cmdr_ready,
  output wire cmdr_valid,
  output wire [DATA_WIDTH-1:0] cmdr,

  output wire sdo_ready,
  input  wire sdo_valid,
  input  wire [DATA_WIDTH-1:0] sdo,

  input  wire sdi_ready,
  output wire sdi_valid,
  output wire [DATA_WIDTH-1:0] sdi,

  input  wire ibi_ready,
  output wire ibi_valid,
  output wire [DATA_WIDTH-1:0] ibi,

  // Command parsed

  output wire cmdp_valid,
  input  wire cmdp_ready,
  output wire cmdp_ccc,
  output wire cmdp_ccc_bcast,
  output wire [6:0] cmdp_ccc_id,
  output wire cmdp_bcast_header,
  output wire [1:0] cmdp_xmit,
  output wire cmdp_sr,
  output wire [11:0] cmdp_buffer_len,
  output wire [6:0] cmdp_da,
  output wire cmdp_rnw,
  output wire cmdp_do_daa,
  input  wire cmdp_do_daa_ready,

  // Byte stream

  input  wire sdo_u8_ready,
  output wire sdo_u8_valid,
  output wire [7:0] sdo_u8,

  output wire sdi_u8_ready,
  input  wire sdi_u8_valid,
  input  wire [7:0] sdi_u8
);
  wire rd_bytes_valid;
  wire rd_bytes_ready;
  wire wr_bytes_valid;
  wire wr_bytes_ready;
  wire cmdp_ready_w;

  i3c_controller_read_byte #(
  ) i_i3c_controller_read_byte (
    .clk(clk),
    .reset_n(reset_n),

    .u32_ready(sdo_ready),
    .u32_valid(sdo_valid),
    .u32(sdo),

    .u8_len_ready(rd_bytes_ready),
    .u8_len_valid(rd_bytes_valid),
    .u8_len(cmdp_buffer_len),

    .u8_ready(sdo_u8_ready),
    .u8_valid(sdo_u8_valid),
    .u8(sdo_u8),

    .debug_u32_underflow()
  );

  i3c_controller_write_byte #(
  ) i_i3c_controller_write_byte (
    .clk(clk),
    .reset_n(reset_n),

    .u32_ready(sdi_ready),
    .u32_valid(sdi_valid),
    .u32(sdi),

    .u8_len_ready(wr_bytes_ready),
    .u8_len_valid(wr_bytes_valid),
    .u8_len(cmdp_buffer_len),

    .u8_ready(sdi_u8_ready),
    .u8_valid(sdi_u8_valid),
    .u8(sdi_u8)
  );

  i3c_controller_cmd_parser #(
  ) i_i3c_controller_cmd_parser (
    .clk(clk),
    .reset_n(reset_n),

    .cmd_ready(cmd_ready),
    .cmd_valid(cmd_valid),
    .cmd(cmd),

    .cmdp_valid(cmdp_valid),
    .cmdp_ready(cmdp_ready_w),
    .cmdp_ccc(cmdp_ccc),
    .cmdp_ccc_bcast(cmdp_ccc_bcast),
    .cmdp_ccc_id(cmdp_ccc_id),
    .cmdp_bcast_header(cmdp_bcast_header),
    .cmdp_xmit(cmdp_xmit),
    .cmdp_sr(cmdp_sr),
    .cmdp_buffer_len(cmdp_buffer_len),
    .cmdp_da(cmdp_da),
    .cmdp_rnw(cmdp_rnw),
    .cmdp_do_daa(cmdp_do_daa),
    .cmdp_do_daa_ready(cmdp_do_daa_ready)
  );

  assign rd_bytes_valid = (cmdp_valid & ~cmdp_ccc & cmdp_rnw);
  assign wr_bytes_valid = (cmdp_valid & ~cmdp_ccc & ~cmdp_rnw);
  assign cmdp_ready_w = (wr_bytes_ready & rd_bytes_ready & cmdp_ready);
endmodule
