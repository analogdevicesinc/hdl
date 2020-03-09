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

module ad_ip_jesd204_tpl_dac_core #(
  parameter DATAPATH_DISABLE = 0,
  parameter IQCORRECTION_DISABLE = 1,
  parameter XBAR_ENABLE = 1,
  parameter NUM_LANES = 1,
  parameter NUM_CHANNELS = 1,
  parameter BITS_PER_SAMPLE = 16,
  parameter CONVERTER_RESOLUTION = 16,
  parameter SAMPLES_PER_FRAME = 1,
  parameter OCTETS_PER_BEAT = 4,
  parameter DATA_PATH_WIDTH = 4,
  parameter LINK_DATA_WIDTH = NUM_LANES * OCTETS_PER_BEAT * 8,
  parameter DMA_DATA_WIDTH = DATA_PATH_WIDTH * BITS_PER_SAMPLE * NUM_CHANNELS,
  parameter DDS_TYPE = 1,
  parameter DDS_CORDIC_DW = 16,
  parameter DDS_CORDIC_PHASE_DW = 16,
  parameter EXT_SYNC = 0
) (
  // dac interface
  input clk,

  output link_valid,
  input link_ready,
  output [LINK_DATA_WIDTH-1:0] link_data,

  // dma interface
  output [NUM_CHANNELS-1:0] dac_valid,
  input [DMA_DATA_WIDTH-1:0] dac_ddata,

  // Configuration interface

  input dac_sync,

  input dac_sync_in,

  output dac_sync_in_status,

  input dac_dds_format,

  input [NUM_CHANNELS*4-1:0] dac_data_sel,
  input [NUM_CHANNELS-1:0]   dac_mask_enable,

  input [NUM_CHANNELS*16-1:0] dac_dds_scale_0,
  input [NUM_CHANNELS*16-1:0] dac_dds_init_0,
  input [NUM_CHANNELS*16-1:0] dac_dds_incr_0,
  input [NUM_CHANNELS*16-1:0] dac_dds_scale_1,
  input [NUM_CHANNELS*16-1:0] dac_dds_init_1,
  input [NUM_CHANNELS*16-1:0] dac_dds_incr_1,

  input [NUM_CHANNELS*16-1:0] dac_pat_data_0,
  input [NUM_CHANNELS*16-1:0] dac_pat_data_1,

  input [NUM_CHANNELS-1:0]  dac_iqcor_enb,
  input [NUM_CHANNELS*16-1:0] dac_iqcor_coeff_1,
  input [NUM_CHANNELS*16-1:0] dac_iqcor_coeff_2,

  input [NUM_CHANNELS*8-1:0] dac_src_chan_sel,

  output [NUM_CHANNELS-1:0] enable
);

  localparam DAC_CDW = CONVERTER_RESOLUTION * DATA_PATH_WIDTH;
  localparam DAC_DATA_WIDTH = DAC_CDW * NUM_CHANNELS;
  localparam DMA_CDW = DATA_PATH_WIDTH * BITS_PER_SAMPLE;


  wire [DAC_DATA_WIDTH-1:0] dac_data_s;
  wire [DMA_DATA_WIDTH-1:0] dac_ddata_muxed;

  wire [DAC_CDW-1:0] pn7_data;
  wire [DAC_CDW-1:0] pn15_data;

  reg dac_sync_in_d1 ='d0;
  reg dac_sync_in_d2 ='d0;
  reg dac_sync_in_arm ='d0;
  reg dac_sync_d1 = 'd0;

  assign link_valid = 1'b1;
  assign dac_sync_in_status = dac_sync_in_arm;

  always @(posedge clk) begin
    dac_sync_d1 <= dac_sync;
    dac_sync_in_d1 <= dac_sync_in;
    dac_sync_in_d2 <= dac_sync_in_d1;
    if ((~dac_sync_d1&dac_sync) == 1'b1) begin
      dac_sync_in_arm <= ~dac_sync_in_arm;
    end else if ((~dac_sync_in_d2&dac_sync_in_d1) == 1'b1) begin
      dac_sync_in_arm <= 1'b0;
    end else if (EXT_SYNC == 1'b0) begin
      dac_sync_in_arm <= 1'b0;
    end
  end

  // device interface

  ad_ip_jesd204_tpl_dac_framer #(
    .NUM_LANES (NUM_LANES),
    .NUM_CHANNELS (NUM_CHANNELS),
    .BITS_PER_SAMPLE (BITS_PER_SAMPLE),
    .CONVERTER_RESOLUTION (CONVERTER_RESOLUTION),
    .SAMPLES_PER_FRAME (SAMPLES_PER_FRAME),
    .OCTETS_PER_BEAT (OCTETS_PER_BEAT),
    .LINK_DATA_WIDTH (LINK_DATA_WIDTH),
    .DAC_DATA_WIDTH (DAC_DATA_WIDTH)
  ) i_framer (
    .link_data (link_data),
    .dac_data (dac_data_s)
  );

  // PN generator
  ad_ip_jesd204_tpl_dac_pn #(
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
    .CONVERTER_RESOLUTION (CONVERTER_RESOLUTION)
  ) i_pn_gen (
    .clk (clk),
    .reset (dac_sync_in_arm),

    .pn7_data (pn7_data),
    .pn15_data (pn15_data)
  );

  // dac valid

  assign dac_valid = {NUM_CHANNELS{~dac_sync_in_arm}};

  generate
  genvar i;
  for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: g_channel

    // Find the pair of the current channel for I/Q channels
    // Assuming even channels are I, odd channels are Q
    // Assuming channel count is even other case do not pair channels
    localparam IQ_PAIR_CH_INDEX = (NUM_CHANNELS%2) ? i :
                                  (i%2) ? i-1 : i+1;


    if (XBAR_ENABLE == 1) begin

      // NUM_CHANNELS : 1  mux
      ad_mux #(
        .CH_W (DMA_CDW),
        .CH_CNT (NUM_CHANNELS),
        .EN_REG (1)
      ) channel_mux (
        .clk (clk),
        .data_in (dac_ddata),
        .ch_sel (dac_src_chan_sel[8*i+:8]),
        .data_out (dac_ddata_muxed[DMA_CDW*i+:DMA_CDW])
      );

    end else begin
      assign dac_ddata_muxed[DMA_CDW*i+:DMA_CDW] = dac_ddata[DMA_CDW*i+:DMA_CDW];
    end

    ad_ip_jesd204_tpl_dac_channel #(
      .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
      .CONVERTER_RESOLUTION (CONVERTER_RESOLUTION),
      .DATAPATH_DISABLE (DATAPATH_DISABLE),
      .BITS_PER_SAMPLE (BITS_PER_SAMPLE),
      .DDS_TYPE (DDS_TYPE),
      .DDS_CORDIC_DW (DDS_CORDIC_DW),
      .DDS_CORDIC_PHASE_DW (DDS_CORDIC_PHASE_DW),
      .IQCORRECTION_DISABLE(IQCORRECTION_DISABLE),
      .Q_OR_I_N(i%2)
    ) i_channel (
      .clk (clk),
      .dac_enable (enable[i]),
      .dac_data (dac_data_s[DAC_CDW*i+:DAC_CDW]),
      .dma_data (dac_ddata_muxed[DMA_CDW*i+:DMA_CDW]),

      .pn7_data (pn7_data),
      .pn15_data (pn15_data),

      .dac_data_sync (dac_sync_in_arm),
      .dac_dds_format (dac_dds_format),

      .dac_data_sel (dac_data_sel[4*i+:4]),
      .dac_mask_enable (dac_mask_enable[i]),

      .dac_dds_scale_0 (dac_dds_scale_0[16*i+:16]),
      .dac_dds_init_0 (dac_dds_init_0[16*i+:16]),
      .dac_dds_incr_0 (dac_dds_incr_0[16*i+:16]),
      .dac_dds_scale_1 (dac_dds_scale_1[16*i+:16]),
      .dac_dds_init_1 (dac_dds_init_1[16*i+:16]),
      .dac_dds_incr_1 (dac_dds_incr_1[16*i+:16]),

      .dac_pat_data_0 (dac_pat_data_0[16*i+:16]),
      .dac_pat_data_1 (dac_pat_data_1[16*i+:16]),

      .dac_iqcor_enb (dac_iqcor_enb[i]),
      .dac_iqcor_coeff_1 (dac_iqcor_coeff_1[16*i+:16]),
      .dac_iqcor_coeff_2 (dac_iqcor_coeff_2[16*i+:16]),
      .dac_iqcor_data_in (dac_ddata_muxed[DMA_CDW*IQ_PAIR_CH_INDEX+:DMA_CDW])

    );
  end
  endgenerate

endmodule
