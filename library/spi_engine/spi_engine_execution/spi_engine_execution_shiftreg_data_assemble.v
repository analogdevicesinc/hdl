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
  parameter N_STAGES = 2,
  parameter DATA_WIDTH = 8,
  parameter NUM_OF_SDIO = 1
) (
  input                                   clk,
  input                                   resetn,
  input               [(DATA_WIDTH)-1:0]  data,
  input                                   data_ready,
  input                                   data_valid,
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
  output                                  data_ready_out,
  output                                  last_handshake
);

  // This module is responsible to align data for different lane masks
  // if lane_mask has all of its SDOs activated, then it allows prefetch data
  // if not, non activated serial lines have their data fulfilled with idle_state and buffer the remaining activated lines
  // also, in this mode it is not possible to prefetch data

  reg                                  sdo_ready_out;
  reg                                  last_handshake_int;
  reg [                  N_STAGES-1:0] last_handshake_pipe;
  reg [(NUM_OF_SDIO * DATA_WIDTH)-1:0] aligned_data;
  reg [              (DATA_WIDTH)-1:0] data_reg;
  reg [     (N_STAGES*DATA_WIDTH)-1:0] data_pipe_reg;
  reg [                           3:0] lane_index         = 0;
  reg [                           3:0] last_lane_index    = 0;
  reg [                           3:0] valid_indices [0:7];
  reg [                           3:0] valid_index = 0;
  reg [              (N_STAGES*8)-1:0] valid_index_pipe;
  reg                                  index_ready_reg;

  wire sdo_toshiftreg = (transfer_active && trigger_tx && first_bit && sdo_enabled);
  integer i;

  assign data_assembled = aligned_data;
  assign data_ready_out = sdo_ready_out;
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

  // pipeline registers
  // Align data to have its bits on the MSB bits
  // data is left shifted left_aligned times, where left_aligned equals to DATA_WIDTH - word_length
  // word_length comes from the dynamic transfer length register
  always @(posedge clk) begin
    last_handshake_pipe[0]        <= sdo_ready_out;
    valid_index_pipe[0+:8]        <= valid_index * DATA_WIDTH;
    data_pipe_reg[0+: DATA_WIDTH] <= data_reg << left_aligned;
    for (i = N_STAGES-1; i > 0; i = i - 1) begin
      last_handshake_pipe[i]                   <= last_handshake_pipe[i-1];
      valid_index_pipe[i*8+:8]                 <= valid_index_pipe[(i-1)*8+:8];
      data_pipe_reg[i*DATA_WIDTH+: DATA_WIDTH] <= data_pipe_reg[(i-1)*DATA_WIDTH+: DATA_WIDTH];
    end
  end

  // Aligned data
  always @(posedge clk) begin
    if (!resetn) begin
      aligned_data <= {(NUM_OF_SDIO * DATA_WIDTH){idle_state}};
    end else begin
      aligned_data[valid_index_pipe[(N_STAGES-1)*8+:8]+:DATA_WIDTH] <= data_pipe_reg[(N_STAGES-1)*DATA_WIDTH+: DATA_WIDTH];
    end
  end

  // data line counter and stores activated lines
  // it returns valid_indices array necessary for correct buffering of data
  reg [3:0] j;
  reg [3:0] mask_index;
  always @(posedge clk) begin
    if (!resetn) begin
      index_ready_reg <= 1'b0;
      mask_index <= 0;
      last_lane_index <= 0;
      j <= 0;
    end else begin
      if (exec_sdo_lane_cmd) begin
        j <= 0;
        index_ready_reg <= 1'b0;
        mask_index <= 0;
        last_lane_index <= 0;
      end else begin
        if (j < NUM_OF_SDIO) begin
          if (lane_mask[j]) begin
            valid_indices[mask_index] <= j;
            last_lane_index <= mask_index; //avoid subtraction in the handshake counter
            mask_index <= mask_index + 1;
          end
          j <= j + 1;
          index_ready_reg <= (j == NUM_OF_SDIO-1);
        end
      end
    end
  end

  // valid_index is used to select the correct bits of aligned_data
  // to be sent to the shift register, and it is updated on each handshake
  always @(posedge clk) begin
    if (!resetn) begin
      valid_index <= 0;
    end else begin
      if (data_ready && data_valid) begin
        valid_index <= valid_indices[lane_index];
      end
    end
  end

  // lane_index is a counter that increments on each handshake,
  // and it is used to retrieve the correct valid_index for data alignment
  always @(posedge clk) begin
    if (!resetn) begin
      lane_index <= 0;
    end else begin
      if (data_ready && data_valid) begin
        if (lane_index < last_lane_index) begin
          lane_index <= lane_index + 1;
        end else begin
          lane_index <= 0;
        end
      end
    end
  end

  // The last handshake is used by external logic to enable sdo_io_ready
  always @(posedge clk) begin
    if (!resetn) begin
      sdo_ready_out <= 1'b0;
      last_handshake_int <= 1'b0;
    end else begin
      last_handshake_int <= last_handshake_pipe[N_STAGES-2];
      if (data_ready && data_valid) begin
        sdo_ready_out <= (lane_index == last_lane_index);
      end else if (sdo_toshiftreg) begin
        sdo_ready_out <= 1'b0;
      end
    end
  end

  endmodule
