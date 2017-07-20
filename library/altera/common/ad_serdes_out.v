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

`timescale 1ps/1ps

module __ad_serdes_out__ #(

  parameter   DEVICE_TYPE = 0,
  parameter   DDR_OR_SDR_N = 1,
  parameter   SERDES_FACTOR = 8,
  parameter   DATA_WIDTH = 16) (

  // reset and clocks

  input                           rst,
  input                           clk,
  input                           div_clk,
  input                           loaden,
                                  
  // data interface               
                                  
  input   [(DATA_WIDTH-1):0]      data_s0,
  input   [(DATA_WIDTH-1):0]      data_s1,
  input   [(DATA_WIDTH-1):0]      data_s2,
  input   [(DATA_WIDTH-1):0]      data_s3,
  input   [(DATA_WIDTH-1):0]      data_s4,
  input   [(DATA_WIDTH-1):0]      data_s5,
  input   [(DATA_WIDTH-1):0]      data_s6,
  input   [(DATA_WIDTH-1):0]      data_s7,
  output  [(DATA_WIDTH-1):0]      data_out_p,
  output  [(DATA_WIDTH-1):0]      data_out_n);

  // local parameter

  localparam ARRIA10 = 0;
  localparam CYCLONE5 = 1;

  // internal signals

  wire    [(DATA_WIDTH-1):0]      data_samples_s[0:(SERDES_FACTOR-1)];
  wire    [(SERDES_FACTOR-1):0]   data_in_s[0:(DATA_WIDTH-1)];

  // defaults

  assign data_out_n = 'd0;

  // instantiations

  genvar n;
  genvar i;

  generate
  if (SERDES_FACTOR == 8) begin
  assign data_samples_s[7] = data_s7;
  assign data_samples_s[6] = data_s6;
  assign data_samples_s[5] = data_s5;
  assign data_samples_s[4] = data_s4;
  end
  endgenerate

  assign data_samples_s[3] = data_s3;
  assign data_samples_s[2] = data_s2;
  assign data_samples_s[1] = data_s1;
  assign data_samples_s[0] = data_s0;

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_swap
    for (i = 0; i < SERDES_FACTOR; i = i + 1) begin: g_samples
      assign data_in_s[n][((SERDES_FACTOR-1)-i)] = data_samples_s[i][n];
    end
  end
  endgenerate

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_data

  if (DEVICE_TYPE == CYCLONE5) begin
  ad_serdes_out_core_c5 #(
    .SERDES_FACTOR (SERDES_FACTOR))
  i_core (
    .clk (clk),
    .div_clk (div_clk),
    .enable (loaden),
    .data_out (data_out_p[n]),
    .data (data_in_s[n]));
  end

  if (DEVICE_TYPE == ARRIA10) begin
  __ad_serdes_out_1__ i_core (
    .clk_export (clk),
    .div_clk_export (div_clk),
    .loaden_export (loaden),
    .data_out_export (data_out_p[n]),
    .data_s_export (data_in_s[n]));
  end

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

