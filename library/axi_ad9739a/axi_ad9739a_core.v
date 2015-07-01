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

module axi_ad9739a_core (

  // dac interface

  dac_div_clk,
  dac_rst,
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
  dac_status,

  // dma interface

  dac_valid,
  dac_enable,
  dac_ddata,
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

  parameter   PCORE_ID = 0;
  parameter   DP_DISABLE = 0;

  // dac interface

  input             dac_div_clk;
  output            dac_rst;
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
  input             dac_status;

  // dma interface

  output            dac_valid;
  output            dac_enable;
  input   [255:0]   dac_ddata;
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

  reg     [ 31:0]   up_rdata = 'd0;
  reg               up_rack = 'd0;
  reg               up_wack = 'd0;

  // internal signals

  wire              dac_sync_s;
  wire              dac_datafmt_s;
  wire    [ 31:0]   up_rdata_0_s;
  wire              up_rack_0_s;
  wire              up_wack_0_s;
  wire    [ 31:0]   up_rdata_s;
  wire              up_rack_s;
  wire              up_wack_s;

  // defaults

  assign dac_valid = 1'b1;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_rdata <= up_rdata_s | up_rdata_0_s;
      up_rack <= up_rack_s | up_rack_0_s;
      up_wack <= up_wack_s | up_wack_0_s;
    end
  end

  // dac channel
  
  axi_ad9739a_channel #(
    .CHID(0),
    .DP_DISABLE(DP_DISABLE))
  i_channel_0 (
    .dac_div_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_enable (dac_enable),
    .dac_data_00 (dac_data_00),
    .dac_data_01 (dac_data_01),
    .dac_data_02 (dac_data_02),
    .dac_data_03 (dac_data_03),
    .dac_data_04 (dac_data_04),
    .dac_data_05 (dac_data_05),
    .dac_data_06 (dac_data_06),
    .dac_data_07 (dac_data_07),
    .dac_data_08 (dac_data_08),
    .dac_data_09 (dac_data_09),
    .dac_data_10 (dac_data_10),
    .dac_data_11 (dac_data_11),
    .dac_data_12 (dac_data_12),
    .dac_data_13 (dac_data_13),
    .dac_data_14 (dac_data_14),
    .dac_data_15 (dac_data_15),
    .dma_data (dac_ddata),
    .dac_data_sync (dac_sync_s),
    .dac_dds_format (dac_datafmt_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_0_s),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_0_s),
    .up_rack (up_rack_0_s));

  // dac common processor interface

  up_dac_common #(.PCORE_ID(PCORE_ID)) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_sync (dac_sync_s),
    .dac_frame (),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .dac_datafmt (dac_datafmt_s),
    .dac_datarate (),
    .dac_status (dac_status),
    .dac_status_ovf (dac_dovf),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (32'd4),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (16'd0),
    .up_drp_ready (1'd1),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd1),
    .up_dac_gpio_in (32'd0),
    .up_dac_gpio_out (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));
  
endmodule

// ***************************************************************************
// ***************************************************************************
