// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad9783_core #(

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 16,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 16,
  parameter   DATAPATH_DISABLE = 0
) (

  // dac interface

  input                   dac_div_clk,
  output                  dac_rst,
  output      [ 15:0]     dac_data_a0,
  output      [ 15:0]     dac_data_a1,
  output      [ 15:0]     dac_data_a2,
  output      [ 15:0]     dac_data_a3,
  output      [ 15:0]     dac_data_b0,
  output      [ 15:0]     dac_data_b1,
  output      [ 15:0]     dac_data_b2,
  output      [ 15:0]     dac_data_b3,
  input                   dac_status,

  // dma interface

  output                  dac_valid,
  output                  dac_enable_0,
  output                  dac_enable_1,
  input       [ 63:0]     dac_ddata_0,
  input       [ 63:0]     dac_ddata_1,
  input                   dac_dunf,

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [ 13:0]     up_waddr,
  input       [ 31:0]     up_wdata,
  output reg              up_wack,
  input                   up_rreq,
  input       [ 13:0]     up_raddr,
  output reg  [ 31:0]     up_rdata,
  output reg              up_rack
);

  // internal registers

  // internal signals

  wire              dac_sync_s;
  wire              dac_datafmt_s;
  wire    [ 31:0]   up_rdata_0_s;
  wire              up_rack_0_s;
  wire              up_wack_0_s;
  wire    [ 31:0]   up_rdata_1_s;
  wire              up_rack_1_s;
  wire              up_wack_1_s;
  wire    [ 31:0]   up_rdata_s;
  wire              up_rack_s;
  wire              up_wack_s;
  wire              dac_enable_0_reg;
  wire              dac_enable_1_reg;

  // defaults

  assign dac_valid = 1'b1;
  assign dac_enable_0 = dac_enable_0_reg;
  assign dac_enable_1 = dac_enable_1_reg;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack  <= 'd0;
      up_wack  <= 'd0;
    end else begin
      up_rdata <= up_rdata_s | up_rdata_0_s | up_rdata_1_s;
      up_rack  <= up_rack_s | up_rack_0_s | up_rack_1_s;
      up_wack  <= up_wack_s | up_wack_0_s | up_wack_1_s;
    end
  end

  // dac channel

  axi_ad9783_channel #(
    .CHANNEL_ID(0),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .DATAPATH_DISABLE(DATAPATH_DISABLE)
  ) i_channel_0 (
    .dac_div_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_enable (dac_enable_0_reg),
    .dac_data0 (dac_data_a0),
    .dac_data1 (dac_data_a1),
    .dac_data2 (dac_data_a2),
    .dac_data3 (dac_data_a3),
    .dma_data (dac_ddata_0),
    .dac_data_sync (dac_sync_s),
    .dac_dds_format (dac_datafmt_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_0_s),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_0_s),
    .up_rack (up_rack_0_s));

  axi_ad9783_channel #(
    .CHANNEL_ID(1),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .DATAPATH_DISABLE(DATAPATH_DISABLE)
  ) i_channel_1 (
    .dac_div_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_enable (dac_enable_1_reg),
    .dac_data0 (dac_data_b0),
    .dac_data1 (dac_data_b1),
    .dac_data2 (dac_data_b2),
    .dac_data3 (dac_data_b3),
    .dma_data (dac_ddata_1),
    .dac_data_sync (dac_sync_s),
    .dac_dds_format (dac_datafmt_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_1_s),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_1_s),
    .up_rack (up_rack_1_s));

  // dac common processor interface

  up_dac_common #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE)
  ) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_sync (dac_sync_s),
    .dac_frame (),
    .dac_clksel (),
    .dac_custom_wr(),
    .dac_custom_rd(32'b0),
    .dac_custom_control(),
    .dac_status_if_busy(1'b0),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .dac_datafmt (dac_datafmt_s),
    .dac_datarate (),
    .dac_status (dac_status),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (32'd16),
    .up_dac_ce (),
    .up_pps_rcounter (31'd0),
    .up_pps_status (1'd0),
    .up_pps_irq_mask (),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (32'd0),
    .up_drp_ready (1'd1),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd1),
    .up_dac_gpio_in (32'd0),
    .up_dac_gpio_out (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

endmodule
