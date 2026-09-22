// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module gearbox_align_tb;

  parameter VCD_FILE = {"gearbox_align_tb.vcd"};

  localparam SW = 16;
  localparam S_SAMPLES = 24;
  localparam M_SAMPLES = 32;
  localparam SDW = SW * S_SAMPLES;
  localparam MDW = SW * M_SAMPLES;

  `include "../../common/tb/tb_base.v"

  reg             s_axis_valid = 1'b0;
  wire            s_axis_ready;
  wire [SDW-1:0]  s_axis_data;
  wire            m_axis_valid;
  reg             m_axis_ready = 1'b1;
  wire [MDW-1:0]  m_axis_data;

  reg  [31:0] in_count = 32'd0;
  reg  [31:0] expected = 32'd0;
  reg  [31:0] beats = 32'd0;
  reg  [31:0] beats_total = 32'd0;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      in_count <= 32'd0;
    end else if (s_axis_valid == 1'b1 && s_axis_ready == 1'b1) begin
      in_count <= in_count + S_SAMPLES;
    end
  end

  genvar g;
  generate
    for (g = 0; g < S_SAMPLES; g = g + 1) begin: g_source
      assign s_axis_data[g*SW +: SW] = in_count + g;
    end
  endgenerate

  util_axis_gearbox #(
    .S_DATA_WIDTH (SDW),
    .M_DATA_WIDTH (MDW)
  ) i_dut (
    .clk (clk),
    .resetn (~reset),
    .s_axis_valid (s_axis_valid),
    .s_axis_ready (s_axis_ready),
    .s_axis_data (s_axis_data),
    .m_axis_valid (m_axis_valid),
    .m_axis_ready (m_axis_ready),
    .m_axis_data (m_axis_data));

  integer k;
  reg [SW-1:0] sample;
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      expected <= 32'd0;
      beats <= 32'd0;
    end else if (m_axis_valid == 1'b1 && m_axis_ready == 1'b1) begin
      for (k = 0; k < M_SAMPLES; k = k + 1) begin
        sample = m_axis_data[k*SW +: SW];
        if (sample !== ((expected + k) & {SW{1'b1}})) begin
          $display("ERROR: beat %0d word %0d: got %0d expected %0d",
                   beats, k, sample, (expected + k) & {SW{1'b1}});
          failed <= 1'b1;
        end
      end
      expected <= expected + M_SAMPLES;
      beats <= beats + 32'd1;
      beats_total <= beats_total + 32'd1;
    end
  end

  integer t;
  initial begin
    @(negedge reset);
    s_axis_valid <= 1'b1;

    repeat (200) @(posedge clk);

    for (t = 0; t < 400; t = t + 1) begin
      @(posedge clk);
      m_axis_ready <= ($random % 4) != 0;
    end
    m_axis_ready <= 1'b1;
    repeat (40) @(posedge clk);

    do_trigger_reset;
    repeat (200) @(posedge clk);

    $display("INFO: gearbox_align_tb moved %0d output beats", beats_total);
    if (beats_total == 32'd0) begin
      $display("ERROR: no data moved");
      failed <= 1'b1;
    end
  end

endmodule
