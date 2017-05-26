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

module axi_ad9361_serdes_out #(

  parameter   DEVICE_TYPE = 0,
  parameter   DATA_WIDTH = 16) (

  // reset and clocks

  input                           clk,
  input                           div_clk,
  input                           loaden,
                                  
  // data interface               
                                  
  input   [(DATA_WIDTH-1):0]      data_s0,
  input   [(DATA_WIDTH-1):0]      data_s1,
  input   [(DATA_WIDTH-1):0]      data_s2,
  input   [(DATA_WIDTH-1):0]      data_s3,
  output  [(DATA_WIDTH-1):0]      data_out_p,
  output  [(DATA_WIDTH-1):0]      data_out_n);

  // local parameter

  localparam ARRIA10 = 0;
  localparam CYCLONE5 = 1;

  // internal signals

  wire    [ 3:0]                  data_in_s[0:(DATA_WIDTH-1)];

  // defaults

  assign data_out_n = 'd0;

  // instantiations

  genvar n;

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_data

  assign data_in_s[n][3] = data_s0[n];
  assign data_in_s[n][2] = data_s1[n];
  assign data_in_s[n][1] = data_s2[n];
  assign data_in_s[n][0] = data_s3[n];

  if (DEVICE_TYPE == CYCLONE5) begin
  altlvds_tx #(
    .center_align_msb ("UNUSED"),
    .common_rx_tx_pll ("OFF"),
    .coreclock_divide_by (1),
    .data_rate ("800.0 Mbps"),
    .deserialization_factor (4),
    .differential_drive (0),
    .enable_clock_pin_mode ("UNUSED"),
    .implement_in_les ("OFF"),
    .inclock_boost (0),
    .inclock_data_alignment ("EDGE_ALIGNED"),
    .inclock_period (50000),
    .inclock_phase_shift (0),
    .intended_device_family ("Cyclone V"),
    .lpm_hint ("CBX_MODULE_PREFIX=axi_ad9361_serdes_out"),
    .lpm_type ("altlvds_tx"),
    .multi_clock ("OFF"),
    .number_of_channels (1),
    .outclock_alignment ("EDGE_ALIGNED"),
    .outclock_divide_by (1),
    .outclock_duty_cycle (50),
    .outclock_multiply_by (1),
    .outclock_phase_shift (0),
    .outclock_resource ("Dual-Regional clock"),
    .output_data_rate (800),
    .pll_compensation_mode ("AUTO"),
    .pll_self_reset_on_loss_lock ("OFF"),
    .preemphasis_setting (0),
    .refclk_frequency ("20.000000 MHz"),
    .registered_input ("OFF"),
    .use_external_pll ("ON"),
    .use_no_phase_shift ("ON"),
    .vod_setting (0),
    .clk_src_is_pll ("off"))
  i_altlvds_tx (
    .tx_enable (loaden),
    .tx_in (data_in_s[n]),
    .tx_inclock (clk),
    .tx_out (data_out_p[n]),
    .pll_areset (1'b0),
    .sync_inclock (1'b0),
    .tx_coreclock (),
    .tx_data_reset (1'b0),
    .tx_locked (),
    .tx_outclock (),
    .tx_pll_enable (1'b1),
    .tx_syncclock (1'b0));
  end

  if (DEVICE_TYPE == ARRIA10) begin
  axi_ad9361_serdes_out_core i_core (
    .clk_export (clk),
    .div_clk_export (div_clk),
    .loaden_export (loaden),
    .data_out_export (data_out_p[n]),
    .data_s_export (data_in_s[n]));
  end

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

