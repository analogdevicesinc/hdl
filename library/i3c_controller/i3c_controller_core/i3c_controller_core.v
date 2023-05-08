// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
`include "i3c_controller_bit_mod_cmd.v"

module i3c_controller_core #(
  parameter DEFAULT_CLK_DIV = 0
) (
  input  wire clk,
  input  wire reset_n,

  // Command parsed

  input  wire cmdp_valid,
  output wire cmdp_ready,
  input  wire cmdp_ccc,
  input  wire cmdp_ccc_broadcast,
  input  wire [6:0] cmdp_ccc_id,
  input  wire cmdp_broadcast_header,
  input  wire [1:0] cmdp_xmit,
  input  wire cmdp_sr,
  input  wire [11:0] cmdp_buffer_len,
  input  wire [6:0] cmdp_da,
  input  wire cmdp_rnw,
  input  wire cmdp_do_daa,
  output wire cmdp_do_daa_ready,

  // Byte stream

  output reg  sdo_ready,
  input  wire sdo_valid,
  input  wire [7:0] sdo,

  input  wire sdi_ready,
  output wire sdi_valid,
  output wire [7:0] sdi,

  // I3C bus signals

  output wire scl,
  inout  wire sda
);
  wire clk_quarter;
  wire [`MOD_BIT_CMD_WIDTH:0] cmd;
  wire cmd_tick;
  wire t;
  wire sdo_bit;
  wire sdi_bit;

  wire [63:0] o_pid_bcr_dcr;
  wire [6:0] o_da;
  wire o_pid_da_valid;
  wire error;

  i3c_controller_quarter_clk #(
  ) i_i3c_controller_quarter_clk (
    .reset_n(reset_n),
    .clk(clk),
    .clk_quarter(clk_quarter)
  );

  i3c_controller_bit_mod #(
  ) i_i3c_controller_bit_mod (
    .reset_n(reset_n),
    .clk(clk),
    .clk_quarter(clk_quarter),
    .cmd(cmd),
    .cmd_tick(cmd_tick),
    .scl(scl),
    .sdi(sdi_bit),
    .t(t)
  );

  i3c_controller_phy_sda #(
  ) i_i3c_controller_phy_sda (
    .sdo(sdo_bit),
    .sdi(sdi_bit),
    .t(t),
    .sda(sda)
  );

  i3c_controller_daa #(
  ) i_i3c_controller_daa (
    .reset_n(reset_n),
    .clk(clk),
    .clk_quarter(clk_quarter),
    .cmdp_do_daa(cmdp_do_daa),
    .cmdp_do_daa_ready(cmdp_do_daa_ready),
    .sdo(sdo_bit),
    .cmd(cmd),
    .o_pid_bcr_dcr(o_pid_bcr_dcr),
    .o_da(o_da),
    .o_pid_da_valid(o_pid_da_valid),
    .error(error)
  );

endmodule
