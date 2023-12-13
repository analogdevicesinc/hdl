// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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

module cic_comb #(
  parameter DATA_WIDTH = 32,
  parameter SEQ = 1,
  parameter STAGE_WIDTH = 1,
  parameter NUM_STAGES = 1
) (
  input clk,
  input ce,
  input [NUM_STAGES-1:0] enable,
  input [DATA_WIDTH-1:0] data_in,
  output [DATA_WIDTH-1:0] data_out
);

  reg [SEQ-1:0] storage[0:DATA_WIDTH-1];
  reg [DATA_WIDTH-1:0] state = 'h00;

  reg [2:0] counter = 'h00;
  reg active = 1'b0;

  integer x;

  initial begin
    for (x = 0; x < DATA_WIDTH; x = x + 1) begin
      storage[x] = 'h00;
    end
  end

  generate if (SEQ != 1) begin

  always @(posedge clk) begin
    if (ce == 1'b1) begin
      counter <= SEQ-1;
      active <= 1'b1;
    end else if (active == 1'b1) begin
      counter <= counter - 1'b1;
      if (counter == 'h1) begin
        active <= 1'b0;
      end
    end
  end

  end
  endgenerate

  wire [DATA_WIDTH-1:0] mask;
  reg [DATA_WIDTH-1:0] data_in_seq;
  wire [DATA_WIDTH-1:0] storage_out;
  wire [DATA_WIDTH-1:0] diff = (data_in_seq | ~mask) - (storage_out & mask);

  always @(*) begin
    if (ce == 1'b1) begin
      data_in_seq <= data_in;
    end else begin
      data_in_seq <= SEQ != 1 ? state : 'h00;
    end
  end

  generate
  genvar i, j;

  for (j = 0; j < NUM_STAGES; j = j + 1) begin
    localparam k = NUM_STAGES - j - 1;
    localparam H = DATA_WIDTH - STAGE_WIDTH * j - 1;
    localparam L = k == 0 ? 0 : DATA_WIDTH - STAGE_WIDTH * (j+1);

    assign mask[H:L] = {{H-L{1'b1}},k != 0 ? enable[k] : 1'b1};

    for (i = L; i <= H; i = i + 1) begin: shift_r
      always @(posedge clk) begin
        if (enable[k] == 1'b1 && (ce == 1'b1 || active == 1'b1)) begin
          if (SEQ > 1) begin
            storage[i] <= {storage[i][SEQ-2:0],data_in_seq[i]};
          end else begin
            storage[i] <= data_in_seq[i];
          end
        end
      end

      assign storage_out[i] = storage[i][SEQ-1];

    end

    always @(posedge clk) begin
      if (enable[k] == 1'b1 && (ce == 1'b1 || active == 1'b1)) begin
        state[H:L] <= diff[H:L];
      end
    end
  end

  endgenerate

  assign data_out = state;

endmodule
