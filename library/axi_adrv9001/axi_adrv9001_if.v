// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2025 Analog Devices, Inc. All rights reserved.
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

module axi_adrv9001_if #(
  parameter CMOS_LVDS_N = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter EN_RX_MCS_TO_STRB_M = 0,
  parameter NUM_LANES = 3,
  parameter DRP_WIDTH = 5,
  parameter RX_USE_BUFG = 0,
  parameter TX_USE_BUFG = 0,
  parameter DISABLE_RX1_SSI = 0,
  parameter DISABLE_TX1_SSI = 0,
  parameter DISABLE_RX2_SSI = 0,
  parameter DISABLE_TX2_SSI = 0,
  parameter IODELAY_CTRL = 1,
  parameter IODELAY_ENABLE = 1,
  parameter IO_DELAY_GROUP = "dev_if_delay_group",
  parameter USE_RX_CLK_FOR_TX1 = 0,
  parameter USE_RX_CLK_FOR_TX2 = 0
) (
  input             mcs_6th_pulse,
  input             tx_output_enable,

  input             mssi_sync,

  // device interface
  input             rx1_dclk_in_n_NC,
  input             rx1_dclk_in_p_dclk_in,
  input             rx1_idata_in_n_idata0,
  input             rx1_idata_in_p_idata1,
  input             rx1_qdata_in_n_qdata2,
  input             rx1_qdata_in_p_qdata3,
  input             rx1_strobe_in_n_NC,
  input             rx1_strobe_in_p_strobe_in,

  input             rx2_dclk_in_n_NC,
  input             rx2_dclk_in_p_dclk_in,
  input             rx2_idata_in_n_idata0,
  input             rx2_idata_in_p_idata1,
  input             rx2_qdata_in_n_qdata2,
  input             rx2_qdata_in_p_qdata3,
  input             rx2_strobe_in_n_NC,
  input             rx2_strobe_in_p_strobe_in,

  output            tx1_dclk_out_n_NC,
  output            tx1_dclk_out_p_dclk_out,
  input             tx1_dclk_in_n_NC,
  input             tx1_dclk_in_p_dclk_in,
  output            tx1_idata_out_n_idata0,
  output            tx1_idata_out_p_idata1,
  output            tx1_qdata_out_n_qdata2,
  output            tx1_qdata_out_p_qdata3,
  output            tx1_strobe_out_n_NC,
  output            tx1_strobe_out_p_strobe_out,

  output            tx2_dclk_out_n_NC,
  output            tx2_dclk_out_p_dclk_out,
  input             tx2_dclk_in_n_NC,
  input             tx2_dclk_in_p_dclk_in,
  output            tx2_idata_out_n_idata0,
  output            tx2_idata_out_p_idata1,
  output            tx2_qdata_out_n_qdata2,
  output            tx2_qdata_out_p_qdata3,
  output            tx2_strobe_out_n_NC,
  output            tx2_strobe_out_p_strobe_out,

  // delay interface (for IDELAY macros)
  input             delay_clk,
  input             delay_rx1_rst,
  input             delay_rx2_rst,
  output            delay_rx1_locked,
  output            delay_rx2_locked,

  input             up_clk,

  input   [NUM_LANES-1:0]           up_rx1_dld,
  input   [DRP_WIDTH*NUM_LANES-1:0] up_rx1_dwdata,
  output  [DRP_WIDTH*NUM_LANES-1:0] up_rx1_drdata,

  input   [NUM_LANES-1:0]           up_rx2_dld,
  input   [DRP_WIDTH*NUM_LANES-1:0] up_rx2_dwdata,
  output  [DRP_WIDTH*NUM_LANES-1:0] up_rx2_drdata,

  // upper layer data interface

  output [ 31:0]    adc_clk_ratio,
  output [ 31:0]    dac_clk_ratio,

  output [  9:0]    rx1_mcs_to_strobe_delay,
  output [  9:0]    rx2_mcs_to_strobe_delay,

  output            rx1_clk,
  input             rx1_rst,
  output            rx1_if_rst,
  output            rx1_data_valid,
  output    [15:0]  rx1_data_i,
  output    [15:0]  rx1_data_q,

  input             rx1_single_lane,
  input             rx1_sdr_ddr_n,
  input             rx1_symb_op,
  input             rx1_symb_8_16b,

  output            rx2_clk,
  input             rx2_rst,
  output            rx2_if_rst,
  output            rx2_data_valid,
  output    [15:0]  rx2_data_i,
  output    [15:0]  rx2_data_q,

  input             rx2_single_lane,
  input             rx2_sdr_ddr_n,
  input             rx2_symb_op,
  input             rx2_symb_8_16b,

  output            tx1_clk,
  input             tx1_rst,
  output            tx1_if_rst,
  input             tx1_data_valid,
  input     [15:0]  tx1_data_i,
  input     [15:0]  tx1_data_q,

  input             tx1_single_lane,
  input             tx1_sdr_ddr_n,
  input             tx1_symb_op,
  input             tx1_symb_8_16b,

  output            tx2_clk,
  input             tx2_rst,
  output            tx2_if_rst,
  input             tx2_data_valid,
  input     [15:0]  tx2_data_i,
  input     [15:0]  tx2_data_q,

  input             tx2_single_lane,
  input             tx2_sdr_ddr_n,
  input             tx2_symb_op,
  input             tx2_symb_8_16b
);

  // Tx has an extra lane to drive the clock
  localparam TX_NUM_LANES = NUM_LANES + 1;

  wire        adc_1_clk_div;
  wire  [7:0] adc_1_data_0;
  wire  [7:0] adc_1_data_1;
  wire  [7:0] adc_1_data_2;
  wire  [7:0] adc_1_data_3;
  wire  [7:0] adc_1_data_strobe;
  wire        adc_1_clk;
  wire        adc_1_valid;

  wire        adc_2_clk_div;
  wire  [7:0] adc_2_data_0;
  wire  [7:0] adc_2_data_1;
  wire  [7:0] adc_2_data_2;
  wire  [7:0] adc_2_data_3;
  wire  [7:0] adc_2_data_strobe;
  wire        adc_2_clk;
  wire        adc_2_valid;

  wire        dac_1_clk_div;
  wire  [7:0] dac_1_data_0;
  wire  [7:0] dac_1_data_1;
  wire  [7:0] dac_1_data_2;
  wire  [7:0] dac_1_data_3;
  wire  [7:0] dac_1_data_strobe;
  wire  [7:0] dac_1_data_clk;
  wire        dac_1_data_valid;

  wire        dac_2_clk_div;
  wire  [7:0] dac_2_data_0;
  wire  [7:0] dac_2_data_1;
  wire  [7:0] dac_2_data_2;
  wire  [7:0] dac_2_data_3;
  wire  [7:0] dac_2_data_strobe;
  wire  [7:0] dac_2_data_clk;
  wire        dac_2_data_valid;

  wire        ext_tx1_clk_div;
  wire        ext_tx1_clk;
  wire        ext_tx2_clk_div;
  wire        ext_tx2_clk;

  generate
  if (DISABLE_RX1_SSI == 0) begin

    adrv9001_rx #(
      .CMOS_LVDS_N (CMOS_LVDS_N),
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .EN_RX_MCS_TO_STRB_M (EN_RX_MCS_TO_STRB_M),
      .NUM_LANES (NUM_LANES),
      .DRP_WIDTH (DRP_WIDTH),
      .IODELAY_CTRL (IODELAY_CTRL),
      .IODELAY_ENABLE (IODELAY_ENABLE),
      .USE_BUFG (RX_USE_BUFG),
      .IO_DELAY_GROUP ({IO_DELAY_GROUP,"_rx"})
    ) i_rx_1_phy (
      .rx_dclk_in_n_NC (rx1_dclk_in_n_NC),
      .rx_dclk_in_p_dclk_in (rx1_dclk_in_p_dclk_in),
      .rx_idata_in_n_idata0 (rx1_idata_in_n_idata0),
      .rx_idata_in_p_idata1 (rx1_idata_in_p_idata1),
      .rx_qdata_in_n_qdata2 (rx1_qdata_in_n_qdata2),
      .rx_qdata_in_p_qdata3 (rx1_qdata_in_p_qdata3),
      .rx_strobe_in_n_NC (rx1_strobe_in_n_NC),
      .rx_strobe_in_p_strobe_in (rx1_strobe_in_p_strobe_in),

      .mcs_6th_pulse (mcs_6th_pulse),

      .adc_rst (rx1_rst),
      .adc_clk (adc_1_clk),
      .adc_if_rst (rx1_if_rst),
      .adc_clk_div (adc_1_clk_div),
      .adc_data_0 (adc_1_data_0),
      .adc_data_1 (adc_1_data_1),
      .adc_data_2 (adc_1_data_2),
      .adc_data_3 (adc_1_data_3),
      .adc_data_strobe (adc_1_data_strobe),
      .adc_valid (adc_1_valid),

      .adc_clk_ratio (adc_clk_ratio),
      .mcs_to_strobe_delay (rx1_mcs_to_strobe_delay),

      .up_clk (up_clk),
      .up_adc_dld (up_rx1_dld),
      .up_adc_dwdata (up_rx1_dwdata),
      .up_adc_drdata (up_rx1_drdata),
      .delay_clk (delay_clk),
      .delay_rst (delay_rx1_rst),
      .delay_locked (delay_rx1_locked),

      .mssi_sync (mssi_sync));

    adrv9001_rx_link #(
      .CMOS_LVDS_N (CMOS_LVDS_N)
    ) i_rx_1_link (
      .adc_rst (rx1_if_rst),
      .adc_clk_div (adc_1_clk_div),
      .adc_data_0 (adc_1_data_0),
      .adc_data_1 (adc_1_data_1),
      .adc_data_2 (adc_1_data_2),
      .adc_data_3 (adc_1_data_3),
      .adc_data_strobe (adc_1_data_strobe),
      .adc_valid (adc_1_valid),

      // ADC interface
      .rx_clk (rx1_clk),
      .rx_data_valid (rx1_data_valid),
      .rx_data_i (rx1_data_i),
      .rx_data_q (rx1_data_q),
      .rx_single_lane (rx1_single_lane),
      .rx_sdr_ddr_n (rx1_sdr_ddr_n),
      .rx_symb_op (rx1_symb_op),
      .rx_symb_8_16b (rx1_symb_8_16b));

  end else begin
    assign delay_rx1_locked = 1'b1;
    assign up_rx1_drdata = 'h0;
    assign rx1_clk = 1'b0;
    assign adc_1_clk_div = 1'b0;
    assign adc_1_clk = 1'b0;
    assign rx1_data_valid = 1'b0;
    assign rx1_data_i = 16'b0;
    assign rx1_data_q = 16'b0;
  end

  if (DISABLE_RX2_SSI == 0) begin
    adrv9001_rx #(
      .CMOS_LVDS_N (CMOS_LVDS_N),
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .EN_RX_MCS_TO_STRB_M (EN_RX_MCS_TO_STRB_M),
      .NUM_LANES (NUM_LANES),
      .DRP_WIDTH (DRP_WIDTH),
      .IODELAY_CTRL (DISABLE_RX1_SSI),
      .IODELAY_ENABLE (IODELAY_ENABLE),
      .USE_BUFG (RX_USE_BUFG),
      .IO_DELAY_GROUP ({IO_DELAY_GROUP,"_rx"})
    ) i_rx_2_phy (
      .rx_dclk_in_n_NC (rx2_dclk_in_n_NC),
      .rx_dclk_in_p_dclk_in (rx2_dclk_in_p_dclk_in),
      .rx_idata_in_n_idata0 (rx2_idata_in_n_idata0),
      .rx_idata_in_p_idata1 (rx2_idata_in_p_idata1),
      .rx_qdata_in_n_qdata2 (rx2_qdata_in_n_qdata2),
      .rx_qdata_in_p_qdata3 (rx2_qdata_in_p_qdata3),
      .rx_strobe_in_n_NC (rx2_strobe_in_n_NC),
      .rx_strobe_in_p_strobe_in (rx2_strobe_in_p_strobe_in),

      .mcs_6th_pulse (mcs_6th_pulse),

      .adc_rst (rx2_rst),
      .adc_clk (adc_2_clk),
      .adc_if_rst (rx2_if_rst),
      .adc_clk_div (adc_2_clk_div),
      .adc_data_0 (adc_2_data_0),
      .adc_data_1 (adc_2_data_1),
      .adc_data_2 (adc_2_data_2),
      .adc_data_3 (adc_2_data_3),
      .adc_data_strobe (adc_2_data_strobe),
      .adc_valid (adc_2_valid),

      .mcs_to_strobe_delay (rx2_mcs_to_strobe_delay),

      .up_clk (up_clk),
      .up_adc_dld (up_rx2_dld),
      .up_adc_dwdata (up_rx2_dwdata),
      .up_adc_drdata (up_rx2_drdata),
      .delay_clk (delay_clk),
      .delay_rst (delay_rx2_rst),
      .delay_locked (delay_rx2_locked),
      .mssi_sync (mssi_sync));

    adrv9001_rx_link #(
      .CMOS_LVDS_N (CMOS_LVDS_N)
    ) i_rx_2_link (
      .adc_rst (rx2_if_rst),
      .adc_clk_div (adc_2_clk_div),
      .adc_data_0 (adc_2_data_0),
      .adc_data_1 (adc_2_data_1),
      .adc_data_2 (adc_2_data_2),
      .adc_data_3 (adc_2_data_3),
      .adc_data_strobe (adc_2_data_strobe),
      .adc_valid (adc_2_valid),
      // ADC interface
      .rx_clk (rx2_clk),
      .rx_data_valid (rx2_data_valid),
      .rx_data_i (rx2_data_i),
      .rx_data_q (rx2_data_q),
      .rx_single_lane (rx2_single_lane),
      .rx_sdr_ddr_n (rx2_sdr_ddr_n),
      .rx_symb_op (rx2_symb_op),
      .rx_symb_8_16b (rx2_symb_8_16b));
  end else begin
    assign delay_rx2_locked = 1'b1;
    assign up_rx2_drdata = 'h0;
    assign rx2_clk = 1'b0;
    assign adc_2_clk_div = 1'b0;
    assign adc_2_clk = 1'b0;
    assign rx2_data_valid = 1'b0;
    assign rx2_data_i = 16'b0;
    assign rx2_data_q = 16'b0;
  end

  if (DISABLE_TX1_SSI == 0) begin

    if (USE_RX_CLK_FOR_TX1 == 1) begin
      assign ext_tx1_clk_div = adc_1_clk_div;
      assign ext_tx1_clk = adc_1_clk;
    end else if (USE_RX_CLK_FOR_TX1 == 2) begin
      assign ext_tx1_clk_div = adc_2_clk_div;
      assign ext_tx1_clk = adc_2_clk;
    end else begin
      assign ext_tx1_clk_div = 1'b0;
      assign ext_tx1_clk = 1'b0;
    end

  adrv9001_tx #(
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .NUM_LANES (TX_NUM_LANES),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .USE_BUFG (TX_USE_BUFG),
    .USE_RX_CLK_FOR_TX (USE_RX_CLK_FOR_TX1)
  ) i_tx_1_phy (
    .up_clk (up_clk),

    .tx_output_enable(tx_output_enable),

    .tx_dclk_out_n_NC (tx1_dclk_out_n_NC),
    .tx_dclk_out_p_dclk_out (tx1_dclk_out_p_dclk_out),
    .tx_dclk_in_n_NC (tx1_dclk_in_n_NC),
    .tx_dclk_in_p_dclk_in (tx1_dclk_in_p_dclk_in),
    .tx_idata_out_n_idata0 (tx1_idata_out_n_idata0),
    .tx_idata_out_p_idata1 (tx1_idata_out_p_idata1),
    .tx_qdata_out_n_qdata2 (tx1_qdata_out_n_qdata2),
    .tx_qdata_out_p_qdata3 (tx1_qdata_out_p_qdata3),
    .tx_strobe_out_n_NC (tx1_strobe_out_n_NC),
    .tx_strobe_out_p_strobe_out (tx1_strobe_out_p_strobe_out),

    .rx_clk_div (adc_1_clk_div),
    .rx_clk (adc_1_clk),

    .dac_rst (tx1_rst),
    .dac_if_rst (tx1_if_rst),
    .dac_clk_div (dac_1_clk_div),

    .dac_data_0 (dac_1_data_0),
    .dac_data_1 (dac_1_data_1),
    .dac_data_2 (dac_1_data_2),
    .dac_data_3 (dac_1_data_3),
    .dac_data_strb (dac_1_data_strobe),
    .dac_data_clk (dac_1_data_clk),
    .dac_data_valid (dac_1_data_valid),

    .dac_clk_ratio (dac_clk_ratio),

    .mssi_sync (mssi_sync));

  adrv9001_tx_link #(
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .CLK_DIV_IS_FAST_CLK (FPGA_TECHNOLOGY >= 100)
  ) i_tx_1_link (
    .dac_clk_div (dac_1_clk_div),
    .dac_data_0 (dac_1_data_0),
    .dac_data_1 (dac_1_data_1),
    .dac_data_2 (dac_1_data_2),
    .dac_data_3 (dac_1_data_3),
    .dac_data_strobe (dac_1_data_strobe),
    .dac_data_clk (dac_1_data_clk),
    .dac_data_valid (dac_1_data_valid),
    // DAC interface
    .tx_clk (tx1_clk),
    .tx_rst (tx1_rst),
    .tx_data_valid (tx1_data_valid),
    .tx_data_i (tx1_data_i),
    .tx_data_q (tx1_data_q),
    .tx_sdr_ddr_n (tx1_sdr_ddr_n),
    .tx_single_lane (tx1_single_lane),
    .tx_symb_op (tx1_symb_op),
    .tx_symb_8_16b (tx1_symb_8_16b));
  end else begin
    assign tx1_clk = 1'b0;
    assign tx1_dclk_out_n_NC = 1'b0;
    assign tx1_dclk_out_p_dclk_out = 1'b0;
    assign tx1_idata_out_n_idata0 = 1'b0;
    assign tx1_idata_out_p_idata1 = 1'b0;
    assign tx1_qdata_out_n_qdata2 = 1'b0;
    assign tx1_qdata_out_p_qdata3 = 1'b0;
    assign tx1_strobe_out_n_NC = 1'b0;
    assign tx1_strobe_out_p_strobe_out = 1'b0;
  end

  if (DISABLE_TX2_SSI == 0) begin

    if (USE_RX_CLK_FOR_TX2 == 1) begin
      assign ext_tx2_clk_div = adc_1_clk_div;
      assign ext_tx2_clk = adc_1_clk;
    end else if (USE_RX_CLK_FOR_TX2 == 2) begin
      assign ext_tx2_clk_div = adc_2_clk_div;
      assign ext_tx2_clk = adc_2_clk;
    end else begin
      assign ext_tx2_clk_div = 1'b0;
      assign ext_tx2_clk = 1'b0;
    end

    adrv9001_tx #(
      .CMOS_LVDS_N (CMOS_LVDS_N),
      .NUM_LANES (TX_NUM_LANES),
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .USE_BUFG (TX_USE_BUFG),
      .USE_RX_CLK_FOR_TX (USE_RX_CLK_FOR_TX2)
    ) i_tx_2_phy (
      .up_clk (up_clk),

      .tx_output_enable(tx_output_enable),

      .tx_dclk_out_n_NC (tx2_dclk_out_n_NC),
      .tx_dclk_out_p_dclk_out (tx2_dclk_out_p_dclk_out),
      .tx_dclk_in_n_NC (tx2_dclk_in_n_NC),
      .tx_dclk_in_p_dclk_in (tx2_dclk_in_p_dclk_in),
      .tx_idata_out_n_idata0 (tx2_idata_out_n_idata0),
      .tx_idata_out_p_idata1 (tx2_idata_out_p_idata1),
      .tx_qdata_out_n_qdata2 (tx2_qdata_out_n_qdata2),
      .tx_qdata_out_p_qdata3 (tx2_qdata_out_p_qdata3),
      .tx_strobe_out_n_NC (tx2_strobe_out_n_NC),
      .tx_strobe_out_p_strobe_out (tx2_strobe_out_p_strobe_out),

      .rx_clk_div (adc_2_clk_div),
      .rx_clk (adc_2_clk),

      .dac_rst (tx2_rst),
      .dac_if_rst (tx2_if_rst),
      .dac_clk_div (dac_2_clk_div),
      .dac_data_0 (dac_2_data_0),
      .dac_data_1 (dac_2_data_1),
      .dac_data_2 (dac_2_data_2),
      .dac_data_3 (dac_2_data_3),
      .dac_data_strb (dac_2_data_strobe),
      .dac_data_clk (dac_2_data_clk),
      .dac_data_valid (dac_2_data_valid),

      .mssi_sync (mssi_sync));

    adrv9001_tx_link #(
      .CMOS_LVDS_N (CMOS_LVDS_N),
      .CLK_DIV_IS_FAST_CLK (FPGA_TECHNOLOGY >= 100)
    ) i_tx_2_link (
      .dac_clk_div (dac_2_clk_div),
      .dac_data_0 (dac_2_data_0),
      .dac_data_1 (dac_2_data_1),
      .dac_data_2 (dac_2_data_2),
      .dac_data_3 (dac_2_data_3),
      .dac_data_strobe (dac_2_data_strobe),
      .dac_data_clk (dac_2_data_clk),
      .dac_data_valid (dac_2_data_valid),
      // DAC interface
      .tx_clk (tx2_clk),
      .tx_rst (tx2_rst),
      .tx_data_valid (tx2_data_valid),
      .tx_data_i (tx2_data_i),
      .tx_data_q (tx2_data_q),
      .tx_sdr_ddr_n (tx2_sdr_ddr_n),
      .tx_single_lane (tx2_single_lane),
      .tx_symb_op (tx2_symb_op),
      .tx_symb_8_16b (tx2_symb_8_16b));
  end else begin
    assign tx2_clk = 1'b0;
    assign tx2_dclk_out_n_NC = 1'b0;
    assign tx2_dclk_out_p_dclk_out = 1'b0;
    assign tx2_idata_out_n_idata0 = 1'b0;
    assign tx2_idata_out_p_idata1 = 1'b0;
    assign tx2_qdata_out_n_qdata2 = 1'b0;
    assign tx2_qdata_out_p_qdata3 = 1'b0;
    assign tx2_strobe_out_n_NC = 1'b0;
    assign tx2_strobe_out_p_strobe_out = 1'b0;
  end
  endgenerate

endmodule
