// ***************************************************************************
// ***************************************************************************
// Copyright 2017(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1 ns / 1 ns

module cic_decim (
  input clk,
  input clk_enable,
  input reset,
  input [11:0] filter_in,
  input [2:0] rate_sel,
  output [105:0] filter_out,
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
  reg [105:0] data_out = 'h00;

  reg [15:0] rate;

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
    end else if (clk_enable == 1'b1) begin
      counter <= counter_in - 1'b1;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      ce_comb <= 1'b0;
    end else begin
      ce_comb <= clk_enable & counter[16];
    end
  end

  always @(posedge clk) begin
    if (clk_enable == 1'b1) begin
      filter_input_stage <= filter_in;
    end
  end

  assign data_stage[0] = $signed(filter_input_stage);

  generate
    genvar i;
    for (i = 0; i < NUM_STAGES; i = i + 1) begin
      cic_int #(
        .DATA_WIDTH(DATA_WIDTH)
      ) i_int (
        .clk(clk),
        .ce(clk_enable),
        .data_in(data_stage[i]),
        .data_out(data_stage[i+1])
      );
    end
  endgenerate

  cic_comb #(
    .DATA_WIDTH(DATA_WIDTH),
    .SEQ(5)
  ) i_comb0 (
    .clk(clk),
    .ce(ce_comb),
    .data_in(data_stage[6]),
    .data_out(data_stage[11])
  );

  cic_comb #(
    .DATA_WIDTH(DATA_WIDTH),
    .SEQ(1)
  ) i_comb1 (
    .clk(clk),
    .ce(ce_comb),
    .data_in(data_stage[11]),
    .data_out(data_stage[12])
  );

  assign data_final_stage = data_stage[2*NUM_STAGES];

  always @(posedge clk) begin
    if (ce_comb == 1'b1) begin
      case (rate_sel)
      'h1: data_out <= {{14{data_final_stage[105]}},data_final_stage[105:14]};
      'h2: data_out <= {{34{data_final_stage[105]}},data_final_stage[105:34]};
      'h3: data_out <= {{54{data_final_stage[105]}},data_final_stage[105:54]};
      'h6: data_out <= {{74{data_final_stage[105]}},data_final_stage[105:74]};
      default: data_out <= {{94{data_final_stage[105]}},data_final_stage[105:94]};
      endcase
    end
    ce_out_reg <= ce_comb;
  end

  assign ce_out = ce_out_reg;
  assign filter_out = data_out;

endmodule  // cic_decim
