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

`timescale 1ns/100ps

module axi_ad9434_if (

  // device interface
  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_or_in_p,
  adc_or_in_n,

  // interface outputs
  adc_data,
  adc_or,

  // internl reset and clocks
  adc_clk,
  adc_rst,
  adc_status,

  // delay interface (for IDELAY macros)
  delay_clk,
  delay_rst,
  delay_sel,
  delay_rwn,
  delay_addr,
  delay_wdata,
  delay_rdata,
  delay_ack_t,
  delay_locked,

  // mmcm reset
  mmcm_rst,

  // drp interface for MMCM
  drp_clk,
  drp_rst,
  drp_sel,
  drp_wr,
  drp_addr,
  drp_wdata,
  drp_rdata,
  drp_ready,
  drp_locked);

  // parameters
  parameter PCORE_DEVTYPE = 0;  // 0 - 7Series / 1 - 6Series
  parameter PCORE_IODELAY_GROUP = "dev_if_delay_group";

  // buffer type based on the target device.
  localparam PCORE_BUFTYPE = PCORE_DEVTYPE;
  localparam SDR = 0;

  // adc interface (clk, data, over-range)
  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [11:0]  adc_data_in_p;
  input   [11:0]  adc_data_in_n;
  input           adc_or_in_p;
  input           adc_or_in_n;

  // interface outputs
  output  [47:0]  adc_data;
  output          adc_or;

  // internal reset and clocks

  output          adc_clk;
  input           adc_rst;
  output          adc_status;

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

  // mmcm reset
  input           mmcm_rst;

  // drp interface
  input           drp_clk;
  input           drp_rst;
  input           drp_sel;
  input           drp_wr;
  input   [11:0]  drp_addr;
  input   [15:0]  drp_wdata;
  output  [15:0]  drp_rdata;
  output          drp_ready;
  output          drp_locked;

  // output registers
  reg     [ 4:0]  delay_rdata   = 'b0;
  reg             delay_ack_t   = 'b0;

  // internal registers
  reg     [12:0]  delay_ld      = 'd0;
  reg             adc_status    = 'd0;
  reg             adc_status_m1 = 'd0;

  // internal signals
  wire    [ 4:0]  delay_rdata_s[12:0];

  wire    [3:0]   adc_or_s;

  wire            adc_clk_in;
  wire            adc_div_clk;

  genvar          l_inst;

  // output assignment for adc clock (1:4 of the sampling clock)
  assign  adc_clk = adc_div_clk;

  // delay write interface, each delay element can be individually
  // addressed, and a delay value can be directly loaded (no inc/dec stuff)
  always @(posedge delay_clk) begin
    if ((delay_sel == 1'b1) && (delay_rwn == 1'b0)) begin
      case (delay_addr)
        8'd12  : delay_ld <= 13'h1000;
        8'd11  : delay_ld <= 13'h0800;
        8'd10  : delay_ld <= 13'h0400;
        8'd9   : delay_ld <= 13'h0200;
        8'd8   : delay_ld <= 13'h0100;
        8'd7   : delay_ld <= 13'h0080;
        8'd6   : delay_ld <= 13'h0040;
        8'd5   : delay_ld <= 13'h0020;
        8'd4   : delay_ld <= 13'h0010;
        8'd3   : delay_ld <= 13'h0008;
        8'd2   : delay_ld <= 13'h0004;
        8'd1   : delay_ld <= 13'h0002;
        8'd0   : delay_ld <= 13'h0001;
        default : delay_ld <= 13'h0000;
      endcase
    end else begin
      delay_ld <= 13'h000;
    end
  end

  // delay read interface, a delay ack toggle is used to transfer data to the
  // processor side- delay locked is independently transferred
  always @(posedge delay_clk) begin
    case (delay_addr)
      8'd12 : delay_rdata <= delay_rdata_s[12];
      8'd11 : delay_rdata <= delay_rdata_s[11];
      8'd10 : delay_rdata <= delay_rdata_s[10];
      8'd9  : delay_rdata <= delay_rdata_s[9];
      8'd8  : delay_rdata <= delay_rdata_s[8];
      8'd7  : delay_rdata <= delay_rdata_s[7];
      8'd6  : delay_rdata <= delay_rdata_s[6];
      8'd5  : delay_rdata <= delay_rdata_s[5];
      8'd4  : delay_rdata <= delay_rdata_s[4];
      8'd3  : delay_rdata <= delay_rdata_s[3];
      8'd2  : delay_rdata <= delay_rdata_s[2];
      8'd1  : delay_rdata <= delay_rdata_s[1];
      8'd0  : delay_rdata <= delay_rdata_s[0];
      default: delay_rdata <= 5'd0;
    endcase
    if (delay_sel == 1'b1) begin
      delay_ack_t <= ~delay_ack_t;
    end
  end

  // data interface
  generate
  for (l_inst = 0; l_inst <= 11; l_inst = l_inst + 1) begin : g_adc_if
    ad_serdes_in #(
      .DEVICE_TYPE(PCORE_DEVTYPE),
      .IODELAY_CTRL(0),
      .IODELAY_GROUP(PCORE_IODELAY_GROUP),
      .IF_TYPE(SDR),
      .PARALLEL_WIDTH(4))
    i_adc_data (
      .rst(adc_rst),
      .clk(adc_clk_in),
      .div_clk(adc_div_clk),
      .data_s0(adc_data[(3*12)+l_inst]),
      .data_s1(adc_data[(2*12)+l_inst]),
      .data_s2(adc_data[(1*12)+l_inst]),
      .data_s3(adc_data[(0*12)+l_inst]),
      .data_s4(),
      .data_s5(),
      .data_s6(),
      .data_s7(),
      .data_in_p(adc_data_in_p[l_inst]),
      .data_in_n(adc_data_in_n[l_inst]),
      .delay_clk(delay_clk),
      .delay_rst(delay_rst),
      .delay_ld(delay_ld[l_inst]),
      .delay_wdata(delay_wdata),
      .delay_rdata(delay_rdata_s[l_inst]),
      .delay_locked());
    end
  endgenerate

  // over-range interface
  ad_serdes_in #(
    .DEVICE_TYPE(PCORE_DEVTYPE),
    .IODELAY_CTRL(1),
    .IODELAY_GROUP(PCORE_IODELAY_GROUP),
    .IF_TYPE(SDR),
    .PARALLEL_WIDTH(4))
  i_adc_data (
    .rst(adc_rst),
    .clk(adc_clk_in),
    .div_clk(adc_div_clk),
    .data_s0(adc_or_s[0]),
    .data_s1(adc_or_s[1]),
    .data_s2(adc_or_s[2]),
    .data_s3(adc_or_s[3]),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_in_p(adc_or_in_p),
    .data_in_n(adc_or_in_n),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_ld(delay_ld[12]),
    .delay_wdata(delay_wdata),
    .delay_rdata(delay_rdata_s[12]),
    .delay_locked(delay_locked));

  // clock input buffers and MMCM
  ad_serdes_clk #(
    .MMCM_DEVICE_TYPE (PCORE_DEVTYPE),
    .MMCM_CLKIN_PERIOD (2),
    .MMCM_VCO_DIV (6),
    .MMCM_VCO_MUL (12),
    .MMCM_CLK0_DIV (2),
    .MMCM_CLK1_DIV (8))
  i_serdes_clk (
    .mmcm_rst (mmcm_rst),
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk_in),
    .div_clk (adc_div_clk),
    .drp_clk (drp_clk),
    .drp_rst (drp_rst),
    .drp_sel (drp_sel),
    .drp_wr (drp_wr),
    .drp_addr (drp_addr),
    .drp_wdata (drp_wdata),
    .drp_rdata (drp_rdata),
    .drp_ready (drp_ready),
    .drp_locked (drp_locked));

  // adc overange
  assign adc_or = adc_or_s[0] | adc_or_s[1] | adc_or_s[2] | adc_or_s[3];

  // adc status: adc is up, if both the MMCM and DELAY blocks are up
  always @(posedge adc_div_clk) begin
    if(adc_rst == 1'b1) begin
      adc_status_m1 <= 1'b0;
      adc_status <= 1'b0;
    end else begin
      adc_status_m1 <= drp_locked & delay_locked;
    end
  end

endmodule
