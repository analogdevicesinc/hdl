// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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

  output  [ 5:0]  ch0_lpddr4_trip1_ca_a,
  output  [ 5:0]  ch0_lpddr4_trip1_ca_b,
  output          ch0_lpddr4_trip1_ck_c_a,
  output          ch0_lpddr4_trip1_ck_c_b,
  output          ch0_lpddr4_trip1_ck_t_a,
  output          ch0_lpddr4_trip1_ck_t_b,
  output          ch0_lpddr4_trip1_cke_a,
  output          ch0_lpddr4_trip1_cke_b,
  output          ch0_lpddr4_trip1_cs_a,
  output          ch0_lpddr4_trip1_cs_b,
  inout   [ 1:0]  ch0_lpddr4_trip1_dmi_a,
  inout   [ 1:0]  ch0_lpddr4_trip1_dmi_b,
  inout   [15:0]  ch0_lpddr4_trip1_dq_a,
  inout   [15:0]  ch0_lpddr4_trip1_dq_b,
  inout   [ 1:0]  ch0_lpddr4_trip1_dqs_c_a,
  inout   [ 1:0]  ch0_lpddr4_trip1_dqs_c_b,
  inout   [ 1:0]  ch0_lpddr4_trip1_dqs_t_a,
  inout   [ 1:0]  ch0_lpddr4_trip1_dqs_t_b,
  output          ch0_lpddr4_trip1_reset_n,
  output  [ 5:0]  ch1_lpddr4_trip1_ca_a,
  output  [ 5:0]  ch1_lpddr4_trip1_ca_b,
  output          ch1_lpddr4_trip1_ck_c_a,
  output          ch1_lpddr4_trip1_ck_c_b,
  output          ch1_lpddr4_trip1_ck_t_a,
  output          ch1_lpddr4_trip1_ck_t_b,
  output          ch1_lpddr4_trip1_cke_a,
  output          ch1_lpddr4_trip1_cke_b,
  output          ch1_lpddr4_trip1_cs_a,
  output          ch1_lpddr4_trip1_cs_b,
  inout   [ 1:0]  ch1_lpddr4_trip1_dmi_a,
  inout   [ 1:0]  ch1_lpddr4_trip1_dmi_b,
  inout   [15:0]  ch1_lpddr4_trip1_dq_a,
  inout   [15:0]  ch1_lpddr4_trip1_dq_b,
  inout   [ 1:0]  ch1_lpddr4_trip1_dqs_c_a,
  inout   [ 1:0]  ch1_lpddr4_trip1_dqs_c_b,
  inout   [ 1:0]  ch1_lpddr4_trip1_dqs_t_a,
  inout   [ 1:0]  ch1_lpddr4_trip1_dqs_t_b,
  output          ch1_lpddr4_trip1_reset_n,

  // GPIOs
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

    .lpddr4_clk1_clk_n (sys_clk_n),
    .lpddr4_clk1_clk_p (sys_clk_p),

    .ch0_lpddr4_trip1_ca_a (ch0_lpddr4_trip1_ca_a),
    .ch0_lpddr4_trip1_ca_b (ch0_lpddr4_trip1_ca_b),
    .ch0_lpddr4_trip1_ck_c_a (ch0_lpddr4_trip1_ck_c_a),
    .ch0_lpddr4_trip1_ck_c_b (ch0_lpddr4_trip1_ck_c_b),
    .ch0_lpddr4_trip1_ck_t_a (ch0_lpddr4_trip1_ck_t_a),
    .ch0_lpddr4_trip1_ck_t_b (ch0_lpddr4_trip1_ck_t_b),
    .ch0_lpddr4_trip1_cke_a (ch0_lpddr4_trip1_cke_a),
    .ch0_lpddr4_trip1_cke_b (ch0_lpddr4_trip1_cke_b),
    .ch0_lpddr4_trip1_cs_a (ch0_lpddr4_trip1_cs_a),
    .ch0_lpddr4_trip1_cs_b (ch0_lpddr4_trip1_cs_b),
    .ch0_lpddr4_trip1_dmi_a (ch0_lpddr4_trip1_dmi_a),
    .ch0_lpddr4_trip1_dmi_b (ch0_lpddr4_trip1_dmi_b),
    .ch0_lpddr4_trip1_dq_a (ch0_lpddr4_trip1_dq_a),
    .ch0_lpddr4_trip1_dq_b (ch0_lpddr4_trip1_dq_b),
    .ch0_lpddr4_trip1_dqs_c_a (ch0_lpddr4_trip1_dqs_c_a),
    .ch0_lpddr4_trip1_dqs_c_b (ch0_lpddr4_trip1_dqs_c_b),
    .ch0_lpddr4_trip1_dqs_t_a (ch0_lpddr4_trip1_dqs_t_a),
    .ch0_lpddr4_trip1_dqs_t_b (ch0_lpddr4_trip1_dqs_t_b),
    .ch0_lpddr4_trip1_reset_n (ch0_lpddr4_trip1_reset_n),
    .ch1_lpddr4_trip1_ca_a (ch1_lpddr4_trip1_ca_a),
    .ch1_lpddr4_trip1_ca_b (ch1_lpddr4_trip1_ca_b),
    .ch1_lpddr4_trip1_ck_c_a (ch1_lpddr4_trip1_ck_c_a),
    .ch1_lpddr4_trip1_ck_c_b (ch1_lpddr4_trip1_ck_c_b),
    .ch1_lpddr4_trip1_ck_t_a (ch1_lpddr4_trip1_ck_t_a),
    .ch1_lpddr4_trip1_ck_t_b (ch1_lpddr4_trip1_ck_t_b),
    .ch1_lpddr4_trip1_cke_a (ch1_lpddr4_trip1_cke_a),
    .ch1_lpddr4_trip1_cke_b (ch1_lpddr4_trip1_cke_b),
    .ch1_lpddr4_trip1_cs_a (ch1_lpddr4_trip1_cs_a),
    .ch1_lpddr4_trip1_cs_b (ch1_lpddr4_trip1_cs_b),
    .ch1_lpddr4_trip1_dmi_a (ch1_lpddr4_trip1_dmi_a),
    .ch1_lpddr4_trip1_dmi_b (ch1_lpddr4_trip1_dmi_b),
    .ch1_lpddr4_trip1_dq_a (ch1_lpddr4_trip1_dq_a),
    .ch1_lpddr4_trip1_dq_b (ch1_lpddr4_trip1_dq_b),
    .ch1_lpddr4_trip1_dqs_c_a (ch1_lpddr4_trip1_dqs_c_a),
    .ch1_lpddr4_trip1_dqs_c_b (ch1_lpddr4_trip1_dqs_c_b),
    .ch1_lpddr4_trip1_dqs_t_a (ch1_lpddr4_trip1_dqs_t_a),
    .ch1_lpddr4_trip1_dqs_t_b (ch1_lpddr4_trip1_dqs_t_b),
    .ch1_lpddr4_trip1_reset_n (ch1_lpddr4_trip1_reset_n),

    .spi0_csn  (),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn  (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk ());

endmodule
