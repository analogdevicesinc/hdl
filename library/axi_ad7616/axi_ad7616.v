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

module axi_ad7616 #(

  parameter ID = 0
) (

  // physical data interface

  output        rx_cs_n,
  output [15:0] rx_db_o,
  input  [15:0] rx_db_i,
  output        rx_db_t,
  output        rx_rd_n,
  output        rx_wr_n,

  // physical control interface

  input         rx_trigger,

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

  output        adc_valid,
  output        adc_clk,
  input         adc_dovf,

  output [15:0] adc_data_0,
  output [15:0] adc_data_1,
  output [15:0] adc_data_2,
  output [15:0] adc_data_3,
  output [15:0] adc_data_4,
  output [15:0] adc_data_5,
  output [15:0] adc_data_6,
  output [15:0] adc_data_7,
  output [15:0] adc_data_8,
  output [15:0] adc_data_9,
  output [15:0] adc_data_10,
  output [15:0] adc_data_11,
  output [15:0] adc_data_12,
  output [15:0] adc_data_13,
  output [15:0] adc_data_14,
  output [15:0] adc_data_15,

  output        adc_enable_0,
  output        adc_enable_1,
  output        adc_enable_2,
  output        adc_enable_3,
  output        adc_enable_4,
  output        adc_enable_5,
  output        adc_enable_6,
  output        adc_enable_7,
  output        adc_enable_8,
  output        adc_enable_9,
  output        adc_enable_10,
  output        adc_enable_11,
  output        adc_enable_12,
  output        adc_enable_13,
  output        adc_enable_14,
  output        adc_enable_15,
  output        adc_reset
);

  localparam [31:0] RD_RAW_CAP = 32'h2000;

  // internal registers

  reg         up_wack = 1'b0;
  reg         up_rack = 1'b0;
  reg  [31:0] up_rdata = 32'b0;
  reg  [31:0] up_rdata_r;
  reg         up_rack_r;
  reg         up_wack_r;

  // internal signals

  wire [15:0] adc_data_0_s;
  wire [15:0] adc_data_1_s;
  wire [15:0] adc_data_2_s;
  wire [15:0] adc_data_3_s;
  wire [15:0] adc_data_4_s;
  wire [15:0] adc_data_5_s;
  wire [15:0] adc_data_6_s;
  wire [15:0] adc_data_7_s;
  wire [15:0] adc_data_8_s;
  wire [15:0] adc_data_9_s;
  wire [15:0] adc_data_10_s;
  wire [15:0] adc_data_11_s;
  wire [15:0] adc_data_12_s;
  wire [15:0] adc_data_13_s;
  wire [15:0] adc_data_14_s;
  wire [15:0] adc_data_15_s;

  wire [255:0] adc_data_s;
  wire [ 7:0]  adc_custom_control;

  wire         adc_dfmt_enable_s[0:15];
  wire         adc_dfmt_type_s[0:15];
  wire         adc_dfmt_se_s[0:15];

  wire [15:0]  adc_enable;
  wire         adc_reset_s;

  wire [255:0] dma_data;
  wire         dma_dvalid;

  wire         up_clk;
  wire         up_rstn;
  wire         up_rst;
  wire         up_rreq_s;
  wire [13:0]  up_raddr_s;
  wire         up_wreq_s;
  wire [13:0]  up_waddr_s;
  wire [31:0]  up_wdata_s;
  wire [31:0]  up_rdata_s[0:16];
  wire [16:0]  up_rack_s;
  wire [16:0]  up_wack_s;

  wire         up_wack_cntrl_s;
  wire         up_rack_cntrl_s;
  wire [31:0]  up_rdata_cntrl_s;

  wire         trigger_s;

  wire         rd_req_s;
  wire         wr_req_s;
  wire [31:0]  wr_data_s;
  wire [15:0]  rd_data_s;
  wire         rd_valid_s;
  wire [ 4:0]  burst_length_s;

  wire [31:0]  adc_config_ctrl_s;
  wire         adc_ctrl_status_s;
  wire         m_axis_ready_s;
  wire         m_axis_valid_s;
  wire [15:0]  m_axis_data_s;
  wire         m_axis_xfer_req_s;

  wire [31:0]  adc_config_ctrl;

  // defaults

  assign adc_clk = s_axi_aclk;
  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign up_rst = ~s_axi_aresetn;
  assign adc_reset = adc_reset_s;

  assign adc_enable_0 = adc_enable[0];
  assign adc_enable_1 = adc_enable[1];
  assign adc_enable_2 = adc_enable[2];
  assign adc_enable_3 = adc_enable[3];
  assign adc_enable_4 = adc_enable[4];
  assign adc_enable_5 = adc_enable[5];
  assign adc_enable_6 = adc_enable[6];
  assign adc_enable_7 = adc_enable[7];
  assign adc_enable_8 = adc_enable[8];
  assign adc_enable_9 = adc_enable[9];
  assign adc_enable_10 = adc_enable[10];
  assign adc_enable_11 = adc_enable[11];
  assign adc_enable_12 = adc_enable[12];
  assign adc_enable_13 = adc_enable[13];
  assign adc_enable_14 = adc_enable[14];
  assign adc_enable_15 = adc_enable[15];

  // processor read interface

  integer j;

  always @(*) begin
    up_rdata_r = 'h00;
    up_rack_r = 'h00;
    up_wack_r = 'h00;
    for (j = 0; j <= 16; j = j + 1) begin
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
    genvar i;
    for (i = 0; i < 16; i = i + 1) begin
      up_adc_channel #(
        .CHANNEL_ID(i)
      ) i_up_adc_channel (
        .adc_clk (up_clk),
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
        .adc_read_data ({16'd0,rd_data_s}),
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
    for (k = 0;k < 16;k = k + 1) begin
      ad_datafmt #(
        .DATA_WIDTH (16),
        .BITS_PER_SAMPLE (16)
      ) i_datafmt (
        .clk (up_clk),
        .valid (1'b1),
        .data (adc_data_s[k*16+15:k*16]),
        .valid_out (dma_dvalid),
        .data_out (dma_data[k*16+15:k*16]),
        .dfmt_enable (adc_dfmt_enable_s[k]),
        .dfmt_type (adc_dfmt_type_s[k]),
        .dfmt_se (adc_dfmt_se_s[k]));
    end
  endgenerate

  axi_ad7616_pif #(
    .UP_ADDRESS_WIDTH(14)
  ) i_ad7616_parallel_interface (
    .cs_n (rx_cs_n),
    .db_o (rx_db_o),
    .db_i (rx_db_i),
    .db_t (rx_db_t),
    .rd_n (rx_rd_n),
    .wr_n (rx_wr_n),
    .adc_data_0 (adc_data_0_s),
    .adc_data_1 (adc_data_1_s),
    .adc_data_2 (adc_data_2_s),
    .adc_data_3 (adc_data_3_s),
    .adc_data_4 (adc_data_4_s),
    .adc_data_5 (adc_data_5_s),
    .adc_data_6 (adc_data_6_s),
    .adc_data_7 (adc_data_7_s),
    .adc_data_8 (adc_data_8_s),
    .adc_data_9 (adc_data_9_s),
    .adc_data_10 (adc_data_10_s),
    .adc_data_11 (adc_data_11_s),
    .adc_data_12 (adc_data_12_s),
    .adc_data_13 (adc_data_13_s),
    .adc_data_14 (adc_data_14_s),
    .adc_data_15 (adc_data_15_s),
    .adc_valid (adc_valid),
    .end_of_conv (rx_trigger),
    .burst_length(burst_length_s),
    .clk (up_clk),
    .rstn (up_rstn),
    .rd_req (rd_req_s),
    .wr_req (wr_req_s),
    .wr_data (wr_data_s[15:0]),
    .rd_data (rd_data_s),
    .rd_valid (rd_valid_s));

  assign adc_data_s = {adc_data_0_s,adc_data_1_s,adc_data_2_s,adc_data_3_s,adc_data_4_s,adc_data_5_s,adc_data_6_s,adc_data_7_s,adc_data_8_s,adc_data_9_s,
                       adc_data_10_s,adc_data_11_s,adc_data_12_s,adc_data_13_s,adc_data_14_s,adc_data_15_s};

  assign adc_data_15 = dma_data[0*16+15:0*16];
  assign adc_data_14 = dma_data[1*16+15:1*16];
  assign adc_data_13 = dma_data[2*16+15:2*16];
  assign adc_data_12 = dma_data[3*16+15:3*16];
  assign adc_data_11 = dma_data[4*16+15:4*16];
  assign adc_data_10 = dma_data[5*16+15:5*16];
  assign adc_data_9 = dma_data[6*16+15:6*16];
  assign adc_data_8 = dma_data[7*16+15:7*16];
  assign adc_data_7 = dma_data[8*16+15:8*16];
  assign adc_data_6 = dma_data[9*16+15:9*16];
  assign adc_data_5 = dma_data[10*16+15:10*16];
  assign adc_data_4 = dma_data[11*16+15:11*16];
  assign adc_data_3 = dma_data[12*16+15:12*16];
  assign adc_data_2 = dma_data[13*16+15:13*16];
  assign adc_data_1 = dma_data[14*16+15:14*16];
  assign adc_data_0 = dma_data[15*16+15:15*16];

  assign wr_req_s = adc_config_ctrl[0];
  assign rd_req_s = adc_config_ctrl[1];
  assign burst_length_s = adc_custom_control[4:0];

  up_adc_common #(
    .ID (ID),
    .CONFIG (RD_RAW_CAP)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (up_clk),
    .adc_rst (adc_reset_s),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (),
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
    .adc_config_wr (wr_data_s),
    .adc_config_ctrl (adc_config_ctrl),
    .adc_config_rd ({16'd0, rd_data_s}),
    .adc_ctrl_status (1'b1),
    .up_adc_gpio_in (),
    .up_adc_gpio_out (),
    .up_adc_ce (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[16]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[16]),
    .up_rack (up_rack_s[16]));

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
