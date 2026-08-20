// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2026 Analog Devices, Inc. All rights reserved.
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
  parameter INTERFACE_TYPE = 1,
  parameter PARALLEL_OR_SERIAL_N = 0
) (
  input clk,
  input reset,

  input [NUM_OF_CHANNELS-1:0] enable,

  input [NUM_OF_CHANNELS-1:0] fifo_wr_en,
  output fifo_wr_overflow,
  input [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_wr_data,

  input m_axis_ready,
  output m_axis_valid,
  output [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] m_axis_data,
  output [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL/8-1:0] m_axis_keep,
  output m_axis_last,

  output packed_fifo_wr_en,
  input packed_fifo_wr_overflow,
  output [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] packed_fifo_wr_data,
  output reg packed_sync = 1'b1
);

  localparam TOTAL_DATA_WIDTH = SAMPLE_DATA_WIDTH * SAMPLES_PER_CHANNEL * NUM_OF_CHANNELS;

  //Internal write signal.
  wire data_wr_en;

  // Control signals from the pack shell.
  wire ce;
  wire flush;
  wire ready;
  wire reset_data;

  wire out_ready_int;
  reg out_valid_int = 1'b0;
  reg [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] out_data_int = 'h00;

  // AXIS (INTERFACE_TYPE==0) output register (s1_*). This single skid register
  // IS the AXIS master: m_axis_valid = s1_valid and m_axis_data = s1_data.
  // pack_shell's `ready` is registered and its packed word is combinational
  // (valid only on the ready&ce cycle), so s1 snapshots that word on the produce
  // cycle and holds it, stable, until the sink accepts it. There is exactly one
  // beat of storage and the packer is frozen while s1 holds an unaccepted beat,
  // so no older word can accumulate behind it. Unused (constant) in FIFO mode.
  reg s1_valid = 1'b0;
  reg [TOTAL_DATA_WIDTH-1:0] s1_data = 'h00;
  reg [TOTAL_DATA_WIDTH/8-1:0] s1_keep = 'h00;

  // Handshake accept. m_axis_ready feeds ONLY this backward (clear) path and the
  // packer freeze below -- never the assertion of m_axis_valid. That is what
  // keeps this a compliant master: TVALID is a pure function of s1_valid, so it
  // rises as soon as s1 loads regardless of TREADY (it never "waits" for TREADY).
  wire s1_accept = s1_valid & m_axis_ready;
  // pack_shell produced a coherent word this cycle (out_data valid on ready&ce).
  wire word_produced = ready & data_wr_en;
  // Load s1 only when it is free, or being drained this same cycle. Never load
  // (i.e. never overwrite s1_data) while s1 holds a beat the sink has not yet
  // accepted -- that would mutate TDATA under a held TVALID before the handshake,
  // violating the AXIS stability rule. The produced word in that case is dropped
  // and reported via fifo_wr_overflow below.
  // Only meaningful in AXIS mode; gated off in FIFO mode so s1 stays inert.
  wire s1_load = (INTERFACE_TYPE == 1) ? 1'b0 :
                 (word_produced & (~s1_valid | s1_accept));
  // Freeze the packer while s1 holds a beat the sink has not accepted. This
  // prevents any newer/older word from being produced during a ready-low gap,
  // so the one held word (the current one at the moment ready dropped) is the
  // first and only beat presented. Legal backward (ready->ce) dependency.
  wire skid_stall = s1_valid & ~m_axis_ready;

  // Interleaved version of `fifo_wr_data`.
  wire [TOTAL_DATA_WIDTH-1:0] interleaved_data;

  // Output data and corresponding control signal from the routing network.
  wire [TOTAL_DATA_WIDTH-1:0] out_data;
  wire out_sync;
  wire [NUM_OF_CHANNELS*SAMPLES_PER_CHANNEL-1:0] out_valid;

  // In FIFO mode the skid buffer is unused; force its stall to 0 so ce/flush
  // reduce to their legacy values and the FIFO path stays bit-identical.
  wire skid_stall_int = (INTERFACE_TYPE == 1) ? 1'b0 : skid_stall;

  generate if (INTERFACE_TYPE == 1) begin
    assign out_ready_int = 1'b1;
    assign packed_fifo_wr_en = out_valid_int;
    assign packed_fifo_wr_data = out_data_int;
    assign fifo_wr_overflow = packed_fifo_wr_overflow;
    assign m_axis_valid = 1'b0;
    assign m_axis_data = 'h00;
    assign m_axis_keep = 'h00;
    assign m_axis_last = 1'b0;
  end else begin
    assign out_ready_int = m_axis_ready;
    assign packed_fifo_wr_en = 1'b0;
    assign packed_fifo_wr_data = 'h00;
    // A word produced while s1 is occupied and not draining is lost -> overflow.
    // Keyed off word_produced (not s1_load, which is now suppressed in exactly
    // this case) so the dropped word is still reported. With the freeze below
    // this only fires on the single boundary cycle when the last in-flight word
    // lands on a full s1.
    assign fifo_wr_overflow = word_produced & s1_valid & ~s1_accept;

    // s1 is the AXIS master. TVALID depends only on s1_valid (internal state),
    // never on m_axis_ready, so it never waits for TREADY -> deadlock-free.
    assign m_axis_valid = s1_valid;
    assign m_axis_data = s1_data;
    assign m_axis_keep = s1_keep;
    assign m_axis_last = 1'b0;
  end endgenerate

  /*
   * Only the first signal of fifo_rd_en is used. All others are ignored. The
   * only reason why fifo_rd_en has multiple entries is to keep the interface
   * somewhat backwards compatible to the previous upack.
   */
  assign data_wr_en = fifo_wr_en[0];

  // Pause the packer while s1 holds an unaccepted beat; flush the partial word
  // so the next accepted beat starts on a clean word boundary.
  // In FIFO mode skid_stall_int is 0, so ce == data_wr_en and flush == 0
  // (legacy behavior, bit-identical).
  assign ce = data_wr_en & ~skid_stall_int;
  assign flush = skid_stall_int;

  /*
   * The cpack core itself has no backpressure. Overflows can only happen
   * downstream. fifo_wr_overflow is driven per-interface in the generate block
   * above.
   */

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
    .PARALLEL_OR_SERIAL_N (PARALLEL_OR_SERIAL_N)
  ) i_pack_shell (
    .clk (clk),
    .reset (reset),

    .reset_data (reset_data),

    .enable (enable),
    .ce (ce),
    .flush (flush),
    .ready (ready),
    .in_data (interleaved_data),
    .out_data (out_data),
    .out_sync (out_sync),
    .out_valid (out_valid));

  always @(posedge clk) begin
    if (reset_data == 1'b1) begin
      out_valid_int <= 1'b0;
      packed_sync <= 1'b0;
    end else if (ready == 1'b1 && data_wr_en == 1'b1) begin
      out_valid_int <= 1'b1;
      packed_sync <= out_sync;
    end else begin
      out_valid_int <= 1'b0;
      packed_sync <= 1'b0;
    end
  end

  always @(posedge clk) begin: gen_packed_fifo_wr_data
    integer i;

    if (data_wr_en == 1'b1) begin
      for (i = 0; i < NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL; i = i + 1) begin
        if (out_valid[i] == 1'b1) begin
          out_data_int[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= out_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH];
        end
      end
    end
  end

  /*
   * AXIS (INTERFACE_TYPE==0) output register (s1_*).
   *
   * s1 is the AXIS master stage. It snapshots pack_shell's combinational packed
   * word on the produce cycle and holds it, stable, until m_axis_ready accepts
   * it. Because the packer is frozen (ce/flush) while s1 holds an unaccepted
   * beat, no further word is produced during a ready-low gap, so s1 always
   * carries the word that was current when ready dropped -- never a stale one.
   * m_axis_valid = s1_valid is independent of m_axis_ready, so TVALID is never
   * gated on TREADY and the master cannot deadlock against a slave that waits
   * for TVALID.
   */

  // s1 occupancy. Load has priority over drain so a word produced the same cycle
  // the sink accepts the previous one is not lost (no gap, ordering preserved).
  always @(posedge clk) begin
    if (reset_data == 1'b1)      s1_valid <= 1'b0;
    else if (s1_load == 1'b1)    s1_valid <= 1'b1;
    else if (s1_accept == 1'b1)  s1_valid <= 1'b0;
  end

  always @(posedge clk) begin
    if (reset_data == 1'b1) begin
      s1_keep <= {(TOTAL_DATA_WIDTH/8){1'b1}};
    end else if (s1_load == 1'b1) begin
      if (m_axis_ready == 1'b1) begin
        s1_keep <= {(TOTAL_DATA_WIDTH/8){1'b1}};
      end else begin
        s1_keep <= {(TOTAL_DATA_WIDTH/8){1'b0}};
      end
    end
  end

  // s1 data. Snapshot the coherent packed word only on the ready&ce cycle
  // (mandatory for the 6-of-8 / non-power-of-two gen_output_buffer path where
  // out_data is combinational and only valid on that cycle).
  always @(posedge clk) begin: gen_s1_data
    integer i;

    if (data_wr_en == 1'b1 && skid_stall_int == 1'b0) begin
      for (i = 0; i < NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL; i = i + 1) begin
        if (out_valid[i] == 1'b1) begin
          s1_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= out_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH];
        end
      end
    end
  end

endmodule
