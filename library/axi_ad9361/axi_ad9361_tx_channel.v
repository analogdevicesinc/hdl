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

module axi_ad9361_tx_channel #(

  // parameters

  parameter   Q_OR_I_N = 0,
  parameter   CHANNEL_ID = 32'h0,
  parameter   DISABLE = 0,
  parameter   DAC_DDS_DISABLE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_PHASE_DW = 16,
  parameter   DAC_DDS_CORDIC_DW = 14,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 13,
  parameter   USERPORTS_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0
) (

  // dac interface

  input           dac_clk,
  input           dac_rst,
  input           dac_valid,
  input   [15:0]  dma_data,
  input   [11:0]  adc_data,
  output  [11:0]  dac_data,
  output  [11:0]  dac_data_out,
  input   [11:0]  dac_data_in,

  // processor interface

  output          dac_enable,
  input           dac_data_sync,
  input           dac_dds_format,

  // bus interface

  input           up_rstn,
  input           up_clk,
  input           up_wreq,
  input   [13:0]  up_waddr,
  input   [31:0]  up_wdata,
  output          up_wack,
  input           up_rreq,
  input   [13:0]  up_raddr,
  output  [31:0]  up_rdata,
  output          up_rack
);

  // parameters

  localparam  PRBS_SEL = CHANNEL_ID;
  localparam  PRBS_P09  = 0;
  localparam  PRBS_P11  = 1;
  localparam  PRBS_P15  = 2;
  localparam  PRBS_P20  = 3;

  // internal registers

  reg             dac_valid_sel = 'd0;
  reg             dac_enable_int = 'd0;
  reg     [11:0]  dac_data_int = 'd0;
  reg     [11:0]  dac_data_out_int = 'd0;
  reg     [23:0]  dac_pn_seq = 'd0;
  reg     [11:0]  dac_pn_data = 'd0;
  reg     [15:0]  dac_pat_data = 'd0;

  // internal signals

  wire            dac_iqcor_valid_s;
  wire    [15:0]  dac_iqcor_data_s;
  wire    [11:0]  dac_dds_data_s;
  wire    [15:0]  dac_dds_scale_1_s;
  wire    [DAC_DDS_PHASE_DW-1:0]  dac_dds_init_1_s;
  wire    [DAC_DDS_PHASE_DW-1:0]  dac_dds_incr_1_s;
  wire    [15:0]  dac_dds_scale_2_s;
  wire    [DAC_DDS_PHASE_DW-1:0]  dac_dds_init_2_s;
  wire    [DAC_DDS_PHASE_DW-1:0]  dac_dds_incr_2_s;
  wire    [15:0]  dac_pat_data_1_s;
  wire    [15:0]  dac_pat_data_2_s;
  wire    [ 3:0]  dac_data_sel_s;
  wire            dac_iqcor_enb_s;
  wire    [15:0]  dac_iqcor_coeff_1_s;
  wire    [15:0]  dac_iqcor_coeff_2_s;
  wire            up_wack_s;
  wire            up_rack_s;
  wire    [31:0]  up_rdata_s;

  // standard prbs functions

  function [23:0] pn1fn;
    input [23:0] din;
    reg   [23:0] dout;
    begin
      case (PRBS_SEL)
        PRBS_P09: begin
          dout[23] = din[ 8] ^ din[ 4];
          dout[22] = din[ 7] ^ din[ 3];
          dout[21] = din[ 6] ^ din[ 2];
          dout[20] = din[ 5] ^ din[ 1];
          dout[19] = din[ 4] ^ din[ 0];
          dout[18] = din[ 3] ^ din[ 8] ^ din[ 4];
          dout[17] = din[ 2] ^ din[ 7] ^ din[ 3];
          dout[16] = din[ 1] ^ din[ 6] ^ din[ 2];
          dout[15] = din[ 0] ^ din[ 5] ^ din[ 1];
          dout[14] = din[ 8] ^ din[ 0];
          dout[13] = din[ 7] ^ din[ 8] ^ din[ 4];
          dout[12] = din[ 6] ^ din[ 7] ^ din[ 3];
          dout[11] = din[ 5] ^ din[ 6] ^ din[ 2];
          dout[10] = din[ 4] ^ din[ 5] ^ din[ 1];
          dout[ 9] = din[ 3] ^ din[ 4] ^ din[ 0];
          dout[ 8] = din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
          dout[ 7] = din[ 1] ^ din[ 2] ^ din[ 7] ^ din[ 3];
          dout[ 6] = din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 2];
          dout[ 5] = din[ 8] ^ din[ 0] ^ din[ 4] ^ din[ 5] ^ din[ 1];
          dout[ 4] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 0];
          dout[ 3] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 8] ^ din[ 4];
          dout[ 2] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 7] ^ din[ 3];
          dout[ 1] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6] ^ din[ 2];
          dout[ 0] = din[ 3] ^ din[ 8] ^ din[ 5] ^ din[ 1];
        end
        PRBS_P11: begin
          dout[23] = din[10] ^ din[ 8];
          dout[22] = din[ 9] ^ din[ 7];
          dout[21] = din[ 8] ^ din[ 6];
          dout[20] = din[ 7] ^ din[ 5];
          dout[19] = din[ 6] ^ din[ 4];
          dout[18] = din[ 5] ^ din[ 3];
          dout[17] = din[ 4] ^ din[ 2];
          dout[16] = din[ 3] ^ din[ 1];
          dout[15] = din[ 2] ^ din[ 0];
          dout[14] = din[ 1] ^ din[10] ^ din[ 8];
          dout[13] = din[ 0] ^ din[ 9] ^ din[ 7];
          dout[12] = din[10] ^ din[ 6];
          dout[11] = din[ 9] ^ din[ 5];
          dout[10] = din[ 8] ^ din[ 4];
          dout[ 9] = din[ 7] ^ din[ 3];
          dout[ 8] = din[ 6] ^ din[ 2];
          dout[ 7] = din[ 5] ^ din[ 1];
          dout[ 6] = din[ 4] ^ din[ 0];
          dout[ 5] = din[ 3] ^ din[10] ^ din[ 8];
          dout[ 4] = din[ 2] ^ din[ 9] ^ din[ 7];
          dout[ 3] = din[ 1] ^ din[ 8] ^ din[ 6];
          dout[ 2] = din[ 0] ^ din[ 7] ^ din[ 5];
          dout[ 1] = din[10] ^ din[ 6] ^ din[ 8] ^ din[ 4];
          dout[ 0] = din[ 9] ^ din[ 5] ^ din[ 7] ^ din[ 3];
        end
        PRBS_P15: begin
          dout[23] = din[14] ^ din[13];
          dout[22] = din[13] ^ din[12];
          dout[21] = din[12] ^ din[11];
          dout[20] = din[11] ^ din[10];
          dout[19] = din[10] ^ din[ 9];
          dout[18] = din[ 9] ^ din[ 8];
          dout[17] = din[ 8] ^ din[ 7];
          dout[16] = din[ 7] ^ din[ 6];
          dout[15] = din[ 6] ^ din[ 5];
          dout[14] = din[ 5] ^ din[ 4];
          dout[13] = din[ 4] ^ din[ 3];
          dout[12] = din[ 3] ^ din[ 2];
          dout[11] = din[ 2] ^ din[ 1];
          dout[10] = din[ 1] ^ din[ 0];
          dout[ 9] = din[ 0] ^ din[14] ^ din[13];
          dout[ 8] = din[14] ^ din[12];
          dout[ 7] = din[13] ^ din[11];
          dout[ 6] = din[12] ^ din[10];
          dout[ 5] = din[11] ^ din[ 9];
          dout[ 4] = din[10] ^ din[ 8];
          dout[ 3] = din[ 9] ^ din[ 7];
          dout[ 2] = din[ 8] ^ din[ 6];
          dout[ 1] = din[ 7] ^ din[ 5];
          dout[ 0] = din[ 6] ^ din[ 4];
        end
        PRBS_P20: begin
          dout[23] = din[19] ^ din[ 2];
          dout[22] = din[18] ^ din[ 1];
          dout[21] = din[17] ^ din[ 0];
          dout[20] = din[16] ^ din[19] ^ din[ 2];
          dout[19] = din[15] ^ din[18] ^ din[ 1];
          dout[18] = din[14] ^ din[17] ^ din[ 0];
          dout[17] = din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[16] = din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[15] = din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[14] = din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[13] = din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[12] = din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[11] = din[ 7] ^ din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[10] = din[ 6] ^ din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[ 9] = din[ 5] ^ din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[ 8] = din[ 4] ^ din[ 7] ^ din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[ 7] = din[ 3] ^ din[ 6] ^ din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[ 6] = din[ 2] ^ din[ 5] ^ din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[ 5] = din[ 1] ^ din[ 4] ^ din[ 7] ^ din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[ 4] = din[ 0] ^ din[ 3] ^ din[ 6] ^ din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[ 3] = din[19] ^ din[ 5] ^ din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
          dout[ 2] = din[18] ^ din[ 4] ^ din[ 7] ^ din[10] ^ din[13] ^ din[16] ^ din[19] ^ din[ 2];
          dout[ 1] = din[17] ^ din[ 3] ^ din[ 6] ^ din[ 9] ^ din[12] ^ din[15] ^ din[18] ^ din[ 1];
          dout[ 0] = din[16] ^ din[ 2] ^ din[ 5] ^ din[ 8] ^ din[11] ^ din[14] ^ din[17] ^ din[ 0];
        end
      endcase
      pn1fn = dout;
    end
  endfunction

  // global toggle

  always @(posedge dac_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_valid_sel <= 1'b0;
    end else if (dac_valid == 1'b1) begin
      dac_valid_sel <= ~dac_valid_sel;
    end
  end

  // dac iq correction

  assign dac_enable = (DISABLE == 1) ? 1'd0 : dac_enable_int;
  assign dac_data = (DISABLE == 1) ? 12'd0 : dac_data_int;

  always @(posedge dac_clk) begin
    dac_enable_int <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    if (dac_iqcor_valid_s == 1'b1) begin
      dac_data_int <= dac_iqcor_data_s[15:4];
    end
  end

  ad_iqcor #(
    .Q_OR_I_N (Q_OR_I_N),
    .DISABLE (IQCORRECTION_DISABLE)
  ) i_ad_iqcor (
    .clk (dac_clk),
    .valid (dac_valid),
    .data_in ({dac_data_out_int, 4'd0}),
    .data_iq ({dac_data_in, 4'd0}),
    .valid_out (dac_iqcor_valid_s),
    .data_out (dac_iqcor_data_s),
    .iqcor_enable (dac_iqcor_enb_s),
    .iqcor_coeff_1 (dac_iqcor_coeff_1_s),
    .iqcor_coeff_2 (dac_iqcor_coeff_2_s));

  // dac mux

  assign dac_data_out = (DISABLE == 1) ? 12'd0 : dac_data_out_int;

  always @(posedge dac_clk) begin
    case (dac_data_sel_s)
      4'h9: dac_data_out_int <= dac_pn_data;
      4'h8: dac_data_out_int <= adc_data;
      4'h3: dac_data_out_int <= 12'd0;
      4'h2: dac_data_out_int <= dma_data[15:4];
      4'h1: dac_data_out_int <= dac_pat_data[15:4];
      default: dac_data_out_int <= dac_dds_data_s;
    endcase
  end

  // prbs sequences

  always @(posedge dac_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_pn_seq <= 24'hffffff;
      dac_pn_data <= 12'd0;
    end else if (dac_valid == 1'b1) begin
      if (dac_valid_sel == 1'b1) begin
        dac_pn_seq <= pn1fn(dac_pn_seq);
        dac_pn_data <= dac_pn_seq[11: 0];
      end else begin
        dac_pn_seq <= dac_pn_seq;
        dac_pn_data <= dac_pn_seq[23:12];
      end
    end
  end

  // pattern

  always @(posedge dac_clk) begin
    if (dac_valid == 1'b1) begin
      if (dac_valid_sel == 1'b0) begin
        dac_pat_data <= dac_pat_data_1_s;
      end else begin
        dac_pat_data <= dac_pat_data_2_s;
      end
    end
  end

  // dds

  ad_dds #(
    .DISABLE (DAC_DDS_DISABLE),
    .DDS_DW (12),
    .PHASE_DW (DAC_DDS_PHASE_DW),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .CLK_RATIO (1)
  ) i_dds (
    .clk (dac_clk),
    .dac_dds_format (dac_dds_format),
    .dac_data_sync (dac_data_sync),
    .dac_valid (dac_valid),
    .tone_1_scale (dac_dds_scale_1_s),
    .tone_2_scale (dac_dds_scale_2_s),
    .tone_1_init_offset (dac_dds_init_1_s),
    .tone_2_init_offset (dac_dds_init_2_s),
    .tone_1_freq_word (dac_dds_incr_1_s),
    .tone_2_freq_word (dac_dds_incr_2_s),
    .dac_dds_data (dac_dds_data_s));

  // single channel processor

  assign up_wack = (DISABLE == 1) ? 1'd0 : up_wack_s;
  assign up_rack = (DISABLE == 1) ? 1'd0 : up_rack_s;
  assign up_rdata = (DISABLE == 1) ? 32'd0 : up_rdata_s;

  up_dac_channel #(
    .COMMON_ID (6'h11),
    .CHANNEL_ID (CHANNEL_ID),
    .DDS_DISABLE (DAC_DDS_DISABLE),
    .DDS_PHASE_DW (DAC_DDS_PHASE_DW),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .IQCORRECTION_DISABLE (IQCORRECTION_DISABLE)
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
    .up_wack (up_wack_s),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

endmodule
