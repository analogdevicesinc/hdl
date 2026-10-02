// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

module upack_tb;
  parameter VCD_FILE = {"upack_tb.vcd"};
  parameter NUM_OF_CHANNELS = 8;
  parameter SAMPLES_PER_CHANNEL = 8;
  parameter ENABLE_RANDOM = 1;
  parameter SAMPLE_DATA_WIDTH = 16;
  parameter PIPELINE_STAGES = 1;
  parameter DATA_OFFSET = 16'hFF80;
  parameter DATA_PHASES_PER_ENABLE_SETTING = 240;
  parameter PARALLEL_OR_SERIAL_N = 0;

  `define TIMEOUT 10000000
  `include "tb_base.v"

  localparam NUM_OF_PORTS = SAMPLES_PER_CHANNEL * NUM_OF_CHANNELS;

  reg fifo_rd_en = 1'b1;
  wire [NUM_OF_PORTS*SAMPLE_DATA_WIDTH-1:0] fifo_rd_data;
  reg [NUM_OF_PORTS*SAMPLE_DATA_WIDTH-1:0] expected_fifo_rd_data = 'h00;
  wire fifo_rd_valid;

  reg s_axis_valid = 1'b1;
  wire s_axis_ready;
  reg [NUM_OF_PORTS*SAMPLE_DATA_WIDTH-1:0] s_axis_data = 'h00;

  reg [NUM_OF_CHANNELS-1:0] enable = 'h1;
  reg [NUM_OF_CHANNELS-1:0] next_enable = 'h1;

  integer counter;

  always @(*) begin
    if (counter == DATA_PHASES_PER_ENABLE_SETTING) do_trigger_reset();
  end

  always @(posedge clk) begin
    if (trigger_reset == 1'b1) begin
      if (enable != {NUM_OF_CHANNELS{1'b1}}) begin
        enable <= enable + 1'b1;
      end else begin
        if (failed == 1'b0)
          $display("SUCCESS");
        else
          $display("FAILED");
        $finish;
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      counter <= 'h00;
    end else if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
      counter <= counter + 1;
    end
  end

  integer i;

  always @(posedge clk) begin
    for (i = 0; i < NUM_OF_PORTS; i = i + 1) begin
      if (reset == 1'b0 && fifo_rd_valid == 1'b1 && enable[i/SAMPLES_PER_CHANNEL] == 1'b1 &&
        fifo_rd_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] !== expected_fifo_rd_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH]) begin
          failed <= 1'b1;
          $display("Failed for enable mask: %x. Expected data %x, got %x",
            enable, expected_fifo_rd_data, fifo_rd_data);
          i = NUM_OF_PORTS;
      end
    end
  end

  integer j;
  integer h;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      j = 0;
      for (h = 0; h < SAMPLES_PER_CHANNEL; h = h + 1) begin
        for (i = 0; i < NUM_OF_CHANNELS; i = i + 1) begin
          if (enable[i] == 1'b1) begin
            expected_fifo_rd_data[(i*SAMPLES_PER_CHANNEL+h)*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= DATA_OFFSET - j;
            j = j + 1;
          end else begin
            expected_fifo_rd_data[(i*SAMPLES_PER_CHANNEL+h)*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= 'hxx;
          end
        end
      end
    end else if (fifo_rd_valid == 1'b1) begin
      for (h = 0; h < SAMPLES_PER_CHANNEL; h = h + 1) begin
        for (i = 0; i < NUM_OF_CHANNELS; i = i + 1) begin
          if (enable[i] == 1'b1) begin
            expected_fifo_rd_data[(i*SAMPLES_PER_CHANNEL+h)*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= DATA_OFFSET - j;
            j = j + 1;
          end
        end
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      for (i = 0; i < NUM_OF_PORTS; i = i + 1) begin
        s_axis_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= DATA_OFFSET - i;
      end
    end else if (s_axis_ready == 1'b1 && s_axis_valid == 1'b1) begin
      for (i = 0; i < NUM_OF_PORTS; i = i + 1) begin
        s_axis_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= s_axis_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] - NUM_OF_PORTS;
      end
    end
  end

  always @(posedge clk) begin
    fifo_rd_en <= ENABLE_RANDOM ? ($random & 1) : 1'b1;
    if (s_axis_valid == 1'b0 || s_axis_ready == 1'b1) begin
      s_axis_valid <= ENABLE_RANDOM ? ($random % 20) : 1'b1;
    end
  end

  util_upack2_impl #(
    .NUM_OF_CHANNELS(NUM_OF_CHANNELS),
    .SAMPLES_PER_CHANNEL(SAMPLES_PER_CHANNEL),
    .SAMPLE_DATA_WIDTH(SAMPLE_DATA_WIDTH),
    .PIPELINE_STAGES(PIPELINE_STAGES),
    .PARALLEL_OR_SERIAL_N(PARALLEL_OR_SERIAL_N)
  ) i_unpack (
    .clk(clk),
    .reset(reset),

    .enable(enable),

    .fifo_rd_en({NUM_OF_CHANNELS{fifo_rd_en}}),
    .fifo_rd_data(fifo_rd_data),
    .fifo_rd_valid(fifo_rd_valid),

    .s_axis_valid(s_axis_valid),
    .s_axis_ready(s_axis_ready),
    .s_axis_data(s_axis_valid ? s_axis_data : {NUM_OF_PORTS{8'hx}}));

endmodule
