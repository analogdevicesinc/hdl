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

`timescale 1ns/100ps

module util_adc_pack (

  clk,

  chan_data_0,
  chan_data_1,
  chan_data_2,
  chan_data_3,
  chan_enable_0,
  chan_enable_1,
  chan_enable_2,
  chan_enable_3,
  chan_valid_0,
  chan_valid_1,
  chan_valid_2,
  chan_valid_3,

  ddata,
  dvalid,
  dsync

  );

  // common clock

  input           clk;

  input   [15:0]  chan_data_0;
  input   [15:0]  chan_data_1;
  input   [15:0]  chan_data_2;
  input   [15:0]  chan_data_3;
  input           chan_enable_0;
  input           chan_enable_1;
  input           chan_enable_2;
  input           chan_enable_3;
  input           chan_valid_0;
  input           chan_valid_1;
  input           chan_valid_2;
  input           chan_valid_3;

  output  [63:0]  ddata;
  output          dvalid;
  output          dsync;

  reg     [47:0]  adc_data_3_1110 = 'd0;
  reg     [47:0]  adc_data_3_1101 = 'd0;
  reg     [47:0]  adc_data_3_1011 = 'd0;
  reg     [47:0]  adc_data_3_0111 = 'd0;
  reg             adc_iqcor_valid = 'd0;
  reg             adc_iqcor_valid_3 = 'd0;
  reg             adc_iqcor_sync = 'd0;
  reg             adc_iqcor_sync_3 = 'd0;
  reg     [63:0]  adc_data = 'd0;
  reg     [63:0]  adc_data_1110 = 'd0;
  reg     [63:0]  adc_data_1101 = 'd0;
  reg     [63:0]  adc_data_1011 = 'd0;
  reg     [63:0]  adc_data_0111 = 'd0;
  reg     [ 1:0]  adc_data_cnt = 'd0;

  wire            valid;

  assign dsync  = adc_iqcor_sync;
  assign dvalid = adc_iqcor_valid;
  assign ddata  = adc_data;

  assign valid = chan_valid_0 & chan_valid_1 & chan_valid_2 & chan_valid_3;

   always @(posedge clk) begin
    if (valid == 1'b1) begin
      adc_iqcor_valid_3 <= adc_data_cnt[0] | adc_data_cnt[1];
      adc_iqcor_sync_3 <= adc_data_cnt[0] & ~adc_data_cnt[1];
      adc_data_3_1110[47:32] <= chan_data_3;
      adc_data_3_1110[31:16] <= chan_data_2;
      adc_data_3_1110[15: 0] <= chan_data_1;
      adc_data_3_1101[47:32] <= chan_data_3;
      adc_data_3_1101[31:16] <= chan_data_2;
      adc_data_3_1101[15: 0] <= chan_data_0;
      adc_data_3_1011[47:32] <= chan_data_3;
      adc_data_3_1011[31:16] <= chan_data_1;
      adc_data_3_1011[15: 0] <= chan_data_0;
      adc_data_3_0111[47:32] <= chan_data_2;
      adc_data_3_0111[31:16] <= chan_data_1;
      adc_data_3_0111[15: 0] <= chan_data_0;
      case (adc_data_cnt)
        2'b11: begin
          adc_data_1110[63:48] <= chan_data_3;
          adc_data_1110[47:32] <= chan_data_2;
          adc_data_1110[31:16] <= chan_data_1;
          adc_data_1110[15: 0] <= adc_data_3_1110[47:32];
          adc_data_1101[63:48] <= chan_data_3;
          adc_data_1101[47:32] <= chan_data_2;
          adc_data_1101[31:16] <= chan_data_0;
          adc_data_1101[15: 0] <= adc_data_3_1101[47:32];
          adc_data_1011[63:48] <= chan_data_3;
          adc_data_1011[47:32] <= chan_data_1;
          adc_data_1011[31:16] <= chan_data_0;
          adc_data_1011[15: 0] <= adc_data_3_1011[47:32];
          adc_data_0111[63:48] <= chan_data_2;
          adc_data_0111[47:32] <= chan_data_1;
          adc_data_0111[31:16] <= chan_data_0;
          adc_data_0111[15: 0] <= adc_data_3_0111[47:32];
        end
        2'b10: begin
          adc_data_1110[63:48] <= chan_data_2;
          adc_data_1110[47:32] <= chan_data_1;
          adc_data_1110[31:16] <= adc_data_3_1110[47:32];
          adc_data_1110[15: 0] <= adc_data_3_1110[31:16];
          adc_data_1101[63:48] <= chan_data_2;
          adc_data_1101[47:32] <= chan_data_0;
          adc_data_1101[31:16] <= adc_data_3_1101[47:32];
          adc_data_1101[15: 0] <= adc_data_3_1101[31:16];
          adc_data_1011[63:48] <= chan_data_1;
          adc_data_1011[47:32] <= chan_data_0;
          adc_data_1011[31:16] <= adc_data_3_1011[47:32];
          adc_data_1011[15: 0] <= adc_data_3_1011[31:16];
          adc_data_0111[63:48] <= chan_data_1;
          adc_data_0111[47:32] <= chan_data_0;
          adc_data_0111[31:16] <= adc_data_3_0111[47:32];
          adc_data_0111[15: 0] <= adc_data_3_0111[31:16];
        end
        2'b01: begin
          adc_data_1110[63:48] <= chan_data_1;
          adc_data_1110[47:32] <= adc_data_3_1110[47:32];
          adc_data_1110[31:16] <= adc_data_3_1110[31:16];
          adc_data_1110[15: 0] <= adc_data_3_1110[15: 0];
          adc_data_1101[63:48] <= chan_data_0;
          adc_data_1101[47:32] <= adc_data_3_1101[47:32];
          adc_data_1101[31:16] <= adc_data_3_1101[31:16];
          adc_data_1101[15: 0] <= adc_data_3_1101[15: 0];
          adc_data_1011[63:48] <= chan_data_0;
          adc_data_1011[47:32] <= adc_data_3_1011[47:32];
          adc_data_1011[31:16] <= adc_data_3_1011[31:16];
          adc_data_1011[15: 0] <= adc_data_3_1011[15: 0];
          adc_data_0111[63:48] <= chan_data_0;
          adc_data_0111[47:32] <= adc_data_3_0111[47:32];
          adc_data_0111[31:16] <= adc_data_3_0111[31:16];
          adc_data_0111[15: 0] <= adc_data_3_0111[15: 0];
        end
        default:begin
          adc_data_1110[63:48] <= 16'hdead;
          adc_data_1110[47:32] <= 16'hdead;
          adc_data_1110[31:16] <= 16'hdead;
          adc_data_1110[15: 0] <= 16'hdead;
          adc_data_1101[63:48] <= 16'hdead;
          adc_data_1101[47:32] <= 16'hdead;
          adc_data_1101[31:16] <= 16'hdead;
          adc_data_1101[15: 0] <= 16'hdead;
          adc_data_1011[63:48] <= 16'hdead;
          adc_data_1011[47:32] <= 16'hdead;
          adc_data_1011[31:16] <= 16'hdead;
          adc_data_1011[15: 0] <= 16'hdead;
          adc_data_0111[63:48] <= 16'hdead;
          adc_data_0111[47:32] <= 16'hdead;
          adc_data_0111[31:16] <= 16'hdead;
          adc_data_0111[15: 0] <= 16'hdead;
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (valid == 1'b1) begin
      case ({chan_enable_3, chan_enable_2, chan_enable_1, chan_enable_0})
        4'b1111: begin
          adc_iqcor_valid <= 1'b1;
          adc_iqcor_sync  <= 1'b1;
          adc_data[63:48] <= chan_data_3;
          adc_data[47:32] <= chan_data_2;
          adc_data[31:16] <= chan_data_1;
          adc_data[15: 0] <= chan_data_0;
        end
        4'b1110: begin
          adc_iqcor_sync  <= adc_iqcor_sync_3;
          adc_iqcor_valid <= adc_iqcor_valid_3;
          adc_data        <= adc_data_1110;
        end
        4'b1101: begin
          adc_iqcor_sync  <= adc_iqcor_sync_3;
          adc_iqcor_valid <= adc_iqcor_valid_3;
          adc_data        <= adc_data_1101;
        end
        4'b1100: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[0];
          adc_data[63:48] <= chan_data_3;
          adc_data[47:32] <= chan_data_2;
          adc_data[31:16] <= adc_data[63:48];
          adc_data[15: 0] <= adc_data[47:32];
        end
        4'b1011: begin
          adc_iqcor_sync  <= adc_iqcor_sync_3;
          adc_iqcor_valid <= adc_iqcor_valid_3;
          adc_data        <= adc_data_1011;
        end
        4'b1010: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[0];
          adc_data[63:48] <= chan_data_3;
          adc_data[47:32] <= chan_data_1;
          adc_data[31:16] <= adc_data[63:48];
          adc_data[15: 0] <= adc_data[47:32];
        end
        4'b1001: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[0];
          adc_data[63:48] <= chan_data_3;
          adc_data[47:32] <= chan_data_0;
          adc_data[31:16] <= adc_data[63:48];
          adc_data[15: 0] <= adc_data[47:32];
        end
        4'b1000: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[1] & adc_data_cnt[0];
          adc_data[63:48] <= chan_data_3;
          adc_data[47:32] <= adc_data[63:48];
          adc_data[31:16] <= adc_data[47:32];
          adc_data[15: 0] <= adc_data[31:16];
        end
        4'b0111: begin
          adc_iqcor_sync  <= adc_iqcor_sync_3;
          adc_iqcor_valid <= adc_iqcor_valid_3;
          adc_data        <= adc_data_0111;
        end
        4'b0110: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[0];
          adc_data[63:48] <= chan_data_2;
          adc_data[47:32] <= chan_data_1;
          adc_data[31:16] <= adc_data[63:48];
          adc_data[15: 0] <= adc_data[47:32];
        end
        4'b0101: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[0];
          adc_data[63:48] <= chan_data_2;
          adc_data[47:32] <= chan_data_0;
          adc_data[31:16] <= adc_data[63:48];
          adc_data[15: 0] <= adc_data[47:32];
        end
        4'b0100: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[1] & adc_data_cnt[0];
          adc_data[63:48] <= chan_data_2;
          adc_data[47:32] <= adc_data[63:48];
          adc_data[31:16] <= adc_data[47:32];
          adc_data[15: 0] <= adc_data[31:16];
        end
        4'b0011: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[0];
          adc_data[63:48] <= chan_data_1;
          adc_data[47:32] <= chan_data_0;
          adc_data[31:16] <= adc_data[63:48];
          adc_data[15: 0] <= adc_data[47:32];
        end
        4'b0010: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[1] & adc_data_cnt[0];
          adc_data[63:48] <= chan_data_1;
          adc_data[47:32] <= adc_data[63:48];
          adc_data[31:16] <= adc_data[47:32];
          adc_data[15: 0] <= adc_data[31:16];
        end
        4'b0001: begin
          adc_iqcor_sync  <= 1'b1;
          adc_iqcor_valid <= adc_data_cnt[1] & adc_data_cnt[0];
          adc_data[63:48] <= chan_data_0;
          adc_data[47:32] <= adc_data[63:48];
          adc_data[31:16] <= adc_data[47:32];
          adc_data[15: 0] <= adc_data[31:16];
        end
        default: begin
          adc_iqcor_valid <= 1'b1;
          adc_data[63:48] <= 16'hdead;
          adc_data[47:32] <= 16'hdead;
          adc_data[31:16] <= 16'hdead;
          adc_data[15: 0] <= 16'hdead;
        end
      endcase
      adc_data_cnt <= adc_data_cnt + 1'b1;
    end else begin
      adc_iqcor_valid <= 1'b0;
      adc_data        <= adc_data;
      adc_data_cnt    <= adc_data_cnt;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
