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
// freedoms and responsabilities that he or she has by using this source/core.
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

`timescale 1ps/1ps

module axi_ad9361_serdes_in #(

  // parameters

  parameter   DEVICE_TYPE = 0,
  parameter   DATA_WIDTH = 16) (

  // reset and clocks

  input                           clk,
  input                           div_clk,
  input                           loaden,
  input   [ 7:0]                  phase,
  input                           locked,

  // data interface

  output  [(DATA_WIDTH-1):0]      data_s0,
  output  [(DATA_WIDTH-1):0]      data_s1,
  output  [(DATA_WIDTH-1):0]      data_s2,
  output  [(DATA_WIDTH-1):0]      data_s3,
  input   [(DATA_WIDTH-1):0]      data_in_p,
  input   [(DATA_WIDTH-1):0]      data_in_n,

  // delay-control interface

  output                          delay_locked);

  // local parameter

  localparam ARRIA10 = 0;
  localparam CYCLONE5 = 1;

  // internal signals

  wire    [(DATA_WIDTH-1):0]      delay_locked_s;
  wire    [(DATA_WIDTH-1):0]      data_samples_s[0:3];
  wire    [ 3:0]                  data_out_s[0:(DATA_WIDTH-1)];

  // assignments

  assign delay_locked = & delay_locked_s;
  assign data_s3 = data_samples_s[3];
  assign data_s2 = data_samples_s[2];
  assign data_s1 = data_samples_s[1];
  assign data_s0 = data_samples_s[0];

  genvar n;
  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_data

  assign data_samples_s[0][n] = data_out_s[n][0];
  assign data_samples_s[1][n] = data_out_s[n][1];
  assign data_samples_s[2][n] = data_out_s[n][2];
  assign data_samples_s[3][n] = data_out_s[n][3];

  if (DEVICE_TYPE == CYCLONE5) begin
  assign delay_locked_s[n] = 1'b1;
  altlvds_rx #(
    .buffer_implementation ("RAM"),
    .cds_mode ("UNUSED"),
    .common_rx_tx_pll ("OFF"),
    .data_align_rollover (4),
    .data_rate ("800.0 Mbps"),
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
    .inclock_period (50000),
    .inclock_phase_shift (0),
    .input_data_rate (800),
    .intended_device_family ("Cyclone V"),
    .lose_lock_on_one_change ("UNUSED"),
    .lpm_hint ("CBX_MODULE_PREFIX=axi_ad9361_serdes_in"),
    .lpm_type ("altlvds_rx"),
    .number_of_channels (1),
    .outclock_resource ("Dual-Regional clock"),
    .pll_operation_mode ("NORMAL"),
    .pll_self_reset_on_loss_lock ("UNUSED"),
    .port_rx_channel_data_align ("PORT_UNUSED"),
    .port_rx_data_align ("PORT_UNUSED"),
    .refclk_frequency ("20.000000 MHz"),
    .registered_data_align_input ("UNUSED"),
    .registered_output ("OFF"),
    .reset_fifo_at_first_lock ("UNUSED"),
    .rx_align_data_reg ("RISING_EDGE"),
    .sim_dpa_is_negative_ppm_drift ("OFF"),
    .sim_dpa_net_ppm_variation (0),
    .sim_dpa_output_clock_phase_shift (0),
    .use_coreclock_input ("OFF"),
    .use_dpll_rawperror ("OFF"),
    .use_external_pll ("ON"),
    .use_no_phase_shift ("ON"),
    .x_on_bitslip ("ON"),
    .clk_src_is_pll ("off"))
  i_altlvds_rx (
    .rx_enable (loaden),
    .rx_in (data_in_p[n]),
    .rx_inclock (clk),
    .rx_out (data_out_s[n]),
    .dpa_pll_cal_busy (),
    .dpa_pll_recal (1'b0),
    .pll_areset (1'b0),
    .pll_phasecounterselect (),
    .pll_phasedone (1'b1),
    .pll_phasestep (),
    .pll_phaseupdown (),
    .pll_scanclk (),
    .rx_cda_max (),
    .rx_cda_reset (1'b0),
    .rx_channel_data_align (1'b0),
    .rx_coreclk (1'b1),
    .rx_data_align (1'b0),
    .rx_data_align_reset (1'b0),
    .rx_data_reset (1'b0),
    .rx_deskew (1'b0),
    .rx_divfwdclk (),
    .rx_dpa_lock_reset (1'b0),
    .rx_dpa_locked (),
    .rx_dpaclock (1'b0),
    .rx_dpll_enable (1'b1),
    .rx_dpll_hold (1'b0),
    .rx_dpll_reset (1'b0),
    .rx_fifo_reset (1'b0),
    .rx_locked (),
    .rx_outclock (),
    .rx_pll_enable (1'b1),
    .rx_readclock (1'b0),
    .rx_reset (1'b0),
    .rx_syncclock (1'b0));
  end

  if (DEVICE_TYPE == ARRIA10) begin
  axi_ad9361_serdes_in_core i_core (
    .clk_export (clk),
    .div_clk_export (div_clk),
    .hs_phase_export (phase),
    .loaden_export (loaden),
    .locked_export (locked),
    .data_in_export (data_in_p[n]),
    .data_s_export (data_out_s[n]),
    .delay_locked_export (delay_locked_s[n]));
  end

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
