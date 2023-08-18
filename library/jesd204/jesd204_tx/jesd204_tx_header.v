// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_tx_header (
  input clk,
  input reset,

  input [1:0]  cfg_header_mode,

  input        lmc_edge,
  input        lmc_quarter_edge,

  // Header content to be sent must be valid during lmc_edge
  input        eoemb,
  input [2:0]  crc3,
  input [11:0] crc12,
  input [25:0] fec,
  input [18:0] cmd,

  output [1:0] header
);

  reg header_bit;
  reg [31:0] sync_word = 'h0;

  always @(posedge clk) begin
    if (reset) begin
      sync_word <= 'h0;
    end else if (lmc_edge) begin
      case (cfg_header_mode)
        // CRC-12
        2'b00 : sync_word <= {crc12[11:9],1'b1,crc12[8:6],1'b1,
                               crc12[5:3],1'b1,crc12[2:0],1'b1,
                                 cmd[6:4],1'b1,cmd[3],1'b1,eoemb,1'b1,
                                 cmd[2:0],5'b00001};
        // CRC-3
        2'b01 : sync_word <= {  crc3[2:0],1'b1,cmd[6:4],1'b1,
                                   3'b000,1'b1,cmd[3:1],1'b1,
                                   3'b000,1'b1,cmd[0],1'b1,eoemb,1'b1,
                                   3'b000,5'b00001};
        // FEC
        2'b10 : sync_word <= { fec[25:18],
                               fec[17:10],
                                 fec[9:4],eoemb,fec[3],
                                 fec[2:0],5'b00001};
        // Stand alone command
        2'b11 : sync_word <= { cmd[18:16],1'b1,cmd[15:13],1'b1,
                               cmd[12:10],1'b1,cmd[9:7],1'b1,
                                 cmd[6:4],1'b1,cmd[3],1'b1,eoemb,1'b1,
                                 cmd[2:0],5'b00001};
      endcase
    end else begin
      if (lmc_quarter_edge && cfg_header_mode == 2'b01) begin
        sync_word <= {crc3[2],crc3[1],crc3[0],sync_word[27:0],1'b0};
      end else begin
        sync_word <= {sync_word[30:0],1'b0};
      end
    end
  end

  assign header = {~sync_word[31],sync_word[31]};

endmodule
