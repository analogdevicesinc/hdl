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
// Transmit HDMI, RGB to CrYCb conversion
// The multiplication coefficients are in 1.4.12 format
// The addition coefficients are in 1.12.12 format
// Cr = (+112.439/256)*R + (-094.154/256)*G + (-018.285/256)*B + 128;
// Y  = (+065.738/256)*R + (+129.057/256)*G + (+025.064/256)*B +  16;
// Cb = (-037.945/256)*R + (-074.494/256)*G + (+112.439/256)*B + 128;

`timescale 1ns/100ps

module ad_csc_RGB2CrYCb #(

  parameter   DELAY_DATA_WIDTH = 16) (

  // R-G-B inputs

  input                   clk,
  input       [DW:0]      RGB_sync,
  input       [23:0]      RGB_data,

  // Cr-Y-Cb outputs

  output      [DW:0]      CrYCb_sync,
  output      [23:0]      CrYCb_data);

  localparam  DW = DELAY_DATA_WIDTH - 1;

  // Cr (red-diff)

  ad_csc_1 #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH)) i_csc_1_Cr (
    .clk (clk),
    .sync (RGB_sync),
    .data (RGB_data),
    .C1 (17'h00707),
    .C2 (17'h105e2),
    .C3 (17'h10124),
    .C4 (25'h0080000),
    .csc_sync_1 (CrYCb_sync),
    .csc_data_1 (CrYCb_data[23:16]));

  // Y (luma)

  ad_csc_1 #(.DELAY_DATA_WIDTH(1)) i_csc_1_Y (
    .clk (clk),
    .sync (1'd0),
    .data (RGB_data),
    .C1 (17'h0041b),
    .C2 (17'h00810),
    .C3 (17'h00191),
    .C4 (25'h0010000),
    .csc_sync_1 (),
    .csc_data_1 (CrYCb_data[15:8]));

  // Cb (blue-diff)

  ad_csc_1 #(.DELAY_DATA_WIDTH(1)) i_csc_1_Cb (
    .clk (clk),
    .sync (1'd0),
    .data (RGB_data),
    .C1 (17'h1025f),
    .C2 (17'h104a7),
    .C3 (17'h00707),
    .C4 (25'h0080000),
    .csc_sync_1 (),
    .csc_data_1 (CrYCb_data[7:0]));

endmodule

// ***************************************************************************
// ***************************************************************************
