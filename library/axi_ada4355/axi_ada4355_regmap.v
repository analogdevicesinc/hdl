// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns / 1ps

module axi_ada4355_regmap (

  // processor interface

  input             up_rstn,
  input             up_clk,
  input             up_wreq,
  input      [13:0] up_waddr,
  input      [31:0] up_wdata,
  output reg        up_wack,
  input             up_rreq,
  input      [13:0] up_raddr,
  output reg [31:0] up_rdata,
  output reg        up_rack,
  input             clk_div,
  output     [ 2:0] enable_error_sync,
  input             adc_rst
);

  // internal registers

  reg [ 2:0]  up_enable_error = 'd0;

  // processor write interface

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_enable_error <= 'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h32)) begin
        up_enable_error <= up_wdata[2:0];
      end
    end
  end

  // processor read interface

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          7'h32: up_rdata <= {29'd0, up_enable_error};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS (3),
    .ASYNC_CLK (1)
  ) i_enable_sync (
    .in_bits (up_enable_error[2:0]),
    .out_resetn (~adc_rst),
    .out_clk (clk_div),
    .out_bits (enable_error_sync));

endmodule
