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

`timescale 1ns/100ps

module util_extract #(

  parameter   CHANNELS = 2,
  parameter  DW = CHANNELS * 16) (

  input                   clk,

  input       [DW-1:0]    data_in,
  input       [DW-1:0]    data_in_trigger,
  input                   data_valid,

  output      [DW-1:0]    data_out,
  output  reg             trigger_out
);



   // loop variables

  genvar  n;

  reg trigger_d1;

  wire [15:0] trigger; // 16 maximum channels

  generate
  for (n = 0; n < CHANNELS; n = n + 1) begin: g_data_out
    assign data_out[(n+1)*16-1:n*16] = {data_in[(n*16)+14],data_in[(n*16)+14:n*16]};
    assign trigger[n] = data_in_trigger[(16*n)+15];
  end
  for (n = CHANNELS; n < 16; n = n + 1) begin: g_trigger_out
    assign trigger[n] = 1'b0;
  end
  endgenerate

  // compensate delay in the FIFO
  always @(posedge clk) begin
    if (data_valid == 1'b1) begin
      trigger_d1  <= |trigger;
      trigger_out <= trigger_d1;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
