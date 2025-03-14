// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad9963_rx #(

  // parameters

  parameter USERPORTS_DISABLE = 0,
  parameter DATAFORMAT_DISABLE = 0,
  parameter DCFILTER_DISABLE = 0,
  parameter IQCORRECTION_DISABLE = 0,
  parameter SCALECORRECTION_ONLY = 1,
  parameter IODELAY_ENABLE = 0,
  parameter ID = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0
) (

  // adc interface

  output              adc_rst,
  input               adc_clk,
  input               adc_valid,
  input       [23:0]  adc_data,
  input               adc_status,

  // delay interface

  output      [12:0]  up_dld,
  output      [64:0]  up_dwdata,
  input       [64:0]  up_drdata,
  input               delay_clk,
  output              delay_rst,
  input               delay_locked,

  // dma interface

  output              adc_enable_i,
  output              adc_valid_i,
  output      [15:0]  adc_data_i,
  output              adc_enable_q,
  output              adc_valid_q,
  output      [15:0]  adc_data_q,
  input               adc_dovf,

  output              up_adc_ce,

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

 // configuration settings

  localparam  CONFIG =  (SCALECORRECTION_ONLY * 512) +
                        (0 * 16) +
                        (USERPORTS_DISABLE * 8) +
                        (DATAFORMAT_DISABLE * 4) +
                        (DCFILTER_DISABLE * 2) +
                        (IQCORRECTION_DISABLE * 1);

  // internal registers

  reg             up_status_pn_err = 'd0;
  reg             up_status_pn_oos = 'd0;
  reg             up_status_or = 'd0;

  // internal signals

  wire    [15:0]  adc_dcfilter_data_out_0_s;
  wire    [15:0]  adc_dcfilter_data_out_1_s;
  wire    [ 1:0]  up_adc_pn_err_s;
  wire    [ 1:0]  up_adc_pn_oos_s;
  wire    [ 1:0]  up_adc_or_s;
  wire    [31:0]  up_rdata_s[0:3];
  wire            up_rack_s[0:3];
  wire            up_wack_s[0:3];

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_pn_err <= 'd0;
      up_status_pn_oos <= 'd0;
      up_status_or <= 'd0;
    end else begin
      up_status_pn_err <= | up_adc_pn_err_s;
      up_status_pn_oos <= | up_adc_pn_oos_s;
      up_status_or <= | up_adc_or_s;
    end
  end

  always @(*) begin
    up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] | up_rdata_s[3];
    up_rack <= up_rack_s[0] | up_rack_s[1] | up_rack_s[2] | up_rack_s[3];
    up_wack <= up_wack_s[0] | up_wack_s[1] | up_wack_s[2] | up_wack_s[3];
  end

  // channel 0 (i)

  axi_ad9963_rx_channel #(
    .Q_OR_I_N(0),
    .CHANNEL_ID(0),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
    .SCALECORRECTION_ONLY (SCALECORRECTION_ONLY)
  ) i_rx_channel_0 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[11:0]),
    .adc_or (1'b0),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_0_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_1_s),
    .adc_iqcor_valid (adc_valid_i),
    .adc_iqcor_data (adc_data_i),
    .adc_enable (adc_enable_i),
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

  axi_ad9963_rx_channel #(
    .Q_OR_I_N(1),
    .CHANNEL_ID(1),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE),
    .SCALECORRECTION_ONLY (SCALECORRECTION_ONLY)
  ) i_rx_channel_1 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[23:12]),
    .adc_or (1'b0),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_1_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_0_s),
    .adc_iqcor_valid (adc_valid_q),
    .adc_iqcor_data (adc_data_q),
    .adc_enable (adc_enable_q),
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

  // common processor control

  up_adc_common #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .CONFIG (CONFIG),
    .COMMON_ID(6'h00),
    .DRP_DISABLE (1),
    .USERPORTS_DISABLE (1),
    .GPIO_DISABLE (1),
    .START_CODE_DISABLE (1)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status),
    .adc_sync_status (1'd0),
    .adc_status_ovf (adc_dovf),
    .adc_clk_ratio (32'd1),
    .adc_start_code (),
    .adc_sref_sync (),
    .adc_sync (),
    .adc_ext_sync_arm (),
    .adc_ext_sync_disarm (),
    .adc_ext_sync_manual_req (),
    .adc_num_lanes (),
    .adc_custom_control (),
    .adc_crc_enable (),
    .adc_sdr_ddr_n (),
    .adc_symb_op (),
    .adc_symb_8_16b (),
    .up_pps_rcounter(32'h0),
    .up_pps_status(1'b0),
    .up_pps_irq_mask(),
    .up_adc_r1_mode (),
    .up_status_pn_err (up_status_pn_err),
    .up_status_pn_oos (up_status_pn_oos),
    .up_status_or (up_status_or),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (16'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax_out (),
    .adc_config_wr (),
    .adc_config_ctrl (),
    .adc_config_rd ('d0),
    .adc_ctrl_status ('d0),
    .up_usr_chanmax_in (8'd1),
    .up_adc_gpio_in (32'h0),
    .up_adc_gpio_out (),
    .up_adc_ce(up_adc_ce),
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

  // adc delay control

  generate if (IODELAY_ENABLE == 1) begin

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
    .up_wack (up_wack_s[3]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[3]),
    .up_rack (up_rack_s[3]));

  end else begin
    assign up_dld = 'h00;
    assign up_dwdata = 'h00;
    assign delay_rst = 1'b1;
    assign up_wack_s[3] = 0;
    assign up_rack_s[3] = 0;
    assign up_rdata_s[3] = 'h00;
  end
  endgenerate

endmodule
