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

  input  wire cmdp_valid,
  output wire cmdp_ready,
  input  wire cmdp_ccc,
  input  wire cmdp_ccc_bcast,
  input  wire [6:0] cmdp_ccc_id,
  input  wire cmdp_bcast_header,
  input  wire [1:0] cmdp_xmit,
  input  wire cmdp_sr,
  input  wire [11:0] cmdp_buffer_len,
  input  wire [6:0] cmdp_da,
  input  wire cmdp_rnw,
  input  wire cmdp_do_daa,
  output wire cmdp_do_daa_ready,

  // Byte stream

  output wire sdo_ready,
  input  wire sdo_valid,
  input  wire [7:0] sdo,

  input  wire sdi_ready,
  output wire sdi_valid,
  output wire [7:0] sdi,

  // uP accessible info

  output wire rmap_daa_status_in_progress,
  output wire [DA_LENGTH_WIDTH-1:0] rmap_daa_status_registered,
  input  wire [DA_LENGTH_WIDTH-1:0] rmap_daa_peripheral_index,
  output wire [6:0] rmap_daa_peripheral_da,

  // I3C bus signals

  output wire scl,
  inout  wire sda
);
  wire clk_out;
  wire [`MOD_BIT_CMD_WIDTH:0] cmd;
  wire cmd_ready;
  wire t;
  wire sdo_bit;
  wire sdi_bit;

  wire rx;
  wire rx_valid;
  wire rx_stop;
  wire rx_nack;

  wire cmdw_ready;
  wire cmdw_mux;
  wire [`CMDW_HEADER_WIDTH+8:0] cmdw_framing;
  wire [`CMDW_HEADER_WIDTH+8:0] cmdw_daa;
  wire cmdw_nack;

  wire cmdw_rx_ready;
  wire cmdw_rx_valid;
  wire [7:0] cmdw_rx;

  wire clk_sel;
  wire clk_clr;

  i3c_controller_daa #(
    .DA_LENGTH(DA_LENGTH),
    .DA_LENGTH_WIDTH(DA_LENGTH_WIDTH),
    .DA(DA)
  ) i_i3c_controller_daa (
    .reset_n(reset_n),
    .clk(clk_0),
    .cmdp_do_daa(cmdp_do_daa),
    .cmdp_do_daa_ready(cmdp_do_daa_ready),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw_daa),
    .cmdw_nack(cmdw_nack),
    .rmap_daa_status_in_progress(rmap_daa_status_in_progress),
    .rmap_daa_status_registered(rmap_daa_status_registered),
    .rmap_daa_peripheral_index(rmap_daa_peripheral_index),
    .rmap_daa_peripheral_da(rmap_daa_peripheral_da)
  );

  i3c_controller_framing #(
  ) i_i3c_controller_framing (
    .reset_n(reset_n),
    .clk(clk_0),
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
    .cmdp_do_daa_ready(cmdp_do_daa_ready),
    .sdo_ready(sdo_ready),
    .sdo_valid(sdo_valid),
    .sdo(sdo),
    .sdi_ready(sdi_ready),
    .sdi_valid(sdi_valid),
    .sdi(sdi),
    .cmdw_ready(cmdw_ready),
    .cmdw(cmdw_framing),
    .cmdw_nack(cmdw_nack),
    .cmdw_rx_ready(cmdw_rx_ready),
    .cmdw_rx_valid(cmdw_rx_valid),
    .cmdw_rx(cmdw_rx)
  );

  i3c_controller_word #(
  ) i_i3c_controller_word (
    .reset_n(reset_n),
    .clk(clk_0),
    .cmdw_ready(cmdw_ready),
    .cmdw_mux(cmdw_mux),
    .cmdw_framing(cmdw_framing),
    .cmdw_daa(cmdw_daa),
    .cmdw_nack(cmdw_nack),
    .cmdw_rx_ready(cmdw_rx_ready),
    .cmdw_rx_valid(cmdw_rx_valid),
    .cmdw_rx(cmdw_rx),
    .cmd(cmd),
    .cmd_ready(cmd_ready),
    .rx(rx),
    .rx_valid(rx_valid),
    .rx_stop(rx_stop),
    .rx_nack(rx_nack),
    .clk_sel(clk_sel),
    .clk_clr(clk_clr)
  );

  i3c_controller_clk_div #(
    .ASYNC_CLK(ASYNC_I3C_CLK)
  ) i_i3c_controller_clk_div (
    .reset_n(reset_n),
    .sel(clk_sel),
    .clr(clk_clr),
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
    .cmd(cmd),
    .cmd_ready(cmd_ready),
    .rx(rx),
    .rx_valid(rx_valid),
    .rx_stop(rx_stop),
    .rx_nack(rx_nack),
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
endmodule
