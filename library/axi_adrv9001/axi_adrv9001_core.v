// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2020 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9001_core #(
  parameter ID = 0,
  parameter CMOS_LVDS_N = 0,
  parameter NUM_LANES = 3,
  parameter DRP_WIDTH = 5,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,

  parameter DAC_DDS_TYPE = 1,
  parameter DAC_DDS_CORDIC_DW = 20,
  parameter DAC_DDS_CORDIC_PHASE_DW = 18
) (
  // ADC interface
  input                   rx1_clk,
  output                  rx1_rst,
  input                   rx1_data_valid,
  input       [15:0]      rx1_data_i,
  input       [15:0]      rx1_data_q,

  output                  rx1_single_lane,
  output                  rx1_sdr_ddr_n,

  input                   rx2_clk,
  output                  rx2_rst,
  input                   rx2_data_valid,
  input       [15:0]      rx2_data_i,
  input       [15:0]      rx2_data_q,

  output                  rx2_single_lane,
  output                  rx2_sdr_ddr_n,

  // DAC interface
  input                   tx1_clk,
  output                  tx1_rst,
  output                  tx1_data_valid,
  output      [15:0]      tx1_data_i,
  output      [15:0]      tx1_data_q,

  output                  tx1_single_lane,
  output                  tx1_sdr_ddr_n,

  input                   tx2_clk,
  output                  tx2_rst,
  output                  tx2_data_valid,
  output      [15:0]      tx2_data_i,
  output      [15:0]      tx2_data_q,

  output                  tx2_single_lane,
  output                  tx2_sdr_ddr_n,

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

  output                  adc_2_valid,
  output                  adc_2_enable_i,
  output      [15:0]      adc_2_data_i,
  output                  adc_2_enable_q,
  output      [15:0]      adc_2_data_q,
  input                   adc_2_dovf,

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

  wire           up_wack_s[0:5];
  wire   [31:0]  up_rdata_s[0:5];
  wire           up_rack_s[0:5];

  wire           tx1_data_valid_A;
  wire   [15:0]  tx1_data_i_A;
  wire   [15:0]  tx1_data_q_A;
  wire           tx1_data_valid_B;
  wire   [15:0]  tx1_data_i_B;
  wire   [15:0]  tx1_data_q_B;
  wire           tx2_data_valid_A;
  wire   [15:0]  tx2_data_i_A;
  wire   [15:0]  tx2_data_q_A;
  wire           rx1_r1_mode;
  wire           rx2_rst_loc;
  wire           rx2_single_lane_loc;
  wire           rx2_sdr_ddr_n_loc;
  wire           tx1_r1_mode;
  wire           tx2_rst_loc;
  wire           tx2_single_lane_loc;
  wire           tx2_sdr_ddr_n_loc;

  reg            tx1_data_valid_A_d;
  reg    [15:0]  tx1_data_i_A_d;
  reg    [15:0]  tx1_data_q_A_d;
  reg            tx1_data_valid_B_d;
  reg    [15:0]  tx1_data_i_B_d;
  reg    [15:0]  tx1_data_q_B_d;
  reg            tx2_data_valid_A_d;
  reg    [15:0]  tx2_data_i_A_d;
  reg    [15:0]  tx2_data_q_A_d;

  // rx1_r1_mode and tx1_r1_mode considered static during operation
  // rx1_r1_mode should be 0 only when rx1_clk and rx2_clk have the same frequency
  // tx1_r1_mode should be 0 only when tx1_clk and tx2_clk have the same frequency

  assign rx2_rst = rx1_r1_mode ? rx2_rst_loc : rx1_rst;
  assign rx2_single_lane = rx1_r1_mode ? rx2_single_lane_loc : rx1_single_lane;
  assign rx2_sdr_ddr_n = rx1_r1_mode ? rx2_sdr_ddr_n_loc : rx1_sdr_ddr_n;

  assign tx2_rst = tx1_r1_mode ? tx2_rst_loc : tx1_rst;
  assign tx2_single_lane = tx1_r1_mode ? tx2_single_lane_loc : tx1_single_lane;
  assign tx2_sdr_ddr_n = tx1_r1_mode ? tx2_sdr_ddr_n_loc : tx1_sdr_ddr_n;

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
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] | up_rdata_s[3] | up_rdata_s[4] | up_rdata_s[5];
      up_rack  <= up_rack_s[0]  | up_rack_s[1]  | up_rack_s[2]  | up_rack_s[3]  | up_rack_s[4]  | up_rack_s[5];
      up_wack  <= up_wack_s[0]  | up_wack_s[1]  | up_wack_s[2]  | up_wack_s[3]  | up_wack_s[4]  | up_wack_s[5];
    end
  end

  axi_adrv9001_rx #(
    .ID (ID),
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .COMMON_BASE_ADDR(6'h00),
    .CHANNEL_BASE_ADDR(6'h01),
    .MODE_R1 (0),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DATAFORMAT_DISABLE (0),
    .DCFILTER_DISABLE (1),
    .IQCORRECTION_DISABLE (1))
  i_rx1 (
    .adc_rst (rx1_rst),
    .adc_clk (rx1_clk),
    .adc_valid_A (rx1_data_valid),
    .adc_data_i_A (rx1_data_i),
    .adc_data_q_A (rx1_data_q),

    .adc_valid_B (rx2_data_valid),
    .adc_data_i_B (rx2_data_i),
    .adc_data_q_B (rx2_data_q),

    .adc_single_lane (rx1_single_lane),
    .adc_sdr_ddr_n (rx1_sdr_ddr_n),
    .adc_r1_mode (rx1_r1_mode),

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
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .COMMON_BASE_ADDR(6'h04),
    .CHANNEL_BASE_ADDR(6'h05),
    .MODE_R1 (1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DATAFORMAT_DISABLE (0),
    .DCFILTER_DISABLE (1),
    .IQCORRECTION_DISABLE (1))
  i_rx2 (
    .adc_rst (rx2_rst_loc),
    .adc_clk (rx2_clk),
    .adc_valid_A (rx2_data_valid),
    .adc_data_i_A (rx2_data_i),
    .adc_data_q_A (rx2_data_q),

    .adc_valid_B (1'b0),
    .adc_data_i_B (16'b0),
    .adc_data_q_B (16'b0),

    .adc_single_lane (rx2_single_lane_loc),
    .adc_sdr_ddr_n (rx2_sdr_ddr_n_loc),

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
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .COMMON_BASE_ADDR ('h08),
    .CHANNEL_BASE_ADDR ('h09),
    .MODE_R1 (0),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DDS_DISABLE (0),
    .IQCORRECTION_DISABLE (1),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_tx1 (
    .dac_rst (tx1_rst),
    .dac_clk (tx1_clk),
    .dac_data_valid_A (tx1_data_valid_A),
    .dac_data_i_A (tx1_data_i_A),
    .dac_data_q_A (tx1_data_q_A),
    .dac_data_valid_B (tx1_data_valid_B),
    .dac_data_i_B (tx1_data_i_B),
    .dac_data_q_B (tx1_data_q_B),
    .dac_single_lane (tx1_single_lane),
    .dac_sdr_ddr_n (tx1_sdr_ddr_n),
    .dac_r1_mode (tx1_r1_mode),
    .dac_sync_in (1'b0),
    .dac_sync_out (),
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
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .COMMON_BASE_ADDR ('h10),
    .CHANNEL_BASE_ADDR ('h11),
    .MODE_R1 (1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DDS_DISABLE (0),
    .IQCORRECTION_DISABLE (1),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_tx2 (
    .dac_rst (tx2_rst_loc),
    .dac_clk (tx2_clk),
    .dac_data_valid_A (tx2_data_valid_A),
    .dac_data_i_A (tx2_data_i_A),
    .dac_data_q_A (tx2_data_q_A),
    .dac_data_valid_B (),
    .dac_data_i_B (),
    .dac_data_q_B (),
    .dac_single_lane (tx2_single_lane_loc),
    .dac_sdr_ddr_n (tx2_sdr_ddr_n_loc),
    .dac_sync_in (1'b0),
    .dac_sync_out (),
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
    .BASE_ADDRESS(6'h02))
  i_delay_cntrl_rx1 (
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
    .BASE_ADDRESS(6'h06))
  i_delay_cntrl_rx2 (
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

endmodule

