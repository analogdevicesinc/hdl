// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
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

module axi_ad9361_alt (

 // physical interface (receive)

  rx_clk_in_p,
  rx_clk_in_n,
  rx_frame_in_p,
  rx_frame_in_n,
  rx_data_in_p,
  rx_data_in_n,

  // physical interface (transmit)

  tx_clk_out_p,
  tx_clk_out_n,
  tx_frame_out_p,
  tx_frame_out_n,
  tx_data_out_p,
  tx_data_out_n,

  // transmit master/slave

  dac_sync_in,
  dac_sync_out,

  // delay clock

  delay_clk,

  // master interface

  l_clk,
  clk,

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
  s_axi_awid,
  s_axi_awlen,
  s_axi_awsize,
  s_axi_awburst,
  s_axi_awlock,
  s_axi_awcache,
  s_axi_awprot,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wlast,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bid,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arid,
  s_axi_arlen,
  s_axi_arsize,
  s_axi_arburst,
  s_axi_arlock,
  s_axi_arcache,
  s_axi_arprot,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rresp,
  s_axi_rdata,
  s_axi_rid,
  s_axi_rlast,
  s_axi_rready,

  // debug signals

  dev_dbg_data,
  dev_l_dbg_data);

  parameter PCORE_ID = 0;
  parameter PCORE_AXI_ID_WIDTH = 3;
  parameter PCORE_DEVICE_TYPE = 0;

  // physical interface (receive)

  input                               rx_clk_in_p;
  input                               rx_clk_in_n;
  input                               rx_frame_in_p;
  input                               rx_frame_in_n;
  input   [  5:0]                     rx_data_in_p;
  input   [  5:0]                     rx_data_in_n;

  // physical interface (transmit)

  output                              tx_clk_out_p;
  output                              tx_clk_out_n;
  output                              tx_frame_out_p;
  output                              tx_frame_out_n;
  output  [  5:0]                     tx_data_out_p;
  output  [  5:0]                     tx_data_out_n;

  // master/slave

  input                               dac_sync_in;
  output                              dac_sync_out;

  // delay clock

  input                               delay_clk;

  // master interface

  output                              l_clk;
  input                               clk;

  // dma interface

  output                              adc_enable_i0;
  output                              adc_valid_i0;
  output  [ 15:0]                     adc_data_i0;
  output                              adc_enable_q0;
  output                              adc_valid_q0;
  output  [ 15:0]                     adc_data_q0;
  output                              adc_enable_i1;
  output                              adc_valid_i1;
  output  [ 15:0]                     adc_data_i1;
  output                              adc_enable_q1;
  output                              adc_valid_q1;
  output  [ 15:0]                     adc_data_q1;
  input                               adc_dovf;
  input                               adc_dunf;
  output                              dac_enable_i0;
  output                              dac_valid_i0;
  input   [ 15:0]                     dac_data_i0;
  output                              dac_enable_q0;
  output                              dac_valid_q0;
  input   [ 15:0]                     dac_data_q0;
  output                              dac_enable_i1;
  output                              dac_valid_i1;
  input   [ 15:0]                     dac_data_i1;
  output                              dac_enable_q1;
  output                              dac_valid_q1;
  input   [ 15:0]                     dac_data_q1;
  input                               dac_dovf;
  input                               dac_dunf;

  // axi interface

  input                               s_axi_aclk;
  input                               s_axi_aresetn;
  input                               s_axi_awvalid;
  input   [ 15:0]                     s_axi_awaddr;
  input   [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_awid;
  input   [  7:0]                     s_axi_awlen;
  input   [  2:0]                     s_axi_awsize;
  input   [  1:0]                     s_axi_awburst;
  input   [  0:0]                     s_axi_awlock;
  input   [  3:0]                     s_axi_awcache;
  input   [  2:0]                     s_axi_awprot;
  output                              s_axi_awready;
  input                               s_axi_wvalid;
  input   [ 31:0]                     s_axi_wdata;
  input   [  3:0]                     s_axi_wstrb;
  input                               s_axi_wlast;
  output                              s_axi_wready;
  output                              s_axi_bvalid;
  output  [  1:0]                     s_axi_bresp;
  output  [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_bid;
  input                               s_axi_bready;
  input                               s_axi_arvalid;
  input   [ 15:0]                     s_axi_araddr;
  input   [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_arid;
  input   [  7:0]                     s_axi_arlen;
  input   [  2:0]                     s_axi_arsize;
  input   [  1:0]                     s_axi_arburst;
  input   [  0:0]                     s_axi_arlock;
  input   [  3:0]                     s_axi_arcache;
  input   [  2:0]                     s_axi_arprot;
  output                              s_axi_arready;
  output                              s_axi_rvalid;
  output  [  1:0]                     s_axi_rresp;
  output  [ 31:0]                     s_axi_rdata;
  output  [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_rid;
  output                              s_axi_rlast;
  input                               s_axi_rready;

  // debug signals

  output [111:0]                      dev_dbg_data;
  output [ 61:0]                      dev_l_dbg_data;

  // defaults

  assign s_axi_bid = s_axi_awid;
  assign s_axi_rid = s_axi_arid;
  assign s_axi_rlast = 1'd0;

  // ad9361 lite version

  axi_ad9361 #(
    .PCORE_ID (PCORE_ID),
    .PCORE_DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .PCORE_IODELAY_GROUP ("dev_if_delay_group"),
    .C_S_AXI_MIN_SIZE (32'hffff),
    .C_BASEADDR (32'h00000000),
    .C_HIGHADDR (32'hffffffff))
  i_ad9361 (
    .rx_clk_in_p (rx_clk_in_p),
    .rx_clk_in_n (rx_clk_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_data_out_n (tx_data_out_n),
    .dac_sync_in (dac_sync_in),
    .dac_sync_out (dac_sync_out),
    .delay_clk (delay_clk),
    .l_clk (l_clk),
    .clk (clk),
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
    .dac_dovf (dac_dovf),
    .dac_dunf (dac_dunf),
    .s_axi_aclk (s_axi_aclk),
    .s_axi_aresetn (s_axi_aresetn),
    .s_axi_awvalid (s_axi_awvalid),
    .s_axi_awaddr ({16'd0, s_axi_awaddr}),
    .s_axi_awready (s_axi_awready),
    .s_axi_wvalid (s_axi_wvalid),
    .s_axi_wdata (s_axi_wdata),
    .s_axi_wstrb (s_axi_wstrb),
    .s_axi_wready (s_axi_wready),
    .s_axi_bvalid (s_axi_bvalid),
    .s_axi_bresp (s_axi_bresp),
    .s_axi_bready (s_axi_bready),
    .s_axi_arvalid (s_axi_arvalid),
    .s_axi_araddr ({18'd0, s_axi_araddr}),
    .s_axi_arready (s_axi_arready),
    .s_axi_rvalid (s_axi_rvalid),
    .s_axi_rresp (s_axi_rresp),
    .s_axi_rdata (s_axi_rdata),
    .s_axi_rready (s_axi_rready),
    .up_dac_gpio_in (32'd0),
    .up_dac_gpio_out (),
    .up_adc_gpio_in (32'd0),
    .up_adc_gpio_out (),
    .dev_dbg_data (dev_dbg_data),
    .dev_l_dbg_data (dev_l_dbg_data));

endmodule

// ***************************************************************************
// ***************************************************************************

