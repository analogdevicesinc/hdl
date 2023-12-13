// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad4858_cmos #(

  parameter FPGA_TECHNOLOGY = 0,
  parameter DELAY_REFCLK_FREQ = 200,
  parameter IODELAY_ENABLE = 1,
  parameter IODELAY_GROUP = "dev_if_delay_group",
  parameter ACTIVE_LANE = 8'b11111111
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

  input       [ 1:0]      packet_format,
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

  localparam NEG_EDGE = 1;
  localparam DW = 32;
  localparam BW = DW - 1;
  localparam PACKET_1_BITS = 20;
  localparam PACKET_2_BITS = 24;
  localparam PACKET_3_BITS = 32;

  // internal registers

  reg         [BW:0]  adc_lane_0;
  reg         [BW:0]  adc_lane_1;
  reg         [BW:0]  adc_lane_2;
  reg         [BW:0]  adc_lane_3;
  reg         [BW:0]  adc_lane_4;
  reg         [BW:0]  adc_lane_5;
  reg         [BW:0]  adc_lane_6;
  reg         [BW:0]  adc_lane_7;

  reg         [ 5:0]  data_counter = 6'h0;
  reg         [ 5:0]  scki_counter = 6'h0;

  reg                 scki_i;
  reg                 scki_d;

  reg         [BW:0]  adc_data_store[8:0];
  reg         [BW:0]  adc_data_init[7:0];
  reg                 adc_valid_init;
  reg                 adc_valid_init_d;

  reg         [ 8:0]  ch_capture;
  reg         [ 8:0]  ch_captured;

  reg         [ 4:0]  adc_ch0_shift;
  reg         [ 4:0]  adc_ch1_shift;
  reg         [ 4:0]  adc_ch2_shift;
  reg         [ 4:0]  adc_ch3_shift;
  reg         [ 4:0]  adc_ch4_shift;
  reg         [ 4:0]  adc_ch5_shift;
  reg         [ 4:0]  adc_ch6_shift;
  reg         [ 4:0]  adc_ch7_shift;

  reg         [ 4:0]  adc_ch0_shift_d;
  reg         [ 4:0]  adc_ch1_shift_d;
  reg         [ 4:0]  adc_ch2_shift_d;
  reg         [ 4:0]  adc_ch3_shift_d;
  reg         [ 4:0]  adc_ch4_shift_d;
  reg         [ 4:0]  adc_ch5_shift_d;
  reg         [ 4:0]  adc_ch6_shift_d;
  reg         [ 4:0]  adc_ch7_shift_d;

  reg         [ 3:0]  lane_0_data = 'd0;
  reg         [ 3:0]  lane_1_data = 'd0;
  reg         [ 3:0]  lane_2_data = 'd0;
  reg         [ 3:0]  lane_3_data = 'd0;
  reg         [ 3:0]  lane_4_data = 'd0;
  reg         [ 3:0]  lane_5_data = 'd0;
  reg         [ 3:0]  lane_6_data = 'd0;
  reg         [ 3:0]  lane_7_data = 'd0;
  reg         [ 8:0]  ch_data_lock = 'h1ff;

  reg                 busy_m1;
  reg                 busy_m2;
  reg                 cnvs_d;
  reg         [31:0]  period_cnt;

  reg                 conversion_quiet_time;
  reg                 run_busy_period_cnt;
  reg         [31:0]  busy_conversion_cnt;
  reg         [31:0]  busy_measure_value;
  reg                 start_transfer;

  reg                 crc_enable_window;
  reg                 run_crc;
  reg                 run_crc_d;
  reg        [288:0]  crc_data_in;
  reg         [15:0]  crc_cnt;
  reg         [ 7:0]  data_in_byte;

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
  wire        [15:0]  crc_data_lenght;

  // packet format selection

  assign packet_lenght = packet_format == 2'd0 ? 6'd20 :
                         packet_format == 2'd1 ? 6'd24 : 6'd32;

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

  assign aquire_data = ~((ch_data_lock[0] | ~adc_enable[0]) &
                         (ch_data_lock[1] | ~adc_enable[1]) &
                         (ch_data_lock[2] | ~adc_enable[2]) &
                         (ch_data_lock[3] | ~adc_enable[3]) &
                         (ch_data_lock[4] | ~adc_enable[4]) &
                         (ch_data_lock[5] | ~adc_enable[5]) &
                         (ch_data_lock[6] | ~adc_enable[6]) &
                         (ch_data_lock[7] | ~adc_enable[7]) &
                         (ch_data_lock[8] | ~crc_enable_window));

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
    end
  endgenerate

  // the most significant bits of the adc_lane_x will remaind from the
  // previous sample for packet formats other than 32.

  always @(negedge scko) begin
    adc_lane_0 <= {adc_lane_0[BW-1:0], db_s[0]};
    adc_lane_1 <= {adc_lane_1[BW-1:0], db_s[1]};
    adc_lane_2 <= {adc_lane_2[BW-1:0], db_s[2]};
    adc_lane_3 <= {adc_lane_3[BW-1:0], db_s[3]};
    adc_lane_4 <= {adc_lane_4[BW-1:0], db_s[4]};
    adc_lane_5 <= {adc_lane_5[BW-1:0], db_s[5]};
    adc_lane_6 <= {adc_lane_6[BW-1:0], db_s[6]};
    adc_lane_7 <= {adc_lane_7[BW-1:0], db_s[7]};
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_valid_init <= 1'b0;
    end else begin
      if (data_counter == packet_lenght && adc_valid_init == 1'b0) begin
        adc_valid_init <= 1'b1;
      end else begin
        adc_valid_init <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_data_init[0] <= 'h0;
      adc_data_init[1] <= 'h0;
      adc_data_init[2] <= 'h0;
      adc_data_init[3] <= 'h0;
      adc_data_init[4] <= 'h0;
      adc_data_init[5] <= 'h0;
      adc_data_init[6] <= 'h0;
      adc_data_init[7] <= 'h0;
      data_counter <= 'h0;
    end else begin
      data_counter <= scki_counter;
      if (data_counter == packet_lenght) begin
        adc_data_init[0] <= adc_lane_0;
        adc_data_init[1] <= adc_lane_1;
        adc_data_init[2] <= adc_lane_2;
        adc_data_init[3] <= adc_lane_3;
        adc_data_init[4] <= adc_lane_4;
        adc_data_init[5] <= adc_lane_5;
        adc_data_init[6] <= adc_lane_6;
        adc_data_init[7] <= adc_lane_7;
      end else begin
        adc_data_init[0] <= adc_data_init[0];
        adc_data_init[1] <= adc_data_init[1];
        adc_data_init[2] <= adc_data_init[2];
        adc_data_init[3] <= adc_data_init[3];
        adc_data_init[4] <= adc_data_init[4];
        adc_data_init[5] <= adc_data_init[5];
        adc_data_init[6] <= adc_data_init[6];
        adc_data_init[7] <= adc_data_init[7];
      end
    end
  end

  always @(posedge clk) begin
    if (rst == 1'b1 || adc_valid == 1'b1) begin
      adc_valid <= 1'b0;
      adc_valid_init_d <= 1'b0;
      ch_capture <= 9'd0;
      ch_captured <= 9'd0;

      adc_ch0_shift <= 4'd0;
      adc_ch1_shift <= 4'd0;
      adc_ch2_shift <= 4'd0;
      adc_ch3_shift <= 4'd0;
      adc_ch4_shift <= 4'd0;
      adc_ch5_shift <= 4'd0;
      adc_ch6_shift <= 4'd0;
      adc_ch7_shift <= 4'd0;
      adc_ch0_shift_d <= 4'd0;
      adc_ch1_shift_d <= 4'd0;
      adc_ch2_shift_d <= 4'd0;
      adc_ch3_shift_d <= 4'd0;
      adc_ch4_shift_d <= 4'd0;
      adc_ch5_shift_d <= 4'd0;
      adc_ch6_shift_d <= 4'd0;
      adc_ch7_shift_d <= 4'd0;
    end else begin
      ch_capture <= ch_data_lock;
      ch_captured <= ch_capture;
      adc_valid_init_d <= adc_valid_init;

      adc_ch0_shift <= {ACTIVE_LANE[0],lane_0_data};
      adc_ch1_shift <= {ACTIVE_LANE[1],lane_1_data};
      adc_ch2_shift <= {ACTIVE_LANE[2],lane_2_data};
      adc_ch3_shift <= {ACTIVE_LANE[3],lane_3_data};
      adc_ch4_shift <= {ACTIVE_LANE[4],lane_4_data};
      adc_ch5_shift <= {ACTIVE_LANE[5],lane_5_data};
      adc_ch6_shift <= {ACTIVE_LANE[6],lane_6_data};
      adc_ch7_shift <= {ACTIVE_LANE[7],lane_7_data};
      adc_ch0_shift_d <= adc_ch0_shift;
      adc_ch1_shift_d <= adc_ch1_shift;
      adc_ch2_shift_d <= adc_ch2_shift;
      adc_ch3_shift_d <= adc_ch3_shift;
      adc_ch4_shift_d <= adc_ch4_shift;
      adc_ch5_shift_d <= adc_ch5_shift;
      adc_ch6_shift_d <= adc_ch6_shift;
      adc_ch7_shift_d <= adc_ch7_shift;
      adc_valid <= adc_valid_init_d &
                     (ch_captured[0] | ~adc_enable[0]) &
                     (ch_captured[1] | ~adc_enable[1]) &
                     (ch_captured[2] | ~adc_enable[2]) &
                     (ch_captured[3] | ~adc_enable[3]) &
                     (ch_captured[4] | ~adc_enable[4]) &
                     (ch_captured[5] | ~adc_enable[5]) &
                     (ch_captured[6] | ~adc_enable[6]) &
                     (ch_captured[7] | ~adc_enable[7]) &
                     (ch_captured[8] | ~crc_enable_window);
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
      if (!adc_valid_init_d & adc_valid_init) begin
        if (adc_ch0_shift_d[4] == 1'b1) begin
          adc_data_store[adc_ch0_shift_d[3:0]] <= adc_data_init[0];
        end
        if (adc_ch1_shift_d[4] == 1'b1) begin
          adc_data_store[adc_ch1_shift_d[3:0]] <= adc_data_init[1];
        end
        if (adc_ch2_shift_d[4] == 1'b1) begin
          adc_data_store[adc_ch2_shift_d[3:0]] <= adc_data_init[2];
        end
        if (adc_ch3_shift_d[4] == 1'b1) begin
          adc_data_store[adc_ch3_shift_d[3:0]] <= adc_data_init[3];
        end
        if (adc_ch4_shift_d[4] == 1'b1) begin
          adc_data_store[adc_ch4_shift_d[3:0]] <= adc_data_init[4];
        end
        if (adc_ch5_shift_d[4] == 1'b1) begin
          adc_data_store[adc_ch5_shift_d[3:0]] <= adc_data_init[5];
        end
        if (adc_ch6_shift_d[4] == 1'b1) begin
          adc_data_store[adc_ch6_shift_d[3:0]] <= adc_data_init[6];
        end
        if (adc_ch7_shift_d[4] == 1'b1) begin
          adc_data_store[adc_ch7_shift_d[3:0]] <= adc_data_init[7];
        end
      end
    end
  end

  assign dev_status = packet_format == 0 ? adc_data_store[8][23:16] << 4 :
                                           adc_data_store[8][23:16];
  assign crc_data = adc_data_store[8][15:0];
  assign adc_data = {adc_data_store[7],
                     adc_data_store[6],
                     adc_data_store[5],
                     adc_data_store[4],
                     adc_data_store[3],
                     adc_data_store[2],
                     adc_data_store[1],
                     adc_data_store[0]};

  // CRC checker logic

  always @(posedge clk) begin
    if (rst == 1) begin
      crc_data_in <= 0;
    end else begin
      if (adc_valid == 1) begin
        if (packet_format == 0) begin
          crc_data_in <= {104'd0,
                          adc_data_store[0][19:0],
                          adc_data_store[1][19:0],
                          adc_data_store[2][19:0],
                          adc_data_store[3][19:0],
                          adc_data_store[4][19:0],
                          adc_data_store[5][19:0],
                          adc_data_store[6][19:0],
                          adc_data_store[7][19:0],
                          adc_data_store[8][19:0],
                          4'd0};
        end else if (packet_format == 1) begin
          crc_data_in <= {72'd0,
                          adc_data_store[0][23:0],
                          adc_data_store[1][23:0],
                          adc_data_store[2][23:0],
                          adc_data_store[3][23:0],
                          adc_data_store[4][23:0],
                          adc_data_store[5][23:0],
                          adc_data_store[6][23:0],
                          adc_data_store[7][23:0],
                          adc_data_store[8][23:0]};
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
      end
    end
  end

  // As an optimization, a crc checker with 8 parallel operations per clk cycle
  // will be used for all packet formats.
  // The channel plus status and crc data will be feed in byte packets to the
  // crc checker.
  // When packet_format is 20 bits, 20x8+20(st and crc) = 180 which is not a
  // multiple of 8. So, we will feed 184 bits, which is a multiple of 8.
  // First extra 4 bits entering the checker being 0, will not affect the result
  // since the initial value of the LFSR is 0x0000.
  assign crc_data_lenght = packet_format == 2'd0 ? 16'd176 : // 184-8
                           packet_format == 2'd1 ? 16'd208 : 16'd280;

  always @(posedge clk) begin
    if (crc_enable_window == 0 || adc_valid == 1) begin
      crc_cnt <= crc_data_lenght;
      data_in_byte <= 0;
      run_crc <= adc_valid;
    end else begin
      if (run_crc == 1'b1) begin
        if (crc_cnt == 0) begin
          run_crc <= 1'b0;
        end else begin
          crc_cnt <= crc_cnt - 8;
        end
        data_in_byte <= crc_data_in[crc_cnt +: 8];
      end else begin
      end
    end
    // the counter is initialized with n-1 to accommodate the byte shifter
    run_crc_d <= run_crc;
  end

  assign crc_reset = adc_valid;
  assign crc_enable = run_crc | run_crc_d;

  always @(posedge clk) begin
    if (crc_valid == 1) begin
      if (crc_res == 16'd0) begin
        crc_error <= 1'd0;
      end else begin
        crc_error <= 1'd1;
      end
    end
  end

  axi_ad4858_crc i_ad4858_crc_8 (
    .rst (crc_reset),
    .clk (clk),
    .crc_en (crc_enable),
    .d_in (data_in_byte),
    .crc_valid (crc_valid),
    .crc_res (crc_res));

endmodule
