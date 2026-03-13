// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns / 1ps

module trigger_channel (
  input  logic        clk,
  input  logic        rstn,
  input  logic        trigger,
  input  logic        ch_en,
  input  logic [15:0] ch_phase,
  input  logic        bsync_event,
  input  logic        bsync_ready,
  input  logic [ 4:0] bsync_delay,
  input  logic [15:0] bsync_ratio,
  output logic [ 2:0] trig_state,
  output logic        trig_out
);

  localparam                   STATE_WIDTH = 3;
  localparam [STATE_WIDTH-1:0] IDLE        = 0;
  localparam [STATE_WIDTH-1:0] TRIG_EDGE   = 1;
  localparam [STATE_WIDTH-1:0] PHASE_READ  = 2;
  localparam [STATE_WIDTH-1:0] TRIG_ADJUST = 3;

  logic  [STATE_WIDTH-1:0] curr_state = IDLE;
  logic  [STATE_WIDTH-1:0] next_state;
  logic  [15:0]            current_phase = 0;
  logic  [15:0]            phase_counter;
  logic  [15:0]            trigger_duration;
  logic                    adjust_done;
  logic                    trig_edge;
  logic                    trig_r;
  logic                    trig_event;
  logic                    out;
  logic  [15:0]            trig_phase;

  assign trig_phase = ((2 * bsync_ratio) - 2) - ch_phase;

  always @* begin
    next_state = curr_state;
    case(curr_state)
      IDLE : begin
        if (ch_en && bsync_ready) begin
          next_state = TRIG_EDGE;
        end
      end

      TRIG_EDGE : begin
        if (ch_en && bsync_ready) begin
          if (current_phase != trig_phase) begin
            next_state = PHASE_READ;
          end else if (trig_event && bsync_event) begin
            next_state = TRIG_ADJUST;
          end else begin
            next_state = TRIG_EDGE;
          end
        end else begin
          next_state = IDLE;
        end
      end

      PHASE_READ : begin
        if (current_phase == trig_phase) begin
          next_state = TRIG_EDGE;
        end
      end

      TRIG_ADJUST : begin
        if (adjust_done) begin
          next_state = TRIG_EDGE;
        end
      end

      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      curr_state <= IDLE;
    end else begin
      curr_state <= next_state;
    end
  end

  always @(posedge clk) begin
    trig_r <= trigger;
    trig_edge <= (trigger && !trig_r);
  end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      out <= 0;
      phase_counter <= 0;
      trigger_duration <= 0;
      current_phase <= 0;
      adjust_done <= 0;
      trig_event <= 0;
    end else begin
      if (curr_state == TRIG_EDGE) begin
        trigger_duration <= 0;
        phase_counter <= 0;
        out <= 0;
        adjust_done <= 0;
        if (trig_edge) begin
          trig_event <= 1;
        end
      end else if (curr_state == PHASE_READ) begin
        current_phase <= trig_phase;
        adjust_done <= 1'b0;
      end else if (curr_state == TRIG_ADJUST) begin
        if (phase_counter < current_phase) begin
          phase_counter <= phase_counter + 1'b1;
        end else begin
          if (trigger_duration < bsync_ratio) begin
            trigger_duration <= trigger_duration + 1'b1;
            out <= 1;
          end else begin
            out <= 0;
            adjust_done <= 1;
            trig_event <= 0;
          end
        end
      end else begin
        out <= 0;
        phase_counter <= 0;
        trigger_duration <= 0;
        adjust_done <= 0;
        trig_event <= 0;
      end
    end
  end

  assign trig_out = out;
  assign trig_state = curr_state;

endmodule
