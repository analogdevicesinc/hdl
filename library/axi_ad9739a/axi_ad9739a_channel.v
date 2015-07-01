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

module axi_ad9739a_channel (

  // dac interface

  dac_div_clk,
  dac_rst,
  dac_enable,
  dac_data_00,
  dac_data_01,
  dac_data_02,
  dac_data_03,
  dac_data_04,
  dac_data_05,
  dac_data_06,
  dac_data_07,
  dac_data_08,
  dac_data_09,
  dac_data_10,
  dac_data_11,
  dac_data_12,
  dac_data_13,
  dac_data_14,
  dac_data_15,
  dma_data,

  // processor interface

  dac_data_sync,
  dac_dds_format,

  // bus interface

  up_rstn,
  up_clk,
  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack);

  // parameters

  parameter CHID = 32'h0;
  parameter DP_DISABLE = 0;

  // dac interface

  input             dac_div_clk;
  input             dac_rst;
  output            dac_enable;
  output  [ 15:0]   dac_data_00;
  output  [ 15:0]   dac_data_01;
  output  [ 15:0]   dac_data_02;
  output  [ 15:0]   dac_data_03;
  output  [ 15:0]   dac_data_04;
  output  [ 15:0]   dac_data_05;
  output  [ 15:0]   dac_data_06;
  output  [ 15:0]   dac_data_07;
  output  [ 15:0]   dac_data_08;
  output  [ 15:0]   dac_data_09;
  output  [ 15:0]   dac_data_10;
  output  [ 15:0]   dac_data_11;
  output  [ 15:0]   dac_data_12;
  output  [ 15:0]   dac_data_13;
  output  [ 15:0]   dac_data_14;
  output  [ 15:0]   dac_data_15;
  input   [255:0]   dma_data;

  // processor interface

  input             dac_data_sync;
  input             dac_dds_format;

  // bus interface

  input             up_rstn;
  input             up_clk;
  input             up_wreq;
  input   [ 13:0]   up_waddr;
  input   [ 31:0]   up_wdata;
  output            up_wack;
  input             up_rreq;
  input   [ 13:0]   up_raddr;
  output  [ 31:0]   up_rdata;
  output            up_rack;

  // internal registers

  reg               dac_enable = 'd0;
  reg     [ 15:0]   dac_data_00 = 'd0;
  reg     [ 15:0]   dac_data_01 = 'd0;
  reg     [ 15:0]   dac_data_02 = 'd0;
  reg     [ 15:0]   dac_data_03 = 'd0;
  reg     [ 15:0]   dac_data_04 = 'd0;
  reg     [ 15:0]   dac_data_05 = 'd0;
  reg     [ 15:0]   dac_data_06 = 'd0;
  reg     [ 15:0]   dac_data_07 = 'd0;
  reg     [ 15:0]   dac_data_08 = 'd0;
  reg     [ 15:0]   dac_data_09 = 'd0;
  reg     [ 15:0]   dac_data_10 = 'd0;
  reg     [ 15:0]   dac_data_11 = 'd0;
  reg     [ 15:0]   dac_data_12 = 'd0;
  reg     [ 15:0]   dac_data_13 = 'd0;
  reg     [ 15:0]   dac_data_14 = 'd0;
  reg     [ 15:0]   dac_data_15 = 'd0;
  reg     [ 15:0]   dac_dds_phase_00_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_00_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_01_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_01_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_02_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_02_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_03_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_03_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_04_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_04_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_05_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_05_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_06_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_06_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_07_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_07_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_08_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_08_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_09_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_09_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_10_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_10_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_11_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_11_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_12_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_12_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_13_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_13_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_14_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_14_1 = 'd0;
  reg     [ 15:0]   dac_dds_phase_15_0 = 'd0;
  reg     [ 15:0]   dac_dds_phase_15_1 = 'd0;
  reg     [ 15:0]   dac_dds_incr_0 = 'd0;
  reg     [ 15:0]   dac_dds_incr_1 = 'd0;
  reg     [ 15:0]   dac_dds_data_00 = 'd0;
  reg     [ 15:0]   dac_dds_data_01 = 'd0;
  reg     [ 15:0]   dac_dds_data_02 = 'd0;
  reg     [ 15:0]   dac_dds_data_03 = 'd0;
  reg     [ 15:0]   dac_dds_data_04 = 'd0;
  reg     [ 15:0]   dac_dds_data_05 = 'd0;
  reg     [ 15:0]   dac_dds_data_06 = 'd0;
  reg     [ 15:0]   dac_dds_data_07 = 'd0;
  reg     [ 15:0]   dac_dds_data_08 = 'd0;
  reg     [ 15:0]   dac_dds_data_09 = 'd0;
  reg     [ 15:0]   dac_dds_data_10 = 'd0;
  reg     [ 15:0]   dac_dds_data_11 = 'd0;
  reg     [ 15:0]   dac_dds_data_12 = 'd0;
  reg     [ 15:0]   dac_dds_data_13 = 'd0;
  reg     [ 15:0]   dac_dds_data_14 = 'd0;
  reg     [ 15:0]   dac_dds_data_15 = 'd0;

  // internal signals

  wire    [ 15:0]   dac_dds_data_00_s;
  wire    [ 15:0]   dac_dds_data_01_s;
  wire    [ 15:0]   dac_dds_data_02_s;
  wire    [ 15:0]   dac_dds_data_03_s;
  wire    [ 15:0]   dac_dds_data_04_s;
  wire    [ 15:0]   dac_dds_data_05_s;
  wire    [ 15:0]   dac_dds_data_06_s;
  wire    [ 15:0]   dac_dds_data_07_s;
  wire    [ 15:0]   dac_dds_data_08_s;
  wire    [ 15:0]   dac_dds_data_09_s;
  wire    [ 15:0]   dac_dds_data_10_s;
  wire    [ 15:0]   dac_dds_data_11_s;
  wire    [ 15:0]   dac_dds_data_12_s;
  wire    [ 15:0]   dac_dds_data_13_s;
  wire    [ 15:0]   dac_dds_data_14_s;
  wire    [ 15:0]   dac_dds_data_15_s;
  wire    [ 15:0]   dac_dds_scale_1_s;
  wire    [ 15:0]   dac_dds_init_1_s;
  wire    [ 15:0]   dac_dds_incr_1_s;
  wire    [ 15:0]   dac_dds_scale_2_s;
  wire    [ 15:0]   dac_dds_init_2_s;
  wire    [ 15:0]   dac_dds_incr_2_s;
  wire    [ 15:0]   dac_pat_data_1_s;
  wire    [ 15:0]   dac_pat_data_2_s;
  wire    [  3:0]   dac_data_sel_s;

  // dac data select

  always @(posedge dac_div_clk) begin
    dac_enable <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel_s)
      4'h2: begin
        dac_data_00 <= dma_data[ 15:  0];
        dac_data_01 <= dma_data[ 31: 16];
        dac_data_02 <= dma_data[ 47: 32];
        dac_data_03 <= dma_data[ 63: 48];
        dac_data_04 <= dma_data[ 79: 64];
        dac_data_05 <= dma_data[ 95: 80];
        dac_data_06 <= dma_data[111: 96];
        dac_data_07 <= dma_data[127:112];
        dac_data_08 <= dma_data[143:128];
        dac_data_09 <= dma_data[159:144];
        dac_data_10 <= dma_data[175:160];
        dac_data_11 <= dma_data[191:176];
        dac_data_12 <= dma_data[207:192];
        dac_data_13 <= dma_data[223:208];
        dac_data_14 <= dma_data[239:224];
        dac_data_15 <= dma_data[255:240];
      end
      4'h1: begin
        dac_data_00 <= dac_pat_data_1_s;
        dac_data_01 <= dac_pat_data_2_s;
        dac_data_02 <= dac_pat_data_1_s;
        dac_data_03 <= dac_pat_data_2_s;
        dac_data_04 <= dac_pat_data_1_s;
        dac_data_05 <= dac_pat_data_2_s;
        dac_data_06 <= dac_pat_data_1_s;
        dac_data_07 <= dac_pat_data_2_s;
        dac_data_08 <= dac_pat_data_1_s;
        dac_data_09 <= dac_pat_data_2_s;
        dac_data_10 <= dac_pat_data_1_s;
        dac_data_11 <= dac_pat_data_2_s;
        dac_data_12 <= dac_pat_data_1_s;
        dac_data_13 <= dac_pat_data_2_s;
        dac_data_14 <= dac_pat_data_1_s;
        dac_data_15 <= dac_pat_data_2_s;
      end
      default: begin
        dac_data_00 <= dac_dds_data_00;
        dac_data_01 <= dac_dds_data_01;
        dac_data_02 <= dac_dds_data_02;
        dac_data_03 <= dac_dds_data_03;
        dac_data_04 <= dac_dds_data_04;
        dac_data_05 <= dac_dds_data_05;
        dac_data_06 <= dac_dds_data_06;
        dac_data_07 <= dac_dds_data_07;
        dac_data_08 <= dac_dds_data_08;
        dac_data_09 <= dac_dds_data_09;
        dac_data_10 <= dac_dds_data_10;
        dac_data_11 <= dac_dds_data_11;
        dac_data_12 <= dac_dds_data_12;
        dac_data_13 <= dac_dds_data_13;
        dac_data_14 <= dac_dds_data_14;
        dac_data_15 <= dac_dds_data_15;
      end
    endcase
  end

  // single channel dds

  always @(posedge dac_div_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_dds_phase_00_0 <= dac_dds_init_1_s;
      dac_dds_phase_00_1 <= dac_dds_init_2_s;
      dac_dds_phase_01_0 <= dac_dds_phase_00_0 + dac_dds_incr_1_s;
      dac_dds_phase_01_1 <= dac_dds_phase_00_1 + dac_dds_incr_2_s;
      dac_dds_phase_02_0 <= dac_dds_phase_01_0 + dac_dds_incr_1_s;
      dac_dds_phase_02_1 <= dac_dds_phase_01_1 + dac_dds_incr_2_s;
      dac_dds_phase_03_0 <= dac_dds_phase_02_0 + dac_dds_incr_1_s;
      dac_dds_phase_03_1 <= dac_dds_phase_02_1 + dac_dds_incr_2_s;
      dac_dds_phase_04_0 <= dac_dds_phase_03_0 + dac_dds_incr_1_s;
      dac_dds_phase_04_1 <= dac_dds_phase_03_1 + dac_dds_incr_2_s;
      dac_dds_phase_05_0 <= dac_dds_phase_04_0 + dac_dds_incr_1_s;
      dac_dds_phase_05_1 <= dac_dds_phase_04_1 + dac_dds_incr_2_s;
      dac_dds_phase_06_0 <= dac_dds_phase_05_0 + dac_dds_incr_1_s;
      dac_dds_phase_06_1 <= dac_dds_phase_05_1 + dac_dds_incr_2_s;
      dac_dds_phase_07_0 <= dac_dds_phase_06_0 + dac_dds_incr_1_s;
      dac_dds_phase_07_1 <= dac_dds_phase_06_1 + dac_dds_incr_2_s;
      dac_dds_phase_08_0 <= dac_dds_phase_07_0 + dac_dds_incr_1_s;
      dac_dds_phase_08_1 <= dac_dds_phase_07_1 + dac_dds_incr_2_s;
      dac_dds_phase_09_0 <= dac_dds_phase_08_0 + dac_dds_incr_1_s;
      dac_dds_phase_09_1 <= dac_dds_phase_08_1 + dac_dds_incr_2_s;
      dac_dds_phase_10_0 <= dac_dds_phase_09_0 + dac_dds_incr_1_s;
      dac_dds_phase_10_1 <= dac_dds_phase_09_1 + dac_dds_incr_2_s;
      dac_dds_phase_11_0 <= dac_dds_phase_10_0 + dac_dds_incr_1_s;
      dac_dds_phase_11_1 <= dac_dds_phase_10_1 + dac_dds_incr_2_s;
      dac_dds_phase_12_0 <= dac_dds_phase_11_0 + dac_dds_incr_1_s;
      dac_dds_phase_12_1 <= dac_dds_phase_11_1 + dac_dds_incr_2_s;
      dac_dds_phase_13_0 <= dac_dds_phase_12_0 + dac_dds_incr_1_s;
      dac_dds_phase_13_1 <= dac_dds_phase_12_1 + dac_dds_incr_2_s;
      dac_dds_phase_14_0 <= dac_dds_phase_13_0 + dac_dds_incr_1_s;
      dac_dds_phase_14_1 <= dac_dds_phase_13_1 + dac_dds_incr_2_s;
      dac_dds_phase_15_0 <= dac_dds_phase_14_0 + dac_dds_incr_1_s;
      dac_dds_phase_15_1 <= dac_dds_phase_14_1 + dac_dds_incr_2_s;
      dac_dds_incr_0 <= {dac_dds_incr_1_s[11:0], 4'd0};
      dac_dds_incr_1 <= {dac_dds_incr_2_s[11:0], 4'd0};
      dac_dds_data_00 <= 15'd0;
      dac_dds_data_01 <= 15'd0;
      dac_dds_data_02 <= 15'd0;
      dac_dds_data_03 <= 15'd0;
      dac_dds_data_04 <= 15'd0;
      dac_dds_data_05 <= 15'd0;
      dac_dds_data_06 <= 15'd0;
      dac_dds_data_07 <= 15'd0;
      dac_dds_data_08 <= 15'd0;
      dac_dds_data_09 <= 15'd0;
      dac_dds_data_10 <= 15'd0;
      dac_dds_data_11 <= 15'd0;
      dac_dds_data_12 <= 15'd0;
      dac_dds_data_13 <= 15'd0;
      dac_dds_data_14 <= 15'd0;
      dac_dds_data_15 <= 15'd0;
    end else begin
      dac_dds_phase_00_0 <= dac_dds_phase_00_0 + dac_dds_incr_0;
      dac_dds_phase_00_1 <= dac_dds_phase_00_1 + dac_dds_incr_1;
      dac_dds_phase_01_0 <= dac_dds_phase_01_0 + dac_dds_incr_0;
      dac_dds_phase_01_1 <= dac_dds_phase_01_1 + dac_dds_incr_1;
      dac_dds_phase_02_0 <= dac_dds_phase_02_0 + dac_dds_incr_0;
      dac_dds_phase_02_1 <= dac_dds_phase_02_1 + dac_dds_incr_1;
      dac_dds_phase_03_0 <= dac_dds_phase_03_0 + dac_dds_incr_0;
      dac_dds_phase_03_1 <= dac_dds_phase_03_1 + dac_dds_incr_1;
      dac_dds_phase_04_0 <= dac_dds_phase_04_0 + dac_dds_incr_0;
      dac_dds_phase_04_1 <= dac_dds_phase_04_1 + dac_dds_incr_1;
      dac_dds_phase_05_0 <= dac_dds_phase_05_0 + dac_dds_incr_0;
      dac_dds_phase_05_1 <= dac_dds_phase_05_1 + dac_dds_incr_1;
      dac_dds_phase_06_0 <= dac_dds_phase_06_0 + dac_dds_incr_0;
      dac_dds_phase_06_1 <= dac_dds_phase_06_1 + dac_dds_incr_1;
      dac_dds_phase_07_0 <= dac_dds_phase_07_0 + dac_dds_incr_0;
      dac_dds_phase_07_1 <= dac_dds_phase_07_1 + dac_dds_incr_1;
      dac_dds_phase_08_0 <= dac_dds_phase_08_0 + dac_dds_incr_0;
      dac_dds_phase_08_1 <= dac_dds_phase_08_1 + dac_dds_incr_1;
      dac_dds_phase_09_0 <= dac_dds_phase_09_0 + dac_dds_incr_0;
      dac_dds_phase_09_1 <= dac_dds_phase_09_1 + dac_dds_incr_1;
      dac_dds_phase_10_0 <= dac_dds_phase_10_0 + dac_dds_incr_0;
      dac_dds_phase_10_1 <= dac_dds_phase_10_1 + dac_dds_incr_1;
      dac_dds_phase_11_0 <= dac_dds_phase_11_0 + dac_dds_incr_0;
      dac_dds_phase_11_1 <= dac_dds_phase_11_1 + dac_dds_incr_1;
      dac_dds_phase_12_0 <= dac_dds_phase_12_0 + dac_dds_incr_0;
      dac_dds_phase_12_1 <= dac_dds_phase_12_1 + dac_dds_incr_1;
      dac_dds_phase_13_0 <= dac_dds_phase_13_0 + dac_dds_incr_0;
      dac_dds_phase_13_1 <= dac_dds_phase_13_1 + dac_dds_incr_1;
      dac_dds_phase_14_0 <= dac_dds_phase_14_0 + dac_dds_incr_0;
      dac_dds_phase_14_1 <= dac_dds_phase_14_1 + dac_dds_incr_1;
      dac_dds_phase_15_0 <= dac_dds_phase_15_0 + dac_dds_incr_0;
      dac_dds_phase_15_1 <= dac_dds_phase_15_1 + dac_dds_incr_1;
      dac_dds_incr_0 <= dac_dds_incr_0;
      dac_dds_incr_1 <= dac_dds_incr_1;
      dac_dds_data_00 <= dac_dds_data_00_s;
      dac_dds_data_01 <= dac_dds_data_01_s;
      dac_dds_data_02 <= dac_dds_data_02_s;
      dac_dds_data_03 <= dac_dds_data_03_s;
      dac_dds_data_04 <= dac_dds_data_04_s;
      dac_dds_data_05 <= dac_dds_data_05_s;
      dac_dds_data_06 <= dac_dds_data_06_s;
      dac_dds_data_07 <= dac_dds_data_07_s;
      dac_dds_data_08 <= dac_dds_data_08_s;
      dac_dds_data_09 <= dac_dds_data_09_s;
      dac_dds_data_10 <= dac_dds_data_10_s;
      dac_dds_data_11 <= dac_dds_data_11_s;
      dac_dds_data_12 <= dac_dds_data_12_s;
      dac_dds_data_13 <= dac_dds_data_13_s;
      dac_dds_data_14 <= dac_dds_data_14_s;
      dac_dds_data_15 <= dac_dds_data_15_s;
    end
  end

  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_00_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_00_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_00_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_00_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_01_s = 16'd0;
  end else begin
  ad_dds i_dds_1 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_01_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_01_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_01_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_02_s = 16'd0;
  end else begin
  ad_dds i_dds_2 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_02_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_02_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_02_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_03_s = 16'd0;
  end else begin
  ad_dds i_dds_3 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_03_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_03_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_03_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_04_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_04_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_04_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_04_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_05_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_05_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_05_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_05_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_06_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_06_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_06_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_06_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_07_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_07_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_07_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_07_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_08_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_08_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_08_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_08_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_09_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_09_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_09_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_09_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_10_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_10_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_10_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_10_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_11_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_11_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_11_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_11_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_12_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_12_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_12_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_12_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_13_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_13_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_13_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_13_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_14_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_14_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_14_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_14_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_15_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_15_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_15_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_15_s));
  end
  endgenerate
  
  // single channel processor

  up_dac_channel #(.PCORE_DAC_CHID(CHID)) i_up_dac_channel (
    .dac_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_dds_scale_1 (dac_dds_scale_1_s),
    .dac_dds_init_1 (dac_dds_init_1_s),
    .dac_dds_incr_1 (dac_dds_incr_1_s),
    .dac_dds_scale_2 (dac_dds_scale_2_s),
    .dac_dds_init_2 (dac_dds_init_2_s),
    .dac_dds_incr_2 (dac_dds_incr_2_s),
    .dac_pat_data_1 (dac_pat_data_1_s),
    .dac_pat_data_2 (dac_pat_data_2_s),
    .dac_data_sel (dac_data_sel_s),
    .dac_iqcor_enb (),
    .dac_iqcor_coeff_1 (),
    .dac_iqcor_coeff_2 (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_interpolation_m (),
    .up_usr_interpolation_n (),
    .dac_usr_datatype_be (1'b0),
    .dac_usr_datatype_signed (1'b1),
    .dac_usr_datatype_shift (8'd0),
    .dac_usr_datatype_total_bits (8'd16),
    .dac_usr_datatype_bits (8'd16),
    .dac_usr_interpolation_m (16'd1),
    .dac_usr_interpolation_n (16'd1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));
  
endmodule

// ***************************************************************************
// ***************************************************************************
