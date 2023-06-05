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
 * Async I3C:
 * Select clock clk_1/2 (sel=0) or clk_0/1 (sel=1) output.
 * Sync I3C:
 * Select clock clk_0/32 (sel=0) or clk_0/8 (sel=1) output.
 */

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_clk_div #(
  parameter ASYNC_CLK = 0
) (
  input  wire reset_n,
  input  wire sel,
  input  wire cmd_ready,
  input  wire clk_0,
  input  wire clk_1,
  output wire clk_out
  );
  wire clk_0_w;
  wire clk_1_w;

  generate if (ASYNC_CLK) begin
    reg [0:0] clk_2;
    always @(posedge clk_1) begin
      if (!reset_n) begin
        clk_2 <= 1'd0;
      end else begin
        clk_2 <= ~clk_2;
      end
    end
    assign clk_0_w = clk_0;
    assign clk_1_w = clk_2;
  end
  endgenerate

  generate if (!ASYNC_CLK) begin
    reg [4:0] clk_reg;
      always @(posedge clk_0) begin
      if (!reset_n) begin
        clk_reg <= 5'd0;
      end else begin
        clk_reg <= clk_reg + 1;
      end
    end
    assign clk_0_w = clk_reg[1];
    assign clk_1_w = clk_reg[4];
  end
  endgenerate

  BUFGMUX #(
  ) i_BUFGMUX (
     .O(clk_out),
     .I0(clk_1_w),
     .I1(clk_0_w),
     .S(sel)
  );

endmodule
