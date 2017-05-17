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

// A simple adder/substracter width preconfigured input ports width and turn-around value
// Output = A - B_constant or A + B_constant
// Constraints: Awidth >= Bwidth

`timescale 1ns/1ps

module ad_addsub #(

  parameter   A_DATA_WIDTH = 32,
  parameter   B_DATA_VALUE = 32'h1,
  parameter   ADD_OR_SUB_N = 0) (
  input                   clk,
  input       [(A_DATA_WIDTH-1):0]  A,
  input       [(A_DATA_WIDTH-1):0]  Amax,
  output  reg [(A_DATA_WIDTH-1):0]  out,
  input                   CE);


  localparam  ADDER = 1;
  localparam  SUBSTRACTER = 0;

  // registers

  reg     [A_DATA_WIDTH:0]       out_d = 'b0;
  reg     [A_DATA_WIDTH:0]       out_d2 = 'b0;
  reg     [(A_DATA_WIDTH-1):0]   A_d = 'b0;
  reg     [(A_DATA_WIDTH-1):0]   A_d2 = 'b0;
  reg     [(A_DATA_WIDTH-1):0]   Amax_d = 'b0;
  reg     [(A_DATA_WIDTH-1):0]   Amax_d2 = 'b0;

  // constant regs

  reg     [(A_DATA_WIDTH-1):0]   B_reg = B_DATA_VALUE;

  // latch the inputs

  always @(posedge clk) begin
      A_d <= A;
      A_d2 <= A_d;
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
