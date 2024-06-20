// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

module axi_ad9434_if #(

  parameter FPGA_TECHNOLOGY = 0,
  parameter IODELAY_ENABLE = 1,
  parameter IO_DELAY_GROUP = "dev_if_delay_group"
) (

  // device interface
  input                   adc_clk_in_p,
  input                   adc_clk_in_n,
  input       [11:0]      adc_data_in_p,
  input       [11:0]      adc_data_in_n,
  input                   adc_or_in_p,
  input                   adc_or_in_n,

  // interface outputs
  output      [47:0]      adc_data,
  output                  adc_or,

  // internl reset and clocks
  output                  adc_clk,
  input                   adc_rst,
  output  reg             adc_status,

  // delay interface (for IDELAY macros)
  input                   up_clk,
  input       [12:0]      up_adc_dld,
  input       [64:0]      up_adc_dwdata,
  output      [64:0]      up_adc_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked,

  // mmcm reset
  input                   mmcm_rst,

  // drp interface for MMCM_OR_BUFR_N
  input                   up_rstn,
  input                   up_drp_sel,
  input                   up_drp_wr,
  input       [11:0]      up_drp_addr,
  input       [31:0]      up_drp_wdata,
  output      [31:0]      up_drp_rdata,
  output                  up_drp_ready,
  output                  up_drp_locked
);

  localparam SDR = 0;

  // internal registers

  reg             adc_status_m1 = 'd0;

  // internal signals

  wire    [3:0]   adc_or_s;

  wire            adc_clk_in;
  wire            adc_div_clk;

  genvar          l_inst;

  // output assignment for adc clock (1:4 of the sampling clock)
  assign  adc_clk = adc_div_clk;

  // data interface
  ad_serdes_in #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_ENABLE (IODELAY_ENABLE),
    .IODELAY_CTRL(0),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(SDR),
    .DATA_WIDTH(12),
    .SERDES_FACTOR(4)
  ) i_adc_data (
    .rst(adc_rst),
    .clk(adc_clk_in),
    .div_clk(adc_div_clk),
    .data_s0(adc_data[47:36]),
    .data_s1(adc_data[35:24]),
    .data_s2(adc_data[23:12]),
    .data_s3(adc_data[11: 0]),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_in_p(adc_data_in_p),
    .data_in_n(adc_data_in_n),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[11:0]),
    .up_dwdata (up_adc_dwdata[59:0]),
    .up_drdata (up_adc_drdata[59:0]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked());

  // over-range interface
  ad_serdes_in #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_ENABLE (IODELAY_ENABLE),
    .IODELAY_CTRL(1),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(SDR),
    .DATA_WIDTH(1),
    .SERDES_FACTOR(4)
  ) i_adc_or (
    .rst(adc_rst),
    .clk(adc_clk_in),
    .div_clk(adc_div_clk),
    .data_s0(adc_or_s[3]),
    .data_s1(adc_or_s[2]),
    .data_s2(adc_or_s[1]),
    .data_s3(adc_or_s[0]),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_in_p(adc_or_in_p),
    .data_in_n(adc_or_in_n),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[12]),
    .up_dwdata (up_adc_dwdata[64:60]),
    .up_drdata (up_adc_drdata[64:60]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked));

  // clock input buffers and MMCM_OR_BUFR_N
  ad_serdes_clk #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .CLKIN_DS_OR_SE_N (1),
    .MMCM_OR_BUFR_N (1),
    .MMCM_CLKIN_PERIOD (2.156),
    .MMCM_VCO_DIV (6),
    .MMCM_VCO_MUL (12),
    .MMCM_CLK0_DIV (2),
    .MMCM_CLK1_DIV (8),
    .SERDES_FACTOR(4)
  ) i_serdes_clk (
    .rst (mmcm_rst),
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk_in),
    .div_clk (adc_div_clk),
    .out_clk (),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked));

  // adc over range
  assign adc_or = adc_or_s[0] | adc_or_s[1] | adc_or_s[2] | adc_or_s[3];

  // adc status: adc is up, if both the MMCM_OR_BUFR_N and DELAY blocks are up
  always @(posedge adc_div_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status_m1 <= 1'b0;
      adc_status <= 1'b0;
    end else begin
      adc_status_m1 <= up_drp_locked & delay_locked;
      adc_status <= adc_status_m1;
    end
  end

endmodule
