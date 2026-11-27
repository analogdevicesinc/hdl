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

module ad_data_out #(
  parameter   SINGLE_ENDED = 0,
  parameter   IODELAY_MODE = 0,
  parameter   TX_CLK_INV = 1'b1,
  parameter   REFCLK_FREQUENCY = 200,
  parameter   DELAY_STEP_COEFFICIENT = 0,
  parameter [7:0] IOD_DELAY_INIT = 8'b00000001,
  parameter   ASYNC_DELAY_CLK = 1,
  // registers before the IOD, the same on both halves
  parameter   PIPE_REGS = 0
) (

  input               tx_clk,
  input               tx_data_p,
  input               tx_data_n,
  output              tx_data_out_p,
  output              tx_data_out_n,

  input               up_clk,
  input               up_dld,
  input       [ 4:0]  up_dwdata,
  output      [ 4:0]  up_drdata,

  input               delay_clk,
  input               delay_rst,
  output              delay_locked
);

  localparam integer  IOD_DELAY_MAX = 127;
  localparam [7:0]    IOD_DELAY_INIT_LIMITED = (IOD_DELAY_INIT > IOD_DELAY_MAX) ? IOD_DELAY_MAX : IOD_DELAY_INIT;

  wire                delay_out_of_range_s;
  wire                tx_pad_s;
  wire                delay_move_s;
  wire                delay_direction_s;
  wire                delay_load_s;
  wire                tx_data_p_s;
  wire                tx_data_n_s;

  // the IOD takes a single register here, not the logic in front of the input

  generate
  if (PIPE_REGS == 0) begin
    assign tx_data_p_s = tx_data_p;
    assign tx_data_n_s = tx_data_n;
  end else begin
    reg [PIPE_REGS-1:0] tx_data_p_pipe = 'd0;
    reg [PIPE_REGS-1:0] tx_data_n_pipe = 'd0;

    always @(posedge tx_clk) begin
      tx_data_p_pipe <= {tx_data_p_pipe, tx_data_p};
      tx_data_n_pipe <= {tx_data_n_pipe, tx_data_n};
    end

    assign tx_data_p_s = tx_data_p_pipe[PIPE_REGS-1];
    assign tx_data_n_s = tx_data_n_pipe[PIPE_REGS-1];
  end
  endgenerate

  ad_iod_delay_ctrl #(
    .IODELAY_MODE (IODELAY_MODE),
    .REFCLK_FREQUENCY (REFCLK_FREQUENCY),
    .DELAY_STEP_COEFFICIENT (DELAY_STEP_COEFFICIENT),
    .RX_DELAY_VAL_X2 (1'b0),
    .IOD_DELAY_INIT (IOD_DELAY_INIT),
    .ASYNC_DELAY_CLK (ASYNC_DELAY_CLK),
    .DRP_WIDTH (5)
  ) i_delay_ctrl (
    .up_clk (up_clk),
    .up_dld (up_dld),
    .up_dwdata (up_dwdata),
    .up_drdata (up_drdata),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked),
    .delay_out_of_range (delay_out_of_range_s),
    .delay_move (delay_move_s),
    .delay_direction (delay_direction_s),
    .delay_load (delay_load_s));

  IOD #(
    .DATA_RATE(800.0),
    .FORMAL_NAME("PF_IO"),
    .INTERFACE_NAME("NA"),
    .DELAY_LINE_SIMULATION_MODE("ENABLED"),
    .RESERVED_0(1'b0),
    .RX_CLK_EN(1'b0),
    .RX_CLK_INV(1'b0),
    .TX_CLK_EN(1'b1),
    .TX_CLK_INV(TX_CLK_INV),
    .HS_IO_CLK_SEL(3'b000),
    .QDR_EN(1'b0),
    .EDGE_DETECT_EN(1'b0),
    .DELAY_LINE_MODE((IODELAY_MODE != 0) ? 2'b10 : 2'b00),
    .RX_MODE(4'b0000),
    .EYE_MONITOR_MODE(1'b0),
    .DYN_DELAY_LINE_EN(IODELAY_MODE != 0),
    .FIFO_WR_EN(1'b0),
    .EYE_MONITOR_EN(1'b0),
    .TX_MODE(7'b1000001),
    .TX_CLK_SEL(2'b00),
    .TX_OE_MODE(3'b000),
    .TX_OE_CLK_INV(1'b0),
    .RX_DELAY_VAL((IODELAY_MODE != 0) ? 8'b00000001 : 8'b00000000),
    .RX_DELAY_VAL_X2(1'b0),
    .TX_DELAY_VAL((IODELAY_MODE != 0) ? IOD_DELAY_INIT_LIMITED : 8'b00000000),
    .EYE_MONITOR_WIDTH(3'b001),
    .EYE_MONITOR_WIDTH_SRC(1'b0),
    .RESERVED_1(1'b0),
    .DISABLE_LANECTRL_RESET(1'b1),
    .INPUT_DELAY_SEL(2'b00),
    .OEFF_EN_INV(1'b0),
    .INFF_EN_INV(1'b0),
    .OUTFF_EN_INV(1'b0)
  ) i_tx_data_iod (
    .EYE_MONITOR_EARLY(),
    .EYE_MONITOR_LATE(),
    .RX_DATA(),
    .DELAY_LINE_OUT_OF_RANGE(delay_out_of_range_s),
    .TX_DATA({6'b0, tx_data_p_s, tx_data_n_s}),
    .OE_DATA(4'b1111),
    .RX_BIT_SLIP(1'b0),
    .EYE_MONITOR_CLEAR_FLAGS(1'b0),
    .DELAY_LINE_MOVE(delay_move_s),
    .DELAY_LINE_DIRECTION(delay_direction_s),
    .DELAY_LINE_LOAD(delay_load_s),
    .RX_CLK(1'b0),
    .TX_CLK(tx_clk),
    .ODT_EN(1'b1),
    .INFF_SL(1'b0),
    .INFF_EN(1'b0),
    .OUTFF_SL(1'b0),
    .OUTFF_EN(1'b0),
    .AL_N(1'b0),
    .OEFF_LAT_N(1'b1),
    .OEFF_SD_N(1'b1),
    .OEFF_AD_N(1'b1),
    .INFF_LAT_N(1'b1),
    .INFF_SD_N(1'b1),
    .INFF_AD_N(1'b1),
    .OUTFF_LAT_N(1'b1),
    .OUTFF_SD_N(1'b1),
    .OUTFF_AD_N(1'b1),
    .RX_P(1'b0),
    .RX_N(),
    .TX_DATA_9(),
    .TX_DATA_8(),
    .ARST_N(1'b1),
    .RX_SYNC_RST(1'b1),
    .TX_SYNC_RST(1'b1),
    .HS_IO_CLK(6'b0),
    .RX_DQS_90(),
    .TX_DQS(1'b0),
    .TX_DQS_270(1'b0),
    .FIFO_WR_PTR(3'b0),
    .FIFO_RD_PTR(3'b0),
    .TX(tx_pad_s),
    .OE(),
    .CDR_CLK(1'b0),
    .CDR_NEXT_CLK(1'b0),
    .EYE_MONITOR_LANE_WIDTH(3'b0),
    .DDR_DO_READ(),
    .CDR_CLK_A_SEL_8(),
    .CDR_CLK_A_SEL_9(),
    .CDR_CLK_A_SEL_10(),
    .CDR_CLK_B_SEL(),
    .SWITCH(),
    .CDR_CLR_NEXT_CLK_N(),
    .TX_DATA_OUT_9(),
    .TX_DATA_OUT_8(),
    .AL_N_OUT(),
    .OUTFF_SL_OUT(),
    .OUTFF_EN_OUT(),
    .INFF_SL_OUT(),
    .INFF_EN_OUT(),
    .RX_CLK_OUT(),
    .TX_CLK_OUT());

  generate
  if (SINGLE_ENDED == 1) begin
    OUTBUF i_tx_data_obuf (
      .PAD (tx_data_out_p),
      .D (tx_pad_s));

    assign tx_data_out_n = 1'b0;
  end else begin
    OUTBUF_DIFF i_tx_data_obuf (
      .PADP (tx_data_out_p),
      .PADN (tx_data_out_n),
      .D (tx_pad_s));
  end
  endgenerate

endmodule
