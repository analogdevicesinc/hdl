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

  delay_clk,
  delay_rst,
  delay_sel,
  delay_rwn,
  delay_addr,
  delay_wdata,
  delay_rdata,
  delay_ack_t,
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

  input           delay_clk;
  input           delay_rst;
  input           delay_sel;
  input           delay_rwn;
  input   [ 7:0]  delay_addr;
  input   [ 4:0]  delay_wdata;
  output  [ 4:0]  delay_rdata;
  output          delay_ack_t;
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
  reg     [16:0]  delay_ld = 'd0;
  reg             delay_ack_t = 'd0;
  reg     [ 4:0]  delay_rdata = 'd0;

  // internal signals

  wire    [ 4:0]  delay_rdata_s[16:0];
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

  // delay write interface, each delay element can be individually
  // addressed, and a delay value can be directly loaded (no inc/dec stuff)

  always @(posedge delay_clk) begin
    if ((delay_sel == 1'b1) && (delay_rwn == 1'b0)) begin
      case (delay_addr)
        8'h10: delay_ld <= 17'h10000;
        8'h0f: delay_ld <= 17'h08000;
        8'h0e: delay_ld <= 17'h04000;
        8'h0d: delay_ld <= 17'h02000;
        8'h0c: delay_ld <= 17'h01000;
        8'h0b: delay_ld <= 17'h00800;
        8'h0a: delay_ld <= 17'h00400;
        8'h09: delay_ld <= 17'h00200;
        8'h08: delay_ld <= 17'h00100;
        8'h07: delay_ld <= 17'h00080;
        8'h06: delay_ld <= 17'h00040;
        8'h05: delay_ld <= 17'h00020;
        8'h04: delay_ld <= 17'h00010;
        8'h03: delay_ld <= 17'h00008;
        8'h02: delay_ld <= 17'h00004;
        8'h01: delay_ld <= 17'h00002;
        8'h00: delay_ld <= 17'h00001;
        default: delay_ld <= 17'h00000;
      endcase
    end else begin
      delay_ld <= 15'h0000;
    end
  end

  // delay read interface, a delay ack toggle is used to transfer data to the
  // processor side- delay locked is independently transferred

  always @(posedge delay_clk) begin
    case (delay_addr)
      8'h10: delay_rdata <= delay_rdata_s[16];
      8'h0f: delay_rdata <= delay_rdata_s[15];
      8'h0e: delay_rdata <= delay_rdata_s[14];
      8'h0d: delay_rdata <= delay_rdata_s[13];
      8'h0c: delay_rdata <= delay_rdata_s[12];
      8'h0b: delay_rdata <= delay_rdata_s[11];
      8'h0a: delay_rdata <= delay_rdata_s[10];
      8'h09: delay_rdata <= delay_rdata_s[ 9];
      8'h08: delay_rdata <= delay_rdata_s[ 8];
      8'h07: delay_rdata <= delay_rdata_s[ 7];
      8'h06: delay_rdata <= delay_rdata_s[ 6];
      8'h05: delay_rdata <= delay_rdata_s[ 5];
      8'h04: delay_rdata <= delay_rdata_s[ 4];
      8'h03: delay_rdata <= delay_rdata_s[ 3];
      8'h02: delay_rdata <= delay_rdata_s[ 2];
      8'h01: delay_rdata <= delay_rdata_s[ 1];
      8'h00: delay_rdata <= delay_rdata_s[ 0];
      default: delay_rdata <= 5'd0;
    endcase
    if (delay_sel == 1'b1) begin
      delay_ack_t <= ~delay_ack_t;
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
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_ld (delay_ld[l_inst]),
    .delay_wdata (delay_wdata),
    .delay_rdata (delay_rdata_s[l_inst]),
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
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_ld (delay_ld[16]),
    .delay_wdata (delay_wdata),
    .delay_rdata (delay_rdata_s[16]),
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
