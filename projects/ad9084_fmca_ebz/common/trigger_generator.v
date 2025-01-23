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

`timescale 1ns / 1ps

module trigger_generator (
  input wire sysref,
  input wire device_clk,
  input wire gpio,
  input wire rstn,
  output reg trigger
);

  localparam                   STATE_WIDTH = 3;
  localparam [STATE_WIDTH-1:0] CALIB_IDLE = 0;
  localparam [STATE_WIDTH-1:0] CALIB_START = 1;
  localparam [STATE_WIDTH-1:0] IDLE = 2;
  localparam [STATE_WIDTH-1:0] SYSREF_SYNC = 3;
  localparam [STATE_WIDTH-1:0] START = 4;
  localparam [STATE_WIDTH-1:0] TRIGGER = 5;

  reg  [STATE_WIDTH-1:0] curr_state    = CALIB_IDLE;
  reg  [STATE_WIDTH-1:0] next_state;
  reg  [15:0]            quarter_count = 'h0000;
  reg  [15:0]            full_count    = 'h0000;
  reg  [15:0]            ratio_counter = 'h0000;
  reg                    calib_done    = 'b0;
  reg                    sysref_edge   = 'b0;
  reg                    sysref_r      = 'b0;
  reg                    gpio_edge     = 'b0;
  reg                    gpio_r        = 'b0;

  wire gpio_sync;

  ad_rst i_gpio_sync(
      .rst_async (gpio),
      .clk (device_clk),
      .rstn (),
      .rst (gpio_sync));

  always @* begin
    case(curr_state)
      CALIB_IDLE:  next_state = (sysref_edge) ? CALIB_START : CALIB_IDLE;
      CALIB_START: next_state = (calib_done == 1'b1) ? IDLE : CALIB_START;
      IDLE:        next_state = (gpio_edge == 1'b1) ? SYSREF_SYNC : IDLE;
      SYSREF_SYNC: next_state = (sysref_edge) ? START : SYSREF_SYNC;
      START:       next_state = (quarter_count < (ratio_counter / 2) - 2) ? START : TRIGGER;
      TRIGGER:     next_state = (full_count <= (ratio_counter * 2) + 2) ? TRIGGER : IDLE;
      default:     next_state = CALIB_IDLE;
    endcase
  end

  always @(posedge device_clk) begin
    if (rstn == 1'b0) begin
      curr_state <= CALIB_IDLE;
      calib_done <= 1'b0;
      ratio_counter <= 'h0000;
    end else begin
      curr_state <= next_state;
      if (curr_state == CALIB_START) begin
        if (sysref) begin
          ratio_counter <= ratio_counter + 'b1;
        end else begin
          calib_done <= 'b1;
        end
      end
    end
  end

  always @(posedge device_clk) begin
    sysref_r <= sysref;
    sysref_edge <= (sysref && !sysref_r);
  end

  always @(posedge device_clk) begin
    gpio_r <= gpio_sync;
    gpio_edge <= (gpio_sync && !gpio_r);
  end

  always @(posedge device_clk) begin
    if (curr_state == START) begin
      if (quarter_count < (ratio_counter / 2) - 2) begin
        quarter_count <= quarter_count + 'b1;
      end else begin
        quarter_count <= 0;
      end
    end
  end

  always @(posedge device_clk) begin
    if (curr_state == TRIGGER) begin
      if (full_count <= (ratio_counter * 2) + 2) begin
        full_count <= full_count + 'b1;
      end else begin
        full_count <= 0;
      end
    end
  end

  always @(posedge device_clk) begin
    if (curr_state == TRIGGER) begin
      trigger <= 1'b1;
    end else begin
      trigger <= 1'b0;
    end
  end

endmodule