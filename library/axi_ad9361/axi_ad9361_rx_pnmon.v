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
// PN monitors

`timescale 1ns/100ps

module axi_ad9361_rx_pnmon (

  // adc interface

  adc_clk,
  adc_valid,
  adc_data_i,
  adc_data_q,

  // pn out of sync and error

  adc_pnseq_sel,
  adc_pn_oos,
  adc_pn_err);

  // parameters

  parameter   IQSEL     = 0;
  parameter   PRBS_SEL  = 0;
  localparam  PRBS_P09  = 0;
  localparam  PRBS_P11  = 1;
  localparam  PRBS_P15  = 2;
  localparam  PRBS_P20  = 3;

  // adc interface

  input           adc_clk;
  input           adc_valid;
  input   [11:0]  adc_data_i;
  input   [11:0]  adc_data_q;

  // pn out of sync and error

  input   [ 3:0]  adc_pnseq_sel;
  output          adc_pn_oos;
  output          adc_pn_err;

  // internal registers

  reg             adc_pn0_valid = 'd0;
  reg     [15:0]  adc_pn0_data = 'd0;
  reg             adc_pn0_valid_in = 'd0;
  reg     [15:0]  adc_pn0_data_in = 'd0;
  reg     [15:0]  adc_pn0_data_pn = 'd0;
  reg             adc_pn1_valid_t = 'd0;
  reg     [11:0]  adc_pn1_data_d = 'd0;
  reg             adc_pn1_valid_in = 'd0;
  reg     [23:0]  adc_pn1_data_in = 'd0;
  reg     [23:0]  adc_pn1_data_pn = 'd0;
  reg             adc_pn_valid_in = 'd0;
  reg     [23:0]  adc_pn_data_in = 'd0;
  reg     [23:0]  adc_pn_data_pn = 'd0;

  // internal signals

  wire    [11:0]  adc_pn0_data_i_s;
  wire    [11:0]  adc_pn0_data_q_s;
  wire    [11:0]  adc_pn0_data_q_rev_s;
  wire    [15:0]  adc_pn0_data_s;
  wire            adc_pn0_iq_match_s;
  wire    [15:0]  adc_pn0_data_pn_s;
  wire            adc_pn1_valid_s;
  wire    [23:0]  adc_pn1_data_pn_s;

  // bit reversal function

  function [11:0] brfn;
    input [11:0] din;
    reg   [11:0] dout;
    begin
      dout[11] = din[ 0];
      dout[10] = din[ 1];
      dout[ 9] = din[ 2];
      dout[ 8] = din[ 3];
      dout[ 7] = din[ 4];
      dout[ 6] = din[ 5];
      dout[ 5] = din[ 6];
      dout[ 4] = din[ 7];
      dout[ 3] = din[ 8];
      dout[ 2] = din[ 9];
      dout[ 1] = din[10];
      dout[ 0] = din[11];
      brfn = dout;
    end
  endfunction

  // device-specific prbs function

  function [15:0] pn0fn;
    input [15:0] din;
    reg   [15:0] dout;
    begin
      dout = {din[14:0], ((^din[15:4]) ^ (^din[2:1]))};
      pn0fn = dout;
    end
  endfunction

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

  // device specific, assuming lower nibble is lost-

  assign adc_pn0_data_i_s = (IQSEL == 1) ? adc_data_q : adc_data_i;
  assign adc_pn0_data_q_s = (IQSEL == 1) ? adc_data_i : adc_data_q;
  assign adc_pn0_data_q_rev_s = brfn(adc_pn0_data_q_s);
  assign adc_pn0_data_s = {adc_pn0_data_i_s, adc_pn0_data_q_rev_s[3:0]};
  assign adc_pn0_iq_match_s = (adc_pn0_data_i_s[7:0] == adc_pn0_data_q_rev_s[11:4]) ? 1'b1 : 1'b0;
  assign adc_pn0_data_pn_s = (adc_pn_oos == 1'b1) ? adc_pn0_data_in : adc_pn0_data_pn;

  always @(posedge adc_clk) begin
    adc_pn0_valid <= adc_valid;
    adc_pn0_data <= (adc_pn0_iq_match_s == 1'b0) ? 16'hdead : adc_pn0_data_s;
    adc_pn0_valid_in <= adc_pn0_valid;
    if (adc_pn0_valid == 1'b1) begin
      adc_pn0_data_in <= adc_pn0_data;
      adc_pn0_data_pn <= pn0fn(adc_pn0_data_pn_s);
    end
  end

  // standard, runs on 24bit

  assign adc_pn1_valid_s = adc_pn1_valid_t & adc_valid;
  assign adc_pn1_data_pn_s = (adc_pn_oos == 1'b1) ? adc_pn1_data_in : adc_pn1_data_pn;

  always @(posedge adc_clk) begin
    if (adc_valid == 1'b1) begin
      adc_pn1_valid_t <= ~adc_pn1_valid_t;
      adc_pn1_data_d <= adc_data_i;
    end
    adc_pn1_valid_in <= adc_pn1_valid_s;
    if (adc_pn1_valid_s == 1'b1) begin
      adc_pn1_data_in <= {adc_pn1_data_d, adc_data_i};
      adc_pn1_data_pn <= pn1fn(adc_pn1_data_pn_s);
    end
  end

  // pn mux

  always @(posedge adc_clk) begin
    if (adc_pnseq_sel == 4'h9) begin
      adc_pn_valid_in <= adc_pn1_valid_in;
      adc_pn_data_in <= adc_pn1_data_in;
      adc_pn_data_pn <= adc_pn1_data_pn;
    end else begin
      adc_pn_valid_in <= adc_pn0_valid_in;
      adc_pn_data_in <= {adc_pn0_data_in[7:0], adc_pn0_data_in};
      adc_pn_data_pn <= {adc_pn0_data_pn[7:0], adc_pn0_data_pn};
    end
  end

  // pn oos & pn err

  ad_pnmon #(.DATA_WIDTH(24)) i_pnmon (
    .adc_clk (adc_clk),
    .adc_valid_in (adc_pn_valid_in),
    .adc_data_in (adc_pn_data_in),
    .adc_data_pn (adc_pn_data_pn),
    .adc_pn_oos (adc_pn_oos),
    .adc_pn_err (adc_pn_err));

endmodule

// ***************************************************************************
// ***************************************************************************

