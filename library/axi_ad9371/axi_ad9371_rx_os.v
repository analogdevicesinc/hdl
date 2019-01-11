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

`timescale 1ns/100ps

module axi_ad9371_rx_os #(

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DATAPATH_DISABLE = 0) (

  // adc interface

  output                  adc_os_rst,
  input                   adc_os_clk,
  input                   adc_os_valid,
  input       [ 63:0]     adc_os_data,

  // dma interface

  output                  adc_os_enable_i0,
  output                  adc_os_valid_i0,
  output      [ 31:0]     adc_os_data_i0,
  output                  adc_os_enable_q0,
  output                  adc_os_valid_q0,
  output      [ 31:0]     adc_os_data_q0,
  input                   adc_os_dovf,

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
  output  reg             up_rack);


  // internal registers

  reg               up_status_pn_err = 'd0;
  reg               up_status_pn_oos = 'd0;
  reg               up_status_or = 'd0;

  // internal signals

  wire    [ 31:0]   adc_os_data_iq_i0_s;
  wire    [ 31:0]   adc_os_data_iq_q0_s;
  wire    [  1:0]   up_adc_pn_err_s;
  wire    [  1:0]   up_adc_pn_oos_s;
  wire    [  1:0]   up_adc_or_s;
  wire    [  2:0]   up_wack_s;
  wire    [  2:0]   up_rack_s;
  wire    [ 31:0]   up_rdata_s[0:2];

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
      up_status_pn_err <= | up_adc_pn_err_s;
      up_status_pn_oos <= | up_adc_pn_oos_s;
      up_status_or <= | up_adc_or_s;
      up_wack <= | up_wack_s;
      up_rack <= | up_rack_s;
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2];
    end
  end

  // channel o/s (i)

  axi_ad9371_rx_channel #(
    .Q_OR_I_N (0),
    .COMMON_ID ('h21),
    .CHANNEL_ID (0),
    .DATAPATH_DISABLE (DATAPATH_DISABLE),
    .DATA_WIDTH (32))
  i_rx_os_channel_0 (
    .adc_clk (adc_os_clk),
    .adc_rst (adc_os_rst),
    .adc_valid_in (adc_os_valid),
    .adc_data_in (adc_os_data[31:0]),
    .adc_valid_out (adc_os_valid_i0),
    .adc_data_out (adc_os_data_i0),
    .adc_data_iq_in (adc_os_data_iq_q0_s),
    .adc_data_iq_out (adc_os_data_iq_i0_s),
    .adc_enable (adc_os_enable_i0),
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

  // channel o/s (q)

  axi_ad9371_rx_channel #(
    .Q_OR_I_N (1),
    .COMMON_ID ('h21),
    .CHANNEL_ID (1),
    .DATAPATH_DISABLE (DATAPATH_DISABLE),
    .DATA_WIDTH (32))
  i_rx_os_channel_1 (
    .adc_clk (adc_os_clk),
    .adc_rst (adc_os_rst),
    .adc_valid_in (adc_os_valid),
    .adc_data_in (adc_os_data[63:32]),
    .adc_valid_out (adc_os_valid_q0),
    .adc_data_out (adc_os_data_q0),
    .adc_data_iq_in (adc_os_data_iq_i0_s),
    .adc_data_iq_out (adc_os_data_iq_q0_s),
    .adc_enable (adc_os_enable_q0),
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
    .COMMON_ID ('h20),
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_os_clk),
    .adc_rst (adc_os_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (1'b1),
    .adc_sync_status (1'd0),
    .adc_status_ovf (adc_os_dovf),
    .adc_clk_ratio (32'd1),
    .adc_start_code (),
    .adc_sref_sync (),
    .adc_sync (),
    .up_pps_rcounter (32'b0),
    .up_pps_status (1'b0),
    .up_pps_irq_mask (),
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
    .up_usr_chanmax_out (),
    .up_usr_chanmax_in (8'd3),
    .up_adc_gpio_in (32'd0),
    .up_adc_gpio_out (),
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

// ***************************************************************************
// ***************************************************************************

