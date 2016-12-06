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

`timescale 1ps/1ps

module __ad_serdes_in__ #(

  // parameters

  parameter   DEVICE_TYPE = 0,
  parameter   DDR_OR_SDR_N = 0,
  parameter   SERDES_FACTOR = 8,
  parameter   DATA_WIDTH = 16,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group") (

  // reset and clocks

  input                           rst,
  input                           clk,
  input                           div_clk,
  input                           loaden,
  input   [ 7:0]                  phase,
  input                           locked,

  // data interface

  output  [(DATA_WIDTH-1):0]      data_s0,
  output  [(DATA_WIDTH-1):0]      data_s1,
  output  [(DATA_WIDTH-1):0]      data_s2,
  output  [(DATA_WIDTH-1):0]      data_s3,
  output  [(DATA_WIDTH-1):0]      data_s4,
  output  [(DATA_WIDTH-1):0]      data_s5,
  output  [(DATA_WIDTH-1):0]      data_s6,
  output  [(DATA_WIDTH-1):0]      data_s7,
  input   [(DATA_WIDTH-1):0]      data_in_p,
  input   [(DATA_WIDTH-1):0]      data_in_n,

  // delay-data interface

  input                           up_clk,
  input   [(DATA_WIDTH-1):0]      up_dld,
  input   [((DATA_WIDTH*5)-1):0]  up_dwdata,
  output  [((DATA_WIDTH*5)-1):0]  up_drdata,

  // delay-control interface

  input                           delay_clk,
  input                           delay_rst,
  output                          delay_locked);

  // local parameter

  localparam ARRIA10 = 0;
  localparam CYCLONE5 = 1;

  // internal signals

  wire    [(DATA_WIDTH-1):0]      delay_locked_s;
  wire    [(DATA_WIDTH-1):0]      data_samples_s[0:(SERDES_FACTOR-1)];
  wire    [(SERDES_FACTOR-1):0]   data_out_s[0:(DATA_WIDTH-1)];

  // assignments

  assign up_drdata = 5'd0;
  assign delay_locked = & delay_locked_s;

  // instantiations

  genvar n;
  genvar i;

  generate
  if (SERDES_FACTOR == 8) begin
  assign data_s7 = data_samples_s[7];
  assign data_s6 = data_samples_s[6];
  assign data_s5 = data_samples_s[5];
  assign data_s4 = data_samples_s[4];
  end else begin
  assign data_s7 = 'd0;
  assign data_s6 = 'd0;
  assign data_s5 = 'd0;
  assign data_s4 = 'd0;
  end
  endgenerate

  assign data_s3 = data_samples_s[3];
  assign data_s2 = data_samples_s[2];
  assign data_s1 = data_samples_s[1];
  assign data_s0 = data_samples_s[0];

  generate
  for (i = 0; i < SERDES_FACTOR; i = i + 1) begin: g_samples
    for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_swap
      assign data_samples_s[i][n] = data_out_s[n][i];
    end
  end
  endgenerate

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_data

  if (DEVICE_TYPE == CYCLONE5) begin

  assign delay_locked_s[n] = 1'b1;

  ad_serdes_in_core_c5 #(
    .SERDES_FACTOR (SERDES_FACTOR))
  i_core (
    .clk (clk),
    .div_clk (div_clk),
    .enable (loaden),
    .data_in (data_in_p[n]),
    .data (data_out_s[n]));
  end

  if (DEVICE_TYPE == ARRIA10) begin
  __ad_serdes_in_1__ i_core (
    .clk_export (clk),
    .div_clk_export (div_clk),
    .hs_phase_export (phase),
    .loaden_export (loaden),
    .locked_export (locked),
    .data_in_export (data_in_p[n]),
    .data_s_export (data_out_s[n]),
    .delay_locked_export (delay_locked_s[n]));
  end

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
