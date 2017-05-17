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
// dc filter- y(n) = c*x(n) + (1-c)*y(n-1)
// NOT IMPLEMENTED

`timescale 1ps/1ps

module ad_dcfilter #(

  // data path disable

  parameter   DISABLE = 0) (

  // data interface

  input               clk,
  input               valid,
  input       [15:0]  data,
  output reg          valid_out,
  output reg  [15:0]  data_out,

  // control interface

  input           dcfilt_enb,
  input   [15:0]  dcfilt_coeff,
  input   [15:0]  dcfilt_offset);

  // internal registers

  reg             valid_d = 'd0;
  reg     [15:0]  data_d = 'd0;
  reg             valid_2d = 'd0;
  reg     [15:0]  data_2d = 'd0;

  // internal signals

  wire    [47:0]  dc_offset_s;

  always @(posedge clk) begin
    valid_d <= valid;
    if (valid == 1'b1) begin
      data_d <= data + dcfilt_offset;
    end
    valid_2d <= valid_d;
    data_2d  <= data_d;
    valid_out <= valid_2d;
    data_out  <= data_2d;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
