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

// ad_data_clk wraps the Microchip input clock path.
//
// CLK_MODE selects the clock path:
// * 0: no ICB_CLKDIVDELAY, clk and clk_div are the buffered input.
// * 1: one ICB_CLKDIVDELAY. clk is its Y output, the input with the clock
//   delay; clk_div is its Y_DIV output, the input divided by CLK_DIVIDER, not
//   delayed in the vendor model. rst stops clk_div.
// * 2: the clock tree of a geared (ad_serdes_in) interface, as the Libero
//   PF_IOD_GENERIC_RX core with a global fabric clock builds it: the input
//   (on a CLKIN_z_w pin) drives an HS_IO_CLK and two ICB_CLKDIVDELAY.
//   - The rx divider gives hs_clk_rx, the clock of the IOD sampling and of
//     the IOD FIFO write side, through the lane controller. It carries the
//     clock delay.
//   - The fifo divider gives hs_clk_fifo, the clock of the IOD FIFO read side
//     and of the gearing, and clk_div, the fabric clock (Y_DIV on a global
//     clock); FIFO_CLK_DELAY_VAL is its static delay.
//   - rst stops clk_div, the serdes clocks keep running. In the vendor model
//     RST_N only gates Y_DIV (not Y_FB), and the divider phase is not
//     restarted by it.
//   - clk is not used (0).
// * The CLK_DIVIDER parameter selects the divide ratio, the IOD gearing in
//   mode 2. According to the vendor model:
//   - 3'b001 -> /1
//   - 3'b010 -> /2
//   - 3'b100 -> /4
//   - 3'b101 -> /5
//   - 3'b111 -> /3.5
//
// The clock delay (modes 1 and 2) is controlled by ad_iod_delay_ctrl, as the
// data delays of ad_data_in: IODELAY_MODE 0 - no delay line, 1 - static, the
// IOD_DELAY_INIT taps, 2 - dynamic, IOD_DELAY_INIT after reset, then set on
// the up_clk interface. locked is the delay_locked of the controller, 1
// without a delay line.

module ad_data_clk #(

  parameter   SINGLE_ENDED = 0,
  parameter   CLK_MODE = 0,
  parameter [2:0] CLK_DIVIDER = 3'b001,
  parameter   IODELAY_MODE = 0,
  parameter   REFCLK_FREQUENCY = 200,
  parameter   DELAY_STEP_COEFFICIENT = 0,
  parameter [7:0] IOD_DELAY_INIT = 8'b00000000,
  parameter [7:0] FIFO_CLK_DELAY_VAL = 8'b00000001,
  parameter   ASYNC_DELAY_CLK = 1,
  parameter   DRP_WIDTH = 5
) (
  input               rst,
  output              locked,

  input               clk_in_p,
  input               clk_in_n,
  output              clk,
  output              clk_div,
  output              hs_clk_rx,
  output              hs_clk_fifo,

  // clock delay interface

  input                     up_clk,
  input                     up_dld,
  input   [DRP_WIDTH-1:0]   up_dwdata,
  output  [DRP_WIDTH-1:0]   up_drdata,
  input                     delay_clk,
  input                     delay_rst
);

  localparam  DELAY_ENABLE = (CLK_MODE != 0) && (IODELAY_MODE != 0);

  wire                clk_ibuf_s;
  wire                delay_locked_s;
  wire                delay_move_s;
  wire                delay_direction_s;
  wire                delay_load_s;
  wire                delay_out_of_range_s;

  assign locked = (DELAY_ENABLE) ? delay_locked_s : 1'b1;

  generate
  if (SINGLE_ENDED == 1) begin
    INBUF i_clk_ibuf (
      .PAD (clk_in_p),
      .Y (clk_ibuf_s));
  end else begin
    INBUF_DIFF i_clk_ibuf (
      .PADP (clk_in_p),
      .PADN (clk_in_n),
      .Y (clk_ibuf_s));
  end
  endgenerate

  // clock delay

  generate
  if (DELAY_ENABLE) begin
    ad_iod_delay_ctrl #(
      .IODELAY_MODE (IODELAY_MODE),
      .REFCLK_FREQUENCY (REFCLK_FREQUENCY),
      .DELAY_STEP_COEFFICIENT (DELAY_STEP_COEFFICIENT),
      .RX_DELAY_VAL_X2 (1'b1),
      .IOD_DELAY_INIT (IOD_DELAY_INIT),
      .ASYNC_DELAY_CLK (ASYNC_DELAY_CLK),
      .DRP_WIDTH (DRP_WIDTH)
    ) i_delay_ctrl (
      .up_clk (up_clk),
      .up_dld (up_dld),
      .up_dwdata (up_dwdata),
      .up_drdata (up_drdata),
      .delay_clk (delay_clk),
      .delay_rst (delay_rst),
      .delay_locked (delay_locked_s),
      .delay_out_of_range (delay_out_of_range_s),
      .delay_move (delay_move_s),
      .delay_direction (delay_direction_s),
      .delay_load (delay_load_s));
  end else begin
    assign up_drdata = {DRP_WIDTH{1'b0}};
    assign delay_locked_s = 1'b1;
    assign delay_move_s = 1'b0;
    assign delay_direction_s = 1'b0;
    assign delay_load_s = 1'b0;
  end
  endgenerate

  generate
  if (CLK_MODE == 1) begin

    ICB_CLKDIVDELAY #(
      .DELAY_LINE_SIMULATION_MODE ((DELAY_ENABLE) ? "ENABLED" : "DISABLED"),
      .DIVIDER (CLK_DIVIDER),
      .DELAY_LINE_EN (DELAY_ENABLE),
      .DELAY_LINE_VAL (IOD_DELAY_INIT),
      .DELAY_VAL_X2 (1'b1),
      .FB_SOURCE_SEL_0 (1'b0),
      .FB_SOURCE_SEL_1 (1'b1)
    ) i_clk_delay (
      .DELAY_LINE_OUT_OF_RANGE (delay_out_of_range_s),
      .DELAY_LINE_DIR (delay_direction_s),
      .DELAY_LINE_MOVE (delay_move_s),
      .DELAY_LINE_LOAD (delay_load_s),
      .RST_N (~rst),
      .BIT_SLIP (1'b0),
      .A (clk_ibuf_s),
      .Y_DIV (clk_div),
      .Y (clk),
      .Y_FB (),
      .Y_ND ());

    assign hs_clk_rx = 1'b0;
    assign hs_clk_fifo = 1'b0;

  end else if (CLK_MODE == 2) begin

    wire  hs_clk_cascaded_s;
    wire  hs_clk_rx_s;
    wire  hs_clk_fifo_s;
    wire  clk_div_s;

    HS_IO_CLK i_hs_clk_cascaded (
      .A (clk_ibuf_s),
      .Y (hs_clk_cascaded_s));

    ICB_CLKDIVDELAY #(
      .DELAY_LINE_SIMULATION_MODE ((DELAY_ENABLE) ? "ENABLED" : "DISABLED"),
      .DIVIDER (CLK_DIVIDER),
      .DELAY_LINE_EN (1'b1),
      .DELAY_LINE_VAL (IOD_DELAY_INIT),
      .DELAY_VAL_X2 (1'b1),
      .FB_SOURCE_SEL_0 (1'b0),
      .FB_SOURCE_SEL_1 (1'b1)
    ) i_clk_div_rx (
      .DELAY_LINE_OUT_OF_RANGE (delay_out_of_range_s),
      .DELAY_LINE_DIR (delay_direction_s),
      .DELAY_LINE_MOVE (delay_move_s),
      .DELAY_LINE_LOAD (delay_load_s),
      .RST_N (1'b1),
      .BIT_SLIP (1'b0),
      .A (hs_clk_cascaded_s),
      .Y_DIV (),
      .Y (),
      .Y_FB (hs_clk_rx_s),
      .Y_ND ());

    ICB_CLKDIVDELAY #(
      .DELAY_LINE_SIMULATION_MODE ("DISABLED"),
      .DIVIDER (CLK_DIVIDER),
      .DELAY_LINE_EN (1'b1),
      .DELAY_LINE_VAL (FIFO_CLK_DELAY_VAL),
      .DELAY_VAL_X2 (1'b1),
      .FB_SOURCE_SEL_0 (1'b0),
      .FB_SOURCE_SEL_1 (1'b1)
    ) i_clk_div_fifo (
      .DELAY_LINE_OUT_OF_RANGE (),
      .DELAY_LINE_DIR (1'b0),
      .DELAY_LINE_MOVE (1'b0),
      .DELAY_LINE_LOAD (1'b0),
      .RST_N (~rst),
      .BIT_SLIP (1'b0),
      .A (hs_clk_cascaded_s),
      .Y_DIV (clk_div_s),
      .Y (),
      .Y_FB (hs_clk_fifo_s),
      .Y_ND ());

    HS_IO_CLK i_hs_clk_rx (
      .A (hs_clk_rx_s),
      .Y (hs_clk_rx));

    HS_IO_CLK i_hs_clk_fifo (
      .A (hs_clk_fifo_s),
      .Y (hs_clk_fifo));

    CLKINT i_clk_div (
      .A (clk_div_s),
      .Y (clk_div));

    assign clk = 1'b0;

  end else begin

    assign delay_out_of_range_s = 1'b0;
    assign clk = clk_ibuf_s;
    assign clk_div = clk_ibuf_s;
    assign hs_clk_rx = 1'b0;
    assign hs_clk_fifo = 1'b0;

  end
  endgenerate

endmodule
