// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
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
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
`timescale 1ps/1ps

module ad_serdes_in (

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
  data_in_p,
  data_in_n);

  // parameters
  parameter   DEVICE_TYPE = 0;
  parameter   SERDES = 1;
  parameter   DATA_WIDTH = 16;
  parameter   PARALLEL_DATA_WIDTH = 8;

  localparam  DEVICE_6SERIES = 1;
  localparam  DEVICE_7SERIES = 0;
  localparam  DW = DATA_WIDTH - 1;

  // reset and clocks
  input           rst;
  input           clk;
  input           div_clk;

  // data interface
  output  [DW:0]  data_s0;
  output  [DW:0]  data_s1;
  output  [DW:0]  data_s2;
  output  [DW:0]  data_s3;
  output  [DW:0]  data_s4;
  output  [DW:0]  data_s5;
  output  [DW:0]  data_s6;
  output  [DW:0]  data_s7;
  input   [DW:0]  data_in_p;
  input   [DW:0]  data_in_n;

  // internal signals
  wire    [DW:0]  data_in_s;
  wire    [DW:0]  data_shift1_s;
  wire    [DW:0]  data_shift2_s;

  // instantiations
  genvar l_inst;
  generate
  for (l_inst = 0; l_inst <= DW; l_inst = l_inst + 1) begin
    if (SERDES == 0) begin
      IDDR #(
        .DDR_CLK_EDGE("SAME_EDGE"),
        .INIT_Q1(1'b0),
        .INIT_Q2(1'b0),
        .SRTYPE("ASYNC"))
      i_iddr (
        .Q1(data_s0[l_inst]),
        .Q2(data_s1[l_inst]),
        .C(clk),
        .CE(1'b1),
        .D(data_in_s[l_inst]),
        .R(rst),
        .S(1'b0)
      );
    end

    if ((SERDES == 1) && (DEVICE_TYPE == DEVICE_7SERIES)) begin
      ISERDESE2 #(
        .DATA_RATE("SDR"),
        .DATA_WIDTH(PARALLEL_DATA_WIDTH),
        .DYN_CLKDIV_INV_EN("FALSE"),
        .DYN_CLK_INV_EN("FALSE"),
        .INIT_Q1(1'b0),
        .INIT_Q2(1'b0),
        .INIT_Q3(1'b0),
        .INIT_Q4(1'b0),
        .INTERFACE_TYPE("NETWORKING"),
        .IOBDELAY("NONE"),
        .NUM_CE(1),
        .OFB_USED("FALSE"),
        .SERDES_MODE("MASTER"),
        .SRVAL_Q1(1'b0),
        .SRVAL_Q2(1'b0),
        .SRVAL_Q3(1'b0),
        .SRVAL_Q4(1'b0)
      )
      ISERDESE2_inst (
        .O(),
        .Q1(data_s0[l_inst]),
        .Q2(data_s1[l_inst]),
        .Q3(data_s2[l_inst]),
        .Q4(data_s3[l_inst]),
        .Q5(data_s4[l_inst]),
        .Q6(data_s5[l_inst]),
        .Q7(data_s6[l_inst]),
        .Q8(data_s7[l_inst]),
        .SHIFTOUT1(),
        .SHIFTOUT2(),
        .BITSLIP(1'b0),
        .CE1(1'b1),
        .CE2(1'b0),
        .CLKDIVP(1'b0),
        .CLK(clk),
        .CLKB(1'b0),
        .CLKDIV(div_clk),
        .OCLK(1'b0),
        .DYNCLKDIVSEL(1'b0),
        .DYNCLKSEL(1'b0),
        .D(data_in_s[l_inst]),
        .DDLY(1'b0),
        .OFB(1'b0),
        .OCLKB(1'b0),
        .RST(rst),
        .SHIFTIN1(1'b0),
        .SHIFTIN2(1'b0)
      );
    end

    if ((SERDES == 1) && (DEVICE_TYPE == DEVICE_6SERIES)) begin
      if (PARALLEL_DATA_WIDTH <= 6) begin
        ISERDESE1 #(
          .DATA_RATE("SDR"),
          .DATA_WIDTH(PARALLEL_DATA_WIDTH),
          .DYN_CLKDIV_INV_EN("FALSE"),
          .DYN_CLK_INV_EN("FALSE"),
          .INIT_Q1(1'b0),
          .INIT_Q2(1'b0),
          .INIT_Q3(1'b0),
          .INIT_Q4(1'b0),
          .INTERFACE_TYPE("NETWORKING"),
          .IOBDELAY("NONE"),
          .NUM_CE(1),
          .OFB_USED("FALSE"),
          .SERDES_MODE("MASTER"),
          .SRVAL_Q1(1'b0),
          .SRVAL_Q2(1'b0),
          .SRVAL_Q3(1'b0),
          .SRVAL_Q4(1'b0))
        i_serdes (
          .O(),
          .Q1(data_s0[l_inst]),
          .Q2(data_s1[l_inst]),
          .Q3(data_s2[l_inst]),
          .Q4(data_s3[l_inst]),
          .Q5(data_s4[l_inst]),
          .Q6(data_s5[l_inst]),
          .SHIFTOUT1(data_shift1_s[l_inst]),
          .SHIFTOUT2(data_shift2_s[l_inst]),
          .BITSLIP(1'b0),
          .CE1(1'b1),
          .CE2(1'b1),
          .CLK(clk),
          .CLKB(1'b0),
          .CLKDIV(div_clk),
          .OCLK(1'b0),
          .DYNCLKDIVSEL(1'b0),
          .DYNCLKSEL(1'b0),
          .D(data_in_s[l_inst]),
          .DDLY(1'b0),
          .OFB(1'b0),
          .RST(rst),
          .SHIFTIN1(1'b0),
          .SHIFTIN2(1'b0)
        );
      end else begin
        ISERDESE1 #(
          .DATA_RATE("SDR"),
          .DATA_WIDTH(PARALLEL_DATA_WIDTH),
          .DYN_CLKDIV_INV_EN("FALSE"),
          .DYN_CLK_INV_EN("FALSE"),
          .INIT_Q1(1'b0),
          .INIT_Q2(1'b0),
          .INIT_Q3(1'b0),
          .INIT_Q4(1'b0),
          .INTERFACE_TYPE("NETWORKING"),
          .IOBDELAY("NONE"),
          .NUM_CE(1),
          .OFB_USED("FALSE"),
          .SERDES_MODE("MASTER"),
          .SRVAL_Q1(1'b0),
          .SRVAL_Q2(1'b0),
          .SRVAL_Q3(1'b0),
          .SRVAL_Q4(1'b0))
        i_serdes_m (
          .O(),
          .Q1(data_s0[l_inst]),
          .Q2(data_s1[l_inst]),
          .Q3(data_s2[l_inst]),
          .Q4(data_s3[l_inst]),
          .Q5(data_s4[l_inst]),
          .Q6(data_s5[l_inst]),
          .SHIFTOUT1(data_shift1_s[l_inst]),
          .SHIFTOUT2(data_shift2_s[l_inst]),
          .BITSLIP(1'b0),
          .CE1(1'b1),
          .CE2(1'b1),
          .CLK(clk),
          .CLKB(1'b0),
          .CLKDIV(div_clk),
          .OCLK(1'b0),
          .DYNCLKDIVSEL(1'b0),
          .DYNCLKSEL(1'b0),
          .D(data_in_s[l_inst]),
          .DDLY(1'b0),
          .OFB(1'b0),
          .RST(rst),
          .SHIFTIN1(1'b0),
          .SHIFTIN2(1'b0)
        );

        ISERDESE1 #(
          .DATA_RATE("SDR"),
          .DATA_WIDTH(PARALLEL_DATA_WIDTH),
          .DYN_CLKDIV_INV_EN("FALSE"),
          .DYN_CLK_INV_EN("FALSE"),
          .INIT_Q1(1'b0),
          .INIT_Q2(1'b0),
          .INIT_Q3(1'b0),
          .INIT_Q4(1'b0),
          .INTERFACE_TYPE("NETWORKING"),
          .IOBDELAY("NONE"),
          .NUM_CE(1),
          .OFB_USED("FALSE"),
          .SERDES_MODE("SLAVE"),
          .SRVAL_Q1(1'b0),
          .SRVAL_Q2(1'b0),
          .SRVAL_Q3(1'b0),
          .SRVAL_Q4(1'b0))
        i_serdes_s (
          .O(),
          .Q1(),
          .Q2(),
          .Q3(data_s6),
          .Q4(data_s7),
          .Q5(),
          .Q6(),
          .SHIFTOUT1(),
          .SHIFTOUT2(),
          .BITSLIP(1'b0),
          .CE1(1'b1),
          .CE2(1'b1),
          .CLK(clk),
          .CLKB(1'b0),
          .CLKDIV(div_clk),
          .OCLK(1'b0),
          .DYNCLKDIVSEL(1'b0),
          .DYNCLKSEL(1'b0),
          .D(1'b0),
          .DDLY(1'b0),
          .OFB(1'b0),
          .RST(rst),
          .SHIFTIN1(data_shift1_s[l_inst]),
          .SHIFTIN2(data_shift2_s[l_inst]));
    end
  end

  IBUFDS i_ibuf (
    .O(data_in_s[l_inst]),
    .I(data_in_p[l_inst]),
    .IB(data_in_n[l_inst])
  );
  end
  endgenerate

endmodule

