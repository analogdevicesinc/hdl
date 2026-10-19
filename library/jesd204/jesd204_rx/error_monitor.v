// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022, 2026 Analog Devices, Inc. All rights reserved.
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

module error_monitor #(
  parameter EVENT_WIDTH = 16,
  parameter CNT_WIDTH = 32
) (
  input clk,
  input reset,
  input active,
  input [EVENT_WIDTH-1:0] error_event,
  input [EVENT_WIDTH-1:0] error_event_mask,
  output [CNT_WIDTH-1:0] status_err_cnt
);

  localparam EVENT_WIDTH_LOG = $clog2(EVENT_WIDTH+1);
  localparam CNT_LOW_WIDTH = CNT_WIDTH / 2;
  localparam CNT_HIGH_WIDTH = CNT_WIDTH - CNT_LOW_WIDTH;

  wire [CNT_LOW_WIDTH:0]  cnt_low_nx  = {1'b0, cnt_low} + err_incr;
  wire [CNT_HIGH_WIDTH-1:0] cnt_high_nx = cnt_high + cnt_carry;

  reg  [EVENT_WIDTH-1:0] err;
  reg  [EVENT_WIDTH_LOG-1:0] err_incr = 'h0;
  reg  [CNT_LOW_WIDTH-1:0] cnt_low  = 'h0;
  reg  [CNT_LOW_WIDTH-1:0] cnt_low_dly  = 'h0;
  reg  [CNT_HIGH_WIDTH-1:0] cnt_high = 'h0;
  reg  cnt_carry = 1'b0;

  function [EVENT_WIDTH_LOG-1:0] num_set_bits;
  input [EVENT_WIDTH-1:0] x;
  integer j;
  begin
    num_set_bits = 0;
    for (j = 0; j < EVENT_WIDTH; j = j + 1) begin
      num_set_bits = num_set_bits + x[j];
    end
  end
  endfunction

  always @(posedge clk) begin
    if (active == 1'b1) begin
      err <= (~error_event_mask) & error_event;
    end else begin
      err <= {EVENT_WIDTH{1'b0}};
    end
  end

  // Register the function before using it in the status_err_cnt counter
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      err_incr <= 'h0;
    end else begin
      err_incr <= num_set_bits(err);
    end
  end

  // The error counter is split into 2 parts. This is the counter for the
  // lower part, with carry.
  // We only count if the current total count value is not about to wrap around.
  // cnt_low may get to 00...0 before we stop counting, but thius value will not
  // be assigned to cnt_low_dly anymore.
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      cnt_low   <= 'h0;
      cnt_low_dly <= 'h0;
      cnt_carry <= 1'b0;
    end else if (~&status_err_cnt[CNT_WIDTH-1:EVENT_WIDTH_LOG]) begin
      cnt_low   <= cnt_low_nx[CNT_LOW_WIDTH-1:0];
      cnt_low_dly <= cnt_low;
      cnt_carry <= cnt_low_nx[CNT_LOW_WIDTH];
    end
  end

  // The error counter is split into 2 parts. This is the counter for the
  // higher part.
  // We only count if the current total count value is not about to wrap around.
  // As a result, the cnt_carry value is not applied anymore, just before we are
  // about to wrap around.
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      cnt_high <= 'h0;
    end else if (~&status_err_cnt[CNT_WIDTH-1:EVENT_WIDTH_LOG]) begin
      cnt_high <= cnt_high_nx;
    end
  end

  // Use cnt_low_dly for the lower part of the counter, so the two halves are
  // always in sync.
  assign status_err_cnt = {cnt_high, cnt_low_dly};

endmodule
