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

module axi_ad9434_core #(

  parameter ID = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0
) (

  // device interface

  input                   adc_clk,
  input       [47:0]      adc_data,
  input                   adc_or,

  // dma interface

  output                  dma_dvalid,
  output      [63:0]      dma_data,
  input                   dma_dovf,

  // drp interface

  output                  up_drp_sel,
  output                  up_drp_wr,
  output      [11:0]      up_drp_addr,
  output      [31:0]      up_drp_wdata,
  input       [31:0]      up_drp_rdata,
  input                   up_drp_ready,
  input                   up_drp_locked,

  // delay interface

  output      [12:0]      up_dld,
  output      [64:0]      up_dwdata,
  input       [64:0]      up_drdata,
  input                   delay_clk,
  output                  delay_rst,
  input                   delay_locked,

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
  output  reg             up_rack,

  // status and control signals

  output                  mmcm_rst,
  output                  adc_rst,
  output                  adc_enable,
  input                   adc_status
);

  // internal signals
  wire            up_status_pn_err_s;
  wire            up_status_pn_oos_s;
  wire            up_status_or_s;

  wire            adc_dfmt_se_s;
  wire            adc_dfmt_type_s;
  wire            adc_dfmt_enable_s;

  wire    [ 3:0]  adc_pnseq_sel_s;
  wire            adc_pn_err_s;
  wire            adc_pn_oos_s;

  wire            up_wack_s[0:2];
  wire    [31:0]  up_rdata_s[0:2];
  wire            up_rack_s[0:2];

  // instantiations
  axi_ad9434_pnmon i_pnmon (
    .adc_clk (adc_clk),
    .adc_data (adc_data),
    .adc_pnseq_sel (adc_pnseq_sel_s),
    .adc_pn_err (adc_pn_err_s),
    .adc_pn_oos (adc_pn_oos_s));

  genvar n;
  generate
  for (n = 0; n < 4; n = n + 1) begin: g_ad_dfmt
    ad_datafmt #(
      .DATA_WIDTH(12)
    ) i_datafmt (
      .clk (adc_clk),
      .valid (1'b1),
      .data (adc_data[n*12+11:n*12]),
      .valid_out (dma_dvalid),
      .data_out (dma_data[n*16+15:n*16]),
      .dfmt_enable (adc_dfmt_enable_s),
      .dfmt_type (adc_dfmt_type_s),
      .dfmt_se (adc_dfmt_se_s));
  end
  endgenerate

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2];
      up_rack <= up_rack_s[0] | up_rack_s[1] | up_rack_s[2];
      up_wack <= up_wack_s[0] | up_wack_s[1] | up_wack_s[2];
    end
  end

  up_adc_common #(
    .ID(ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .CONFIG(0),
    .COMMON_ID(0),
    .DRP_DISABLE(0),
    .USERPORTS_DISABLE(1),
    .GPIO_DISABLE(1),
    .START_CODE_DISABLE(1)
  ) i_adc_common(
    .mmcm_rst (mmcm_rst),

    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status),
    .adc_sync_status (1'd0),
    .adc_status_ovf (dma_dovf),
    .adc_clk_ratio (32'd4),
    .adc_start_code (),
    .adc_sref_sync (),
    .adc_ext_sync_arm (),
    .adc_ext_sync_disarm (),
    .adc_ext_sync_manual_req (),
    .adc_num_lanes (),
    .adc_custom_control (),
    .adc_crc_enable (),
    .adc_sdr_ddr_n (),
    .adc_symb_op (),
    .adc_symb_8_16b (),
    .adc_sync (),

    .up_pps_rcounter(32'h0),
    .up_adc_r1_mode (),
    .up_pps_status(1'b0),
    .up_pps_irq_mask(),

    .up_adc_ce (),
    .up_status_pn_err (up_status_pn_err_s),
    .up_status_pn_oos (up_status_pn_oos_s),
    .up_status_or (up_status_or_s),

    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .adc_config_wr (),
    .adc_config_ctrl (),
    .adc_config_rd ('d0),
    .adc_ctrl_status ('d0),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked),

    .up_usr_chanmax_out (),
    .up_usr_chanmax_in (8'd0),
    .up_adc_gpio_in (32'd0),
    .up_adc_gpio_out (),

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

  up_adc_channel #(
    .CHANNEL_ID(0),
    .USERPORTS_DISABLE(1),
    .DATAFORMAT_DISABLE(0),
    .DCFILTER_DISABLE(1),
    .IQCORRECTION_DISABLE(1)
  ) i_adc_channel(
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (adc_dfmt_se_s),
    .adc_dfmt_type (adc_dfmt_type_s),
    .adc_dfmt_enable (adc_dfmt_enable_s),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pnseq_sel (adc_pnseq_sel_s),
    .adc_data_sel (),
    .adc_pn_err (adc_pn_err_s),
    .adc_pn_oos (adc_pn_oos_s),
    .adc_or (adc_or),
    .adc_read_data ('d0),
    .adc_status_header ('d0),
    .adc_crc_err ('d0),
    .up_adc_pn_err (up_status_pn_err_s),
    .up_adc_pn_oos (up_status_pn_oos_s),
    .up_adc_or (up_status_or_s),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (16'd1),
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

  // adc delay control

  up_delay_cntrl #(
    .DATA_WIDTH(13),
    .BASE_ADDRESS(6'h02)
  ) i_delay_cntrl (
    .core_rst (1'b0),
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
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

endmodule
