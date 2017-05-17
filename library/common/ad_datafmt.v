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
// data format (offset binary or 2's complement only)

`timescale 1ps/1ps

module ad_datafmt #(

  // data bus width

  parameter   DATA_WIDTH = 16,
  parameter   DISABLE = 0) (

  // data path

  input                       clk,
  input                       valid,
  input   [(DATA_WIDTH-1):0]  data,
  output                      valid_out,
  output  [15:0]              data_out,

  // control signals

  input                       dfmt_enable,
  input                       dfmt_type,
  input                       dfmt_se);

  // internal registers

  reg                         valid_int = 'd0;
  reg     [15:0]              data_int = 'd0;

  // internal signals

  wire                        type_s;
  wire                        signext_s;
  wire                        sign_s;
  wire    [15:0]              data_out_s;

  // data-path disable

  generate
  if (DISABLE == 1) begin
  assign valid_out = valid;
  assign data_out = data;
  end else begin
  assign valid_out = valid_int;
  assign data_out = data_int;
  end
  endgenerate

  // if offset-binary convert to 2's complement first

  assign type_s = dfmt_enable & dfmt_type;
  assign signext_s = dfmt_enable & dfmt_se;
  assign sign_s = signext_s & (type_s ^ data[(DATA_WIDTH-1)]);

  generate
  if (DATA_WIDTH < 16) begin
  assign data_out_s[15:DATA_WIDTH] = {(16-DATA_WIDTH){sign_s}};
  end
  endgenerate
  
  assign data_out_s[(DATA_WIDTH-1)] = type_s ^ data[(DATA_WIDTH-1)];
  assign data_out_s[(DATA_WIDTH-2):0] = data[(DATA_WIDTH-2):0];

  always @(posedge clk) begin
    valid_int <= valid;
    data_int <= data_out_s[15:0];
  end

endmodule

// ***************************************************************************
// ***************************************************************************
