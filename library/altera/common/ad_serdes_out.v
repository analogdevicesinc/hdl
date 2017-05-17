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

module __ad_serdes_out__ #(

  parameter   DEVICE_TYPE = 0,
  parameter   DDR_OR_SDR_N = 1,
  parameter   SERDES_FACTOR = 8,
  parameter   DATA_WIDTH = 16) (

  // reset and clocks

  input                           rst,
  input                           clk,
  input                           div_clk,
  input                           loaden,
                                  
  // data interface               
                                  
  input   [(DATA_WIDTH-1):0]      data_s0,
  input   [(DATA_WIDTH-1):0]      data_s1,
  input   [(DATA_WIDTH-1):0]      data_s2,
  input   [(DATA_WIDTH-1):0]      data_s3,
  input   [(DATA_WIDTH-1):0]      data_s4,
  input   [(DATA_WIDTH-1):0]      data_s5,
  input   [(DATA_WIDTH-1):0]      data_s6,
  input   [(DATA_WIDTH-1):0]      data_s7,
  output  [(DATA_WIDTH-1):0]      data_out_p,
  output  [(DATA_WIDTH-1):0]      data_out_n);

  // local parameter

  localparam ARRIA10 = 0;
  localparam CYCLONE5 = 1;

  // internal signals

  wire    [(DATA_WIDTH-1):0]      data_samples_s[0:(SERDES_FACTOR-1)];
  wire    [(SERDES_FACTOR-1):0]   data_in_s[0:(DATA_WIDTH-1)];

  // defaults

  assign data_out_n = 'd0;

  // instantiations

  genvar n;
  genvar i;

  generate
  if (SERDES_FACTOR == 8) begin
  assign data_samples_s[7] = data_s7;
  assign data_samples_s[6] = data_s6;
  assign data_samples_s[5] = data_s5;
  assign data_samples_s[4] = data_s4;
  end
  endgenerate

  assign data_samples_s[3] = data_s3;
  assign data_samples_s[2] = data_s2;
  assign data_samples_s[1] = data_s1;
  assign data_samples_s[0] = data_s0;

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_swap
    for (i = 0; i < SERDES_FACTOR; i = i + 1) begin: g_samples
      assign data_in_s[n][((SERDES_FACTOR-1)-i)] = data_samples_s[i][n];
    end
  end
  endgenerate

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_data

  if (DEVICE_TYPE == CYCLONE5) begin
  ad_serdes_out_core_c5 #(
    .SERDES_FACTOR (SERDES_FACTOR))
  i_core (
    .clk (clk),
    .div_clk (div_clk),
    .enable (loaden),
    .data_out (data_out_p[n]),
    .data (data_in_s[n]));
  end

  if (DEVICE_TYPE == ARRIA10) begin
  __ad_serdes_out_1__ i_core (
    .clk_export (clk),
    .div_clk_export (div_clk),
    .loaden_export (loaden),
    .data_out_export (data_out_p[n]),
    .data_s_export (data_in_s[n]));
  end

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

