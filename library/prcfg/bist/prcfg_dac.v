
// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
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

`timescale 1ns/1ns

module prcfg_dac(

  clk,

  // control ports
  control,
  status,

  // FIFO interface
  src_dac_en,
  src_dac_ddata,
  src_dac_dunf,
  src_dac_dvalid,

  dst_dac_en,
  dst_dac_ddata,
  dst_dac_dunf,
  dst_dac_dvalid
);

  localparam  RP_ID      = 8'hA1;
  parameter   CHANNEL_ID = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  output            src_dac_en;
  input   [31:0]    src_dac_ddata;
  input             src_dac_dunf;
  input             src_dac_dvalid;

  input             dst_dac_en;
  output  [31:0]    dst_dac_ddata;
  output            dst_dac_dunf;
  output            dst_dac_dvalid;

  reg               dst_dac_dunf   = 0;
  reg     [31:0]    dst_dac_ddata  = 0;
  reg               dst_dac_dvalid = 0;
  reg               src_dac_en     = 0;

  reg     [31:0]    dac_prbs       = 32'hA2F19C;
  reg     [31:0]    status         = 0;

  reg     [ 2:0]    counter        = 0;
  reg               pattern        = 0;
  reg     [15:0]    sin_tone       = 0;
  reg     [15:0]    cos_tone       = 0;

  reg     [ 3:0]    mode;

  wire    [31:0]    dac_pattern_s;

  // prbs function
  function [31:0] pn;
    input [31:0] din;
    reg   [31:0] dout;
    begin
      dout[31]  = din[14] ^ din[13];
      dout[30]  = din[13] ^ din[12];
      dout[29]  = din[12] ^ din[11];
      dout[28]  = din[11] ^ din[10];
      dout[27]  = din[10] ^ din[9];
      dout[26]  = din[9]  ^ din[8];
      dout[25]  = din[8]  ^ din[7];
      dout[24]  = din[7]  ^ din[6];
      dout[23]  = din[6]  ^ din[5];
      dout[22]  = din[5]  ^ din[4];
      dout[21]  = din[4]  ^ din[3];
      dout[20]  = din[3]  ^ din[2];
      dout[19]  = din[2]  ^ din[1];
      dout[18]  = din[1]  ^ din[0];
      dout[17]  = din[0]  ^ din[14] ^ din[13];
      dout[16]  = din[14] ^ din[12];
      dout[15]  = din[13] ^ din[11];
      dout[14]  = din[12] ^ din[10];
      dout[13]  = din[11] ^ din[9];
      dout[12]  = din[10] ^ din[8];
      dout[11]  = din[9]  ^ din[7];
      dout[10]  = din[8]  ^ din[6];
      dout[9]   = din[7]  ^ din[5];
      dout[8]   = din[6]  ^ din[4];
      dout[7]   = din[5]  ^ din[3];
      dout[6]   = din[4]  ^ din[2];
      dout[5]   = din[3]  ^ din[1];
      dout[4]   = din[2]  ^ din[0];
      dout[3]   = din[1]  ^ din[14] ^ din[13];
      dout[2]   = din[0]  ^ din[13] ^ din[12];
      dout[1]   = din[14] ^ din[12] ^ din[13] ^ din[11];
      dout[0]   = din[13] ^ din[11] ^ din[12] ^ din[10];
      pn = dout;
    end
  endfunction

  always @(posedge clk) begin
    status <= {24'h0, RP_ID};
    mode   <= control[7:4];
  end

  // sine tone generation
  always @(posedge clk) begin
    if (dst_dac_en == 1'h1) begin
      counter <= counter + 1;
    end
  end

  always @(counter) begin
    case(counter)
      3'd0  : begin
                sin_tone <= 16'h0000;
                cos_tone <= 16'h7FFF;
              end
      3'd1  : begin
                sin_tone <= 16'h5A82;
                cos_tone <= 16'h5A82;
              end
      3'd2  : begin
                sin_tone <= 16'h7FFF;
                cos_tone <= 16'h0000;
              end
      3'd3  : begin
                sin_tone <= 16'h5A82;
                cos_tone <= 16'hA57E;
              end
      3'd4  : begin
                sin_tone <= 16'h0000;
                cos_tone <= 16'h8001;
              end
      3'd5  : begin
                sin_tone <= 16'hA57E;
                cos_tone <= 16'hA57E;
              end
      3'd6  : begin
                sin_tone <= 16'h8001;
                cos_tone <= 16'h0000;
              end
      3'd7  : begin
                sin_tone <= 16'hA57E;
                cos_tone <= 16'h5A82;
              end
    endcase
  end

  // prbs generation
  always @(posedge clk) begin
    if(dst_dac_en == 1'h1) begin
      dac_prbs <= pn(dac_prbs);
    end
  end

  // constant pattern generator
  always @(posedge clk) begin
    if(dst_dac_en == 1'h1) begin
      pattern <= ~pattern;
    end
  end

  assign dac_pattern_s = (pattern == 1'h1) ?
                          {16'h5555, 16'hAAAA, 16'h5555, 16'hAAAA} :
                          {16'hAAAA, 16'h5555, 16'hAAAA, 16'h5555};

  // output mux for tx side
  always @(posedge clk) begin
    src_dac_en     <= (mode == 0) ? dst_dac_en  : 1'b0;
    dst_dac_dvalid <= (mode == 0) ? src_dac_dvalid  : dst_dac_en;
    dst_dac_dunf   <= (mode == 0) ? src_dac_dunf : 1'b0;
  end

  always @(posedge clk) begin
    case(mode)
      4'h0    : begin
                  dst_dac_ddata <= src_dac_ddata;
                end
      4'h1    : begin
                  dst_dac_ddata <= {cos_tone, sin_tone};
                end
      4'h2    : begin
                  dst_dac_ddata <= dac_prbs;
                end
      4'h3    : begin
                  dst_dac_ddata <= dac_pattern_s;
                end
      default : begin
                  dst_dac_ddata <= src_dac_ddata;
                end
    endcase
  end
endmodule
