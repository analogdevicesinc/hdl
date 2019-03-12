// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms.
// The user should keep this in in mind while exploring these cores.
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_ip_jesd204_tpl_dac_channel #(
  parameter DATAPATH_DISABLE = 0,
  parameter DATA_PATH_WIDTH = 4,
  parameter CONVERTER_RESOLUTION = 16,
  parameter BITS_PER_SAMPLE = 16,
  parameter DDS_TYPE = 1,
  parameter DDS_CORDIC_DW = 16,
  parameter DDS_CORDIC_PHASE_DW = 16
) (
  // dac interface

  input clk,

  input [DATA_PATH_WIDTH*BITS_PER_SAMPLE-1:0] dma_data,
  output reg [DATA_PATH_WIDTH*CONVERTER_RESOLUTION-1:0] dac_data = 'h00,

  // PN data

  input [DATA_PATH_WIDTH*CONVERTER_RESOLUTION-1:0] pn7_data,
  input [DATA_PATH_WIDTH*CONVERTER_RESOLUTION-1:0] pn15_data,

  // Configuration

  input dac_data_sync,
  input dac_dds_format,

  input [3:0] dac_data_sel,

  input [15:0] dac_dds_scale_0,
  input [15:0] dac_dds_init_0,
  input [15:0] dac_dds_incr_0,
  input [15:0] dac_dds_scale_1,
  input [15:0] dac_dds_init_1,
  input [15:0] dac_dds_incr_1,

  input [15:0] dac_pat_data_0,
  input [15:0] dac_pat_data_1,

  output reg dac_enable = 1'b0
);

  localparam CR = CONVERTER_RESOLUTION;
  localparam CHANNEL_DATA_WIDTH = DATA_PATH_WIDTH * CR;

  // internal signals

  wire [CHANNEL_DATA_WIDTH-1:0] dac_dds_data_s;
  wire [CHANNEL_DATA_WIDTH-1:0] dac_dma_data_s;
  wire [CHANNEL_DATA_WIDTH-1:0] dac_pat_data_s;

  generate
    if (DATA_PATH_WIDTH > 1) begin
      assign dac_pat_data_s = {DATA_PATH_WIDTH/2{dac_pat_data_1[0+:CR],dac_pat_data_0[0+:CR]}};
    end else begin
      reg dac_pat_data_sel = 1'b0;

      always @(posedge clk) begin
        if (dac_data_sync == 1'b1) begin
          dac_pat_data_sel <= 1'b0;
        end else begin
          dac_pat_data_sel <= ~dac_pat_data_sel;
        end
      end

      assign dac_pat_data_s = dac_pat_data_sel == 1'b0 ?
        dac_pat_data_0[0+:CR] : dac_pat_data_1[0+:CR];
    end

    genvar i;
    /* Data is expected to be LSB aligned, drop unused MSBs */
    for (i = 0; i < DATA_PATH_WIDTH; i = i + 1) begin: g_dac_dma_data
      assign dac_dma_data_s[CR*i+:CR] = dma_data[BITS_PER_SAMPLE*i+:CR];
    end
  endgenerate

  // dac data select

  always @(posedge clk) begin
    dac_enable <= (dac_data_sel == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel)
      4'h7: dac_data <= pn15_data;
      4'h6: dac_data <= pn7_data;
      4'h5: dac_data <= ~pn15_data;
      4'h4: dac_data <= ~pn7_data;
      4'h3: dac_data <= 'h00;
      4'h2: dac_data <= dac_dma_data_s;
      4'h1: dac_data <= dac_pat_data_s;
      default: dac_data <= dac_dds_data_s;
    endcase
  end

  // dds

    ad_dds #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_DW (CONVERTER_RESOLUTION),
    .PHASE_DW (16),
    .DDS_TYPE (DDS_TYPE),
    .CORDIC_DW (DDS_CORDIC_DW),
    .CORDIC_PHASE_DW (DDS_CORDIC_PHASE_DW),
    .CLK_RATIO (DATA_PATH_WIDTH))
  i_dds (
    .clk (clk),
    .dac_dds_format (dac_dds_format),
    .dac_data_sync (dac_data_sync),
    .dac_valid (1'b1),
    .tone_1_scale (dac_dds_scale_0),
    .tone_2_scale (dac_dds_scale_1),
    .tone_1_init_offset (dac_dds_init_0),
    .tone_2_init_offset (dac_dds_init_1),
    .tone_1_freq_word (dac_dds_incr_0),
    .tone_2_freq_word (dac_dds_incr_1),
    .dac_dds_data (dac_dds_data_s));

endmodule
