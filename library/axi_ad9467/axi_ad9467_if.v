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
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module axi_ad9467_if #(

  parameter FPGA_TECHNOLOGY = 0,
  parameter IO_DELAY_GROUP = "dev_if_delay_group",
  parameter DELAY_REFCLK_FREQUENCY = 200
) (

  // adc interface (clk, data, over-range)

  input                   adc_clk_in_p,
  input                   adc_clk_in_n,
  input       [ 7:0]      adc_data_in_p,
  input       [ 7:0]      adc_data_in_n,
  input                   adc_or_in_p,
  input                   adc_or_in_n,

  // interface outputs

  output                  adc_clk,
  output  reg [15:0]      adc_data,
  output  reg             adc_or,

  // processor interface

  input                   adc_ddr_edgesel,

  // delay control signals

  input                   up_clk,
  input       [ 8:0]      up_dld,
  input       [44:0]      up_dwdata,
  output      [44:0]      up_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked
);

  // internal registers

  reg     [ 7:0]  adc_data_p = 'd0;
  reg     [ 7:0]  adc_data_n = 'd0;
  reg     [ 7:0]  adc_data_p_d = 'd0;
  reg     [ 7:0]  adc_dmux_a = 'd0;
  reg     [ 7:0]  adc_dmux_b = 'd0;
  reg             adc_or_p = 'd0;
  reg             adc_or_n = 'd0;

  // internal signals

  wire    [ 7:0]  adc_data_p_s;
  wire    [ 7:0]  adc_data_n_s;
  wire            adc_or_p_s;
  wire            adc_or_n_s;

  genvar          l_inst;

  // sample select (p/n) swap

  always @(posedge adc_clk) begin
    adc_data_p <= adc_data_p_s;
    adc_data_n <= adc_data_n_s;
    adc_data_p_d <= adc_data_p;
    adc_dmux_a <= (adc_ddr_edgesel == 1'b1) ? adc_data_n   : adc_data_p;
    adc_dmux_b <= (adc_ddr_edgesel == 1'b1) ? adc_data_p_d : adc_data_n;
    adc_data[15] <= adc_dmux_b[7];
    adc_data[14] <= adc_dmux_a[7];
    adc_data[13] <= adc_dmux_b[6];
    adc_data[12] <= adc_dmux_a[6];
    adc_data[11] <= adc_dmux_b[5];
    adc_data[10] <= adc_dmux_a[5];
    adc_data[ 9] <= adc_dmux_b[4];
    adc_data[ 8] <= adc_dmux_a[4];
    adc_data[ 7] <= adc_dmux_b[3];
    adc_data[ 6] <= adc_dmux_a[3];
    adc_data[ 5] <= adc_dmux_b[2];
    adc_data[ 4] <= adc_dmux_a[2];
    adc_data[ 3] <= adc_dmux_b[1];
    adc_data[ 2] <= adc_dmux_a[1];
    adc_data[ 1] <= adc_dmux_b[0];
    adc_data[ 0] <= adc_dmux_a[0];
    adc_or_p <= adc_or_p_s;
    adc_or_n <= adc_or_n_s;
    if ((adc_or_p == 1'b1) || (adc_or_n == 1'b1)) begin
      adc_or <= 1'b1;
    end else begin
      adc_or <= 1'b0;
    end
  end

  // data interface

  generate
  for (l_inst = 0; l_inst <= 7; l_inst = l_inst + 1) begin : g_adc_if
  ad_data_in #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY)
  ) i_adc_data (
    .rx_clk (adc_clk),
    .rx_data_in_p (adc_data_in_p[l_inst]),
    .rx_data_in_n (adc_data_in_n[l_inst]),
    .rx_data_p (adc_data_p_s[l_inst]),
    .rx_data_n (adc_data_n_s[l_inst]),
    .up_clk (up_clk),
    .up_dld (up_dld[l_inst]),
    .up_dwdata (up_dwdata[((l_inst*5)+4):(l_inst*5)]),
    .up_drdata (up_drdata[((l_inst*5)+4):(l_inst*5)]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
  end
  endgenerate

  // over-range interface

  ad_data_in #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IODELAY_CTRL (1),
    .IODELAY_GROUP (IO_DELAY_GROUP),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY)
  ) i_adc_or (
    .rx_clk (adc_clk),
    .rx_data_in_p (adc_or_in_p),
    .rx_data_in_n (adc_or_in_n),
    .rx_data_p (adc_or_p_s),
    .rx_data_n (adc_or_n_s),
    .up_clk (up_clk),
    .up_dld (up_dld[8]),
    .up_dwdata (up_dwdata[44:40]),
    .up_drdata (up_drdata[44:40]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // clock

  ad_data_clk i_adc_clk (
    .rst (1'b0),
    .locked (),
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk));

endmodule
