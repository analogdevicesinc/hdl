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
// poor man's version of calibration & correction (scale & offset only)
// assumes linear frequency response on all discrete components
// looking for a rich man's version? fidus.com (FSF-AD15000A)

`timescale 1ns/100ps

module axi_fmcadc5_sync_calcor (

  // receive interface
 
  input             rx_clk,
  input             rx_enable_0,
  input   [255:0]   rx_data_0,
  input             rx_enable_1,
  input   [255:0]   rx_data_1,
  output            rx_cor_enable,
  output  [511:0]   rx_cor_data,

  // calibration signals

  input             rx_cal_enable,
  output            rx_cal_done_t,
  output  [ 15:0]   rx_cal_max_0,
  output  [ 15:0]   rx_cal_min_0,
  output  [ 15:0]   rx_cal_max_1,
  output  [ 15:0]   rx_cal_min_1,
  input   [ 15:0]   rx_cor_scale_0,
  input   [ 15:0]   rx_cor_offset_0,
  input   [ 15:0]   rx_cor_scale_1,
  input   [ 15:0]   rx_cor_offset_1);

  // internal registers

  reg               rx_cor_enable_int = 'd0;
  reg     [ 15:0]   rx_cor_data_0[0:15];
  reg     [ 15:0]   rx_cor_data_1[0:15];
  reg               rx_cal_done_int_t = 'd0;
  reg     [ 15:0]   rx_cal_max_0_6 = 'd0;
  reg     [ 15:0]   rx_cal_min_0_6 = 'd0;
  reg     [ 15:0]   rx_cal_max_1_6 = 'd0;
  reg     [ 15:0]   rx_cal_min_1_6 = 'd0;
  reg     [ 15:0]   rx_cal_max_0_5 = 'd0;
  reg     [ 15:0]   rx_cal_min_0_5 = 'd0;
  reg     [ 15:0]   rx_cal_max_1_5 = 'd0;
  reg     [ 15:0]   rx_cal_min_1_5 = 'd0;
  reg     [ 15:0]   rx_cal_max_0_4[0:1];
  reg     [ 15:0]   rx_cal_min_0_4[0:1];
  reg     [ 15:0]   rx_cal_max_1_4[0:1];
  reg     [ 15:0]   rx_cal_min_1_4[0:1];
  reg     [ 15:0]   rx_cal_max_0_3[0:3];
  reg     [ 15:0]   rx_cal_min_0_3[0:3];
  reg     [ 15:0]   rx_cal_max_1_3[0:3];
  reg     [ 15:0]   rx_cal_min_1_3[0:3];
  reg     [ 15:0]   rx_cal_max_0_2[0:7];
  reg     [ 15:0]   rx_cal_min_0_2[0:7];
  reg     [ 15:0]   rx_cal_max_1_2[0:7];
  reg     [ 15:0]   rx_cal_min_1_2[0:7];
  reg     [ 15:0]   rx_cal_max_0_1[0:15];
  reg     [ 15:0]   rx_cal_min_0_1[0:15];
  reg     [ 15:0]   rx_cal_max_1_1[0:15];
  reg     [ 15:0]   rx_cal_min_1_1[0:15];

  // internal signals

  wire    [ 33:0]   rx_cor_data_0_s[0:15];
  wire    [ 33:0]   rx_cor_data_1_s[0:15];
  wire    [ 15:0]   rx_data_0_s[0:15];
  wire    [ 15:0]   rx_data_1_s[0:15];

  // iterations
 
  genvar n;

  // offset & gain
 
  assign rx_cor_enable = rx_cor_enable_int;

  always @(posedge rx_clk) begin
    rx_cor_enable_int = rx_enable_0 & rx_enable_1;
  end

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_cal_data
  assign rx_cor_data[((n*32)+15):((n*32)+ 0)] = rx_cor_data_0_s[n][30:15];
  assign rx_cor_data[((n*32)+31):((n*32)+16)] = rx_cor_data_1_s[n][30:15];
  end
  endgenerate

  // gain

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_gain
  ad_mul #(.DELAY_DATA_WIDTH(1)) i_rx_gain_0 (
    .clk (rx_clk),
    .data_a ({rx_cor_data_0[n][15], rx_cor_data_0[n]}),
    .data_b ({1'b0, rx_cor_scale_0}),
    .data_p (rx_cor_data_0_s[n]),
    .ddata_in (1'd0),
    .ddata_out ());
  ad_mul #(.DELAY_DATA_WIDTH(1)) i_rx_gain_1 (
    .clk (rx_clk),
    .data_a ({rx_cor_data_1[n][15], rx_cor_data_1[n]}),
    .data_b ({1'b0, rx_cor_scale_1}),
    .data_p (rx_cor_data_1_s[n]),
    .ddata_in (1'd0),
    .ddata_out ());
  end
  endgenerate

  // offset

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_offset
  always @(posedge rx_clk) begin
    rx_cor_data_0[n] <= rx_data_0_s[n] + rx_cor_offset_0;
    rx_cor_data_1[n] <= rx_data_1_s[n] + rx_cor_offset_1;
  end
  end
  endgenerate

  // calibration peaks (average would be better)

  assign rx_cal_done_t = rx_cal_done_int_t;
  assign rx_cal_max_0 = rx_cal_max_0_6;
  assign rx_cal_min_0 = rx_cal_min_0_6;
  assign rx_cal_max_1 = rx_cal_max_1_6;
  assign rx_cal_min_1 = rx_cal_min_1_6;

  always @(posedge rx_clk) begin
    if (rx_cal_enable == 1'b1) begin
      rx_cal_done_int_t <= ~rx_cal_done_int_t;
      rx_cal_max_0_6 <= rx_cal_max_0_5;
      rx_cal_min_0_6 <= rx_cal_min_0_5;
      rx_cal_max_1_6 <= rx_cal_max_1_5;
      rx_cal_min_1_6 <= rx_cal_min_1_5;
    end
  end

  // run-time peaks

  always @(posedge rx_clk) begin
    if (rx_cal_max_0_4[1] > rx_cal_max_0_4[0]) begin
      rx_cal_max_0_5 <= rx_cal_max_0_4[1];
    end else begin
      rx_cal_max_0_5 <= rx_cal_max_0_4[0];
    end
    if (rx_cal_min_0_4[1] < rx_cal_min_0_4[0]) begin
      rx_cal_min_0_5 <= rx_cal_min_0_4[1];
    end else begin
      rx_cal_min_0_5 <= rx_cal_min_0_4[0];
    end
    if (rx_cal_max_1_4[1] > rx_cal_max_1_4[0]) begin
      rx_cal_max_1_5 <= rx_cal_max_1_4[1];
    end else begin
      rx_cal_max_1_5 <= rx_cal_max_1_4[0];
    end
    if (rx_cal_min_1_4[1] < rx_cal_min_1_4[0]) begin
      rx_cal_min_1_5 <= rx_cal_min_1_4[1];
    end else begin
      rx_cal_min_1_5 <= rx_cal_min_1_4[0];
    end
  end

  // peak iterations
 
  generate
  for (n = 0; n <= 1; n = n + 1) begin: g_rx_peak_4
  always @(posedge rx_clk) begin
    if (rx_cal_max_0_3[((n*2)+1)] > rx_cal_max_0_3[(n*2)]) begin
      rx_cal_max_0_4[n] <= rx_cal_max_0_3[((n*2)+1)];
    end else begin
      rx_cal_max_0_4[n] <= rx_cal_max_0_3[(n*2)];
    end
    if (rx_cal_min_0_3[((n*2)+1)] < rx_cal_min_0_3[(n*2)]) begin
      rx_cal_min_0_4[n] <= rx_cal_min_0_3[((n*2)+1)];
    end else begin
      rx_cal_min_0_4[n] <= rx_cal_min_0_3[(n*2)];
    end
    if (rx_cal_max_1_3[((n*2)+1)] > rx_cal_max_1_3[(n*2)]) begin
      rx_cal_max_1_4[n] <= rx_cal_max_1_3[((n*2)+1)];
    end else begin
      rx_cal_max_1_4[n] <= rx_cal_max_1_3[(n*2)];
    end
    if (rx_cal_min_1_3[((n*2)+1)] < rx_cal_min_1_3[(n*2)]) begin
      rx_cal_min_1_4[n] <= rx_cal_min_1_3[((n*2)+1)];
    end else begin
      rx_cal_min_1_4[n] <= rx_cal_min_1_3[(n*2)];
    end
  end
  end
  endgenerate

  generate
  for (n = 0; n <= 3; n = n + 1) begin: g_rx_peak_3
  always @(posedge rx_clk) begin
    if (rx_cal_max_0_2[((n*2)+1)] > rx_cal_max_0_2[(n*2)]) begin
      rx_cal_max_0_3[n] <= rx_cal_max_0_2[((n*2)+1)];
    end else begin
      rx_cal_max_0_3[n] <= rx_cal_max_0_2[(n*2)];
    end
    if (rx_cal_min_0_2[((n*2)+1)] < rx_cal_min_0_2[(n*2)]) begin
      rx_cal_min_0_3[n] <= rx_cal_min_0_2[((n*2)+1)];
    end else begin
      rx_cal_min_0_3[n] <= rx_cal_min_0_2[(n*2)];
    end
    if (rx_cal_max_1_2[((n*2)+1)] > rx_cal_max_1_2[(n*2)]) begin
      rx_cal_max_1_3[n] <= rx_cal_max_1_2[((n*2)+1)];
    end else begin
      rx_cal_max_1_3[n] <= rx_cal_max_1_2[(n*2)];
    end
    if (rx_cal_min_1_2[((n*2)+1)] < rx_cal_min_1_2[(n*2)]) begin
      rx_cal_min_1_3[n] <= rx_cal_min_1_2[((n*2)+1)];
    end else begin
      rx_cal_min_1_3[n] <= rx_cal_min_1_2[(n*2)];
    end
  end
  end
  endgenerate

  generate
  for (n = 0; n <= 7; n = n + 1) begin: g_rx_peak_2
  always @(posedge rx_clk) begin
    if (rx_cal_max_0_1[((n*2)+1)] > rx_cal_max_0_1[(n*2)]) begin
      rx_cal_max_0_2[n] <= rx_cal_max_0_1[((n*2)+1)];
    end else begin
      rx_cal_max_0_2[n] <= rx_cal_max_0_1[(n*2)];
    end
    if (rx_cal_min_0_1[((n*2)+1)] < rx_cal_min_0_1[(n*2)]) begin
      rx_cal_min_0_2[n] <= rx_cal_min_0_1[((n*2)+1)];
    end else begin
      rx_cal_min_0_2[n] <= rx_cal_min_0_1[(n*2)];
    end
    if (rx_cal_max_1_1[((n*2)+1)] > rx_cal_max_1_1[(n*2)]) begin
      rx_cal_max_1_2[n] <= rx_cal_max_1_1[((n*2)+1)];
    end else begin
      rx_cal_max_1_2[n] <= rx_cal_max_1_1[(n*2)];
    end
    if (rx_cal_min_1_1[((n*2)+1)] < rx_cal_min_1_1[(n*2)]) begin
      rx_cal_min_1_2[n] <= rx_cal_min_1_1[((n*2)+1)];
    end else begin
      rx_cal_min_1_2[n] <= rx_cal_min_1_1[(n*2)];
    end
  end
  end
  endgenerate

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_peak_1
  always @(posedge rx_clk) begin
    if (rx_cal_enable == 1'b0) begin
      rx_cal_max_0_1[n] <= 16'h0000;
    end else if ((rx_data_0_s[n] > rx_cal_max_0_1[n]) &&
      (rx_data_0_s[n][15] == 1'b0)) begin
      rx_cal_max_0_1[n] <= rx_data_0_s[n];
    end
    if (rx_cal_enable == 1'b0) begin
      rx_cal_min_0_1[n] <= 16'hffff;
    end else if ((rx_data_0_s[n] < rx_cal_min_0_1[n]) &&
      (rx_data_0_s[n][15] == 1'b1)) begin
      rx_cal_min_0_1[n] <= rx_data_0_s[n];
    end
    if (rx_cal_enable == 1'b0) begin
      rx_cal_max_1_1[n] <= 16'h0000;
    end else if ((rx_data_1_s[n] > rx_cal_max_1_1[n]) &&
      (rx_data_1_s[n][15] == 1'b0)) begin
      rx_cal_max_1_1[n] <= rx_data_1_s[n];
    end
    if (rx_cal_enable == 1'b0) begin
      rx_cal_min_1_1[n] <= 16'hffff;
    end else if ((rx_data_1_s[n] < rx_cal_min_1_1[n]) &&
      (rx_data_1_s[n][15] == 1'b1)) begin
      rx_cal_min_1_1[n] <= rx_data_1_s[n];
    end
  end
  end
  endgenerate

  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_rx_data
  assign rx_data_0_s[n] = {{4{rx_data_0[((n*16)+11)]}}, rx_data_0[((n*16)+11):(n*16)]};
  assign rx_data_1_s[n] = {{4{rx_data_1[((n*16)+11)]}}, rx_data_1[((n*16)+11):(n*16)]};
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
