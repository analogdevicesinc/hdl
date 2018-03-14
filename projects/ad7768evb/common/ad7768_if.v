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

`timescale 1ns/100ps

module ad7768_if (

  // device-interface

  input                   clk_in,
  input                   ready_in,
  input       [ 7:0]      data_in,

  // data path interface

  output                  adc_clk,
  output  reg             adc_valid,
  output  reg [ 31:0]     adc_data,

  // control interface

  input                   up_sshot,
  input       [ 1:0]      up_format,
  input                   up_crc_enable,
  input                   up_crc_4_or_16_n,
  input       [ 35:0]     up_status_clr,
  output      [ 35:0]     up_status);

  // internal registers

  reg     [  1:0]   adc_status_8 = 'd0;
  reg     [  2:0]   adc_status_7 = 'd0;
  reg     [  2:0]   adc_status_6 = 'd0;
  reg     [  2:0]   adc_status_5 = 'd0;
  reg     [  2:0]   adc_status_4 = 'd0;
  reg     [  2:0]   adc_status_3 = 'd0;
  reg     [  2:0]   adc_status_2 = 'd0;
  reg     [  2:0]   adc_status_1 = 'd0;
  reg     [  2:0]   adc_status_0 = 'd0;
  reg     [  2:0]   adc_seq = 'd0;
  reg     [  4:0]   adc_status = 'd0;
  reg     [ 63:0]   adc_crc_8 = 'd0;
  reg     [  7:0]   adc_crc_mismatch_int = 'd0;
  reg               adc_crc_valid = 'd0;
  reg     [  7:0]   adc_crc_data = 'd0;
  reg     [  7:0]   adc_crc_mismatch_8 = 'd0;
  reg               adc_valid_int = 'd0;
  reg     [ 31:0]   adc_data_int = 'd0;
  reg     [  2:0]   adc_seq_int = 'd0;
  reg               adc_enable_int = 'd0;
  reg     [  3:0]   adc_crc_scnt_int = 'd0;
  reg     [  3:0]   adc_crc_scnt_8 = 'd0;
  reg     [ 23:0]   adc_seq_data = 'd0;
  reg               adc_seq_fmatch = 'd0;
  reg     [ 23:0]   adc_seq_fdata = 'd0;
  reg               adc_seq_foos = 'd0;
  reg     [  7:0]   adc_enable_8 = 'd0;
  reg     [ 23:0]   adc_seq_8 = 'd0;
  reg               adc_valid_8 = 'd0;
  reg     [ 31:0]   adc_data_8 = 'd0;
  reg     [  7:0]   adc_ch_valid_d = 'd0;
  reg     [255:0]   adc_ch_data_d0 = 'd0;
  reg     [255:0]   adc_ch_data_d1 = 'd0;
  reg     [255:0]   adc_ch_data_d2 = 'd0;
  reg     [255:0]   adc_ch_data_d3 = 'd0;
  reg     [255:0]   adc_ch_data_d4 = 'd0;
  reg     [255:0]   adc_ch_data_d5 = 'd0;
  reg     [255:0]   adc_ch_data_d6 = 'd0;
  reg     [255:0]   adc_ch_data_d7 = 'd0;
  reg               adc_ch_valid_0 = 'd0;
  reg               adc_ch_valid_1 = 'd0;
  reg               adc_ch_valid_2 = 'd0;
  reg               adc_ch_valid_3 = 'd0;
  reg               adc_ch_valid_4 = 'd0;
  reg               adc_ch_valid_5 = 'd0;
  reg               adc_ch_valid_6 = 'd0;
  reg               adc_ch_valid_7 = 'd0;
  reg     [ 31:0]   adc_ch_data_0 = 'd0;
  reg     [ 31:0]   adc_ch_data_1 = 'd0;
  reg     [ 31:0]   adc_ch_data_2 = 'd0;
  reg     [ 31:0]   adc_ch_data_3 = 'd0;
  reg     [ 31:0]   adc_ch_data_4 = 'd0;
  reg     [ 31:0]   adc_ch_data_5 = 'd0;
  reg     [ 31:0]   adc_ch_data_6 = 'd0;
  reg     [ 31:0]   adc_ch_data_7 = 'd0;
  reg               adc_ch_valid = 'd0;
  reg     [255:0]   adc_ch_data = 'd0;
  reg     [  8:0]   adc_cnt_p = 'd0;
  reg               adc_valid_p = 'd0;
  reg     [255:0]   adc_data_p = 'd0;
  reg     [  7:0]   adc_data_d1 = 'd0;
  reg     [  7:0]   adc_data_d2 = 'd0;
  reg               adc_ready_d1 = 'd0;
  reg               adc_ready = 'd0;
  reg               adc_ready_d = 'd0;
  reg               adc_sshot_m1 = 'd0;
  reg               adc_sshot = 'd0;
  reg     [  1:0]   adc_format_m1 = 'd0;
  reg     [  1:0]   adc_format = 'd0;
  reg               adc_crc_enable_m1 = 'd0;
  reg               adc_crc_enable = 'd0;
  reg               adc_crc_4_or_16_n_m1 = 'd0;
  reg               adc_crc_4_or_16_n = 'd0;
  reg     [ 35:0]   adc_status_clr_m1 = 'd0;
  reg     [ 35:0]   adc_status_clr = 'd0;
  reg     [ 35:0]   adc_status_clr_d = 'd0;

  // internal signals

  wire    [  7:0]   adc_crc_in_s;
  wire    [  7:0]   adc_crc_s;
  wire              adc_crc_mismatch_s;
  wire              adc_seq_fmatch_s;
  wire              adc_seq_fupdate_s;
  wire    [  7:0]   adc_enable_8_s;
  wire    [ 23:0]   adc_seq_8_s;
  wire              adc_cnt_enable_1_s;
  wire              adc_cnt_enable_4_s;
  wire              adc_cnt_enable_8_s;
  wire              adc_cnt_enable_s;
  wire    [  7:0]   adc_data_in_s;
  wire              adc_ready_in_s;
  wire              adc_clk_in_s;
  wire    [ 35:0]   adc_status_clr_s;

  // function (crc)

  function  [ 7:0]  crc8;
    input   [23:0]  din;
    input   [ 7:0]  cin;
    reg     [ 7:0]  cout;
    begin
      cout[ 7] =  cin[ 1] ^ cin[ 2] ^ cin[ 4] ^ cin[ 6] ^ din[ 5] ^ din[ 6] ^ din[ 7] ^ din[11] ^
                  din[13] ^ din[15] ^ din[17] ^ din[18] ^ din[20] ^ din[22];
      cout[ 6] =  cin[ 0] ^ cin[ 1] ^ cin[ 3] ^ cin[ 5] ^ din[ 4] ^ din[ 5] ^ din[ 6] ^ din[10] ^
                  din[12] ^ din[14] ^ din[16] ^ din[17] ^ din[19] ^ din[21];
      cout[ 5] =  cin[ 0] ^ cin[ 2] ^ cin[ 4] ^ din[ 3] ^ din[ 4] ^ din[ 5] ^ din[ 9] ^ din[11] ^
                  din[13] ^ din[15] ^ din[16] ^ din[18] ^ din[20];
      cout[ 4] =  cin[ 1] ^ cin[ 3] ^ din[ 2] ^ din[ 3] ^ din[ 4] ^ din[ 8] ^ din[10] ^ din[12] ^
                  din[14] ^ din[15] ^ din[17] ^ din[19];
      cout[ 3] =  cin[ 0] ^ cin[ 2] ^ cin[ 7] ^ din[ 1] ^ din[ 2] ^ din[ 3] ^ din[ 7] ^ din[ 9] ^
                  din[11] ^ din[13] ^ din[14] ^ din[16] ^ din[18] ^ din[23];
      cout[ 2] =  cin[ 1] ^ cin[ 6] ^ din[ 0] ^ din[ 1] ^ din[ 2] ^ din[ 6] ^ din[ 8] ^ din[10] ^
                  din[12] ^ din[13] ^ din[15] ^ din[17] ^ din[22];
      cout[ 1] =  cin[ 0] ^ cin[ 1] ^ cin[ 2] ^ cin[ 4] ^ cin[ 5] ^ cin[ 6] ^ cin[ 7] ^ din[ 0] ^
                  din[ 1] ^ din[ 6] ^ din[ 9] ^ din[12] ^ din[13] ^ din[14] ^ din[15] ^ din[16] ^
                  din[17] ^ din[18] ^ din[20] ^ din[21] ^ din[22] ^ din[23];
      cout[ 0] =  cin[ 0] ^ cin[ 2] ^ cin[ 3] ^ cin[ 5] ^ cin[ 7] ^ din[ 0] ^ din[ 6] ^ din[ 7] ^
                  din[ 8] ^ din[12] ^ din[14] ^ din[16] ^ din[18] ^ din[19] ^ din[21] ^ din[23];
      crc8 = cout;
    end
  endfunction

  // status

  assign up_status[35:32] = {2'd0, adc_status_8};
  assign up_status[31:28] = {1'd0, adc_status_7};
  assign up_status[27:24] = {1'd0, adc_status_6};
  assign up_status[23:20] = {1'd0, adc_status_5};
  assign up_status[19:16] = {1'd0, adc_status_4};
  assign up_status[15:12] = {1'd0, adc_status_3};
  assign up_status[11: 8] = {1'd0, adc_status_2};
  assign up_status[ 7: 4] = {1'd0, adc_status_1};
  assign up_status[ 3: 0] = {1'd0, adc_status_0};

  always @(posedge adc_clk) begin
    if (adc_valid == 1'b1) begin
      adc_status_8 <= adc_status_8 | adc_status[1:0];
    end else begin
      adc_status_8 <= adc_status_8 & ~adc_status_clr_s[33:32];
    end
    if ((adc_valid == 1'b1) && (adc_seq[2:0] == 3'd7)) begin
      adc_status_7 <= adc_status_7 | adc_status[4:2];
    end else begin
      adc_status_7 <= adc_status_7 & ~adc_status_clr_s[30:28];
    end
    if ((adc_valid == 1'b1) && (adc_seq[2:0] == 3'd6)) begin
      adc_status_6 <= adc_status_6 | adc_status[4:2];
    end else begin
      adc_status_6 <= adc_status_6 & ~adc_status_clr_s[26:24];
    end
    if ((adc_valid == 1'b1) && (adc_seq[2:0] == 3'd5)) begin
      adc_status_5 <= adc_status_5 | adc_status[4:2];
    end else begin
      adc_status_5 <= adc_status_5 & ~adc_status_clr_s[22:20];
    end
    if ((adc_valid == 1'b1) && (adc_seq[2:0] == 3'd4)) begin
      adc_status_4 <= adc_status_4 | adc_status[4:2];
    end else begin
      adc_status_4 <= adc_status_4 & ~adc_status_clr_s[18:16];
    end
    if ((adc_valid == 1'b1) && (adc_seq[2:0] == 3'd3)) begin
      adc_status_3 <= adc_status_3 | adc_status[4:2];
    end else begin
      adc_status_3 <= adc_status_3 & ~adc_status_clr_s[14:12];
    end
    if ((adc_valid == 1'b1) && (adc_seq[2:0] == 3'd2)) begin
      adc_status_2 <= adc_status_2 | adc_status[4:2];
    end else begin
      adc_status_2 <= adc_status_2 & ~adc_status_clr_s[10: 8];
    end
    if ((adc_valid == 1'b1) && (adc_seq[2:0] == 3'd1)) begin
      adc_status_1 <= adc_status_1 | adc_status[4:2];
    end else begin
      adc_status_1 <= adc_status_1 & ~adc_status_clr_s[ 6: 4];
    end
    if ((adc_valid == 1'b1) && (adc_seq[2:0] == 3'd0)) begin
      adc_status_0 <= adc_status_0 | adc_status[4:2];
    end else begin
      adc_status_0 <= adc_status_0 & ~adc_status_clr_s[ 2: 0];
    end
  end

  // data & status

  always @(posedge adc_clk) begin
    adc_valid <= adc_valid_int & adc_enable_int;
    adc_data <= {{8{adc_data_int[23]}}, adc_data_int[23:0]};
    adc_seq <= adc_seq_int;
    if ((adc_crc_enable == 1'b1) && (adc_crc_scnt_int == 4'd0)) begin
      adc_status[4] <= adc_crc_mismatch_8[7] & adc_enable_int;
      adc_status[3] <= 1'b0;
      adc_status[2] <= 1'b0;
      adc_status[1] <= 1'b0;
      adc_status[0] <= adc_seq_foos;
    end else begin
      adc_status[4] <= adc_crc_mismatch_8[7] & adc_enable_int;
      adc_status[3] <= adc_data_int[30] & adc_enable_int;
      adc_status[2] <= adc_data_int[27] & adc_enable_int;
      adc_status[1] <= adc_data_int[31] & adc_enable_int;
      adc_status[0] <= adc_seq_foos;
    end 
  end

  // crc- not much useful at the interface, since it is post-framing

  assign adc_crc_in_s = (adc_crc_scnt_int == 4'd1) ? 8'hff : adc_crc_8[63:56];
  assign adc_crc_s = crc8(adc_data_int[23:0], adc_crc_in_s);
  assign adc_crc_mismatch_s = (adc_crc_data == adc_crc_8[7:0]) ? 1'b0 : adc_crc_enable;

  always @(posedge adc_clk) begin
    if (adc_valid_int == 1'b1) begin
      adc_crc_8 <= {adc_crc_8[55:0], adc_crc_s};
    end
    if (adc_valid_int == 1'b1) begin
      adc_crc_mismatch_int <= {adc_crc_mismatch_int[6:0], 1'd0};
    end else begin
      adc_crc_mismatch_int <= adc_crc_mismatch_8;
    end
    if (adc_crc_scnt_int == 4'd0) begin
      adc_crc_valid <= adc_valid_int;
    end else begin
      adc_crc_valid <= 1'd0;
    end
    adc_crc_data <= adc_data_int[31:24];
    if (adc_crc_valid == 1'b1) begin
      adc_crc_mismatch_8 <= {adc_crc_mismatch_8[6:0], adc_crc_mismatch_s};
    end
  end

  // data interleaved & all-aligned

  always @(posedge adc_clk) begin
    adc_valid_int <= adc_valid_8;
    adc_data_int <= adc_data_8;
    adc_seq_int <= adc_seq_8[23:21];
    adc_enable_int <= adc_enable_8[7] & adc_valid_8;
    adc_crc_scnt_int <= adc_crc_scnt_8;
  end

  // crc- count

  always @(posedge adc_clk) begin
    if ((adc_ready == 1'b0) && (adc_ready_d == 1'b1)) begin
      if (adc_seq_fmatch_s == 1'b0) begin
        adc_crc_scnt_8 <= 4'd1;
      end else if ((adc_crc_4_or_16_n == 1'b1) && (adc_crc_scnt_8 == 4'h3)) begin
        adc_crc_scnt_8 <= 4'd0;
      end else begin
        adc_crc_scnt_8 <= adc_crc_scnt_8 + 1'b1;
      end
    end
  end

  // three sample framing logic

  always @(posedge adc_clk) begin
    if (adc_ready == 1'b0) begin
      adc_seq_data <= 24'd0;
    end else if (adc_valid_8 == 1'b1) begin
      adc_seq_data <= {adc_seq_data[20:0], adc_data_8[26:24]};
    end
  end

  assign adc_seq_fmatch_s = (adc_seq_data == adc_seq_fdata) ? 1'b1 : 1'b0;
  assign adc_seq_fupdate_s = adc_seq_fmatch_s ^ adc_seq_fmatch;

  always @(posedge adc_clk) begin
    if ((adc_ready == 1'b0) && (adc_ready_d == 1'b1)) begin
      adc_seq_fmatch <= adc_seq_fmatch_s;
      if (adc_seq_foos == 1'b1) begin
        adc_seq_fdata <= adc_seq_data;
      end
      if (adc_seq_fupdate_s == 1'b0) begin
        adc_seq_foos <= ~adc_seq_fmatch_s;
      end
    end
  end

  // we are cluless on 0 -- safe to compare all 32bits against 0x0?

  assign adc_enable_8_s[7] = (adc_seq_8[23:21] == adc_seq_fdata[23:21]) ? 1'b1 : 1'b0;
  assign adc_enable_8_s[6] = (adc_seq_8[20:18] == adc_seq_fdata[20:18]) ? 1'b1 : 1'b0;
  assign adc_enable_8_s[5] = (adc_seq_8[17:15] == adc_seq_fdata[17:15]) ? 1'b1 : 1'b0;
  assign adc_enable_8_s[4] = (adc_seq_8[14:12] == adc_seq_fdata[14:12]) ? 1'b1 : 1'b0;
  assign adc_enable_8_s[3] = (adc_seq_8[11: 9] == adc_seq_fdata[11: 9]) ? 1'b1 : 1'b0;
  assign adc_enable_8_s[2] = (adc_seq_8[ 8: 6] == adc_seq_fdata[ 8: 6]) ? 1'b1 : 1'b0;
  assign adc_enable_8_s[1] = (adc_seq_8[ 5: 3] == adc_seq_fdata[ 5: 3]) ? 1'b1 : 1'b0;
  assign adc_enable_8_s[0] = (adc_seq_8[ 2: 0] == adc_seq_fdata[ 2: 0]) ? 1'b1 : 1'b0;

  always @(posedge adc_clk) begin
    if (adc_ready_d == 1'b0) begin
      adc_enable_8 <= adc_enable_8_s;
    end else if (adc_valid_8 == 1'b1) begin
      adc_enable_8 <= {adc_enable_8[6:0], 1'd0};
    end
  end

  // channel-sequence

  assign adc_seq_8_s[23:21] = (adc_format == 2'b01) ? 3'd0 : 3'd0;
  assign adc_seq_8_s[20:18] = (adc_format == 2'b01) ? 3'd4 : 3'd1;
  assign adc_seq_8_s[17:15] = (adc_format == 2'b01) ? 3'd1 : 3'd2;
  assign adc_seq_8_s[14:12] = (adc_format == 2'b01) ? 3'd5 : 3'd3;
  assign adc_seq_8_s[11: 9] = (adc_format == 2'b01) ? 3'd2 : 3'd4;
  assign adc_seq_8_s[ 8: 6] = (adc_format == 2'b01) ? 3'd6 : 3'd5;
  assign adc_seq_8_s[ 5: 3] = (adc_format == 2'b01) ? 3'd3 : 3'd6;
  assign adc_seq_8_s[ 2: 0] = (adc_format == 2'b01) ? 3'd7 : 3'd7;

  always @(posedge adc_clk) begin
    if ((adc_ready == 1'b0) && (adc_ready_d == 1'b1)) begin
      adc_seq_8 <= adc_seq_8_s;
    end else if (adc_valid_8 == 1'b1) begin
      adc_seq_8 <= {adc_seq_8[20:0], 3'd0};
    end
  end

  // data (interleaving)

  always @(posedge adc_clk) begin
    adc_valid_8 <=  adc_ch_valid_0 | adc_ch_valid_1 | adc_ch_valid_2 | adc_ch_valid_3 |
                    adc_ch_valid_4 | adc_ch_valid_5 | adc_ch_valid_6 | adc_ch_valid_7;
    adc_data_8 <= adc_ch_data_0 | adc_ch_data_1 | adc_ch_data_2 | adc_ch_data_3 |
                  adc_ch_data_4 | adc_ch_data_5 | adc_ch_data_6 | adc_ch_data_7;
  end

  always @(posedge adc_clk) begin
    adc_ch_valid_d <= {adc_ch_valid_d[6:0], adc_ch_valid};
    adc_ch_data_d0[((32*0)+31):(32*0)] <= adc_ch_data[((32*0)+31):(32*0)];
    adc_ch_data_d0[((32*7)+31):(32*1)] <= adc_ch_data_d0[((32*6)+31):(32*0)];
    adc_ch_data_d1[((32*0)+31):(32*0)] <= adc_ch_data[((32*1)+31):(32*1)];
    adc_ch_data_d1[((32*7)+31):(32*1)] <= adc_ch_data_d1[((32*6)+31):(32*0)];
    adc_ch_data_d2[((32*0)+31):(32*0)] <= adc_ch_data[((32*2)+31):(32*2)];
    adc_ch_data_d2[((32*7)+31):(32*1)] <= adc_ch_data_d2[((32*6)+31):(32*0)];
    adc_ch_data_d3[((32*0)+31):(32*0)] <= adc_ch_data[((32*3)+31):(32*3)];
    adc_ch_data_d3[((32*7)+31):(32*1)] <= adc_ch_data_d3[((32*6)+31):(32*0)];
    adc_ch_data_d4[((32*0)+31):(32*0)] <= adc_ch_data[((32*4)+31):(32*4)];
    adc_ch_data_d4[((32*7)+31):(32*1)] <= adc_ch_data_d4[((32*6)+31):(32*0)];
    adc_ch_data_d5[((32*0)+31):(32*0)] <= adc_ch_data[((32*5)+31):(32*5)];
    adc_ch_data_d5[((32*7)+31):(32*1)] <= adc_ch_data_d5[((32*6)+31):(32*0)];
    adc_ch_data_d6[((32*0)+31):(32*0)] <= adc_ch_data[((32*6)+31):(32*6)];
    adc_ch_data_d6[((32*7)+31):(32*1)] <= adc_ch_data_d6[((32*6)+31):(32*0)];
    adc_ch_data_d7[((32*0)+31):(32*0)] <= adc_ch_data[((32*7)+31):(32*7)];
    adc_ch_data_d7[((32*7)+31):(32*1)] <= adc_ch_data_d7[((32*6)+31):(32*0)];
  end

  always @(posedge adc_clk) begin
    adc_ch_valid_0 <= adc_ch_valid_d[0];
    adc_ch_valid_1 <= adc_ch_valid_d[1] & ~adc_format[1];
    adc_ch_valid_2 <= adc_ch_valid_d[2] & ~adc_format[1] & ~adc_format[0];
    adc_ch_valid_3 <= adc_ch_valid_d[3] & ~adc_format[1] & ~adc_format[0];
    adc_ch_valid_4 <= adc_ch_valid_d[4] & ~adc_format[1] & ~adc_format[0];
    adc_ch_valid_5 <= adc_ch_valid_d[5] & ~adc_format[1] & ~adc_format[0];
    adc_ch_valid_6 <= adc_ch_valid_d[6] & ~adc_format[1] & ~adc_format[0];
    adc_ch_valid_7 <= adc_ch_valid_d[7] & ~adc_format[1] & ~adc_format[0];
    adc_ch_data_0 <= adc_ch_data_d0[((32*0)+31):(32*0)];
    adc_ch_data_1 <= adc_ch_data_d1[((32*1)+31):(32*1)];
    adc_ch_data_2 <= adc_ch_data_d2[((32*2)+31):(32*2)];
    adc_ch_data_3 <= adc_ch_data_d3[((32*3)+31):(32*3)];
    adc_ch_data_4 <= adc_ch_data_d4[((32*4)+31):(32*4)];
    adc_ch_data_5 <= adc_ch_data_d5[((32*5)+31):(32*5)];
    adc_ch_data_6 <= adc_ch_data_d6[((32*6)+31):(32*6)];
    adc_ch_data_7 <= adc_ch_data_d7[((32*7)+31):(32*7)];
  end

  always @(posedge adc_clk) begin
    adc_ch_valid <= adc_valid_p;
    if (adc_valid_p == 1'b1) begin
      adc_ch_data <= adc_data_p;
    end else begin
      adc_ch_data <= 256'd0;
    end
  end

  // data (common)

  assign adc_cnt_enable_1_s = (adc_cnt_p <= 9'h01f) ? 1'b1 : 1'b0;
  assign adc_cnt_enable_4_s = (adc_cnt_p <= 9'h07f) ? 1'b1 : 1'b0;
  assign adc_cnt_enable_8_s = (adc_cnt_p <= 9'h0ff) ? 1'b1 : 1'b0;

  assign adc_cnt_enable_s = (adc_format == 2'b00) ? adc_cnt_enable_1_s :
    ((adc_format == 2'b01) ? adc_cnt_enable_4_s : adc_cnt_enable_8_s);

  always @(posedge adc_clk) begin
    if (adc_ready == 1'b0) begin
      adc_cnt_p <= 9'h000;
    end else if (adc_cnt_enable_s == 1'b1) begin
      adc_cnt_p <= adc_cnt_p + 1'b1;
    end
    if (adc_cnt_p[4:0] == 5'h1f) begin
      adc_valid_p <= 1'b1;
    end else begin
      adc_valid_p <= 1'b0;
    end
  end

  // data (individual lanes)

  genvar n;
  generate
  for (n = 0; n < 8; n = n + 1) begin: g_data

  always @(posedge adc_clk) begin
    if (adc_cnt_p[4:0] == 5'h00) begin
      adc_data_p[((32*n)+31):(32*n)] <= {31'd0, adc_data_d2[n]};
    end else begin
      adc_data_p[((32*n)+31):(32*n)] <= {adc_data_p[((32*n)+30):(32*n)], adc_data_d2[n]};
    end
  end

  always @(posedge adc_clk) begin
    adc_data_d1[n] <= adc_data_in_s[n];
    adc_data_d2[n] <= adc_data_d1[n];
  end

  IBUF i_ibuf_data (
    .I (data_in[n]),
    .O (adc_data_in_s[n]));

  end
  endgenerate

  // ready (single shot or continous)

  always @(posedge adc_clk) begin
    adc_ready_d1 <= adc_ready_in_s;
    adc_ready <= adc_sshot ~^ adc_ready_d1;
    adc_ready_d <= adc_ready;
  end

  IBUF i_ibuf_ready (
    .I (ready_in),
    .O (adc_ready_in_s));

  // clock (use bufg delay ~4ns on 29ns)

  BUFG i_bufg_clk (
    .I (adc_clk_in_s),
    .O (adc_clk));

  IBUFG i_ibufg_clk (
    .I (clk_in),
    .O (adc_clk_in_s));

  // control signals

  assign adc_status_clr_s = adc_status_clr & ~adc_status_clr_d;

  always @(posedge adc_clk) begin
    adc_sshot_m1 <= up_sshot;
    adc_sshot <= adc_sshot_m1;
    adc_format_m1 <= up_format;
    adc_format <= adc_format_m1;
    adc_crc_enable_m1 <= up_crc_enable;
    adc_crc_enable <= adc_crc_enable_m1;
    adc_crc_4_or_16_n_m1 <= up_crc_4_or_16_n;
    adc_crc_4_or_16_n <= adc_crc_4_or_16_n_m1;
    adc_status_clr_m1 <= up_status_clr;
    adc_status_clr <= adc_status_clr_m1;
    adc_status_clr_d <= adc_status_clr;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
