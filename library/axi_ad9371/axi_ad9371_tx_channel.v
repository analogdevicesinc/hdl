// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9371_tx_channel (

  // dac interface

  dac_clk,
  dac_rst,
  dac_data_in,
  dac_data_out,
  dac_data_iq_in,
  dac_data_iq_out,

  // processor interface

  dac_enable,
  dac_data_sync,
  dac_dds_format,

  // bus interface

  up_rstn,
  up_clk,
  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack);

  // parameters

  parameter   CHANNEL_ID = 32'h0;
  parameter   Q_OR_I_N = 0;
  parameter   DATAPATH_DISABLE = 0;

  // dac interface

  input           dac_clk;
  input           dac_rst;
  input   [31:0]  dac_data_in;
  output  [31:0]  dac_data_out;
  input   [31:0]  dac_data_iq_in;
  output  [31:0]  dac_data_iq_out;

  // processor interface

  output          dac_enable;
  input           dac_data_sync;
  input           dac_dds_format;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           up_wreq;
  input   [13:0]  up_waddr;
  input   [31:0]  up_wdata;
  output          up_wack;
  input           up_rreq;
  input   [13:0]  up_raddr;
  output  [31:0]  up_rdata;
  output          up_rack;

  // internal registers

  reg             dac_enable = 'd0;
  reg     [31:0]  dac_data_iq_out = 'd0;
  reg     [31:0]  dac_pat_data = 'd0;
  reg     [15:0]  dac_dds_phase_0_0 = 'd0;
  reg     [15:0]  dac_dds_phase_0_1 = 'd0;
  reg     [15:0]  dac_dds_phase_1_0 = 'd0;
  reg     [15:0]  dac_dds_phase_1_1 = 'd0;
  reg     [15:0]  dac_dds_incr_0 = 'd0;
  reg     [15:0]  dac_dds_incr_1 = 'd0;
  reg     [31:0]  dac_dds_data = 'd0;

  // internal signals

  wire    [15:0]  dac_dds_data_0_s;
  wire    [15:0]  dac_dds_data_1_s;
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

  // dac iq correction

  generate
  if (DATAPATH_DISABLE == 1) begin

  assign dac_data_out = dac_data_iq_out;

  end else begin

  ad_iqcor #(.Q_OR_I_N (Q_OR_I_N)) i_ad_iqcor_1 (
    .clk (dac_clk),
    .valid (1'b1),
    .data_in (dac_data_iq_out[31:16]),
    .data_iq (dac_data_iq_in[31:16]),
    .valid_out (),
    .data_out (dac_data_out[31:16]),
    .iqcor_enable (dac_iqcor_enb_s),
    .iqcor_coeff_1 (dac_iqcor_coeff_1_s),
    .iqcor_coeff_2 (dac_iqcor_coeff_2_s));

  ad_iqcor #(.Q_OR_I_N (Q_OR_I_N)) i_ad_iqcor_0 (
    .clk (dac_clk),
    .valid (1'b1),
    .data_in (dac_data_iq_out[15:0]),
    .data_iq (dac_data_iq_in[15:0]),
    .valid_out (),
    .data_out (dac_data_out[15:0]),
    .iqcor_enable (dac_iqcor_enb_s),
    .iqcor_coeff_1 (dac_iqcor_coeff_1_s),
    .iqcor_coeff_2 (dac_iqcor_coeff_2_s));
  end
  endgenerate

  // dac mux

  always @(posedge dac_clk) begin
    dac_enable <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel_s)
      4'h3: dac_data_iq_out <= 32'd0;
      4'h2: dac_data_iq_out <= dac_data_in;
      4'h1: dac_data_iq_out <= dac_pat_data;
      default: dac_data_iq_out <= dac_dds_data;
    endcase
  end

  // pattern

  always @(posedge dac_clk) begin
    dac_pat_data <= {dac_pat_data_2_s, dac_pat_data_1_s};
  end

  // dds

  always @(posedge dac_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_dds_phase_0_0 <= dac_dds_init_1_s;
      dac_dds_phase_0_1 <= dac_dds_init_2_s;
      dac_dds_phase_1_0 <= dac_dds_phase_0_0 + dac_dds_incr_1_s;
      dac_dds_phase_1_1 <= dac_dds_phase_0_1 + dac_dds_incr_2_s;
      dac_dds_incr_0 <= {dac_dds_incr_1_s[14:0], 1'd0};
      dac_dds_incr_1 <= {dac_dds_incr_2_s[14:0], 1'd0};
      dac_dds_data <= 32'd0;
    end else begin
      dac_dds_phase_0_0 <= dac_dds_phase_0_0 + dac_dds_incr_0;
      dac_dds_phase_0_1 <= dac_dds_phase_0_1 + dac_dds_incr_1;
      dac_dds_phase_1_0 <= dac_dds_phase_1_0 + dac_dds_incr_0;
      dac_dds_phase_1_1 <= dac_dds_phase_1_1 + dac_dds_incr_1;
      dac_dds_incr_0 <= dac_dds_incr_0;
      dac_dds_incr_1 <= dac_dds_incr_1;
      dac_dds_data <= {dac_dds_data_1_s, dac_dds_data_0_s};
    end
  end

  // dds

  generate
  if (DATAPATH_DISABLE == 1) begin

  assign dac_dds_data_0_s = 16'd0;
  assign dac_dds_data_1_s = 16'd0;

  end else begin

  ad_dds i_dds_0 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_0_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_0_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_0_s));

  ad_dds i_dds_1 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_1_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_1_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_1_s));

  end
  endgenerate

  // single channel processor

  up_dac_channel #(.CHANNEL_ID (CHANNEL_ID)) i_up_dac_channel (
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
  
endmodule

// ***************************************************************************
// ***************************************************************************
