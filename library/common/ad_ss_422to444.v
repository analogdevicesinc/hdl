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
// Input must be RGB or CrYCb in that order, output is CrY/CbY

`timescale 1ns/100ps

module ad_ss_422to444 #(

  parameter   CR_CB_N = 0,
  parameter   DELAY_DATA_WIDTH = 16) (

  // 422 inputs

  input                               clk,
  input                               s422_de,
  input       [DELAY_DATA_WIDTH-1:0]  s422_sync,
  input       [                15:0]  s422_data,

  // 444 outputs

  output  reg [DELAY_DATA_WIDTH-1:0]  s444_sync,
  output  reg [                23:0]  s444_data);

  localparam  DW = DELAY_DATA_WIDTH - 1;

  // internal registers

  reg             cr_cb_sel = 'd0;
  reg             s422_de_d = 'd0;
  reg     [DW:0]  s422_sync_d = 'd0;
  reg             s422_de_2d = 'd0;
  reg      [7:0]  s422_Y_d;
  reg      [7:0]  s422_CbCr_d;
  reg      [7:0]  s422_CbCr_2d;
  reg     [ 8:0]  s422_CbCr_avg;

  // internal wires

  wire    [ 7:0]  s422_Y;
  wire    [ 7:0]  s422_CbCr;

  // Input format is
  // [15:8] Cb/Cr
  // [ 7:0] Y
  //
  // Output format is
  // [23:15] Cr
  // [16: 8] Y
  // [ 7: 0] Cb

  assign s422_Y = s422_data[7:0];
  assign s422_CbCr = s422_data[15:8];

  // first data on de assertion is cb (0x0), then cr (0x1).
  // previous data is held when not current

  always @(posedge clk) begin
    if (s422_de_d == 1'b1) begin
      cr_cb_sel <= ~cr_cb_sel;
    end else begin
      cr_cb_sel <= CR_CB_N;
    end
  end

  // pipe line stages

  always @(posedge clk) begin
    s422_de_d <= s422_de;
    s422_sync_d <= s422_sync;
    s422_de_2d <= s422_de_d;
    s422_Y_d <= s422_Y;

    s422_CbCr_d <= s422_CbCr;
    s422_CbCr_2d <= s422_CbCr_d;
  end

  // If both the left and the right sample are valid do the average, otherwise
  // use the only valid.
  always @(s422_de_2d, s422_de, s422_CbCr, s422_CbCr_2d)
  begin
    if (s422_de == 1'b1 && s422_de_2d)
      s422_CbCr_avg <= s422_CbCr + s422_CbCr_2d;
    else if (s422_de == 1'b1)
      s422_CbCr_avg <= {s422_CbCr, 1'b0};
    else
      s422_CbCr_avg <= {s422_CbCr_2d, 1'b0};
  end

  // 444 outputs

  always @(posedge clk) begin
    s444_sync <= s422_sync_d;
    s444_data[15:8] <= s422_Y_d;
    if (cr_cb_sel) begin
      s444_data[23:16] <= s422_CbCr_d;
      s444_data[ 7: 0] <= s422_CbCr_avg[8:1];
    end else begin
      s444_data[23:16] <= s422_CbCr_avg[8:1];
      s444_data[ 7: 0] <= s422_CbCr_d;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
