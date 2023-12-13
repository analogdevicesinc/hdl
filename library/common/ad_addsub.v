// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
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

// A simple adder/substracter width preconfigured input ports width and turn-around value
// Output = A - B_constant or A + B_constant
// Constraints: Awidth >= Bwidth

`timescale 1ns/1ps

module ad_addsub #(

  parameter   A_DATA_WIDTH = 32,
  parameter   B_DATA_VALUE = 32'h1,
  parameter   ADD_OR_SUB_N = 0
) (
  input                   clk,
  input       [(A_DATA_WIDTH-1):0]  A,
  input       [(A_DATA_WIDTH-1):0]  Amax,
  output  reg [(A_DATA_WIDTH-1):0]  out,
  input                   CE
);

  localparam  ADDER = 1;
  localparam  SUBSTRACTER = 0;

  // registers

  reg     [A_DATA_WIDTH:0]       out_d = 'b0;
  reg     [A_DATA_WIDTH:0]       out_d2 = 'b0;
  reg     [(A_DATA_WIDTH-1):0]   A_d = 'b0;
  reg     [(A_DATA_WIDTH-1):0]   Amax_d = 'b0;
  reg     [(A_DATA_WIDTH-1):0]   Amax_d2 = 'b0;

  // constant regs

  reg     [(A_DATA_WIDTH-1):0]   B_reg = B_DATA_VALUE;

  // latch the inputs

  always @(posedge clk) begin
      A_d <= A;
      Amax_d <= Amax;
      Amax_d2 <= Amax_d;
  end

  // ADDER/SUBSTRACTER

  always @(posedge clk) begin
    if ( ADD_OR_SUB_N == ADDER ) begin
      out_d <= A_d + B_reg;
    end else begin
      out_d <= A_d - B_reg;
    end
  end

  // Resolve

  always @(posedge clk) begin
    if ( ADD_OR_SUB_N == ADDER ) begin
      if ( out_d > Amax_d2 ) begin
        out_d2 <= out_d - Amax_d2;
      end else begin
        out_d2 <= out_d;
      end
    end else begin // SUBSTRACTER
      if ( out_d[A_DATA_WIDTH] == 1'b1 ) begin
        out_d2 <= Amax_d2 + out_d;
      end else begin
        out_d2 <= out_d;
      end
    end
  end

  // output logic

  always @(posedge clk) begin
    if ( CE ) begin
      out <= out_d2;
    end else begin
      out <= 'b0;
    end
  end

endmodule
