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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9361_tx_channel (

  // dac interface

  dac_clk,
  dac_rst,
  dac_valid,
  dma_data,
  adc_data,
  dac_data,
  dac_data_out,
  dac_data_in,

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

  parameter   CHID = 32'h0;
  parameter   IQSEL = 0;
  parameter   DP_DISABLE = 0;
  localparam  PRBS_SEL = CHID;
  localparam  PRBS_P09  = 0;
  localparam  PRBS_P11  = 1;
  localparam  PRBS_P15  = 2;
  localparam  PRBS_P20  = 3;

  // dac interface

  input           dac_clk;
  input           dac_rst;
  input           dac_valid;
  input   [15:0]  dma_data;
  input   [11:0]  adc_data;
  output  [11:0]  dac_data;
  output  [11:0]  dac_data_out;
  input   [11:0]  dac_data_in;

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

  reg             dac_valid_sel = 'd0;
  reg             dac_enable = 'd0;
  reg     [11:0]  dac_data = 'd0;
  reg     [11:0]  dac_data_out = 'd0;
  reg     [23:0]  dac_pn_seq = 'd0;
  reg     [11:0]  dac_pn_data = 'd0;
  reg     [15:0]  dac_pat_data = 'd0;
  reg     [15:0]  dac_dds_phase_0 = 'd0;
  reg     [15:0]  dac_dds_phase_1 = 'd0;
  reg     [15:0]  dac_dds_incr_0 = 'd0;
  reg     [15:0]  dac_dds_incr_1 = 'd0;
  reg     [15:0]  dac_dds_data = 'd0;

  // internal signals

  wire    [11:0]  dac_data_i_s;
  wire    [11:0]  dac_data_q_s;
  wire            dac_iqcor_valid_s;
  wire    [15:0]  dac_iqcor_data_s;
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

  assign dac_data_i_s = (IQSEL == 1) ? dac_data_in  : dac_data_out;
  assign dac_data_q_s = (IQSEL == 1) ? dac_data_out : dac_data_in;

  always @(posedge dac_clk) begin
    dac_enable <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    if (dac_iqcor_valid_s == 1'b1) begin
      dac_data <= dac_iqcor_data_s[15:4];
    end
  end

  generate
  if (DP_DISABLE == 1) begin
  assign dac_iqcor_valid_s = dac_valid;
  assign dac_iqcor_data_s = {dac_data_out, 4'd0};
  end else begin
  ad_iqcor #(.IQSEL (IQSEL)) i_ad_iqcor (
    .clk (dac_clk),
    .valid (dac_valid),
    .data_i ({dac_data_i_s, 4'd0}),
    .data_q ({dac_data_q_s, 4'd0}),
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
      4'h9: dac_data_out <= dac_pn_data;
      4'h8: dac_data_out <= adc_data;
      4'h3: dac_data_out <= 12'd0;
      4'h2: dac_data_out <= dma_data[15:4];
      4'h1: dac_data_out <= dac_pat_data[15:4];
      default: dac_data_out <= dac_dds_data[15:4];
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

  always @(posedge dac_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_dds_phase_0 <= dac_dds_init_1_s;
      dac_dds_phase_1 <= dac_dds_init_2_s;
      dac_dds_incr_0 <= dac_dds_incr_1_s;
      dac_dds_incr_1 <= dac_dds_incr_2_s;
      dac_dds_data <= 16'd0;
    end else if (dac_valid == 1'b1) begin
      dac_dds_phase_0 <= dac_dds_phase_0 + dac_dds_incr_0;
      dac_dds_phase_1 <= dac_dds_phase_1 + dac_dds_incr_1;
      dac_dds_incr_0 <= dac_dds_incr_0;
      dac_dds_incr_1 <= dac_dds_incr_1;
      dac_dds_data <= dac_dds_data_s;
    end
  end

  // dds

  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_s = 16'd0;
  end else begin
  ad_dds i_dds (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_s));
  end
  endgenerate

  // single channel processor

  up_dac_channel #(.PCORE_DAC_CHID(CHID)) i_up_dac_channel (
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
