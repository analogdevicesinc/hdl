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
  input   [11:0]  rcfg_in_address_0,
  input   [31:0]  rcfg_in_writedata_0,
  output  [31:0]  rcfg_in_readdata_0,
  output          rcfg_in_waitrequest_0,

  output          rcfg_out_read_0,
  output          rcfg_out_write_0,
  output  [11:0]  rcfg_out_address_0,
  output  [31:0]  rcfg_out_writedata_0,
  input   [31:0]  rcfg_out_readdata_0,
  input           rcfg_out_waitrequest_0,

  input           rcfg_in_read_1,
  input           rcfg_in_write_1,
  input   [11:0]  rcfg_in_address_1,
  input   [31:0]  rcfg_in_writedata_1,
  output  [31:0]  rcfg_in_readdata_1,
  output          rcfg_in_waitrequest_1,

  output          rcfg_out_read_1,
  output          rcfg_out_write_1,
  output  [11:0]  rcfg_out_address_1,
  output  [31:0]  rcfg_out_writedata_1,
  input   [31:0]  rcfg_out_readdata_1,
  input           rcfg_out_waitrequest_1,

  input           rcfg_in_read_2,
  input           rcfg_in_write_2,
  input   [11:0]  rcfg_in_address_2,
  input   [31:0]  rcfg_in_writedata_2,
  output  [31:0]  rcfg_in_readdata_2,
  output          rcfg_in_waitrequest_2,

  output          rcfg_out_read_2,
  output          rcfg_out_write_2,
  output  [11:0]  rcfg_out_address_2,
  output  [31:0]  rcfg_out_writedata_2,
  input   [31:0]  rcfg_out_readdata_2,
  input           rcfg_out_waitrequest_2,

  input           rcfg_in_read_3,
  input           rcfg_in_write_3,
  input   [11:0]  rcfg_in_address_3,
  input   [31:0]  rcfg_in_writedata_3,
  output  [31:0]  rcfg_in_readdata_3,
  output          rcfg_in_waitrequest_3,

  output          rcfg_out_read_3,
  output          rcfg_out_write_3,
  output  [11:0]  rcfg_out_address_3,
  output  [31:0]  rcfg_out_writedata_3,
  input   [31:0]  rcfg_out_readdata_3,
  input           rcfg_out_waitrequest_3,

  input           rcfg_in_read_4,
  input           rcfg_in_write_4,
  input   [11:0]  rcfg_in_address_4,
  input   [31:0]  rcfg_in_writedata_4,
  output  [31:0]  rcfg_in_readdata_4,
  output          rcfg_in_waitrequest_4,

  output          rcfg_out_read_4,
  output          rcfg_out_write_4,
  output  [11:0]  rcfg_out_address_4,
  output  [31:0]  rcfg_out_writedata_4,
  input   [31:0]  rcfg_out_readdata_4,
  input           rcfg_out_waitrequest_4,

  input           rcfg_in_read_5,
  input           rcfg_in_write_5,
  input   [11:0]  rcfg_in_address_5,
  input   [31:0]  rcfg_in_writedata_5,
  output  [31:0]  rcfg_in_readdata_5,
  output          rcfg_in_waitrequest_5,

  output          rcfg_out_read_5,
  output          rcfg_out_write_5,
  output  [11:0]  rcfg_out_address_5,
  output  [31:0]  rcfg_out_writedata_5,
  input   [31:0]  rcfg_out_readdata_5,
  input           rcfg_out_waitrequest_5,

  input           rcfg_in_read_6,
  input           rcfg_in_write_6,
  input   [11:0]  rcfg_in_address_6,
  input   [31:0]  rcfg_in_writedata_6,
  output  [31:0]  rcfg_in_readdata_6,
  output          rcfg_in_waitrequest_6,

  output          rcfg_out_read_6,
  output          rcfg_out_write_6,
  output  [11:0]  rcfg_out_address_6,
  output  [31:0]  rcfg_out_writedata_6,
  input   [31:0]  rcfg_out_readdata_6,
  input           rcfg_out_waitrequest_6,

  input           rcfg_in_read_7,
  input           rcfg_in_write_7,
  input   [11:0]  rcfg_in_address_7,
  input   [31:0]  rcfg_in_writedata_7,
  output  [31:0]  rcfg_in_readdata_7,
  output          rcfg_in_waitrequest_7,

  output          rcfg_out_read_7,
  output          rcfg_out_write_7,
  output  [11:0]  rcfg_out_address_7,
  output  [31:0]  rcfg_out_writedata_7,
  input   [31:0]  rcfg_out_readdata_7,
  input           rcfg_out_waitrequest_7);

  // internal registers

  reg     [11:0]  rcfg_out_address = 'd0;
  reg     [31:0]  rcfg_out_writedata = 'd0;
  reg             rcfg_out_iread_0 = 'd0;
  reg             rcfg_out_iwrite_0 = 'd0;
  reg     [31:0]  rcfg_in_ireaddata_0 = 'd0;
  reg             rcfg_in_iwaitrequest_0 = 'd0;
  reg             rcfg_out_iread_1 = 'd0;
  reg             rcfg_out_iwrite_1 = 'd0;
  reg     [31:0]  rcfg_in_ireaddata_1 = 'd0;
  reg             rcfg_in_iwaitrequest_1 = 'd0;
  reg             rcfg_out_iread_2 = 'd0;
  reg             rcfg_out_iwrite_2 = 'd0;
  reg     [31:0]  rcfg_in_ireaddata_2 = 'd0;
  reg             rcfg_in_iwaitrequest_2 = 'd0;
  reg             rcfg_out_iread_3 = 'd0;
  reg             rcfg_out_iwrite_3 = 'd0;
  reg     [31:0]  rcfg_in_ireaddata_3 = 'd0;
  reg             rcfg_in_iwaitrequest_3 = 'd0;
  reg             rcfg_out_iread_4 = 'd0;
  reg             rcfg_out_iwrite_4 = 'd0;
  reg     [31:0]  rcfg_in_ireaddata_4 = 'd0;
  reg             rcfg_in_iwaitrequest_4 = 'd0;
  reg             rcfg_out_iread_5 = 'd0;
  reg             rcfg_out_iwrite_5 = 'd0;
  reg     [31:0]  rcfg_in_ireaddata_5 = 'd0;
  reg             rcfg_in_iwaitrequest_5 = 'd0;
  reg             rcfg_out_iread_6 = 'd0;
  reg             rcfg_out_iwrite_6 = 'd0;
  reg     [31:0]  rcfg_in_ireaddata_6 = 'd0;
  reg             rcfg_in_iwaitrequest_6 = 'd0;
  reg             rcfg_out_iread_7 = 'd0;
  reg             rcfg_out_iwrite_7 = 'd0;
  reg     [31:0]  rcfg_in_ireaddata_7 = 'd0;
  reg             rcfg_in_iwaitrequest_7 = 'd0;
  reg     [ 3:0]  rcfg_select = 'd0;

  // internal signals

  wire            rcfg_in_req_0_s;
  wire            rcfg_in_req_1_s;
  wire            rcfg_in_req_2_s;
  wire            rcfg_in_req_3_s;
  wire            rcfg_in_req_4_s;
  wire            rcfg_in_req_5_s;
  wire            rcfg_in_req_6_s;
  wire            rcfg_in_req_7_s;

  // xcvr sharing requires same bus with ONLY different write/read signals

  assign rcfg_out_address_0 = rcfg_out_address;
  assign rcfg_out_writedata_0 = rcfg_out_writedata;
  assign rcfg_out_address_1 = rcfg_out_address;
  assign rcfg_out_writedata_1 = rcfg_out_writedata;
  assign rcfg_out_address_2 = rcfg_out_address;
  assign rcfg_out_writedata_2 = rcfg_out_writedata;
  assign rcfg_out_address_3 = rcfg_out_address;
  assign rcfg_out_writedata_3 = rcfg_out_writedata;
  assign rcfg_out_address_4 = rcfg_out_address;
  assign rcfg_out_writedata_4 = rcfg_out_writedata;
  assign rcfg_out_address_5 = rcfg_out_address;
  assign rcfg_out_writedata_5 = rcfg_out_writedata;
  assign rcfg_out_address_6 = rcfg_out_address;
  assign rcfg_out_writedata_6 = rcfg_out_writedata;
  assign rcfg_out_address_7 = rcfg_out_address;
  assign rcfg_out_writedata_7 = rcfg_out_writedata;

  always @(negedge rcfg_reset_n or posedge rcfg_clk) begin
    if (rcfg_reset_n == 0) begin
      rcfg_out_address <= 12'd0;
      rcfg_out_writedata <= 32'd0;
    end else begin
      case (rcfg_select)
        4'h8: begin
          rcfg_out_address <= rcfg_in_address_0;
          rcfg_out_writedata <= rcfg_in_writedata_0;
        end
        4'h9: begin
          rcfg_out_address <= rcfg_in_address_1;
          rcfg_out_writedata <= rcfg_in_writedata_1;
        end
        4'ha: begin
          rcfg_out_address <= rcfg_in_address_2;
          rcfg_out_writedata <= rcfg_in_writedata_2;
        end
        4'hb: begin
          rcfg_out_address <= rcfg_in_address_3;
          rcfg_out_writedata <= rcfg_in_writedata_3;
        end
        4'hc: begin
          rcfg_out_address <= rcfg_in_address_4;
          rcfg_out_writedata <= rcfg_in_writedata_4;
        end
        4'hd: begin
          rcfg_out_address <= rcfg_in_address_5;
          rcfg_out_writedata <= rcfg_in_writedata_5;
        end
        4'he: begin
          rcfg_out_address <= rcfg_in_address_6;
          rcfg_out_writedata <= rcfg_in_writedata_6;
        end
        4'hf: begin
          rcfg_out_address <= rcfg_in_address_7;
          rcfg_out_writedata <= rcfg_in_writedata_7;
        end
        default: begin
          rcfg_out_address <= 12'd0;
          rcfg_out_writedata <= 32'd0;
        end
      endcase
    end
  end

  assign rcfg_out_read_0 = rcfg_out_iread_0;
  assign rcfg_out_write_0 = rcfg_out_iwrite_0;
  assign rcfg_in_readdata_0 = rcfg_in_ireaddata_0;
  assign rcfg_in_waitrequest_0 = rcfg_in_iwaitrequest_0;
  assign rcfg_out_read_1 = rcfg_out_iread_1;
  assign rcfg_out_write_1 = rcfg_out_iwrite_1;
  assign rcfg_in_readdata_1 = rcfg_in_ireaddata_1;
  assign rcfg_in_waitrequest_1 = rcfg_in_iwaitrequest_1;
  assign rcfg_out_read_2 = rcfg_out_iread_2;
  assign rcfg_out_write_2 = rcfg_out_iwrite_2;
  assign rcfg_in_readdata_2 = rcfg_in_ireaddata_2;
  assign rcfg_in_waitrequest_2 = rcfg_in_iwaitrequest_2;
  assign rcfg_out_read_3 = rcfg_out_iread_3;
  assign rcfg_out_write_3 = rcfg_out_iwrite_3;
  assign rcfg_in_readdata_3 = rcfg_in_ireaddata_3;
  assign rcfg_in_waitrequest_3 = rcfg_in_iwaitrequest_3;
  assign rcfg_out_read_4 = rcfg_out_iread_4;
  assign rcfg_out_write_4 = rcfg_out_iwrite_4;
  assign rcfg_in_readdata_4 = rcfg_in_ireaddata_4;
  assign rcfg_in_waitrequest_4 = rcfg_in_iwaitrequest_4;
  assign rcfg_out_read_5 = rcfg_out_iread_5;
  assign rcfg_out_write_5 = rcfg_out_iwrite_5;
  assign rcfg_in_readdata_5 = rcfg_in_ireaddata_5;
  assign rcfg_in_waitrequest_5 = rcfg_in_iwaitrequest_5;
  assign rcfg_out_read_6 = rcfg_out_iread_6;
  assign rcfg_out_write_6 = rcfg_out_iwrite_6;
  assign rcfg_in_readdata_6 = rcfg_in_ireaddata_6;
  assign rcfg_in_waitrequest_6 = rcfg_in_iwaitrequest_6;
  assign rcfg_out_read_7 = rcfg_out_iread_7;
  assign rcfg_out_write_7 = rcfg_out_iwrite_7;
  assign rcfg_in_readdata_7 = rcfg_in_ireaddata_7;
  assign rcfg_in_waitrequest_7 = rcfg_in_iwaitrequest_7;

  always @(negedge rcfg_reset_n or posedge rcfg_clk) begin
    if (rcfg_reset_n == 0) begin
      rcfg_out_iread_0 <= 1'd0;
      rcfg_out_iwrite_0 <= 1'd0;
      rcfg_in_ireaddata_0 <= 32'd0;
      rcfg_in_iwaitrequest_0 <= 1'd1;
      rcfg_out_iread_1 <= 1'd0;
      rcfg_out_iwrite_1 <= 1'd0;
      rcfg_in_ireaddata_1 <= 32'd0;
      rcfg_in_iwaitrequest_1 <= 1'd1;
      rcfg_out_iread_2 <= 1'd0;
      rcfg_out_iwrite_2 <= 1'd0;
      rcfg_in_ireaddata_2 <= 32'd0;
      rcfg_in_iwaitrequest_2 <= 1'd1;
      rcfg_out_iread_3 <= 1'd0;
      rcfg_out_iwrite_3 <= 1'd0;
      rcfg_in_ireaddata_3 <= 32'd0;
      rcfg_in_iwaitrequest_3 <= 1'd1;
      rcfg_out_iread_4 <= 1'd0;
      rcfg_out_iwrite_4 <= 1'd0;
      rcfg_in_ireaddata_4 <= 32'd0;
      rcfg_in_iwaitrequest_4 <= 1'd1;
      rcfg_out_iread_5 <= 1'd0;
      rcfg_out_iwrite_5 <= 1'd0;
      rcfg_in_ireaddata_5 <= 32'd0;
      rcfg_in_iwaitrequest_5 <= 1'd1;
      rcfg_out_iread_6 <= 1'd0;
      rcfg_out_iwrite_6 <= 1'd0;
      rcfg_in_ireaddata_6 <= 32'd0;
      rcfg_in_iwaitrequest_6 <= 1'd1;
      rcfg_out_iread_7 <= 1'd0;
      rcfg_out_iwrite_7 <= 1'd0;
      rcfg_in_ireaddata_7 <= 32'd0;
      rcfg_in_iwaitrequest_7 <= 1'd1;
    end else begin
      if (rcfg_select == 4'h8) begin
        rcfg_out_iread_0 <= rcfg_in_read_0;
        rcfg_out_iwrite_0 <= rcfg_in_write_0;
        rcfg_in_ireaddata_0 <= rcfg_out_readdata_0;
        rcfg_in_iwaitrequest_0 <= rcfg_out_waitrequest_0 | ~rcfg_in_req_0_s;
      end else begin
        rcfg_out_iread_0 <= 1'd0;
        rcfg_out_iwrite_0 <= 1'd0;
        rcfg_in_ireaddata_0 <= 32'd0;
        rcfg_in_iwaitrequest_0 <= 1'd1;
      end
      if (rcfg_select == 4'h9) begin
        rcfg_out_iread_1 <= rcfg_in_read_1;
        rcfg_out_iwrite_1 <= rcfg_in_write_1;
        rcfg_in_ireaddata_1 <= rcfg_out_readdata_1;
        rcfg_in_iwaitrequest_1 <= rcfg_out_waitrequest_1 | ~rcfg_in_req_1_s;
      end else begin
        rcfg_out_iread_1 <= 1'd0;
        rcfg_out_iwrite_1 <= 1'd0;
        rcfg_in_ireaddata_1 <= 32'd0;
        rcfg_in_iwaitrequest_1 <= 1'd1;
      end
      if (rcfg_select == 4'ha) begin
        rcfg_out_iread_2 <= rcfg_in_read_2;
        rcfg_out_iwrite_2 <= rcfg_in_write_2;
        rcfg_in_ireaddata_2 <= rcfg_out_readdata_2;
        rcfg_in_iwaitrequest_2 <= rcfg_out_waitrequest_2 | ~rcfg_in_req_2_s;
      end else begin
        rcfg_out_iread_2 <= 1'd0;
        rcfg_out_iwrite_2 <= 1'd0;
        rcfg_in_ireaddata_2 <= 32'd0;
        rcfg_in_iwaitrequest_2 <= 1'd1;
      end
      if (rcfg_select == 4'hb) begin
        rcfg_out_iread_3 <= rcfg_in_read_3;
        rcfg_out_iwrite_3 <= rcfg_in_write_3;
        rcfg_in_ireaddata_3 <= rcfg_out_readdata_3;
        rcfg_in_iwaitrequest_3 <= rcfg_out_waitrequest_3 | ~rcfg_in_req_3_s;
      end else begin
        rcfg_out_iread_3 <= 1'd0;
        rcfg_out_iwrite_3 <= 1'd0;
        rcfg_in_ireaddata_3 <= 32'd0;
        rcfg_in_iwaitrequest_3 <= 1'd1;
      end
      if (rcfg_select == 4'hc) begin
        rcfg_out_iread_4 <= rcfg_in_read_4;
        rcfg_out_iwrite_4 <= rcfg_in_write_4;
        rcfg_in_ireaddata_4 <= rcfg_out_readdata_4;
        rcfg_in_iwaitrequest_4 <= rcfg_out_waitrequest_4 | ~rcfg_in_req_4_s;
      end else begin
        rcfg_out_iread_4 <= 1'd0;
        rcfg_out_iwrite_4 <= 1'd0;
        rcfg_in_ireaddata_4 <= 32'd0;
        rcfg_in_iwaitrequest_4 <= 1'd1;
      end
      if (rcfg_select == 4'hd) begin
        rcfg_out_iread_5 <= rcfg_in_read_5;
        rcfg_out_iwrite_5 <= rcfg_in_write_5;
        rcfg_in_ireaddata_5 <= rcfg_out_readdata_5;
        rcfg_in_iwaitrequest_5 <= rcfg_out_waitrequest_5 | ~rcfg_in_req_5_s;
      end else begin
        rcfg_out_iread_5 <= 1'd0;
        rcfg_out_iwrite_5 <= 1'd0;
        rcfg_in_ireaddata_5 <= 32'd0;
        rcfg_in_iwaitrequest_5 <= 1'd1;
      end
      if (rcfg_select == 4'he) begin
        rcfg_out_iread_6 <= rcfg_in_read_6;
        rcfg_out_iwrite_6 <= rcfg_in_write_6;
        rcfg_in_ireaddata_6 <= rcfg_out_readdata_6;
        rcfg_in_iwaitrequest_6 <= rcfg_out_waitrequest_6 | ~rcfg_in_req_6_s;
      end else begin
        rcfg_out_iread_6 <= 1'd0;
        rcfg_out_iwrite_6 <= 1'd0;
        rcfg_in_ireaddata_6 <= 32'd0;
        rcfg_in_iwaitrequest_6 <= 1'd1;
      end
      if (rcfg_select == 4'hf) begin
        rcfg_out_iread_7 <= rcfg_in_read_7;
        rcfg_out_iwrite_7 <= rcfg_in_write_7;
        rcfg_in_ireaddata_7 <= rcfg_out_readdata_7;
        rcfg_in_iwaitrequest_7 <= rcfg_out_waitrequest_7 | ~rcfg_in_req_7_s;
      end else begin
        rcfg_out_iread_7 <= 1'd0;
        rcfg_out_iwrite_7 <= 1'd0;
        rcfg_in_ireaddata_7 <= 32'd0;
        rcfg_in_iwaitrequest_7 <= 1'd1;
      end
    end
  end

  assign rcfg_in_req_0_s = rcfg_in_read_0 | rcfg_in_write_0;
  assign rcfg_in_req_1_s = rcfg_in_read_1 | rcfg_in_write_1;
  assign rcfg_in_req_2_s = rcfg_in_read_2 | rcfg_in_write_2;
  assign rcfg_in_req_3_s = rcfg_in_read_3 | rcfg_in_write_3;
  assign rcfg_in_req_4_s = rcfg_in_read_4 | rcfg_in_write_4;
  assign rcfg_in_req_5_s = rcfg_in_read_5 | rcfg_in_write_5;
  assign rcfg_in_req_6_s = rcfg_in_read_6 | rcfg_in_write_6;
  assign rcfg_in_req_7_s = rcfg_in_read_7 | rcfg_in_write_7;

  always @(negedge rcfg_reset_n or posedge rcfg_clk) begin
    if (rcfg_reset_n == 0) begin
      rcfg_select <= 4'h0;
    end else begin
      case (rcfg_select)
        4'h8: begin
          if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
        4'h9: begin
          if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
        4'ha: begin
          if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
        4'hb: begin
          if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
        4'hc: begin
          if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
        4'hd: begin
          if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
        4'he: begin
          if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
        4'hf: begin
          if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
        default: begin
          if (rcfg_in_req_0_s == 1'b1) begin
            rcfg_select <= 4'h8;
          end else if (rcfg_in_req_1_s == 1'b1) begin
            rcfg_select <= 4'h9;
          end else if (rcfg_in_req_2_s == 1'b1) begin
            rcfg_select <= 4'ha;
          end else if (rcfg_in_req_3_s == 1'b1) begin
            rcfg_select <= 4'hb;
          end else if (rcfg_in_req_4_s == 1'b1) begin
            rcfg_select <= 4'hc;
          end else if (rcfg_in_req_5_s == 1'b1) begin
            rcfg_select <= 4'hd;
          end else if (rcfg_in_req_6_s == 1'b1) begin
            rcfg_select <= 4'he;
          end else if (rcfg_in_req_7_s == 1'b1) begin
            rcfg_select <= 4'hf;
          end else begin
            rcfg_select <= 4'h0;
          end
        end
      endcase
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************

