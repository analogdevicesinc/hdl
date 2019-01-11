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

module ad_ip_jesd204_tpl_adc #(
  parameter ID = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,
  parameter NUM_LANES = 1,
  parameter NUM_CHANNELS = 4,
  parameter SAMPLES_PER_FRAME = 1,
  parameter CONVERTER_RESOLUTION = 14,
  parameter BITS_PER_SAMPLE = 16,
  parameter OCTETS_PER_BEAT = 4,
  parameter TWOS_COMPLEMENT = 1
) (
  // jesd interface
  // link_clk is (line-rate/40)
  input link_clk,

  input [OCTETS_PER_BEAT-1:0] link_sof,
  input link_valid,
  input [NUM_LANES*8*OCTETS_PER_BEAT-1:0] link_data,
  output link_ready,

  // dma interface

  output [NUM_CHANNELS-1:0] enable,

  output [NUM_CHANNELS-1:0] adc_valid,
  output [NUM_LANES*8*OCTETS_PER_BEAT-1:0] adc_data,
  input adc_dovf,

  // axi interface

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

  output s_axi_bvalid,
  input s_axi_bready,
  output [1:0] s_axi_bresp,

  input s_axi_arvalid,
  output s_axi_arready,
  input [11:0] s_axi_araddr,
  input [2:0] s_axi_arprot,

  output s_axi_rvalid,
  input s_axi_rready,
  output [1:0] s_axi_rresp,
  output [31:0] s_axi_rdata
);

  // Number of samples per channel that are processed in parallel.
  localparam DATA_PATH_WIDTH = OCTETS_PER_BEAT * 8 * NUM_LANES / NUM_CHANNELS / BITS_PER_SAMPLE;
  localparam LINK_DATA_WIDTH = NUM_LANES * OCTETS_PER_BEAT * 8;
  localparam DMA_DATA_WIDTH = BITS_PER_SAMPLE * DATA_PATH_WIDTH * NUM_CHANNELS;

  localparam BYTES_PER_FRAME = (NUM_CHANNELS * BITS_PER_SAMPLE * SAMPLES_PER_FRAME) / ( 8 * NUM_LANES);

  wire [NUM_CHANNELS-1:0] dfmt_enable_s;
  wire [NUM_CHANNELS-1:0] dfmt_sign_extend_s;
  wire [NUM_CHANNELS-1:0] dfmt_type_s;

  wire [NUM_CHANNELS*4-1:0] pn_seq_sel_s;
  wire [NUM_CHANNELS-1:0] pn_err_s;
  wire [NUM_CHANNELS-1:0] pn_oos_s;

  // regmap
  ad_ip_jesd204_tpl_adc_regmap #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .NUM_CHANNELS (NUM_CHANNELS),
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
    .NUM_PROFILES(1)
  ) i_regmap (
    .s_axi_aclk (s_axi_aclk),
    .s_axi_aresetn (s_axi_aresetn),
    .s_axi_awvalid (s_axi_awvalid),
    .s_axi_awready (s_axi_awready),
    .s_axi_awaddr (s_axi_awaddr),
    .s_axi_awprot (s_axi_awprot),
    .s_axi_wvalid (s_axi_wvalid),
    .s_axi_wready (s_axi_wready),
    .s_axi_wdata (s_axi_wdata),
    .s_axi_wstrb (s_axi_wstrb),
    .s_axi_bvalid (s_axi_bvalid),
    .s_axi_bresp (s_axi_bresp),
    .s_axi_bready (s_axi_bready),
    .s_axi_arvalid (s_axi_arvalid),
    .s_axi_arready (s_axi_arready),
    .s_axi_araddr (s_axi_araddr),
    .s_axi_arprot (s_axi_arprot),
    .s_axi_rvalid (s_axi_rvalid),
    .s_axi_rready (s_axi_rready),
    .s_axi_rresp (s_axi_rresp),
    .s_axi_rdata (s_axi_rdata),

    .link_clk (link_clk),

    .dfmt_enable (dfmt_enable_s),
    .dfmt_sign_extend (dfmt_sign_extend_s),
    .dfmt_type (dfmt_type_s),

    .pn_seq_sel (pn_seq_sel_s),
    .pn_err (pn_err_s),
    .pn_oos (pn_oos_s),

    .enable (enable),

    .adc_dovf (adc_dovf),

    .jesd_m (NUM_CHANNELS),
    .jesd_l (NUM_LANES),
    .jesd_s (SAMPLES_PER_FRAME),
    .jesd_f (BYTES_PER_FRAME),
    .jesd_n (CONVERTER_RESOLUTION),
    .jesd_np (BITS_PER_SAMPLE),
    .up_profile_sel ()
  );

  ad_ip_jesd204_tpl_adc_core #(
    .NUM_LANES (NUM_LANES),
    .NUM_CHANNELS (NUM_CHANNELS),
    .BITS_PER_SAMPLE (BITS_PER_SAMPLE),
    .CONVERTER_RESOLUTION (CONVERTER_RESOLUTION),
    .SAMPLES_PER_FRAME (SAMPLES_PER_FRAME),
    .OCTETS_PER_BEAT (OCTETS_PER_BEAT),
    .LINK_DATA_WIDTH (LINK_DATA_WIDTH),
    .DMA_DATA_WIDTH (DMA_DATA_WIDTH),
    .TWOS_COMPLEMENT (TWOS_COMPLEMENT),
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH)
  ) i_core (
    .clk (link_clk),

    .dfmt_enable (dfmt_enable_s),
    .dfmt_sign_extend (dfmt_sign_extend_s),
    .dfmt_type (dfmt_type_s),

    .pn_seq_sel (pn_seq_sel_s),
    .pn_err (pn_err_s),
    .pn_oos (pn_oos_s),

    .link_valid (link_valid),
    .link_ready (link_ready),
    .link_sof (link_sof),
    .link_data (link_data),

    .adc_valid (adc_valid),
    .adc_data (adc_data)
  );

endmodule
