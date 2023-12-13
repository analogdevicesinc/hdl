// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad7768_if #(
  parameter NUM_CHANNELS = 8
) (

  // device-interface

  input                  clk_in,
  input                  ready_in,
  input       [ 7:0]     data_in,

  // data path interface

  output                 adc_clk,
  output                 adc_valid,
  output      [31:0]     adc_data,
  output                 adc_sync,
  output      [31:0]     adc_data_0,
  output      [31:0]     adc_data_1,
  output      [31:0]     adc_data_2,
  output      [31:0]     adc_data_3,
  output      [31:0]     adc_data_4,
  output      [31:0]     adc_data_5,
  output      [31:0]     adc_data_6,
  output      [31:0]     adc_data_7,
  output      [ 7:0]     adc_status_0,
  output      [ 7:0]     adc_status_1,
  output      [ 7:0]     adc_status_2,
  output      [ 7:0]     adc_status_3,
  output      [ 7:0]     adc_status_4,
  output      [ 7:0]     adc_status_5,
  output      [ 7:0]     adc_status_6,
  output      [ 7:0]     adc_status_7,
  output      [ 7:0]     adc_crc_ch_mismatch,

  // control interface

  input                  adc_sshot,
  input       [ 4:0]     adc_format,
  input                  adc_crc_enable
);

  // internal registers

  reg     [ 95:0]   adc_crc_data_s    [0:7];
  reg     [  7:0]   adc_crc_read_data [0:7];
  reg     [  7:0]   adc_crc_reg       [0:7];
  reg     [ 31:0]   adc_data_s_d      [0:7];
  reg     [ 31:0]   adc_data_s        [0:7];
  reg     [ 31:0]   adc_data_int          = 'd0;
  reg     [  3:0]   adc_crc_cnt           = 'd0;
  reg     [  8:0]   adc_cnt_p             = 'd0;
  reg     [255:0]   adc_data_p            = 'd0;
  reg     [255:0]   adc_ch_data_d0        = 'd0;
  reg     [255:0]   adc_ch_data_d1        = 'd0;
  reg     [255:0]   adc_ch_data_d2        = 'd0;
  reg     [255:0]   adc_ch_data_d3        = 'd0;
  reg     [255:0]   adc_ch_data_d4        = 'd0;
  reg     [255:0]   adc_ch_data_d5        = 'd0;
  reg     [255:0]   adc_ch_data_d6        = 'd0;
  reg     [255:0]   adc_ch_data_d7        = 'd0;
  reg     [  7:0]   adc_status_0_s        = 'd0;
  reg     [  7:0]   adc_status_1_s        = 'd0;
  reg     [  7:0]   adc_status_2_s        = 'd0;
  reg     [  7:0]   adc_status_3_s        = 'd0;
  reg     [  7:0]   adc_status_4_s        = 'd0;
  reg     [  7:0]   adc_status_5_s        = 'd0;
  reg     [  7:0]   adc_status_6_s        = 'd0;
  reg     [  7:0]   adc_status_7_s        = 'd0;
  reg     [  7:0]   adc_crc_ch_mismatch_s = 'd0;
  reg               adc_valid_s           = 'b0;
  reg               adc_valid_s_d         = 'b0;
  reg               adc_crc_valid_p       = 'b0;
  reg               sync_ss               = 'd0;
  reg               adc_valid_p           = 'd0;
  reg               adc_ready             = 'd0;
  reg               adc_cnt_enable_s_d    = 'b0;
  // internal signals

  wire   [  7:0]    adc_crc_in_s [0:7];
  wire   [  7:0]    adc_crc_s    [0:7];
  wire   [  3:0]    adc_crc_cnt_value;
  wire   [  8:0]    adc_cnt_value;
  wire   [  7:0]    adc_crc_mismatch_s;
  wire              adc_crc_cnt_enable_s;
  wire              adc_cnt_enable_s;
  wire              adc_ready_in_s;
  wire              crc_in_sync_n;

  // function (crc8)

  function  [ 7:0]  crc8;
    input   [95:0]  din;
    input   [ 7:0]  cin;
    reg     [ 7:0]  cout;
    begin

    cout[0] = cin[0]  ^ cin[2]  ^ cin[4]  ^ cin[5]  ^ cin[6]  ^ din[0]  ^ din[6]  ^ din[7]  ^ din[8]  ^ din[12] ^ din[14] ^ din[16] ^
              din[18] ^ din[19] ^ din[21] ^ din[23] ^ din[28] ^ din[30] ^ din[31] ^ din[34] ^ din[35] ^ din[39] ^ din[40] ^ din[43] ^
              din[45] ^ din[48] ^ din[49] ^ din[50] ^ din[52] ^ din[53] ^ din[54] ^ din[56] ^ din[60] ^ din[63] ^ din[64] ^ din[66] ^
              din[67] ^ din[68] ^ din[69] ^ din[74] ^ din[75] ^ din[77] ^ din[80] ^ din[84] ^ din[85] ^ din[86] ^ din[87] ^ din[88] ^
              din[90] ^ din[92] ^ din[93] ^ din[94];
    cout[1] = cin[1]  ^ cin[2]  ^ cin[3]  ^ cin[4]  ^ cin[7]  ^ din[0]  ^ din[1]  ^ din[6]  ^ din[9]  ^ din[12] ^ din[13] ^ din[14] ^
              din[15] ^ din[16] ^ din[17] ^ din[18] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^ din[24] ^ din[28] ^ din[29] ^ din[30] ^
              din[32] ^ din[34] ^ din[36] ^ din[39] ^ din[41] ^ din[43] ^ din[44] ^ din[45] ^ din[46] ^ din[48] ^ din[51] ^ din[52] ^
              din[55] ^ din[56] ^ din[57] ^ din[60] ^ din[61] ^ din[63] ^ din[65] ^ din[66] ^ din[70] ^ din[74] ^ din[76] ^ din[77] ^
              din[78] ^ din[80] ^ din[81] ^ din[84] ^ din[89] ^ din[90] ^ din[91] ^ din[92] ^ din[95];
    cout[2] = cin[0]  ^ cin[3]  ^ cin[6]  ^ din[0]  ^ din[1]  ^ din[2]  ^ din[6]  ^ din[8]  ^ din[10] ^ din[12] ^ din[13] ^ din[15] ^
              din[17] ^ din[22] ^ din[24] ^ din[25] ^ din[28] ^ din[29] ^ din[33] ^ din[34] ^ din[37] ^ din[39] ^ din[42] ^ din[43] ^
              din[44] ^ din[46] ^ din[47] ^ din[48] ^ din[50] ^ din[54] ^ din[57] ^ din[58] ^ din[60] ^ din[61] ^ din[62] ^ din[63] ^
              din[68] ^ din[69] ^ din[71] ^ din[74] ^ din[78] ^ din[79] ^ din[80] ^ din[81] ^ din[82] ^ din[84] ^ din[86] ^ din[87] ^
              din[88] ^ din[91] ^ din[94];
    cout[3] = cin[0]  ^ cin[1]  ^ cin[4]  ^ cin[7]  ^ din[1]  ^ din[2]  ^ din[3]  ^ din[7]  ^ din[9]  ^ din[11] ^ din[13] ^ din[14] ^
              din[16] ^ din[18] ^ din[23] ^ din[25] ^ din[26] ^ din[29] ^ din[30] ^ din[34] ^ din[35] ^ din[38] ^ din[40] ^ din[43] ^
              din[44] ^ din[45] ^ din[47] ^ din[48] ^ din[49] ^ din[51] ^ din[55] ^ din[58] ^ din[59] ^ din[61] ^ din[62] ^ din[63] ^
              din[64] ^ din[69] ^ din[70] ^ din[72] ^ din[75] ^ din[79] ^ din[80] ^ din[81] ^ din[82] ^ din[83] ^ din[85] ^ din[87] ^
              din[88] ^ din[89] ^ din[92] ^ din[95];
    cout[4] = cin[0]  ^ cin[1]  ^ cin[2]  ^ cin[5]  ^ din[2]  ^ din[3]  ^ din[4]  ^ din[8]  ^ din[10] ^ din[12] ^ din[14] ^ din[15] ^
              din[17] ^ din[19] ^ din[24] ^ din[26] ^ din[27] ^ din[30] ^ din[31] ^ din[35] ^ din[36] ^ din[39] ^ din[41] ^ din[44] ^
              din[45] ^ din[46] ^ din[48] ^ din[49] ^ din[50] ^ din[52] ^ din[56] ^ din[59] ^ din[60] ^ din[62] ^ din[63] ^ din[64] ^
              din[65] ^ din[70] ^ din[71] ^ din[73] ^ din[76] ^ din[80] ^ din[81] ^ din[82] ^ din[83] ^ din[84] ^ din[86] ^ din[88] ^
              din[89] ^ din[90] ^ din[93];
    cout[5] = cin[1]  ^ cin[2]  ^ cin[3]  ^ cin[6]  ^ din[3]  ^ din[4]  ^ din[5]  ^ din[9]  ^ din[11] ^ din[13] ^ din[15] ^ din[16] ^
              din[18] ^ din[20] ^ din[25] ^ din[27] ^ din[28] ^ din[31] ^ din[32] ^ din[36] ^ din[37] ^ din[40] ^ din[42] ^ din[45] ^
              din[46] ^ din[47] ^ din[49] ^ din[50] ^ din[51] ^ din[53] ^ din[57] ^ din[60] ^ din[61] ^ din[63] ^ din[64] ^ din[65] ^
              din[66] ^ din[71] ^ din[72] ^ din[74] ^ din[77] ^ din[81] ^ din[82] ^ din[83] ^ din[84] ^ din[85] ^ din[87] ^ din[89] ^
              din[90] ^ din[91] ^ din[94];
    cout[6] = cin[0]  ^ cin[2]  ^ cin[3]  ^ cin[4]  ^ cin[7]  ^ din[4]  ^ din[5]  ^ din[6]  ^ din[10] ^ din[12] ^ din[14] ^ din[16] ^
              din[17] ^ din[19] ^ din[21] ^ din[26] ^ din[28] ^ din[29] ^ din[32] ^ din[33] ^ din[37] ^ din[38] ^ din[41] ^ din[43] ^
              din[46] ^ din[47] ^ din[48] ^ din[50] ^ din[51] ^ din[52] ^ din[54] ^ din[58] ^ din[61] ^ din[62] ^ din[64] ^ din[65] ^
              din[66] ^ din[67] ^ din[72] ^ din[73] ^ din[75] ^ din[78] ^ din[82] ^ din[83] ^ din[84] ^ din[85] ^ din[86] ^ din[88] ^
              din[90] ^ din[91] ^ din[92] ^ din[95];
    cout[7] = cin[1]  ^ cin[3]  ^ cin[4]  ^ cin[5]  ^ din[5]  ^ din[6]  ^ din[7]  ^ din[11] ^ din[13] ^ din[15] ^ din[17] ^ din[18] ^
              din[20] ^ din[22] ^ din[27] ^ din[29] ^ din[30] ^ din[33] ^ din[34] ^ din[38] ^ din[39] ^ din[42] ^ din[44] ^ din[47] ^
              din[48] ^ din[49] ^ din[51] ^ din[52] ^ din[53] ^ din[55] ^ din[59] ^ din[62] ^ din[63] ^ din[65] ^ din[66] ^ din[67] ^
              din[68] ^ din[73] ^ din[74] ^ din[76] ^ din[79] ^ din[83] ^ din[84] ^ din[85] ^ din[86] ^ din[87] ^ din[89] ^ din[91] ^
              din[92] ^ din[93];
      crc8 = cout;
    end
  endfunction

  assign adc_ready_in_s = ready_in;
  assign adc_clk = clk_in;
  assign adc_valid = adc_valid_s_d;
  assign adc_data= adc_data_int;
  assign adc_data_0 = adc_data_s_d[0];
  assign adc_data_1 = adc_data_s_d[1];
  assign adc_data_2 = adc_data_s_d[2];
  assign adc_data_3 = adc_data_s_d[3];
  assign adc_data_4 = adc_data_s_d[4];
  assign adc_data_5 = adc_data_s_d[5];
  assign adc_data_6 = adc_data_s_d[6];
  assign adc_data_7 = adc_data_s_d[7];
  assign adc_status_0 = adc_status_0_s;
  assign adc_status_1 = adc_status_1_s;
  assign adc_status_2 = adc_status_2_s;
  assign adc_status_3 = adc_status_3_s;
  assign adc_status_4 = adc_status_4_s;
  assign adc_status_5 = adc_status_5_s;
  assign adc_status_6 = adc_status_6_s;
  assign adc_status_7 = adc_status_7_s;
  assign adc_crc_ch_mismatch = adc_crc_ch_mismatch_s;
  assign crc_in_sync_n = |adc_crc_mismatch_s;

  // CRC check

  assign adc_crc_mismatch_s[0] = (adc_crc_read_data[0] == adc_crc_s[0]) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[1] = (adc_crc_read_data[1] == adc_crc_s[1]) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[2] = (adc_crc_read_data[2] == adc_crc_s[2]) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[3] = (adc_crc_read_data[3] == adc_crc_s[3]) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[4] = (adc_crc_read_data[4] == adc_crc_s[4] || NUM_CHANNELS == 4) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[5] = (adc_crc_read_data[5] == adc_crc_s[5] || NUM_CHANNELS == 4) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[6] = (adc_crc_read_data[6] == adc_crc_s[6] || NUM_CHANNELS == 4) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[7] = (adc_crc_read_data[7] == adc_crc_s[7] || NUM_CHANNELS == 4) ? 1'b0 : adc_crc_enable;

  assign adc_crc_s[0] = crc8(adc_crc_data_s[0], adc_crc_in_s[0]);
  assign adc_crc_s[1] = crc8(adc_crc_data_s[1], adc_crc_in_s[1]);
  assign adc_crc_s[2] = crc8(adc_crc_data_s[2], adc_crc_in_s[2]);
  assign adc_crc_s[3] = crc8(adc_crc_data_s[3], adc_crc_in_s[3]);
  assign adc_crc_s[4] = crc8(adc_crc_data_s[4], adc_crc_in_s[4]);
  assign adc_crc_s[5] = crc8(adc_crc_data_s[5], adc_crc_in_s[5]);
  assign adc_crc_s[6] = crc8(adc_crc_data_s[6], adc_crc_in_s[6]);
  assign adc_crc_s[7] = crc8(adc_crc_data_s[7], adc_crc_in_s[7]);

  assign adc_crc_in_s[0] = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg[0];
  assign adc_crc_in_s[1] = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg[1];
  assign adc_crc_in_s[2] = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg[2];
  assign adc_crc_in_s[3] = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg[3];
  assign adc_crc_in_s[4] = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg[4];
  assign adc_crc_in_s[5] = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg[5];
  assign adc_crc_in_s[6] = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg[6];
  assign adc_crc_in_s[7] = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg[7];

  assign adc_sync = adc_valid_s & ~adc_valid_s_d & sync_ss;

  // serial output data

  always @(posedge adc_clk) begin
    if (adc_valid_s) begin
      sync_ss <= 1'h1;
    end else if (adc_sync) begin
      sync_ss <= 1'h0;
    end

    adc_data_int <= adc_ch_data_d0[((32*0)+31):(32*0)] | adc_ch_data_d1[((32*1)+31):(32*1)] | adc_ch_data_d2[((32*2)+31):(32*2)] |
                    adc_ch_data_d3[((32*3)+31):(32*3)] | adc_ch_data_d4[((32*4)+31):(32*4)] | adc_ch_data_d5[((32*5)+31):(32*5)] |
                    adc_ch_data_d6[((32*6)+31):(32*6)] | adc_ch_data_d7[((32*7)+31):(32*7)];

    adc_ch_data_d0 <= {adc_ch_data_d0[((32*6)+31):(32*0)],adc_data_s[0]};
    adc_ch_data_d1 <= {adc_ch_data_d1[((32*6)+31):(32*0)],adc_data_s[1]};
    adc_ch_data_d2 <= {adc_ch_data_d2[((32*6)+31):(32*0)],adc_data_s[2]};
    adc_ch_data_d3 <= {adc_ch_data_d3[((32*6)+31):(32*0)],adc_data_s[3]};
    adc_ch_data_d4 <= {adc_ch_data_d4[((32*6)+31):(32*0)],adc_data_s[4]};
    adc_ch_data_d5 <= {adc_ch_data_d5[((32*6)+31):(32*0)],adc_data_s[5]};
    adc_ch_data_d6 <= {adc_ch_data_d6[((32*6)+31):(32*0)],adc_data_s[6]};
    adc_ch_data_d7 <= {adc_ch_data_d7[((32*6)+31):(32*0)],adc_data_s[7]};

    end

  always @(posedge adc_clk) begin

   adc_status_0_s <= (adc_valid_s == 1'b1) ? adc_data_s[0][31:24]: adc_status_0_s;
   adc_status_1_s <= (adc_valid_s == 1'b1) ? adc_data_s[1][31:24]: adc_status_1_s;
   adc_status_2_s <= (adc_valid_s == 1'b1) ? adc_data_s[2][31:24]: adc_status_2_s;
   adc_status_3_s <= (adc_valid_s == 1'b1) ? adc_data_s[3][31:24]: adc_status_3_s;
   adc_status_4_s <= (adc_valid_s == 1'b1) ? adc_data_s[4][31:24]: adc_status_4_s;
   adc_status_5_s <= (adc_valid_s == 1'b1) ? adc_data_s[5][31:24]: adc_status_5_s;
   adc_status_6_s <= (adc_valid_s == 1'b1) ? adc_data_s[6][31:24]: adc_status_6_s;
   adc_status_7_s <= (adc_valid_s == 1'b1) ? adc_data_s[7][31:24]: adc_status_7_s;
   adc_crc_ch_mismatch_s[0] <= (adc_crc_valid_p == 1'b1) ? adc_crc_mismatch_s[0] : adc_crc_ch_mismatch_s[0];
   adc_crc_ch_mismatch_s[1] <= (adc_crc_valid_p == 1'b1) ? adc_crc_mismatch_s[1] : adc_crc_ch_mismatch_s[1];
   adc_crc_ch_mismatch_s[2] <= (adc_crc_valid_p == 1'b1) ? adc_crc_mismatch_s[2] : adc_crc_ch_mismatch_s[2];
   adc_crc_ch_mismatch_s[3] <= (adc_crc_valid_p == 1'b1) ? adc_crc_mismatch_s[3] : adc_crc_ch_mismatch_s[3];
   adc_crc_ch_mismatch_s[4] <= (adc_crc_valid_p == 1'b1) ? adc_crc_mismatch_s[4] : adc_crc_ch_mismatch_s[4];
   adc_crc_ch_mismatch_s[5] <= (adc_crc_valid_p == 1'b1) ? adc_crc_mismatch_s[5] : adc_crc_ch_mismatch_s[5];
   adc_crc_ch_mismatch_s[6] <= (adc_crc_valid_p == 1'b1) ? adc_crc_mismatch_s[6] : adc_crc_ch_mismatch_s[6];
   adc_crc_ch_mismatch_s[7] <= (adc_crc_valid_p == 1'b1) ? adc_crc_mismatch_s[7] : adc_crc_ch_mismatch_s[7];

  end

  // 4 samples counter for crc

  assign adc_crc_cnt_value = 4'h4;

  assign adc_crc_cnt_enable_s = (adc_crc_cnt < adc_crc_cnt_value) ? 1'b1 : 1'b0;

  always @(posedge adc_clk) begin
    if ((crc_in_sync_n == 1'b0) || (adc_crc_enable == 1'b0) || (adc_crc_cnt_enable_s ==1'b0)) begin
      adc_crc_cnt <= 4'd0;
    end else if ((adc_valid_p == 1'b1) && (adc_crc_enable == 1'b1)) begin
      adc_crc_cnt <= adc_crc_cnt + 1'b1;
    end

    if (adc_crc_cnt == adc_crc_cnt_value) begin
      adc_crc_valid_p <= 1'b1;
    end else begin
      adc_crc_valid_p <= 1'b0;
    end
  end

  // capturing crc data

  always @(posedge adc_clk) begin
    if(adc_valid_s == 1'b1) begin
      adc_crc_data_s[0] <= {adc_crc_data_s[0][71:0],adc_data_s[0][23:0]};
      adc_crc_data_s[1] <= {adc_crc_data_s[1][71:0],adc_data_s[1][23:0]};
      adc_crc_data_s[2] <= {adc_crc_data_s[2][71:0],adc_data_s[2][23:0]};
      adc_crc_data_s[3] <= {adc_crc_data_s[3][71:0],adc_data_s[3][23:0]};
      adc_crc_data_s[4] <= {adc_crc_data_s[4][71:0],adc_data_s[4][23:0]};
      adc_crc_data_s[5] <= {adc_crc_data_s[5][71:0],adc_data_s[5][23:0]};
      adc_crc_data_s[6] <= {adc_crc_data_s[6][71:0],adc_data_s[6][23:0]};
      adc_crc_data_s[7] <= {adc_crc_data_s[7][71:0],adc_data_s[7][23:0]};
      adc_crc_read_data[0] <=adc_data_s[0][31:24];
      adc_crc_read_data[1] <=adc_data_s[1][31:24];
      adc_crc_read_data[2] <=adc_data_s[2][31:24];
      adc_crc_read_data[3] <=adc_data_s[3][31:24];
      adc_crc_read_data[4] <=adc_data_s[4][31:24];
      adc_crc_read_data[5] <=adc_data_s[5][31:24];
      adc_crc_read_data[6] <=adc_data_s[6][31:24];
      adc_crc_read_data[7] <=adc_data_s[7][31:24];
      adc_crc_reg[0]  <= adc_crc_s[0];
      adc_crc_reg[1]  <= adc_crc_s[1];
      adc_crc_reg[2]  <= adc_crc_s[2];
      adc_crc_reg[3]  <= adc_crc_s[3];
      adc_crc_reg[4]  <= adc_crc_s[4];
      adc_crc_reg[5]  <= adc_crc_s[5];
      adc_crc_reg[6]  <= adc_crc_s[6];
      adc_crc_reg[7]  <= adc_crc_s[7];
    end else begin
      adc_crc_data_s[0] <= adc_crc_data_s[0];
      adc_crc_data_s[1] <= adc_crc_data_s[1];
      adc_crc_data_s[2] <= adc_crc_data_s[2];
      adc_crc_data_s[3] <= adc_crc_data_s[3];
      adc_crc_data_s[4] <= adc_crc_data_s[4];
      adc_crc_data_s[5] <= adc_crc_data_s[5];
      adc_crc_data_s[6] <= adc_crc_data_s[6];
      adc_crc_data_s[7] <= adc_crc_data_s[7];
      adc_crc_read_data[0] <= 8'b0;
      adc_crc_read_data[1] <= 8'b0;
      adc_crc_read_data[2] <= 8'b0;
      adc_crc_read_data[3] <= 8'b0;
      adc_crc_read_data[4] <= 8'b0;
      adc_crc_read_data[5] <= 8'b0;
      adc_crc_read_data[6] <= 8'b0;
      adc_crc_read_data[7] <= 8'b0;
      adc_crc_reg[0]  <= 'b0;
      adc_crc_reg[1]  <= 'b0;
      adc_crc_reg[2]  <= 'b0;
      adc_crc_reg[3]  <= 'b0;
      adc_crc_reg[4]  <= 'b0;
      adc_crc_reg[5]  <= 'b0;
      adc_crc_reg[6]  <= 'b0;
      adc_crc_reg[7]  <= 'b0;
    end
  end

  // data capturing counter

  assign adc_cnt_value = (adc_format == 'h1 && NUM_CHANNELS == 8) ? 'hff :
                       (((adc_format == 'h2 && NUM_CHANNELS == 8) || (adc_format == 'h1 && NUM_CHANNELS == 4)) ? 'h7f : 'h1f);

  assign adc_cnt_enable_s = (adc_cnt_p < adc_cnt_value) ? 1'b1 : 1'b0;

  always @(negedge adc_clk) begin
    adc_cnt_enable_s_d <= adc_cnt_enable_s;
    if (adc_ready == 1'b0) begin
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

  //delay data 1 clk for data, data_valid and crc mismatch for alignment

  always @(posedge adc_clk) begin
    if (adc_valid_s == 1'b1) begin
      adc_data_s_d[0] <= adc_data_s[0];
      adc_data_s_d[1] <= adc_data_s[1];
      adc_data_s_d[2] <= adc_data_s[2];
      adc_data_s_d[3] <= adc_data_s[3];
      adc_data_s_d[4] <= adc_data_s[4];
      adc_data_s_d[5] <= adc_data_s[5];
      adc_data_s_d[6] <= adc_data_s[6];
      adc_data_s_d[7] <= adc_data_s[7];
      adc_valid_s_d  <= adc_valid_s;
    end else begin
      adc_data_s_d[0] <= 32'b0;
      adc_data_s_d[1] <= 32'b0;
      adc_data_s_d[2] <= 32'b0;
      adc_data_s_d[3] <= 32'b0;
      adc_data_s_d[4] <= 32'b0;
      adc_data_s_d[5] <= 32'b0;
      adc_data_s_d[6] <= 32'b0;
      adc_data_s_d[7] <= 32'b0;
      adc_valid_s_d  <=  1'b0;
    end
  end

  always @(posedge adc_clk) begin
    if (adc_valid_p == 1'b1) begin
      if(adc_format == 'h1 && NUM_CHANNELS == 8) begin          // 1 active line
        adc_data_s[0] <= adc_data_p[((32*7)+31):(32*7)];
        adc_data_s[1] <= adc_data_p[((32*6)+31):(32*6)];
        adc_data_s[2] <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_s[3] <= adc_data_p[((32*4)+31):(32*4)];
        adc_data_s[4] <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_s[5] <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_s[6] <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_s[7] <= adc_data_p[((32*0)+31):(32*0)];
      end else if((adc_format == 'h2 && NUM_CHANNELS == 8) || (adc_format == 'h1 && NUM_CHANNELS == 4)) begin   // 2 active lines or 1 for ad7768-4
        adc_data_s[0] <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_s[1] <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_s[2] <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_s[3] <= adc_data_p[((32*0)+31):(32*0)];
        adc_data_s[4] <= adc_data_p[((32*7)+31):(32*7)];
        adc_data_s[5] <= adc_data_p[((32*6)+31):(32*6)];
        adc_data_s[6] <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_s[7] <= adc_data_p[((32*4)+31):(32*4)];
      end else begin                       // 8 active lines
        adc_data_s[0] <= adc_data_p[((32*0)+31):(32*0)];
        adc_data_s[1] <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_s[2] <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_s[3] <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_s[4] <= adc_data_p[((32*4)+31):(32*4)];
        adc_data_s[5] <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_s[6] <= adc_data_p[((32*6)+31):(32*6)];
        adc_data_s[7] <= adc_data_p[((32*7)+31):(32*7)];
      end
      adc_valid_s    <= adc_valid_p;
    end else begin
      adc_data_s[0] <= 32'b0;
      adc_data_s[1] <= 32'b0;
      adc_data_s[2] <= 32'b0;
      adc_data_s[3] <= 32'b0;
      adc_data_s[4] <= 32'b0;
      adc_data_s[5] <= 32'b0;
      adc_data_s[6] <= 32'b0;
      adc_data_s[7] <= 32'b0;
	    adc_valid_s  <=  1'b0;
    end
  end

  // data (individual lanes)

  always @(negedge adc_clk) begin
    if(adc_format == 'h1 && NUM_CHANNELS == 8) begin     // 1 active line for ad7768
      if (adc_cnt_p == 'h0) begin
        adc_data_p[((256*0)+255):(256*0)] <= {255'd0, data_in[0]};
      end else begin
        adc_data_p[((256*0)+255):(255*0)] <= {adc_data_p[((256*0)+254):(256*0)], data_in[0]};
      end
    end else if((adc_format == 'h2 && NUM_CHANNELS == 8) || (adc_format == 'h1 && NUM_CHANNELS == 4)) begin  // 2 active lines or 1 active lane for ad7768-4
      if (adc_cnt_p == 'h0) begin
        adc_data_p[((128*0)+127):(128*0)] <= {127'd0, data_in[0]};
        adc_data_p[((128*1)+127):(128*1)] <= {127'd0, data_in[1]};
      end else begin
        adc_data_p[((128*0)+127):(128*0)] <= {adc_data_p[((128*0)+126):(128*0)], data_in[0]};
        adc_data_p[((128*1)+127):(128*1)] <= {adc_data_p[((128*1)+126):(128*1)], data_in[1]};
      end
    end else begin   // 8 active lines or 4 active lane for ad7768-4
     if (adc_cnt_p == 'h0) begin
        adc_data_p[((32*0)+31):(32*0)] <= {31'd0, data_in[0]};
        adc_data_p[((32*1)+31):(32*1)] <= {31'd0, data_in[1]};
        adc_data_p[((32*2)+31):(32*2)] <= {31'd0, data_in[2]};
        adc_data_p[((32*3)+31):(32*3)] <= {31'd0, data_in[3]};
        adc_data_p[((32*4)+31):(32*4)] <= {31'd0, data_in[4]};
        adc_data_p[((32*5)+31):(32*5)] <= {31'd0, data_in[5]};
        adc_data_p[((32*6)+31):(32*6)] <= {31'd0, data_in[6]};
        adc_data_p[((32*7)+31):(32*7)] <= {31'd0, data_in[7]};
      end else begin
        adc_data_p[((32*0)+31):(32*0)] <= {adc_data_p[((32*0)+30):(32*0)], data_in[0]};
        adc_data_p[((32*1)+31):(32*1)] <= {adc_data_p[((32*1)+30):(32*1)], data_in[1]};
        adc_data_p[((32*2)+31):(32*2)] <= {adc_data_p[((32*2)+30):(32*2)], data_in[2]};
        adc_data_p[((32*3)+31):(32*3)] <= {adc_data_p[((32*3)+30):(32*3)], data_in[3]};
        adc_data_p[((32*4)+31):(32*4)] <= {adc_data_p[((32*4)+30):(32*4)], data_in[4]};
        adc_data_p[((32*5)+31):(32*5)] <= {adc_data_p[((32*5)+30):(32*5)], data_in[5]};
        adc_data_p[((32*6)+31):(32*6)] <= {adc_data_p[((32*6)+30):(32*6)], data_in[6]};
        adc_data_p[((32*7)+31):(32*7)] <= {adc_data_p[((32*7)+30):(32*7)], data_in[7]};
      end
    end
  end

  // ready (single shot or continous)

  always @(posedge adc_clk) begin
    adc_ready <= adc_sshot ~^ adc_ready_in_s;
  end

endmodule
