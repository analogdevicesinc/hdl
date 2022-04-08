// ***************************************************************************
// ***************************************************************************
// Copyright 2021 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

module axi_tdd #(
  // Boolean. Whether a false path constraint should be introduced for the tdd_sync
  // trigger input. This allows asynchronous (or external) sources to be used.
  // Note: This parameter isn't used inside of the core, but just for the
  // configuration of the constraints file.
  parameter ASYNC_TDD_SYNC = 1
) (

  // clock

  input                   clk,
  input                   rst,

  // control signals from the tdd control

  output                  tdd_rx_vco_en,
  output                  tdd_tx_vco_en,
  output                  tdd_rx_rf_en,
  output                  tdd_tx_rf_en,

  // status signal

  output                  tdd_enabled,

  // sync signal

  input                   tdd_sync,
  output  reg             tdd_sync_cntr,

  // tx/rx data flow control

  output  reg             tdd_tx_valid,
  output  reg             tdd_rx_valid,

  // bus interface
  input                   s_axi_aresetn,
  input                   s_axi_aclk,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready
);

  // internal signals

  wire              up_rstn;
  wire              up_clk;
  wire              up_wreq;
  wire    [13:0]    up_waddr;
  wire    [31:0]    up_wdata;
  wire              up_wack;
  wire              up_rreq;
  wire    [13:0]    up_raddr;
  wire    [31:0]    up_rdata;
  wire              up_rack;

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  wire              tdd_enable_s;
  wire              tdd_secondary_s;
  wire    [ 7:0]    tdd_burst_count_s;
  wire              tdd_rx_only_s;
  wire              tdd_tx_only_s;
  wire              tdd_gated_rx_dmapath_s;
  wire              tdd_gated_tx_dmapath_s;
  wire    [23:0]    tdd_counter_init_s;
  wire    [23:0]    tdd_frame_length_s;
  wire              tdd_terminal_type_s;
  wire              tdd_sync_enable_s;
  wire    [23:0]    tdd_vco_rx_on_1_s;
  wire    [23:0]    tdd_vco_rx_off_1_s;
  wire    [23:0]    tdd_vco_tx_on_1_s;
  wire    [23:0]    tdd_vco_tx_off_1_s;
  wire    [23:0]    tdd_rx_on_1_s;
  wire    [23:0]    tdd_rx_off_1_s;
  wire    [23:0]    tdd_rx_dp_on_1_s;
  wire    [23:0]    tdd_rx_dp_off_1_s;
  wire    [23:0]    tdd_tx_on_1_s;
  wire    [23:0]    tdd_tx_off_1_s;
  wire    [23:0]    tdd_tx_dp_on_1_s;
  wire    [23:0]    tdd_tx_dp_off_1_s;
  wire    [23:0]    tdd_vco_rx_on_2_s;
  wire    [23:0]    tdd_vco_rx_off_2_s;
  wire    [23:0]    tdd_vco_tx_on_2_s;
  wire    [23:0]    tdd_vco_tx_off_2_s;
  wire    [23:0]    tdd_rx_on_2_s;
  wire    [23:0]    tdd_rx_off_2_s;
  wire    [23:0]    tdd_rx_dp_on_2_s;
  wire    [23:0]    tdd_rx_dp_off_2_s;
  wire    [23:0]    tdd_tx_on_2_s;
  wire    [23:0]    tdd_tx_off_2_s;
  wire    [23:0]    tdd_tx_dp_on_2_s;
  wire    [23:0]    tdd_tx_dp_off_2_s;
  wire    [ 7:0]    tdd_status;

  wire    [23:0]    tdd_counter_status;

  wire              tdd_rx_dp_en_s;
  wire              tdd_tx_dp_en_s;

  reg               tdd_vco_overlap;
  reg               tdd_rf_overlap;

  assign  tdd_enabled = tdd_enable_s;

  // syncronization control signal

  always @(posedge clk) begin
    if (tdd_enable_s == 1'b1) begin
      tdd_sync_cntr <= ~tdd_terminal_type_s;
    end else begin
      tdd_sync_cntr <= 1'b0;
    end
  end

  // tx/rx data flow control

  always @(posedge clk) begin
    if ((tdd_enable_s == 1) && (tdd_gated_tx_dmapath_s == 1)) begin
      tdd_tx_valid <= tdd_tx_dp_en_s;
    end else begin
      tdd_tx_valid <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if ((tdd_enable_s == 1) && (tdd_gated_rx_dmapath_s == 1)) begin
      tdd_rx_valid <= tdd_rx_dp_en_s;
    end else begin
      tdd_rx_valid <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      tdd_vco_overlap <= 1'b0;
      tdd_rf_overlap <= 1'b0;
    end else begin
      tdd_vco_overlap <= tdd_rx_vco_en & tdd_tx_vco_en;
      tdd_rf_overlap <= tdd_rx_rf_en & tdd_tx_rf_en;
    end
  end

  assign tdd_status = {6'b0, tdd_rf_overlap, tdd_vco_overlap};

  // instantiations

  up_tdd_cntrl #(
    .BASE_ADDRESS('h0)
  ) i_up_tdd_cntrl(
    .clk(clk),
    .rst(rst),
    .tdd_enable(tdd_enable_s),
    .tdd_secondary(tdd_secondary_s),
    .tdd_burst_count(tdd_burst_count_s),
    .tdd_tx_only(tdd_tx_only_s),
    .tdd_rx_only(tdd_rx_only_s),
    .tdd_gated_rx_dmapath(tdd_gated_rx_dmapath_s),
    .tdd_gated_tx_dmapath(tdd_gated_tx_dmapath_s),
    .tdd_counter_init(tdd_counter_init_s),
    .tdd_frame_length(tdd_frame_length_s),
    .tdd_terminal_type(tdd_terminal_type_s),
    .tdd_vco_rx_on_1(tdd_vco_rx_on_1_s),
    .tdd_vco_rx_off_1(tdd_vco_rx_off_1_s),
    .tdd_vco_tx_on_1(tdd_vco_tx_on_1_s),
    .tdd_vco_tx_off_1(tdd_vco_tx_off_1_s),
    .tdd_rx_on_1(tdd_rx_on_1_s),
    .tdd_rx_off_1(tdd_rx_off_1_s),
    .tdd_rx_dp_on_1(tdd_rx_dp_on_1_s),
    .tdd_rx_dp_off_1(tdd_rx_dp_off_1_s),
    .tdd_tx_on_1(tdd_tx_on_1_s),
    .tdd_tx_off_1(tdd_tx_off_1_s),
    .tdd_tx_dp_on_1(tdd_tx_dp_on_1_s),
    .tdd_tx_dp_off_1(tdd_tx_dp_off_1_s),
    .tdd_vco_rx_on_2(tdd_vco_rx_on_2_s),
    .tdd_vco_rx_off_2(tdd_vco_rx_off_2_s),
    .tdd_vco_tx_on_2(tdd_vco_tx_on_2_s),
    .tdd_vco_tx_off_2(tdd_vco_tx_off_2_s),
    .tdd_rx_on_2(tdd_rx_on_2_s),
    .tdd_rx_off_2(tdd_rx_off_2_s),
    .tdd_rx_dp_on_2(tdd_rx_dp_on_2_s),
    .tdd_rx_dp_off_2(tdd_rx_dp_off_2_s),
    .tdd_tx_on_2(tdd_tx_on_2_s),
    .tdd_tx_off_2(tdd_tx_off_2_s),
    .tdd_tx_dp_on_2(tdd_tx_dp_on_2_s),
    .tdd_tx_dp_off_2(tdd_tx_dp_off_2_s),
    .tdd_status(tdd_status),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack));

  ad_tdd_control #(
    .TX_DATA_PATH_DELAY(0),
    .CONTROL_PATH_DELAY(0)
  ) i_tdd_control (
    .clk(clk),
    .rst(rst),
    .tdd_enable(tdd_enable_s),
    .tdd_secondary(tdd_secondary_s),
    .tdd_counter_init(tdd_counter_init_s),
    .tdd_frame_length(tdd_frame_length_s),
    .tdd_burst_count(tdd_burst_count_s),
    .tdd_rx_only(tdd_rx_only_s),
    .tdd_tx_only(tdd_tx_only_s),
    .tdd_sync (tdd_sync),
    .tdd_vco_rx_on_1(tdd_vco_rx_on_1_s),
    .tdd_vco_rx_off_1(tdd_vco_rx_off_1_s),
    .tdd_vco_tx_on_1(tdd_vco_tx_on_1_s),
    .tdd_vco_tx_off_1(tdd_vco_tx_off_1_s),
    .tdd_rx_on_1(tdd_rx_on_1_s),
    .tdd_rx_off_1(tdd_rx_off_1_s),
    .tdd_rx_dp_on_1(tdd_rx_dp_on_1_s),
    .tdd_rx_dp_off_1(tdd_rx_dp_off_1_s),
    .tdd_tx_on_1(tdd_tx_on_1_s),
    .tdd_tx_off_1(tdd_tx_off_1_s),
    .tdd_tx_dp_on_1(tdd_tx_dp_on_1_s),
    .tdd_tx_dp_off_1(tdd_tx_dp_off_1_s),
    .tdd_vco_rx_on_2(tdd_vco_rx_on_2_s),
    .tdd_vco_rx_off_2(tdd_vco_rx_off_2_s),
    .tdd_vco_tx_on_2(tdd_vco_tx_on_2_s),
    .tdd_vco_tx_off_2(tdd_vco_tx_off_2_s),
    .tdd_rx_on_2(tdd_rx_on_2_s),
    .tdd_rx_off_2(tdd_rx_off_2_s),
    .tdd_rx_dp_on_2(tdd_rx_dp_on_2_s),
    .tdd_rx_dp_off_2(tdd_rx_dp_off_2_s),
    .tdd_tx_on_2(tdd_tx_on_2_s),
    .tdd_tx_off_2(tdd_tx_off_2_s),
    .tdd_tx_dp_on_2(tdd_tx_dp_on_2_s),
    .tdd_tx_dp_off_2(tdd_tx_dp_off_2_s),
    .tdd_rx_dp_en(tdd_rx_dp_en_s),
    .tdd_tx_dp_en(tdd_tx_dp_en_s),
    .tdd_rx_vco_en(tdd_rx_vco_en),
    .tdd_tx_vco_en(tdd_tx_vco_en),
    .tdd_rx_rf_en(tdd_rx_rf_en),
    .tdd_tx_rf_en(tdd_tx_rf_en),
    .tdd_counter_status(tdd_counter_status));

  up_axi #(
    .AXI_ADDRESS_WIDTH(16)
  ) i_up_axi (
    .up_rstn(s_axi_aresetn),
    .up_clk(s_axi_aclk),

    .up_axi_awvalid(s_axi_awvalid),
    .up_axi_awaddr(s_axi_awaddr),
    .up_axi_awready(s_axi_awready),
    .up_axi_wvalid(s_axi_wvalid),
    .up_axi_wdata(s_axi_wdata),
    .up_axi_wstrb(s_axi_wstrb),
    .up_axi_wready(s_axi_wready),
    .up_axi_bvalid(s_axi_bvalid),
    .up_axi_bresp(s_axi_bresp),
    .up_axi_bready(s_axi_bready),
    .up_axi_arvalid(s_axi_arvalid),
    .up_axi_araddr(s_axi_araddr),
    .up_axi_arready(s_axi_arready),
    .up_axi_rvalid(s_axi_rvalid),
    .up_axi_rresp(s_axi_rresp),
    .up_axi_rdata(s_axi_rdata),
    .up_axi_rready(s_axi_rready),

    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack));

endmodule
