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

module axi_ad9625_if #(

  parameter   ID = 0) (
  // jesd interface
  // rx_clk is (line-rate/40)

  input                   rx_clk,
  input       [  3:0]     rx_sof,
  input       [255:0]     rx_data,

  // adc data output

  output                  adc_clk,
  input                   adc_rst,
  output      [191:0]     adc_data,
  output                  adc_or,
  output                  adc_status,
  output      [ 15:0]     adc_sref,
  input                   adc_sref_sync,
  input       [  3:0]     adc_raddr_in,
  output      [  3:0]     adc_raddr_out);

  // internal registers

  reg         [191:0]     adc_data_int = 'd0;
  reg                     adc_status_int = 'd0;
  reg         [ 15:0]     adc_sref_int = 'd0;
  reg         [191:0]     adc_data_cur = 'd0;
  reg         [191:0]     adc_data_prv = 'd0;
  reg         [  3:0]     adc_waddr = 'd0;
  reg         [191:0]     adc_wdata = 'd0;
  reg         [  3:0]     adc_raddr = 'd0;

  // internal signals

  wire        [191:0]     adc_rdata_s;
  wire        [  3:0]     adc_raddr_s;
  wire        [ 15:0]     adc_sref_s;
  wire        [191:0]     adc_data_s;
  wire        [ 15:0]     adc_data_s15_s;
  wire        [ 15:0]     adc_data_s14_s;
  wire        [ 15:0]     adc_data_s13_s;
  wire        [ 15:0]     adc_data_s12_s;
  wire        [ 15:0]     adc_data_s11_s;
  wire        [ 15:0]     adc_data_s10_s;
  wire        [ 15:0]     adc_data_s09_s;
  wire        [ 15:0]     adc_data_s08_s;
  wire        [ 15:0]     adc_data_s07_s;
  wire        [ 15:0]     adc_data_s06_s;
  wire        [ 15:0]     adc_data_s05_s;
  wire        [ 15:0]     adc_data_s04_s;
  wire        [ 15:0]     adc_data_s03_s;
  wire        [ 15:0]     adc_data_s02_s;
  wire        [ 15:0]     adc_data_s01_s;
  wire        [ 15:0]     adc_data_s00_s;
  wire        [ 31:0]     rx_data0_s;
  wire        [ 31:0]     rx_data1_s;
  wire        [ 31:0]     rx_data2_s;
  wire        [ 31:0]     rx_data3_s;
  wire        [ 31:0]     rx_data4_s;
  wire        [ 31:0]     rx_data5_s;
  wire        [ 31:0]     rx_data6_s;
  wire        [ 31:0]     rx_data7_s;
  wire        [255:0]     rx_data_s;

  // nothing much to do on clock & over-range

  assign adc_clk = rx_clk;
  assign adc_or = 1'b0;

  // synchronization mode, multiple instances

  assign adc_data = adc_data_int;
  assign adc_status = adc_status_int;
  assign adc_sref = adc_sref_int;
  assign adc_raddr_out = adc_raddr;
  assign adc_raddr_s = (ID == 0) ? adc_raddr : adc_raddr_in;

  always @(posedge rx_clk) begin
    if (adc_sref_sync == 1'b1) begin
      adc_data_int <= adc_rdata_s;
    end else begin
      adc_data_int <= adc_data_s;
    end
    if (adc_sref_s != 16'd0) begin
      adc_sref_int <= adc_sref_s;
    end
    adc_data_cur <= adc_data_s;
    adc_data_prv <= adc_data_cur;
    if (adc_sref_s == 16'd0) begin
      adc_waddr <= adc_waddr + 1'b1;
      adc_raddr <= adc_raddr + 1'b1;
    end else begin
      adc_waddr <= 4'h0;
      adc_raddr <= 4'h8;
    end
    case (adc_sref_int)
      16'h8000: adc_wdata <= {adc_data_cur[179:0], adc_data_prv[191:180]};
      16'h4000: adc_wdata <= {adc_data_cur[167:0], adc_data_prv[191:168]};
      16'h2000: adc_wdata <= {adc_data_cur[155:0], adc_data_prv[191:156]};
      16'h1000: adc_wdata <= {adc_data_cur[143:0], adc_data_prv[191:144]};
      16'h0800: adc_wdata <= {adc_data_cur[131:0], adc_data_prv[191:132]};
      16'h0400: adc_wdata <= {adc_data_cur[119:0], adc_data_prv[191:120]};
      16'h0200: adc_wdata <= {adc_data_cur[107:0], adc_data_prv[191:108]};
      16'h0100: adc_wdata <= {adc_data_cur[ 95:0], adc_data_prv[191: 96]};
      16'h0080: adc_wdata <= {adc_data_cur[ 83:0], adc_data_prv[191: 84]};
      16'h0040: adc_wdata <= {adc_data_cur[ 71:0], adc_data_prv[191: 72]};
      16'h0020: adc_wdata <= {adc_data_cur[ 59:0], adc_data_prv[191: 60]};
      16'h0010: adc_wdata <= {adc_data_cur[ 47:0], adc_data_prv[191: 48]};
      16'h0008: adc_wdata <= {adc_data_cur[ 35:0], adc_data_prv[191: 36]};
      16'h0004: adc_wdata <= {adc_data_cur[ 23:0], adc_data_prv[191: 24]};
      16'h0002: adc_wdata <= {adc_data_cur[ 11:0], adc_data_prv[191: 12]};
      default:  adc_wdata <= adc_data_prv;
    endcase
  end

  // samples only

  assign adc_sref_s = {adc_data_s15_s[14], adc_data_s14_s[14],
    adc_data_s13_s[14], adc_data_s12_s[14], adc_data_s11_s[14],
    adc_data_s10_s[14], adc_data_s09_s[14], adc_data_s08_s[14],
    adc_data_s07_s[14], adc_data_s06_s[14], adc_data_s05_s[14],
    adc_data_s04_s[14], adc_data_s03_s[14], adc_data_s02_s[14],
    adc_data_s01_s[14], adc_data_s00_s[14]};

  assign adc_data_s = {adc_data_s15_s[11:0], adc_data_s14_s[11:0],
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

  assign rx_data0_s = rx_data_s[ 31:  0];
  assign rx_data1_s = rx_data_s[ 63: 32];
  assign rx_data2_s = rx_data_s[ 95: 64];
  assign rx_data3_s = rx_data_s[127: 96];
  assign rx_data4_s = rx_data_s[159:128];
  assign rx_data5_s = rx_data_s[191:160];
  assign rx_data6_s = rx_data_s[223:192];
  assign rx_data7_s = rx_data_s[255:224];

  // status

  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status_int <= 1'b0;
    end else begin
      adc_status_int <= 1'b1;
    end
  end

  // alignment fifo

  ad_mem #(.ADDRESS_WIDTH(4), .DATA_WIDTH(192)) i_mem (
    .clka (rx_clk),
    .wea (1'b1),
    .addra (adc_waddr),
    .dina (adc_wdata),
    .clkb (rx_clk),
    .reb (1'b1),
    .addrb (adc_raddr_s),
    .doutb (adc_rdata_s));

  // frame-alignment

  genvar n;
  generate
  for (n = 0; n < 8; n = n + 1) begin: g_xcvr_if
  ad_xcvr_rx_if i_xcvr_if (
    .rx_clk (rx_clk),
    .rx_ip_sof (rx_sof),
    .rx_ip_data (rx_data[((n*32)+31):(n*32)]),
    .rx_sof (),
    .rx_data (rx_data_s[((n*32)+31):(n*32)]));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

