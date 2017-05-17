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

