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

module ad_dds_1 (

  // interface

  input                   clk,
  input       [15:0]      angle,
  input       [15:0]      scale,
  output  reg [15:0]      dds_data);

  // internal registers

  // internal signals

  wire    [15:0]  sine_s;
  wire    [33:0]  s1_data_s;

  // sine

  ad_dds_sine #(.DELAY_DATA_WIDTH(1)) i_dds_sine (
    .clk (clk),
    .angle (angle),
    .sine (sine_s),
    .ddata_in (1'b0),
    .ddata_out ());

  // scale

  ad_mul #(.DELAY_DATA_WIDTH(1)) i_dds_scale (
    .clk (clk),
    .data_a ({sine_s[15], sine_s}),
    .data_b ({scale[15], scale}),
    .data_p (s1_data_s),
    .ddata_in (1'b0),
    .ddata_out ());

  // dds data

  always @(posedge clk) begin
    dds_data <= s1_data_s[29:14];
  end

endmodule

// ***************************************************************************
// ***************************************************************************
