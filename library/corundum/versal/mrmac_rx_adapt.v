// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MRMAC RX adapter (non-segmented mode) — parameterized by MODE:
 *   MODE="1x100G": one 100GE port, 384-bit = 6x64-bit words (SEG_COUNT=6).
 *                  Downstream axis_adapter width-converts 384 -> 512.
 *   MODE="4x25G":  one 25GE port, 64-bit = 1x64-bit word (SEG_COUNT=1).
 *                  Instantiate once PER 25G port (x4). At 64-bit this matches a
 *                  64-bit Corundum datapath directly (no width conversion needed).
 * The logic below is identical for both modes; it iterates over SEG_COUNT words.
 * MRMAC uses the same non-segmented per-word tkeep_user[10:0] encoding in each.
 *
 * Translates the AMD Versal MRMAC *non-segmented* receive user interface into a
 * single flat AXI4-Stream bus.
 *
 * MRMAC non-segmented RX interface (PG314), per word:
 *   - rx_axis_tdata[SEG_COUNT words] : SEG_COUNT words of SEG_WIDTH bits (word 0 first on wire)
 *   - rx_axis_tkeep_user[SEG_COUNT]  : SEG_COUNT * 11 bits. Per PG314 non-segmented encoding:
 *        [7:0]  tkeep  - per-byte valid for that word (contiguous, meaningful at tlast)
 *        [8]    ERR    - packet error / discard (packet-level, carried on WORD 0 only)
 *        [9]    Preempt- TSN (unused here)
 *        [10]   Resume - TSN (unused here)
 *   - rx_axis_tvalid : beat valid
 *   - rx_axis_tlast  : last beat of the packet (only beat allowed to be partial)
 *
 * MRMAC RX cannot be back-pressured, so this module is a pure combinational
 * relabeler with NO tready. Downstream elasticity/CDC is provided by a FIFO
 * (added at the wrapper level), which must accept every valid beat.
 *
 * Flat output AXI4-Stream (valid-only, must be consumed):
 *   - m_axis_tdata  [DATA_WIDTH-1:0]   = {tdata5,...,tdata0}   (word 0 in low bytes)
 *   - m_axis_tkeep  [KEEP_WIDTH-1:0]   = per-byte keep; full on non-last beats
 *   - m_axis_tvalid
 *   - m_axis_tlast
 *   - m_axis_tuser                     = ERR (bad-frame), from word-0 tkeep_user[8]
 */

`timescale 1ns/100ps

module mrmac_rx_adapt #(
  // MODE selects the MRMAC per-port datapath geometry:
  //   "1x100G" -> one 100GE port, 384-bit = 6x64-bit words (SEG_COUNT=6)
  //   "4x25G"  -> one 25GE port,   64-bit = 1x64-bit word  (SEG_COUNT=1)
  // For 4x25G, instantiate this adapter once PER 25G port (4 instances).
  // The datapath logic is identical for both — only SEG_COUNT differs — because
  // MRMAC uses the same non-segmented per-word tkeep_user[10:0] encoding in each.
  parameter MODE = "1x100G",
  // SEG_COUNT defaults from MODE; leave as-is (do not override) so MODE is the
  // single source of truth. 6 for 1x100G, 1 for one 4x25G port.
  parameter SEG_COUNT = (MODE == "4x25G") ? 1 : 6,
  parameter SEG_WIDTH = 64,                          // 64-bit MRMAC word (both modes)
  parameter SEG_BYTES = SEG_WIDTH/8,                 // 8
  parameter KUSER_WIDTH = 11,                        // MRMAC tkeep_user width (both modes)
  parameter DATA_WIDTH = SEG_COUNT*SEG_WIDTH,        // 384 (100G) or 64 (25G)
  parameter KEEP_WIDTH = DATA_WIDTH/8                // 48  (100G) or 8  (25G)
) (
  /*
   * MRMAC non-segmented RX interface (valid-only)
   */
  input  wire [SEG_COUNT*SEG_WIDTH-1:0]   rx_axis_tdata,       // packed {word5..word0}
  input  wire [SEG_COUNT*KUSER_WIDTH-1:0] rx_axis_tkeep_user,  // packed {ku5..ku0}
  input  wire                             rx_axis_tvalid,
  input  wire                             rx_axis_tlast,

  /*
   * Flat AXI4-Stream output (valid-only, no back-pressure)
   */
  output wire [DATA_WIDTH-1:0]            m_axis_tdata,
  output wire [KEEP_WIDTH-1:0]            m_axis_tkeep,
  output wire                             m_axis_tvalid,
  output wire                             m_axis_tlast,
  output wire                             m_axis_tuser
);

  // check configuration
  initial begin
    if (MODE != "1x100G" && MODE != "4x25G") begin
      $error("Error: MODE must be \"1x100G\" or \"4x25G\" (instance %m)");
      $finish;
    end
  end

  // data words map straight through: word 0 occupies the low bytes
  assign m_axis_tdata = rx_axis_tdata;

  // build the flat byte-keep from each word's tkeep_user[7:0].
  // On non-last beats every byte is valid (standard AXIS mid-packet rule);
  // only the last beat carries a partial keep pattern from MRMAC.
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

  // packet-level ERR lives on word 0's tkeep_user[8]
  assign m_axis_tuser  = rx_axis_tkeep_user[8];

endmodule
