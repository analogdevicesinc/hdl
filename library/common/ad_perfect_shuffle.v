// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms.
// The user should keep this in in mind while exploring these cores.
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_perfect_shuffle #(
  parameter NUM_GROUPS = 2,
  parameter WORDS_PER_GROUP = 2,
  parameter WORD_WIDTH = 8
) (
  input [NUM_GROUPS*WORDS_PER_GROUP*WORD_WIDTH-1:0] data_in,
  output [NUM_GROUPS*WORDS_PER_GROUP*WORD_WIDTH-1:0] data_out
);
 /*
  * Performs the perfect shuffle operation.
  *
  * The perfect shuffle splits the input vector into NUM_GROUPS groups and then
  * each group in WORDS_PER_GROUP. The output vector consists of WORDS_PER_GROUP
  * groups and each group has NUM_GROUPS words. The data is remapped, so that
  * the i-th word of the j-th word in the output vector is the j-th word of the
  * i-th group of the input vector.

  * The inverse operation of the perfect shuffle is the perfect shuffle with
  * both parameters swapped.
  * I.e. [perfect_suffle B A [perfect_shuffle A B data]] == data
  *
  * Examples:
  *   NUM_GROUPS = 2, WORDS_PER_GROUP = 4
  *     [A B C D a b c d] => [A a B b C c D d]
  *   NUM_GROUPS = 4, WORDS_PER_GROUP = 2
  *     [A a B b C c D d] => [A B C D a b c d]
  *   NUM_GROUPS = 3, WORDS_PER_GROUP = 2
  *     [A B a b 1 2] => [A a 1 B b 2]
  */
  generate
    genvar i;
    genvar j;
    for (i = 0; i < NUM_GROUPS; i = i + 1) begin: shuffle_outer
      for (j = 0; j < WORDS_PER_GROUP; j = j + 1) begin: shuffle_inner
        localparam src_lsb = (j + i * WORDS_PER_GROUP) * WORD_WIDTH;
        localparam dst_lsb = (i + j * NUM_GROUPS) * WORD_WIDTH;

        assign data_out[dst_lsb+:WORD_WIDTH] = data_in[src_lsb+:WORD_WIDTH];
      end
    end
  endgenerate

endmodule
