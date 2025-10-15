//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Converts a stream of input data with missing words in the bus to
// a stream of output data without missing words.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module tx_fsrc_make_holes #(
  parameter SAMPLE_DATA_WIDTH = 8,
  parameter NUM_OF_CHANNELS = 8,
  parameter CHANNEL_WIDTH = 31,
  parameter SAMPLES_PER_CHANNEL = 8,
  parameter logic [SAMPLE_DATA_WIDTH-1:0] HOLE_VALUE = '0
)(
  input  wire       clk,
  input  wire       reset,

  output logic                                          in_ready,
  input  wire  [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] in_data,
  input  wire                                           in_valid,

  output logic [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] out_data,
  output logic                                          out_valid,
  input  wire                                           out_ready,

  output logic                           holes_ready,
  input  wire                            holes_valid,
  input  wire  [SAMPLES_PER_CHANNEL-1:0] holes_data
);

  logic in_xfer;
  logic out_xfer;
  logic in_valid_d;
  logic holes_xfer;
  logic holes_valid_d;
  logic [1:0][SAMPLES_PER_CHANNEL-1:0] holes_data_d;
  logic [SAMPLES_PER_CHANNEL-1:0] [$clog2(SAMPLES_PER_CHANNEL+1)-1:0] non_holes_cnt_total_per_word;
  logic [SAMPLES_PER_CHANNEL-1:0] [$clog2(SAMPLES_PER_CHANNEL+1)-1:0] non_holes_cnt_total_per_word_d;
  logic [$clog2(SAMPLES_PER_CHANNEL+1)-1:0]                   non_holes_cnt_total;
  logic [$clog2(SAMPLES_PER_CHANNEL+1)-1:0]                   non_holes_cnt_total_comb;
  logic [$clog2(SAMPLES_PER_CHANNEL+1)-1:0]                   non_holes_cnt_out;
  logic [$clog2((SAMPLES_PER_CHANNEL*3)+1)-1:0]               non_holes_cnt_comb;
  logic [$clog2((SAMPLES_PER_CHANNEL*3)+1)-1:0]               non_holes_cnt_comb_shift_out;
  logic [$clog2((SAMPLES_PER_CHANNEL*3)+1)-1:0]               non_holes_cnt_shift_out;
  logic [$clog2((SAMPLES_PER_CHANNEL*3)+1)-1:0]               non_holes_cnt;
  logic [NUM_OF_CHANNELS-1:0][SAMPLES_PER_CHANNEL-1:0][SAMPLE_DATA_WIDTH-1:0]     in_data_d;
  logic [NUM_OF_CHANNELS-1:0][(SAMPLES_PER_CHANNEL*3)-1:0][SAMPLE_DATA_WIDTH-1:0] data_stored;
  logic [NUM_OF_CHANNELS-1:0][(SAMPLES_PER_CHANNEL*SAMPLE_DATA_WIDTH*3)-1:0]      data_stored_shift;
  logic data_stored_out_valid;
  logic data_stored_in_ready;
  logic data_shift_in_xfer;
  logic data_shift_holes_ready;
  logic data_shift_holes_xfer;
  logic data_out_valid;
  logic data_out_ready;
  logic data_out_xfer;
  logic out_valid_next;
  genvar ii;
  genvar jj;

  // Input flow control and pipeline
  always_ff @(posedge clk) begin
    if (reset) begin
      in_valid_d <= '0;
    end else begin
      if(in_xfer) begin
        in_valid_d <= 1'b1;
      end else if(data_shift_in_xfer) begin
        in_valid_d <= 1'b0;
      end
    end
  end

  always_ff @(posedge clk) begin
    if (in_xfer) begin
      in_data_d <= in_data;
    end
  end

  assign in_xfer = in_valid && in_ready;
  assign in_ready = !reset && (!in_valid_d || data_shift_in_xfer);

  // Holes flow control and pipeline
  assign holes_xfer = holes_valid && holes_ready;

  always_ff @(posedge clk) begin
    if (reset) begin
      holes_valid_d <= '0;
    end else begin
      if (holes_xfer) begin
        holes_valid_d <= 1'b1;
      end else if(data_shift_holes_xfer) begin
        holes_valid_d <= 1'b0;
      end
    end
  end

  assign holes_ready = !reset && (!holes_valid_d || data_shift_holes_xfer);

  always_ff @(posedge clk) begin
    if (reset) begin
      holes_data_d[0] <= 'b0;
    end else if (holes_xfer) begin
      holes_data_d[0] <= holes_data;
    end
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      holes_data_d[1] <= 'b0;
    end else if (data_shift_holes_xfer) begin
      holes_data_d[1] <= holes_data_d[0];
    end
  end

  // Count of non-holes words from 0 to jj for each word jj
  for (jj = 0; jj < SAMPLES_PER_CHANNEL; jj = jj + 1) begin : move_holes_gen
    int kk;
    always_comb begin
      if (jj==0) begin
        non_holes_cnt_total_per_word[jj] = !holes_data_d[0][0];
      end else begin
        non_holes_cnt_total_per_word[jj] = non_holes_cnt_total_per_word[jj-1] + !holes_data_d[0][jj];
      end
    end

    // non_holes_cnt_total_per_word_d needs to have 1 subtracted from each value to get position not count
    always_ff @(posedge clk) begin
      if(data_shift_holes_xfer) begin
        non_holes_cnt_total_per_word_d[jj] <= non_holes_cnt_total_per_word[jj] - 1'b1;
      end
    end
  end

  assign non_holes_cnt_total_comb = data_shift_holes_xfer ? non_holes_cnt_total_per_word[SAMPLES_PER_CHANNEL-1] : non_holes_cnt_total;

  always_ff @(posedge clk) begin
    non_holes_cnt_total <= non_holes_cnt_total_comb;
  end

  // Total number of non-holes words
  assign non_holes_cnt_out = data_out_xfer ? non_holes_cnt_total : 0;

  // Number of words after shifting out
  assign non_holes_cnt_comb_shift_out = data_out_xfer ? non_holes_cnt_shift_out : non_holes_cnt;
  assign non_holes_cnt_comb = non_holes_cnt_comb_shift_out + (data_shift_in_xfer ? SAMPLES_PER_CHANNEL : '0);

  for (ii = 0; ii < NUM_OF_CHANNELS; ii=ii+1) begin : data_gen
    // Data after shifting out and in
    for (jj = 0; jj < SAMPLES_PER_CHANNEL*3; jj=jj+1) begin : data_stored_shift_out_gen
      assign data_stored_shift[ii][jj*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] = jj < non_holes_cnt_comb_shift_out ? data_stored[ii][jj+non_holes_cnt_out] : in_data_d[ii][jj-non_holes_cnt_comb_shift_out];
    end
  end

  always_ff @(posedge clk) begin
    data_stored <= data_stored_shift;
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      non_holes_cnt <= '0;
      data_stored_out_valid <= 1'b0;
      data_stored_in_ready <= 1'b0;
    end else begin
      non_holes_cnt <= non_holes_cnt_comb;
      non_holes_cnt_shift_out <= non_holes_cnt_comb - non_holes_cnt_total_comb;
      data_stored_out_valid <= non_holes_cnt_comb >= SAMPLES_PER_CHANNEL;
      data_stored_in_ready <= non_holes_cnt_comb <= SAMPLES_PER_CHANNEL*2;
    end
  end

  assign data_shift_holes_ready = data_stored_out_valid && (!data_out_valid || data_out_xfer);

  // Shift data in if input data is valid and there is enough room in data_stored
  assign data_shift_in_xfer = in_valid_d && data_stored_in_ready;

  assign data_shift_holes_xfer = holes_valid_d && data_shift_holes_ready;

  always_ff @(posedge clk) begin
    if (reset) begin
      data_out_valid <= '0;
    end else begin
      if (data_shift_holes_xfer) begin
        data_out_valid <= 1'b1;
      end else if (data_out_xfer) begin
        data_out_valid <= 1'b0;
      end
    end
  end

  // Out valid if holes calculation is complete and stored data is valid
  assign out_valid_next = data_out_valid && data_stored_out_valid;

  assign data_out_ready = !out_valid || out_xfer;
  assign data_out_xfer = out_valid_next && data_out_ready;

  for (ii = 0; ii < NUM_OF_CHANNELS; ii=ii+1) begin : out_data_gen
    // Create output bus
    for (jj = 0; jj < SAMPLES_PER_CHANNEL; jj=jj+1) begin : out_data_gen
      always_ff @(posedge clk) begin
        if (reset) begin
          out_data[ii][jj*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= HOLE_VALUE;
        end if (data_out_xfer) begin
          out_data[ii][jj*SAMPLE_DATA_WIDTH+:SAMPLE_DATA_WIDTH] <= holes_data_d[1][jj] ? HOLE_VALUE : data_stored[ii][non_holes_cnt_total_per_word_d[jj]];
        end
      end
    end
  end

  // Output flow control
  always_ff @(posedge clk) begin
    if (reset) begin
      out_valid <= 1'b0;
    end else begin
      if (data_out_xfer) begin
        out_valid <= 1'b1;
      end else if (out_xfer) begin
        out_valid <= 1'b0;
      end
    end
  end

  assign out_xfer = out_valid && out_ready;

endmodule

`default_nettype wire
