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

`timescale 1ps/1ps

module ad_mul #(

  parameter   DELAY_DATA_WIDTH = 16) (

  // data_p = data_a * data_b;

  input                   clk,
  input       [16:0]      data_a,
  input       [16:0]      data_b,
  output      [33:0]      data_p,

  // delay interface

  input       [(DELAY_DATA_WIDTH-1):0]  ddata_in,
  output  reg [(DELAY_DATA_WIDTH-1):0]  ddata_out);


  // internal registers

  reg     [(DELAY_DATA_WIDTH-1):0]    p1_ddata = 'd0;
  reg     [(DELAY_DATA_WIDTH-1):0]    p2_ddata = 'd0;

  // a/b reg, m-reg, p-reg delay match

  always @(posedge clk) begin
    p1_ddata <= ddata_in;
    p2_ddata <= p1_ddata;
    ddata_out <= p2_ddata;
  end

  lpm_mult #(
    .lpm_type ("lpm_mult"),
    .lpm_widtha (17),
    .lpm_widthb (17),
    .lpm_widthp (34),
    .lpm_representation ("SIGNED"),
    .lpm_pipeline (3))
  i_lpm_mult (
    .clken (1'b1),
    .aclr (1'b0),
    .sum (1'b0),
    .clock (clk),
    .dataa (data_a),
    .datab (data_b),
    .result (data_p));

endmodule

// ***************************************************************************
// ***************************************************************************
