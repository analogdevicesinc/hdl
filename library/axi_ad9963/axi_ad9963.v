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

module axi_ad9963 #(

  // parameters

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   ADC_IODELAY_ENABLE = 0,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group",
  parameter   IODELAY_ENABLE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 14,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 13,
  parameter   DAC_DATAPATH_DISABLE = 0,
  parameter   ADC_USERPORTS_DISABLE = 0,
  parameter   ADC_DATAFORMAT_DISABLE = 0,
  parameter   ADC_DCFILTER_DISABLE = 0,
  parameter   ADC_IQCORRECTION_DISABLE = 0,
  parameter   ADC_SCALECORRECTION_ONLY = 1,
  parameter   DELAY_REFCLK_FREQUENCY = 200) (

  // physical interface (receive)

  input           trx_clk,
  input           trx_iq,
  input   [11:0]  trx_data,

  // physical interface (transmit)

  input           tx_clk,
  output          tx_iq,
  output  [11:0]  tx_data,

  // transmit master/slave

  input           dac_sync_in,
  output          dac_sync_out,

  // delay clock

  input           delay_clk,

  // master interface

  output          adc_clk,
  output          dac_clk,
  output          adc_rst,
  output          dac_rst,

  // dma interface

  output          adc_enable_i,
  output          adc_valid_i,
  output  [15:0]  adc_data_i,
  output          adc_enable_q,
  output          adc_valid_q,
  output  [15:0]  adc_data_q,
  input           adc_dovf,

  output          dac_enable_i,
  output          dac_valid_i,
  input   [15:0]  dac_data_i,
  output          dac_enable_q,
  output          dac_valid_q,
  input   [15:0]  dac_data_q,
  input           dac_dunf,

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
  input           s_axi_rready);

  // internal registers

  reg             up_wack = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;

  // internal clocks and resets

  wire            up_clk;
  wire            up_rstn;
  wire            delay_rst;

  // internal signals

  wire            adc_valid_s;
  wire    [23:0]  adc_data_s;
  wire            adc_status_s;
  wire            dac_valid_s;
  wire    [23:0]  dac_data_s;
  wire    [12:0]  up_adc_dld_s;
  wire    [64:0]  up_adc_dwdata_s;
  wire    [64:0]  up_adc_drdata_s;
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
  wire            up_adc_ce;
  wire            up_dac_ce;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // processor read interface

  always @(*) begin
    up_wack = up_wack_rx_s | up_wack_tx_s;
    up_rack = up_rack_rx_s | up_rack_tx_s;
    up_rdata = up_rdata_rx_s | up_rdata_tx_s;
  end

  // device interface

  axi_ad9963_if #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .ADC_IODELAY_ENABLE (ADC_IODELAY_ENABLE),
    .IO_DELAY_GROUP (IO_DELAY_GROUP),
    .DELAY_REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY))
  i_dev_if (
    .trx_clk (trx_clk),
    .trx_iq (trx_iq),
    .trx_data (trx_data),
    .tx_clk (tx_clk),
    .tx_iq (tx_iq),
    .tx_data (tx_data),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_status (adc_status_s),
    .up_adc_ce(up_adc_ce),
    .dac_valid (dac_valid_s),
    .dac_data (dac_data_s),
    .up_dac_ce(up_dac_ce),
    .up_clk (up_clk),
    .up_adc_dld (up_adc_dld_s),
    .up_adc_dwdata (up_adc_dwdata_s),
    .up_adc_drdata (up_adc_drdata_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_s));

  // receive

  axi_ad9963_rx #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .USERPORTS_DISABLE (ADC_USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (ADC_DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (ADC_DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE (ADC_IQCORRECTION_DISABLE),
    .SCALECORRECTION_ONLY (ADC_SCALECORRECTION_ONLY),
    .IODELAY_ENABLE (ADC_IODELAY_ENABLE)
  ) i_rx (
    .adc_rst (adc_rst),
    .adc_clk (adc_clk),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_status (adc_status_s),
    .up_adc_ce(up_adc_ce),
    .up_dld (up_adc_dld_s),
    .up_dwdata (up_adc_dwdata_s),
    .up_drdata (up_adc_drdata_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_s),
    .adc_enable_i (adc_enable_i),
    .adc_valid_i (adc_valid_i),
    .adc_data_i (adc_data_i),
    .adc_enable_q (adc_enable_q),
    .adc_valid_q (adc_valid_q),
    .adc_data_q (adc_data_q),
    .adc_dovf (adc_dovf),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_rx_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_rx_s),
    .up_rack (up_rack_rx_s));

  // transmit

  axi_ad9963_tx #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .DATAPATH_DISABLE (DAC_DATAPATH_DISABLE))
  i_tx (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid_s),
    .dac_data (dac_data_s),
    .adc_data (adc_data_s),
    .dac_sync_in (dac_sync_in),
    .dac_sync_out (dac_sync_out),
    .dac_enable_i (dac_enable_i),
    .dac_valid_i (dac_valid_i),
    .dac_data_i (dac_data_i),
    .dac_enable_q (dac_enable_q),
    .dac_valid_q (dac_valid_q),
    .dac_data_q (dac_data_q),
    .dac_dunf(dac_dunf),
    .up_dac_ce(up_dac_ce),
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
