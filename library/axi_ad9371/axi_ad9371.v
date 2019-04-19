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

module axi_ad9371 #(

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 20,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 18,
  parameter   DAC_DATAPATH_DISABLE = 0,
  parameter   ADC_DATAPATH_DISABLE = 0) (

  // receive

  input                   adc_clk,
  input                   adc_rx_valid,
  input       [ 3:0]      adc_rx_sof,
  input       [ 63:0]     adc_rx_data,
  output                  adc_rx_ready,
  input                   adc_os_clk,
  input                   adc_rx_os_valid,
  input       [ 3:0]      adc_rx_os_sof,
  input       [ 63:0]     adc_rx_os_data,
  output                  adc_rx_os_ready,

  // transmit

  input                   dac_clk,
  output                  dac_tx_valid,
  output      [127:0]     dac_tx_data,
  input                   dac_tx_ready,

  // master/slave

  input                   dac_sync_in,
  output                  dac_sync_out,

  // dma interface

  output                  adc_enable_i0,
  output                  adc_valid_i0,
  output      [ 15:0]     adc_data_i0,
  output                  adc_enable_q0,
  output                  adc_valid_q0,
  output      [ 15:0]     adc_data_q0,
  output                  adc_enable_i1,
  output                  adc_valid_i1,
  output      [ 15:0]     adc_data_i1,
  output                  adc_enable_q1,
  output                  adc_valid_q1,
  output      [ 15:0]     adc_data_q1,
  input                   adc_dovf,

  output                  adc_os_enable_i0,
  output                  adc_os_valid_i0,
  output      [ 31:0]     adc_os_data_i0,
  output                  adc_os_enable_q0,
  output                  adc_os_valid_q0,
  output      [ 31:0]     adc_os_data_q0,
  input                   adc_os_dovf,

  output                  dac_enable_i0,
  output                  dac_valid_i0,
  input       [ 31:0]     dac_data_i0,
  output                  dac_enable_q0,
  output                  dac_valid_q0,
  input       [ 31:0]     dac_data_q0,
  output                  dac_enable_i1,
  output                  dac_valid_i1,
  input       [ 31:0]     dac_data_i1,
  output                  dac_enable_q1,
  output                  dac_valid_q1,
  input       [ 31:0]     dac_data_q1,
  input                   dac_dunf,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [ 15:0]     s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [ 31:0]     s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [ 15:0]     s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 31:0]     s_axi_rdata,
  output      [ 1:0]      s_axi_rresp,
  input                   s_axi_rready);


  // internal registers

  reg               up_wack = 'd0;
  reg               up_rack = 'd0;
  reg     [ 31:0]   up_rdata = 'd0;

  // internal signals

  wire              up_clk;
  wire              up_rstn;
  wire              adc_rst;
  wire              adc_os_rst;
  wire    [ 63:0]   adc_data_s;
  wire              adc_os_valid_s;
  wire    [ 63:0]   adc_os_data_s;
  wire              dac_rst;
  wire    [127:0]   dac_data_s;
  wire              up_wreq_s;
  wire    [ 13:0]   up_waddr_s;
  wire    [ 31:0]   up_wdata_s;
  wire    [  2:0]   up_wack_s;
  wire              up_rreq_s;
  wire    [ 13:0]   up_raddr_s;
  wire    [ 31:0]   up_rdata_s[0:2];
  wire    [  2:0]   up_rack_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // defaults

  assign dac_tx_valid = 1'b1;
  assign adc_rx_ready = 1'b1;
  assign adc_rx_os_ready = 1'b1;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= | up_wack_s;
      up_rack <= | up_rack_s;
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2];
    end
  end

  // device interface

  axi_ad9371_if i_if (
    .adc_clk (adc_clk),
    .adc_rx_sof (adc_rx_sof),
    .adc_rx_data (adc_rx_data),
    .adc_os_clk (adc_os_clk),
    .adc_rx_os_sof (adc_rx_os_sof),
    .adc_rx_os_data (adc_rx_os_data),
    .adc_data (adc_data_s),
    .adc_os_valid (adc_os_valid_s),
    .adc_os_data (adc_os_data_s),
    .dac_clk (dac_clk),
    .dac_tx_data (dac_tx_data),
    .dac_data (dac_data_s));

  // receive

  axi_ad9371_rx #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DATAPATH_DISABLE (ADC_DATAPATH_DISABLE))
  i_rx (
    .adc_rst (adc_rst),
    .adc_clk (adc_clk),
    .adc_data (adc_data_s),
    .adc_enable_i0 (adc_enable_i0),
    .adc_valid_i0 (adc_valid_i0),
    .adc_data_i0 (adc_data_i0),
    .adc_enable_q0 (adc_enable_q0),
    .adc_valid_q0 (adc_valid_q0),
    .adc_data_q0 (adc_data_q0),
    .adc_enable_i1 (adc_enable_i1),
    .adc_valid_i1 (adc_valid_i1),
    .adc_data_i1 (adc_data_i1),
    .adc_enable_q1 (adc_enable_q1),
    .adc_valid_q1 (adc_valid_q1),
    .adc_data_q1 (adc_data_q1),
    .adc_dovf (adc_dovf),
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

  // receive (o/s)

  axi_ad9371_rx_os #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DATAPATH_DISABLE (ADC_DATAPATH_DISABLE))
  i_rx_os (
    .adc_os_rst (adc_os_rst),
    .adc_os_clk (adc_os_clk),
    .adc_os_valid (adc_os_valid_s),
    .adc_os_data (adc_os_data_s),
    .adc_os_enable_i0 (adc_os_enable_i0),
    .adc_os_valid_i0 (adc_os_valid_i0),
    .adc_os_data_i0 (adc_os_data_i0),
    .adc_os_enable_q0 (adc_os_enable_q0),
    .adc_os_valid_q0 (adc_os_valid_q0),
    .adc_os_data_q0 (adc_os_data_q0),
    .adc_os_dovf (adc_os_dovf),
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

  // transmit

  axi_ad9371_tx #(
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
    .dac_rst (dac_rst),
    .dac_clk (dac_clk),
    .dac_data (dac_data_s),
    .dac_sync_in (dac_sync_in),
    .dac_sync_out (dac_sync_out),
    .dac_enable_i0 (dac_enable_i0),
    .dac_valid_i0 (dac_valid_i0),
    .dac_data_i0 (dac_data_i0),
    .dac_enable_q0 (dac_enable_q0),
    .dac_valid_q0 (dac_valid_q0),
    .dac_data_q0 (dac_data_q0),
    .dac_enable_i1 (dac_enable_i1),
    .dac_valid_i1 (dac_valid_i1),
    .dac_data_i1 (dac_data_i1),
    .dac_enable_q1 (dac_enable_q1),
    .dac_valid_q1 (dac_valid_q1),
    .dac_data_q1 (dac_data_q1),
    .dac_dunf(dac_dunf),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

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
