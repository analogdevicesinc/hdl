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

// Divides the input clock to SEL_0_DIV if clk_sel is 0 or SEL_1_DIV if
// clk_sel is 1. Provides a glitch free output clock
// IP uses BUFR/BUFGCE_DIV and BUFGMUX_CTRL primitives

module util_clkdiv #(
  parameter SIM_DEVICE = "CYCLONE5",
  parameter CLOCK_TYPE = "Global Clock") (

  input   clk,
  input   reset,
  output  clk_out,
  output  reset_out
 );

reg enable;
reg reset_d1;

assign reset_out = reset | reset_d1;

always @(posedge clk) begin
  reset_d1 <= reset;
end

always @(posedge clk) begin
  enable <= ~enable;
end

generate if (SIM_DEVICE == "CYCLONE5") begin
	cyclonev_clkena #(
		.clock_type ("Global Clock"),
		.ena_register_mode ("falling edge"),
		.lpm_type ("cyclonev_clkena")
  ) clock_divider_by_2 (
	.ena(enable),
	.enaout(),
	.inclk(clk),
//	.clkselect (2'b0),
	.outclk(clk_out));

end endgenerate

endmodule  // util_clkdiv
