// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
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
// replacing Xilinx's macro with Altera's LPM

`timescale 1ps/1ps

module MULT_MACRO (

  CE,
  RST,
  CLK,
  A,
  B,
  P);

  parameter   LATENCY = 3;
  parameter   WIDTH_A = 16;
  parameter   WIDTH_B = 16;

  localparam  WIDTH_P = WIDTH_A + WIDTH_B;

  input                   CE;
  input                   RST;
  input                   CLK;

  input   [WIDTH_A-1:0]   A;
  input   [WIDTH_B-1:0]   B;
  output  [WIDTH_P-1:0]   P;

  lpm_mult #(
    .lpm_type ("lpm_mult"),
    .lpm_widtha (WIDTH_A),
    .lpm_widthb (WIDTH_B),
    .lpm_widthp (WIDTH_P),
    .lpm_representation ("SIGNED"),
    .lpm_pipeline (3))
  i_lpm_mult (
    .clken (CE),
    .aclr (RST),
    .sum (1'b0),
    .clock (CLK),
    .dataa (A),
    .datab (B),
    .result (P));

endmodule

// ***************************************************************************
// ***************************************************************************
