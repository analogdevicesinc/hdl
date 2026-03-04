// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023, 2026 Analog Devices, Inc. All rights reserved.
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
  parameter PACK = 0, // 0 = Unpack, 1 = Pack
  parameter PIPELINE_STAGES = 0, // 0 = no pipeline, 1 = pipeline every 2 stages, 2 = pipeline every stage
  parameter PIPELINE_OFFSET = 0  // Cumulative pipeline delay from previous networks
) (
  input clk,
  (* max_fanout = 100 *) input ce,  // Clock enable for data pipeline registers
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
  localparam CTRL_WIDTH_PER_STAGE = NUM_PORTS * MUX_ORDER;

  wire [TOTAL_DATA_WIDTH-1:0] interconnect_comb[0:NUM_STAGES];
  wire [TOTAL_DATA_WIDTH-1:0] interconnect[0:NUM_STAGES];

  assign interconnect_comb[0] = data_in;
  assign data_out = interconnect[NUM_STAGES];

  /*
   * Function to calculate cumulative pipeline delay for each stage.
   * The control signals for each stage must be delayed to match when data arrives.
   */
  function integer calc_ctrl_delay;
    input integer stage;
    integer delay;
    integer s;
    begin
      delay = 0;
      for (s = 1; s <= stage; s = s + 1) begin
        if (PIPELINE_STAGES == 2) begin
          delay = delay + 1;
        end else if (PIPELINE_STAGES == 1 && s % 2 == 0) begin
          delay = delay + 1;
        end
      end
      calc_ctrl_delay = delay;
    end
  endfunction

  // Generate pipeline stages between MUX stages for DATA path
  generate
    genvar p;
    for (p = 0; p <= NUM_STAGES; p = p + 1) begin: gen_pipeline
      // PIPELINE_STAGES=0: no pipelining
      // PIPELINE_STAGES=1: pipeline after every 2 MUX stages (at p=2,4,6,...)
      // PIPELINE_STAGES=2: pipeline after every MUX stage (at p=1,2,3,...)
      localparam SHOULD_REGISTER = (PIPELINE_STAGES == 2 && p > 0) ||
                                   (PIPELINE_STAGES == 1 && p > 0 && p % 2 == 0);

      if (SHOULD_REGISTER == 0) begin
        // No pipeline register, pass through
        assign interconnect[p] = interconnect_comb[p];
      end else begin
        // Pipeline register advances only when ce is asserted
        // This ensures data pipeline timing matches ce-gated control signals
        (* shreg_extract = "no" *) reg [TOTAL_DATA_WIDTH-1:0] data_pipe = {TOTAL_DATA_WIDTH{1'b0}};
        always @(posedge clk) begin
          if (ce == 1'b1) begin
            data_pipe <= interconnect_comb[p];
          end
        end
        assign interconnect[p] = data_pipe;
      end
    end
  endgenerate

  generate
    genvar i, j;

    localparam z = 2**MUX_ORDER;
    localparam w = PORT_DATA_WIDTH;
    localparam NUM_SWITCHES = NUM_PORTS / z;

    // Do perfect shuffle, either in forward or reverse direction
    for (i = 0; i < NUM_STAGES; i = i + 1) begin: gen_stages
      // Pack network are in the opposite direction
      localparam ctrl_stage = PACK ? NUM_STAGES - i - 1 : i;

      // Calculate cumulative delay for this stage control signals
      // Include PIPELINE_OFFSET from previous networks
      localparam CTRL_DELAY = calc_ctrl_delay(i) + PIPELINE_OFFSET;

      wire [TOTAL_DATA_WIDTH-1:0] shuffle_in;
      wire [TOTAL_DATA_WIDTH-1:0] shuffle_out;
      wire [TOTAL_DATA_WIDTH-1:0] mux_in;
      wire [TOTAL_DATA_WIDTH-1:0] mux_out;

      wire [CTRL_WIDTH_PER_STAGE-1:0] ctrl_stage_in;
      wire [CTRL_WIDTH_PER_STAGE-1:0] ctrl_stage_delayed;

      // Extract control bits for this stage
      assign ctrl_stage_in = ctrl[ctrl_stage*CTRL_WIDTH_PER_STAGE +: CTRL_WIDTH_PER_STAGE];

      // Delay control signals to match ce-gated data pipeline latency
      // Control signals must also be ce-gated to maintain timing alignment
      if (CTRL_DELAY == 0) begin: gen_ctrl_comb
        assign ctrl_stage_delayed = ctrl_stage_in;
      end else begin: gen_ctrl_pipe
        (* shreg_extract = "no" *) reg [CTRL_WIDTH_PER_STAGE-1:0] ctrl_sr [0:CTRL_DELAY-1];
        integer ci, cj;
        initial begin
          for (ci = 0; ci < CTRL_DELAY; ci = ci + 1)
            ctrl_sr[ci] = {CTRL_WIDTH_PER_STAGE{1'b0}};
        end
        always @(posedge clk) begin
          if (ce == 1'b1) begin
            ctrl_sr[0] <= ctrl_stage_in;
            for (cj = 1; cj < CTRL_DELAY; cj = cj + 1)
              ctrl_sr[cj] <= ctrl_sr[cj-1];
          end
        end
        assign ctrl_stage_delayed = ctrl_sr[CTRL_DELAY-1];
      end

      // Unpack uses forward shuffle and pack a reverse shuffle
      ad_perfect_shuffle #(
        .NUM_GROUPS (PACK ? NUM_SWITCHES : z),
        .WORDS_PER_GROUP (PACK ? z : NUM_SWITCHES),
        .WORD_WIDTH (w)
      ) i_shuffle (
        .data_in (shuffle_in),
        .data_out (shuffle_out));

      for (j = 0; j < NUM_PORTS; j = j + 1) begin: gen_ports
        localparam ctrl_offset = j * MUX_ORDER;
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

        // Use delayed control signals for proper timing alignment
        wire [MUX_ORDER-1:0] sel = ctrl_stage_delayed[ctrl_offset+:MUX_ORDER];
        assign mux_out[j*w+:w] = mux_in[(sel_base+sel)*w+:w];
      end

      /*
       * Pack is MUX followed by shuffle.
       * Unpack is shuffle followed by MUX.
       * Read from interconnect (pipelined) and write to interconnect_comb (combinational).
       */
      if (PACK) begin
        assign mux_in = interconnect[i];
        assign shuffle_in = mux_out;
        assign interconnect_comb[i+1] = shuffle_out;
      end else begin
        assign shuffle_in = interconnect[i];
        assign mux_in = shuffle_out;
        assign interconnect_comb[i+1] = mux_out;
      end
  end
  endgenerate

endmodule
