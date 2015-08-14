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
// ADC channel-

`timescale 1ns/100ps

module axi_ad9652_channel (

  // adc interface

  adc_clk,
  adc_rst,
  adc_data,
  adc_or,

  // channel interface

  adc_dcfilter_data_out,
  adc_dcfilter_data_in,
  adc_iqcor_data,
  adc_enable,
  up_adc_pn_err,
  up_adc_pn_oos,
  up_adc_or,

  // processor interface

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

  parameter IQSEL = 0;
  parameter CHID = 0;
  parameter DP_DISABLE = 0;

  // adc interface

  input           adc_clk;
  input           adc_rst;
  input   [15:0]  adc_data;
  input           adc_or;

  // channel interface

  output  [15:0]  adc_dcfilter_data_out;
  input   [15:0]  adc_dcfilter_data_in;
  output  [15:0]  adc_iqcor_data;
  output          adc_enable;
  output          up_adc_pn_err;
  output          up_adc_pn_oos;
  output          up_adc_or;

  // processor interface

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

  // internal signals

  wire    [15:0]  adc_dcfilter_data_i_s;
  wire    [15:0]  adc_dcfilter_data_q_s;
  wire            adc_iqcor_enb_s;
  wire            adc_dcfilt_enb_s;
  wire    [15:0]  adc_dcfilt_offset_s;
  wire    [15:0]  adc_dcfilt_coeff_s;
  wire    [15:0]  adc_iqcor_coeff_1_s;
  wire    [15:0]  adc_iqcor_coeff_2_s;
  wire    [ 3:0]  adc_pnseq_sel_s;
  wire            adc_pn_err_s;
  wire            adc_pn_oos_s;

  // iq correction inputs

  assign adc_dcfilter_data_i_s = (IQSEL == 1) ? adc_dcfilter_data_in  : adc_dcfilter_data_out;
  assign adc_dcfilter_data_q_s = (IQSEL == 1) ? adc_dcfilter_data_out : adc_dcfilter_data_in;

  axi_ad9652_pnmon i_pnmon (
    .adc_clk (adc_clk),
    .adc_data (adc_data),
    .adc_pn_oos (adc_pn_oos_s),
    .adc_pn_err (adc_pn_err_s),
    .adc_pnseq_sel (adc_pnseq_sel_s));

  generate
  if (DP_DISABLE == 1) begin
  assign adc_dcfilter_data_out = adc_data;
  end else begin
  ad_dcfilter i_ad_dcfilter (
    .clk (adc_clk),
    .valid (1'b1),
    .data (adc_data),
    .valid_out (),
    .data_out (adc_dcfilter_data_out),
    .dcfilt_enb (adc_dcfilt_enb_s),
    .dcfilt_coeff (adc_dcfilt_coeff_s),
    .dcfilt_offset (adc_dcfilt_offset_s));
  end
  endgenerate

  generate
  if (DP_DISABLE == 1) begin
  assign adc_iqcor_data = (IQSEL == 1) ? adc_dcfilter_data_q_s : adc_dcfilter_data_i_s;
  end else begin
  ad_iqcor #(.IQSEL(IQSEL)) i_ad_iqcor (
    .clk (adc_clk),
    .valid (1'b1),
    .data_i (adc_dcfilter_data_i_s),
    .data_q (adc_dcfilter_data_q_s),
    .valid_out (),
    .data_out (adc_iqcor_data),
    .iqcor_enable (adc_iqcor_enb_s),
    .iqcor_coeff_1 (adc_iqcor_coeff_1_s),
    .iqcor_coeff_2 (adc_iqcor_coeff_2_s));
  end
  endgenerate

  up_adc_channel #(.PCORE_ADC_CHID(CHID)) i_up_adc_channel (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable),
    .adc_iqcor_enb (adc_iqcor_enb_s),
    .adc_dcfilt_enb (adc_dcfilt_enb_s),
    .adc_dfmt_se (),
    .adc_dfmt_type (),
    .adc_dfmt_enable (),
    .adc_dcfilt_offset (adc_dcfilt_offset_s),
    .adc_dcfilt_coeff (adc_dcfilt_coeff_s),
    .adc_iqcor_coeff_1 (adc_iqcor_coeff_1_s),
    .adc_iqcor_coeff_2 (adc_iqcor_coeff_2_s),
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

