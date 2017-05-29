// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory of
//      the repository (LICENSE_GPL2), and at: <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_cmos_clk #(

  parameter   DEVICE_TYPE   = 0) (

  input                   rst,
  output                  locked,

  input                   clk_in,
  output                  clk);


  // instantiations

  generate
  if (DEVICE_TYPE == 0) begin
  alt_clk i_clk (
    .rst (rst),
    .refclk (clk_in),
    .outclk_0 (clk),
    .locked (locked));
  end
  endgenerate

  generate
  if (DEVICE_TYPE == 1) begin
  altera_pll #(
    .reference_clock_frequency("250.0 MHz"),
    .operation_mode("source synchronous"),
    .number_of_clocks(1),
    .output_clock_frequency0("0 MHz"),
    .phase_shift0("0"))
  i_clk (
    .rst (rst),
    .refclk (clk_in),
    .outclk (clk),
    .fboutclk (),
    .fbclk (1'b0),
    .locked (locked));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
