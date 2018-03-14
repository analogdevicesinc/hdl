// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1 ns / 1 ns

module cic_decim (
  input clk,
  input clk_enable,
  input [4:0] filter_enable,
  input reset,
  input [11:0] filter_in,
  input [2:0] rate_sel,
  output [11:0] filter_out,
  output ce_out
  );

  localparam NUM_STAGES = 6;
  localparam DATA_WIDTH = 106;

  reg [11:0] filter_input_stage = 'h00;
  wire signed [DATA_WIDTH-1:0] data_stage[0:NUM_STAGES*2];
  wire signed [DATA_WIDTH-1:0] data_final_stage;

  reg [16:0] counter = 'h00;
  reg ce_comb = 1'b0;

  reg ce_out_reg = 1'b0;
  reg [11:0] data_out = 'h00;

  reg [15:0] rate;

  wire [4:0] enable = (clk_enable == 1'b1) ? filter_enable : 5'b0;

  always @(*) begin
    case (rate_sel)
    3'h1: rate <= 16'd5 - 1;
    3'h2: rate <= 16'd50 - 1;
    3'h3: rate <= 16'd500 - 1;
    3'h6: rate <= 16'd5000 - 1;
    default: rate <= 16'd50000 - 1;
    endcase
  end

  wire [15:0] counter_in = counter[16] == 1'b1 ? rate : counter[15:0];

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      counter <= {1'b1,16'h00};
    end else if (clk_enable == 1'b1 && enable[0] == 1'b1) begin
      counter <= counter_in - 1'b1;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      ce_comb <= 1'b0;
    end else begin
      ce_comb <= enable[0] & counter[16];
    end
  end

  always @(posedge clk) begin
    if (enable[0] == 1'b1) begin
      filter_input_stage <= filter_in;
    end
  end

  assign data_stage[0] = $signed(filter_input_stage);

  generate
    genvar i;
    for (i = 0; i < NUM_STAGES; i = i + 1) begin
      cic_int #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_STAGES(5),
        .STAGE_WIDTH(20)
      ) i_int (
        .clk(clk),
        .ce(enable),
        .data_in(data_stage[i]),
        .data_out(data_stage[i+1])
      );
    end
  endgenerate

  cic_comb #(
    .DATA_WIDTH(DATA_WIDTH),
    .SEQ(5),
    .NUM_STAGES(5),
    .STAGE_WIDTH(20)
  ) i_comb0 (
    .clk(clk),
    .ce(ce_comb),
    .enable(filter_enable),
    .data_in(data_stage[6]),
    .data_out(data_stage[11])
  );

  cic_comb #(
    .DATA_WIDTH(DATA_WIDTH),
    .SEQ(1),
    .NUM_STAGES(5),
    .STAGE_WIDTH(20)
  ) i_comb1 (
    .clk(clk),
    .ce(ce_comb),
    .enable(filter_enable),
    .data_in(data_stage[11]),
    .data_out(data_stage[12])
  );

  assign data_final_stage = data_stage[2*NUM_STAGES];

  always @(posedge clk) begin
    if (ce_comb == 1'b1) begin
      case (rate_sel)
      'h1: data_out <= data_final_stage[25:14];
      'h2: data_out <= data_final_stage[45:34];
      'h3: data_out <= data_final_stage[65:54];
      'h6: data_out <= data_final_stage[85:74];
      default: data_out <= data_final_stage[105:94];
      endcase
    end
    ce_out_reg <= ce_comb;
  end

  assign ce_out = ce_out_reg;
  assign filter_out = data_out;

endmodule  // cic_decim
