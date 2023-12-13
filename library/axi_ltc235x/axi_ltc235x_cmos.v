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

module axi_ltc235x_cmos #(
  parameter ACTIVE_LANES = 8'b1111_1111,
  parameter LTC235X_FAMILY = 0,
  parameter NUM_CHANNELS = 8,	// 8 for 2358, 4 for 2357, 2 for 2353
  parameter DATA_WIDTH = 18	// 18 or 16 based on -18/-16
) (

  input                   rst,
  input                   clk,
  input       [ 7:0]      adc_enable,
  input       [23:0]      softspan_next,

  // physical interface

  output                  scki,
  output                  sdi,
  input                   scko,
  input       [ 7:0]      sdo,
  input                   busy,

  // FIFO interface

  output      [ 2:0]      adc_ch0_id,
  output      [ 2:0]      adc_ch1_id,
  output      [ 2:0]      adc_ch2_id,
  output      [ 2:0]      adc_ch3_id,
  output      [ 2:0]      adc_ch4_id,
  output      [ 2:0]      adc_ch5_id,
  output      [ 2:0]      adc_ch6_id,
  output      [ 2:0]      adc_ch7_id,

  output      [31:0]      adc_data_0,
  output      [31:0]      adc_data_1,
  output      [31:0]      adc_data_2,
  output      [31:0]      adc_data_3,
  output      [31:0]      adc_data_4,
  output      [31:0]      adc_data_5,
  output      [31:0]      adc_data_6,
  output      [31:0]      adc_data_7,

  output      [ 2:0]      adc_softspan_0,
  output      [ 2:0]      adc_softspan_1,
  output      [ 2:0]      adc_softspan_2,
  output      [ 2:0]      adc_softspan_3,
  output      [ 2:0]      adc_softspan_4,
  output      [ 2:0]      adc_softspan_5,
  output      [ 2:0]      adc_softspan_6,
  output      [ 2:0]      adc_softspan_7,

  output reg              adc_valid
);

  localparam DW = 24;     // packet size
  localparam BW = DW - 1;

  // internal registers

  reg        busy_m1;
  reg        busy_m2;
  reg        busy_m3;

  reg [ 4:0] scki_counter = 5'h0;
  reg [ 4:0] data_counter = 5'h0;

  reg        scki_i;
  reg        scki_d;

  reg [BW:0] adc_lane_0;
  reg [BW:0] adc_lane_1;
  reg [BW:0] adc_lane_2;
  reg [BW:0] adc_lane_3;
  reg [BW:0] adc_lane_4;
  reg [BW:0] adc_lane_5;
  reg [BW:0] adc_lane_6;
  reg [BW:0] adc_lane_7;

  reg [BW:0] adc_data_init[7:0];
  reg [BW:0] adc_data_store[7:0];

  reg [ 2:0] lane_0_ch = 3'd0;
  reg [ 2:0] lane_1_ch = 3'd0;
  reg [ 2:0] lane_2_ch = 3'd0;
  reg [ 2:0] lane_3_ch = 3'd0;
  reg [ 2:0] lane_4_ch = 3'd0;
  reg [ 2:0] lane_5_ch = 3'd0;
  reg [ 2:0] lane_6_ch = 3'd0;
  reg [ 2:0] lane_7_ch = 3'd0;

  reg [ 3:0] adc_lane0_shift;
  reg [ 3:0] adc_lane1_shift;
  reg [ 3:0] adc_lane2_shift;
  reg [ 3:0] adc_lane3_shift;
  reg [ 3:0] adc_lane4_shift;
  reg [ 3:0] adc_lane5_shift;
  reg [ 3:0] adc_lane6_shift;
  reg [ 3:0] adc_lane7_shift;

  reg [ 3:0] adc_lane0_shift_d;
  reg [ 3:0] adc_lane1_shift_d;
  reg [ 3:0] adc_lane2_shift_d;
  reg [ 3:0] adc_lane3_shift_d;
  reg [ 3:0] adc_lane4_shift_d;
  reg [ 3:0] adc_lane5_shift_d;
  reg [ 3:0] adc_lane6_shift_d;
  reg [ 3:0] adc_lane7_shift_d;

  reg        adc_valid_init;
  reg        adc_valid_init_d;

  reg [ 7:0] ch_data_lock = 8'hff;
  reg [ 7:0] ch_capture;
  reg [ 7:0] ch_captured;

  reg        scko_d;
  reg [ 7:0] sdo_d;

  reg [ 4:0] sdi_index = 5'd23;

  reg [23:0] softspan_next_int;

  // internal wires

  wire        start_transfer_s;

  wire        scki_cnt_rst;

  wire        acquire_data;

  wire [17:0] adc_data_raw_s [7:0];
  wire [31:0] adc_data_sign_s [7:0];
  wire [31:0] adc_data_zero_s [7:0];
  wire [31:0] adc_data_s [7:0];
  wire [ 2:0] adc_ch_id_s [7:0];
  wire [ 2:0] adc_softspan_s [7:0];

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      busy_m1 <= 1'b0;
      busy_m2 <= 1'b0;
    end else begin
      busy_m1 <= busy;
      busy_m2 <= busy_m1;
      busy_m3 <= busy_m2;
    end
  end

  assign start_transfer_s = busy_m3 & ~busy_m2;

  // reading clock logic
  always @(posedge clk) begin
    if (rst) begin
      scki_counter <= 5'h0;
      scki_i <= 1'b1;
      scki_d <= 1'b0;
    end else begin
      scki_d <= scki_i;
      if (acquire_data == 1'b0) begin
        scki_counter <= 5'h0;
        scki_i <= 1'b1;
      end else if (scki_cnt_rst & (scki_d & ~scki_i)) begin // end of a capture
        scki_counter <= 5'h1;
        scki_i <= 1'b1;
      end else if (scki_i == 1'b0) begin
        scki_counter <= scki_counter + 5'd1;
        scki_i <= 1'b1;
      end else begin
        scki_counter <= scki_counter;
        scki_i <= ~scki_i;
      end
    end
  end

  assign scki_cnt_rst = (scki_counter == DW);
  assign scki = scki_i | ~acquire_data;

  /*
  The device sends each channel data on one of the 8 lines.
  Data is stored in the device in a ring buffer. After the first packet is read
  and no new conversion is requested if the reading process is restarted,
  the new data on the lines will be from the next index from the ring buffer.
  e.g For second read process without a conversion start
  line 0 = channel 1, line 1 = channel 2, line 2 = channel 3; so on and so forth.

  The ring buffer contains the crc data on the 8(last position.)
  e.g for a 4'th reading cycle:
  line 0 = ch 3
  line 1 = ch 4
  line 2 = ch 5
  line 3 = ch 6
  line 4 = ch 7
  line 5 = crc
  line 6 = ch 0
  line 7 = ch 1

  Because there is no rule for a specific number of lanes to be enabled at a given time
  the interface can handle every combination of enabled lanes with enabled channels.
  The valid signal will only be asserted after all enabled channels are stored.
  This means that the user must adjust the sampling frequency based on the
  interface clock frequency and the maximum position/index
  difference +1 of a channel data and the first enabled lane that will
  pass that channels data, maximum difference is 8(e.g line 0 to line 7).
  e.g. If only lanes 1 and 2(0 to 7) are enabled,
    1. The user wants to capture the 6'th(0 to 7) channel, 5 reading cycles are required.
    2. The user wants to capture channel 0, 8 reading cycles are required.
  */

  // capture data per lane in rx buffers adc_lane_X on every edge of scko
  // ignore when busy forced scko to 0
  always @(posedge clk) begin
    scko_d <= scko;
    sdo_d <= sdo;
    if (scko != scko_d && scki != scki_d) begin
      adc_lane_0 <= {adc_lane_0[BW-1:0], sdo_d[0]};
      adc_lane_1 <= {adc_lane_1[BW-1:0], sdo_d[1]};
      adc_lane_2 <= {adc_lane_2[BW-1:0], sdo_d[2]};
      adc_lane_3 <= {adc_lane_3[BW-1:0], sdo_d[3]};
      adc_lane_4 <= {adc_lane_4[BW-1:0], sdo_d[4]};
      adc_lane_5 <= {adc_lane_5[BW-1:0], sdo_d[5]};
      adc_lane_6 <= {adc_lane_6[BW-1:0], sdo_d[6]};
      adc_lane_7 <= {adc_lane_7[BW-1:0], sdo_d[7]};
    end
  end

  // store the data from the rx buffers when all bits are received
  // when data transaction window is done
  // index is based by lane
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
      data_counter <= 5'h0;
    end else begin
      data_counter <= scki_counter;
      if (data_counter == DW) begin
        adc_data_init[0] <= adc_lane_0;
        adc_data_init[1] <= adc_lane_1;
        adc_data_init[2] <= adc_lane_2;
        adc_data_init[3] <= adc_lane_3;
        adc_data_init[4] <= adc_lane_4;
        adc_data_init[5] <= adc_lane_5;
        adc_data_init[6] <= adc_lane_6;
        adc_data_init[7] <= adc_lane_7;
      end
    end
  end

  // lane_x_ch - channel corresponds to which lane, e.g. lane_0_ch stores the current channel lane 0 has
  // ch_data_lock[i] - locks ch i, e.g. ch_data_lock[7] = 1 means data from channel 7 has already been sent to an active lane, channel 7 should now be locked
  // dont acquire data if all channels are all already locked
  always @(posedge clk) begin
    if (start_transfer_s) begin
      lane_0_ch <= 3'd0;
      lane_1_ch <= 3'd1;
      lane_2_ch <= 3'd2;
      lane_3_ch <= 3'd3;
      lane_4_ch <= 3'd4;
      lane_5_ch <= 3'd5;
      lane_6_ch <= 3'd6;
      lane_7_ch <= 3'd7;
      ch_data_lock <= 8'd0;
    end else if (acquire_data == 1'b1 && (scki_cnt_rst & (~scki_d & scki_i))) begin
      lane_0_ch <= lane_0_ch + 3'd1;
      lane_1_ch <= lane_1_ch + 3'd1;
      lane_2_ch <= lane_2_ch + 3'd1;
      lane_3_ch <= lane_3_ch + 3'd1;
      lane_4_ch <= lane_4_ch + 3'd1;
      lane_5_ch <= lane_5_ch + 3'd1;
      lane_6_ch <= lane_6_ch + 3'd1;
      lane_7_ch <= lane_7_ch + 3'd1;
      ch_data_lock[lane_0_ch] <= ACTIVE_LANES[0] ? 1'b1 : ch_data_lock[lane_0_ch];
      ch_data_lock[lane_1_ch] <= ACTIVE_LANES[1] ? 1'b1 : ch_data_lock[lane_1_ch];
      ch_data_lock[lane_2_ch] <= ACTIVE_LANES[2] ? 1'b1 : ch_data_lock[lane_2_ch];
      ch_data_lock[lane_3_ch] <= ACTIVE_LANES[3] ? 1'b1 : ch_data_lock[lane_3_ch];
      ch_data_lock[lane_4_ch] <= ACTIVE_LANES[4] ? 1'b1 : ch_data_lock[lane_4_ch];
      ch_data_lock[lane_5_ch] <= ACTIVE_LANES[5] ? 1'b1 : ch_data_lock[lane_5_ch];
      ch_data_lock[lane_6_ch] <= ACTIVE_LANES[6] ? 1'b1 : ch_data_lock[lane_6_ch];
      ch_data_lock[lane_7_ch] <= ACTIVE_LANES[7] ? 1'b1 : ch_data_lock[lane_7_ch];
    end
  end

  assign acquire_data = ~((ch_data_lock[0] | ~adc_enable[0]) &
                         (ch_data_lock[1] | ~adc_enable[1]) &
                         (ch_data_lock[2] | ~adc_enable[2]) &
                         (ch_data_lock[3] | ~adc_enable[3]) &
                         (ch_data_lock[4] | ~adc_enable[4]) &
                         (ch_data_lock[5] | ~adc_enable[5]) &
                         (ch_data_lock[6] | ~adc_enable[6]) &
                         (ch_data_lock[7] | ~adc_enable[7]));

  // hold lane status and lane channel
  // for datasyncing with valid signal
  always @(posedge clk) begin
    if (rst == 1'b1 || adc_valid == 1'b1) begin
      adc_lane0_shift <= 4'd0;
      adc_lane1_shift <= 4'd0;
      adc_lane2_shift <= 4'd0;
      adc_lane3_shift <= 4'd0;
      adc_lane4_shift <= 4'd0;
      adc_lane5_shift <= 4'd0;
      adc_lane6_shift <= 4'd0;
      adc_lane7_shift <= 4'd0;
      adc_lane0_shift_d <= 4'd0;
      adc_lane1_shift_d <= 4'd0;
      adc_lane2_shift_d <= 4'd0;
      adc_lane3_shift_d <= 4'd0;
      adc_lane4_shift_d <= 4'd0;
      adc_lane5_shift_d <= 4'd0;
      adc_lane6_shift_d <= 4'd0;
      adc_lane7_shift_d <= 4'd0;
    end else begin
      adc_lane0_shift <= {ACTIVE_LANES[0], lane_0_ch};
      adc_lane1_shift <= {ACTIVE_LANES[1], lane_1_ch};
      adc_lane2_shift <= {ACTIVE_LANES[2], lane_2_ch};
      adc_lane3_shift <= {ACTIVE_LANES[3], lane_3_ch};
      adc_lane4_shift <= {ACTIVE_LANES[4], lane_4_ch};
      adc_lane5_shift <= {ACTIVE_LANES[5], lane_5_ch};
      adc_lane6_shift <= {ACTIVE_LANES[6], lane_6_ch};
      adc_lane7_shift <= {ACTIVE_LANES[7], lane_7_ch};
      adc_lane0_shift_d <= adc_lane0_shift;
      adc_lane1_shift_d <= adc_lane1_shift;
      adc_lane2_shift_d <= adc_lane2_shift;
      adc_lane3_shift_d <= adc_lane3_shift;
      adc_lane4_shift_d <= adc_lane4_shift;
      adc_lane5_shift_d <= adc_lane5_shift;
      adc_lane6_shift_d <= adc_lane6_shift;
      adc_lane7_shift_d <= adc_lane7_shift;
    end
  end

  // stores the data from the rx buffer, but now based on ch
  // index is based on ch, not lane anymore
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
    end else begin
      if (!adc_valid_init_d & adc_valid_init) begin
        if (adc_lane0_shift_d[3] == 1'b1) begin
          adc_data_store[adc_lane0_shift_d[2:0]] <= adc_data_init[0];
        end
        if (adc_lane1_shift_d[3] == 1'b1) begin
          adc_data_store[adc_lane1_shift_d[2:0]] <= adc_data_init[1];
        end
        if (adc_lane2_shift_d[3] == 1'b1) begin
          adc_data_store[adc_lane2_shift_d[2:0]] <= adc_data_init[2];
        end
        if (adc_lane3_shift_d[3] == 1'b1) begin
          adc_data_store[adc_lane3_shift_d[2:0]] <= adc_data_init[3];
        end
        if (adc_lane4_shift_d[3] == 1'b1) begin
          adc_data_store[adc_lane4_shift_d[2:0]] <= adc_data_init[4];
        end
        if (adc_lane5_shift_d[3] == 1'b1) begin
          adc_data_store[adc_lane5_shift_d[2:0]] <= adc_data_init[5];
        end
        if (adc_lane6_shift_d[3] == 1'b1) begin
          adc_data_store[adc_lane6_shift_d[2:0]] <= adc_data_init[6];
        end
        if (adc_lane7_shift_d[3] == 1'b1) begin
          adc_data_store[adc_lane7_shift_d[2:0]] <= adc_data_init[7];
        end
      end
    end
  end

  // extract info from the data bits
  genvar i;
  generate
    for (i=0; i < 8; i=i+1) begin: format
      assign adc_data_raw_s[i] = adc_data_store[i][BW:DW-DATA_WIDTH];
      assign adc_data_sign_s[i] = {{(32-DATA_WIDTH){adc_data_raw_s[i][DATA_WIDTH-1]}}, adc_data_raw_s[i]};
      assign adc_data_zero_s[i] = {{(32-DATA_WIDTH){1'b0}}, adc_data_raw_s[i]};
      assign adc_data_s[i] =  (adc_softspan_s[i] == 3'b0)?  32'h0               :
                              (adc_softspan_s[i][1])?       adc_data_sign_s[i]  :
                                                            adc_data_zero_s[i]  ;
      if (NUM_CHANNELS == 8) begin
        assign adc_ch_id_s[i] = adc_data_store[i][5:3];
      end else if (NUM_CHANNELS == 4) begin
        assign adc_ch_id_s[i] = {1'b0, adc_data_store[i][4:3]};
      end else begin
        assign adc_ch_id_s[i] = {2'b0, adc_data_store[i][3]};
      end
      assign adc_softspan_s[i] = adc_data_store[i][2:0];
    end
  endgenerate

  // assign extracted adc data to corresponding outputs
  assign adc_data_0 = adc_data_s[0];
  assign adc_data_1 = adc_data_s[1];
  assign adc_data_2 = adc_data_s[2];
  assign adc_data_3 = adc_data_s[3];
  assign adc_data_4 = adc_data_s[4];
  assign adc_data_5 = adc_data_s[5];
  assign adc_data_6 = adc_data_s[6];
  assign adc_data_7 = adc_data_s[7];

  // assign extracted adc channel id to corresponding outputs
  assign adc_ch0_id = adc_ch_id_s[0];
  assign adc_ch1_id = adc_ch_id_s[1];
  assign adc_ch2_id = adc_ch_id_s[2];
  assign adc_ch3_id = adc_ch_id_s[3];
  assign adc_ch4_id = adc_ch_id_s[4];
  assign adc_ch5_id = adc_ch_id_s[5];
  assign adc_ch6_id = adc_ch_id_s[6];
  assign adc_ch7_id = adc_ch_id_s[7];

  // assign extracted adc channel id to corresponding outputs
  assign adc_softspan_0 = adc_softspan_s[0];
  assign adc_softspan_1 = adc_softspan_s[1];
  assign adc_softspan_2 = adc_softspan_s[2];
  assign adc_softspan_3 = adc_softspan_s[3];
  assign adc_softspan_4 = adc_softspan_s[4];
  assign adc_softspan_5 = adc_softspan_s[5];
  assign adc_softspan_6 = adc_softspan_s[6];
  assign adc_softspan_7 = adc_softspan_s[7];

  // initial valid signal
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      adc_valid_init <= 1'b0;
    end else begin
      if (data_counter == DW && adc_valid_init == 1'b0) begin
        adc_valid_init <= 1'b1;
      end else begin
        adc_valid_init <= 1'b0;
      end
    end
  end

  // delayed both valid signal and data_lock signal
  // for datasyncing with valid signal
  always @(posedge clk) begin
    if (rst == 1'b1 || adc_valid == 1'b1) begin
      adc_valid <= 1'b0;
      adc_valid_init_d <= 1'b0;
      ch_capture <= 8'd0;
      ch_captured <= 8'd0;
    end else begin
      ch_capture <= ch_data_lock;
      ch_captured <= ch_capture;
      adc_valid_init_d <= adc_valid_init;
      adc_valid <= adc_valid_init_d &
                     (ch_captured[0] | ~adc_enable[0]) &
                     (ch_captured[1] | ~adc_enable[1]) &
                     (ch_captured[2] | ~adc_enable[2]) &
                     (ch_captured[3] | ~adc_enable[3]) &
                     (ch_captured[4] | ~adc_enable[4]) &
                     (ch_captured[5] | ~adc_enable[5]) &
                     (ch_captured[6] | ~adc_enable[6]) &
                     (ch_captured[7] | ~adc_enable[7]);
    end
  end

  // every negedge of scki, update index of sdi
  always @(posedge clk) begin
    if (start_transfer_s || rst) begin
      sdi_index <= 5'd23;
    end else begin
      if (scki && !scki_d && sdi_index != 5'b11111) begin
        sdi_index <= sdi_index - 5'b1;
      end
    end
  end

  // update next softspan configuration every after busy
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      softspan_next_int <= 24'hff_ffff;
    end else begin
      if (busy_m3 & ~busy_m2) begin
        softspan_next_int <= softspan_next;
      end else begin
        softspan_next_int <= softspan_next_int;
      end
    end
  end

  assign sdi = (sdi_index != 5'b11111)? softspan_next_int[sdi_index] : 1'b0;

endmodule
