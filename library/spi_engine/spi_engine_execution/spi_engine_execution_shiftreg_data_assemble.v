// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

module spi_engine_execution_shiftreg_data_assemble #(
  parameter N_STAGES    = 2,
  parameter DATA_WIDTH  = 8,
  parameter NUM_OF_SDIO = 1
) (
  input                                   clk,
  input                                   resetn,

  // Data interface
  input  [             (DATA_WIDTH)-1:0] data,
  input                                  data_ready,
  input                                  data_valid,

  // Lane configuration
  input                                  lane_cfg_valid,
  input  [                          7:0] sdo_lane_mask,
  input                                  sdo_idle_state,
  input  [                          7:0] left_shift_count,
  output                                 lane_cfg_ready,

  // Transfer control (from execution FSM)
  input                                  transfer_active,
  input                                  trigger_tx,
  input                                  first_bit,
  input                                  sdo_enabled,

  // Assembled data output
  output [(NUM_OF_SDIO*DATA_WIDTH)-1:0] data_assembled,
  output                                 word_ready,
  output                                 word_ready_aligned
);

  // =============================================================================
  // SDO Data Assembly Module
  // =============================================================================
  // Assembles sequential data words into a multi-lane output buffer (aligned_data).
  // Maps each incoming word to the correct physical SDO lane based on sdo_lane_mask.
  //
  // Operation:
  //   1. Lane mask is parsed when lane_cfg_valid asserts, building lane_lookup[]
  //      table that maps sequential index to physical lane number.
  //   2. On each data handshake, active_lane_idx cycles through active lanes.
  //   3. Data is left-shifted for MSB alignment, then pipelined for timing.
  //   4. At pipeline output, data is written to aligned_data at the correct lane position.
  //
  // Example (NUM_OF_SDIO=4, DATA_WIDTH=8, sdo_lane_mask=4'b1010):
  //   - lane_lookup[0]=1, lane_lookup[1]=3, last_active_idx=1
  //   - Handshake 1: data -> aligned_data[15:8]  (lane 1)
  //   - Handshake 2: data -> aligned_data[31:24] (lane 3), word_ready=1
  //
  // Pipeline adds N_STAGES cycles latency from data input to aligned_data output.
  // =============================================================================

  // Parameter validation
  initial begin
    if (N_STAGES < 2) begin
      $error("N_STAGES must be >= 2 for pipeline to function correctly");
    end
  end

  // Output registers
  reg                                  word_ready_int;
  reg                                  word_ready_aligned_int;

  // Pipeline registers for timing closure
  reg [                  N_STAGES-1:0] word_ready_pipe;
  reg [(NUM_OF_SDIO * DATA_WIDTH)-1:0] aligned_data;
  reg [              (DATA_WIDTH)-1:0] data_reg;
  reg [     (N_STAGES*DATA_WIDTH)-1:0] data_pipe_reg;

  // Lane indexing and mapping
  reg [             3:0] active_lane_idx  = 0;  // Current active lane being processed (0 to last_active_idx)
  reg [             3:0] last_active_idx  = 0;  // Index of last active lane (num_active_lanes - 1)
  reg [             3:0] lane_lookup [0:7];     // Lookup table: sequential index -> physical lane number
  reg [             3:0] physical_lane    = 0;  // Current physical lane number from lookup
  reg [(N_STAGES*8)-1:0] bit_position_pipe;  // Pipelined bit position (physical_lane * DATA_WIDTH)
  reg                    lane_cfg_ready_reg; // Asserted when lane mask processing complete

  // Indicates data is being loaded into shift register (consumption point)
  wire sdo_toshiftreg = (transfer_active && trigger_tx && first_bit && sdo_enabled);
  integer i;

  assign data_assembled      = aligned_data;
  assign word_ready          = word_ready_int;
  assign word_ready_aligned  = word_ready_aligned_int;
  assign lane_cfg_ready      = lane_cfg_ready_reg;

  // Register incoming data on handshake
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      data_reg <= {DATA_WIDTH{sdo_idle_state}};
    end else begin
      if (data_ready && data_valid) begin
        data_reg <= data;
      end
    end
  end

  // Pipeline Registers
  // Stage 0: Left-shift data for MSB alignment (left_shift_count = DATA_WIDTH - word_length)
  //          Compute bit position in aligned_data (physical_lane * DATA_WIDTH)
  // Stages 1+: Propagate data and position through pipeline for timing closure
  always @(posedge clk) begin
    word_ready_pipe[0]            <= word_ready_int;
    bit_position_pipe[0+:8]       <= physical_lane * DATA_WIDTH;
    data_pipe_reg[0+: DATA_WIDTH] <= data_reg << left_shift_count;
    for (i = N_STAGES-1; i > 0; i = i - 1) begin
      word_ready_pipe[i]                       <= word_ready_pipe[i-1];
      bit_position_pipe[i*8+:8]                <= bit_position_pipe[(i-1)*8+:8];
      data_pipe_reg[i*DATA_WIDTH+: DATA_WIDTH] <= data_pipe_reg[(i-1)*DATA_WIDTH+: DATA_WIDTH];
    end
  end

  // Data Assembly
  // At pipeline output, write shifted data to aligned_data at the lane's bit position.
  // Inactive lanes retain sdo_idle_state from reset.
  always @(posedge clk) begin
    if (!resetn) begin
      aligned_data <= {(NUM_OF_SDIO * DATA_WIDTH){sdo_idle_state}};
    end else begin
      aligned_data[bit_position_pipe[(N_STAGES-1)*8+:8]+:DATA_WIDTH] <= data_pipe_reg[(N_STAGES-1)*DATA_WIDTH+: DATA_WIDTH];
    end
  end

  // Lane Mask Processing
  // Parses sdo_lane_mask to build lane_lookup[] table.
  // Example: sdo_lane_mask = 8'b00001010 (lanes 1 and 3 active)
  //   lane_lookup[0] = 1, lane_lookup[1] = 3, last_active_idx = 1
  // Processing starts on lane_cfg_valid and completes after NUM_OF_SDIO cycles.
  reg [3:0] lane_scan_idx;
  reg [3:0] active_lane_cnt;
  always @(posedge clk) begin
    if (!resetn) begin
      lane_cfg_ready_reg <= 1'b0;
      active_lane_cnt    <= 0;
      last_active_idx    <= 0;
      lane_scan_idx      <= 0;
    end else begin
      if (lane_cfg_valid) begin
        lane_scan_idx      <= 0;
        lane_cfg_ready_reg <= 1'b0;
        active_lane_cnt    <= 0;
        last_active_idx    <= 0;
      end else begin
        if (lane_scan_idx < NUM_OF_SDIO) begin
          if (sdo_lane_mask[lane_scan_idx]) begin
            lane_lookup[active_lane_cnt] <= lane_scan_idx;
            last_active_idx <= active_lane_cnt; // avoid subtraction in the handshake counter
            active_lane_cnt <= active_lane_cnt + 1;
          end
          lane_scan_idx      <= lane_scan_idx + 1;
          lane_cfg_ready_reg <= (lane_scan_idx == NUM_OF_SDIO-1);
        end
      end
    end
  end

  // physical_lane selects the correct bit position in aligned_data
  // for the shift register, updated on each handshake
  always @(posedge clk) begin
    if (!resetn) begin
      physical_lane <= 0;
    end else begin
      if (data_ready && data_valid) begin
        physical_lane <= lane_lookup[active_lane_idx];
      end
    end
  end

  // active_lane_idx cycles through active lanes on each handshake,
  // used to retrieve the correct physical_lane for data alignment
  always @(posedge clk) begin
    if (!resetn) begin
      active_lane_idx <= 0;
    end else begin
      if (data_ready && data_valid) begin
        if (active_lane_idx < last_active_idx) begin
          active_lane_idx <= active_lane_idx + 1;
        end else begin
          active_lane_idx <= 0;
        end
      end
    end
  end

  // Handshake and Ready Signaling
  // word_ready_int: Asserted when last active lane's data received (active_lane_idx == last_active_idx).
  //                 Cleared when shift register consumes the data (sdo_toshiftreg).
  // word_ready_aligned_int: Pipelined version aligned with data_assembled output timing.
  always @(posedge clk) begin
    if (!resetn) begin
      word_ready_int         <= 1'b0;
      word_ready_aligned_int <= 1'b0;
    end else begin
      word_ready_aligned_int <= word_ready_pipe[N_STAGES-2];
      if (data_ready && data_valid) begin
        word_ready_int <= (active_lane_idx == last_active_idx);
      end else if (sdo_toshiftreg) begin
        word_ready_int <= 1'b0;
      end
    end
  end

  endmodule
