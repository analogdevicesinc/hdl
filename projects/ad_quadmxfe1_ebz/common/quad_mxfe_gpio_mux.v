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

module quad_mxfe_gpio_mux #() (

  inout  [10:0] mxfe0_gpio,
  inout  [10:0] mxfe1_gpio,
  inout  [10:0] mxfe2_gpio,
  inout  [10:0] mxfe3_gpio,

  input  [127:64] gpio_t,
  output [127:64] gpio_i,
  input  [127:64] gpio_o

);


  wire gpio0_mode;
  wire mxfe3_gpio0_in;
  wire mxfe3_gpio1_in;
  wire mxfe3_gpio2_in;
  wire mxfe3_gpio3_in;
  wire mxfe3_gpio4_in;
  wire mxfe3_gpio5_in;
  wire [5:0] gpio_t_69_64;
  wire [5:0] gpio_o_69_64;
  wire [5:0] gpio_t_80_75;
  wire [5:0] gpio_o_80_75;
  wire [5:0] gpio_t_91_86;
  wire [5:0] gpio_o_91_86;
  wire [5:0] gpio_t_102_97;

  ad_iobuf #(.DATA_WIDTH(11)) i_iobuf_mxfe_0 (
    .dio_t ({gpio_t[74:70],gpio_t_69_64}),
    .dio_i ({gpio_o[74:70],gpio_o_69_64}),
    .dio_o (gpio_i[74:64]),
    .dio_p (mxfe0_gpio)); // 74-64

  assign gpio_t_69_64[0] = gpio0_mode ? 1'b0 : gpio_t[64];
  assign gpio_t_69_64[1] = gpio1_mode ? 1'b0 : gpio_t[65];
  assign gpio_t_69_64[2] = gpio2_mode ? 1'b0 : gpio_t[66];
  assign gpio_t_69_64[3] = gpio3_mode ? 1'b0 : gpio_t[67];
  assign gpio_t_69_64[4] = gpio4_mode ? 1'b0 : gpio_t[68];
  assign gpio_t_69_64[5] = gpio5_mode ? 1'b0 : gpio_t[69];
  assign gpio_o_69_64[0] = gpio0_mode ? mxfe3_gpio0_in : gpio_o[64];
  assign gpio_o_69_64[1] = gpio1_mode ? mxfe3_gpio1_in : gpio_o[65];
  assign gpio_o_69_64[2] = gpio2_mode ? mxfe3_gpio2_in : gpio_o[66];
  assign gpio_o_69_64[3] = gpio3_mode ? mxfe3_gpio3_in : gpio_o[67];
  assign gpio_o_69_64[4] = gpio4_mode ? mxfe3_gpio4_in : gpio_o[68];
  assign gpio_o_69_64[5] = gpio5_mode ? mxfe3_gpio5_in : gpio_o[69];

  ad_iobuf #(.DATA_WIDTH(11)) i_iobuf_mxfe_1 (
    .dio_t ({gpio_t[85:81],gpio_t_80_75}),
    .dio_i ({gpio_o[85:81],gpio_o_80_75}),
    .dio_o (gpio_i[85:75]),
    .dio_p (mxfe1_gpio)); // 85-75

  assign gpio_t_80_75[0] = gpio0_mode ? 1'b0 : gpio_t[75];
  assign gpio_t_80_75[1] = gpio1_mode ? 1'b0 : gpio_t[76];
  assign gpio_t_80_75[2] = gpio2_mode ? 1'b0 : gpio_t[77];
  assign gpio_t_80_75[3] = gpio3_mode ? 1'b0 : gpio_t[78];
  assign gpio_t_80_75[4] = gpio4_mode ? 1'b0 : gpio_t[79];
  assign gpio_t_80_75[5] = gpio5_mode ? 1'b0 : gpio_t[80];
  assign gpio_o_80_75[0] = gpio0_mode ? mxfe3_gpio0_in : gpio_o[75];
  assign gpio_o_80_75[1] = gpio1_mode ? mxfe3_gpio1_in : gpio_o[76];
  assign gpio_o_80_75[2] = gpio2_mode ? mxfe3_gpio2_in : gpio_o[77];
  assign gpio_o_80_75[3] = gpio3_mode ? mxfe3_gpio3_in : gpio_o[78];
  assign gpio_o_80_75[4] = gpio4_mode ? mxfe3_gpio4_in : gpio_o[79];
  assign gpio_o_80_75[5] = gpio5_mode ? mxfe3_gpio5_in : gpio_o[80];

  ad_iobuf #(.DATA_WIDTH(11)) i_iobuf_mxfe_2 (
    .dio_t ({gpio_t[96:92],gpio_t_91_86}),
    .dio_i ({gpio_o[96:92],gpio_o_91_86}),
    .dio_o (gpio_i[96:86]),
    .dio_p (mxfe2_gpio)); // 96-86

  assign gpio_t_91_86[0] = gpio0_mode ? 1'b0 : gpio_t[86];
  assign gpio_t_91_86[1] = gpio1_mode ? 1'b0 : gpio_t[87];
  assign gpio_t_91_86[2] = gpio2_mode ? 1'b0 : gpio_t[88];
  assign gpio_t_91_86[3] = gpio3_mode ? 1'b0 : gpio_t[89];
  assign gpio_t_91_86[4] = gpio4_mode ? 1'b0 : gpio_t[90];
  assign gpio_t_91_86[5] = gpio5_mode ? 1'b0 : gpio_t[91];
  assign gpio_o_91_86[0] = gpio0_mode ? mxfe3_gpio0_in : gpio_o[86];
  assign gpio_o_91_86[1] = gpio1_mode ? mxfe3_gpio1_in : gpio_o[87];
  assign gpio_o_91_86[2] = gpio2_mode ? mxfe3_gpio2_in : gpio_o[88];
  assign gpio_o_91_86[3] = gpio3_mode ? mxfe3_gpio3_in : gpio_o[89];
  assign gpio_o_91_86[4] = gpio4_mode ? mxfe3_gpio4_in : gpio_o[90];
  assign gpio_o_91_86[5] = gpio5_mode ? mxfe3_gpio5_in : gpio_o[91];


  ad_iobuf #(.DATA_WIDTH(11)) i_iobuf_mxfe_3 (
    .dio_t ({gpio_t[107:103],gpio_t_102_97}),
    .dio_i (gpio_o[107:97]),
    .dio_o (gpio_i[107:97]),
    .dio_p (mxfe3_gpio)); // 107-97

  assign gpio_t_102_97[0] = gpio0_mode ? 1'b1 : gpio_t[97];
  assign gpio_t_102_97[1] = gpio1_mode ? 1'b1 : gpio_t[98];
  assign gpio_t_102_97[2] = gpio2_mode ? 1'b1 : gpio_t[99];
  assign gpio_t_102_97[3] = gpio3_mode ? 1'b1 : gpio_t[100];
  assign gpio_t_102_97[4] = gpio4_mode ? 1'b1 : gpio_t[101];
  assign gpio_t_102_97[5] = gpio5_mode ? 1'b1 : gpio_t[102];
  assign mxfe3_gpio0_in = gpio_i[97];
  assign mxfe3_gpio1_in = gpio_i[98];
  assign mxfe3_gpio2_in = gpio_i[99];
  assign mxfe3_gpio3_in = gpio_i[100];
  assign mxfe3_gpio4_in = gpio_i[101];
  assign mxfe3_gpio5_in = gpio_i[102];


  // 0 - Software controlled GPIO
  // 1 - LMFC based Master-Slave NCO Sync
  assign gpio0_mode = gpio_o[108];
  assign gpio1_mode = gpio_o[110];
  assign gpio2_mode = gpio_o[112];
  assign gpio3_mode = gpio_o[114];
  assign gpio4_mode = gpio_o[116];
  assign gpio5_mode = gpio_o[118];


  //loopback unused gpios
  assign gpio_i[127:108] = gpio_o[127:108];


endmodule
