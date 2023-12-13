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

module system_top (

  input           sys_clk_n,
  input           sys_clk_p,

  output          ddr4_act_n,
  output  [16:0]  ddr4_adr,
  output  [ 1:0]  ddr4_ba,
  output  [ 1:0]  ddr4_bg,
  output          ddr4_ck_c,
  output          ddr4_ck_t,
  output          ddr4_cke,
  output          ddr4_cs_n,
  inout   [ 7:0]  ddr4_dm_n,
  inout   [63:0]  ddr4_dq,
  inout   [ 7:0]  ddr4_dqs_c,
  inout   [ 7:0]  ddr4_dqs_t,
  output          ddr4_odt,
  output          ddr4_reset_n,

  output  [ 3:0]  gpio_led,
  input   [ 3:0]  gpio_dip_sw,
  input   [ 1:0]  gpio_pb
);

  // internal signals
  wire    [95:0]  gpio_i;
  wire    [95:0]  gpio_o;
  wire    [95:0]  gpio_t;

  // Board GPIOS. Buttons, LEDs, etc...
  assign gpio_led = gpio_o[3:0];
  assign gpio_i[3:0] = gpio_o[3:0];
  assign gpio_i[7:4] = gpio_dip_sw;
  assign gpio_i[9:8] = gpio_pb;

  // Unused GPIOs
  assign gpio_i[95:64] = gpio_o[95:64];
  assign gpio_i[63:32] = gpio_o[63:32];
  assign gpio_i[31:10] = gpio_o[31:10];

  system_wrapper i_system_wrapper (
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio2_i (gpio_i[95:64]),
    .gpio2_o (gpio_o[95:64]),
    .gpio2_t (gpio_t[95:64]),

    .ddr4_dimm1_sma_clk_clk_n (sys_clk_n),
    .ddr4_dimm1_sma_clk_clk_p (sys_clk_p),

    .ddr4_dimm1_act_n (ddr4_act_n),
    .ddr4_dimm1_adr (ddr4_adr),
    .ddr4_dimm1_ba (ddr4_ba),
    .ddr4_dimm1_bg (ddr4_bg),
    .ddr4_dimm1_ck_c (ddr4_ck_c),
    .ddr4_dimm1_ck_t (ddr4_ck_t),
    .ddr4_dimm1_cke (ddr4_cke),
    .ddr4_dimm1_cs_n (ddr4_cs_n),
    .ddr4_dimm1_dm_n (ddr4_dm_n),
    .ddr4_dimm1_dq (ddr4_dq),
    .ddr4_dimm1_dqs_c (ddr4_dqs_c),
    .ddr4_dimm1_dqs_t (ddr4_dqs_t),
    .ddr4_dimm1_odt (ddr4_odt),
    .ddr4_dimm1_reset_n (ddr4_reset_n),

    .spi0_csn (),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk ());

endmodule
