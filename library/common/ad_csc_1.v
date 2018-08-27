// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// csc = c1*d[23:16] + c2*d[15:8] + c3*d[7:0] + c4;

`timescale 1ns/100ps

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
