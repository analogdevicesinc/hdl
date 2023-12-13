// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

module ad_ip_jesd204_tpl_dac_framer #(
  parameter NUM_LANES = 8,
  parameter NUM_CHANNELS = 4,
  parameter BITS_PER_SAMPLE = 16,
  parameter CONVERTER_RESOLUTION = 16,
  parameter SAMPLES_PER_FRAME = 2,
  parameter OCTETS_PER_BEAT = 4,
  parameter LINK_DATA_WIDTH = OCTETS_PER_BEAT * 8 * NUM_LANES,
  parameter DAC_DATA_WIDTH = LINK_DATA_WIDTH * CONVERTER_RESOLUTION / BITS_PER_SAMPLE
) (

  // jesd interface

  output [LINK_DATA_WIDTH-1:0] link_data,

  // dac interface

  input [DAC_DATA_WIDTH-1:0] dac_data
);

  /*
   * The framer module takes sample data and maps it onto the format that the
   * JESD204 link expects for the specified framer configuration.
   *
   * The input sample data in dac_data is expected to be grouped by converter.
   * The first sample is in the LSBs. Each sample has CONVERTER_RESOLUTION bits.
   *
   * Or in other words the data in dac_data is expected to have the following
   * layout.
   *
   *  MSB                                                                      LSB
   *   [ MmSn, ..., MmS1, MnS0, ..., M1Sn, ... M1S1, M1S0, M0Sn, ... M0S1, M0S0 ]
   *
   * Where MjSi refers to the i-th sample of the j-th converter. With m being
   * the number of converters and n the number of samples per converter per
   * beat.
   *
   * In the default configuration the framer module processes 4 octets per beat.
   * This means it can support settings with either 1, 2 or 4 octets per frame
   * (F). Depending on the octets per frame the frames per beat will either be
   * 4, 2 or 1 respectively. For other settings of OCTETS_PER_BEAT similar
   * reasoning applies.
   *
   * The number of samples per frame (S) and the number of frames processed per
   * beat gives the number of samples per converter per beat. This is either
   * S * 4 (for F=1), S * 2 (for F=2) or S (for F=1).
   *
   * The framer module does not have a parameter for the octets per frame (F)
   * since it can be derived from all other parameters given the following
   * relationship: F = (M * N' * S) / (L * 8)
   *
   *
   * Mapping in performed in two steps. First samples are grouped into frames,
   * as there might be more than one frame pert beat. In the second step the
   * frames are distributed onto the lanes.
   *
   * In the JESD204 standard samples and octets are ordered MSB first, this
   * means earlier data is in the MSBs. This core on the other hand expects
   * samples and octets to be LSB first ordered. This means earlier data is in
   * the LSBs. To accommodate this two additional steps are required to order
   * data from LSB to MSB before the framing process and back from MSB to LSB
   * after it.
   *
   * The data itself that is contained within the samples and octets is LSB
   * ordered in either case. That means lower bits are in the LSBs.
   */

  localparam BITS_PER_CHANNEL_PER_FRAME = BITS_PER_SAMPLE * SAMPLES_PER_FRAME;
  localparam BITS_PER_LANE_PER_FRAME = BITS_PER_CHANNEL_PER_FRAME *
                                       NUM_CHANNELS / NUM_LANES;
  localparam FRAMES_PER_BEAT = OCTETS_PER_BEAT * 8 / BITS_PER_LANE_PER_FRAME;
  localparam SAMPLES_PER_BEAT = DAC_DATA_WIDTH / CONVERTER_RESOLUTION;
  localparam TAIL_BITS = BITS_PER_SAMPLE - CONVERTER_RESOLUTION;

  wire [LINK_DATA_WIDTH-1:0] link_data_msb_s;
  wire [LINK_DATA_WIDTH-1:0] frame_data_s;
  wire [LINK_DATA_WIDTH-1:0] dac_data_msb;

  generate
    genvar i;
    genvar j;
    /* Reorder samples MSB first and insert tail bits */
    for (i = 0; i < SAMPLES_PER_BEAT; i = i + 1) begin: g_dac_data_msb
      localparam src_w = CONVERTER_RESOLUTION;
      localparam dst_w = BITS_PER_SAMPLE;
      localparam src_lsb = i * src_w;
      localparam dst_msb = LINK_DATA_WIDTH - 1 - i * dst_w;

      assign dac_data_msb[dst_msb-:src_w] = dac_data[src_lsb+:src_w];
      if (TAIL_BITS > 0) begin
        assign dac_data_msb[dst_msb-src_w-:TAIL_BITS] = {TAIL_BITS{1'b0}};
      end
    end

    /* Slice channel and pack it into frames */
    ad_perfect_shuffle #(
      .NUM_GROUPS (NUM_CHANNELS),
      .WORDS_PER_GROUP (FRAMES_PER_BEAT),
      .WORD_WIDTH (BITS_PER_CHANNEL_PER_FRAME)
    ) i_channels_to_frames (
      .data_in (dac_data_msb),
      .data_out (frame_data_s));

    /* Slice frame and pack it into lanes */
    ad_perfect_shuffle #(
      .NUM_GROUPS (FRAMES_PER_BEAT),
      .WORDS_PER_GROUP (NUM_LANES),
      .WORD_WIDTH (BITS_PER_LANE_PER_FRAME)
    ) i_frames_to_lanes (
      .data_in (frame_data_s),
      .data_out (link_data_msb_s));

    /* Reorder octets LSB first */
    for (i = 0; i < LINK_DATA_WIDTH; i = i + 8) begin: g_link_data
      assign link_data[i+:8] = link_data_msb_s[LINK_DATA_WIDTH-1-i-:8];
    end
  endgenerate

endmodule
