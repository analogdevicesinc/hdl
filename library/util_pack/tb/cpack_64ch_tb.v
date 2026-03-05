// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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
module cpack_64ch_tb;
  parameter VCD_FILE = {"cpack_64ch_tb.vcd"};
  parameter NUM_OF_CHANNELS = 64;
  parameter SAMPLES_PER_CHANNEL = 1;
  parameter ENABLE_RANDOM = 0;
  parameter PIPELINE_STAGES = 2;

  `define TIMEOUT 20000000
  `include "tb_base.v"

  localparam NUM_OF_PORTS = SAMPLES_PER_CHANNEL * NUM_OF_CHANNELS;

  reg fifo_wr_en = 1'b1;
  reg [NUM_OF_PORTS*16-1:0] fifo_wr_data = 'h00;

  wire packed_fifo_wr_en;
  wire [NUM_OF_PORTS*16-1:0] packed_fifo_wr_data;
  reg [NUM_OF_PORTS*16-1:0] expected_packed_fifo_wr_data;

  reg [NUM_OF_CHANNELS-1:0] enable = 'h1;

  integer counter;
  integer test_index;

  // Test representative enable masks instead of all 2^64 combinations
  // Include all channels, single channels, non_power_of_two configs
  reg [NUM_OF_CHANNELS-1:0] test_enables [0:31];
  initial begin
    test_enables[0]  = 64'hFFFFFFFFFFFFFFFF;  // All 64 channels
    test_enables[1]  = 64'h7FFFFFFFFFFFFFFF;  // 63 channels (non-pow2)
    test_enables[2]  = 64'hFFFFFFFFFFFFFFFE;  // 63 channels (different pattern)
    test_enables[3]  = 64'h5555555555555555;  // Alternating pattern (32 channels)
    test_enables[4]  = 64'hAAAAAAAAAAAAAAAA;  // Alternating inverse (32 channels)
    test_enables[5]  = 64'h00000000FFFFFFFF;  // Lower 32 channels
    test_enables[6]  = 64'hFFFFFFFF00000000;  // Upper 32 channels
    test_enables[7]  = 64'h0000FFFF0000FFFF;  // 32 channels grouped
    test_enables[8]  = 64'hFFFF0000FFFF0000;  // 32 channels grouped inverse
    test_enables[9]  = 64'h0F0F0F0F0F0F0F0F;  // 32 channels nibble pattern
    test_enables[10] = 64'h0000000000000007;  // 3 channels (non-pow2)
    test_enables[11] = 64'h000000000000000F;  // 4 channels
    test_enables[12] = 64'h000000000000001F;  // 5 channels (non-pow2)
    test_enables[13] = 64'h000000000000003F;  // 6 channels (non-pow2)
    test_enables[14] = 64'h000000000000007F;  // 7 channels (non-pow2)
    test_enables[15] = 64'h00000000000000FF;  // 8 channels
    test_enables[16] = 64'h00000000000001FF;  // 9 channels (non-pow2)
    test_enables[17] = 64'h0000000000000FFF;  // 12 channels (non-pow2)
    test_enables[18] = 64'h000000000000FFFF;  // 16 channels
    test_enables[19] = 64'h00000000001FFFFF;  // 21 channels (non-pow2)
    test_enables[20] = 64'h0000000000FFFFFF;  // 24 channels (non-pow2)
    test_enables[21] = 64'h00000000FFFFFFFF;  // 32 channels
    test_enables[22] = 64'h000001FFFFFFFFFF;  // 41 channels (non-pow2)
    test_enables[23] = 64'h0000FFFFFFFFFFFF;  // 48 channels (non-pow2)
    test_enables[24] = 64'h001FFFFFFFFFFFFF;  // 53 channels (non-pow2)
    test_enables[25] = 64'h00FFFFFFFFFFFFFF;  // 56 channels (non-pow2)
    test_enables[26] = 64'h03FFFFFFFFFFFFFF;  // 58 channels (non-pow2)
    test_enables[27] = 64'h0FFFFFFFFFFFFFFF;  // 60 channels (non-pow2)
    test_enables[28] = 64'h1FFFFFFFFFFFFFFF;  // 61 channels (non-pow2)
    test_enables[29] = 64'h3FFFFFFFFFFFFFFF;  // 62 channels (non-pow2)
    test_enables[30] = 64'hF7F7F7F7F7F7F7F7;  // 56 channels (scattered)
    test_enables[31] = 64'h0000000000000001;  // 1 channel
  end

  always @(*) begin
    if (counter == 15) do_trigger_reset();
  end

  always @(posedge clk) begin
    if (trigger_reset == 1'b1) begin
      if (test_index < 31) begin
        test_index <= test_index + 1;
        enable <= test_enables[test_index + 1];
      end else begin
        if (failed == 1'b0)
          $display("SUCCESS");
        else
          $display("FAILED");
        $finish;
      end
    end
  end

  reg reset_data = 1'b0;
  integer reset_counter = 'h00;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      reset_data <= 1'b1;
      reset_counter <= 'h00;
      if (test_index == 0) begin
        enable <= test_enables[0];
      end
    end else begin
      reset_counter <= reset_counter + 1'b1;
      if (reset_counter == 'h5) begin
        reset_data <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      counter <= 'h00;
      test_index <= 0;
    end else if (packed_fifo_wr_en == 1'b1) begin
      counter <= counter + 1;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b0 && packed_fifo_wr_en == 1'b1 &&
        expected_packed_fifo_wr_data !== packed_fifo_wr_data) begin
        failed <= 1'b1;
        $display("Failed for enable mask: %x. Expected data %x, got %x",
          enable, expected_packed_fifo_wr_data, packed_fifo_wr_data);
    end
  end

  integer i;
  integer j;
  integer h;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      j = 0;
      for (h = 0; h < SAMPLES_PER_CHANNEL; h = h + 1) begin
        for (i = 0; i < NUM_OF_CHANNELS; i = i + 1) begin
          if (enable[i] == 1'b1) begin
            fifo_wr_data[(i*SAMPLES_PER_CHANNEL+h)*16+:16] <= j;
            j = j + 1;
          end else begin
            fifo_wr_data[(i*SAMPLES_PER_CHANNEL+h)*16+:16] <= 'hxxxx;
          end
        end
      end
    end else if (fifo_wr_en == 1'b1) begin
      for (h = 0; h < SAMPLES_PER_CHANNEL; h = h + 1) begin
        for (i = 0; i < NUM_OF_CHANNELS; i = i + 1) begin
          if (enable[i] == 1'b1) begin
            fifo_wr_data[(i*SAMPLES_PER_CHANNEL+h)*16+:16] <= j;
            j = j + 1;
          end
        end
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      for (i = 0; i < NUM_OF_PORTS; i = i + 1) begin
        expected_packed_fifo_wr_data[i*16+:16] <= i;
      end
    end else if (packed_fifo_wr_en == 1'b1) begin
      for (i = 0; i < NUM_OF_PORTS; i = i + 1) begin
        expected_packed_fifo_wr_data[i*16+:16] <= expected_packed_fifo_wr_data[i*16+:16] + NUM_OF_PORTS;
      end
    end
  end

  always @(posedge clk) begin
    if (reset_data == 1'b1) begin
      fifo_wr_en <= 1'b0;
    end else begin
      fifo_wr_en <= ENABLE_RANDOM ? ($random & 1'b1) : ~fifo_wr_en;
    end
  end

  util_cpack2_impl #(
    .NUM_OF_CHANNELS(NUM_OF_CHANNELS),
    .SAMPLES_PER_CHANNEL(SAMPLES_PER_CHANNEL),
    .SAMPLE_DATA_WIDTH(16),
    .PIPELINE_STAGES(PIPELINE_STAGES)
  ) i_cpack (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .fifo_wr_en({NUM_OF_CHANNELS{fifo_wr_en}}),
    .fifo_wr_data(fifo_wr_data),
    .packed_fifo_wr_en(packed_fifo_wr_en),
    .packed_fifo_wr_data(packed_fifo_wr_data),
    .packed_fifo_wr_overflow(1'b0));
endmodule
