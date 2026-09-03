// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MRMAC TX adapter (non-segmented mode) — parameterized by MODE:
 *   MODE="1x100G": one 100GE port, 384-bit = 6x64-bit words (SEG_COUNT=6). Fed by
 *                  an upstream axis_adapter that width-converts 512 -> 384.
 *   MODE="4x25G":  one 25GE port, 64-bit = 1x64-bit word (SEG_COUNT=1). Instantiate
 *                  once PER 25G port (x4); at 64-bit it takes a 64-bit AXIS directly.
 * Logic is identical for both modes; it iterates over SEG_COUNT words with the
 * same non-segmented per-word tkeep_user[10:0] encoding.
 *
 * Translates a single flat AXI4-Stream bus into the AMD Versal MRMAC
 * *non-segmented* transmit user interface (PG314).
 *
 * MRMAC non-segmented TX interface, per word:
 *   - tx_axis_tdata[SEG_COUNT words] : SEG_COUNT words of SEG_WIDTH bits (word 0 first)
 *   - tx_axis_tkeep_user[SEG_COUNT]  : SEG_COUNT * 11 bits, non-segmented encoding:
 *        [7:0]  tkeep  - per-byte valid for that word (meaningful at tlast)
 *        [8]    ERR    - packet error / bad-FCS (packet-level, on WORD 0, at tlast)
 *        [9]    Preempt- TSN (driven 0)
 *        [10]   Resume - TSN (driven 0)
 *   - tx_axis_tvalid : beat valid
 *   - tx_axis_tready : back-pressure to the user
 *   - tx_axis_tlast  : last beat of the packet (only beat allowed partial)
 *
 * Because the flat input and the MRMAC output are the same width (384) with the
 * same one-packet-per-tlast framing, this is a combinational relabeler that
 * passes tready straight back. Runt padding is done upstream (cmac_pad on the
 * 512-bit side). PTP 1588 op/tag generation is handled at wrapper integration,
 * not here, to keep this a pure datapath translator.
 */

`timescale 1ns/100ps

module mrmac_tx_adapt #(
  // MODE selects the MRMAC per-port datapath geometry:
  //   "1x100G" -> one 100GE port, 384-bit = 6x64-bit words (SEG_COUNT=6)
  //   "4x25G"  -> one 25GE port,   64-bit = 1x64-bit word  (SEG_COUNT=1)
  // For 4x25G, instantiate once PER 25G port (4 instances). Logic is identical
  // for both modes (same non-segmented per-word tkeep_user[10:0] encoding).
  parameter MODE = "1x100G",
  parameter SEG_COUNT = (MODE == "4x25G") ? 1 : 6,   // derived from MODE
  parameter SEG_WIDTH = 64,                          // 64-bit MRMAC word (both modes)
  parameter SEG_BYTES = SEG_WIDTH/8,                 // 8
  parameter KUSER_WIDTH = 11,                        // MRMAC tkeep_user width (both modes)
  parameter DATA_WIDTH = SEG_COUNT*SEG_WIDTH,        // 384 (100G) or 64 (25G)
  parameter KEEP_WIDTH = DATA_WIDTH/8,               // 48  (100G) or 8  (25G)
  parameter USER_WIDTH = 1                           // s_axis_tuser[0] = error
) (
  /*
   * Flat AXI4-Stream input (from width adapter)
   */
  input  wire [DATA_WIDTH-1:0]            s_axis_tdata,
  input  wire [KEEP_WIDTH-1:0]            s_axis_tkeep,
  input  wire                             s_axis_tvalid,
  output wire                             s_axis_tready,
  input  wire                             s_axis_tlast,
  input  wire [USER_WIDTH-1:0]            s_axis_tuser,

  /*
   * MRMAC non-segmented TX interface
   */
  output wire [SEG_COUNT*SEG_WIDTH-1:0]   tx_axis_tdata,       // packed {word5..word0}
  output wire [SEG_COUNT*KUSER_WIDTH-1:0] tx_axis_tkeep_user,  // packed {ku5..ku0}
  output wire                             tx_axis_tvalid,
  input  wire                             tx_axis_tready,
  output wire                             tx_axis_tlast
);

  // check configuration
  initial begin
    if (MODE != "1x100G" && MODE != "4x25G") begin
      $error("Error: MODE must be \"1x100G\" or \"4x25G\" (instance %m)");
      $finish;
    end
  end

  // data words map straight through: word 0 in the low bytes
  assign tx_axis_tdata = s_axis_tdata;

  // per-word tkeep_user. tkeep[7:0] carries the byte-keep (contiguous from the
  // upstream adapter; only meaningful to MRMAC on the last beat). ERR is carried
  // on word 0 bit 8, qualified by tlast. Preempt/Resume ([10:9]) are unused.
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

  // back-pressure passes straight through
  assign s_axis_tready  = tx_axis_tready;

endmodule
