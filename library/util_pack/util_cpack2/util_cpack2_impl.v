// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2025, 2026 Analog Devices, Inc. All rights reserved.
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
  parameter SAMPLE_DATA_WIDTH = 16,
  parameter PARALLEL_OR_SERIAL_N = 0,
  parameter PIPELINE_STAGES = 0
) (
  input clk,
  input reset,

  input [NUM_OF_CHANNELS-1:0] enable,

  input [NUM_OF_CHANNELS-1:0] fifo_wr_en,
  output fifo_wr_overflow,
  input [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_wr_data,

  output reg packed_fifo_wr_en = 1'b0,
  input packed_fifo_wr_overflow,
  output reg [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] packed_fifo_wr_data = 'h00,
  output reg packed_sync = 1'b1
);

  localparam TOTAL_DATA_WIDTH = SAMPLE_DATA_WIDTH * SAMPLES_PER_CHANNEL * NUM_OF_CHANNELS;
  localparam NUM_OF_SAMPLES = NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL;

  localparam SAMPLE_ADDRESS_WIDTH =
    NUM_OF_SAMPLES > 512 ? 10 :
    NUM_OF_SAMPLES > 256 ? 9 :
    NUM_OF_SAMPLES > 128 ? 8 :
    NUM_OF_SAMPLES > 64 ? 7 :
    NUM_OF_SAMPLES > 32 ? 6 :
    NUM_OF_SAMPLES > 16 ? 5 :
    NUM_OF_SAMPLES > 8 ? 4 :
    NUM_OF_SAMPLES > 4 ? 3 :
    NUM_OF_SAMPLES > 2 ? 2 : 1;

  localparam NETWORK0_STAGES = SAMPLE_ADDRESS_WIDTH / 2;
  localparam NETWORK1_STAGES = SAMPLE_ADDRESS_WIDTH % 2;

  // Calculate pipeline latency per network based on PIPELINE_STAGES parameter
  function integer calc_pipeline_latency;
    input integer num_stages;
    begin
      if (PIPELINE_STAGES == 2)
        calc_pipeline_latency = num_stages;
      else if (PIPELINE_STAGES == 1)
        calc_pipeline_latency = num_stages / 2;
      else
        calc_pipeline_latency = 0;
    end
  endfunction

  localparam TOTAL_PIPELINE_LATENCY = (NUM_OF_CHANNELS == 1) ? 0 :
                                       calc_pipeline_latency(NETWORK0_STAGES) +
                                       calc_pipeline_latency(NETWORK1_STAGES);

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
  wire data_wr_en_delayed;

  /*
   * Ce-gated delay for data_wr_en to match the ce-gated data pipeline.
   * When PIPELINE_STAGES > 0, the data pipeline is ce-gated, so this
   * delay must also be ce-gated.
   */
  generate
    if (TOTAL_PIPELINE_LATENCY == 0) begin: gen_wr_en_comb
      assign data_wr_en_delayed = data_wr_en;
    end else begin: gen_wr_en_pipe
      (* shreg_extract = "no" *) reg [TOTAL_PIPELINE_LATENCY:0] wr_en_sr = 'h0;
      integer wei;
      always @(posedge clk) begin
        if (data_wr_en == 1'b1) begin
          wr_en_sr[0] <= data_wr_en;
          for (wei = 1; wei <= TOTAL_PIPELINE_LATENCY; wei = wei + 1)
            wr_en_sr[wei] <= wr_en_sr[wei-1];
        end
      end
      assign data_wr_en_delayed = wr_en_sr[TOTAL_PIPELINE_LATENCY];
    end
  endgenerate

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
    .PACK (1),
    .PARALLEL_OR_SERIAL_N (PARALLEL_OR_SERIAL_N),
    .PIPELINE_STAGES (PIPELINE_STAGES)
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
      packed_sync <= 1'b0;
    end else if (ready == 1'b1 && data_wr_en == 1'b1) begin
      packed_fifo_wr_en <= 1'b1;
      packed_sync <= out_sync;
    end else begin
      packed_fifo_wr_en <= 1'b0;
      packed_sync <= 1'b0;
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
