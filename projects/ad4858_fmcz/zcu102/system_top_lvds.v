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

  output          scki_p,
  output          scki_n,
  input           scko_p,
  input           scko_n,
  input           sdo_p,
  input           sdo_n,

  input           busy,
  output          cnv,
  output          pd,
  output          lvds_cmos_n,

  input           csdo,
  output  reg     csck,
  output  reg     csdio,
  output  reg     cs_n

);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [ 2:0]  spi0_csn;
  wire            spiad_sck_s;
  wire            spiad_csn_s;

  // internal reg

  reg     [ 4:0]  cnt_cs_up = 3'd0;

  // assigments

  assign gpio_bd_o = gpio_o[20:13];
  assign gpio_i[12: 0] = gpio_bd_i;

  assign gpio_i[94:13] = gpio_o[94:13];

  assign spiad_csn_s = spi0_csn[0];

  always @(posedge cpu_clk) begin
    csck <= spiad_sck_s;
    csdio <= spiad_sdi_s;
    if (spiad_csn_s == 1'b0) begin
      cs_n <= 1'b0;
      cnt_cs_up <= 3'd0;
    end else if (cnt_cs_up == 5'h1f) begin
      cs_n <= 1'b0;
      cnt_cs_up <= cnt_cs_up;
    end else begin
      cs_n <= 1'b1;
      cnt_cs_up <= cnt_cs_up + 3'd1;
    end
  end

  // instantiations

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),
    .spi0_csn (spi0_csn),
    .spi0_miso (csdo),
    .spi0_mosi (spiad_sdi_s),
    .spi0_sclk (spiad_sck_s),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),
    .system_cpu_clk (cpu_clk),
    .scki_p (scki_p),
    .scki_n (scki_n),
    .scko_p (scko_p),
    .scko_n (scko_n),
    .sdo_p (sdo_p),
    .sdo_n (sdo_n),
    .busy (busy),
    .cnv (cnv),
    .lvds_cmos_n (lvds_cmos_n));

endmodule
