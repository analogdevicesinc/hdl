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

`timescale 1ns/1ps

module avl_adxcfg (

  // reconfig sharing

  input           rcfg_clk,
  input           rcfg_reset_n,

  input           rcfg_in_read_0,
  input           rcfg_in_write_0,
  input   [ 9:0]  rcfg_in_address_0,
  input   [31:0]  rcfg_in_writedata_0,
  output  [31:0]  rcfg_in_readdata_0,
  output          rcfg_in_waitrequest_0,

  input           rcfg_in_read_1,
  input           rcfg_in_write_1,
  input   [ 9:0]  rcfg_in_address_1,
  input   [31:0]  rcfg_in_writedata_1,
  output  [31:0]  rcfg_in_readdata_1,
  output          rcfg_in_waitrequest_1,

  output          rcfg_out_read_0,
  output          rcfg_out_write_0,
  output  [ 9:0]  rcfg_out_address_0,
  output  [31:0]  rcfg_out_writedata_0,
  input   [31:0]  rcfg_out_readdata_0,
  input           rcfg_out_waitrequest_0,

  output          rcfg_out_read_1,
  output          rcfg_out_write_1,
  output  [ 9:0]  rcfg_out_address_1,
  output  [31:0]  rcfg_out_writedata_1,
  input   [31:0]  rcfg_out_readdata_1,
  input           rcfg_out_waitrequest_1);

  // internal registers

  reg     [ 1:0]  rcfg_select = 'd0;
  reg             rcfg_read_int = 'd0;
  reg             rcfg_write_int = 'd0;
  reg     [ 9:0]  rcfg_address_int = 'd0;
  reg     [31:0]  rcfg_writedata_int = 'd0;
  reg     [31:0]  rcfg_readdata_int = 'd0;
  reg             rcfg_waitrequest_int_0 = 'd1;
  reg             rcfg_waitrequest_int_1 = 'd1;

  // internal signals

  wire    [31:0]  rcfg_readdata_s;
  wire            rcfg_waitrequest_s;

  // xcvr sharing requires same bus (sw must make sure they are mutually exclusive access).

  assign rcfg_out_read_0 = rcfg_read_int;
  assign rcfg_out_write_0 = rcfg_write_int;
  assign rcfg_out_address_0 = rcfg_address_int;
  assign rcfg_out_writedata_0 = rcfg_writedata_int;
  assign rcfg_out_read_1 = rcfg_read_int;
  assign rcfg_out_write_1 = rcfg_write_int;
  assign rcfg_out_address_1 = rcfg_address_int;
  assign rcfg_out_writedata_1 = rcfg_writedata_int;
  assign rcfg_in_readdata_0 = rcfg_readdata_int;
  assign rcfg_in_readdata_1 = rcfg_readdata_int;
  assign rcfg_in_waitrequest_0 = rcfg_waitrequest_int_0;
  assign rcfg_in_waitrequest_1 = rcfg_waitrequest_int_1;

  assign rcfg_readdata_s = rcfg_out_readdata_1 & rcfg_out_readdata_0;
  assign rcfg_waitrequest_s = rcfg_out_waitrequest_1 & rcfg_out_waitrequest_0;

  always @(negedge rcfg_reset_n or posedge rcfg_clk) begin
    if (rcfg_reset_n == 0) begin
      rcfg_select <= 2'd0;
      rcfg_read_int <= 1'd0;
      rcfg_write_int <= 1'd0;
      rcfg_address_int <= 10'd0;
      rcfg_writedata_int <= 32'd0;
      rcfg_readdata_int = 32'd0;
      rcfg_waitrequest_int_0 <= 1'b1;
      rcfg_waitrequest_int_1 <= 1'b1;
    end else begin
      if (rcfg_select[1] == 1'b1) begin
        if (rcfg_waitrequest_s == 1'b0) begin
          rcfg_select <= 2'd0;
          rcfg_read_int <= 1'b0;
          rcfg_write_int <= 1'b0;
          rcfg_address_int <= 10'd0;
          rcfg_writedata_int <= 32'd0;
        end
        rcfg_readdata_int = rcfg_readdata_s;
        rcfg_waitrequest_int_0 <= rcfg_waitrequest_s | rcfg_select[0];
        rcfg_waitrequest_int_1 <= rcfg_waitrequest_s | ~rcfg_select[0];
      end else if ((rcfg_in_read_0 == 1'b1) || (rcfg_in_write_0 == 1'b1)) begin
        rcfg_select <= 2'b10;
        rcfg_read_int <= rcfg_in_read_0;
        rcfg_write_int <= rcfg_in_write_0;
        rcfg_address_int <= rcfg_in_address_0;
        rcfg_writedata_int <= rcfg_in_writedata_0;
        rcfg_readdata_int = 32'd0;
        rcfg_waitrequest_int_0 <= 1'b1;
        rcfg_waitrequest_int_1 <= 1'b1;
      end else if ((rcfg_in_read_1 == 1'b1) || (rcfg_in_write_1 == 1'b1)) begin
        rcfg_select <= 2'b11;
        rcfg_read_int <= rcfg_in_read_1;
        rcfg_write_int <= rcfg_in_write_1;
        rcfg_address_int <= rcfg_in_address_1;
        rcfg_writedata_int <= rcfg_in_writedata_1;
        rcfg_readdata_int = 32'd0;
        rcfg_waitrequest_int_0 <= 1'b1;
        rcfg_waitrequest_int_1 <= 1'b1;
      end else begin
        rcfg_select <= 2'd0;
        rcfg_read_int <= 1'd0;
        rcfg_write_int <= 1'd0;
        rcfg_address_int <= 10'd0;
        rcfg_writedata_int <= 32'd0;
        rcfg_readdata_int = 32'd0;
        rcfg_waitrequest_int_0 <= 1'b1;
        rcfg_waitrequest_int_1 <= 1'b1;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************

