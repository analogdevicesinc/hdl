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

module ad_ip_jesd204_tpl_dac_regmap #(
  parameter ID = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,
  parameter NUM_CHANNELS = 2,
  parameter DATA_PATH_WIDTH = 16,
  parameter NUM_PROFILES = 1    // Number of supported JESD profiles
) (
  input s_axi_aclk,
  input s_axi_aresetn,

  input s_axi_awvalid,
  output s_axi_awready,
  input [11:0] s_axi_awaddr,
  input [2:0] s_axi_awprot,

  input s_axi_wvalid,
  output s_axi_wready,
  input [31:0] s_axi_wdata,
  input [3:0] s_axi_wstrb,

  input s_axi_arvalid,
  output s_axi_arready,
  input [11:0] s_axi_araddr,
  input [2:0] s_axi_arprot,

  output s_axi_rvalid,
  input s_axi_rready,
  output [31:0] s_axi_rdata,
  output [1:0] s_axi_rresp,

  output s_axi_bvalid,
  input s_axi_bready,
  output [1:0] s_axi_bresp,

  input link_clk,

  input dac_dunf,

  output dac_sync,

  output [NUM_CHANNELS*4-1:0] dac_data_sel,
  output dac_dds_format,

  output [NUM_CHANNELS*16-1:0] dac_dds_scale_0,
  output [NUM_CHANNELS*16-1:0] dac_dds_init_0,
  output [NUM_CHANNELS*16-1:0] dac_dds_incr_0,
  output [NUM_CHANNELS*16-1:0] dac_dds_scale_1,
  output [NUM_CHANNELS*16-1:0] dac_dds_init_1,
  output [NUM_CHANNELS*16-1:0] dac_dds_incr_1,

  output [NUM_CHANNELS*16-1:0] dac_pat_data_0,
  output [NUM_CHANNELS*16-1:0] dac_pat_data_1,

  // Framer interface
  input [NUM_PROFILES*8-1: 0] jesd_m,
  input [NUM_PROFILES*8-1: 0] jesd_l,
  input [NUM_PROFILES*8-1: 0] jesd_s,
  input [NUM_PROFILES*8-1: 0] jesd_f,
  input [NUM_PROFILES*8-1: 0] jesd_n,
  input [NUM_PROFILES*8-1: 0] jesd_np,

  output [$clog2(NUM_PROFILES):0] up_profile_sel
);

  // internal registers
  reg up_wack = 1'b0;
  reg up_rack = 1'b0;
  reg [31:0] up_rdata = 32'h00;
  reg [31:0] up_rdata_all;


  wire up_wreq_s;
  wire [9:0] up_waddr_s;
  wire [31:0] up_wdata_s;
  wire [NUM_CHANNELS+1:0] up_wack_s;
  wire up_rreq_s;
  wire [9:0] up_raddr_s;
  wire [31:0] up_rdata_s[0:NUM_CHANNELS+1];
  wire [NUM_CHANNELS+1:0] up_rack_s;

  // internal clocks and resets

  wire up_clk;
  wire up_rstn;
  wire dac_rst;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // up bus interface

  up_axi #(
    .AXI_ADDRESS_WIDTH (12)
  ) i_up_axi (
    .up_clk (up_clk),
    .up_rstn (up_rstn),

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
    .up_rack (up_rack)
  );

  integer n;

  always @(*) begin
    up_rdata_all = 'h00;
    for (n = 0; n < NUM_CHANNELS + 2; n = n + 1) begin
      up_rdata_all = up_rdata_all | up_rdata_s[n];
     end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_rdata <= up_rdata_all;
      up_rack <= |up_rack_s;
      up_wack <= |up_wack_s;
    end
  end

  // dac common processor interface

  up_dac_common #(
    .COMMON_ID(6'h0),
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DRP_DISABLE (1),
    .USERPORTS_DISABLE (1),
    .GPIO_DISABLE (1)
  ) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (link_clk),
    .dac_rst (dac_rst),
    .dac_sync (dac_sync),
    .dac_frame (),
    .dac_clksel (),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .dac_datafmt (dac_dds_format),
    .dac_datarate (),
    .dac_status (1'b1),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (DATA_PATH_WIDTH),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (32'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (NUM_CHANNELS),
    .up_dac_gpio_in (32'd0),
    .up_dac_gpio_out (),
    .up_dac_ce (),
    .up_pps_rcounter ('h00),
    .up_pps_status (1'b0),
    .up_pps_irq_mask (),

    .up_clk (up_clk),
    .up_rstn (up_rstn),

    .up_wreq (up_wreq_s),
    .up_waddr ({4'b0,up_waddr_s}),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr ({4'b0,up_raddr_s}),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0])
  );

  generate
  genvar i;
  for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: g_channel
    up_dac_channel #(
      .COMMON_ID(6'h1 + i/16),
      .CHANNEL_ID (i % 16),
      .USERPORTS_DISABLE (1),
      .IQCORRECTION_DISABLE (1)
    ) i_up_dac_channel (
      .dac_clk (link_clk),
      .dac_rst (dac_rst),
      .dac_dds_scale_1 (dac_dds_scale_0[16*i+:16]),
      .dac_dds_init_1 (dac_dds_init_0[16*i+:16]),
      .dac_dds_incr_1 (dac_dds_incr_0[16*i+:16]),
      .dac_dds_scale_2 (dac_dds_scale_1[16*i+:16]),
      .dac_dds_init_2 (dac_dds_init_1[16*i+:16]),
      .dac_dds_incr_2 (dac_dds_incr_1[16*i+:16]),
      .dac_pat_data_1 (dac_pat_data_0[16*i+:16]),
      .dac_pat_data_2 (dac_pat_data_1[16*i+:16]),
      .dac_data_sel (dac_data_sel[4*i+:4]),
      .dac_iq_mode (),
      .dac_iqcor_enb (),
      .dac_iqcor_coeff_1 (),
      .dac_iqcor_coeff_2 (),
      .up_usr_datatype_be (),
      .up_usr_datatype_signed (),
      .up_usr_datatype_shift (),
      .up_usr_datatype_total_bits (),
      .up_usr_datatype_bits (),
      .up_usr_interpolation_m (),
      .up_usr_interpolation_n (),
      .dac_usr_datatype_be (1'b0),
      .dac_usr_datatype_signed (1'b1),
      .dac_usr_datatype_shift (8'd0),
      .dac_usr_datatype_total_bits (8'd16),
      .dac_usr_datatype_bits (8'd16),
      .dac_usr_interpolation_m (16'd1),
      .dac_usr_interpolation_n (16'd1),

      .up_clk (up_clk),
      .up_rstn (up_rstn),
      .up_wreq (up_wreq_s),
      .up_waddr ({4'b0,up_waddr_s}),
      .up_wdata (up_wdata_s),
      .up_wack (up_wack_s[i+1]),
      .up_rreq (up_rreq_s),
      .up_raddr ({4'b0,up_raddr_s}),
      .up_rdata (up_rdata_s[i+1]),
      .up_rack (up_rack_s[i+1])
    );
  end
  endgenerate

  up_tpl_common #(
     .COMMON_ID(2'h0),            // Offset of regmap
     .NUM_PROFILES(NUM_PROFILES)  // Number of JESD profiles
    ) i_up_tpl_dac (

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
