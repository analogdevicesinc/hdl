// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad9671_if #(

  parameter QUAD_OR_DUAL_N = 1,
  parameter ID = 0
) (

  // jesd interface
  // rx_clk is (line-rate/40)

  input                   rx_clk,
  input       [ 3:0]      rx_sof,
  input       [(64*QUAD_OR_DUAL_N)+63:0]  rx_data,

  // adc data output

  output                  adc_clk,
  input                   adc_rst,
  output                  adc_valid,
  output  reg [ 15:0]     adc_data_a,
  output                  adc_or_a,
  output  reg [ 15:0]     adc_data_b,
  output                  adc_or_b,
  output  reg [ 15:0]     adc_data_c,
  output                  adc_or_c,
  output  reg [ 15:0]     adc_data_d,
  output                  adc_or_d,
  output  reg [ 15:0]     adc_data_e,
  output                  adc_or_e,
  output  reg [ 15:0]     adc_data_f,
  output                  adc_or_f,
  output  reg [ 15:0]     adc_data_g,
  output                  adc_or_g,
  output  reg [ 15:0]     adc_data_h,
  output                  adc_or_h,
  input       [ 31:0]     adc_start_code,
  input                   adc_sync_in,
  output                  adc_sync_out,
  input                   adc_sync,
  output  reg             adc_sync_status,
  output  reg             adc_status,
  input       [ 3:0]      adc_raddr_in,
  output  reg [ 3:0]      adc_raddr_out
);

  // internal wires

  wire    [(2*QUAD_OR_DUAL_N)+1:0]      rx_sof_s;
  wire    [(64*QUAD_OR_DUAL_N)+63:0]    rx_data_s;
  wire    [127:0]                       adc_wdata;
  wire    [127:0]                       adc_rdata;
  wire    [ 15:0]                       adc_data_a_s;
  wire    [ 15:0]                       adc_data_b_s;
  wire    [ 15:0]                       adc_data_c_s;
  wire    [ 15:0]                       adc_data_d_s;
  wire    [ 15:0]                       adc_data_e_s;
  wire    [ 15:0]                       adc_data_f_s;
  wire    [ 15:0]                       adc_data_g_s;
  wire    [ 15:0]                       adc_data_h_s;
  wire    [  3:0]                       adc_raddr_s;
  wire                                  adc_sync_s;

  // internal registers

  reg                                   int_valid = 'd0;
  reg     [127:0]                       int_data = 'd0;
  reg                                   rx_sof_d = 'd0;
  reg     [  3:0]                       adc_waddr = 'd0;

  // adc clock & valid

  assign adc_clk = rx_clk;
  assign adc_valid = int_valid;
  assign adc_sync_out = adc_sync;

  assign adc_or_a = 'd0;
  assign adc_or_b = 'd0;
  assign adc_or_c = 'd0;
  assign adc_or_d = 'd0;
  assign adc_or_e = 'd0;
  assign adc_or_f = 'd0;
  assign adc_or_g = 'd0;
  assign adc_or_h = 'd0;

  assign adc_data_a_s = {int_data[  7:  0], int_data[ 15:  8]};
  assign adc_data_b_s = {int_data[ 23: 16], int_data[ 31: 24]};
  assign adc_data_c_s = {int_data[ 39: 32], int_data[ 47: 40]};
  assign adc_data_d_s = {int_data[ 55: 48], int_data[ 63: 56]};
  assign adc_data_e_s = {int_data[ 71: 64], int_data[ 79: 72]};
  assign adc_data_f_s = {int_data[ 87: 80], int_data[ 95: 88]};
  assign adc_data_g_s = {int_data[103: 96], int_data[111:104]};
  assign adc_data_h_s = {int_data[119:112], int_data[127:120]};

  assign adc_wdata = {adc_data_h_s, adc_data_g_s, adc_data_f_s, adc_data_e_s,
                      adc_data_d_s, adc_data_c_s, adc_data_b_s, adc_data_a_s};

  assign adc_raddr_s = (ID == 0) ? adc_raddr_out : adc_raddr_in;
  assign adc_sync_s  = (ID == 0) ? adc_sync_out : adc_sync_in;

  always @(posedge rx_clk) begin
    adc_data_a <= adc_rdata[ 15:  0];
    adc_data_b <= adc_rdata[ 31: 16];
    adc_data_c <= adc_rdata[ 47: 32];
    adc_data_d <= adc_rdata[ 63: 48];
    adc_data_e <= adc_rdata[ 79: 64];
    adc_data_f <= adc_rdata[ 95: 80];
    adc_data_g <= adc_rdata[111: 96];
    adc_data_h <= adc_rdata[127:112];
  end

  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_waddr       <= 4'h0;
      adc_raddr_out   <= 4'h8;
      adc_sync_status <= 1'b0;
    end else begin
      if (adc_data_d_s == adc_start_code[15:0] && adc_sync_status == 1'b1) begin
        adc_sync_status <= 1'b0;
      end else if(adc_sync_s == 1'b1) begin
        adc_sync_status <= 1'b1;
      end
      if (adc_data_d_s == adc_start_code[15:0] && adc_sync_status == 1'b1) begin
        adc_waddr       <= 4'h0;
        adc_raddr_out   <= 4'h8;
      end else if (int_valid == 1'b1) begin
        adc_waddr       <= adc_waddr + 1;
        adc_raddr_out   <= adc_raddr_out + 1;
      end
    end
  end

  always @(posedge rx_clk) begin
    if (QUAD_OR_DUAL_N == 1'b1) begin
      int_valid <= 1'b1;
      int_data  <= rx_data_s;
    end else begin
      rx_sof_d          <= &rx_sof_s;
      int_valid         <= rx_sof_d;
      int_data[63:0]    <= {rx_data_s[31: 0], int_data[ 63:32]};
      int_data[127:64]  <= {rx_data_s[63:32], int_data[127:96]};
    end
  end

  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

  ad_mem #(
    .ADDRESS_WIDTH(4),
    .DATA_WIDTH(128)
  ) i_mem (
    .clka(rx_clk),
    .wea(int_valid),
    .addra(adc_waddr),
    .dina(adc_wdata),
    .clkb(rx_clk),
    .reb (1'b1),
    .addrb(adc_raddr_s),
    .doutb(adc_rdata));

  // frame-alignment

  genvar n;

  generate
  for (n = 0; n < ((2*QUAD_OR_DUAL_N)+2); n = n + 1) begin: g_xcvr_if
  ad_xcvr_rx_if i_xcvr_if (
    .rx_clk (rx_clk),
    .rx_ip_sof (rx_sof),
    .rx_ip_data (rx_data[((n*32)+31):(n*32)]),
    .rx_sof (rx_sof_s[n]),
    .rx_data (rx_data_s[((n*32)+31):(n*32)]));
  end
  endgenerate

endmodule
