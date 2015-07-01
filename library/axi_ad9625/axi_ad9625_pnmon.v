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

module axi_ad9625_pnmon (

  // adc interface

  adc_clk,
  adc_data,

  // pn out of sync and error

  adc_pn_oos,
  adc_pn_err,

  // processor interface PN9 (0x0), PN23 (0x1)

  adc_pnseq_sel);

  // adc interface

  input           adc_clk;
  input   [191:0] adc_data;

  // pn out of sync and error

  output          adc_pn_oos;
  output          adc_pn_err;

  // processor interface PN9 (0x0), PN23 (0x1)

  input   [ 3:0]  adc_pnseq_sel;

  // internal registers

  reg     [191:0] adc_pn_data_in = 'd0;
  reg     [191:0] adc_pn_data_pn = 'd0;

  // internal signals

  wire   [191:0]  adc_pn_data_pn_s;

  // PN23 function

  function [191:0] pn23;
    input [191:0] din;
    reg   [191:0] dout;
    begin
      dout[191] = din[22] ^ din[17];
      dout[190] = din[21] ^ din[16];
      dout[189] = din[20] ^ din[15];
      dout[188] = din[19] ^ din[14];
      dout[187] = din[18] ^ din[13];
      dout[186] = din[17] ^ din[12];
      dout[185] = din[16] ^ din[11];
      dout[184] = din[15] ^ din[10];
      dout[183] = din[14] ^ din[ 9];
      dout[182] = din[13] ^ din[ 8];
      dout[181] = din[12] ^ din[ 7];
      dout[180] = din[11] ^ din[ 6];
      dout[179] = din[10] ^ din[ 5];
      dout[178] = din[ 9] ^ din[ 4];
      dout[177] = din[ 8] ^ din[ 3];
      dout[176] = din[ 7] ^ din[ 2];
      dout[175] = din[ 6] ^ din[ 1];
      dout[174] = din[ 5] ^ din[ 0];
      dout[173] = din[ 4] ^ din[22] ^ din[17];
      dout[172] = din[ 3] ^ din[21] ^ din[16];
      dout[171] = din[ 2] ^ din[20] ^ din[15];
      dout[170] = din[ 1] ^ din[19] ^ din[14];
      dout[169] = din[ 0] ^ din[18] ^ din[13];
      dout[168] = din[22] ^ din[12];
      dout[167] = din[21] ^ din[11];
      dout[166] = din[20] ^ din[10];
      dout[165] = din[19] ^ din[ 9];
      dout[164] = din[18] ^ din[ 8];
      dout[163] = din[17] ^ din[ 7];
      dout[162] = din[16] ^ din[ 6];
      dout[161] = din[15] ^ din[ 5];
      dout[160] = din[14] ^ din[ 4];
      dout[159] = din[13] ^ din[ 3];
      dout[158] = din[12] ^ din[ 2];
      dout[157] = din[11] ^ din[ 1];
      dout[156] = din[10] ^ din[ 0];
      dout[155] = din[ 9] ^ din[22] ^ din[17];
      dout[154] = din[ 8] ^ din[21] ^ din[16];
      dout[153] = din[ 7] ^ din[20] ^ din[15];
      dout[152] = din[ 6] ^ din[19] ^ din[14];
      dout[151] = din[ 5] ^ din[18] ^ din[13];
      dout[150] = din[ 4] ^ din[17] ^ din[12];
      dout[149] = din[ 3] ^ din[16] ^ din[11];
      dout[148] = din[ 2] ^ din[15] ^ din[10];
      dout[147] = din[ 1] ^ din[14] ^ din[ 9];
      dout[146] = din[ 0] ^ din[13] ^ din[ 8];
      dout[145] = din[22] ^ din[12] ^ din[17] ^ din[ 7];
      dout[144] = din[21] ^ din[11] ^ din[16] ^ din[ 6];
      dout[143] = din[20] ^ din[10] ^ din[15] ^ din[ 5];
      dout[142] = din[19] ^ din[ 9] ^ din[14] ^ din[ 4];
      dout[141] = din[18] ^ din[ 8] ^ din[13] ^ din[ 3];
      dout[140] = din[17] ^ din[ 7] ^ din[12] ^ din[ 2];
      dout[139] = din[16] ^ din[ 6] ^ din[11] ^ din[ 1];
      dout[138] = din[15] ^ din[ 5] ^ din[10] ^ din[ 0];
      dout[137] = din[14] ^ din[ 4] ^ din[ 9] ^ din[22] ^ din[17];
      dout[136] = din[13] ^ din[ 3] ^ din[ 8] ^ din[21] ^ din[16];
      dout[135] = din[12] ^ din[ 2] ^ din[ 7] ^ din[20] ^ din[15];
      dout[134] = din[11] ^ din[ 1] ^ din[ 6] ^ din[19] ^ din[14];
      dout[133] = din[10] ^ din[ 0] ^ din[ 5] ^ din[18] ^ din[13];
      dout[132] = din[ 9] ^ din[22] ^ din[ 4] ^ din[12];
      dout[131] = din[ 8] ^ din[21] ^ din[ 3] ^ din[11];
      dout[130] = din[ 7] ^ din[20] ^ din[ 2] ^ din[10];
      dout[129] = din[ 6] ^ din[19] ^ din[ 1] ^ din[ 9];
      dout[128] = din[ 5] ^ din[18] ^ din[ 0] ^ din[ 8];
      dout[127] = din[ 4] ^ din[22] ^ din[ 7];
      dout[126] = din[ 3] ^ din[21] ^ din[ 6];
      dout[125] = din[ 2] ^ din[20] ^ din[ 5];
      dout[124] = din[ 1] ^ din[19] ^ din[ 4];
      dout[123] = din[ 0] ^ din[18] ^ din[ 3];
      dout[122] = din[22] ^ din[ 2];
      dout[121] = din[21] ^ din[ 1];
      dout[120] = din[20] ^ din[ 0];
      dout[119] = din[19] ^ din[22] ^ din[17];
      dout[118] = din[18] ^ din[21] ^ din[16];
      dout[117] = din[17] ^ din[20] ^ din[15];
      dout[116] = din[16] ^ din[19] ^ din[14];
      dout[115] = din[15] ^ din[18] ^ din[13];
      dout[114] = din[14] ^ din[17] ^ din[12];
      dout[113] = din[13] ^ din[16] ^ din[11];
      dout[112] = din[12] ^ din[15] ^ din[10];
      dout[111] = din[11] ^ din[14] ^ din[ 9];
      dout[110] = din[10] ^ din[13] ^ din[ 8];
      dout[109] = din[ 9] ^ din[12] ^ din[ 7];
      dout[108] = din[ 8] ^ din[11] ^ din[ 6];
      dout[107] = din[ 7] ^ din[10] ^ din[ 5];
      dout[106] = din[ 6] ^ din[ 9] ^ din[ 4];
      dout[105] = din[ 5] ^ din[ 8] ^ din[ 3];
      dout[104] = din[ 4] ^ din[ 7] ^ din[ 2];
      dout[103] = din[ 3] ^ din[ 6] ^ din[ 1];
      dout[102] = din[ 2] ^ din[ 5] ^ din[ 0];
      dout[101] = din[ 1] ^ din[ 4] ^ din[22] ^ din[17];
      dout[100] = din[ 0] ^ din[ 3] ^ din[21] ^ din[16];
      dout[ 99] = din[22] ^ din[ 2] ^ din[17] ^ din[20] ^ din[15];
      dout[ 98] = din[21] ^ din[ 1] ^ din[16] ^ din[19] ^ din[14];
      dout[ 97] = din[20] ^ din[ 0] ^ din[15] ^ din[18] ^ din[13];
      dout[ 96] = din[19] ^ din[22] ^ din[14] ^ din[12];
      dout[ 95] = din[18] ^ din[21] ^ din[13] ^ din[11];
      dout[ 94] = din[17] ^ din[20] ^ din[12] ^ din[10];
      dout[ 93] = din[16] ^ din[19] ^ din[11] ^ din[ 9];
      dout[ 92] = din[15] ^ din[18] ^ din[10] ^ din[ 8];
      dout[ 91] = din[14] ^ din[17] ^ din[ 9] ^ din[ 7];
      dout[ 90] = din[13] ^ din[16] ^ din[ 8] ^ din[ 6];
      dout[ 89] = din[12] ^ din[15] ^ din[ 7] ^ din[ 5];
      dout[ 88] = din[11] ^ din[14] ^ din[ 6] ^ din[ 4];
      dout[ 87] = din[10] ^ din[13] ^ din[ 5] ^ din[ 3];
      dout[ 86] = din[ 9] ^ din[12] ^ din[ 4] ^ din[ 2];
      dout[ 85] = din[ 8] ^ din[11] ^ din[ 3] ^ din[ 1];
      dout[ 84] = din[ 7] ^ din[10] ^ din[ 2] ^ din[ 0];
      dout[ 83] = din[ 6] ^ din[ 9] ^ din[ 1] ^ din[22] ^ din[17];
      dout[ 82] = din[ 5] ^ din[ 8] ^ din[ 0] ^ din[21] ^ din[16];
      dout[ 81] = din[ 4] ^ din[ 7] ^ din[22] ^ din[17] ^ din[20] ^ din[15];
      dout[ 80] = din[ 3] ^ din[ 6] ^ din[21] ^ din[16] ^ din[19] ^ din[14];
      dout[ 79] = din[ 2] ^ din[ 5] ^ din[20] ^ din[15] ^ din[18] ^ din[13];
      dout[ 78] = din[ 1] ^ din[ 4] ^ din[17] ^ din[19] ^ din[14] ^ din[12];
      dout[ 77] = din[ 0] ^ din[ 3] ^ din[16] ^ din[18] ^ din[13] ^ din[11];
      dout[ 76] = din[22] ^ din[ 2] ^ din[15] ^ din[12] ^ din[10];
      dout[ 75] = din[21] ^ din[ 1] ^ din[14] ^ din[11] ^ din[ 9];
      dout[ 74] = din[20] ^ din[ 0] ^ din[13] ^ din[10] ^ din[ 8];
      dout[ 73] = din[19] ^ din[22] ^ din[12] ^ din[17] ^ din[ 9] ^ din[ 7];
      dout[ 72] = din[18] ^ din[21] ^ din[11] ^ din[16] ^ din[ 8] ^ din[ 6];
      dout[ 71] = din[17] ^ din[20] ^ din[10] ^ din[15] ^ din[ 7] ^ din[ 5];
      dout[ 70] = din[16] ^ din[19] ^ din[ 9] ^ din[14] ^ din[ 6] ^ din[ 4];
      dout[ 69] = din[15] ^ din[18] ^ din[ 8] ^ din[13] ^ din[ 5] ^ din[ 3];
      dout[ 68] = din[14] ^ din[17] ^ din[ 7] ^ din[12] ^ din[ 4] ^ din[ 2];
      dout[ 67] = din[13] ^ din[16] ^ din[ 6] ^ din[11] ^ din[ 3] ^ din[ 1];
      dout[ 66] = din[12] ^ din[15] ^ din[ 5] ^ din[10] ^ din[ 2] ^ din[ 0];
      dout[ 65] = din[11] ^ din[14] ^ din[ 4] ^ din[ 9] ^ din[ 1] ^ din[22] ^ din[17];
      dout[ 64] = din[10] ^ din[13] ^ din[ 3] ^ din[ 8] ^ din[ 0] ^ din[21] ^ din[16];
      dout[ 63] = din[ 9] ^ din[12] ^ din[ 2] ^ din[ 7] ^ din[22] ^ din[17] ^ din[20] ^ din[15];
      dout[ 62] = din[ 8] ^ din[11] ^ din[ 1] ^ din[ 6] ^ din[21] ^ din[16] ^ din[19] ^ din[14];
      dout[ 61] = din[ 7] ^ din[10] ^ din[ 0] ^ din[ 5] ^ din[20] ^ din[15] ^ din[18] ^ din[13];
      dout[ 60] = din[ 6] ^ din[ 9] ^ din[22] ^ din[ 4] ^ din[19] ^ din[14] ^ din[12];
      dout[ 59] = din[ 5] ^ din[ 8] ^ din[21] ^ din[ 3] ^ din[18] ^ din[13] ^ din[11];
      dout[ 58] = din[ 4] ^ din[ 7] ^ din[17] ^ din[20] ^ din[ 2] ^ din[12] ^ din[10];
      dout[ 57] = din[ 3] ^ din[ 6] ^ din[16] ^ din[19] ^ din[ 1] ^ din[11] ^ din[ 9];
      dout[ 56] = din[ 2] ^ din[ 5] ^ din[15] ^ din[18] ^ din[ 0] ^ din[10] ^ din[ 8];
      dout[ 55] = din[ 1] ^ din[ 4] ^ din[14] ^ din[22] ^ din[ 9] ^ din[ 7];
      dout[ 54] = din[ 0] ^ din[ 3] ^ din[13] ^ din[21] ^ din[ 8] ^ din[ 6];
      dout[ 53] = din[22] ^ din[ 2] ^ din[12] ^ din[17] ^ din[20] ^ din[ 7] ^ din[ 5];
      dout[ 52] = din[21] ^ din[ 1] ^ din[11] ^ din[16] ^ din[19] ^ din[ 6] ^ din[ 4];
      dout[ 51] = din[20] ^ din[ 0] ^ din[10] ^ din[15] ^ din[18] ^ din[ 5] ^ din[ 3];
      dout[ 50] = din[19] ^ din[22] ^ din[ 9] ^ din[14] ^ din[ 4] ^ din[ 2];
      dout[ 49] = din[18] ^ din[21] ^ din[ 8] ^ din[13] ^ din[ 3] ^ din[ 1];
      dout[ 48] = din[17] ^ din[20] ^ din[ 7] ^ din[12] ^ din[ 2] ^ din[ 0];
      dout[ 47] = din[16] ^ din[19] ^ din[ 6] ^ din[11] ^ din[ 1] ^ din[22] ^ din[17];
      dout[ 46] = din[15] ^ din[18] ^ din[ 5] ^ din[10] ^ din[ 0] ^ din[21] ^ din[16];
      dout[ 45] = din[14] ^ din[ 4] ^ din[ 9] ^ din[22] ^ din[20] ^ din[15];
      dout[ 44] = din[13] ^ din[ 3] ^ din[ 8] ^ din[21] ^ din[19] ^ din[14];
      dout[ 43] = din[12] ^ din[ 2] ^ din[ 7] ^ din[20] ^ din[18] ^ din[13];
      dout[ 42] = din[11] ^ din[ 1] ^ din[17] ^ din[ 6] ^ din[19] ^ din[12];
      dout[ 41] = din[10] ^ din[ 0] ^ din[16] ^ din[ 5] ^ din[18] ^ din[11];
      dout[ 40] = din[ 9] ^ din[22] ^ din[15] ^ din[ 4] ^ din[10];
      dout[ 39] = din[ 8] ^ din[21] ^ din[14] ^ din[ 3] ^ din[ 9];
      dout[ 38] = din[ 7] ^ din[20] ^ din[13] ^ din[ 2] ^ din[ 8];
      dout[ 37] = din[ 6] ^ din[19] ^ din[12] ^ din[ 1] ^ din[ 7];
      dout[ 36] = din[ 5] ^ din[18] ^ din[11] ^ din[ 0] ^ din[ 6];
      dout[ 35] = din[ 4] ^ din[10] ^ din[22] ^ din[ 5];
      dout[ 34] = din[ 3] ^ din[ 9] ^ din[21] ^ din[ 4];
      dout[ 33] = din[ 2] ^ din[ 8] ^ din[20] ^ din[ 3];
      dout[ 32] = din[ 1] ^ din[ 7] ^ din[19] ^ din[ 2];
      dout[ 31] = din[ 0] ^ din[ 6] ^ din[18] ^ din[ 1];
      dout[ 30] = din[22] ^ din[ 5] ^ din[ 0];
      dout[ 29] = din[21] ^ din[ 4] ^ din[22] ^ din[17];
      dout[ 28] = din[20] ^ din[ 3] ^ din[21] ^ din[16];
      dout[ 27] = din[19] ^ din[ 2] ^ din[20] ^ din[15];
      dout[ 26] = din[18] ^ din[ 1] ^ din[19] ^ din[14];
      dout[ 25] = din[17] ^ din[ 0] ^ din[18] ^ din[13];
      dout[ 24] = din[16] ^ din[22] ^ din[12];
      dout[ 23] = din[15] ^ din[21] ^ din[11];
      dout[ 22] = din[14] ^ din[20] ^ din[10];
      dout[ 21] = din[13] ^ din[19] ^ din[ 9];
      dout[ 20] = din[12] ^ din[18] ^ din[ 8];
      dout[ 19] = din[11] ^ din[17] ^ din[ 7];
      dout[ 18] = din[10] ^ din[16] ^ din[ 6];
      dout[ 17] = din[ 9] ^ din[15] ^ din[ 5];
      dout[ 16] = din[ 8] ^ din[14] ^ din[ 4];
      dout[ 15] = din[ 7] ^ din[13] ^ din[ 3];
      dout[ 14] = din[ 6] ^ din[12] ^ din[ 2];
      dout[ 13] = din[ 5] ^ din[11] ^ din[ 1];
      dout[ 12] = din[ 4] ^ din[10] ^ din[ 0];
      dout[ 11] = din[ 3] ^ din[ 9] ^ din[22] ^ din[17];
      dout[ 10] = din[ 2] ^ din[ 8] ^ din[21] ^ din[16];
      dout[  9] = din[ 1] ^ din[ 7] ^ din[20] ^ din[15];
      dout[  8] = din[ 0] ^ din[ 6] ^ din[19] ^ din[14];
      dout[  7] = din[22] ^ din[ 5] ^ din[17] ^ din[18] ^ din[13];
      dout[  6] = din[21] ^ din[ 4] ^ din[17] ^ din[16] ^ din[12];
      dout[  5] = din[20] ^ din[ 3] ^ din[16] ^ din[15] ^ din[11];
      dout[  4] = din[19] ^ din[ 2] ^ din[15] ^ din[14] ^ din[10];
      dout[  3] = din[18] ^ din[ 1] ^ din[14] ^ din[13] ^ din[ 9];
      dout[  2] = din[17] ^ din[ 0] ^ din[13] ^ din[12] ^ din[ 8];
      dout[  1] = din[16] ^ din[22] ^ din[12] ^ din[11] ^ din[17] ^ din[ 7];
      dout[  0] = din[15] ^ din[21] ^ din[11] ^ din[10] ^ din[16] ^ din[ 6];
      pn23 = dout;
    end
  endfunction

  // PN9 function

  function [191:0] pn9;
    input [191:0] din;
    reg   [191:0] dout;
    begin
      dout[191] = din[ 8] ^ din[ 4];
      dout[190] = din[ 7] ^ din[ 3];
      dout[189] = din[ 6] ^ din[ 2];
      dout[188] = din[ 5] ^ din[ 1];
      dout[187] = din[ 4] ^ din[ 0];
      dout[186] = din[ 3] ^ din[ 8] ^ din[ 4];
      dout[185] = din[ 2] ^ din[ 7] ^ din[ 3];
      dout[184] = din[ 1] ^ din[ 6] ^ din[ 2];
      dout[183] = din[ 0] ^ din[ 5] ^ din[ 1];
      dout[182] = din[ 8] ^ din[ 0];
      dout[181] = din[ 7] ^ din[ 8] ^ din[ 4];
      dout[180] = din[ 6] ^ din[ 7] ^ din[ 3];
      dout[179] = din[ 5] ^ din[ 6] ^ din[ 2];
      dout[178] = din[ 4] ^ din[ 5] ^ din[ 1];
      dout[177] = din[ 3] ^ din[ 4] ^ din[ 0];
      dout[176] = din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[175] = din[ 1] ^ din[ 2] ^ din[ 7] ^ din[ 3];
      dout[174] = din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[173] = din[ 8] ^ din[ 0] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[172] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 0];
      dout[171] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 8] ^ din[ 4];
      dout[170] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[169] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[168] = din[ 3] ^ din[ 8] ^ din[ 5] ^ din[ 1];
      dout[167] = din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 0];
      dout[166] = din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 4];
      dout[165] = din[ 0] ^ din[ 2] ^ din[ 5] ^ din[ 7] ^ din[ 3];
      dout[164] = din[ 8] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[163] = din[ 7] ^ din[ 0] ^ din[ 5] ^ din[ 1];
      dout[162] = din[ 6] ^ din[ 8] ^ din[ 0];
      dout[161] = din[ 5] ^ din[ 7] ^ din[ 8] ^ din[ 4];
      dout[160] = din[ 4] ^ din[ 6] ^ din[ 7] ^ din[ 3];
      dout[159] = din[ 3] ^ din[ 5] ^ din[ 6] ^ din[ 2];
      dout[158] = din[ 2] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[157] = din[ 1] ^ din[ 3] ^ din[ 4] ^ din[ 0];
      dout[156] = din[ 0] ^ din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[155] = din[ 8] ^ din[ 1] ^ din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 3];
      dout[154] = din[ 7] ^ din[ 0] ^ din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 2];
      dout[153] = din[ 6] ^ din[ 8] ^ din[ 0] ^ din[ 2] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[152] = din[ 5] ^ din[ 7] ^ din[ 8] ^ din[ 1] ^ din[ 3] ^ din[ 0];
      dout[151] = din[ 6] ^ din[ 7] ^ din[ 0] ^ din[ 2] ^ din[ 8];
      dout[150] = din[ 5] ^ din[ 6] ^ din[ 8] ^ din[ 1] ^ din[ 4] ^ din[ 7];
      dout[149] = din[ 4] ^ din[ 5] ^ din[ 7] ^ din[ 0] ^ din[ 3] ^ din[ 6];
      dout[148] = din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 2] ^ din[ 5];
      dout[147] = din[ 2] ^ din[ 4] ^ din[ 5] ^ din[ 7] ^ din[ 1];
      dout[146] = din[ 1] ^ din[ 4] ^ din[ 3] ^ din[ 6] ^ din[ 0];
      dout[145] = din[ 0] ^ din[ 3] ^ din[ 2] ^ din[ 5] ^ din[ 8] ^ din[ 4];
      dout[144] = din[ 8] ^ din[ 2] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[143] = din[ 7] ^ din[ 1] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[142] = din[ 6] ^ din[ 0] ^ din[ 8] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[141] = din[ 5] ^ din[ 8] ^ din[ 7] ^ din[ 3] ^ din[ 0];
      dout[140] = din[ 7] ^ din[ 6] ^ din[ 2] ^ din[ 8];
      dout[139] = din[ 6] ^ din[ 5] ^ din[ 1] ^ din[ 7];
      dout[138] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6];
      dout[137] = din[ 3] ^ din[ 8] ^ din[ 5];
      dout[136] = din[ 2] ^ din[ 4] ^ din[ 7];
      dout[135] = din[ 1] ^ din[ 3] ^ din[ 6];
      dout[134] = din[ 0] ^ din[ 2] ^ din[ 5];
      dout[133] = din[ 8] ^ din[ 1];
      dout[132] = din[ 7] ^ din[ 0];
      dout[131] = din[ 6] ^ din[ 8] ^ din[ 4];
      dout[130] = din[ 5] ^ din[ 7] ^ din[ 3];
      dout[129] = din[ 4] ^ din[ 6] ^ din[ 2];
      dout[128] = din[ 3] ^ din[ 5] ^ din[ 1];
      dout[127] = din[ 2] ^ din[ 4] ^ din[ 0];
      dout[126] = din[ 1] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[125] = din[ 0] ^ din[ 2] ^ din[ 7] ^ din[ 3];
      dout[124] = din[ 8] ^ din[ 1] ^ din[ 4] ^ din[ 6] ^ din[ 2];
      dout[123] = din[ 7] ^ din[ 0] ^ din[ 3] ^ din[ 5] ^ din[ 1];
      dout[122] = din[ 6] ^ din[ 8] ^ din[ 2] ^ din[ 0];
      dout[121] = din[ 5] ^ din[ 7] ^ din[ 1] ^ din[ 8] ^ din[ 4];
      dout[120] = din[ 4] ^ din[ 6] ^ din[ 0] ^ din[ 7] ^ din[ 3];
      dout[119] = din[ 3] ^ din[ 5] ^ din[ 8] ^ din[ 4] ^ din[ 6] ^ din[ 2];
      dout[118] = din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 3] ^ din[ 5] ^ din[ 1];
      dout[117] = din[ 1] ^ din[ 3] ^ din[ 4] ^ din[ 6] ^ din[ 2] ^ din[ 0];
      dout[116] = din[ 0] ^ din[ 2] ^ din[ 3] ^ din[ 5] ^ din[ 1] ^ din[ 8] ^ din[ 4];
      dout[115] = din[ 8] ^ din[ 1] ^ din[ 2] ^ din[ 0] ^ din[ 7] ^ din[ 3];
      dout[114] = din[ 7] ^ din[ 0] ^ din[ 1] ^ din[ 8] ^ din[ 4] ^ din[ 6] ^ din[ 2];
      dout[113] = din[ 6] ^ din[ 8] ^ din[ 0] ^ din[ 4] ^ din[ 7] ^ din[ 3] ^ din[ 5] ^ din[ 1];
      dout[112] = din[ 5] ^ din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 6] ^ din[ 2] ^ din[ 0];
      dout[111] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 5] ^ din[ 1] ^ din[ 8];
      dout[110] = din[ 5] ^ din[ 4] ^ din[ 6] ^ din[ 1] ^ din[ 0] ^ din[ 7];
      dout[109] = din[ 3] ^ din[ 5] ^ din[ 0] ^ din[ 8] ^ din[ 6];
      dout[108] = din[ 2] ^ din[ 8] ^ din[ 7] ^ din[ 5];
      dout[107] = din[ 1] ^ din[ 4] ^ din[ 7] ^ din[ 6];
      dout[106] = din[ 0] ^ din[ 3] ^ din[ 6] ^ din[ 5];
      dout[105] = din[ 8] ^ din[ 2] ^ din[ 5];
      dout[104] = din[ 4] ^ din[ 7] ^ din[ 1];
      dout[103] = din[ 3] ^ din[ 6] ^ din[ 0];
      dout[102] = din[ 2] ^ din[ 5] ^ din[ 8] ^ din[ 4];
      dout[101] = din[ 4] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[100] = din[ 3] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[ 99] = din[ 2] ^ din[ 8] ^ din[ 5] ^ din[ 4] ^ din[ 1];
      dout[ 98] = din[ 1] ^ din[ 4] ^ din[ 7] ^ din[ 3] ^ din[ 0];
      dout[ 97] = din[ 0] ^ din[ 3] ^ din[ 6] ^ din[ 2] ^ din[ 8] ^ din[ 4];
      dout[ 96] = din[ 8] ^ din[ 2] ^ din[ 5] ^ din[ 4] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[ 95] = din[ 4] ^ din[ 7] ^ din[ 1] ^ din[ 3] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[ 94] = din[ 3] ^ din[ 6] ^ din[ 0] ^ din[ 2] ^ din[ 8] ^ din[ 5] ^ din[ 4] ^ din[ 1];
      dout[ 93] = din[ 2] ^ din[ 5] ^ din[ 8] ^ din[ 1] ^ din[ 7] ^ din[ 3] ^ din[ 0];
      dout[ 92] = din[ 1] ^ din[ 7] ^ din[ 0] ^ din[ 6] ^ din[ 2] ^ din[ 8];
      dout[ 91] = din[ 0] ^ din[ 6] ^ din[ 8] ^ din[ 5] ^ din[ 4] ^ din[ 1] ^ din[ 7];
      dout[ 90] = din[ 8] ^ din[ 5] ^ din[ 7] ^ din[ 3] ^ din[ 0] ^ din[ 6];
      dout[ 89] = din[ 7] ^ din[ 6] ^ din[ 2] ^ din[ 8] ^ din[ 5];
      dout[ 88] = din[ 6] ^ din[ 4] ^ din[ 5] ^ din[ 1] ^ din[ 7];
      dout[ 87] = din[ 5] ^ din[ 4] ^ din[ 3] ^ din[ 0] ^ din[ 6];
      dout[ 86] = din[ 3] ^ din[ 2] ^ din[ 8] ^ din[ 5];
      dout[ 85] = din[ 2] ^ din[ 4] ^ din[ 1] ^ din[ 7];
      dout[ 84] = din[ 1] ^ din[ 3] ^ din[ 0] ^ din[ 6];
      dout[ 83] = din[ 0] ^ din[ 2] ^ din[ 8] ^ din[ 4] ^ din[ 5];
      dout[ 82] = din[ 8] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[ 81] = din[ 7] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[ 80] = din[ 6] ^ din[ 8] ^ din[ 5] ^ din[ 4] ^ din[ 1];
      dout[ 79] = din[ 4] ^ din[ 5] ^ din[ 7] ^ din[ 3] ^ din[ 0];
      dout[ 78] = din[ 3] ^ din[ 6] ^ din[ 2] ^ din[ 8];
      dout[ 77] = din[ 2] ^ din[ 5] ^ din[ 1] ^ din[ 7];
      dout[ 76] = din[ 4] ^ din[ 1] ^ din[ 0] ^ din[ 6];
      dout[ 75] = din[ 3] ^ din[ 0] ^ din[ 8] ^ din[ 5] ^ din[ 4];
      dout[ 74] = din[ 2] ^ din[ 8] ^ din[ 7] ^ din[ 3];
      dout[ 73] = din[ 1] ^ din[ 7] ^ din[ 6] ^ din[ 2];
      dout[ 72] = din[ 0] ^ din[ 6] ^ din[ 5] ^ din[ 1];
      dout[ 71] = din[ 8] ^ din[ 5] ^ din[ 0];
      dout[ 70] = din[ 7] ^ din[ 8];
      dout[ 69] = din[ 6] ^ din[ 7];
      dout[ 68] = din[ 5] ^ din[ 6];
      dout[ 67] = din[ 4] ^ din[ 5];
      dout[ 66] = din[ 3] ^ din[ 4];
      dout[ 65] = din[ 2] ^ din[ 3];
      dout[ 64] = din[ 1] ^ din[ 2];
      dout[ 63] = din[ 0] ^ din[ 1];
      dout[ 62] = din[ 8] ^ din[ 0] ^ din[ 4];
      dout[ 61] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 4];
      dout[ 60] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 3];
      dout[ 59] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 2];
      dout[ 58] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 1];
      dout[ 57] = din[ 3] ^ din[ 8] ^ din[ 0];
      dout[ 56] = din[ 2] ^ din[ 7] ^ din[ 8] ^ din[ 4];
      dout[ 55] = din[ 1] ^ din[ 6] ^ din[ 7] ^ din[ 3];
      dout[ 54] = din[ 0] ^ din[ 5] ^ din[ 6] ^ din[ 2];
      dout[ 53] = din[ 8] ^ din[ 5] ^ din[ 1];
      dout[ 52] = din[ 7] ^ din[ 4] ^ din[ 0];
      dout[ 51] = din[ 6] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[ 50] = din[ 5] ^ din[ 2] ^ din[ 7] ^ din[ 3];
      dout[ 49] = din[ 4] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[ 48] = din[ 3] ^ din[ 0] ^ din[ 5] ^ din[ 1];
      dout[ 47] = din[ 2] ^ din[ 8] ^ din[ 0];
      dout[ 46] = din[ 1] ^ din[ 7] ^ din[ 8] ^ din[ 4];
      dout[ 45] = din[ 0] ^ din[ 6] ^ din[ 7] ^ din[ 3];
      dout[ 44] = din[ 8] ^ din[ 5] ^ din[ 4] ^ din[ 6] ^ din[ 2];
      dout[ 43] = din[ 7] ^ din[ 4] ^ din[ 3] ^ din[ 5] ^ din[ 1];
      dout[ 42] = din[ 6] ^ din[ 3] ^ din[ 4] ^ din[ 2] ^ din[ 0];
      dout[ 41] = din[ 5] ^ din[ 2] ^ din[ 3] ^ din[ 1] ^ din[ 8] ^ din[ 4];
      dout[ 40] = din[ 4] ^ din[ 1] ^ din[ 2] ^ din[ 0] ^ din[ 7] ^ din[ 3];
      dout[ 39] = din[ 3] ^ din[ 0] ^ din[ 1] ^ din[ 8] ^ din[ 4] ^ din[ 6] ^ din[ 2];
      dout[ 38] = din[ 2] ^ din[ 8] ^ din[ 0] ^ din[ 7] ^ din[ 4] ^ din[ 3] ^ din[ 5] ^ din[ 1];
      dout[ 37] = din[ 1] ^ din[ 7] ^ din[ 8] ^ din[ 6] ^ din[ 3] ^ din[ 2] ^ din[ 0];
      dout[ 36] = din[ 0] ^ din[ 6] ^ din[ 7] ^ din[ 5] ^ din[ 2] ^ din[ 1] ^ din[ 8] ^ din[ 4];
      dout[ 35] = din[ 8] ^ din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 0] ^ din[ 7] ^ din[ 3];
      dout[ 34] = din[ 7] ^ din[ 5] ^ din[ 0] ^ din[ 8] ^ din[ 6] ^ din[ 2];
      dout[ 33] = din[ 6] ^ din[ 8] ^ din[ 7] ^ din[ 5] ^ din[ 1];
      dout[ 32] = din[ 5] ^ din[ 4] ^ din[ 7] ^ din[ 6] ^ din[ 0];
      dout[ 31] = din[ 3] ^ din[ 6] ^ din[ 5] ^ din[ 8];
      dout[ 30] = din[ 4] ^ din[ 2] ^ din[ 5] ^ din[ 7];
      dout[ 29] = din[ 4] ^ din[ 3] ^ din[ 1] ^ din[ 6];
      dout[ 28] = din[ 3] ^ din[ 2] ^ din[ 0] ^ din[ 5];
      dout[ 27] = din[ 2] ^ din[ 1] ^ din[ 8];
      dout[ 26] = din[ 1] ^ din[ 0] ^ din[ 7];
      dout[ 25] = din[ 0] ^ din[ 8] ^ din[ 6] ^ din[ 4];
      dout[ 24] = din[ 8] ^ din[ 7] ^ din[ 5] ^ din[ 4] ^ din[ 3];
      dout[ 23] = din[ 4] ^ din[ 7] ^ din[ 6] ^ din[ 3] ^ din[ 2];
      dout[ 22] = din[ 3] ^ din[ 6] ^ din[ 5] ^ din[ 2] ^ din[ 1];
      dout[ 21] = din[ 4] ^ din[ 2] ^ din[ 5] ^ din[ 1] ^ din[ 0];
      dout[ 20] = din[ 3] ^ din[ 1] ^ din[ 0] ^ din[ 8];
      dout[ 19] = din[ 2] ^ din[ 0] ^ din[ 8] ^ din[ 7] ^ din[ 4];
      dout[ 18] = din[ 1] ^ din[ 8] ^ din[ 4] ^ din[ 7] ^ din[ 6] ^ din[ 3];
      dout[ 17] = din[ 0] ^ din[ 7] ^ din[ 3] ^ din[ 6] ^ din[ 5] ^ din[ 2];
      dout[ 16] = din[ 8] ^ din[ 6] ^ din[ 2] ^ din[ 5] ^ din[ 1];
      dout[ 15] = din[ 7] ^ din[ 5] ^ din[ 4] ^ din[ 1] ^ din[ 0];
      dout[ 14] = din[ 6] ^ din[ 3] ^ din[ 0] ^ din[ 8];
      dout[ 13] = din[ 5] ^ din[ 2] ^ din[ 8] ^ din[ 4] ^ din[ 7];
      dout[ 12] = din[ 4] ^ din[ 1] ^ din[ 7] ^ din[ 3] ^ din[ 6];
      dout[ 11] = din[ 3] ^ din[ 0] ^ din[ 6] ^ din[ 2] ^ din[ 5];
      dout[ 10] = din[ 2] ^ din[ 8] ^ din[ 5] ^ din[ 1];
      dout[  9] = din[ 1] ^ din[ 4] ^ din[ 7] ^ din[ 0];
      dout[  8] = din[ 0] ^ din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 4];
      dout[  7] = din[ 8] ^ din[ 2] ^ din[ 5] ^ din[ 4] ^ din[ 7] ^ din[ 3];
      dout[  6] = din[ 7] ^ din[ 4] ^ din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 2];
      dout[  5] = din[ 6] ^ din[ 3] ^ din[ 0] ^ din[ 2] ^ din[ 5] ^ din[ 1];
      dout[  4] = din[ 5] ^ din[ 2] ^ din[ 8] ^ din[ 1] ^ din[ 0];
      dout[  3] = din[ 1] ^ din[ 7] ^ din[ 0] ^ din[ 8];
      dout[  2] = din[ 0] ^ din[ 6] ^ din[ 8] ^ din[ 4] ^ din[ 7];
      dout[  1] = din[ 8] ^ din[ 5] ^ din[ 7] ^ din[ 4] ^ din[ 3] ^ din[ 6];
      dout[  0] = din[ 4] ^ din[ 7] ^ din[ 6] ^ din[ 3] ^ din[ 2] ^ din[ 5];
      pn9 = dout;
    end
  endfunction

  // pn sequence select

  assign adc_pn_data_pn_s = (adc_pn_oos == 1'b1) ? adc_pn_data_in : adc_pn_data_pn;

  always @(posedge adc_clk) begin
    adc_pn_data_in <= { ~adc_data[ 11], adc_data[ 10:  0],
                        ~adc_data[ 23], adc_data[ 22: 12],
                        ~adc_data[ 35], adc_data[ 34: 24],
                        ~adc_data[ 47], adc_data[ 46: 36],
                        ~adc_data[ 59], adc_data[ 58: 48],
                        ~adc_data[ 71], adc_data[ 70: 60],
                        ~adc_data[ 83], adc_data[ 82: 72],
                        ~adc_data[ 95], adc_data[ 94: 84],
                        ~adc_data[107], adc_data[106: 96],
                        ~adc_data[119], adc_data[118:108],
                        ~adc_data[131], adc_data[130:120],
                        ~adc_data[143], adc_data[142:132],
                        ~adc_data[155], adc_data[154:144],
                        ~adc_data[167], adc_data[166:156],
                        ~adc_data[179], adc_data[178:168],
                        ~adc_data[191], adc_data[190:180]};
    if (adc_pnseq_sel == 4'd0) begin
      adc_pn_data_pn <= pn9(adc_pn_data_pn_s);
    end else begin
      adc_pn_data_pn <= pn23(adc_pn_data_pn_s);
    end
  end

  // pn oos & pn error

  ad_pnmon #(.DATA_WIDTH(192)) i_pnmon (
    .adc_clk (adc_clk),
    .adc_valid_in (1'b1),
    .adc_data_in (adc_pn_data_in),
    .adc_data_pn (adc_pn_data_pn),
    .adc_pn_oos (adc_pn_oos),
    .adc_pn_err (adc_pn_err));

endmodule

// ***************************************************************************
// ***************************************************************************

