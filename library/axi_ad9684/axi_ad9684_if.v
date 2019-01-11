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

module axi_ad9684_if #(

  parameter FPGA_TECHNOLOGY = 0,
  parameter IO_DELAY_GROUP = "dev_if_delay_group",
  parameter OR_STATUS = 0) (

  // device interface
  input                   adc_clk_in_p,
  input                   adc_clk_in_n,
  input       [13:0]      adc_data_in_p,
  input       [13:0]      adc_data_in_n,
  input                   adc_data_or_p,
  input                   adc_data_or_n,

  // data interface
  output                  adc_clk,
  input                   adc_rst,
  output      [27:0]      adc_data_a,
  output                  adc_or_a,
  output      [27:0]      adc_data_b,
  output                  adc_or_b,
  output  reg             adc_status,

  // delay interface
  input                   delay_clk,
  input                   delay_rst,
  input       [14:0]      delay_dload,
  input       [74:0]      delay_wdata,
  output      [74:0]      delay_rdata,
  output                  delay_locked,

  // reset
  input                   rst,

  // drp interface
  input                   up_clk,
  input                   up_rstn,
  input                   up_drp_sel,
  input                   up_drp_wr,
  input       [11:0]      up_drp_addr,
  input       [31:0]      up_drp_wdata,
  output      [31:0]      up_drp_rdata,
  output                  up_drp_ready,
  output                  up_drp_locked);


  localparam DDR_OR_SDR_N = 1;

  // internal registers

  reg             adc_status_m1 = 'd0;

  // internal signals

  wire            adc_clk_in;
  wire            adc_div_clk;
  wire  [ 1:0]    adc_data_or_a_s;
  wire  [ 1:0]    adc_data_or_b_s;
  wire            loaden_s;
  wire  [ 7:0]    phase_s;

  genvar          l_inst;

  // adc_clk is 1:2 of the sampling clock
  // f_max = 250 MHz

  assign  adc_clk = adc_div_clk;

  // data interface

  ad_serdes_in #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IODELAY_CTRL(1),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(DDR_OR_SDR_N),
    .DATA_WIDTH(14))
  i_adc_data (
    .rst(adc_rst),
    .clk(adc_clk_in),
    .div_clk(adc_div_clk),
    .loaden(loaden_s),
    .phase(phase_s),
    .locked(1'b0),
    .data_s0(adc_data_b[27:14]),
    .data_s1(adc_data_a[27:14]),
    .data_s2(adc_data_b[13: 0]),
    .data_s3(adc_data_a[13: 0]),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_in_p(adc_data_in_p[13:0]),
    .data_in_n(adc_data_in_n[13:0]),
    .up_clk (up_clk),
    .up_dld (delay_dload[13:0]),
    .up_dwdata (delay_wdata[69:0]),
    .up_drdata (delay_rdata[69:0]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked));

  generate if (OR_STATUS == 1) begin

    ad_serdes_in #(
      .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
      .IODELAY_CTRL(0),
      .IODELAY_GROUP(IO_DELAY_GROUP),
      .DDR_OR_SDR_N(DDR_OR_SDR_N),
      .DATA_WIDTH(1))
    i_adc_or (
      .rst(adc_rst),
      .clk(adc_clk_in),
      .div_clk(adc_div_clk),
      .loaden(loaden_s),
      .phase(phase_s),
      .locked(1'b0),
      .data_s0(adc_data_or_b_s[1]),
      .data_s1(adc_data_or_a_s[1]),
      .data_s2(adc_data_or_b_s[0]),
      .data_s3(adc_data_or_a_s[0]),
      .data_s4(),
      .data_s5(),
      .data_s6(),
      .data_s7(),
      .data_in_p(adc_data_or_p),
      .data_in_n(adc_data_or_n),
      .up_clk (up_clk),
      .up_dld (delay_dload[14]),
      .up_dwdata (delay_wdata[74:70]),
      .up_drdata (delay_rdata[74:70]),
      .delay_clk(delay_clk),
      .delay_rst(delay_rst),
      .delay_locked());

    assign adc_or_a = adc_data_or_a_s[0] | adc_data_or_a_s[1];
    assign adc_or_b = adc_data_or_b_s[0] | adc_data_or_b_s[1];

  end else begin

    assign adc_or_a = 1'b0;
    assign adc_or_b = 1'b0;

  end
  endgenerate

  // clock input buffers and MMCM_OR_BUFR_N

  ad_serdes_clk #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .MMCM_CLKIN_PERIOD (2),
    .MMCM_VCO_DIV (6),
    .MMCM_VCO_MUL (12),
    .MMCM_CLK0_DIV (2),
    .MMCM_CLK1_DIV (4))
  i_serdes_clk (
    .rst (rst),
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk_in),
    .div_clk (adc_div_clk),
    .out_clk (),
    .loaden (loaden_s),
    .phase (phase_s),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked));

  // adc status: adc is up, if both the MMCM_OR_BUFR_N and DELAY blocks are up
  always @(posedge adc_div_clk) begin
    if(adc_rst == 1'b1) begin
      adc_status_m1 <= 1'b0;
      adc_status <= 1'b0;
    end else begin
      adc_status_m1 <= up_drp_locked;
      adc_status <= adc_status_m1;
    end
  end

endmodule
