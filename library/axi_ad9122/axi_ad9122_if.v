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
// This is the dac physical interface (drives samples from the low speed clock to the
// dac clock domain.

`timescale 1ns/100ps

module axi_ad9122_if #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   SERDES_OR_DDR_N = 1,
  parameter   MMCM_OR_BUFIO_N = 1,
  parameter   MMCM_CLKIN_PERIOD = 1.667,
  parameter   MMCM_VCO_DIV = 6,
  parameter   MMCM_VCO_MUL = 12,
  parameter   MMCM_CLK0_DIV = 2,
  parameter   MMCM_CLK1_DIV = 8,
  parameter   IO_DELAY_GROUP = "dac_if_delay_group"
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

  // internal resets and clocks

  input                   dac_rst,
  output                  dac_clk,
  output                  dac_div_clk,
  output  reg             dac_status,

  // data interface

  input                   dac_frame_i0,
  input       [15:0]      dac_data_i0,
  input                   dac_frame_i1,
  input       [15:0]      dac_data_i1,
  input                   dac_frame_i2,
  input       [15:0]      dac_data_i2,
  input                   dac_frame_i3,
  input       [15:0]      dac_data_i3,

  input                   dac_frame_q0,
  input       [15:0]      dac_data_q0,
  input                   dac_frame_q1,
  input       [15:0]      dac_data_q1,
  input                   dac_frame_q2,
  input       [15:0]      dac_data_q2,
  input                   dac_frame_q3,
  input       [15:0]      dac_data_q3,

  // mmcm reset

  input                   mmcm_rst,

  // drp interface

  input                   up_clk,
  input                   up_rstn,
  input                   up_drp_sel,
  input                   up_drp_wr,
  input       [11:0]      up_drp_addr,
  input       [31:0]      up_drp_wdata,
  output      [31:0]      up_drp_rdata,
  output                  up_drp_ready,
  output                  up_drp_locked
);

  // internal registers

  reg             dac_status_m1 = 'd0;

  // internal signals

  wire            dac_out_clk;

  // dac status

  always @(posedge dac_div_clk) begin
    if (dac_rst == 1'b1) begin
      dac_status_m1 <= 1'd0;
      dac_status <= 1'd0;
    end else begin
      dac_status_m1 <= up_drp_locked;
      dac_status <= dac_status_m1;
    end
  end

  // dac data output serdes(s) & buffers

  ad_serdes_out #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .DDR_OR_SDR_N (SERDES_OR_DDR_N),
    .DATA_WIDTH (16)
  ) i_serdes_out_data (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_oe (1'b1),
    .data_s0 (dac_data_i0),
    .data_s1 (dac_data_q0),
    .data_s2 (dac_data_i1),
    .data_s3 (dac_data_q1),
    .data_s4 (dac_data_i2),
    .data_s5 (dac_data_q2),
    .data_s6 (dac_data_i3),
    .data_s7 (dac_data_q3),
    .data_out_se (),
    .data_out_p (dac_data_out_p),
    .data_out_n (dac_data_out_n));

  // dac frame output serdes & buffer

  ad_serdes_out #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .DDR_OR_SDR_N (SERDES_OR_DDR_N),
    .DATA_WIDTH (1)
  ) i_serdes_out_frame (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_oe (1'b1),
    .data_s0 (dac_frame_i0),
    .data_s1 (dac_frame_q0),
    .data_s2 (dac_frame_i1),
    .data_s3 (dac_frame_q1),
    .data_s4 (dac_frame_i2),
    .data_s5 (dac_frame_q2),
    .data_s6 (dac_frame_i3),
    .data_s7 (dac_frame_q3),
    .data_out_se (),
    .data_out_p (dac_frame_out_p),
    .data_out_n (dac_frame_out_n));

  // dac clock output serdes & buffer

  ad_serdes_out #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .DDR_OR_SDR_N (SERDES_OR_DDR_N),
    .DATA_WIDTH (1)
  ) i_serdes_out_clk (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_oe (1'b1),
    .data_s0 (1'b1),
    .data_s1 (1'b0),
    .data_s2 (1'b1),
    .data_s3 (1'b0),
    .data_s4 (1'b1),
    .data_s5 (1'b0),
    .data_s6 (1'b1),
    .data_s7 (1'b0),
    .data_out_se (),
    .data_out_p (dac_clk_out_p),
    .data_out_n (dac_clk_out_n));

  // dac clock input buffers

  ad_serdes_clk #(
    .DDR_OR_SDR_N (SERDES_OR_DDR_N),
    .MMCM_OR_BUFR_N (MMCM_OR_BUFIO_N),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .MMCM_CLKIN_PERIOD (MMCM_CLKIN_PERIOD),
    .MMCM_VCO_DIV (MMCM_VCO_DIV),
    .MMCM_VCO_MUL (MMCM_VCO_MUL),
    .MMCM_CLK0_DIV (MMCM_CLK0_DIV),
    .MMCM_CLK1_DIV (MMCM_CLK1_DIV)
  ) i_serdes_clk (
    .rst (mmcm_rst),
    .clk_in_p (dac_clk_in_p),
    .clk_in_n (dac_clk_in_n),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .out_clk (dac_out_clk),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked));

endmodule
