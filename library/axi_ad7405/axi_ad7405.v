// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

module axi_ad7405 (

  input         adc_data_in,      /* input data to be filtered */
  output [15:0] adc_data_out,     /* filtered output */
  output        adc_data_en,

  // AXI Slave Memory Map

  input         s_axi_aclk,
  input         s_axi_aresetn,
  input         s_axi_awvalid,
  input  [15:0] s_axi_awaddr,
  input  [ 2:0] s_axi_awprot,
  output        s_axi_awready,
  input         s_axi_wvalid,
  input  [31:0] s_axi_wdata,
  input  [ 3:0] s_axi_wstrb,
  output        s_axi_wready,
  output        s_axi_bvalid,
  output [ 1:0] s_axi_bresp,
  input         s_axi_bready,
  input         s_axi_arvalid,
  input  [15:0] s_axi_araddr,
  input  [ 2:0] s_axi_arprot,
  output        s_axi_arready,
  output        s_axi_rvalid,
  output [ 1:0] s_axi_rresp,
  output [31:0] s_axi_rdata,
  input         s_axi_rready,

  input         clk_in
);

  localparam [31:0] RD_RAW_CAP = 32'h2000;

  // internal registers

  reg         up_wack = 1'b0;
  reg         up_rack = 1'b0;
  reg  [31:0] up_rdata = 32'b0;
  reg  [31:0] up_rdata_r;
  reg         up_rack_r;
  reg         up_wack_r;
  wire [15:0] up_dec_rate;
  wire [15:0] adc_dec_rate;

  wire        adc_reset_s;
  wire        adc_clk_s;

  wire        up_clk;
  wire        up_rstn;
  wire        up_rst;
  wire        up_rreq_s;
  wire [13:0] up_raddr_s;
  wire        up_wreq_s;
  wire [13:0] up_waddr_s;
  wire [31:0] up_wdata_s;
  wire [31:0] up_rdata_s[0:1];
  wire [ 1:0] up_rack_s;
  wire [ 1:0] up_wack_s;

  wire [15:0] dma_data;
  wire        dma_dvalid;
  wire [15:0] adc_data_out_s;

  wire        adc_dfmt_enable_s;
  wire        adc_dfmt_type_s;
  wire        adc_dfmt_se_s;

  assign adc_clk_s = clk_in;
  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

 // processor read interface

  integer j;

  always @(*) begin
    up_rdata_r = 'h00;
    up_rack_r = 'h00;
    up_wack_r = 'h00;
    for (j = 0; j <= 1; j=j+1) begin
      up_rack_r = up_rack_r | up_rack_s[j];
      up_wack_r = up_wack_r | up_wack_s[j];
      up_rdata_r = up_rdata_r | up_rdata_s[j];
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_rdata <= up_rdata_r;
      up_rack <= up_rack_r;
      up_wack <= up_wack_r;
    end
  end

  sync_data #(
    .NUM_OF_BITS (16),
    .ASYNC_CLK (1)
  ) i_cdc_status (
    .in_clk (up_clk),
    .in_data (up_dec_rate),
    .out_clk (adc_clk_s),
    .out_data (adc_dec_rate));

  up_adc_channel #(
    .CHANNEL_ID(0)
  ) i_up_adc_channel (
    .adc_clk (adc_clk_s),
    .adc_rst (adc_reset_s),
    .adc_enable (),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (adc_dfmt_se_s),
    .adc_dfmt_type (adc_dfmt_type_s),
    .adc_dfmt_enable (adc_dfmt_enable_s),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pnseq_sel (),
    .adc_data_sel (),
    .adc_pn_err (1'b0),
    .adc_pn_oos (1'b0),
    .adc_or (1'b0),
    .adc_read_data ({16'd0,adc_data_out}),
    .adc_status_header(),
    .adc_crc_err(),
    .up_adc_pn_err (),
    .up_adc_pn_oos (),
    .up_adc_or (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (up_dec_rate),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (up_dec_rate),
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

  ad_datafmt #(
    .DATA_WIDTH (16),
    .BITS_PER_SAMPLE (16)
  ) i_datafmt (
    .clk (adc_clk_s),
    .valid (1'b1),
    .data (adc_data_out_s[15:0]),
    .valid_out (dma_dvalid),
    .data_out (dma_data[15:0]),
    .dfmt_enable (adc_dfmt_enable_s),
    .dfmt_type (adc_dfmt_type_s),
    .dfmt_se (adc_dfmt_se_s));

  util_dec256sinc24b i_util_dec256sinc24b_interface (
    .clk (adc_clk_s),
    .reset (adc_reset_s),
    .data_in (adc_data_in),
    .data_out (adc_data_out_s),
    .data_en (adc_data_en),
    .dec_rate (adc_dec_rate));

  assign adc_data_out = dma_data[15:0];

  up_adc_common #(
    .CONFIG (RD_RAW_CAP)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk_s),
    .adc_rst (adc_reset_s),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (),
    .adc_sync_status (1'b1),
    .adc_status_ovf (1'b0),
    .adc_clk_ratio (),
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
    .up_pps_rcounter (),
    .up_pps_status (),
    .up_pps_irq_mask (),
    .up_adc_r1_mode (),
    .up_status_pn_err (),
    .up_status_pn_oos (),
    .up_status_or (),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (),
    .up_drp_ready (),
    .up_drp_locked (1'b1),
    .adc_config_wr (),
    .adc_config_ctrl (),
    .adc_config_rd ({16'd0, adc_data_out}),
    .adc_ctrl_status (1'b1),
    .up_adc_gpio_in (),
    .up_adc_gpio_out (),
    .up_adc_ce (),
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

  // up bus interface

  up_axi #(
    .AXI_ADDRESS_WIDTH (16)
  ) i_up_axi (
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
