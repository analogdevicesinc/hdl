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

module pack_interconnect #(
  parameter PORT_DATA_WIDTH = 16,
  parameter PORT_ADDRESS_WIDTH = 3,
  parameter MUX_ORDER = 2,
  parameter NUM_STAGES = 2,
  parameter PACK = 0 // 0 = Unpack, 1 = Pack
) (
  input [2**PORT_ADDRESS_WIDTH*MUX_ORDER*NUM_STAGES-1:0] ctrl,

  input [PORT_DATA_WIDTH * 2**PORT_ADDRESS_WIDTH-1:0] data_in,
  output [PORT_DATA_WIDTH * 2**PORT_ADDRESS_WIDTH-1:0] data_out
);

  /*
   * This module implements the interconnect for pack or unpack core.
   * The interconnect is made up of NUM_STAGES stages. Each stage is made up of
   * multiple MUXs (one for each port) and a perfect shuffle.
   *
   * The number of inputs per MUX is 2**MUX_ORDER.
   * The number of ports is 2**PORT_ADDRESS_WIDTH.
   */

  localparam NUM_PORTS = 2**PORT_ADDRESS_WIDTH;
  localparam TOTAL_DATA_WIDTH = PORT_DATA_WIDTH * NUM_PORTS;

  wire [TOTAL_DATA_WIDTH-1:0] interconnect[0:NUM_STAGES];

  assign interconnect[0] = data_in;
  assign data_out = interconnect[NUM_STAGES];

  generate
    genvar i, j;

    localparam z = 2**MUX_ORDER;
    localparam w = PORT_DATA_WIDTH;
    localparam NUM_SWITCHES = NUM_PORTS / z;

    // Do perfect shuffle, either in forward or reverse direction
    for (i = 0; i < NUM_STAGES; i = i + 1) begin: gen_stages
      // Pack network are in the opposite direction
      localparam ctrl_stage = PACK ? NUM_STAGES - i - 1 : i;
      wire [TOTAL_DATA_WIDTH-1:0] shuffle_in;
      wire [TOTAL_DATA_WIDTH-1:0] shuffle_out;
      wire [TOTAL_DATA_WIDTH-1:0] mux_in;
      wire [TOTAL_DATA_WIDTH-1:0] mux_out;

      // Unpack uses forward shuffle and pack a reverse shuffle
      ad_perfect_shuffle #(
        .NUM_GROUPS (PACK ? NUM_SWITCHES : z),
        .WORDS_PER_GROUP (PACK ? z : NUM_SWITCHES),
        .WORD_WIDTH (w)
      ) i_shuffle (
        .data_in (shuffle_in),
        .data_out (shuffle_out));

      for (j = 0; j < NUM_PORTS; j = j + 1) begin: gen_ports
        localparam ctrl_base = (ctrl_stage * NUM_PORTS + j) * MUX_ORDER;
        localparam sel_base = j & ~(z-1); // base increments in 2**MUX_ORDER steps

        /*
         * To be able to better share MUX control signals and reduce overall
         * resource consumption the control signal gets rotated by the offset of
         * MUX in a switch.
         *
         * E.g. a control signal of 0 for the first MUX means that the first
         * input should be selected. A control signal of 0 for the second switch
         * means that the second input will be used. To implement this (j % z)
         * is added to the control signal when selecting the input bits. This
         * addition does not result in additional resources being used. It just
         * results in a different look-up table.
         */

        wire [MUX_ORDER-1:0] sel = ctrl[ctrl_base+:MUX_ORDER];// + j % z;
        assign mux_out[j*w+:w] = mux_in[(sel_base+sel)*w+:w];
      end

      /*
       * Pack is MUX followed by shuffle.
       * Unpack is shuffle followed by MUX.
       */
      if (PACK) begin
        assign mux_in = interconnect[i];
        assign shuffle_in = mux_out;
        assign interconnect[i+1] = shuffle_out;
      end else begin
        assign shuffle_in = interconnect[i];
        assign mux_in = shuffle_out;
        assign interconnect[i+1] = mux_out;
      end
  end
  endgenerate

endmodule
