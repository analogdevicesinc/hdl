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
// serial data output interface: serdes(x8) or oddr(x2) output module

`timescale 1ps/1ps

module ad_serdes_out (

  // reset and clocks

  rst,
  clk,
  div_clk,

  // data interface

  data_s0,
  data_s1,
  data_s2,
  data_s3,
  data_s4,
  data_s5,
  data_s6,
  data_s7,
  data_out_p,
  data_out_n);

  // parameters

  parameter   DEVICE_TYPE = 0;
  parameter   SERDES_OR_DDR_N = 1;
  parameter   DATA_WIDTH = 16;


  localparam  DEVICE_6SERIES = 1;
  localparam  DEVICE_7SERIES = 0;
  localparam  DW = DATA_WIDTH - 1;

  // reset and clocks

  input           rst;
  input           clk;
  input           div_clk;

  // data interface

  input   [DW:0]  data_s0;
  input   [DW:0]  data_s1;
  input   [DW:0]  data_s2;
  input   [DW:0]  data_s3;
  input   [DW:0]  data_s4;
  input   [DW:0]  data_s5;
  input   [DW:0]  data_s6;
  input   [DW:0]  data_s7;
  output  [DW:0]  data_out_p;
  output  [DW:0]  data_out_n;

  // internal signals

  wire    [DW:0]  data_out_s;
  wire    [DW:0]  serdes_shift1_s;
  wire    [DW:0]  serdes_shift2_s;

  // instantiations

  genvar l_inst;
  generate
  for (l_inst = 0; l_inst <= DW; l_inst = l_inst + 1) begin: g_data

  if (SERDES_OR_DDR_N == 0) begin
  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_oddr (
    .S (1'b0),
    .CE (1'b1),
    .R (rst),
    .C (clk),
    .D1 (data_s0[l_inst]),
    .D2 (data_s1[l_inst]),
    .Q (data_out_s[l_inst]));
  end

  if ((SERDES_OR_DDR_N == 1) && (DEVICE_TYPE == DEVICE_7SERIES)) begin
  OSERDESE2  #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (8),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("MASTER"))
  i_serdes (
    .D1 (data_s0[l_inst]),
    .D2 (data_s1[l_inst]),
    .D3 (data_s2[l_inst]),
    .D4 (data_s3[l_inst]),
    .D5 (data_s4[l_inst]),
    .D6 (data_s5[l_inst]),
    .D7 (data_s6[l_inst]),
    .D8 (data_s7[l_inst]),
    .T1 (1'b0),
    .T2 (1'b0),
    .T3 (1'b0),
    .T4 (1'b0),
    .SHIFTIN1 (1'b0),
    .SHIFTIN2 (1'b0),
    .SHIFTOUT1 (),
    .SHIFTOUT2 (),
    .OCE (1'b1),
    .CLK (clk),
    .CLKDIV (div_clk),
    .OQ (data_out_s[l_inst]),
    .TQ (),
    .OFB (),
    .TFB (),
    .TBYTEIN (1'b0),
    .TBYTEOUT (),
    .TCE (1'b0),
    .RST (rst));
  end

  if ((SERDES_OR_DDR_N == 1) && (DEVICE_TYPE == DEVICE_6SERIES)) begin
  OSERDESE1  #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (8),
    .INTERFACE_TYPE ("DEFAULT"),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("MASTER"))
  i_serdes_m (
    .D1 (data_s0[l_inst]),
    .D2 (data_s1[l_inst]),
    .D3 (data_s2[l_inst]),
    .D4 (data_s3[l_inst]),
    .D5 (data_s4[l_inst]),
    .D6 (data_s5[l_inst]),
    .T1 (1'b0),
    .T2 (1'b0),
    .T3 (1'b0),
    .T4 (1'b0),
    .SHIFTIN1 (serdes_shift1_s[l_inst]),
    .SHIFTIN2 (serdes_shift2_s[l_inst]),
    .SHIFTOUT1 (),
    .SHIFTOUT2 (),
    .OCE (1'b1),
    .CLK (clk),
    .CLKDIV (div_clk),
    .CLKPERF (1'b0),
    .CLKPERFDELAY (1'b0),
    .WC (1'b0),
    .ODV (1'b0),
    .OQ (data_out_s[l_inst]),
    .TQ (),
    .OCBEXTEND (),
    .OFB (),
    .TFB (),
    .TCE (1'b0),
    .RST (rst));

  OSERDESE1  #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (8),
    .INTERFACE_TYPE ("DEFAULT"),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("SLAVE"))
  i_serdes_s (
    .D1 (1'b0), 
    .D2 (1'b0), 
    .D3 (data_s6[l_inst]),
    .D4 (data_s7[l_inst]),
    .D5 (1'b0),
    .D6 (1'b0),
    .T1 (1'b0),
    .T2 (1'b0),
    .T3 (1'b0),
    .T4 (1'b0),
    .SHIFTIN1 (1'b0),
    .SHIFTIN2 (1'b0),
    .SHIFTOUT1 (serdes_shift1_s[l_inst]),
    .SHIFTOUT2 (serdes_shift2_s[l_inst]),
    .OCE (1'b1),
    .CLK (clk),
    .CLKDIV (div_clk),
    .CLKPERF (1'b0),
    .CLKPERFDELAY (1'b0),
    .WC (1'b0),
    .ODV (1'b0),
    .OQ (),
    .TQ (),
    .OCBEXTEND (),
    .OFB (),
    .TFB (),
    .TCE (1'b0),
    .RST (rst));
  end

  OBUFDS i_obuf (
    .I (data_out_s[l_inst]),
    .O (data_out_p[l_inst]),
    .OB (data_out_n[l_inst]));

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

