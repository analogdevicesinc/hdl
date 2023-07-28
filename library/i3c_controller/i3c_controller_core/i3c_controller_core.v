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
`default_nettype wire
`include "i3c_controller_bit_mod_cmd.v"
`include "i3c_controller_word_cmd.v"

`define CLK_DIV "4"
`define MAX_DEVS 15

module i3c_controller_core #(
  parameter SIM_DEVICE = "7SERIES"
) (
  input clk,
  input reset_n,

  // Command parsed

  input         cmdp_valid,
  input         cmdp_ccc,
  input         cmdp_ccc_bcast,
  input  [6:0]  cmdp_ccc_id,
  input         cmdp_bcast_header,
  input  [1:0]  cmdp_xmit,
  input         cmdp_sr,
  input  [11:0] cmdp_buffer_len,
  input  [6:0]  cmdp_da,
  input         cmdp_rnw,
  output        cmdp_ready,
  output        cmdp_cancelled,
  output        cmdp_idle_bus,

  // Byte stream

  output sdo_ready,
  input  sdo_valid,
  input  [7:0] sdo,

  input  sdi_ready,
  output sdi_valid,
  output [7:0] sdi,

  input  ibi_ready,
  output ibi_valid,
  output [14:0] ibi,

  // uP accessible info

  output rmap_daa_status,
  input  [1:0] rmap_ibi_config,
  input  [29:0] rmap_devs_ctrl_mr,
  output [14:0] rmap_devs_ctrl,
  output rmap_dev_char_e,
  output rmap_dev_char_we,
  output [5:0]  rmap_dev_char_addr,
  output [31:0] rmap_dev_char_wdata,
  input  [8:0]  rmap_dev_char_rdata,

  // I3C bus signals

  output scl,
  inout  sda
);
  wire clk_out;
  wire [`MOD_BIT_CMD_WIDTH:0] cmd;
  wire cmd_valid;
  wire cmd_ready;
  wire t;
  wire sdo_bit;
  wire sdi_bit;

  wire rx;
  wire rx_valid;
  wire rx_stop;
  wire rx_nack;

  wire cmdw_valid;
  wire cmdw_ready;
  wire cmdw_mux;
  wire [`CMDW_HEADER_WIDTH+8:0] cmdw;
  wire cmdw_nack;

  wire cmdw_rx_ready;
  wire cmdw_rx_valid;
  wire [7:0] cmdw_rx;

  wire ibi_requested;
  wire ibi_requested_auto;
  wire ibi_tick;
  wire [6:0] ibi_da;
  wire [7:0] ibi_mdb;

  wire [31:0] pid_bcr_dcr;
  wire pid_bcr_dcr_tick;

  wire clk_sel;
  wire clk_clr;

  wire idle_bus;

  i3c_controller_framing #(
    .MAX_DEVS(`MAX_DEVS)
  ) i_i3c_controller_framing (
    .reset_n(reset_n),
    .clk(clk),
    .cmdp_valid(cmdp_valid),
    .cmdp_ready(cmdp_ready),
    .cmdp_ccc(cmdp_ccc),
    .cmdp_ccc_bcast(cmdp_ccc_bcast),
    .cmdp_ccc_id(cmdp_ccc_id),
    .cmdp_bcast_header(cmdp_bcast_header),
    .cmdp_xmit(cmdp_xmit),
    .cmdp_sr(cmdp_sr),
    .cmdp_buffer_len(cmdp_buffer_len),
    .cmdp_da(cmdp_da),
    .cmdp_rnw(cmdp_rnw),
    .cmdp_cancelled(cmdp_cancelled),
    .sdo_ready(sdo_ready),
    .sdo_valid(sdo_valid),
    .sdo(sdo),
    .sdi_ready(sdi_ready),
    .sdi_valid(sdi_valid),
    .sdi(sdi),
    .cmdw_valid(cmdw_valid),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw),
    .cmdw_nack(cmdw_nack),
    .cmdw_rx_ready(cmdw_rx_ready),
    .cmdw_rx_valid(cmdw_rx_valid),
    .cmdw_rx(cmdw_rx),
    .rx(rx),
    .idle_bus(idle_bus),
    .ibi_requested(ibi_requested),
    .ibi_requested_auto(ibi_requested_auto),
    .pid_bcr_dcr_tick(pid_bcr_dcr_tick),
    .pid_bcr_dcr(pid_bcr_dcr),
    .rmap_ibi_config(rmap_ibi_config),
    .rmap_devs_ctrl_mr(rmap_devs_ctrl_mr),
    .rmap_devs_ctrl(rmap_devs_ctrl),
    .rmap_dev_char_e(rmap_dev_char_e),
    .rmap_dev_char_we(rmap_dev_char_we),
    .rmap_dev_char_addr(rmap_dev_char_addr),
    .rmap_dev_char_wdata(rmap_dev_char_wdata),
    .rmap_dev_char_rdata(rmap_dev_char_rdata));

  i3c_controller_word #(
  ) i_i3c_controller_word (
    .reset_n(reset_n),
    .clk(clk),
    .cmdw_valid(cmdw_valid),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw),
    .cmdw_nack(cmdw_nack),
    .cmdw_rx_ready(cmdw_rx_ready),
    .cmdw_rx_valid(cmdw_rx_valid),
    .cmdw_rx(cmdw_rx),
    .cmd(cmd),
    .cmd_valid(cmd_valid),
    .cmd_ready(cmd_ready),
    .rx(rx),
    .rx_valid(rx_valid),
    .rx_stop(rx_stop),
    .rx_nack(rx_nack),
    .clk_sel(clk_sel),
    .ibi_requested(ibi_requested),
    .ibi_requested_auto(ibi_requested_auto),
    .ibi_tick(ibi_tick),
    .ibi_da(ibi_da),
    .ibi_mdb(ibi_mdb),
    .pid_bcr_dcr_tick(pid_bcr_dcr_tick),
    .pid_bcr_dcr(pid_bcr_dcr),
    .rmap_ibi_config(rmap_ibi_config));

  i3c_controller_clk_div #(
    .SIM_DEVICE(SIM_DEVICE),
    .CLK_DIV(`CLK_DIV)
  ) i_i3c_controller_clk_div (
    .reset_n(reset_n),
    .sel(clk_sel),
    .cmd_ready(cmd_ready),
    .clk(clk),
    .clk_out(clk_out));

  i3c_controller_bit_mod #(
  ) i_i3c_controller_bit_mod (
    .reset_n(reset_n),
    .clk_0(clk),
    .clk_1(clk_out),
    .clk_sel(clk_sel),
    .cmd(cmd),
    .cmd_valid(cmd_valid),
    .cmd_ready(cmd_ready),
    .rx(rx),
    .rx_valid(rx_valid),
    .rx_stop(rx_stop),
    .rx_nack(rx_nack),
    .idle_bus(idle_bus),
    .scl(scl),
    .sdi(sdi_bit),
    .sdo(sdo_bit),
    .t(t));

  i3c_controller_phy_sda #(
  ) i_i3c_controller_phy_sda (
    .sdo(sdo_bit),
    .sdi(sdi_bit),
    .t(t),
    .sda(sda));

  assign ibi = {ibi_da, ibi_mdb};
  assign ibi_valid = ibi_tick;
  assign cmdp_idle_bus = idle_bus;
endmodule
