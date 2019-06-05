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
// poor man's version of calibration & correction (scale & offset only)
// assumes linear frequency response on all discrete components
// looking for a rich man's version? fidus.com (FSF-AD15000A)

`timescale 1ns/100ps

module axi_fmcadc5_sync_calcor (

  // receive interface

  input             rx_clk,
  input             rx_enable_0,
  input   [255:0]   rx_data_0,
  input             rx_enable_1,
  input   [255:0]   rx_data_1,
  output            rx_enable,
  output  [511:0]   rx_data,

  // calibration signals

  input             rx_cal_enable,
  output            rx_cal_done_t,
  output  [ 15:0]   rx_cal_max_0,
  output  [ 15:0]   rx_cal_min_0,
  output  [ 15:0]   rx_cal_max_1,
  output  [ 15:0]   rx_cal_min_1,
  input   [ 15:0]   rx_cor_scale_0,
  input   [ 15:0]   rx_cor_offset_0,
  input   [ 15:0]   rx_cor_scale_1,
  input   [ 15:0]   rx_cor_offset_1);

  // internal registers

  reg               rx_enable_int = 'd0;
  reg     [ 15:0]   rx_cor_data_0[0:15];
  reg     [ 15:0]   rx_cor_data_1[0:15];
  reg               rx_cal_done_int_t = 'd0;
  reg     [ 15:0]   rx_cal_max_0_6 = 'd0;
  reg     [ 15:0]   rx_cal_min_0_6 = 'd0;
  reg     [ 15:0]   rx_cal_max_1_6 = 'd0;
  reg     [ 15:0]   rx_cal_min_1_6 = 'd0;
  reg     [ 15:0]   rx_cal_max_0_5 = 'd0;
  reg     [ 15:0]   rx_cal_min_0_5 = 'd0;
  reg     [ 15:0]   rx_cal_max_1_5 = 'd0;
  reg     [ 15:0]   rx_cal_min_1_5 = 'd0;
  reg     [ 15:0]   rx_cal_max_0_4[0:1];
  reg     [ 15:0]   rx_cal_min_0_4[0:1];
  reg     [ 15:0]   rx_cal_max_1_4[0:1];
  reg     [ 15:0]   rx_cal_min_1_4[0:1];
  reg     [ 15:0]   rx_cal_max_0_3[0:3];
  reg     [ 15:0]   rx_cal_min_0_3[0:3];
  reg     [ 15:0]   rx_cal_max_1_3[0:3];
  reg     [ 15:0]   rx_cal_min_1_3[0:3];
  reg     [ 15:0]   rx_cal_max_0_2[0:7];
  reg     [ 15:0]   rx_cal_min_0_2[0:7];
  reg     [ 15:0]   rx_cal_max_1_2[0:7];
  reg     [ 15:0]   rx_cal_min_1_2[0:7];
  reg     [ 15:0]   rx_cal_max_0_1[0:15];
  reg     [ 15:0]   rx_cal_min_0_1[0:15];
  reg     [ 15:0]   rx_cal_max_1_1[0:15];
  reg     [ 15:0]   rx_cal_min_1_1[0:15];

  // internal signals

  wire    [ 33:0]   rx_cor_data_0_s[0:15];
  wire    [ 33:0]   rx_cor_data_1_s[0:15];
  wire    [ 15:0]   rx_data_0_s[0:15];
  wire    [ 15:0]   rx_data_1_s[0:15];

  // iterations

  genvar n;

  // offset & gain

  assign rx_enable = rx_enable_int;

  always @(posedge rx_clk) begin
    rx_enable_int = rx_enable_0 & rx_enable_1;
  end

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_cal_data
  assign rx_data[((n*32)+15):((n*32)+ 0)] = rx_cor_data_0_s[n][30:15];
  assign rx_data[((n*32)+31):((n*32)+16)] = rx_cor_data_1_s[n][30:15];
  end
  endgenerate

  // gain

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_gain
  ad_mul #(.DELAY_DATA_WIDTH(1)) i_rx_gain_0 (
    .clk (rx_clk),
    .data_a ({rx_cor_data_0[n][15], rx_cor_data_0[n]}),
    .data_b ({1'b0, rx_cor_scale_0}),
    .data_p (rx_cor_data_0_s[n]),
    .ddata_in (1'd0),
    .ddata_out ());
  ad_mul #(.DELAY_DATA_WIDTH(1)) i_rx_gain_1 (
    .clk (rx_clk),
    .data_a ({rx_cor_data_1[n][15], rx_cor_data_1[n]}),
    .data_b ({1'b0, rx_cor_scale_1}),
    .data_p (rx_cor_data_1_s[n]),
    .ddata_in (1'd0),
    .ddata_out ());
  end
  endgenerate

  // offset

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_offset
  always @(posedge rx_clk) begin
    rx_cor_data_0[n] <= rx_data_0_s[n] + rx_cor_offset_0;
    rx_cor_data_1[n] <= rx_data_1_s[n] + rx_cor_offset_1;
  end
  end
  endgenerate

  // calibration peaks (average would be better)

  assign rx_cal_done_t = rx_cal_done_int_t;
  assign rx_cal_max_0 = rx_cal_max_0_6;
  assign rx_cal_min_0 = rx_cal_min_0_6;
  assign rx_cal_max_1 = rx_cal_max_1_6;
  assign rx_cal_min_1 = rx_cal_min_1_6;

  always @(posedge rx_clk) begin
    if (rx_cal_enable == 1'b1) begin
      rx_cal_done_int_t <= ~rx_cal_done_int_t;
      rx_cal_max_0_6 <= rx_cal_max_0_5;
      rx_cal_min_0_6 <= rx_cal_min_0_5;
      rx_cal_max_1_6 <= rx_cal_max_1_5;
      rx_cal_min_1_6 <= rx_cal_min_1_5;
    end
  end

  // run-time peaks

  always @(posedge rx_clk) begin
    if (rx_cal_max_0_4[1] > rx_cal_max_0_4[0]) begin
      rx_cal_max_0_5 <= rx_cal_max_0_4[1];
    end else begin
      rx_cal_max_0_5 <= rx_cal_max_0_4[0];
    end
    if (rx_cal_min_0_4[1] < rx_cal_min_0_4[0]) begin
      rx_cal_min_0_5 <= rx_cal_min_0_4[1];
    end else begin
      rx_cal_min_0_5 <= rx_cal_min_0_4[0];
    end
    if (rx_cal_max_1_4[1] > rx_cal_max_1_4[0]) begin
      rx_cal_max_1_5 <= rx_cal_max_1_4[1];
    end else begin
      rx_cal_max_1_5 <= rx_cal_max_1_4[0];
    end
    if (rx_cal_min_1_4[1] < rx_cal_min_1_4[0]) begin
      rx_cal_min_1_5 <= rx_cal_min_1_4[1];
    end else begin
      rx_cal_min_1_5 <= rx_cal_min_1_4[0];
    end
  end

  // peak iterations

  generate
  for (n = 0; n <= 1; n = n + 1) begin: g_rx_peak_4
  always @(posedge rx_clk) begin
    if (rx_cal_max_0_3[((n*2)+1)] > rx_cal_max_0_3[(n*2)]) begin
      rx_cal_max_0_4[n] <= rx_cal_max_0_3[((n*2)+1)];
    end else begin
      rx_cal_max_0_4[n] <= rx_cal_max_0_3[(n*2)];
    end
    if (rx_cal_min_0_3[((n*2)+1)] < rx_cal_min_0_3[(n*2)]) begin
      rx_cal_min_0_4[n] <= rx_cal_min_0_3[((n*2)+1)];
    end else begin
      rx_cal_min_0_4[n] <= rx_cal_min_0_3[(n*2)];
    end
    if (rx_cal_max_1_3[((n*2)+1)] > rx_cal_max_1_3[(n*2)]) begin
      rx_cal_max_1_4[n] <= rx_cal_max_1_3[((n*2)+1)];
    end else begin
      rx_cal_max_1_4[n] <= rx_cal_max_1_3[(n*2)];
    end
    if (rx_cal_min_1_3[((n*2)+1)] < rx_cal_min_1_3[(n*2)]) begin
      rx_cal_min_1_4[n] <= rx_cal_min_1_3[((n*2)+1)];
    end else begin
      rx_cal_min_1_4[n] <= rx_cal_min_1_3[(n*2)];
    end
  end
  end
  endgenerate

  generate
  for (n = 0; n <= 3; n = n + 1) begin: g_rx_peak_3
  always @(posedge rx_clk) begin
    if (rx_cal_max_0_2[((n*2)+1)] > rx_cal_max_0_2[(n*2)]) begin
      rx_cal_max_0_3[n] <= rx_cal_max_0_2[((n*2)+1)];
    end else begin
      rx_cal_max_0_3[n] <= rx_cal_max_0_2[(n*2)];
    end
    if (rx_cal_min_0_2[((n*2)+1)] < rx_cal_min_0_2[(n*2)]) begin
      rx_cal_min_0_3[n] <= rx_cal_min_0_2[((n*2)+1)];
    end else begin
      rx_cal_min_0_3[n] <= rx_cal_min_0_2[(n*2)];
    end
    if (rx_cal_max_1_2[((n*2)+1)] > rx_cal_max_1_2[(n*2)]) begin
      rx_cal_max_1_3[n] <= rx_cal_max_1_2[((n*2)+1)];
    end else begin
      rx_cal_max_1_3[n] <= rx_cal_max_1_2[(n*2)];
    end
    if (rx_cal_min_1_2[((n*2)+1)] < rx_cal_min_1_2[(n*2)]) begin
      rx_cal_min_1_3[n] <= rx_cal_min_1_2[((n*2)+1)];
    end else begin
      rx_cal_min_1_3[n] <= rx_cal_min_1_2[(n*2)];
    end
  end
  end
  endgenerate

  generate
  for (n = 0; n <= 7; n = n + 1) begin: g_rx_peak_2
  always @(posedge rx_clk) begin
    if (rx_cal_max_0_1[((n*2)+1)] > rx_cal_max_0_1[(n*2)]) begin
      rx_cal_max_0_2[n] <= rx_cal_max_0_1[((n*2)+1)];
    end else begin
      rx_cal_max_0_2[n] <= rx_cal_max_0_1[(n*2)];
    end
    if (rx_cal_min_0_1[((n*2)+1)] < rx_cal_min_0_1[(n*2)]) begin
      rx_cal_min_0_2[n] <= rx_cal_min_0_1[((n*2)+1)];
    end else begin
      rx_cal_min_0_2[n] <= rx_cal_min_0_1[(n*2)];
    end
    if (rx_cal_max_1_1[((n*2)+1)] > rx_cal_max_1_1[(n*2)]) begin
      rx_cal_max_1_2[n] <= rx_cal_max_1_1[((n*2)+1)];
    end else begin
      rx_cal_max_1_2[n] <= rx_cal_max_1_1[(n*2)];
    end
    if (rx_cal_min_1_1[((n*2)+1)] < rx_cal_min_1_1[(n*2)]) begin
      rx_cal_min_1_2[n] <= rx_cal_min_1_1[((n*2)+1)];
    end else begin
      rx_cal_min_1_2[n] <= rx_cal_min_1_1[(n*2)];
    end
  end
  end
  endgenerate

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_peak_1
  always @(posedge rx_clk) begin
    if (rx_cal_enable == 1'b0) begin
      rx_cal_max_0_1[n] <= 16'h0000;
    end else if ((rx_data_0_s[n] > rx_cal_max_0_1[n]) &&
      (rx_data_0_s[n][15] == 1'b0)) begin
      rx_cal_max_0_1[n] <= rx_data_0_s[n];
    end
    if (rx_cal_enable == 1'b0) begin
      rx_cal_min_0_1[n] <= 16'hffff;
    end else if ((rx_data_0_s[n] < rx_cal_min_0_1[n]) &&
      (rx_data_0_s[n][15] == 1'b1)) begin
      rx_cal_min_0_1[n] <= rx_data_0_s[n];
    end
    if (rx_cal_enable == 1'b0) begin
      rx_cal_max_1_1[n] <= 16'h0000;
    end else if ((rx_data_1_s[n] > rx_cal_max_1_1[n]) &&
      (rx_data_1_s[n][15] == 1'b0)) begin
      rx_cal_max_1_1[n] <= rx_data_1_s[n];
    end
    if (rx_cal_enable == 1'b0) begin
      rx_cal_min_1_1[n] <= 16'hffff;
    end else if ((rx_data_1_s[n] < rx_cal_min_1_1[n]) &&
      (rx_data_1_s[n][15] == 1'b1)) begin
      rx_cal_min_1_1[n] <= rx_data_1_s[n];
    end
  end
  end
  endgenerate

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_data
  assign rx_data_0_s[n] = {{4{rx_data_0[((n*16)+11)]}}, rx_data_0[((n*16)+11):(n*16)]};
  assign rx_data_1_s[n] = {{4{rx_data_1[((n*16)+11)]}}, rx_data_1[((n*16)+11):(n*16)]};
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
