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

module axi_adrv9001_core #(
  parameter ID = 0,
  parameter CMOS_LVDS_N = 0,
  parameter USE_RX1_CLK_FOR_TX = 0,
  parameter USE_RX2_CLK_FOR_TX = 0,
  parameter USE_RX_CLK_FOR_TX1 = 0,
  parameter USE_RX_CLK_FOR_TX2 = 0,
  parameter NUM_LANES = 3,
  parameter DRP_WIDTH = 5,
  parameter TDD_DISABLE = 0,
  parameter DDS_DISABLE = 0,
  parameter INDEPENDENT_1R1T_SUPPORT = 1,
  parameter COMMON_2R2T_SUPPORT = 1,
  parameter DISABLE_RX1_SSI = 0,
  parameter DISABLE_RX2_SSI = 0,
  parameter DISABLE_TX2_SSI = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,
  parameter EXT_SYNC = 0,
  parameter ENABLE_REF_CLK_MON = 0,
  parameter DAC_DDS_TYPE = 1,
  parameter DAC_DDS_CORDIC_DW = 20,
  parameter DAC_DDS_CORDIC_PHASE_DW = 18
) (

  // ADC interface
  input                   rx1_clk,
  output                  rx1_rst,
  input                   rx1_if_rst,
  input                   rx1_data_valid,
  input       [15:0]      rx1_data_i,
  input       [15:0]      rx1_data_q,

  output                  rx1_single_lane,
  output                  rx1_sdr_ddr_n,
  output                  rx1_symb_op,
  output                  rx1_symb_8_16b,

  input                   rx2_clk,
  output                  rx2_rst,
  input                   rx2_if_rst,
  input                   rx2_data_valid,
  input       [15:0]      rx2_data_i,
  input       [15:0]      rx2_data_q,

  output                  rx2_single_lane,
  output                  rx2_sdr_ddr_n,
  output                  rx2_symb_op,
  output                  rx2_symb_8_16b,

  // DAC interface
  input                   tx1_clk,
  output                  tx1_rst,
  input                   tx1_if_rst,
  output                  tx1_data_valid,
  output      [15:0]      tx1_data_i,
  output      [15:0]      tx1_data_q,

  output                  tx1_single_lane,
  output                  tx1_sdr_ddr_n,
  output                  tx1_symb_op,
  output                  tx1_symb_8_16b,

  input                   tx2_clk,
  output                  tx2_rst,
  input                   tx2_if_rst,
  output                  tx2_data_valid,
  output      [15:0]      tx2_data_i,
  output      [15:0]      tx2_data_q,

  output                  tx2_single_lane,
  output                  tx2_sdr_ddr_n,
  output                  tx2_symb_op,
  output                  tx2_symb_8_16b,

  input        [31:0]     adc_clk_ratio,
  input        [31:0]     dac_clk_ratio,

  input        [ 9:0]     rx1_mcs_to_strobe_delay,
  input        [ 9:0]     rx2_mcs_to_strobe_delay,

  output       [31:0]     sync_config,
  output       [31:0]     mcs_sync_pulse_width,
  output       [31:0]     mcs_sync_pulse_1_delay,
  output       [31:0]     mcs_sync_pulse_2_delay,
  output       [31:0]     mcs_sync_pulse_3_delay,
  output       [31:0]     mcs_sync_pulse_4_delay,
  output       [31:0]     mcs_sync_pulse_5_delay,
  output       [31:0]     mcs_sync_pulse_6_delay,

  // DMA interface
  output                  adc_1_valid,
  output                  adc_1_enable_i0,
  output      [15:0]      adc_1_data_i0,
  output                  adc_1_enable_q0,
  output      [15:0]      adc_1_data_q0,
  output                  adc_1_enable_i1,
  output      [15:0]      adc_1_data_i1,
  output                  adc_1_enable_q1,
  output      [15:0]      adc_1_data_q1,
  input                   adc_1_dovf,
  output                  adc_1_start_sync,

  output                  adc_2_valid,
  output                  adc_2_enable_i,
  output      [15:0]      adc_2_data_i,
  output                  adc_2_enable_q,
  output      [15:0]      adc_2_data_q,
  input                   adc_2_dovf,
  output                  adc_2_start_sync,

  output                  dac_1_valid,
  output                  dac_1_enable_i0,
  input       [15:0]      dac_1_data_i0,
  output                  dac_1_enable_q0,
  input       [15:0]      dac_1_data_q0,
  output                  dac_1_enable_i1,
  input       [15:0]      dac_1_data_i1,
  output                  dac_1_enable_q1,
  input       [15:0]      dac_1_data_q1,
  input                   dac_1_dunf,

  output                  dac_2_valid,
  output                  dac_2_enable_i0,
  input       [15:0]      dac_2_data_i0,
  output                  dac_2_enable_q0,
  input       [15:0]      dac_2_data_q0,
  input                   dac_2_dunf,

  // delay interface

  input                   delay_clk,
  output                  delay_rx1_rst,
  input                   delay_rx1_locked,
  output                  delay_rx2_rst,
  input                   delay_rx2_locked,

  output  [NUM_LANES-1:0]           up_rx1_dld,
  output  [DRP_WIDTH*NUM_LANES-1:0] up_rx1_dwdata,
  input   [DRP_WIDTH*NUM_LANES-1:0] up_rx1_drdata,

  output  [NUM_LANES-1:0]           up_rx2_dld,
  output  [DRP_WIDTH*NUM_LANES-1:0] up_rx2_dwdata,
  input   [DRP_WIDTH*NUM_LANES-1:0] up_rx2_drdata,

  // TDD interface
  input                   tdd_sync,
  output                  tdd_sync_cntr,

  output                  tdd_rx1_rf_en,
  output                  tdd_tx1_rf_en,
  output                  tdd_if1_mode,
  output                  tdd_rx2_rf_en,
  output                  tdd_tx2_rf_en,
  output                  tdd_if2_mode,

  // external syncronization signals
  input                   ref_clk,
  input                   rate_sync,
  input                   transfer_sync_in,

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output  reg             up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output  reg [31:0]      up_rdata,
  output  reg             up_rack
);

  // internal wires

  wire   [8:0]   up_wack_s;
  wire   [31:0]  up_rdata_s[0:8];
  wire   [8:0]   up_rack_s;

  wire           tx1_data_valid_A;
  wire   [15:0]  tx1_data_i_A;
  wire   [15:0]  tx1_data_q_A;
  wire           tx1_data_valid_B;
  wire   [15:0]  tx1_data_i_B;
  wire   [15:0]  tx1_data_q_B;
  wire           tx2_data_valid_A;
  wire   [15:0]  tx2_data_i_A;
  wire   [15:0]  tx2_data_q_A;
  wire           up_rx1_r1_mode;
  wire           rx1_r1_mode;
  wire           rx2_rst_loc;
  wire           rx2_single_lane_loc;
  wire           rx2_sdr_ddr_n_loc;
  wire           rx2_symb_op_loc;
  wire           rx2_symb_8_16b_loc;
  wire           up_tx1_r1_mode;
  wire           tx1_r1_mode;
  wire           tx2_rst_loc;
  wire           tx2_single_lane_loc;
  wire           tx2_sdr_ddr_n_loc;
  wire           tx2_symb_op_loc;
  wire           tx2_symb_8_16b_loc;
  wire           adc_sync_cd_1;
  wire           adc_sync_cd_2;
  wire           dac_sync_cd_1;
  wire           dac_sync_cd_2;
  wire           dac_sync_out_1;
  wire           dac_sync_out_2;
  wire           adc_1_ext_sync_arm;
  wire           adc_1_ext_sync_disarm;
  wire           adc_1_ext_sync_arm_cdc_s;
  wire           adc_1_ext_sync_disarm_cdc_s;
  wire           adc_2_ext_sync_arm;
  wire           adc_2_ext_sync_disarm;
  wire           dac_sync_armed_cd_1_s;
  wire           dac_sync_armed_cd_2_s;
  wire           dac_2_ext_sync_arm;
  wire           dac_2_ext_sync_disarm;
  wire           rx1_rst_s;
  wire           rx1_rst_cdc_s;
  wire           tx1_rst_s;
  wire           tx1_rst_cdc_s;

  wire           adc_sync_1;
  wire           adc_sync_2;
  wire           adc_1_armed_s;
  wire           adc_2_armed_s;

  reg            tx1_data_valid_A_d;
  reg    [15:0]  tx1_data_i_A_d;
  reg    [15:0]  tx1_data_q_A_d;
  reg            tx1_data_valid_B_d;
  reg    [15:0]  tx1_data_i_B_d;
  reg    [15:0]  tx1_data_q_B_d;
  reg            tx2_data_valid_A_d;
  reg    [15:0]  tx2_data_i_A_d;
  reg    [15:0]  tx2_data_q_A_d;

  reg            adc_1_transfer_sync_d1 = 1'b0;
  reg            adc_1_transfer_sync_d2 = 1'b0;
  reg            adc_2_transfer_sync_d1 = 1'b0;
  reg            adc_2_transfer_sync_d2 = 1'b0;
  reg            dac_1_transfer_sync_d1 = 1'b0;
  reg            dac_1_transfer_sync_d2 = 1'b0;
  reg            dac_2_transfer_sync_d1 = 1'b0;
  reg            dac_2_transfer_sync_d2 = 1'b0;

  // workaround registers
  reg rx1_r1_mode_d;
  reg rx1_symb_op_d;
  reg rx1_symb_8_16b_d;
  reg rx1_sdr_ddr_n_d;
  reg rx1_single_lane_d;
  reg rx1_rst_d;
  reg adc_sync_2_d;
  reg adc_1_ext_sync_disarm_cdc_d;
  reg adc_1_ext_sync_arm_cdc_d;

  reg tx1_r1_mode_d;
  reg tx1_symb_op_d;
  reg tx1_symb_8_16b_d;
  reg tx1_sdr_ddr_n_d;
  reg tx1_single_lane_d;
  reg tx1_rst_cdc_s_d;
  // end of workaround registers

  // rx1_r1_mode and tx1_r1_mode considered static during operation
  // rx1_r1_mode should be 0 only when rx1_clk and rx2_clk have the same frequency
  // tx1_r1_mode should be 0 only when tx1_clk and tx2_clk have the same frequency

  always @(posedge rx2_clk) begin
    rx1_r1_mode_d <= up_rx1_r1_mode;
    rx1_symb_op_d <= rx1_symb_op;
    rx1_symb_8_16b_d <= rx1_symb_8_16b;
    rx1_sdr_ddr_n_d <= rx1_sdr_ddr_n;
    rx1_single_lane_d <= rx1_single_lane;
    rx1_rst_d <= rx1_rst;
    adc_sync_2_d <= adc_sync_1;
    adc_1_ext_sync_disarm_cdc_d <= adc_1_ext_sync_disarm;
    adc_1_ext_sync_arm_cdc_d <= adc_1_ext_sync_arm;
  end

  assign rx1_r1_mode = rx1_r1_mode_d;
  assign rx1_symb_op_s = rx1_symb_op_d;
  assign rx1_symb_8_16b_s = rx1_symb_8_16b_d;
  assign rx1_sdr_ddr_n_s = rx1_sdr_ddr_n_d;
  assign rx1_single_lane_s = rx1_single_lane_d;
  assign rx1_rst_s = rx1_rst_d;
  assign adc_sync_2 = adc_sync_2_d;
  assign adc_1_ext_sync_disarm_cdc_s = adc_1_ext_sync_disarm_cdc_d;
  assign adc_1_ext_sync_arm_cdc_s = adc_1_ext_sync_arm_cdc_d;

  always @(posedge rx2_clk) begin
    tx1_r1_mode_d <= up_tx1_r1_mode;
    tx1_symb_op_d <= tx1_symb_op;
    tx1_symb_8_16b_d <= tx1_symb_8_16b;
    tx1_sdr_ddr_n_d <= tx1_sdr_ddr_n;
    tx1_single_lane_d <= tx1_single_lane;
    tx1_rst_cdc_s_d <= tx1_rst_s;
    adc_sync_2_d <= adc_sync_1;
    adc_1_ext_sync_disarm_cdc_d <= adc_1_ext_sync_disarm;
    adc_1_ext_sync_arm_cdc_d <= adc_1_ext_sync_arm;
  end

  assign tx1_r1_mode = tx1_r1_mode_d;
  assign tx1_symb_op_s = tx1_symb_op_d;
  assign tx1_symb_8_16b_s = tx1_symb_8_16b_d;
  assign tx1_sdr_ddr_n_s = tx1_sdr_ddr_n_d;
  assign tx1_single_lane_s = tx1_single_lane_d;
  assign tx1_rst_cdc_s = tx1_rst_cdc_s_d;

  assign rx2_rst = rx1_r1_mode ? rx2_rst_loc : rx1_rst_s;
  assign rx2_single_lane = rx1_r1_mode ? rx2_single_lane_loc : rx1_single_lane_s;
  assign rx2_sdr_ddr_n = rx1_r1_mode ? rx2_sdr_ddr_n_loc : rx1_sdr_ddr_n_s;
  assign rx2_symb_op = rx1_r1_mode ? rx2_symb_op_loc : rx1_symb_op_s;
  assign rx2_symb_8_16b = rx1_r1_mode ? rx2_symb_8_16b_loc : rx1_symb_8_16b_s;

  assign tx2_single_lane = tx1_r1_mode ? tx2_single_lane_loc : tx1_single_lane_s;
  assign tx2_sdr_ddr_n = tx1_r1_mode ? tx2_sdr_ddr_n_loc : tx1_sdr_ddr_n_s;
  assign tx2_symb_op = tx1_r1_mode ? tx2_symb_op_loc : tx1_symb_op_s;
  assign tx2_symb_8_16b = tx1_r1_mode ? tx2_symb_8_16b_loc : tx1_symb_8_16b_s;
  assign tx1_data_valid = tx1_data_valid_A_d;
  assign tx1_data_i = tx1_data_i_A_d;
  assign tx1_data_q = tx1_data_q_A_d;

  assign tx2_data_valid = tx1_r1_mode ? tx2_data_valid_A_d : tx1_data_valid_B_d;
  assign tx2_data_i = tx1_r1_mode ? tx2_data_i_A_d : tx1_data_i_B_d;
  assign tx2_data_q = tx1_r1_mode ? tx2_data_q_A_d : tx1_data_q_B_d;

  always @(posedge tx1_clk) begin
    tx1_data_valid_A_d <= tx1_data_valid_A;
    tx1_data_i_A_d <= tx1_data_i_A;
    tx1_data_q_A_d <= tx1_data_q_A;
  end

  always @(posedge tx2_clk) begin
    tx2_data_valid_A_d <= tx2_data_valid_A;
    tx2_data_i_A_d <= tx2_data_i_A;
    tx2_data_q_A_d <= tx2_data_q_A;
  end

  // Use tx1_r1_mode as clock enable when the two clocks have different frequency
  always @(posedge tx2_clk) begin
    if (tx1_r1_mode==0) begin
      tx1_data_valid_B_d <= tx1_data_valid_B;
      tx1_data_i_B_d <= tx1_data_i_B;
      tx1_data_q_B_d <= tx1_data_q_B;
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_rdata <= up_rdata_s[0] |
                  up_rdata_s[1] |
                  up_rdata_s[2] |
                  up_rdata_s[3] |
                  up_rdata_s[4] |
                  up_rdata_s[5] |
                  up_rdata_s[6] |
                  up_rdata_s[7] |
                  up_rdata_s[8];
      up_rack  <= |up_rack_s;
      up_wack  <= |up_wack_s;
    end
  end

  // rx1 transfer sync

  always @(posedge rx1_clk) begin
    adc_1_transfer_sync_d1 <= transfer_sync_in;
    adc_1_transfer_sync_d2 <= adc_1_transfer_sync_d1;
  end

  util_ext_sync #(
    .ENABLED (EXT_SYNC)
  ) i_util_rx1_ext_sync (
    .clk (rx1_clk),
    .ext_sync_arm (adc_1_ext_sync_arm),
    .ext_sync_disarm (adc_1_ext_sync_disarm),
    .sync_in (adc_1_transfer_sync_d2 | adc_sync_1),
    .sync_armed (adc_1_armed_s)
  );

  // rx2 transfer sync

  always @(posedge rx2_clk) begin
    adc_2_transfer_sync_d1 <= transfer_sync_in;
    adc_2_transfer_sync_d2 <= adc_2_transfer_sync_d1;
  end

  util_ext_sync #(
    .ENABLED (EXT_SYNC)
  ) i_util_rx2_ext_sync (
    .clk (rx2_clk),
    .ext_sync_arm (adc_2_ext_sync_arm | adc_1_ext_sync_arm_cdc_s),
    .ext_sync_disarm (adc_2_ext_sync_disarm | adc_1_ext_sync_disarm_cdc_s),
    .sync_in (adc_2_transfer_sync_d2 | adc_sync_2),
    .sync_armed (adc_2_armed_s)
  );

  // adc DMA sync start
  assign adc_1_start_sync = ~adc_1_armed_s;
  assign adc_2_start_sync = ~adc_2_armed_s;

  // tx1 transfer sync

  always @(posedge tx1_clk) begin
    dac_1_transfer_sync_d1 <= transfer_sync_in;
    dac_1_transfer_sync_d2 <= dac_1_transfer_sync_d1;
  end

  util_ext_sync #(
    .ENABLED (EXT_SYNC)
  ) i_util_tx_1_ext_sync (
    .clk (tx1_clk),
    .ext_sync_arm (dac_1_ext_sync_arm),
    .ext_sync_disarm (dac_1_ext_sync_disarm),
    .sync_in (dac_1_transfer_sync_d2),
    .sync_armed (dac_sync_armed_cd_1_s)
  );

  // tx2 transfer sync

  always @(posedge tx2_clk) begin
    dac_2_transfer_sync_d1 <= transfer_sync_in;
    dac_2_transfer_sync_d2 <= dac_2_transfer_sync_d1;
  end

  util_ext_sync #(
    .ENABLED (EXT_SYNC)
  ) i_util_tx_2_ext_sync (
    .clk (tx2_clk),
    .ext_sync_arm (dac_2_ext_sync_arm),
    .ext_sync_disarm (dac_2_ext_sync_disarm),
    .sync_in (dac_2_transfer_sync_d2),
    .sync_armed (dac_sync_armed_cd_2_s)
  );

  assign tx1_rst = tx1_rst_s;
  assign tx2_rst = tx1_r1_mode ? tx2_rst_loc : tx1_rst_cdc_s;

  axi_adrv9001_rx #(
    .ID (ID),
    .ENABLED (1),
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .USE_RX_CLK_FOR_TX (USE_RX1_CLK_FOR_TX),
    .COMMON_BASE_ADDR(6'h00),
    .CHANNEL_BASE_ADDR(6'h01),
    .MODE_R1 (COMMON_2R2T_SUPPORT == 0 || DISABLE_RX2_SSI == 1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DATAFORMAT_DISABLE (0),
    .DCFILTER_DISABLE (1),
    .IQCORRECTION_DISABLE (1)
  ) i_rx1 (
    .adc_rst (rx1_rst),
    .adc_clk (rx1_clk),
    .adc_valid_A (rx1_data_valid & tdd_rx1_valid),
    .adc_data_i_A (rx1_data_i),
    .adc_data_q_A (rx1_data_q),

    .adc_valid_B (rx2_data_valid & tdd_rx1_valid),
    .adc_data_i_B (rx2_data_i),
    .adc_data_q_B (rx2_data_q),

    .adc_single_lane (rx1_single_lane),
    .adc_sdr_ddr_n (rx1_sdr_ddr_n),
    .adc_symb_op (rx1_symb_op),
    .adc_symb_8_16b (rx1_symb_8_16b),
    .up_adc_r1_mode (up_rx1_r1_mode),

    .adc_clk_ratio (adc_clk_ratio),

    .dac_data_valid_A (tx1_data_valid_A),
    .dac_data_i_A (tx1_data_i_A),
    .dac_data_q_A (tx1_data_q_A),
    .dac_data_valid_B (tx1_data_valid_B),
    .dac_data_i_B (tx1_data_i_B),
    .dac_data_q_B (tx1_data_q_B),

    .adc_valid (adc_1_valid),

    .adc_enable_i0 (adc_1_enable_i0),
    .adc_data_i0 (adc_1_data_i0[15:0]),
    .adc_enable_q0 (adc_1_enable_q0),
    .adc_data_q0 (adc_1_data_q0[15:0]),

    .adc_enable_i1 (adc_1_enable_i1),
    .adc_data_i1 (adc_1_data_i1[15:0]),
    .adc_enable_q1 (adc_1_enable_q1),
    .adc_data_q1 (adc_1_data_q1[15:0]),

    .adc_dovf (adc_1_dovf),
    .adc_sync (adc_sync_1),
    .adc_sync_status (adc_1_start_sync),
    .adc_ext_sync_arm (adc_1_ext_sync_arm),
    .adc_ext_sync_disarm (adc_1_ext_sync_disarm),
    .adc_ext_sync_manual_req (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  axi_adrv9001_rx #(
    .ID (ID),
    .ENABLED (INDEPENDENT_1R1T_SUPPORT == 1 && DISABLE_RX2_SSI != 1),
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .USE_RX_CLK_FOR_TX (USE_RX2_CLK_FOR_TX),
    .COMMON_BASE_ADDR(6'h04),
    .CHANNEL_BASE_ADDR(6'h05),
    .MODE_R1 (1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DATAFORMAT_DISABLE (0),
    .DCFILTER_DISABLE (1),
    .IQCORRECTION_DISABLE (1)
  ) i_rx2 (
    .adc_rst (rx2_rst_loc),
    .adc_clk (rx2_clk),
    .adc_valid_A (rx2_data_valid & tdd_rx2_valid),
    .adc_data_i_A (rx2_data_i),
    .adc_data_q_A (rx2_data_q),

    .adc_valid_B (1'b0),
    .adc_data_i_B (16'b0),
    .adc_data_q_B (16'b0),

    .adc_single_lane (rx2_single_lane_loc),
    .adc_sdr_ddr_n (rx2_sdr_ddr_n_loc),
    .adc_symb_op (rx2_symb_op_loc),
    .adc_symb_8_16b (rx2_symb_8_16b_loc),

    .adc_clk_ratio (adc_clk_ratio),

    .dac_data_valid_A (tx2_data_valid_A),
    .dac_data_i_A (tx2_data_i_A),
    .dac_data_q_A (tx2_data_q_A),
    .dac_data_valid_B (1'b0),
    .dac_data_i_B (16'b0),
    .dac_data_q_B (16'b0),

    .adc_valid (adc_2_valid),

    .adc_enable_i0 (adc_2_enable_i),
    .adc_data_i0 (adc_2_data_i[15:0]),
    .adc_enable_q0 (adc_2_enable_q),
    .adc_data_q0 (adc_2_data_q[15:0]),

    .adc_dovf (adc_2_dovf),
    .adc_sync (),
    .adc_sync_status (adc_2_start_sync),
    .adc_ext_sync_arm (adc_2_ext_sync_arm),
    .adc_ext_sync_disarm (adc_2_ext_sync_disarm),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  axi_adrv9001_tx #(
    .ID (ID),
    .ENABLED (1),
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .USE_RX_CLK_FOR_TX (USE_RX_CLK_FOR_TX1),
    .COMMON_BASE_ADDR ('h08),
    .CHANNEL_BASE_ADDR ('h09),
    .MODE_R1 (COMMON_2R2T_SUPPORT == 0 || DISABLE_RX2_SSI == 1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .EXT_SYNC (EXT_SYNC),
    .DDS_DISABLE (DDS_DISABLE),
    .IQCORRECTION_DISABLE (1),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW)
  ) i_tx1 (
    .dac_rst (tx1_rst_s),
    .tx_if_rst (tx1_if_rst),
    .dac_clk (tx1_clk),
    .dac_data_valid_A (tx1_data_valid_A),
    .dac_data_i_A (tx1_data_i_A),
    .dac_data_q_A (tx1_data_q_A),
    .dac_data_valid_B (tx1_data_valid_B),
    .dac_data_i_B (tx1_data_i_B),
    .dac_data_q_B (tx1_data_q_B),
    .dac_single_lane (tx1_single_lane),
    .dac_sdr_ddr_n (tx1_sdr_ddr_n),
    .dac_symb_op (tx1_symb_op),
    .dac_symb_8_16b (tx1_symb_8_16b),
    .up_dac_r1_mode (up_tx1_r1_mode),
    .tdd_tx_valid (tdd_tx1_valid),
    .dac_clk_ratio (dac_clk_ratio),
    .dac_transfer_sync_in (dac_sync_armed_cd_1_s | dac_sync_out_1 | dac_sync_out_2),
    .dac_rate_sync_in (rate_sync),
    .dac_sync_out (dac_sync_out_1),
    .dac_ext_sync_arm (dac_1_ext_sync_arm),
    .dac_ext_sync_disarm (dac_1_ext_sync_disarm),
    .dac_sync_in_status (dac_sync_armed_cd_1_s),
    .dac_enable_i0 (dac_1_enable_i0),
    .dac_valid (dac_1_valid),
    .dac_data_i0 (dac_1_data_i0[15:0]),
    .dac_enable_q0 (dac_1_enable_q0),
    .dac_data_q0 (dac_1_data_q0[15:0]),
    .dac_enable_i1 (dac_1_enable_i1),
    .dac_data_i1 (dac_1_data_i1[15:0]),
    .dac_enable_q1 (dac_1_enable_q1),
    .dac_data_q1 (dac_1_data_q1[15:0]),
    .dac_dunf (dac_1_dunf),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

  axi_adrv9001_tx #(
    .ID (ID),
    .ENABLED (INDEPENDENT_1R1T_SUPPORT == 1 && DISABLE_TX2_SSI != 1),
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .USE_RX_CLK_FOR_TX (USE_RX_CLK_FOR_TX2),
    .COMMON_BASE_ADDR ('h10),
    .CHANNEL_BASE_ADDR ('h11),
    .MODE_R1 (1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .EXT_SYNC (EXT_SYNC),
    .DDS_DISABLE (DDS_DISABLE),
    .IQCORRECTION_DISABLE (1),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW)
  ) i_tx2 (
    .dac_rst (tx2_rst_loc),
    .tx_if_rst (tx2_if_rst),
    .dac_clk (tx2_clk),
    .dac_data_valid_A (tx2_data_valid_A),
    .dac_data_i_A (tx2_data_i_A),
    .dac_data_q_A (tx2_data_q_A),
    .dac_data_valid_B (),
    .dac_data_i_B (),
    .dac_data_q_B (),
    .dac_single_lane (tx2_single_lane_loc),
    .dac_sdr_ddr_n (tx2_sdr_ddr_n_loc),
    .dac_symb_op (tx2_symb_op_loc),
    .dac_symb_8_16b (tx2_symb_8_16b_loc),
    .dac_rate_sync_in (rate_sync),
    .dac_transfer_sync_in (dac_sync_armed_cd_2_s | dac_sync_out_1 | dac_sync_out_2),
    .dac_sync_out (dac_sync_out_2),
    .dac_ext_sync_arm (dac_2_ext_sync_arm),
    .dac_ext_sync_disarm (dac_2_ext_sync_disarm),
    .dac_sync_in_status (dac_sync_armed_cd_2_s),
    .dac_valid (dac_2_valid),
    .dac_enable_i0 (dac_2_enable_i0),
    .dac_data_i0 (dac_2_data_i0[15:0]),
    .dac_enable_q0 (dac_2_enable_q0),
    .dac_data_q0 (dac_2_data_q0[15:0]),
    .dac_enable_i1 (),
    .dac_data_i1 (16'b0),
    .dac_enable_q1 (),
    .dac_data_q1 (16'b0),
    .dac_dunf (dac_2_dunf),
    .tdd_tx_valid (tdd_tx2_valid),
    .dac_clk_ratio (dac_clk_ratio),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[3]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[3]),
    .up_rack (up_rack_s[3]));

  // adc delay control
  up_delay_cntrl #(
    .DATA_WIDTH(NUM_LANES),
    .DRP_WIDTH(DRP_WIDTH),
    .DISABLE(DISABLE_RX1_SSI),
    .BASE_ADDRESS(6'h02)
  ) i_delay_cntrl_rx1 (
    .core_rst (1'b0),
    .delay_clk (delay_clk),
    .delay_rst (delay_rx1_rst),
    .delay_locked (delay_rx1_locked),
    .up_dld (up_rx1_dld),
    .up_dwdata (up_rx1_dwdata),
    .up_drdata (up_rx1_drdata),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[4]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[4]),
    .up_rack (up_rack_s[4]));

  up_delay_cntrl #(
    .DATA_WIDTH(NUM_LANES),
    .DRP_WIDTH(DRP_WIDTH),
    .DISABLE(DISABLE_RX2_SSI),
    .BASE_ADDRESS(6'h06)
  ) i_delay_cntrl_rx2 (
    .core_rst (1'b0),
    .delay_clk (delay_clk),
    .delay_rst (delay_rx2_rst),
    .delay_locked (delay_rx2_locked),
    .up_dld (up_rx2_dld),
    .up_dwdata (up_rx2_dwdata),
    .up_drdata (up_rx2_drdata),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[5]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[5]),
    .up_rack (up_rack_s[5]));

  wire tdd_rx2_rf_en_loc;
  wire tdd_tx2_rf_en_loc;
  wire tdd_if2_mode_loc;

  axi_adrv9001_tdd #(
    .BASE_ADDRESS (6'h12),
    .ENABLED (TDD_DISABLE==0)
  ) i_tdd_1 (
    .clk (rx1_clk),
    .rst (rx1_rst),
    .tdd_rx_vco_en (),
    .tdd_tx_vco_en (),
    .tdd_rx_rf_en (tdd_rx1_rf_en),
    .tdd_tx_rf_en (tdd_tx1_rf_en),
    .tdd_enabled (tdd_if1_mode),
    .tdd_status (8'h0),
    .tdd_sync (tdd_sync),
    .tdd_sync_cntr (tdd_sync_cntr1),
    .tdd_tx_valid (tdd_tx1_valid),
    .tdd_rx_valid (tdd_rx1_valid),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[6]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[6]),
    .up_rack (up_rack_s[6]));

  axi_adrv9001_tdd #(
    .BASE_ADDRESS (6'h13),
    .ENABLED(TDD_DISABLE == 0 && (DISABLE_RX2_SSI == 0 || DISABLE_TX2_SSI == 0))
  ) i_tdd_2 (
    .clk (rx2_clk),
    .rst (rx2_rst_loc),
    .tdd_rx_vco_en (),
    .tdd_tx_vco_en (),
    .tdd_rx_rf_en (tdd_rx2_rf_en_loc),
    .tdd_tx_rf_en (tdd_tx2_rf_en_loc),
    .tdd_enabled (tdd_if2_mode_loc),
    .tdd_status (8'h0),
    .tdd_sync (tdd_sync),
    .tdd_sync_cntr (tdd_sync_cntr2),
    .tdd_tx_valid (tdd_tx2_valid),
    .tdd_rx_valid (tdd_rx2_valid),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[7]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[7]),
    .up_rack (up_rack_s[7]));

  assign tdd_rx2_rf_en = rx1_r1_mode ? tdd_rx2_rf_en_loc : tdd_rx1_rf_en;
  assign tdd_tx2_rf_en = tx1_r1_mode ? tdd_tx2_rf_en_loc : tdd_tx1_rf_en;
  assign tdd_if2_mode = tx1_r1_mode||rx1_r1_mode ? tdd_if2_mode_loc : tdd_if1_mode;

  assign tdd_sync_cntr = tdd_sync_cntr1 | tdd_sync_cntr2;

  axi_adrv9001_sync_ctrl #(
    .BASE_ADDRESS (6'h14),
    .ENABLE_REF_CLK_MON (ENABLE_REF_CLK_MON)
  ) i_sync_ctrl (
    .ref_clk (ref_clk),
    .rx1_clk (rx1_clk),
    .rx1_rst (rx1_rst),
    .rx2_clk (rx2_clk),
    .rx2_rst (rx2_rst),
    .sync_config (sync_config),
    .rx1_mcs_to_strobe_delay (rx1_mcs_to_strobe_delay),
    .rx2_mcs_to_strobe_delay (rx2_mcs_to_strobe_delay),
    .mcs_sync_pulse_width (mcs_sync_pulse_width),
    .mcs_sync_pulse_1_delay (mcs_sync_pulse_1_delay),
    .mcs_sync_pulse_2_delay (mcs_sync_pulse_2_delay),
    .mcs_sync_pulse_3_delay (mcs_sync_pulse_3_delay),
    .mcs_sync_pulse_4_delay (mcs_sync_pulse_4_delay),
    .mcs_sync_pulse_5_delay (mcs_sync_pulse_5_delay),
    .mcs_sync_pulse_6_delay (mcs_sync_pulse_6_delay),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[8]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[8]),
    .up_rack (up_rack_s[8]));

endmodule
