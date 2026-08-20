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

  // AXIS (INTERFACE_TYPE==0) output skid buffer -- 2 deep.
  //   s1_* : the AXIS master (output) stage. m_axis_valid = s1_valid,
  //          m_axis_data = s1_data.
  //   s2_* : the forward (catch) stage between pack_shell and s1.
  // Two slots let TVALID stay continuously high across accepts: while s1 holds
  // the current beat, s2 catches the next produced word, so on every accept s1
  // is immediately reloaded from s2 with no bubble. The packer is frozen only
  // when BOTH slots are full and the sink is not draining. Unused in FIFO mode.
  reg s1_valid = 1'b0;
  reg [TOTAL_DATA_WIDTH-1:0] s1_data = 'h00;
  reg s2_valid = 1'b0;
  reg [TOTAL_DATA_WIDTH-1:0] s2_data = 'h00;

  // Handshake accept. m_axis_ready feeds ONLY the backward (drain/shift) path and
  // the packer freeze below -- never the assertion of m_axis_valid. TVALID is a
  // pure function of s1_valid, so it rises as soon as s1 loads regardless of
  // TREADY (it never "waits" for TREADY) -> compliant, deadlock-free master.
  wire s1_accept = s1_valid & m_axis_ready;
  // pack_shell produced a coherent word this cycle (out_data valid on ready&ce).
  wire word_produced = ready & data_wr_en;

  // A slot frees this cycle if s1 drains, letting s2 shift into s1.
  wire s1_free = ~s1_valid | m_axis_ready;
  // s1 is (re)loaded when it is free and a word is available (from s2 if it holds
  // one, else directly from the freshly produced word).
  wire s1_shift = s1_free & (s2_valid | word_produced);
  // The fresh produced word goes straight to s1 only when both slots are empty.
  wire s1_take_new = s1_shift & ~s2_valid;
  // Otherwise a fresh produced word is captured by s2, provided s2 has room:
  // s2 is free if it is currently empty, or it is shifting its content into s1.
  wire s2_free = ~s2_valid | (s1_free & s2_valid);
  wire s2_load = word_produced & ~s1_take_new & s2_free;
  // A word produced while both slots are full and s1 is not draining has nowhere
  // to go -> dropped, reported via fifo_wr_overflow. This is the freeze boundary
  // case only; the freeze below prevents it in steady state.
  wire skid_drop = word_produced & s1_valid & s2_valid & ~m_axis_ready;

  // Freeze the packer while both slots are full and the sink is not draining.
  // While s1 drains there is always room (s2->s1 shift), so no freeze -> the
  // stream stays gap-free. Legal backward (ready->ce) dependency.
  wire skid_stall = s1_valid & s2_valid & ~m_axis_ready;

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
    // A word produced while both slots are full and s1 is not draining is lost
    // -> overflow. With the freeze this only fires on the single boundary cycle
    // when the last in-flight word lands on a full 2-deep buffer.
    assign fifo_wr_overflow = packed_fifo_wr_overflow | skid_drop;

    // s1 is the AXIS master. TVALID depends only on s1_valid (internal state),
    // never on m_axis_ready, so it never waits for TREADY -> deadlock-free.
    assign m_axis_valid = s1_valid;
    assign m_axis_data = s1_data;
    assign m_axis_keep = {(NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL/8){1'b1}};
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
   * AXIS (INTERFACE_TYPE==0) output skid buffer -- 2 deep (s1 master, s2 catch).
   *
   * s2 snapshots pack_shell's combinational packed word on the produce cycle;
   * s1 is fed either from s2 (steady state) or directly from the produced word
   * (both slots empty). Because a beat produced while s1 holds an unaccepted beat
   * is parked in s2, s1_data is never overwritten under a held TVALID -> TDATA is
   * stable until the handshake completes. m_axis_valid = s1_valid is independent
   * of m_axis_ready, so TVALID is never gated on TREADY (deadlock-free master).
   * With two slots, TVALID stays continuously high across accepts (no bubbles):
   * on every accept s1 reloads from s2 the same cycle.
   */

  // s1 occupancy: stays valid while held; loads on shift (from s2 or a fresh
  // word); clears only if it drains with nothing to shift in behind it.
  always @(posedge clk) begin
    if (reset_data == 1'b1)          s1_valid <= 1'b0;
    else if (s1_shift == 1'b1)       s1_valid <= 1'b1;
    else if (s1_accept == 1'b1)      s1_valid <= 1'b0;
  end

  // s2 occupancy: loads a fresh produced word; clears when it shifts into s1
  // and no new word replaces it the same cycle.
  always @(posedge clk) begin
    if (reset_data == 1'b1)          s2_valid <= 1'b0;
    else if (s2_load == 1'b1)        s2_valid <= 1'b1;
    else if (s1_shift == 1'b1)       s2_valid <= 1'b0;
  end

  // s1 data: on a shift, take s2's stored word (plain copy -- already coherent),
  // or the freshly produced word when s1 takes it directly (both slots empty).
  // The fresh-word path masks by out_valid[i] because out_data is combinational
  // and only the valid lanes carry this cycle's word (6-of-8 / gen_output_buffer).
  always @(posedge clk) begin: gen_s1_data
    integer i;

    if (s1_shift == 1'b1) begin
      if (s1_take_new == 1'b1) begin
        for (i = 0; i < NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL; i = i + 1) begin
          if (out_valid[i] == 1'b1) begin
            s1_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= out_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH];
          end
        end
      end else begin
        s1_data <= s2_data;
      end
    end
  end

  // s2 data: snapshot the coherent packed word on the produce cycle, masked by
  // out_valid[i] as above.
  always @(posedge clk) begin: gen_s2_data
    integer i;

    if (s2_load == 1'b1) begin
      for (i = 0; i < NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL; i = i + 1) begin
        if (out_valid[i] == 1'b1) begin
          s2_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= out_data[i*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH];
        end
      end
    end
  end

endmodule
