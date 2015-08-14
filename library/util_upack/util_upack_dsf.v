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

`timescale 1ns/100ps

module util_upack_dsf (

  // dac interface

  dac_clk,
  dac_valid,
  dac_data,

  // dmx interface

  dac_dmx_enable,
  dac_dsf_valid,
  dac_dsf_sync,
  dac_dsf_data);

  // parameters

  parameter   P_CNT   =  4;
  parameter   M_CNT   =  8;
  parameter   CH_DW   = 32;
  parameter   CH_OCNT =  4;

  localparam  CH_SCNT = CH_DW/16;
  localparam  P_WIDTH = CH_DW*P_CNT;
  localparam  M_WIDTH = CH_DW*M_CNT;
  localparam  O_WIDTH = CH_DW*CH_OCNT;
  localparam  E_WIDTH = CH_DW*(M_CNT+1);
  localparam  CH_DCNT = P_CNT - CH_OCNT;

  // dac interface

  input                     dac_clk;
  input                     dac_valid;
  input   [(P_WIDTH-1):0]   dac_data;

  // dmx interface

  input                     dac_dmx_enable;
  output                    dac_dsf_valid;
  output                    dac_dsf_sync;
  output  [(M_WIDTH-1):0]   dac_dsf_data;

  // internal registers

  reg                       dac_dmx_valid = 'd0;
  reg                       dac_dsf_valid = 'd0;
  reg                       dac_dsf_sync = 'd0;
  reg     [  2:0]           dac_samples_int = 'd0;
  reg                       dac_dmx_valid_d = 'd0;
  reg                       dac_dsf_valid_d = 'd0;
  reg     [  2:0]           dac_samples_int_d = 'd0;
  reg     [(M_WIDTH-1):0]   dac_data_int = 'd0;
  reg     [(M_WIDTH-1):0]   dac_dsf_data_int = 'd0;
  reg     [(M_WIDTH-1):0]   dac_dsf_data = 'd0;

  // internal signals

  wire    [  2:0]           dac_samples_int_s;
  wire    [(E_WIDTH-1):0]   dac_data_s;
  wire    [(E_WIDTH-1):0]   dac_data_int_0_s;
  wire    [(E_WIDTH-1):0]   dac_data_int_1_s;
  wire    [M_WIDTH:0]       dac_dsf_data_s;

  // bypass 

  genvar i;
  generate
  if (CH_OCNT == P_CNT) begin
  for (i = 0; i < CH_SCNT ; i = i +1) begin: g_dsf_data
    assign dac_dsf_data_s[(((i +1) * M_CNT * 16)-1):(i*M_CNT*16)] =
      dac_data[(((i+1)*16*P_CNT)-1): (i*16*P_CNT)];
  end
  end
  endgenerate

  generate
  if (CH_OCNT == P_CNT) begin

  assign dac_samples_int_s = 'd0;
  assign dac_data_s = 'd0;
  assign dac_data_int_0_s = 'd0;
  assign dac_data_int_1_s = 'd0;

  always @(posedge dac_clk) begin
    dac_dmx_valid <= dac_valid & dac_dmx_enable;
    dac_dsf_valid <= dac_valid & dac_dmx_enable;
    dac_dsf_sync <= dac_valid & dac_dmx_enable;
    dac_samples_int <= 'd0;
    dac_dmx_valid_d <= 'd0;
    dac_dsf_valid_d <= 'd0;
    dac_samples_int_d <= 'd0;
    dac_data_int <= 'd0;
    dac_dsf_data_int <= 'd0;
    if (dac_dmx_enable == 1'b1) begin
      dac_dsf_data <= dac_dsf_data_s[(M_WIDTH-1):0];
    end else begin
      dac_dsf_data <= 'd0;
    end
  end
  end
  endgenerate

  // data store & forward

  generate
  if (P_CNT > CH_OCNT) begin

  assign dac_samples_int_s =  (dac_dsf_valid == 1'b1) ? (dac_samples_int + CH_DCNT) :
            ((dac_samples_int >= CH_OCNT) ? (dac_samples_int - CH_OCNT) : dac_samples_int);


  always @(posedge dac_clk) begin
    dac_dmx_valid <= dac_valid & dac_dmx_enable;
    if (dac_samples_int_s < CH_OCNT) begin
      dac_dsf_valid <= dac_valid & dac_dmx_enable;
    end else begin
      dac_dsf_valid <= 1'b0;
    end
    if (dac_samples_int_s == 0) begin
      dac_dsf_sync <= dac_valid & dac_dmx_enable;
    end else begin
      dac_dsf_sync <= 1'b0;
    end
    if (dac_dmx_valid == 1'b1) begin
      dac_samples_int <= dac_samples_int_s;
    end
  end

  assign dac_data_s[(E_WIDTH-1):P_WIDTH] = 'd0;
  assign dac_data_s[(P_WIDTH-1):0] = dac_data;

  assign dac_data_int_0_s[(E_WIDTH-1):(E_WIDTH-P_WIDTH)] = dac_data;
  assign dac_data_int_0_s[((E_WIDTH-P_WIDTH)-1):0] =
            dac_data_int[(M_WIDTH-1):(M_WIDTH-(E_WIDTH-P_WIDTH))];

  assign dac_data_int_1_s[(E_WIDTH-1):(E_WIDTH-(M_WIDTH-O_WIDTH))] =
            dac_data_int[(M_WIDTH-1):O_WIDTH];
  assign dac_data_int_1_s[((E_WIDTH-(M_WIDTH-O_WIDTH))-1):0] = 'd0;

  always @(posedge dac_clk) begin
    dac_dmx_valid_d <= dac_dmx_valid;
    dac_dsf_valid_d <= dac_dsf_valid;
    dac_samples_int_d <= dac_samples_int;
    if (dac_dsf_valid_d == 1'b1) begin
      dac_data_int <= dac_data_int_0_s[(E_WIDTH-1):(E_WIDTH-M_WIDTH)];
    end else if (dac_dmx_valid_d == 1'b1) begin
      dac_data_int <= dac_data_int_1_s[(E_WIDTH-1):(E_WIDTH-M_WIDTH)];
    end
  end

  always @(posedge dac_clk) begin
    if (dac_dmx_valid_d == 1'b1) begin
      case (dac_samples_int_d)
        3'b111: dac_dsf_data_int <= { dac_data_s[((CH_DW*1)-1):0],
                                      dac_data_int[((CH_DW*8)-1):(CH_DW*1)]};
        3'b110: dac_dsf_data_int <= { dac_data_s[((CH_DW*2)-1):0],
                                      dac_data_int[((CH_DW*8)-1):(CH_DW*2)]};
        3'b101: dac_dsf_data_int <= { dac_data_s[((CH_DW*3)-1):0],
                                      dac_data_int[((CH_DW*8)-1):(CH_DW*3)]};
        3'b100: dac_dsf_data_int <= { dac_data_s[((CH_DW*4)-1):0],
                                      dac_data_int[((CH_DW*8)-1):(CH_DW*4)]};
        3'b011: dac_dsf_data_int <= { dac_data_s[((CH_DW*5)-1):0],
                                      dac_data_int[((CH_DW*8)-1):(CH_DW*5)]};
        3'b010: dac_dsf_data_int <= { dac_data_s[((CH_DW*6)-1):0],
                                      dac_data_int[((CH_DW*8)-1):(CH_DW*6)]};
        3'b001: dac_dsf_data_int <= { dac_data_s[((CH_DW*7)-1):0],
                                      dac_data_int[((CH_DW*8)-1):(CH_DW*7)]};
        3'b000: dac_dsf_data_int <= dac_data_s;
        default: dac_dsf_data_int <= 'd0;
      endcase
    end
  end
  end
  endgenerate

  genvar n;
  generate
  if (P_CNT > CH_OCNT) begin
  assign dac_dsf_data_s[M_WIDTH] = 'd0;
  for (n = 0; n < CH_SCNT; n = n + 1) begin: g_out
  assign dac_dsf_data_s[(((n+1)*M_CNT*16)-1):(((n*M_CNT)+CH_OCNT)*16)] = 'd0;
  assign dac_dsf_data_s[((((n*M_CNT)+CH_OCNT)*16)-1):(n*M_CNT*16)] =
    dac_dsf_data_int[(((n+1)*CH_OCNT*16)-1):(n*CH_OCNT*16)];
  end
  end
  endgenerate

  generate
  if (P_CNT > CH_OCNT) begin
  always @(posedge dac_clk) begin
    if (dac_dmx_enable == 1'b1) begin
      dac_dsf_data <= dac_dsf_data_s[(M_WIDTH-1):0];
    end else begin
      dac_dsf_data <= 'd0;
    end
  end
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
