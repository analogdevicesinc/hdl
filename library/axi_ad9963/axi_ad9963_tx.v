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

module axi_ad9963_tx #(

  // parameters

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 14,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 13,
  parameter   DATAPATH_DISABLE = 0
) (

  // dac interface

  input               dac_clk,
  output              dac_rst,
  output      [23:0]  dac_data,
  input       [23:0]  adc_data,

  // master/slave

  input               dac_sync_in,
  output              dac_sync_out,

  // dma interface

  output              dac_enable_i,
  output reg          dac_valid_i,
  input       [15:0]  dac_data_i,
  input               dma_valid_i,
  output              dac_enable_q,
  output reg          dac_valid_q,
  input       [15:0]  dac_data_q,
  input               dma_valid_q,
  input               dac_dunf,

  output              up_dac_ce,

  // processor interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [13:0]  up_waddr,
  input       [31:0]  up_wdata,
  output reg          up_wack,
  input               up_rreq,
  input       [13:0]  up_raddr,
  output reg  [31:0]  up_rdata,
  output reg          up_rack
);

  // internal signals

  wire            dac_data_sync_s;
  wire            dac_dds_format_s;
  wire    [23:0]  dac_data_int_s;
  wire    [31:0]  up_rdata_s[0:2];
  wire            up_rack_s[0:2];
  wire            up_wack_s[0:2];

  // master/slave

  assign dac_data_sync_s = (ID == 0) ? dac_sync_out : dac_sync_in;

  // dma interface

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_valid_i <= 1'b0;
      dac_valid_q <= 1'b0;
    end else begin
      dac_valid_i <= 1'b1;
      dac_valid_q <= 1'b1;
    end
  end

  // processor read interface

  always @(*) begin
    up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2];
    up_rack <=  up_rack_s[0] | up_rack_s[1] | up_rack_s[2];
    up_wack <=  up_wack_s[0] | up_wack_s[1] | up_wack_s[2];
  end

  // dac channel

  axi_ad9963_tx_channel #(
    .CHANNEL_ID (0),
    .Q_OR_I_N (0),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .DATAPATH_DISABLE (DATAPATH_DISABLE)
  ) i_tx_channel_0 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid_i),
    .dma_data (dac_data_i),
    .adc_data (adc_data[11:0]),
    .dac_data (dac_data[11:0]),
    .dac_data_out (dac_data_int_s[11:0]),
    .dac_data_in (dac_data_int_s[23:12]),
    .dac_enable (dac_enable_i),
    .dac_data_sync (dac_data_sync_s),
    .dac_dds_format (dac_dds_format_s),
    .dma_valid (dma_valid_i),
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

  axi_ad9963_tx_channel #(
    .CHANNEL_ID (1),
    .Q_OR_I_N (1),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .DATAPATH_DISABLE (DATAPATH_DISABLE)
  ) i_tx_channel_1 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid_q),
    .dma_data (dac_data_q),
    .adc_data (adc_data[23:12]),
    .dac_data (dac_data[23:12]),
    .dac_data_out (dac_data_int_s[23:12]),
    .dac_data_in (dac_data_int_s[11:0]),
    .dac_enable (dac_enable_q),
    .dac_data_sync (dac_data_sync_s),
    .dac_dds_format (dac_dds_format_s),
    .dma_valid (dma_valid_q),
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

  // dac common processor interface

  up_dac_common #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .CONFIG(0),
    .CLK_EDGE_SEL(0),
    .COMMON_ID(6'h10),
    .DRP_DISABLE (1),
    .USERPORTS_DISABLE (1),
    .GPIO_DISABLE(1)
  ) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_num_lanes (),
    .dac_sdr_ddr_n (),
    .dac_sync (dac_sync_out),
    .dac_frame (),
    .dac_clksel(),
    .dac_custom_wr(),
    .dac_custom_rd(32'b0),
    .dac_custom_control(),
    .dac_status_if_busy(1'b0),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .dac_datafmt (dac_dds_format_s),
    .dac_datarate (),
    .dac_status (1'b1),
    .dac_sync_in_status (1'b1),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (32'd1),
    .up_dac_ce(up_dac_ce),
    .up_pps_rcounter(32'h0),
    .up_pps_status(1'b0),
    .up_pps_irq_mask(),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (16'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd2),
    .up_dac_gpio_in (32'h0),
    .up_dac_gpio_out (),
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

endmodule
