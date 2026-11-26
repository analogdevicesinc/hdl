// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MODE="1x100G": 384b = 6x64b words. MODE="1x40G": 256b = 4x64b words.
 * MODE="4x25G": 64b = 1 word. Each word carries an 11b tkeep_user field:
 * [7:0] byte keep (meaningful at tlast), [8] ERR (packet-level, word 0 only),
 * [10:9] TSN preempt/resume.
 */

`timescale 1ns/100ps

module mrmac_tx_adapt #(
  parameter MODE = "1x100G",
  parameter SEG_COUNT = (MODE == "4x25G") ? 1 : (MODE == "1x40G") ? 4 : 6,
  parameter SEG_WIDTH = 64,
  parameter SEG_BYTES = SEG_WIDTH/8,
  parameter KUSER_WIDTH = 11,
  parameter DATA_WIDTH = SEG_COUNT*SEG_WIDTH,
  parameter KEEP_WIDTH = DATA_WIDTH/8,
  parameter USER_WIDTH = 1                           // s_axis_tuser[0] = error
) (
  input  wire [DATA_WIDTH-1:0]            s_axis_tdata,
  input  wire [KEEP_WIDTH-1:0]            s_axis_tkeep,
  input  wire                             s_axis_tvalid,
  output wire                             s_axis_tready,
  input  wire                             s_axis_tlast,
  input  wire [USER_WIDTH-1:0]            s_axis_tuser,

  output wire [SEG_COUNT*SEG_WIDTH-1:0]   tx_axis_tdata,       // word 0 in the low bits
  output wire [SEG_COUNT*KUSER_WIDTH-1:0] tx_axis_tkeep_user,
  output wire                             tx_axis_tvalid,
  input  wire                             tx_axis_tready,
  output wire                             tx_axis_tlast
);

  initial begin
    if (MODE != "1x100G" && MODE != "4x25G" && MODE != "1x40G") begin
      $error("Error: MODE must be \"1x100G\", \"4x25G\" or \"1x40G\" (instance %m)");
      $finish;
    end
  end

  assign tx_axis_tdata = s_axis_tdata;

  genvar s;
  generate
    for (s = 0; s < SEG_COUNT; s = s + 1) begin : g_kuser
      wire [SEG_BYTES-1:0] word_keep = s_axis_tkeep[s*SEG_BYTES +: SEG_BYTES];
      if (s == 0) begin : g_word0
        assign tx_axis_tkeep_user[s*KUSER_WIDTH +: KUSER_WIDTH] =
            { {(KUSER_WIDTH-9){1'b0}},                 // [10:9] preempt/resume = 0
              (s_axis_tlast & s_axis_tuser[0]),        // [8] ERR
              word_keep };                             // [7:0] keep
      end else begin : g_wordn
        assign tx_axis_tkeep_user[s*KUSER_WIDTH +: KUSER_WIDTH] =
            { {(KUSER_WIDTH-8){1'b0}},                 // [10:8] = 0
              word_keep };                             // [7:0] keep
      end
    end
  endgenerate

  assign tx_axis_tvalid = s_axis_tvalid;
  assign tx_axis_tlast  = s_axis_tlast;
  assign s_axis_tready  = tx_axis_tready;

endmodule
