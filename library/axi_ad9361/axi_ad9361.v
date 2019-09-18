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

module axi_ad9361 #(

  // parameters

  parameter   ID = 0,
  parameter   MODE_1R1T = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   TDD_DISABLE = 0,
  parameter   PPS_RECEIVER_ENABLE = 0,
  parameter   CMOS_OR_LVDS_N = 0,
  parameter   ADC_INIT_DELAY = 0,
  parameter   ADC_DATAPATH_DISABLE = 0,
  parameter   ADC_USERPORTS_DISABLE = 0,
  parameter   ADC_DATAFORMAT_DISABLE = 0,
  parameter   ADC_DCFILTER_DISABLE = 0,
  parameter   ADC_IQCORRECTION_DISABLE = 0,
  parameter   DAC_INIT_DELAY = 0,
  parameter   DAC_CLK_EDGE_SEL = 0,
  parameter   DAC_IODELAY_ENABLE = 0,
  parameter   DAC_DATAPATH_DISABLE = 0,
  parameter   DAC_DDS_DISABLE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 14,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 13,
  parameter   DAC_USERPORTS_DISABLE = 0,
  parameter   DAC_IQCORRECTION_DISABLE = 0,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group",
  parameter   MIMO_ENABLE = 0,
  parameter   USE_SSI_CLK = 1,
  parameter   DELAY_REFCLK_FREQUENCY = 200) (

  // physical interface (receive-lvds)

  input           rx_clk_in_p,
  input           rx_clk_in_n,
  input           rx_frame_in_p,
  input           rx_frame_in_n,
  input   [ 5:0]  rx_data_in_p,
  input   [ 5:0]  rx_data_in_n,

  // physical interface (receive-cmos)

  input           rx_clk_in,
  input           rx_frame_in,
  input   [11:0]  rx_data_in,

  // physical interface (transmit-lvds)

  output          tx_clk_out_p,
  output          tx_clk_out_n,
  output          tx_frame_out_p,
  output          tx_frame_out_n,
  output  [ 5:0]  tx_data_out_p,
  output  [ 5:0]  tx_data_out_n,

  // physical interface (transmit-cmos)

  output          tx_clk_out,
  output          tx_frame_out,
  output  [11:0]  tx_data_out,

  // ensm control

  output          enable,
  output          txnrx,

  // transmit master/slave

  input           dac_sync_in,
  output          dac_sync_out,

  // tdd sync

  input           tdd_sync,
  output          tdd_sync_cntr,

  input           gps_pps,
  output          gps_pps_irq,

  // delay clock

  input           delay_clk,

  // master interface

  output          l_clk,
  input           clk,
  output          rst,

  // dma interface

  output          adc_enable_i0,
  output          adc_valid_i0,
  output  [15:0]  adc_data_i0,
  output          adc_enable_q0,
  output          adc_valid_q0,
  output  [15:0]  adc_data_q0,
  output          adc_enable_i1,
  output          adc_valid_i1,
  output  [15:0]  adc_data_i1,
  output          adc_enable_q1,
  output          adc_valid_q1,
  output  [15:0]  adc_data_q1,
  input           adc_dovf,
  output          adc_r1_mode,

  output          dac_enable_i0,
  output          dac_valid_i0,
  input   [15:0]  dac_data_i0,
  output          dac_enable_q0,
  output          dac_valid_q0,
  input   [15:0]  dac_data_q0,
  output          dac_enable_i1,
  output          dac_valid_i1,
  input   [15:0]  dac_data_i1,
  output          dac_enable_q1,
  output          dac_valid_q1,
  input   [15:0]  dac_data_q1,
  input           dac_dunf,
  output          dac_r1_mode,

  // axi interface

  input           s_axi_aclk,
  input           s_axi_aresetn,
  input           s_axi_awvalid,
  input   [15:0]  s_axi_awaddr,
  input   [ 2:0]  s_axi_awprot,
  output          s_axi_awready,
  input           s_axi_wvalid,
  input   [31:0]  s_axi_wdata,
  input   [ 3:0]  s_axi_wstrb,
  output          s_axi_wready,
  output          s_axi_bvalid,
  output  [ 1:0]  s_axi_bresp,
  input           s_axi_bready,
  input           s_axi_arvalid,
  input   [15:0]  s_axi_araddr,
  input   [ 2:0]  s_axi_arprot,
  output          s_axi_arready,
  output          s_axi_rvalid,
  output  [31:0]  s_axi_rdata,
  output  [ 1:0]  s_axi_rresp,
  input           s_axi_rready,

  // gpio

  input           up_enable,
  input           up_txnrx,
  input   [31:0]  up_dac_gpio_in,
  output  [31:0]  up_dac_gpio_out,
  input   [31:0]  up_adc_gpio_in,
  output  [31:0]  up_adc_gpio_out);

  // derived parameters

  localparam  ADC_USERPORTS_DISABLE_INT = (ADC_DATAPATH_DISABLE == 1) ? 1 : ADC_USERPORTS_DISABLE;
  localparam  ADC_DATAFORMAT_DISABLE_INT = (ADC_DATAPATH_DISABLE == 1) ? 1 : ADC_DATAFORMAT_DISABLE;
  localparam  ADC_DCFILTER_DISABLE_INT = (ADC_DATAPATH_DISABLE == 1) ? 1 : ADC_DCFILTER_DISABLE;
  localparam  ADC_IQCORRECTION_DISABLE_INT = (ADC_DATAPATH_DISABLE == 1) ? 1 : ADC_IQCORRECTION_DISABLE;
  localparam  DAC_DDS_DISABLE_INT = (DAC_DATAPATH_DISABLE == 1) ? 1 : DAC_DDS_DISABLE;
  localparam  DAC_USERPORTS_DISABLE_INT = (DAC_DATAPATH_DISABLE == 1) ? 1 : DAC_USERPORTS_DISABLE;
  localparam  DAC_DELAYCNTRL_DISABLE_INT = (DAC_IODELAY_ENABLE == 1) ? 0 : 1;
  localparam  DAC_IQCORRECTION_DISABLE_INT = (DAC_DATAPATH_DISABLE == 1) ? 1 : DAC_IQCORRECTION_DISABLE;

  // internal registers

  reg             adc_valid_i0_int = 'd0;
  reg             adc_valid_q0_int = 'd0;
  reg             adc_valid_i1_int = 'd0;
  reg             adc_valid_q1_int = 'd0;
  reg     [15:0]  adc_data_i0_int = 'd0;
  reg     [15:0]  adc_data_q0_int = 'd0;
  reg     [15:0]  adc_data_i1_int = 'd0;
  reg     [15:0]  adc_data_q1_int = 'd0;
  reg             dac_valid_i0_int = 'd0;
  reg             dac_valid_q0_int = 'd0;
  reg             dac_valid_i1_int = 'd0;
  reg             dac_valid_q1_int = 'd0;
  reg             up_wack = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;

  // internal clocks and resets

  wire            up_clk;
  wire            up_rstn;
  wire            mmcm_rst;
  wire            delay_rst;

  // internal signals

  wire            adc_ddr_edgesel_s;
  wire            adc_valid_s;
  wire            adc_valid_i0_s;
  wire            adc_valid_q0_s;
  wire            adc_valid_i1_s;
  wire            adc_valid_q1_s;
  wire    [15:0]  adc_data_i0_s;
  wire    [15:0]  adc_data_q0_s;
  wire    [15:0]  adc_data_i1_s;
  wire    [15:0]  adc_data_q1_s;
  wire    [47:0]  adc_data_s;
  wire            adc_status_s;
  wire            dac_clksel_s;
  wire            dac_valid_s;
  wire    [47:0]  dac_data_s;
  wire            dac_valid_i0_s;
  wire            dac_valid_q0_s;
  wire            dac_valid_i1_s;
  wire            dac_valid_q1_s;
  wire            dac_data_i0_s;
  wire            dac_data_q0_s;
  wire            dac_data_i1_s;
  wire            dac_data_q1_s;
  wire            dac_sync_enable;
  wire    [12:0]  up_adc_dld_s;
  wire    [64:0]  up_adc_dwdata_s;
  wire    [64:0]  up_adc_drdata_s;
  wire    [15:0]  up_dac_dld_s;
  wire    [79:0]  up_dac_dwdata_s;
  wire    [79:0]  up_dac_drdata_s;
  wire            delay_locked_s;
  wire            up_wreq_s;
  wire    [13:0]  up_waddr_s;
  wire    [31:0]  up_wdata_s;
  wire            up_wack_rx_s;
  wire            up_wack_tx_s;
  wire            up_rreq_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_rdata_rx_s;
  wire            up_rack_rx_s;
  wire    [31:0]  up_rdata_tx_s;
  wire            up_rack_tx_s;
  wire            up_wack_tdd_s;
  wire            up_rack_tdd_s;
  wire    [31:0]  up_rdata_tdd_s;
  wire            tdd_enable_s;
  wire            tdd_txnrx_s;
  wire            tdd_mode_s;
  wire            tdd_tx_valid_s;
  wire            tdd_rx_valid_s;
  wire            tdd_rx_vco_en_s;
  wire            tdd_tx_vco_en_s;
  wire            tdd_rx_rf_en_s;
  wire            tdd_tx_rf_en_s;
  wire    [ 7:0]  tdd_status_s;
  wire            up_drp_sel;
  wire            up_drp_wr;
  wire    [11:0]  up_drp_addr;
  wire    [31:0]  up_drp_wdata;
  wire    [31:0]  up_drp_rdata;
  wire            up_drp_ready;
  wire            up_drp_locked;

  wire    [31:0]  up_pps_rcounter_s;
  wire            up_pps_status_s;
  wire            up_irq_mask_s;
  wire            adc_up_pps_irq_mask_s;
  wire            dac_up_pps_irq_mask_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= up_wack_rx_s | up_wack_tx_s | up_wack_tdd_s;
      up_rack <= up_rack_rx_s | up_rack_tx_s | up_rack_tdd_s;
      up_rdata <= up_rdata_rx_s | up_rdata_tx_s | up_rdata_tdd_s;
    end
  end

  // device interface

  generate
  if (CMOS_OR_LVDS_N == 1) begin

  assign tx_clk_out_p = 1'd0;
  assign tx_clk_out_n = 1'd1;
  assign tx_frame_out_p = 1'd0;
  assign tx_frame_out_n = 1'd0;
  assign tx_data_out_p = 6'h00;
  assign tx_data_out_n = 6'h3f;

  axi_ad9361_cmos_if #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .DAC_IODELAY_ENABLE (DAC_IODELAY_ENABLE),
    .IO_DELAY_GROUP (IO_DELAY_GROUP),
    .CLK_DESKEW (MIMO_ENABLE),
    .USE_SSI_CLK (USE_SSI_CLK),
    .DELAY_REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY))
  i_dev_if (
    .rx_clk_in (rx_clk_in),
    .rx_frame_in (rx_frame_in),
    .rx_data_in (rx_data_in),
    .tx_clk_out (tx_clk_out),
    .tx_frame_out (tx_frame_out),
    .tx_data_out (tx_data_out),
    .enable (enable),
    .txnrx (txnrx),
    .rst (rst),
    .clk (clk),
    .l_clk (l_clk),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_status (adc_status_s),
    .adc_r1_mode (adc_r1_mode),
    .adc_ddr_edgesel (adc_ddr_edgesel_s),
    .dac_valid (dac_valid_s),
    .dac_data (dac_data_s),
    .dac_clksel (dac_clksel_s),
    .dac_r1_mode (dac_r1_mode),
    .tdd_enable (tdd_enable_s),
    .tdd_txnrx (tdd_txnrx_s),
    .tdd_mode (tdd_mode_s),
    .mmcm_rst (mmcm_rst),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_enable (up_enable),
    .up_txnrx (up_txnrx),
    .up_adc_dld (up_adc_dld_s),
    .up_adc_dwdata (up_adc_dwdata_s),
    .up_adc_drdata (up_adc_drdata_s),
    .up_dac_dld (up_dac_dld_s),
    .up_dac_dwdata (up_dac_dwdata_s),
    .up_dac_drdata (up_dac_drdata_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_s),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked(up_drp_locked));
  end
  endgenerate

  generate
  if (CMOS_OR_LVDS_N == 0) begin

  assign tx_clk_out = 1'd0;
  assign tx_frame_out = 1'd0;
  assign tx_data_out = 12'd0;
  assign up_adc_drdata_s[64:35] = 30'd0;
  assign up_dac_drdata_s[79:50] = 30'd0;

  axi_ad9361_lvds_if #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .DAC_IODELAY_ENABLE (DAC_IODELAY_ENABLE),
    .IO_DELAY_GROUP (IO_DELAY_GROUP),
    .CLK_DESKEW (MIMO_ENABLE),
    .USE_SSI_CLK (USE_SSI_CLK),
    .DELAY_REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY))
  i_dev_if (
    .rx_clk_in_p (rx_clk_in_p),
    .rx_clk_in_n (rx_clk_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_data_out_n (tx_data_out_n),
    .enable (enable),
    .txnrx (txnrx),
    .rst (rst),
    .clk (clk),
    .l_clk (l_clk),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_status (adc_status_s),
    .adc_r1_mode (adc_r1_mode),
    .adc_ddr_edgesel (adc_ddr_edgesel_s),
    .dac_valid (dac_valid_s),
    .dac_data (dac_data_s),
    .dac_clksel (dac_clksel_s),
    .dac_r1_mode (dac_r1_mode),
    .tdd_enable (tdd_enable_s),
    .tdd_txnrx (tdd_txnrx_s),
    .tdd_mode (tdd_mode_s),
    .mmcm_rst (mmcm_rst),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_enable (up_enable),
    .up_txnrx (up_txnrx),
    .up_adc_dld (up_adc_dld_s[6:0]),
    .up_adc_dwdata (up_adc_dwdata_s[34:0]),
    .up_adc_drdata (up_adc_drdata_s[34:0]),
    .up_dac_dld (up_dac_dld_s[9:0]),
    .up_dac_dwdata (up_dac_dwdata_s[49:0]),
    .up_dac_drdata (up_dac_drdata_s[49:0]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_s),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked(up_drp_locked));
  end
  endgenerate

  assign adc_valid_i0 = adc_valid_i0_int;
  assign adc_valid_q0 = adc_valid_q0_int;
  assign adc_valid_i1 = adc_valid_i1_int;
  assign adc_valid_q1 = adc_valid_q1_int;

  always @(posedge clk) begin
    adc_valid_i0_int <= tdd_rx_valid_s & adc_valid_i0_s;
    adc_valid_q0_int <= tdd_rx_valid_s & adc_valid_q0_s;
    adc_valid_i1_int <= tdd_rx_valid_s & adc_valid_i1_s;
    adc_valid_q1_int <= tdd_rx_valid_s & adc_valid_q1_s;
  end

  assign adc_data_i0 = adc_data_i0_int;
  assign adc_data_q0 = adc_data_q0_int;
  assign adc_data_i1 = adc_data_i1_int;
  assign adc_data_q1 = adc_data_q1_int;

  always @(posedge clk) begin
    adc_data_i0_int <= adc_data_i0_s;
    adc_data_q0_int <= adc_data_q0_s;
    adc_data_i1_int <= adc_data_i1_s;
    adc_data_q1_int <= adc_data_q1_s;
  end

  assign dac_valid_i0 = dac_valid_i0_int;
  assign dac_valid_q0 = dac_valid_q0_int;
  assign dac_valid_i1 = dac_valid_i1_int;
  assign dac_valid_q1 = dac_valid_q1_int;

  always @(posedge clk) begin
    dac_valid_i0_int <= tdd_tx_valid_s & dac_valid_i0_s;
    dac_valid_q0_int <= tdd_tx_valid_s & dac_valid_q0_s;
    dac_valid_i1_int <= tdd_tx_valid_s & dac_valid_i1_s;
    dac_valid_q1_int <= tdd_tx_valid_s & dac_valid_q1_s;
  end

  // tdd

  generate
  if (TDD_DISABLE == 1) begin
  assign tdd_enable_s = 1'b0;
  assign tdd_txnrx_s = 1'b0;
  assign tdd_txnrx_s = 1'b0;
  assign tdd_mode_s = 1'b0;
  assign tdd_rx_vco_en_s = 1'b0;
  assign tdd_tx_vco_en_s = 1'b0;
  assign tdd_rx_rf_en_s = 1'b0;
  assign tdd_tx_rf_en_s = 1'b0;
  assign tdd_status_s = 8'd0;
  assign tdd_sync_cntr  = 1'b0;
  assign tdd_tx_valid_s = 1'b1;
  assign tdd_rx_valid_s = 1'b1;
  assign up_wack_tdd_s  = 1'b0;
  assign up_rack_tdd_s  = 1'b0;
  assign up_rdata_tdd_s = 32'b0;
  assign dac_sync_enable = adc_valid_s;
  end
  endgenerate

  generate
  if (TDD_DISABLE == 0) begin
  axi_ad9361_tdd_if #(.LEVEL_OR_PULSE_N(1)) i_tdd_if (
    .clk (clk),
    .rst (rst),
    .tdd_rx_vco_en (tdd_rx_vco_en_s),
    .tdd_tx_vco_en (tdd_tx_vco_en_s),
    .tdd_rx_rf_en (tdd_rx_rf_en_s),
    .tdd_tx_rf_en (tdd_tx_rf_en_s),
    .ad9361_txnrx (tdd_txnrx_s),
    .ad9361_enable (tdd_enable_s),
    .ad9361_tdd_status (tdd_status_s));

  axi_ad9361_tdd i_tdd (
    .clk (clk),
    .rst (rst),
    .tdd_rx_vco_en (tdd_rx_vco_en_s),
    .tdd_tx_vco_en (tdd_tx_vco_en_s),
    .tdd_rx_rf_en (tdd_rx_rf_en_s),
    .tdd_tx_rf_en (tdd_tx_rf_en_s),
    .tdd_enabled (tdd_mode_s),
    .tdd_status (tdd_status_s),
    .tdd_sync (tdd_sync),
    .tdd_sync_cntr (tdd_sync_cntr),
    .tdd_tx_valid (tdd_tx_valid_s),
    .tdd_rx_valid (tdd_rx_valid_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_tdd_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_tdd_s),
    .up_rack (up_rack_tdd_s));

  assign dac_sync_enable = adc_valid_s || tdd_mode_s;

  end
  endgenerate

  generate if (PPS_RECEIVER_ENABLE == 1) begin
    // GPS's PPS receiver
    ad_pps_receiver i_pps_receiver (
      .clk (clk),
      .rst (rst),
      .gps_pps (gps_pps),
      .up_clk (up_clk),
      .up_rstn (up_rstn),
      .up_pps_rcounter (up_pps_rcounter_s),
      .up_pps_status (up_pps_status_s),
      .up_irq_mask (up_irq_mask_s),
      .up_irq (gps_pps_irq));
    assign up_irq_mask_s = adc_up_pps_irq_mask_s | dac_up_pps_irq_mask_s;
  end
  endgenerate

  generate if (PPS_RECEIVER_ENABLE == 0) begin
    assign up_pps_rcounter_s = 32'b0;
    assign up_pps_status_s = 1'b1;
    assign gps_pps_irq = 1'b0;
  end
  endgenerate

  // receive

  axi_ad9361_rx #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .MODE_1R1T (MODE_1R1T),
    .CMOS_OR_LVDS_N (CMOS_OR_LVDS_N),
    .PPS_RECEIVER_ENABLE (PPS_RECEIVER_ENABLE),
    .INIT_DELAY (ADC_INIT_DELAY),
    .USERPORTS_DISABLE (ADC_USERPORTS_DISABLE_INT),
    .DATAFORMAT_DISABLE (ADC_DATAFORMAT_DISABLE_INT),
    .DCFILTER_DISABLE (ADC_DCFILTER_DISABLE_INT),
    .IQCORRECTION_DISABLE (ADC_IQCORRECTION_DISABLE_INT))
  i_rx (
    .mmcm_rst (mmcm_rst),
    .adc_rst (rst),
    .adc_clk (clk),

    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_status (adc_status_s),
    .adc_r1_mode (adc_r1_mode),
    .adc_ddr_edgesel (adc_ddr_edgesel_s),
    .dac_data (dac_data_s),
    .up_dld (up_adc_dld_s),
    .up_dwdata (up_adc_dwdata_s),
    .up_drdata (up_adc_drdata_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_s),
    .adc_enable_i0 (adc_enable_i0),
    .adc_valid_i0 (adc_valid_i0_s),
    .adc_data_i0 (adc_data_i0_s),
    .adc_enable_q0 (adc_enable_q0),
    .adc_valid_q0 (adc_valid_q0_s),
    .adc_data_q0 (adc_data_q0_s),
    .adc_enable_i1 (adc_enable_i1),
    .adc_valid_i1 (adc_valid_i1_s),
    .adc_data_i1 (adc_data_i1_s),
    .adc_enable_q1 (adc_enable_q1),
    .adc_valid_q1 (adc_valid_q1_s),
    .adc_data_q1 (adc_data_q1_s),
    .adc_dovf (adc_dovf),
    .up_adc_gpio_in (up_adc_gpio_in),
    .up_adc_gpio_out (up_adc_gpio_out),
    .up_pps_rcounter (up_pps_rcounter_s),
    .up_pps_status (up_pps_status_s),
    .up_pps_irq_mask (adc_up_pps_irq_mask_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_rx_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_rx_s),
    .up_rack (up_rack_rx_s),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked(up_drp_locked));

  // transmit

  axi_ad9361_tx #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .MODE_1R1T (MODE_1R1T),
    .CLK_EDGE_SEL (DAC_CLK_EDGE_SEL),
    .CMOS_OR_LVDS_N (CMOS_OR_LVDS_N),
    .PPS_RECEIVER_ENABLE (PPS_RECEIVER_ENABLE),
    .INIT_DELAY (DAC_INIT_DELAY),
    .DAC_DDS_DISABLE (DAC_DDS_DISABLE_INT),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .USERPORTS_DISABLE (DAC_USERPORTS_DISABLE_INT),
    .DELAYCNTRL_DISABLE (DAC_DELAYCNTRL_DISABLE_INT),
    .IQCORRECTION_DISABLE (DAC_IQCORRECTION_DISABLE_INT))
  i_tx (
    .dac_clk (clk),
    .dac_valid (dac_valid_s),
    .dac_data (dac_data_s),
    .dac_clksel (dac_clksel_s),
    .dac_r1_mode (dac_r1_mode),
    .adc_data (adc_data_s),
    .up_dld (up_dac_dld_s),
    .up_dwdata (up_dac_dwdata_s),
    .up_drdata (up_dac_drdata_s),
    .delay_clk (delay_clk),
    .delay_rst (),
    .delay_locked (delay_locked_s),
    .dac_sync_enable (dac_sync_enable),
    .dac_sync_in (dac_sync_in),
    .dac_sync_out (dac_sync_out),
    .dac_enable_i0 (dac_enable_i0),
    .dac_valid_i0 (dac_valid_i0_s),
    .dac_data_i0 (dac_data_i0),
    .dac_enable_q0 (dac_enable_q0),
    .dac_valid_q0 (dac_valid_q0_s),
    .dac_data_q0 (dac_data_q0),
    .dac_enable_i1 (dac_enable_i1),
    .dac_valid_i1 (dac_valid_i1_s),
    .dac_data_i1 (dac_data_i1),
    .dac_enable_q1 (dac_enable_q1),
    .dac_valid_q1 (dac_valid_q1_s),
    .dac_data_q1 (dac_data_q1),
    .dac_dunf(dac_dunf),
    .up_pps_rcounter (up_pps_rcounter_s),
    .up_pps_status (up_pps_status_s),
    .up_pps_irq_mask (dac_up_pps_irq_mask_s),
    .up_dac_gpio_in (up_dac_gpio_in),
    .up_dac_gpio_out (up_dac_gpio_out),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_tx_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_tx_s),
    .up_rack (up_rack_tx_s));

  // axi interface

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

// ***************************************************************************
// ***************************************************************************
