// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_lmfc #(
  parameter LINK_MODE = 1, // 2 - 64B/66B;  1 - 8B/10B
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input sysref,

  input [9:0] cfg_octets_per_multiframe,
  input [7:0] cfg_beats_per_multiframe,
  input [7:0] cfg_lmfc_offset,
  input cfg_sysref_oneshot,
  input cfg_sysref_disable,

  output reg lmfc_edge,
  output reg lmfc_clk,
  output reg [7:0] lmfc_counter,

  // Local MultiBlock clock edge
  output reg lmc_edge,
  output reg lmc_quarter_edge,
  // End of Extended MultiBlock
  output reg eoemb,

  output reg sysref_edge,
  output reg sysref_alignment_error
);

  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;
  localparam BEATS_PER_MF_WIDTH = 10-DPW_LOG2;

  //wire [BEATS_PER_MF_WIDTH-1:0]     cfg_beats_per_multiframe = cfg_octets_per_multiframe[9:DPW_LOG2];
  reg  [BEATS_PER_MF_WIDTH:0]       cfg_whole_beats_per_multiframe;

  reg sysref_r = 1'b0;
  reg sysref_d1 = 1'b0;
  reg sysref_d2 = 1'b0;
  reg sysref_d3 = 1'b0;

  reg sysref_captured;

  /* lmfc_octet_counter = lmfc_counter * (char_clock_rate / device_clock_rate) */
  reg [7:0] lmfc_counter_next = 'h00;

  reg lmfc_clk_p1 = 1'b1;

  reg lmfc_active = 1'b0;

  always @(posedge clk) begin
    sysref_r <= sysref;
  end

  /*
   * Unfortunately setup and hold are often ignored on the sysref signal relative
   * to the device clock. The device will often still work fine, just not
   * deterministic. Reduce the probability that the meta-stability creeps into the
   * reset of the system and causes non-reproducible issues.
   */
  always @(posedge clk) begin
    sysref_d1 <= sysref_r;
    sysref_d2 <= sysref_d1;
    sysref_d3 <= sysref_d2;
  end

  always @(posedge clk) begin
    if (sysref_d3 == 1'b0 && sysref_d2 == 1'b1 && cfg_sysref_disable == 1'b0) begin
      sysref_edge <= 1'b1;
    end else begin
      sysref_edge <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      sysref_captured <= 1'b0;
    end else if (sysref_edge == 1'b1) begin
      sysref_captured <= 1'b1;
    end
  end

  /*
   * The configuration must be static when the core is out of reset. Otherwise
   * undefined behaviour might occur.
   * E.g. lmfc_counter > beats_per_multiframe
   *
   * To change the configuration first assert reset, then update the configuration
   * setting, finally deassert reset.
   */

  /*
   * For DATA_PATH_WIDTH == 8, F*K%8=4, set
   * cfg_beats_per_multiframe = cfg_beats_per_multiframe*2
   * LMFC will be twice the actual length
   */
  always @(*) begin
    if((LINK_MODE == 1) && (DATA_PATH_WIDTH == 8) && ~cfg_octets_per_multiframe[2]) begin
      cfg_whole_beats_per_multiframe = cfg_beats_per_multiframe*2;
    end else begin
      cfg_whole_beats_per_multiframe = cfg_beats_per_multiframe;
    end
  end

  always @(*) begin
    if (lmfc_counter == cfg_whole_beats_per_multiframe) begin
      lmfc_counter_next = 'h00;
    end else begin
      lmfc_counter_next = lmfc_counter + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      lmfc_counter <= 'h01;
      lmfc_active <= cfg_sysref_disable;
    end else begin
      /*
       * In oneshot mode only the first occurence of the
       * SYSREF signal is used for alignment.
       */
      if (sysref_edge == 1'b1 &&
          (cfg_sysref_oneshot == 1'b0 || sysref_captured == 1'b0)) begin
        lmfc_counter <= cfg_lmfc_offset;
        lmfc_active <= 1'b1;
      end else begin
        lmfc_counter <= lmfc_counter_next;
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      sysref_alignment_error <= 1'b0;
    end else begin
      /*
       * Alignement error is reported regardless of oneshot mode
       * setting.
       */
      sysref_alignment_error <= 1'b0;
      if (sysref_edge == 1'b1 && lmfc_active == 1'b1 &&
          lmfc_counter_next != cfg_lmfc_offset) begin
        sysref_alignment_error <= 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (lmfc_counter == 'h00 && lmfc_active == 1'b1) begin
      lmfc_edge <= 1'b1;
    end else begin
      lmfc_edge <= 1'b0;
    end
  end

  // 1 MultiBlock = 32 blocks
  always @(posedge clk) begin
    if (lmfc_counter[4:0] == 'h00 && lmfc_active == 1'b1) begin
      lmc_edge <= 1'b1;
    end else begin
      lmc_edge <= 1'b0;
    end
  end
  always @(posedge clk) begin
    if (lmfc_counter[2:0] == 'h00 && lmfc_active == 1'b1) begin
      lmc_quarter_edge <= 1'b1;
    end else begin
      lmc_quarter_edge <= 1'b0;
    end
  end
  // End of Extended MultiBlock
  always @(posedge clk) begin
    if (lmfc_active == 1'b1) begin
      eoemb <= lmfc_counter[7:5] == cfg_whole_beats_per_multiframe[7:5];
    end else begin
      eoemb <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      lmfc_clk_p1 <= 1'b0;
    end else if (lmfc_active == 1'b1) begin
      if (lmfc_counter == cfg_whole_beats_per_multiframe) begin
        lmfc_clk_p1 <= 1'b1;
      end else if (lmfc_counter == cfg_whole_beats_per_multiframe[7:1]) begin
        lmfc_clk_p1 <= 1'b0;
      end
    end

    lmfc_clk <= lmfc_clk_p1;
  end

endmodule
