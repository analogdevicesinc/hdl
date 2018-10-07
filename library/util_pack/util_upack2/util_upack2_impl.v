// ***************************************************************************
// ***************************************************************************
// Copyright 2017 (c) Analog Devices, Inc. All rights reserved.
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

module util_upack2_impl #(
  parameter NUM_OF_CHANNELS = 4,
  parameter SAMPLES_PER_CHANNEL = 1,
  parameter SAMPLE_DATA_WIDTH = 16
) (
  input clk,
  input reset,

  input [NUM_OF_CHANNELS-1:0] enable,

  input [NUM_OF_CHANNELS-1:0] fifo_rd_en,
  output reg fifo_rd_valid,
  output reg fifo_rd_underflow,
  output reg [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data,

  input s_axis_valid,
  output s_axis_ready,
  input [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] s_axis_data
);

  /*
   * Final output data of the routing network that will be written to
   * `fifo_rd_data` after being deinterleaved.
   */
  wire [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] out_data;

  /*
   * Deinterleaved version of `out_data`
   */
  wire [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] deinterleaved_data;

  /*
   * Internal read signal.
   */
  wire data_rd_en;

  /*
   * Control signals from/to the pack shell.
   */
  wire ce;
  wire ready;
  wire reset_data;

  /*
   * Only the first signal of fifo_rd_en is used. All others are ignored. The
   * only reason why fifo_rd_en has multiple entries is to keep the interface
   * somewhat backwards compatible to the previous upack.
   */
  assign data_rd_en = fifo_rd_en[0];

  assign ce = s_axis_valid & data_rd_en;
  assign s_axis_ready = ready & ce;

  pack_shell #(
    .NUM_OF_CHANNELS (NUM_OF_CHANNELS),
    .SAMPLES_PER_CHANNEL (SAMPLES_PER_CHANNEL),
    .SAMPLE_DATA_WIDTH (SAMPLE_DATA_WIDTH),
    .PACK (0)
  ) i_pack_shell (
    .clk (clk),
    .reset (reset),

    .reset_data (reset_data),

    .enable (enable),
    .ce (ce),
    .ready (ready),
    .in_data (s_axis_data),
    .out_data (out_data),

    .out_valid (),
    .out_sync ()
  );

  /*
   * Data at the output of the routing network is interleaved. The upack
   * core is supposed to produce deinterleaved data. This just rearrange the
   * bits in the data vector and does not consume any FPGA resources.
   */
  ad_perfect_shuffle #(
    .NUM_GROUPS (SAMPLES_PER_CHANNEL),
    .WORDS_PER_GROUP (NUM_OF_CHANNELS),
    .WORD_WIDTH (SAMPLE_DATA_WIDTH)
  ) i_deinterleave (
    .data_in (out_data),
    .data_out (deinterleaved_data)
  );

  always @(posedge clk) begin
    /* In case of an underflow the output vector should be zeroed */
    if (reset_data == 1'b1 ||
        (data_rd_en == 1'b1 && s_axis_valid == 1'b0)) begin
      fifo_rd_data <= 'h00;
    end else if (data_rd_en == 1'b1) begin
      fifo_rd_data <= deinterleaved_data;
    end
  end

  always @(posedge clk) begin
    if (data_rd_en == 1'b1) begin
      fifo_rd_valid <= s_axis_valid & ~reset_data;
      fifo_rd_underflow <= ~(s_axis_valid & ~reset_data);
    end else begin
      fifo_rd_valid <= 1'b0;
      fifo_rd_underflow <= 1'b0;
    end
  end

endmodule
