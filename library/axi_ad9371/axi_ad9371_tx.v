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

`timescale 1ns/100ps

module axi_ad9371_tx (

  // dac interface

  dac_rst,
  dac_clk,
  dac_data,
  
  // master/slave

  dac_sync_in,
  dac_sync_out,

  // dma interface

  dac_enable_i0,
  dac_valid_i0,
  dac_data_i0,
  dac_enable_q0,
  dac_valid_q0,
  dac_data_q0,
  dac_enable_i1,
  dac_valid_i1,
  dac_data_i1,
  dac_enable_q1,
  dac_valid_q1,
  dac_data_q1,
  dac_dovf,
  dac_dunf,

  // processor interface

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

  parameter   DATAPATH_DISABLE = 0;
  parameter   ID = 0;

  // dac interface

  output            dac_rst;
  input             dac_clk;
  output  [127:0]   dac_data;
  
  // master/slave

  input             dac_sync_in;
  output            dac_sync_out;

  // dma interface

  output            dac_enable_i0;
  output            dac_valid_i0;
  input   [ 31:0]   dac_data_i0;
  output            dac_enable_q0;
  output            dac_valid_q0;
  input   [ 31:0]   dac_data_q0;
  output            dac_enable_i1;
  output            dac_valid_i1;
  input   [ 31:0]   dac_data_i1;
  output            dac_enable_q1;
  output            dac_valid_q1;
  input   [ 31:0]   dac_data_q1;
  input             dac_dovf;
  input             dac_dunf;

  // processor interface

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

  reg               dac_data_sync = 'd0;
  reg               up_wack = 'd0;
  reg               up_rack = 'd0;
  reg     [ 31:0]   up_rdata = 'd0;

  // internal signals

  wire              dac_data_sync_s;
  wire    [ 31:0]   dac_data_iq_i0_s;
  wire    [ 31:0]   dac_data_iq_q0_s;
  wire    [ 31:0]   dac_data_iq_i1_s;
  wire    [ 31:0]   dac_data_iq_q1_s;
  wire              dac_dds_format_s;
  wire    [  4:0]   up_wack_s;
  wire    [  4:0]   up_rack_s;
  wire    [ 31:0]   up_rdata_s[0:4];

  // master/slave

  assign dac_data_sync_s = (ID == 0) ? dac_sync_out : dac_sync_in;

  always @(posedge dac_clk) begin
    dac_data_sync <= dac_data_sync_s;
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= | up_wack_s;
      up_rack <= | up_rack_s;
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] |
        up_rdata_s[3] | up_rdata_s[4];
    end
  end

  // dac channel

  assign dac_valid_i0 = 1'b1;
  
  axi_ad9371_tx_channel #(
    .CHANNEL_ID (0),
    .Q_OR_I_N (0),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_tx_channel_0 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_data_in (dac_data_i0),
    .dac_data_out (dac_data[31:0]),
    .dac_data_iq_in (dac_data_iq_q0_s),
    .dac_data_iq_out (dac_data_iq_i0_s),
    .dac_enable (dac_enable_i0),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  // dac channel
  
  assign dac_valid_q0 = 1'b1;

  axi_ad9371_tx_channel #(
    .CHANNEL_ID (1),
    .Q_OR_I_N (1),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_tx_channel_1 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_data_in (dac_data_q0),
    .dac_data_out (dac_data[63:32]),
    .dac_data_iq_in (dac_data_iq_i0_s),
    .dac_data_iq_out (dac_data_iq_q0_s),
    .dac_enable (dac_enable_q0),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  // dac channel
  
  assign dac_valid_i1 = 1'b1;

  axi_ad9371_tx_channel #(
    .CHANNEL_ID (2),
    .Q_OR_I_N (0),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_tx_channel_2 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_data_in (dac_data_i1),
    .dac_data_out (dac_data[95:64]),
    .dac_data_iq_in (dac_data_iq_q1_s),
    .dac_data_iq_out (dac_data_iq_i1_s),
    .dac_enable (dac_enable_i1),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

  // dac channel
  
  assign dac_valid_q1 = 1'b1;

  axi_ad9371_tx_channel #(
    .CHANNEL_ID (3),
    .Q_OR_I_N (1),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_tx_channel_3 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_data_in (dac_data_q1),
    .dac_data_out (dac_data[127:96]),
    .dac_data_iq_in (dac_data_iq_i1_s),
    .dac_data_iq_out (dac_data_iq_q1_s),
    .dac_enable (dac_enable_q1),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[3]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[3]),
    .up_rack (up_rack_s[3]));

  // dac common processor interface

  up_dac_common #(.ID (ID)) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_sync (dac_sync_out),
    .dac_frame (),
    .dac_clksel (),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .dac_datafmt (dac_dds_format_s),
    .dac_datarate (),
    .dac_status (1'b1),
    .dac_status_ovf (dac_dovf),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (32'd1),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (32'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd3),
    .up_dac_gpio_in (32'd0),
    .up_dac_gpio_out (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[4]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[4]),
    .up_rack (up_rack_s[4]));
  
endmodule

// ***************************************************************************
// ***************************************************************************
