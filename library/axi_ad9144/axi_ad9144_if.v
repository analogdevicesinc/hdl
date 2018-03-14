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

module axi_ad9144_if (

  // jesd interface
  // tx_clk is (line-rate/40)

  input                   tx_clk,
  output  reg [255:0]     tx_data,

  // dac interface

  output                  dac_clk,
  input                   dac_rst,
  input       [15:0]      dac_data_0_0,
  input       [15:0]      dac_data_0_1,
  input       [15:0]      dac_data_0_2,
  input       [15:0]      dac_data_0_3,
  input       [15:0]      dac_data_1_0,
  input       [15:0]      dac_data_1_1,
  input       [15:0]      dac_data_1_2,
  input       [15:0]      dac_data_1_3,
  input       [15:0]      dac_data_2_0,
  input       [15:0]      dac_data_2_1,
  input       [15:0]      dac_data_2_2,
  input       [15:0]      dac_data_2_3,
  input       [15:0]      dac_data_3_0,
  input       [15:0]      dac_data_3_1,
  input       [15:0]      dac_data_3_2,
  input       [15:0]      dac_data_3_3);


  // internal registers

  // reorder data for the jesd links

  assign dac_clk = tx_clk;

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      tx_data <= 256'd0;
    end else begin
      tx_data[255:248] <= dac_data_3_3[ 7: 0];
      tx_data[247:240] <= dac_data_3_2[ 7: 0];
      tx_data[239:232] <= dac_data_3_1[ 7: 0];
      tx_data[231:224] <= dac_data_3_0[ 7: 0];
      tx_data[223:216] <= dac_data_3_3[15: 8];
      tx_data[215:208] <= dac_data_3_2[15: 8];
      tx_data[207:200] <= dac_data_3_1[15: 8];
      tx_data[199:192] <= dac_data_3_0[15: 8];
      tx_data[191:184] <= dac_data_2_3[ 7: 0];
      tx_data[183:176] <= dac_data_2_2[ 7: 0];
      tx_data[175:168] <= dac_data_2_1[ 7: 0];
      tx_data[167:160] <= dac_data_2_0[ 7: 0];
      tx_data[159:152] <= dac_data_2_3[15: 8];
      tx_data[151:144] <= dac_data_2_2[15: 8];
      tx_data[143:136] <= dac_data_2_1[15: 8];
      tx_data[135:128] <= dac_data_2_0[15: 8];
      tx_data[127:120] <= dac_data_1_3[ 7: 0];
      tx_data[119:112] <= dac_data_1_2[ 7: 0];
      tx_data[111:104] <= dac_data_1_1[ 7: 0];
      tx_data[103: 96] <= dac_data_1_0[ 7: 0];
      tx_data[ 95: 88] <= dac_data_1_3[15: 8];
      tx_data[ 87: 80] <= dac_data_1_2[15: 8];
      tx_data[ 79: 72] <= dac_data_1_1[15: 8];
      tx_data[ 71: 64] <= dac_data_1_0[15: 8];
      tx_data[ 63: 56] <= dac_data_0_3[ 7: 0];
      tx_data[ 55: 48] <= dac_data_0_2[ 7: 0];
      tx_data[ 47: 40] <= dac_data_0_1[ 7: 0];
      tx_data[ 39: 32] <= dac_data_0_0[ 7: 0];
      tx_data[ 31: 24] <= dac_data_0_3[15: 8];
      tx_data[ 23: 16] <= dac_data_0_2[15: 8];
      tx_data[ 15:  8] <= dac_data_0_1[15: 8];
      tx_data[  7:  0] <= dac_data_0_0[15: 8];
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
