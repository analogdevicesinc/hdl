// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad9122 #(

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   SERDES_OR_DDR_N = 1,
  parameter   MMCM_OR_BUFIO_N = 1,
  parameter   MMCM_CLKIN_PERIOD = 1.667,
  parameter   MMCM_VCO_DIV = 2,
  parameter   MMCM_VCO_MUL = 4,
  parameter   MMCM_CLK0_DIV = 2,
  parameter   MMCM_CLK1_DIV = 8,
  parameter   DAC_DATAPATH_DISABLE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 20,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 18,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group"
) (

  // dac interface

  input                   dac_clk_in_p,
  input                   dac_clk_in_n,
  output                  dac_clk_out_p,
  output                  dac_clk_out_n,
  output                  dac_frame_out_p,
  output                  dac_frame_out_n,
  output      [15:0]      dac_data_out_p,
  output      [15:0]      dac_data_out_n,

  // master/slave

  output                  dac_sync_out,
  input                   dac_sync_in,

  // dma interface

  output                  dac_div_clk,
  output                  dac_valid_0,
  output                  dac_enable_0,
  input       [63:0]      dac_ddata_0,
  output                  dac_valid_1,
  output                  dac_enable_1,
  input       [63:0]      dac_ddata_1,
  input                   dac_dunf,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [31:0]      s_axi_rdata,
  output      [ 1:0]      s_axi_rresp,
  input                   s_axi_rready,
  input       [ 2:0]      s_axi_awprot,
  input       [ 2:0]      s_axi_arprot
);

  // internal clocks and resets

  wire            dac_rst;
  wire            mmcm_rst;
  wire            up_clk;
  wire            up_rstn;

  // internal signals

  wire            dac_frame_i0_s;
  wire    [15:0]  dac_data_i0_s;
  wire            dac_frame_i1_s;
  wire    [15:0]  dac_data_i1_s;
  wire            dac_frame_i2_s;
  wire    [15:0]  dac_data_i2_s;
  wire            dac_frame_i3_s;
  wire    [15:0]  dac_data_i3_s;
  wire            dac_frame_q0_s;
  wire    [15:0]  dac_data_q0_s;
  wire            dac_frame_q1_s;
  wire    [15:0]  dac_data_q1_s;
  wire            dac_frame_q2_s;
  wire    [15:0]  dac_data_q2_s;
  wire            dac_frame_q3_s;
  wire    [15:0]  dac_data_q3_s;
  wire            dac_status_s;
  wire            up_drp_sel_s;
  wire            up_drp_wr_s;
  wire    [11:0]  up_drp_addr_s;
  wire    [31:0]  up_drp_wdata_s;
  wire    [31:0]  up_drp_rdata_s;
  wire            up_drp_ready_s;
  wire            up_drp_locked_s;
  wire            up_wreq_s;
  wire    [13:0]  up_waddr_s;
  wire    [31:0]  up_wdata_s;
  wire            up_wack_s;
  wire            up_rreq_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_rdata_s;
  wire            up_rack_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // device interface

  axi_ad9122_if #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .SERDES_OR_DDR_N (SERDES_OR_DDR_N),
    .MMCM_OR_BUFIO_N (MMCM_OR_BUFIO_N),
    .MMCM_CLKIN_PERIOD (MMCM_CLKIN_PERIOD),
    .MMCM_VCO_DIV (MMCM_VCO_DIV),
    .MMCM_VCO_MUL (MMCM_VCO_MUL),
    .MMCM_CLK0_DIV (MMCM_CLK0_DIV),
    .MMCM_CLK1_DIV (MMCM_CLK1_DIV)
  ) i_if (
    .dac_clk_in_p (dac_clk_in_p),
    .dac_clk_in_n (dac_clk_in_n),
    .dac_clk_out_p (dac_clk_out_p),
    .dac_clk_out_n (dac_clk_out_n),
    .dac_frame_out_p (dac_frame_out_p),
    .dac_frame_out_n (dac_frame_out_n),
    .dac_data_out_p (dac_data_out_p),
    .dac_data_out_n (dac_data_out_n),
    .dac_rst (dac_rst),
    .dac_clk (),
    .dac_div_clk (dac_div_clk),
    .dac_status (dac_status_s),
    .dac_frame_i0 (dac_frame_i0_s),
    .dac_data_i0 (dac_data_i0_s),
    .dac_frame_i1 (dac_frame_i1_s),
    .dac_data_i1 (dac_data_i1_s),
    .dac_frame_i2 (dac_frame_i2_s),
    .dac_data_i2 (dac_data_i2_s),
    .dac_frame_i3 (dac_frame_i3_s),
    .dac_data_i3 (dac_data_i3_s),
    .dac_frame_q0 (dac_frame_q0_s),
    .dac_data_q0 (dac_data_q0_s),
    .dac_frame_q1 (dac_frame_q1_s),
    .dac_data_q1 (dac_data_q1_s),
    .dac_frame_q2 (dac_frame_q2_s),
    .dac_data_q2 (dac_data_q2_s),
    .dac_frame_q3 (dac_frame_q3_s),
    .dac_data_q3 (dac_data_q3_s),
    .mmcm_rst (mmcm_rst),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_s),
    .up_drp_ready (up_drp_ready_s),
    .up_drp_locked (up_drp_locked_s));

  // core

  axi_ad9122_core #(
    .ID(ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .DATAPATH_DISABLE(DAC_DATAPATH_DISABLE)
  ) i_core (
    .dac_div_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_frame_i0 (dac_frame_i0_s),
    .dac_data_i0 (dac_data_i0_s),
    .dac_frame_i1 (dac_frame_i1_s),
    .dac_data_i1 (dac_data_i1_s),
    .dac_frame_i2 (dac_frame_i2_s),
    .dac_data_i2 (dac_data_i2_s),
    .dac_frame_i3 (dac_frame_i3_s),
    .dac_data_i3 (dac_data_i3_s),
    .dac_frame_q0 (dac_frame_q0_s),
    .dac_data_q0 (dac_data_q0_s),
    .dac_frame_q1 (dac_frame_q1_s),
    .dac_data_q1 (dac_data_q1_s),
    .dac_frame_q2 (dac_frame_q2_s),
    .dac_data_q2 (dac_data_q2_s),
    .dac_frame_q3 (dac_frame_q3_s),
    .dac_data_q3 (dac_data_q3_s),
    .dac_status (dac_status_s),
    .dac_sync_out (dac_sync_out),
    .dac_sync_in (dac_sync_in),
    .dac_valid_0 (dac_valid_0),
    .dac_enable_0 (dac_enable_0),
    .dac_ddata_0 (dac_ddata_0),
    .dac_valid_1 (dac_valid_1),
    .dac_enable_1 (dac_enable_1),
    .dac_ddata_1 (dac_ddata_1),
    .dac_dunf (dac_dunf),
    .mmcm_rst (mmcm_rst),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_s),
    .up_drp_ready (up_drp_ready_s),
    .up_drp_locked (up_drp_locked_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  // up bus interface

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
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

endmodule
