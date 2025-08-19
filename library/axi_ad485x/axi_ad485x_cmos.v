// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
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

module axi_ad485x_cmos #(

  parameter FPGA_TECHNOLOGY = 0,
  parameter RESOLUTION = 20,
  parameter DELAY_REFCLK_FREQ = 200,
  parameter IODELAY_ENABLE = 1,
  parameter IODELAY_GROUP = "dev_if_delay_group",
  parameter ACTIVE_LANE = 8'b11111111,
  parameter N_CHANNELS = 8
) (

  input                   rst,
  input                   clk,
  input        [ 7:0]     adc_enable,
  input                   adc_crc_enable,

  // physical interface

  output                  scki,
  input                   scko,
  input       [ 7:0]      db_i,
  input                   busy,
  input                   cnvs,

  // format

  input       [ 1:0]      packet_format_in,
  input                   oversampling_en,

  // channel interface

  output     [255:0]      adc_data,
  output reg              adc_valid,
  output reg              crc_error,
  output      [ 7:0]      dev_status,

  // delay interface (for IDELAY macros)

  input                   up_clk,
  input       [ 7:0]      up_adc_dld,
  input       [39:0]      up_adc_dwdata,
  output      [39:0]      up_adc_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked
);

  localparam DW  = (32 * N_CHANNELS);
  localparam FBW = DW + 31;

  localparam [5:0] PACKET_1 = RESOLUTION == 16 ? 16 : 20;
  localparam [5:0] PACKET_2 = RESOLUTION == 16 ? 24 : 24;
  localparam [5:0] PACKET_3 = RESOLUTION == 16 ? 24 : 32;

  // internal registers

  reg         [31:0]  adc_lane_0;
  reg         [31:0]  adc_lane_1;
  reg         [31:0]  adc_lane_2;
  reg         [31:0]  adc_lane_3;
  reg         [31:0]  adc_lane_4;
  reg         [31:0]  adc_lane_5;
  reg         [31:0]  adc_lane_6;
  reg         [31:0]  adc_lane_7;

  reg         [ 1:0]  packet_format;
  reg         [ 5:0]  data_counter = 6'h0;
  reg         [ 5:0]  scki_counter = 6'h0;
  reg                 adc_captured;
  reg                 adc_captured_d;
  reg         [ 6:0]  capture_cnt;

  reg                 scki_i;
  reg                 scki_d;

  reg         [31:0]  adc_data_store[8:0];
  reg         [31:0]  adc_data_init[7:0];

  reg         [ 8:0]  ch_captured;

  reg         [ 4:0]  adc_ch0_shift;
  reg         [ 4:0]  adc_ch1_shift;
  reg         [ 4:0]  adc_ch2_shift;
  reg         [ 4:0]  adc_ch3_shift;
  reg         [ 4:0]  adc_ch4_shift;
  reg         [ 4:0]  adc_ch5_shift;
  reg         [ 4:0]  adc_ch6_shift;
  reg         [ 4:0]  adc_ch7_shift;

  reg         [ 3:0]  lane_0_data = 'd0;
  reg         [ 3:0]  lane_1_data = 'd0;
  reg         [ 3:0]  lane_2_data = 'd0;
  reg         [ 3:0]  lane_3_data = 'd0;
  reg         [ 3:0]  lane_4_data = 'd0;
  reg         [ 3:0]  lane_5_data = 'd0;
  reg         [ 3:0]  lane_6_data = 'd0;
  reg         [ 3:0]  lane_7_data = 'd0;
  reg         [ 8:0]  ch_data_lock = 'h1ff;
  reg                 adc_valid_init = 'd0;
  reg                 adc_valid_init_d1 = 'd0;
  reg                 adc_valid_init_d2 = 'd0;

  reg                 busy_m1;
  reg                 busy_m2;
  reg                 cnvs_d;
  reg         [31:0]  period_cnt;

  reg                 adc_valid_d;
  reg                 conversion_quiet_time;
  reg                 run_busy_period_cnt;
  reg         [31:0]  busy_conversion_cnt;
  reg         [31:0]  busy_measure_value;
  reg                 start_transfer;

  reg                 crc_enable_window;
  reg                 run_crc;
  reg                 run_crc_d;
  reg        [FBW:0]  crc_data_in;
  reg        [FBW:0]  crc_data_in_sh;
  reg         [15:0]  crc_cnt;
  reg         [ 7:0]  data_in_byte;
  reg         [15:0]  crc_data_length;

  reg         [ 3:0]  ch_0_index = 4'd0;
  reg         [ 3:0]  ch_1_index = 4'd1;
  reg         [ 3:0]  ch_2_index = 4'd2;
  reg         [ 3:0]  ch_3_index = 4'd3;
  reg         [ 3:0]  ch_4_index = 4'd4;
  reg         [ 3:0]  ch_5_index = 4'd5;
  reg         [ 3:0]  ch_6_index = 4'd6;
  reg         [ 3:0]  ch_7_index = 4'd7;
  reg         [ 3:0]  ch_0_index_d = 4'd0;
  reg         [ 3:0]  ch_1_index_d = 4'd1;
  reg         [ 3:0]  ch_2_index_d = 4'd2;
  reg         [ 3:0]  ch_3_index_d = 4'd3;
  reg         [ 3:0]  ch_4_index_d = 4'd4;
  reg         [ 3:0]  ch_5_index_d = 4'd5;
  reg         [ 3:0]  ch_6_index_d = 4'd6;
  reg         [ 3:0]  ch_7_index_d = 4'd7;
  reg         [ 8:0]  ch_data_capt = 9'd0;
  reg                 new_transfer = 1'd0;
  reg                 new_transfer_d = 1'd0;

  // internal wires

  wire        [ 7:0]  db_s;

  wire        [31:0]  status_and_crc_data;

  wire                aquire_data;
  wire                scki_cnt_rst;
  wire                adc_cnvs_redge;
  wire                conversion_completed;
  wire                conversion_quiet_time_s;

  wire        [ 5:0]  packet_lenght;

  wire                crc_reset;
  wire                crc_enable;
  wire                crc_valid;
  wire        [15:0]  crc_res;
  wire                adc_valid_s;

  // packet format selection

  always @(posedge clk) begin
    packet_format <= packet_format_in;
  end

  assign packet_lenght = packet_format == 2'd0 ? PACKET_1 :
                         packet_format == 2'd1 ? PACKET_2 : PACKET_3;

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      busy_m1 <= 1'b0;
      busy_m2 <= 1'b0;
      start_transfer <= 1'b0;
    end else begin
      busy_m1 <= busy;
      busy_m2 <= busy_m1;
      start_transfer <= busy_m2 & !busy_m1;
    end
  end

  always @(posedge clk) begin
    if (start_transfer) begin
      crc_enable_window <= adc_crc_enable;
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      scki_counter <= 5'h0;
      scki_i <= 1'b1;
      scki_d <=  1'b0;
    end else begin
      scki_d <= scki_i;
      if (aquire_data == 1'b0) begin
        scki_counter <= 5'h0;
        scki_i <= 1'b1;
      end else if (scki_cnt_rst & (scki_d & ~scki_i)) begin // end of a capture
        scki_counter <= 5'h1;
        scki_i <= 1'b1;
      end else if (scki_i == 1'b0) begin
        scki_counter <= scki_counter + 1;
        scki_i <= 1'b1;
      end else if (conversion_quiet_time_s == 1'b1) begin
        scki_counter <= scki_counter;
        scki_i <= scki_i;
      end else begin
        scki_counter <= scki_counter;
        scki_i <= ~scki_i;
      end
    end
  end

  // busy period counter
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      run_busy_period_cnt <= 1'b0;
      busy_conversion_cnt <= 'd0;
      busy_measure_value <= 'd0;
    end else begin
      if (cnvs == 1'b1 && busy_m2 == 1'b1) begin
        run_busy_period_cnt <= 1'b1;
      end else if (start_transfer == 1'b1) begin
        run_busy_period_cnt <= 1'b0;
      end

      if (adc_cnvs_redge == 1'b1) begin
        busy_conversion_cnt <= 'd0;
      end else if (start_transfer == 1'b1) begin
        busy_measure_value <= busy_conversion_cnt;
      end else if (run_busy_period_cnt == 1'b1) begin
        busy_conversion_cnt <= busy_conversion_cnt + 'd1;
      end
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      period_cnt <= 'd0;
      cnvs_d <= 'd0;
      conversion_quiet_time <= 1'b0;
    end else begin
      cnvs_d <= cnvs;
      if (oversampling_en == 1 && adc_cnvs_redge == 1'b1) begin
        conversion_quiet_time <= 1'b1;
      end else begin
        conversion_quiet_time <= conversion_quiet_time & ~conversion_completed;
      end
      if (adc_cnvs_redge == 1'b1) begin
        period_cnt <= 'd0;
      end else begin
        period_cnt <= period_cnt + 1;
      end
    end
  end

  assign conversion_quiet_time_s = (oversampling_en == 1) ? conversion_quiet_time | cnvs : 1'b0;
  assign conversion_completed = (period_cnt == busy_measure_value) ? 1'b1 : 1'b0;
  assign adc_cnvs_redge = ~cnvs_d & cnvs;
  assign scki_cnt_rst = (scki_counter == packet_lenght) ? 1'b1 : 1'b0;
  assign scki = scki_i | ~aquire_data;

  /*
  The device sends each channel data on one of the 8 lines.
  Data is stored in the device in a ring buffer. After the first packet is read
  and no new conversion is activated if the reading process restarted,
  the new data on the lines will be from the next index from the ring buffer.
  e.g For second read process without a conversion start
  line 0 = channel 1, line 1 = channel 2, line 2 = channel 3; so on and so forth.
  */

  always @(posedge clk) begin
    if (start_transfer) begin
      lane_0_data <= 4'd0;
      lane_1_data <= 4'd1;
      lane_2_data <= 4'd2;
      lane_3_data <= 4'd3;
      lane_4_data <= 4'd4;
      lane_5_data <= 4'd5;
      lane_6_data <= 4'd6;
      lane_7_data <= 4'd7;
      ch_data_lock <= 9'd0;
    end else if (aquire_data == 1'b1 && (scki_cnt_rst & (~scki_d & scki_i))) begin
      lane_0_data <= lane_0_data[3] == 1'b1 ? 4'd0 : lane_0_data + 1;
      lane_1_data <= lane_1_data[3] == 1'b1 ? 4'd0 : lane_1_data + 1;
      lane_2_data <= lane_2_data[3] == 1'b1 ? 4'd0 : lane_2_data + 1;
      lane_3_data <= lane_3_data[3] == 1'b1 ? 4'd0 : lane_3_data + 1;
      lane_4_data <= lane_4_data[3] == 1'b1 ? 4'd0 : lane_4_data + 1;
      lane_5_data <= lane_5_data[3] == 1'b1 ? 4'd0 : lane_5_data + 1;
      lane_6_data <= lane_6_data[3] == 1'b1 ? 4'd0 : lane_6_data + 1;
      lane_7_data <= lane_7_data[3] == 1'b1 ? 4'd0 : lane_7_data + 1;
      ch_data_lock[lane_0_data[3:0]] <= ACTIVE_LANE[0] ? 1'b1 : ch_data_lock[lane_0_data[2:0]];
      ch_data_lock[lane_1_data[3:0]] <= ACTIVE_LANE[1] ? 1'b1 : ch_data_lock[lane_1_data[2:0]];
      ch_data_lock[lane_2_data[3:0]] <= ACTIVE_LANE[2] ? 1'b1 : ch_data_lock[lane_2_data[2:0]];
      ch_data_lock[lane_3_data[3:0]] <= ACTIVE_LANE[3] ? 1'b1 : ch_data_lock[lane_3_data[2:0]];
      ch_data_lock[lane_4_data[3:0]] <= ACTIVE_LANE[4] ? 1'b1 : ch_data_lock[lane_4_data[2:0]];
      ch_data_lock[lane_5_data[3:0]] <= ACTIVE_LANE[5] ? 1'b1 : ch_data_lock[lane_5_data[2:0]];
      ch_data_lock[lane_6_data[3:0]] <= ACTIVE_LANE[6] ? 1'b1 : ch_data_lock[lane_6_data[2:0]];
      ch_data_lock[lane_7_data[3:0]] <= ACTIVE_LANE[7] ? 1'b1 : ch_data_lock[lane_7_data[2:0]];
    end else begin
      lane_0_data <= lane_0_data;
      lane_1_data <= lane_1_data;
      lane_2_data <= lane_2_data;
      lane_3_data <= lane_3_data;
      lane_4_data <= lane_4_data;
      lane_5_data <= lane_5_data;
      lane_6_data <= lane_6_data;
      lane_7_data <= lane_7_data;
      ch_data_lock <= ch_data_lock;
    end
  end

  generate
    if (N_CHANNELS == 8) begin
      assign aquire_data = ~((ch_data_lock[0] | ~adc_enable[0]) &
                             (ch_data_lock[1] | ~adc_enable[1]) &
                             (ch_data_lock[2] | ~adc_enable[2]) &
                             (ch_data_lock[3] | ~adc_enable[3]) &
                             (ch_data_lock[4] | ~adc_enable[4]) &
                             (ch_data_lock[5] | ~adc_enable[5]) &
                             (ch_data_lock[6] | ~adc_enable[6]) &
                             (ch_data_lock[7] | ~adc_enable[7]) &
                             (ch_data_lock[8] | ~crc_enable_window));
    end else begin
      assign aquire_data = ~((ch_data_lock[0] | ~adc_enable[0]) &
                             (ch_data_lock[1] | ~adc_enable[1]) &
                             (ch_data_lock[2] | ~adc_enable[2]) &
                             (ch_data_lock[3] | ~adc_enable[3]) &
                             (ch_data_lock[4] | ~crc_enable_window));
    end
  endgenerate

  // capture data

  genvar i;
  generate
    if (IODELAY_ENABLE == 1) begin
      ad_data_in #(
        .SINGLE_ENDED (1),
        .DDR_SDR_N (0),
        .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
        .IODELAY_CTRL (1),
        .IODELAY_ENABLE (IODELAY_ENABLE),
        .IODELAY_GROUP (IODELAY_GROUP),
        .REFCLK_FREQUENCY (DELAY_REFCLK_FREQ)
      ) i_rx_data (
        .rx_clk (scko),
        .rx_data_in_p (db_i[0]),
        .rx_data_in_n (1'd0),
        .rx_data_p (db_s[0]),
        .rx_data_n (),
        .up_clk (up_clk),
        .up_dld (up_adc_dld[0]),
        .up_dwdata (up_adc_dwdata[4:0]),
        .up_drdata (up_adc_drdata[4:0]),
        .delay_clk (delay_clk),
        .delay_rst (delay_rst),
        .delay_locked (delay_locked));
    end
    for (i = 1; i < 8; i = i + 1) begin: g_rx_lanes
      if (i < N_CHANNELS) begin
        ad_data_in #(
          .SINGLE_ENDED (1),
          .DDR_SDR_N (0),
          .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
          .IODELAY_CTRL (0),
          .IODELAY_ENABLE (IODELAY_ENABLE),
          .IODELAY_GROUP (IODELAY_GROUP),
          .REFCLK_FREQUENCY (DELAY_REFCLK_FREQ)
        ) i_rx_data (
          .rx_clk (scko),
          .rx_data_in_p (db_i[i]),
          .rx_data_in_n (1'd0),
          .rx_data_p (db_s[i]),
          .rx_data_n (),
          .up_clk (up_clk),
          .up_dld (up_adc_dld[i]),
          .up_dwdata (up_adc_dwdata[((i*5)+4):(i*5)]),
          .up_drdata (up_adc_drdata[((i*5)+4):(i*5)]),
          .delay_clk (delay_clk),
          .delay_rst (delay_rst),
          .delay_locked ());
      end else begin
        assign db_s[i] = 1'b0;
      end
    end
  endgenerate

  // scko clock domain - obtained as an echo and gated clock from the base
  // core clock

  // the most significant bits of the adc_lane_x will remaind from the
  // previous sample for packet formats other than 32.

  always @(negedge scko) begin
    adc_lane_0 <= {adc_lane_0[30:0], db_s[0]};
    adc_lane_1 <= {adc_lane_1[30:0], db_s[1]};
    adc_lane_2 <= {adc_lane_2[30:0], db_s[2]};
    adc_lane_3 <= {adc_lane_3[30:0], db_s[3]};
    adc_lane_4 <= {adc_lane_4[30:0], db_s[4]};
    adc_lane_5 <= {adc_lane_5[30:0], db_s[5]};
    adc_lane_6 <= {adc_lane_6[30:0], db_s[6]};
    adc_lane_7 <= {adc_lane_7[30:0], db_s[7]};
  end

  // scko is not active when start_transfer toggles
  always @(negedge scko, posedge start_transfer) begin
    if (start_transfer == 1'b1) begin
      capture_cnt <= 7'b1;
      adc_captured <= 1'b0;
      new_transfer <= 1'b1;
      new_transfer_d <= 1'b0;
    end else begin
      new_transfer_d <= new_transfer;
      new_transfer <= ~new_transfer_d & new_transfer;
      if (capture_cnt == packet_lenght) begin
        adc_captured <= 1'b1;
        capture_cnt <= 7'b1;
      end else begin
        adc_captured <= 1'b0;
        capture_cnt <= capture_cnt + 7'd1;
      end
    end
  end

  // hold data and index information for a packet capture interval

  always @(posedge scko) begin
    adc_captured_d <= adc_captured;
    if (new_transfer == 1'b1) begin
      ch_0_index <= 4'd0;
      ch_1_index <= 4'd1;
      ch_2_index <= 4'd2;
      ch_3_index <= 4'd3;
      ch_4_index <= 4'd4;
      ch_5_index <= 4'd5;
      ch_6_index <= 4'd6;
      ch_7_index <= 4'd7;
      ch_data_capt <= 9'd0;
    end else if (adc_captured == 1'b1) begin
      ch_0_index <= ch_0_index[3] == 1'b1 ? 4'd0 : ch_0_index + 1;
      ch_1_index <= ch_1_index[3] == 1'b1 ? 4'd0 : ch_1_index + 1;
      ch_2_index <= ch_2_index[3] == 1'b1 ? 4'd0 : ch_2_index + 1;
      ch_3_index <= ch_3_index[3] == 1'b1 ? 4'd0 : ch_3_index + 1;
      ch_4_index <= ch_4_index[3] == 1'b1 ? 4'd0 : ch_4_index + 1;
      ch_5_index <= ch_5_index[3] == 1'b1 ? 4'd0 : ch_5_index + 1;
      ch_6_index <= ch_6_index[3] == 1'b1 ? 4'd0 : ch_6_index + 1;
      ch_7_index <= ch_7_index[3] == 1'b1 ? 4'd0 : ch_7_index + 1;
      ch_data_capt[ch_0_index] <= ACTIVE_LANE[0] ? 1'b1 : ch_data_capt[ch_0_index];
      ch_data_capt[ch_1_index] <= ACTIVE_LANE[1] ? 1'b1 : ch_data_capt[ch_1_index];
      ch_data_capt[ch_2_index] <= ACTIVE_LANE[2] ? 1'b1 : ch_data_capt[ch_2_index];
      ch_data_capt[ch_3_index] <= ACTIVE_LANE[3] ? 1'b1 : ch_data_capt[ch_3_index];
      ch_data_capt[ch_4_index] <= ACTIVE_LANE[4] ? 1'b1 : ch_data_capt[ch_4_index];
      ch_data_capt[ch_5_index] <= ACTIVE_LANE[5] ? 1'b1 : ch_data_capt[ch_5_index];
      ch_data_capt[ch_6_index] <= ACTIVE_LANE[6] ? 1'b1 : ch_data_capt[ch_6_index];
      ch_data_capt[ch_7_index] <= ACTIVE_LANE[7] ? 1'b1 : ch_data_capt[ch_7_index];
    end
  end

  always @(posedge scko) begin
    if (adc_captured == 1'b1) begin
      adc_data_init[0] <= adc_lane_0;
      adc_data_init[1] <= adc_lane_1;
      adc_data_init[2] <= adc_lane_2;
      adc_data_init[3] <= adc_lane_3;
      adc_data_init[4] <= adc_lane_4;
      adc_data_init[5] <= adc_lane_5;
      adc_data_init[6] <= adc_lane_6;
      adc_data_init[7] <= adc_lane_7;
      ch_0_index_d <= ch_0_index;
      ch_1_index_d <= ch_1_index;
      ch_2_index_d <= ch_2_index;
      ch_3_index_d <= ch_3_index;
      ch_4_index_d <= ch_4_index;
      ch_5_index_d <= ch_5_index;
      ch_6_index_d <= ch_6_index;
      ch_7_index_d <= ch_7_index;
    end
  end

  // base core clock domain 2x scko

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_valid_init <= 1'b0;
    end else begin
      if (adc_captured_d == 1'd1) begin
        adc_valid_init <= 1'b1;
      end else begin
        adc_valid_init <= 1'b0;
      end
    end
    adc_valid_init_d1 <= adc_valid_init;
    adc_valid_init_d2 <= adc_valid_init_d1;
    adc_valid_d <= adc_valid_s;
  end

  assign adc_valid_s = ~adc_valid_init_d2 & adc_valid_init_d1;

  always @(posedge clk) begin
    adc_ch0_shift <= {ACTIVE_LANE[0],ch_0_index_d};
    adc_ch1_shift <= {ACTIVE_LANE[1],ch_1_index_d};
    adc_ch2_shift <= {ACTIVE_LANE[2],ch_2_index_d};
    adc_ch3_shift <= {ACTIVE_LANE[3],ch_3_index_d};
    adc_ch4_shift <= {ACTIVE_LANE[4],ch_4_index_d};
    adc_ch5_shift <= {ACTIVE_LANE[5],ch_5_index_d};
    adc_ch6_shift <= {ACTIVE_LANE[6],ch_6_index_d};
    adc_ch7_shift <= {ACTIVE_LANE[7],ch_7_index_d};
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_valid <= 1'b0;
      ch_captured <= 9'd0;

    end else begin
      ch_captured <= ch_data_capt;

      if (N_CHANNELS == 8) begin
        adc_valid <= adc_valid_d &
                       (ch_captured[0] | ~adc_enable[0]) &
                       (ch_captured[1] | ~adc_enable[1]) &
                       (ch_captured[2] | ~adc_enable[2]) &
                       (ch_captured[3] | ~adc_enable[3]) &
                       (ch_captured[4] | ~adc_enable[4]) &
                       (ch_captured[5] | ~adc_enable[5]) &
                       (ch_captured[6] | ~adc_enable[6]) &
                       (ch_captured[7] | ~adc_enable[7]) &
                       (ch_captured[8] | ~crc_enable_window);
      end else begin
        adc_valid <= adc_valid_d &
                       (ch_captured[0] | ~adc_enable[0]) &
                       (ch_captured[1] | ~adc_enable[1]) &
                       (ch_captured[2] | ~adc_enable[2]) &
                       (ch_captured[3] | ~adc_enable[3]) &
                       (ch_captured[4] | ~crc_enable_window);
      end
    end
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_data_store[0] <= 'd0;
      adc_data_store[1] <= 'd0;
      adc_data_store[2] <= 'd0;
      adc_data_store[3] <= 'd0;
      adc_data_store[4] <= 'd0;
      adc_data_store[5] <= 'd0;
      adc_data_store[6] <= 'd0;
      adc_data_store[7] <= 'd0;
      adc_data_store[8] <= 'd0;
    end else begin
      if (adc_valid_s) begin
        if (adc_ch0_shift[4] == 1'b1) begin
          adc_data_store[adc_ch0_shift[3:0]] <= adc_data_init[0];
        end
        if (adc_ch1_shift[4] == 1'b1) begin
          adc_data_store[adc_ch1_shift[3:0]] <= adc_data_init[1];
        end
        if (adc_ch2_shift[4] == 1'b1) begin
          adc_data_store[adc_ch2_shift[3:0]] <= adc_data_init[2];
        end
        if (adc_ch3_shift[4] == 1'b1) begin
          adc_data_store[adc_ch3_shift[3:0]] <= adc_data_init[3];
        end
        if (adc_ch4_shift[4] == 1'b1) begin
          adc_data_store[adc_ch4_shift[3:0]] <= adc_data_init[4];
        end
        if (adc_ch5_shift[4] == 1'b1) begin
          adc_data_store[adc_ch5_shift[3:0]] <= adc_data_init[5];
        end
        if (adc_ch6_shift[4] == 1'b1) begin
          adc_data_store[adc_ch6_shift[3:0]] <= adc_data_init[6];
        end
        if (adc_ch7_shift[4] == 1'b1) begin
          adc_data_store[adc_ch7_shift[3:0]] <= adc_data_init[7];
        end
      end
    end
  end

  generate
    if (RESOLUTION == 20) begin
      assign dev_status = packet_format == 0 ? adc_data_store[8][23:16] << 4 :
                                               adc_data_store[8][23:16];
    end else begin
      assign dev_status = packet_format == 0 ? 8'd0 : adc_data_store[8][23:16];
    end
  endgenerate

  assign adc_data = {adc_data_store[7],
                     adc_data_store[6],
                     adc_data_store[5],
                     adc_data_store[4],
                     adc_data_store[3],
                     adc_data_store[2],
                     adc_data_store[1],
                     adc_data_store[0]};

  // CRC checker logic

  generate
    always @(posedge clk) begin
      if (rst == 1) begin
        crc_data_in <= 0;
      end else begin
        if (adc_valid == 1) begin
          if (N_CHANNELS == 8) begin
            if (packet_format == 0 && RESOLUTION == 16) begin
              crc_data_in <= {adc_data_store[0][15:0],
                              adc_data_store[1][15:0],
                              adc_data_store[2][15:0],
                              adc_data_store[3][15:0],
                              adc_data_store[4][15:0],
                              adc_data_store[5][15:0],
                              adc_data_store[6][15:0],
                              adc_data_store[7][15:0],
                              adc_data_store[8][15:0],144'd0};
            end else if (packet_format == 0 && RESOLUTION == 20) begin
              crc_data_in <= {adc_data_store[0][19:0],
                              adc_data_store[1][19:0],
                              adc_data_store[2][19:0],
                              adc_data_store[3][19:0],
                              adc_data_store[4][19:0],
                              adc_data_store[5][19:0],
                              adc_data_store[6][19:0],
                              adc_data_store[7][19:0],
                              adc_data_store[8][19:0],108'd0};
            end else if (packet_format == 1) begin
              crc_data_in <= {adc_data_store[0][23:0],
                              adc_data_store[1][23:0],
                              adc_data_store[2][23:0],
                              adc_data_store[3][23:0],
                              adc_data_store[4][23:0],
                              adc_data_store[5][23:0],
                              adc_data_store[6][23:0],
                              adc_data_store[7][23:0],
                              adc_data_store[8][23:0],72'd0};
            end else  begin
              crc_data_in <= {adc_data_store[0],
                              adc_data_store[1],
                              adc_data_store[2],
                              adc_data_store[3],
                              adc_data_store[4],
                              adc_data_store[5],
                              adc_data_store[6],
                              adc_data_store[7],
                              adc_data_store[8]};
            end
          end else begin
            if (packet_format == 0 && RESOLUTION == 16) begin
              crc_data_in <= {adc_data_store[0][15:0],
                              adc_data_store[1][15:0],
                              adc_data_store[2][15:0],
                              adc_data_store[3][15:0],
                              adc_data_store[4][15:0],80'd0};
            end else if (packet_format == 0 && RESOLUTION == 20) begin
              crc_data_in <= {adc_data_store[0][19:0],
                              adc_data_store[1][19:0],
                              adc_data_store[2][19:0],
                              adc_data_store[3][19:0],
                              adc_data_store[4][19:0],56'd0};
            end else if (packet_format == 1) begin
              crc_data_in <= {adc_data_store[0][23:0],
                              adc_data_store[1][23:0],
                              adc_data_store[2][23:0],
                              adc_data_store[3][23:0],
                              adc_data_store[4][23:0],40'd0};
            end else  begin
              crc_data_in <= {adc_data_store[0],
                              adc_data_store[1],
                              adc_data_store[2],
                              adc_data_store[3],
                              adc_data_store[4]};
            end
          end
        end
      end
    end
  endgenerate


  // relax timing
  reg  adc_valid_crc_d;
  always @(posedge clk) begin
    adc_valid_crc_d <= adc_valid;
  end

  // As an optimization, a crc checker with 8 parallel operations per clk cycle
  // will be used for all packet formats.
  // The channel plus status and crc data will be feed in byte packets to the
  // crc checker.
  // When packet_format is 20 bits, 20x8+20(st and crc) = 180 which is not a
  // multiple of 8. So, we will feed 184 bits, which is a multiple of 8.
  // First extra 4 bits entering the checker being 0, will not affect the result
  // since the initial value of the LFSR is 0x0000.
  generate
    always @(posedge clk) begin
      if (N_CHANNELS == 8) begin
        if (RESOLUTION == 16) begin
          crc_data_length <= packet_format == 2'd0 ? 16'd144 : 16'd208;
        end else if (RESOLUTION == 20) begin
          crc_data_length <= packet_format == 2'd0 ? 16'd176 : // 184-8
                             packet_format == 2'd1 ? 16'd208 : 16'd280;
        end
      end else begin // quad channel
        if (RESOLUTION == 16) begin
          crc_data_length <= packet_format == 2'd0 ? 16'd80 : 16'd120;
        end else if (RESOLUTION == 20) begin
          crc_data_length <= packet_format == 2'd0 ? 16'd104 :
                             packet_format == 2'd1 ? 16'd120 : 16'd160;
        end
      end
    end
  endgenerate

  always @(posedge clk) begin
    if (crc_enable_window == 0 || adc_valid_crc_d == 1) begin
      crc_cnt <= crc_data_length;
      run_crc <= adc_valid_crc_d;
    end else begin
      if (run_crc == 1'b1) begin
        if (crc_cnt == 0) begin
          run_crc <= 1'b0;
        end else begin
          crc_cnt <= crc_cnt - 8;
        end
      end
    end
    // the counter is initialized with n-1 to accommodate the byte shifter
    run_crc_d <= run_crc;
  end

  assign crc_reset = adc_valid_crc_d;
  assign crc_enable = run_crc | run_crc_d;

  always @(posedge clk) begin
    if (adc_valid_crc_d == 1'b1) begin
      crc_data_in_sh <= crc_data_in;
    end else if (run_crc == 1'b1) begin
      crc_data_in_sh <= crc_data_in_sh << 8;
    end
  end

  always @(posedge clk) begin
    if (run_crc == 1'b1) begin
      data_in_byte <= crc_data_in_sh[FBW:FBW-7];
    end else begin
      data_in_byte <= 8'd0;
    end
  end

  always @(posedge clk) begin
    if (crc_valid == 1) begin
      if (crc_res == 16'd0) begin
        crc_error <= 1'd0;
      end else begin
        crc_error <= 1'd1;
      end
    end
  end

  axi_ad485x_crc i_ad485x_crc_8 (
    .rst (crc_reset),
    .clk (clk),
    .crc_en (crc_enable),
    .d_in (data_in_byte),
    .crc_valid (crc_valid),
    .crc_res (crc_res));

endmodule
