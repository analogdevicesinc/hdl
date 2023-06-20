// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2019 (c) Analog Devices, Inc. All rights reserved.
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

module axi_pwm_custom #(
  parameter       ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0
) (
  
  // physical interface

  output                  pwm_led_0,
  output                  pwm_led_1,
  output                  pwm_led_2,
  output                  pwm_led_3,

    // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
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
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready
);

// internal registers

reg             up_wack = 'd0;
reg     [31:0]  up_rdata = 'd0;
reg             up_rack = 'd0;

// internal clocks & resets

wire            adc_rst;
wire            up_clk;
wire            adc_clk;
wire            pwm_clk;
wire            up_rstn;
         


// internal signals

wire    [11:0]  data_channel_0;
wire    [11:0]  data_channel_1;
wire    [11:0]  data_channel_2;
wire    [11:0]  data_channel_3;

wire    [31:0]  up_rdata_s[0:3];
wire            up_rack_s[0:3];
wire            up_wack_s[0:3];

wire            up_wreq_s;
wire            up_rreq_s;
wire [13:0]     up_waddr_s; 
wire [13:0]     up_raddr_s;
wire [31:0]     up_wdata_s; 

  //defaults

assign up_clk = s_axi_aclk;
assign pwm_clk = s_axi_aclk;
assign adc_clk = s_axi_aclk;
assign up_rstn = s_axi_aresetn;
assign adc_rst = ~up_rstn; 

  // processor read interface

always @(negedge up_rstn or posedge up_clk) begin
  if (up_rstn == 0) begin
    up_rdata <= 32'd0;
    up_rack <= 1'd0;
    up_wack <= 1'd0;
  end else begin
    up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] | up_rdata_s[3];
    up_rack <= up_rack_s[0] | up_rack_s[1] | up_rack_s[2] | up_rack_s[3];
    up_wack <= up_wack_s[0] | up_wack_s[1] | up_wack_s[2] | up_wack_s[3];
  end
end

   axi_pwm_custom_if #(
    
  ) i_if (
    .pwm_clk (pwm_clk),
    .rstn (up_rstn),
    .pwm_led_0 (pwm_led_0),
    .pwm_led_1 (pwm_led_1),
    .pwm_led_2 (pwm_led_2),
    .pwm_led_3 (pwm_led_3),
    .data_channel_0 (data_channel_0),
    .data_channel_1 (data_channel_1),
    .data_channel_2 (data_channel_2),
    .data_channel_3 (data_channel_3));

 // channels

    up_adc_channel #(
    .CHANNEL_ID(0)
  ) axi_pwm_custom_channel_0(
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (),
    .adc_dfmt_type (),
    .adc_dfmt_enable (),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pnseq_sel (),
    .adc_data_sel (0),
    .adc_pn_err ('b0),
    .adc_pn_oos ('b0),
    .adc_or ('b0),
    .adc_read_data ('b0),
    .adc_status_header ('b0),
    .adc_crc_err ('b0),
    .adc_softspan (),
    .adc_data_channel (data_channel_0),
    .up_adc_crc_err (),
    .up_adc_pn_err (),
    .up_adc_pn_oos (),
    .up_adc_or (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be ('b0),
    .adc_usr_datatype_signed ('b0),
    .adc_usr_datatype_shift ('b0),
    .adc_usr_datatype_total_bits ('b0),
    .adc_usr_datatype_bits ('b0),
    .adc_usr_decimation_m ('b0),
    .adc_usr_decimation_n ('b0),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[0]),
    .up_rack  ( up_rack_s[0])); 
    

    up_adc_channel #(
    .CHANNEL_ID(1)
  ) axi_pwm_custom_channel_1(
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (),
    .adc_dfmt_type (),
    .adc_dfmt_enable (),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pnseq_sel (),
    .adc_data_sel (0),
    .adc_pn_err ('b0),
    .adc_pn_oos ('b0),
    .adc_or ('b0),
    .adc_read_data ('b0),
    .adc_status_header ('b0),
    .adc_crc_err ('b0),
    .adc_softspan (),
    .adc_data_channel (data_channel_1),
    .up_adc_crc_err (),
    .up_adc_pn_err (),
    .up_adc_pn_oos (),
    .up_adc_or (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be ('b0),
    .adc_usr_datatype_signed ('b0),
    .adc_usr_datatype_shift ('b0),
    .adc_usr_datatype_total_bits ('b0),
    .adc_usr_datatype_bits ('b0),
    .adc_usr_decimation_m ('b0),
    .adc_usr_decimation_n ('b0),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[1]),
    .up_rack  ( up_rack_s[1])); 

    up_adc_channel #(
      .CHANNEL_ID(2)
    ) axi_pwm_custom_channel_2(
      .adc_clk (adc_clk),
      .adc_rst (adc_rst),
      .adc_enable (),
      .adc_iqcor_enb (),
      .adc_dcfilt_enb (),
      .adc_dfmt_se (),
      .adc_dfmt_type (),
      .adc_dfmt_enable (),
      .adc_dcfilt_offset (),
      .adc_dcfilt_coeff (),
      .adc_iqcor_coeff_1 (),
      .adc_iqcor_coeff_2 (),
      .adc_pnseq_sel (),
      .adc_data_sel (0),
      .adc_pn_err ('b0),
      .adc_pn_oos ('b0),
      .adc_or ('b0),
      .adc_read_data ('b0),
      .adc_status_header ('b0),
      .adc_crc_err ('b0),
      .adc_softspan (),
      .adc_data_channel (data_channel_2),
      .up_adc_crc_err (),
      .up_adc_pn_err (),
      .up_adc_pn_oos (),
      .up_adc_or (),
      .up_usr_datatype_be (),
      .up_usr_datatype_signed (),
      .up_usr_datatype_shift (),
      .up_usr_datatype_total_bits (),
      .up_usr_datatype_bits (),
      .up_usr_decimation_m (),
      .up_usr_decimation_n (),
      .adc_usr_datatype_be ('b0),
      .adc_usr_datatype_signed ('b0),
      .adc_usr_datatype_shift ('b0),
      .adc_usr_datatype_total_bits ('b0),
      .adc_usr_datatype_bits ('b0),
      .adc_usr_decimation_m ('b0),
      .adc_usr_decimation_n ('b0),
      .up_rstn (up_rstn),
      .up_clk (up_clk),
      .up_wreq (up_wreq_s),
      .up_waddr (up_waddr_s),
      .up_wdata (up_wdata_s),
      .up_wack (up_wack_s[2]),
      .up_rreq (up_rreq_s),
      .up_raddr (up_raddr_s),
      .up_rdata (up_rdata_s[2]),
      .up_rack  ( up_rack_s[2])); 

      up_adc_channel #(
        .CHANNEL_ID(3)
      ) axi_pwm_custom_channel_3(
        .adc_clk (adc_clk),
        .adc_rst (adc_rst),
        .adc_enable (),
        .adc_iqcor_enb (),
        .adc_dcfilt_enb (),
        .adc_dfmt_se (),
        .adc_dfmt_type (),
        .adc_dfmt_enable (),
        .adc_dcfilt_offset (),
        .adc_dcfilt_coeff (),
        .adc_iqcor_coeff_1 (),
        .adc_iqcor_coeff_2 (),
        .adc_pnseq_sel (),
        .adc_data_sel (0),
        .adc_pn_err ('b0),
        .adc_pn_oos ('b0),
        .adc_or ('b0),
        .adc_read_data ('b0),
        .adc_status_header ('b0),
        .adc_crc_err ('b0),
        .adc_softspan (),
        .adc_data_channel (data_channel_3),
        .up_adc_crc_err (),
        .up_adc_pn_err (),
        .up_adc_pn_oos (),
        .up_adc_or (),
        .up_usr_datatype_be (),
        .up_usr_datatype_signed (),
        .up_usr_datatype_shift (),
        .up_usr_datatype_total_bits (),
        .up_usr_datatype_bits (),
        .up_usr_decimation_m (),
        .up_usr_decimation_n (),
        .adc_usr_datatype_be ('b0),
        .adc_usr_datatype_signed ('b0),
        .adc_usr_datatype_shift ('b0),
        .adc_usr_datatype_total_bits ('b0),
        .adc_usr_datatype_bits ('b0),
        .adc_usr_decimation_m ('b0),
        .adc_usr_decimation_n ('b0),
        .up_rstn (up_rstn),
        .up_clk (up_clk),
        .up_wreq (up_wreq_s),
        .up_waddr (up_waddr_s),
        .up_wdata (up_wdata_s),
        .up_wack (up_wack_s[3]),
        .up_rreq (up_rreq_s),
        .up_raddr (up_raddr_s),
        .up_rdata (up_rdata_s[3]),
        .up_rack  ( up_rack_s[3])); 
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
