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

`timescale 1ns/100ps

module util_cpack (

  // adc interface

  adc_rst,
  adc_clk,
  adc_enable_0,
  adc_valid_0,
  adc_data_0,
  adc_enable_1,
  adc_valid_1,
  adc_data_1,
  adc_enable_2,
  adc_valid_2,
  adc_data_2,
  adc_enable_3,
  adc_valid_3,
  adc_data_3,
  adc_enable_4,
  adc_valid_4,
  adc_data_4,
  adc_enable_5,
  adc_valid_5,
  adc_data_5,
  adc_enable_6,
  adc_valid_6,
  adc_data_6,
  adc_enable_7,
  adc_valid_7,
  adc_data_7,

  // fifo interface

  adc_valid,
  adc_sync,
  adc_data);

  // parameters

  parameter   CH_DW     = 32;
  parameter   CH_CNT    = 8;

  localparam  CH_SCNT   = CH_DW/16;
  localparam  CH_MCNT   = 8;
  localparam  P_DW      = CH_CNT*CH_DW;
  localparam  P_CNT     = CH_CNT;
  localparam  P_SCNT    = P_DW/16;

  // adc interface

  input                             adc_rst;
  input                             adc_clk;
  input                             adc_enable_0;
  input                             adc_valid_0;
  input   [(CH_DW-1):0]             adc_data_0;
  input                             adc_enable_1;
  input                             adc_valid_1;
  input   [(CH_DW-1):0]             adc_data_1;
  input                             adc_enable_2;
  input                             adc_valid_2;
  input   [(CH_DW-1):0]             adc_data_2;
  input                             adc_enable_3;
  input                             adc_valid_3;
  input   [(CH_DW-1):0]             adc_data_3;
  input                             adc_enable_4;
  input                             adc_valid_4;
  input   [(CH_DW-1):0]             adc_data_4;
  input                             adc_enable_5;
  input                             adc_valid_5;
  input   [(CH_DW-1):0]             adc_data_5;
  input                             adc_enable_6;
  input                             adc_valid_6;
  input   [(CH_DW-1):0]             adc_data_6;
  input                             adc_enable_7;
  input                             adc_valid_7;
  input   [(CH_DW-1):0]             adc_data_7;

  // fifo interface

  output                            adc_valid;
  output                            adc_sync;
  output  [((CH_CNT*CH_DW)-1):0]    adc_data;

  // internal registers

  reg                               adc_valid_d = 'd0;
  reg     [((CH_MCNT*CH_DW)-1):0]   adc_data_d = 'd0;
  reg                               adc_mux_valid = 'd0;
  reg     [(CH_MCNT-1):0]           adc_mux_enable = 'd0;
  reg     [((CH_SCNT*16*79)-1):0]   adc_mux_data = 'd0;
  reg                               adc_valid = 'd0;
  reg                               adc_sync = 'd0;
  reg     [((CH_CNT*CH_DW)-1):0]    adc_data = 'd0;

  // internal signals

  wire    [(CH_MCNT-1):0]           adc_enable_s;
  wire    [(CH_MCNT-1):0]           adc_valid_s;
  wire    [((CH_MCNT*CH_DW)-1):0]   adc_data_s;
  wire    [((CH_MCNT*CH_DW)-1):0]   adc_data_intlv_s;
  wire    [(CH_SCNT-1):0]           adc_mux_valid_s;
  wire    [(CH_SCNT-1):0]           adc_mux_enable_0_s;
  wire    [(CH_SCNT-1):0]           adc_mux_enable_1_s;
  wire    [(CH_SCNT-1):0]           adc_mux_enable_2_s;
  wire    [(CH_SCNT-1):0]           adc_mux_enable_3_s;
  wire    [(CH_SCNT-1):0]           adc_mux_enable_4_s;
  wire    [(CH_SCNT-1):0]           adc_mux_enable_5_s;
  wire    [(CH_SCNT-1):0]           adc_mux_enable_6_s;
  wire    [(CH_SCNT-1):0]           adc_mux_enable_7_s;
  wire    [((CH_SCNT*16*1)-1):0]    adc_mux_data_0_s;
  wire    [((CH_SCNT*16*2)-1):0]    adc_mux_data_1_s;
  wire    [((CH_SCNT*16*3)-1):0]    adc_mux_data_2_s;
  wire    [((CH_SCNT*16*4)-1):0]    adc_mux_data_3_s;
  wire    [((CH_SCNT*16*5)-1):0]    adc_mux_data_4_s;
  wire    [((CH_SCNT*16*6)-1):0]    adc_mux_data_5_s;
  wire    [((CH_SCNT*16*7)-1):0]    adc_mux_data_6_s;
  wire    [((CH_SCNT*16*8)-1):0]    adc_mux_data_7_s;
  wire    [(CH_MCNT-1):0]           adc_dsf_valid_s;
  wire    [(CH_MCNT-1):0]           adc_dsf_sync_s;
  wire    [(P_DW-1):0]              adc_dsf_data_s[(CH_MCNT-1):0];

  // loop variables

  genvar                            n;

  // making things a bit easier

  assign adc_enable_s = { adc_enable_7, adc_enable_6, adc_enable_5, adc_enable_4,
                          adc_enable_3, adc_enable_2, adc_enable_1, adc_enable_0};
  assign adc_valid_s  = { adc_valid_7, adc_valid_6, adc_valid_5, adc_valid_4,
                          adc_valid_3, adc_valid_2, adc_valid_1, adc_valid_0};
  assign adc_data_s   = { adc_data_7, adc_data_6, adc_data_5, adc_data_4,
                          adc_data_3, adc_data_2, adc_data_1, adc_data_0};

  // adc first channel must be always on (doesn't have to be enabled)

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      adc_valid_d <= 'd0;
    end else begin
      adc_valid_d <= adc_valid_0;
    end
  end

  // mw requires unused to be zero

  generate
  for (n = 0; n < CH_MCNT; n = n + 1) begin: g_in
  always @(posedge adc_clk) begin
    if ((adc_rst == 1'b1) && (adc_enable_s[n] == 1'b0)) begin
      adc_data_d[((CH_DW*(n+1))-1):(CH_DW*n)] <= 'd0;
    end else if (adc_valid_s[n] == 1'b1) begin
      adc_data_d[((CH_DW*(n+1))-1):(CH_DW*n)] <=
        adc_data_s[((CH_DW*(n+1))-1):(CH_DW*n)];
    end
  end
  end
  endgenerate

  // interleave data

  generate
  for (n = 0; n < CH_SCNT; n = n + 1) begin: g_intlv
  assign adc_data_intlv_s[((16*CH_MCNT*(n+1))-1):(16*CH_MCNT*n)] =
          { adc_data_d[(((CH_DW*7)+(16*(n+1)))-1):((CH_DW*7)+(16*n))],
            adc_data_d[(((CH_DW*6)+(16*(n+1)))-1):((CH_DW*6)+(16*n))],
            adc_data_d[(((CH_DW*5)+(16*(n+1)))-1):((CH_DW*5)+(16*n))],
            adc_data_d[(((CH_DW*4)+(16*(n+1)))-1):((CH_DW*4)+(16*n))],
            adc_data_d[(((CH_DW*3)+(16*(n+1)))-1):((CH_DW*3)+(16*n))],
            adc_data_d[(((CH_DW*2)+(16*(n+1)))-1):((CH_DW*2)+(16*n))],
            adc_data_d[(((CH_DW*1)+(16*(n+1)))-1):((CH_DW*1)+(16*n))],
            adc_data_d[(((CH_DW*0)+(16*(n+1)))-1):((CH_DW*0)+(16*n))]};
  end
  endgenerate

  // mux

  generate
  for (n = 0; n < CH_SCNT; n = n + 1) begin: g_mux
  util_cpack_mux i_mux (
    .adc_clk (adc_clk),
    .adc_valid (adc_valid_d),
    .adc_enable (adc_enable_s),
    .adc_data (adc_data_intlv_s[((16*CH_MCNT*(n+1))-1):(16*CH_MCNT*n)]),
    .adc_mux_valid (adc_mux_valid_s[n]),
    .adc_mux_enable_0 (adc_mux_enable_0_s[n]),
    .adc_mux_data_0 (adc_mux_data_0_s[(((n+1)*16*1)-1):(n*16*1)]),
    .adc_mux_enable_1 (adc_mux_enable_1_s[n]),
    .adc_mux_data_1 (adc_mux_data_1_s[(((n+1)*16*2)-1):(n*16*2)]),
    .adc_mux_enable_2 (adc_mux_enable_2_s[n]),
    .adc_mux_data_2 (adc_mux_data_2_s[(((n+1)*16*3)-1):(n*16*3)]),
    .adc_mux_enable_3 (adc_mux_enable_3_s[n]),
    .adc_mux_data_3 (adc_mux_data_3_s[(((n+1)*16*4)-1):(n*16*4)]),
    .adc_mux_enable_4 (adc_mux_enable_4_s[n]),
    .adc_mux_data_4 (adc_mux_data_4_s[(((n+1)*16*5)-1):(n*16*5)]),
    .adc_mux_enable_5 (adc_mux_enable_5_s[n]),
    .adc_mux_data_5 (adc_mux_data_5_s[(((n+1)*16*6)-1):(n*16*6)]),
    .adc_mux_enable_6 (adc_mux_enable_6_s[n]),
    .adc_mux_data_6 (adc_mux_data_6_s[(((n+1)*16*7)-1):(n*16*7)]),
    .adc_mux_enable_7 (adc_mux_enable_7_s[n]),
    .adc_mux_data_7 (adc_mux_data_7_s[(((n+1)*16*8)-1):(n*16*8)]));
  end
  endgenerate

  // concat

  always @(posedge adc_clk) begin
    adc_mux_valid <= & adc_mux_valid_s;
    adc_mux_enable[0] <= & adc_mux_enable_0_s;
    adc_mux_enable[1] <= & adc_mux_enable_1_s;
    adc_mux_enable[2] <= & adc_mux_enable_2_s;
    adc_mux_enable[3] <= & adc_mux_enable_3_s;
    adc_mux_enable[4] <= & adc_mux_enable_4_s;
    adc_mux_enable[5] <= & adc_mux_enable_5_s;
    adc_mux_enable[6] <= & adc_mux_enable_6_s;
    adc_mux_enable[7] <= & adc_mux_enable_7_s;
    adc_mux_data[((CH_SCNT*16* 9)-1):(CH_SCNT*16* 1)] <= 'd0;
    adc_mux_data[((CH_SCNT*16*19)-1):(CH_SCNT*16*12)] <= 'd0;
    adc_mux_data[((CH_SCNT*16*29)-1):(CH_SCNT*16*23)] <= 'd0;
    adc_mux_data[((CH_SCNT*16*39)-1):(CH_SCNT*16*34)] <= 'd0;
    adc_mux_data[((CH_SCNT*16*49)-1):(CH_SCNT*16*45)] <= 'd0;
    adc_mux_data[((CH_SCNT*16*59)-1):(CH_SCNT*16*56)] <= 'd0;
    adc_mux_data[((CH_SCNT*16*69)-1):(CH_SCNT*16*67)] <= 'd0;
    adc_mux_data[((CH_SCNT*16*79)-1):(CH_SCNT*16*78)] <= 'd0;
    adc_mux_data[((CH_SCNT*16* 1)-1):(CH_SCNT*16* 0)] <= adc_mux_data_0_s;
    adc_mux_data[((CH_SCNT*16*12)-1):(CH_SCNT*16*10)] <= adc_mux_data_1_s;
    adc_mux_data[((CH_SCNT*16*23)-1):(CH_SCNT*16*20)] <= adc_mux_data_2_s;
    adc_mux_data[((CH_SCNT*16*34)-1):(CH_SCNT*16*30)] <= adc_mux_data_3_s;
    adc_mux_data[((CH_SCNT*16*45)-1):(CH_SCNT*16*40)] <= adc_mux_data_4_s;
    adc_mux_data[((CH_SCNT*16*56)-1):(CH_SCNT*16*50)] <= adc_mux_data_5_s;
    adc_mux_data[((CH_SCNT*16*67)-1):(CH_SCNT*16*60)] <= adc_mux_data_6_s;
    adc_mux_data[((CH_SCNT*16*78)-1):(CH_SCNT*16*70)] <= adc_mux_data_7_s;
  end

  // store & fwd

  generate
  for (n = 0; n < P_CNT; n = n + 1) begin: g_dsf
  util_cpack_dsf #(
    .CH_MCNT (CH_MCNT),
    .P_CNT (P_CNT),
    .CH_DW (CH_DW),
    .CH_ICNT ((n+1)))
  i_dsf (
    .adc_clk (adc_clk),
    .adc_valid (adc_mux_valid),
    .adc_enable (adc_mux_enable[n]),
    .adc_data (adc_mux_data[((CH_SCNT*16*((11*n)+1))-1):(CH_SCNT*16*10*n)]),
    .adc_dsf_valid (adc_dsf_valid_s[n]),
    .adc_dsf_sync (adc_dsf_sync_s[n]),
    .adc_dsf_data (adc_dsf_data_s[n]));
  end
  endgenerate

  generate
  if (CH_MCNT > P_CNT) begin
  for (n = P_CNT; n < CH_MCNT; n = n + 1) begin: g_def
  assign adc_dsf_valid_s[n] = 'd0;
  assign adc_dsf_sync_s[n] = 'd0;
  assign adc_dsf_data_s[n] = 'd0;
  end
  end
  endgenerate

  always @(posedge adc_clk) begin
    adc_valid <= | adc_dsf_valid_s;
    adc_sync <= | adc_dsf_sync_s;
    adc_data <= adc_dsf_data_s[7] | adc_dsf_data_s[6] |
                adc_dsf_data_s[5] | adc_dsf_data_s[4] |
                adc_dsf_data_s[3] | adc_dsf_data_s[2] |
                adc_dsf_data_s[1] | adc_dsf_data_s[0];
  end

endmodule

// ***************************************************************************
// ***************************************************************************
