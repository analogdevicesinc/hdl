//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Removes FSRC invalid samples.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module rx_fsrc_remove_invalid #(
  parameter DATA_WIDTH = 512,
  parameter NUM_OF_CHANNELS = 4,
  parameter NP = 16
)(
  input  wire                     clk,
  input  wire                     reset,
  input  wire                     fsrc_en,

  input  wire  [DATA_WIDTH-1:0]   in_data,
  input  wire                     in_valid,

  output logic [DATA_WIDTH-1:0]   out_data,
  output logic                    out_valid
);

  localparam NUM_SAMPLES_PER_CHANNEL = DATA_WIDTH / NP / NUM_OF_CHANNELS;
  localparam NUM_OF_SAMPLES = NUM_SAMPLES_PER_CHANNEL * NUM_OF_CHANNELS;
  localparam CHANNEL_WIDTH = NP * NUM_SAMPLES_PER_CHANNEL;
  localparam FSRC_INVALID_SAMPLE = {1'b1, {(NP-1){1'b0}}};

  genvar ii;
  genvar jj;

  logic                      in_valid_d;
  logic [NUM_OF_CHANNELS-1:0][NUM_SAMPLES_PER_CHANNEL-1:0] invalid_sample;
  logic                      out_data_fsrc_valid;
  logic [DATA_WIDTH-1:0]     out_data_unscrambled;
  logic [DATA_WIDTH-1:0]     out_data_fsrc;

  (*KEEP = "TRUE" *)
  logic [2:0][DATA_WIDTH-1:0]                    rx_sample_data_fsrc_d;
  (*KEEP = "TRUE" *)
  logic [2:0]                                    rx_sample_valid_fsrc_d;
  logic [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] data_in_per_channel;
  logic [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] data_in_per_channel_d;
  logic [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] fsrc_data_out_per_channel;
  logic [NUM_OF_CHANNELS-1:0]                    fsrc_data_out_valid_per_channel;
  logic [NUM_OF_CHANNELS-1:0][CHANNEL_WIDTH-1:0] fifo_data_out;
  logic [NUM_OF_CHANNELS-1:0]                    fifo_empty;
  logic [NUM_OF_CHANNELS-1:0]                    fifo_full;
  logic [NUM_OF_CHANNELS-1:0]                    fifo_overflow;
  logic [NUM_OF_CHANNELS-1:0]                    fifo_underflow;
  logic [NUM_OF_CHANNELS-1:0]                    wr_rst_busy;
  logic [NUM_OF_CHANNELS-1:0]                    rd_rst_busy;
  logic                                          sync_rd_en;

  for (ii = 0; ii < NUM_OF_CHANNELS; ii = ii + 1) begin
    assign data_in_per_channel[ii] = in_data[ii * CHANNEL_WIDTH +: CHANNEL_WIDTH];
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      in_valid_d <= 1'b0;
    end else begin
      in_valid_d <= in_valid;
    end
  end

  for(ii = 0; ii < NUM_OF_CHANNELS; ii = ii + 1) begin
    always_ff @(posedge clk) begin
      data_in_per_channel_d[ii] <= data_in_per_channel[ii];
    end

    for (jj = 0; jj < NUM_SAMPLES_PER_CHANNEL; jj = jj + 1) begin
      always_ff @(posedge clk) begin
        if (reset) begin
          invalid_sample[ii][jj] <= 'b0;
        end else begin
          invalid_sample[ii][jj] <= data_in_per_channel[ii][jj * NP +: NP] == FSRC_INVALID_SAMPLE;
        end
      end
    end
  end

  for (ii = 0; ii < NUM_OF_CHANNELS; ii = ii + 1) begin
    fill_holes #(
      .WORD_LENGTH  (NP),
      .NUM_WORDS    (NUM_SAMPLES_PER_CHANNEL)
    ) fill_holes (
      .clk (clk),
      .reset (reset),
      .in_holes (invalid_sample[ii]),
      .in_data (data_in_per_channel_d[ii]),
      .in_valid (in_valid_d),
      .out_data (fsrc_data_out_per_channel[ii]),
      .out_valid (fsrc_data_out_valid_per_channel[ii]));

    xpm_fifo_sync #(
      .CASCADE_HEIGHT(0),
      .DOUT_RESET_VALUE("0"),
      .ECC_MODE("no_ecc"),
      .FIFO_MEMORY_TYPE("auto"),
      .FIFO_READ_LATENCY(1),
      .FIFO_WRITE_DEPTH(32),
      .FULL_RESET_VALUE(0),
      .PROG_EMPTY_THRESH(3),
      .PROG_FULL_THRESH(28),
      .RD_DATA_COUNT_WIDTH(1),
      .READ_DATA_WIDTH(CHANNEL_WIDTH),
      .READ_MODE("std"),
      .SIM_ASSERT_CHK(0),
      .USE_ADV_FEATURES("0707"),
      .WAKEUP_TIME(0),
      .WRITE_DATA_WIDTH(CHANNEL_WIDTH),
      .WR_DATA_COUNT_WIDTH(1)
    ) xpm_fifo_sync_inst (
      .dout(fifo_data_out[ii]),
      .empty(fifo_empty[ii]),
      .full(fifo_full[ii]),
      .overflow(fifo_overflow[ii]),
      .rd_rst_busy(rd_rst_busy[ii]),
      .underflow(fifo_underflow[ii]),
      .wr_rst_busy(wr_rst_busy[ii]),
      .din(fsrc_data_out_per_channel[ii]),
      .injectdbiterr('b0),
      .injectsbiterr('b0),
      .rd_en(sync_rd_en & (~rd_rst_busy[ii])),
      .rst(reset),
      .sleep('b0),
      .wr_clk(clk),
      .wr_en(fsrc_data_out_valid_per_channel[ii] & (~wr_rst_busy[ii])));
  end

  assign sync_rd_en = ~(|fifo_empty);

  for (ii = 0; ii < NUM_OF_CHANNELS; ii = ii + 1) begin
    assign out_data_unscrambled[ii * CHANNEL_WIDTH +: CHANNEL_WIDTH] = fifo_data_out[ii];
  end

  always_ff @(posedge clk) begin
    rx_sample_valid_fsrc_d <= {rx_sample_valid_fsrc_d[1:0], sync_rd_en};
    rx_sample_data_fsrc_d <= {rx_sample_data_fsrc_d[1:0], out_data_unscrambled};

    out_data_fsrc_valid <= rx_sample_valid_fsrc_d[2];
    out_data_fsrc <= rx_sample_data_fsrc_d[2];
  end

  assign out_data  = fsrc_en ? out_data_fsrc : in_data ;
  assign out_valid = fsrc_en ? out_data_fsrc_valid : in_valid ;

endmodule

`default_nettype wire
