//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Removes FSRC invalid samples.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module rx_fsrc_remove_invalid #(
  parameter DATA_WIDTH = 512,
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

  localparam NUM_SAMPLES = DATA_WIDTH / NP;
  localparam FSRC_INVALID_SAMPLE = {1'b1, {(NP-1){1'b0}}};

  logic [DATA_WIDTH-1:0]   in_data_d;
  logic                    in_valid_d;
  logic [NUM_SAMPLES-1:0]  invalid_sample;
  logic [DATA_WIDTH-1:0]   out_data_fsrc;
  logic                    out_valid_fsrc;
  genvar ii;

  always_ff @(posedge clk) begin
    if(reset) begin
      in_valid_d <= '0;
    end else begin
      in_valid_d <= in_valid;
    end
  end

  always_ff @(posedge clk) begin
    in_data_d <= in_data;
  end

  for(ii = 0; ii < NUM_SAMPLES; ii=ii+1) begin : invalid_sample_check_gen
    always_ff @(posedge clk) begin
      if(reset) begin
        invalid_sample[ii] <= '0;
      end else begin
        invalid_sample[ii] <= in_data[ii*NP+:NP] == FSRC_INVALID_SAMPLE;
      end
    end
  end

  fill_holes #(
    .WORD_LENGTH  (NP),
    .NUM_WORDS    (NUM_SAMPLES)
  ) fill_holes (
    .clk              (clk),
    .reset            (reset),
    .in_holes         (invalid_sample),
    .in_data          (in_data_d),
    .in_valid         (in_valid_d),
    .out_data         (out_data_fsrc),
    .out_valid        (out_valid_fsrc)
  );

  assign out_data = fsrc_en ? out_data_fsrc : in_data_d;
  assign out_valid = fsrc_en ? out_valid_fsrc : in_valid_d;

endmodule

`default_nettype wire
