// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
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

module axi_ad7606x #(

  parameter ID = 0,
  parameter DEV_CONFIG = 0,
  parameter ADC_TO_DMA_N_BITS = 16,
  parameter ADC_N_BITS = 16,
  parameter EXTERNAL_CLK = 0
) (

  // physical data interface

  output        rx_cs_n,
  output [15:0] rx_db_o,
  input  [15:0] rx_db_i,
  output        rx_db_t,
  output        rx_rd_n,
  output        rx_wr_n,
  input         external_clk,

  // physical control interface

  input         rx_busy,
  input         first_data,

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

  input         adc_dovf,
  output        adc_clk,

  output        adc_valid,
  output [ADC_TO_DMA_N_BITS-1:0] adc_data_0,
  output [ADC_TO_DMA_N_BITS-1:0] adc_data_1,
  output [ADC_TO_DMA_N_BITS-1:0] adc_data_2,
  output [ADC_TO_DMA_N_BITS-1:0] adc_data_3,
  output [ADC_TO_DMA_N_BITS-1:0] adc_data_4,
  output [ADC_TO_DMA_N_BITS-1:0] adc_data_5,
  output [ADC_TO_DMA_N_BITS-1:0] adc_data_6,
  output [ADC_TO_DMA_N_BITS-1:0] adc_data_7,
  output        adc_enable_0,
  output        adc_enable_1,
  output        adc_enable_2,
  output        adc_enable_3,
  output        adc_enable_4,
  output        adc_enable_5,
  output        adc_enable_6,
  output        adc_enable_7,
  output        adc_reset
);

  localparam [31:0] RD_RAW_CAP = 32'h2000;
  localparam        AD7606B = 1'b0;
  localparam        AD7606C_16 = 1'b1;

  // internal registers

  reg         up_wack = 1'b0;
  reg         up_rack = 1'b0;
  reg  [31:0] up_rdata = 32'b0;
  reg  [31:0] up_rdata_r;
  reg         up_rack_r;
  reg         up_wack_r;

  // internal signals

  wire [ADC_N_BITS-1:0] adc_data_0_s;
  wire [ADC_N_BITS-1:0] adc_data_1_s;
  wire [ADC_N_BITS-1:0] adc_data_2_s;
  wire [ADC_N_BITS-1:0] adc_data_3_s;
  wire [ADC_N_BITS-1:0] adc_data_4_s;
  wire [ADC_N_BITS-1:0] adc_data_5_s;
  wire [ADC_N_BITS-1:0] adc_data_6_s;
  wire [ADC_N_BITS-1:0] adc_data_7_s;
  wire [(8*ADC_N_BITS)-1:0] adc_data_s;
  wire [ 7:0]           adc_status_header[0:7];
  wire                  adc_status;
  wire [15:0]           adc_crc;
  wire [15:0]           adc_crc_res;
  wire                  adc_crc_err;
  wire                  adc_mode_en;
  wire [ 7:0]           adc_custom_control;

  wire                  adc_dfmt_enable_s[0:7];
  wire                  adc_dfmt_type_s[0:7];
  wire                  adc_dfmt_se_s[0:7];

  wire                  adc_clk_s;
  wire [ 7:0]           adc_enable;
  wire                  adc_reset_s;

  wire [(8*ADC_TO_DMA_N_BITS)-1:0] dma_data;
  wire                  dma_dvalid;

  wire                  up_clk;
  wire                  up_rstn;
  wire                  up_rreq_s;
  wire [13:0]           up_raddr_s;
  wire                  up_wreq_s;
  wire [13:0]           up_waddr_s;
  wire [31:0]           up_wdata_s;
  wire [31:0]           up_rdata_s[0:8];
  wire [8:0]            up_rack_s;
  wire [8:0]            up_wack_s;

  wire                  up_wack_cntrl_s;
  wire                  up_rack_cntrl_s;
  wire [31:0]           up_rdata_cntrl_s;

  wire [31:0]           wr_data_s;
  wire [15:0]           rd_data_s;
  wire                  rd_valid_s;
  wire [31:0]           adc_config_ctrl_s;
  wire                  adc_ctrl_status_s;
  wire                  m_axis_ready_s;
  wire                  m_axis_valid_s;
  wire [15:0]           m_axis_data_s;
  wire                  m_axis_xfer_req_s;

  // defaults

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign adc_reset = adc_reset_s;

  assign adc_enable_0 = adc_enable[0];
  assign adc_enable_1 = adc_enable[1];
  assign adc_enable_2 = adc_enable[2];
  assign adc_enable_3 = adc_enable[3];
  assign adc_enable_4 = adc_enable[4];
  assign adc_enable_5 = adc_enable[5];
  assign adc_enable_6 = adc_enable[6];
  assign adc_enable_7 = adc_enable[7];

  // processor read interface

  integer j;

  always @(*) begin
    up_rdata_r = 'h00;
    up_rack_r = 'h00;
    up_wack_r = 'h00;
    for (j = 0; j <= 8; j=j+1) begin
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

  generate
    if (EXTERNAL_CLK == 1'b1) begin
      assign adc_clk_s = external_clk;
    end else begin
      assign adc_clk_s = up_clk;
    end
  endgenerate

  assign adc_clk = adc_clk_s;

  generate
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin
      up_adc_channel #(
        .CHANNEL_ID(i)
      ) i_up_adc_channel (
        .adc_clk (adc_clk_s),
        .adc_rst (adc_reset_s),
        .adc_enable (adc_enable[i]),
        .adc_iqcor_enb (),
        .adc_dcfilt_enb (),
        .adc_dfmt_se (adc_dfmt_se_s[i]),
        .adc_dfmt_type (adc_dfmt_type_s[i]),
        .adc_dfmt_enable (adc_dfmt_enable_s[i]),
        .adc_dcfilt_offset (),
        .adc_dcfilt_coeff (),
        .adc_iqcor_coeff_1 (),
        .adc_iqcor_coeff_2 (),
        .adc_pnseq_sel (),
        .adc_data_sel (),
        .adc_pn_err (1'b0),
        .adc_pn_oos (1'b0),
        .adc_or (1'b0),
        .adc_read_data (rd_data_s),
        .adc_status_header(adc_status_header[i]),
        .adc_crc_err(adc_crc_err),
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
        .adc_usr_datatype_be (1'b0),
        .adc_usr_datatype_signed (1'b1),
        .adc_usr_datatype_shift (8'd0),
        .adc_usr_datatype_total_bits (8'd16),
        .adc_usr_datatype_bits (8'd16),
        .adc_usr_decimation_m (16'd1),
        .adc_usr_decimation_n (16'd1),
        .up_rstn (up_rstn),
        .up_clk (up_clk),
        .up_wreq (up_wreq_s),
        .up_waddr (up_waddr_s),
        .up_wdata (up_wdata_s),
        .up_wack (up_wack_s[i]),
        .up_rreq (up_rreq_s),
        .up_raddr (up_raddr_s),
        .up_rdata (up_rdata_s[i]),
        .up_rack (up_rack_s[i]));
    end
  endgenerate

  genvar k;
  generate
    for (k = 0;k < 8;k = k + 1) begin
      ad_datafmt #(
        .DATA_WIDTH (ADC_N_BITS),
        .BITS_PER_SAMPLE (ADC_TO_DMA_N_BITS)
      ) i_datafmt (
        .clk (adc_clk),
        .valid (1'b1),
        .data (adc_data_s[k*ADC_N_BITS+(ADC_N_BITS-1):k*ADC_N_BITS]),
        .valid_out (dma_dvalid),
        .data_out (dma_data[k*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):k*ADC_TO_DMA_N_BITS]),
        .dfmt_enable (adc_dfmt_enable_s[k]),
        .dfmt_type (adc_dfmt_type_s[k]),
        .dfmt_se (adc_dfmt_se_s[k]));
    end
  endgenerate

  generate
    if (DEV_CONFIG == AD7606B || DEV_CONFIG == AD7606C_16) begin
      axi_ad7606x_16b_pif i_ad7606_parallel_interface (
        .cs_n (rx_cs_n),
        .db_o (rx_db_o),
        .db_i (rx_db_i),
        .db_t (rx_db_t),
        .rd_n (rx_rd_n),
        .wr_n (rx_wr_n),
        .busy (rx_busy),
        .first_data (first_data),
        .adc_data_0 (adc_data_0_s),
        .adc_status_0 (adc_status_header[0]),
        .adc_data_1 (adc_data_1_s),
        .adc_status_1 (adc_status_header[1]),
        .adc_data_2 (adc_data_2_s),
        .adc_status_2 (adc_status_header[2]),
        .adc_data_3 (adc_data_3_s),
        .adc_status_3 (adc_status_header[3]),
        .adc_data_4 (adc_data_4_s),
        .adc_status_4 (adc_status_header[4]),
        .adc_data_5 (adc_data_5_s),
        .adc_status_5 (adc_status_header[5]),
        .adc_data_6 (adc_data_6_s),
        .adc_status_6 (adc_status_header[6]),
        .adc_data_7 (adc_data_7_s),
        .adc_status_7 (adc_status_header[7]),
        .adc_status (adc_status),
        .adc_crc (adc_crc),
        .adc_crc_res (adc_crc_res),
        .adc_crc_err (adc_crc_err),
        .adc_valid (adc_valid),
        .clk (adc_clk_s),
        .rstn (up_rstn),
        .adc_config_ctrl (adc_config_ctrl_s),
        .adc_ctrl_status (adc_ctrl_status_s),
        .adc_mode_en (adc_mode_en),
        .adc_custom_control (adc_custom_control),
        .wr_data (wr_data_s[15:0]),
        .rd_data (rd_data_s),
        .rd_valid (rd_valid_s));
    end else begin
      axi_ad7606x_18b_pif i_ad7606_parallel_interface (
        .cs_n (rx_cs_n),
        .db_o (rx_db_o),
        .db_i (rx_db_i),
        .db_t (rx_db_t),
        .rd_n (rx_rd_n),
        .wr_n (rx_wr_n),
        .busy (rx_busy),
        .first_data (first_data),
        .adc_data_0 (adc_data_0_s),
        .adc_status_0 (adc_status_header[0]),
        .adc_data_1 (adc_data_1_s),
        .adc_status_1 (adc_status_header[1]),
        .adc_data_2 (adc_data_2_s),
        .adc_status_2 (adc_status_header[2]),
        .adc_data_3 (adc_data_3_s),
        .adc_status_3 (adc_status_header[3]),
        .adc_data_4 (adc_data_4_s),
        .adc_status_4 (adc_status_header[4]),
        .adc_data_5 (adc_data_5_s),
        .adc_status_5 (adc_status_header[5]),
        .adc_data_6 (adc_data_6_s),
        .adc_status_6 (adc_status_header[6]),
        .adc_data_7 (adc_data_7_s),
        .adc_status_7 (adc_status_header[7]),
        .adc_status (adc_status),
        .adc_crc (adc_crc),
        .adc_crc_res (adc_crc_res),
        .adc_crc_err (adc_crc_err),
        .adc_valid (adc_valid),
        .clk (adc_clk_s),
        .rstn (up_rstn),
        .adc_config_ctrl (adc_config_ctrl_s),
        .adc_ctrl_status (adc_ctrl_status_s),
        .adc_mode_en (adc_mode_en),
        .adc_custom_control (adc_custom_control),
        .wr_data (wr_data_s[15:0]),
        .rd_data (rd_data_s),
        .rd_valid (rd_valid_s));
    end
  endgenerate

  assign adc_data_s = {adc_data_0_s,adc_data_1_s,adc_data_2_s,adc_data_3_s,adc_data_4_s,adc_data_5_s,adc_data_6_s,adc_data_7_s};
  assign adc_data_7 = dma_data[0*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):0*ADC_TO_DMA_N_BITS];
  assign adc_data_6 = dma_data[1*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):1*ADC_TO_DMA_N_BITS];
  assign adc_data_5 = dma_data[2*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):2*ADC_TO_DMA_N_BITS];
  assign adc_data_4 = dma_data[3*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):3*ADC_TO_DMA_N_BITS];
  assign adc_data_3 = dma_data[4*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):4*ADC_TO_DMA_N_BITS];
  assign adc_data_2 = dma_data[5*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):5*ADC_TO_DMA_N_BITS];
  assign adc_data_1 = dma_data[6*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):6*ADC_TO_DMA_N_BITS];
  assign adc_data_0 = dma_data[7*ADC_TO_DMA_N_BITS+(ADC_TO_DMA_N_BITS-1):7*ADC_TO_DMA_N_BITS];

  up_adc_common #(
    .ID (ID),
    .CONFIG (RD_RAW_CAP)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk_s),
    .adc_rst (adc_reset_s),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status),
    .adc_sync_status (1'b1),
    .adc_status_ovf (adc_dovf),
    .adc_clk_ratio (),
    .adc_start_code (),
    .adc_sref_sync (),
    .adc_sync (),
    .adc_ext_sync_arm (),
    .adc_ext_sync_disarm (),
    .adc_ext_sync_manual_req (),
    .adc_num_lanes (),
    .adc_custom_control (adc_custom_control),
    .adc_crc_enable (adc_mode_en),
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
    .adc_config_wr (wr_data_s),
    .adc_config_ctrl (adc_config_ctrl_s),
    .adc_config_rd ({16'd0, rd_data_s}),
    .adc_ctrl_status (adc_ctrl_status_s),
    .up_adc_gpio_in (),
    .up_adc_gpio_out (),
    .up_adc_ce (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[8]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[8]),
    .up_rack (up_rack_s[8]));

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
