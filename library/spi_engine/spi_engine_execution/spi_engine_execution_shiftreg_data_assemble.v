// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

  parameter ALL_ACTIVE_LANE_MASK = 8'hFF,
  parameter DATA_WIDTH = 8,
  parameter NUM_OF_SDIO = 1,
  parameter [2:0] CMD_WRITE = 3'b010
) (
  input                                   clk,
  input                                   resetn,
  input               [(DATA_WIDTH)-1:0]  data,
  input                                   data_ready,
  input                                   data_valid,
  input                           [15:0]  current_cmd,
  input                                   exec_sdo_lane_cmd,
  input                            [7:0]  lane_mask,
  input                                   idle_state,
  input                            [7:0]  left_aligned,
  input                                   transfer_active,
  input                                   trigger_tx,
  input                                   first_bit,
  input                                   sdo_enabled,
  output                                  index_ready,
  output [(NUM_OF_SDIO * DATA_WIDTH)-1:0] data_assembled,
  output                                  last_handshake
);

  // This module is responsible to align data for different lane masks
  // if lane_mask has all of its SDOs activated, then it allows prefetch data
  // if not, non activated serial lines have their data fulfilled with idle_state and buffer the remaining activated lines
  // also, in this mode it is not possible to prefetch data

  reg                                  last_handshake_int;
  reg [(NUM_OF_SDIO * DATA_WIDTH)-1:0] aligned_data;
  reg [              (DATA_WIDTH)-1:0] data_reg;
  reg [                           3:0] count_active_lanes = 0;
  reg [                           3:0] num_active_lanes   = NUM_OF_SDIO;
  reg [                           3:0] lane_index         = 0;
  reg [                           3:0] lane_index_d       = 0;
  reg [                           3:0] valid_indices [0:7];

  wire sdo_toshiftreg = (transfer_active && trigger_tx && first_bit && sdo_enabled);
  integer valid_index = 0;

  assign data_assembled = aligned_data;
  assign last_handshake = last_handshake_int;
  assign index_ready    = index_ready_reg;

  // register data
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      data_reg <= {DATA_WIDTH{idle_state}};
    end else begin
      if (data_ready && data_valid) begin
          data_reg <= data;
      end
    end
  end

  // Align data to have its bits on the MSB bits
  // data is left shifted left_aligned times, where left_aligned equals to DATA_WIDTH - word_length
  // word_length comes from the dynamic transfer length register
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      aligned_data <= {(NUM_OF_SDIO * DATA_WIDTH){idle_state}};
    end else begin
      aligned_data[valid_index * DATA_WIDTH+:DATA_WIDTH] <= data_reg << left_aligned;
    end
  end

  // data line counter and stores activated lines
  // it returns valid_indices array necessary for correct buffering of data
  reg [3:0] i;
  reg [3:0] j;
  reg [3:0] mask_index;
  reg       index_ready_reg;
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      num_active_lanes <= NUM_OF_SDIO;
      index_ready_reg <= 1'b0;
      mask_index <= 0;
      j <= 0;
    end else begin
      if (exec_sdo_lane_cmd) begin
        count_active_lanes = 0;
        i = 0;
        j <= 0;
        index_ready_reg <= 1'b0;
        mask_index <= 0;
        for (i = 0; i < NUM_OF_SDIO; i = i + 1) begin
          count_active_lanes = count_active_lanes + current_cmd[i];
        end
        num_active_lanes <= count_active_lanes;
      end else begin
        if (j < NUM_OF_SDIO) begin
          if (lane_mask[j]) begin
            valid_indices[mask_index] <= j;
            mask_index <= mask_index + 1;
          end
          j <= j + 1;
          index_ready_reg <= (j == NUM_OF_SDIO-1) ? 1'b1 : 1'b0;
        end
      end
    end
  end

  // handshake counter
  // it will increment up to num_active_lanes
  // The last handshake is used by external logic to enable sdo_io_ready
  // retrieves the correct lane_index used to align data
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      lane_index <= 0;
      lane_index_d <= 0;
      valid_index <= 0;
      last_handshake_int <= 1'b0;
    end else begin
      if (data_ready && data_valid) begin
        last_handshake_int <= (lane_index == (num_active_lanes-1)) ? 1'b1 : 1'b0;
        if (lane_index < (num_active_lanes-1)) begin
          lane_index <= lane_index + 1;
        end else begin
          lane_index <= 0;
        end
        lane_index_d <= lane_index;
        valid_index <= (lane_mask == ALL_ACTIVE_LANE_MASK) ? lane_index : valid_indices[lane_index_d];
      end else if (sdo_toshiftreg) begin
        last_handshake_int <= 1'b0;
      end
    end
  end

  endmodule
