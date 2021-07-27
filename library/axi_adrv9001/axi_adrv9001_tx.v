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

module axi_adrv9001_tx #(
  parameter   ID = 0,
  parameter   ENABLED = 1,
  parameter   CMOS_LVDS_N = 0,
  parameter   USE_RX_CLK_FOR_TX = 0,
  parameter   COMMON_BASE_ADDR = 'h10,
  parameter   CHANNEL_BASE_ADDR = 'h11,
  parameter   MODE_R1 = 1,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DISABLE = 0,
  parameter   DDS_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 20,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 18
) (
  // dac interface
  output                  dac_rst,
  input                   dac_clk,
  output                  dac_data_valid_A,
  output       [15:0]     dac_data_i_A,
  output       [15:0]     dac_data_q_A,

  output                  dac_data_valid_B,
  output       [15:0]     dac_data_i_B,
  output       [15:0]     dac_data_q_B,

  output                  dac_single_lane,
  output                  dac_sdr_ddr_n,
  output                  dac_symb_op,
  output                  dac_symb_8_16b,
  output                  up_dac_r1_mode,

  input                   tdd_tx_valid,

  input       [ 31:0]     dac_clk_ratio,

  // master/slave
  input                   dac_sync_in,
  output                  dac_sync_out,

  // dma interface
  output                  dac_valid,

  output                  dac_enable_i0,
  input       [ 15:0]     dac_data_i0,
  output                  dac_enable_q0,
  input       [ 15:0]     dac_data_q0,

  output                  dac_enable_i1,
  input       [ 15:0]     dac_data_i1,
  output                  dac_enable_q1,
  input       [ 15:0]     dac_data_q1,

  input                   dac_dunf,

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

  assign dac_rst = 1'b0;
  assign dac_data_valid_A = 1'b0;
  assign dac_data_i_A = 16'b0;
  assign dac_data_q_A = 16'b0;
  assign dac_data_valid_B = 1'b0;
  assign dac_data_i_B = 16'b0;
  assign dac_data_q_B = 16'b0;
  assign dac_single_lane = 1'b0;
  assign dac_sdr_ddr_n = 1'b0;
  assign dac_symb_op = 1'b0;
  assign dac_symb_8_16b = 1'b0;
  assign up_dac_r1_mode = 1'b0;
  assign dac_sync_out = 1'b0;
  assign dac_valid = 1'b0;
  assign dac_enable_i0 = 1'b0;
  assign dac_enable_q0 = 1'b0;
  assign dac_enable_i1 = 1'b0;
  assign dac_enable_q1 = 1'b0;

  always @(*) begin
    up_wack = 1'b0;
    up_rdata = 32'b0;
    up_rack = 1'b0;
  end

end else begin : core_enabled

  // configuration settings

  localparam  CONFIG =  (USE_RX_CLK_FOR_TX * 1024) +
                        (CMOS_LVDS_N * 128) +
                        (MODE_R1 * 16) +
                        (DDS_DISABLE * 64) +
                        (IQCORRECTION_DISABLE * 1);

  // internal registers

  reg               dac_data_sync = 'd0;
  reg     [15:0]    dac_rate_cnt = 'd0;
  reg               dac_valid_int = 'd0;

  // internal signals

  wire              dac_data_sync_s;
  wire    [ 15:0]   dac_data_iq_i0_s;
  wire    [ 15:0]   dac_data_iq_q0_s;
  wire    [ 15:0]   dac_data_iq_i1_s;
  wire    [ 15:0]   dac_data_iq_q1_s;
  wire              dac_dds_format_s;
  wire    [ 15:0]   dac_datarate_s;
  wire      [4:0]   dac_num_lanes;
  wire    [  4:0]   up_wack_s;
  wire    [  4:0]   up_rack_s;
  wire    [ 31:0]   up_rdata_s[0:4];

  // master/slave

  assign dac_data_sync_s = (ID == 0) ? dac_sync_out : dac_sync_in;

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

  assign dac_data_valid_A = dac_valid_int;
  assign dac_data_valid_B = dac_valid_int;

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_valid_int <= 1'b0;
    end else begin
      dac_valid_int <= (dac_rate_cnt == 16'd0) ? tdd_tx_valid : 1'b0;
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= | up_wack_s;
      up_rack <= | up_rack_s;
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] |
                  up_rdata_s[3] | up_rdata_s[4];
    end
  end

  // dac channel 0

  axi_adrv9001_tx_channel #(
    .CHANNEL_ID (0),
    .COMMON_ID (CHANNEL_BASE_ADDR),
    .Q_OR_I_N (0),
    .DISABLE (DISABLE),
    .DDS_DISABLE (DDS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_tx_channel_0 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_data_in_req (dac_valid),
    .dac_data_in (dac_data_i0),
    .dac_data_out_req (dac_data_valid_A),
    .dac_data_out (dac_data_i_A[15:0]),
    .dac_data_iq_in (dac_data_iq_q0_s),
    .dac_data_iq_out (dac_data_iq_i0_s),
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

  // dac channel 1

  axi_adrv9001_tx_channel #(
    .CHANNEL_ID (1),
    .COMMON_ID (CHANNEL_BASE_ADDR),
    .Q_OR_I_N (1),
    .DISABLE (DISABLE),
    .DDS_DISABLE (DDS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_tx_channel_1 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_data_in_req (),
    .dac_data_in (dac_data_q0),
    .dac_data_out_req (dac_data_valid_A),
    .dac_data_out (dac_data_q_A[15:0]),
    .dac_data_iq_in (dac_data_iq_i0_s),
    .dac_data_iq_out (dac_data_iq_q0_s),
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

  // dac channel 2 - disabled in 1R1T mode

  axi_adrv9001_tx_channel #(
    .CHANNEL_ID (2),
    .COMMON_ID (CHANNEL_BASE_ADDR),
    .Q_OR_I_N (0),
    .DISABLE (MODE_R1),
    .DDS_DISABLE (DDS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_tx_channel_2 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_data_in_req (),
    .dac_data_in (dac_data_i1),
    .dac_data_out_req (dac_data_valid_B),
    .dac_data_out (dac_data_i_B[15:0]),
    .dac_data_iq_in (dac_data_iq_q1_s),
    .dac_data_iq_out (dac_data_iq_i1_s),
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

  // dac channel 3 - disabled in 1R1T mode

  axi_adrv9001_tx_channel #(
    .CHANNEL_ID (3),
    .COMMON_ID (CHANNEL_BASE_ADDR),
    .Q_OR_I_N (1),
    .DISABLE (MODE_R1),
    .DDS_DISABLE (DDS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW))
  i_tx_channel_3 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_data_in_req (),
    .dac_data_in (dac_data_q1),
    .dac_data_out_req (dac_data_valid_B),
    .dac_data_out (dac_data_q_B[15:0]),
    .dac_data_iq_in (dac_data_iq_i1_s),
    .dac_data_iq_out (dac_data_iq_q1_s),
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
    .CONFIG(CONFIG),
    .CLK_EDGE_SEL(0),
    .COMMON_ID(COMMON_BASE_ADDR),
    .DRP_DISABLE(1),
    .USERPORTS_DISABLE(1),
    .GPIO_DISABLE(1))
  i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_num_lanes (dac_num_lanes),
    .dac_sdr_ddr_n (dac_sdr_ddr_n),
    .dac_symb_op (dac_symb_op),
    .dac_symb_8_16b (dac_symb_8_16b),
    .dac_sync (dac_sync_out),
    .dac_frame (),
    .dac_clksel (),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .up_dac_r1_mode (up_dac_r1_mode),
    .dac_datafmt (dac_dds_format_s),
    .dac_datarate (dac_datarate_s),
    .dac_status (1'b1),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (dac_clk_ratio),
    .up_dac_ce (),
    .up_pps_rcounter(32'h0),
    .up_pps_status(1'b0),
    .up_pps_irq_mask(),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (32'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd3),
    .up_dac_gpio_in (32'd0),
    .up_dac_gpio_out (),
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

  assign dac_single_lane = dac_num_lanes[0];

end
endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
