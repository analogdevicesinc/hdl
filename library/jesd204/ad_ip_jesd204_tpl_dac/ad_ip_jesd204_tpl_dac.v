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

module ad_ip_jesd204_tpl_dac #(
  parameter ID = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,
  parameter NUM_LANES = 4,
  parameter NUM_CHANNELS = 2,
  parameter SAMPLES_PER_FRAME = 1,
  parameter CONVERTER_RESOLUTION = 16, // JESD_N
  parameter BITS_PER_SAMPLE = 16,      // JESD_NP
  parameter DMA_BITS_PER_SAMPLE = 16,
  parameter PADDING_TO_MSB_LSB_N = 0,
  parameter OCTETS_PER_BEAT = 4,
  parameter DDS_TYPE = 1,
  parameter DDS_CORDIC_DW = 16,
  parameter DDS_CORDIC_PHASE_DW = 16,
  parameter DATAPATH_DISABLE = 0,
  parameter IQCORRECTION_DISABLE = 1,
  parameter EXT_SYNC = 0,
  parameter XBAR_ENABLE = 0
) (

  // jesd interface
  // link_clk is (line-rate/40)

  input link_clk,
  output link_valid,
  input link_ready,
  output [NUM_LANES*8*OCTETS_PER_BEAT*2-1:0] link_data,

  // dma interface
  output [NUM_CHANNELS-1:0] enable,

  input [NUM_CHANNELS-1:0] dac_valid,
  input [DMA_BITS_PER_SAMPLE * OCTETS_PER_BEAT * 8 * NUM_LANES / BITS_PER_SAMPLE-1:0] dac_ddata
);

  localparam DATA_PATH_WIDTH = OCTETS_PER_BEAT * 8 * NUM_LANES / NUM_CHANNELS / BITS_PER_SAMPLE;
  localparam LINK_DATA_WIDTH = NUM_LANES * OCTETS_PER_BEAT * 8 * 2;
  localparam DMA_DATA_WIDTH = DMA_BITS_PER_SAMPLE * DATA_PATH_WIDTH * NUM_CHANNELS;

  localparam BYTES_PER_FRAME = (NUM_CHANNELS * BITS_PER_SAMPLE * SAMPLES_PER_FRAME) / ( 8 * NUM_LANES);

  // Just bridge the signals
  assign link_valid = dac_valid[0]; // They are the same anyway (see upack_hw.tcl)
  assign enable = {NUM_CHANNELS{link_ready}};
  generate
    genvar i;
    localparam DW = OCTETS_PER_BEAT * 8;
    for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: gen_dac_intel_ip
      assign link_data[2*i*DW   +:DW] = {DW{1'b0}};
      assign link_data[2*i*DW+DW+:DW] = dac_ddata[i*DW+:DW];
    end
 endgenerate

endmodule
