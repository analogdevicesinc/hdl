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

  // interface - inputs

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

  // interface - outputs

  adc_valid,
  adc_data_i1,
  adc_data_q1,
  adc_data_i2,
  adc_data_q2,
  dac_valid,
  dac_data_i1,
  dac_data_q1,
  dac_data_i2,
  dac_data_q2,

  // control signals

  adc_lb_enb_i1,
  dac_lb_enb_i1,
  dac_pn_enb_i1,
  adc_lb_enb_q1,
  dac_lb_enb_q1,
  dac_pn_enb_q1,
  adc_lb_enb_i2,
  dac_lb_enb_i2,
  dac_pn_enb_i2,
  adc_lb_enb_q2,
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

  output          adc_valid;
  output  [11:0]  adc_data_i1;
  output  [11:0]  adc_data_q1;
  output  [11:0]  adc_data_i2;
  output  [11:0]  adc_data_q2;
  output          dac_valid;
  output  [11:0]  dac_data_i1;
  output  [11:0]  dac_data_q1;
  output  [11:0]  dac_data_i2;
  output  [11:0]  dac_data_q2;

  // control signals

  input           adc_lb_enb_i1;
  input           dac_lb_enb_i1;
  input           dac_pn_enb_i1;
  input           adc_lb_enb_q1;
  input           dac_lb_enb_q1;
  input           dac_pn_enb_q1;
  input           adc_lb_enb_i2;
  input           dac_lb_enb_i2;
  input           dac_pn_enb_i2;
  input           adc_lb_enb_q2;
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

  // instantiations

  axi_ad9361_pnlb_1 #(.PRBS_SEL(0)) i_pnlb_i1 (
    .clk (clk),
    .adc_valid_in (adc_valid_in),
    .adc_data_in (adc_data_in_i1),
    .dac_valid_in (dac_valid_in),
    .dac_data_in (dac_data_in_i1),
    .adc_valid (adc_valid),
    .adc_data (adc_data_i1),
    .dac_valid (dac_valid),
    .dac_data (dac_data_i1),
    .adc_lb_enb (adc_lb_enb_i1),
    .dac_lb_enb (dac_lb_enb_i1),
    .dac_pn_enb (dac_pn_enb_i1),
    .adc_pn_oos (adc_pn_oos_i1),
    .adc_pn_err (adc_pn_err_i1));

  axi_ad9361_pnlb_1 #(.PRBS_SEL(1)) i_pnlb_q1 (
    .clk (clk),
    .adc_valid_in (adc_valid_in),
    .adc_data_in (adc_data_in_q1),
    .dac_valid_in (dac_valid_in),
    .dac_data_in (dac_data_in_q1),
    .adc_valid (),
    .adc_data (adc_data_q1),
    .dac_valid (),
    .dac_data (dac_data_q1),
    .adc_lb_enb (adc_lb_enb_q1),
    .dac_lb_enb (dac_lb_enb_q1),
    .dac_pn_enb (dac_pn_enb_q1),
    .adc_pn_oos (adc_pn_oos_q1),
    .adc_pn_err (adc_pn_err_q1));

  axi_ad9361_pnlb_1 #(.PRBS_SEL(2)) i_pnlb_i2 (
    .clk (clk),
    .adc_valid_in (adc_valid_in),
    .adc_data_in (adc_data_in_i2),
    .dac_valid_in (dac_valid_in),
    .dac_data_in (dac_data_in_i2),
    .adc_valid (),
    .adc_data (adc_data_i2),
    .dac_valid (),
    .dac_data (dac_data_i2),
    .adc_lb_enb (adc_lb_enb_i2),
    .dac_lb_enb (dac_lb_enb_i2),
    .dac_pn_enb (dac_pn_enb_i2),
    .adc_pn_oos (adc_pn_oos_i2),
    .adc_pn_err (adc_pn_err_i2));

  axi_ad9361_pnlb_1 #(.PRBS_SEL(3)) i_pnlb_q2 (
    .clk (clk),
    .adc_valid_in (adc_valid_in),
    .adc_data_in (adc_data_in_q2),
    .dac_valid_in (dac_valid_in),
    .dac_data_in (dac_data_in_q2),
    .adc_valid (),
    .adc_data (adc_data_q2),
    .dac_valid (),
    .dac_data (dac_data_q2),
    .adc_lb_enb (adc_lb_enb_q2),
    .dac_lb_enb (dac_lb_enb_q2),
    .dac_pn_enb (dac_pn_enb_q2),
    .adc_pn_oos (adc_pn_oos_q2),
    .adc_pn_err (adc_pn_err_q2));

endmodule

// ***************************************************************************
// ***************************************************************************
