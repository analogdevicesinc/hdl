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

module util_cpack2_impl #(
  parameter NUM_OF_CHANNELS = 4,
  parameter SAMPLES_PER_CHANNEL = 1,
  parameter SAMPLE_DATA_WIDTH = 16
) (
  input clk,
  input reset,

  input [NUM_OF_CHANNELS-1:0] enable,

  input [NUM_OF_CHANNELS-1:0] fifo_wr_en,
  output fifo_wr_overflow,
  input [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_wr_data,

  output reg packed_fifo_wr_en = 1'b0,
  input packed_fifo_wr_overflow,
  output reg packed_fifo_wr_sync = 1'b1,
  output reg [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] packed_fifo_wr_data = 'h00
);

  localparam TOTAL_DATA_WIDTH = SAMPLE_DATA_WIDTH * SAMPLES_PER_CHANNEL * NUM_OF_CHANNELS;

  // Control signals from the pack shell.
  wire reset_data;
  wire ready;

  // Interleaved version of `fifo_wr_data`.
  wire [TOTAL_DATA_WIDTH-1:0] interleaved_data;

  // Output data and corresponding control signal from the routing network.
  wire [TOTAL_DATA_WIDTH-1:0] out_data;
  wire out_sync;
  wire [NUM_OF_CHANNELS*SAMPLES_PER_CHANNEL-1:0] out_valid;

  /*
   * Only the first signal of fifo_rd_en is used. All others are ignored. The
   * only reason why fifo_rd_en has multiple entries is to keep the interface
   * somewhat backwards compatible to the previous upack.
   */
  wire data_wr_en = fifo_wr_en[0];

  /*
   * The cpack core itself has no backpressure. Overflows can only happen
   * downstream.
   */

  assign fifo_wr_overflow = packed_fifo_wr_overflow;

  /*
   * Data at the input of the routing network should be interleaved. The cpack
   * core is supposed to accept deinterleaved data. This just rearrange the bits
   * in the data vector and does not consume any FPGA resources.
   */
  ad_perfect_shuffle #(
    .NUM_GROUPS (NUM_OF_CHANNELS),
    .WORDS_PER_GROUP (SAMPLES_PER_CHANNEL),
    .WORD_WIDTH (SAMPLE_DATA_WIDTH)
  ) i_interleave (
    .data_in (fifo_wr_data),
    .data_out (interleaved_data));

  pack_shell #(
    .NUM_OF_CHANNELS (NUM_OF_CHANNELS),
    .SAMPLES_PER_CHANNEL (SAMPLES_PER_CHANNEL),
    .SAMPLE_DATA_WIDTH (SAMPLE_DATA_WIDTH),
    .PACK (1)
  ) i_pack_shell (
    .clk (clk),
    .reset (reset),

    .reset_data (reset_data),

    .enable (enable),
    .ce (data_wr_en),
    .ready (ready),
    .in_data (interleaved_data),
    .out_data (out_data),
    .out_sync (out_sync),
    .out_valid (out_valid));

  always @(posedge clk) begin
    if (reset_data == 1'b1) begin
      packed_fifo_wr_en <= 1'b0;
      packed_fifo_wr_sync <= 1'b0;
    end else if (ready == 1'b1 && data_wr_en == 1'b1) begin
      packed_fifo_wr_en <= 1'b1;
      packed_fifo_wr_sync <= out_sync;
    end else begin
      packed_fifo_wr_en <= 1'b0;
      packed_fifo_wr_sync <= 1'b0;
    end
  end

  always @(posedge clk) begin: gen_packed_fifo_wr_data
    integer i;

    if (data_wr_en == 1'b1) begin
      for (i = 0; i < NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL; i = i + 1) begin
        if (out_valid[i] == 1'b1) begin
          packed_fifo_wr_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= out_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH];
        end
      end
    end
  end

endmodule
