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
`default_nettype wire
`include "i3c_controller_bit_mod_cmd.v"
`include "i3c_controller_word_cmd.v"

module i3c_controller_core #(
  parameter SIM_DEVICE = "7SERIES",
  parameter CLK_DIV = "4",
  parameter MAX_DEVS = 15
) (
  input  wire clk,
  input  wire reset_n,

  // Command parsed

  input  wire        cmdp_valid,
  input  wire        cmdp_ccc,
  input  wire        cmdp_ccc_bcast,
  input  wire [6:0]  cmdp_ccc_id,
  input  wire        cmdp_bcast_header,
  input  wire [1:0]  cmdp_xmit,
  input  wire        cmdp_sr,
  input  wire [11:0] cmdp_buffer_len,
  input  wire [6:0]  cmdp_da,
  input  wire        cmdp_rnw,
  input  wire        cmdp_do_daa,
  output wire        cmdp_do_daa_ready,
  output wire        cmdp_ready,
  output wire        cmdp_cancelled,

  // Byte stream

  output wire sdo_ready,
  input  wire sdo_valid,
  input  wire [7:0] sdo,

  input  wire sdi_ready,
  output wire sdi_valid,
  output wire [7:0] sdi,

  input  wire ibi_ready,
  output wire ibi_valid,
  output wire [14:0] ibi,

  // uP accessible info

  output wire rmap_daa_status,
  input  wire [1:0] rmap_ibi_config,
  input  wire [29:0] rmap_devs_ctrl_mr,
  output wire [14:0] rmap_devs_ctrl,
  output wire rmap_dev_char_e,
  output wire rmap_dev_char_we,
  output wire [5:0]  rmap_dev_char_addr,
  output wire [31:0] rmap_dev_char_wdata,
  input  wire [8:0]  rmap_dev_char_rdata,

  // I3C bus signals

  output wire scl,
  inout  wire sda
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

  wire cmdp_ready_w;
  wire cmdp_valid_w;

  wire cmdw_framing_valid;
  wire cmdw_daa_valid;
  wire cmdw_ready;
  wire cmdw_mux;
  wire [`CMDW_HEADER_WIDTH+8:0] cmdw_framing;
  wire [`CMDW_HEADER_WIDTH+8:0] cmdw_daa;
  wire [`CMDW_HEADER_WIDTH+8:0] cmdw_ibi;
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

  i3c_controller_daa #(
    .MAX_DEVS(MAX_DEVS)
  ) i_i3c_controller_daa (
    .reset_n(reset_n),
    .clk(clk),
    .cmdp_do_daa(cmdp_do_daa),
    .cmdp_do_daa_ready(cmdp_do_daa_ready),
    .cmdw_valid(cmdw_daa_valid),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw_daa),
    .cmdw_nack(cmdw_nack),
    .idle_bus(idle_bus),
    .pid_bcr_dcr_tick(pid_bcr_dcr_tick),
    .pid_bcr_dcr(pid_bcr_dcr),
    .rmap_daa_status(rmap_daa_status),
    .rmap_devs_ctrl_mr(rmap_devs_ctrl_mr),
    .rmap_devs_ctrl(rmap_devs_ctrl),
    .rmap_dev_char_e(rmap_dev_char_e),
    .rmap_dev_char_we(rmap_dev_char_we),
    .rmap_dev_char_addr(rmap_dev_char_addr),
    .rmap_dev_char_wdata(rmap_dev_char_wdata),
    .rmap_dev_char_rdata(rmap_dev_char_rdata)
  );

  i3c_controller_framing #(
  ) i_i3c_controller_framing (
    .reset_n(reset_n),
    .clk(clk),
    .cmdp_valid(cmdp_valid_w),
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
    .cmdp_cancelled(cmdp_cancelled),
    .sdo_ready(sdo_ready),
    .sdo_valid(sdo_valid),
    .sdo(sdo),
    .sdi_ready(sdi_ready),
    .sdi_valid(sdi_valid),
    .sdi(sdi),
    .cmdw_valid(cmdw_framing_valid),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw_framing),
    .cmdw_nack(cmdw_nack),
    .cmdw_rx_ready(cmdw_rx_ready),
    .cmdw_rx_valid(cmdw_rx_valid),
    .cmdw_rx(cmdw_rx),
    .rx(rx),
    .idle_bus(idle_bus),
    .ibi_requested(ibi_requested),
    .ibi_requested_auto(ibi_requested_auto),
    .rmap_ibi_config(rmap_ibi_config)
  );

  i3c_controller_word #(
  ) i_i3c_controller_word (
    .reset_n(reset_n),
    .clk(clk),
    .cmdw_framing_valid(cmdw_framing_valid),
    .cmdw_daa_valid(cmdw_daa_valid),
    .cmdw_ready(cmdw_ready),
    .cmdw_mux(cmdw_mux),
    .cmdw_framing(cmdw_framing),
    .cmdw_daa(cmdw_daa),
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
    .rmap_ibi_config(rmap_ibi_config)
  );

  i3c_controller_clk_div #(
    .SIM_DEVICE(SIM_DEVICE),
    .CLK_DIV(CLK_DIV)
  ) i_i3c_controller_clk_div (
    .reset_n(reset_n),
    .sel(clk_sel),
    .cmd_ready(cmd_ready),
    .clk(clk),
    .clk_out(clk_out)
  );

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
    .t(t)
  );

  i3c_controller_phy_sda #(
  ) i_i3c_controller_phy_sda (
    .sdo(sdo_bit),
    .sdi(sdi_bit),
    .t(t),
    .sda(sda)
  );

  assign cmdw_mux = cmdp_do_daa_ready;
  assign cmdp_ready = cmdp_ready_w & cmdp_do_daa_ready;
  assign cmdp_valid_w = cmdp_valid & cmdp_do_daa_ready;

  assign ibi = {ibi_da, ibi_mdb};
  assign ibi_valid = ibi_tick;
endmodule
