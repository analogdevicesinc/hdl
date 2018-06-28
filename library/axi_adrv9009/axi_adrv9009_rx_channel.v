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

module axi_adrv9009_rx_channel #(

  parameter   Q_OR_I_N = 0,
  parameter   COMMON_ID = 0,
  parameter   CHANNEL_ID = 0,
  parameter   DISABLE = 0,
  parameter   DATAFORMAT_DISABLE = 0,
  parameter   DCFILTER_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0,
  parameter   DATA_WIDTH = 32) (

  // adc interface

  input                           adc_clk,
  input                           adc_rst,
  input                           adc_valid_in,
  input       [(DATA_WIDTH-1):0]  adc_data_in,
  output                          adc_valid_out,
  output      [(DATA_WIDTH-1):0]  adc_data_out,
  input       [(DATA_WIDTH-1):0]  adc_data_iq_in,
  output      [(DATA_WIDTH-1):0]  adc_data_iq_out,
  output                          adc_enable,

  // channel interface

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


  localparam  NUM_OF_SAMPLES = DATA_WIDTH/16;

  // internal signals

  wire    [(NUM_OF_SAMPLES-1):0]  adc_dfmt_valid_s;
  wire    [(DATA_WIDTH-1):0]      adc_dfmt_data_s;
  wire    [(NUM_OF_SAMPLES-1):0]  adc_dcfilter_valid_s;
  wire    [(DATA_WIDTH-1):0]      adc_dcfilter_data_s;
  wire    [(NUM_OF_SAMPLES-1):0]  adc_valid_out_s;
  wire                            adc_pn_err_s;
  wire                            adc_pn_oos_s;
  wire                            adc_dfmt_se_s;
  wire                            adc_dfmt_type_s;
  wire                            adc_dfmt_enable_s;
  wire                            adc_dcfilt_enb_s;
  wire    [15:0]                  adc_dcfilt_offset_s;
  wire    [15:0]                  adc_dcfilt_coeff_s;
  wire                            adc_iqcor_enb_s;
  wire    [15:0]                  adc_iqcor_coeff_1_s;
  wire    [15:0]                  adc_iqcor_coeff_2_s;

  // variables

  genvar                          n;

  // iq correction inputs

  assign adc_pn_oos_s = 1'b1;
  assign adc_pn_err_s = 1'b0;

  generate
  for (n = 0; n < NUM_OF_SAMPLES; n = n + 1) begin: g_datafmt
  if (DISABLE == 1 || DATAFORMAT_DISABLE == 1) begin
  assign adc_dfmt_valid_s[n] = adc_valid_in;
  assign adc_dfmt_data_s[((16*n)+15):(16*n)] = adc_data_in[((16*n)+15):(16*n)];
  end else begin
  ad_datafmt #(.DATA_WIDTH (16)) i_ad_datafmt (
    .clk (adc_clk),
    .valid (adc_valid_in),
    .data (adc_data_in[((16*n)+15):(16*n)]),
    .valid_out (adc_dfmt_valid_s[n]),
    .data_out (adc_dfmt_data_s[((16*n)+15):(16*n)]),
    .dfmt_enable (adc_dfmt_enable_s),
    .dfmt_type (adc_dfmt_type_s),
    .dfmt_se (adc_dfmt_se_s));
  end
  end
  endgenerate

  generate
  for (n = 0; n < NUM_OF_SAMPLES; n = n + 1) begin: g_dcfilter
  if (DISABLE == 1 || DCFILTER_DISABLE == 1) begin
  assign adc_dcfilter_valid_s[n] = adc_dfmt_valid_s[n];
  assign adc_dcfilter_data_s[((16*n)+15):(16*n)] = adc_dfmt_data_s[((16*n)+15):(16*n)];
  end else begin
  ad_dcfilter i_ad_dcfilter (
    .clk (adc_clk),
    .valid (adc_dfmt_valid_s[n]),
    .data (adc_dfmt_data_s[((16*n)+15):(16*n)]),
    .valid_out (adc_dcfilter_valid_s[n]),
    .data_out (adc_dcfilter_data_s[((16*n)+15):(16*n)]),
    .dcfilt_enb (adc_dcfilt_enb_s),
    .dcfilt_coeff (adc_dcfilt_coeff_s),
    .dcfilt_offset (adc_dcfilt_offset_s));
  end
  end
  endgenerate

  assign adc_valid_out = adc_valid_out_s[0];
  assign adc_data_iq_out = adc_dcfilter_data_s;

  generate
  for (n = 0; n < NUM_OF_SAMPLES; n = n + 1) begin: g_iqcor
  if (DISABLE == 1 || IQCORRECTION_DISABLE == 1) begin
  assign adc_valid_out_s[n] = adc_dcfilter_valid_s[n];
  assign adc_data_out[((16*n)+15):(16*n)] = adc_dcfilter_data_s[((16*n)+15):(16*n)];
  end else begin
  ad_iqcor #(.Q_OR_I_N (Q_OR_I_N)) i_ad_iqcor (
    .clk (adc_clk),
    .valid (adc_dcfilter_valid_s[n]),
    .data_in (adc_dcfilter_data_s[((16*n)+15):(16*n)]),
    .data_iq (adc_data_iq_in[((16*n)+15):(16*n)]),
    .valid_out (adc_valid_out_s[n]),
    .data_out (adc_data_out[((16*n)+15):(16*n)]),
    .iqcor_enable (adc_iqcor_enb_s),
    .iqcor_coeff_1 (adc_iqcor_coeff_1_s),
    .iqcor_coeff_2 (adc_iqcor_coeff_2_s));
  end
  end
  endgenerate

  up_adc_channel #(
    .COMMON_ID (COMMON_ID),
    .CHANNEL_ID (CHANNEL_ID),
    .USERPORTS_DISABLE(1),
    .DATAFORMAT_DISABLE(DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE(DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE(IQCORRECTION_DISABLE))
  i_up_adc_channel (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable),
    .adc_iqcor_enb (adc_iqcor_enb_s),
    .adc_dcfilt_enb (adc_dcfilt_enb_s),
    .adc_dfmt_se (adc_dfmt_se_s),
    .adc_dfmt_type (adc_dfmt_type_s),
    .adc_dfmt_enable (adc_dfmt_enable_s),
    .adc_dcfilt_offset (adc_dcfilt_offset_s),
    .adc_dcfilt_coeff (adc_dcfilt_coeff_s),
    .adc_iqcor_coeff_1 (adc_iqcor_coeff_1_s),
    .adc_iqcor_coeff_2 (adc_iqcor_coeff_2_s),
    .adc_pnseq_sel (),
    .adc_data_sel (),
    .adc_pn_err (adc_pn_err_s),
    .adc_pn_oos (adc_pn_oos_s),
    .adc_or (1'd0),
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

