// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory of
//      the repository (LICENSE_GPL2), and at: <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// This is the dac physical interface (drives samples from the low speed clock to the
// dac clock domain.

`timescale 1ns/100ps

module axi_ad9152_if #(

  // altera (0x1) or xilinx (0x0)

  parameter DEVICE_TYPE = 0)(

  // jesd interface
  // tx_clk is (line-rate/40)

  input                tx_clk,
  output reg  [127:0]  tx_data,

  // dac interface

  output               dac_clk,
  input                dac_rst,
  input       [15:0]   dac_data_0_0,
  input       [15:0]   dac_data_0_1,
  input       [15:0]   dac_data_0_2,
  input       [15:0]   dac_data_0_3,
  input       [15:0]   dac_data_1_0,
  input       [15:0]   dac_data_1_1,
  input       [15:0]   dac_data_1_2,
  input       [15:0]   dac_data_1_3);

  // reorder data for the jesd links

  assign dac_clk = tx_clk;

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      tx_data <= 128'd0;
    end else begin
      tx_data[127:120] <= (DEVICE_TYPE == 1) ? dac_data_1_0[ 7: 0] : dac_data_1_3[ 7: 0];
      tx_data[119:112] <= (DEVICE_TYPE == 1) ? dac_data_1_1[ 7: 0] : dac_data_1_2[ 7: 0];
      tx_data[111:104] <= (DEVICE_TYPE == 1) ? dac_data_1_2[ 7: 0] : dac_data_1_1[ 7: 0];
      tx_data[103: 96] <= (DEVICE_TYPE == 1) ? dac_data_1_3[ 7: 0] : dac_data_1_0[ 7: 0];
      tx_data[ 95: 88] <= (DEVICE_TYPE == 1) ? dac_data_1_0[15: 8] : dac_data_1_3[15: 8];
      tx_data[ 87: 80] <= (DEVICE_TYPE == 1) ? dac_data_1_1[15: 8] : dac_data_1_2[15: 8];
      tx_data[ 79: 72] <= (DEVICE_TYPE == 1) ? dac_data_1_2[15: 8] : dac_data_1_1[15: 8];
      tx_data[ 71: 64] <= (DEVICE_TYPE == 1) ? dac_data_1_3[15: 8] : dac_data_1_0[15: 8];
      tx_data[ 63: 56] <= (DEVICE_TYPE == 1) ? dac_data_0_0[ 7: 0] : dac_data_0_3[ 7: 0];
      tx_data[ 55: 48] <= (DEVICE_TYPE == 1) ? dac_data_0_1[ 7: 0] : dac_data_0_2[ 7: 0];
      tx_data[ 47: 40] <= (DEVICE_TYPE == 1) ? dac_data_0_2[ 7: 0] : dac_data_0_1[ 7: 0];
      tx_data[ 39: 32] <= (DEVICE_TYPE == 1) ? dac_data_0_3[ 7: 0] : dac_data_0_0[ 7: 0];
      tx_data[ 31: 24] <= (DEVICE_TYPE == 1) ? dac_data_0_0[15: 8] : dac_data_0_3[15: 8];
      tx_data[ 23: 16] <= (DEVICE_TYPE == 1) ? dac_data_0_1[15: 8] : dac_data_0_2[15: 8];
      tx_data[ 15:  8] <= (DEVICE_TYPE == 1) ? dac_data_0_2[15: 8] : dac_data_0_1[15: 8];
      tx_data[  7:  0] <= (DEVICE_TYPE == 1) ? dac_data_0_3[15: 8] : dac_data_0_0[15: 8];
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
