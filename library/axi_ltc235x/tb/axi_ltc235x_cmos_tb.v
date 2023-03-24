// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2023 (c) Analog Devices, Inc. All rights reserved.
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

module axi_ltc235x_cmos_tb ();
  parameter NUM_CHANNELS = 8;	// 8 for 2358, 4 for 2357, 2 for 2353
  parameter DATA_WIDTH = 18;	// 18 or 16
  parameter ACTIVE_LANE = 8'b1111_1111;

  reg                   resetn = 0;
  reg                   clk = 0;
  reg       [ 7:0]      adc_enable = 'b1111_1111;
  reg       [23:0]      ltc235x_softspan_next_24 = 24'hff_ffff;

  // physical interface

  wire                  scki;
  wire                  db_o;
  reg                   scko = 1;
  wire      [ 7:0]      db_i;
  reg                   rx_busy = 0;

  // FIFO interface

  wire      [ 2:0]      adc_ch0_id;
  wire      [ 2:0]      adc_ch1_id;
  wire      [ 2:0]      adc_ch2_id;
  wire      [ 2:0]      adc_ch3_id;
  wire      [ 2:0]      adc_ch4_id;
  wire      [ 2:0]      adc_ch5_id;
  wire      [ 2:0]      adc_ch6_id;
  wire      [ 2:0]      adc_ch7_id;
  wire      [31:0]      adc_data_0;
  wire      [31:0]      adc_data_1;
  wire      [31:0]      adc_data_2;
  wire      [31:0]      adc_data_3;
  wire      [31:0]      adc_data_4;
  wire      [31:0]      adc_data_5;
  wire      [31:0]      adc_data_6;
  wire      [31:0]      adc_data_7;
  wire      [ 2:0]      adc_softspan_0;
  wire      [ 2:0]      adc_softspan_1;
  wire      [ 2:0]      adc_softspan_2;
  wire      [ 2:0]      adc_softspan_3;
  wire      [ 2:0]      adc_softspan_4;
  wire      [ 2:0]      adc_softspan_5;
  wire      [ 2:0]      adc_softspan_6;
  wire      [ 2:0]      adc_softspan_7;
  wire                  adc_valid;

	// other registers
  reg       [31:0]      rx_db_data[0:7];
  reg       [ 2:0]      rx_ch_id[0:7];
  reg       [ 2:0]      softspan_now_3[0:7];
  reg       [ 2:0]      softspan_next_3[0:7];
  reg       [ 4:0]      db_i_index = 23;
  reg       [ 3:0]      ring_buffer_index = 0;

  reg       [ 2:0]      ch_index_lane_0 = 0;
  reg       [ 2:0]      ch_index_lane_1 = 1;
  reg       [ 2:0]      ch_index_lane_2 = 2;
  reg       [ 2:0]      ch_index_lane_3 = 3;
  reg       [ 2:0]      ch_index_lane_4 = 4;
  reg       [ 2:0]      ch_index_lane_5 = 5;
  reg       [ 2:0]      ch_index_lane_6 = 6;
  reg       [ 2:0]      ch_index_lane_7 = 7;

  reg                   rx_busy_d = 0;
  reg       [ 2:0]      busy_counter = 'd0;

  reg                   action = 'd0;
  reg                   action_d = 'd0;

  reg                   scki_d = 0;

  reg       [ 4:0]      softspan_counter = 'd0;

  // wires

  wire      [ 2:0]      ltc235x_softspan_next_3 [7:0];
  wire      [23:0]      rx_db_i_24[0:7];
  wire      [23:0]      softspan_next_24;
  
  genvar                i;

  axi_ltc235x_cmos #(
    .NUM_CHANNELS (NUM_CHANNELS),
    .DATA_WIDTH (DATA_WIDTH),
    .ACTIVE_LANE (ACTIVE_LANE)
  ) i_ltc235x_cmos (
    .rst (!resetn),
    .clk (clk),
    .adc_enable (adc_enable),
    .softspan_next (softspan_next_24),

    .scki (scki),
    .db_o (db_o),
    .scko (scko),
    .db_i (db_i),
    .busy (rx_busy),

    .adc_ch0_id (adc_ch0_id),
    .adc_ch1_id (adc_ch1_id),
    .adc_ch2_id (adc_ch2_id),
    .adc_ch3_id (adc_ch3_id),
    .adc_ch4_id (adc_ch4_id),
    .adc_ch5_id (adc_ch5_id),
    .adc_ch6_id (adc_ch6_id),
    .adc_ch7_id (adc_ch7_id),

    .adc_data_0 (adc_data_0),
    .adc_data_1 (adc_data_1),
    .adc_data_2 (adc_data_2),
    .adc_data_3 (adc_data_3),
    .adc_data_4 (adc_data_4),
    .adc_data_5 (adc_data_5),
    .adc_data_6 (adc_data_6),
    .adc_data_7 (adc_data_7),

    .adc_softspan_0 (adc_softspan_0),
    .adc_softspan_1 (adc_softspan_1),
    .adc_softspan_2 (adc_softspan_2),
    .adc_softspan_3 (adc_softspan_3),
    .adc_softspan_4 (adc_softspan_4),
    .adc_softspan_5 (adc_softspan_5),
    .adc_softspan_6 (adc_softspan_6),
    .adc_softspan_7 (adc_softspan_7),

    .adc_valid (adc_valid)
  );

  always #1 clk = ~clk;

  initial begin
    #40
    resetn <= 1'b1;
    // 18-bit data, 3-bit ch id, 3-bit softspan_now
    rx_db_data[0] <= 'h28000; rx_ch_id[0] = 0; softspan_now_3[0] <= ltc235x_softspan_next_3[0];
    rx_db_data[1] <= 'h28007; rx_ch_id[1] = 1; softspan_now_3[1] <= ltc235x_softspan_next_3[1];
    rx_db_data[2] <= 'h28001; rx_ch_id[2] = 2; softspan_now_3[2] <= ltc235x_softspan_next_3[2];
    rx_db_data[3] <= 'h28006; rx_ch_id[3] = 3; softspan_now_3[3] <= ltc235x_softspan_next_3[3];
    rx_db_data[4] <= 'h28002; rx_ch_id[4] = 4; softspan_now_3[4] <= ltc235x_softspan_next_3[4];
    rx_db_data[5] <= 'h28005; rx_ch_id[5] = 5; softspan_now_3[5] <= ltc235x_softspan_next_3[5];
    rx_db_data[6] <= 'h28003; rx_ch_id[6] = 6; softspan_now_3[6] <= ltc235x_softspan_next_3[6];
    rx_db_data[7] <= 'h28004; rx_ch_id[7] = 7; softspan_now_3[7] <= ltc235x_softspan_next_3[7];
    // next softspan configuration
    softspan_next_3[0] = 7; // 2's complement
    softspan_next_3[1] = 0; // 0
    softspan_next_3[2] = 6; // 2's complement
    softspan_next_3[3] = 1; // straight binary
    softspan_next_3[4] = 5; // straight binary
    softspan_next_3[5] = 2; // 2's complement
    softspan_next_3[6] = 4; // straight binary
    softspan_next_3[7] = 3; // 2's complement
    #100
    action <= 1;
    #45000
    action <= 0;  softspan_counter <= 'd0;
    #100
    action <= 1;
    #3000
    $finish;	
  end

  // simulate ltc235x_softspan_next_24 from up_adc_channel
  assign softspan_next_24 = {softspan_next_3[7], softspan_next_3[6], softspan_next_3[5], softspan_next_3[4], softspan_next_3[3], softspan_next_3[2], softspan_next_3[1], softspan_next_3[0]};

  // {18-bit data, channel id, softspan}
  generate
    for (i = 0; i < 8; i = i + 1) begin: rx_db_data_24_gen
      assign rx_db_i_24[i] = {rx_db_data[i][17:0], rx_ch_id[i], softspan_now_3[i]};
    end
  endgenerate

  // scko logic
  always @(posedge clk) begin
    if (!rx_busy && rx_busy_d) begin
      scko <= 1'b0;
    end else if (!scki && scki_d) begin
      scko <= ~scko;
    end
  end

  // simulate transmission of bits from the adc
  always @(posedge clk) begin
    action_d <= action;
    if (action == 1'b1) begin
      scki_d <= scki;

      // update rx_db_data for next conversion
      // update softspan_now_3 for next conversion
      if (adc_valid) begin
        rx_db_data[0] <= rx_db_data[0] + 1;
        rx_db_data[1] <= rx_db_data[1] + 1;
        rx_db_data[2] <= rx_db_data[2] + 1;
        rx_db_data[3] <= rx_db_data[3] + 1;
        rx_db_data[4] <= rx_db_data[4] + 1;
        rx_db_data[5] <= rx_db_data[5] + 1;
        rx_db_data[6] <= rx_db_data[6] + 1;
        rx_db_data[7] <= rx_db_data[7] + 1;
        softspan_now_3[0] <= ltc235x_softspan_next_3[0];
        softspan_now_3[1] <= ltc235x_softspan_next_3[1];
        softspan_now_3[2] <= ltc235x_softspan_next_3[2];
        softspan_now_3[3] <= ltc235x_softspan_next_3[3];
        softspan_now_3[4] <= ltc235x_softspan_next_3[4];
        softspan_now_3[5] <= ltc235x_softspan_next_3[5];
        softspan_now_3[6] <= ltc235x_softspan_next_3[6];
        softspan_now_3[7] <= ltc235x_softspan_next_3[7];
      end else begin
        rx_db_data[0] <= rx_db_data[0];
        rx_db_data[1] <= rx_db_data[1];
        rx_db_data[2] <= rx_db_data[2];
        rx_db_data[3] <= rx_db_data[3];
        rx_db_data[4] <= rx_db_data[4];
        rx_db_data[5] <= rx_db_data[5];
        rx_db_data[6] <= rx_db_data[6];
        rx_db_data[7] <= rx_db_data[7];
        softspan_now_3[0] <= softspan_now_3[0];
        softspan_now_3[1] <= softspan_now_3[1];
        softspan_now_3[2] <= softspan_now_3[2];
        softspan_now_3[3] <= softspan_now_3[3];
        softspan_now_3[4] <= softspan_now_3[4];
        softspan_now_3[5] <= softspan_now_3[5];
        softspan_now_3[6] <= softspan_now_3[6];
        softspan_now_3[7] <= softspan_now_3[7];
      end

      // on every posedge of scki
      // update index of databits to be sent
      // update index of ring buffer
      // update ch of each lane
      if (rx_busy_d & !rx_busy) begin
        db_i_index <= 23;
        ring_buffer_index <= 0;

        ch_index_lane_0 <= 0;
        ch_index_lane_1 <= 1;
        ch_index_lane_2 <= 2;
        ch_index_lane_3 <= 3;
        ch_index_lane_4 <= 4;
        ch_index_lane_5 <= 5;
        ch_index_lane_6 <= 6;
        ch_index_lane_7 <= 7;
      end else if (~scki & scki_d) begin
        db_i_index <= (db_i_index != 'd0) ? db_i_index - 1 : 23;
        ring_buffer_index <= (db_i_index == 'd0) ? ring_buffer_index +1 : (ring_buffer_index == 8) ? 0 : ring_buffer_index;

        ch_index_lane_0 <= (0 + ring_buffer_index) < 8 ? (0 + ring_buffer_index) : (0 + ring_buffer_index) -8;
        ch_index_lane_1 <= (1 + ring_buffer_index) < 8 ? (1 + ring_buffer_index) : (1 + ring_buffer_index) -8;
        ch_index_lane_2 <= (2 + ring_buffer_index) < 8 ? (2 + ring_buffer_index) : (2 + ring_buffer_index) -8;
        ch_index_lane_3 <= (3 + ring_buffer_index) < 8 ? (3 + ring_buffer_index) : (3 + ring_buffer_index) -8;
        ch_index_lane_4 <= (4 + ring_buffer_index) < 8 ? (4 + ring_buffer_index) : (4 + ring_buffer_index) -8;
        ch_index_lane_5 <= (5 + ring_buffer_index) < 8 ? (5 + ring_buffer_index) : (5 + ring_buffer_index) -8;
        ch_index_lane_6 <= (6 + ring_buffer_index) < 8 ? (6 + ring_buffer_index) : (6 + ring_buffer_index) -8;
        ch_index_lane_7 <= (7 + ring_buffer_index) < 8 ? (7 + ring_buffer_index) : (7 + ring_buffer_index) -8;
      end

      // simulate busy signal
      rx_busy_d <= rx_busy;
      if (action && !action_d) begin
        busy_counter <= 'd0;
        rx_busy <= 1'b1;
      end else if (busy_counter == 'd4) begin
        busy_counter <= 'd0;
        rx_busy <= 1'b0;
      end else if (rx_busy == 1'b1) begin
        busy_counter <= busy_counter +1;
        rx_busy <= 1'b1;
      end

      // receive softspan for next conversion
      // every posedge scki
      if (!scki && scki_d && softspan_counter < 24) begin
        ltc235x_softspan_next_24 <= {ltc235x_softspan_next_24[22:0], db_o};
        softspan_counter <= softspan_counter + 1'b1;
      end
    end
  end
  
  // send 1 bit at a time from the databits
  assign db_i[0] = rx_db_i_24[ch_index_lane_0][db_i_index];
  assign db_i[1] = rx_db_i_24[ch_index_lane_1][db_i_index];
  assign db_i[2] = rx_db_i_24[ch_index_lane_2][db_i_index];
  assign db_i[3] = rx_db_i_24[ch_index_lane_3][db_i_index];
  assign db_i[4] = rx_db_i_24[ch_index_lane_4][db_i_index];
  assign db_i[5] = rx_db_i_24[ch_index_lane_5][db_i_index];
  assign db_i[6] = rx_db_i_24[ch_index_lane_6][db_i_index];
  assign db_i[7] = rx_db_i_24[ch_index_lane_7][db_i_index];

  generate
    for (i = 0; i < 8; i = i + 1) begin: softspan_next_gen
      assign ltc235x_softspan_next_3[i] = ltc235x_softspan_next_24[(2 + (i*3)) : (i*3)];
    end
  endgenerate

endmodule
