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
// data format (offset binary or 2's complement only)

`timescale 1ps/1ps

module ad_datafmt (

  // data path

  clk,
  valid,
  data,
  valid_out,
  data_out,

  // control signals

  dfmt_enable,
  dfmt_type,
  dfmt_se);

  // delayed data bus width

  parameter   DATA_WIDTH = 16;
  localparam  DW = DATA_WIDTH - 1;

  // data path

  input           clk;
  input           valid;
  input   [DW:0]  data;
  output          valid_out;
  output  [15:0]  data_out;

  // control signals

  input           dfmt_enable;
  input           dfmt_type;
  input           dfmt_se;

  // internal registers

  reg             valid_out = 'd0;
  reg     [15:0]  data_out = 'd0;

  // internal signals

  wire            type_s;
  wire            signext_s;
  wire    [DW:0]  data_s;
  wire    [23:0]  sign_s;
  wire    [23:0]  data_out_s;

  // if offset-binary convert to 2's complement first

  assign type_s = dfmt_enable & dfmt_type;
  assign signext_s = dfmt_enable & dfmt_se;

  assign data_s = (type_s == 1'b1) ? {~data[DW], data[(DW-1):0]} : data;
  assign sign_s = (signext_s == 1'b1) ? {{24{data_s[DW]}}} : 24'd0;
  assign data_out_s = {sign_s[23:(DW+1)], data_s};

  always @(posedge clk) begin
    valid_out <= valid;
    data_out <= data_out_s[15:0];
  end

endmodule

// ***************************************************************************
// ***************************************************************************
