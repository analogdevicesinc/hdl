// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
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
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module axi_ad9467_if (

  // adc interface (clk, data, over-range)

  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_or_in_p,
  adc_or_in_n,

  // interface outputs

  adc_clk,
  adc_data,
  adc_or,

  // processor interface

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

  // buffer type based on the target device.

  parameter PCORE_BUFTYPE = 0;
  parameter PCORE_IODELAY_GROUP = "dev_if_delay_group";

  // adc interface (clk, data, over-range)

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [ 7:0]  adc_data_in_p;
  input   [ 7:0]  adc_data_in_n;
  input           adc_or_in_p;
  input           adc_or_in_n;

  // interface outputs

  output          adc_clk;
  output  [15:0]  adc_data;
  output          adc_or;

  // processor interface

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

  reg     [ 7:0]  adc_data_p = 'd0;
  reg     [ 7:0]  adc_data_n = 'd0;
  reg     [ 7:0]  adc_data_p_d = 'd0;
  reg     [ 7:0]  adc_dmux_a = 'd0;
  reg     [ 7:0]  adc_dmux_b = 'd0;
  reg     [15:0]  adc_data = 'd0;
  reg             adc_or_p = 'd0;
  reg             adc_or_n = 'd0;
  reg             adc_or = 'd0;
  reg     [ 8:0]  delay_ld = 'd0;
  reg             delay_ack_t = 'd0;
  reg     [ 4:0]  delay_rdata = 'd0;

  // internal signals

  wire    [ 4:0]  delay_rdata_s[8:0];
  wire    [ 7:0]  adc_data_p_s;
  wire    [ 7:0]  adc_data_n_s;
  wire            adc_or_p_s;
  wire            adc_or_n_s;

  genvar          l_inst;

  // sample select (p/n) swap

  always @(posedge adc_clk) begin
    adc_data_p <= adc_data_p_s;
    adc_data_n <= adc_data_n_s;
    adc_data_p_d <= adc_data_p;
    adc_dmux_a <= (adc_ddr_edgesel == 1'b1) ? adc_data_n   : adc_data_p;
    adc_dmux_b <= (adc_ddr_edgesel == 1'b1) ? adc_data_p_d : adc_data_n;
    adc_data[15] <= adc_dmux_b[7];
    adc_data[14] <= adc_dmux_a[7];
    adc_data[13] <= adc_dmux_b[6];
    adc_data[12] <= adc_dmux_a[6];
    adc_data[11] <= adc_dmux_b[5];
    adc_data[10] <= adc_dmux_a[5];
    adc_data[ 9] <= adc_dmux_b[4];
    adc_data[ 8] <= adc_dmux_a[4];
    adc_data[ 7] <= adc_dmux_b[3];
    adc_data[ 6] <= adc_dmux_a[3];
    adc_data[ 5] <= adc_dmux_b[2];
    adc_data[ 4] <= adc_dmux_a[2];
    adc_data[ 3] <= adc_dmux_b[1];
    adc_data[ 2] <= adc_dmux_a[1];
    adc_data[ 1] <= adc_dmux_b[0];
    adc_data[ 0] <= adc_dmux_a[0];
    adc_or_p <= adc_or_p_s;
    adc_or_n <= adc_or_n_s;
    if ((adc_or_p == 1'b1) || (adc_or_n == 1'b1)) begin
      adc_or <= 1'b1;
    end else begin
      adc_or <= 1'b0;
    end
  end

  // delay write interface, each delay element can be individually
  // addressed, and a delay value can be directly loaded (no inc/dec stuff)

  always @(posedge delay_clk) begin
    if ((delay_sel == 1'b1) && (delay_rwn == 1'b0)) begin
      case (delay_addr)
        8'd8 : delay_ld <= 9'h100;
        8'd7 : delay_ld <= 9'h080;
        8'd6 : delay_ld <= 9'h040;
        8'd5 : delay_ld <= 9'h020;
        8'd4 : delay_ld <= 9'h010;
        8'd3 : delay_ld <= 9'h008;
        8'd2 : delay_ld <= 9'h004;
        8'd1 : delay_ld <= 9'h002;
        8'd0 : delay_ld <= 9'h001;
        default: delay_ld <= 9'h000;
      endcase
    end else begin
      delay_ld <= 9'h000;
    end
  end

  // delay read interface, a delay ack toggle is used to transfer data to the
  // processor side- delay locked is independently transferred

  always @(posedge delay_clk) begin
    case (delay_addr)
      8'd8 : delay_rdata <= delay_rdata_s[8];
      8'd7 : delay_rdata <= delay_rdata_s[7];
      8'd6 : delay_rdata <= delay_rdata_s[6];
      8'd5 : delay_rdata <= delay_rdata_s[5];
      8'd4 : delay_rdata <= delay_rdata_s[4];
      8'd3 : delay_rdata <= delay_rdata_s[3];
      8'd2 : delay_rdata <= delay_rdata_s[2];
      8'd1 : delay_rdata <= delay_rdata_s[1];
      8'd0 : delay_rdata <= delay_rdata_s[0];
      default: delay_rdata <= 5'd0;
    endcase
    if (delay_sel == 1'b1) begin
      delay_ack_t <= ~delay_ack_t;
    end
  end

  // data interface

  generate
  for (l_inst = 0; l_inst <= 7; l_inst = l_inst + 1) begin : g_adc_if
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
    .delay_ld (delay_ld[8]),
    .delay_wdata (delay_wdata),
    .delay_rdata (delay_rdata_s[8]),
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
