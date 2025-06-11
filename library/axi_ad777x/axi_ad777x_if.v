// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad777x_if (

  // device-interface

  input                 clk_in,
  input                 ready_in,
  output                sync_adc_mosi,
  input                 sync_adc_miso,
  input   [ 3:0]        data_in,
  input   [ 4:0]        adc_num_lanes,
  input                 adc_crc_enable,

  // data path interface

  output                adc_clk,
  output                adc_valid,
  output   [ 7:0]       adc_crc_ch_mismatch,
  output   [31:0]       adc_data_0,
  output   [31:0]       adc_data_1,
  output   [31:0]       adc_data_2,
  output   [31:0]       adc_data_3,
  output   [31:0]       adc_data_4,
  output   [31:0]       adc_data_5,
  output   [31:0]       adc_data_6,
  output   [31:0]       adc_data_7,
  output   [ 7:0]       adc_status_0,
  output   [ 7:0]       adc_status_1,
  output   [ 7:0]       adc_status_2,
  output   [ 7:0]       adc_status_3,
  output   [ 7:0]       adc_status_4,
  output   [ 7:0]       adc_status_5,
  output   [ 7:0]       adc_status_6,
  output   [ 7:0]       adc_status_7
);

  // internal registers

  reg      [ 8:0]       adc_cnt_p     = 'd0;
  reg                   adc_valid_p   = 'd0;
  reg     [255:0]       adc_data_p    = 'd0;
  reg      [31:0]       adc_data_0_s  = 'd0;
  reg      [31:0]       adc_data_1_s  = 'd0;
  reg      [31:0]       adc_data_2_s  = 'd0;
  reg      [31:0]       adc_data_3_s  = 'd0;
  reg      [31:0]       adc_data_4_s  = 'd0;
  reg      [31:0]       adc_data_5_s  = 'd0;
  reg      [31:0]       adc_data_6_s  = 'd0;
  reg      [31:0]       adc_data_7_s  = 'd0;
  reg      [31:0]       adc_data_0_s_d  = 'd0;
  reg      [31:0]       adc_data_1_s_d  = 'd0;
  reg      [31:0]       adc_data_2_s_d  = 'd0;
  reg      [31:0]       adc_data_3_s_d  = 'd0;
  reg      [31:0]       adc_data_4_s_d  = 'd0;
  reg      [31:0]       adc_data_5_s_d  = 'd0;
  reg      [31:0]       adc_data_6_s_d  = 'd0;
  reg      [31:0]       adc_data_7_s_d  = 'd0;
  reg                   adc_valid_s    = 'b0;
  reg                   adc_valid_s_d  = 'b0;
  reg      [ 7:0]       adc_crc_read_data_0_1 = 'd0;
  reg      [ 7:0]       adc_crc_read_data_2_3 = 'd0;
  reg      [ 7:0]       adc_crc_read_data_4_5 = 'd0;
  reg      [ 7:0]       adc_crc_read_data_6_7 = 'd0;
  reg      [55:0]       adc_crc_data_0_1 = 'd0;
  reg      [55:0]       adc_crc_data_2_3 = 'd0;
  reg      [55:0]       adc_crc_data_4_5 = 'd0;
  reg      [55:0]       adc_crc_data_6_7 = 'd0;
  reg      [ 7:0]       adc_crc_reg_0_1 = 'd0;
  reg      [ 7:0]       adc_crc_reg_2_3 = 'd0;
  reg      [ 7:0]       adc_crc_reg_4_5 = 'd0;
  reg      [ 7:0]       adc_crc_reg_6_7 = 'd0;
  reg      [ 7:0]       adc_status_0_s = 'd0;
  reg      [ 7:0]       adc_status_1_s = 'd0;
  reg      [ 7:0]       adc_status_2_s = 'd0;
  reg      [ 7:0]       adc_status_3_s = 'd0;
  reg      [ 7:0]       adc_status_4_s = 'd0;
  reg      [ 7:0]       adc_status_5_s = 'd0;
  reg      [ 7:0]       adc_status_6_s = 'd0;
  reg      [ 7:0]       adc_status_7_s = 'd0;
  reg      [ 7:0]       adc_crc_ch_mismatch_s = 'd0;
  reg                   adc_cnt_enable_s_d    = 'b0;

  // internal signals

  wire                  adc_cnt_enable_s;
  wire                  adc_ready_in_s;
  wire    [ 8:0]        adc_cnt_value;
  wire    [ 7:0]        adc_crc_in_s_0_1;
  wire    [ 7:0]        adc_crc_in_s_2_3;
  wire    [ 7:0]        adc_crc_in_s_4_5;
  wire    [ 7:0]        adc_crc_in_s_6_7;
  wire    [ 7:0]        adc_crc_s_0_1;
  wire    [ 7:0]        adc_crc_s_2_3;
  wire    [ 7:0]        adc_crc_s_4_5;
  wire    [ 7:0]        adc_crc_s_6_7;
  wire                  adc_crc_mismatch_s_0_1;
  wire                  adc_crc_mismatch_s_2_3;
  wire                  adc_crc_mismatch_s_4_5;
  wire                  adc_crc_mismatch_s_6_7;

  assign adc_valid      = adc_valid_s_d;
  assign adc_ready_in_s = ready_in;
  assign adc_data_0     = adc_data_0_s_d;
  assign adc_data_1     = adc_data_1_s_d;
  assign adc_data_2     = adc_data_2_s_d;
  assign adc_data_3     = adc_data_3_s_d;
  assign adc_data_4     = adc_data_4_s_d;
  assign adc_data_5     = adc_data_5_s_d;
  assign adc_data_6     = adc_data_6_s_d;
  assign adc_data_7     = adc_data_7_s_d;
  assign sync_adc_mosi  = sync_adc_miso;
  assign adc_clk        = clk_in;

  assign adc_status_0   = adc_status_0_s;
  assign adc_status_1   = adc_status_1_s;
  assign adc_status_2   = adc_status_2_s;
  assign adc_status_3   = adc_status_3_s;
  assign adc_status_4   = adc_status_4_s;
  assign adc_status_5   = adc_status_5_s;
  assign adc_status_6   = adc_status_6_s;
  assign adc_status_7   = adc_status_7_s;
  assign adc_crc_ch_mismatch = adc_crc_ch_mismatch_s;

 // function (crc)

  function  [ 7:0]  crc8;
    input   [55:0]  din;
    input   [ 7:0]  cin;
    reg     [ 7:0]  cout;
    begin
      cout[0] = cin[ 0] ^ cin[ 1] ^ cin[ 2] ^ cin[ 4] ^ cin[ 5] ^ cin[ 6] ^ din[ 0] ^ din[ 6] ^ din[ 7] ^ din[ 8] ^ din[12] ^ din[14] ^ din[16] ^
                din[18] ^ din[19] ^ din[21] ^ din[23] ^ din[28] ^ din[30] ^ din[31] ^ din[34] ^ din[35] ^ din[39] ^ din[40] ^ din[43] ^ din[45] ^
                din[48] ^ din[49] ^ din[50] ^ din[52] ^ din[53] ^ din[54];
      cout[1] = cin[ 0] ^ cin[ 3] ^ cin[ 4] ^ cin[ 7] ^ din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 9] ^ din[12] ^ din[13] ^ din[14] ^ din[15] ^ din[16] ^
                din[17] ^ din[18] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^ din[24] ^ din[28] ^ din[29] ^ din[30] ^ din[32] ^ din[34] ^ din[36] ^
                din[39] ^ din[41] ^ din[43] ^ din[44] ^ din[45] ^ din[46] ^ din[48] ^ din[51] ^ din[52] ^ din[55];
      cout[2] = cin[ 0] ^ cin[ 2] ^ cin[ 6] ^ din[ 0] ^ din[ 1] ^ din[ 2] ^ din[ 6] ^ din[ 8] ^ din[10] ^ din[12] ^ din[13] ^ din[15] ^ din[17] ^
                din[22] ^ din[24] ^ din[25] ^ din[28] ^ din[29] ^ din[33] ^ din[34] ^ din[37] ^ din[39] ^ din[42] ^ din[43] ^ din[44] ^ din[46] ^
                din[47] ^ din[48] ^ din[50] ^ din[54];
      cout[3] = cin[ 0] ^ cin[ 1] ^ cin[ 3] ^ cin[ 7] ^ din[ 1] ^ din[ 2] ^ din[ 3] ^ din[ 7] ^ din[ 9] ^ din[11] ^ din[13] ^ din[14] ^ din[16] ^
                din[18] ^ din[23] ^ din[25] ^ din[26] ^ din[29] ^ din[30] ^ din[34] ^ din[35] ^ din[38] ^ din[40] ^ din[43] ^ din[44] ^ din[45] ^
                din[47] ^ din[48] ^ din[49] ^ din[51] ^ din[55];
      cout[4] = cin[ 0] ^ cin[ 1] ^ cin[ 2] ^ cin[ 4] ^ din[ 2] ^ din[ 3] ^ din[ 4] ^ din[ 8] ^ din[10] ^ din[12] ^ din[14] ^ din[15] ^ din[17] ^
                din[19] ^ din[24] ^ din[26] ^ din[27] ^ din[30] ^ din[31] ^ din[35] ^ din[36] ^ din[39] ^ din[41] ^ din[44] ^ din[45] ^ din[46] ^
                din[48] ^ din[49] ^ din[50] ^ din[52];
      cout[5] = cin[ 1] ^ cin[ 2] ^ cin[ 3] ^ cin[ 5] ^ din[ 3] ^ din[ 4] ^ din[ 5] ^ din[ 9] ^ din[11] ^ din[13] ^ din[15] ^ din[16] ^ din[18] ^
                din[20] ^ din[25] ^ din[27] ^ din[28] ^ din[31] ^ din[32] ^ din[36] ^ din[37] ^ din[40] ^ din[42] ^ din[45] ^ din[46] ^ din[47] ^
                din[49] ^ din[50] ^ din[51] ^ din[53];
      cout[6] = cin[ 0] ^ cin[ 2] ^ cin[ 3] ^ cin[ 4] ^ cin[ 6] ^ din[ 4] ^ din[ 5] ^ din[ 6] ^ din[10] ^ din[12] ^ din[14] ^ din[16] ^ din[17] ^
                din[19] ^ din[21] ^ din[26] ^ din[28] ^ din[29] ^ din[32] ^ din[33] ^ din[37] ^ din[38] ^ din[41] ^ din[43] ^ din[46] ^ din[47] ^
                din[48] ^ din[50] ^ din[51] ^ din[52] ^ din[54];
      cout[7] = cin[ 0] ^ cin[ 1] ^ cin[ 3] ^ cin[ 4] ^ cin[ 5] ^ cin[ 7] ^ din[ 5] ^ din[ 6] ^ din[ 7] ^ din[11] ^ din[13] ^ din[15] ^ din[17] ^
                din[18] ^ din[20] ^ din[22] ^ din[27] ^ din[29] ^ din[30] ^ din[33] ^ din[34] ^ din[38] ^ din[39] ^ din[42] ^ din[44] ^ din[47] ^
                din[48] ^ din[49] ^ din[51] ^ din[52] ^ din[53] ^ din[55];
      crc8 = cout;
    end
  endfunction

  //crc computing

  assign adc_crc_s_0_1 = crc8(adc_crc_data_0_1, adc_crc_in_s_0_1);
  assign adc_crc_s_2_3 = crc8(adc_crc_data_2_3, adc_crc_in_s_2_3);
  assign adc_crc_s_4_5 = crc8(adc_crc_data_4_5, adc_crc_in_s_4_5);
  assign adc_crc_s_6_7 = crc8(adc_crc_data_6_7, adc_crc_in_s_6_7);

  assign adc_crc_in_s_0_1 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_0_1;
  assign adc_crc_in_s_2_3 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_2_3;
  assign adc_crc_in_s_4_5 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_4_5;
  assign adc_crc_in_s_6_7 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_6_7;

  assign adc_crc_mismatch_s_0_1 = (adc_crc_read_data_0_1 == adc_crc_s_0_1) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s_2_3 = (adc_crc_read_data_2_3 == adc_crc_s_2_3) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s_4_5 = (adc_crc_read_data_4_5 == adc_crc_s_4_5) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s_6_7 = (adc_crc_read_data_6_7 == adc_crc_s_6_7) ? 1'b0 : adc_crc_enable;

  always @(posedge adc_clk) begin
   adc_status_0_s   <= (adc_valid_s == 1'b1 ) ? adc_data_0_s[31:24]: adc_status_0_s;
   adc_status_1_s   <= (adc_valid_s == 1'b1 ) ? adc_data_1_s[31:24]: adc_status_1_s;
   adc_status_2_s   <= (adc_valid_s == 1'b1 ) ? adc_data_2_s[31:24]: adc_status_2_s;
   adc_status_3_s   <= (adc_valid_s == 1'b1 ) ? adc_data_3_s[31:24]: adc_status_3_s;
   adc_status_4_s   <= (adc_valid_s == 1'b1 ) ? adc_data_4_s[31:24]: adc_status_4_s;
   adc_status_5_s   <= (adc_valid_s == 1'b1 ) ? adc_data_5_s[31:24]: adc_status_5_s;
   adc_status_6_s   <= (adc_valid_s == 1'b1 ) ? adc_data_6_s[31:24]: adc_status_6_s;
   adc_status_7_s   <= (adc_valid_s == 1'b1 ) ? adc_data_7_s[31:24]: adc_status_7_s;

   adc_crc_ch_mismatch_s[1:0] <= (adc_valid_s_d == 1'b1 ) ? {2{adc_crc_mismatch_s_0_1}} : adc_crc_ch_mismatch_s[1:0];
   adc_crc_ch_mismatch_s[3:2] <= (adc_valid_s_d == 1'b1 ) ? {2{adc_crc_mismatch_s_2_3}} : adc_crc_ch_mismatch_s[3:2];
   adc_crc_ch_mismatch_s[5:4] <= (adc_valid_s_d == 1'b1 ) ? {2{adc_crc_mismatch_s_4_5}} : adc_crc_ch_mismatch_s[5:4];
   adc_crc_ch_mismatch_s[7:6] <= (adc_valid_s_d == 1'b1 ) ? {2{adc_crc_mismatch_s_6_7}} : adc_crc_ch_mismatch_s[7:6];
  end

  // crc generation/validation data

  always @(posedge adc_clk) begin
    if (adc_valid_s == 1'b1) begin
      adc_crc_reg_0_1        <= adc_crc_s_0_1;
      adc_crc_reg_2_3        <= adc_crc_s_2_3;
      adc_crc_reg_4_5        <= adc_crc_s_4_5;
      adc_crc_reg_6_7        <= adc_crc_s_6_7;
      adc_crc_read_data_0_1  <= {adc_data_0_s[27:24],adc_data_1_s[27:24]};
      adc_crc_read_data_2_3  <= {adc_data_2_s[27:24],adc_data_3_s[27:24]};
      adc_crc_read_data_4_5  <= {adc_data_4_s[27:24],adc_data_5_s[27:24]};
      adc_crc_read_data_6_7  <= {adc_data_6_s[27:24],adc_data_7_s[27:24]};
      adc_crc_data_0_1       <= {adc_data_0_s[31:28],adc_data_0_s[23:0],adc_data_1_s[31:28],adc_data_1_s[23:0]};
      adc_crc_data_2_3       <= {adc_data_2_s[31:28],adc_data_2_s[23:0],adc_data_3_s[31:28],adc_data_3_s[23:0]};
      adc_crc_data_4_5       <= {adc_data_4_s[31:28],adc_data_4_s[23:0],adc_data_5_s[31:28],adc_data_5_s[23:0]};
      adc_crc_data_6_7       <= {adc_data_6_s[31:28],adc_data_6_s[23:0],adc_data_7_s[31:28],adc_data_7_s[23:0]};
    end else begin
      adc_crc_reg_0_1        <= 'd0;
      adc_crc_reg_2_3        <= 'd0;
      adc_crc_reg_4_5        <= 'd0;
      adc_crc_reg_6_7        <= 'd0;
      adc_crc_read_data_0_1  <= 'd0;
      adc_crc_read_data_2_3  <= 'd0;
      adc_crc_read_data_4_5  <= 'd0;
      adc_crc_read_data_6_7  <= 'd0;
      adc_crc_data_0_1       <= 'd0;
      adc_crc_data_2_3       <= 'd0;
      adc_crc_data_4_5       <= 'd0;
      adc_crc_data_6_7       <= 'd0;
    end
  end

  //delay data 1 clk for data, data_valid and crc mismatch for alignment

  always @(posedge adc_clk) begin
    if (adc_valid_s == 1'b1) begin
      adc_data_0_s_d <= adc_data_0_s;
      adc_data_1_s_d <= adc_data_1_s;
      adc_data_2_s_d <= adc_data_2_s;
      adc_data_3_s_d <= adc_data_3_s;
      adc_data_4_s_d <= adc_data_4_s;
      adc_data_5_s_d <= adc_data_5_s;
      adc_data_6_s_d <= adc_data_6_s;
      adc_data_7_s_d <= adc_data_7_s;
      adc_valid_s_d  <= adc_valid_s;
    end else begin
      adc_data_0_s_d <= 32'b0;
      adc_data_1_s_d <= 32'b0;
      adc_data_2_s_d <= 32'b0;
      adc_data_3_s_d <= 32'b0;
      adc_data_4_s_d <= 32'b0;
      adc_data_5_s_d <= 32'b0;
      adc_data_6_s_d <= 32'b0;
      adc_data_7_s_d <= 32'b0;
      adc_valid_s_d  <=  1'b0;
    end
  end

  always @(posedge adc_clk) begin
    if (adc_valid_p == 1'b1) begin
      if( adc_num_lanes == 'h1) begin
        adc_data_0_s <= adc_data_p[((32*7)+31):(32*7)];
        adc_data_1_s <= adc_data_p[((32*6)+31):(32*6)];
        adc_data_2_s <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_3_s <= adc_data_p[((32*4)+31):(32*4)];
        adc_data_4_s <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_5_s <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_6_s <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_7_s <= adc_data_p[((32*0)+31):(32*0)];
      end else if( adc_num_lanes == 'h2) begin
        adc_data_0_s <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_1_s <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_2_s <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_3_s <= adc_data_p[((32*0)+31):(32*0)];
        adc_data_4_s <= adc_data_p[((32*7)+31):(32*7)];
        adc_data_5_s <= adc_data_p[((32*6)+31):(32*6)];
        adc_data_6_s <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_7_s <= adc_data_p[((32*4)+31):(32*4)];
      end else begin
        adc_data_0_s <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_1_s <= adc_data_p[((32*0)+31):(32*0)];
        adc_data_2_s <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_3_s <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_4_s <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_5_s <= adc_data_p[((32*4)+31):(32*4)];
        adc_data_6_s <= adc_data_p[((32*7)+31):(32*7)];
        adc_data_7_s <= adc_data_p[((32*6)+31):(32*6)];
      end
      adc_valid_s    <= adc_valid_p;
    end else begin
      adc_data_0_s <= 32'b0;
      adc_data_1_s <= 32'b0;
      adc_data_2_s <= 32'b0;
      adc_data_3_s <= 32'b0;
      adc_data_4_s <= 32'b0;
      adc_data_5_s <= 32'b0;
      adc_data_6_s <= 32'b0;
      adc_data_7_s <= 32'b0;
	    adc_valid_s  <=  1'b0;
    end
  end

  assign adc_cnt_value = (adc_num_lanes == 'h1) ? 'hff :
                        ((adc_num_lanes == 'h2)? 'h7f : 'h3f);

  assign adc_cnt_enable_s = (adc_cnt_p < adc_cnt_value) ? 1'b1 : 1'b0;

  always @(negedge adc_clk) begin
    adc_cnt_enable_s_d <= adc_cnt_enable_s;
    if (adc_ready_in_s == 1'b1) begin
      adc_cnt_p <= 'h000;
    end else if (adc_cnt_enable_s == 1'b1) begin
      adc_cnt_p <= adc_cnt_p + 1'b1;
    end
     if (adc_cnt_p == adc_cnt_value && adc_cnt_enable_s_d == 1'b1) begin
      adc_valid_p <= 1'b1;
    end else begin
      adc_valid_p <= 1'b0;
    end
  end

  // data (individual lanes)

  always @(negedge adc_clk) begin
    if( adc_num_lanes == 'h1) begin
      if (adc_cnt_p == 'h000 ) begin
        adc_data_p[((256*0)+255):(256*0)] <= {255'd0, data_in[0]};
      end else begin
        adc_data_p[((256*0)+255):(255*0)] <= {adc_data_p[((256*0)+254):(256*0)], data_in[0]};
      end
    end else if( adc_num_lanes == 'h2) begin
     if (adc_cnt_p == 'h000 ) begin
        adc_data_p[((128*0)+127):(128*0)] <= {127'd0, data_in[0]};
        adc_data_p[((128*1)+127):(128*1)] <= {127'd0, data_in[1]};
      end else begin
        adc_data_p[((128*0)+127):(128*0)] <= {adc_data_p[((128*0)+126):(128*0)], data_in[0]};
        adc_data_p[((128*1)+127):(128*1)] <= {adc_data_p[((128*1)+126):(128*1)], data_in[1]};
      end
    end else begin
     if (adc_cnt_p == 'h000 ) begin
        adc_data_p[((64*0)+63):(64*0)] <= {63'd0, data_in[0]};
        adc_data_p[((64*1)+63):(64*1)] <= {63'd0, data_in[1]};
        adc_data_p[((64*2)+63):(64*2)] <= {63'd0, data_in[2]};
        adc_data_p[((64*3)+63):(64*3)] <= {63'd0, data_in[3]};
      end else begin
        adc_data_p[((64*0)+63):(64*0)] <= {adc_data_p[((64*0)+62):(64*0)], data_in[0]};
        adc_data_p[((64*1)+63):(64*1)] <= {adc_data_p[((64*1)+62):(64*1)], data_in[1]};
        adc_data_p[((64*2)+63):(64*2)] <= {adc_data_p[((64*2)+62):(64*2)], data_in[2]};
        adc_data_p[((64*3)+63):(64*3)] <= {adc_data_p[((64*3)+62):(64*3)], data_in[3]};
      end
    end
  end
endmodule
