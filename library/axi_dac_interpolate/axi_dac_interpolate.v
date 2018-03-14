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

  output      [15:0]    dac_int_data_a,
  output      [15:0]    dac_int_data_b,
  output                dac_int_valid_a,
  output                dac_int_valid_b,

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

  wire              dac_correction_enable_a;
  wire              dac_correction_enable_b;
  wire    [15:0]    dac_correction_coefficient_a;
  wire    [15:0]    dac_correction_coefficient_b;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  axi_dac_interpolate_filter #(
    .CORRECTION_DISABLE(CORRECTION_DISABLE))
    i_filter_a (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),

    .dac_data (dac_data_a),
    .dac_valid (dac_valid_a),

    .dac_int_data (dac_int_data_a),
    .dac_int_valid (dac_int_valid_a),

    .filter_mask (filter_mask_a),
    .interpolation_ratio (interpolation_ratio_a),
    .dma_transfer_suspend (dma_transfer_suspend),
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

    .dac_int_data (dac_int_data_b),
    .dac_int_valid (dac_int_valid_b),

    .filter_mask (filter_mask_b),
    .interpolation_ratio (interpolation_ratio_b),
    .dma_transfer_suspend (dma_transfer_suspend),
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
    .dac_correction_enable_a(dac_correction_enable_a),
    .dac_correction_enable_b(dac_correction_enable_b),
    .dac_correction_coefficient_a(dac_correction_coefficient_a),
    .dac_correction_coefficient_b(dac_correction_coefficient_b),

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
    .AXI_ADDRESS_WIDTH(7),
    .ADDRESS_WIDTH(5)
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
