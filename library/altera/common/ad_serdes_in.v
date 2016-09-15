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

module ad_serdes_in #(

  // parameters

  parameter   DEVICE_TYPE = 0,
  parameter   DATA_WIDTH = 16) (

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

  input                           up_clk;
  input   [(DATA_WIDTH-1):0]      up_dld;
  input   [((DATA_WIDTH*5)-1):0]  up_dwdata;
  output  [((DATA_WIDTH*5)-1):0]  up_drdata;

  // delay-control interface

  input                           delay_clk,
  input                           delay_rst,
  output                          delay_locked);

  // internal signals

  wire    [(DATA_WIDTH-1):0]      delay_locked_s;

  // assignments

  assign up_drdata = 5'd0;
  assign delay_locked = & delay_locked_s;

  // instantiations

  genvar l_inst;
  generate
  for (l_inst = 0; l_inst < DATA_WIDTH; l_inst = l_inst + 1) begin: g_data
  alt_serdes_in_core i_core (
    .clk_export (clk),
    .div_clk_export (div_clk),
    .hs_phase_export (phase),
    .loaden_export (loaden),
    .locked_export (locked),
    .data_in_export (data_in_p[l_inst]),
    .data_s_export ({ data_s0[l_inst],
                      data_s1[l_inst],
                      data_s2[l_inst],
                      data_s3[l_inst],
                      data_s4[l_inst],
                      data_s5[l_inst],
                      data_s6[l_inst],
                      data_s7[l_inst]}),
    .delay_locked_export (delay_locked_s[l_inst]));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
