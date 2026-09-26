// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023, 2025-2026 Analog Devices, Inc. All rights reserved.
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

module pack_shell #(
  parameter NUM_OF_CHANNELS = 4,
  parameter SAMPLES_PER_CHANNEL = 1,
  parameter SAMPLE_DATA_WIDTH = 16,
  parameter PACK = 0,
  parameter PARALLEL_OR_SERIAL_N = 0,
  parameter PIPELINE_STAGES = 0
) (
  input clk,
  input reset,

  output reg reset_data = 1'b0,

  input [NUM_OF_CHANNELS-1:0] enable,

  input ce,
  input flush,

  output ready,
  input [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] in_data,

  output [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] out_data,
  output out_sync,
  output [NUM_OF_CHANNELS*SAMPLES_PER_CHANNEL-1:0] out_valid
);

  // If the number of active channels can be a non-power of two
  localparam NON_POWER_OF_TWO = NUM_OF_CHANNELS > 2;

  localparam CHANNEL_DATA_WIDTH = SAMPLES_PER_CHANNEL * SAMPLE_DATA_WIDTH;

  localparam TOTAL_DATA_WIDTH = CHANNEL_DATA_WIDTH * NUM_OF_CHANNELS;
  localparam NUM_OF_SAMPLES = NUM_OF_CHANNELS * SAMPLES_PER_CHANNEL;
  localparam LOG2_NUM_OF_SAMPLES = $clog2(NUM_OF_SAMPLES);

  // Function to calculate pipeline latency for a given number of MUX stages.
  function integer calc_pipeline_latency;
    input integer num_stages;
    begin
      if (PIPELINE_STAGES == 2)
        calc_pipeline_latency = num_stages;
      else if (PIPELINE_STAGES == 1)
        calc_pipeline_latency = num_stages / 2;
      else
        calc_pipeline_latency = 0;
    end
  endfunction

  /*
   * Reset and control signals for the state machine. Data and control have
   * separate resets since control is pipelined and needs to be taken out of
   * reset before data so it can compute the control signals for the first data
   * cycle.
   */
  reg reset_ctrl = 1'b1;
  reg startup_ctrl = 1'b0;
  reg startup_ctrl2 = 1'b0;
  reg [NUM_OF_CHANNELS-1:0] enable_int = 'h00;

  /*
   * Internal copy of the enable signals. This is used to detect changes in the
   * channel selection and reset the internal state when that happens.
   */
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      enable_int <= {NUM_OF_CHANNELS{1'b0}};
    end else begin
      enable_int <= enable;
    end
  end

  /*
   * The internal state is reset whenever the selected channels change. The
   * control path is pipelined and computed one clock cycle in advance. This
   * means the control path needs to be taken out of reset one clock cycle
   * before the data path and a special startup cycles are required to compute
   * the first sets of control signals.
   *
   * In the case where there is only one channel no control signals are needed
   * and hence no startup cycle. In the case where there are two channels the
   * control signal pipeline is one cycle, so one startup cycle is required. For
   * more than two channels the startup pipeline is two channels and two startup
   * cycles are required.
   */
  always @(posedge clk) begin
    if (reset == 1'b1 || enable == {NUM_OF_CHANNELS{1'b0}}) begin
      reset_ctrl <= 1'b1;
      reset_data <= 1'b1;
      startup_ctrl <= 1'b0;
      startup_ctrl2 <= 1'b0;
    end else if (enable != enable_int) begin
      reset_ctrl <= 1'b1;
      reset_data <= 1'b1;
      startup_ctrl <= 1'b1;
      startup_ctrl2 <= 1'b1;
    end else begin
      reset_ctrl <= 1'b0;
      reset_data <= NUM_OF_CHANNELS != 1 ? startup_ctrl2 : 1'b0;
      startup_ctrl2 <= NON_POWER_OF_TWO && PACK == 0 ? reset_ctrl : 1'b0;
      startup_ctrl <= reset_ctrl | startup_ctrl2;
    end
  end

  generate
    if (NUM_OF_CHANNELS == 1) begin
      /*
       * In the one channel case there is not much to do. Nevertheless we should
       * support it to allow generic designs where the number of channels is
       * selected programmatically.
       */
      assign out_data = in_data;
      assign out_sync = 1'b1;
      assign out_valid = {NUM_OF_SAMPLES{1'b1}};
      assign ready = ce & ~reset_data;
    end else begin
      localparam
        SAMPLE_ADDRESS_WIDTH = NUM_OF_SAMPLES > 512 ? 10 :
        NUM_OF_SAMPLES > 256 ? 9 :
        NUM_OF_SAMPLES > 128 ? 8 :
        NUM_OF_SAMPLES > 64 ? 7 :
        NUM_OF_SAMPLES > 32 ? 6 :
        NUM_OF_SAMPLES > 16 ? 5 :
        NUM_OF_SAMPLES > 8 ? 4 :
        NUM_OF_SAMPLES > 4 ? 3 :
        NUM_OF_SAMPLES > 2 ? 2 : 1;

      /*
       * Calculate total pipeline latency from all pack_network stages.
       * For PACK mode:
       *   gen_network[0]: SAMPLE_ADDRESS_WIDTH / 2 stages (4:1 MUX)
       *   gen_network[1]: SAMPLE_ADDRESS_WIDTH % 2 stages (2:1 MUX)
       * For UNPACK mode:
       *   i_ext_ctrl_interconnect: 1 stage (only if NON_POWER_OF_TWO)
       *   gen_network[0]: (SAMPLE_ADDRESS_WIDTH - NON_POWER_OF_TWO) / 2 stages
       *   gen_network[1]: (SAMPLE_ADDRESS_WIDTH - NON_POWER_OF_TWO) % 2 stages
       */
      localparam
        NETWORK0_STAGES = PACK ? (SAMPLE_ADDRESS_WIDTH / 2) :
        ((SAMPLE_ADDRESS_WIDTH - NON_POWER_OF_TWO) / 2);
      localparam
        NETWORK1_STAGES = PACK ? (SAMPLE_ADDRESS_WIDTH % 2) :
        ((SAMPLE_ADDRESS_WIDTH - NON_POWER_OF_TWO) % 2);
      localparam EXT_NETWORK_STAGES = (NON_POWER_OF_TWO == 1 && PACK == 0) ? 1 : 0;

      localparam
        TOTAL_PIPELINE_LATENCY = calc_pipeline_latency(NETWORK0_STAGES) +
        calc_pipeline_latency(NETWORK1_STAGES) +
        calc_pipeline_latency(EXT_NETWORK_STAGES);

      /*
       * Internal versions of control signals before pipeline delay.
       * These are delayed by TOTAL_PIPELINE_LATENCY clock enable cycles to match the
       * ce-gated data path latency through the pack/unpack network.
       *
       * When PIPELINE_STAGES > 0, the data pipeline is ce-gated and control
       * signal delays must also be ce-gated to maintain alignment.
       */
      reg ready_int = 1'b0;
      wire out_sync_int;
      wire [NUM_OF_SAMPLES-1:0] out_valid_int;

      /*
       * Unpack must produce an output word a fixed number of cycles after
       * each read, whether or not input data was available, so its routing
       * network is a pure retiming that advances every clock; the consumer
       * delays its read strobes by TOTAL_PIPELINE_LATENCY clocks. `ready` then
       * refers to the unpipelined input side and must not be delayed.
       */
      wire pipe_ce = PACK ? ce : 1'b1;

      // Ce-gated pipeline delay for ready signal
      // TOTAL_PIPELINE_LATENCY stages of ce-gated delay to match data pipeline
      if (TOTAL_PIPELINE_LATENCY == 0 || PACK == 0) begin: gen_ready_comb
        assign ready = ready_int;
      end else begin: gen_ready_pipe
        (* shreg_extract = "no" *) reg [TOTAL_PIPELINE_LATENCY-1:0] ready_sr = 'h0;
        integer ri;
        always @(posedge clk) begin
          if (reset_ctrl == 1'b1) begin
            ready_sr <= 'h0;
          end else if (ce == 1'b1) begin
            ready_sr[0] <= ready_int;
            for (ri = 1; ri < TOTAL_PIPELINE_LATENCY; ri = ri + 1)
              ready_sr[ri] <= ready_sr[ri-1];
          end
        end
        assign ready = ready_sr[TOTAL_PIPELINE_LATENCY-1];
      end

      // Ce-gated pipeline delay for out_sync signal
      if (TOTAL_PIPELINE_LATENCY == 0) begin: gen_sync_comb
        assign out_sync = out_sync_int;
      end else begin: gen_sync_pipe
        (* shreg_extract = "no" *) reg [TOTAL_PIPELINE_LATENCY-1:0] sync_sr = 'h0;
        integer si;
        always @(posedge clk) begin
          if (reset_ctrl == 1'b1) begin
            sync_sr <= 'h0;
          end else if (ce == 1'b1) begin
            sync_sr[0] <= out_sync_int;
            for (si = 1; si < TOTAL_PIPELINE_LATENCY; si = si + 1)
              sync_sr[si] <= sync_sr[si-1];
          end
        end
        assign out_sync = sync_sr[TOTAL_PIPELINE_LATENCY-1];
      end

      // Ce-gated pipeline delay for out_valid signal
      if (TOTAL_PIPELINE_LATENCY == 0) begin: gen_valid_comb
        assign out_valid = out_valid_int;
      end else begin: gen_valid_pipe
        (* shreg_extract = "no" *) reg [NUM_OF_SAMPLES-1:0] valid_sr [0:TOTAL_PIPELINE_LATENCY-1];
        integer vi, vj;
        initial begin
          for (vi = 0; vi < TOTAL_PIPELINE_LATENCY; vi = vi + 1)
            valid_sr[vi] = {NUM_OF_SAMPLES{1'b0}};
        end
        always @(posedge clk) begin
          if (reset_ctrl == 1'b1) begin
            for (vj = 0; vj < TOTAL_PIPELINE_LATENCY; vj = vj + 1)
              valid_sr[vj] <= {NUM_OF_SAMPLES{1'b0}};
          end else if (ce == 1'b1) begin
            valid_sr[0] <= out_valid_int;
            for (vj = 1; vj < TOTAL_PIPELINE_LATENCY; vj = vj + 1)
              valid_sr[vj] <= valid_sr[vj-1];
          end
        end
        assign out_valid = valid_sr[TOTAL_PIPELINE_LATENCY-1];
      end

      /*
       * `rotate` is used as an offset into the input data vector. When not all
       * samples are enabled it can take multiple cycles for the input vector to
       * be consumed. `rotate` points to the first sample in the input vector
       * that should consumed next. E.g. when there are 4 channels, but only 2
       * are enabled `rotate` will oscillate between 0 and 2. If there are 4
       * channels and 3 are enabled it will cycle through the sequence 0, 3, 2,
       * 1.
       */
      reg [SAMPLE_ADDRESS_WIDTH-1:0] rotate = 'h00;

      /*
      * `prefix_count` counts the number of disabled channels that precede a
      * channel. E.g. if channel 0 is enabled and channel 1 and 2 are disabled
      * the prefix count for channel 3 is 2.
      */
      reg [SAMPLE_ADDRESS_WIDTH*NUM_OF_SAMPLES-1:0] prefix_count;

      /*
       * Clock enable for all the control signals. When asserted the next cycle
       * for the control signals should computed
       */
      wire ce_ctrl;

      /*
       * Used to connect the different intermediary stages of the routing
       * network. There can be up to three sub-networks.
       */
      wire [TOTAL_DATA_WIDTH-1:0] data[0:2];

      /*
       * Unregistered version of `prefix_count`. This is used to add up the
       * enable ports.
       */
      wire [SAMPLE_ADDRESS_WIDTH-1:0] prefix_count_s[0:NUM_OF_SAMPLES];

      /*
       * Control pipeline is active and should compute the next state either
       * during the startup phase or when a output data set is consumed.
       */
      assign ce_ctrl = startup_ctrl | ce;

      /*
       * The prefix sum is computed in two register stages to keep its adders
       * out of a single cycle. The samples are split into blocks of
       * PREFIX_BLOCK. The first stage registers the running count of disabled
       * samples within each block and the second stage adds the count of all
       * preceding blocks. The first stage is computed from the same
       * expression that loads `enable_int`, so its registers always hold the
       * value `enable_int` would produce and `prefix_count_s` keeps its
       * original timing. PARALLEL_OR_SERIAL_N selects a log-depth or a serial
       * adder structure inside both stages.
       */
      localparam PREFIX_BLOCK_LOG2 = (LOG2_NUM_OF_SAMPLES + 1) / 2;
      localparam PREFIX_BLOCK = 2**PREFIX_BLOCK_LOG2;
      localparam PREFIX_NUM_BLOCKS = (NUM_OF_SAMPLES + PREFIX_BLOCK - 1) / PREFIX_BLOCK;
      localparam PREFIX_NUM_BLOCKS_LOG2 = PREFIX_NUM_BLOCKS > 1 ? $clog2(PREFIX_NUM_BLOCKS) : 0;

      wire [NUM_OF_CHANNELS-1:0] enable_next = reset == 1'b1 ? {NUM_OF_CHANNELS{1'b0}} : enable;

      /*
       * Samples are interleaved, so the sample mask is just the channel mask
       * concatenated with itself SAMPLES_PER_CHANNEL times.
       */
      wire [NUM_OF_SAMPLES-1:0] samples_enable_next = {SAMPLES_PER_CHANNEL{enable_next}};

      /* Running count of disabled samples inside each block, inclusive. */
      wire [SAMPLE_ADDRESS_WIDTH-1:0] block_count_s[0:PREFIX_BLOCK_LOG2][0:NUM_OF_SAMPLES-1];
      wire [SAMPLE_ADDRESS_WIDTH-1:0] block_count_next[0:NUM_OF_SAMPLES-1];
      wire [SAMPLE_ADDRESS_WIDTH-1:0] block_count[0:NUM_OF_SAMPLES-1];

      /* Number of disabled samples in all blocks preceding a block. */
      wire [SAMPLE_ADDRESS_WIDTH-1:0] block_offset_s[0:PREFIX_NUM_BLOCKS_LOG2][0:PREFIX_NUM_BLOCKS-1];
      wire [SAMPLE_ADDRESS_WIDTH-1:0] block_offset[0:PREFIX_NUM_BLOCKS-1];
      wire [SAMPLE_ADDRESS_WIDTH-1:0] block_total[0:PREFIX_NUM_BLOCKS-1];

      genvar i, j;
      for (i = 0; i < NUM_OF_SAMPLES; i = i + 1) begin: gen_block_count
        /*
         * Do not write this as ~samples_enable_next[i]: the operand is
         * widened to the full width before the inversion.
         */
        assign block_count_s[0][i] = samples_enable_next[i] ? 1'b0 : 1'b1;

        for (j = 1; j <= PREFIX_BLOCK_LOG2; j = j + 1) begin: gen_row
          if (PARALLEL_OR_SERIAL_N == 1 && i % PREFIX_BLOCK >= 2**(j-1)) begin
            assign block_count_s[j][i] = block_count_s[j-1][i] + block_count_s[j-1][i-2**(j-1)];
          end else if (PARALLEL_OR_SERIAL_N == 0 && j == PREFIX_BLOCK_LOG2 && i % PREFIX_BLOCK != 0) begin
            assign block_count_s[j][i] = block_count_next[i-1] + block_count_s[0][i];
          end else begin
            assign block_count_s[j][i] = block_count_s[j-1][i];
          end
        end

        assign block_count_next[i] = block_count_s[PREFIX_BLOCK_LOG2][i];

        /* Power-up value matches `enable_int` = 0, i.e. all samples disabled */
        reg [SAMPLE_ADDRESS_WIDTH-1:0] block_count_r = (i % PREFIX_BLOCK) + 1;

        always @(posedge clk) begin
          block_count_r <= block_count_next[i];
        end

        assign block_count[i] = block_count_r;
      end

      for (i = 0; i < PREFIX_NUM_BLOCKS; i = i + 1) begin: gen_block_offset
        localparam LAST = (i + 1) * PREFIX_BLOCK - 1 < NUM_OF_SAMPLES ? (i + 1) * PREFIX_BLOCK - 1 : NUM_OF_SAMPLES - 1;

        /* Row 0 holds the total of the preceding block, shifted by one. */
        if (i == 0) begin
          assign block_offset_s[0][i] = 'h0;
        end else begin
          assign block_offset_s[0][i] = block_total[i-1];
        end
        assign block_total[i] = block_count[LAST];

        for (j = 1; j <= PREFIX_NUM_BLOCKS_LOG2; j = j + 1) begin: gen_row
          if (PARALLEL_OR_SERIAL_N == 1 && i >= 2**(j-1)) begin
            assign block_offset_s[j][i] = block_offset_s[j-1][i] + block_offset_s[j-1][i-2**(j-1)];
          end else if (PARALLEL_OR_SERIAL_N == 0 && j == PREFIX_NUM_BLOCKS_LOG2 && i > 0) begin
            assign block_offset_s[j][i] = block_offset[i-1] + block_offset_s[0][i];
          end else begin
            assign block_offset_s[j][i] = block_offset_s[j-1][i];
          end
        end

        assign block_offset[i] = block_offset_s[PREFIX_NUM_BLOCKS_LOG2][i];
      end

      /* First channel has no other channels before it */
      assign prefix_count_s[0] = 'h0;

      for (i = 0; i < NUM_OF_SAMPLES; i = i + 1) begin: gen_prefix_count
        assign prefix_count_s[i+1] = block_offset[i / PREFIX_BLOCK] + block_count[i];

        if (i < 2 || NUM_OF_CHANNELS <= 2) begin
          /* This will only be one bit, no need to register it */
          always @(prefix_count_s[i]) begin
            prefix_count[i*SAMPLE_ADDRESS_WIDTH+:SAMPLE_ADDRESS_WIDTH] <= prefix_count_s[i];
          end
        end else begin
          always @(posedge clk) begin
            prefix_count[i*SAMPLE_ADDRESS_WIDTH+:SAMPLE_ADDRESS_WIDTH] <= prefix_count_s[i];
          end
        end
      end

      /*
       * Number of enabled channels - 1. Zero enabled channels is not a valid
       * configuration and storing it this way allows for better utilization.
       */
      reg [SAMPLE_ADDRESS_WIDTH-1:0] enable_count = 'h0;

      always @(posedge clk) begin
        /*
         * `prefix_count` tracks the number of disabled channels. Invert it to
         * get the number of enabled channels - 1
         */
        enable_count <= ~prefix_count_s[NUM_OF_SAMPLES];
      end

      if (NON_POWER_OF_TWO == 1 && PACK == 0) begin: gen_input_buffer
        /* Delayed data vector. Data from the previous cycle. */
        reg [TOTAL_DATA_WIDTH-2*CHANNEL_DATA_WIDTH-1:0] data_d1 = 'h00;

        /*
         * Same as `rotate`, but two pipeline stages ahead of the data path.
         * This is needed to compute some of the other control signals ahead of
         * time.
         */
        reg [SAMPLE_ADDRESS_WIDTH:0] rotate_next;

        /*
         * MSB of the rotate control signal. This is used to move the source
         * data index to the delayed data vector. This will only ever be
         * asserted for one clock cycle at a time.
         */
        reg rotate_msb = 1'b0;

        /*
         * Extended version of the normal control and data signals that can
         * handle 2*NUM_OF_CHANNELS channels.
         */
        wire [(SAMPLE_ADDRESS_WIDTH+1)*(2*NUM_OF_SAMPLES)-1:0] ext_prefix_count;
        wire [TOTAL_DATA_WIDTH*2-1:0] ext_data_in;
        wire [TOTAL_DATA_WIDTH*2-1:0] ext_data_out;
        wire [TOTAL_DATA_WIDTH*2-1:0] ext_data_shuffled;
        wire [SAMPLE_ADDRESS_WIDTH:0] rotate_next_next;

        /*
         * This stage needs to handle 2*NUM_OF_CHANNELS channels so the prefix
         * count needs to padded with an extra bit.
         */
        for (i = 0; i < NUM_OF_SAMPLES; i = i + 1) begin: gen_ext_prefix_count1
          assign ext_prefix_count[i*(SAMPLE_ADDRESS_WIDTH+1)+:SAMPLE_ADDRESS_WIDTH+1] = {1'b0,prefix_count[i*SAMPLE_ADDRESS_WIDTH+:SAMPLE_ADDRESS_WIDTH]};
        end

        /*
         * The inversion and the addition of the constant will be folded into
         * the LUT that generates the control signals. This does not use up any
         * extra resources.
         */
        for (i = NUM_OF_SAMPLES; i < NUM_OF_SAMPLES * 2; i = i + 1) begin: gen_ext_prefix_count2
          assign ext_prefix_count[i*(SAMPLE_ADDRESS_WIDTH+1)+:SAMPLE_ADDRESS_WIDTH+1] = ~enable_count + i;
        end

        /*
         * For non power of two channel masks the previous data needs to be
         * saved since a single read can span over two consecutive input data
         * words. The lower two channels don't need to be saved since there are
         * no configurations in which they'd be required.
         */
        always @(posedge clk) begin
          if (ce == 1'b1 && ready_int == 1'b1) begin
            data_d1 <= in_data[TOTAL_DATA_WIDTH-1:2*CHANNEL_DATA_WIDTH];
          end
        end

        /* Three pipeline steps ahead of data */
        assign rotate_next_next = rotate_next[SAMPLE_ADDRESS_WIDTH-1:0] + enable_count + 1'b1;

        always @(posedge clk) begin
          if (reset_ctrl == 1'b1) begin
            ready_int <= 1'b0;
            rotate_msb <= 1'b0;

            rotate <= 'h0;
            rotate_next <= 'h0;
          end else if (ce_ctrl == 1'b1) begin
            ready_int <= 1'b0;
            rotate_msb <= 1'b0;

            /*
             * If the next cycle will consume more data than what is still
             * available ready needs to be asserted and the network needs to be
             * updated to source data from the delayed data register.
             */
            if (rotate_next_next[SAMPLE_ADDRESS_WIDTH] &
                |rotate_next_next[SAMPLE_ADDRESS_WIDTH-1:0]) begin
              ready_int <= 1'b1;
              rotate_msb <= 1'b1;
            end
            /*
             * If the current cycle consumes all available data ready needs to
             * be asserted, but only if it wasn't already asserted on the
             * previous cycle due to overconsumption.
             */
            if (rotate_next[SAMPLE_ADDRESS_WIDTH] == 1'b1 && rotate_msb == 1'b0) begin
              ready_int <= 1'b1;
            end

            rotate <= rotate_next;
            rotate_next <= rotate_next_next;
          end
        end

        /*
         * First stage of the routing network. We know that we have at least 4
         * channels and hence 8 input to the network, so we'll always use a
         * 4-MUX based stage here.
         */
        pack_network #(
          .PORT_ADDRESS_WIDTH (SAMPLE_ADDRESS_WIDTH + 1),
          .MUX_ORDER (2),
          .MIN_STAGE (0),
          .NUM_STAGES (1),
          .PORT_DATA_WIDTH (SAMPLE_DATA_WIDTH),
          .PIPELINE_STAGES (PIPELINE_STAGES),
          .PIPELINE_OFFSET (0)
        ) i_ext_ctrl_interconnect (
          .clk (clk),
          .ce_ctrl (ce_ctrl),
          .ce (pipe_ce),

          .rotate ({rotate_msb,rotate}),
          .prefix_count (ext_prefix_count),

          .data_in (ext_data_in),
          .data_out (ext_data_out));

        /*
         * In order to go from this stage that has 2 * NUM_OF_SAMPLES inputs
         * and output to the remainder of the network that has only NUM_OF_SAMPLES
         * inputs and outputs every second two ports need to be skipped. I.e.
         * port 2, 3, 6, 7...
         * The shuffle groups all ports that are wanted into the first half of
         * `ext_data_shuffled` and the unwanted ports into the second half which
         * will be discarded.
         */
        ad_perfect_shuffle #(
          .NUM_GROUPS (NUM_OF_SAMPLES / 2),
          .WORDS_PER_GROUP (2),
          .WORD_WIDTH (2 * SAMPLE_DATA_WIDTH)
        ) i_ext_shuffle (
          .data_in (ext_data_out),
          .data_out (ext_data_shuffled));

        assign ext_data_in = {data_d1,{2*CHANNEL_DATA_WIDTH{1'b0}},in_data};
        assign data[0] = ext_data_shuffled[0+:TOTAL_DATA_WIDTH];
      end else begin
        always @(posedge clk) begin
          if (reset_ctrl == 1'b1) begin
            ready_int <= 1'b0;
            rotate <= 'h0;
          end else if (ce_ctrl == 1'b1) begin
            /*
             * When all samples in the input vector has been consumed ready is
             * asserted for a single clock cycle. Here the number of enabled
             * channels is always a power of two. That means the input vector is
             * evenly divisible into the output data and there is no fractional
             * residual data. I.e. when ready is asserted rotate is 0.
             */
            {ready_int,rotate} <= rotate + enable_count + 1'b1;
          end else if (flush == 1'b1) begin
            /*
             * Downstream backpressure: discard any partial accumulation so the
             * next enabled window starts on a clean word boundary.
             */
            ready_int <= 1'b0;
            rotate <= 'h0;
          end
          /*
           * Only flush clears the alignment. A plain `ce_ctrl` gap means no
           * data moved, so the alignment must not move either: every other
           * state element in this module freezes on a gap the same way.
           * Clearing `ready` on such a gap would clear it one cycle too late to
           * be restored, and the beat that arrives in the cycle right after the
           * gap would be written into the output register without a write
           * enable, so it would be lost. A gapless producer never takes this
           * path at all, so its behaviour is unchanged.
           */
        end

        assign data[0] = in_data;
      end

      /*
       * The routing network can be built from any type of MUX. When it comes to
       * resource usage 2:1 MUXes and 4:1 MUXes are the most efficient, both will
       * require the same amount of LUTs. But a network built from 4:1 MUXes only uses
       * half the number of stages of a network built from 2:1 MUXes, so it has a
       * shorter routing delay and is the preferred architecture.
       *
       * For a pure 4:1 MUX network the number of ports is a power of 4. For a 2:1 MUX
       * network the number of ports is a power of 2. To get the best from both worlds
       * build the last stage from 2:1 MUXes when the number of ports is a power of
       * 2 and use 4:1 MUXes for the other stages.
       */
      for (i = 0; i < 2; i = i + 1) begin: gen_network
        localparam MUX_ORDER = i == 0 ? 2 : 1;
        localparam
          MIN_STAGE = PACK ? (i == 0 ? SAMPLE_ADDRESS_WIDTH % 2 : 0) :
          (i == 0 ? NON_POWER_OF_TWO : SAMPLE_ADDRESS_WIDTH - 1);
        localparam
          NUM_STAGES = PACK ?
          (i == 0 ? SAMPLE_ADDRESS_WIDTH / 2 : SAMPLE_ADDRESS_WIDTH % 2) :
          (i == 0 ? (SAMPLE_ADDRESS_WIDTH - NON_POWER_OF_TWO) / 2 :
          (SAMPLE_ADDRESS_WIDTH - NON_POWER_OF_TWO) % 2);
        // Cumulative pipeline delay from previous networks
        // gen_network[0]: includes ext network latency (if present)
        // gen_network[1]: includes ext network + gen_network[0] latency
        localparam
          PIPELINE_OFFSET = (i == 0) ?
          calc_pipeline_latency(EXT_NETWORK_STAGES) :
          calc_pipeline_latency(EXT_NETWORK_STAGES) +
          calc_pipeline_latency(NETWORK0_STAGES);

        if (NUM_STAGES > 0) begin
          pack_network #(
            .PACK (PACK),
            .PORT_ADDRESS_WIDTH (SAMPLE_ADDRESS_WIDTH),
            .MUX_ORDER (MUX_ORDER),
            .MIN_STAGE (MIN_STAGE),
            .NUM_STAGES (NUM_STAGES),
            .PORT_DATA_WIDTH (SAMPLE_DATA_WIDTH),
            .PIPELINE_STAGES (PIPELINE_STAGES),
            .PIPELINE_OFFSET (PIPELINE_OFFSET)
          ) i_ctrl_interconnect (
            .clk (clk),
            .ce_ctrl (ce_ctrl),
            .ce (pipe_ce),

            .rotate (rotate),
            .prefix_count (prefix_count),

            .data_in (data[i]),
            .data_out (data[i+1]));
        end else begin
          assign data[i+1] = data[i];
        end
      end

      if (PACK == 1) begin: gen_pack
        /*
         * Mask the qualifies the samples in the out_data vector. There is on
         * entry for each sample. If the entry is 1 that means the corresponding
         * sample has valid data. If the entry is 0 the data is undefined.
         */
        reg [NUM_OF_SAMPLES-1:0] valid = 'h00;

        /*
         * Mask that qualifies the samples that overflowed in the previous
         * cycle.
         */
        reg [NUM_OF_SAMPLES-2*SAMPLES_PER_CHANNEL-1:0] prev_valid = 'h00;

        /*
         * Compute which positions are being filled. The mask is extended to
         * the full width (NUM_OF_SAMPLES + prev_valid width) before shifting
         * so that overflow bits properly go into prev_valid.
         */
        localparam PREV_VALID_WIDTH = NUM_OF_SAMPLES - 2 * SAMPLES_PER_CHANNEL;
        localparam MASK_WIDTH = NUM_OF_SAMPLES + PREV_VALID_WIDTH;

        always @(posedge clk) begin
          if (ce_ctrl == 1'b1) begin
            {prev_valid,valid} <= ({{PREV_VALID_WIDTH{1'b0}}, {NUM_OF_SAMPLES{1'b1}} >> ~enable_count} << rotate) | {{PREV_VALID_WIDTH{1'b0}}, prev_valid};
          end
        end

        if (NON_POWER_OF_TWO == 1) begin: gen_output_buffer
          localparam DELAYED_DATA_WIDTH = TOTAL_DATA_WIDTH - 2 * CHANNEL_DATA_WIDTH;

          /*
           * Delayed data from the previous cycle. When the number of enabled
           * channels is not a power of two it is possible that not all
           * incoming data can be consumed in one cycle since there might not
           * be enough room in the output vector anymore. In this case it needs
           * to be delayed and will be used in the next cycle.
           */
          reg [DELAYED_DATA_WIDTH-1:0] data_d1 = 'h00;

          /*
           * prev_valid_d1 needs ce-gated delay to match data_d1 timing.
           * With ce-gated data pipeline of TOTAL_PIPELINE_LATENCY stages:
           *   prev_valid: is set when overflow occurs
           *   data_d1: captures overflow data (TOTAL_PIPELINE_LATENCY + 1) ce-cycles later
           *   prev_valid_d1: must match this timing
           *
           * Use shift register for PV_DELAY ce-cycles delay.
           */
          localparam PV_WIDTH = NUM_OF_SAMPLES - 2*SAMPLES_PER_CHANNEL;
          localparam PV_DELAY = TOTAL_PIPELINE_LATENCY + 1;

          (* shreg_extract = "no" *) reg [PV_WIDTH-1:0] pv_sr [0:PV_DELAY-1];
          wire [PV_WIDTH-1:0] prev_valid_d1;

          integer pv_i;
          initial begin
            for (pv_i = 0; pv_i < PV_DELAY; pv_i = pv_i + 1)
              pv_sr[pv_i] = {PV_WIDTH{1'b0}};
          end

          always @(posedge clk) begin
            if (reset_ctrl == 1'b1) begin
              for (pv_i = 0; pv_i < PV_DELAY; pv_i = pv_i + 1)
                pv_sr[pv_i] <= {PV_WIDTH{1'b0}};
            end else if (ce_ctrl == 1'b1) begin
              pv_sr[0] <= prev_valid;
              for (pv_i = 1; pv_i < PV_DELAY; pv_i = pv_i + 1)
                pv_sr[pv_i] <= pv_sr[pv_i-1];
            end
          end

          assign prev_valid_d1 = pv_sr[PV_DELAY-1];

          /*
           * synchronization signal that indicates whether the first enabled
           * channel is in the first output sample. This will always be true if
           * the number of enabled channels is a power of two.
           */
          reg sync = 1'b1;

          always @(posedge clk) begin
            if (reset_ctrl == 1'b1) begin
              sync <= 1'b1;
            end else if (ready_int == 1'b1 && ce == 1'b1) begin
              if (rotate == 'h0) begin
                sync <= 1'b1;
              end else begin
                sync <= 1'b0;
              end
            end
          end

          always @(posedge clk) begin
            if (ce == 1'b1) begin
              data_d1 <= data[2][DELAYED_DATA_WIDTH-1:0];
            end
          end

          for (i = 0; i < NUM_OF_SAMPLES; i = i + 1) begin: gen_out_data
            localparam w = SAMPLE_DATA_WIDTH;
            localparam base = i * w;
            if (base >= DELAYED_DATA_WIDTH) begin
              assign out_data[base+:w] = data[2][base+:w];
            end else begin
              assign out_data[base+:w] = prev_valid_d1[i] == 1'b1 ? data_d1[base+:w] : data[2][base+:w];
            end
          end

          assign out_sync_int = sync;
        end else begin
          assign out_data = data[2];
          assign out_sync_int = 1'b1;
        end

        assign out_valid_int = valid;
      end else begin
        assign out_sync_int = 1'b1;
        assign out_valid_int = {NUM_OF_SAMPLES{1'b1}};
        assign out_data = data[2];
      end
    end
  endgenerate

endmodule
