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
// serial data output interface: serdes(x8)

`timescale 1ps/1ps

module ad_serdes_out (

  // reset and clocks

  rst,
  clk,
  div_clk,
  loaden,

  // data interface

  data_s0,
  data_s1,
  data_s2,
  data_s3,
  data_s4,
  data_s5,
  data_s6,
  data_s7,
  data_out_p,
  data_out_n);

  // parameters

  parameter   DEVICE_TYPE = 0;
  parameter   DATA_WIDTH = 16;

  localparam  DW = DATA_WIDTH - 1;

  // reset and clocks

  input           rst;
  input           clk;
  input           div_clk;
  input           loaden;

  // data interface

  input   [DW:0]  data_s0;
  input   [DW:0]  data_s1;
  input   [DW:0]  data_s2;
  input   [DW:0]  data_s3;
  input   [DW:0]  data_s4;
  input   [DW:0]  data_s5;
  input   [DW:0]  data_s6;
  input   [DW:0]  data_s7;
  output  [DW:0]  data_out_p;
  output  [DW:0]  data_out_n;

  // internal signals

  wire    [DW:0]  data_out_s;
  wire    [ 7:0]  data_in_s[DW:0];

  // instantiations

  assign data_out_p = data_out_s;
  assign data_out_n = 0;   // differential pair will be defined by the Pin Planner

  genvar l_inst;
  generate
  for (l_inst = 0; l_inst <= DW; l_inst = l_inst + 1) begin: g_data

    assign data_in_s[l_inst] = {data_s7[l_inst],
                                data_s6[l_inst],
                                data_s5[l_inst],
                                data_s4[l_inst],
                                data_s3[l_inst],
                                data_s2[l_inst],
                                data_s1[l_inst],
                                data_s0[l_inst]};

    alt_serdes_out i_alt_serdes_out (
      .ext_coreclock (div_clk),         // ext_coreclock.export
      .ext_fclk (clk),                  // ext_fclk.export
      .ext_loaden (loaden),             // ext_loaden.export
      .tx_in (data_in_s[l_inst]),       // tx_in.export
      .tx_out (data_out_s[l_inst])      // tx_out.export
    );

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

