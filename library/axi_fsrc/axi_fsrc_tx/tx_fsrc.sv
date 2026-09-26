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

// Inserts invalid samples into TX sample data streams

`default_nettype none

module tx_fsrc #(
  parameter NP = 16,
  parameter DATA_WIDTH = 1024,
  parameter MAX_CONV = 8,
  parameter ACCUM_WIDTH = 64,
  localparam NUM_SAMPLES = DATA_WIDTH/NP
)(
  input  wire                                         clk,
  input  wire                                         reset,

  input  wire                                         fsrc_en,
  input  wire                                         fsrc_data_en,
  input  wire  [MAX_CONV-1:0]                         conv_mask,
  input  wire  [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0]     accum_set_val,
  input  wire                                         accum_set,
  input  wire  [ACCUM_WIDTH-1:0]                      accum_add_val,
  input  wire  [ACCUM_WIDTH-1:0]                      accum_step_val,
  input  wire  [7:0]                                  group_beats_m1,
  input  wire  [7:0]                                  group_start,

  output logic [MAX_CONV-1:0]                         in_ready,
  input  wire  [MAX_CONV-1:0][(NP*NUM_SAMPLES)-1:0]   in_data,
  input  wire  [MAX_CONV-1:0]                         in_valid,

  output logic [MAX_CONV-1:0][(NP*NUM_SAMPLES)-1:0]   out_data,
  output logic [MAX_CONV-1:0]                         out_valid,
  input  wire  [MAX_CONV-1:0]                         out_ready
);

  localparam FSRC_INVALID_SAMPLE = {1'b1, {(NP-1){1'b0}}};

  logic [MAX_CONV-1:0]                        in_fifo_out_ready;
  logic [MAX_CONV-1:0][(NP*NUM_SAMPLES)-1:0]  in_fifo_out_data;
  logic [MAX_CONV-1:0]                        in_fifo_out_valid;
  logic [MAX_CONV-1:0]                        in_fifo_out_valid_next;
  logic                                       fsrc_in_single_valid;
  logic [MAX_CONV-1:0][(NP*NUM_SAMPLES)-1:0]  fsrc_in_data;
  logic                                       fsrc_in_single_ready;
  logic                                       fsrc_out_valid;
  logic [MAX_CONV-1:0][(NP*NUM_SAMPLES)-1:0]  fsrc_out_data;
  logic                                       fsrc_out_ready;
  logic [MAX_CONV-1:0]                        out_fifo_in_ready;
  logic [MAX_CONV-1:0]                        out_fifo_in_ready_next;
  logic [MAX_CONV-1:0][(NP*NUM_SAMPLES)-1:0]  out_fifo_in_data;
  logic [MAX_CONV-1:0]                        out_fifo_in_valid;
  logic                                       accum_en;
  logic                                       holes_ready;
  logic                                       holes_valid;
  logic [NUM_SAMPLES-1:0]                     holes_n;
  logic [NUM_SAMPLES-1:0]                     holes_data;
  genvar ii;

  for(ii = 0; ii < MAX_CONV; ii=ii+1) begin :  in_fifo_gen
      fifo_sync_2deep #(
        .DWIDTH             (DATA_WIDTH),
        .DORESET            (1'b0),
        .REGISTER_INTERFACE (1'b1)
      ) in_fifo (
        .aclk           (clk),
        .aresetn        (!reset),
        .m_tready       (in_fifo_out_ready[ii]),
        .m_tdata        (in_fifo_out_data[ii]),
        .m_tvalid       (in_fifo_out_valid[ii]),
        .m_tvalid_next  (in_fifo_out_valid_next[ii]),
        .s_tready       (in_ready[ii]),
        .s_tready_next  (),
        .s_tdata        (in_data[ii]),
        .s_tvalid       (in_valid[ii]),
        .cnt            ()
      );
  end

  always_ff @(posedge clk) begin
    if(reset) begin
      fsrc_in_single_valid <= 1'b0;
    end else begin
      fsrc_in_single_valid <= fsrc_en && &(in_fifo_out_valid_next | ~conv_mask);
    end
  end

  assign fsrc_in_data = in_fifo_out_data;

  always_comb begin
    if(reset) begin
      in_fifo_out_ready = '0;
    end else begin
      if(fsrc_en) begin
        in_fifo_out_ready = {MAX_CONV{fsrc_in_single_valid && fsrc_in_single_ready}};
      end else begin
        in_fifo_out_ready = out_fifo_in_ready;
      end
    end
  end

  always_comb begin
    if(reset) begin
      out_fifo_in_valid = '0;
    end else begin
      if(fsrc_en) begin
        out_fifo_in_valid = {MAX_CONV{fsrc_out_valid && fsrc_out_ready}} & conv_mask;
      end else begin
        out_fifo_in_valid = in_fifo_out_valid;
      end
    end
  end

  assign out_fifo_in_data = fsrc_en ? fsrc_out_data : in_fifo_out_data;

  always_ff @(posedge clk) begin
    if(reset) begin
      fsrc_out_ready <= 1'b0;
    end else begin
      fsrc_out_ready <= fsrc_en && &(out_fifo_in_ready_next | ~conv_mask);
    end
  end

  // holes_data is one bit per sample slot, not per converter: the MAX_CONV
  // replication the original had was truncated back down to NUM_SAMPLES anyway.
  assign holes_data = fsrc_data_en ? ~holes_n : '1;
  assign holes_valid = !reset;
  assign accum_en = !reset && fsrc_en && fsrc_data_en && holes_ready;

  // Generate sequence of valid and invalid samples
  tx_fsrc_sample_en_gen #(
    .ACCUM_WIDTH  (ACCUM_WIDTH),
    .NUM_SAMPLES  (NUM_SAMPLES)
  ) tx_fsrc_sample_en_gen (
    .clk        (clk),
    .en         (accum_en),
    .sample_en  (holes_n),
    .set_val    (accum_set_val),
    .set        (accum_set),
    .add_val    (accum_add_val),
    .step_val   (accum_step_val),
    .group_beats_m1 (group_beats_m1),
    .group_start (group_start)
  );

  // Insert invalid samples in sample streams
  tx_fsrc_make_holes #(
    .WORD_LENGTH  (NP),
    .NUM_WORDS    (NUM_SAMPLES),
    .NUM_DATA     (MAX_CONV),
    .HOLE_VALUE   (FSRC_INVALID_SAMPLE)
  ) tx_fsrc_make_holes (
    .clk              (clk),
    .reset            (reset),
    .in_data          (fsrc_in_data),
    .in_valid         (fsrc_in_single_valid),
    .in_ready         (fsrc_in_single_ready),
    .out_data         (fsrc_out_data),
    .out_valid        (fsrc_out_valid),
    .out_ready        (fsrc_out_ready),
    .holes_ready      (holes_ready),
    .holes_valid      (holes_valid),
    .holes_data       (holes_data)
  );

  for(ii = 0; ii < MAX_CONV; ii=ii+1) begin :  out_fifo_gen
    fifo_sync_2deep #(
      .DWIDTH             (DATA_WIDTH),
      .DORESET            (1'b0),
      .REGISTER_INTERFACE (1'b1)
    ) out_fifo (
      .aclk           (clk),
      .aresetn        (!reset),
      .m_tready       (out_ready[ii]),
      .m_tdata        (out_data[ii]),
      .m_tvalid       (out_valid[ii]),
      .m_tvalid_next  (),
      .s_tready       (out_fifo_in_ready[ii]),
      .s_tready_next  (out_fifo_in_ready_next[ii]),
      .s_tdata        (out_fifo_in_data[ii]),
      .s_tvalid       (out_fifo_in_valid[ii]),
      .cnt            ()
    );
  end

endmodule

`default_nettype wire
