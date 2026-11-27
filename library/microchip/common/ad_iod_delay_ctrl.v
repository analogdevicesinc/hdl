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

// Steps the dynamic delay line of a PolarFire IOD to the delay requested on the
// up_clk interface (up_dld, up_dwdata), as the IDELAY of the Xilinx flow loads
// it: the PolarFire delay line can only move by one tap, so the target is
// reached tap by tap (DELAY_LINE_MOVE, DELAY_LINE_DIRECTION).
// IODELAY_MODE: 0 - the delay line is not used, 1 - static, IOD_DELAY_INIT is
// loaded after reset, 2 - dynamic, IOD_DELAY_INIT is loaded after reset and
// the delay can be changed on the up_clk interface.
// A reset of the IOD (ARST_N) sets its dynamic delay line to 0 taps; delay_rst
// must also be asserted then. The delay line is loaded (DELAY_LINE_LOAD, to
// IOD_DELAY_INIT) by a pulse LOAD_WAIT delay_clk cycles after delay_rst is
// released, so the load is not lost while the IOD is still in reset.

module ad_iod_delay_ctrl #(
  parameter   IODELAY_MODE = 2,
  parameter   REFCLK_FREQUENCY = 200,
  parameter   DELAY_STEP_COEFFICIENT = 0,
  parameter   RX_DELAY_VAL_X2 = 1'b1,
  parameter [7:0] IOD_DELAY_INIT = 8'b00000001,
  parameter   ASYNC_DELAY_CLK = 1,
  parameter   DRP_WIDTH = 5
) (

  input                       up_clk,
  input                       up_dld,
  input   [(DRP_WIDTH-1):0]   up_dwdata,
  output  [(DRP_WIDTH-1):0]   up_drdata,

  input                       delay_clk,
  input                       delay_rst,
  output                      delay_locked,

  // IOD delay line

  input                       delay_out_of_range,
  output                      delay_move,
  output                      delay_direction,
  output                      delay_load
);

  localparam integer  INTERNAL_DELAY_WIDTH = 10;
  localparam integer  IOD_DELAY_MAX = (RX_DELAY_VAL_X2 != 0) ? 255 : 127;
  localparam integer  DEFAULT_DELAY_STEP_COEFFICIENT_RAW =
    (REFCLK_FREQUENCY > 0) ? (625 / REFCLK_FREQUENCY) : ((IOD_DELAY_MAX + 1) / 32);
  localparam integer  DEFAULT_DELAY_STEP_COEFFICIENT =
    (DEFAULT_DELAY_STEP_COEFFICIENT_RAW > 0) ? DEFAULT_DELAY_STEP_COEFFICIENT_RAW : 1;
  localparam integer  EFFECTIVE_DELAY_STEP_COEFFICIENT =
    (DELAY_STEP_COEFFICIENT > 0) ? DELAY_STEP_COEFFICIENT : DEFAULT_DELAY_STEP_COEFFICIENT;
  localparam [7:0]    IOD_DELAY_INIT_LIMITED = (IOD_DELAY_INIT > IOD_DELAY_MAX) ? IOD_DELAY_MAX : IOD_DELAY_INIT;
  localparam          IOD_DELAY_LOAD_ON_RESET =
    (IODELAY_MODE != 0) && (IOD_DELAY_INIT != 8'b00000000);
  localparam integer  RESET_DELAY_VALUE =
    (IODELAY_MODE != 0) ? IOD_DELAY_INIT_LIMITED : 0;
  localparam integer  LOAD_WAIT = 16;
  localparam integer  DRDATA_MAX = (1 << DRP_WIDTH) - 1;
  localparam integer  RESET_DRDATA_RAW = RESET_DELAY_VALUE / EFFECTIVE_DELAY_STEP_COEFFICIENT;
  localparam [(DRP_WIDTH-1):0] RESET_DRDATA =
    (RESET_DRDATA_RAW > DRDATA_MAX) ? DRDATA_MAX : RESET_DRDATA_RAW;

  reg [INTERNAL_DELAY_WIDTH-1:0] delay_target = {INTERNAL_DELAY_WIDTH{1'b0}};
  reg [INTERNAL_DELAY_WIDTH-1:0] delay_value = {INTERNAL_DELAY_WIDTH{1'b0}};
  reg                         delay_move_int = 1'b0;
  reg                         delay_direction_int = 1'b0;
  reg                         delay_load_int = 1'b0;
  reg                         delay_load_pending = IOD_DELAY_LOAD_ON_RESET;
  reg     [ 4:0]              delay_load_wait = 5'd0;
  reg     [(DRP_WIDTH-1):0]   delay_drdata = RESET_DRDATA;
  reg                         up_dld_toggle = 1'b0;
  reg     [(DRP_WIDTH-1):0]   up_dwdata_hold = {DRP_WIDTH{1'b0}};
  reg                         delay_dld_toggle_d = 1'b0;
  reg                         delay_locked_int = 1'b0;

  wire                        delay_settled_s;
  wire    [31:0]              delay_target_scaled_s;
  wire [INTERNAL_DELAY_WIDTH-1:0] delay_target_limited_s;
  wire [INTERNAL_DELAY_WIDTH-1:0] delay_drdata_scaled_s;
  wire                        delay_dld_toggle_s;
  wire    [(DRP_WIDTH-1):0]   delay_dwdata_s;
  wire                        delay_dld_s;

  assign delay_move = (IODELAY_MODE == 2) ? delay_move_int : 1'b0;
  assign delay_direction = (IODELAY_MODE == 2) ? delay_direction_int : 1'b0;
  assign delay_load = (IODELAY_MODE != 0) ? delay_load_int : 1'b0;

  // the delay control runs on delay_clk; ASYNC_DELAY_CLK can be 0 only if
  // delay_clk and up_clk are the same clock

  // delay load request (up_clk -> delay_clk)

  always @(posedge up_clk) begin
    if (up_dld == 1'b1) begin
      up_dld_toggle <= ~up_dld_toggle;
      up_dwdata_hold <= up_dwdata;
    end
  end

  sync_data #(
    .NUM_OF_BITS (DRP_WIDTH+1),
    .ASYNC_CLK (ASYNC_DELAY_CLK)
  ) i_delay_dld_sync (
    .in_clk (up_clk),
    .in_data ({up_dld_toggle, up_dwdata_hold}),
    .out_clk (delay_clk),
    .out_data ({delay_dld_toggle_s, delay_dwdata_s}));

  always @(posedge delay_clk) begin
    delay_dld_toggle_d <= delay_dld_toggle_s;
  end

  assign delay_dld_s = delay_dld_toggle_s ^ delay_dld_toggle_d;

  // delay readback (delay_clk -> up_clk)

  sync_data #(
    .NUM_OF_BITS (DRP_WIDTH),
    .ASYNC_CLK (ASYNC_DELAY_CLK)
  ) i_up_drdata_sync (
    .in_clk (delay_clk),
    .in_data (delay_drdata),
    .out_clk (up_clk),
    .out_data (up_drdata));

  assign delay_target_scaled_s = delay_dwdata_s * EFFECTIVE_DELAY_STEP_COEFFICIENT;
  assign delay_target_limited_s =
    (delay_target_scaled_s > IOD_DELAY_MAX) ? IOD_DELAY_MAX : delay_target_scaled_s[INTERNAL_DELAY_WIDTH-1:0];
  assign delay_drdata_scaled_s = delay_value / EFFECTIVE_DELAY_STEP_COEFFICIENT;
  assign delay_settled_s = (delay_load_pending == 1'b0) &&
                           (delay_load_int == 1'b0) &&
                           (delay_move_int == 1'b0) &&
                           (delay_value == delay_target);

  // Like IDELAYCTRL RDY, delay_locked is set once after reset when the initial
  // delay value is loaded; the readback keeps the last settled value while
  // the delay line is stepped to a new target. delay_locked is moved to the
  // up_clk domain.

  always @(posedge delay_clk) begin
    delay_locked_int <= ~delay_rst & ~delay_load_pending & ~delay_load_int;
  end

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (ASYNC_DELAY_CLK)
  ) i_delay_locked_sync (
    .in_bits (delay_locked_int),
    .out_resetn (1'b1),
    .out_clk (up_clk),
    .out_bits (delay_locked));

  always @(posedge delay_clk) begin
    if (delay_rst == 1'b1) begin
      delay_drdata <= RESET_DRDATA;
    end else if (delay_settled_s == 1'b1) begin
      delay_drdata <= (delay_drdata_scaled_s > DRDATA_MAX) ? DRDATA_MAX :
                      delay_drdata_scaled_s[(DRP_WIDTH-1):0];
    end
  end

  always @(posedge delay_clk) begin
    if (delay_rst == 1'b1) begin
      delay_target <= RESET_DELAY_VALUE;
      delay_value <= RESET_DELAY_VALUE;
      delay_move_int <= 1'b0;
      delay_direction_int <= 1'b0;
      delay_load_int <= 1'b0;
      delay_load_pending <= IOD_DELAY_LOAD_ON_RESET;
      delay_load_wait <= 5'd0;
    end else begin
      // DELAY_LINE_LOAD only pulses after reset; keep 0 during dynamic operation
      delay_load_int <= 1'b0;
      if (delay_load_pending == 1'b1) begin
        delay_load_wait <= delay_load_wait + 1'b1;
        if (delay_load_wait == LOAD_WAIT-1) begin
          delay_load_int <= 1'b1;
          delay_load_pending <= 1'b0;
        end
      end

      if (delay_dld_s == 1'b1) begin
        delay_target <= delay_target_limited_s;
      end

      if ((delay_load_pending == 1'b1) || (delay_load_int == 1'b1)) begin
        delay_move_int <= 1'b0;
      end else if (IODELAY_MODE == 2) begin
        if ((delay_out_of_range == 1'b1) && (delay_move_int == 1'b1)) begin
          delay_move_int <= 1'b0;
          if (delay_direction_int == 1'b1) begin
            delay_value <= IOD_DELAY_MAX;
            delay_target <= IOD_DELAY_MAX;
          end else begin
            delay_value <= {INTERNAL_DELAY_WIDTH{1'b0}};
            delay_target <= {INTERNAL_DELAY_WIDTH{1'b0}};
          end
        end else if (delay_move_int == 1'b1) begin
          delay_move_int <= 1'b0;
        end else if (delay_value < delay_target) begin
          if (delay_direction_int != 1'b1) begin
            delay_direction_int <= 1'b1;
            delay_move_int <= 1'b0;
          end else begin
            delay_move_int <= 1'b1;
            delay_value <= delay_value + 1'b1;
          end
        end else if (delay_value > delay_target) begin
          if (delay_direction_int != 1'b0) begin
            delay_direction_int <= 1'b0;
            delay_move_int <= 1'b0;
          end else begin
            delay_move_int <= 1'b1;
            delay_value <= delay_value - 1'b1;
          end
        end else begin
          delay_move_int <= 1'b0;
        end
      end else begin
        delay_move_int <= 1'b0;
        delay_direction_int <= 1'b0;
        delay_target <= RESET_DELAY_VALUE;
        delay_value <= RESET_DELAY_VALUE;
      end
    end
  end

endmodule
