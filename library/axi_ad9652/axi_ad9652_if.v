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
// This is the LVDS/DDR interface, note that overrange is independent of data path,
// software will not be able to relate overrange to a specific sample!
// Alternative is to concatenate sample value and or status for data.

`timescale 1ns/100ps

module axi_ad9652_if (

  // adc interface (clk, data, over-range)

  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_or_in_p,
  adc_or_in_n,

  // interface outputs

  adc_clk,
  adc_data_a,
  adc_data_b,
  adc_or_a,
  adc_or_b,
  adc_status,

  // processor control signals

  adc_ddr_edgesel,

  // delay control signals

  up_clk,
  up_dld,
  up_dwdata,
  up_drdata,
  delay_clk,
  delay_rst,
  delay_locked);

  // This parameter controls the buffer type based on the target device.

  parameter   PCORE_BUFTYPE = 0;
  parameter   PCORE_IODELAY_GROUP = "adc_if_delay_group";

  // adc interface (clk, data, over-range)

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [15:0]  adc_data_in_p;
  input   [15:0]  adc_data_in_n;
  input           adc_or_in_p;
  input           adc_or_in_n;

  // interface outputs

  output          adc_clk;
  output  [15:0]  adc_data_a;
  output  [15:0]  adc_data_b;
  output          adc_or_a;
  output          adc_or_b;
  output          adc_status;

  // processor control signals

  input           adc_ddr_edgesel;

  // delay control signals

  input           up_clk;
  input   [16:0]  up_dld;
  input   [84:0]  up_dwdata;
  output  [84:0]  up_drdata;
  input           delay_clk;
  input           delay_rst;
  output          delay_locked;

  // internal registers

  reg             adc_status = 'd0;
  reg     [15:0]  adc_data_p = 'd0;
  reg     [15:0]  adc_data_n = 'd0;
  reg     [15:0]  adc_data_p_d = 'd0;
  reg             adc_or_p = 'd0;
  reg             adc_or_n = 'd0;
  reg             adc_or_p_d = 'd0;
  reg     [15:0]  adc_data_a = 'd0;
  reg     [15:0]  adc_data_b = 'd0;
  reg             adc_or_a = 'd0;
  reg             adc_or_b = 'd0;

  // internal signals

  wire    [15:0]  adc_data_p_s;
  wire    [15:0]  adc_data_n_s;
  wire            adc_or_p_s;
  wire            adc_or_n_s;

  genvar          l_inst;

  // two data pin modes are supported-
  // mux - across clock edges (rising or falling edges),
  // mux - within clock edges (lower 7 bits and upper 7 bits)

  always @(posedge adc_clk) begin
    adc_status <= 1'b1;
    adc_data_p <= adc_data_p_s;
    adc_data_n <= adc_data_n_s;
    adc_data_p_d <= adc_data_p;
    adc_or_p <= adc_or_p_s;
    adc_or_n <= adc_or_n_s;
    adc_or_p_d <= adc_or_p;
  end

  always @(posedge adc_clk) begin
    if (adc_ddr_edgesel == 1'b1) begin
      adc_data_a <= adc_data_p_d;
      adc_data_b <= adc_data_n;
      adc_or_a <= adc_or_p_d;
      adc_or_b <= adc_or_n;
    end else begin
      adc_data_a <= adc_data_n;
      adc_data_b <= adc_data_p;
      adc_or_a <= adc_or_n;
      adc_or_b <= adc_or_p;
    end
  end


  // data interface

  generate
  for (l_inst = 0; l_inst <= 15; l_inst = l_inst + 1) begin : g_adc_if
  ad_lvds_in #(
    .BUFTYPE (PCORE_BUFTYPE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (PCORE_IODELAY_GROUP))
  i_adc_data (
    .rx_clk (adc_clk),
    .rx_data_in_p (adc_data_in_p[l_inst]),
    .rx_data_in_n (adc_data_in_n[l_inst]),
    .rx_data_p (adc_data_p_s[l_inst]),
    .rx_data_n (adc_data_n_s[l_inst]),
    .up_clk (up_clk),
    .up_dld (up_dld[l_inst]),
    .up_dwdata (up_dwdata[((l_inst*5)+4):(l_inst*5)]),
    .up_drdata (up_drdata[((l_inst*5)+4):(l_inst*5)]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
  end
  endgenerate

  // over-range interface

  ad_lvds_in #(
    .BUFTYPE (PCORE_BUFTYPE),
    .IODELAY_CTRL (1),
    .IODELAY_GROUP (PCORE_IODELAY_GROUP))
  i_adc_or (
    .rx_clk (adc_clk),
    .rx_data_in_p (adc_or_in_p),
    .rx_data_in_n (adc_or_in_n),
    .rx_data_p (adc_or_p_s),
    .rx_data_n (adc_or_n_s),
    .up_clk (up_clk),
    .up_dld (up_dld[16]),
    .up_dwdata (up_dwdata[84:80]),
    .up_drdata (up_drdata[84:80]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // clock

  ad_lvds_clk #(
    .BUFTYPE (PCORE_BUFTYPE))
  i_adc_clk (
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
