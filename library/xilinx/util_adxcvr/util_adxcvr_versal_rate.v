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

`timescale 1ns/100ps

module util_adxcvr_versal_rate #(
  parameter   integer TIMEOUT_WIDTH = 16
) (
  input                   up_rstn,
  input                   up_clk,
  input                   up_rst,
  input                   up_user_ready,
  input       [ 2:0]      up_rate,
  output                  up_rst_done,

  input                   usr_clk,
  input                   gt_resetdone,
  output      [ 7:0]      gt_rate
);

  localparam  [ 2:0]  S_RESET     = 3'd0;
  localparam  [ 2:0]  S_WAIT_INIT = 3'd1;
  localparam  [ 2:0]  S_WAIT_LOW  = 3'd2;
  localparam  [ 2:0]  S_WAIT_HIGH = 3'd3;
  localparam  [ 2:0]  S_DONE      = 3'd4;

  reg     [ 2:0]              up_state = S_RESET;
  reg     [ 2:0]              up_rate_applied = 3'd0;
  reg     [TIMEOUT_WIDTH-1:0] up_timer = 'd0;

  wire                        up_resetdone;

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_sync_resetdone (
    .in_bits (gt_resetdone),
    .out_resetn (up_rstn),
    .out_clk (up_clk),
    .out_bits (up_resetdone));

  // The reset-done of the previous sequence can stay high for a while after
  // reset is released, so wait for it to drop (or time out) first. A rate
  // change makes the quad run its own reset sequence (AM002 Rate Change), so
  // the new rate is applied only once the normal reset has completed.
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_state <= S_RESET;
      up_rate_applied <= 3'd0;
      up_timer <= 'd0;
    end else if (up_rst == 1'b1) begin
      up_state <= S_RESET;
      up_timer <= 'd0;
    end else begin
      case (up_state)
        S_RESET: begin
          up_timer <= up_timer + 1'b1;
          if (up_resetdone == 1'b0 || &up_timer == 1'b1) begin
            up_state <= S_WAIT_INIT;
          end
        end
        S_WAIT_INIT: begin
          if (up_resetdone == 1'b1 && up_user_ready == 1'b1) begin
            if (up_rate != up_rate_applied) begin
              up_rate_applied <= up_rate;
              up_timer <= 'd0;
              up_state <= S_WAIT_LOW;
            end else begin
              up_state <= S_DONE;
            end
          end
        end
        S_WAIT_LOW: begin
          up_timer <= up_timer + 1'b1;
          if (up_resetdone == 1'b0 || &up_timer == 1'b1) begin
            up_state <= S_WAIT_HIGH;
          end
        end
        S_WAIT_HIGH: begin
          if (up_resetdone == 1'b1) begin
            up_state <= S_DONE;
          end
        end
        default: begin
          up_state <= S_DONE;
        end
      endcase
    end
  end

  assign up_rst_done = up_state == S_DONE;

  // The RX user clock only runs once the GT has left reset, and the GT needs
  // a defined rate to get there, so the synchronized rate starts at 0 instead
  // of waiting for a first transfer. up_rate_applied changes once per rate
  // change, so a value is taken only after two equal samples.
  reg     [ 2:0]              usr_rate_m1 = 3'd0;
  reg     [ 2:0]              usr_rate_m2 = 3'd0;
  reg     [ 2:0]              usr_rate = 3'd0;

  always @(posedge usr_clk) begin
    usr_rate_m1 <= up_rate_applied;
    usr_rate_m2 <= usr_rate_m1;
    if (usr_rate_m1 == usr_rate_m2) begin
      usr_rate <= usr_rate_m2;
    end
  end

  assign gt_rate = {5'd0, usr_rate};

endmodule
