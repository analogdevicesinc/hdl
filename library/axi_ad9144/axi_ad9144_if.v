// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// This is the dac physical interface (drives samples from the low speed clock to the
// dac clock domain.

`timescale 1ns/100ps

module axi_ad9144_if (

  // jesd interface
  // tx_clk is (line-rate/40)

  tx_clk,
  tx_data,

  // dac interface

  dac_clk,
  dac_rst,
  dac_data_0_0,
  dac_data_0_1,
  dac_data_0_2,
  dac_data_0_3,
  dac_data_1_0,
  dac_data_1_1,
  dac_data_1_2,
  dac_data_1_3,
  dac_data_2_0,
  dac_data_2_1,
  dac_data_2_2,
  dac_data_2_3,
  dac_data_3_0,
  dac_data_3_1,
  dac_data_3_2,
  dac_data_3_3);

  // jesd interface
  // tx_clk is (line-rate/40)

  input           tx_clk;
  output [255:0]  tx_data;

  // dac interface

  output          dac_clk;
  input           dac_rst;
  input   [15:0]  dac_data_0_0;
  input   [15:0]  dac_data_0_1;
  input   [15:0]  dac_data_0_2;
  input   [15:0]  dac_data_0_3;
  input   [15:0]  dac_data_1_0;
  input   [15:0]  dac_data_1_1;
  input   [15:0]  dac_data_1_2;
  input   [15:0]  dac_data_1_3;
  input   [15:0]  dac_data_2_0;
  input   [15:0]  dac_data_2_1;
  input   [15:0]  dac_data_2_2;
  input   [15:0]  dac_data_2_3;
  input   [15:0]  dac_data_3_0;
  input   [15:0]  dac_data_3_1;
  input   [15:0]  dac_data_3_2;
  input   [15:0]  dac_data_3_3;

  // internal registers

  reg    [255:0]  tx_data = 'd0;

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
