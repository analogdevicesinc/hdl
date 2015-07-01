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
// Transmit HDMI, RGB to CrYCb conversion
// The multiplication coefficients are in 1.4.12 format
// The addition coefficients are in 1.12.12 format
// Cr = (+112.439/256)*R + (-094.154/256)*G + (-018.285/256)*B + 128;
// Y  = (+065.738/256)*R + (+129.057/256)*G + (+025.064/256)*B +  16;
// Cb = (-037.945/256)*R + (-074.494/256)*G + (+112.439/256)*B + 128;

module ad_csc_RGB2CrYCb (

  // R-G-B inputs

  clk,
  RGB_sync,
  RGB_data,

  // Cr-Y-Cb outputs

  CrYCb_sync,
  CrYCb_data);

  // parameters

  parameter   DELAY_DATA_WIDTH = 16;
  localparam  DW = DELAY_DATA_WIDTH - 1;

  // R-G-B inputs

  input           clk;
  input   [DW:0]  RGB_sync;
  input   [23:0]  RGB_data;

  // Cr-Y-Cb outputs

  output  [DW:0]  CrYCb_sync;
  output  [23:0]  CrYCb_data;

  // Cr (red-diff)

  ad_csc_1 #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH)) i_csc_1_Cr (
    .clk (clk),
    .sync (RGB_sync),
    .data (RGB_data),
    .C1 (17'h00707),
    .C2 (17'h105e2),
    .C3 (17'h10124),
    .C4 (25'h0080000),
    .csc_sync_1 (CrYCb_sync),
    .csc_data_1 (CrYCb_data[23:16]));

  // Y (luma)

  ad_csc_1 #(.DELAY_DATA_WIDTH(1)) i_csc_1_Y (
    .clk (clk),
    .sync (1'd0),
    .data (RGB_data),
    .C1 (17'h0041b),
    .C2 (17'h00810),
    .C3 (17'h00191),
    .C4 (25'h0010000),
    .csc_sync_1 (),
    .csc_data_1 (CrYCb_data[15:8]));

  // Cb (blue-diff)

  ad_csc_1 #(.DELAY_DATA_WIDTH(1)) i_csc_1_Cb (
    .clk (clk),
    .sync (1'd0),
    .data (RGB_data),
    .C1 (17'h1025f),
    .C2 (17'h104a7),
    .C3 (17'h00707),
    .C4 (25'h0080000),
    .csc_sync_1 (),
    .csc_data_1 (CrYCb_data[7:0]));

endmodule

// ***************************************************************************
// ***************************************************************************
