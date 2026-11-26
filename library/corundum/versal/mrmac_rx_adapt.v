// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MODE="1x100G": 384b = 6x64b words. MODE="1x40G": 256b = 4x64b words.
 * MODE="4x25G": 64b = 1 word. Each word carries an 11b tkeep_user field:
 * [7:0] byte keep (meaningful at tlast), [8] ERR (packet-level, word 0 only),
 * [10:9] TSN preempt/resume. m_axis_tuser is ERR.
 */

`timescale 1ns/100ps

module mrmac_rx_adapt #(
  parameter MODE = "1x100G",
  parameter SEG_COUNT = (MODE == "4x25G") ? 1 : (MODE == "1x40G") ? 4 : 6,
  parameter SEG_WIDTH = 64,
  parameter SEG_BYTES = SEG_WIDTH/8,
  parameter KUSER_WIDTH = 11,
  parameter DATA_WIDTH = SEG_COUNT*SEG_WIDTH,
  parameter KEEP_WIDTH = DATA_WIDTH/8
) (
  input  wire [SEG_COUNT*SEG_WIDTH-1:0]   rx_axis_tdata,       // word 0 in the low bits
  input  wire [SEG_COUNT*KUSER_WIDTH-1:0] rx_axis_tkeep_user,
  input  wire                             rx_axis_tvalid,
  input  wire                             rx_axis_tlast,

  output wire [DATA_WIDTH-1:0]            m_axis_tdata,
  output wire [KEEP_WIDTH-1:0]            m_axis_tkeep,
  output wire                             m_axis_tvalid,
  output wire                             m_axis_tlast,
  output wire                             m_axis_tuser
);

  initial begin
    if (MODE != "1x100G" && MODE != "4x25G" && MODE != "1x40G") begin
      $error("Error: MODE must be \"1x100G\", \"4x25G\" or \"1x40G\" (instance %m)");
      $finish;
    end
  end

  assign m_axis_tdata = rx_axis_tdata;

  genvar s;
  generate
    for (s = 0; s < SEG_COUNT; s = s + 1) begin : g_keep
      assign m_axis_tkeep[s*SEG_BYTES +: SEG_BYTES] =
          rx_axis_tlast ? rx_axis_tkeep_user[s*KUSER_WIDTH +: SEG_BYTES]
                        : {SEG_BYTES{1'b1}};
    end
  endgenerate

  assign m_axis_tvalid = rx_axis_tvalid;
  assign m_axis_tlast  = rx_axis_tlast;
  assign m_axis_tuser  = rx_axis_tkeep_user[8];

endmodule
