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
// freedoms and responsabilities that he or she has by using this source/core.
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

module ad_ss_422to444 #(

  parameter   CR_CB_N = 0,
  parameter   DELAY_DATA_WIDTH = 16) (

  // 422 inputs

  input                             clk,
  input                             s422_de,
  input   [(DELAY_DATA_WIDTH-1):0]  s422_sync,
  input   [15:0]                    s422_data,

  // 444 outputs

  output  [(DELAY_DATA_WIDTH-1):0]  s444_sync,
  output  [23:0]                    s444_data);

  // internal registers

  reg                               s422_cbcr_sel = 'd0;
  reg                               s422_de_d = 'd0;
  reg     [(DELAY_DATA_WIDTH-1):0]  s422_sync_d = 'd0;
  reg     [(DELAY_DATA_WIDTH-1):0]  s422_sync_2d = 'd0;
  reg                               s422_de_2d = 'd0;
  reg     [ 7:0]                    s422_y_d = 'd0;
  reg     [ 7:0]                    s422_cbcr_d = 'd0;
  reg     [ 7:0]                    s422_cbcr_2d = 'd0;
  reg     [23:0]                    s422_ycbcr_2d = 'd0;

  // internal wires

  wire    [ 7:0]                    s422_y_s;
  wire    [ 7:0]                    s422_cbcr_s;
  wire    [ 8:0]                    s422_cbcr_sum_s;
  wire    [ 7:0]                    s422_cbcr_avg_s;

  // Input format is
  // [15:8] Cb/Cr
  // [ 7:0] Y
  //
  // Output format is
  // [23:15] Cr
  // [16: 8] Y
  // [ 7: 0] Cb

  assign s422_y_s = s422_data[7:0];
  assign s422_cbcr_s = s422_data[15:8];

  // first data on de assertion is cb (0x0), then cr (0x1).
  // previous data is held when not current

  always @(posedge clk) begin
    if (s422_de_d == 1'b1) begin
      s422_cbcr_sel <= ~s422_cbcr_sel;
    end else begin
      s422_cbcr_sel <= CR_CB_N;
    end
  end

  // pipe line stages

  always @(posedge clk) begin
    s422_de_d <= s422_de;
    s422_sync_d <= s422_sync;
    s422_de_2d <= s422_de_d;
    s422_y_d <= s422_y_s;
    s422_cbcr_d <= s422_cbcr_s;
    s422_cbcr_2d <= s422_cbcr_d;
  end

  // valid samples only-

  assign s422_cbcr_sum_s = {1'b0, s422_cbcr_s} + {1'b0, s422_cbcr_2d};
  assign s422_cbcr_avg_s = ((s422_de == 1'b1) && (s422_de_2d == 1'b1)) ?
    s422_cbcr_sum_s[8:1] : ((s422_de == 1'b1) ? s422_cbcr_s : s422_cbcr_2d);

  // 444 outputs

  assign s444_sync = s422_sync_2d;
  assign s444_data = s422_ycbcr_2d;

  always @(posedge clk) begin
    s422_sync_2d <= s422_sync_d;
    s422_ycbcr_2d[15:8] <= s422_y_d;
    if (s422_cbcr_sel == 1'b1) begin
      s422_ycbcr_2d[23:16] <= s422_cbcr_d;
      s422_ycbcr_2d[ 7: 0] <= s422_cbcr_avg_s;
    end else begin
      s422_ycbcr_2d[23:16] <= s422_cbcr_avg_s;
      s422_ycbcr_2d[ 7: 0] <= s422_cbcr_d;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
