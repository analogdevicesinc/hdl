// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
// ADC channel-need to work on dual mode for pn sequence

`timescale 1ns/100ps

module axi_ad9361_rx #(

  // parameters

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   MODE_1R1T = 0,
  parameter   CMOS_OR_LVDS_N = 0,
  parameter   PPS_RECEIVER_ENABLE = 0,
  parameter   INIT_DELAY = 0,
  parameter   USERPORTS_DISABLE = 0,
  parameter   DATAFORMAT_DISABLE = 0,
  parameter   DCFILTER_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0) (

  // common

  output          mmcm_rst,

  // adc interface

  output          adc_rst,
  input           adc_clk,
  input           adc_valid,
  input   [47:0]  adc_data,
  input           adc_status,
  output          adc_r1_mode,
  output          adc_ddr_edgesel,
  input   [47:0]  dac_data,

  // delay interface

  output  [12:0]  up_dld,
  output  [64:0]  up_dwdata,
  input   [64:0]  up_drdata,
  input           delay_clk,
  output          delay_rst,
  input           delay_locked,

  // dma interface

  output          adc_enable_i0,
  output          adc_valid_i0,
  output  [15:0]  adc_data_i0,
  output          adc_enable_q0,
  output          adc_valid_q0,
  output  [15:0]  adc_data_q0,
  output          adc_enable_i1,
  output          adc_valid_i1,
  output  [15:0]  adc_data_i1,
  output          adc_enable_q1,
  output          adc_valid_q1,
  output  [15:0]  adc_data_q1,
  input           adc_dovf,

  // gpio

  input   [31:0]  up_adc_gpio_in,
  output  [31:0]  up_adc_gpio_out,

  // 1PPS reporting counter and interrupt

  input   [31:0]  up_pps_rcounter,
  input           up_pps_status,
  output          up_pps_irq_mask,

  // processor interface

  input           up_rstn,
  input           up_clk,
  input           up_wreq,
  input   [13:0]  up_waddr,
  input   [31:0]  up_wdata,
  output          up_wack,
  input           up_rreq,
  input   [13:0]  up_raddr,
  output  [31:0]  up_rdata,
  output          up_rack,

  // drp interface

  output          up_drp_sel,
  output          up_drp_wr,
  output   [11:0] up_drp_addr,
  output   [31:0] up_drp_wdata,
  input    [31:0] up_drp_rdata,
  input           up_drp_ready,
  input           up_drp_locked);

  // configuration settings

  localparam  CONFIG =  (PPS_RECEIVER_ENABLE * 256) +
                        (CMOS_OR_LVDS_N * 128) +
                        (MODE_1R1T * 16) +
                        (USERPORTS_DISABLE * 8) +
                        (DATAFORMAT_DISABLE * 4) +
                        (DCFILTER_DISABLE * 2) +
                        (IQCORRECTION_DISABLE * 1);

  // internal registers

  reg             up_status_pn_err = 'd0;
  reg             up_status_pn_oos = 'd0;
  reg             up_status_or = 'd0;
  reg     [31:0]  up_rdata_int = 'd0;
  reg             up_rack_int = 'd0;
  reg             up_wack_int = 'd0;

  // internal signals

  wire    [15:0]  adc_dcfilter_data_out_0_s;
  wire    [15:0]  adc_dcfilter_data_out_1_s;
  wire    [15:0]  adc_dcfilter_data_out_2_s;
  wire    [15:0]  adc_dcfilter_data_out_3_s;
  wire    [ 3:0]  up_adc_pn_err_s;
  wire    [ 3:0]  up_adc_pn_oos_s;
  wire    [ 3:0]  up_adc_or_s;
  wire    [31:0]  up_rdata_s[0:5];
  wire    [ 5:0]  up_rack_s;
  wire    [ 5:0]  up_wack_s;

  // processor read interface

  assign up_wack = up_wack_int;
  assign up_rack = up_rack_int;
  assign up_rdata = up_rdata_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_pn_err <= 'd0;
      up_status_pn_oos <= 'd0;
      up_status_or <= 'd0;
      up_rdata_int <= 'd0;
      up_rack_int <= 'd0;
      up_wack_int <= 'd0;
    end else begin
      up_status_pn_err <= | up_adc_pn_err_s;
      up_status_pn_oos <= | up_adc_pn_oos_s;
      up_status_or <= | up_adc_or_s;
      up_rdata_int <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] |
        up_rdata_s[3] | up_rdata_s[4] | up_rdata_s[5];
      up_rack_int <=  | up_rack_s;
      up_wack_int <=  | up_wack_s;
    end
  end

  // channel 0 (i)

  axi_ad9361_rx_channel #(
    .Q_OR_I_N (0),
    .CHANNEL_ID (0),
    .DISABLE (0),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE))
  i_rx_channel_0 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[11:0]),
    .adc_data_q (adc_data[23:12]),
    .adc_or (1'b0),
    .dac_data (dac_data[11:0]),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_0_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_1_s),
    .adc_iqcor_valid (adc_valid_i0),
    .adc_iqcor_data (adc_data_i0),
    .adc_enable (adc_enable_i0),
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

  axi_ad9361_rx_channel #(
    .Q_OR_I_N (1),
    .CHANNEL_ID (1),
    .DISABLE (0),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE))
  i_rx_channel_1 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[23:12]),
    .adc_data_q (adc_data[11:0]),
    .adc_or (1'b0),
    .dac_data (dac_data[23:12]),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_1_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_0_s),
    .adc_iqcor_valid (adc_valid_q0),
    .adc_iqcor_data (adc_data_q0),
    .adc_enable (adc_enable_q0),
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

  axi_ad9361_rx_channel #(
    .Q_OR_I_N (0),
    .CHANNEL_ID (2),
    .DISABLE (MODE_1R1T),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE))
  i_rx_channel_2 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[35:24]),
    .adc_data_q (adc_data[47:36]),
    .adc_or (1'b0),
    .dac_data (dac_data[35:24]),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_2_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_3_s),
    .adc_iqcor_valid (adc_valid_i1),
    .adc_iqcor_data (adc_data_i1),
    .adc_enable (adc_enable_i1),
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

  axi_ad9361_rx_channel #(
    .Q_OR_I_N (1),
    .CHANNEL_ID (3),
    .DISABLE (MODE_1R1T),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE))
  i_rx_channel_3 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[47:36]),
    .adc_data_q (adc_data[35:24]),
    .adc_or (1'b0),
    .dac_data (dac_data[47:36]),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_3_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_2_s),
    .adc_iqcor_valid (adc_valid_q1),
    .adc_iqcor_data (adc_data_q1),
    .adc_enable (adc_enable_q1),
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
    .CONFIG (CONFIG),
    .DRP_DISABLE (1),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .GPIO_DISABLE (0),
    .START_CODE_DISABLE (0))
  i_up_adc_common (
    .mmcm_rst (mmcm_rst),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (adc_r1_mode),
    .adc_ddr_edgesel (adc_ddr_edgesel),
    .adc_pin_mode (),
    .adc_status (adc_status),
    .adc_sync_status (1'd0),
    .adc_status_ovf (adc_dovf),
    .adc_clk_ratio (32'd1),
    .adc_start_code (),
    .adc_sref_sync (),
    .adc_sync (),
    .adc_num_lanes (),
    .adc_sdr_ddr_n (),
    .up_adc_ce (),
    .up_pps_rcounter (up_pps_rcounter),
    .up_pps_status (up_pps_status),
    .up_pps_irq_mask (up_pps_irq_mask),
    .up_adc_r1_mode (),
    .up_status_pn_err (up_status_pn_err),
    .up_status_pn_oos (up_status_pn_oos),
    .up_status_or (up_status_or),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked),
    .up_usr_chanmax_out (),
    .up_usr_chanmax_in (8'd3),
    .up_adc_gpio_in (up_adc_gpio_in),
    .up_adc_gpio_out (up_adc_gpio_out),
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

  // adc delay control

  up_delay_cntrl #(
    .INIT_DELAY (INIT_DELAY),
    .DATA_WIDTH (13),
    .BASE_ADDRESS (6'h02))
  i_delay_cntrl (
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked),
    .up_dld (up_dld),
    .up_dwdata (up_dwdata),
    .up_drdata (up_drdata),
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

// ***************************************************************************
// ***************************************************************************

