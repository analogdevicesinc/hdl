// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

module cpack_tb;
  parameter VCD_FILE = {`__FILE__,"cd"};
  parameter NUM_OF_CHANNELS = 4;
  parameter SAMPLES_PER_CHANNEL = 1;
  parameter ENABLE_RANDOM = 0;

  `define TIMEOUT 1500000
  `include "tb_base.v"

  localparam NUM_OF_PORTS = SAMPLES_PER_CHANNEL * NUM_OF_CHANNELS;

  reg fifo_wr_en = 1'b1;
  reg [NUM_OF_PORTS*8-1:0] fifo_wr_data = 'h00;

  wire packed_fifo_wr_en;
  wire [NUM_OF_PORTS*8-1:0] packed_fifo_wr_data;
  reg [NUM_OF_PORTS*8-1:0] expected_packed_fifo_wr_data;

  reg [NUM_OF_CHANNELS-1:0] enable = 'h1;
  reg [NUM_OF_CHANNELS-1:0] next_enable = 'h1;

  integer counter;

  always @(*) begin
    if (counter == 15) do_trigger_reset();
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

  reg reset_data = 1'b0;
  integer reset_counter = 'h00;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      reset_data <= 1'b1;
      reset_counter <= 'h00;
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

  integer j;
  integer h;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      j = 0;
      for (h = 0; h < SAMPLES_PER_CHANNEL; h = h + 1) begin
        for (i = 0; i < NUM_OF_CHANNELS; i = i + 1) begin
          if (enable[i] == 1'b1) begin
            fifo_wr_data[(i*SAMPLES_PER_CHANNEL+h)*8+:8] <= j;
            j = j + 1;
          end else begin
            fifo_wr_data[(i*SAMPLES_PER_CHANNEL+h)*8+:8] <= 'hxx;
          end
        end
      end
    end else if (fifo_wr_en == 1'b1) begin
      for (h = 0; h < SAMPLES_PER_CHANNEL; h = h + 1) begin
        for (i = 0; i < NUM_OF_CHANNELS; i = i + 1) begin
          if (enable[i] == 1'b1) begin
            fifo_wr_data[(i*SAMPLES_PER_CHANNEL+h)*8+:8] <= j;
            j = j + 1;
          end
        end
      end
    end
  end

  integer i;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      for (i = 0; i < NUM_OF_PORTS; i = i + 1) begin
        expected_packed_fifo_wr_data[i*8+:8] <= i;
      end
    end else if (packed_fifo_wr_en == 1'b1) begin
      for (i = 0; i < NUM_OF_PORTS; i = i + 1) begin
        expected_packed_fifo_wr_data[i*8+:8] <= expected_packed_fifo_wr_data[i*8+:8] + NUM_OF_PORTS;
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
    .SAMPLE_DATA_WIDTH(8)
  ) i_cpack (
    .clk(clk),
    .reset(reset),

    .enable(enable),

    .fifo_wr_en({NUM_OF_CHANNELS{fifo_wr_en}}),
    .fifo_wr_data(fifo_wr_data),

    .packed_fifo_wr_en(packed_fifo_wr_en),
    .packed_fifo_wr_data(packed_fifo_wr_data),
    .packed_fifo_wr_overflow(1'b0)
  );

endmodule
