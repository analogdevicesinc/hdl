//////////////////////////////////////////////////////////////////////////////////
// Company:    Analog Devices, Inc.
// Engineer:   MBB
// Converts a stream of input data with missing words in the bus to
// a stream of output data without missing words.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
`default_nettype none

module fill_holes #(
  parameter WORD_LENGTH = 16,
  parameter NUM_WORDS = 4
)(
  input  wire       clk,
  input  wire       reset,

  input  wire  [NUM_WORDS-1:0]                in_holes,
  input  wire  [(WORD_LENGTH*NUM_WORDS)-1:0]  in_data,
  input  wire                                 in_valid,

  output logic [(WORD_LENGTH*NUM_WORDS)-1:0]  out_data,
  output logic                                out_valid
);

  logic [NUM_WORDS-1:0]                     in_holes_d;
  logic [3:1][(WORD_LENGTH*NUM_WORDS)-1:0]  in_data_d;
  logic [4:1]                               in_valid_d;
  logic [NUM_WORDS-1:0] [$clog2(NUM_WORDS)-1:0]     word_sel;
  logic [NUM_WORDS-1:0] [$clog2(NUM_WORDS)-1:0]     word_sel_d;
  logic [NUM_WORDS-1:0] [$clog2(NUM_WORDS+1)-1:0]   non_holes_cnt_total_per_word;
  logic [NUM_WORDS-1:0] [$clog2(NUM_WORDS+1)-1:0]   non_holes_cnt_total_per_word_d;
  logic [NUM_WORDS-1:0]                     cnt_found;
  logic [(WORD_LENGTH*NUM_WORDS)-1:0]       data_filled;
  logic [(WORD_LENGTH*NUM_WORDS)-1:0]       data_filled_d;
  logic [(WORD_LENGTH*NUM_WORDS*2)-1:0]     data_filled_padded;
  logic [$clog2(NUM_WORDS+1) -1:0]          non_holes_cnt_filled;
  logic [2:1] [$clog2(NUM_WORDS+1)-1:0]     non_holes_cnt_filled_d;
  logic [$clog2(NUM_WORDS+1)-1:0]           non_holes_cnt_filled_valid;
  logic [(WORD_LENGTH*NUM_WORDS*3)-1:0]     data_stored;
  logic [(WORD_LENGTH*NUM_WORDS*3)-1:0]     data_stored_shift_out;
  logic [(WORD_LENGTH*NUM_WORDS*3)-1:0]     data_stored_shift_in;
  logic [$clog2((NUM_WORDS*3)+1)-1:0]       non_holes_cnt_comb_shift_out;
  logic [$clog2((NUM_WORDS*3)+1)-1:0]       non_holes_cnt_comb;
  logic [$clog2((NUM_WORDS*3)+1)-1:0]       non_holes_cnt;
  genvar jj;

  always_ff @(posedge clk) begin
    if (reset) begin
      in_holes_d <= '0;
      in_valid_d <= '0;
      in_data_d <= 'X;
    end else begin
      in_holes_d <= in_holes;
      in_data_d <= {in_data_d[2:1], in_data};
      in_valid_d <= {in_valid_d[3:1], in_valid};
    end
  end

  // Count of non-holes words from 0 to jj for each word jj
  for (jj=0; jj < NUM_WORDS; jj=jj+1) begin : move_holes_gen
    int kk;
    always_comb begin
      if(jj==0) begin
        non_holes_cnt_total_per_word[jj] = !in_holes_d[0];
      end else begin
        non_holes_cnt_total_per_word[jj] = non_holes_cnt_total_per_word[jj-1] + !in_holes_d[jj];
      end
    end

    // Select input word position per-shifted data bus word word
    always_comb begin
      word_sel[jj] = '0;
      cnt_found[jj] = 1'b0;
      for(kk = 0; kk < NUM_WORDS; kk=kk+1) begin
        if(!cnt_found[jj] && (non_holes_cnt_total_per_word_d[kk] == (jj+1'b1))) begin
          cnt_found[jj] = 1'b1;
          word_sel[jj] = kk;
        end
      end
    end

    // Register shifted data words
    always_ff @(posedge clk) begin
      word_sel_d[jj] <= word_sel[jj];
      data_filled[jj*WORD_LENGTH+:WORD_LENGTH] <= in_data_d[3][word_sel_d[jj]*WORD_LENGTH+:WORD_LENGTH];
    end
  end

  always @(posedge clk) begin
    non_holes_cnt_total_per_word_d <= non_holes_cnt_total_per_word;
    data_filled_d <= data_filled;
  end

  // Total non-holes words for entire input word
  assign non_holes_cnt_filled = non_holes_cnt_total_per_word_d[NUM_WORDS-1];

  // Register non-holes count
  always_ff @(posedge clk) begin
    if(reset) begin
      non_holes_cnt_filled_valid <= '0;
      non_holes_cnt_filled_d <= 'X;
    end else begin
      non_holes_cnt_filled_valid <= in_valid_d[4] ? non_holes_cnt_filled_d[2] : '0;
      non_holes_cnt_filled_d <= {non_holes_cnt_filled_d[1], non_holes_cnt_filled};
    end
  end

  // Concatenate input data to create output data
  always_ff @(posedge clk) begin
    if(reset) begin
      non_holes_cnt <= '0;
      out_valid <= 1'b0;
      data_stored <= 'X;
    end else begin
      non_holes_cnt <= non_holes_cnt_comb;
      out_valid <= non_holes_cnt_comb >= NUM_WORDS;
      data_stored <= data_stored_shift_in;
    end
  end

  // Number of words after shifting out
  assign non_holes_cnt_comb_shift_out = non_holes_cnt - (out_valid ? NUM_WORDS : '0);
  // Number of words after shifting out and in
  assign non_holes_cnt_comb = non_holes_cnt + non_holes_cnt_filled_valid - (out_valid ? NUM_WORDS : '0);
  // Data after shifting out
  assign data_stored_shift_out = out_valid ? {{(NUM_WORDS*WORD_LENGTH){1'bX}}, data_stored[(NUM_WORDS*WORD_LENGTH)+:(NUM_WORDS*2*WORD_LENGTH)]} : data_stored;
  // Padded to ensure length is enough for data_stored_shift_in
  assign data_filled_padded = {{(NUM_WORDS*2*WORD_LENGTH){1'bX}}, data_filled_d};
  // Data after shifting out and in
  for(jj = 0; jj < NUM_WORDS*3; jj=jj+1) begin : data_stored_shift_in_gen
    assign data_stored_shift_in[jj*WORD_LENGTH+:WORD_LENGTH] = jj < non_holes_cnt_comb_shift_out ? data_stored_shift_out[jj*WORD_LENGTH+:WORD_LENGTH] : data_filled_d[(jj-non_holes_cnt_comb_shift_out)*WORD_LENGTH+:WORD_LENGTH];
  end
  // Output data
  assign out_data = data_stored[(WORD_LENGTH*NUM_WORDS)-1:0];

endmodule

`default_nettype wire
