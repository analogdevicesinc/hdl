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

module axi_ad9467_channel#(

  parameter CHANNEL_ID = 0) (

  // adc interface

  input                   adc_clk,
  input                   adc_rst,
  input       [15:0]      adc_data,
  input                   adc_or,

  // channel interface

  output      [15:0]      adc_dfmt_data,
  output                  adc_enable,
  output                  up_adc_pn_err,
  output                  up_adc_pn_oos,
  output                  up_adc_or,

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output                  up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output      [31:0]      up_rdata,
  output                  up_rack);


  // internal signals

  wire            adc_pn_oos_s;
  wire            adc_pn_err_s;
  wire    [ 3:0]  adc_pnseq_sel_s;
  wire            adc_dfmt_enable_s;
  wire            adc_dfmt_type_s;
  wire            adc_dfmt_se_s;

  // instantiations

  axi_ad9467_pnmon i_axi_ad9467_pnmon (
    .adc_clk (adc_clk),
    .adc_data (adc_data),
    .adc_pn_oos (adc_pn_oos_s),
    .adc_pn_err (adc_pn_err_s),
    .adc_pnseq_sel (adc_pnseq_sel_s));

  ad_datafmt #(.DATA_WIDTH(16)) i_datafmt (
    .clk(adc_clk),
    .valid(1'b1),
    .data(adc_data),
    .valid_out(),
    .data_out(adc_dfmt_data),
    .dfmt_enable(adc_dfmt_enable_s),
    .dfmt_type(adc_dfmt_type_s),
    .dfmt_se(adc_dfmt_se_s));

  up_adc_channel #(
    .COMMON_ID (6'h01),
    .CHANNEL_ID(CHANNEL_ID),
    .USERPORTS_DISABLE (0),
    .DATAFORMAT_DISABLE (0),
    .DCFILTER_DISABLE (0),
    .IQCORRECTION_DISABLE (0))
  i_up_adc_channel (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (adc_dfmt_se_s),
    .adc_dfmt_type (adc_dfmt_type_s),
    .adc_dfmt_enable (adc_dfmt_enable_s),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pnseq_sel (adc_pnseq_sel_s),
    .adc_data_sel (),
    .adc_pn_err (adc_pn_err_s),
    .adc_pn_oos (adc_pn_oos_s),
    .adc_or (adc_or),
    .up_adc_pn_err (up_adc_pn_err),
    .up_adc_pn_oos (up_adc_pn_oos),
    .up_adc_or (up_adc_or),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (16'd1),
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
