// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module axi_dac_interpolate #(

  parameter CORRECTION_DISABLE = 1) (

  input                 dac_clk,
  input                 dac_rst,

  input       [15:0]    dac_data_a,
  input       [15:0]    dac_data_b,
  input                 dac_valid_a,
  input                 dac_valid_b,

  input                 dma_valid_a,
  input                 dma_valid_b,
  output                dma_ready_a,
  output                dma_ready_b,

  input                 dac_enable_a,
  input                 dac_enable_b,
  output      [15:0]    dac_int_data_a,
  output      [15:0]    dac_int_data_b,
  output                dac_valid_out_a,
  output                dac_valid_out_b,
  output                hold_last_sample,
  output                underflow,

  input       [ 1:0]    trigger_i,
  input                 trigger_adc,
  input                 trigger_la,

  // axi interface

  input                 s_axi_aclk,
  input                 s_axi_aresetn,
  input                 s_axi_awvalid,
  input       [ 6:0]    s_axi_awaddr,
  input       [ 2:0]    s_axi_awprot,
  output                s_axi_awready,
  input                 s_axi_wvalid,
  input       [31:0]    s_axi_wdata,
  input       [ 3:0]    s_axi_wstrb,
  output                s_axi_wready,
  output                s_axi_bvalid,
  output      [ 1:0]    s_axi_bresp,
  input                 s_axi_bready,
  input                 s_axi_arvalid,
  input       [ 6:0]    s_axi_araddr,
  input       [ 2:0]    s_axi_arprot,
  output                s_axi_arready,
  output                s_axi_rvalid,
  output      [31:0]    s_axi_rdata,
  output      [ 1:0]    s_axi_rresp,
  input                 s_axi_rready);


  reg    [ 1:0]    trigger_i_m1;
  reg    [ 1:0]    trigger_i_m2;
  reg    [ 1:0]    trigger_i_m3;
  reg              trigger_adc_m1;
  reg              trigger_adc_m2;
  reg              trigger_adc_m3;
  reg              trigger_la_m1;
  reg              trigger_la_m2;
  reg              trigger_la_m3;

  reg    [ 1:0]    any_edge_trigger;
  reg    [ 1:0]    rise_edge_trigger;
  reg    [ 1:0]    fall_edge_trigger;
  reg    [ 1:0]    high_level_trigger;
  reg    [ 1:0]    low_level_trigger;

  // internal signals

  wire              up_clk;
  wire              up_rstn;
  wire    [ 4:0]    up_waddr;
  wire    [31:0]    up_wdata;
  wire              up_wack;
  wire              up_wreq;
  wire              up_rack;
  wire    [31:0]    up_rdata;
  wire              up_rreq;
  wire    [ 4:0]    up_raddr;

  wire    [31:0]    interpolation_ratio_a;
  wire    [31:0]    interpolation_ratio_b;
  wire    [ 2:0]    filter_mask_a;
  wire    [ 2:0]    filter_mask_b;

  wire              dma_transfer_suspend;
  wire              start_sync_channels;

  wire              dac_correction_enable_a;
  wire              dac_correction_enable_b;
  wire    [15:0]    dac_correction_coefficient_a;
  wire    [15:0]    dac_correction_coefficient_b;
  wire    [19:0]    trigger_config;

  wire              en_start_trigger;
  wire              en_stop_trigger;
  wire    [ 1:0]    en_trigger_pins;
  wire              en_trigger_adc;
  wire              en_trigger_la;

  wire    [ 1:0]    low_level;
  wire    [ 1:0]    high_level;
  wire    [ 1:0]    any_edge;
  wire    [ 1:0]    rise_edge;
  wire    [ 1:0]    fall_edge;

  wire              trigger_active;
  wire              trigger;
  wire              ext_trigger;

  wire              underflow_a;
  wire              underflow_b;

  wire    [ 1:0]    lsample_hold_config;
  wire              sync_stop_channels;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // trigger logic

  assign low_level  = trigger_config[1:0];
  assign high_level = trigger_config[3:2];
  assign any_edge   = trigger_config[5:4];
  assign rise_edge  = trigger_config[7:6];
  assign fall_edge  = trigger_config[9:8];

  assign en_start_trigger = trigger_config[14];
  assign en_stop_trigger  = trigger_config[15];
  assign en_trigger_pins  = trigger_config[17:16];
  assign en_trigger_adc   = trigger_config[18];
  assign en_trigger_la    = trigger_config[19];

  assign trigger_active = |trigger_config[19:16];
  assign trigger = (ext_trigger & en_trigger_pins) |
                   (trigger_adc_m2 & en_trigger_adc) |
                   (trigger_la_m2 & en_trigger_la);

  assign ext_trigger = |(any_edge_trigger |
                        rise_edge_trigger |
                        fall_edge_trigger |
                        high_level_trigger |
                        low_level_trigger);

  // sync
  always @(posedge dac_clk) begin
   trigger_i_m1 <= trigger_i;
   trigger_i_m2 <= trigger_i_m1;
   trigger_i_m3 <= trigger_i_m2;

   trigger_adc_m1 <= trigger_adc;
   trigger_adc_m2 <= trigger_adc_m1;

   trigger_la_m1 <= trigger_la;
   trigger_la_m2 <= trigger_la_m1;
  end

  always @(posedge dac_clk) begin
   any_edge_trigger <= (trigger_i_m3 ^ trigger_i_m2) & any_edge;
   rise_edge_trigger <= (~trigger_i_m3 & trigger_i_m2) & rise_edge;
   fall_edge_trigger <= (trigger_i_m3 & ~trigger_i_m2) & fall_edge;
   high_level_trigger <= trigger_i_m3 & high_level;
   low_level_trigger <= ~trigger_i_m3 & low_level;
  end

  assign hold_last_sample = lsample_hold_config[0];
  assign sync_stop_channels = lsample_hold_config[1];

  assign underflow = underflow_a | underflow_b;

  axi_dac_interpolate_filter #(
    .CORRECTION_DISABLE(CORRECTION_DISABLE))
    i_filter_a (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),

    .dac_data (dac_data_a),
    .dac_valid (dac_valid_a),
    .dac_valid_out (dac_valid_out_a),
    .sync_stop_channels (sync_stop_channels),

    .dac_enable (dac_enable_a),
    .dac_int_data (dac_int_data_a),
    .dma_ready (dma_ready_a),
    .underflow (underflow_a),

    .filter_mask (filter_mask_a),
    .interpolation_ratio (interpolation_ratio_a),
    .dma_transfer_suspend (dma_transfer_suspend),
    .start_sync_channels (start_sync_channels),
    .trigger (trigger),
    .trigger_active (trigger_active),
    .en_start_trigger (en_start_trigger),
    .en_stop_trigger (en_stop_trigger),
    .dma_valid (dma_valid_a),
    .dma_valid_adjacent (dma_valid_b),
    .dac_correction_enable(dac_correction_enable_a),
    .dac_correction_coefficient(dac_correction_coefficient_a)
  );

  axi_dac_interpolate_filter #(
    .CORRECTION_DISABLE(CORRECTION_DISABLE))
    i_filter_b (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),

    .dac_data (dac_data_b),
    .dac_valid (dac_valid_b),
    .dac_valid_out (dac_valid_out_b),
    .sync_stop_channels (sync_stop_channels),
    .underflow (underflow_b),

    .dac_enable (dac_enable_b),
    .dac_int_data (dac_int_data_b),
    .dma_ready (dma_ready_b),

    .filter_mask (filter_mask_b),
    .interpolation_ratio (interpolation_ratio_b),
    .dma_transfer_suspend (dma_transfer_suspend),
    .start_sync_channels (start_sync_channels),
    .trigger (trigger),
    .trigger_active (trigger_active),
    .en_start_trigger (en_start_trigger),
    .en_stop_trigger (en_stop_trigger),
    .dma_valid (dma_valid_b),
    .dma_valid_adjacent (dma_valid_a),
    .dac_correction_enable(dac_correction_enable_b),
    .dac_correction_coefficient(dac_correction_coefficient_b)
  );

  axi_dac_interpolate_reg axi_dac_interpolate_reg_inst (

    .clk (dac_clk),

    .dac_interpolation_ratio_a (interpolation_ratio_a),
    .dac_filter_mask_a (filter_mask_a),
    .dac_interpolation_ratio_b (interpolation_ratio_b),
    .dac_filter_mask_b (filter_mask_b),

    .dma_transfer_suspend (dma_transfer_suspend),
    .start_sync_channels (start_sync_channels),
    .dac_correction_enable_a(dac_correction_enable_a),
    .dac_correction_enable_b(dac_correction_enable_b),
    .dac_correction_coefficient_a(dac_correction_coefficient_a),
    .dac_correction_coefficient_b(dac_correction_coefficient_b),
    .trigger_config (trigger_config),
    .lsample_hold_config (lsample_hold_config),

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

  up_axi #(
    .AXI_ADDRESS_WIDTH(7)
  ) i_up_axi (
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
