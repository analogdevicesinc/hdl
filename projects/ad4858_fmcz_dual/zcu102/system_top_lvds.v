// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2023 (c) Analog Devices, Inc. All rights reserved.
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

module system_top (

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  output          adc_0_scki_p,
  output          adc_0_scki_n,
  input           adc_0_scko_p,
  input           adc_0_scko_n,
  input           adc_0_sdo_p,
  input           adc_0_sdo_n,

  input           adc_0_busy,
  output          adc_0_cnv,
  output          adc_0_pd,
  output          adc_0_lvds_cmos_n,

  input           adc_0_csdo,
  output  reg     adc_0_csck,
  output  reg     adc_0_csdio,
  output  reg     adc_0_cs_n,

  output          adc_1_scki_p,
  output          adc_1_scki_n,
  input           adc_1_scko_p,
  input           adc_1_scko_n,
  input           adc_1_sdo_p,
  input           adc_1_sdo_n,

  input           adc_1_busy,
  output          adc_1_cnv,
  output          adc_1_pd,
  output          adc_1_lvds_cmos_n,

  input           adc_1_csdo,
  output  reg     adc_1_csck,
  output  reg     adc_1_csdio,
  output  reg     adc_1_cs_n
);


  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [ 2:0]  spi0_csn;
  wire            spiad0_sck_s;
  wire            spiad0_csn_s;
  wire            spiad0_sdi_s;
  wire    [ 2:0]  spi1_csn;
  wire            spiad1_sck_s;
  wire            spiad1_csn_s;
  wire            spiad1_sdi_s;
  wire            lvds_cmos_n;

  // internal reg

  reg     [ 4:0]  cnt_cs0_up = 3'd0;
  reg     [ 4:0]  cnt_cs1_up = 3'd0;

  // assigments

  assign gpio_bd_o = gpio_o[20:13];
  assign gpio_i[12: 0] = gpio_bd_i;

  assign gpio_i[94:13] = gpio_o[94:13];

  assign spiad0_csn_s = spi0_csn[0];
  assign spiad1_csn_s = spi1_csn[0];

  always @(posedge cpu_clk) begin
    adc_0_csck <= spiad0_sck_s;
    adc_0_csdio <= spiad0_sdi_s;
    if (spiad0_csn_s == 1'b0) begin
      adc_0_cs_n <= 1'b0;
      cnt_cs0_up <= 3'd0;
    end else if (cnt_cs0_up == 5'h1f) begin
      adc_0_cs_n <= 1'b0;
      cnt_cs0_up <= cnt_cs0_up;
    end else begin
      adc_0_cs_n <= 1'b1;
      cnt_cs0_up <= cnt_cs0_up + 3'd1;
    end
  end

  always @(posedge cpu_clk) begin
    adc_1_csck <= spiad1_sck_s;
    adc_1_csdio <= spiad1_sdi_s;
    if (spiad1_csn_s == 1'b0) begin
      adc_1_cs_n <= 1'b0;
      cnt_cs1_up <= 3'd0;
    end else if (cnt_cs1_up == 5'h1f) begin
      adc_1_cs_n <= 1'b0;
      cnt_cs1_up <= cnt_cs1_up;
    end else begin
      adc_1_cs_n <= 1'b1;
      cnt_cs1_up <= cnt_cs1_up + 3'd1;
    end
  end

  assign adc_0_lvds_cmos_n = lvds_cmos_n;
  assign adc_1_lvds_cmos_n = lvds_cmos_n;

  // instantiations

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),
    .spi0_csn (spi0_csn),
    .spi0_miso (adc_0_csdo),
    .spi0_mosi (spiad0_sdi_s),
    .spi0_sclk (spiad0_sck_s),
    .spi1_csn (spi1_csn),
    .spi1_miso (adc_1_csdo),
    .spi1_mosi (spiad1_sdi_s),
    .spi1_sclk (spiad1_sck_s),
    .system_cpu_clk (cpu_clk),
    .adc_0_scki_p (adc_0_scki_p),
    .adc_0_scki_n (adc_0_scki_n),
    .adc_0_scko_p (adc_0_scko_p),
    .adc_0_scko_n (adc_0_scko_n),
    .adc_0_sdo_p (adc_0_sdo_p),
    .adc_0_sdo_n (adc_0_sdo_n),
    .adc_0_busy (adc_0_busy),
    .adc_0_cnv (adc_0_cnv),
    .adc_1_scki_p (adc_1_scki_p),
    .adc_1_scki_n (adc_1_scki_n),
    .adc_1_scko_p (adc_1_scko_p),
    .adc_1_scko_n (adc_1_scko_n),
    .adc_1_sdo_p (adc_1_sdo_p),
    .adc_1_sdo_n (adc_1_sdo_n),
    .adc_1_busy (adc_1_busy),
    .adc_1_cnv (adc_1_cnv),
    .lvds_cmos_n (lvds_cmos_n));

endmodule
