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
  parameter DAC_DDS_TYPE = 1,
  parameter DAC_DDS_CORDIC_DW = 16,
  parameter DAC_DDS_CORDIC_PHASE_DW = 16
) (
  // dac interface

  input clk,

  input [DATA_PATH_WIDTH*16-1:0] dma_data,
  output reg [DATA_PATH_WIDTH*16-1:0] dac_data = 'h00,

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

  localparam DW = DATA_PATH_WIDTH * 16 - 1;

  // internal registers

  reg [DW:0] dac_pn7_data = 'd0;
  reg [DW:0] dac_pn15_data = 'd0;
  reg [15:0] dac_dds_phase_0[0:DATA_PATH_WIDTH-1];
  reg [15:0] dac_dds_phase_1[0:DATA_PATH_WIDTH-1];

  // internal signals

  wire [DW:0] dac_dds_data_s;

  wire [DW:0] pn15;
  wire [DW+15:0] pn15_full_state;
  wire [DW:0] dac_pn15_data_s;
  wire [DW:0] pn7;
  wire [DW+7:0] pn7_full_state;
  wire [DW:0] dac_pn7_data_s;

  // PN15 x^15 + x^14 + 1
  assign pn15 = pn15_full_state[15+:DW+1] ^ pn15_full_state[14+:DW+1];
  assign pn15_full_state = {dac_pn15_data[14:0],pn15};

  // PN7 x^7 + x^6 + 1
  assign pn7 = pn7_full_state[7+:DW+1] ^ pn7_full_state[6+:DW+1];
  assign pn7_full_state = {dac_pn7_data[6:0],pn7};

  generate
  genvar i;
  for (i = 0; i < DATA_PATH_WIDTH; i = i + 1) begin: g_pn_swizzle
    localparam src_lsb = i * 16;
    localparam dst_lsb = (DATA_PATH_WIDTH - i - 1) * 16;

    assign dac_pn15_data_s[dst_lsb+:16] = dac_pn15_data[src_lsb+:16];
    assign dac_pn7_data_s[dst_lsb+:16] = dac_pn7_data[src_lsb+:16];
  end
  endgenerate

  // dac data select

  always @(posedge clk) begin
    dac_enable <= (dac_data_sel == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel)
      4'h7: dac_data <= dac_pn15_data_s;
      4'h6: dac_data <= dac_pn7_data_s;
      4'h5: dac_data <= ~dac_pn15_data_s;
      4'h4: dac_data <= ~dac_pn7_data_s;
      4'h3: dac_data <= 'h00;
      4'h2: dac_data <= dma_data;
      4'h1: dac_data <= {DATA_PATH_WIDTH/2{dac_pat_data_1, dac_pat_data_0}};
      default: dac_data <= dac_dds_data_s;
    endcase
  end

  // pn registers

  always @(posedge clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_pn15_data <= {DW+1{1'd1}};
      dac_pn7_data <= {DW+1{1'd1}};
    end else begin
      dac_pn15_data <= pn15;
      dac_pn7_data <= pn7;
    end
  end

  // dds

    ad_dds #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_DW (16),
    .PHASE_DW (16),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
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
