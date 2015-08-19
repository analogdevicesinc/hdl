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

`timescale 1ns/100ps

module axi_ad9671_if (

  // jesd interface 
  // rx_clk is (line-rate/40)

  rx_clk,
  rx_sof,
  rx_data,

  // adc data output

  adc_clk,
  adc_rst,
  adc_valid,
  adc_data_a,
  adc_or_a,
  adc_data_b,
  adc_or_b,
  adc_data_c,
  adc_or_c,
  adc_data_d,
  adc_or_d,
  adc_data_e,
  adc_or_e,
  adc_data_f,
  adc_or_f,
  adc_data_g,
  adc_or_g,
  adc_data_h,
  adc_or_h,
  adc_start_code,
  adc_sync_in,
  adc_sync_out,
  adc_sync,
  adc_sync_status,
  adc_status,
  adc_raddr_in,
  adc_raddr_out);

  // parameters

  parameter PCORE_4L_2L_N = 1;
  parameter PCORE_ID = 0;

  // jesd interface 
  // rx_clk is (line-rate/40)

  input                                 rx_clk;
  input                                 rx_sof;
  input   [(64*PCORE_4L_2L_N)+63:0]     rx_data;

  // adc data output

  output                                adc_clk;
  input                                 adc_rst;
  output                                adc_valid;
  output  [ 15:0]                       adc_data_a;
  output                                adc_or_a;
  output  [ 15:0]                       adc_data_b;
  output                                adc_or_b;
  output  [ 15:0]                       adc_data_c;
  output                                adc_or_c;
  output  [ 15:0]                       adc_data_d;
  output                                adc_or_d;
  output  [ 15:0]                       adc_data_e;
  output                                adc_or_e;
  output  [ 15:0]                       adc_data_f;
  output                                adc_or_f;
  output  [ 15:0]                       adc_data_g;
  output                                adc_or_g;
  output  [ 15:0]                       adc_data_h;
  output                                adc_or_h;
  input   [ 31:0]                       adc_start_code;
  input                                 adc_sync_in;
  output                                adc_sync_out;
  input                                 adc_sync;
  output                                adc_sync_status;
  output                                adc_status;
  input   [ 3:0]                        adc_raddr_in;
  output  [ 3:0]                        adc_raddr_out;

  // internal wires

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
  reg                                   adc_status = 'd0;
  reg                                   adc_sync_status = 'd0;
  reg                                   rx_sof_d = 'd0;

  reg     [  3:0]                       adc_waddr = 'd0;
  reg     [  3:0]                       adc_raddr_out = 'd0;
  reg     [ 15:0]                       adc_data_a;
  reg     [ 15:0]                       adc_data_b;
  reg     [ 15:0]                       adc_data_c;
  reg     [ 15:0]                       adc_data_d;
  reg     [ 15:0]                       adc_data_e;
  reg     [ 15:0]                       adc_data_f;
  reg     [ 15:0]                       adc_data_g;
  reg     [ 15:0]                       adc_data_h;

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

  assign adc_raddr_s = (PCORE_ID == 0) ? adc_raddr_out : adc_raddr_in;
  assign adc_sync_s  = (PCORE_ID == 0) ? adc_sync_out : adc_sync_in;

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
    if (PCORE_4L_2L_N == 1'b1) begin
      int_valid <= 1'b1;
      int_data  <= rx_data;
    end else begin
      rx_sof_d          <= rx_sof;
      int_valid         <= rx_sof_d;
      int_data[63:0]    <= {rx_data[31:0], int_data[63:32]};
      int_data[127:64]  <= {rx_data[63:32], int_data[127:96]};
    end
  end

  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

  ad_mem #(.ADDR_WIDTH(4), .DATA_WIDTH(128)) i_mem (
    .clka(rx_clk),
    .wea(int_valid),
    .addra(adc_waddr),
    .dina(adc_wdata),
    .clkb(rx_clk),
    .addrb(adc_raddr_s),
    .doutb(adc_rdata));

endmodule

// ***************************************************************************
// ***************************************************************************

