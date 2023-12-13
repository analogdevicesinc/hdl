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

module axi_ad9361_lvds_if_c5 (

  // physical interface (receive)

  input               rx_clk_in_p,
  input               rx_clk_in_n,
  input               rx_frame_in_p,
  input               rx_frame_in_n,
  input   [ 5:0]      rx_data_in_p,
  input   [ 5:0]      rx_data_in_n,

  // physical interface (transmit)

  output              tx_clk_out_p,
  output              tx_clk_out_n,
  output              tx_frame_out_p,
  output              tx_frame_out_n,
  output  [ 5:0]      tx_data_out_p,
  output  [ 5:0]      tx_data_out_n,

  // ensm control

  output              enable,
  output              txnrx,

  // clock (common to both receive and transmit)

  output              clk,

  // receive data path interface

  output  [ 3:0]      rx_frame,
  output  [ 5:0]      rx_data_0,
  output  [ 5:0]      rx_data_1,
  output  [ 5:0]      rx_data_2,
  output  [ 5:0]      rx_data_3,

  // transmit data path interface

  input   [ 3:0]      tx_frame,
  input   [ 5:0]      tx_data_0,
  input   [ 5:0]      tx_data_1,
  input   [ 5:0]      tx_data_2,
  input   [ 5:0]      tx_data_3,
  input               tx_enable,
  input               tx_txnrx,

  // locked (status)

  output              locked,

  // delay interface

  input               up_clk,
  input               up_rstn
);

  // internal registers

  reg                 pll_rst = 1'd1;
  reg                 locked_int = 'd0;
  reg                 tx_core_enable_int = 'd0;
  reg                 tx_core_txnrx_int = 'd0;
  reg     [27:0]      tx_core_data_int = 'd0;
  reg                 tx_core_enable = 'd0;
  reg                 tx_core_txnrx = 'd0;
  reg     [27:0]      tx_core_data = 'd0;
  reg                 tx_locked_int = 'd0;
  reg                 tx_locked = 'd0;

  // internal signals

  wire    [27:0]      rx_core_data_s;
  wire                rx_locked_s;
  wire                tx_core_clk;
  wire                tx_locked_s;

  // pll reset

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      pll_rst <= 1'b1;
    end else begin
      pll_rst <= 1'b0;
    end
  end

  assign locked = locked_int;

  always @(posedge clk) begin
    locked_int <= rx_locked_s & tx_locked;
  end

  // receive

  assign rx_frame[3] = rx_core_data_s[24];
  assign rx_frame[2] = rx_core_data_s[25];
  assign rx_frame[1] = rx_core_data_s[26];
  assign rx_frame[0] = rx_core_data_s[27];

  assign rx_data_3[5] = rx_core_data_s[20];
  assign rx_data_3[4] = rx_core_data_s[16];
  assign rx_data_3[3] = rx_core_data_s[12];
  assign rx_data_3[2] = rx_core_data_s[ 8];
  assign rx_data_3[1] = rx_core_data_s[ 4];
  assign rx_data_3[0] = rx_core_data_s[ 0];
  assign rx_data_2[5] = rx_core_data_s[21];
  assign rx_data_2[4] = rx_core_data_s[17];
  assign rx_data_2[3] = rx_core_data_s[13];
  assign rx_data_2[2] = rx_core_data_s[ 9];
  assign rx_data_2[1] = rx_core_data_s[ 5];
  assign rx_data_2[0] = rx_core_data_s[ 1];
  assign rx_data_1[5] = rx_core_data_s[22];
  assign rx_data_1[4] = rx_core_data_s[18];
  assign rx_data_1[3] = rx_core_data_s[14];
  assign rx_data_1[2] = rx_core_data_s[10];
  assign rx_data_1[1] = rx_core_data_s[ 6];
  assign rx_data_1[0] = rx_core_data_s[ 2];
  assign rx_data_0[5] = rx_core_data_s[23];
  assign rx_data_0[4] = rx_core_data_s[19];
  assign rx_data_0[3] = rx_core_data_s[15];
  assign rx_data_0[2] = rx_core_data_s[11];
  assign rx_data_0[1] = rx_core_data_s[ 7];
  assign rx_data_0[0] = rx_core_data_s[ 3];

  // transmit (by definition, tx_core_clk and clk are the same (shared pll))
  // however, we safe guard transition - incase you keep them separate

  assign tx_clk_out_n = 1'd0;
  assign tx_frame_out_n = 1'd0;
  assign tx_data_out_n = 6'd0;

  always @(negedge clk) begin
    tx_core_enable_int <= tx_enable;
    tx_core_txnrx_int <= tx_txnrx;
    tx_core_data_int[24] <= tx_frame[3];
    tx_core_data_int[25] <= tx_frame[2];
    tx_core_data_int[26] <= tx_frame[1];
    tx_core_data_int[27] <= tx_frame[0];
    tx_core_data_int[20] <= tx_data_3[5];
    tx_core_data_int[16] <= tx_data_3[4];
    tx_core_data_int[12] <= tx_data_3[3];
    tx_core_data_int[ 8] <= tx_data_3[2];
    tx_core_data_int[ 4] <= tx_data_3[1];
    tx_core_data_int[ 0] <= tx_data_3[0];
    tx_core_data_int[21] <= tx_data_2[5];
    tx_core_data_int[17] <= tx_data_2[4];
    tx_core_data_int[13] <= tx_data_2[3];
    tx_core_data_int[ 9] <= tx_data_2[2];
    tx_core_data_int[ 5] <= tx_data_2[1];
    tx_core_data_int[ 1] <= tx_data_2[0];
    tx_core_data_int[22] <= tx_data_1[5];
    tx_core_data_int[18] <= tx_data_1[4];
    tx_core_data_int[14] <= tx_data_1[3];
    tx_core_data_int[10] <= tx_data_1[2];
    tx_core_data_int[ 6] <= tx_data_1[1];
    tx_core_data_int[ 2] <= tx_data_1[0];
    tx_core_data_int[23] <= tx_data_0[5];
    tx_core_data_int[19] <= tx_data_0[4];
    tx_core_data_int[15] <= tx_data_0[3];
    tx_core_data_int[11] <= tx_data_0[2];
    tx_core_data_int[ 7] <= tx_data_0[1];
    tx_core_data_int[ 3] <= tx_data_0[0];
  end

  always @(posedge tx_core_clk) begin
    tx_core_enable <= tx_core_enable_int;
    tx_core_txnrx <= tx_core_txnrx_int;
    tx_core_data <= tx_core_data_int;
  end

  always @(negedge tx_core_clk) begin
    tx_locked_int <= tx_locked_s;
  end

  always @(posedge clk) begin
    tx_locked <= tx_locked_int;
  end

  // instantiations

  altlvds_rx #(
    .buffer_implementation ("RAM"),
    .cds_mode ("UNUSED"),
    .common_rx_tx_pll ("ON"),
    .data_align_rollover (4),
    .data_rate ("500.0 Mbps"),
    .deserialization_factor (4),
    .dpa_initial_phase_value (0),
    .dpll_lock_count (0),
    .dpll_lock_window (0),
    .enable_clock_pin_mode ("UNUSED"),
    .enable_dpa_align_to_rising_edge_only ("OFF"),
    .enable_dpa_calibration ("ON"),
    .enable_dpa_fifo ("UNUSED"),
    .enable_dpa_initial_phase_selection ("OFF"),
    .enable_dpa_mode ("OFF"),
    .enable_dpa_pll_calibration ("OFF"),
    .enable_soft_cdr_mode ("OFF"),
    .implement_in_les ("OFF"),
    .inclock_boost (0),
    .inclock_data_alignment ("EDGE_ALIGNED"),
    .inclock_period (4000),
    .inclock_phase_shift (0),
    .input_data_rate (500),
    .intended_device_family ("Cyclone V"),
    .lose_lock_on_one_change ("UNUSED"),
    .lpm_hint ("CBX_MODULE_PREFIX=axi_ad9361_lvds_if_c5_rx"),
    .lpm_type ("altlvds_rx"),
    .number_of_channels (7),
    .outclock_resource ("Global clock"),
    .pll_operation_mode ("NORMAL"),
    .pll_self_reset_on_loss_lock ("UNUSED"),
    .port_rx_channel_data_align ("PORT_UNUSED"),
    .port_rx_data_align ("PORT_UNUSED"),
    .refclk_frequency ("250.000000 MHz"),
    .registered_data_align_input ("UNUSED"),
    .registered_output ("ON"),
    .reset_fifo_at_first_lock ("UNUSED"),
    .rx_align_data_reg ("RISING_EDGE"),
    .sim_dpa_is_negative_ppm_drift ("OFF"),
    .sim_dpa_net_ppm_variation (0),
    .sim_dpa_output_clock_phase_shift (0),
    .use_coreclock_input ("OFF"),
    .use_dpll_rawperror ("OFF"),
    .use_external_pll ("OFF"),
    .use_no_phase_shift ("ON"),
    .x_on_bitslip ("ON"),
    .clk_src_is_pll ("off"))
  i_altlvds_rx (
    .pll_areset (pll_rst),
    .rx_in ({rx_frame_in_p, rx_data_in_p}),
    .rx_inclock (rx_clk_in_p),
    .rx_locked (rx_locked_s),
    .rx_out (rx_core_data_s),
    .rx_outclock (clk),
    .dpa_pll_cal_busy (),
    .dpa_pll_recal (1'b0),
    .pll_phasecounterselect (),
    .pll_phasedone (1'b1),
    .pll_phasestep (),
    .pll_phaseupdown (),
    .pll_scanclk (),
    .rx_cda_max (),
    .rx_cda_reset ({7{1'b0}}),
    .rx_channel_data_align ({7{1'b0}}),
    .rx_coreclk ({7{1'b1}}),
    .rx_data_align (1'b0),
    .rx_data_align_reset (1'b0),
    .rx_data_reset (1'b0),
    .rx_deskew (1'b0),
    .rx_divfwdclk (),
    .rx_dpa_lock_reset ({7{1'b0}}),
    .rx_dpa_locked (),
    .rx_dpaclock (1'b0),
    .rx_dpll_enable ({7{1'b1}}),
    .rx_dpll_hold ({7{1'b0}}),
    .rx_dpll_reset ({7{1'b0}}),
    .rx_enable (1'b1),
    .rx_fifo_reset ({7{1'b0}}),
    .rx_pll_enable (1'b1),
    .rx_readclock (1'b0),
    .rx_reset ({7{1'b0}}),
    .rx_syncclock (1'b0));

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
    .lpm_hint ("CBX_MODULE_PREFIX=axi_ad9361_lvds_if_c5_tx"),
    .lpm_type ("altlvds_tx"),
    .multi_clock ("OFF"),
    .number_of_channels (7),
    .outclock_alignment ("EDGE_ALIGNED"),
    .outclock_divide_by (2),
    .outclock_duty_cycle (50),
    .outclock_multiply_by (1),
    .outclock_phase_shift (0),
    .outclock_resource ("Global clock"),
    .output_data_rate (500),
    .pll_compensation_mode ("AUTO"),
    .pll_self_reset_on_loss_lock ("OFF"),
    .preemphasis_setting (0),
    .refclk_frequency ("250.000000 MHz"),
    .registered_input ("TX_CORECLK"),
    .use_external_pll ("OFF"),
    .use_no_phase_shift ("ON"),
    .vod_setting (0),
    .clk_src_is_pll ("off"))
  i_altlvds_tx (
    .pll_areset (pll_rst),
    .tx_in (tx_core_data),
    .tx_inclock (rx_clk_in_p),
    .tx_coreclock (tx_core_clk),
    .tx_locked (tx_locked_s),
    .tx_out ({tx_frame_out_p, tx_data_out_p}),
    .tx_outclock (tx_clk_out_p),
    .sync_inclock (1'b0),
    .tx_data_reset (1'b0),
    .tx_enable (1'b1),
    .tx_pll_enable (1'b1),
    .tx_syncclock (1'b0));

  altddio_out #(
    .extend_oe_disable ("OFF"),
    .intended_device_family ("Cyclone V"),
    .invert_output ("OFF"),
    .lpm_hint ("UNUSED"),
    .lpm_type ("altddio_out"),
    .oe_reg ("UNREGISTERED"),
    .power_up_high ("OFF"),
    .width (1))
  i_altddio_enable (
    .datain_h (tx_core_enable),
    .datain_l (tx_core_enable),
    .outclock (tx_core_clk),
    .dataout (enable),
    .aclr (1'b0),
    .aset (1'b0),
    .oe (1'b1),
    .oe_out (),
    .outclocken (1'b1),
    .sclr (1'b0),
    .sset (1'b0));

  altddio_out #(
    .extend_oe_disable ("OFF"),
    .intended_device_family ("Cyclone V"),
    .invert_output ("OFF"),
    .lpm_hint ("UNUSED"),
    .lpm_type ("altddio_out"),
    .oe_reg ("UNREGISTERED"),
    .power_up_high ("OFF"),
    .width (1))
  i_altddio_txnrx (
    .datain_h (tx_core_txnrx),
    .datain_l (tx_core_txnrx),
    .outclock (tx_core_clk),
    .dataout (txnrx),
    .aclr (1'b0),
    .aset (1'b0),
    .oe (1'b1),
    .oe_out (),
    .outclocken (1'b1),
    .sclr (1'b0),
    .sset (1'b0));

endmodule
