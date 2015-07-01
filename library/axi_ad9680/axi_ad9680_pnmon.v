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

module axi_ad9680_pnmon (

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
  input   [55:0]  adc_data;

  // pn out of sync and error

  output          adc_pn_oos;
  output          adc_pn_err;

  // processor interface PN9 (0x0), PN23 (0x1)

  input   [ 3:0]  adc_pnseq_sel;

  // internal registers

  reg     [55:0]  adc_pn_data_in = 'd0;
  reg     [55:0]  adc_pn_data_pn = 'd0;

  // internal signals

  wire    [55:0]  adc_pn_data_pn_s;

  // PN23 function

  function [55:0] pn23;
    input [55:0] din;
    reg   [55:0] dout;
    begin
      dout[55] = din[22] ^ din[17];
      dout[54] = din[21] ^ din[16];
      dout[53] = din[20] ^ din[15];
      dout[52] = din[19] ^ din[14];
      dout[51] = din[18] ^ din[13];
      dout[50] = din[17] ^ din[12];
      dout[49] = din[16] ^ din[11];
      dout[48] = din[15] ^ din[10];
      dout[47] = din[14] ^ din[ 9];
      dout[46] = din[13] ^ din[ 8];
      dout[45] = din[12] ^ din[ 7];
      dout[44] = din[11] ^ din[ 6];
      dout[43] = din[10] ^ din[ 5];
      dout[42] = din[ 9] ^ din[ 4];
      dout[41] = din[ 8] ^ din[ 3];
      dout[40] = din[ 7] ^ din[ 2];
      dout[39] = din[ 6] ^ din[ 1];
      dout[38] = din[ 5] ^ din[ 0];
      dout[37] = din[ 4] ^ din[22] ^ din[17];
      dout[36] = din[ 3] ^ din[21] ^ din[16];
      dout[35] = din[ 2] ^ din[20] ^ din[15];
      dout[34] = din[ 1] ^ din[19] ^ din[14];
      dout[33] = din[ 0] ^ din[18] ^ din[13];
      dout[32] = din[22] ^ din[12];
      dout[31] = din[21] ^ din[11];
      dout[30] = din[20] ^ din[10];
      dout[29] = din[19] ^ din[ 9];
      dout[28] = din[18] ^ din[ 8];
      dout[27] = din[17] ^ din[ 7];
      dout[26] = din[16] ^ din[ 6];
      dout[25] = din[15] ^ din[ 5];
      dout[24] = din[14] ^ din[ 4];
      dout[23] = din[13] ^ din[ 3];
      dout[22] = din[12] ^ din[ 2];
      dout[21] = din[11] ^ din[ 1];
      dout[20] = din[10] ^ din[ 0];
      dout[19] = din[ 9] ^ din[22] ^ din[17];
      dout[18] = din[ 8] ^ din[21] ^ din[16];
      dout[17] = din[ 7] ^ din[20] ^ din[15];
      dout[16] = din[ 6] ^ din[19] ^ din[14];
      dout[15] = din[ 5] ^ din[18] ^ din[13];
      dout[14] = din[ 4] ^ din[17] ^ din[12];
      dout[13] = din[ 3] ^ din[16] ^ din[11];
      dout[12] = din[ 2] ^ din[15] ^ din[10];
      dout[11] = din[ 1] ^ din[14] ^ din[ 9];
      dout[10] = din[ 0] ^ din[13] ^ din[ 8];
      dout[ 9] = din[22] ^ din[12] ^ din[17] ^ din[ 7];
      dout[ 8] = din[21] ^ din[11] ^ din[16] ^ din[ 6];
      dout[ 7] = din[20] ^ din[10] ^ din[15] ^ din[ 5];
      dout[ 6] = din[19] ^ din[ 9] ^ din[14] ^ din[ 4];
      dout[ 5] = din[18] ^ din[ 8] ^ din[13] ^ din[ 3];
      dout[ 4] = din[17] ^ din[ 7] ^ din[12] ^ din[ 2];
      dout[ 3] = din[16] ^ din[ 6] ^ din[11] ^ din[ 1];
      dout[ 2] = din[15] ^ din[ 5] ^ din[10] ^ din[ 0];
      dout[ 1] = din[14] ^ din[ 4] ^ din[ 9] ^ din[22] ^ din[17];
      dout[ 0] = din[13] ^ din[ 3] ^ din[ 8] ^ din[21] ^ din[16];
      pn23 = dout;
    end
  endfunction

  // PN9 function

  function [55:0] pn9;
    input [55:0] din;
    reg   [55:0] dout;
    begin
      dout[55] = din[ 8] ^ din[ 4];
      dout[54] = din[ 7] ^ din[ 3];
      dout[53] = din[ 6] ^ din[ 2];
      dout[52] = din[ 5] ^ din[ 1];
      dout[51] = din[ 4] ^ din[ 0];
      dout[50] = din[ 3] ^ din[ 8] ^ din[ 4];
      dout[49] = din[ 2] ^ din[ 7] ^ din[ 3];
      dout[48] = din[ 1] ^ din[ 6] ^ din[ 2];
      dout[47] = din[ 0] ^ din[ 5] ^ din[ 1];
      dout[46] = din[ 8] ^ din[ 0];
      dout[45] = din[ 7] ^ din[ 8] ^ din[ 4];
      dout[44] = din[ 6] ^ din[ 7] ^ din[ 3];
      dout[43] = din[ 5] ^ din[ 6] ^ din[ 2];
      dout[42] = din[ 4] ^ din[ 5] ^ din[ 1];
      dout[41] = din[ 3] ^ din[ 4] ^ din[ 0];
      dout[40] = din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[39] = din[ 1] ^ din[ 2] ^ din[ 7] ^ din[ 3];
      dout[38] = din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[37] = din[ 8] ^ din[ 0] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[36] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 0];
      dout[35] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 8] ^ din[ 4];
      dout[34] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[33] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[32] = din[ 3] ^ din[ 8] ^ din[ 5] ^ din[ 1];
      dout[31] = din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 0];
      dout[30] = din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 4];
      dout[29] = din[ 0] ^ din[ 2] ^ din[ 5] ^ din[ 7] ^ din[ 3];
      dout[28] = din[ 8] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[27] = din[ 7] ^ din[ 0] ^ din[ 5] ^ din[ 1];
      dout[26] = din[ 6] ^ din[ 8] ^ din[ 0];
      dout[25] = din[ 5] ^ din[ 7] ^ din[ 8] ^ din[ 4];
      dout[24] = din[ 4] ^ din[ 6] ^ din[ 7] ^ din[ 3];
      dout[23] = din[ 3] ^ din[ 5] ^ din[ 6] ^ din[ 2];
      dout[22] = din[ 2] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[21] = din[ 1] ^ din[ 3] ^ din[ 4] ^ din[ 0];
      dout[20] = din[ 0] ^ din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[19] = din[ 8] ^ din[ 1] ^ din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 3];
      dout[18] = din[ 7] ^ din[ 0] ^ din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 2];
      dout[17] = din[ 6] ^ din[ 8] ^ din[ 0] ^ din[ 2] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[16] = din[ 5] ^ din[ 7] ^ din[ 8] ^ din[ 1] ^ din[ 3] ^ din[ 0];
      dout[15] = din[ 6] ^ din[ 7] ^ din[ 0] ^ din[ 2] ^ din[ 8];
      dout[14] = din[ 5] ^ din[ 6] ^ din[ 8] ^ din[ 1] ^ din[ 4] ^ din[ 7];
      dout[13] = din[ 4] ^ din[ 5] ^ din[ 7] ^ din[ 0] ^ din[ 3] ^ din[ 6];
      dout[12] = din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 2] ^ din[ 5];
      dout[11] = din[ 2] ^ din[ 4] ^ din[ 5] ^ din[ 7] ^ din[ 1];
      dout[10] = din[ 1] ^ din[ 4] ^ din[ 3] ^ din[ 6] ^ din[ 0];
      dout[ 9] = din[ 0] ^ din[ 3] ^ din[ 2] ^ din[ 5] ^ din[ 8] ^ din[ 4];
      dout[ 8] = din[ 8] ^ din[ 2] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[ 7] = din[ 7] ^ din[ 1] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[ 6] = din[ 6] ^ din[ 0] ^ din[ 8] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[ 5] = din[ 5] ^ din[ 8] ^ din[ 7] ^ din[ 3] ^ din[ 0];
      dout[ 4] = din[ 7] ^ din[ 6] ^ din[ 2] ^ din[ 8];
      dout[ 3] = din[ 6] ^ din[ 5] ^ din[ 1] ^ din[ 7];
      dout[ 2] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6];
      dout[ 1] = din[ 3] ^ din[ 8] ^ din[ 5];
      dout[ 0] = din[ 2] ^ din[ 4] ^ din[ 7];
      pn9 = dout;
    end
  endfunction

  // pn sequence select

  assign adc_pn_data_pn_s = (adc_pn_oos == 1'b1) ? adc_pn_data_in : adc_pn_data_pn;

  always @(posedge adc_clk) begin
    adc_pn_data_in <= { ~adc_data[13], adc_data[12: 0],
                        ~adc_data[27], adc_data[26:14],
                        ~adc_data[41], adc_data[40:28],
                        ~adc_data[55], adc_data[54:42]};
    if (adc_pnseq_sel == 4'd0) begin
      adc_pn_data_pn <= pn9(adc_pn_data_pn_s);
    end else begin
      adc_pn_data_pn <= pn23(adc_pn_data_pn_s);
    end
  end

  // pn oos & pn err

  ad_pnmon #(.DATA_WIDTH(56)) i_pnmon (
    .adc_clk (adc_clk),
    .adc_valid_in (1'b1),
    .adc_data_in (adc_pn_data_in),
    .adc_data_pn (adc_pn_data_pn),
    .adc_pn_oos (adc_pn_oos),
    .adc_pn_err (adc_pn_err));

endmodule

// ***************************************************************************
// ***************************************************************************

