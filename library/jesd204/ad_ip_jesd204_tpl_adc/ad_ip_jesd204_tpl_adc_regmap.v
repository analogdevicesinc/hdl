// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms.
// The user should keep this in in mind while exploring these cores.
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_ip_jesd204_tpl_adc_regmap #(
  parameter ID = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,
  parameter NUM_CHANNELS = 1,
  parameter DATA_PATH_WIDTH = 1,
  parameter NUM_PROFILES = 1    // Number of supported JESD profiles
) (
  // axi interface
  input s_axi_aclk,
  input s_axi_aresetn,
  input s_axi_awvalid,
  input [12:0] s_axi_awaddr,
  input [2:0] s_axi_awprot,
  output s_axi_awready,
  input s_axi_wvalid,
  input [31:0] s_axi_wdata,
  input [3:0] s_axi_wstrb,
  output s_axi_wready,
  output s_axi_bvalid,
  output [ 1:0] s_axi_bresp,
  input s_axi_bready,
  input s_axi_arvalid,
  input [12:0] s_axi_araddr,
  input [2:0] s_axi_arprot,
  output s_axi_arready,
  output s_axi_rvalid,
  output [1:0] s_axi_rresp,
  output [31:0] s_axi_rdata,
  input s_axi_rready,

  // control interface
  input link_clk,

  // Data format conversion configuration
  output [NUM_CHANNELS-1:0] dfmt_enable,
  output [NUM_CHANNELS-1:0] dfmt_sign_extend,
  output [NUM_CHANNELS-1:0] dfmt_type,

  // PN sequence monitor
  output [NUM_CHANNELS*4-1:0] pn_seq_sel,
  input [NUM_CHANNELS-1:0] pn_err,
  input [NUM_CHANNELS-1:0] pn_oos,

  output [NUM_CHANNELS-1:0] enable,

  input adc_sync_status,
  output adc_sync,
  output adc_rst,

  // Underflow
  input adc_dovf,

  // Deframer interface
  input [NUM_PROFILES*8-1: 0] jesd_m,
  input [NUM_PROFILES*8-1: 0] jesd_l,
  input [NUM_PROFILES*8-1: 0] jesd_s,
  input [NUM_PROFILES*8-1: 0] jesd_f,
  input [NUM_PROFILES*8-1: 0] jesd_n,
  input [NUM_PROFILES*8-1: 0] jesd_np,

  output [$clog2(NUM_PROFILES):0] up_profile_sel
);

  localparam [31:0] CLK_RATIO = DATA_PATH_WIDTH;

  reg up_rack = 1'b0;
  reg up_wack = 1'b0;
  reg [31:0] up_rdata = 32'h00;
  reg [31:0] up_rdata_all;

  reg up_status_pn_err = 1'b0;
  reg up_status_pn_oos = 1'b0;

  reg adc_status = 1'b0;

  // internal clocks & resets
  wire up_clk;
  wire up_rstn;

  wire up_wreq_s;
  wire [10:0] up_waddr_s;
  wire [31:0] up_wdata_s;
  wire [NUM_CHANNELS+1:0] up_wack_s;
  wire up_rreq_s;
  wire [10:0] up_raddr_s;
  wire [31:0] up_rdata_s[0:NUM_CHANNELS+1];
  wire [NUM_CHANNELS+1:0] up_rack_s;

  wire [NUM_CHANNELS-1:0] up_adc_pn_err_s;
  wire [NUM_CHANNELS-1:0] up_adc_pn_oos_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // status

  always @(posedge link_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

  // up bus interface

  up_axi #(
    .AXI_ADDRESS_WIDTH (13)
  ) i_up_axi (
    .up_clk (up_clk),
    .up_rstn (up_rstn),

    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr ({3'b0,s_axi_awaddr}),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr ({3'b0,s_axi_araddr}),
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
    .up_rack (up_rack)
  );

  integer n;

  always @(*) begin
    up_rdata_all = 'h00;
    for (n = 0; n <= NUM_CHANNELS+1; n = n + 1) begin
      up_rdata_all = up_rdata_all | up_rdata_s[n];
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_status_pn_err <= 'd0;
      up_status_pn_oos <= 'd0;
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_status_pn_err <= |up_adc_pn_err_s;
      up_status_pn_oos <= |up_adc_pn_oos_s;

      up_rdata <= up_rdata_all;
      up_rack <= |up_rack_s;
      up_wack <= |up_wack_s;
    end
  end

  // common processor control

  up_adc_common #(
    .COMMON_ID (6'h0),
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DRP_DISABLE (1),
    .USERPORTS_DISABLE (1),
    .GPIO_DISABLE (1),
    .START_CODE_DISABLE (1)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (link_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status),
    .adc_sync_status (adc_sync_status),
    .adc_status_ovf (adc_dovf),
    .adc_clk_ratio (CLK_RATIO),
    .adc_start_code (),
    .adc_sref_sync (),
    .adc_sync (adc_sync),

    .up_status_pn_err (up_status_pn_err),
    .up_status_pn_oos (up_status_pn_oos),
    .up_status_or (1'b0),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (32'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax_out (),
    .up_usr_chanmax_in (NUM_CHANNELS),
    .up_adc_gpio_in (32'd0),
    .up_adc_gpio_out (),
    .up_adc_ce (),
    .up_pps_rcounter (32'd0),
    .up_pps_status (1'b0),
    .up_pps_irq_mask (),

    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_wreq (up_wreq_s),
    .up_waddr ({3'b0,up_waddr_s}),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr ({3'b0,up_raddr_s}),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0])
  );

  generate
  genvar i;
  for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: g_channel
    up_adc_channel #(
      .COMMON_ID (6'h1 + i/16),
      .CHANNEL_ID (i % 16),
      .USERPORTS_DISABLE (1),
      .DCFILTER_DISABLE (1),
      .IQCORRECTION_DISABLE (1)
    ) i_up_adc_channel (
      .adc_clk (link_clk),
      .adc_rst (adc_rst),
      .adc_enable (enable[i]),
      .adc_iqcor_enb (),
      .adc_dcfilt_enb (),
      .adc_dfmt_enable (dfmt_enable[i]),
      .adc_dfmt_se (dfmt_sign_extend[i]),
      .adc_dfmt_type (dfmt_type[i]),
      .adc_dcfilt_offset (),
      .adc_dcfilt_coeff (),
      .adc_iqcor_coeff_1 (),
      .adc_iqcor_coeff_2 (),
      .adc_pnseq_sel (pn_seq_sel[i*4+:4]),
      .adc_data_sel (),
      .adc_pn_err (pn_err[i]),
      .adc_pn_oos (pn_oos[i]),
      .adc_or (1'b0),
      .adc_usr_datatype_be (1'b0),
      .adc_usr_datatype_signed (1'b1),
      .adc_usr_datatype_shift (8'd0),
      .adc_usr_datatype_total_bits (8'd16),
      .adc_usr_datatype_bits (8'd16),
      .adc_usr_decimation_m (16'd1),
      .adc_usr_decimation_n (16'd1),

      .up_adc_pn_err (up_adc_pn_err_s[i]),
      .up_adc_pn_oos (up_adc_pn_oos_s[i]),
      .up_adc_or (),
      .up_usr_datatype_be (),
      .up_usr_datatype_signed (),
      .up_usr_datatype_shift (),
      .up_usr_datatype_total_bits (),
      .up_usr_datatype_bits (),
      .up_usr_decimation_m (),
      .up_usr_decimation_n (),

      .up_clk (up_clk),
      .up_rstn (up_rstn),
      .up_wreq (up_wreq_s),
      .up_waddr ({3'b0,up_waddr_s}),
      .up_wdata (up_wdata_s),
      .up_wack (up_wack_s[i+1]),
      .up_rreq (up_rreq_s),
      .up_raddr ({3'b0,up_raddr_s}),
      .up_rdata (up_rdata_s[i+1]),
      .up_rack (up_rack_s[i+1])
    );
  end
  endgenerate

  up_tpl_common #(
     .COMMON_ID(2'h0),            // Offset of regmap
     .NUM_PROFILES(NUM_PROFILES)  // Number of JESD profiles
    ) i_up_tpl_adc (

    .jesd_m (jesd_m),
    .jesd_l (jesd_l),
    .jesd_s (jesd_s),
    .jesd_f (jesd_f),
    .jesd_n (jesd_n),
    .jesd_np (jesd_np),

    .up_profile_sel (up_profile_sel),

    // bus interface
    .up_clk (up_clk),
    .up_rstn (up_rstn),

    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[NUM_CHANNELS+1]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[NUM_CHANNELS+1]),
    .up_rack (up_rack_s[NUM_CHANNELS+1])
  );

endmodule
