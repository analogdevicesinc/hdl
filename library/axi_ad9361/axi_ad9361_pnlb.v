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
// This interface includes both the transmit and receive components -
// They both uses the same clock (sourced from the receiving side).

`timescale 1ns/100ps

module axi_ad9361_pnlb (

  // device interface

  clk,
  adc_valid_in,
  adc_data_in_i1,
  adc_data_in_q1,
  adc_data_in_i2,
  adc_data_in_q2,
  dac_valid_in,
  dac_data_in_i1,
  dac_data_in_q1,
  dac_data_in_i2,
  dac_data_in_q2,

  // dac outputs

  dac_valid,
  dac_data_i1,
  dac_data_q1,
  dac_data_i2,
  dac_data_q2,

  // control signals

  dac_lb_enb_i1,
  dac_pn_enb_i1,
  dac_lb_enb_q1,
  dac_pn_enb_q1,
  dac_lb_enb_i2,
  dac_pn_enb_i2,
  dac_lb_enb_q2,
  dac_pn_enb_q2,

  // status signals

  adc_pn_oos_i1,
  adc_pn_err_i1,
  adc_pn_oos_q1,
  adc_pn_err_q1,
  adc_pn_oos_i2,
  adc_pn_err_i2,
  adc_pn_oos_q2,
  adc_pn_err_q2);

  // device interface

  input           clk;
  input           adc_valid_in;
  input   [11:0]  adc_data_in_i1;
  input   [11:0]  adc_data_in_q1;
  input   [11:0]  adc_data_in_i2;
  input   [11:0]  adc_data_in_q2;
  input           dac_valid_in;
  input   [11:0]  dac_data_in_i1;
  input   [11:0]  dac_data_in_q1;
  input   [11:0]  dac_data_in_i2;
  input   [11:0]  dac_data_in_q2;

  // dac outputs

  output          dac_valid;
  output  [11:0]  dac_data_i1;
  output  [11:0]  dac_data_q1;
  output  [11:0]  dac_data_i2;
  output  [11:0]  dac_data_q2;

  // control signals

  input           dac_lb_enb_i1;
  input           dac_pn_enb_i1;
  input           dac_lb_enb_q1;
  input           dac_pn_enb_q1;
  input           dac_lb_enb_i2;
  input           dac_pn_enb_i2;
  input           dac_lb_enb_q2;
  input           dac_pn_enb_q2;

  // status signals

  output          adc_pn_oos_i1;
  output          adc_pn_err_i1;
  output          adc_pn_oos_q1;
  output          adc_pn_err_q1;
  output          adc_pn_oos_i2;
  output          adc_pn_err_i2;
  output          adc_pn_oos_q2;
  output          adc_pn_err_q2;

  // internal registers

  reg             dac_valid_t = 'd0;
  reg     [23:0]  dac_pn_i1 = 'd0;
  reg     [23:0]  dac_pn_q1 = 'd0;
  reg     [23:0]  dac_pn_i2 = 'd0;
  reg     [23:0]  dac_pn_q2 = 'd0;
  reg     [11:0]  dac_lb_i1 = 'd0;
  reg     [11:0]  dac_lb_q1 = 'd0;
  reg     [11:0]  dac_lb_i2 = 'd0;
  reg     [11:0]  dac_lb_q2 = 'd0;
  reg             dac_valid = 'd0;
  reg     [11:0]  dac_data_i1 = 'd0;
  reg     [11:0]  dac_data_q1 = 'd0;
  reg     [11:0]  dac_data_i2 = 'd0;
  reg     [11:0]  dac_data_q2 = 'd0;
  reg             adc_valid_t = 'd0;
  reg     [11:0]  adc_data_in_i1_d = 'd0;
  reg     [11:0]  adc_data_in_q1_d = 'd0;
  reg     [11:0]  adc_data_in_i2_d = 'd0;
  reg     [11:0]  adc_data_in_q2_d = 'd0;
  reg     [23:0]  adc_pn_data_i1 = 'd0;
  reg     [23:0]  adc_pn_data_q1 = 'd0;
  reg     [23:0]  adc_pn_data_i2 = 'd0;
  reg     [23:0]  adc_pn_data_q2 = 'd0;
  reg             adc_pn_err_i1 = 'd0;
  reg             adc_pn_oos_i1 = 'd0;
  reg     [ 3:0]  adc_pn_oos_count_i1 = 'd0;
  reg             adc_pn_err_q1 = 'd0;
  reg             adc_pn_oos_q1 = 'd0;
  reg     [ 3:0]  adc_pn_oos_count_q1 = 'd0;
  reg             adc_pn_err_i2 = 'd0;
  reg             adc_pn_oos_i2 = 'd0;
  reg     [ 3:0]  adc_pn_oos_count_i2 = 'd0;
  reg             adc_pn_err_q2 = 'd0;
  reg             adc_pn_oos_q2 = 'd0;
  reg     [ 3:0]  adc_pn_oos_count_q2 = 'd0;

  // internal signals

  wire            dac_valid_t_s;
  wire            adc_valid_t_s;
  wire    [23:0]  adc_data_in_i1_s;
  wire            adc_pn_err_i1_s;
  wire            adc_pn_update_i1_s;
  wire            adc_pn_match_i1_s;
  wire            adc_pn_match_i1_z_s;
  wire            adc_pn_match_i1_d_s;
  wire    [23:0]  adc_pn_data_i1_s;
  wire    [23:0]  adc_data_in_q1_s;
  wire            adc_pn_err_q1_s;
  wire            adc_pn_update_q1_s;
  wire            adc_pn_match_q1_s;
  wire            adc_pn_match_q1_z_s;
  wire            adc_pn_match_q1_d_s;
  wire    [23:0]  adc_pn_data_q1_s;
  wire    [23:0]  adc_data_in_i2_s;
  wire            adc_pn_err_i2_s;
  wire            adc_pn_update_i2_s;
  wire            adc_pn_match_i2_s;
  wire            adc_pn_match_i2_z_s;
  wire            adc_pn_match_i2_d_s;
  wire    [23:0]  adc_pn_data_i2_s;
  wire    [23:0]  adc_data_in_q2_s;
  wire            adc_pn_err_q2_s;
  wire            adc_pn_update_q2_s;
  wire            adc_pn_match_q2_s;
  wire            adc_pn_match_q2_z_s;
  wire            adc_pn_match_q2_d_s;
  wire    [23:0]  adc_pn_data_q2_s;

  // prbs-9 function

  function [23:0] pn09;
    input [23:0] din;
    reg   [23:0] dout;
    begin
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
      pn09 = dout;
    end
  endfunction

  // prbs-11 function

  function [23:0] pn11;
    input [23:0] din;
    reg   [23:0] dout;
    begin
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
      pn11 = dout;
    end
  endfunction

  // prbs-15 function

  function [23:0] pn15;
    input [23:0] din;
    reg   [23:0] dout;
    begin
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
      pn15 = dout;
    end
  endfunction

  // prbs-20 function

  function [23:0] pn20;
    input [23:0] din;
    reg   [23:0] dout;
    begin
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
      pn20 = dout;
    end
  endfunction

  // prbs generators run at 24bits wide

  assign dac_valid_t_s = dac_valid_in & dac_valid_t;

  always @(posedge clk) begin
    if (dac_valid_in == 1'b1) begin
      dac_valid_t <= ~dac_valid_t;
    end
    if (dac_pn_enb_i1 == 1'b0) begin
      dac_pn_i1 <= 24'hffffff;
    end else if (dac_valid_t_s == 1'b1) begin
      dac_pn_i1 <= pn09(dac_pn_i1);
    end
    if (dac_pn_enb_q1 == 1'b0) begin
      dac_pn_q1 <= 24'hffffff;
    end else if (dac_valid_t_s == 1'b1) begin
      dac_pn_q1 <= pn11(dac_pn_q1);
    end
    if (dac_pn_enb_i2 == 1'b0) begin
      dac_pn_i2 <= 24'hffffff;
    end else if (dac_valid_t_s == 1'b1) begin
      dac_pn_i2 <= pn15(dac_pn_i2);
    end
    if (dac_pn_enb_q2 == 1'b0) begin
      dac_pn_q2 <= 24'hffffff;
    end else if (dac_valid_t_s == 1'b1) begin
      dac_pn_q2 <= pn20(dac_pn_q2);
    end
  end

  // hold adc data for loopback, it is assumed that there is a one to one mapping
  // of receive and transmit (the rates are the same).

  always @(posedge clk) begin
    if (adc_valid_in == 1'b1) begin
      dac_lb_i1 <= adc_data_in_i1;
      dac_lb_q1 <= adc_data_in_q1;
      dac_lb_i2 <= adc_data_in_i2;
      dac_lb_q2 <= adc_data_in_q2;
    end
  end

  // dac outputs-

  always @(posedge clk) begin
    dac_valid <= dac_valid_in;
    if (dac_pn_enb_i1 == 1'b1) begin
      if (dac_valid_t == 1'b1) begin
        dac_data_i1 <= dac_pn_i1[11:0];
      end else begin
        dac_data_i1 <= dac_pn_i1[23:12];
      end
    end else if (dac_lb_enb_i1 == 1'b1) begin
      dac_data_i1 <= dac_lb_i1;
    end else begin
      dac_data_i1 <= dac_data_in_i1;
    end
    if (dac_pn_enb_q1 == 1'b1) begin
      if (dac_valid_t == 1'b1) begin
        dac_data_q1 <= dac_pn_q1[11:0];
      end else begin
        dac_data_q1 <= dac_pn_q1[23:12];
      end
    end else if (dac_lb_enb_q1 == 1'b1) begin
      dac_data_q1 <= dac_lb_q1;
    end else begin
      dac_data_q1 <= dac_data_in_q1;
    end
    if (dac_pn_enb_i2 == 1'b1) begin
      if (dac_valid_t == 1'b1) begin
        dac_data_i2 <= dac_pn_i2[11:0];
      end else begin
        dac_data_i2 <= dac_pn_i2[23:12];
      end
    end else if (dac_lb_enb_i2 == 1'b1) begin
      dac_data_i2 <= dac_lb_i2;
    end else begin
      dac_data_i2 <= dac_data_in_i2;
    end
    if (dac_pn_enb_q2 == 1'b1) begin
      if (dac_valid_t == 1'b1) begin
        dac_data_q2 <= dac_pn_q2[11:0];
      end else begin
        dac_data_q2 <= dac_pn_q2[23:12];
      end
    end else if (dac_lb_enb_q2 == 1'b1) begin
      dac_data_q2 <= dac_lb_q2;
    end else begin
      dac_data_q2 <= dac_data_in_q2;
    end
  end

  // adc pn monitoring

  assign adc_valid_t_s = adc_valid_in & adc_valid_t;

  assign adc_data_in_i1_s = {adc_data_in_i1_d, adc_data_in_i1};
  assign adc_pn_err_i1_s = ~(adc_pn_oos_i1 | adc_pn_match_i1_s);
  assign adc_pn_update_i1_s = ~(adc_pn_oos_i1 ^ adc_pn_match_i1_s);
  assign adc_pn_match_i1_s = adc_pn_match_i1_d_s & adc_pn_match_i1_z_s;
  assign adc_pn_match_i1_z_s = (adc_data_in_i1_s == 24'd0) ? 1'b0 : 1'b1;
  assign adc_pn_match_i1_d_s = (adc_data_in_i1_s == adc_pn_data_i1) ? 1'b1 : 1'b0;
  assign adc_pn_data_i1_s = (adc_pn_oos_i1 == 1'b1) ? adc_data_in_i1_s : adc_pn_data_i1;

  assign adc_data_in_q1_s = {adc_data_in_q1_d, adc_data_in_q1};
  assign adc_pn_err_q1_s = ~(adc_pn_oos_q1 | adc_pn_match_q1_s);
  assign adc_pn_update_q1_s = ~(adc_pn_oos_q1 ^ adc_pn_match_q1_s);
  assign adc_pn_match_q1_s = adc_pn_match_q1_d_s & adc_pn_match_q1_z_s;
  assign adc_pn_match_q1_z_s = (adc_data_in_q1_s == 24'd0) ? 1'b0 : 1'b1;
  assign adc_pn_match_q1_d_s = (adc_data_in_q1_s == adc_pn_data_q1) ? 1'b1 : 1'b0;
  assign adc_pn_data_q1_s = (adc_pn_oos_q1 == 1'b1) ? adc_data_in_q1_s : adc_pn_data_q1;

  assign adc_data_in_i2_s = {adc_data_in_i2_d, adc_data_in_i2};
  assign adc_pn_err_i2_s = ~(adc_pn_oos_i2 | adc_pn_match_i2_s);
  assign adc_pn_update_i2_s = ~(adc_pn_oos_i2 ^ adc_pn_match_i2_s);
  assign adc_pn_match_i2_s = adc_pn_match_i2_d_s & adc_pn_match_i2_z_s;
  assign adc_pn_match_i2_z_s = (adc_data_in_i2_s == 24'd0) ? 1'b0 : 1'b1;
  assign adc_pn_match_i2_d_s = (adc_data_in_i2_s == adc_pn_data_i2) ? 1'b1 : 1'b0;
  assign adc_pn_data_i2_s = (adc_pn_oos_i2 == 1'b1) ? adc_data_in_i2_s : adc_pn_data_i2;

  assign adc_data_in_q2_s = {adc_data_in_q2_d, adc_data_in_q2};
  assign adc_pn_err_q2_s = ~(adc_pn_oos_q2 | adc_pn_match_q2_s);
  assign adc_pn_update_q2_s = ~(adc_pn_oos_q2 ^ adc_pn_match_q2_s);
  assign adc_pn_match_q2_s = adc_pn_match_q2_d_s & adc_pn_match_q2_z_s;
  assign adc_pn_match_q2_z_s = (adc_data_in_q2_s == 24'd0) ? 1'b0 : 1'b1;
  assign adc_pn_match_q2_d_s = (adc_data_in_q2_s == adc_pn_data_q2) ? 1'b1 : 1'b0;
  assign adc_pn_data_q2_s = (adc_pn_oos_q2 == 1'b1) ? adc_data_in_q2_s : adc_pn_data_q2;

  // adc pn running sequence

  always @(posedge clk) begin
    if (adc_valid_in == 1'b1) begin
      adc_valid_t <= ~adc_valid_t;
      adc_data_in_i1_d <= adc_data_in_i1;
      adc_data_in_q1_d <= adc_data_in_q1;
      adc_data_in_i2_d <= adc_data_in_i2;
      adc_data_in_q2_d <= adc_data_in_q2;
    end
    if (adc_valid_t_s == 1'b1) begin
      adc_pn_data_i1 <= pn09(adc_pn_data_i1_s);
      adc_pn_data_q1 <= pn11(adc_pn_data_q1_s);
      adc_pn_data_i2 <= pn15(adc_pn_data_i2_s);
      adc_pn_data_q2 <= pn20(adc_pn_data_q2_s);
    end
  end

  // pn oos and counters (16 to clear and set).

  always @(posedge clk) begin
    if (adc_valid_t_s == 1'b1) begin
      adc_pn_err_i1 <= adc_pn_err_i1_s;
      if ((adc_pn_update_i1_s == 1'b1) && (adc_pn_oos_count_i1 >= 15)) begin
        adc_pn_oos_i1 <= ~adc_pn_oos_i1;
      end
      if (adc_pn_update_i1_s == 1'b1) begin
        adc_pn_oos_count_i1 <= adc_pn_oos_count_i1 + 1'b1;
      end else begin
        adc_pn_oos_count_i1 <= 'd0;
      end
      adc_pn_err_q1 <= adc_pn_err_q1_s;
      if ((adc_pn_update_q1_s == 1'b1) && (adc_pn_oos_count_q1 >= 15)) begin
        adc_pn_oos_q1 <= ~adc_pn_oos_q1;
      end
      if (adc_pn_update_q1_s == 1'b1) begin
        adc_pn_oos_count_q1 <= adc_pn_oos_count_q1 + 1'b1;
      end else begin
        adc_pn_oos_count_q1 <= 'd0;
      end
      adc_pn_err_i2 <= adc_pn_err_i2_s;
      if ((adc_pn_update_i2_s == 1'b1) && (adc_pn_oos_count_i2 >= 15)) begin
        adc_pn_oos_i2 <= ~adc_pn_oos_i2;
      end
      if (adc_pn_update_i2_s == 1'b1) begin
        adc_pn_oos_count_i2 <= adc_pn_oos_count_i2 + 1'b1;
      end else begin
        adc_pn_oos_count_i2 <= 'd0;
      end
      adc_pn_err_q2 <= adc_pn_err_q2_s;
      if ((adc_pn_update_q2_s == 1'b1) && (adc_pn_oos_count_q2 >= 15)) begin
        adc_pn_oos_q2 <= ~adc_pn_oos_q2;
      end
      if (adc_pn_update_q2_s == 1'b1) begin
        adc_pn_oos_count_q2 <= adc_pn_oos_count_q2 + 1'b1;
      end else begin
        adc_pn_oos_count_q2 <= 'd0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
