// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

  input [1:0] mipi_csi1_data_n,
  input [1:0] mipi_csi1_data_p,
  input       mipi_csi1_clk_n,
  input       mipi_csi1_clk_p,

  input [1:0] mipi_csi2_data_n,
  input [1:0] mipi_csi2_data_p,
  input       mipi_csi2_clk_n,
  input       mipi_csi2_clk_p,

  input [1:0] mipi_csi3_data_n,
  input [1:0] mipi_csi3_data_p,
  input       mipi_csi3_clk_n,
  input       mipi_csi3_clk_p,

  input [1:0] mipi_csi4_data_n,
  input [1:0] mipi_csi4_data_p,
  input       mipi_csi4_clk_n,
  input       mipi_csi4_clk_p,

  input [1:0] mipi_csi5_data_n,
  input [1:0] mipi_csi5_data_p,
  input       mipi_csi5_clk_n,
  input       mipi_csi5_clk_p,

  input [1:0] mipi_csi6_data_n,
  input [1:0] mipi_csi6_data_p,
  input       mipi_csi6_clk_n,
  input       mipi_csi6_clk_p,

  input [1:0] mipi_csi7_data_n,
  input [1:0] mipi_csi7_data_p,
  input       mipi_csi7_clk_n,
  input       mipi_csi7_clk_p,

  input [1:0] mipi_csi8_data_n,
  input [1:0] mipi_csi8_data_p,
  input       mipi_csi8_clk_n,
  input       mipi_csi8_clk_p
);

  wire            ap_rstn_frmbuf;
  wire            ap_rstn_v_proc;
  wire            csirxss_rstn;

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;

  assign gpio_i[94:0] = gpio_o[94:0];

  assign csirxss_rstn = gpio_o[1];
  assign ap_rstn_frmbuf = gpio_o[2];
  assign ap_rstn_v_proc = gpio_o[3];


  // instantiations
  system_wrapper i_system_wrapper (
    .mipi_csi1_data_n (mipi_csi1_data_n),
    .mipi_csi1_data_p (mipi_csi1_data_p),
    .mipi_csi1_clk_n (mipi_csi1_clk_n),
    .mipi_csi1_clk_p (mipi_csi1_clk_p),

    .mipi_csi2_data_n (mipi_csi2_data_n),
    .mipi_csi2_data_p (mipi_csi2_data_p),
    .mipi_csi2_clk_n (mipi_csi2_clk_n),
    .mipi_csi2_clk_p (mipi_csi2_clk_p),

    .mipi_csi3_data_n (mipi_csi3_data_n),
    .mipi_csi3_data_p (mipi_csi3_data_p),
    .mipi_csi3_clk_n (mipi_csi3_clk_n),
    .mipi_csi3_clk_p (mipi_csi3_clk_p),

    .mipi_csi4_data_n (mipi_csi4_data_n),
    .mipi_csi4_data_p (mipi_csi4_data_p),
    .mipi_csi4_clk_n (mipi_csi4_clk_n),
    .mipi_csi4_clk_p (mipi_csi4_clk_p),

    .mipi_csi5_data_n (mipi_csi5_data_n),
    .mipi_csi5_data_p (mipi_csi5_data_p),
    .mipi_csi5_clk_n (mipi_csi5_clk_n),
    .mipi_csi5_clk_p (mipi_csi5_clk_p),

    .mipi_csi6_data_n (mipi_csi6_data_n),
    .mipi_csi6_data_p (mipi_csi6_data_p),
    .mipi_csi6_clk_n (mipi_csi6_clk_n),
    .mipi_csi6_clk_p (mipi_csi6_clk_p),

    .mipi_csi7_data_n (mipi_csi7_data_n),
    .mipi_csi7_data_p (mipi_csi7_data_p),
    .mipi_csi7_clk_n (mipi_csi7_clk_n),
    .mipi_csi7_clk_p (mipi_csi7_clk_p),

    .mipi_csi8_data_n (mipi_csi8_data_n),
    .mipi_csi8_data_p (mipi_csi8_data_p),
    .mipi_csi8_clk_n (mipi_csi8_clk_n),
    .mipi_csi8_clk_p (mipi_csi8_clk_p),

    .ap_rstn_frmbuf (ap_rstn_frmbuf),
    .csirxss_rstn (csirxss_rstn),
    .ap_rstn_v_proc (ap_rstn_v_proc),

    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),

    .spi0_csn (1'b1),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk ());

endmodule

