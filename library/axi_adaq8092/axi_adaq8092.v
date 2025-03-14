// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_adaq8092 #(

  parameter ID = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,
  parameter ADC_DATAPATH_DISABLE = 0,
  parameter IO_DELAY_GROUP = "adc_if_delay_group",
  parameter OUTPUT_MODE = 0,
  parameter   [27:0] POLARITY_MASK ='hfffffff
) (

  // adc interface (clk, data, over-range)

  input                   adc_clk_in_p,
  input                   adc_clk_in_n,
  input       [ 6:0]      lvds_adc_data_in1_p,
  input       [ 6:0]      lvds_adc_data_in1_n,
  input       [ 6:0]      lvds_adc_data_in2_p,
  input       [ 6:0]      lvds_adc_data_in2_n,
  input                   lvds_adc_or_in_p,
  input                   lvds_adc_or_in_n,
  input       [13:0]      cmos_adc_data_in1,
  input       [13:0]      cmos_adc_data_in2,
  input                   cmos_adc_or_in_1,
  input                   cmos_adc_or_in_2,

  // delay interface

  input                   delay_clk,

  // dma interface

  output                  adc_clk,
  output                  adc_rst,
  output                  adc_valid,
  output                  adc_enable_1,
  output                  adc_enable_2,
  output      [15:0]      adc_data_channel1,
  output      [15:0]      adc_data_channel2,
  input                   adc_dovf,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready,
  input       [ 2:0]      s_axi_awprot,
  input       [ 2:0]      s_axi_arprot
);

  // configuration settings

  localparam CONFIG = (OUTPUT_MODE * 128);

  // internal registers

  reg             up_status_or = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_wack = 'd0;
  reg             up_rack = 'd0;

  // internal clocks & resets

  wire            up_rstn;
  wire            up_clk;
  wire            delay_rst;

  // internal signals

  wire            adc_or_s;
  wire    [27:0]  adc_data_s;
  wire    [1:0]   up_status_or_s;
  wire            adc_status_s;
  wire    [29:0]  up_dld_s;
  wire    [149:0] up_dwdata_s;
  wire    [149:0] up_drdata_s;
  wire            delay_locked_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_rdata_s[0:3];
  wire    [3:0]   up_rack_s;
  wire    [3:0]   up_wack_s;
  wire            up_wreq_s;
  wire    [13:0]  up_waddr_s;
  wire    [31:0]  up_wdata_s;
  wire            up_rreq_s;
  wire    [13:0]  adc_decoded_data_s_1;
  wire    [13:0]  adc_decoded_data_s_2;
  wire    [27:0]  adc_part_decoded_data_s;
  wire    [7:0]   adc_custom_control_s;
  wire            sdr_or_ddr_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign adc_valid = 1'b1;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_or <= 'd0;
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_status_or <= up_status_or_s[0] | up_status_or_s[1];
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] | up_rdata_s[3];
      up_rack  <=  up_rack_s[0] | up_rack_s[1]  | up_rack_s[2]  | up_rack_s[3];
      up_wack  <=  up_wack_s[0] | up_wack_s[1]  | up_wack_s[2]  | up_wack_s[3];
    end
  end

  // ADC channel 1

  axi_adaq8092_channel #(
    .CHANNEL_ID(0),
    .DATAPATH_DISABLE (ADC_DATAPATH_DISABLE)
  ) i_channel_1 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data (adc_decoded_data_s_1),
    .adc_or (adc_or_s),
    .adc_dcfilter_data_out (adc_data_channel1),
    .adc_enable (adc_enable_1),
    .adc_valid (),
    .up_adc_or (up_status_or_s[0]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  // ADC channel 2

  axi_adaq8092_channel #(
    .CHANNEL_ID(1),
    .DATAPATH_DISABLE (ADC_DATAPATH_DISABLE)
  ) i_channel_2 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data (adc_decoded_data_s_2),
    .adc_or (adc_or_s),
    .adc_dcfilter_data_out (adc_data_channel2),
    .adc_enable (adc_enable_2),
    .adc_valid (),
    .up_adc_or (up_status_or_s[1]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  // ADC interface

  axi_adaq8092_rand_decode i_rand (
    .adc_data(adc_data_s),
    .adc_clk(adc_clk),
    .adc_rand_enb(adc_custom_control_s[0]),
    .adc_data_decoded(adc_part_decoded_data_s));

  axi_adaq8092_apb_decode i_apb (
    .adc_data(adc_part_decoded_data_s),
    .adc_clk(adc_clk),
    .adc_abp_enb(adc_custom_control_s[1]),
    .adc_data_decoded({adc_decoded_data_s_2,adc_decoded_data_s_1}));

  axi_adaq8092_if #(
    .OUTPUT_MODE(OUTPUT_MODE),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IO_DELAY_GROUP (IO_DELAY_GROUP),
    .POLARITY_MASK(POLARITY_MASK)
  ) i_if (
    .adc_clk_in_p (adc_clk_in_p),
    .adc_clk_in_n (adc_clk_in_n),
    .lvds_adc_data_p({lvds_adc_data_in2_p,lvds_adc_data_in1_p}),
    .lvds_adc_data_n({lvds_adc_data_in2_n,lvds_adc_data_in1_n}),
    .lvds_adc_or_p(lvds_adc_or_in_p),
    .lvds_adc_or_n(lvds_adc_or_in_n),
    .cmos_adc_data({cmos_adc_data_in2,cmos_adc_data_in1}),
    .cmos_adc_data_or_1(cmos_adc_or_in_1),
    .cmos_adc_data_or_2(cmos_adc_or_in_2),
    .sdr_or_ddr(sdr_or_ddr_s),
    .adc_clk (adc_clk),
    .adc_data(adc_data_s),
    .adc_or(adc_or_s),
    .adc_status (adc_status_s),
    .up_clk (up_clk),
    .up_dld (up_dld_s),
    .up_dwdata (up_dwdata_s),
    .up_drdata (up_drdata_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_s));

  // adc delay control

  up_delay_cntrl #(
    .DATA_WIDTH(30),
    .BASE_ADDRESS(6'h02)
  ) i_delay_cntrl (
    .core_rst (1'b0),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_s),
    .up_dld (up_dld_s),
    .up_dwdata (up_dwdata_s),
    .up_drdata (up_drdata_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

  // common processor control

  up_adc_common #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .CONFIG (CONFIG),
    .COMMON_ID (6'h00),
    .DRP_DISABLE (6'h00),
    .USERPORTS_DISABLE (0),
    .GPIO_DISABLE (0),
    .START_CODE_DISABLE(0)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_custom_control(adc_custom_control_s),
    .adc_sdr_ddr_n(sdr_or_ddr_s),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status_s),
    .adc_sync_status (1'd0),
    .adc_status_ovf (adc_dovf),
    .adc_clk_ratio (32'd1),
    .adc_start_code (),
    .adc_sref_sync (),
    .adc_sync (),
    .adc_ext_sync_arm(),
    .adc_ext_sync_disarm(),
    .adc_ext_sync_manual_req(),
    .adc_crc_enable (),
    .adc_num_lanes(),
    .adc_symb_op(),
    .adc_symb_8_16b(),

    .up_pps_rcounter(32'd0),
    .up_pps_status(1'd0),
    .up_pps_irq_mask(),
    .up_adc_ce (),
    .up_status_pn_err (),
    .up_status_pn_oos (),
    .up_status_or (),
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
    .up_usr_chanmax_in (8'd0),
    .up_adc_gpio_in (32'd0),
    .up_adc_gpio_out (),
    .up_adc_r1_mode(),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[3]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[3]),
    .up_rack (up_rack_s[3]));

  // up bus interface

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule
