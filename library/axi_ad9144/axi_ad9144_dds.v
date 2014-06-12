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

module axi_ad9144_dds (

  // dac interface

  dac_clk,
  dac_rst,
  dac_dds_data_0,
  dac_dds_data_1,
  dac_dds_data_2,
  dac_dds_data_3,

  // processor interface

  dac_dds_enable,
  dac_dds_format,
  dac_dds_sel,
  dac_dds_patt_1,
  dac_dds_init_1,
  dac_dds_incr_1,
  dac_dds_scale_1,
  dac_dds_patt_2,
  dac_dds_init_2,
  dac_dds_incr_2,
  dac_dds_scale_2);

  // parameters

  parameter DP_DISABLE = 0;

  // dac interface

  input           dac_clk;
  input           dac_rst;
  output  [15:0]  dac_dds_data_0;
  output  [15:0]  dac_dds_data_1;
  output  [15:0]  dac_dds_data_2;
  output  [15:0]  dac_dds_data_3;

  // processor interface

  input           dac_dds_enable;
  input           dac_dds_format;
  input   [ 3:0]  dac_dds_sel;
  input   [15:0]  dac_dds_patt_1;
  input   [15:0]  dac_dds_init_1;
  input   [15:0]  dac_dds_incr_1;
  input   [15:0]  dac_dds_scale_1;
  input   [15:0]  dac_dds_patt_2;
  input   [15:0]  dac_dds_init_2;
  input   [15:0]  dac_dds_incr_2;
  input   [15:0]  dac_dds_scale_2;

  // internal registers

  reg     [63:0]  dac_pn7 = 'd0;
  reg     [63:0]  dac_pn15 = 'd0;
  reg     [63:0]  dac_pn23 = 'd0;
  reg     [63:0]  dac_pn31 = 'd0;
  reg     [15:0]  dac_dds_phase_0_0 = 'd0;
  reg     [15:0]  dac_dds_phase_0_1 = 'd0;
  reg     [15:0]  dac_dds_phase_1_0 = 'd0;
  reg     [15:0]  dac_dds_phase_1_1 = 'd0;
  reg     [15:0]  dac_dds_phase_2_0 = 'd0;
  reg     [15:0]  dac_dds_phase_2_1 = 'd0;
  reg     [15:0]  dac_dds_phase_3_0 = 'd0;
  reg     [15:0]  dac_dds_phase_3_1 = 'd0;
  reg     [15:0]  dac_dds_data_0 = 'd0;
  reg     [15:0]  dac_dds_data_1 = 'd0;
  reg     [15:0]  dac_dds_data_2 = 'd0;
  reg     [15:0]  dac_dds_data_3 = 'd0;

  // internal signals

  wire    [15:0]  dac_dds_data_0_s;
  wire    [15:0]  dac_dds_data_1_s;
  wire    [15:0]  dac_dds_data_2_s;
  wire    [15:0]  dac_dds_data_3_s;

  // pn7 function

  function [63:0] pn7;
    input [63:0] din;
    reg   [63:0] dout;
    begin
      dout[63] = din[ 7] ^ din[ 6];
      dout[62] = din[ 6] ^ din[ 5];
      dout[61] = din[ 5] ^ din[ 4];
      dout[60] = din[ 4] ^ din[ 3];
      dout[59] = din[ 3] ^ din[ 2];
      dout[58] = din[ 2] ^ din[ 1];
      dout[57] = din[ 1] ^ din[ 0];
      dout[56] = din[ 0] ^ din[ 7] ^ din[ 6];
      dout[55] = din[ 7] ^ din[ 5];
      dout[54] = din[ 6] ^ din[ 4];
      dout[53] = din[ 5] ^ din[ 3];
      dout[52] = din[ 4] ^ din[ 2];
      dout[51] = din[ 3] ^ din[ 1];
      dout[50] = din[ 2] ^ din[ 0];
      dout[49] = din[ 1] ^ din[ 7] ^ din[ 6];
      dout[48] = din[ 0] ^ din[ 6] ^ din[ 5];
      dout[47] = din[ 7] ^ din[ 5] ^ din[ 6] ^ din[ 4];
      dout[46] = din[ 6] ^ din[ 4] ^ din[ 5] ^ din[ 3];
      dout[45] = din[ 5] ^ din[ 3] ^ din[ 4] ^ din[ 2];
      dout[44] = din[ 4] ^ din[ 2] ^ din[ 3] ^ din[ 1];
      dout[43] = din[ 3] ^ din[ 1] ^ din[ 2] ^ din[ 0];
      dout[42] = din[ 2] ^ din[ 0] ^ din[ 1] ^ din[ 7] ^ din[ 6];
      dout[41] = din[ 1] ^ din[ 7] ^ din[ 0] ^ din[ 5];
      dout[40] = din[ 0] ^ din[ 7] ^ din[ 4];
      dout[39] = din[ 7] ^ din[ 3];
      dout[38] = din[ 6] ^ din[ 2];
      dout[37] = din[ 5] ^ din[ 1];
      dout[36] = din[ 4] ^ din[ 0];
      dout[35] = din[ 3] ^ din[ 7] ^ din[ 6];
      dout[34] = din[ 2] ^ din[ 6] ^ din[ 5];
      dout[33] = din[ 1] ^ din[ 5] ^ din[ 4];
      dout[32] = din[ 0] ^ din[ 4] ^ din[ 3];
      dout[31] = din[ 7] ^ din[ 3] ^ din[ 6] ^ din[ 2];
      dout[30] = din[ 6] ^ din[ 2] ^ din[ 5] ^ din[ 1];
      dout[29] = din[ 5] ^ din[ 1] ^ din[ 4] ^ din[ 0];
      dout[28] = din[ 4] ^ din[ 0] ^ din[ 3] ^ din[ 7] ^ din[ 6];
      dout[27] = din[ 3] ^ din[ 7] ^ din[ 2] ^ din[ 5];
      dout[26] = din[ 2] ^ din[ 6] ^ din[ 1] ^ din[ 4];
      dout[25] = din[ 1] ^ din[ 5] ^ din[ 0] ^ din[ 3];
      dout[24] = din[ 0] ^ din[ 4] ^ din[ 7] ^ din[ 6] ^ din[ 2];
      dout[23] = din[ 7] ^ din[ 3] ^ din[ 5] ^ din[ 1];
      dout[22] = din[ 6] ^ din[ 2] ^ din[ 4] ^ din[ 0];
      dout[21] = din[ 5] ^ din[ 1] ^ din[ 3] ^ din[ 7] ^ din[ 6];
      dout[20] = din[ 4] ^ din[ 0] ^ din[ 6] ^ din[ 2] ^ din[ 5];
      dout[19] = din[ 3] ^ din[ 7] ^ din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 4];
      dout[18] = din[ 2] ^ din[ 6] ^ din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 3];
      dout[17] = din[ 1] ^ din[ 5] ^ din[ 3] ^ din[ 4] ^ din[ 7] ^ din[ 6] ^ din[ 2];
      dout[16] = din[ 0] ^ din[ 4] ^ din[ 6] ^ din[ 2] ^ din[ 3] ^ din[ 5] ^ din[ 1];
      dout[15] = din[ 7] ^ din[ 3] ^ din[ 5] ^ din[ 1] ^ din[ 6] ^ din[ 2] ^ din[ 4] ^ din[ 0];
      dout[14] = din[ 2] ^ din[ 4] ^ din[ 0] ^ din[ 5] ^ din[ 1] ^ din[ 3] ^ din[ 7];
      dout[13] = din[ 1] ^ din[ 3] ^ din[ 7] ^ din[ 4] ^ din[ 0] ^ din[ 2];
      dout[12] = din[ 0] ^ din[ 2] ^ din[ 3] ^ din[ 7] ^ din[ 1];
      dout[11] = din[ 7] ^ din[ 1] ^ din[ 2] ^ din[ 0];
      dout[10] = din[ 0] ^ din[ 1] ^ din[ 7];
      dout[ 9] = din[ 7] ^ din[ 0];
      dout[ 8] = din[ 7];
      dout[ 7] = din[ 6];
      dout[ 6] = din[ 5];
      dout[ 5] = din[ 4];
      dout[ 4] = din[ 3];
      dout[ 3] = din[ 2];
      dout[ 2] = din[ 1];
      dout[ 1] = din[ 0];
      dout[ 0] = din[ 7] ^ din[ 6];
      pn7 = dout;
    end
  endfunction

  // pn15 function

  function [63:0] pn15;
    input [63:0] din;
    reg   [63:0] dout;
    begin
      dout[63] = din[15] ^ din[14];
      dout[62] = din[14] ^ din[13];
      dout[61] = din[13] ^ din[12];
      dout[60] = din[12] ^ din[11];
      dout[59] = din[11] ^ din[10];
      dout[58] = din[10] ^ din[ 9];
      dout[57] = din[ 9] ^ din[ 8];
      dout[56] = din[ 8] ^ din[ 7];
      dout[55] = din[ 7] ^ din[ 6];
      dout[54] = din[ 6] ^ din[ 5];
      dout[53] = din[ 5] ^ din[ 4];
      dout[52] = din[ 4] ^ din[ 3];
      dout[51] = din[ 3] ^ din[ 2];
      dout[50] = din[ 2] ^ din[ 1];
      dout[49] = din[ 1] ^ din[ 0];
      dout[48] = din[ 0] ^ din[15] ^ din[14];
      dout[47] = din[15] ^ din[13];
      dout[46] = din[14] ^ din[12];
      dout[45] = din[13] ^ din[11];
      dout[44] = din[12] ^ din[10];
      dout[43] = din[11] ^ din[ 9];
      dout[42] = din[10] ^ din[ 8];
      dout[41] = din[ 9] ^ din[ 7];
      dout[40] = din[ 8] ^ din[ 6];
      dout[39] = din[ 7] ^ din[ 5];
      dout[38] = din[ 6] ^ din[ 4];
      dout[37] = din[ 5] ^ din[ 3];
      dout[36] = din[ 4] ^ din[ 2];
      dout[35] = din[ 3] ^ din[ 1];
      dout[34] = din[ 2] ^ din[ 0];
      dout[33] = din[ 1] ^ din[15] ^ din[14];
      dout[32] = din[ 0] ^ din[14] ^ din[13];
      dout[31] = din[15] ^ din[13] ^ din[14] ^ din[12];
      dout[30] = din[14] ^ din[12] ^ din[13] ^ din[11];
      dout[29] = din[13] ^ din[11] ^ din[12] ^ din[10];
      dout[28] = din[12] ^ din[10] ^ din[11] ^ din[ 9];
      dout[27] = din[11] ^ din[ 9] ^ din[10] ^ din[ 8];
      dout[26] = din[10] ^ din[ 8] ^ din[ 9] ^ din[ 7];
      dout[25] = din[ 9] ^ din[ 7] ^ din[ 8] ^ din[ 6];
      dout[24] = din[ 8] ^ din[ 6] ^ din[ 7] ^ din[ 5];
      dout[23] = din[ 7] ^ din[ 5] ^ din[ 6] ^ din[ 4];
      dout[22] = din[ 6] ^ din[ 4] ^ din[ 5] ^ din[ 3];
      dout[21] = din[ 5] ^ din[ 3] ^ din[ 4] ^ din[ 2];
      dout[20] = din[ 4] ^ din[ 2] ^ din[ 3] ^ din[ 1];
      dout[19] = din[ 3] ^ din[ 1] ^ din[ 2] ^ din[ 0];
      dout[18] = din[ 2] ^ din[ 0] ^ din[ 1] ^ din[15] ^ din[14];
      dout[17] = din[ 1] ^ din[15] ^ din[ 0] ^ din[13];
      dout[16] = din[ 0] ^ din[15] ^ din[12];
      dout[15] = din[15] ^ din[11];
      dout[14] = din[14] ^ din[10];
      dout[13] = din[13] ^ din[ 9];
      dout[12] = din[12] ^ din[ 8];
      dout[11] = din[11] ^ din[ 7];
      dout[10] = din[10] ^ din[ 6];
      dout[ 9] = din[ 9] ^ din[ 5];
      dout[ 8] = din[ 8] ^ din[ 4];
      dout[ 7] = din[ 7] ^ din[ 3];
      dout[ 6] = din[ 6] ^ din[ 2];
      dout[ 5] = din[ 5] ^ din[ 1];
      dout[ 4] = din[ 4] ^ din[ 0];
      dout[ 3] = din[ 3] ^ din[15] ^ din[14];
      dout[ 2] = din[ 2] ^ din[14] ^ din[13];
      dout[ 1] = din[ 1] ^ din[13] ^ din[12];
      dout[ 0] = din[ 0] ^ din[12] ^ din[11];
      pn15 = dout;
    end
  endfunction

  // pn23 function

  function [63:0] pn23;
    input [63:0] din;
    reg   [63:0] dout;
    begin
      dout[63] = din[23] ^ din[18];
      dout[62] = din[22] ^ din[17];
      dout[61] = din[21] ^ din[16];
      dout[60] = din[20] ^ din[15];
      dout[59] = din[19] ^ din[14];
      dout[58] = din[18] ^ din[13];
      dout[57] = din[17] ^ din[12];
      dout[56] = din[16] ^ din[11];
      dout[55] = din[15] ^ din[10];
      dout[54] = din[14] ^ din[ 9];
      dout[53] = din[13] ^ din[ 8];
      dout[52] = din[12] ^ din[ 7];
      dout[51] = din[11] ^ din[ 6];
      dout[50] = din[10] ^ din[ 5];
      dout[49] = din[ 9] ^ din[ 4];
      dout[48] = din[ 8] ^ din[ 3];
      dout[47] = din[ 7] ^ din[ 2];
      dout[46] = din[ 6] ^ din[ 1];
      dout[45] = din[ 5] ^ din[ 0];
      dout[44] = din[ 4] ^ din[23] ^ din[18];
      dout[43] = din[ 3] ^ din[22] ^ din[17];
      dout[42] = din[ 2] ^ din[21] ^ din[16];
      dout[41] = din[ 1] ^ din[20] ^ din[15];
      dout[40] = din[ 0] ^ din[19] ^ din[14];
      dout[39] = din[23] ^ din[13];
      dout[38] = din[22] ^ din[12];
      dout[37] = din[21] ^ din[11];
      dout[36] = din[20] ^ din[10];
      dout[35] = din[19] ^ din[ 9];
      dout[34] = din[18] ^ din[ 8];
      dout[33] = din[17] ^ din[ 7];
      dout[32] = din[16] ^ din[ 6];
      dout[31] = din[15] ^ din[ 5];
      dout[30] = din[14] ^ din[ 4];
      dout[29] = din[13] ^ din[ 3];
      dout[28] = din[12] ^ din[ 2];
      dout[27] = din[11] ^ din[ 1];
      dout[26] = din[10] ^ din[ 0];
      dout[25] = din[ 9] ^ din[23] ^ din[18];
      dout[24] = din[ 8] ^ din[22] ^ din[17];
      dout[23] = din[ 7] ^ din[21] ^ din[16];
      dout[22] = din[ 6] ^ din[20] ^ din[15];
      dout[21] = din[ 5] ^ din[19] ^ din[14];
      dout[20] = din[ 4] ^ din[18] ^ din[13];
      dout[19] = din[ 3] ^ din[17] ^ din[12];
      dout[18] = din[ 2] ^ din[16] ^ din[11];
      dout[17] = din[ 1] ^ din[15] ^ din[10];
      dout[16] = din[ 0] ^ din[14] ^ din[ 9];
      dout[15] = din[23] ^ din[13] ^ din[18] ^ din[ 8];
      dout[14] = din[22] ^ din[12] ^ din[17] ^ din[ 7];
      dout[13] = din[21] ^ din[11] ^ din[16] ^ din[ 6];
      dout[12] = din[20] ^ din[10] ^ din[15] ^ din[ 5];
      dout[11] = din[19] ^ din[ 9] ^ din[14] ^ din[ 4];
      dout[10] = din[18] ^ din[ 8] ^ din[13] ^ din[ 3];
      dout[ 9] = din[17] ^ din[ 7] ^ din[12] ^ din[ 2];
      dout[ 8] = din[16] ^ din[ 6] ^ din[11] ^ din[ 1];
      dout[ 7] = din[15] ^ din[ 5] ^ din[10] ^ din[ 0];
      dout[ 6] = din[14] ^ din[ 4] ^ din[ 9] ^ din[23] ^ din[18];
      dout[ 5] = din[13] ^ din[ 3] ^ din[ 8] ^ din[22] ^ din[17];
      dout[ 4] = din[12] ^ din[ 2] ^ din[ 7] ^ din[21] ^ din[16];
      dout[ 3] = din[11] ^ din[ 1] ^ din[ 6] ^ din[20] ^ din[15];
      dout[ 2] = din[10] ^ din[ 0] ^ din[ 5] ^ din[19] ^ din[14];
      dout[ 1] = din[ 9] ^ din[23] ^ din[ 4] ^ din[13];
      dout[ 0] = din[ 8] ^ din[22] ^ din[ 3] ^ din[12];
      pn23 = dout;
    end
  endfunction

  // pn31 function

  function [63:0] pn31;
    input [63:0] din;
    reg   [63:0] dout;
    begin
      dout[63] = din[31] ^ din[28];
      dout[62] = din[30] ^ din[27];
      dout[61] = din[29] ^ din[26];
      dout[60] = din[28] ^ din[25];
      dout[59] = din[27] ^ din[24];
      dout[58] = din[26] ^ din[23];
      dout[57] = din[25] ^ din[22];
      dout[56] = din[24] ^ din[21];
      dout[55] = din[23] ^ din[20];
      dout[54] = din[22] ^ din[19];
      dout[53] = din[21] ^ din[18];
      dout[52] = din[20] ^ din[17];
      dout[51] = din[19] ^ din[16];
      dout[50] = din[18] ^ din[15];
      dout[49] = din[17] ^ din[14];
      dout[48] = din[16] ^ din[13];
      dout[47] = din[15] ^ din[12];
      dout[46] = din[14] ^ din[11];
      dout[45] = din[13] ^ din[10];
      dout[44] = din[12] ^ din[ 9];
      dout[43] = din[11] ^ din[ 8];
      dout[42] = din[10] ^ din[ 7];
      dout[41] = din[ 9] ^ din[ 6];
      dout[40] = din[ 8] ^ din[ 5];
      dout[39] = din[ 7] ^ din[ 4];
      dout[38] = din[ 6] ^ din[ 3];
      dout[37] = din[ 5] ^ din[ 2];
      dout[36] = din[ 4] ^ din[ 1];
      dout[35] = din[ 3] ^ din[ 0];
      dout[34] = din[ 2] ^ din[31] ^ din[28];
      dout[33] = din[ 1] ^ din[30] ^ din[27];
      dout[32] = din[ 0] ^ din[29] ^ din[26];
      dout[31] = din[31] ^ din[25];
      dout[30] = din[30] ^ din[24];
      dout[29] = din[29] ^ din[23];
      dout[28] = din[28] ^ din[22];
      dout[27] = din[27] ^ din[21];
      dout[26] = din[26] ^ din[20];
      dout[25] = din[25] ^ din[19];
      dout[24] = din[24] ^ din[18];
      dout[23] = din[23] ^ din[17];
      dout[22] = din[22] ^ din[16];
      dout[21] = din[21] ^ din[15];
      dout[20] = din[20] ^ din[14];
      dout[19] = din[19] ^ din[13];
      dout[18] = din[18] ^ din[12];
      dout[17] = din[17] ^ din[11];
      dout[16] = din[16] ^ din[10];
      dout[15] = din[15] ^ din[ 9];
      dout[14] = din[14] ^ din[ 8];
      dout[13] = din[13] ^ din[ 7];
      dout[12] = din[12] ^ din[ 6];
      dout[11] = din[11] ^ din[ 5];
      dout[10] = din[10] ^ din[ 4];
      dout[ 9] = din[ 9] ^ din[ 3];
      dout[ 8] = din[ 8] ^ din[ 2];
      dout[ 7] = din[ 7] ^ din[ 1];
      dout[ 6] = din[ 6] ^ din[ 0];
      dout[ 5] = din[ 5] ^ din[31] ^ din[28];
      dout[ 4] = din[ 4] ^ din[30] ^ din[27];
      dout[ 3] = din[ 3] ^ din[29] ^ din[26];
      dout[ 2] = din[ 2] ^ din[28] ^ din[25];
      dout[ 1] = din[ 1] ^ din[27] ^ din[24];
      dout[ 0] = din[ 0] ^ din[26] ^ din[23];
      pn31 = dout;
    end
  endfunction

  // dds output scaling (shift only)

  function [15:0] dac_datascale;
    input [15:0]  data;
    input [ 3:0]  scale;
    reg   [15:0]  data_out;
    begin
      case (scale)
        4'b1111: data_out = {{15{data[15]}}, data[15:15]};
        4'b1110: data_out = {{14{data[15]}}, data[15:14]};
        4'b1101: data_out = {{13{data[15]}}, data[15:13]};
        4'b1100: data_out = {{12{data[15]}}, data[15:12]};
        4'b1011: data_out = {{11{data[15]}}, data[15:11]};
        4'b1010: data_out = {{10{data[15]}}, data[15:10]};
        4'b1001: data_out = {{ 9{data[15]}}, data[15: 9]};
        4'b1000: data_out = {{ 8{data[15]}}, data[15: 8]};
        4'b0111: data_out = {{ 7{data[15]}}, data[15: 7]};
        4'b0110: data_out = {{ 6{data[15]}}, data[15: 6]};
        4'b0101: data_out = {{ 5{data[15]}}, data[15: 5]};
        4'b0100: data_out = {{ 4{data[15]}}, data[15: 4]};
        4'b0011: data_out = {{ 3{data[15]}}, data[15: 3]};
        4'b0010: data_out = {{ 2{data[15]}}, data[15: 2]};
        4'b0001: data_out = {{ 1{data[15]}}, data[15: 1]};
        default: data_out = data;
      endcase
      dac_datascale = data_out;
    end
  endfunction

  // pn registers

  always @(posedge dac_clk) begin
    if (dac_dds_enable == 1'b0) begin
      dac_pn7 <= {64{1'd1}};
      dac_pn15 <= {64{1'd1}};
      dac_pn23 <= {64{1'd1}};
      dac_pn31 <= {64{1'd1}};
    end else begin
      dac_pn7 <= pn7(dac_pn7);
      dac_pn15 <= pn15(dac_pn15);
      dac_pn23 <= pn23(dac_pn23);
      dac_pn31 <= pn31(dac_pn31);
    end
  end

  // dds phase counters

  always @(posedge dac_clk) begin
    if (dac_dds_enable == 1'b0) begin
      dac_dds_phase_0_0 <= dac_dds_init_1;
      dac_dds_phase_0_1 <= dac_dds_init_2;
      dac_dds_phase_1_0 <= dac_dds_phase_0_0 + dac_dds_incr_1;
      dac_dds_phase_1_1 <= dac_dds_phase_0_1 + dac_dds_incr_2;
      dac_dds_phase_2_0 <= dac_dds_phase_1_0 + dac_dds_incr_1;
      dac_dds_phase_2_1 <= dac_dds_phase_1_1 + dac_dds_incr_2;
      dac_dds_phase_3_0 <= dac_dds_phase_2_0 + dac_dds_incr_1;
      dac_dds_phase_3_1 <= dac_dds_phase_2_1 + dac_dds_incr_2;
    end else begin
      dac_dds_phase_0_0 <= dac_dds_phase_0_0 + {dac_dds_incr_1[13:0], 2'd0};
      dac_dds_phase_0_1 <= dac_dds_phase_0_1 + {dac_dds_incr_2[13:0], 2'd0};
      dac_dds_phase_1_0 <= dac_dds_phase_1_0 + {dac_dds_incr_1[13:0], 2'd0};
      dac_dds_phase_1_1 <= dac_dds_phase_1_1 + {dac_dds_incr_2[13:0], 2'd0};
      dac_dds_phase_2_0 <= dac_dds_phase_2_0 + {dac_dds_incr_1[13:0], 2'd0};
      dac_dds_phase_2_1 <= dac_dds_phase_2_1 + {dac_dds_incr_2[13:0], 2'd0};
      dac_dds_phase_3_0 <= dac_dds_phase_3_0 + {dac_dds_incr_1[13:0], 2'd0};
      dac_dds_phase_3_1 <= dac_dds_phase_3_1 + {dac_dds_incr_2[13:0], 2'd0};
    end
  end

  // output is either 2's complement or offset binary.

  always @(posedge dac_clk) begin
    case (dac_dds_sel)
      4'b0111: begin
        dac_dds_data_0 <= dac_pn31[15: 0];
        dac_dds_data_1 <= dac_pn31[31:16];
        dac_dds_data_2 <= dac_pn31[47:32];
        dac_dds_data_3 <= dac_pn31[63:48];
      end
      4'b0110: begin
        dac_dds_data_0 <= dac_pn23[15: 0];
        dac_dds_data_1 <= dac_pn23[31:16];
        dac_dds_data_2 <= dac_pn23[47:32];
        dac_dds_data_3 <= dac_pn23[63:48];
      end
      4'b0101: begin
        dac_dds_data_0 <= dac_pn15[15: 0];
        dac_dds_data_1 <= dac_pn15[31:16];
        dac_dds_data_2 <= dac_pn15[47:32];
        dac_dds_data_3 <= dac_pn15[63:48];
      end
      4'b0100: begin
        dac_dds_data_0 <= dac_pn7[15: 0];
        dac_dds_data_1 <= dac_pn7[31:16];
        dac_dds_data_2 <= dac_pn7[47:32];
        dac_dds_data_3 <= dac_pn7[63:48];
      end
      4'b0001: begin
        dac_dds_data_0 <= dac_dds_patt_1;
        dac_dds_data_1 <= dac_dds_patt_2;
        dac_dds_data_2 <= dac_dds_patt_1;
        dac_dds_data_3 <= dac_dds_patt_2;
      end
      default: begin
        dac_dds_data_0 <= dac_dds_data_0_s;
        dac_dds_data_1 <= dac_dds_data_1_s;
        dac_dds_data_2 <= dac_dds_data_2_s;
        dac_dds_data_3 <= dac_dds_data_3_s;
      end
    endcase
  end

  // dds

  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_0_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_enable (dac_dds_enable),
    .dds_phase_0 (dac_dds_phase_0_0),
    .dds_scale_0 (dac_dds_scale_1),
    .dds_phase_1 (dac_dds_phase_0_1),
    .dds_scale_1 (dac_dds_scale_2),
    .dds_data (dac_dds_data_0_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_1_s = 16'd0;
  end else begin
  ad_dds i_dds_1 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_enable (dac_dds_enable),
    .dds_phase_0 (dac_dds_phase_1_0),
    .dds_scale_0 (dac_dds_scale_1),
    .dds_phase_1 (dac_dds_phase_1_1),
    .dds_scale_1 (dac_dds_scale_2),
    .dds_data (dac_dds_data_1_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_2_s = 16'd0;
  end else begin
  ad_dds i_dds_2 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_enable (dac_dds_enable),
    .dds_phase_0 (dac_dds_phase_2_0),
    .dds_scale_0 (dac_dds_scale_1),
    .dds_phase_1 (dac_dds_phase_2_1),
    .dds_scale_1 (dac_dds_scale_2),
    .dds_data (dac_dds_data_2_s));
  end
  endgenerate
  
  generate
  if (DP_DISABLE == 1) begin
  assign dac_dds_data_3_s = 16'd0;
  end else begin
  ad_dds i_dds_3 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_enable (dac_dds_enable),
    .dds_phase_0 (dac_dds_phase_3_0),
    .dds_scale_0 (dac_dds_scale_1),
    .dds_phase_1 (dac_dds_phase_3_1),
    .dds_scale_1 (dac_dds_scale_2),
    .dds_data (dac_dds_data_3_s));
  end
  endgenerate
  
endmodule

// ***************************************************************************
// ***************************************************************************
