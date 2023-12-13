// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad9361_tx #(

  // parameters

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   MODE_1R1T = 0,
  parameter   CLK_EDGE_SEL = 0,
  parameter   CMOS_OR_LVDS_N = 0,
  parameter   PPS_RECEIVER_ENABLE = 0,
  parameter   INIT_DELAY = 0,
  parameter   DAC_DDS_DISABLE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_PHASE_DW = 16,
  parameter   DAC_DDS_CORDIC_DW = 14,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 13,
  parameter   USERPORTS_DISABLE = 0,
  parameter   DELAYCNTRL_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0
) (

  // dac interface

  input           dac_clk,
  output          dac_valid,
  output  [47:0]  dac_data,
  output          dac_clksel,
  output          dac_r1_mode,
  input   [47:0]  adc_data,

  // delay interface

  output  [15:0]  up_dld,
  output  [79:0]  up_dwdata,
  input   [79:0]  up_drdata,
  input           delay_clk,
  output          delay_rst,
  input           delay_locked,

  // master/slave

  input           dac_sync_enable,
  input           dac_sync_in,
  output          dac_sync_out,

  // dma interface

  output          dac_enable_i0,
  output          dac_valid_i0,
  input   [15:0]  dac_data_i0,
  output          dac_enable_q0,
  output          dac_valid_q0,
  input   [15:0]  dac_data_q0,
  output          dac_enable_i1,
  output          dac_valid_i1,
  input   [15:0]  dac_data_i1,
  output          dac_enable_q1,
  output          dac_valid_q1,
  input   [15:0]  dac_data_q1,
  input           dac_dunf,

  // gpio

  input   [31:0]  up_dac_gpio_in,
  output  [31:0]  up_dac_gpio_out,

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
  output          up_rack
);

  // configuration settings

  localparam  CONFIG =  (PPS_RECEIVER_ENABLE * 256) +
                        (CMOS_OR_LVDS_N * 128) +
                        (DAC_DDS_DISABLE * 64) +
                        (DELAYCNTRL_DISABLE * 32) +
                        (MODE_1R1T * 16) +
                        (USERPORTS_DISABLE * 8) +
                        (IQCORRECTION_DISABLE * 1);

  // internal registers

  reg             dac_data_sync = 'd0;
  reg     [15:0]  dac_rate_cnt = 'd0;
  reg             dac_valid_int = 'd0;
  reg             dac_valid_i0_int = 'd0;
  reg             dac_valid_q0_int = 'd0;
  reg             dac_valid_i1_int = 'd0;
  reg             dac_valid_q1_int = 'd0;
  reg             up_wack_int = 'd0;
  reg             up_rack_int = 'd0;
  reg     [31:0]  up_rdata_int = 'd0;

  // internal clock and resets

  wire            dac_rst;

  // internal signals

  wire            dac_data_sync_s;
  wire            dac_dds_format_s;
  wire    [15:0]  dac_datarate_s;
  wire    [47:0]  dac_data_int_s;
  wire    [ 5:0]  up_wack_s;
  wire    [ 5:0]  up_rack_s;
  wire    [31:0]  up_rdata_s[0:5];

  // master/slave

  assign dac_data_sync_s = (ID == 0) ? dac_sync_out : dac_sync_in;
  assign dac_sync_out = dac_sync & dac_sync_enable;

  always @(posedge dac_clk) begin
    dac_data_sync <= dac_data_sync_s;
  end

  // rate counters and data sync signals

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_rate_cnt <= 16'b0;
    end else begin
      if ((dac_data_sync == 1'b1) || (dac_rate_cnt == 16'd0)) begin
        dac_rate_cnt <= dac_datarate_s;
      end else begin
        dac_rate_cnt <= dac_rate_cnt - 1'b1;
      end
    end
  end

  // dma interface

  assign dac_valid = dac_valid_int;
  assign dac_valid_i0 = dac_valid_i0_int;
  assign dac_valid_q0 = dac_valid_q0_int;
  assign dac_valid_i1 = dac_valid_i1_int;
  assign dac_valid_q1 = dac_valid_q1_int;

  always @(posedge dac_clk) begin
    dac_valid_int <= (dac_rate_cnt == 16'd0) ? 1'b1 : 1'b0;
    dac_valid_i0_int <= dac_valid_int;
    dac_valid_q0_int <= dac_valid_int;
    dac_valid_i1_int <= dac_valid_int & ~dac_r1_mode;
    dac_valid_q1_int <= dac_valid_int & ~dac_r1_mode;
  end

  // processor read interface

  assign up_wack = up_wack_int;
  assign up_rack = up_rack_int;
  assign up_rdata = up_rdata_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack_int <= 'd0;
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
    end else begin
      up_wack_int <=  | up_wack_s;
      up_rack_int <=  | up_rack_s;
      up_rdata_int <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] |
        up_rdata_s[3] | up_rdata_s[4] | up_rdata_s[5];
    end
  end

  // dac channel

  axi_ad9361_tx_channel #(
    .CHANNEL_ID (0),
    .Q_OR_I_N (0),
    .DISABLE (0),
    .DAC_DDS_DISABLE (DAC_DDS_DISABLE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_PHASE_DW (DAC_DDS_PHASE_DW),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE)
  ) i_tx_channel_0 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid_int),
    .dma_data (dac_data_i0),
    .adc_data (adc_data[11:0]),
    .dac_data (dac_data[11:0]),
    .dac_data_out (dac_data_int_s[11:0]),
    .dac_data_in (dac_data_int_s[23:12]),
    .dac_enable (dac_enable_i0),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
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

  // dac channel

  axi_ad9361_tx_channel #(
    .CHANNEL_ID (1),
    .Q_OR_I_N (1),
    .DISABLE (0),
    .DAC_DDS_DISABLE (DAC_DDS_DISABLE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_PHASE_DW (DAC_DDS_PHASE_DW),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE)
  ) i_tx_channel_1 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid_int),
    .dma_data (dac_data_q0),
    .adc_data (adc_data[23:12]),
    .dac_data (dac_data[23:12]),
    .dac_data_out (dac_data_int_s[23:12]),
    .dac_data_in (dac_data_int_s[11:0]),
    .dac_enable (dac_enable_q0),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
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

  // dac channel

  axi_ad9361_tx_channel #(
    .CHANNEL_ID (2),
    .Q_OR_I_N (0),
    .DISABLE (MODE_1R1T),
    .DAC_DDS_DISABLE (DAC_DDS_DISABLE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_PHASE_DW (DAC_DDS_PHASE_DW),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE)
  ) i_tx_channel_2 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid_int),
    .dma_data (dac_data_i1),
    .adc_data (adc_data[35:24]),
    .dac_data (dac_data[35:24]),
    .dac_data_out (dac_data_int_s[35:24]),
    .dac_data_in (dac_data_int_s[47:36]),
    .dac_enable (dac_enable_i1),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
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

  // dac channel

  axi_ad9361_tx_channel #(
    .CHANNEL_ID (3),
    .Q_OR_I_N (1),
    .DISABLE (MODE_1R1T),
    .DAC_DDS_DISABLE (DAC_DDS_DISABLE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_PHASE_DW (DAC_DDS_PHASE_DW),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE)
  ) i_tx_channel_3 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid_int),
    .dma_data (dac_data_q1),
    .adc_data (adc_data[47:36]),
    .dac_data (dac_data[47:36]),
    .dac_data_out (dac_data_int_s[47:36]),
    .dac_data_in (dac_data_int_s[35:24]),
    .dac_enable (dac_enable_q1),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
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

  // dac common processor interface

  up_dac_common #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .CONFIG (CONFIG),
    .CLK_EDGE_SEL (CLK_EDGE_SEL),
    .DRP_DISABLE (1),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .GPIO_DISABLE (0)
  ) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_num_lanes (),
    .dac_sdr_ddr_n (),
    .dac_sync (dac_sync),
    .dac_frame (),
    .dac_clksel (dac_clksel),
    .dac_custom_wr(),
    .dac_custom_rd(32'b0),
    .dac_custom_control(),
    .dac_status_if_busy(1'b0),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (dac_r1_mode),
    .dac_datafmt (dac_dds_format_s),
    .dac_datarate (dac_datarate_s),
    .dac_status (1'b1),
    .dac_sync_in_status (1'b1),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (32'd1),
    .up_dac_ce (),
    .up_pps_rcounter (up_pps_rcounter),
    .up_pps_status (up_pps_status),
    .up_pps_irq_mask (up_pps_irq_mask),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (32'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd3),
    .up_dac_gpio_in (up_dac_gpio_in),
    .up_dac_gpio_out (up_dac_gpio_out),
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

  // dac delay control

  up_delay_cntrl #(
    .DISABLE (DELAYCNTRL_DISABLE),
    .INIT_DELAY (INIT_DELAY),
    .DATA_WIDTH(16),
    .BASE_ADDRESS(6'h12)
  ) i_delay_cntrl (
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
