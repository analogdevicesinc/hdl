// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2022, 2025-2026 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module jesd204_rx_lane_64b #(
  parameter ELASTIC_BUFFER_SIZE = 256,
  parameter ENABLE_FEC = 1'b0,
  parameter TPL_DATA_PATH_WIDTH = 8,
  parameter ASYNC_CLK = 0,
  // Number of pipeline stages present on the all_buffer_ready_n input. The
  // beat on which the input is evaluated is moved by the same amount, so the
  // sampled value is always the one from the half multiblock beat.
  parameter ALL_BUFFER_READY_DELAY = 0
) (
  input clk,
  input reset,

  input device_clk,
  input device_reset,

  input [63:0] phy_data,
  input [1:0] phy_header,
  input phy_block_sync,

  output [TPL_DATA_PATH_WIDTH*8-1:0] rx_data,

  output reg buffer_ready_n = 'b1,
  input all_buffer_ready_n,
  input buffer_release_n,

  input lmfc_edge,
  output emb_lock,

  input cfg_disable_scrambler,
  input [1:0] cfg_header_mode,  // 0 - CRC12 ; 1 - CRC3; 2 - FEC; 3 - CMD
  input [4:0] cfg_rx_thresh_emb_err,
  input [7:0] cfg_beats_per_multiframe,

  input ctrl_err_statistics_reset,
  input [5:0] ctrl_err_statistics_mask,
  output [31:0] status_err_statistics_cnt,

  output [2:0] status_lane_emb_state,
  output reg [7:0] status_lane_skew
);

  reg  [11:0] crc12_calculated_prev;

  wire [63:0] phy_data_r;
  wire [11:0] crc12_received_r;
  wire [63:0] data_descrambled_s;
  wire [63:0] data_descrambled;
  wire [63:0] data_descrambled_reordered;
  wire [11:0] crc12_received;
  wire [11:0] crc12_calculated;

  wire event_invalid_header;
  wire event_unexpected_eomb;
  wire event_unexpected_eoemb;
  wire event_crc12_mismatch;
  wire event_fec_trapped_error_flag;
  wire event_fec_untrapped_error_flag;
  wire err_cnt_rst;

  wire [63:0] rx_data_msb_s;

  wire eomb;
  wire eoemb;
  wire eomb_r;
  wire valid_fec;
  wire [25:0] fec_received;
  wire fec_en;
  wire [63:0] fec_data_out;
  wire [63:0] scram_data_in;
  wire fec_data_out_valid;
  wire fec_trapped_error_flag;
  wire fec_untrapped_error_flag;
  wire buffer_not_ready_next;
  wire buffer_ready_next;
  reg [2:1] buffer_not_ready_r;
  reg [2:1] buffer_ready_r;

  wire [7:0] sh_count;

  jesd204_rx_header #(
    .ENABLE_FEC (ENABLE_FEC)
  ) i_rx_header (
    .clk(clk),
    .reset(reset),

    .sh_lock(phy_block_sync),
    .header(phy_header),

    .cfg_header_mode(cfg_header_mode),
    .cfg_rx_thresh_emb_err(cfg_rx_thresh_emb_err),
    .cfg_beats_per_multiframe(cfg_beats_per_multiframe),

    .emb_lock(emb_lock),

    .valid_eomb(eomb),
    .valid_eoemb(eoemb),
    .valid_fec(valid_fec),
    .crc12(crc12_received),
    .crc3(),
    .fec(fec_received),
    .cmd(),
    .sh_count(sh_count),

    .status_lane_emb_state(status_lane_emb_state),
    .event_invalid_header(event_invalid_header),
    .event_unexpected_eomb(event_unexpected_eomb),
    .event_unexpected_eoemb(event_unexpected_eoemb));

  util_pipeline_stage #(
    .WIDTH(1+12+64),
    .REGISTERED(1)
  ) i_pipeline_crc12 (
    .clk(clk),
    .in({
        eomb,
        crc12_received,
        phy_data
      }),
    .out({
        eomb_r,
        crc12_received_r,
        phy_data_r
      }));

  jesd204_crc12 i_crc12 (
    .clk(clk),
    .reset(reset),
    .init(eomb_r),
    .data_in(phy_data_r),
    .crc12(crc12_calculated));

  reg crc12_on = 'b0;
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      crc12_on <= 1'b0;
    end else if ((cfg_header_mode == 2'd0) && eomb_r) begin
      crc12_on <= 1'b1;
    end
  end

  reg crc12_rdy = 'b0;
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      crc12_rdy <= 1'b0;
    end else if (crc12_on && eomb_r) begin
      crc12_rdy <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (eomb_r) begin
      crc12_calculated_prev <= crc12_calculated;
    end
  end

  assign event_crc12_mismatch = crc12_rdy && eomb_r && (crc12_calculated_prev != crc12_received_r);

  assign err_cnt_rst = reset || ctrl_err_statistics_reset;

  genvar j;

  if(ENABLE_FEC) begin : gen_fec
    wire [63:0] fec_data_in;
    wire [63:0] fec_data_out_rev;
    wire fec_eomb;

    // The decoder shifts data_in[0] first and expects eomb with the last
    // block of the multiblock; bit 63 is the first bit on the wire and
    // valid_eomb only asserts one block later, with the first block of the
    // next multiblock.
    for (j = 0; j < 64; j = j + 1) begin: g_fec_data_rev
      assign fec_data_in[j] = phy_data[63-j];
      assign fec_data_out[j] = fec_data_out_rev[63-j];
    end

    assign fec_eomb = emb_lock && (sh_count[4:0] == 5'd31);

    jesd204_fec_decode #(
      .DATA_WIDTH (64)
    ) jesd204_fec_decode (
      .data_out              (fec_data_out_rev),
      .data_out_valid        (fec_data_out_valid),
      .trapped_error_flag    (fec_trapped_error_flag),
      .untrapped_error_flag  (fec_untrapped_error_flag),
      .clk                   (clk),
      .rst                   (reset),
      .eomb                  (fec_eomb),
      .fec_in_valid          (valid_fec),
      .fec_in                (fec_received),
      .data_in               (fec_data_in));

    assign fec_en = cfg_header_mode == 2'd2;
    assign scram_data_in = fec_en ? fec_data_out : phy_data;
    assign event_fec_trapped_error_flag = fec_en && fec_trapped_error_flag;
    assign event_fec_untrapped_error_flag = fec_en && fec_untrapped_error_flag;
  end else begin : gen_no_fec
    assign scram_data_in = phy_data;
    assign fec_en = 1'b0;
    assign fec_trapped_error_flag = 1'b0;
    assign fec_untrapped_error_flag = 1'b0;
    assign event_fec_trapped_error_flag = 1'b0;
    assign event_fec_untrapped_error_flag = 1'b0;
  end

  error_monitor #(
    .EVENT_WIDTH(6),
    .CNT_WIDTH(32)
  ) i_error_monitor (
    .clk(clk),
    .reset(err_cnt_rst),
    .active(1'b1),
    .error_event({
      event_fec_trapped_error_flag,
      event_fec_untrapped_error_flag,
      event_invalid_header,
      event_unexpected_eomb,
      event_unexpected_eoemb,
      event_crc12_mismatch
    }),
    .error_event_mask(ctrl_err_statistics_mask),
    .status_err_cnt(status_err_statistics_cnt));

  jesd204_scrambler_64b #(
    .WIDTH(64),
    .DESCRAMBLE(1)
  ) i_descrambler (
    .clk(clk),
    .reset(reset),
    .enable(~cfg_disable_scrambler),
    .data_in(scram_data_in),
    .data_out(data_descrambled_s));

  util_pipeline_stage #(
    .WIDTH(64),
    .REGISTERED(1)
  ) i_pipeline_stage2 (
    .clk(clk),
    .in({
        data_descrambled_s
      }),
    .out({
        data_descrambled
      }));

  // Beat on which the aggregated ready status of all the lanes is evaluated.
  // ALL_BUFFER_READY_DELAY compensates for the pipeline stages on the
  // all_buffer_ready_n input, keeping the evaluated value the one from the half
  // multiblock beat. sh_count wraps at cfg_beats_per_multiframe (= E*32-1) and
  // eoemb is expected on sh_count 0, so as long as the delay stays well below
  // half a multiblock this cannot collide with either boundary.
  wire [7:0] buffer_abort_beat = {1'b0,cfg_beats_per_multiframe[7:1]} +
                                 ALL_BUFFER_READY_DELAY;

  // Control when data is written to the elastic buffer
  // Start writing to the buffer when current lane is multiblock locked, but if
  // other lanes are not writing in the next half multiblock period stop
  // writing.
  // This limits the supported lane skew to half of the multiframe

  assign buffer_not_ready_next = sh_count == buffer_abort_beat && all_buffer_ready_n;
  assign buffer_ready_next = eomb;

  always @(posedge clk) begin
    buffer_not_ready_r <= {buffer_not_ready_r[1], buffer_not_ready_next};
    buffer_ready_r <= {buffer_ready_r[1], buffer_ready_next};
  end

  always @(posedge clk) begin
    if (reset | ~emb_lock | (fec_en & ~fec_data_out_valid)) begin
      buffer_ready_n <= 1'b1;
    end else begin
      // FEC data is delayed by 2 cycles
      if(fec_en) begin
        if(buffer_not_ready_r[2]) begin
          buffer_ready_n <= 1'b1;
        end else if(buffer_ready_r[2]) begin
          buffer_ready_n <= 1'b0;
        end
      end else begin
        if(buffer_not_ready_next) begin
          buffer_ready_n <= 1'b1;
        end else if(buffer_ready_next) begin
          buffer_ready_n <= 1'b0;
        end
      end
    end
  end

  elastic_buffer #(
    .IWIDTH(64),
    .OWIDTH(TPL_DATA_PATH_WIDTH*8),
    .SIZE(ELASTIC_BUFFER_SIZE),
    .ASYNC_CLK(ASYNC_CLK)
  ) i_elastic_buffer (
    .clk(clk),
    .reset(reset),

    .device_clk(device_clk),
    .device_reset(device_reset),

    .wr_data(data_descrambled_reordered),
    .rd_data(rx_data),

    .ready_n(buffer_ready_n),
    .do_release_n(buffer_release_n));

  // Measure the delay from the eoemb to the next LMFC edge.
  always @(posedge clk) begin
    if (lmfc_edge) begin
      status_lane_skew <= sh_count;
    end
  end

  /* Reorder octets LSB first */
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 8) begin: g_link_data
      assign data_descrambled_reordered[i+:8] = data_descrambled[64-1-i-:8];
    end
  endgenerate

endmodule
