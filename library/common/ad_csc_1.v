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
// csc = c1*d[23:16] + c2*d[15:8] + c3*d[7:0] + c4;

module ad_csc_1 (

  // data

  clk,
  sync,
  data,

  // constants

  C1,
  C2,
  C3,
  C4,

  // sync is delay matched

  csc_sync_1,
  csc_data_1);

  // parameters

  parameter   DELAY_DATA_WIDTH = 16;
  localparam  DW = DELAY_DATA_WIDTH - 1;

  // data

  input           clk;
  input   [DW:0]  sync;
  input   [23:0]  data;

  // constants

  input   [16:0]  C1;
  input   [16:0]  C2;
  input   [16:0]  C3;
  input   [24:0]  C4;

  // sync is delay matched

  output  [DW:0]  csc_sync_1;
  output  [ 7:0]  csc_data_1;

  // internal wires

  wire    [24:0]  data_1_m_s;
  wire    [24:0]  data_2_m_s;
  wire    [24:0]  data_3_m_s;
  wire    [DW:0]  sync_3_m_s;

  // c1*R

  ad_csc_1_mul #(.DELAY_DATA_WIDTH(1)) i_mul_c1 (
    .clk (clk),
    .data_a (C1),
    .data_b (data[23:16]),
    .data_p (data_1_m_s),
    .ddata_in (1'd0),
    .ddata_out ());

  // c2*G

  ad_csc_1_mul #(.DELAY_DATA_WIDTH(1)) i_mul_c2 (
    .clk (clk),
    .data_a (C2),
    .data_b (data[15:8]),
    .data_p (data_2_m_s),
    .ddata_in (1'd0),
    .ddata_out ());

  // c3*B

  ad_csc_1_mul #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH)) i_mul_c3 (
    .clk (clk),
    .data_a (C3),
    .data_b (data[7:0]),
    .data_p (data_3_m_s),
    .ddata_in (sync),
    .ddata_out (sync_3_m_s));

  // sum + c4

  ad_csc_1_add #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH)) i_add_c4 (
    .clk (clk),
    .data_1 (data_1_m_s),
    .data_2 (data_2_m_s),
    .data_3 (data_3_m_s),
    .data_4 (C4),
    .data_p (csc_data_1),
    .ddata_in (sync_3_m_s),
    .ddata_out (csc_sync_1));

endmodule

// ***************************************************************************
// ***************************************************************************
