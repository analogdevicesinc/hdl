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

module axi_ad9122_channel #(

  parameter CHANNEL_ID = 32'h0,
  parameter DDS_TYPE = 1,
  parameter DDS_CORDIC_DW = 16,
  parameter DATAPATH_DISABLE = 0) (

  // dac interface

  input                   dac_div_clk,
  input                   dac_rst,
  output  reg             dac_enable,
  output  reg [63:0]      dac_data,
  output  reg [ 3:0]      dac_frame,
  input       [63:0]      dma_data,

  // processor interface

  input                   dac_data_frame,
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
  output                  up_rack);


  // internal registers

  reg     [15:0]  dac_dds_phase_0_0 = 'd0;
  reg     [15:0]  dac_dds_phase_0_1 = 'd0;
  reg     [15:0]  dac_dds_phase_1_0 = 'd0;
  reg     [15:0]  dac_dds_phase_1_1 = 'd0;
  reg     [15:0]  dac_dds_phase_2_0 = 'd0;
  reg     [15:0]  dac_dds_phase_2_1 = 'd0;
  reg     [15:0]  dac_dds_phase_3_0 = 'd0;
  reg     [15:0]  dac_dds_phase_3_1 = 'd0;
  reg     [15:0]  dac_dds_incr_0 = 'd0;
  reg     [15:0]  dac_dds_incr_1 = 'd0;
  reg     [63:0]  dac_dds_data = 'd0;

  // internal signals

  wire    [15:0]  dac_dds_data_0_s;
  wire    [15:0]  dac_dds_data_1_s;
  wire    [15:0]  dac_dds_data_2_s;
  wire    [15:0]  dac_dds_data_3_s;
  wire    [15:0]  dac_dds_scale_1_s;
  wire    [15:0]  dac_dds_init_1_s;
  wire    [15:0]  dac_dds_incr_1_s;
  wire    [15:0]  dac_dds_scale_2_s;
  wire    [15:0]  dac_dds_init_2_s;
  wire    [15:0]  dac_dds_incr_2_s;
  wire    [15:0]  dac_pat_data_1_s;
  wire    [15:0]  dac_pat_data_2_s;
  wire    [ 3:0]  dac_data_sel_s;

  // dac data select

  always @(posedge dac_div_clk) begin
    dac_enable <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel_s)
      4'h2: dac_data <= dma_data;
      4'ha, 4'h1: dac_data <= {dac_pat_data_2_s, dac_pat_data_1_s,
        dac_pat_data_2_s, dac_pat_data_1_s};
      default: dac_data <= dac_dds_data;
    endcase
    if (dac_data_sel_s == 4'h1) begin
      dac_frame <= 4'b0101;
    end else begin
      dac_frame <= {3'd0, dac_data_frame};
    end
  end

  // single channel dds

  always @(posedge dac_div_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_dds_phase_0_0 <= dac_dds_init_1_s;
      dac_dds_phase_0_1 <= dac_dds_init_2_s;
      dac_dds_phase_1_0 <= dac_dds_phase_0_0 + dac_dds_incr_1_s;
      dac_dds_phase_1_1 <= dac_dds_phase_0_1 + dac_dds_incr_2_s;
      dac_dds_phase_2_0 <= dac_dds_phase_1_0 + dac_dds_incr_1_s;
      dac_dds_phase_2_1 <= dac_dds_phase_1_1 + dac_dds_incr_2_s;
      dac_dds_phase_3_0 <= dac_dds_phase_2_0 + dac_dds_incr_1_s;
      dac_dds_phase_3_1 <= dac_dds_phase_2_1 + dac_dds_incr_2_s;
      dac_dds_incr_0 <= {dac_dds_incr_1_s[13:0], 2'd0};
      dac_dds_incr_1 <= {dac_dds_incr_2_s[13:0], 2'd0};
      dac_dds_data <= 64'd0;
    end else begin
      dac_dds_phase_0_0 <= dac_dds_phase_0_0 + dac_dds_incr_0;
      dac_dds_phase_0_1 <= dac_dds_phase_0_1 + dac_dds_incr_1;
      dac_dds_phase_1_0 <= dac_dds_phase_1_0 + dac_dds_incr_0;
      dac_dds_phase_1_1 <= dac_dds_phase_1_1 + dac_dds_incr_1;
      dac_dds_phase_2_0 <= dac_dds_phase_2_0 + dac_dds_incr_0;
      dac_dds_phase_2_1 <= dac_dds_phase_2_1 + dac_dds_incr_1;
      dac_dds_phase_3_0 <= dac_dds_phase_3_0 + dac_dds_incr_0;
      dac_dds_phase_3_1 <= dac_dds_phase_3_1 + dac_dds_incr_1;
      dac_dds_incr_0 <= dac_dds_incr_0;
      dac_dds_incr_1 <= dac_dds_incr_1;
      dac_dds_data <= { dac_dds_data_3_s, dac_dds_data_2_s,
                        dac_dds_data_1_s, dac_dds_data_0_s};
    end
  end

  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_dds_data_0_s = 16'd0;
  end else begin
  ad_dds #(
    .DISABLE (0),
    .DDS_TYPE (DDS_TYPE),
    .CORDIC_DW (DDS_CORDIC_DW))
  i_dds_0 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_0_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_0_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_0_s));
  end
  endgenerate

  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_dds_data_1_s = 16'd0;
  end else begin
  ad_dds #(
    .DISABLE (0),
    .DDS_TYPE (DDS_TYPE),
    .CORDIC_DW (DDS_CORDIC_DW))
  i_dds_1 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_1_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_1_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_1_s));
  end
  endgenerate

  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_dds_data_2_s = 16'd0;
  end else begin
  ad_dds #(
    .DISABLE (0),
    .DDS_TYPE (DDS_TYPE),
    .CORDIC_DW (DDS_CORDIC_DW))
  i_dds_2 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_2_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_2_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_2_s));
  end
  endgenerate

  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_dds_data_3_s = 16'd0;
  end else begin
  ad_dds #(
    .DISABLE (0),
    .DDS_TYPE (DDS_TYPE),
    .CORDIC_DW (DDS_CORDIC_DW))
  i_dds_3 (
    .clk (dac_div_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_3_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_3_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_3_s));
  end
  endgenerate

  // single channel processor

  up_dac_channel #(
    .COMMON_ID (6'h11),
    .CHANNEL_ID(CHANNEL_ID),
    .DDS_DISABLE (0),
    .USERPORTS_DISABLE (0),
    .IQCORRECTION_DISABLE (0))
  i_up_dac_channel (
    .dac_clk (dac_div_clk),
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
    .dac_iqcor_enb (),
    .dac_iqcor_coeff_1 (),
    .dac_iqcor_coeff_2 (),
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

// ***************************************************************************
// ***************************************************************************
