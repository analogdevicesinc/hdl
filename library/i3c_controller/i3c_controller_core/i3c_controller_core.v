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
  parameter ASYNC_I3C_CLK = 0,
  parameter DA_LENGTH = 4,
  parameter DA_LENGTH_WIDTH = 2,
  // See I3C Target Address Restrictions for valid values
  parameter [7*DA_LENGTH-1:0] DA = {7'h0b, 7'h0a, 7'h09, 7'h08}
) (
  input  wire clk_0,
  input  wire clk_1,
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

  output wire [2:0] rmap_daa_status,
  input  wire [DA_LENGTH_WIDTH-1:0] rmap_daa_peripheral_index,
  output wire [6:0] rmap_daa_peripheral_da,
  input  wire [1:0] rmap_ibi_config,

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
  wire ibi_tick;
  wire [6:0] ibi_da;
  wire [7:0] ibi_mdb;

  wire clk_sel;
  wire clk_clr;

  wire idle_bus;

  i3c_controller_daa #(
    .DA_LENGTH(DA_LENGTH),
    .DA_LENGTH_WIDTH(DA_LENGTH_WIDTH),
    .DA(DA)
  ) i_i3c_controller_daa (
    .reset_n(reset_n),
    .clk(clk_0),
    .cmdp_do_daa(cmdp_do_daa),
    .cmdp_do_daa_ready(cmdp_do_daa_ready),
    .cmdw_valid(cmdw_daa_valid),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw_daa),
    .cmdw_nack(cmdw_nack),
    .rmap_daa_status(rmap_daa_status),
    .rmap_daa_peripheral_index(rmap_daa_peripheral_index),
    .rmap_daa_peripheral_da(rmap_daa_peripheral_da)
  );

  i3c_controller_framing #(
  ) i_i3c_controller_framing (
    .reset_n(reset_n),
    .clk(clk_0),
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
    .rmap_ibi_config(rmap_ibi_config)
  );

  i3c_controller_word #(
  ) i_i3c_controller_word (
    .reset_n(reset_n),
    .clk(clk_0),
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
    .ibi_tick(ibi_tick),
    .ibi_da(ibi_da),
    .ibi_mdb(ibi_mdb),
    .rmap_ibi_config(rmap_ibi_config)
  );

  i3c_controller_clk_div #(
    .ASYNC_CLK(ASYNC_I3C_CLK)
  ) i_i3c_controller_clk_div (
    .reset_n(reset_n),
    .sel(clk_sel),
    .cmd_ready(cmd_ready),
    .clk_0(clk_0),
    .clk_1(clk_1),
    .clk_out(clk_out)
  );

  i3c_controller_bit_mod #(
  ) i_i3c_controller_bit_mod (
    .reset_n(reset_n),
    .clk_0(clk_0),
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
