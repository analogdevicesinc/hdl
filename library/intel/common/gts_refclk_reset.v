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

// GTS refclk buffer control state machine.
//
// Drives the GTS reset controller's refclk_on request based on the aggregated
// refclk-ready status. On a rising edge of refclk_ready it requests the refclk
// buffers on, waits for the acknowledge, and re-requests them whenever a refclk
// failure is reported while the reference clock is still expected to be ready.

module gts_refclk_reset #(
  parameter REFCLK_ON_WIDTH      = 10,
  parameter FAIL_STATUS_WIDTH    = 8
) (
  input                             clk,
  input                             resetn,

  input                             refclk_ready,
  input                             refclk_on_ack,
  input   [FAIL_STATUS_WIDTH-1:0]   refclk_fail_status,

  output reg [REFCLK_ON_WIDTH-1:0]  refclk_on
);

  localparam GTS_STATE_WIDTH      = 2;

  localparam GTS_REFCLK_IDLE      = 2'd0;
  localparam GTS_REFCLK_REQ_ON    = 2'd1;
  localparam GTS_REFCLK_WAIT_ACK  = 2'd2;
  localparam GTS_REFCLK_ACTIVE    = 2'd3;

  reg [GTS_STATE_WIDTH-1:0] gts_refclk_state;
  reg                       refclk_ready_d;
  wire                      refclk_fail_detected;

  assign refclk_fail_detected = |refclk_fail_status;

  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      refclk_on <= 'd0;
      gts_refclk_state <= GTS_REFCLK_IDLE;
      refclk_ready_d <= 1'b0;
    end else begin
      refclk_ready_d <= refclk_ready;

      case (gts_refclk_state)
        GTS_REFCLK_IDLE: begin
          refclk_on <= 'd0;
          if (refclk_ready && !refclk_ready_d) begin
            gts_refclk_state <= GTS_REFCLK_REQ_ON;
          end
        end

        GTS_REFCLK_REQ_ON: begin
          refclk_on <= {REFCLK_ON_WIDTH{1'b1}};
          gts_refclk_state <= GTS_REFCLK_WAIT_ACK;
        end

        GTS_REFCLK_WAIT_ACK: begin
          if (refclk_on_ack) begin
            refclk_on <= 'd0;
            gts_refclk_state <= GTS_REFCLK_ACTIVE;
          end
          if (!refclk_ready) begin
            refclk_on <= 'd0;
            gts_refclk_state <= GTS_REFCLK_IDLE;
          end
        end

        GTS_REFCLK_ACTIVE: begin
          if (refclk_fail_detected && refclk_ready) begin
            gts_refclk_state <= GTS_REFCLK_REQ_ON;
          end
          if (!refclk_ready) begin
            gts_refclk_state <= GTS_REFCLK_IDLE;
          end
        end

        default: begin
          gts_refclk_state <= GTS_REFCLK_IDLE;
        end
      endcase
    end
  end

endmodule
