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
/**
 * Modulates the Target Reset Pattern (TRP).
 *
 * The TRP is fourteen SDA transitions while SCL is kept Low, followed by a
 * Repeated START and a STOP. Each cycle is 40ns.
 */

`timescale 1ns/100ps

module i3c_controller_trp (
  input      clk,
  input      reset_n,

  input      cmd_valid,
  output     cmd_ready,

  input      idle,
  output     hold,

  output reg scl,
  output reg sdo,
  output reg t
);

  localparam SM_IDLE = 1'b0;
  localparam SM_RUN  = 1'b1;

  localparam [4:0] PH_SR_SETUP = 15;
  localparam [4:0] PH_SR       = 16;
  localparam [4:0] PH_STOP     = 17;

  reg       sm;
  reg [4:0] ph;
  reg [1:0] count;

  wire start;
  wire ph_end;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm <= SM_IDLE;
      ph <= 0;
      count <= 0;
    end else begin
      case (sm)
        SM_IDLE: begin
          ph <= 0;
          count <= 0;
          if (start) begin
            sm <= SM_RUN;
          end
        end
        SM_RUN: begin
          count <= count + 1;
          if (ph_end) begin
            ph <= ph + 1;
            if (ph == PH_STOP) begin
              sm <= SM_IDLE;
            end
          end
        end
      endcase
    end
  end

  assign ph_end = &count;

  always @(posedge clk) begin
    if (start || (sm == SM_RUN && ph < PH_SR_SETUP)) begin
      scl <= 1'b0;
      sdo <= start ? 1'b1 : ~ph[0];
      t   <= 1'b0;
    end else if (sm == SM_RUN) begin
      scl <= 1'b1;
      sdo <= ph != PH_SR;
      t   <= ph != PH_SR;
    end else begin
      scl <= 1'b1;
      sdo <= 1'b1;
      t   <= 1'b1;
    end
  end

  assign start = sm == SM_IDLE & cmd_valid & idle;
  assign cmd_ready = sm == SM_IDLE & idle;
  assign hold = sm == SM_RUN;
endmodule
