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

module ad_dds #(

  // data path disable

  parameter   DISABLE = 0,
  parameter   DDS_TYPE = 1,
  parameter   CORDIC_DW = 14) (

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

  generate
    if (DISABLE == 1) begin
      assign dds_data = 16'd0;
    end else begin

      assign dds_data = dds_data_out;

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

       ad_dds_1 #(
         .CORDIC_DW(CORDIC_DW),
         .DDS_TYPE(DDS_TYPE))
       i_dds_1_0 (
         .clk (clk),
         .angle (dds_phase_0),
         .scale (dds_scale_0_d),
         .dds_data (dds_data_0_s));

       // dds-2

       ad_dds_1 #(
         .CORDIC_DW(CORDIC_DW),
         .DDS_TYPE(DDS_TYPE))
       i_dds_1_1 (
         .clk (clk),
         .angle (dds_phase_1),
         .scale (dds_scale_1_d),
         .dds_data (dds_data_1_s));
    end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
