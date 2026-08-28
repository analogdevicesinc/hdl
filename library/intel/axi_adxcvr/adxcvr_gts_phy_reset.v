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

// Reset sequencer for one datapath of one GTS PHY.
//
// The GTS PMA/FEC Direct PHY IP requires that the reset stay asserted until the
// PHY reports reset_ack, and only then be released; ready follows once the PLL
// or CDR has locked (GTS Transceiver PHY UG 817660, sections 3.9.4 and 3.9.5).
//
// req is level-sensitive: hold it high to keep the datapath in reset, drop it to
// run the release sequence.

module adxcvr_gts_phy_reset (
  input             clk,
  input             resetn,

  input             req,

  input             reset_ack,
  input             ready,

  output reg        reset,

  // Sticky: set when this PHY acknowledges the current request, held until the
  // next one arrives. A caller reducing this across several PHYs must not depend
  // on them acknowledging in the same cycle - they do not.
  output reg        ack_latched,

  output reg        done
);

  localparam STATE_ASSERT     = 2'd0;
  localparam STATE_WAIT_ACK   = 2'd1;
  localparam STATE_WAIT_READY = 2'd2;
  localparam STATE_DONE       = 2'd3;

  reg [ 1:0] state;

  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      state <= STATE_ASSERT;
      reset <= 1'b1;
      ack_latched <= 1'b0;
      done <= 1'b0;
    end else begin
      case (state)
        STATE_ASSERT: begin
          reset <= 1'b1;
          done <= 1'b0;
          ack_latched <= 1'b0;
          state <= STATE_WAIT_ACK;
        end

        STATE_WAIT_ACK: begin
          if (reset_ack) begin
            reset <= 1'b0;
            ack_latched <= 1'b1;
            state <= STATE_WAIT_READY;
          end
        end

        STATE_WAIT_READY: begin
          if (ready) begin
            state <= STATE_DONE;
          end
        end

        STATE_DONE: begin
          done <= 1'b1;
          if (req) begin
            state <= STATE_ASSERT;
          end
        end

        default: begin
          state <= STATE_ASSERT;
        end
      endcase
    end
  end

endmodule
