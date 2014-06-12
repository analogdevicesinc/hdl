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

module axi_ad9144_core (

  // dac interface

  dac_clk,
  dac_rst,
  dac_data_i0_0,
  dac_data_i0_1,
  dac_data_i0_2,
  dac_data_i0_3,
  dac_data_q0_0,
  dac_data_q0_1,
  dac_data_q0_2,
  dac_data_q0_3,
  dac_data_i1_0,
  dac_data_i1_1,
  dac_data_i1_2,
  dac_data_i1_3,
  dac_data_q1_0,
  dac_data_q1_1,
  dac_data_q1_2,
  dac_data_q1_3,

  // dma interface

  dac_drd,
  dac_ddata,
  dac_dovf,
  dac_dunf,

  // processor interface

  up_rstn,
  up_clk,
  up_sel,
  up_wr,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack);

  // parameters

  parameter   PCORE_ID = 0;
  parameter   DP_DISABLE = 0;

  // dac interface

  input           dac_clk;
  output          dac_rst;
  output  [15:0]  dac_data_i0_0;
  output  [15:0]  dac_data_i0_1;
  output  [15:0]  dac_data_i0_2;
  output  [15:0]  dac_data_i0_3;
  output  [15:0]  dac_data_q0_0;
  output  [15:0]  dac_data_q0_1;
  output  [15:0]  dac_data_q0_2;
  output  [15:0]  dac_data_q0_3;
  output  [15:0]  dac_data_i1_0;
  output  [15:0]  dac_data_i1_1;
  output  [15:0]  dac_data_i1_2;
  output  [15:0]  dac_data_i1_3;
  output  [15:0]  dac_data_q1_0;
  output  [15:0]  dac_data_q1_1;
  output  [15:0]  dac_data_q1_2;
  output  [15:0]  dac_data_q1_3;

  // dma interface

  output          dac_drd;
  input  [255:0]  dac_ddata;
  input           dac_dovf;
  input           dac_dunf;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_wr;
  input   [13:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // internal registers

  reg             dac_enable = 'd0;
  reg     [15:0]  dac_data_i0_0 = 'd0;
  reg     [15:0]  dac_data_i0_1 = 'd0;
  reg     [15:0]  dac_data_i0_2 = 'd0;
  reg     [15:0]  dac_data_i0_3 = 'd0;
  reg     [15:0]  dac_data_q0_0 = 'd0;
  reg     [15:0]  dac_data_q0_1 = 'd0;
  reg     [15:0]  dac_data_q0_2 = 'd0;
  reg     [15:0]  dac_data_q0_3 = 'd0;
  reg     [15:0]  dac_data_i1_0 = 'd0;
  reg     [15:0]  dac_data_i1_1 = 'd0;
  reg     [15:0]  dac_data_i1_2 = 'd0;
  reg     [15:0]  dac_data_i1_3 = 'd0;
  reg     [15:0]  dac_data_q1_0 = 'd0;
  reg     [15:0]  dac_data_q1_1 = 'd0;
  reg     [15:0]  dac_data_q1_2 = 'd0;
  reg     [15:0]  dac_data_q1_3 = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_ack = 'd0;

  // internal signals

  wire            dac_enable_s;
  wire            dac_datafmt_s;
  wire    [ 3:0]  dac_datasel_s;
  wire    [15:0]  dac_dds_data_0_0_s;
  wire    [15:0]  dac_dds_data_0_1_s;
  wire    [15:0]  dac_dds_data_0_2_s;
  wire    [15:0]  dac_dds_data_0_3_s;
  wire    [15:0]  dac_dds_data_1_0_s;
  wire    [15:0]  dac_dds_data_1_1_s;
  wire    [15:0]  dac_dds_data_1_2_s;
  wire    [15:0]  dac_dds_data_1_3_s;
  wire    [15:0]  dac_dds_data_2_0_s;
  wire    [15:0]  dac_dds_data_2_1_s;
  wire    [15:0]  dac_dds_data_2_2_s;
  wire    [15:0]  dac_dds_data_2_3_s;
  wire    [15:0]  dac_dds_data_3_0_s;
  wire    [15:0]  dac_dds_data_3_1_s;
  wire    [15:0]  dac_dds_data_3_2_s;
  wire    [15:0]  dac_dds_data_3_3_s;
  wire    [31:0]  up_rdata_0_s;
  wire            up_ack_0_s;
  wire    [31:0]  up_rdata_1_s;
  wire            up_ack_1_s;
  wire    [31:0]  up_rdata_2_s;
  wire            up_ack_2_s;
  wire    [31:0]  up_rdata_3_s;
  wire            up_ack_3_s;
  wire    [31:0]  up_rdata_s;
  wire            up_ack_s;

  // dac dma read

  assign dac_drd = dac_enable;

  always @(posedge dac_clk) begin
    dac_enable <= dac_enable_s;
  end

  // dac outputs

  always @(posedge dac_clk) begin
    if (dac_datasel_s[3:1] == 3'd1) begin
      dac_data_i0_0 <= dac_ddata[ 15:  0];
      dac_data_i0_1 <= dac_ddata[ 79: 64];
      dac_data_i0_2 <= dac_ddata[143:128];
      dac_data_i0_3 <= dac_ddata[207:192];
      dac_data_q0_0 <= dac_ddata[ 31: 16];
      dac_data_q0_1 <= dac_ddata[ 95: 80];
      dac_data_q0_2 <= dac_ddata[159:144];
      dac_data_q0_3 <= dac_ddata[223:208];
      dac_data_i1_0 <= dac_ddata[ 47: 32];
      dac_data_i1_1 <= dac_ddata[111: 96];
      dac_data_i1_2 <= dac_ddata[175:160];
      dac_data_i1_3 <= dac_ddata[239:224];
      dac_data_q1_0 <= dac_ddata[ 63: 48];
      dac_data_q1_1 <= dac_ddata[127:112];
      dac_data_q1_2 <= dac_ddata[191:176];
      dac_data_q1_3 <= dac_ddata[255:240];
    end else begin
      dac_data_i0_0 <= dac_dds_data_0_0_s;
      dac_data_i0_1 <= dac_dds_data_0_1_s;
      dac_data_i0_2 <= dac_dds_data_0_2_s;
      dac_data_i0_3 <= dac_dds_data_0_3_s;
      dac_data_q0_0 <= dac_dds_data_1_0_s;
      dac_data_q0_1 <= dac_dds_data_1_1_s;
      dac_data_q0_2 <= dac_dds_data_1_2_s;
      dac_data_q0_3 <= dac_dds_data_1_3_s;
      dac_data_i1_0 <= dac_dds_data_2_0_s;
      dac_data_i1_1 <= dac_dds_data_2_1_s;
      dac_data_i1_2 <= dac_dds_data_2_2_s;
      dac_data_i1_3 <= dac_dds_data_2_3_s;
      dac_data_q1_0 <= dac_dds_data_3_0_s;
      dac_data_q1_1 <= dac_dds_data_3_1_s;
      dac_data_q1_2 <= dac_dds_data_3_2_s;
      dac_data_q1_3 <= dac_dds_data_3_3_s;
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_ack <= 'd0;
    end else begin
      up_rdata <= up_rdata_s | up_rdata_0_s | up_rdata_1_s | up_rdata_2_s | up_rdata_3_s;
      up_ack <= up_ack_s | up_ack_0_s | up_ack_1_s | up_ack_2_s | up_ack_3_s;
    end
  end

  // dac channel
  
  axi_ad9144_channel #(
    .CHID(0),
    .DP_DISABLE(DP_DISABLE))
  i_channel_0 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_data_0 (dac_dds_data_0_0_s),
    .dac_dds_data_1 (dac_dds_data_0_1_s),
    .dac_dds_data_2 (dac_dds_data_0_2_s),
    .dac_dds_data_3 (dac_dds_data_0_3_s),
    .dac_dds_enable (dac_enable),
    .dac_dds_format (dac_datafmt_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_0_s),
    .up_ack (up_ack_0_s));

  // dac channel
  
  axi_ad9144_channel #(
    .CHID(1),
    .DP_DISABLE(DP_DISABLE))
  i_channel_1 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_data_0 (dac_dds_data_1_0_s),
    .dac_dds_data_1 (dac_dds_data_1_1_s),
    .dac_dds_data_2 (dac_dds_data_1_2_s),
    .dac_dds_data_3 (dac_dds_data_1_3_s),
    .dac_dds_enable (dac_enable),
    .dac_dds_format (dac_datafmt_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_1_s),
    .up_ack (up_ack_1_s));

  // dac channel
  
  axi_ad9144_channel #(
    .CHID(2),
    .DP_DISABLE(DP_DISABLE))
  i_channel_2 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_data_0 (dac_dds_data_2_0_s),
    .dac_dds_data_1 (dac_dds_data_2_1_s),
    .dac_dds_data_2 (dac_dds_data_2_2_s),
    .dac_dds_data_3 (dac_dds_data_2_3_s),
    .dac_dds_enable (dac_enable),
    .dac_dds_format (dac_datafmt_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_2_s),
    .up_ack (up_ack_2_s));

  // dac channel
  
  axi_ad9144_channel #(
    .CHID(3),
    .DP_DISABLE(DP_DISABLE))
  i_channel_3 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_data_0 (dac_dds_data_3_0_s),
    .dac_dds_data_1 (dac_dds_data_3_1_s),
    .dac_dds_data_2 (dac_dds_data_3_2_s),
    .dac_dds_data_3 (dac_dds_data_3_3_s),
    .dac_dds_enable (dac_enable),
    .dac_dds_format (dac_datafmt_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_3_s),
    .up_ack (up_ack_3_s));

  // dac common processor interface

  up_dac_common #(.PCORE_ID(PCORE_ID)) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_enable (dac_enable_s),
    .dac_frame (),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .dac_datafmt (dac_datafmt_s),
    .dac_datasel (dac_datasel_s),
    .dac_datarate (),
    .dac_status (1'b1),
    .dac_status_ovf (dac_dovf),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (32'd40),
    .drp_clk (up_clk),
    .drp_rst (),
    .drp_sel (),
    .drp_wr (),
    .drp_addr (),
    .drp_wdata (),
    .drp_rdata (16'd0),
    .drp_ready (1'd0),
    .drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd3),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_s),
    .up_ack (up_ack_s));
  
endmodule

// ***************************************************************************
// ***************************************************************************
