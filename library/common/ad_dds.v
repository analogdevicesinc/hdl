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

module ad_dds (

  // interface

  clk,
  dds_format,
  dds_phase_0,
  dds_scale_0,
  dds_phase_1,
  dds_scale_1,
  dds_data);

  // interface

  input           clk;
  input           dds_format;
  input   [15:0]  dds_phase_0;
  input   [15:0]  dds_scale_0;
  input   [15:0]  dds_phase_1;
  input   [15:0]  dds_scale_1;
  output  [15:0]  dds_data;

  // internal registers

  reg     [15:0]  dds_data_int = 'd0;
  reg     [15:0]  dds_data = 'd0;

  // internal signals

  wire    [15:0]  dds_data_0_s;
  wire    [15:0]  dds_data_1_s;

  // dds channel output

  always @(posedge clk) begin
    dds_data_int <= dds_data_0_s + dds_data_1_s;
    dds_data[15:15] <= dds_data_int[15] ^ dds_format;
    dds_data[14: 0] <= dds_data_int[14:0];
  end

  // dds-1

  ad_dds_1 i_dds_1_0 (
    .clk (clk),
    .angle (dds_phase_0),
    .scale (dds_scale_0),
    .dds_data (dds_data_0_s));

  // dds-2

  ad_dds_1 i_dds_1_1 (
    .clk (clk),
    .angle (dds_phase_1),
    .scale (dds_scale_1),
    .dds_data (dds_data_1_s));

endmodule

// ***************************************************************************
// ***************************************************************************
