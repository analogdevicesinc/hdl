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

// A simple edge detector circuit

`timescale 1ns/100ps

module ad_edge_detect #(

  parameter   EDGE = 0) (

  input                   clk,
  input                   rst,

  input                   in,
  output  reg             out);


  localparam  POS_EDGE = 0;
  localparam  NEG_EDGE = 1;
  localparam  ANY_EDGE = 2;

  reg         ff_m1 = 0;
  reg         ff_m2 = 0;

  always @(posedge clk) begin
    if (rst == 1) begin
      ff_m1 <= 0;
      ff_m2 <= 0;
    end else begin
      ff_m1 <= in;
      ff_m2 <= ff_m1;
    end
  end

  always @(posedge clk) begin
    if (rst == 1) begin
      out <= 1'b0;
    end else begin
      if (EDGE == POS_EDGE) begin
        out <= ff_m1 & ~ff_m2;
      end else if (EDGE == NEG_EDGE) begin
        out <= ~ff_m1 & ff_m2;
      end else begin
        out <= ff_m1 ^ ff_m2;
      end
    end
  end

endmodule

