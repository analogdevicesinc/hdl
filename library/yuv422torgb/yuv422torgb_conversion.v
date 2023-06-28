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
// YUV 4:2:2 to RGB conversion
// The multiplication coefficients are in 1.2.15 format
// The addition coefficients are in 1.?.15 format
// R =        0 * U + Y +   1.13983 * V;
// G = -0.39465 * U + Y +  -0.58060 * V;
// B =  2.03211 * U + Y +         0 * V;


`timescale 1ns/100ps

module yuv422torgb_conversion (

  // Y-U-V inputs

  input              clk,
  input              YUV_sync,
  input       [23:0] YUV_data,

  // R-G-B outputs

  output             RGB_sync,
  output      [23:0] RGB_data
);

  // red

  ad_csc  #(
    .DELAY_DW (1),
    .MUL_COEF_DW (18),
    .SUM_COEF_DW (28),
    .YCbCr_2_RGB (0)
  ) i_csc_R (
    .clk (clk),
    .sync (YUV_sync),
    .data (YUV_data),
    .C1 (18'd0),     
    .C2 (18'd32768), 
    .C3 (18'd37349),     
    .C4 (28'd0),     
    .csc_sync (RGB_sync),
    .csc_data (RGB_data[23:16]));

  // green

  ad_csc  #(
    .MUL_COEF_DW (18),
    .SUM_COEF_DW (28),
    .YCbCr_2_RGB (0)
  ) i_csc_G (
    .clk (clk),
    .sync (16'b0),
    .data (YUV_data),
    .C1 (18'd12931),   
    .C2 (18'd32768),  
    .C3 (18'd19025),  
    .C4 (28'd0),      
    .csc_sync (),
    .csc_data (RGB_data[15:8]));

  // blue

  ad_csc #(
    .MUL_COEF_DW (18),
    .SUM_COEF_DW (28),
    .YCbCr_2_RGB (0)
  ) i_csc_B (
    .clk (clk),
    .sync (16'd0),
    .data (YUV_data),
    .C1 (18'd99356), 
    .C2 (18'd32768), 
    .C3 (18'd0),     
    .C4 (28'd0),     
    .csc_sync (),
    .csc_data (RGB_data[7:0]));

endmodule