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

module axi_ad9250_alt (

  // jesd interface 
  // rx_clk is (line-rate/40)

  rx_clk,
  rx_data,

  // dma interface

  adc_clk,
  adc_valid_a,
  adc_enable_a,
  adc_data_a,
  adc_valid_b,
  adc_enable_b,
  adc_data_b,
  adc_dovf,
  adc_dunf,

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
  s_axi_rready);

  parameter PCORE_ID = 0;
  parameter PCORE_AXI_ID_WIDTH = 3;
  parameter PCORE_DEVICE_TYPE = 0;

  // jesd interface 
  // rx_clk is (line-rate/40)

  input                               rx_clk;
  input   [63:0]                      rx_data;

  // dma interface

  output                              adc_clk;
  output                              adc_valid_a;
  output                              adc_enable_a;
  output  [31:0]                      adc_data_a;
  output                              adc_valid_b;
  output                              adc_enable_b;
  output  [31:0]                      adc_data_b;
  input                               adc_dovf;
  input                               adc_dunf;

  // axi interface

  input                               s_axi_aclk;
  input                               s_axi_aresetn;
  input                               s_axi_awvalid;
  input   [13:0]                      s_axi_awaddr;
  input   [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_awid;
  input   [ 7:0]                      s_axi_awlen;
  input   [ 2:0]                      s_axi_awsize;
  input   [ 1:0]                      s_axi_awburst;
  input   [ 0:0]                      s_axi_awlock;
  input   [ 3:0]                      s_axi_awcache;
  input   [ 2:0]                      s_axi_awprot;
  output                              s_axi_awready;
  input                               s_axi_wvalid;
  input   [31:0]                      s_axi_wdata;
  input   [ 3:0]                      s_axi_wstrb;
  input                               s_axi_wlast;
  output                              s_axi_wready;
  output                              s_axi_bvalid;
  output  [ 1:0]                      s_axi_bresp;
  output  [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_bid;
  input                               s_axi_bready;
  input                               s_axi_arvalid;
  input   [13:0]                      s_axi_araddr;
  input   [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_arid;
  input   [ 7:0]                      s_axi_arlen;
  input   [ 2:0]                      s_axi_arsize;
  input   [ 1:0]                      s_axi_arburst;
  input   [ 0:0]                      s_axi_arlock;
  input   [ 3:0]                      s_axi_arcache;
  input   [ 2:0]                      s_axi_arprot;
  output                              s_axi_arready;
  output                              s_axi_rvalid;
  output  [ 1:0]                      s_axi_rresp;
  output  [31:0]                      s_axi_rdata;
  output  [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_rid;
  output                              s_axi_rlast;
  input                               s_axi_rready;

  // defaults

  assign s_axi_bid = s_axi_awid;
  assign s_axi_rid = s_axi_arid;
  assign s_axi_rlast = 1'd0;

  // ad9250 lite version

  axi_ad9250 #(
    .PCORE_ID (PCORE_ID),
    .PCORE_DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .PCORE_IODELAY_GROUP ("adc_if_delay_group"),
    .C_S_AXI_MIN_SIZE (32'hffff))
  i_ad9250 (
    .rx_clk (rx_clk),
    .rx_data (rx_data),
    .adc_clk (adc_clk),
    .adc_valid_a (adc_valid_a),
    .adc_enable_a (adc_enable_a),
    .adc_data_a (adc_data_a),
    .adc_valid_b (adc_valid_b),
    .adc_enable_b (adc_enable_b),
    .adc_data_b (adc_data_b),
    .adc_dovf (adc_dovf),
    .adc_dunf (adc_dunf),
    .s_axi_aclk (s_axi_aclk),
    .s_axi_aresetn (s_axi_aresetn),
    .s_axi_awvalid (s_axi_awvalid),
    .s_axi_awaddr ({18'd0, s_axi_awaddr}),
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
    .s_axi_rready (s_axi_rready));

endmodule

// ***************************************************************************
// ***************************************************************************

