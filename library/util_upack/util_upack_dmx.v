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

module util_upack_dmx (

  // dac interface

  input             dac_clk,
  input   [  7:0]   dac_enable,
  output            dac_valid,
  output  [ 15:0]   dac_data_0,
  output  [ 15:0]   dac_data_1,
  output  [ 15:0]   dac_data_2,
  output  [ 15:0]   dac_data_3,
  output  [ 15:0]   dac_data_4,
  output  [ 15:0]   dac_data_5,
  output  [ 15:0]   dac_data_6,
  output  [ 15:0]   dac_data_7,

  // dmx interface

  output  [  7:0]   dac_dmx_enable,
  input             dac_dsf_valid,
  input   [127:0]   dac_dsf_data);

  // internal registers

  reg     [  7:0]   dac_dmx_enable_int = 'd0;
  reg               dac_valid_int = 'd0;
  reg               dac_valid_d2 = 'd0;
  reg               dac_valid_d1 = 'd0;
  reg     [ 15:0]   dac_data_int_0 = 'd0;
  reg     [ 15:0]   dac_data_int_1 = 'd0;
  reg     [ 15:0]   dac_data_int_2 = 'd0;
  reg     [ 15:0]   dac_data_int_3 = 'd0;
  reg     [ 15:0]   dac_data_int_4 = 'd0;
  reg     [ 15:0]   dac_data_int_5 = 'd0;
  reg     [ 15:0]   dac_data_int_6 = 'd0;
  reg     [ 15:0]   dac_data_int_7 = 'd0;
  reg               dac_dmx_enable_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_0 = 'd0;
  reg               dac_dmx_enable_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_1 = 'd0;
  reg               dac_dmx_enable_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_2 = 'd0;
  reg               dac_dmx_enable_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_3 = 'd0;
  reg               dac_dmx_enable_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_4 = 'd0;
  reg               dac_dmx_enable_5 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_5 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_5 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_5 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_5 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_5 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_5 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_5 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_5 = 'd0;
  reg               dac_dmx_enable_6 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_6 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_6 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_6 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_6 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_6 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_6 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_6 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_6 = 'd0;
  reg               dac_dmx_enable_7 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_7 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_7 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_7 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_7 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_7 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_7 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_7 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_7 = 'd0;
  reg               dac_dmx_enable_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_0_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_0_0 = 'd0;
  reg               dac_dmx_enable_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_1_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_1_0 = 'd0;
  reg               dac_dmx_enable_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_1_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_1_1 = 'd0;
  reg               dac_dmx_enable_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_2_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_2_0 = 'd0;
  reg               dac_dmx_enable_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_2_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_2_1 = 'd0;
  reg               dac_dmx_enable_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_2_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_2_2 = 'd0;
  reg               dac_dmx_enable_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_2_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_2_3 = 'd0;
  reg               dac_dmx_enable_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_3_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_3_0 = 'd0;
  reg               dac_dmx_enable_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_3_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_3_1 = 'd0;
  reg               dac_dmx_enable_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_3_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_3_2 = 'd0;
  reg               dac_dmx_enable_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_3_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_3_3 = 'd0;
  reg               dac_dmx_enable_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_3_4 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_3_4 = 'd0;
  reg               dac_dmx_enable_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_4_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_4_0 = 'd0;
  reg               dac_dmx_enable_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_4_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_4_1 = 'd0;
  reg               dac_dmx_enable_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_4_2 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_4_2 = 'd0;
  reg               dac_dmx_enable_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_4_3 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_4_3 = 'd0;
  reg               dac_dmx_enable_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_5_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_5_0 = 'd0;
  reg               dac_dmx_enable_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_5_1 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_5_1 = 'd0;
  reg               dac_dmx_enable_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_6_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_6_0 = 'd0;
  reg               dac_dmx_enable_7_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_0_7_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_1_7_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_2_7_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_3_7_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_4_7_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_5_7_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_6_7_0 = 'd0;
  reg     [ 15:0]   dac_dmx_data_7_7_0 = 'd0;

  // simple data or for pipe line registers

  assign dac_dmx_enable = dac_dmx_enable_int;
  assign dac_valid = dac_valid_int;
  assign dac_data_0 = dac_data_int_0;
  assign dac_data_1 = dac_data_int_1;
  assign dac_data_2 = dac_data_int_2;
  assign dac_data_3 = dac_data_int_3;
  assign dac_data_4 = dac_data_int_4;
  assign dac_data_5 = dac_data_int_5;
  assign dac_data_6 = dac_data_int_6;
  assign dac_data_7 = dac_data_int_7;

  always @(posedge dac_clk) begin
    dac_dmx_enable_int <= { dac_dmx_enable_7, dac_dmx_enable_6,
                            dac_dmx_enable_5, dac_dmx_enable_4,
                            dac_dmx_enable_3, dac_dmx_enable_2,
                            dac_dmx_enable_1, dac_dmx_enable_0};
  end

  always @(posedge dac_clk) begin
    dac_valid_int <= dac_valid_d2;
    dac_valid_d2 <= dac_valid_d1;
    dac_valid_d1 <= dac_dsf_valid;
  end

  always @(posedge dac_clk) begin
    dac_data_int_0 <= dac_dmx_data_0_0 | dac_dmx_data_0_1 |
                      dac_dmx_data_0_2 | dac_dmx_data_0_3 |
                      dac_dmx_data_0_4 | dac_dmx_data_0_5 |
                      dac_dmx_data_0_6 | dac_dmx_data_0_7;
    dac_data_int_1 <= dac_dmx_data_1_0 | dac_dmx_data_1_1 |
                      dac_dmx_data_1_2 | dac_dmx_data_1_3 |
                      dac_dmx_data_1_4 | dac_dmx_data_1_5 |
                      dac_dmx_data_1_6 | dac_dmx_data_1_7;
    dac_data_int_2 <= dac_dmx_data_2_0 | dac_dmx_data_2_1 |
                      dac_dmx_data_2_2 | dac_dmx_data_2_3 |
                      dac_dmx_data_2_4 | dac_dmx_data_2_5 |
                      dac_dmx_data_2_6 | dac_dmx_data_2_7;
    dac_data_int_3 <= dac_dmx_data_3_0 | dac_dmx_data_3_1 |
                      dac_dmx_data_3_2 | dac_dmx_data_3_3 |
                      dac_dmx_data_3_4 | dac_dmx_data_3_5 |
                      dac_dmx_data_3_6 | dac_dmx_data_3_7;
    dac_data_int_4 <= dac_dmx_data_4_0 | dac_dmx_data_4_1 |
                      dac_dmx_data_4_2 | dac_dmx_data_4_3 |
                      dac_dmx_data_4_4 | dac_dmx_data_4_5 |
                      dac_dmx_data_4_6 | dac_dmx_data_4_7;
    dac_data_int_5 <= dac_dmx_data_5_0 | dac_dmx_data_5_1 |
                      dac_dmx_data_5_2 | dac_dmx_data_5_3 |
                      dac_dmx_data_5_4 | dac_dmx_data_5_5 |
                      dac_dmx_data_5_6 | dac_dmx_data_5_7;
    dac_data_int_6 <= dac_dmx_data_6_0 | dac_dmx_data_6_1 |
                      dac_dmx_data_6_2 | dac_dmx_data_6_3 |
                      dac_dmx_data_6_4 | dac_dmx_data_6_5 |
                      dac_dmx_data_6_6 | dac_dmx_data_6_7;
    dac_data_int_7 <= dac_dmx_data_7_0 | dac_dmx_data_7_1 |
                      dac_dmx_data_7_2 | dac_dmx_data_7_3 |
                      dac_dmx_data_7_4 | dac_dmx_data_7_5 |
                      dac_dmx_data_7_6 | dac_dmx_data_7_7;
  end

  always @(posedge dac_clk) begin
    dac_dmx_enable_0 <= dac_dmx_enable_0_0;
    dac_dmx_data_0_0 <= dac_dmx_data_0_0_0;
    dac_dmx_data_1_0 <= dac_dmx_data_1_0_0;
    dac_dmx_data_2_0 <= dac_dmx_data_2_0_0;
    dac_dmx_data_3_0 <= dac_dmx_data_3_0_0;
    dac_dmx_data_4_0 <= dac_dmx_data_4_0_0;
    dac_dmx_data_5_0 <= dac_dmx_data_5_0_0;
    dac_dmx_data_6_0 <= dac_dmx_data_6_0_0;
    dac_dmx_data_7_0 <= dac_dmx_data_7_0_0;
    dac_dmx_enable_1 <= dac_dmx_enable_1_0 | dac_dmx_enable_1_1;
    dac_dmx_data_0_1 <= dac_dmx_data_0_1_0 | dac_dmx_data_0_1_1;
    dac_dmx_data_1_1 <= dac_dmx_data_1_1_0 | dac_dmx_data_1_1_1;
    dac_dmx_data_2_1 <= dac_dmx_data_2_1_0 | dac_dmx_data_2_1_1;
    dac_dmx_data_3_1 <= dac_dmx_data_3_1_0 | dac_dmx_data_3_1_1;
    dac_dmx_data_4_1 <= dac_dmx_data_4_1_0 | dac_dmx_data_4_1_1;
    dac_dmx_data_5_1 <= dac_dmx_data_5_1_0 | dac_dmx_data_5_1_1;
    dac_dmx_data_6_1 <= dac_dmx_data_6_1_0 | dac_dmx_data_6_1_1;
    dac_dmx_data_7_1 <= dac_dmx_data_7_1_0 | dac_dmx_data_7_1_1;
    dac_dmx_enable_2 <= dac_dmx_enable_2_0 | dac_dmx_enable_2_1 |
                        dac_dmx_enable_2_2 | dac_dmx_enable_2_3;
    dac_dmx_data_0_2 <= dac_dmx_data_0_2_0 | dac_dmx_data_0_2_1 |
                        dac_dmx_data_0_2_2 | dac_dmx_data_0_2_3;
    dac_dmx_data_1_2 <= dac_dmx_data_1_2_0 | dac_dmx_data_1_2_1 |
                        dac_dmx_data_1_2_2 | dac_dmx_data_1_2_3;
    dac_dmx_data_2_2 <= dac_dmx_data_2_2_0 | dac_dmx_data_2_2_1 |
                        dac_dmx_data_2_2_2 | dac_dmx_data_2_2_3;
    dac_dmx_data_3_2 <= dac_dmx_data_3_2_0 | dac_dmx_data_3_2_1 |
                        dac_dmx_data_3_2_2 | dac_dmx_data_3_2_3;
    dac_dmx_data_4_2 <= dac_dmx_data_4_2_0 | dac_dmx_data_4_2_1 |
                        dac_dmx_data_4_2_2 | dac_dmx_data_4_2_3;
    dac_dmx_data_5_2 <= dac_dmx_data_5_2_0 | dac_dmx_data_5_2_1 |
                        dac_dmx_data_5_2_2 | dac_dmx_data_5_2_3;
    dac_dmx_data_6_2 <= dac_dmx_data_6_2_0 | dac_dmx_data_6_2_1 |
                        dac_dmx_data_6_2_2 | dac_dmx_data_6_2_3;
    dac_dmx_data_7_2 <= dac_dmx_data_7_2_0 | dac_dmx_data_7_2_1 |
                        dac_dmx_data_7_2_2 | dac_dmx_data_7_2_3;
    dac_dmx_enable_3 <= dac_dmx_enable_3_0 | dac_dmx_enable_3_1 |
                        dac_dmx_enable_3_2 | dac_dmx_enable_3_3 |
                        dac_dmx_enable_3_4;
    dac_dmx_data_0_3 <= dac_dmx_data_0_3_0 | dac_dmx_data_0_3_1 |
                        dac_dmx_data_0_3_2 | dac_dmx_data_0_3_3 |
                        dac_dmx_data_0_3_4;
    dac_dmx_data_1_3 <= dac_dmx_data_1_3_0 | dac_dmx_data_1_3_1 |
                        dac_dmx_data_1_3_2 | dac_dmx_data_1_3_3 |
                        dac_dmx_data_1_3_4;
    dac_dmx_data_2_3 <= dac_dmx_data_2_3_0 | dac_dmx_data_2_3_1 |
                        dac_dmx_data_2_3_2 | dac_dmx_data_2_3_3 |
                        dac_dmx_data_2_3_4;
    dac_dmx_data_3_3 <= dac_dmx_data_3_3_0 | dac_dmx_data_3_3_1 |
                        dac_dmx_data_3_3_2 | dac_dmx_data_3_3_3 |
                        dac_dmx_data_3_3_4;
    dac_dmx_data_4_3 <= dac_dmx_data_4_3_0 | dac_dmx_data_4_3_1 |
                        dac_dmx_data_4_3_2 | dac_dmx_data_4_3_3 |
                        dac_dmx_data_4_3_4;
    dac_dmx_data_5_3 <= dac_dmx_data_5_3_0 | dac_dmx_data_5_3_1 |
                        dac_dmx_data_5_3_2 | dac_dmx_data_5_3_3 |
                        dac_dmx_data_5_3_4;
    dac_dmx_data_6_3 <= dac_dmx_data_6_3_0 | dac_dmx_data_6_3_1 |
                        dac_dmx_data_6_3_2 | dac_dmx_data_6_3_3 |
                        dac_dmx_data_6_3_4;
    dac_dmx_data_7_3 <= dac_dmx_data_7_3_0 | dac_dmx_data_7_3_1 |
                        dac_dmx_data_7_3_2 | dac_dmx_data_7_3_3 |
                        dac_dmx_data_7_3_4;
    dac_dmx_enable_4 <= dac_dmx_enable_4_0 | dac_dmx_enable_4_1 |
                        dac_dmx_enable_4_2 | dac_dmx_enable_4_3;
    dac_dmx_data_0_4 <= dac_dmx_data_0_4_0 | dac_dmx_data_0_4_1 |
                        dac_dmx_data_0_4_2 | dac_dmx_data_0_4_3;
    dac_dmx_data_1_4 <= dac_dmx_data_1_4_0 | dac_dmx_data_1_4_1 |
                        dac_dmx_data_1_4_2 | dac_dmx_data_1_4_3;
    dac_dmx_data_2_4 <= dac_dmx_data_2_4_0 | dac_dmx_data_2_4_1 |
                        dac_dmx_data_2_4_2 | dac_dmx_data_2_4_3;
    dac_dmx_data_3_4 <= dac_dmx_data_3_4_0 | dac_dmx_data_3_4_1 |
                        dac_dmx_data_3_4_2 | dac_dmx_data_3_4_3;
    dac_dmx_data_4_4 <= dac_dmx_data_4_4_0 | dac_dmx_data_4_4_1 |
                        dac_dmx_data_4_4_2 | dac_dmx_data_4_4_3;
    dac_dmx_data_5_4 <= dac_dmx_data_5_4_0 | dac_dmx_data_5_4_1 |
                        dac_dmx_data_5_4_2 | dac_dmx_data_5_4_3;
    dac_dmx_data_6_4 <= dac_dmx_data_6_4_0 | dac_dmx_data_6_4_1 |
                        dac_dmx_data_6_4_2 | dac_dmx_data_6_4_3;
    dac_dmx_data_7_4 <= dac_dmx_data_7_4_0 | dac_dmx_data_7_4_1 |
                        dac_dmx_data_7_4_2 | dac_dmx_data_7_4_3;
    dac_dmx_enable_5 <= dac_dmx_enable_5_0 | dac_dmx_enable_5_1;
    dac_dmx_data_0_5 <= dac_dmx_data_0_5_0 | dac_dmx_data_0_5_1;
    dac_dmx_data_1_5 <= dac_dmx_data_1_5_0 | dac_dmx_data_1_5_1;
    dac_dmx_data_2_5 <= dac_dmx_data_2_5_0 | dac_dmx_data_2_5_1;
    dac_dmx_data_3_5 <= dac_dmx_data_3_5_0 | dac_dmx_data_3_5_1;
    dac_dmx_data_4_5 <= dac_dmx_data_4_5_0 | dac_dmx_data_4_5_1;
    dac_dmx_data_5_5 <= dac_dmx_data_5_5_0 | dac_dmx_data_5_5_1;
    dac_dmx_data_6_5 <= dac_dmx_data_6_5_0 | dac_dmx_data_6_5_1;
    dac_dmx_data_7_5 <= dac_dmx_data_7_5_0 | dac_dmx_data_7_5_1;
    dac_dmx_enable_6 <= dac_dmx_enable_6_0;
    dac_dmx_data_0_6 <= dac_dmx_data_0_6_0;
    dac_dmx_data_1_6 <= dac_dmx_data_1_6_0;
    dac_dmx_data_2_6 <= dac_dmx_data_2_6_0;
    dac_dmx_data_3_6 <= dac_dmx_data_3_6_0;
    dac_dmx_data_4_6 <= dac_dmx_data_4_6_0;
    dac_dmx_data_5_6 <= dac_dmx_data_5_6_0;
    dac_dmx_data_6_6 <= dac_dmx_data_6_6_0;
    dac_dmx_data_7_6 <= dac_dmx_data_7_6_0;
    dac_dmx_enable_7 <= dac_dmx_enable_7_0;
    dac_dmx_data_0_7 <= dac_dmx_data_0_7_0;
    dac_dmx_data_1_7 <= dac_dmx_data_1_7_0;
    dac_dmx_data_2_7 <= dac_dmx_data_2_7_0;
    dac_dmx_data_3_7 <= dac_dmx_data_3_7_0;
    dac_dmx_data_4_7 <= dac_dmx_data_4_7_0;
    dac_dmx_data_5_7 <= dac_dmx_data_5_7_0;
    dac_dmx_data_6_7 <= dac_dmx_data_6_7_0;
    dac_dmx_data_7_7 <= dac_dmx_data_7_7_0;
  end

  // mux below is generated using a script-- do not modify-- ask me first!

  // 1 channel(s)

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b00000001: begin
        dac_dmx_enable_0_0 <= 1'b1;
        dac_dmx_data_0_0_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_0_0 <= 'd0;
        dac_dmx_data_2_0_0 <= 'd0;
        dac_dmx_data_3_0_0 <= 'd0;
        dac_dmx_data_4_0_0 <= 'd0;
        dac_dmx_data_5_0_0 <= 'd0;
        dac_dmx_data_6_0_0 <= 'd0;
        dac_dmx_data_7_0_0 <= 'd0;
      end
      8'b00000010: begin
        dac_dmx_enable_0_0 <= 1'b1;
        dac_dmx_data_0_0_0 <= 'd0;
        dac_dmx_data_1_0_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_0_0 <= 'd0;
        dac_dmx_data_3_0_0 <= 'd0;
        dac_dmx_data_4_0_0 <= 'd0;
        dac_dmx_data_5_0_0 <= 'd0;
        dac_dmx_data_6_0_0 <= 'd0;
        dac_dmx_data_7_0_0 <= 'd0;
      end
      8'b00000100: begin
        dac_dmx_enable_0_0 <= 1'b1;
        dac_dmx_data_0_0_0 <= 'd0;
        dac_dmx_data_1_0_0 <= 'd0;
        dac_dmx_data_2_0_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_0_0 <= 'd0;
        dac_dmx_data_4_0_0 <= 'd0;
        dac_dmx_data_5_0_0 <= 'd0;
        dac_dmx_data_6_0_0 <= 'd0;
        dac_dmx_data_7_0_0 <= 'd0;
      end
      8'b00001000: begin
        dac_dmx_enable_0_0 <= 1'b1;
        dac_dmx_data_0_0_0 <= 'd0;
        dac_dmx_data_1_0_0 <= 'd0;
        dac_dmx_data_2_0_0 <= 'd0;
        dac_dmx_data_3_0_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_0_0 <= 'd0;
        dac_dmx_data_5_0_0 <= 'd0;
        dac_dmx_data_6_0_0 <= 'd0;
        dac_dmx_data_7_0_0 <= 'd0;
      end
      8'b00010000: begin
        dac_dmx_enable_0_0 <= 1'b1;
        dac_dmx_data_0_0_0 <= 'd0;
        dac_dmx_data_1_0_0 <= 'd0;
        dac_dmx_data_2_0_0 <= 'd0;
        dac_dmx_data_3_0_0 <= 'd0;
        dac_dmx_data_4_0_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_5_0_0 <= 'd0;
        dac_dmx_data_6_0_0 <= 'd0;
        dac_dmx_data_7_0_0 <= 'd0;
      end
      8'b00100000: begin
        dac_dmx_enable_0_0 <= 1'b1;
        dac_dmx_data_0_0_0 <= 'd0;
        dac_dmx_data_1_0_0 <= 'd0;
        dac_dmx_data_2_0_0 <= 'd0;
        dac_dmx_data_3_0_0 <= 'd0;
        dac_dmx_data_4_0_0 <= 'd0;
        dac_dmx_data_5_0_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_6_0_0 <= 'd0;
        dac_dmx_data_7_0_0 <= 'd0;
      end
      8'b01000000: begin
        dac_dmx_enable_0_0 <= 1'b1;
        dac_dmx_data_0_0_0 <= 'd0;
        dac_dmx_data_1_0_0 <= 'd0;
        dac_dmx_data_2_0_0 <= 'd0;
        dac_dmx_data_3_0_0 <= 'd0;
        dac_dmx_data_4_0_0 <= 'd0;
        dac_dmx_data_5_0_0 <= 'd0;
        dac_dmx_data_6_0_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_7_0_0 <= 'd0;
      end
      8'b10000000: begin
        dac_dmx_enable_0_0 <= 1'b1;
        dac_dmx_data_0_0_0 <= 'd0;
        dac_dmx_data_1_0_0 <= 'd0;
        dac_dmx_data_2_0_0 <= 'd0;
        dac_dmx_data_3_0_0 <= 'd0;
        dac_dmx_data_4_0_0 <= 'd0;
        dac_dmx_data_5_0_0 <= 'd0;
        dac_dmx_data_6_0_0 <= 'd0;
        dac_dmx_data_7_0_0 <= dac_dsf_data[((16*0)+15):(16*0)];
      end
      default: begin
        dac_dmx_enable_0_0 <= 'd0;
        dac_dmx_data_0_0_0 <= 'd0;
        dac_dmx_data_1_0_0 <= 'd0;
        dac_dmx_data_2_0_0 <= 'd0;
        dac_dmx_data_3_0_0 <= 'd0;
        dac_dmx_data_4_0_0 <= 'd0;
        dac_dmx_data_5_0_0 <= 'd0;
        dac_dmx_data_6_0_0 <= 'd0;
        dac_dmx_data_7_0_0 <= 'd0;
      end
    endcase
  end

  // 2 channel(s)

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b00000011: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00000101: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00000110: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00001001: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00001010: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00001100: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00010001: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00010010: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00010100: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00011000: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00100001: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00100010: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00100100: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00101000: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b00110000: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_5_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
      8'b01000001: begin
        dac_dmx_enable_1_0 <= 1'b1;
        dac_dmx_data_0_1_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_1_0 <= 'd0;
      end
      default: begin
        dac_dmx_enable_1_0 <= 'd0;
        dac_dmx_data_0_1_0 <= 'd0;
        dac_dmx_data_1_1_0 <= 'd0;
        dac_dmx_data_2_1_0 <= 'd0;
        dac_dmx_data_3_1_0 <= 'd0;
        dac_dmx_data_4_1_0 <= 'd0;
        dac_dmx_data_5_1_0 <= 'd0;
        dac_dmx_data_6_1_0 <= 'd0;
        dac_dmx_data_7_1_0 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b01000010: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_1_1 <= 'd0;
      end
      8'b01000100: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_1_1 <= 'd0;
      end
      8'b01001000: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_1_1 <= 'd0;
      end
      8'b01010000: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_1_1 <= 'd0;
      end
      8'b01100000: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_6_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_1_1 <= 'd0;
      end
      8'b10000001: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= 'd0;
        dac_dmx_data_7_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
      end
      8'b10000010: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= 'd0;
        dac_dmx_data_7_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
      end
      8'b10000100: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= 'd0;
        dac_dmx_data_7_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
      end
      8'b10001000: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= 'd0;
        dac_dmx_data_7_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
      end
      8'b10010000: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= 'd0;
        dac_dmx_data_7_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
      end
      8'b10100000: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_6_1_1 <= 'd0;
        dac_dmx_data_7_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
      end
      8'b11000000: begin
        dac_dmx_enable_1_1 <= 1'b1;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_7_1_1 <= dac_dsf_data[((16*1)+15):(16*1)];
      end
      default: begin
        dac_dmx_enable_1_1 <= 'd0;
        dac_dmx_data_0_1_1 <= 'd0;
        dac_dmx_data_1_1_1 <= 'd0;
        dac_dmx_data_2_1_1 <= 'd0;
        dac_dmx_data_3_1_1 <= 'd0;
        dac_dmx_data_4_1_1 <= 'd0;
        dac_dmx_data_5_1_1 <= 'd0;
        dac_dmx_data_6_1_1 <= 'd0;
        dac_dmx_data_7_1_1 <= 'd0;
      end
    endcase
  end

  // 3 channel(s)

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b00000111: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_2_0 <= 'd0;
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00001011: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_2_0 <= 'd0;
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00001101: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= 'd0;
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00001110: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= 'd0;
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00010011: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_2_0 <= 'd0;
        dac_dmx_data_3_2_0 <= 'd0;
        dac_dmx_data_4_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00010101: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= 'd0;
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_0 <= 'd0;
        dac_dmx_data_4_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00010110: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= 'd0;
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_0 <= 'd0;
        dac_dmx_data_4_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00011001: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= 'd0;
        dac_dmx_data_2_2_0 <= 'd0;
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00011010: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= 'd0;
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_0 <= 'd0;
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00011100: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= 'd0;
        dac_dmx_data_1_2_0 <= 'd0;
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00100011: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_2_0 <= 'd0;
        dac_dmx_data_3_2_0 <= 'd0;
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00100101: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= 'd0;
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_0 <= 'd0;
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00100110: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= 'd0;
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_0 <= 'd0;
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00101001: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_0 <= 'd0;
        dac_dmx_data_2_2_0 <= 'd0;
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00101010: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= 'd0;
        dac_dmx_data_1_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_0 <= 'd0;
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      8'b00101100: begin
        dac_dmx_enable_2_0 <= 1'b1;
        dac_dmx_data_0_2_0 <= 'd0;
        dac_dmx_data_1_2_0 <= 'd0;
        dac_dmx_data_2_2_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
      default: begin
        dac_dmx_enable_2_0 <= 'd0;
        dac_dmx_data_0_2_0 <= 'd0;
        dac_dmx_data_1_2_0 <= 'd0;
        dac_dmx_data_2_2_0 <= 'd0;
        dac_dmx_data_3_2_0 <= 'd0;
        dac_dmx_data_4_2_0 <= 'd0;
        dac_dmx_data_5_2_0 <= 'd0;
        dac_dmx_data_6_2_0 <= 'd0;
        dac_dmx_data_7_2_0 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b00110001: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_1 <= 'd0;
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b00110010: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_1 <= 'd0;
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b00110100: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_1 <= 'd0;
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b00111000: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_2_1 <= 'd0;
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01000011: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01000101: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01000110: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01001001: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01001010: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01001100: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01010001: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01010010: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01010100: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01011000: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01100001: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      8'b01100010: begin
        dac_dmx_enable_2_1 <= 1'b1;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_1 <= 'd0;
      end
      default: begin
        dac_dmx_enable_2_1 <= 'd0;
        dac_dmx_data_0_2_1 <= 'd0;
        dac_dmx_data_1_2_1 <= 'd0;
        dac_dmx_data_2_2_1 <= 'd0;
        dac_dmx_data_3_2_1 <= 'd0;
        dac_dmx_data_4_2_1 <= 'd0;
        dac_dmx_data_5_2_1 <= 'd0;
        dac_dmx_data_6_2_1 <= 'd0;
        dac_dmx_data_7_2_1 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b01100100: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_2 <= 'd0;
      end
      8'b01101000: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_2 <= 'd0;
      end
      8'b01110000: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_5_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_2_2 <= 'd0;
      end
      8'b10000011: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10000101: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10000110: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10001001: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10001010: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10001100: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10010001: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10010010: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10010100: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10011000: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10100001: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10100010: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10100100: begin
        dac_dmx_enable_2_2 <= 1'b1;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      default: begin
        dac_dmx_enable_2_2 <= 'd0;
        dac_dmx_data_0_2_2 <= 'd0;
        dac_dmx_data_1_2_2 <= 'd0;
        dac_dmx_data_2_2_2 <= 'd0;
        dac_dmx_data_3_2_2 <= 'd0;
        dac_dmx_data_4_2_2 <= 'd0;
        dac_dmx_data_5_2_2 <= 'd0;
        dac_dmx_data_6_2_2 <= 'd0;
        dac_dmx_data_7_2_2 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b10101000: begin
        dac_dmx_enable_2_3 <= 1'b1;
        dac_dmx_data_0_2_3 <= 'd0;
        dac_dmx_data_1_2_3 <= 'd0;
        dac_dmx_data_2_2_3 <= 'd0;
        dac_dmx_data_3_2_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_2_3 <= 'd0;
        dac_dmx_data_5_2_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_3 <= 'd0;
        dac_dmx_data_7_2_3 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b10110000: begin
        dac_dmx_enable_2_3 <= 1'b1;
        dac_dmx_data_0_2_3 <= 'd0;
        dac_dmx_data_1_2_3 <= 'd0;
        dac_dmx_data_2_2_3 <= 'd0;
        dac_dmx_data_3_2_3 <= 'd0;
        dac_dmx_data_4_2_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_5_2_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_2_3 <= 'd0;
        dac_dmx_data_7_2_3 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b11000001: begin
        dac_dmx_enable_2_3 <= 1'b1;
        dac_dmx_data_0_2_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_2_3 <= 'd0;
        dac_dmx_data_2_2_3 <= 'd0;
        dac_dmx_data_3_2_3 <= 'd0;
        dac_dmx_data_4_2_3 <= 'd0;
        dac_dmx_data_5_2_3 <= 'd0;
        dac_dmx_data_6_2_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_2_3 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b11000010: begin
        dac_dmx_enable_2_3 <= 1'b1;
        dac_dmx_data_0_2_3 <= 'd0;
        dac_dmx_data_1_2_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_2_3 <= 'd0;
        dac_dmx_data_3_2_3 <= 'd0;
        dac_dmx_data_4_2_3 <= 'd0;
        dac_dmx_data_5_2_3 <= 'd0;
        dac_dmx_data_6_2_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_2_3 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b11000100: begin
        dac_dmx_enable_2_3 <= 1'b1;
        dac_dmx_data_0_2_3 <= 'd0;
        dac_dmx_data_1_2_3 <= 'd0;
        dac_dmx_data_2_2_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_2_3 <= 'd0;
        dac_dmx_data_4_2_3 <= 'd0;
        dac_dmx_data_5_2_3 <= 'd0;
        dac_dmx_data_6_2_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_2_3 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b11001000: begin
        dac_dmx_enable_2_3 <= 1'b1;
        dac_dmx_data_0_2_3 <= 'd0;
        dac_dmx_data_1_2_3 <= 'd0;
        dac_dmx_data_2_2_3 <= 'd0;
        dac_dmx_data_3_2_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_2_3 <= 'd0;
        dac_dmx_data_5_2_3 <= 'd0;
        dac_dmx_data_6_2_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_2_3 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b11010000: begin
        dac_dmx_enable_2_3 <= 1'b1;
        dac_dmx_data_0_2_3 <= 'd0;
        dac_dmx_data_1_2_3 <= 'd0;
        dac_dmx_data_2_2_3 <= 'd0;
        dac_dmx_data_3_2_3 <= 'd0;
        dac_dmx_data_4_2_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_5_2_3 <= 'd0;
        dac_dmx_data_6_2_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_2_3 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      8'b11100000: begin
        dac_dmx_enable_2_3 <= 1'b1;
        dac_dmx_data_0_2_3 <= 'd0;
        dac_dmx_data_1_2_3 <= 'd0;
        dac_dmx_data_2_2_3 <= 'd0;
        dac_dmx_data_3_2_3 <= 'd0;
        dac_dmx_data_4_2_3 <= 'd0;
        dac_dmx_data_5_2_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_6_2_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_7_2_3 <= dac_dsf_data[((16*2)+15):(16*2)];
      end
      default: begin
        dac_dmx_enable_2_3 <= 'd0;
        dac_dmx_data_0_2_3 <= 'd0;
        dac_dmx_data_1_2_3 <= 'd0;
        dac_dmx_data_2_2_3 <= 'd0;
        dac_dmx_data_3_2_3 <= 'd0;
        dac_dmx_data_4_2_3 <= 'd0;
        dac_dmx_data_5_2_3 <= 'd0;
        dac_dmx_data_6_2_3 <= 'd0;
        dac_dmx_data_7_2_3 <= 'd0;
      end
    endcase
  end

  // 4 channel(s)

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b00001111: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_3_0 <= 'd0;
        dac_dmx_data_5_3_0 <= 'd0;
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00010111: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_3_0 <= 'd0;
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_3_0 <= 'd0;
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00011011: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_0 <= 'd0;
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_3_0 <= 'd0;
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00011101: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= 'd0;
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_3_0 <= 'd0;
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00011110: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= 'd0;
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_3_0 <= 'd0;
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00100111: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_3_0 <= 'd0;
        dac_dmx_data_4_3_0 <= 'd0;
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00101011: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_0 <= 'd0;
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_0 <= 'd0;
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00101101: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= 'd0;
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_0 <= 'd0;
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00101110: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= 'd0;
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_0 <= 'd0;
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00110011: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_0 <= 'd0;
        dac_dmx_data_3_3_0 <= 'd0;
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00110101: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= 'd0;
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_0 <= 'd0;
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00110110: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= 'd0;
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_0 <= 'd0;
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00111001: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= 'd0;
        dac_dmx_data_2_3_0 <= 'd0;
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00111010: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= 'd0;
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_0 <= 'd0;
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b00111100: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= 'd0;
        dac_dmx_data_1_3_0 <= 'd0;
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
      8'b01000111: begin
        dac_dmx_enable_3_0 <= 1'b1;
        dac_dmx_data_0_3_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_3_0 <= 'd0;
        dac_dmx_data_4_3_0 <= 'd0;
        dac_dmx_data_5_3_0 <= 'd0;
        dac_dmx_data_6_3_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_0 <= 'd0;
      end
      default: begin
        dac_dmx_enable_3_0 <= 'd0;
        dac_dmx_data_0_3_0 <= 'd0;
        dac_dmx_data_1_3_0 <= 'd0;
        dac_dmx_data_2_3_0 <= 'd0;
        dac_dmx_data_3_3_0 <= 'd0;
        dac_dmx_data_4_3_0 <= 'd0;
        dac_dmx_data_5_3_0 <= 'd0;
        dac_dmx_data_6_3_0 <= 'd0;
        dac_dmx_data_7_3_0 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b01001011: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01001101: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01001110: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= 'd0;
        dac_dmx_data_1_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01010011: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= 'd0;
        dac_dmx_data_4_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01010101: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_1 <= 'd0;
        dac_dmx_data_4_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01010110: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= 'd0;
        dac_dmx_data_1_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_1 <= 'd0;
        dac_dmx_data_4_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01011001: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01011010: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= 'd0;
        dac_dmx_data_1_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01011100: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= 'd0;
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01100011: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= 'd0;
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01100101: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_1 <= 'd0;
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01100110: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= 'd0;
        dac_dmx_data_1_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_1 <= 'd0;
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01101001: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01101010: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= 'd0;
        dac_dmx_data_1_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01101100: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= 'd0;
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      8'b01110001: begin
        dac_dmx_enable_3_1 <= 1'b1;
        dac_dmx_data_0_3_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= 'd0;
        dac_dmx_data_4_3_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_1 <= 'd0;
      end
      default: begin
        dac_dmx_enable_3_1 <= 'd0;
        dac_dmx_data_0_3_1 <= 'd0;
        dac_dmx_data_1_3_1 <= 'd0;
        dac_dmx_data_2_3_1 <= 'd0;
        dac_dmx_data_3_3_1 <= 'd0;
        dac_dmx_data_4_3_1 <= 'd0;
        dac_dmx_data_5_3_1 <= 'd0;
        dac_dmx_data_6_3_1 <= 'd0;
        dac_dmx_data_7_3_1 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b01110010: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_2 <= 'd0;
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_2 <= 'd0;
      end
      8'b01110100: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= 'd0;
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_2 <= 'd0;
      end
      8'b01111000: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= 'd0;
        dac_dmx_data_2_3_2 <= 'd0;
        dac_dmx_data_3_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_3_2 <= 'd0;
      end
      8'b10000111: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= 'd0;
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10001011: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_2 <= 'd0;
        dac_dmx_data_3_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_2 <= 'd0;
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10001101: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_2 <= 'd0;
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_2 <= 'd0;
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10001110: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_3_2 <= 'd0;
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10010011: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_2 <= 'd0;
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10010101: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_2 <= 'd0;
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10010110: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10011001: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_2 <= 'd0;
        dac_dmx_data_2_3_2 <= 'd0;
        dac_dmx_data_3_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10011010: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_2 <= 'd0;
        dac_dmx_data_3_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10011100: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= 'd0;
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10100011: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_2 <= 'd0;
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= 'd0;
        dac_dmx_data_5_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10100101: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_2 <= 'd0;
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= 'd0;
        dac_dmx_data_5_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10100110: begin
        dac_dmx_enable_3_2 <= 1'b1;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= 'd0;
        dac_dmx_data_5_3_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      default: begin
        dac_dmx_enable_3_2 <= 'd0;
        dac_dmx_data_0_3_2 <= 'd0;
        dac_dmx_data_1_3_2 <= 'd0;
        dac_dmx_data_2_3_2 <= 'd0;
        dac_dmx_data_3_3_2 <= 'd0;
        dac_dmx_data_4_3_2 <= 'd0;
        dac_dmx_data_5_3_2 <= 'd0;
        dac_dmx_data_6_3_2 <= 'd0;
        dac_dmx_data_7_3_2 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b10101001: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_3 <= 'd0;
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10101010: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_3 <= 'd0;
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10101100: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_3 <= 'd0;
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10110001: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_3 <= 'd0;
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10110010: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_3 <= 'd0;
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10110100: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_3 <= 'd0;
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b10111000: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_3_3 <= 'd0;
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11000011: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11000101: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11000110: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11001001: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11001010: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11001100: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11010001: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11010010: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11010100: begin
        dac_dmx_enable_3_3 <= 1'b1;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_3 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      default: begin
        dac_dmx_enable_3_3 <= 'd0;
        dac_dmx_data_0_3_3 <= 'd0;
        dac_dmx_data_1_3_3 <= 'd0;
        dac_dmx_data_2_3_3 <= 'd0;
        dac_dmx_data_3_3_3 <= 'd0;
        dac_dmx_data_4_3_3 <= 'd0;
        dac_dmx_data_5_3_3 <= 'd0;
        dac_dmx_data_6_3_3 <= 'd0;
        dac_dmx_data_7_3_3 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b11011000: begin
        dac_dmx_enable_3_4 <= 1'b1;
        dac_dmx_data_0_3_4 <= 'd0;
        dac_dmx_data_1_3_4 <= 'd0;
        dac_dmx_data_2_3_4 <= 'd0;
        dac_dmx_data_3_3_4 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_3_4 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_3_4 <= 'd0;
        dac_dmx_data_6_3_4 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_4 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11100001: begin
        dac_dmx_enable_3_4 <= 1'b1;
        dac_dmx_data_0_3_4 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_3_4 <= 'd0;
        dac_dmx_data_2_3_4 <= 'd0;
        dac_dmx_data_3_3_4 <= 'd0;
        dac_dmx_data_4_3_4 <= 'd0;
        dac_dmx_data_5_3_4 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_3_4 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_4 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11100010: begin
        dac_dmx_enable_3_4 <= 1'b1;
        dac_dmx_data_0_3_4 <= 'd0;
        dac_dmx_data_1_3_4 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_3_4 <= 'd0;
        dac_dmx_data_3_3_4 <= 'd0;
        dac_dmx_data_4_3_4 <= 'd0;
        dac_dmx_data_5_3_4 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_3_4 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_4 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11100100: begin
        dac_dmx_enable_3_4 <= 1'b1;
        dac_dmx_data_0_3_4 <= 'd0;
        dac_dmx_data_1_3_4 <= 'd0;
        dac_dmx_data_2_3_4 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_3_4 <= 'd0;
        dac_dmx_data_4_3_4 <= 'd0;
        dac_dmx_data_5_3_4 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_3_4 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_4 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11101000: begin
        dac_dmx_enable_3_4 <= 1'b1;
        dac_dmx_data_0_3_4 <= 'd0;
        dac_dmx_data_1_3_4 <= 'd0;
        dac_dmx_data_2_3_4 <= 'd0;
        dac_dmx_data_3_3_4 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_3_4 <= 'd0;
        dac_dmx_data_5_3_4 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_3_4 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_4 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      8'b11110000: begin
        dac_dmx_enable_3_4 <= 1'b1;
        dac_dmx_data_0_3_4 <= 'd0;
        dac_dmx_data_1_3_4 <= 'd0;
        dac_dmx_data_2_3_4 <= 'd0;
        dac_dmx_data_3_3_4 <= 'd0;
        dac_dmx_data_4_3_4 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_5_3_4 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_6_3_4 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_7_3_4 <= dac_dsf_data[((16*3)+15):(16*3)];
      end
      default: begin
        dac_dmx_enable_3_4 <= 'd0;
        dac_dmx_data_0_3_4 <= 'd0;
        dac_dmx_data_1_3_4 <= 'd0;
        dac_dmx_data_2_3_4 <= 'd0;
        dac_dmx_data_3_3_4 <= 'd0;
        dac_dmx_data_4_3_4 <= 'd0;
        dac_dmx_data_5_3_4 <= 'd0;
        dac_dmx_data_6_3_4 <= 'd0;
        dac_dmx_data_7_3_4 <= 'd0;
      end
    endcase
  end

  // 5 channel(s)

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b00011111: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_5_4_0 <= 'd0;
        dac_dmx_data_6_4_0 <= 'd0;
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b00101111: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_4_0 <= 'd0;
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_4_0 <= 'd0;
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b00110111: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_0 <= 'd0;
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_4_0 <= 'd0;
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b00111011: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= 'd0;
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_4_0 <= 'd0;
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b00111101: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= 'd0;
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_4_0 <= 'd0;
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b00111110: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= 'd0;
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_4_0 <= 'd0;
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01001111: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_4_0 <= 'd0;
        dac_dmx_data_5_4_0 <= 'd0;
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01010111: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_0 <= 'd0;
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_0 <= 'd0;
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01011011: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= 'd0;
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_0 <= 'd0;
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01011101: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= 'd0;
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_0 <= 'd0;
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01011110: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= 'd0;
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_0 <= 'd0;
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01100111: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_0 <= 'd0;
        dac_dmx_data_4_4_0 <= 'd0;
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01101011: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= 'd0;
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= 'd0;
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01101101: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= 'd0;
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= 'd0;
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01101110: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= 'd0;
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_0 <= 'd0;
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      8'b01110011: begin
        dac_dmx_enable_4_0 <= 1'b1;
        dac_dmx_data_0_4_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_0 <= 'd0;
        dac_dmx_data_3_4_0 <= 'd0;
        dac_dmx_data_4_4_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_0 <= 'd0;
      end
      default: begin
        dac_dmx_enable_4_0 <= 'd0;
        dac_dmx_data_0_4_0 <= 'd0;
        dac_dmx_data_1_4_0 <= 'd0;
        dac_dmx_data_2_4_0 <= 'd0;
        dac_dmx_data_3_4_0 <= 'd0;
        dac_dmx_data_4_4_0 <= 'd0;
        dac_dmx_data_5_4_0 <= 'd0;
        dac_dmx_data_6_4_0 <= 'd0;
        dac_dmx_data_7_4_0 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b01110101: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= 'd0;
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_1 <= 'd0;
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_1 <= 'd0;
      end
      8'b01110110: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= 'd0;
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_1 <= 'd0;
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_1 <= 'd0;
      end
      8'b01111001: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= 'd0;
        dac_dmx_data_2_4_1 <= 'd0;
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_1 <= 'd0;
      end
      8'b01111010: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= 'd0;
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_1 <= 'd0;
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_1 <= 'd0;
      end
      8'b01111100: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= 'd0;
        dac_dmx_data_1_4_1 <= 'd0;
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_4_1 <= 'd0;
      end
      8'b10001111: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_4_1 <= 'd0;
        dac_dmx_data_5_4_1 <= 'd0;
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10010111: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_1 <= 'd0;
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_1 <= 'd0;
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10011011: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_1 <= 'd0;
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_1 <= 'd0;
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10011101: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= 'd0;
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_1 <= 'd0;
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10011110: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= 'd0;
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_4_1 <= 'd0;
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10100111: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_1 <= 'd0;
        dac_dmx_data_4_4_1 <= 'd0;
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10101011: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_1 <= 'd0;
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_1 <= 'd0;
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10101101: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= 'd0;
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_1 <= 'd0;
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10101110: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= 'd0;
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_1 <= 'd0;
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10110011: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_1 <= 'd0;
        dac_dmx_data_3_4_1 <= 'd0;
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10110101: begin
        dac_dmx_enable_4_1 <= 1'b1;
        dac_dmx_data_0_4_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_1 <= 'd0;
        dac_dmx_data_2_4_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_1 <= 'd0;
        dac_dmx_data_4_4_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      default: begin
        dac_dmx_enable_4_1 <= 'd0;
        dac_dmx_data_0_4_1 <= 'd0;
        dac_dmx_data_1_4_1 <= 'd0;
        dac_dmx_data_2_4_1 <= 'd0;
        dac_dmx_data_3_4_1 <= 'd0;
        dac_dmx_data_4_4_1 <= 'd0;
        dac_dmx_data_5_4_1 <= 'd0;
        dac_dmx_data_6_4_1 <= 'd0;
        dac_dmx_data_7_4_1 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b10110110: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= 'd0;
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_2 <= 'd0;
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_2 <= 'd0;
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10111001: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= 'd0;
        dac_dmx_data_2_4_2 <= 'd0;
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_2 <= 'd0;
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10111010: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= 'd0;
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_2 <= 'd0;
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_2 <= 'd0;
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b10111100: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= 'd0;
        dac_dmx_data_1_4_2 <= 'd0;
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_4_2 <= 'd0;
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11000111: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_4_2 <= 'd0;
        dac_dmx_data_4_4_2 <= 'd0;
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11001011: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_2 <= 'd0;
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_2 <= 'd0;
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11001101: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= 'd0;
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_2 <= 'd0;
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11001110: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= 'd0;
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_4_2 <= 'd0;
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11010011: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_2 <= 'd0;
        dac_dmx_data_3_4_2 <= 'd0;
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11010101: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= 'd0;
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_2 <= 'd0;
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11010110: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= 'd0;
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_2 <= 'd0;
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11011001: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= 'd0;
        dac_dmx_data_2_4_2 <= 'd0;
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11011010: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= 'd0;
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_2 <= 'd0;
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11011100: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= 'd0;
        dac_dmx_data_1_4_2 <= 'd0;
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11100011: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_4_2 <= 'd0;
        dac_dmx_data_3_4_2 <= 'd0;
        dac_dmx_data_4_4_2 <= 'd0;
        dac_dmx_data_5_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11100101: begin
        dac_dmx_enable_4_2 <= 1'b1;
        dac_dmx_data_0_4_2 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_2 <= 'd0;
        dac_dmx_data_2_4_2 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_2 <= 'd0;
        dac_dmx_data_4_4_2 <= 'd0;
        dac_dmx_data_5_4_2 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_2 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_2 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      default: begin
        dac_dmx_enable_4_2 <= 'd0;
        dac_dmx_data_0_4_2 <= 'd0;
        dac_dmx_data_1_4_2 <= 'd0;
        dac_dmx_data_2_4_2 <= 'd0;
        dac_dmx_data_3_4_2 <= 'd0;
        dac_dmx_data_4_4_2 <= 'd0;
        dac_dmx_data_5_4_2 <= 'd0;
        dac_dmx_data_6_4_2 <= 'd0;
        dac_dmx_data_7_4_2 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b11100110: begin
        dac_dmx_enable_4_3 <= 1'b1;
        dac_dmx_data_0_4_3 <= 'd0;
        dac_dmx_data_1_4_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_4_3 <= 'd0;
        dac_dmx_data_4_4_3 <= 'd0;
        dac_dmx_data_5_4_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_3 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_3 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11101001: begin
        dac_dmx_enable_4_3 <= 1'b1;
        dac_dmx_data_0_4_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_3 <= 'd0;
        dac_dmx_data_2_4_3 <= 'd0;
        dac_dmx_data_3_4_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_3 <= 'd0;
        dac_dmx_data_5_4_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_3 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_3 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11101010: begin
        dac_dmx_enable_4_3 <= 1'b1;
        dac_dmx_data_0_4_3 <= 'd0;
        dac_dmx_data_1_4_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_3 <= 'd0;
        dac_dmx_data_3_4_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_3 <= 'd0;
        dac_dmx_data_5_4_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_3 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_3 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11101100: begin
        dac_dmx_enable_4_3 <= 1'b1;
        dac_dmx_data_0_4_3 <= 'd0;
        dac_dmx_data_1_4_3 <= 'd0;
        dac_dmx_data_2_4_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_4_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_4_3 <= 'd0;
        dac_dmx_data_5_4_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_3 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_3 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11110001: begin
        dac_dmx_enable_4_3 <= 1'b1;
        dac_dmx_data_0_4_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_4_3 <= 'd0;
        dac_dmx_data_2_4_3 <= 'd0;
        dac_dmx_data_3_4_3 <= 'd0;
        dac_dmx_data_4_4_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_4_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_3 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_3 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11110010: begin
        dac_dmx_enable_4_3 <= 1'b1;
        dac_dmx_data_0_4_3 <= 'd0;
        dac_dmx_data_1_4_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_4_3 <= 'd0;
        dac_dmx_data_3_4_3 <= 'd0;
        dac_dmx_data_4_4_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_4_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_3 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_3 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11110100: begin
        dac_dmx_enable_4_3 <= 1'b1;
        dac_dmx_data_0_4_3 <= 'd0;
        dac_dmx_data_1_4_3 <= 'd0;
        dac_dmx_data_2_4_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_4_3 <= 'd0;
        dac_dmx_data_4_4_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_4_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_3 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_3 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      8'b11111000: begin
        dac_dmx_enable_4_3 <= 1'b1;
        dac_dmx_data_0_4_3 <= 'd0;
        dac_dmx_data_1_4_3 <= 'd0;
        dac_dmx_data_2_4_3 <= 'd0;
        dac_dmx_data_3_4_3 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_4_4_3 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_5_4_3 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_6_4_3 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_7_4_3 <= dac_dsf_data[((16*4)+15):(16*4)];
      end
      default: begin
        dac_dmx_enable_4_3 <= 'd0;
        dac_dmx_data_0_4_3 <= 'd0;
        dac_dmx_data_1_4_3 <= 'd0;
        dac_dmx_data_2_4_3 <= 'd0;
        dac_dmx_data_3_4_3 <= 'd0;
        dac_dmx_data_4_4_3 <= 'd0;
        dac_dmx_data_5_4_3 <= 'd0;
        dac_dmx_data_6_4_3 <= 'd0;
        dac_dmx_data_7_4_3 <= 'd0;
      end
    endcase
  end

  // 6 channel(s)

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b00111111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_6_5_0 <= 'd0;
        dac_dmx_data_7_5_0 <= 'd0;
      end
      8'b01011111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_5_5_0 <= 'd0;
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_5_0 <= 'd0;
      end
      8'b01101111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_5_0 <= 'd0;
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_5_0 <= 'd0;
      end
      8'b01110111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= 'd0;
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_5_0 <= 'd0;
      end
      8'b01111011: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= 'd0;
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_5_0 <= 'd0;
      end
      8'b01111101: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= 'd0;
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_5_0 <= 'd0;
      end
      8'b01111110: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= 'd0;
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_5_0 <= 'd0;
      end
      8'b10011111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_5_5_0 <= 'd0;
        dac_dmx_data_6_5_0 <= 'd0;
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b10101111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_5_0 <= 'd0;
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= 'd0;
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b10110111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= 'd0;
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= 'd0;
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b10111011: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= 'd0;
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= 'd0;
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b10111101: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= 'd0;
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= 'd0;
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b10111110: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= 'd0;
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_5_0 <= 'd0;
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11001111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_5_0 <= 'd0;
        dac_dmx_data_5_5_0 <= 'd0;
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11010111: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_0 <= 'd0;
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= 'd0;
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11011011: begin
        dac_dmx_enable_5_0 <= 1'b1;
        dac_dmx_data_0_5_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_0 <= 'd0;
        dac_dmx_data_3_5_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_0 <= 'd0;
        dac_dmx_data_6_5_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_0 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      default: begin
        dac_dmx_enable_5_0 <= 'd0;
        dac_dmx_data_0_5_0 <= 'd0;
        dac_dmx_data_1_5_0 <= 'd0;
        dac_dmx_data_2_5_0 <= 'd0;
        dac_dmx_data_3_5_0 <= 'd0;
        dac_dmx_data_4_5_0 <= 'd0;
        dac_dmx_data_5_5_0 <= 'd0;
        dac_dmx_data_6_5_0 <= 'd0;
        dac_dmx_data_7_5_0 <= 'd0;
      end
    endcase
  end

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b11011101: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_1 <= 'd0;
        dac_dmx_data_2_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_1 <= 'd0;
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11011110: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= 'd0;
        dac_dmx_data_1_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_5_1 <= 'd0;
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11100111: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_5_1 <= 'd0;
        dac_dmx_data_4_5_1 <= 'd0;
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11101011: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_1 <= 'd0;
        dac_dmx_data_3_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_1 <= 'd0;
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11101101: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_1 <= 'd0;
        dac_dmx_data_2_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_1 <= 'd0;
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11101110: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= 'd0;
        dac_dmx_data_1_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_5_1 <= 'd0;
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11110011: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_5_1 <= 'd0;
        dac_dmx_data_3_5_1 <= 'd0;
        dac_dmx_data_4_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11110101: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_1 <= 'd0;
        dac_dmx_data_2_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_1 <= 'd0;
        dac_dmx_data_4_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11110110: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= 'd0;
        dac_dmx_data_1_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_5_1 <= 'd0;
        dac_dmx_data_4_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11111001: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_5_1 <= 'd0;
        dac_dmx_data_2_5_1 <= 'd0;
        dac_dmx_data_3_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11111010: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= 'd0;
        dac_dmx_data_1_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_5_1 <= 'd0;
        dac_dmx_data_3_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      8'b11111100: begin
        dac_dmx_enable_5_1 <= 1'b1;
        dac_dmx_data_0_5_1 <= 'd0;
        dac_dmx_data_1_5_1 <= 'd0;
        dac_dmx_data_2_5_1 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_3_5_1 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_4_5_1 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_5_5_1 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_6_5_1 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_7_5_1 <= dac_dsf_data[((16*5)+15):(16*5)];
      end
      default: begin
        dac_dmx_enable_5_1 <= 'd0;
        dac_dmx_data_0_5_1 <= 'd0;
        dac_dmx_data_1_5_1 <= 'd0;
        dac_dmx_data_2_5_1 <= 'd0;
        dac_dmx_data_3_5_1 <= 'd0;
        dac_dmx_data_4_5_1 <= 'd0;
        dac_dmx_data_5_5_1 <= 'd0;
        dac_dmx_data_6_5_1 <= 'd0;
        dac_dmx_data_7_5_1 <= 'd0;
      end
    endcase
  end

  // 7 channel(s)

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b01111111: begin
        dac_dmx_enable_6_0 <= 1'b1;
        dac_dmx_data_0_6_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_6_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_6_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_6_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_6_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_5_6_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_6_6_0 <= dac_dsf_data[((16*6)+15):(16*6)];
        dac_dmx_data_7_6_0 <= 'd0;
      end
      8'b10111111: begin
        dac_dmx_enable_6_0 <= 1'b1;
        dac_dmx_data_0_6_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_6_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_6_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_6_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_6_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_5_6_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_6_6_0 <= 'd0;
        dac_dmx_data_7_6_0 <= dac_dsf_data[((16*6)+15):(16*6)];
      end
      8'b11011111: begin
        dac_dmx_enable_6_0 <= 1'b1;
        dac_dmx_data_0_6_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_6_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_6_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_6_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_6_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_5_6_0 <= 'd0;
        dac_dmx_data_6_6_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_6_0 <= dac_dsf_data[((16*6)+15):(16*6)];
      end
      8'b11101111: begin
        dac_dmx_enable_6_0 <= 1'b1;
        dac_dmx_data_0_6_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_6_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_6_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_6_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_6_0 <= 'd0;
        dac_dmx_data_5_6_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_6_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_6_0 <= dac_dsf_data[((16*6)+15):(16*6)];
      end
      8'b11110111: begin
        dac_dmx_enable_6_0 <= 1'b1;
        dac_dmx_data_0_6_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_6_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_6_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_6_0 <= 'd0;
        dac_dmx_data_4_6_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_6_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_6_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_6_0 <= dac_dsf_data[((16*6)+15):(16*6)];
      end
      8'b11111011: begin
        dac_dmx_enable_6_0 <= 1'b1;
        dac_dmx_data_0_6_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_6_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_6_0 <= 'd0;
        dac_dmx_data_3_6_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_6_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_6_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_6_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_6_0 <= dac_dsf_data[((16*6)+15):(16*6)];
      end
      8'b11111101: begin
        dac_dmx_enable_6_0 <= 1'b1;
        dac_dmx_data_0_6_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_6_0 <= 'd0;
        dac_dmx_data_2_6_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_6_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_6_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_6_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_6_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_6_0 <= dac_dsf_data[((16*6)+15):(16*6)];
      end
      8'b11111110: begin
        dac_dmx_enable_6_0 <= 1'b1;
        dac_dmx_data_0_6_0 <= 'd0;
        dac_dmx_data_1_6_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_2_6_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_3_6_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_4_6_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_5_6_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_6_6_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_7_6_0 <= dac_dsf_data[((16*6)+15):(16*6)];
      end
      default: begin
        dac_dmx_enable_6_0 <= 'd0;
        dac_dmx_data_0_6_0 <= 'd0;
        dac_dmx_data_1_6_0 <= 'd0;
        dac_dmx_data_2_6_0 <= 'd0;
        dac_dmx_data_3_6_0 <= 'd0;
        dac_dmx_data_4_6_0 <= 'd0;
        dac_dmx_data_5_6_0 <= 'd0;
        dac_dmx_data_6_6_0 <= 'd0;
        dac_dmx_data_7_6_0 <= 'd0;
      end
    endcase
  end

  // 8 channel(s)

  always @(posedge dac_clk) begin
     case (dac_enable)
      8'b11111111: begin
        dac_dmx_enable_7_0 <= 1'b1;
        dac_dmx_data_0_7_0 <= dac_dsf_data[((16*0)+15):(16*0)];
        dac_dmx_data_1_7_0 <= dac_dsf_data[((16*1)+15):(16*1)];
        dac_dmx_data_2_7_0 <= dac_dsf_data[((16*2)+15):(16*2)];
        dac_dmx_data_3_7_0 <= dac_dsf_data[((16*3)+15):(16*3)];
        dac_dmx_data_4_7_0 <= dac_dsf_data[((16*4)+15):(16*4)];
        dac_dmx_data_5_7_0 <= dac_dsf_data[((16*5)+15):(16*5)];
        dac_dmx_data_6_7_0 <= dac_dsf_data[((16*6)+15):(16*6)];
        dac_dmx_data_7_7_0 <= dac_dsf_data[((16*7)+15):(16*7)];
      end
      default: begin
        dac_dmx_enable_7_0 <= 'd0;
        dac_dmx_data_0_7_0 <= 'd0;
        dac_dmx_data_1_7_0 <= 'd0;
        dac_dmx_data_2_7_0 <= 'd0;
        dac_dmx_data_3_7_0 <= 'd0;
        dac_dmx_data_4_7_0 <= 'd0;
        dac_dmx_data_5_7_0 <= 'd0;
        dac_dmx_data_6_7_0 <= 'd0;
        dac_dmx_data_7_7_0 <= 'd0;
      end
    endcase
  end

endmodule

// ***************************************************************************
// ***************************************************************************
