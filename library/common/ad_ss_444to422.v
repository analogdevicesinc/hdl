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

module ad_ss_444to422 #(

  parameter   CR_CB_N = 0,
  parameter   DELAY_DATA_WIDTH = 16) (

  // 444 inputs

  input                             clk,
  input                             s444_de,
  input   [(DELAY_DATA_WIDTH-1):0]  s444_sync,
  input   [23:0]                    s444_data,

  // 422 outputs

  output  [(DELAY_DATA_WIDTH-1):0]  s422_sync,
  output  [15:0]                    s422_data);

  // internal registers

  reg                               s444_de_d = 'd0;
  reg     [(DELAY_DATA_WIDTH-1):0]  s444_sync_d = 'd0;
  reg     [23:0]                    s444_data_d = 'd0;
  reg                               s444_de_2d = 'd0;
  reg     [(DELAY_DATA_WIDTH-1):0]  s444_sync_2d = 'd0;
  reg     [23:0]                    s444_data_2d = 'd0;
  reg                               s444_de_3d = 'd0;
  reg     [(DELAY_DATA_WIDTH-1):0]  s444_sync_3d = 'd0;
  reg     [23:0]                    s444_data_3d = 'd0;
  reg     [ 7:0]                    s444_cr = 'd0;
  reg     [ 7:0]                    s444_cb = 'd0;
  reg                               s444_cbcr_sel = 'd0;
  reg     [(DELAY_DATA_WIDTH-1):0]  s444_sync_4d = 'd0;
  reg     [15:0]                    s444_data_4d = 'd0;

  // internal wires

  wire    [ 9:0]                    s444_cr_s;
  wire    [ 9:0]                    s444_cb_s;

  // fill the data pipe lines, hold the last data on edges 

  always @(posedge clk) begin
    s444_de_d <= s444_de;
    s444_sync_d <= s444_sync;
    if (s444_de == 1'b1) begin
      s444_data_d <= s444_data;
    end
    s444_de_2d <= s444_de_d;
    s444_sync_2d <= s444_sync_d;
    if (s444_de_d == 1'b1) begin
      s444_data_2d <= s444_data_d;
    end
    s444_de_3d <= s444_de_2d;
    s444_sync_3d <= s444_sync_2d;
    if (s444_de_2d == 1'b1) begin
      s444_data_3d <= s444_data_2d;
    end
  end

  // get the average 0.25*s(n-1) + 0.5*s(n) + 0.25*s(n+1)

  assign s444_cr_s = {2'd0, s444_data_d[23:16]} +
                {2'd0, s444_data_3d[23:16]} +
                {1'd0, s444_data_2d[23:16], 1'd0};

  assign s444_cb_s = {2'd0, s444_data_d[7:0]} +
                {2'd0, s444_data_3d[7:0]} +
                {1'd0, s444_data_2d[7:0], 1'd0};

  always @(posedge clk) begin
    s444_cr <= s444_cr_s[9:2];
    s444_cb <= s444_cb_s[9:2];
    if (s444_de_3d == 1'b1) begin
      s444_cbcr_sel <= ~s444_cbcr_sel;
    end else begin
      s444_cbcr_sel <= CR_CB_N;
    end
  end

  // 422 outputs

  assign  s422_sync = s444_sync_4d;
  assign  s422_data = s444_data_4d;

  always @(posedge clk) begin
    s444_sync_4d <= s444_sync_3d;
    if (s444_de_3d == 1'b0) begin
      s444_data_4d <= 'd0;
    end else if (s444_cbcr_sel == 1'b1) begin
      s444_data_4d <= {s444_cr, s444_data_3d[15:8]};
    end else begin
      s444_data_4d <= {s444_cb, s444_data_3d[15:8]};
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
