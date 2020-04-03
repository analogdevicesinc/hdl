// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

`include "utils.svh"

module system_tb();

  reg mng_clk = 1'b0;
  reg ref_clk = 1'b0;
  reg device_clk = 1'b0;
  reg sysref = 1'b0;
  reg mng_rst = 1'b1;
  reg mng_rstn = 1'b0;
  reg [15:0] dac_data = 'h0000;

  wire    [15:0]  c2m_0_n;
  wire    [15:0]  c2m_0_p;
  wire    [15:0]  m2c_0_n;
  wire    [15:0]  m2c_0_p;

  wire    [15:0]  c2m_1_n;
  wire    [15:0]  c2m_1_p;
  wire    [15:0]  m2c_1_n;
  wire    [15:0]  m2c_1_p;

  wire    [15:0]  c2m_2_n;
  wire    [15:0]  c2m_2_p;
  wire    [15:0]  m2c_2_n;
  wire    [15:0]  m2c_2_p;

  wire    [15:0]  c2m_3_n;
  wire    [15:0]  c2m_3_p;
  wire    [15:0]  m2c_3_n;
  wire    [15:0]  m2c_3_p;

  wire    [3:0]   tx_syncin_0;
  wire    [3:0]   rx_syncout_0;
  wire    [3:0]   ref_clk_0;

  wire    [3:0]   tx_syncin_1;
  wire    [3:0]   rx_syncout_1;
  wire    [3:0]   ref_clk_1;

  wire    [3:0]   tx_syncin_2;
  wire    [3:0]   rx_syncout_2;
  wire    [3:0]   ref_clk_2;

  wire    [3:0]   tx_syncin_3;
  wire    [3:0]   rx_syncout_3;
  wire    [3:0]   ref_clk_3;

  assign ref_clk_0 = {4{ref_clk}};
  /*
  assign ref_clk_1 = {4{ref_clk}};
  assign ref_clk_2 = {4{ref_clk}};
  assign ref_clk_3 = {4{ref_clk}};
 */
  // Loopback SYNC
  assign tx_syncin_0 = rx_syncout_0;
  /*
  assign tx_syncin_1 = rx_syncout_1;
  assign tx_syncin_2 = rx_syncout_2;
  assign tx_syncin_3 = rx_syncout_3;
  */
  // Loopback data lines
  assign m2c_0_n = c2m_0_n;
  assign m2c_0_p = c2m_0_p;
  /*
  assign m2c_1_n = c2m_1_n;
  assign m2c_1_p = c2m_1_p;
  assign m2c_2_n = c2m_2_n;
  assign m2c_2_p = c2m_2_p;
  assign m2c_3_n = c2m_3_n;
  assign m2c_3_p = c2m_3_p;
 */

  `TEST_PROGRAM test();

  test_harness `TH (
    .mng_rst(mng_rst),
    .mng_rstn(mng_rstn),
    .mng_clk(mng_clk),
    // QUAD 1 signals

    // rx quad 1
    .rx_data_0_n  (m2c_0_n[0]),
    .rx_data_0_p  (m2c_0_p[0]),
    .rx_data_1_n  (m2c_0_n[1]),
    .rx_data_1_p  (m2c_0_p[1]),
    .rx_data_2_n  (m2c_0_n[2]),
    .rx_data_2_p  (m2c_0_p[2]),
    .rx_data_3_n  (m2c_0_n[3]),
    .rx_data_3_p  (m2c_0_p[3]),
    // rx quad 2
    .rx_data_4_n  (m2c_0_n[4]),
    .rx_data_4_p  (m2c_0_p[4]),
    .rx_data_5_n  (m2c_0_n[5]),
    .rx_data_5_p  (m2c_0_p[5]),
    .rx_data_6_n  (m2c_0_n[6]),
    .rx_data_6_p  (m2c_0_p[6]),
    .rx_data_7_n  (m2c_0_n[7]),
    .rx_data_7_p  (m2c_0_p[7]),
    // rx quad 3
    .rx_data_8_n  (m2c_0_n[8]),
    .rx_data_8_p  (m2c_0_p[8]),
    .rx_data_9_n  (m2c_0_n[9]),
    .rx_data_9_p  (m2c_0_p[9]),
    .rx_data_10_n (m2c_0_n[10]),
    .rx_data_10_p (m2c_0_p[10]),
    .rx_data_11_n (m2c_0_n[11]),
    .rx_data_11_p (m2c_0_p[11]),
    // rx quad 4
    .rx_data_12_n (m2c_0_n[12]),
    .rx_data_12_p (m2c_0_p[12]),
    .rx_data_13_n (m2c_0_n[13]),
    .rx_data_13_p (m2c_0_p[13]),
    .rx_data_14_n (m2c_0_n[14]),
    .rx_data_14_p (m2c_0_p[14]),
    .rx_data_15_n (m2c_0_n[15]),
    .rx_data_15_p (m2c_0_p[15]),
    // tx quad 1
    .tx_data_0_n  (c2m_0_n[0]),
    .tx_data_0_p  (c2m_0_p[0]),
    .tx_data_1_n  (c2m_0_n[1]),
    .tx_data_1_p  (c2m_0_p[1]),
    .tx_data_2_n  (c2m_0_n[2]),
    .tx_data_2_p  (c2m_0_p[2]),
    .tx_data_3_n  (c2m_0_n[3]),
    .tx_data_3_p  (c2m_0_p[3]),
    // tx quad 2
    .tx_data_4_n  (c2m_0_n[4]),
    .tx_data_4_p  (c2m_0_p[4]),
    .tx_data_5_n  (c2m_0_n[5]),
    .tx_data_5_p  (c2m_0_p[5]),
    .tx_data_6_n  (c2m_0_n[6]),
    .tx_data_6_p  (c2m_0_p[6]),
    .tx_data_7_n  (c2m_0_n[7]),
    .tx_data_7_p  (c2m_0_p[7]),
    // tx quad 3
    .tx_data_8_n  (c2m_0_n[8]),
    .tx_data_8_p  (c2m_0_p[8]),
    .tx_data_9_n  (c2m_0_n[9]),
    .tx_data_9_p  (c2m_0_p[9]),
    .tx_data_10_n (c2m_0_n[10]),
    .tx_data_10_p (c2m_0_p[10]),
    .tx_data_11_n (c2m_0_n[11]),
    .tx_data_11_p (c2m_0_p[11]),
    // tx quad 4
    .tx_data_12_n (c2m_0_n[12]),
    .tx_data_12_p (c2m_0_p[12]),
    .tx_data_13_n (c2m_0_n[13]),
    .tx_data_13_p (c2m_0_p[13]),
    .tx_data_14_n (c2m_0_n[14]),
    .tx_data_14_p (c2m_0_p[14]),
    .tx_data_15_n (c2m_0_n[15]),
    .tx_data_15_p (c2m_0_p[15]),

    .ref_clk_0_q0 (ref_clk_0[0]),
    .ref_clk_0_q1 (ref_clk_0[1]),
    .ref_clk_0_q2 (ref_clk_0[2]),
    .ref_clk_0_q3 (ref_clk_0[3]),
    .rx_sync_0 (rx_syncout_0),
    .tx_sync_0 (tx_syncin_0),
    .rx_sysref_0 (sysref),
    .tx_sysref_0 (sysref),
/*
    // QUAD 1 signals

    // rx quad 1
    .rx_data_1_0_n  (m2c_1_n[0]),
    .rx_data_1_0_p  (m2c_1_p[0]),
    .rx_data_1_1_n  (m2c_1_n[1]),
    .rx_data_1_1_p  (m2c_1_p[1]),
    .rx_data_1_2_n  (m2c_1_n[2]),
    .rx_data_1_2_p  (m2c_1_p[2]),
    .rx_data_1_3_n  (m2c_1_n[3]),
    .rx_data_1_3_p  (m2c_1_p[3]),
    // rx quad 2
    .rx_data_1_4_n  (m2c_1_n[4]),
    .rx_data_1_4_p  (m2c_1_p[4]),
    .rx_data_1_5_n  (m2c_1_n[5]),
    .rx_data_1_5_p  (m2c_1_p[5]),
    .rx_data_1_6_n  (m2c_1_n[6]),
    .rx_data_1_6_p  (m2c_1_p[6]),
    .rx_data_1_7_n  (m2c_1_n[7]),
    .rx_data_1_7_p  (m2c_1_p[7]),
    // rx quad 3
    .rx_data_1_8_n  (m2c_1_n[8]),
    .rx_data_1_8_p  (m2c_1_p[8]),
    .rx_data_1_9_n  (m2c_1_n[9]),
    .rx_data_1_9_p  (m2c_1_p[9]),
    .rx_data_1_10_n (m2c_1_n[10]),
    .rx_data_1_10_p (m2c_1_p[10]),
    .rx_data_1_11_n (m2c_1_n[11]),
    .rx_data_1_11_p (m2c_1_p[11]),
    // rx quad 4
    .rx_data_1_12_n (m2c_1_n[12]),
    .rx_data_1_12_p (m2c_1_p[12]),
    .rx_data_1_13_n (m2c_1_n[13]),
    .rx_data_1_13_p (m2c_1_p[13]),
    .rx_data_1_14_n (m2c_1_n[14]),
    .rx_data_1_14_p (m2c_1_p[14]),
    .rx_data_1_15_n (m2c_1_n[15]),
    .rx_data_1_15_p (m2c_1_p[15]),
    // tx quad 1
    .tx_data_1_0_n  (c2m_1_n[0]),
    .tx_data_1_0_p  (c2m_1_p[0]),
    .tx_data_1_1_n  (c2m_1_n[1]),
    .tx_data_1_1_p  (c2m_1_p[1]),
    .tx_data_1_2_n  (c2m_1_n[2]),
    .tx_data_1_2_p  (c2m_1_p[2]),
    .tx_data_1_3_n  (c2m_1_n[3]),
    .tx_data_1_3_p  (c2m_1_p[3]),
    // tx quad 2
    .tx_data_1_4_n  (c2m_1_n[4]),
    .tx_data_1_4_p  (c2m_1_p[4]),
    .tx_data_1_5_n  (c2m_1_n[5]),
    .tx_data_1_5_p  (c2m_1_p[5]),
    .tx_data_1_6_n  (c2m_1_n[6]),
    .tx_data_1_6_p  (c2m_1_p[6]),
    .tx_data_1_7_n  (c2m_1_n[7]),
    .tx_data_1_7_p  (c2m_1_p[7]),
    // tx quad 3
    .tx_data_1_8_n  (c2m_1_n[8]),
    .tx_data_1_8_p  (c2m_1_p[8]),
    .tx_data_1_9_n  (c2m_1_n[9]),
    .tx_data_1_9_p  (c2m_1_p[9]),
    .tx_data_1_10_n (c2m_1_n[10]),
    .tx_data_1_10_p (c2m_1_p[10]),
    .tx_data_1_11_n (c2m_1_n[11]),
    .tx_data_1_11_p (c2m_1_p[11]),
    // tx quad 4
    .tx_data_1_12_n (c2m_1_n[12]),
    .tx_data_1_12_p (c2m_1_p[12]),
    .tx_data_1_13_n (c2m_1_n[13]),
    .tx_data_1_13_p (c2m_1_p[13]),
    .tx_data_1_14_n (c2m_1_n[14]),
    .tx_data_1_14_p (c2m_1_p[14]),
    .tx_data_1_15_n (c2m_1_n[15]),
    .tx_data_1_15_p (c2m_1_p[15]),

    .ref_clk_1_q0 (ref_clk_1[0]),
    .ref_clk_1_q1 (ref_clk_1[1]),
    .ref_clk_1_q2 (ref_clk_1[2]),
    .ref_clk_1_q3 (ref_clk_1[3]),
    .rx_sync_1_0 (rx_syncout_1),
    .tx_sync_1_0 (tx_syncin_1),
    .rx_sysref_1_0 (sysref),
    .tx_sysref_1_0 (sysref),
    // QUAD 2 signals

    // rx quad 1
    .rx_data_2_0_n  (m2c_2_n[0]),
    .rx_data_2_0_p  (m2c_2_p[0]),
    .rx_data_2_1_n  (m2c_2_n[1]),
    .rx_data_2_1_p  (m2c_2_p[1]),
    .rx_data_2_2_n  (m2c_2_n[2]),
    .rx_data_2_2_p  (m2c_2_p[2]),
    .rx_data_2_3_n  (m2c_2_n[3]),
    .rx_data_2_3_p  (m2c_2_p[3]),
    // rx quad 2
    .rx_data_2_4_n  (m2c_2_n[4]),
    .rx_data_2_4_p  (m2c_2_p[4]),
    .rx_data_2_5_n  (m2c_2_n[5]),
    .rx_data_2_5_p  (m2c_2_p[5]),
    .rx_data_2_6_n  (m2c_2_n[6]),
    .rx_data_2_6_p  (m2c_2_p[6]),
    .rx_data_2_7_n  (m2c_2_n[7]),
    .rx_data_2_7_p  (m2c_2_p[7]),
    // rx quad 3
    .rx_data_2_8_n  (m2c_2_n[8]),
    .rx_data_2_8_p  (m2c_2_p[8]),
    .rx_data_2_9_n  (m2c_2_n[9]),
    .rx_data_2_9_p  (m2c_2_p[9]),
    .rx_data_2_10_n (m2c_2_n[10]),
    .rx_data_2_10_p (m2c_2_p[10]),
    .rx_data_2_11_n (m2c_2_n[11]),
    .rx_data_2_11_p (m2c_2_p[11]),
    // rx quad 4
    .rx_data_2_12_n (m2c_2_n[12]),
    .rx_data_2_12_p (m2c_2_p[12]),
    .rx_data_2_13_n (m2c_2_n[13]),
    .rx_data_2_13_p (m2c_2_p[13]),
    .rx_data_2_14_n (m2c_2_n[14]),
    .rx_data_2_14_p (m2c_2_p[14]),
    .rx_data_2_15_n (m2c_2_n[15]),
    .rx_data_2_15_p (m2c_2_p[15]),
    // tx quad 1
    .tx_data_2_0_n  (c2m_2_n[0]),
    .tx_data_2_0_p  (c2m_2_p[0]),
    .tx_data_2_1_n  (c2m_2_n[1]),
    .tx_data_2_1_p  (c2m_2_p[1]),
    .tx_data_2_2_n  (c2m_2_n[2]),
    .tx_data_2_2_p  (c2m_2_p[2]),
    .tx_data_2_3_n  (c2m_2_n[3]),
    .tx_data_2_3_p  (c2m_2_p[3]),
    // tx quad 2
    .tx_data_2_4_n  (c2m_2_n[4]),
    .tx_data_2_4_p  (c2m_2_p[4]),
    .tx_data_2_5_n  (c2m_2_n[5]),
    .tx_data_2_5_p  (c2m_2_p[5]),
    .tx_data_2_6_n  (c2m_2_n[6]),
    .tx_data_2_6_p  (c2m_2_p[6]),
    .tx_data_2_7_n  (c2m_2_n[7]),
    .tx_data_2_7_p  (c2m_2_p[7]),
    // tx quad 3
    .tx_data_2_8_n  (c2m_2_n[8]),
    .tx_data_2_8_p  (c2m_2_p[8]),
    .tx_data_2_9_n  (c2m_2_n[9]),
    .tx_data_2_9_p  (c2m_2_p[9]),
    .tx_data_2_10_n (c2m_2_n[10]),
    .tx_data_2_10_p (c2m_2_p[10]),
    .tx_data_2_11_n (c2m_2_n[11]),
    .tx_data_2_11_p (c2m_2_p[11]),
    // tx quad 4
    .tx_data_2_12_n (c2m_2_n[12]),
    .tx_data_2_12_p (c2m_2_p[12]),
    .tx_data_2_13_n (c2m_2_n[13]),
    .tx_data_2_13_p (c2m_2_p[13]),
    .tx_data_2_14_n (c2m_2_n[14]),
    .tx_data_2_14_p (c2m_2_p[14]),
    .tx_data_2_15_n (c2m_2_n[15]),
    .tx_data_2_15_p (c2m_2_p[15]),

    .ref_clk_2_q0 (ref_clk_2[0]),
    .ref_clk_2_q1 (ref_clk_2[1]),
    .ref_clk_2_q2 (ref_clk_2[2]),
    .ref_clk_2_q3 (ref_clk_2[3]),
    .rx_sync_2_0 (rx_syncout_2),
    .tx_sync_2_0 (tx_syncin_2),
    .rx_sysref_2_0 (sysref),
    .tx_sysref_2_0 (sysref),

    // QUAD 3 signals

    // rx quad 1
    .rx_data_3_0_n  (m2c_3_n[0]),
    .rx_data_3_0_p  (m2c_3_p[0]),
    .rx_data_3_1_n  (m2c_3_n[1]),
    .rx_data_3_1_p  (m2c_3_p[1]),
    .rx_data_3_2_n  (m2c_3_n[2]),
    .rx_data_3_2_p  (m2c_3_p[2]),
    .rx_data_3_3_n  (m2c_3_n[3]),
    .rx_data_3_3_p  (m2c_3_p[3]),
    // rx quad 2
    .rx_data_3_4_n  (m2c_3_n[4]),
    .rx_data_3_4_p  (m2c_3_p[4]),
    .rx_data_3_5_n  (m2c_3_n[5]),
    .rx_data_3_5_p  (m2c_3_p[5]),
    .rx_data_3_6_n  (m2c_3_n[6]),
    .rx_data_3_6_p  (m2c_3_p[6]),
    .rx_data_3_7_n  (m2c_3_n[7]),
    .rx_data_3_7_p  (m2c_3_p[7]),
    // rx quad 3
    .rx_data_3_8_n  (m2c_3_n[8]),
    .rx_data_3_8_p  (m2c_3_p[8]),
    .rx_data_3_9_n  (m2c_3_n[9]),
    .rx_data_3_9_p  (m2c_3_p[9]),
    .rx_data_3_10_n (m2c_3_n[10]),
    .rx_data_3_10_p (m2c_3_p[10]),
    .rx_data_3_11_n (m2c_3_n[11]),
    .rx_data_3_11_p (m2c_3_p[11]),
    // rx quad 4
    .rx_data_3_12_n (m2c_3_n[12]),
    .rx_data_3_12_p (m2c_3_p[12]),
    .rx_data_3_13_n (m2c_3_n[13]),
    .rx_data_3_13_p (m2c_3_p[13]),
    .rx_data_3_14_n (m2c_3_n[14]),
    .rx_data_3_14_p (m2c_3_p[14]),
    .rx_data_3_15_n (m2c_3_n[15]),
    .rx_data_3_15_p (m2c_3_p[15]),
    // tx quad 1
    .tx_data_3_0_n  (c2m_3_n[0]),
    .tx_data_3_0_p  (c2m_3_p[0]),
    .tx_data_3_1_n  (c2m_3_n[1]),
    .tx_data_3_1_p  (c2m_3_p[1]),
    .tx_data_3_2_n  (c2m_3_n[2]),
    .tx_data_3_2_p  (c2m_3_p[2]),
    .tx_data_3_3_n  (c2m_3_n[3]),
    .tx_data_3_3_p  (c2m_3_p[3]),
    // tx quad 2
    .tx_data_3_4_n  (c2m_3_n[4]),
    .tx_data_3_4_p  (c2m_3_p[4]),
    .tx_data_3_5_n  (c2m_3_n[5]),
    .tx_data_3_5_p  (c2m_3_p[5]),
    .tx_data_3_6_n  (c2m_3_n[6]),
    .tx_data_3_6_p  (c2m_3_p[6]),
    .tx_data_3_7_n  (c2m_3_n[7]),
    .tx_data_3_7_p  (c2m_3_p[7]),
    // tx quad 3
    .tx_data_3_8_n  (c2m_3_n[8]),
    .tx_data_3_8_p  (c2m_3_p[8]),
    .tx_data_3_9_n  (c2m_3_n[9]),
    .tx_data_3_9_p  (c2m_3_p[9]),
    .tx_data_3_10_n (c2m_3_n[10]),
    .tx_data_3_10_p (c2m_3_p[10]),
    .tx_data_3_11_n (c2m_3_n[11]),
    .tx_data_3_11_p (c2m_3_p[11]),
    // tx quad 4
    .tx_data_3_12_n (c2m_3_n[12]),
    .tx_data_3_12_p (c2m_3_p[12]),
    .tx_data_3_13_n (c2m_3_n[13]),
    .tx_data_3_13_p (c2m_3_p[13]),
    .tx_data_3_14_n (c2m_3_n[14]),
    .tx_data_3_14_p (c2m_3_p[14]),
    .tx_data_3_15_n (c2m_3_n[15]),
    .tx_data_3_15_p (c2m_3_p[15]),

    .ref_clk_3_q0 (ref_clk_3[0]),
    .ref_clk_3_q1 (ref_clk_3[1]),
    .ref_clk_3_q2 (ref_clk_3[2]),
    .ref_clk_3_q3 (ref_clk_3[3]),
    .rx_sync_3_0 (rx_syncout_3),
    .tx_sync_3_0 (tx_syncin_3),
    .rx_sysref_3_0 (sysref),
    .tx_sysref_3_0 (sysref),
*/
    .device_clk (device_clk),

    .dac_data_0   ({8'd0 ,dac_data[7:0]}),
    .dac_data_1   ({8'd1 ,dac_data[7:0]}),
    .dac_data_2   ({8'd2 ,dac_data[7:0]}),
    .dac_data_3   ({8'd3 ,dac_data[7:0]}),
    .dac_data_4   ({8'd4 ,dac_data[7:0]}),
    .dac_data_5   ({8'd5 ,dac_data[7:0]}),
    .dac_data_6   ({8'd6 ,dac_data[7:0]}),
    .dac_data_7   ({8'd7 ,dac_data[7:0]}),
    .dac_data_8   ({8'd8 ,dac_data[7:0]}),
    .dac_data_9   ({8'd9 ,dac_data[7:0]}),
    .dac_data_10  ({8'd10,dac_data[7:0]}),
    .dac_data_11  ({8'd11,dac_data[7:0]}),
    .dac_data_12  ({8'd12,dac_data[7:0]}),
    .dac_data_13  ({8'd13,dac_data[7:0]}),
    .dac_data_14  ({8'd14,dac_data[7:0]}),
    .dac_data_15  ({8'd15,dac_data[7:0]}),
    .dac_data_16  ({8'd16,dac_data[7:0]}),
    .dac_data_17  ({8'd17,dac_data[7:0]}),
    .dac_data_18  ({8'd18,dac_data[7:0]}),
    .dac_data_19  ({8'd19,dac_data[7:0]}),
    .dac_data_20  ({8'd20,dac_data[7:0]}),
    .dac_data_21  ({8'd21,dac_data[7:0]}),
    .dac_data_22  ({8'd22,dac_data[7:0]}),
    .dac_data_23  ({8'd23,dac_data[7:0]}),
    .dac_data_24  ({8'd24,dac_data[7:0]}),
    .dac_data_25  ({8'd25,dac_data[7:0]}),
    .dac_data_26  ({8'd26,dac_data[7:0]}),
    .dac_data_27  ({8'd27,dac_data[7:0]}),
    .dac_data_28  ({8'd28,dac_data[7:0]}),
    .dac_data_29  ({8'd29,dac_data[7:0]}),
    .dac_data_30  ({8'd30,dac_data[7:0]}),
    .dac_data_31  ({8'd31,dac_data[7:0]})

  );


  always #10 mng_clk <= ~mng_clk;
  always #1 ref_clk <= ~ref_clk;   //500 MHz
  always #2 device_clk <= ~device_clk;   //250 MHz
  always #(2*32) sysref <= ~sysref;   //250/32 MHz

  initial begin
    // Asserts all the resets for 100 ns
    mng_rst = 1'b1;
    mng_rstn = 1'b0;
    #1000;
    mng_rst = 1'b0;
    mng_rstn = 1'b1;
  end

  always @(posedge device_clk) begin
    dac_data[15:0]  <= dac_data[15:0] + 1;
  end

endmodule
