// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
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

  // Supported divider values for the Microchip ICB_CLKDIV primitive:
  // 1.0 -> 3'b001
  // 2.0 -> 3'b010
  // 3.5 -> 3'b011
  // 4.0 -> 3'b100
  // 5.0 -> 3'b101
  parameter [2:0] SEL_0_DIV = 3'b100;
  parameter [2:0] SEL_1_DIV = 3'b010;

  wire clk_div_sel_0_s;
  wire clk_div_sel_1_s;
  wire clk_mux_s;

  ICB_CLKDIV #(
    .DIVIDER(SEL_0_DIV)
  ) i_clk_divide_sel_0 (
    .RST_N(1'b1),
    .BIT_SLIP(1'b0),
    .A(clk),
    .Y_DIV(clk_div_sel_0_s)
  );

  ICB_CLKDIV #(
    .DIVIDER(SEL_1_DIV)
  ) i_clk_divide_sel_1 (
    .RST_N(1'b1),
    .BIT_SLIP(1'b0),
    .A(clk),
    .Y_DIV(clk_div_sel_1_s)
  );

  ICB_NGMUX #(
    .NGMUX_MODE(1'b0)
  ) i_div_clk_mux (
    .SEL(clk_sel),
    .CLK0(clk_div_sel_0_s),
    .CLK1(clk_div_sel_1_s),
    .Y(clk_mux_s)
  );

  CLKINT i_div_clk_clkint (
    .A(clk_mux_s),
    .Y(clk_out)
  );

endmodule
