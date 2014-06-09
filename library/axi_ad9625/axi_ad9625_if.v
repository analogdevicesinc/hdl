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
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module axi_ad9625_if (

  // jesd interface 
  // rx_clk is (line-rate/40)

  rx_clk,
  rx_data,

  // adc data output

  adc_clk,
  adc_rst,
  adc_data,
  adc_or,
  adc_status);

  // jesd interface 
  // rx_clk is ref_clk/4

  input           rx_clk;
  input   [255:0] rx_data;

  // adc data output

  output          adc_clk;
  input           adc_rst;
  output  [191:0] adc_data;
  output          adc_or;
  output          adc_status;

  // internal registers

  reg             adc_status = 'd0;

  // internal signals

  wire    [ 15:0] adc_data_s15_s;
  wire    [ 15:0] adc_data_s14_s;
  wire    [ 15:0] adc_data_s13_s;
  wire    [ 15:0] adc_data_s12_s;
  wire    [ 15:0] adc_data_s11_s;
  wire    [ 15:0] adc_data_s10_s;
  wire    [ 15:0] adc_data_s09_s;
  wire    [ 15:0] adc_data_s08_s;
  wire    [ 15:0] adc_data_s07_s;
  wire    [ 15:0] adc_data_s06_s;
  wire    [ 15:0] adc_data_s05_s;
  wire    [ 15:0] adc_data_s04_s;
  wire    [ 15:0] adc_data_s03_s;
  wire    [ 15:0] adc_data_s02_s;
  wire    [ 15:0] adc_data_s01_s;
  wire    [ 15:0] adc_data_s00_s;
  wire    [ 31:0] rx_data0_s;
  wire    [ 31:0] rx_data1_s;
  wire    [ 31:0] rx_data2_s;
  wire    [ 31:0] rx_data3_s;
  wire    [ 31:0] rx_data4_s;
  wire    [ 31:0] rx_data5_s;
  wire    [ 31:0] rx_data6_s;
  wire    [ 31:0] rx_data7_s;

  assign adc_clk = rx_clk;
  assign adc_or = 1'b0;

  // samples only

  assign adc_data = {adc_data_s15_s[11:0], adc_data_s14_s[11:0],
    adc_data_s13_s[11:0], adc_data_s12_s[11:0], adc_data_s11_s[11:0],
    adc_data_s10_s[11:0], adc_data_s09_s[11:0], adc_data_s08_s[11:0],
    adc_data_s07_s[11:0], adc_data_s06_s[11:0], adc_data_s05_s[11:0],
    adc_data_s04_s[11:0], adc_data_s03_s[11:0], adc_data_s02_s[11:0],
    adc_data_s01_s[11:0], adc_data_s00_s[11:0]};

  // data is received across multiple lanes (reconstruct samples)

  assign adc_data_s15_s = {rx_data7_s[27:24], rx_data6_s[31:24], rx_data7_s[31:28]};
  assign adc_data_s14_s = {rx_data5_s[27:24], rx_data4_s[31:24], rx_data5_s[31:28]};
  assign adc_data_s13_s = {rx_data3_s[27:24], rx_data2_s[31:24], rx_data3_s[31:28]};
  assign adc_data_s12_s = {rx_data1_s[27:24], rx_data0_s[31:24], rx_data1_s[31:28]};
  assign adc_data_s11_s = {rx_data7_s[19:16], rx_data6_s[23:16], rx_data7_s[23:20]};
  assign adc_data_s10_s = {rx_data5_s[19:16], rx_data4_s[23:16], rx_data5_s[23:20]};
  assign adc_data_s09_s = {rx_data3_s[19:16], rx_data2_s[23:16], rx_data3_s[23:20]};
  assign adc_data_s08_s = {rx_data1_s[19:16], rx_data0_s[23:16], rx_data1_s[23:20]};
  assign adc_data_s07_s = {rx_data7_s[11: 8], rx_data6_s[15: 8], rx_data7_s[15:12]};
  assign adc_data_s06_s = {rx_data5_s[11: 8], rx_data4_s[15: 8], rx_data5_s[15:12]};
  assign adc_data_s05_s = {rx_data3_s[11: 8], rx_data2_s[15: 8], rx_data3_s[15:12]};
  assign adc_data_s04_s = {rx_data1_s[11: 8], rx_data0_s[15: 8], rx_data1_s[15:12]};
  assign adc_data_s03_s = {rx_data7_s[ 3: 0], rx_data6_s[ 7: 0], rx_data7_s[ 7: 4]};
  assign adc_data_s02_s = {rx_data5_s[ 3: 0], rx_data4_s[ 7: 0], rx_data5_s[ 7: 4]};
  assign adc_data_s01_s = {rx_data3_s[ 3: 0], rx_data2_s[ 7: 0], rx_data3_s[ 7: 4]};
  assign adc_data_s00_s = {rx_data1_s[ 3: 0], rx_data0_s[ 7: 0], rx_data1_s[ 7: 4]};

  assign rx_data0_s = rx_data[ 31:  0];
  assign rx_data1_s = rx_data[ 63: 32];
  assign rx_data2_s = rx_data[ 95: 64];
  assign rx_data3_s = rx_data[127: 96];
  assign rx_data4_s = rx_data[159:128];
  assign rx_data5_s = rx_data[191:160];
  assign rx_data6_s = rx_data[223:192];
  assign rx_data7_s = rx_data[255:224];

  // status

  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************

