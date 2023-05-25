// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
/**
 * Async I3C: Divides the input clock by 1 (sel=1) or 2 (sel=0).
 * Sync I3C: Divides the input clock by 8 (sel=1) or 4 (sel=0).
 * Multipath constraints should be tuned.
 */

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_clk_div #(
  parameter ASYNC_CLK = 0
) (
  input  wire reset_n,
  input  wire sel,
  input  wire clr,
  input  wire cmd_ready,
  input  wire clk,
  input  wire clk_bus,
  output wire clk_out
  );

  reg [1:0] sel_reg;
  always @(posedge clk) begin
    if (clr) begin
      sel_reg <= 2'b00;
    end else if (cmd_ready) begin
      sel_reg <= {sel_reg[0], sel};
    end
  end

  generate if (ASYNC_CLK) begin
    BUFGMUX #(
    ) i_BUFGMUX (
       .O(clk_out),
       .I0(clk_bus),
       .I1(clk),
       .S(sel_reg)
    );
  end
  endgenerate

  generate if (!ASYNC_CLK) begin
    reg [2:0] clk_reg;
      always @(posedge clk) begin
      if (!reset_n) begin
        clk_reg <= 5'd0;
      end else begin
        clk_reg <= clk_reg + 1;
      end
    end
    assign clk_out = sel_reg[1] ? clk_reg[1] : clk_reg[2];
  end
  endgenerate

endmodule
