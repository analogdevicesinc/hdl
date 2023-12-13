// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

module quad_mxfe_gpio_mux (

  inout         mxfe0_gpio0,
  inout         mxfe0_gpio1,
  inout         mxfe0_gpio2,
  inout         mxfe0_gpio5,
  inout         mxfe0_gpio6,
  inout         mxfe0_gpio7,
  inout         mxfe0_gpio8,
  inout         mxfe0_gpio9,
  inout         mxfe0_gpio10,
  inout         mxfe0_syncin_1_n,
  inout         mxfe0_syncin_1_p,
  inout         mxfe0_syncout_1_n,
  inout         mxfe0_syncout_1_p,

  inout         mxfe1_gpio0,
  inout         mxfe1_gpio1,
  inout         mxfe1_gpio2,
  inout         mxfe1_gpio5,
  inout         mxfe1_gpio6,
  inout         mxfe1_gpio7,
  inout         mxfe1_gpio8,
  inout         mxfe1_gpio9,
  inout         mxfe1_gpio10,
  inout         mxfe1_syncin_1_n,
  inout         mxfe1_syncin_1_p,
  inout         mxfe1_syncout_1_n,
  inout         mxfe1_syncout_1_p,

  inout         mxfe2_gpio0,
  inout         mxfe2_gpio1,
  inout         mxfe2_gpio2,
  inout         mxfe2_gpio5,
  inout         mxfe2_gpio6,
  inout         mxfe2_gpio7,
  inout         mxfe2_gpio8,
  inout         mxfe2_gpio9,
  inout         mxfe2_gpio10,
  inout         mxfe2_syncin_1_n,
  inout         mxfe2_syncin_1_p,
  inout         mxfe2_syncout_1_n,
  inout         mxfe2_syncout_1_p,

  inout         mxfe3_gpio0,
  inout         mxfe3_gpio1,
  inout         mxfe3_gpio2,
  inout         mxfe3_gpio5,
  inout         mxfe3_gpio6,
  inout         mxfe3_gpio7,
  inout         mxfe3_gpio8,
  inout         mxfe3_gpio9,
  inout         mxfe3_gpio10,
  inout         mxfe3_syncin_1_n,
  inout         mxfe3_syncin_1_p,
  inout         mxfe3_syncout_1_n,
  inout         mxfe3_syncout_1_p,

  input  [127:64] gpio_t,
  output [127:64] gpio_i,
  input  [127:64] gpio_o
);

  wire gpio0_mode;

  ad_iobuf #(
    .DATA_WIDTH(13)
  ) i_iobuf_mxfe_0 (
    .dio_t ( {mxfe0_gpio0_t,
              mxfe0_gpio1_t,
              mxfe0_gpio2_t,
              mxfe0_gpio5_t,
              mxfe0_gpio6_t,
              mxfe0_gpio7_t,
              mxfe0_gpio8_t,
              mxfe0_gpio9_t,
              mxfe0_gpio10_t,
              mxfe0_syncin_1_n_t,
              mxfe0_syncin_1_p_t,
              mxfe0_syncout_1_n_t,
              mxfe0_syncout_1_p_t}),
    .dio_i ( {mxfe0_gpio0_o,
              mxfe0_gpio1_o,
              mxfe0_gpio2_o,
              mxfe0_gpio5_o,
              mxfe0_gpio6_o,
              mxfe0_gpio7_o,
              mxfe0_gpio8_o,
              mxfe0_gpio9_o,
              mxfe0_gpio10_o,
              mxfe0_syncin_1_n_o,
              mxfe0_syncin_1_p_o,
              mxfe0_syncout_1_n_o,
              mxfe0_syncout_1_p_o}),
    .dio_o ( {mxfe0_gpio0_i,
              mxfe0_gpio1_i,
              mxfe0_gpio2_i,
              mxfe0_gpio5_i,
              mxfe0_gpio6_i,
              mxfe0_gpio7_i,
              mxfe0_gpio8_i,
              mxfe0_gpio9_i,
              mxfe0_gpio10_i,
              mxfe0_syncin_1_n_i,
              mxfe0_syncin_1_p_i,
              mxfe0_syncout_1_n_i,
              mxfe0_syncout_1_p_i}),
    .dio_p ( {mxfe0_gpio0,
              mxfe0_gpio1,
              mxfe0_gpio2,
              mxfe0_gpio5,
              mxfe0_gpio6,
              mxfe0_gpio7,
              mxfe0_gpio8,
              mxfe0_gpio9,
              mxfe0_gpio10,
              mxfe0_syncin_1_n,
              mxfe0_syncin_1_p,
              mxfe0_syncout_1_n,
              mxfe0_syncout_1_p}));

  ad_iobuf #(
    .DATA_WIDTH(13)
  ) i_iobuf_mxfe_1 (
    .dio_t ( {mxfe1_gpio0_t,
              mxfe1_gpio1_t,
              mxfe1_gpio2_t,
              mxfe1_gpio5_t,
              mxfe1_gpio6_t,
              mxfe1_gpio7_t,
              mxfe1_gpio8_t,
              mxfe1_gpio9_t,
              mxfe1_gpio10_t,
              mxfe1_syncin_1_n_t,
              mxfe1_syncin_1_p_t,
              mxfe1_syncout_1_n_t,
              mxfe1_syncout_1_p_t}),
    .dio_i ( {mxfe1_gpio0_o,
              mxfe1_gpio1_o,
              mxfe1_gpio2_o,
              mxfe1_gpio5_o,
              mxfe1_gpio6_o,
              mxfe1_gpio7_o,
              mxfe1_gpio8_o,
              mxfe1_gpio9_o,
              mxfe1_gpio10_o,
              mxfe1_syncin_1_n_o,
              mxfe1_syncin_1_p_o,
              mxfe1_syncout_1_n_o,
              mxfe1_syncout_1_p_o}),
    .dio_o ( {mxfe1_gpio0_i,
              mxfe1_gpio1_i,
              mxfe1_gpio2_i,
              mxfe1_gpio5_i,
              mxfe1_gpio6_i,
              mxfe1_gpio7_i,
              mxfe1_gpio8_i,
              mxfe1_gpio9_i,
              mxfe1_gpio10_i,
              mxfe1_syncin_1_n_i,
              mxfe1_syncin_1_p_i,
              mxfe1_syncout_1_n_i,
              mxfe1_syncout_1_p_i}),
    .dio_p ( {mxfe1_gpio0,
              mxfe1_gpio1,
              mxfe1_gpio2,
              mxfe1_gpio5,
              mxfe1_gpio6,
              mxfe1_gpio7,
              mxfe1_gpio8,
              mxfe1_gpio9,
              mxfe1_gpio10,
              mxfe1_syncin_1_n,
              mxfe1_syncin_1_p,
              mxfe1_syncout_1_n,
              mxfe1_syncout_1_p}));

  ad_iobuf #(
    .DATA_WIDTH(13)
  ) i_iobuf_mxfe_2 (
    .dio_t ( {mxfe2_gpio0_t,
              mxfe2_gpio1_t,
              mxfe2_gpio2_t,
              mxfe2_gpio5_t,
              mxfe2_gpio6_t,
              mxfe2_gpio7_t,
              mxfe2_gpio8_t,
              mxfe2_gpio9_t,
              mxfe2_gpio10_t,
              mxfe2_syncin_1_n_t,
              mxfe2_syncin_1_p_t,
              mxfe2_syncout_1_n_t,
              mxfe2_syncout_1_p_t}),
    .dio_i ( {mxfe2_gpio0_o,
              mxfe2_gpio1_o,
              mxfe2_gpio2_o,
              mxfe2_gpio5_o,
              mxfe2_gpio6_o,
              mxfe2_gpio7_o,
              mxfe2_gpio8_o,
              mxfe2_gpio9_o,
              mxfe2_gpio10_o,
              mxfe2_syncin_1_n_o,
              mxfe2_syncin_1_p_o,
              mxfe2_syncout_1_n_o,
              mxfe2_syncout_1_p_o}),
    .dio_o ( {mxfe2_gpio0_i,
              mxfe2_gpio1_i,
              mxfe2_gpio2_i,
              mxfe2_gpio5_i,
              mxfe2_gpio6_i,
              mxfe2_gpio7_i,
              mxfe2_gpio8_i,
              mxfe2_gpio9_i,
              mxfe2_gpio10_i,
              mxfe2_syncin_1_n_i,
              mxfe2_syncin_1_p_i,
              mxfe2_syncout_1_n_i,
              mxfe2_syncout_1_p_i}),
    .dio_p ( {mxfe2_gpio0,
              mxfe2_gpio1,
              mxfe2_gpio2,
              mxfe2_gpio5,
              mxfe2_gpio6,
              mxfe2_gpio7,
              mxfe2_gpio8,
              mxfe2_gpio9,
              mxfe2_gpio10,
              mxfe2_syncin_1_n,
              mxfe2_syncin_1_p,
              mxfe2_syncout_1_n,
              mxfe2_syncout_1_p}));

  ad_iobuf #(
    .DATA_WIDTH(13)
  ) i_iobuf_mxfe_3 (
    .dio_t ( {mxfe3_gpio0_t,
              mxfe3_gpio1_t,
              mxfe3_gpio2_t,
              mxfe3_gpio5_t,
              mxfe3_gpio6_t,
              mxfe3_gpio7_t,
              mxfe3_gpio8_t,
              mxfe3_gpio9_t,
              mxfe3_gpio10_t,
              mxfe3_syncin_1_n_t,
              mxfe3_syncin_1_p_t,
              mxfe3_syncout_1_n_t,
              mxfe3_syncout_1_p_t}),
    .dio_i ( {mxfe3_gpio0_o,
              mxfe3_gpio1_o,
              mxfe3_gpio2_o,
              mxfe3_gpio5_o,
              mxfe3_gpio6_o,
              mxfe3_gpio7_o,
              mxfe3_gpio8_o,
              mxfe3_gpio9_o,
              mxfe3_gpio10_o,
              mxfe3_syncin_1_n_o,
              mxfe3_syncin_1_p_o,
              mxfe3_syncout_1_n_o,
              mxfe3_syncout_1_p_o}),
    .dio_o ( {mxfe3_gpio0_i,
              mxfe3_gpio1_i,
              mxfe3_gpio2_i,
              mxfe3_gpio5_i,
              mxfe3_gpio6_i,
              mxfe3_gpio7_i,
              mxfe3_gpio8_i,
              mxfe3_gpio9_i,
              mxfe3_gpio10_i,
              mxfe3_syncin_1_n_i,
              mxfe3_syncin_1_p_i,
              mxfe3_syncout_1_n_i,
              mxfe3_syncout_1_p_i}),
    .dio_p ( {mxfe3_gpio0,
              mxfe3_gpio1,
              mxfe3_gpio2,
              mxfe3_gpio5,
              mxfe3_gpio6,
              mxfe3_gpio7,
              mxfe3_gpio8,
              mxfe3_gpio9,
              mxfe3_gpio10,
              mxfe3_syncin_1_n,
              mxfe3_syncin_1_p,
              mxfe3_syncout_1_n,
              mxfe3_syncout_1_p}));

  // Bidirectional buffer output enables
  assign {mxfe0_gpio0_t,
          mxfe1_gpio0_t,
          mxfe2_gpio0_t,
          mxfe3_gpio0_t} = gpio0_mode ? 4'b0001 : {4{gpio_t[64]}};

  assign {mxfe0_gpio1_t,
          mxfe1_gpio1_t,
          mxfe2_gpio1_t,
          mxfe3_gpio1_t} = {4{gpio_t[65]}};

  assign {mxfe0_gpio2_t,
          mxfe1_gpio2_t,
          mxfe2_gpio2_t,
          mxfe3_gpio2_t} = {4{gpio_t[66]}};

  assign {mxfe0_gpio5_t,
          mxfe1_gpio5_t,
          mxfe2_gpio5_t,
          mxfe3_gpio5_t} = {4{gpio_t[69]}};

  assign {mxfe0_gpio6_t,
          mxfe1_gpio6_t,
          mxfe2_gpio6_t,
          mxfe3_gpio6_t} = {4{gpio_t[70]}};

  assign {mxfe0_gpio7_t,
          mxfe1_gpio7_t,
          mxfe2_gpio7_t,
          mxfe3_gpio7_t} = {4{gpio_t[71]}};

  assign {mxfe0_gpio8_t,
          mxfe1_gpio8_t,
          mxfe2_gpio8_t,
          mxfe3_gpio8_t} = {4{gpio_t[72]}};

  assign {mxfe0_gpio9_t,
          mxfe1_gpio9_t,
          mxfe2_gpio9_t,
          mxfe3_gpio9_t} = {4{gpio_t[73]}};

  assign {mxfe0_gpio10_t,
          mxfe1_gpio10_t,
          mxfe2_gpio10_t,
          mxfe3_gpio10_t} = {4{gpio_t[74]}};

  assign {mxfe0_syncin_1_n_t,
          mxfe1_syncin_1_n_t,
          mxfe2_syncin_1_n_t,
          mxfe3_syncin_1_n_t} = {4{gpio_t[75]}};

  assign {mxfe0_syncin_1_p_t,
          mxfe1_syncin_1_p_t,
          mxfe2_syncin_1_p_t,
          mxfe3_syncin_1_p_t} = {4{gpio_t[76]}};

  assign {mxfe0_syncout_1_n_t,
          mxfe1_syncout_1_n_t,
          mxfe2_syncout_1_n_t,
          mxfe3_syncout_1_n_t} = {4{gpio_t[77]}};

  assign {mxfe0_syncout_1_p_t,
          mxfe1_syncout_1_p_t,
          mxfe2_syncout_1_p_t,
          mxfe3_syncout_1_p_t} = {4{gpio_t[78]}};

  // Bidirectional buffer output values
  assign {mxfe0_gpio0_o,
          mxfe1_gpio0_o,
          mxfe2_gpio0_o,
          mxfe3_gpio0_o} = gpio0_mode ? {4{mxfe3_gpio0_i}} : {4{gpio_o[64]}};

  assign {mxfe0_gpio1_o,
          mxfe1_gpio1_o,
          mxfe2_gpio1_o,
          mxfe3_gpio1_o} = {4{gpio_o[65]}};

  assign {mxfe0_gpio2_o,
          mxfe1_gpio2_o,
          mxfe2_gpio2_o,
          mxfe3_gpio2_o} = {4{gpio_o[66]}};

  assign {mxfe0_gpio5_o,
          mxfe1_gpio5_o,
          mxfe2_gpio5_o,
          mxfe3_gpio5_o} = {4{gpio_o[69]}};

  assign {mxfe0_gpio6_o,
          mxfe1_gpio6_o,
          mxfe2_gpio6_o,
          mxfe3_gpio6_o} = {4{gpio_o[70]}};

  assign {mxfe0_gpio7_o,
          mxfe1_gpio7_o,
          mxfe2_gpio7_o,
          mxfe3_gpio7_o} = {4{gpio_o[71]}};

  assign {mxfe0_gpio8_o,
          mxfe1_gpio8_o,
          mxfe2_gpio8_o,
          mxfe3_gpio8_o} = {4{gpio_o[72]}};

  assign {mxfe0_gpio9_o,
          mxfe1_gpio9_o,
          mxfe2_gpio9_o,
          mxfe3_gpio9_o} = {4{gpio_o[73]}};

  assign {mxfe0_gpio10_o,
          mxfe1_gpio10_o,
          mxfe2_gpio10_o,
          mxfe3_gpio10_o} = {4{gpio_o[74]}};

  assign {mxfe0_syncin_1_n_o,
          mxfe1_syncin_1_n_o,
          mxfe2_syncin_1_n_o,
          mxfe3_syncin_1_n_o} = {4{gpio_o[75]}};

  assign {mxfe0_syncin_1_p_o,
          mxfe1_syncin_1_p_o,
          mxfe2_syncin_1_p_o,
          mxfe3_syncin_1_p_o} = {4{gpio_o[76]}};

  assign {mxfe0_syncout_1_n_o,
          mxfe1_syncout_1_n_o,
          mxfe2_syncout_1_n_o,
          mxfe3_syncout_1_n_o} = {4{gpio_o[77]}};

  assign {mxfe0_syncout_1_p_o,
          mxfe1_syncout_1_p_o,
          mxfe2_syncout_1_p_o,
          mxfe3_syncout_1_p_o} = {4{gpio_o[78]}};

  // GPIO inputs

  assign gpio_i[64] = gpio0_mode ? gpio_o[64] : |{mxfe0_gpio0_i,
                                                  mxfe1_gpio0_i,
                                                  mxfe2_gpio0_i,
                                                  mxfe3_gpio0_i};

  assign gpio_i[65] = |{mxfe0_gpio1_i,
                        mxfe1_gpio1_i,
                        mxfe2_gpio1_i,
                        mxfe3_gpio1_i};

  assign gpio_i[66] = |{mxfe0_gpio2_i,
                        mxfe1_gpio2_i,
                        mxfe2_gpio2_i,
                        mxfe3_gpio2_i};

  assign gpio_i[69] = |{mxfe0_gpio5_i,
                        mxfe1_gpio5_i,
                        mxfe2_gpio5_i,
                        mxfe3_gpio5_i};

  assign gpio_i[70] = |{mxfe0_gpio6_i,
                        mxfe1_gpio6_i,
                        mxfe2_gpio6_i,
                        mxfe3_gpio6_i};

  assign gpio_i[71] = |{mxfe0_gpio7_i,
                        mxfe1_gpio7_i,
                        mxfe2_gpio7_i,
                        mxfe3_gpio7_i};

  assign gpio_i[72] = |{mxfe0_gpio8_i,
                        mxfe1_gpio8_i,
                        mxfe2_gpio8_i,
                        mxfe3_gpio8_i};

  assign gpio_i[73] = |{mxfe0_gpio9_i,
                        mxfe1_gpio9_i,
                        mxfe2_gpio9_i,
                        mxfe3_gpio9_i};

  assign gpio_i[74] = |{mxfe0_gpio10_i,
                        mxfe1_gpio10_i,
                        mxfe2_gpio10_i,
                        mxfe3_gpio10_i};

  assign gpio_i[75] = |{mxfe0_syncin_1_n_i,
                        mxfe1_syncin_1_n_i,
                        mxfe2_syncin_1_n_i,
                        mxfe3_syncin_1_n_i};

  assign gpio_i[76] = |{mxfe0_syncin_1_p_i,
                        mxfe1_syncin_1_p_i,
                        mxfe2_syncin_1_p_i,
                        mxfe3_syncin_1_p_i};

  assign gpio_i[77] = |{mxfe0_syncout_1_n_i,
                        mxfe1_syncout_1_n_i,
                        mxfe2_syncout_1_n_i,
                        mxfe3_syncout_1_n_i};

  assign gpio_i[78] = |{mxfe0_syncout_1_p_i,
                        mxfe1_syncout_1_p_i,
                        mxfe2_syncout_1_p_i,
                        mxfe3_syncout_1_p_i};

  //loopback unused gpios
  assign gpio_i[68:67] = gpio_o[68:67];
  assign gpio_i[107:79] = gpio_o[107:79];

  // 0 - Software controlled GPIO
  // 1 - LMFC based Master-Slave NCO Sync
  assign gpio0_mode = gpio_o[108];

  //loopback unused gpios
  assign gpio_i[127:108] = gpio_o[127:108];

endmodule
