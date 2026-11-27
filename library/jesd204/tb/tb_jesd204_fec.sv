// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
// Short identifier: ADIJESD204
//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have by
// using this source code/core.
//
// The JESD204 HDL, is copyright (C) 2016-2026 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask questions
// about and improve this core. Distribution of source, or resulting binaries
// (including those inside an FPGA or ASIC) require you to release the source of
// the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary. If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License (e.g. they do
// not require you to accompany any image (FPGA or ASIC) using the JESD204 core
// with any corresponding source code). For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a license
// to use this core in a commercial setting without releasing their source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required to
// do so; it is up to your common sense to decide whether you want to comply with
// this request or not.) For general publications, we suggest referencing: "The
// design and implementation of the JESD204 HDL Core used in this project is
// copyright (C) 2016-2026, Analog Devices, Inc."
// ***************************************************************************
// ***************************************************************************

`timescale 1ns / 100ps
`default_nettype none

// jesd204_fec_encode -> jesd204_fec_decode with one error pattern per block:
// bursts of up to 9 bits in the data, in the parity or across both must be
// corrected and flagged as trapped; 10-17 bit bursts must be flagged.
// Bit positions follow the modules' convention: data_in[0] of the first word
// is codeword bit 0, parity bit fec[25] is codeword bit 2048.

module tb_jesd204_fec;
  localparam DATA_WIDTH = 64;
  localparam NUM_BLOCKS = 160;
  localparam NUM_CYCLES = 32*NUM_BLOCKS;
  localparam MAX_BURST_LEN = 9;

  localparam T_CLEAN = 0;
  localparam T_DATA = 1;
  localparam T_PARITY = 2;
  localparam T_STRADDLE = 3;
  localparam T_LONG = 4;

  parameter VCD_FILE = {"tb_jesd204_fec.vcd"};
  `define TIMEOUT 1000000
  `include "tb_base.v"

  logic                   rst = 1'b1;
  logic [4:0]             cnt = '0;
  logic                   eomb;
  logic [DATA_WIDTH-1:0]  data_in = '0;
  logic [DATA_WIDTH-1:0]  err_mask [NUM_CYCLES+64];
  logic [DATA_WIDTH-1:0]  clean [NUM_CYCLES+64];
  logic [25:0]            fec_err [NUM_BLOCKS+4];
  int                     blk_type [NUM_BLOCKS+4];
  logic [25:0]            fec;
  logic [25:0]            fec_saved;
  logic [27:1]            eomb_d = '0;
  int                     par_blk = -1;
  logic [DATA_WIDTH-1:0]  data_out;
  logic                   data_out_valid;
  logic                   trapped_error_flag;
  logic                   untrapped_error_flag;
  int                     cyc = 0;
  int                     nout = 0;
  int                     n_trapped = 0;
  int                     n_untrapped = 0;
  int                     n_mismatch = 0;
  int                     n_type [5] = '{default: 0};

  assign eomb = cnt == 31;

  task automatic set_bit(int blk, int pos);
    if (pos < 2048)
      err_mask[32*blk + pos/64][pos%64] ^= 1'b1;
    else
      fec_err[blk][25-(pos-2048)] ^= 1'b1;
  endtask

  task automatic set_burst(int blk, int pos, int len, bit rand_inner);
    for (int i = 0; i < len; i++)
      if (i == 0 || i == len-1 || (rand_inner && ($urandom & 1)))
        set_bit(blk, pos + i);
  endtask

  task automatic add_block(int blk, int t, int pos, int len);
    blk_type[blk] = t;
    n_type[t]++;
    if (t != T_CLEAN) set_burst(blk, pos, len, 1'b1);
  endtask

  initial begin
    int b;
    int len;
    for (int i = 0; i < NUM_CYCLES+64; i++) err_mask[i] = '0;
    for (int i = 0; i < NUM_BLOCKS+4; i++) begin fec_err[i] = '0; blk_type[i] = T_CLEAN; end

    // Directed: block edges, the loaded-syndrome position 0, parity, straddles
    b = 3;
    add_block(b++, T_DATA, 0, 1);
    add_block(b++, T_DATA, 0, 3);
    add_block(b++, T_DATA, 0, 9);
    add_block(b++, T_DATA, 1, 9);
    add_block(b++, T_DATA, 63, 2);
    add_block(b++, T_DATA, 64, 9);
    add_block(b++, T_DATA, 1984, 3);
    add_block(b++, T_DATA, 2039, 9);
    add_block(b++, T_PARITY, 2048, 1);
    add_block(b++, T_PARITY, 2048, 9);
    add_block(b++, T_PARITY, 2049, 5);
    add_block(b++, T_PARITY, 2061, 9);
    add_block(b++, T_PARITY, 2073, 1);
    add_block(b++, T_PARITY, 2065, 9);
    add_block(b++, T_STRADDLE, 2044, 9);
    add_block(b++, T_STRADDLE, 2047, 2);
    add_block(b++, T_LONG, 0, 17);
    add_block(b++, T_LONG, 1000, 10);
    add_block(b++, T_LONG, 2031, 17);

    // Random, leaving the last blocks clean so their flags are seen
    for (; b < NUM_BLOCKS-4; b++) begin
      case ($urandom % 6)
        0: add_block(b, T_CLEAN, 0, 0);
        1, 2: begin
          len = 1 + ($urandom % MAX_BURST_LEN);
          add_block(b, T_DATA, $urandom % (2048 - len + 1), len);
        end
        3: begin
          len = 1 + ($urandom % MAX_BURST_LEN);
          add_block(b, T_PARITY, 2048 + $urandom % (26 - len + 1), len);
        end
        4: begin
          len = 2 + ($urandom % (MAX_BURST_LEN - 1));
          add_block(b, T_STRADDLE, 2048 - 1 - ($urandom % (len - 1)), len);
        end
        5: begin
          len = 10 + ($urandom % 8);
          add_block(b, T_LONG, $urandom % (2048 - len + 1), len);
        end
      endcase
    end

    repeat (4) @(posedge clk);
    rst <= 1'b0;
  end

  // Block b covers cycles 32*b .. 32*b+31, eomb on the last one
  always @(posedge clk) begin
    if (!rst) begin
      cyc <= cyc + 1;
      cnt <= cnt + 1'b1;
      data_in <= {$urandom, $urandom};
    end
  end

  always @(negedge clk) begin
    if (!rst) clean[cyc] = data_in;
  end

  always @(posedge clk) begin
    eomb_d <= {eomb_d[26:1], eomb && !rst};
    if (eomb_d[1]) begin
      fec_saved <= fec;
      par_blk <= par_blk + 1;
    end
  end

  jesd204_fec_encode #(
    .DATA_WIDTH  (DATA_WIDTH)
  ) jesd204_fec_encode (
    .fec         (fec),
    .clk         (clk),
    .rst         (rst),
    .shift_en    (~rst),
    .eomb        (eomb),
    .data_in     (data_in));

  jesd204_fec_decode #(
    .DATA_WIDTH            (DATA_WIDTH)
  ) jesd204_fec_decode (
    .data_out              (data_out),
    .data_out_valid        (data_out_valid),
    .trapped_error_flag    (trapped_error_flag),
    .untrapped_error_flag  (untrapped_error_flag),
    .clk                   (clk),
    .rst                   (rst),
    .eomb                  (eomb),
    .fec_in_valid          (eomb_d[27]),
    .fec_in                (fec_saved ^ ((par_blk >= 0) ? fec_err[par_blk] : 26'd0)),
    .data_in               (data_in ^ err_mask[cyc]));

  // The decoder starts with the block after the first eomb (block 1)
  always @(posedge clk) begin
    if (data_out_valid) begin
      if (blk_type[1 + nout/32] != T_LONG && data_out !== clean[32 + nout]) begin
        $display("block %0d word %0d: %h, expected %h", 1 + nout/32, nout%32, data_out, clean[32 + nout]);
        n_mismatch++;
      end
      nout++;
    end
    if (trapped_error_flag) n_trapped++;
    if (untrapped_error_flag) n_untrapped++;
  end

  initial begin
    int n_correctable;
    wait (cyc == NUM_CYCLES);
    n_correctable = n_type[T_DATA] + n_type[T_PARITY] + n_type[T_STRADDLE];
    $display("blocks: %0d clean, %0d data, %0d parity, %0d straddle, %0d long",
      n_type[T_CLEAN], n_type[T_DATA], n_type[T_PARITY], n_type[T_STRADDLE], n_type[T_LONG]);
    $display("trapped %0d, untrapped %0d, mismatched words %0d, words out %0d",
      n_trapped, n_untrapped, n_mismatch, nout);
    if (n_mismatch != 0 || n_trapped < n_correctable ||
        n_trapped + n_untrapped != n_correctable + n_type[T_LONG])
      failed = 1'b1;
    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

endmodule

`default_nettype wire
