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

`timescale 1ps/1ps

module __ad_serdes_in__ #(

  // parameters

  parameter   DEVICE_TYPE = 0,
  parameter   DDR_OR_SDR_N = 0,
  parameter   SERDES_FACTOR = 8,
  parameter   DATA_WIDTH = 16,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group") (

  // reset and clocks

  input                           rst,
  input                           clk,
  input                           div_clk,
  input                           loaden,
  input   [ 7:0]                  phase,
  input                           locked,

  // data interface

  output  [(DATA_WIDTH-1):0]      data_s0,
  output  [(DATA_WIDTH-1):0]      data_s1,
  output  [(DATA_WIDTH-1):0]      data_s2,
  output  [(DATA_WIDTH-1):0]      data_s3,
  output  [(DATA_WIDTH-1):0]      data_s4,
  output  [(DATA_WIDTH-1):0]      data_s5,
  output  [(DATA_WIDTH-1):0]      data_s6,
  output  [(DATA_WIDTH-1):0]      data_s7,
  input   [(DATA_WIDTH-1):0]      data_in_p,
  input   [(DATA_WIDTH-1):0]      data_in_n,

  // delay-data interface

  input                           up_clk,
  input   [(DATA_WIDTH-1):0]      up_dld,
  input   [((DATA_WIDTH*5)-1):0]  up_dwdata,
  output  [((DATA_WIDTH*5)-1):0]  up_drdata,

  // delay-control interface

  input                           delay_clk,
  input                           delay_rst,
  output                          delay_locked);

  // local parameter

  localparam ARRIA10 = 0;
  localparam CYCLONE5 = 1;

  // internal signals

  wire    [(DATA_WIDTH-1):0]      delay_locked_s;
  wire    [(DATA_WIDTH-1):0]      data_samples_s[0:(SERDES_FACTOR-1)];
  wire    [(SERDES_FACTOR-1):0]   data_out_s[0:(DATA_WIDTH-1)];

  // assignments

  assign up_drdata = 5'd0;
  assign delay_locked = & delay_locked_s;

  // instantiations

  genvar n;
  genvar i;

  generate
  if (SERDES_FACTOR == 8) begin
  assign data_s7 = data_samples_s[7];
  assign data_s6 = data_samples_s[6];
  assign data_s5 = data_samples_s[5];
  assign data_s4 = data_samples_s[4];
  end else begin
  assign data_s7 = 'd0;
  assign data_s6 = 'd0;
  assign data_s5 = 'd0;
  assign data_s4 = 'd0;
  end
  endgenerate

  assign data_s3 = data_samples_s[3];
  assign data_s2 = data_samples_s[2];
  assign data_s1 = data_samples_s[1];
  assign data_s0 = data_samples_s[0];

  generate
  for (i = 0; i < SERDES_FACTOR; i = i + 1) begin: g_samples
    for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_swap
      assign data_samples_s[i][n] = data_out_s[n][i];
    end
  end
  endgenerate

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_data

  if (DEVICE_TYPE == CYCLONE5) begin

  assign delay_locked_s[n] = 1'b1;

  ad_serdes_in_core_c5 #(
    .SERDES_FACTOR (SERDES_FACTOR))
  i_core (
    .clk (clk),
    .div_clk (div_clk),
    .enable (loaden),
    .data_in (data_in_p[n]),
    .data (data_out_s[n]));
  end

  if (DEVICE_TYPE == ARRIA10) begin
  __ad_serdes_in_1__ i_core (
    .clk_export (clk),
    .div_clk_export (div_clk),
    .hs_phase_export (phase),
    .loaden_export (loaden),
    .locked_export (locked),
    .data_in_export (data_in_p[n]),
    .data_s_export (data_out_s[n]),
    .delay_locked_export (delay_locked_s[n]));
  end

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
