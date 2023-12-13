// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad9361_alt_lvds_tx (

  // physical interface (transmit)

  output          tx_clk_out_p,
  output          tx_clk_out_n,
  output          tx_frame_out_p,
  output          tx_frame_out_n,
  output  [ 5:0]  tx_data_out_p,
  output  [ 5:0]  tx_data_out_n,

  // data interface

  input           tx_clk,
  input           clk,
  input   [ 3:0]  tx_frame,
  input   [ 5:0]  tx_data_0,
  input   [ 5:0]  tx_data_1,
  input   [ 5:0]  tx_data_2,
  input   [ 5:0]  tx_data_3,
  output          tx_locked
);

  // internal registers

  reg     [27:0]  tx_data_n = 'd0;
  reg     [27:0]  tx_data_p = 'd0;

  // internal signals

  wire            core_clk;
  wire    [27:0]  tx_data_s;

  // instantiations

  assign tx_clk_out_n = 1'd0;
  assign tx_frame_out_n = 1'd0;
  assign tx_data_out_n = 6'd0;

  assign tx_data_s[24] = tx_frame[3];
  assign tx_data_s[25] = tx_frame[2];
  assign tx_data_s[26] = tx_frame[1];
  assign tx_data_s[27] = tx_frame[0];
  assign tx_data_s[20] = tx_data_3[5];
  assign tx_data_s[16] = tx_data_3[4];
  assign tx_data_s[12] = tx_data_3[3];
  assign tx_data_s[ 8] = tx_data_3[2];
  assign tx_data_s[ 4] = tx_data_3[1];
  assign tx_data_s[ 0] = tx_data_3[0];
  assign tx_data_s[21] = tx_data_2[5];
  assign tx_data_s[17] = tx_data_2[4];
  assign tx_data_s[13] = tx_data_2[3];
  assign tx_data_s[ 9] = tx_data_2[2];
  assign tx_data_s[ 5] = tx_data_2[1];
  assign tx_data_s[ 1] = tx_data_2[0];
  assign tx_data_s[22] = tx_data_1[5];
  assign tx_data_s[18] = tx_data_1[4];
  assign tx_data_s[14] = tx_data_1[3];
  assign tx_data_s[10] = tx_data_1[2];
  assign tx_data_s[ 6] = tx_data_1[1];
  assign tx_data_s[ 2] = tx_data_1[0];
  assign tx_data_s[23] = tx_data_0[5];
  assign tx_data_s[19] = tx_data_0[4];
  assign tx_data_s[15] = tx_data_0[3];
  assign tx_data_s[11] = tx_data_0[2];
  assign tx_data_s[ 7] = tx_data_0[1];
  assign tx_data_s[ 3] = tx_data_0[0];

  always @(negedge clk) begin
    tx_data_n <= tx_data_s;
  end

  always @(posedge core_clk) begin
    tx_data_p <= tx_data_n;
  end

  altlvds_tx #(
    .center_align_msb ("UNUSED"),
    .common_rx_tx_pll ("ON"),
    .coreclock_divide_by (1),
    .data_rate ("500.0 Mbps"),
    .deserialization_factor (4),
    .differential_drive (0),
    .enable_clock_pin_mode ("UNUSED"),
    .implement_in_les ("OFF"),
    .inclock_boost (0),
    .inclock_data_alignment ("EDGE_ALIGNED"),
    .inclock_period (4000),
    .inclock_phase_shift (0),
    .intended_device_family ("Cyclone V"),
    .lpm_hint ("CBX_MODULE_PREFIX=axi_ad9361_alt_lvds_tx"),
    .lpm_type ("altlvds_tx"),
    .multi_clock ("OFF"),
    .number_of_channels (7),
    .outclock_alignment ("EDGE_ALIGNED"),
    .outclock_divide_by (2),
    .outclock_duty_cycle (50),
    .outclock_multiply_by (1),
    .outclock_phase_shift (0),
    .outclock_resource ("Regional clock"),
    .output_data_rate (500),
    .pll_compensation_mode ("AUTO"),
    .pll_self_reset_on_loss_lock ("OFF"),
    .preemphasis_setting (0),
    .refclk_frequency ("250.000000 MHz"),
    .registered_input ("TX_CORECLK"),
    .use_external_pll ("OFF"),
    .use_no_phase_shift ("ON"),
    .vod_setting (0),
    .clk_src_is_pll ("off")
  ) i_altlvds_tx (
    .tx_inclock (tx_clk),
    .tx_coreclock (core_clk),
    .tx_in (tx_data_p),
    .tx_outclock (tx_clk_out_p),
    .tx_out ({tx_frame_out_p, tx_data_out_p}),
    .tx_locked (tx_locked),
    .pll_areset (1'b0),
    .sync_inclock (1'b0),
    .tx_data_reset (1'b0),
    .tx_enable (1'b1),
    .tx_pll_enable (1'b1),
    .tx_syncclock (1'b0));

endmodule
