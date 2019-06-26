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
  reg sysref = 1'b0;
  reg mng_rst = 1'b1;
  reg [31:0] dac_data = 'h0001_0000;

  `TEST_PROGRAM test();

  test_harness `TH (
    .mng_rst(mng_rst),
    .mng_clk(mng_clk),

    .ref_clk(ref_clk),

    .rx_data_0_p(data_0_p),
    .rx_data_0_n(data_0_n),
    .rx_sysref_0(sysref),
    .rx_sync_0(sync_0),

    .tx_data_0_p(data_0_p),
    .tx_data_0_n(data_0_n),
    .tx_sysref_0(sysref),
    .tx_sync_0(sync_0),

    .dac_data_0(dac_data),
    .link_clk(link_clk)
  );


  always #10 mng_clk <= ~mng_clk;
  always #8 ref_clk <= ~ref_clk;   //125 MHz

  initial begin
    // Asserts all the resets for 100 ns
    mng_rst = 1'b0;
    #100;
    mng_rst = 1'b1;
  end

  always @(posedge link_clk) begin
    dac_data[15:0]  <= dac_data[15:0] + 2;
    dac_data[31:16] <= dac_data[31:16] + 2;
  end

endmodule
