// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module axi_ad974x_core #(
  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DDS_DISABLE = 0,
  parameter   DDS_TYPE = 1,
  parameter   DDS_CORDIC_DW = 14,
  parameter   DDS_CORDIC_PHASE_DW = 14
) (

  // dac interface

  input         dac_clk,
  output        dac_rst,
  input  [15:0] dma_data,
  input         dma_valid,
  output        dma_ready,
  output [13:0] dac_data,

  // processor interface

  input             up_rstn,
  input             up_clk,
  input             up_wreq,
  input      [13:0] up_waddr,
  input      [31:0] up_wdata,
  output reg        up_wack,
  input             up_rreq,
  input      [13:0] up_raddr,
  output reg [31:0] up_rdata,
  output reg        up_rack
);

  wire [31:0] up_rdata_0_s;
  wire        up_rack_0_s;
  wire        up_wack_0_s;
  wire [31:0] up_rdata_1_s;
  wire        up_rack_1_s;
  wire        up_wack_1_s;
  wire [31:0] up_rdata_s;
  wire        up_rack_s;
  wire        up_wack_s;

  wire [15:0] dac_data_channel_0;
  wire        dac_rst_s;
  wire        dac_data_sync;
  wire        dac_dfmt_type;

  // defaults

  assign dac_rst       = dac_rst_s;
  assign dac_data      = dac_data_channel_0;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if(up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack  <= 'd0;
      up_wack  <= 'd0;
    end else begin
      up_rdata <= up_rdata_s | up_rdata_0_s | up_rdata_1_s;
      up_rack  <= up_rack_s  | up_rack_0_s  | up_rack_1_s;
      up_wack  <= up_wack_s  | up_wack_0_s  | up_wack_1_s;
    end
  end

  // dac channel 0

  axi_ad974x_channel #(
    .CHANNEL_ID(0),
    .DDS_DISABLE(DDS_DISABLE),
    .DDS_TYPE(DDS_TYPE),
    .DDS_CORDIC_DW(DDS_CORDIC_DW),
    .DDS_CORDIC_PHASE_DW(DDS_CORDIC_PHASE_DW)
  ) axi_ad974x_channel_0 (
    .dac_clk(dac_clk),
    .dac_rst(dac_rst_s),
    .dac_data(dac_data_channel_0),
    .dma_data(dma_data[15:0]),
    .dma_ready(dma_ready),
    .dma_valid(dma_valid),
    .dac_data_sync(dac_data_sync),
    .dac_dfmt_type(dac_dfmt_type),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack_0_s),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata_0_s),
    .up_rack(up_rack_0_s));

  // dac common processor interface

  up_dac_common #(
    .ID(ID),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .COMMON_ID(6'h00)
  ) axi_ad974x_common_core (
    .mmcm_rst(),
    .dac_clk(dac_clk),
    .dac_rst(dac_rst_s),
    .dac_num_lanes(),
    .dac_sdr_ddr_n(),
    .dac_symb_op(),
    .dac_symb_8_16b(),
    .dac_sync(dac_data_sync),
    .dac_ext_sync_arm(),
    .dac_ext_sync_disarm(),
    .dac_ext_sync_manual_req(),
    .dac_frame(),
    .dac_clksel(),
    .dac_custom_wr(),
    .dac_custom_rd(32'b0),
    .dac_custom_control(),
    .dac_status_if_busy(if_busy),
    .dac_par_type(),
    .dac_par_enb(),
    .dac_r1_mode(),
    .dac_datafmt(dac_dfmt_type),
    .dac_datarate(),
    .dac_status(),
    .dac_sync_in_status(),
    .dac_status_unf(),
    .dac_clk_ratio(32'd1),
    .up_dac_ce(),
    .up_pps_rcounter(32'd0),
    .up_pps_status(1'd0),
    .up_pps_irq_mask(),
    .up_dac_r1_mode(),
    .up_drp_sel(),
    .up_drp_wr(),
    .up_drp_addr(),
    .up_drp_wdata()  ,
    .up_drp_rdata(32'd0),
    .up_drp_ready(1'd1),
    .up_drp_locked(1'd1),
    .up_usr_chanmax(),
    .dac_usr_chanmax(8'd1),
    .up_dac_gpio_in(32'd0),
    .up_dac_gpio_out(),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack_s),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata_s),
    .up_rack (up_rack_s));
endmodule
