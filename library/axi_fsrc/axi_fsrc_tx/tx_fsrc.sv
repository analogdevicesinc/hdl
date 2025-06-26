//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Inserts invalid samples into TX sample data streams
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module tx_fsrc #(
  parameter NP = 16,
  parameter DATA_WIDTH = 256,
  parameter ACCUM_WIDTH = 64,
  parameter NUM_SAMPLES = 16
)(
  input  wire                                         clk,
  input  wire                                         reset,

  input  wire                                         enable,
  input  wire                                         start,
  input  wire                                         stop,
  input  wire  [NUM_SAMPLES-1:0]                      conv_mask,
  input  wire  [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0]     accum_set_val,
  input  wire                                         accum_set,
  input  wire  [ACCUM_WIDTH-1:0]                      accum_add_val,

  output logic                                        in_ready,
  input  wire                                         in_valid,
  input  wire  [NUM_SAMPLES-1:0][NP-1:0]              in_data,

  input  wire                                         out_ready,
  output logic [NUM_SAMPLES-1:0][NP-1:0]              out_data,
  output logic                                        out_valid
);

  localparam FSRC_INVALID_SAMPLE = {1'b1, {(NP-1){1'b0}}};

  logic                                       in_fifo_out_ready;
  logic [NUM_SAMPLES-1:0][NP-1:0]             in_fifo_out_data;
  logic [NUM_SAMPLES-1:0]                     in_fifo_out_valid;
  logic [NUM_SAMPLES-1:0]                     in_fifo_out_valid_next;
  logic                                       fsrc_in_single_valid;
  logic                                       fsrc_in_single_ready;
  logic                                       fsrc_out_valid;
  logic [NUM_SAMPLES-1:0][NP-1:0]             fsrc_out_data;
  logic                                       fsrc_out_ready;
  logic [NUM_SAMPLES-1:0]                     out_fifo_in_ready;
  logic [NUM_SAMPLES-1:0]                     out_fifo_in_ready_next;
  logic [NUM_SAMPLES-1:0][NP-1:0]             out_fifo_in_data;
  logic [NUM_SAMPLES-1:0]                     out_fifo_in_valid;
  logic                                       accum_en;
  logic                                       holes_ready;
  logic [NUM_SAMPLES-1:0]                     holes_n;
  logic [NUM_SAMPLES-1:0]                     holes_data;
  logic                                       fsrc_data_en;
  logic [NUM_SAMPLES-1:0]                     in_ready_s;
  logic [NUM_SAMPLES-1:0]                     out_valid_s;

  genvar ii;

  always @(posedge clk) begin
    if (reset) begin
      fsrc_data_en <= 1'b0;
    end else begin
      if (~enable || stop) begin
        fsrc_data_en <= 1'b0;
      end else if (start & in_valid) begin
        fsrc_data_en <= 1'b1;
      end
    end
  end

  for (ii = 0; ii < NUM_SAMPLES; ii=ii+1) begin : in_fifo_gen
      fifo_sync_2deep #(
        .DWIDTH             (DATA_WIDTH),
        .DORESET            (1'b0),
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
        .s_tdata        (in_data[ii]),
        .s_tvalid       (in_valid),
        .cnt            ()
      );
  end
  assign in_ready = |in_ready_s;

  always_ff @(posedge clk) begin
    if(reset) begin
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
    if(reset) begin
      fsrc_out_ready <= 1'b0;
    end else begin
      fsrc_out_ready <= enable && &(out_fifo_in_ready_next | ~conv_mask);
    end
  end

  assign out_fifo_in_data = enable ? fsrc_out_data : in_fifo_out_data;
  assign holes_data = fsrc_data_en ? {NUM_SAMPLES{~holes_n}} : '1;
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
    .NP (NP),
    .NUM_SAMPLES (NUM_SAMPLES),
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

  for (ii = 0; ii < NUM_SAMPLES; ii=ii+1) begin : out_fifo_gen
    fifo_sync_2deep #(
      .DWIDTH             (DATA_WIDTH),
      .DORESET            (1'b0),
      .REGISTER_INTERFACE (1'b1)
    ) out_fifo (
      .aclk           (clk),
      .aresetn        (!reset),
      .m_tready       (out_ready),
      .m_tdata        (out_data[ii]),
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

endmodule

`default_nettype wire
