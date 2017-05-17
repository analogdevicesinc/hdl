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
// csc = c1*d[23:16] + c2*d[15:8] + c3*d[7:0] + c4;

module ad_csc_1 #(

  parameter   DELAY_DATA_WIDTH = 16) (

  // data

  input                   clk,
  input       [DW:0]      sync,
  input       [23:0]      data,

  // constants

  input       [16:0]      C1,
  input       [16:0]      C2,
  input       [16:0]      C3,
  input       [24:0]      C4,

  // sync is delay matched

  output      [DW:0]      csc_sync_1,
  output      [ 7:0]      csc_data_1);

  localparam  DW = DELAY_DATA_WIDTH - 1;

  // internal wires

  wire    [24:0]  data_1_m_s;
  wire    [24:0]  data_2_m_s;
  wire    [24:0]  data_3_m_s;
  wire    [DW:0]  sync_3_m_s;

  // c1*R

  ad_csc_1_mul #(.DELAY_DATA_WIDTH(1)) i_mul_c1 (
    .clk (clk),
    .data_a (C1),
    .data_b (data[23:16]),
    .data_p (data_1_m_s),
    .ddata_in (1'd0),
    .ddata_out ());

  // c2*G

  ad_csc_1_mul #(.DELAY_DATA_WIDTH(1)) i_mul_c2 (
    .clk (clk),
    .data_a (C2),
    .data_b (data[15:8]),
    .data_p (data_2_m_s),
    .ddata_in (1'd0),
    .ddata_out ());

  // c3*B

  ad_csc_1_mul #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH)) i_mul_c3 (
    .clk (clk),
    .data_a (C3),
    .data_b (data[7:0]),
    .data_p (data_3_m_s),
    .ddata_in (sync),
    .ddata_out (sync_3_m_s));

  // sum + c4

  ad_csc_1_add #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH)) i_add_c4 (
    .clk (clk),
    .data_1 (data_1_m_s),
    .data_2 (data_2_m_s),
    .data_3 (data_3_m_s),
    .data_4 (C4),
    .data_p (csc_data_1),
    .ddata_in (sync_3_m_s),
    .ddata_out (csc_sync_1));

endmodule

// ***************************************************************************
// ***************************************************************************
