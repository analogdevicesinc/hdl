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

module util_pad #(
  parameter NUM_OF_SAMPLES = 2,
  parameter IN_BITS_PER_SAMPLE = 16,
  parameter OUT_BITS_PER_SAMPLE = 16,
  parameter PADDING_TO_MSB_LSB_N = 0,
  parameter SIGN_EXTEND = 1
) (
  input [NUM_OF_SAMPLES*IN_BITS_PER_SAMPLE-1:0] data_in,
  output reg [NUM_OF_SAMPLES*OUT_BITS_PER_SAMPLE-1:0] data_out
);

  // Remove padding
  if (IN_BITS_PER_SAMPLE >= OUT_BITS_PER_SAMPLE) begin
    integer i;
    always @(*) begin
      for (i=0;i<NUM_OF_SAMPLES;i=i+1) begin
        if (PADDING_TO_MSB_LSB_N==1) begin
          data_out[i*OUT_BITS_PER_SAMPLE +: OUT_BITS_PER_SAMPLE] =
            data_in[i*IN_BITS_PER_SAMPLE +: OUT_BITS_PER_SAMPLE];
        end else begin
          data_out[i*OUT_BITS_PER_SAMPLE +: OUT_BITS_PER_SAMPLE] =
            data_in[((i+1)*IN_BITS_PER_SAMPLE)-1 -: OUT_BITS_PER_SAMPLE];
        end
      end
    end
  end

  // Add padding
  if (IN_BITS_PER_SAMPLE < OUT_BITS_PER_SAMPLE) begin
    integer i;
    always @(*) begin
      for (i=0;i<NUM_OF_SAMPLES;i=i+1) begin
        if (PADDING_TO_MSB_LSB_N==1) begin
          data_out[i*OUT_BITS_PER_SAMPLE +: OUT_BITS_PER_SAMPLE] =
            {{OUT_BITS_PER_SAMPLE-IN_BITS_PER_SAMPLE{data_in[(i+1)*IN_BITS_PER_SAMPLE-1]&SIGN_EXTEND[0]}},
            data_in[i*IN_BITS_PER_SAMPLE +: OUT_BITS_PER_SAMPLE]};
        end else begin
          data_out[i*OUT_BITS_PER_SAMPLE +: OUT_BITS_PER_SAMPLE] =
            {data_in[((i+1)*IN_BITS_PER_SAMPLE)-1 -: OUT_BITS_PER_SAMPLE],
            {OUT_BITS_PER_SAMPLE-IN_BITS_PER_SAMPLE{1'b0}}};
        end
      end
    end
  end

endmodule
