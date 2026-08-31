// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
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

`include "i3c_controller_bit_mod.vh"
`include "i3c_controller_word.vh"

module i3c_controller_core #(
  parameter MAX_DEVS = 16,
  parameter I2C_MOD = 0
) (
  input         clk,
  input         reset_n,

  // Command parsed

  output        cmdp_ready,
  input         cmdp_valid,
  input  [31:0] cmdp,
  output [2:0]  cmdp_error,
  output        cmdp_nop,
  output        cmdp_daa_trigger,

  // Byte stream

  output       sdo_ready,
  input        sdo_valid,
  input  [7:0] sdo,

  input        sdi_ready,
  output       sdi_valid,
  output       sdi_last,
  output [7:0] sdi,

  input         ibi_ready,
  output        ibi_valid,
  output [14:0] ibi,

  // uP accessible info

  input  [1:0] rmap_ibi_config,
  input  [1:0] rmap_pp_sg,
  output [6:0] rmap_dev_char_addr,
  input  [3:0] rmap_dev_char_data,

  // I3C bus signals

  output       i3c_scl,
  output       i3c_sdo,
  input        i3c_sdi,
  output       i3c_t
);

  wire [`MOD_BIT_CMD_WIDTH:0] cmdb;
  wire cmdb_valid;
  wire cmdb_ready;

  wire rx;
  wire rx_valid;

  wire cmdw_valid;
  wire cmdw_ready;
  wire [`CMDW_HEADER_WIDTH+8:0] cmdw;
  wire cmdw_nack_bcast;
  wire cmdw_nack_resp;

  wire arbitration_valid;
  wire ibi_bcr_2;
  wire ibi_dev_is_attached;
  wire ibi_requested;
  wire ibi_requested_auto;
  wire ibi_tick;
  wire [6:0] ibi_da;
  wire [7:0] ibi_mdb;

  wire nop;
  wire i2c_mode;

  wire bus_reset_n;
  wire framing_cmdp_ready;
  wire framing_cmdp_valid;

  wire bit_mod_scl;
  wire bit_mod_sdo;
  wire bit_mod_t;

  wire trp_cmd_valid;
  wire trp_cmd_ready;
  wire trp_idle;
  wire trp_hold;
  wire trp_scl;
  wire trp_sdo;
  wire trp_t;

  i3c_controller_framing #(
    .MAX_DEVS(MAX_DEVS)
  ) i_i3c_controller_framing (
    .reset_n(bus_reset_n),
    .clk(clk),
    .cmdp_valid(framing_cmdp_valid),
    .cmdp_ready(framing_cmdp_ready),
    .cmdp(cmdp[30:0]),
    .cmdp_error(cmdp_error),
    .cmdp_daa_trigger(cmdp_daa_trigger),
    .sdo_ready(sdo_ready),
    .sdo_valid(sdo_valid),
    .sdo(sdo),
    .cmdw_valid(cmdw_valid),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw),
    .cmdw_nack_bcast(cmdw_nack_bcast),
    .cmdw_nack_resp(cmdw_nack_resp),
    .rx(rx),
    .i2c_mode(i2c_mode),
    .nop(nop),
    .arbitration_valid(arbitration_valid),
    .ibi_dev_is_attached(ibi_dev_is_attached),
    .ibi_bcr_2(ibi_bcr_2),
    .ibi_requested(ibi_requested),
    .ibi_requested_auto(ibi_requested_auto),
    .ibi_da(ibi_da),
    .rmap_ibi_config(rmap_ibi_config),
    .rmap_dev_char_addr(rmap_dev_char_addr),
    .rmap_dev_char_data(rmap_dev_char_data));

  i3c_controller_word
  i_i3c_controller_word (
    .reset_n(bus_reset_n),
    .clk(clk),
    .cmdw_valid(cmdw_valid),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw),
    .cmdw_nack_bcast(cmdw_nack_bcast),
    .cmdw_nack_resp(cmdw_nack_resp),
    .sdi_ready(sdi_ready),
    .sdi_valid(sdi_valid),
    .sdi_last(sdi_last),
    .sdi(sdi),
    .cmdb(cmdb),
    .cmdb_valid(cmdb_valid),
    .cmdb_ready(cmdb_ready),
    .rx(rx),
    .rx_valid(rx_valid),
    .arbitration_valid(arbitration_valid),
    .ibi_dev_is_attached(ibi_dev_is_attached),
    .ibi_bcr_2(ibi_bcr_2),
    .ibi_requested(ibi_requested),
    .ibi_requested_auto(ibi_requested_auto),
    .ibi_tick(ibi_tick),
    .ibi_da(ibi_da),
    .ibi_mdb(ibi_mdb),
    .rmap_ibi_config(rmap_ibi_config));

  i3c_controller_bit_mod #(
    .I2C_MOD(I2C_MOD)
  ) i_i3c_controller_bit_mod (
    .reset_n(bus_reset_n),
    .clk(clk),
    .cmdb(cmdb),
    .cmdb_valid(cmdb_valid),
    .cmdb_ready(cmdb_ready),
    .scl_pp_sg(rmap_pp_sg),
    .rx(rx),
    .rx_valid(rx_valid),
    .i2c_mode(i2c_mode),
    .nop(nop),
    .scl(bit_mod_scl),
    .sdo(bit_mod_sdo),
    .sdi(i3c_sdi),
    .t(bit_mod_t));

  i3c_controller_trp
  i_i3c_controller_trp (
    .reset_n(reset_n),
    .clk(clk),
    .cmd_valid(trp_cmd_valid),
    .cmd_ready(trp_cmd_ready),
    .idle(trp_idle),
    .hold(trp_hold),
    .scl(trp_scl),
    .sdo(trp_sdo),
    .t(trp_t));

  assign trp_cmd_valid      = cmdp_valid &  cmdp[31];
  assign framing_cmdp_valid = cmdp_valid & ~cmdp[31];
  assign cmdp_ready = cmdp[31] ? trp_cmd_ready : framing_cmdp_ready;

  assign trp_idle = framing_cmdp_ready & cmdw_ready & (nop | ~bit_mod_scl) &
                    ~(rmap_ibi_config[1] & ~rx);

  assign bus_reset_n = reset_n & ~trp_hold;

  assign i3c_scl = trp_hold ? trp_scl : bit_mod_scl;
  assign i3c_sdo = trp_hold ? trp_sdo : bit_mod_sdo;
  assign i3c_t   = trp_hold ? trp_t   : bit_mod_t;

  assign ibi = {ibi_da, ibi_mdb};
  assign ibi_valid = ibi_tick;
  assign cmdp_nop = nop & ~trp_hold;

endmodule
