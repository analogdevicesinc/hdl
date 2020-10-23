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

  localparam SAMPLES_PER_CHANNEL = `JESD_L*32 / `JESD_M / `JESD_NP;
  localparam MAX_LANES = 16;
  localparam MAX_CHANNLES = 16;

  reg mng_clk = 1'b0;
  reg ref_clk = 1'b0;
  reg sysref = 1'b0;
  reg mng_rst = 1'b1;
  reg [MAX_LANES*32-1:0] dac_data = 'h0;

  `TEST_PROGRAM test();

  test_harness `TH (
    .mng_rst(mng_rst),
    .mng_clk(mng_clk),

    .ref_clk(ref_clk),

    .rx_data_0_p(data_0_p),
    .rx_data_0_n(data_0_n),
    .rx_data_1_p(data_1_p),
    .rx_data_1_n(data_1_n),
    .rx_data_2_p(data_2_p),
    .rx_data_2_n(data_2_n),
    .rx_data_3_p(data_3_p),
    .rx_data_3_n(data_3_n),
    .rx_data_4_p(data_4_p),
    .rx_data_4_n(data_4_n),
    .rx_data_5_p(data_5_p),
    .rx_data_5_n(data_5_n),
    .rx_data_6_p(data_6_p),
    .rx_data_6_n(data_6_n),
    .rx_data_7_p(data_7_p),
    .rx_data_7_n(data_7_n),
    .rx_sysref_0(sysref),
    .rx_sync_0(sync_0),

    .tx_data_0_p(data_0_p),
    .tx_data_0_n(data_0_n),
    .tx_data_1_p(data_1_p),
    .tx_data_1_n(data_1_n),
    .tx_data_2_p(data_2_p),
    .tx_data_2_n(data_2_n),
    .tx_data_3_p(data_3_p),
    .tx_data_3_n(data_3_n),
    .tx_data_4_p(data_4_p),
    .tx_data_4_n(data_4_n),
    .tx_data_5_p(data_5_p),
    .tx_data_5_n(data_5_n),
    .tx_data_6_p(data_6_p),
    .tx_data_6_n(data_6_n),
    .tx_data_7_p(data_7_p),
    .tx_data_7_n(data_7_n),
    .tx_sysref_0(sysref),
    .tx_sync_0(sync_0),

    .dac_data_0(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*0 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_1(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*1 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_2(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*2 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_3(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*3 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_4(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*4 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_5(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*5 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_6(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*6 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_7(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*7 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_8(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*8 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_9(dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*9 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_10 (dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*10 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_11 (dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*11 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_12 (dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*12 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_13 (dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*13 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_14 (dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*14 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .dac_data_15 (dac_data[SAMPLES_PER_CHANNEL*`JESD_NP*15 +: SAMPLES_PER_CHANNEL*`JESD_NP]),
    .link_clk(link_clk)
  );


  always #10 mng_clk <= ~mng_clk;
  always #4 ref_clk <= ~ref_clk;   // 125 MHz  = device clock 
  always #(4*(`JESD_K*`JESD_F/4)) sysref <= ~sysref;   //  SYSREF = device_clk*4 / (K *F)

  initial begin
    // Asserts all the resets for 1000 ns
    mng_rst = 1'b0;
    #1000;
    mng_rst = 1'b1;
  end

  reg [`JESD_NP-1:0] sample = 'h0;
  integer sample_couter = 0;
  always @(posedge link_clk) begin
    for (int i = 0; i < `JESD_M; i++) begin
      for (int j = 0; j < SAMPLES_PER_CHANNEL; j++) begin
        // First 256 sample is channel count on each nibble 
        // Next 256 sample is channel count on MS nibble and incr pattern
        if (sample_couter[8]) begin
          sample[`JESD_NP-1 -: 4] = i;
          sample[7:0] = sample_couter+j;
        end else begin
          sample = {4{i[3:0]}};
        end
        dac_data[`JESD_NP*(SAMPLES_PER_CHANNEL*i+j) +:`JESD_NP] = sample;
      end
    end
    sample_couter = sample_couter + SAMPLES_PER_CHANNEL;
  end

endmodule
