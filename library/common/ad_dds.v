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

`timescale 1ns/100ps

module ad_dds #(

  // data path disable

  parameter   DISABLE = 0) (

  // interface

  input           clk,
  input           dds_format,
  input   [15:0]  dds_phase_0,
  input   [15:0]  dds_scale_0,
  input   [15:0]  dds_phase_1,
  input   [15:0]  dds_scale_1,
  output  [15:0]  dds_data);

  // internal registers

  reg     [15:0]  dds_data_int = 'd0;
  reg     [15:0]  dds_data_out = 'd0;
  reg     [15:0]  dds_scale_0_d = 'd0;
  reg     [15:0]  dds_scale_1_d = 'd0;

  // internal signals

  wire    [15:0]  dds_data_0_s;
  wire    [15:0]  dds_data_1_s;

  // disable

  assign dds_data = (DISABLE == 1) ? 16'd0 : dds_data_out;

  // dds channel output

  always @(posedge clk) begin
    dds_data_int <= dds_data_0_s + dds_data_1_s;
    dds_data_out[15:15] <= dds_data_int[15] ^ dds_format;
    dds_data_out[14: 0] <= dds_data_int[14:0];
  end

  always @(posedge clk) begin
    dds_scale_0_d <= dds_scale_0;
    dds_scale_1_d <= dds_scale_1;
  end
  // dds-1

  ad_dds_1 i_dds_1_0 (
    .clk (clk),
    .angle (dds_phase_0),
    .scale (dds_scale_0_d),
    .dds_data (dds_data_0_s));

  // dds-2

  ad_dds_1 i_dds_1_1 (
    .clk (clk),
    .angle (dds_phase_1),
    .scale (dds_scale_1_d),
    .dds_data (dds_data_1_s));

endmodule

// ***************************************************************************
// ***************************************************************************
