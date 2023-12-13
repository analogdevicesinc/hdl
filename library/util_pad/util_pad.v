// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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
