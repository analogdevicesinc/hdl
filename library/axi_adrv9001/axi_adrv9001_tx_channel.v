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

module axi_adrv9001_tx_channel #(
  parameter   COMMON_ID = 6'h11,
  parameter   CHANNEL_ID = 32'h0,
  parameter   Q_OR_I_N = 0,
  parameter   DISABLE = 0,
  parameter   DDS_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 20,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 18
) (

  // dac interface
  input                   dac_clk,
  input                   dac_rst,
  output                  dac_data_in_req,
  input       [15:0]      dac_data_in,
  input                   dac_data_out_req,
  output      [15:0]      dac_data_out,
  input       [15:0]      dac_data_iq_in,
  output  reg [15:0]      dac_data_iq_out,

  // processor interface
  output  reg             dac_enable = 1'b0,
  input                   dac_data_sync,
  input                   dac_dds_format,

  // bus interface
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

  // internal registers

  reg     [15:0]  dac_pat_data = 'd0;
  reg     [15:0]  full_ramp_counter = 'd0;

  // internal signals

  wire    [15:0]  dac_dds_data_s;
  wire    [15:0]  dac_dds_scale_1_s;
  wire    [15:0]  dac_dds_init_1_s;
  wire    [15:0]  dac_dds_incr_1_s;
  wire    [15:0]  dac_dds_scale_2_s;
  wire    [15:0]  dac_dds_init_2_s;
  wire    [15:0]  dac_dds_incr_2_s;
  wire    [15:0]  dac_pat_data_1_s;
  wire    [15:0]  dac_pat_data_2_s;
  wire    [ 3:0]  dac_data_sel_s;
  wire            dac_iqcor_enb_s;
  wire    [15:0]  dac_iqcor_coeff_1_s;
  wire    [15:0]  dac_iqcor_coeff_2_s;
  wire    [15:0]  pn7_data;
  wire    [15:0]  pn15_data;
  // dac iq correction

  generate
  if (DISABLE == 1 || IQCORRECTION_DISABLE == 1) begin

  assign dac_data_out = dac_data_iq_out;
  assign dac_data_in_req = dac_data_out_req;

  end else begin
  ad_iqcor #(
    .Q_OR_I_N (Q_OR_I_N)
  ) i_ad_iqcor_0 (
    .clk (dac_clk),
    .valid (dac_data_out_req),
    .data_in (dac_data_iq_out[15:0]),
    .data_iq (dac_data_iq_in[15:0]),
    .valid_out (dac_data_in_req),
    .data_out (dac_data_out[15:0]),
    .iqcor_enable (dac_iqcor_enb_s),
    .iqcor_coeff_1 (dac_iqcor_coeff_1_s),
    .iqcor_coeff_2 (dac_iqcor_coeff_2_s));
  end

  if (DISABLE == 1) begin
    assign up_wack = 1'b0;
    assign up_rdata =  32'b0;
    assign up_rack = 1'b0;
  end else begin

  // PN7 x^7 + x^6 + 1
  ad_pngen  #(
    .POL_MASK ((1<<7) | (1<<6)),
    .POL_W (7),
    .DW (16)
  ) PN7_gen (
    .clk (dac_clk),
    .reset (dac_rst),
    .clk_en (dac_data_in_req),
    .pn_init (1'b0),
    .pn_data_out (pn7_data));

  // PN15 x^15 + x^14 + 1
  ad_pngen  #(
    .POL_MASK ((1<<15) | (1<<14)),
    .POL_W (15),
    .DW (16)
  ) PN15_gen (
    .clk (dac_clk),
    .reset (dac_rst),
    .clk_en (dac_data_in_req),
    .pn_init (1'b0),
    .pn_data_out (pn15_data));

  // full ramp generator
  always @(posedge dac_clk) begin
    if (dac_data_sync) begin
      full_ramp_counter <= 'h0;
    end else if (dac_data_in_req) begin
      full_ramp_counter <= full_ramp_counter + 16'd1;
    end
  end

  // dac mux

  always @(posedge dac_clk) begin
    dac_enable <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel_s)
      4'hB: dac_data_iq_out <= full_ramp_counter;           // full ramp
      4'hA: dac_data_iq_out <= {4{full_ramp_counter[3:0]}}; // nibble ramp
      4'h7: dac_data_iq_out <= pn15_data;
      4'h6: dac_data_iq_out <= pn7_data;
      4'h3: dac_data_iq_out <= 16'd0;
      4'h2: dac_data_iq_out <= dac_data_in;
      4'h1: dac_data_iq_out <= dac_pat_data_1_s;
      default: dac_data_iq_out <= dac_dds_data_s;
    endcase
  end

  // dds

  ad_dds #(
    .DISABLE (DDS_DISABLE),
    .DDS_DW (16),
    .PHASE_DW (16),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .CLK_RATIO (1)
  ) i_dds (
    .clk (dac_clk),
    .dac_dds_format (dac_dds_format),
    .dac_data_sync (dac_data_sync),
    .dac_valid (dac_data_out_req),
    .tone_1_scale (dac_dds_scale_1_s),
    .tone_2_scale (dac_dds_scale_2_s),
    .tone_1_init_offset (dac_dds_init_1_s),
    .tone_2_init_offset (dac_dds_init_2_s),
    .tone_1_freq_word (dac_dds_incr_1_s),
    .tone_2_freq_word (dac_dds_incr_2_s),
    .dac_dds_data (dac_dds_data_s));

  // single channel processor

  up_dac_channel #(
    .COMMON_ID(COMMON_ID),
    .CHANNEL_ID (CHANNEL_ID),
    .DDS_DISABLE(DDS_DISABLE),
    .USERPORTS_DISABLE(1),
    .IQCORRECTION_DISABLE(IQCORRECTION_DISABLE)
  ) i_up_dac_channel (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_scale_1 (dac_dds_scale_1_s),
    .dac_dds_init_1 (dac_dds_init_1_s),
    .dac_dds_incr_1 (dac_dds_incr_1_s),
    .dac_dds_scale_2 (dac_dds_scale_2_s),
    .dac_dds_init_2 (dac_dds_init_2_s),
    .dac_dds_incr_2 (dac_dds_incr_2_s),
    .dac_pat_data_1 (dac_pat_data_1_s),
    .dac_pat_data_2 (dac_pat_data_2_s),
    .dac_data_sel (dac_data_sel_s),
    .dac_iq_mode (),
    .dac_iqcor_enb (dac_iqcor_enb_s),
    .dac_iqcor_coeff_1 (dac_iqcor_coeff_1_s),
    .dac_iqcor_coeff_2 (dac_iqcor_coeff_2_s),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_interpolation_m (),
    .up_usr_interpolation_n (),
    .dac_usr_datatype_be (1'b0),
    .dac_usr_datatype_signed (1'b1),
    .dac_usr_datatype_shift (8'd0),
    .dac_usr_datatype_total_bits (8'd16),
    .dac_usr_datatype_bits (8'd16),
    .dac_usr_interpolation_m (16'd1),
    .dac_usr_interpolation_n (16'd1),
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
