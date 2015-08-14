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
// This is the dac physical interface (drives samples from the low speed clock to the
// dac clock domain.

`timescale 1ns/100ps

module axi_ad9739a_if (

  // dac interface

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_data_out_a_p,
  dac_data_out_a_n,
  dac_data_out_b_p,
  dac_data_out_b_n,

  // internal resets and clocks

  dac_rst,
  dac_clk,
  dac_div_clk,
  dac_status,

  // data interface

  dac_data_00,
  dac_data_01,
  dac_data_02,
  dac_data_03,
  dac_data_04,
  dac_data_05,
  dac_data_06,
  dac_data_07,
  dac_data_08,
  dac_data_09,
  dac_data_10,
  dac_data_11,
  dac_data_12,
  dac_data_13,
  dac_data_14,
  dac_data_15);

  // parameters

  parameter   PCORE_DEVICE_TYPE = 0;

  // dac interface

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output  [13:0]  dac_data_out_a_p;
  output  [13:0]  dac_data_out_a_n;
  output  [13:0]  dac_data_out_b_p;
  output  [13:0]  dac_data_out_b_n;

  // internal resets and clocks

  input           dac_rst;
  output          dac_clk;
  output          dac_div_clk;
  output          dac_status;

  // data interface

  input   [15:0]  dac_data_00;
  input   [15:0]  dac_data_01;
  input   [15:0]  dac_data_02;
  input   [15:0]  dac_data_03;
  input   [15:0]  dac_data_04;
  input   [15:0]  dac_data_05;
  input   [15:0]  dac_data_06;
  input   [15:0]  dac_data_07;
  input   [15:0]  dac_data_08;
  input   [15:0]  dac_data_09;
  input   [15:0]  dac_data_10;
  input   [15:0]  dac_data_11;
  input   [15:0]  dac_data_12;
  input   [15:0]  dac_data_13;
  input   [15:0]  dac_data_14;
  input   [15:0]  dac_data_15;

  // internal registers

  reg             dac_status = 'd0;

  // internal signals

  wire            dac_clk_in_s;
  wire            dac_div_clk_s;

  // dac status

  always @(posedge dac_div_clk) begin
    if (dac_rst == 1'b1) begin
      dac_status <= 1'd0;
    end else begin
      dac_status <= 1'd1;
    end
  end

  // dac data output serdes(s) & buffers

  ad_serdes_out #(
    .SERDES(1),
    .DATA_WIDTH(14),
    .DEVICE_TYPE (PCORE_DEVICE_TYPE))
  i_serdes_out_data_a (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_s0 (dac_data_00[15:2]),
    .data_s1 (dac_data_02[15:2]),
    .data_s2 (dac_data_04[15:2]),
    .data_s3 (dac_data_06[15:2]),
    .data_s4 (dac_data_08[15:2]),
    .data_s5 (dac_data_10[15:2]),
    .data_s6 (dac_data_12[15:2]),
    .data_s7 (dac_data_14[15:2]),
    .data_out_p (dac_data_out_a_p),
    .data_out_n (dac_data_out_a_n));

  // dac data output serdes(s) & buffers
  
  ad_serdes_out #(
    .SERDES(1),
    .DATA_WIDTH(14),
    .DEVICE_TYPE (PCORE_DEVICE_TYPE))
  i_serdes_out_data_b (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_s0 (dac_data_01[15:2]),
    .data_s1 (dac_data_03[15:2]),
    .data_s2 (dac_data_05[15:2]),
    .data_s3 (dac_data_07[15:2]),
    .data_s4 (dac_data_09[15:2]),
    .data_s5 (dac_data_11[15:2]),
    .data_s6 (dac_data_13[15:2]),
    .data_s7 (dac_data_15[15:2]),
    .data_out_p (dac_data_out_b_p),
    .data_out_n (dac_data_out_b_n));

  // dac clock output serdes & buffer
  
  ad_serdes_out #(
    .SERDES(1),
    .DATA_WIDTH(1),
    .DEVICE_TYPE (PCORE_DEVICE_TYPE))
  i_serdes_out_clk (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_s0 (1'b1),
    .data_s1 (1'b0),
    .data_s2 (1'b1),
    .data_s3 (1'b0),
    .data_s4 (1'b1),
    .data_s5 (1'b0),
    .data_s6 (1'b1),
    .data_s7 (1'b0),
    .data_out_p (dac_clk_out_p),
    .data_out_n (dac_clk_out_n));

  // dac clock input buffers

  IBUFGDS i_dac_clk_in_ibuf (
    .I (dac_clk_in_p),
    .IB (dac_clk_in_n),
    .O (dac_clk_in_s));

  BUFG i_dac_clk_in_gbuf (
    .I (dac_clk_in_s),
    .O (dac_clk));

  BUFR #(.BUFR_DIVIDE("4")) i_dac_div_clk_rbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (dac_clk_in_s),
    .O (dac_div_clk_s));

  BUFG i_dac_div_clk_gbuf (
    .I (dac_div_clk_s),
    .O (dac_div_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
