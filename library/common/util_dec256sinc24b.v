// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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

module util_dec256sinc24b (

  input               clk,          /* used to clk filter */
  input               reset,        /* used to reset filter */
  input               data_in,      /* input data to be filtered */
  output reg [15:0]   data_out,     /* filtered output */
  output reg          data_en,
  input      [15:0]   dec_rate
);

  /* Data is read on positive clk edge */

  reg [36:0]  data_int = 37'h0;
  reg [36:0]  acc1 = 37'h0;
  reg [36:0]  acc2 = 37'h0;
  reg [36:0]  acc3 = 37'h0;
  reg [36:0]  acc3_d = 37'h0;
  reg [36:0]  diff1_d = 37'h0;
  reg [36:0]  diff2_d = 37'h0;
  reg [15:0]  word_count = 16'h0;
  reg         word_en = 1'b0;
  reg         enable = 1'b0;

  wire [36:0] acc1_s;
  wire [36:0] acc2_s;
  wire [36:0] acc3_s;
  wire [36:0] diff1_s;
  wire [36:0] diff2_s;
  wire [36:0] diff3_s;

  /* Perform the Sinc action */

  always @(data_in) begin
    if (data_in==0)
      data_int <= 37'd0;
    else /* change 0 to a -1 for twos complement */
      data_int <= 37'd1;
  end

  /* Accumulator (Integrator) Perform the accumulation (IIR) at the speed of
   * the modulator. Z = one sample delay MCLKOUT = modulators conversion
   * bit rate */

  always @(negedge clk) begin
    if (reset == 1'b1) begin
      /* initialize acc registers on reset */
      acc1 <= 37'd0;
      acc2 <= 37'd0;
      acc3 <= 37'd0;
    end else begin
      /* perform accumulation process */
      acc1 <= acc1_s;
      acc2 <= acc2_s;
      acc3 <= acc3_s;
    end
  end
  assign acc1_s = acc1 + data_int;
  assign acc2_s = acc2 + acc1;
  assign acc3_s = acc3 + acc2;

  /* decimation stage (MCLKOUT/WORD_CLK) */

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      word_count <= 16'd0;
    end else begin
      if (word_count == (dec_rate - 1))
        word_count <= 16'd0;
      else
        word_count <= word_count + 16'b1;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      word_en <= 1'b0;
    end else begin
      if (word_count == (dec_rate/2 - 1))
        word_en <= 1'b1;
      else
        word_en <= 1'b0;
    end
  end

  /* Differentiator (including decimation stage)
   * Perform the differentiation stage (FIR) at a lower speed.
   * Z = one sample delay WORD_EN = output word rate */

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      diff1_d <= 37'd0;
      diff2_d <= 37'd0;
      acc3_d <= 37'b0;
    end else if (word_en == 1'b1) begin
      acc3_d <= acc3;
      diff1_d <= diff1_s;
      diff2_d <= diff2_s;
    end
  end
  assign diff1_s = acc3_s - acc3;
  assign diff2_s = diff1_s - diff1_d;
  assign diff3_s = diff2_s - diff2_d;

  /* Clock the Sinc output into an output register
   * WORD_EN = output word rate */

  always @(posedge clk) begin
    if (word_en == 1'b1) begin
      case (dec_rate)

        16'd32: begin
          data_out <= (diff3_s[15:0] == 16'h8000) ? 16'hFFFF : {diff3_s[14:0], 1'b0};
        end

        16'd64: begin
          data_out <= (diff3_s[18:2] == 17'h10000) ? 16'hFFFF : diff3_s[17:2];
        end

        16'd128: begin
          data_out <= (diff3_s[21:5] == 17'h10000) ? 16'hFFFF : diff3_s[20:5];
        end

        16'd256: begin
          data_out <= (diff3_s[24:8] == 17'h10000) ? 16'hFFFF : diff3_s[23:8];
        end

        16'd512: begin
          data_out <= (diff3_s[27:11] == 17'h10000) ? 16'hFFFF : diff3_s[26:11];
        end

        16'd1024: begin
          data_out <= (diff3_s[30:14] == 17'h10000) ? 16'hFFFF : diff3_s[29:14];
        end

        16'd2048: begin
          data_out <= (diff3_s[33:17] == 17'h10000) ? 16'hFFFF : diff3_s[32:17];
        end

        16'd4096: begin
          data_out <= (diff3_s[36:20] == 17'h10000) ? 16'hFFFF : diff3_s[35:20];
        end

        default:begin
          data_out <= (diff3_s[24:8] == 17'h10000) ? 16'hFFFF : diff3_s[23:8];
        end
      endcase
    end
  end

  /* Synchronize Data Output */

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_en <= 1'b0;
      enable <= 1'b1;
    end else begin
      if ((word_count == (dec_rate/2 - 1)) && (enable == 1'b1)) begin
        data_en <= 1'b1;
        enable <= 1'b0;
      end else if ((word_count == (dec_rate - 1)) && (enable == 1'b0)) begin
        data_en <= 1'b0;
        enable <= 1'b1;
      end else
        data_en <= 1'b0;
    end
  end

endmodule
