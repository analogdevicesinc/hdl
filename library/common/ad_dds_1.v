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
