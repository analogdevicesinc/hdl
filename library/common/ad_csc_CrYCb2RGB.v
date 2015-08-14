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
// Transmit HDMI, CrYCb to RGB conversion
// The multiplication coefficients are in 1.4.12 format
// The addition coefficients are in 1.12.12 format
// R = (+408.583/256)*Cr + (+298.082/256)*Y + ( 000.000/256)*Cb + (-222.921);
// G = (-208.120/256)*Cr + (+298.082/256)*Y + (-100.291/256)*Cb + (+135.576);
// B = ( 000.000/256)*Cr + (+298.082/256)*Y + (+516.412/256)*Cb + (-276.836);

module ad_csc_CrYCb2RGB (

  // Cr-Y-Cb inputs

  clk,
  CrYCb_sync,
  CrYCb_data,

  // R-G-B outputs

  RGB_sync,
  RGB_data);

  // parameters

  parameter   DELAY_DATA_WIDTH = 16;
  localparam  DW = DELAY_DATA_WIDTH - 1;

  // Cr-Y-Cb inputs

  input           clk;
  input   [DW:0]  CrYCb_sync;
  input   [23:0]  CrYCb_data;

  // R-G-B outputs

  output  [DW:0]  RGB_sync;
  output  [23:0]  RGB_data;

  // red

  ad_csc_1 #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH)) i_csc_1_R (
    .clk (clk),
    .sync (CrYCb_sync),
    .data (CrYCb_data),
    .C1 (17'h01989),
    .C2 (17'h012a1),
    .C3 (17'h00000),
    .C4 (25'h10deebc),
    .csc_sync_1 (RGB_sync),
    .csc_data_1 (RGB_data[23:16]));

  // green

  ad_csc_1 #(.DELAY_DATA_WIDTH(1)) i_csc_1_G (
    .clk (clk),
    .sync (1'd0),
    .data (CrYCb_data),
    .C1 (17'h10d01),
    .C2 (17'h012a1),
    .C3 (17'h10644),
    .C4 (25'h0087937),
    .csc_sync_1 (),
    .csc_data_1 (RGB_data[15:8]));

  // blue

  ad_csc_1 #(.DELAY_DATA_WIDTH(1)) i_csc_1_B (
    .clk (clk),
    .sync (1'd0),
    .data (CrYCb_data),
    .C1 (17'h00000),
    .C2 (17'h012a1),
    .C3 (17'h02046),
    .C4 (25'h1114d60),
    .csc_sync_1 (),
    .csc_data_1 (RGB_data[7:0]));

endmodule

// ***************************************************************************
// ***************************************************************************
