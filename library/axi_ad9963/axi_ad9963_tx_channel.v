// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2025 Analog Devices, Inc. All rights reserved.
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

module axi_ad9963_tx_channel #(

  // parameters

  parameter   CHANNEL_ID = 32'h0,
  parameter   Q_OR_I_N = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 14,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 13,
  parameter   DATAPATH_DISABLE = 0
) (

  // dac interface

  input               dac_clk,
  input               dac_rst,
  input               dac_valid,
  input       [15:0]  dma_data,
  input       [11:0]  adc_data,
  output reg  [11:0]  dac_data,
  output reg  [11:0]  dac_data_out,
  input       [11:0]  dac_data_in,
  input               dma_valid,

  // processor interface

  output  reg         dac_enable,
  input               dac_data_sync,
  input               dac_dds_format,

  // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [13:0]  up_waddr,
  input       [31:0]  up_wdata,
  output              up_wack,
  input               up_rreq,
  input       [13:0]  up_raddr,
  output      [31:0]  up_rdata,
  output              up_rack
);

  localparam  PRBS_SEL = CHANNEL_ID;
  localparam  PRBS_P09 = 0;
  localparam  PRBS_P11 = 1;
  localparam  PRBS_P15 = 2;
  localparam  PRBS_P20 = 3;

  // internal registers

  reg             dac_valid_sel = 'd0;
  reg     [23:0]  dac_test_data = 'd0;
  reg     [15:0]  dac_test_counter = 'd0;
  reg     [15:0]  dac_pat_data = 'd0;
  reg             dma_valid_m = 1'd0;

  // internal signals

  wire            dac_iqcor_valid_s;
  wire    [15:0]  dac_iqcor_data_s;
  wire    [11:0]  dac_dds_data_s;
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
  wire            data_source_valid_s;

  // dac iq correction

  always @(posedge dac_clk) begin
    dac_enable <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    if (dac_iqcor_valid_s == 1'b1) begin
      dac_data <= dac_iqcor_data_s[15:4];
    end
  end

  assign data_source_valid_s = dac_data_sel_s == 4'h2 ? dma_valid_m : dac_valid;

  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_iqcor_valid_s = data_source_valid_s;
  assign dac_iqcor_data_s = {dac_data_out, 4'd0};
  end else begin
  ad_iqcor #(
    .Q_OR_I_N (Q_OR_I_N)
  ) i_ad_iqcor (
    .clk (dac_clk),
    .valid (data_source_valid_s),
    .data_in ({dac_data_out, 4'd0}),
    .data_iq ({dac_data_in, 4'd0}),
    .valid_out (dac_iqcor_valid_s),
    .data_out (dac_iqcor_data_s),
    .iqcor_enable (dac_iqcor_enb_s),
    .iqcor_coeff_1 (dac_iqcor_coeff_1_s),
    .iqcor_coeff_2 (dac_iqcor_coeff_2_s));
  end
  endgenerate

  // dac mux

  always @(posedge dac_clk) begin
    case (dac_data_sel_s)
      4'h6: dac_data_out <= dac_test_data[11:0];
      4'h5: dac_data_out <= dac_data_out-1;
      4'h4: dac_data_out <= dac_data_out+1;
      4'h3: dac_data_out <= 12'd0;
      4'h2: dac_data_out <= dma_data[15:4];
      4'h1: dac_data_out <= dac_pat_data[15:4];
      default: dac_data_out <= dac_dds_data_s;
    endcase
    dma_valid_m <= dma_valid;
  end

  function [23:0] pn23;
    input [23:0] din;
    reg   [23:0] dout;
    begin
      dout = {din[22:0], din[22] ^ din[17]};
      pn23 = dout;
    end
  endfunction

  always @(posedge dac_clk) begin
    if(dac_data_sel_s != 6) begin
      dac_test_data <= 24'hffffff;
      dac_test_counter <= 16'h0;
    end else if (dac_test_counter == 1024) begin
      dac_test_data <= 24'h0;
    end else begin
      dac_test_data <= pn23(dac_test_data);
      dac_test_counter <= dac_test_counter + 1;
    end
  end

  // pattern
  always @(posedge dac_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_valid_sel <= 1'b0;
    end else if (dac_valid == 1'b1) begin
      dac_valid_sel <= ~dac_valid_sel;
    end
  end

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
    .DISABLE (DATAPATH_DISABLE),
    .DDS_DW (12),
    .PHASE_DW (16),
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

  up_dac_channel #(
    .COMMON_ID (6'h11),
    .CHANNEL_ID(CHANNEL_ID),
    .DDS_DISABLE(DATAPATH_DISABLE),
    .IQCORRECTION_DISABLE(DATAPATH_DISABLE),
    .USERPORTS_DISABLE(1)
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
    .dac_iq_mode(),
    .dac_data_sel (dac_data_sel_s),
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

endmodule
