//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Inserts invalid samples into TX sample data streams
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module tx_fsrc #(
  parameter NUM_OF_CHANNELS = 4,
  parameter SAMPLE_DATA_WIDTH = 16,
  parameter DATA_WIDTH = 256,
  parameter ACCUM_WIDTH = 64,
  parameter NUM_SAMPLES = 16
) (
  input  wire clk,
  input  wire reset,

  output reg [31:0] debug_flags,

  input  wire                                         enable,
  input  wire                                         start,
  input  wire                                         stop,
  input  wire  [NUM_OF_CHANNELS-1:0]                  conv_mask,
  input  wire  [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0]     accum_set_val,
  input  wire                                         accum_set,
  input  wire  [ACCUM_WIDTH-1:0]                      accum_add_val,

  output logic                   in_ready,
  input  wire                    in_valid,
  input  wire  [DATA_WIDTH-1:0]  in_data,

  input  wire                    out_ready,
  output logic [DATA_WIDTH-1:0]  out_data,
  output logic                   out_valid
);

  localparam FSRC_INVALID_SAMPLE = {1'b1, {(SAMPLE_DATA_WIDTH-1){1'b0}}};
  localparam CHANNEL_WIDTH = DATA_WIDTH / NUM_OF_CHANNELS;
  localparam SAMPLES_PER_CHANNEL = CHANNEL_WIDTH / SAMPLE_DATA_WIDTH;

  logic                                          in_fifo_out_ready;
  logic [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] in_fifo_out_data;
  logic [NUM_OF_CHANNELS-1:0]                    in_fifo_out_valid;
  logic [NUM_OF_CHANNELS-1:0]                    in_fifo_out_valid_next;
  logic                                          fsrc_in_single_valid;
  logic                                          fsrc_in_single_ready;
  logic                                          fsrc_out_valid;
  logic [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] fsrc_out_data;
  logic                                          fsrc_out_ready;
  logic [NUM_OF_CHANNELS-1:0]                    out_fifo_in_ready;
  logic [NUM_OF_CHANNELS-1:0]                    out_fifo_in_ready_next;
  logic [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] out_fifo_in_data;
  logic [NUM_OF_CHANNELS-1:0]                    out_fifo_in_valid;
  logic                                          accum_en;
  logic                   holes_ready;
  logic [NUM_SAMPLES-1:0] holes_n;
  logic [NUM_SAMPLES-1:0] holes_data;
  logic                   fsrc_data_en;
  logic [NUM_OF_CHANNELS-1:0] in_ready_s;
  logic [NUM_OF_CHANNELS-1:0] out_valid_s;
  logic debug_enable;

  wire [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] in_data_arr;
  wire [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] out_data_arr;
  wire                      [   DATA_WIDTH-1:0] deinterleaved_data;
  wire                      [   DATA_WIDTH-1:0] out_data_deinterleaved;

  /* Data from the offload should come interleaved */
  ad_perfect_shuffle #(
    .NUM_GROUPS (SAMPLES_PER_CHANNEL),
    .WORDS_PER_GROUP (NUM_OF_CHANNELS),
    .WORD_WIDTH (SAMPLE_DATA_WIDTH)
  ) i_deinterleave (
    .data_in (in_data),
    .data_out (deinterleaved_data));

  /* Map a flat array to a 2d array of data per channel and vice-versa */
  genvar ii;
  for (ii = 0; ii < NUM_OF_CHANNELS; ii = ii + 1) begin
    assign in_data_arr[ii] = deinterleaved_data[ii*CHANNEL_WIDTH+:CHANNEL_WIDTH];
    assign out_data_deinterleaved[ii*CHANNEL_WIDTH+:CHANNEL_WIDTH] = out_data_arr[ii];
  end

  always @(posedge clk) begin
    if (reset) begin
      fsrc_data_en <= 1'b0;
    end else begin
      if (~enable || stop) begin
        fsrc_data_en <= 1'b0;
      end else if (start) begin
        fsrc_data_en <= 1'b1;
      end
      debug_enable <= enable;
    end
  end

  for (ii = 0; ii < NUM_OF_CHANNELS; ii=ii+1) begin : in_fifo_gen
      fifo_sync_2deep #(
        .DWIDTH             (CHANNEL_WIDTH),
        .DORESET            (1'b1),
        .REGISTER_INTERFACE (1'b1)
      ) in_fifo (
        .aclk           (clk),
        .aresetn        (!reset),
        .m_tready       (in_fifo_out_ready),
        .m_tdata        (in_fifo_out_data[ii]),
        .m_tvalid       (in_fifo_out_valid[ii]),
        .m_tvalid_next  (in_fifo_out_valid_next[ii]),
        .s_tready       (in_ready_s[ii]),
        .s_tready_next  (),
        .s_tdata        (in_data_arr[ii]),
        .s_tvalid       (in_valid),
        .cnt            ()
      );
  end
  assign in_ready = |in_ready_s;

  always_ff @(posedge clk) begin
    if (reset) begin
      fsrc_in_single_valid <= 1'b0;
    end else begin
      fsrc_in_single_valid <= enable && &(in_fifo_out_valid_next | ~conv_mask);
    end
  end

  always_comb begin
    if (reset) begin
      in_fifo_out_ready = '0;
    end else begin
      if (enable) begin
        in_fifo_out_ready = fsrc_in_single_valid;
      end else begin
        in_fifo_out_ready = |out_fifo_in_ready;
      end
    end
  end

  always_comb begin
    if (reset) begin
      out_fifo_in_valid = '0;
    end else begin
      if (enable) begin
        out_fifo_in_valid = {NUM_SAMPLES{fsrc_out_valid && fsrc_out_ready}} & conv_mask;
      end else begin
        out_fifo_in_valid = in_fifo_out_valid;
      end
    end
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      fsrc_out_ready <= 1'b0;
    end else begin
      fsrc_out_ready <= enable && &(out_fifo_in_ready_next | ~conv_mask);
    end
  end

  assign out_fifo_in_data = enable ? fsrc_out_data : in_fifo_out_data;
  assign holes_data = fsrc_data_en ? {NUM_OF_CHANNELS{~holes_n}} : '1;
  assign accum_en = !reset && enable && fsrc_data_en && holes_ready;

  // Generate sequence of valid and invalid samples
  tx_fsrc_sample_en_gen #(
    .ACCUM_WIDTH (ACCUM_WIDTH),
    .NUM_SAMPLES (NUM_SAMPLES)
  ) tx_fsrc_sample_en_gen (
    .clk        (clk),
    .reset      (reset),
    .set_val    (accum_set_val),
    .set        (accum_set),
    .add_val    (accum_add_val),
    .add        (accum_en),
    .overflow   (holes_n)
  );

  // Insert invalid samples in sample streams
  tx_fsrc_make_holes #(
    .SAMPLE_DATA_WIDTH (SAMPLE_DATA_WIDTH),
    .NUM_OF_CHANNELS (NUM_OF_CHANNELS),
    .CHANNEL_WIDTH (CHANNEL_WIDTH),
    .SAMPLES_PER_CHANNEL(SAMPLES_PER_CHANNEL),
    .HOLE_VALUE (FSRC_INVALID_SAMPLE)
  ) tx_fsrc_make_holes (
    .clk              (clk),
    .reset            (reset),
    .in_data          (in_fifo_out_data),
    .in_valid         (fsrc_in_single_valid),
    .in_ready         (fsrc_in_single_ready),
    .out_data         (fsrc_out_data),
    .out_valid        (fsrc_out_valid),
    .out_ready        (fsrc_out_ready),
    .holes_ready      (holes_ready),
    .holes_valid      (!reset),
    .holes_data       (holes_data)
  );

  for (ii = 0; ii < NUM_OF_CHANNELS; ii=ii+1) begin : out_fifo_gen
    fifo_sync_2deep #(
      .DWIDTH             (CHANNEL_WIDTH),
      .DORESET            (1'b1),
      .REGISTER_INTERFACE (1'b1)
    ) out_fifo (
      .aclk           (clk),
      .aresetn        (!reset),
      .m_tready       (out_ready),
      .m_tdata        (out_data_arr[ii]),
      .m_tvalid       (out_valid_s[ii]),
      .m_tvalid_next  (),
      .s_tready       (out_fifo_in_ready[ii]),
      .s_tready_next  (out_fifo_in_ready_next[ii]),
      .s_tdata        (out_fifo_in_data[ii]),
      .s_tvalid       (out_fifo_in_valid),
      .cnt            ()
    );
  end
  assign out_valid = |out_valid_s;

  always @(posedge clk) begin
    debug_flags[31:15] <= 'b0;

    debug_flags[14] <= holes_n[3];
    debug_flags[13] <= holes_n[2];
    debug_flags[12] <= holes_n[1];
    debug_flags[11] <= holes_n[0];

    debug_flags[11] <= 'b0;
    debug_flags[10] <= 'b0;
    debug_flags[9] <= in_valid;
    debug_flags[8] <= in_ready;

    debug_flags[7] <= out_valid;
    debug_flags[6] <= out_ready;
    debug_flags[5] <= holes_ready;
    debug_flags[4] <= fsrc_data_en;

    debug_flags[3] <= debug_enable;
  end

  always @(*) begin
    debug_flags[2] <= enable;
    debug_flags[1] <= reset;
    debug_flags[0] <= 1'b1;
  end

  /* Since we are connecting to upack, the data needs to be interleaved again */
  ad_perfect_shuffle #(
    .NUM_GROUPS (NUM_OF_CHANNELS),
    .WORDS_PER_GROUP (SAMPLES_PER_CHANNEL),
    .WORD_WIDTH (SAMPLE_DATA_WIDTH)
  ) i_interleave (
    .data_in (out_data_deinterleaved),
    .data_out (out_data));

endmodule

`default_nettype wire
