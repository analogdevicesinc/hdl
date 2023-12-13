// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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
  parameter DMA_BITS_PER_SAMPLE = 16,
  parameter OCTETS_PER_BEAT = 4,
  parameter EN_FRAME_ALIGN = 1,
  parameter TWOS_COMPLEMENT = 1,
  parameter EXT_SYNC = 0,
  parameter PN7_ENABLE = 1,
  parameter PN15_ENABLE = 1
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
  output [DMA_BITS_PER_SAMPLE * OCTETS_PER_BEAT * 8 * NUM_LANES / BITS_PER_SAMPLE-1:0] adc_data,
  input adc_dovf,

  input adc_sync_in,
  output adc_sync_manual_req_out,
  input adc_sync_manual_req_in,

  output adc_rst,

  // axi interface

  input s_axi_aclk,
  input s_axi_aresetn,

  input s_axi_awvalid,
  output s_axi_awready,
  input [12:0] s_axi_awaddr,
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
  input [12:0] s_axi_araddr,
  input [2:0] s_axi_arprot,

  output s_axi_rvalid,
  input s_axi_rready,
  output [1:0] s_axi_rresp,
  output [31:0] s_axi_rdata
);

  // Number of samples per channel that are processed in parallel.
  localparam DATA_PATH_WIDTH = OCTETS_PER_BEAT * 8 * NUM_LANES / NUM_CHANNELS / BITS_PER_SAMPLE;
  localparam LINK_DATA_WIDTH = NUM_LANES * OCTETS_PER_BEAT * 8;
  localparam DMA_DATA_WIDTH = DMA_BITS_PER_SAMPLE * DATA_PATH_WIDTH * NUM_CHANNELS;

  localparam BYTES_PER_FRAME = (NUM_CHANNELS * BITS_PER_SAMPLE * SAMPLES_PER_FRAME) / ( 8 * NUM_LANES);

  wire [NUM_CHANNELS-1:0] dfmt_enable_s;
  wire [NUM_CHANNELS-1:0] dfmt_sign_extend_s;
  wire [NUM_CHANNELS-1:0] dfmt_type_s;

  wire [NUM_CHANNELS*4-1:0] pn_seq_sel_s;
  wire [NUM_CHANNELS-1:0] pn_err_s;
  wire [NUM_CHANNELS-1:0] pn_oos_s;

  wire adc_rst_sync_s;
  wire adc_rst_s;
  wire adc_sync;
  wire adc_sync_status;

  assign adc_rst = adc_rst_s | adc_rst_sync_s;

  // regmap
  ad_ip_jesd204_tpl_adc_regmap #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .NUM_CHANNELS (NUM_CHANNELS),
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
    .NUM_PROFILES(1),
    .EXT_SYNC (EXT_SYNC)
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

    .adc_sync (adc_sync),
    .adc_sync_status (adc_sync_status),
    .adc_ext_sync_arm (adc_ext_sync_arm),
    .adc_ext_sync_disarm (adc_ext_sync_disarm),
    .adc_ext_sync_manual_req (adc_sync_manual_req_out),

    .adc_rst (adc_rst_s),

    .adc_dovf (adc_dovf),

    .jesd_m (NUM_CHANNELS),
    .jesd_l (NUM_LANES),
    .jesd_s (SAMPLES_PER_FRAME),
    .jesd_f (BYTES_PER_FRAME),
    .jesd_n (CONVERTER_RESOLUTION),
    .jesd_np (BITS_PER_SAMPLE),
    .up_profile_sel ());

  ad_ip_jesd204_tpl_adc_core #(
    .NUM_LANES (NUM_LANES),
    .NUM_CHANNELS (NUM_CHANNELS),
    .BITS_PER_SAMPLE (BITS_PER_SAMPLE),
    .CONVERTER_RESOLUTION (CONVERTER_RESOLUTION),
    .SAMPLES_PER_FRAME (SAMPLES_PER_FRAME),
    .EN_FRAME_ALIGN (EN_FRAME_ALIGN),
    .OCTETS_PER_BEAT (OCTETS_PER_BEAT),
    .LINK_DATA_WIDTH (LINK_DATA_WIDTH),
    .DMA_DATA_WIDTH (DMA_DATA_WIDTH),
    .TWOS_COMPLEMENT (TWOS_COMPLEMENT),
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
    .DMA_BITS_PER_SAMPLE (DMA_BITS_PER_SAMPLE),
    .EXT_SYNC (EXT_SYNC),
    .PN7_ENABLE (PN7_ENABLE),
    .PN15_ENABLE(PN15_ENABLE)
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

    .adc_sync (adc_sync),
    .adc_sync_status (adc_sync_status),
    .adc_sync_in (adc_sync_in),
    .adc_ext_sync_arm (adc_ext_sync_arm),
    .adc_ext_sync_disarm (adc_ext_sync_disarm),
    .adc_sync_manual_req (adc_sync_manual_req_in),
    .adc_rst_sync (adc_rst_sync_s),

    .adc_valid (adc_valid),
    .adc_data (adc_data));

endmodule
