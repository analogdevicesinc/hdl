// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns/1ps

module axi_tdd_counter #(
  parameter  REGISTER_WIDTH = 32,
  parameter  BURST_COUNT_WIDTH = 32
) (

  input  logic                         clk,
  input  logic                         resetn,

  input  logic                         tdd_enable,
  input  logic                         tdd_sync_rst,
  input  logic                         tdd_sync,

  input  logic [BURST_COUNT_WIDTH-1:0] asy_tdd_burst_count,
  input  logic [REGISTER_WIDTH-1:0]    asy_tdd_startup_delay,
  input  logic [REGISTER_WIDTH-1:0]    asy_tdd_frame_length,

  output logic [REGISTER_WIDTH-1:0]    tdd_counter,
  output axi_tdd_pkg::state_t          tdd_cstate,
  output logic                         tdd_endof_frame
);

  // package import
  import axi_tdd_pkg::*;

  // internal registers/wires
  logic [BURST_COUNT_WIDTH-1:0] tdd_burst_count;
  logic [REGISTER_WIDTH-1:0]    tdd_startup_delay;
  logic [REGISTER_WIDTH-1:0]    tdd_frame_length;
  logic [BURST_COUNT_WIDTH-1:0] tdd_burst_counter;
  logic                         tdd_delay_done;
  logic                         tdd_endof_burst;
  logic                         tdd_last_burst;
  state_t                       tdd_cstate_ns;

  wire  [BURST_COUNT_WIDTH-1:0] tdd_burst_count_s;
  wire  [REGISTER_WIDTH-1:0]    tdd_startup_delay_s;
  wire  [REGISTER_WIDTH-1:0]    tdd_frame_length_s;

  // initial values
  initial begin
    tdd_burst_counter = '0;
    tdd_counter = '0;
    tdd_cstate = IDLE;
    tdd_cstate_ns = IDLE;
    tdd_delay_done = 1'b0;
    tdd_endof_frame = 1'b0;
    tdd_last_burst = 1'b0;
  end

  // Connect the enable signal to the enable flop lines
  (* direct_enable = "yes" *) logic enable;
  assign enable = tdd_enable;

  sync_bits #(
    .NUM_OF_BITS(BURST_COUNT_WIDTH),
    .ASYNC_CLK(1),
    .SYNC_STAGES(2)
  ) i_tdd_burst_count_sync (
    .out_clk(clk),
    .out_resetn(resetn),
    .in_bits(asy_tdd_burst_count),
    .out_bits(tdd_burst_count_s));

  // Save the async register values only when the module is enabled
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_burst_count <= '0;
    end else begin
      if (enable) begin
        tdd_burst_count <= tdd_burst_count_s;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS(REGISTER_WIDTH),
    .ASYNC_CLK(1),
    .SYNC_STAGES(2)
  ) i_tdd_startup_delay_sync (
    .out_clk(clk),
    .out_resetn(resetn),
    .in_bits(asy_tdd_startup_delay),
    .out_bits(tdd_startup_delay_s));

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_startup_delay <= '0;
    end else begin
      if (enable) begin
        tdd_startup_delay <= tdd_startup_delay_s;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS(REGISTER_WIDTH),
    .ASYNC_CLK(1),
    .SYNC_STAGES(2)
  ) i_tdd_frame_length_sync (
    .out_clk(clk),
    .out_resetn(resetn),
    .in_bits(asy_tdd_frame_length),
    .out_bits(tdd_frame_length_s));

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_frame_length <= '0;
    end else begin
      if (enable) begin
        tdd_frame_length <= tdd_frame_length_s;
      end
    end
  end

  // TDD counter FSM
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_cstate <= IDLE;
    end else begin
      tdd_cstate <= tdd_cstate_ns;
    end
  end

  always @* begin
    tdd_cstate_ns = tdd_cstate;
    case (tdd_cstate)
      IDLE : begin
        if (tdd_enable == 1'b1) begin
          tdd_cstate_ns = ARMED;
        end
      end

      ARMED : begin
        if (tdd_enable == 1'b0) begin
          tdd_cstate_ns = IDLE;
        end else if (tdd_sync == 1'b1) begin
          tdd_cstate_ns = (tdd_startup_delay == 0) ? RUNNING : WAITING;
        end
      end

      WAITING : begin
        if (tdd_delay_done == 1'b1) begin
          tdd_cstate_ns = RUNNING;
        end
      end

      RUNNING : begin
        if (tdd_endof_frame == 1'b1) begin
          tdd_cstate_ns = (tdd_endof_burst == 1'b1) ? (tdd_enable ? ARMED : IDLE) :
                          (((tdd_burst_counter == 0) && !tdd_enable) ? IDLE : RUNNING);
        end
      end
    endcase
  end

  // TDD control signals
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_delay_done <= 1'b0;
    end else begin
      if ((tdd_cstate == WAITING) && (tdd_counter == (tdd_startup_delay - 1'b1))) begin
        tdd_delay_done <= 1'b1;
      end else begin
        tdd_delay_done <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_endof_frame <= 1'b0;
    end else begin
      if (tdd_counter == (tdd_frame_length - 1'b1)) begin
        tdd_endof_frame <= 1'b1;
      end else begin
        tdd_endof_frame <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_last_burst <= 1'b0;
    end else begin
      tdd_last_burst <= (tdd_burst_counter == 1) ? 1'b1 : 1'b0;
    end
  end

  assign tdd_endof_burst = ((tdd_last_burst == 1'b1) && (tdd_endof_frame == 1'b1)) ? 1'b1 : 1'b0;

  // TDD free running counter
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_counter <= '0;
    end else begin
      if ((tdd_sync && tdd_sync_rst) == 1'b1) begin
        tdd_counter <= '0;
      end else begin
        if (tdd_cstate == WAITING) begin
          tdd_counter <= (tdd_delay_done == 1'b1) ? '0 : tdd_counter + 1'b1;
        end else begin
          if (tdd_cstate == RUNNING) begin
            tdd_counter <= (tdd_endof_frame == 1'b1) ? '0 : tdd_counter + 1'b1;
          end else begin
            tdd_counter <= '0;
          end
        end
      end
    end
  end

  // TDD burst counter
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tdd_burst_counter <= '0;
    end else begin
      if (tdd_cstate == ARMED) begin
        tdd_burst_counter <= tdd_burst_count;
      end else begin
        if ((tdd_cstate == RUNNING) && (tdd_burst_counter != 0) && (tdd_endof_frame == 1'b1)) begin
          tdd_burst_counter <= tdd_burst_counter - 1'b1;
        end
      end
    end
  end

endmodule
