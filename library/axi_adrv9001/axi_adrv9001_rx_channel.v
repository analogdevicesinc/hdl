// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_adrv9001_rx_channel #(
  parameter   Q_OR_I_N = 0,
  parameter   COMMON_ID = 0,
  parameter   CHANNEL_ID = 0,
  parameter   DISABLE = 0,
  parameter   DATAFORMAT_DISABLE = 0,
  parameter   DCFILTER_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0,
  parameter   DATA_WIDTH = 16
) (

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

  input                           dac_valid_in,
  input       [(DATA_WIDTH-1):0]  dac_data_in,

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
  output                  up_rack
);

  localparam  NUM_OF_SAMPLES = DATA_WIDTH/16;

  // internal signals

  wire    [(NUM_OF_SAMPLES-1):0]  adc_dfmt_valid_s;
  wire    [(DATA_WIDTH-1):0]      adc_dfmt_data_s;
  wire    [(NUM_OF_SAMPLES-1):0]  adc_dcfilter_valid_s;
  wire    [(DATA_WIDTH-1):0]      adc_dcfilter_data_s;
  wire    [(NUM_OF_SAMPLES-1):0]  adc_valid_out_s;
  wire                            adc_pn_err_s;
  wire                            adc_pn_oos_s;
  wire    [3:0]                   adc_pnseq_sel;
  wire                            adc_dfmt_se_s;
  wire                            adc_dfmt_type_s;
  wire                            adc_dfmt_enable_s;
  wire                            adc_dcfilt_enb_s;
  wire    [15:0]                  adc_dcfilt_offset_s;
  wire    [15:0]                  adc_dcfilt_coeff_s;
  wire                            adc_iqcor_enb_s;
  wire    [15:0]                  adc_iqcor_coeff_1_s;
  wire    [15:0]                  adc_iqcor_coeff_2_s;
  wire    [(DATA_WIDTH-1):0]      adc_data_pn;
  wire    [(DATA_WIDTH-1):0]      pn7_data;
  wire    [(DATA_WIDTH-1):0]      pn15_data;
  wire    [ 3:0]                  adc_data_sel_s;
  wire    [15:0]                  adc_data_in_s;
  wire                            adc_valid_in_s;

  reg     [15:0]                  full_ramp_counter = 'd0;

  reg                             adc_valid_in_d = 'h0;
  reg                             adc_valid_in_2d = 'h0;
  reg     [(DATA_WIDTH-1):0]      adc_data_in_d = 'h0;
  reg     [(DATA_WIDTH-1):0]      adc_data_in_2d = 'h0;

  reg                             dac_valid_in_d = 'h0;
  reg                             dac_valid_in_2d = 'h0;
  reg     [(DATA_WIDTH-1):0]      dac_data_in_d = 'h0;
  reg     [(DATA_WIDTH-1):0]      dac_data_in_2d = 'h0;

  // variables
  genvar                          n;

  // input pipeline stage to protect logic if data comes from an async clock domain
  always @(posedge adc_clk) begin
    adc_valid_in_d <= adc_valid_in;
    adc_valid_in_2d <= adc_valid_in_d;
    adc_data_in_d <= adc_data_in;
    adc_data_in_2d <= adc_data_in_d;
  end
  always @(posedge adc_clk) begin
    dac_valid_in_d <= dac_valid_in;
    dac_valid_in_2d <= dac_valid_in_d;
    dac_data_in_d <= dac_data_in;
    dac_data_in_2d <= dac_data_in_d;
  end

  assign adc_data_in_s = (adc_data_sel_s == 4'h0) ? adc_data_in_2d : dac_data_in_2d;
  assign adc_valid_in_s = (adc_data_sel_s == 4'h0) ? adc_valid_in_2d : dac_valid_in_2d;

  // iq correction inputs

  generate
  for (n = 0; n < NUM_OF_SAMPLES; n = n + 1) begin: g_datafmt
  if (DISABLE == 1 || DATAFORMAT_DISABLE == 1) begin
  assign adc_dfmt_valid_s[n] = adc_valid_in_s;
  assign adc_dfmt_data_s[((16*n)+15):(16*n)] = adc_data_in_s[((16*n)+15):(16*n)];
  end else begin
  ad_datafmt #(
    .DATA_WIDTH (16)
  ) i_ad_datafmt (
    .clk (adc_clk),
    .valid (adc_valid_in_s),
    .data (adc_data_in_s[((16*n)+15):(16*n)]),
    .valid_out (adc_dfmt_valid_s[n]),
    .data_out (adc_dfmt_data_s[((16*n)+15):(16*n)]),
    .dfmt_enable (adc_dfmt_enable_s),
    .dfmt_type (adc_dfmt_type_s),
    .dfmt_se (adc_dfmt_se_s));
  end
  end

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

  assign adc_valid_out = adc_valid_out_s[0];
  assign adc_data_iq_out = adc_dcfilter_data_s;

  for (n = 0; n < NUM_OF_SAMPLES; n = n + 1) begin: g_iqcor
  if (DISABLE == 1 || IQCORRECTION_DISABLE == 1) begin
  assign adc_valid_out_s[n] = adc_dcfilter_valid_s[n];
  assign adc_data_out[((16*n)+15):(16*n)] = adc_dcfilter_data_s[((16*n)+15):(16*n)];
  end else begin
  ad_iqcor #(
    .Q_OR_I_N (Q_OR_I_N)
  ) i_ad_iqcor (
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

  if (DISABLE == 1) begin
    assign adc_enable = 1'b0;
    assign up_adc_pn_err = 1'b0;
    assign up_adc_pn_oos = 1'b0;
    assign up_adc_or = 1'b0;
    assign up_wack = 1'b0;
    assign up_rdata =  32'b0;
    assign up_rack = 1'b0;
  end else begin
  // pn oos & pn err

  // PN7 x^7 + x^6 + 1
  ad_pngen  #(
    .POL_MASK ( (1<<7) | (1<<6) ),
    .POL_W (7),
    .DW (16)
  ) PN7_gen (
    .clk (adc_clk),
    .reset (adc_rst),
    .clk_en (adc_valid_in_s),
    .pn_init (adc_pn_oos_s),
    .pn_data_in (adc_data_in_s),
    .pn_data_out (pn7_data));

  // PN15 x^15 + x^14 + 1
  ad_pngen  #(
    .POL_MASK ( (1<<15) | (1<<14) ),
    .POL_W (15),
    .DW (16)
  ) PN15_gen (
    .clk (adc_clk),
    .reset (adc_rst),
    .clk_en (adc_valid_in_s),
    .pn_init (adc_pn_oos_s),
    .pn_data_in (adc_data_in_s),
    .pn_data_out (pn15_data));

  // reference nibble ramp and full ramp generator
  // next value is always the currently received value incremented
  always @(posedge adc_clk) begin
    if (adc_valid_in_s) begin
      full_ramp_counter <= adc_data_in_s + 16'd1;
    end
  end

  assign adc_data_pn  = adc_pnseq_sel == 4'd4 ? pn7_data :
                        adc_pnseq_sel == 4'd5 ? pn15_data :
                        adc_pnseq_sel == 4'd10 ? {4{full_ramp_counter[3:0]}} :
                        adc_pnseq_sel == 4'd11 ? full_ramp_counter : 'h0;
  assign valid_seq_sel = adc_pnseq_sel == 4'd4 || adc_pnseq_sel == 4'd5 ||
                         adc_pnseq_sel == 4'd10 || adc_pnseq_sel == 4'd11;

  ad_pnmon #(
    .DATA_WIDTH (DATA_WIDTH),
    .OOS_THRESHOLD (8),
    .ALLOW_ZERO_MASKING(1)
  ) i_pnmon (
    .adc_clk (adc_clk),
    .adc_valid_in (adc_valid_in_s),
    .adc_data_in (adc_data_in_s),
    .adc_data_pn (adc_data_pn),
    .adc_pattern_has_zero (adc_pnseq_sel[3]),
    .adc_pn_oos (adc_pn_oos_s),
    .adc_pn_err (adc_pn_err_s));

  up_adc_channel #(
    .COMMON_ID (COMMON_ID),
    .CHANNEL_ID (CHANNEL_ID),
    .USERPORTS_DISABLE(1),
    .DATAFORMAT_DISABLE(DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE(DCFILTER_DISABLE),
    .IQCORRECTION_DISABLE(IQCORRECTION_DISABLE)
  ) i_up_adc_channel (
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
    .adc_pnseq_sel (adc_pnseq_sel),
    .adc_data_sel (adc_data_sel_s),
    .adc_pn_err (adc_pn_err_s & valid_seq_sel),
    .adc_pn_oos (adc_pn_oos_s & valid_seq_sel),
    .adc_or (1'd0),
    .adc_read_data ('d0),
    .adc_status_header ('d0),
    .adc_crc_err ('d0),
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
  end
  endgenerate

endmodule
