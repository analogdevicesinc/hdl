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

module axi_ad9371 (

  // receive

  adc_clk,
  adc_rx_valid,
  adc_rx_sof,
  adc_rx_data,
  adc_rx_ready,
  adc_os_clk,
  adc_rx_os_valid,
  adc_rx_os_sof,
  adc_rx_os_data,
  adc_rx_os_ready,

  // transmit

  dac_clk,
  dac_tx_valid,
  dac_tx_data,
  dac_tx_ready,

  // master/slave

  dac_sync_in,
  dac_sync_out,

  // dma interface

  adc_enable_i0,
  adc_valid_i0,
  adc_data_i0,
  adc_enable_q0,
  adc_valid_q0,
  adc_data_q0,
  adc_enable_i1,
  adc_valid_i1,
  adc_data_i1,
  adc_enable_q1,
  adc_valid_q1,
  adc_data_q1,
  adc_dovf,
  adc_dunf,

  adc_os_enable_i0,
  adc_os_valid_i0,
  adc_os_data_i0,
  adc_os_enable_q0,
  adc_os_valid_q0,
  adc_os_data_q0,
  adc_os_dovf,
  adc_os_dunf,

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

  // axi interface

  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awprot,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arprot,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rdata,
  s_axi_rresp,
  s_axi_rready);

  // parameters

  parameter   ID = 0;
  parameter   DEVICE_TYPE = 0;
  parameter   DAC_DATAPATH_DISABLE = 0;
  parameter   ADC_DATAPATH_DISABLE = 0;

  // receive

  input             adc_clk;
  input             adc_rx_valid;
  input   [  3:0]   adc_rx_sof;
  input   [ 63:0]   adc_rx_data;
  output            adc_rx_ready;
  input             adc_os_clk;
  input             adc_rx_os_valid;
  input   [  3:0]   adc_rx_os_sof;
  input   [ 63:0]   adc_rx_os_data;
  output            adc_rx_os_ready;

  // transmit

  input             dac_clk;
  output            dac_tx_valid;
  output  [127:0]   dac_tx_data;
  input             dac_tx_ready;

  // master/slave

  input             dac_sync_in;
  output            dac_sync_out;

  // dma interface

  output            adc_enable_i0;
  output            adc_valid_i0;
  output  [ 15:0]   adc_data_i0;
  output            adc_enable_q0;
  output            adc_valid_q0;
  output  [ 15:0]   adc_data_q0;
  output            adc_enable_i1;
  output            adc_valid_i1;
  output  [ 15:0]   adc_data_i1;
  output            adc_enable_q1;
  output            adc_valid_q1;
  output  [ 15:0]   adc_data_q1;
  input             adc_dovf;
  input             adc_dunf;

  output            adc_os_enable_i0;
  output            adc_os_valid_i0;
  output  [ 31:0]   adc_os_data_i0;
  output            adc_os_enable_q0;
  output            adc_os_valid_q0;
  output  [ 31:0]   adc_os_data_q0;
  input             adc_os_dovf;
  input             adc_os_dunf;

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

  // axi interface

  input             s_axi_aclk;
  input             s_axi_aresetn;
  input             s_axi_awvalid;
  input   [ 31:0]   s_axi_awaddr;
  input   [  2:0]   s_axi_awprot;
  output            s_axi_awready;
  input             s_axi_wvalid;
  input   [ 31:0]   s_axi_wdata;
  input   [  3:0]   s_axi_wstrb;
  output            s_axi_wready;
  output            s_axi_bvalid;
  output  [  1:0]   s_axi_bresp;
  input             s_axi_bready;
  input             s_axi_arvalid;
  input   [ 31:0]   s_axi_araddr;
  input   [  2:0]   s_axi_arprot;
  output            s_axi_arready;
  output            s_axi_rvalid;
  output  [ 31:0]   s_axi_rdata;
  output  [  1:0]   s_axi_rresp;
  input             s_axi_rready;

  // internal registers

  reg               up_wack = 'd0;
  reg               up_rack = 'd0;
  reg     [ 31:0]   up_rdata = 'd0;

  // internal signals

  wire              up_clk;
  wire              up_rstn;
  wire    [ 63:0]   adc_data_s;
  wire              adc_os_valid_s;
  wire    [ 63:0]   adc_os_data_s;
  wire    [127:0]   dac_data_s;
  wire              up_wreq_s;
  wire    [ 13:0]   up_waddr_s;
  wire    [ 31:0]   up_wdata_s;
  wire    [  2:0]   up_wack_s;
  wire              up_rreq_s;
  wire    [ 13:0]   up_raddr_s;
  wire    [ 31:0]   up_rdata_s[0:2];
  wire    [  2:0]   up_rack_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // defaults

  assign dac_tx_valid = 1'b1;
  assign adc_rx_ready = 1'b1;
  assign adc_rx_os_ready = 1'b1;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= | up_wack_s;
      up_rack <= | up_rack_s;
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2];
    end
  end

  // device interface

  axi_ad9371_if #(
    .DEVICE_TYPE (DEVICE_TYPE))
  i_if (
    .adc_clk (adc_clk),
    .adc_rx_sof (adc_rx_sof),
    .adc_rx_data (adc_rx_data),
    .adc_os_clk (adc_os_clk),
    .adc_rx_os_sof (adc_rx_os_sof),
    .adc_rx_os_data (adc_rx_os_data),
    .adc_data (adc_data_s),
    .adc_os_valid (adc_os_valid_s),
    .adc_os_data (adc_os_data_s),
    .dac_clk (dac_clk),
    .dac_tx_data (dac_tx_data),
    .dac_data (dac_data_s));

  // receive

  axi_ad9371_rx #(
    .ID (ID),
    .DATAPATH_DISABLE (ADC_DATAPATH_DISABLE))
  i_rx (
    .adc_rst (adc_rst),
    .adc_clk (adc_clk),
    .adc_data (adc_data_s),
    .adc_enable_i0 (adc_enable_i0),
    .adc_valid_i0 (adc_valid_i0),
    .adc_data_i0 (adc_data_i0),
    .adc_enable_q0 (adc_enable_q0),
    .adc_valid_q0 (adc_valid_q0),
    .adc_data_q0 (adc_data_q0),
    .adc_enable_i1 (adc_enable_i1),
    .adc_valid_i1 (adc_valid_i1),
    .adc_data_i1 (adc_data_i1),
    .adc_enable_q1 (adc_enable_q1),
    .adc_valid_q1 (adc_valid_q1),
    .adc_data_q1 (adc_data_q1),
    .adc_dovf (adc_dovf),
    .adc_dunf (adc_dunf),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  // receive (o/s)

  axi_ad9371_rx_os #(
    .ID (ID),
    .DATAPATH_DISABLE (ADC_DATAPATH_DISABLE))
  i_rx_os (
    .adc_os_rst (adc_os_rst),
    .adc_os_clk (adc_os_clk),
    .adc_os_valid (adc_os_valid_s),
    .adc_os_data (adc_os_data_s),
    .adc_os_enable_i0 (adc_os_enable_i0),
    .adc_os_valid_i0 (adc_os_valid_i0),
    .adc_os_data_i0 (adc_os_data_i0),
    .adc_os_enable_q0 (adc_os_enable_q0),
    .adc_os_valid_q0 (adc_os_valid_q0),
    .adc_os_data_q0 (adc_os_data_q0),
    .adc_os_dovf (adc_os_dovf),
    .adc_os_dunf (adc_os_dunf),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  // transmit

  axi_ad9371_tx #(
    .ID (ID),
    .DATAPATH_DISABLE (DAC_DATAPATH_DISABLE))
  i_tx (
    .dac_rst (dac_rst),
    .dac_clk (dac_clk),
    .dac_data (dac_data_s),
    .dac_sync_in (dac_sync_in),
    .dac_sync_out (dac_sync_out),
    .dac_enable_i0 (dac_enable_i0),
    .dac_valid_i0 (dac_valid_i0),
    .dac_data_i0 (dac_data_i0),
    .dac_enable_q0 (dac_enable_q0),
    .dac_valid_q0 (dac_valid_q0),
    .dac_data_q0 (dac_data_q0),
    .dac_enable_i1 (dac_enable_i1),
    .dac_valid_i1 (dac_valid_i1),
    .dac_data_i1 (dac_data_i1),
    .dac_enable_q1 (dac_enable_q1),
    .dac_valid_q1 (dac_valid_q1),
    .dac_data_q1 (dac_data_q1),
    .dac_dovf(dac_dovf),
    .dac_dunf(dac_dunf),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

  // axi interface

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
