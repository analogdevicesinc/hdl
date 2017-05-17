// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ps/1ps

module ad_serdes_out_core_c5 #(

  parameter       SERDES_FACTOR = 8) (

  input                           clk,
  input                           div_clk,
  input                           enable,
  output                          data_out,
  input   [(SERDES_FACTOR-1):0]   data);

  reg     [(SERDES_FACTOR-1):0]   data_int = 'd0;

  always @(posedge div_clk) begin
    data_int <= data;
  end

  altlvds_tx  i_altlvds_tx (
    .tx_enable (enable),
    .tx_in (data),
    .tx_inclock (clk),
    .tx_out (data_out),
    .pll_areset (1'b0),
    .sync_inclock (1'b0),
    .tx_coreclock (),
    .tx_data_reset (1'b0),
    .tx_locked (),
    .tx_outclock (),
    .tx_pll_enable (1'b1),
    .tx_syncclock (1'b0));
  defparam
    i_altlvds_tx.center_align_msb = "UNUSED",
    i_altlvds_tx.common_rx_tx_pll = "OFF",
    i_altlvds_tx.coreclock_divide_by = 1,
    i_altlvds_tx.data_rate = "800.0 Mbps",
    i_altlvds_tx.deserialization_factor = SERDES_FACTOR,
    i_altlvds_tx.differential_drive = 0,
    i_altlvds_tx.enable_clock_pin_mode = "UNUSED",
    i_altlvds_tx.implement_in_les = "OFF",
    i_altlvds_tx.inclock_boost = 0,
    i_altlvds_tx.inclock_data_alignment = "EDGE_ALIGNED",
    i_altlvds_tx.inclock_period = 50000,
    i_altlvds_tx.inclock_phase_shift = 0,
    i_altlvds_tx.intended_device_family = "Cyclone V",
    i_altlvds_tx.lpm_hint = "CBX_MODULE_PREFIX=ad_serdes_out_core_c5",
    i_altlvds_tx.lpm_type = "altlvds_tx",
    i_altlvds_tx.multi_clock = "OFF",
    i_altlvds_tx.number_of_channels = 1,
    i_altlvds_tx.outclock_alignment = "EDGE_ALIGNED",
    i_altlvds_tx.outclock_divide_by = 1,
    i_altlvds_tx.outclock_duty_cycle = 50,
    i_altlvds_tx.outclock_multiply_by = 1,
    i_altlvds_tx.outclock_phase_shift = 0,
    i_altlvds_tx.outclock_resource = "Dual-Regional clock",
    i_altlvds_tx.output_data_rate = 800,
    i_altlvds_tx.pll_compensation_mode = "AUTO",
    i_altlvds_tx.pll_self_reset_on_loss_lock = "OFF",
    i_altlvds_tx.preemphasis_setting = 0,
    i_altlvds_tx.refclk_frequency = "20.000000 MHz",
    i_altlvds_tx.registered_input = "OFF",
    i_altlvds_tx.use_external_pll = "ON",
    i_altlvds_tx.use_no_phase_shift = "ON",
    i_altlvds_tx.vod_setting = 0,
    i_altlvds_tx.clk_src_is_pll = "off";

endmodule

// ***************************************************************************
// ***************************************************************************
