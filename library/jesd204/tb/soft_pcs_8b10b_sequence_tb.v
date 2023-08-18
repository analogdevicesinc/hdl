// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module soft_pcs_8b10b_sequence_tb;
  parameter VCD_FILE = "soft_pcs_8b10b_sequence_tb.vcd";

  `include "tb_base.v"

  // Send a random sequence of characters to the decoder and make sure the
  // decoder produces the same character sequence and no disparity or
  // not-in-table errors

  wire [9:0] raw_data;

  reg [7:0] encoder_char = 'h00;
  reg encoder_charisk = 1'b0;

  wire [7:0] decoder_char;
  wire decoder_charisk;
  wire decoder_notintable;
  wire decoder_disperr;

  reg encoder_disparity = 1'b0;
  wire encoder_disparity_s;
  reg decoder_disparity = 1'b0;
  wire decoder_disparity_s;

  integer x;

  reg inject_enc_disparity_error = 1'b0;

/*
  always @(posedge clk) begin
    if ({$random} % 256 == 0) begin
      inject_enc_disparity_error <= 1'b1;
    end else begin
      inject_enc_disparity_error <= 1'b0;
    end
  end
*/

  always @(posedge clk) begin
    x = {$random} % (256 + 5);
    if (x < 256) begin
      encoder_char <= x & 8'hff;
      encoder_charisk <= 1'b0;
    end else begin
      case (x - 256)
      0: encoder_char <= {3'd0,5'd28};
      1: encoder_char <= {3'd3,5'd28};
      2: encoder_char <= {3'd4,5'd28};
      3: encoder_char <= {3'd5,5'd28};
      4: encoder_char <= {3'd7,5'd28};
      endcase
      encoder_charisk <= 1'b1;
    end
    encoder_disparity <= encoder_disparity_s ^ inject_enc_disparity_error;
    decoder_disparity <= decoder_disparity_s;
  end

  jesd204_8b10b_encoder i_enc (
    .in_char(encoder_char),
    .in_charisk(encoder_charisk),
    .out_char(raw_data),

    .in_disparity(encoder_disparity),
    .out_disparity(encoder_disparity_s));

  jesd204_8b10b_decoder i_dec (
    .in_char(raw_data),
    .out_char(decoder_char),
    .out_notintable(decoder_notintable),
    .out_disperr(decoder_disperr),
    .out_charisk(decoder_charisk),

    .in_disparity(decoder_disparity),
    .out_disparity(decoder_disparity_s));

   wire char_mismatch = encoder_char != decoder_char;
   wire charisk_mismatch = encoder_charisk != decoder_charisk;

   always @(posedge clk) begin
     if (char_mismatch == 1'b1 || charisk_mismatch == 1'b1 ||
         decoder_notintable == 1'b1 || decoder_disperr == 1'b1) begin
       failed <= 1'b1;
     end
   end

endmodule
