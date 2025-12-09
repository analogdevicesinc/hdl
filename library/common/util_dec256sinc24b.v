// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
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
  input             clk,      /* used to clk filter */
  input             reset,    /* used to reset filter */
  input             data_in,  /* input data to be filtered */
  output reg [15:0] data_out, /* filtered output */
  output reg        data_en,
  input      [15:0] dec_rate
);

  /* Data is read on positive clk edge */
  reg [36:0] ip_data1;
  reg [36:0] acc1;
  reg [36:0] acc2;
  reg [36:0] acc3;
  reg [36:0] acc3_d2;
  reg [36:0] diff1;
  reg [36:0] diff2;
  reg [36:0] diff3;
  reg [36:0] diff1_d;
  reg [36:0] diff2_d;
  reg [15:0] word_count;
  reg        word_clk;
  reg        enable;
  reg        word_clk_d;

  wire        word_rst;
  wire [36:0] acc3_s;
  wire [36:0] diff3_s;

  /*Perform the Sinc action*/
  always @ (data_in) begin
    if(data_in == 0) begin
      ip_data1 <= 37'd0;
  /* change 0 to a -1 for twos complement*/
    end else begin
      ip_data1 <= 37'd1;
    end
  end

  /*Accumulator (Integrator)
  Perform the accumulation (IIR) at the speed of the modulator.
  Z = one sample delay MCLKOUT = modulators conversion bit rate */

  always @ (negedge clk) begin
    if (reset) begin
      /* initialize acc registers on reset */
      acc1 <= 37'd0;
      acc2 <= 37'd0;
      acc3 <= 37'd0;
    end else begin
      /*perform accumulation process */
      acc1 <= acc1 + ip_data1;
      acc2 <= acc2 + acc1;
      acc3 <= acc3 + acc2;
    end
  end

  /*decimation stage (MCLKOUT/WORD_CLK) */
  always @ (posedge clk) begin
    if (reset) begin
      word_count <= 16'd0;
    end else begin
      if (word_count == dec_rate - 1) begin
        word_count <= 16'd0;
      end else begin
        word_count <= word_count + 16'b1;
      end
    end
  end

  always @ (posedge clk) begin
    if (reset) begin
      word_clk_d <= 1'b0;
    end else begin
      if (word_count == dec_rate/2 - 2) begin
        word_clk_d <= 1'b1;
      end else if (word_count == dec_rate - 2) begin
        word_clk_d <= 1'b0;
      end
    end
  end

  always @ (posedge clk) begin
    word_clk <= word_clk_d;
  end

  util_rst #(
    .ASYNC_STAGES(2),
    .SYNC_STAGES(2)
  ) i_cdc_async_stage_sync (
    .rst_async(reset),
    .clk(word_clk),
    .rstn(),
    .rst(word_rst));

  /*Differentiator (including decimation stage)
  Perform the differentiation stage (FIR) at a lower speed.
  Z = one sample delay WORD_CLK = output word rate */

  sync_bits #(
    .NUM_OF_BITS(37),
    .ASYNC_CLK(1),
    .SYNC_STAGES(2)
  ) i_acc3_sync (
    .out_clk(word_clk),
    .out_resetn(word_rst),
    .in_bits(acc3),
    .out_bits(acc3_s));

  always @ (posedge word_clk) begin
    if(word_rst) begin
      acc3_d2 <= 37'd0;
      diff1_d <= 37'd0;
      diff2_d <= 37'd0;
      diff1 <= 37'd0;
      diff2 <= 37'd0;
      diff3 <= 37'd0;
    end else begin
      diff1 <= acc3_s - acc3_d2;
      diff2 <= diff1 - diff1_d;
      diff3 <= diff2 - diff2_d;
      acc3_d2 <= acc3_s;
      diff1_d <= diff1;
      diff2_d <= diff2;
    end
  end

  /* Clock the Sinc output into an output register WORD_CLK = output word rate */

  sync_bits #(
    .NUM_OF_BITS(37),
    .ASYNC_CLK(1),
    .SYNC_STAGES(2)
  ) i_diff3_sync (
    .out_clk(clk),
    .out_resetn(reset),
    .in_bits(diff3),
    .out_bits(diff3_s));

  always @ (posedge clk) begin
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
      default: begin
        data_out <= (diff3_s[24:8] == 17'h10000) ? 16'hFFFF : diff3_s[23:8];
      end
    endcase
  end

  /* Synchronize Data Output*/
  always@ (posedge clk) begin
    if (reset) begin
      data_en <= 1'b0;
      enable <= 1'b1;
    end else begin
      if ((word_count == dec_rate/2 - 1) && enable) begin
        data_en <= 1'b1;
        enable <= 1'b0;
      end else if ((word_count == dec_rate - 1) && ~enable) begin
        data_en <= 1'b0;
        enable <= 1'b1;
      end else begin
        data_en <= 1'b0;
      end
    end
  end
endmodule
