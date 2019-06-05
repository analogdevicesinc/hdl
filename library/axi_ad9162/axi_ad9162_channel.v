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

`timescale 1ns / 1ps

module axi_ad9162_channel #(

  parameter CHANNEL_ID = 32'h0,
  parameter DAC_DDS_TYPE = 1,
  parameter DAC_DDS_CORDIC_DW = 16,
  parameter DAC_DDS_CORDIC_PHASE_DW = 16,
  parameter DATAPATH_DISABLE = 0) (

  // dac interface

  input             dac_clk,
  input             dac_rst,
  output            dac_enable,
  output  [255:0]   dac_data,
  input   [255:0]   dma_data,

  // processor interface

  input             dac_data_sync,
  input             dac_dds_format,

  // bus interface

  input             up_rstn,
  input             up_clk,
  input             up_wreq,
  input   [ 13:0]   up_waddr,
  input   [ 31:0]   up_wdata,
  output            up_wack,
  input             up_rreq,
  input   [ 13:0]   up_raddr,
  output  [ 31:0]   up_rdata,
  output            up_rack);

  // internal registers

  reg     [255:0]   dac_data_int = 'd0;
  reg               dac_enable_int = 'd0;
  reg     [255:0]   dac_data_d = 'd0;
  reg     [ 15:0]   dac_dds_phase_00_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_00_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_01_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_01_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_02_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_02_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_03_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_03_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_04_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_04_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_05_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_05_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_06_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_06_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_07_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_07_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_08_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_08_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_09_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_09_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_10_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_10_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_11_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_11_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_12_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_12_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_13_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_13_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_14_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_14_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_15_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_15_1 = 'd0;
  reg     [ 15:0]   dac_dds_incr_0 = 'd0;
  reg     [ 15:0]   dac_dds_incr_1 = 'd0;
  reg     [255:0]   dac_dds_data = 'd0;

  // internal signals

  wire    [ 15:0]   dac_dds_scale_1_s;
  wire    [ 15:0]   dac_dds_init_1_s;
  wire    [ 15:0]   dac_dds_incr_1_s;
  wire    [ 15:0]   dac_dds_scale_2_s;
  wire    [ 15:0]   dac_dds_init_2_s;
  wire    [ 15:0]   dac_dds_incr_2_s;
  wire    [ 15:0]   dac_pat_data_1_s;
  wire    [ 15:0]   dac_pat_data_2_s;
  wire    [  3:0]   dac_data_sel_s;
  wire    [  1:0]   dac_iq_mode_s;
  wire    [255:0]   dac_pat_data_s;
  wire    [255:0]   dac_dds_data_s;
  wire    [255:0]   dac_dds_data_i_s;

  // dac sample mux

  assign dac_data = dac_data_int;

  always @(posedge dac_clk) begin
    dac_data_int[255:240] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[255:240] : dac_data_d[255:240];
    dac_data_int[239:224] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[223:208] : dac_data_d[239:224];
    dac_data_int[223:208] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[239:224] : dac_data_d[223:208];
    dac_data_int[207:192] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[207:192] : dac_data_d[207:192];
    dac_data_int[191:176] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[191:176] : dac_data_d[191:176];
    dac_data_int[175:160] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[159:144] : dac_data_d[175:160];
    dac_data_int[159:144] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[175:160] : dac_data_d[159:144];
    dac_data_int[143:128] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[143:128] : dac_data_d[143:128];
    dac_data_int[127:112] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[127:112] : dac_data_d[127:112];
    dac_data_int[111: 96] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[ 95: 80] : dac_data_d[111: 96];
    dac_data_int[ 95: 80] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[111: 96] : dac_data_d[ 95: 80];
    dac_data_int[ 79: 64] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[ 79: 64] : dac_data_d[ 79: 64];
    dac_data_int[ 63: 48] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[ 63: 48] : dac_data_d[ 63: 48];
    dac_data_int[ 47: 32] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[ 31: 16] : dac_data_d[ 47: 32];
    dac_data_int[ 31: 16] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[ 47: 32] : dac_data_d[ 31: 16];
    dac_data_int[ 15:  0] <= (dac_iq_mode_s[0] == 1'b1) ? dac_data_d[ 15:  0] : dac_data_d[ 15:  0];
  end

  // dac pattern data

  genvar n;
  generate
  for (n = 0; n < 8; n = n + 1) begin: g_dac_pat_data
  assign dac_pat_data_s[((32*n)+31):((32*n)+16)] = dac_pat_data_2_s;
  assign dac_pat_data_s[((32*n)+15):((32*n)+ 0)] = dac_pat_data_1_s;
  end
  endgenerate

  // dac data select

  assign dac_enable = dac_enable_int;

  always @(posedge dac_clk) begin
    dac_enable_int <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel_s)
      4'h3: dac_data_d <= 256'd0;
      4'h2: dac_data_d <= dma_data;
      4'h1: dac_data_d <= dac_pat_data_s;
      default: dac_data_d <= dac_dds_data;
    endcase
  end

  // dds

  always @(posedge dac_clk) begin
    if (dac_data_sync == 1'b0) begin
      dac_dds_phase_00_0 <= dac_dds_phase_00_0 + dac_dds_incr_0;
      dac_dds_phase_00_1 <= dac_dds_phase_00_1 + dac_dds_incr_1;
      dac_dds_phase_01_0 <= dac_dds_phase_01_0 + dac_dds_incr_0;
      dac_dds_phase_01_1 <= dac_dds_phase_01_1 + dac_dds_incr_1;
      dac_dds_phase_02_0 <= dac_dds_phase_02_0 + dac_dds_incr_0;
      dac_dds_phase_02_1 <= dac_dds_phase_02_1 + dac_dds_incr_1;
      dac_dds_phase_03_0 <= dac_dds_phase_03_0 + dac_dds_incr_0;
      dac_dds_phase_03_1 <= dac_dds_phase_03_1 + dac_dds_incr_1;
      dac_dds_phase_04_0 <= dac_dds_phase_04_0 + dac_dds_incr_0;
      dac_dds_phase_04_1 <= dac_dds_phase_04_1 + dac_dds_incr_1;
      dac_dds_phase_05_0 <= dac_dds_phase_05_0 + dac_dds_incr_0;
      dac_dds_phase_05_1 <= dac_dds_phase_05_1 + dac_dds_incr_1;
      dac_dds_phase_06_0 <= dac_dds_phase_06_0 + dac_dds_incr_0;
      dac_dds_phase_06_1 <= dac_dds_phase_06_1 + dac_dds_incr_1;
      dac_dds_phase_07_0 <= dac_dds_phase_07_0 + dac_dds_incr_0;
      dac_dds_phase_07_1 <= dac_dds_phase_07_1 + dac_dds_incr_1;
      dac_dds_phase_08_0 <= dac_dds_phase_08_0 + dac_dds_incr_0;
      dac_dds_phase_08_1 <= dac_dds_phase_08_1 + dac_dds_incr_1;
      dac_dds_phase_09_0 <= dac_dds_phase_09_0 + dac_dds_incr_0;
      dac_dds_phase_09_1 <= dac_dds_phase_09_1 + dac_dds_incr_1;
      dac_dds_phase_10_0 <= dac_dds_phase_10_0 + dac_dds_incr_0;
      dac_dds_phase_10_1 <= dac_dds_phase_10_1 + dac_dds_incr_1;
      dac_dds_phase_11_0 <= dac_dds_phase_11_0 + dac_dds_incr_0;
      dac_dds_phase_11_1 <= dac_dds_phase_11_1 + dac_dds_incr_1;
      dac_dds_phase_12_0 <= dac_dds_phase_12_0 + dac_dds_incr_0;
      dac_dds_phase_12_1 <= dac_dds_phase_12_1 + dac_dds_incr_1;
      dac_dds_phase_13_0 <= dac_dds_phase_13_0 + dac_dds_incr_0;
      dac_dds_phase_13_1 <= dac_dds_phase_13_1 + dac_dds_incr_1;
      dac_dds_phase_14_0 <= dac_dds_phase_14_0 + dac_dds_incr_0;
      dac_dds_phase_14_1 <= dac_dds_phase_14_1 + dac_dds_incr_1;
      dac_dds_phase_15_0 <= dac_dds_phase_15_0 + dac_dds_incr_0;
      dac_dds_phase_15_1 <= dac_dds_phase_15_1 + dac_dds_incr_1;
      dac_dds_incr_0 <= dac_dds_incr_0;
      dac_dds_incr_1 <= dac_dds_incr_1;
      dac_dds_data <= dac_dds_data_s;
    end else if (dac_iq_mode_s[0] == 1'b1) begin
      dac_dds_phase_00_0 <= dac_dds_init_1_s;
      dac_dds_phase_00_1 <= dac_dds_init_2_s;
      dac_dds_phase_01_0 <= dac_dds_phase_00_0 + 16'h4000;
      dac_dds_phase_01_1 <= dac_dds_phase_00_1 + 16'h4000;
      dac_dds_phase_02_0 <= dac_dds_phase_00_0 + dac_dds_incr_1_s;
      dac_dds_phase_02_1 <= dac_dds_phase_00_1 + dac_dds_incr_2_s;
      dac_dds_phase_03_0 <= dac_dds_phase_02_0 + 16'h4000;
      dac_dds_phase_03_1 <= dac_dds_phase_02_1 + 16'h4000;
      dac_dds_phase_04_0 <= dac_dds_phase_02_0 + dac_dds_incr_1_s;
      dac_dds_phase_04_1 <= dac_dds_phase_02_1 + dac_dds_incr_2_s;
      dac_dds_phase_05_0 <= dac_dds_phase_04_0 + 16'h4000;
      dac_dds_phase_05_1 <= dac_dds_phase_04_1 + 16'h4000;
      dac_dds_phase_06_0 <= dac_dds_phase_04_0 + dac_dds_incr_1_s;
      dac_dds_phase_06_1 <= dac_dds_phase_04_1 + dac_dds_incr_2_s;
      dac_dds_phase_07_0 <= dac_dds_phase_06_0 + 16'h4000;
      dac_dds_phase_07_1 <= dac_dds_phase_06_1 + 16'h4000;
      dac_dds_phase_08_0 <= dac_dds_phase_06_0 + dac_dds_incr_1_s;
      dac_dds_phase_08_1 <= dac_dds_phase_06_1 + dac_dds_incr_2_s;
      dac_dds_phase_09_0 <= dac_dds_phase_08_0 + 16'h4000;
      dac_dds_phase_09_1 <= dac_dds_phase_08_1 + 16'h4000;
      dac_dds_phase_10_0 <= dac_dds_phase_08_0 + dac_dds_incr_1_s;
      dac_dds_phase_10_1 <= dac_dds_phase_08_1 + dac_dds_incr_2_s;
      dac_dds_phase_11_0 <= dac_dds_phase_10_0 + 16'h4000;
      dac_dds_phase_11_1 <= dac_dds_phase_10_1 + 16'h4000;
      dac_dds_phase_12_0 <= dac_dds_phase_10_0 + dac_dds_incr_1_s;
      dac_dds_phase_12_1 <= dac_dds_phase_10_1 + dac_dds_incr_2_s;
      dac_dds_phase_13_0 <= dac_dds_phase_12_0 + 16'h4000;
      dac_dds_phase_13_1 <= dac_dds_phase_12_1 + 16'h4000;
      dac_dds_phase_14_0 <= dac_dds_phase_12_0 + dac_dds_incr_1_s;
      dac_dds_phase_14_1 <= dac_dds_phase_12_1 + dac_dds_incr_2_s;
      dac_dds_phase_15_0 <= dac_dds_phase_14_0 + 16'h4000;
      dac_dds_phase_15_1 <= dac_dds_phase_14_1 + 16'h4000;
      dac_dds_incr_0 <= {dac_dds_incr_1_s[12:0], 3'd0};
      dac_dds_incr_1 <= {dac_dds_incr_2_s[12:0], 3'd0};
      dac_dds_data <= 256'd0;
    end else begin
      dac_dds_phase_00_0 <= dac_dds_init_1_s;
      dac_dds_phase_00_1 <= dac_dds_init_2_s;
      dac_dds_phase_01_0 <= dac_dds_phase_00_0 + dac_dds_incr_1_s;
      dac_dds_phase_01_1 <= dac_dds_phase_00_1 + dac_dds_incr_2_s;
      dac_dds_phase_02_0 <= dac_dds_phase_01_0 + dac_dds_incr_1_s;
      dac_dds_phase_02_1 <= dac_dds_phase_01_1 + dac_dds_incr_2_s;
      dac_dds_phase_03_0 <= dac_dds_phase_02_0 + dac_dds_incr_1_s;
      dac_dds_phase_03_1 <= dac_dds_phase_02_1 + dac_dds_incr_2_s;
      dac_dds_phase_04_0 <= dac_dds_phase_03_0 + dac_dds_incr_1_s;
      dac_dds_phase_04_1 <= dac_dds_phase_03_1 + dac_dds_incr_2_s;
      dac_dds_phase_05_0 <= dac_dds_phase_04_0 + dac_dds_incr_1_s;
      dac_dds_phase_05_1 <= dac_dds_phase_04_1 + dac_dds_incr_2_s;
      dac_dds_phase_06_0 <= dac_dds_phase_05_0 + dac_dds_incr_1_s;
      dac_dds_phase_06_1 <= dac_dds_phase_05_1 + dac_dds_incr_2_s;
      dac_dds_phase_07_0 <= dac_dds_phase_06_0 + dac_dds_incr_1_s;
      dac_dds_phase_07_1 <= dac_dds_phase_06_1 + dac_dds_incr_2_s;
      dac_dds_phase_08_0 <= dac_dds_phase_07_0 + dac_dds_incr_1_s;
      dac_dds_phase_08_1 <= dac_dds_phase_07_1 + dac_dds_incr_2_s;
      dac_dds_phase_09_0 <= dac_dds_phase_08_0 + dac_dds_incr_1_s;
      dac_dds_phase_09_1 <= dac_dds_phase_08_1 + dac_dds_incr_2_s;
      dac_dds_phase_10_0 <= dac_dds_phase_09_0 + dac_dds_incr_1_s;
      dac_dds_phase_10_1 <= dac_dds_phase_09_1 + dac_dds_incr_2_s;
      dac_dds_phase_11_0 <= dac_dds_phase_10_0 + dac_dds_incr_1_s;
      dac_dds_phase_11_1 <= dac_dds_phase_10_1 + dac_dds_incr_2_s;
      dac_dds_phase_12_0 <= dac_dds_phase_11_0 + dac_dds_incr_1_s;
      dac_dds_phase_12_1 <= dac_dds_phase_11_1 + dac_dds_incr_2_s;
      dac_dds_phase_13_0 <= dac_dds_phase_12_0 + dac_dds_incr_1_s;
      dac_dds_phase_13_1 <= dac_dds_phase_12_1 + dac_dds_incr_2_s;
      dac_dds_phase_14_0 <= dac_dds_phase_13_0 + dac_dds_incr_1_s;
      dac_dds_phase_14_1 <= dac_dds_phase_13_1 + dac_dds_incr_2_s;
      dac_dds_phase_15_0 <= dac_dds_phase_14_0 + dac_dds_incr_1_s;
      dac_dds_phase_15_1 <= dac_dds_phase_14_1 + dac_dds_incr_2_s;
      dac_dds_incr_0 <= {dac_dds_incr_1_s[11:0], 4'd0};
      dac_dds_incr_1 <= {dac_dds_incr_2_s[11:0], 4'd0};
      dac_dds_data <= 256'd0;
    end
  end

  assign dac_dds_data_s[255:240] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[239:224] : dac_dds_data_i_s[255:240];
  assign dac_dds_data_s[239:224] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[255:240] : dac_dds_data_i_s[239:224];
  assign dac_dds_data_s[223:208] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[207:192] : dac_dds_data_i_s[223:208];
  assign dac_dds_data_s[207:192] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[223:208] : dac_dds_data_i_s[207:192];
  assign dac_dds_data_s[191:176] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[175:160] : dac_dds_data_i_s[191:176];
  assign dac_dds_data_s[175:160] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[191:176] : dac_dds_data_i_s[175:160];
  assign dac_dds_data_s[159:144] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[143:128] : dac_dds_data_i_s[159:144];
  assign dac_dds_data_s[143:128] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[159:144] : dac_dds_data_i_s[143:128];
  assign dac_dds_data_s[127:112] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[111: 96] : dac_dds_data_i_s[127:112];
  assign dac_dds_data_s[111: 96] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[127:112] : dac_dds_data_i_s[111: 96];
  assign dac_dds_data_s[ 95: 80] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[ 79: 64] : dac_dds_data_i_s[ 95: 80];
  assign dac_dds_data_s[ 79: 64] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[ 95: 80] : dac_dds_data_i_s[ 79: 64];
  assign dac_dds_data_s[ 63: 48] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[ 47: 32] : dac_dds_data_i_s[ 63: 48];
  assign dac_dds_data_s[ 47: 32] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[ 63: 48] : dac_dds_data_i_s[ 47: 32];
  assign dac_dds_data_s[ 31: 16] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[ 15:  0] : dac_dds_data_i_s[ 31: 16];
  assign dac_dds_data_s[ 15:  0] = (dac_iq_mode_s == 2'b11) ? dac_dds_data_i_s[ 31: 16] : dac_dds_data_i_s[ 15:  0];

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_00 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_00_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_00_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[15:0]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_01 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_01_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_01_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[31:16]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_02 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_02_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_02_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[47:32]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_03 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_03_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_03_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[63:48]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_04 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_04_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_04_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[79:64]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_05 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_05_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_05_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[95:80]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_06 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_06_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_06_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[111:96]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_07 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_07_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_07_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[127:112]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_08 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_08_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_08_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[143:128]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_09 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_09_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_09_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[159:144]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_10 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_10_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_10_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[175:160]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_11 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_11_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_11_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[191:176]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_12 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_12_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_12_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[207:192]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_13 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_13_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_13_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[223:208]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_14 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_14_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_14_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[239:224]));

  ad_dds_2 #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_dds_15 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_15_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_15_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_i_s[255:240]));

  // single channel processor

  up_dac_channel #(.CHANNEL_ID(CHANNEL_ID)) i_up_dac_channel (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_scale_1 (dac_dds_scale_1_s),
    .dac_dds_init_1 (dac_dds_init_1_s),
    .dac_dds_incr_1 (dac_dds_incr_1_s),
    .dac_dds_scale_2 (dac_dds_scale_2_s),
    .dac_dds_init_2 (dac_dds_init_2_s),
    .dac_dds_incr_2 (dac_dds_incr_2_s),
    .dac_pat_data_1 (dac_pat_data_1_s),
    .dac_pat_data_2 (dac_pat_data_2_s),
    .dac_data_sel (dac_data_sel_s),
    .dac_iq_mode (dac_iq_mode_s),
    .dac_iqcor_enb (),
    .dac_iqcor_coeff_1 (),
    .dac_iqcor_coeff_2 (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_interpolation_m (),
    .up_usr_interpolation_n (),
    .dac_usr_datatype_be (1'b0),
    .dac_usr_datatype_signed (1'b1),
    .dac_usr_datatype_shift (8'd0),
    .dac_usr_datatype_total_bits (8'd16),
    .dac_usr_datatype_bits (8'd16),
    .dac_usr_interpolation_m (16'd1),
    .dac_usr_interpolation_n (16'd1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
