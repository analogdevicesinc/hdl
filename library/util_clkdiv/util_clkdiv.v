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

module util_clkdiv (
  input   clk,
  input   clk_sel,
  output  clk_out
 );

parameter SIM_DEVICE = "7SERIES";
parameter SEL_0_DIV = "4";
parameter SEL_1_DIV = "2";

  wire clk_div_sel_0_s;
  wire clk_div_sel_1_s;

generate if (SIM_DEVICE == "7SERIES") begin

  BUFR #(
    .BUFR_DIVIDE(SEL_0_DIV),
    .SIM_DEVICE("7SERIES")
  ) clk_divide_sel_0 (
    .I(clk),
    .CE(1),
    .CLR(0),
    .O(clk_div_sel_0_s));

  BUFR #(
    .BUFR_DIVIDE(SEL_1_DIV),
    .SIM_DEVICE("7SERIES")
  ) clk_divide_sel_1 (
    .I(clk),
    .CE(1),
    .CLR(0),
    .O(clk_div_sel_1_s));

end else if (SIM_DEVICE == "ULTRASCALE") begin

  BUFGCE_DIV #(
    .BUFGCE_DIVIDE(SEL_0_DIV)
  ) clk_divide_sel_0 (
    .I(clk),
    .CE(1),
    .CLR(0),
    .O(clk_div_sel_0_s));

  BUFGCE_DIV #(
    .BUFGCE_DIVIDE(SEL_1_DIV)
  ) clk_divide_sel_1 (
    .I(clk),
    .CE(1),
    .CLR(0),
    .O(clk_div_sel_1_s));

end endgenerate

  BUFGMUX_CTRL i_div_clk_gbuf (
    .I0(clk_div_sel_0_s), // 1-bit input: Clock input (S=0)
    .I1(clk_div_sel_1_s), // 1-bit input: Clock input (S=1)
    .S(clk_sel),
    .O (clk_out));

endmodule  // util_clkdiv

