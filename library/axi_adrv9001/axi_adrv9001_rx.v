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

module axi_adrv9001_rx #(
  parameter   ID = 0,
  parameter   ENABLED = 1,
  parameter   CMOS_LVDS_N = 0,
  parameter   USE_RX_CLK_FOR_TX = 0,
  parameter   COMMON_BASE_ADDR = 'h00,
  parameter   CHANNEL_BASE_ADDR = 'h01,
  parameter   MODE_R1 = 1,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DATAFORMAT_DISABLE = 0,
  parameter   DCFILTER_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 1
) (

  // adc interface
  output                  adc_rst,
  input                   adc_clk,
  input                   adc_valid_A,
  input       [ 15:0]     adc_data_i_A,
  input       [ 15:0]     adc_data_q_A,

  input                   adc_valid_B,
  input       [ 15:0]     adc_data_i_B,
  input       [ 15:0]     adc_data_q_B,

  output                  adc_single_lane,
  output                  adc_sdr_ddr_n,
  output                  adc_symb_op,
  output                  adc_symb_8_16b,
  output                  up_adc_r1_mode,

  input       [ 31:0]     adc_clk_ratio,

  // dac loopback interface
  input                   dac_data_valid_A,
  input       [ 15:0]     dac_data_i_A,
  input       [ 15:0]     dac_data_q_A,

  input                   dac_data_valid_B,
  input       [ 15:0]     dac_data_i_B,
  input       [ 15:0]     dac_data_q_B,

  // dma interface
  output                  adc_valid,

  output                  adc_enable_i0,
  output      [ 15:0]     adc_data_i0,
  output                  adc_enable_q0,
  output      [ 15:0]     adc_data_q0,

  output                  adc_enable_i1,
  output      [ 15:0]     adc_data_i1,
  output                  adc_enable_q1,
  output      [ 15:0]     adc_data_q1,

  input                   adc_dovf,

  output                  adc_sync,
  input                   adc_sync_status,
  output                  adc_ext_sync_arm,
  output                  adc_ext_sync_disarm,
  output                  adc_ext_sync_manual_req,

  // processor interface
  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [ 13:0]     up_waddr,
  input       [ 31:0]     up_wdata,
  output  reg             up_wack,
  input                   up_rreq,
  input       [ 13:0]     up_raddr,
  output  reg [ 31:0]     up_rdata,
  output  reg             up_rack
);

  generate
  if (ENABLED == 0) begin : core_disabled

    assign adc_rst = 1'b0;
    assign adc_single_lane = 1'b0;
    assign adc_sdr_ddr_n = 1'b0;
    assign adc_symb_op = 1'b0;
    assign adc_symb_8_16b = 1'b0;
    assign up_adc_r1_mode = 1'b0;
    assign adc_valid = 1'b0;
    assign adc_enable_i0 = 1'b0;
    assign adc_data_i0 = 16'b0;
    assign adc_enable_q0 = 1'b0;
    assign adc_data_q0 = 16'b0;
    assign adc_enable_i1 = 1'b0;
    assign adc_data_i1 = 16'b0;
    assign adc_enable_q1 = 1'b0;
    assign adc_data_q1 = 16'b0;

    always @(*) begin
      up_wack = 1'b0;
      up_rdata = 32'b0;
      up_rack = 1'b0;
    end

  end else begin : core_enabled

    // This bit lets the sw know that this feature is available
    localparam  SELECTABLE_CLK = 1;

    // configuration settings

    localparam  CONFIG =  (SELECTABLE_CLK * 16384) +
                          (USE_RX_CLK_FOR_TX[0] * 1024) +
                          (CMOS_LVDS_N * 128) +
                          (MODE_R1 * 16) +
                          (DATAFORMAT_DISABLE * 4) +
                          (DCFILTER_DISABLE * 2) +
                          (IQCORRECTION_DISABLE * 1);

    // internal registers

    reg               up_status_pn_err = 'd0;
    reg               up_status_pn_oos = 'd0;
    reg               up_status_or = 'd0;

    // internal signals

    wire    [ 15:0]   adc_data_iq_i0_s;
    wire    [ 15:0]   adc_data_iq_q0_s;
    wire    [ 15:0]   adc_data_iq_i1_s;
    wire    [ 15:0]   adc_data_iq_q1_s;
    wire    [  4:0]   adc_num_lanes;
    wire    [  3:0]   up_adc_pn_err_s;
    wire    [  3:0]   up_adc_pn_oos_s;
    wire    [  3:0]   up_adc_or_s;
    wire    [  4:0]   up_wack_s;
    wire    [  4:0]   up_rack_s;
    wire    [ 31:0]   up_rdata_s[0:4];
    wire              adc_valid_out_i0;
    wire              adc_valid_out_i1;

    // processor read interface

    always @(negedge up_rstn or posedge up_clk) begin
      if (up_rstn == 0) begin
        up_status_pn_err <= 'd0;
        up_status_pn_oos <= 'd0;
        up_status_or <= 'd0;
        up_wack <= 'd0;
        up_rack <= 'd0;
        up_rdata <= 'd0;
      end else begin
        up_status_pn_err <= up_adc_r1_mode ? | up_adc_pn_err_s[1:0] : | up_adc_pn_err_s[3:0];
        up_status_pn_oos <= up_adc_r1_mode ? | up_adc_pn_oos_s[1:0] : | up_adc_pn_oos_s[3:0];
        up_status_or <= | up_adc_or_s;
        up_wack <= | up_wack_s;
        up_rack <= | up_rack_s;
        up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] |
                    up_rdata_s[3] | up_rdata_s[4];
      end
    end

    // channel width is 32 bits

    assign adc_valid = adc_enable_i0 ? adc_valid_out_i0 : adc_valid_out_i1;

    // channel 0 (i)

    axi_adrv9001_rx_channel #(
      .Q_OR_I_N (0),
      .COMMON_ID (CHANNEL_BASE_ADDR),
      .DISABLE (0),
      .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
      .DCFILTER_DISABLE (DCFILTER_DISABLE),
      .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
      .DATA_WIDTH (16)
    ) i_rx_channel_0 (
      .adc_clk (adc_clk),
      .adc_rst (adc_rst),
      .adc_valid_in (adc_valid_A),
      .adc_data_in (adc_data_i_A[15:0]),
      .adc_valid_out (adc_valid_out_i0),
      .adc_data_out (adc_data_i0),
      .adc_data_iq_in (adc_data_iq_q0_s),
      .adc_data_iq_out (adc_data_iq_i0_s),
      .adc_enable (adc_enable_i0),
      .dac_valid_in (dac_data_valid_A),
      .dac_data_in (dac_data_i_A),
      .up_adc_pn_err (up_adc_pn_err_s[0]),
      .up_adc_pn_oos (up_adc_pn_oos_s[0]),
      .up_adc_or (up_adc_or_s[0]),
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

    // channel 1 (q)

    axi_adrv9001_rx_channel #(
      .Q_OR_I_N (1),
      .COMMON_ID (CHANNEL_BASE_ADDR),
      .CHANNEL_ID (1),
      .DISABLE (0),
      .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
      .DCFILTER_DISABLE (DCFILTER_DISABLE),
      .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
      .DATA_WIDTH (16)
    ) i_rx_channel_1 (
      .adc_clk (adc_clk),
      .adc_rst (adc_rst),
      .adc_valid_in (adc_valid_A),
      .adc_data_in (adc_data_q_A[15:0]),
      .adc_valid_out (),
      .adc_data_out (adc_data_q0),
      .adc_data_iq_in (adc_data_iq_i0_s),
      .adc_data_iq_out (adc_data_iq_q0_s),
      .adc_enable (adc_enable_q0),
      .dac_valid_in (dac_data_valid_A),
      .dac_data_in (dac_data_q_A),
      .up_adc_pn_err (up_adc_pn_err_s[1]),
      .up_adc_pn_oos (up_adc_pn_oos_s[1]),
      .up_adc_or (up_adc_or_s[1]),
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

    // channel 2 (i)

    axi_adrv9001_rx_channel #(
      .Q_OR_I_N (0),
      .COMMON_ID (CHANNEL_BASE_ADDR),
      .CHANNEL_ID (2),
      .DISABLE (MODE_R1),
      .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
      .DCFILTER_DISABLE (DCFILTER_DISABLE),
      .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
      .DATA_WIDTH (16)
    ) i_rx_channel_2 (
      .adc_clk (adc_clk),
      .adc_rst (adc_rst),
      .adc_valid_in (adc_valid_B),
      .adc_data_in (adc_data_i_B[15:0]),
      .adc_valid_out (adc_valid_out_i1),
      .adc_data_out (adc_data_i1),
      .adc_data_iq_in (adc_data_iq_q1_s),
      .adc_data_iq_out (adc_data_iq_i1_s),
      .adc_enable (adc_enable_i1),
      .dac_valid_in (dac_data_valid_B),
      .dac_data_in (dac_data_i_B),
      .up_adc_pn_err (up_adc_pn_err_s[2]),
      .up_adc_pn_oos (up_adc_pn_oos_s[2]),
      .up_adc_or (up_adc_or_s[2]),
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

    // channel 3 (q)

    axi_adrv9001_rx_channel #(
      .Q_OR_I_N (1),
      .COMMON_ID (CHANNEL_BASE_ADDR),
      .CHANNEL_ID (3),
      .DISABLE (MODE_R1),
      .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
      .DCFILTER_DISABLE (DCFILTER_DISABLE),
      .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
      .DATA_WIDTH (16)
    ) i_rx_channel_3 (
      .adc_clk (adc_clk),
      .adc_rst (adc_rst),
      .adc_valid_in (adc_valid_B),
      .adc_data_in (adc_data_q_B[15:0]),
      .adc_valid_out (),
      .adc_data_out (adc_data_q1),
      .adc_data_iq_in (adc_data_iq_i1_s),
      .adc_data_iq_out (adc_data_iq_q1_s),
      .adc_enable (adc_enable_q1),
      .dac_valid_in (dac_data_valid_B),
      .dac_data_in (dac_data_q_B),
      .up_adc_pn_err (up_adc_pn_err_s[3]),
      .up_adc_pn_oos (up_adc_pn_oos_s[3]),
      .up_adc_or (up_adc_or_s[3]),
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

    // common processor control

    up_adc_common #(
      .ID (ID),
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .FPGA_FAMILY (FPGA_FAMILY),
      .SPEED_GRADE (SPEED_GRADE),
      .DEV_PACKAGE (DEV_PACKAGE),
      .COMMON_ID (COMMON_BASE_ADDR),
      .CONFIG(CONFIG),
      .DRP_DISABLE(1),
      .USERPORTS_DISABLE(1),
      .GPIO_DISABLE(1),
      .START_CODE_DISABLE(1)
    ) i_up_adc_common (
      .mmcm_rst (),
      .adc_clk (adc_clk),
      .adc_rst (adc_rst),
      .adc_r1_mode (),
      .adc_ddr_edgesel (),
      .adc_pin_mode (),
      .adc_status (1'b1),
      .adc_sync_status (1'd0),
      .adc_status_ovf (adc_dovf),
      .adc_clk_ratio (adc_clk_ratio),
      .adc_start_code (),
      .adc_sref_sync (),
      .adc_sync (adc_sync),
      .adc_ext_sync_arm (adc_ext_sync_arm),
      .adc_ext_sync_disarm (adc_ext_sync_disarm),
      .adc_ext_sync_manual_req (adc_ext_sync_manual_req),
      .adc_num_lanes (adc_num_lanes),
      .adc_custom_control (),
      .adc_crc_enable (),
      .adc_sdr_ddr_n (adc_sdr_ddr_n),
      .adc_symb_op (adc_symb_op),
      .adc_symb_8_16b (adc_symb_8_16b),
      .up_pps_rcounter(32'h0),
      .up_pps_status(1'b0),
      .up_pps_irq_mask(),
      .up_adc_r1_mode (up_adc_r1_mode),
      .up_adc_ce (),
      .up_status_pn_err (up_status_pn_err),
      .up_status_pn_oos (up_status_pn_oos),
      .up_status_or (up_status_or),
      .up_drp_sel (),
      .up_drp_wr (),
      .up_drp_addr (),
      .up_drp_wdata (),
      .up_drp_rdata (32'd0),
      .up_drp_ready (1'd0),
      .up_drp_locked (1'd1),
      .adc_config_wr (),
      .adc_config_ctrl (),
      .adc_config_rd ('d0),
      .adc_ctrl_status ('d0),
      .up_usr_chanmax_out (),
      .up_usr_chanmax_in (8'd3),
      .up_adc_gpio_in (32'd0),
      .up_adc_gpio_out (),
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

    assign adc_single_lane = adc_num_lanes[0];

  end
  endgenerate

endmodule
