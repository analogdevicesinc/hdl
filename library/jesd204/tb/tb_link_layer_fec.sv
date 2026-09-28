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

// JESD204C TX -> RX loopback with FEC enabled on both sides.
//
// Directed mode (RANDOM_BURSTS = 0) sends fixed data patterns and injects one
// 2-bit burst; random mode sends random data with one random 1..MAX_BURST_LEN
// bit burst on lane 0 in every other multiblock. Bursts are contiguous on the
// wire (bit 63 of a data word is sent first), stay inside one multiblock and
// are only injected once the link is in DATA, so each must be counted exactly
// once by the lane 0 error counter, with all error sources unmasked.

module tb_link_layer_fec #(
  parameter RANDOM_BURSTS = 0,
  parameter MAX_BURST_LEN = 9,
  parameter NUM_INPUT_PIPELINE = 1
);
  localparam NUM_LANES = 2;
  localparam NUM_LINKS = 1;
  localparam SCR = 0;
  localparam DATA_PATH_WIDTH = 8;
  localparam DATA_WIDTH = DATA_PATH_WIDTH*8;

  localparam DIRECTED_DATA_WIDTH = 2048*9*2;
  localparam logic [DIRECTED_DATA_WIDTH-1:0] DATA_VALUE = {2{{2048{1'b1}}, 1'b1, 2047'b0, {64{32'h12345678}}, {2048{1'b1}}, 2047'b0, 1'b1, {64{32'hABCDEF01}}, {64{32'h23456789}}, {2048{1'b1}}, 1'b1, 2047'b0}};
  localparam INPUT_DATA_CYCLES = RANDOM_BURSTS ? 32*240 : DIRECTED_DATA_WIDTH/DATA_WIDTH;

  // Directed burst: bit 0 of one word and bit 63 of the next, i.e. the last
  // bit of a word and the first bit of the following word on the wire.
  localparam DIRECTED_ERROR_WORD = 4;
  localparam [DATA_WIDTH-1:0] DIRECTED_ERROR_BITS = 64'h1;
  localparam [DATA_WIDTH-1:0] DIRECTED_NEXT_ERROR_BITS = 64'h8000000000000000;

  // Stop injecting early enough for the last bursts to be decoded and counted
  localparam INJECT_STOP_CYCLE = INPUT_DATA_CYCLES - 32*2;
  localparam MAX_RX_OFFSET = 32*12;
  // The directed patterns repeat within two multiblocks, so match three
  localparam MATCH_LEN = 96;
  localparam NUM_WINDOWS = INPUT_DATA_CYCLES/32 + 64;

  parameter VCD_FILE = {"tb_link_layer_fec.vcd"};
  `define TIMEOUT 2000000
  `include "tb_base.v"

  logic                           rst;
  logic [DIRECTED_DATA_WIDTH-1:0] data;
  logic [DATA_WIDTH-1:0]          data_in;
  logic [DATA_WIDTH-1:0]          data_in_swap;
  int                             data_in_cnt;
  int ii;
  int tx_cycle_cnt;
  int rx_cycle_cnt;
  int data_cycle;
  int mb_phase;
  int phase_votes[32];
  logic [3:0] sh_hist;
  int n_mismatch;
  int n_bursts;
  genvar jj;

  logic [NUM_LANES-1:0] tx_cfg_lanes_disable;
  logic [NUM_LINKS-1:0] tx_cfg_links_disable;
  logic [9:0] tx_cfg_octets_per_multiframe;
  logic [7:0] tx_cfg_octets_per_frame;
  logic [9:0] tx_device_cfg_octets_per_multiframe;
  logic [7:0] tx_device_cfg_octets_per_frame;
  logic [7:0] tx_device_cfg_beats_per_multiframe;
  logic [7:0] tx_device_cfg_lmfc_offset;
  logic tx_device_cfg_sysref_oneshot;
  logic tx_device_cfg_sysref_disable;
  logic tx_cfg_continuous_cgs;
  logic tx_cfg_continuous_ilas;
  logic tx_cfg_skip_ilas;
  logic [7:0] tx_cfg_mframes_per_ilas;
  logic tx_cfg_disable_char_replacement;
  logic [1:0] tx_cfg_header_mode;
  logic tx_cfg_disable_scrambler;
  logic tx_lmfc_edge;
  logic tx_lmfc_clk;
  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_data;
  logic tx_ready;
  logic [DATA_PATH_WIDTH-1:0] tx_eof;
  logic [DATA_PATH_WIDTH-1:0] tx_sof;
  logic [DATA_PATH_WIDTH-1:0] tx_somf;
  logic [DATA_PATH_WIDTH-1:0] tx_eomf;
  logic tx_valid;

  logic [NUM_LANES-1:0] rx_cfg_lanes_disable;
  logic [NUM_LINKS-1:0] rx_cfg_links_disable;
  logic [9:0] rx_cfg_octets_per_multiframe;
  logic [7:0] rx_cfg_octets_per_frame;
  logic [9:0] rx_device_cfg_octets_per_multiframe;
  logic [7:0] rx_device_cfg_octets_per_frame;
  logic [7:0] rx_device_cfg_beats_per_multiframe;
  logic [7:0] rx_device_cfg_lmfc_offset;
  logic rx_device_cfg_sysref_oneshot;
  logic rx_device_cfg_sysref_disable;
  logic [7:0] rx_device_cfg_buffer_delay;
  logic rx_device_cfg_buffer_early_release;
  logic rx_cfg_disable_scrambler;
  logic rx_cfg_disable_char_replacement;
  logic [1:0] rx_cfg_header_mode;
  logic [7:0] rx_cfg_frame_align_err_threshold;

  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_phy_data;
  logic [2*NUM_LANES-1:0] tx_phy_header;
  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] rx_phy_data;
  logic [2*NUM_LANES-1:0] rx_phy_header;
  logic [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_charisk;
  logic  rx_lmfc_edge;
  logic  rx_lmfc_clk;
  logic  [DATA_PATH_WIDTH*8*NUM_LANES-1:0] rx_data;
  logic  rx_valid;
  logic  [DATA_PATH_WIDTH-1:0] rx_eof;
  logic  [DATA_PATH_WIDTH-1:0] rx_sof;
  logic  [DATA_PATH_WIDTH-1:0] rx_eomf;
  logic  [DATA_PATH_WIDTH-1:0] rx_somf;
  logic  [1:0] rx_status_ctrl_state;
  logic  rx_ctrl_err_statistics_reset;
  logic [8:0] rx_ctrl_err_statistics_mask;
  logic [32*NUM_LANES-1:0] rx_status_err_statistics_cnt;

  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_hist [INPUT_DATA_CYCLES];
  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] rx_first [MATCH_LEN];
  int rx_offset;

  logic link_sysref = 1'b0;
  logic [7:0] sysref_cnt = '0;
  logic [2047:0] burst_mask [NUM_WINDOWS];
  logic [DATA_WIDTH-1:0] cur_err;

  // SYSREF period of 8 multiblocks
  always @(posedge clk) begin
    sysref_cnt <= sysref_cnt + 1'b1;
    link_sysref <= sysref_cnt[7];
  end

  initial begin
    rst = 1'b1;
    #200ns;
    @(posedge clk) rst = 1'b0;
  end

  assign tx_valid = 1'b1;

  initial begin
    // Shift directed data in MSb-first
    for(ii = 0; ii < DIRECTED_DATA_WIDTH; ii = ii + 1) begin
      data[ii] = DATA_VALUE[DIRECTED_DATA_WIDTH-1-ii];
    end
    data_in_cnt = '0;
    data_in = RANDOM_BURSTS ? {$urandom, $urandom} : data[0+:DATA_WIDTH];
    forever begin
      @(posedge clk);
      #0;
      if(tx_ready && (data_in_cnt < INPUT_DATA_CYCLES)) begin
        data = data >> DATA_WIDTH;
        data_in = RANDOM_BURSTS ? {$urandom, $urandom} : data[0+:DATA_WIDTH];
        data_in_cnt = data_in_cnt + 1;
      end
    end
  end

  always_ff @(posedge clk) begin
    if(rst) begin
      tx_cycle_cnt <= '0;
    end else begin
      if(tx_ready) begin
        tx_cycle_cnt <= tx_cycle_cnt + 1;
      end
    end
  end

  // Swap order of octets
  for(jj = 0; jj < DATA_PATH_WIDTH; jj=jj+1) begin : tx_data_gen
    assign data_in_swap[jj*8+:8] = data_in[(DATA_PATH_WIDTH-jj-1)*8+:8];
  end

  assign tx_data = {NUM_LANES{data_in_swap}};

  initial begin
    int len;
    int pos;
    for (int w = 0; w < NUM_WINDOWS; w++) begin
      burst_mask[w] = '0;
      if (RANDOM_BURSTS && w % 2 == 0) begin
        len = 1 + ($urandom % MAX_BURST_LEN);
        pos = $urandom % (2048 - len + 1);
        for (int k = 0; k < len; k++)
          if (k == 0 || k == len-1 || ($urandom & 1))
            burst_mask[w][pos + k] = 1'b1;
      end
    end
  end

  // Multiblock phase: the last word of a multiblock carries the final bits of
  // the 00001 pilot in its sync header. FEC parity can mimic the pilot, so vote.
  always @(posedge clk) begin
    if (rst) begin
      sh_hist <= '0;
      for (int k = 0; k < 32; k++) phase_votes[k] <= 0;
    end else if (tx_ready) begin
      sh_hist <= {sh_hist[2:0], tx_phy_header[0]};
      if ({sh_hist, tx_phy_header[0]} == 5'b00001)
        phase_votes[(tx_cycle_cnt+1)%32] <= phase_votes[(tx_cycle_cnt+1)%32] + 1;
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      data_cycle <= -1;
      mb_phase <= 0;
    end else if (data_cycle < 0 && rx_status_ctrl_state == 2'd3) begin
      data_cycle <= tx_cycle_cnt;
      for (int k = 0; k < 32; k++)
        if (phase_votes[k] > phase_votes[mb_phase]) mb_phase <= k;
    end
  end

  function automatic int mb_index(int cyc);
    return (cyc - mb_phase) / 32;
  endfunction

  function automatic int mb_word(int cyc);
    return (cyc - mb_phase) % 32;
  endfunction

  function automatic int first_burst_word(int mb);
    for (int k = 0; k < 2048; k++)
      if (burst_mask[mb][k]) return k/64;
    return -1;
  endfunction

  // Injection starts two multiblocks after DATA, once mb_phase is settled
  function automatic bit inject_mb(int cyc);
    return data_cycle >= 0 && cyc < INJECT_STOP_CYCLE &&
           mb_index(cyc) >= mb_index(data_cycle) + 2;
  endfunction

  always @(*) begin
    cur_err = '0;
    if (inject_mb(tx_cycle_cnt)) begin
      if (RANDOM_BURSTS) begin
        for (int b = 0; b < 64; b++)
          cur_err[63-b] = burst_mask[mb_index(tx_cycle_cnt)][mb_word(tx_cycle_cnt)*64 + b];
      end else if (mb_index(tx_cycle_cnt) == mb_index(data_cycle) + 2) begin
        if (mb_word(tx_cycle_cnt) == DIRECTED_ERROR_WORD)
          cur_err = DIRECTED_ERROR_BITS;
        else if (mb_word(tx_cycle_cnt) == DIRECTED_ERROR_WORD + 1)
          cur_err = DIRECTED_NEXT_ERROR_BITS;
      end
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      n_bursts <= 0;
    end else if (cur_err != '0 &&
                 (RANDOM_BURSTS ? mb_word(tx_cycle_cnt) == first_burst_word(mb_index(tx_cycle_cnt)) :
                                  mb_word(tx_cycle_cnt) == DIRECTED_ERROR_WORD)) begin
      n_bursts <= n_bursts + 1;
    end
  end

  assign rx_phy_data = tx_phy_data ^ {{(DATA_WIDTH*(NUM_LANES-1)){1'b0}}, cur_err};
  assign rx_phy_header = tx_phy_header;

  assign rx_ctrl_err_statistics_mask = 9'h0;
  assign rx_ctrl_err_statistics_reset = 1'b0;

  initial begin
    forever begin
      @(negedge clk);
      if(tx_ready && (data_in_cnt < INPUT_DATA_CYCLES)) begin
        tx_hist[data_in_cnt] = tx_data;
      end
    end
  end

  // How many words the link drops at startup depends on the SYSREF/LMFC
  // phase, so locate the first RX words in the TX history instead of assuming.
  function automatic int find_rx_offset();
    for (int o = 0; o < MAX_RX_OFFSET; o++) begin
      bit match = 1'b1;
      for (int k = 0; k < MATCH_LEN; k++)
        if (tx_hist[o+k] !== rx_first[k]) match = 1'b0;
      if (match) return o;
    end
    return -1;
  endfunction

  task automatic finish_test();
    $display("Words checked: %0d, mismatches: %0d, bursts injected: %0d",
      rx_cycle_cnt, n_mismatch, n_bursts);
    $display("Error statistics lane0: %0d lane1: %0d",
      rx_status_err_statistics_cnt[31:0], rx_status_err_statistics_cnt[63:32]);
    if (n_bursts == 0 ||
        rx_status_err_statistics_cnt[31:0] != n_bursts ||
        rx_status_err_statistics_cnt[63:32] != 0) begin
      $display("Unexpected error statistics");
      failed = 1'b1;
    end
    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  endtask

  initial begin
    rx_cycle_cnt = 0;
    n_mismatch = 0;
    rx_offset = -1;
    forever begin
      @(negedge clk);
      if(rx_valid) begin
        if (rx_cycle_cnt < MATCH_LEN) begin
          rx_first[rx_cycle_cnt] = rx_data;
          if (rx_cycle_cnt == MATCH_LEN-1) begin
            rx_offset = find_rx_offset();
            if (rx_offset < 0) begin
              $error("RX data does not match any TX start offset");
              failed = 1'b1;
              finish_test();
            end
          end
        end else begin
          if (rx_offset + rx_cycle_cnt >= INPUT_DATA_CYCLES)
            finish_test();
          if (tx_hist[rx_offset + rx_cycle_cnt] !== rx_data) begin
            $error("RX Cycle: %d Data mismatch. Expected: %X  Observed: %X",
              rx_cycle_cnt, tx_hist[rx_offset + rx_cycle_cnt], rx_data);
            n_mismatch = n_mismatch + 1;
            failed = 1'b1;
          end
        end
        rx_cycle_cnt = rx_cycle_cnt + 1;
      end
    end
  end

  jesd204_tx_static_config #(
    .NUM_LANES      (NUM_LANES),
    .OCTETS_PER_FRAME(8),
    .FRAMES_PER_MULTIFRAME(32),
    .SCR            (SCR),
    .LINK_MODE      (2),
    .HEADER_MODE    (2)
  ) jesd204_tx_static_config (
    .clk                               (clk),
    .cfg_lanes_disable                 (tx_cfg_lanes_disable),
    .cfg_links_disable                 (tx_cfg_links_disable),
    .cfg_octets_per_multiframe         (tx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame              (tx_cfg_octets_per_frame),
    .device_cfg_octets_per_multiframe  (tx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame       (tx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe   (tx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset            (tx_device_cfg_lmfc_offset),
    .device_cfg_sysref_oneshot         (tx_device_cfg_sysref_oneshot),
    .device_cfg_sysref_disable         (tx_device_cfg_sysref_disable),
    .cfg_continuous_cgs                (tx_cfg_continuous_cgs),
    .cfg_continuous_ilas               (tx_cfg_continuous_ilas),
    .cfg_skip_ilas                     (tx_cfg_skip_ilas),
    .cfg_mframes_per_ilas              (tx_cfg_mframes_per_ilas),
    .cfg_disable_char_replacement      (tx_cfg_disable_char_replacement),
    .cfg_header_mode                   (tx_cfg_header_mode),
    .cfg_disable_scrambler             (tx_cfg_disable_scrambler),
    .ilas_config_rd(),
    .ilas_config_addr(),
    .ilas_config_data()
  );

  jesd204_tx #(
    .NUM_LANES                            (NUM_LANES),
    .NUM_LINKS                            (NUM_LINKS),
    .NUM_INPUT_PIPELINE                   (NUM_INPUT_PIPELINE),
    .NUM_OUTPUT_PIPELINE                  (0),
    .LINK_MODE                            (2),
    .ENABLE_FEC                           (1),
    .DATA_PATH_WIDTH                      (DATA_PATH_WIDTH)
  ) jesd204_tx (
    .clk                                  (clk),
    .reset                                (rst),
    .device_clk                           (clk),
    .device_reset                         (rst),
    .phy_data                             (tx_phy_data),
    .phy_charisk                          (phy_charisk),
    .phy_header                           (tx_phy_header),
    .sysref                               (link_sysref),
    .lmfc_edge                            (tx_lmfc_edge),
    .lmfc_clk                             (tx_lmfc_clk),
    .sync                                 ('0),
    .tx_data                              (tx_data),
    .tx_ready                             (tx_ready),
    .tx_eof                               (tx_eof),
    .tx_sof                               (tx_sof),
    .tx_eomf                              (tx_eomf),
    .tx_somf                              (tx_somf),
    .tx_valid                             (tx_valid),
    .cfg_lanes_disable                    (tx_cfg_lanes_disable),
    .cfg_links_disable                    (tx_cfg_links_disable),
    .cfg_octets_per_multiframe            (tx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame                 (tx_cfg_octets_per_frame),
    .device_cfg_octets_per_multiframe     (tx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame          (tx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe      (tx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset               (tx_device_cfg_lmfc_offset),
    .device_cfg_sysref_oneshot            (tx_device_cfg_sysref_oneshot),
    .device_cfg_sysref_disable            (tx_device_cfg_sysref_disable),
    .cfg_continuous_cgs                   (tx_cfg_continuous_cgs),
    .cfg_continuous_ilas                  (tx_cfg_continuous_ilas),
    .cfg_skip_ilas                        (tx_cfg_skip_ilas),
    .cfg_mframes_per_ilas                 (tx_cfg_mframes_per_ilas),
    .cfg_disable_char_replacement         (tx_cfg_disable_char_replacement),
    .cfg_header_mode                      (tx_cfg_header_mode),
    .cfg_disable_scrambler                (tx_cfg_disable_scrambler),
    .ilas_config_rd                       (),
    .ilas_config_addr                     (),
    .ilas_config_data                     ('0),
    .ctrl_manual_sync_request             (),
    .device_event_sysref_edge             (),
    .device_event_sysref_alignment_error  (),
    .status_sync                          (),
    .status_state                         ()
  );



  jesd204_rx_static_config #(
    .NUM_LANES                         (NUM_LANES),
    .OCTETS_PER_FRAME                  (8),
    .FRAMES_PER_MULTIFRAME             (32),
    .SCR                               (SCR),
    .LINK_MODE                         (2),
    .HEADER_MODE                       (2),
    .SYSREF_DISABLE                    (0)
  ) jesd204_rx_static_config(
    .clk                                  (clk),
    .cfg_lanes_disable                    (rx_cfg_lanes_disable),
    .cfg_links_disable                    (rx_cfg_links_disable),
    .cfg_disable_scrambler                (rx_cfg_disable_scrambler),
    .cfg_disable_char_replacement         (rx_cfg_disable_char_replacement),
    .cfg_header_mode                      (rx_cfg_header_mode),
    .cfg_frame_align_err_threshold        (rx_cfg_frame_align_err_threshold),
    .cfg_octets_per_multiframe            (rx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame                 (rx_cfg_octets_per_frame),
    .device_cfg_octets_per_multiframe     (rx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame          (rx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe      (rx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset               (rx_device_cfg_lmfc_offset),
    .device_cfg_sysref_oneshot            (rx_device_cfg_sysref_oneshot),
    .device_cfg_sysref_disable            (rx_device_cfg_sysref_disable),
    .device_cfg_buffer_delay              (rx_device_cfg_buffer_delay),
    .device_cfg_buffer_early_release      (rx_device_cfg_buffer_early_release)
  );


  jesd204_rx #(
    .NUM_LANES                            (NUM_LANES),
    .LINK_MODE                            (2),
    .ENABLE_FEC                           (1)
  ) jesd204_rx (
    .clk                                  (clk),
    .reset                                (rst),
    .device_clk                           (clk),
    .device_reset                         (rst),
    .phy_data                             (rx_phy_data),
    .phy_header                           (rx_phy_header),
    .phy_charisk                          ('0),
    .phy_notintable                       ('0),
    .phy_disperr                          ('0),
    .phy_block_sync                       ('1),
    .sysref                               (link_sysref),
    .lmfc_edge                            (rx_lmfc_edge),
    .lmfc_clk                             (rx_lmfc_clk),
    .device_event_sysref_alignment_error  (),
    .device_event_sysref_edge             (),
    .event_frame_alignment_error          (),
    .event_unexpected_lane_state_error    (),
    .sync                                 (),
    .phy_en_char_align                    (),
    .rx_data                              (rx_data),
    .rx_valid                             (rx_valid),
    .rx_eof                               (rx_eof),
    .rx_sof                               (rx_sof),
    .rx_eomf                              (rx_eomf),
    .rx_somf                              (rx_somf),
    .cfg_lanes_disable                    (rx_cfg_lanes_disable),
    .cfg_links_disable                    (rx_cfg_links_disable),
    .cfg_octets_per_multiframe            (rx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame                 (rx_cfg_octets_per_frame),
    .device_cfg_octets_per_multiframe     (rx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame          (rx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe      (rx_device_cfg_beats_per_multiframe),
    .cfg_disable_scrambler                (rx_cfg_disable_scrambler),
    .cfg_disable_char_replacement         (rx_cfg_disable_char_replacement),
    .cfg_header_mode                      (rx_cfg_header_mode),
    .cfg_frame_align_err_threshold        (rx_cfg_frame_align_err_threshold),
    .device_cfg_lmfc_offset               (rx_device_cfg_lmfc_offset),
    .device_cfg_sysref_disable            (rx_device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot            (rx_device_cfg_sysref_oneshot),
    .device_cfg_buffer_early_release      (rx_device_cfg_buffer_early_release),
    .device_cfg_buffer_delay              (rx_device_cfg_buffer_delay),
    .ctrl_err_statistics_reset            (rx_ctrl_err_statistics_reset),
    .ctrl_err_statistics_mask             (rx_ctrl_err_statistics_mask),
    .status_err_statistics_cnt            (rx_status_err_statistics_cnt),
    .ilas_config_valid                    (),
    .ilas_config_addr                     (),
    .ilas_config_data                     (),
    .status_ctrl_state                    (rx_status_ctrl_state),
    .status_lane_cgs_state                (),
    .status_lane_ifs_ready                (),
    .status_lane_latency                  (),
    .status_lane_emb_state                (),
    .status_lane_frame_align_err_cnt      ()
  );

endmodule

`default_nettype wire
