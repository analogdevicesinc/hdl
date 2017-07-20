// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// Divides the input clock to SEL_0_DIV if clk_sel is 0 or SEL_1_DIV if
// clk_sel is 1. Provides a glitch free output clock
// IP uses BUFR/BUFGCE_DIV and BUFGMUX_CTRL primitives
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

