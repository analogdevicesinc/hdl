// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_ilas_cfg_static #(
  parameter DID = 8'h00,
  parameter BID = 4'h0,
  parameter L = 5'h3,
  parameter SCR = 1'b1,
  parameter F = 8'h01,
  parameter K = 5'h1f,
  parameter M = 8'h3,
  parameter N = 5'h0f,
  parameter CS = 2'h0,
  parameter NP = 5'h0f,
  parameter SUBCLASSV = 3'h1,
  parameter S = 5'h00,
  parameter JESDV = 3'h1,
  parameter CF = 5'h00,
  parameter HD = 1'b1,
  parameter NUM_LANES = 1,
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,

  input [1:0] ilas_config_addr,
  input ilas_config_rd,
  output reg [NUM_LANES*DATA_PATH_WIDTH*8-1:0] ilas_config_data
);

  wire [31:0] ilas_mem[0:3];
  reg  [31:0] ilas_lane_mem[0:NUM_LANES-1][0:3];

  assign ilas_mem[0][15:0] = 8'h00;
  assign ilas_mem[0][23:16] = DID;         // DID
  assign ilas_mem[0][27:24] = BID;         // BID
  assign ilas_mem[0][31:28] = 4'h0;        // ADJCNT
  assign ilas_mem[1][4:0] = 5'h00;         // LID
  assign ilas_mem[1][5] = 1'b0;            // PHADJ
  assign ilas_mem[1][6] = 1'b0;            // ADJDIR
  assign ilas_mem[1][7] = 1'b0;            // X
  assign ilas_mem[1][12:8] = L;            // L
  assign ilas_mem[1][14:13] = 2'b00;       // X
  assign ilas_mem[1][15] = SCR;            // SCR
  assign ilas_mem[1][23:16] = F;           // F
  assign ilas_mem[1][28:24] = K;           // K
  assign ilas_mem[1][31:29] = 3'b000;      // X
  assign ilas_mem[2][7:0] = M;             // M
  assign ilas_mem[2][12:8] = N;            // N
  assign ilas_mem[2][13] = 1'b0;           // X
  assign ilas_mem[2][15:14] = CS;          // CS
  assign ilas_mem[2][20:16] = NP;          // N'
  assign ilas_mem[2][23:21] = SUBCLASSV;   // SUBCLASSV
  assign ilas_mem[2][28:24] = S;           // S
  assign ilas_mem[2][31:29] = JESDV;       // JESDV
  assign ilas_mem[3][4:0] = CF;            // CF
  assign ilas_mem[3][6:5] = 2'b00;         // X
  assign ilas_mem[3][7] = HD;              // HD
  assign ilas_mem[3][23:8] = 16'h0000;     // X
  assign ilas_mem[3][31:24] = ilas_mem[0][23:16] + ilas_mem[0][31:24] +
    ilas_mem[1][4:0] + ilas_mem[1][5] + ilas_mem[1][6] + ilas_mem[1][12:8] +
    ilas_mem[1][15] + ilas_mem[1][23:16] + ilas_mem[1][28:24] +
    ilas_mem[2][7:0] + ilas_mem[2][12:8] + ilas_mem[2][15:14] +
    ilas_mem[2][20:16] + ilas_mem[2][23:21] + ilas_mem[2][28:24] +
    ilas_mem[2][31:29] + ilas_mem[3][4:0] + ilas_mem[3][7];

  generate
  genvar i;
  genvar j;

  for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane
    for(j = 0; j < 4; j = j + 1) begin : gen_word
      always @(*) begin
        ilas_lane_mem[i][j] = ilas_mem[j];
        case(j)
          1: ilas_lane_mem[i][j][4:0] = i;
          3: ilas_lane_mem[i][j][31:24] = ilas_mem[3][31:24] + i;
        endcase
      end
    end

    always @(posedge clk) begin
      if (ilas_config_rd == 1'b1) begin
        if(DATA_PATH_WIDTH == 4) begin
          ilas_config_data[i*32+31:i*32] <= ilas_lane_mem[i][ilas_config_addr];
        end else begin
          ilas_config_data[i*64+63:i*64] <= {ilas_lane_mem[i][{ilas_config_addr[0], 1'b1}], ilas_lane_mem[i][{ilas_config_addr[0], 1'b0}]};
        end
      end
    end
  end
  endgenerate

endmodule
