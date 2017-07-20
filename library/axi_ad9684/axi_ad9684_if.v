// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
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

module axi_ad9684_if (

  // device interface
  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_data_or_p,
  adc_data_or_n,

  // data interface
  adc_clk,
  adc_rst,
  adc_data_a,
  adc_or_a,
  adc_data_b,
  adc_or_b,
  adc_status,

  // delay interface
  delay_clk,
  delay_rst,
  delay_dload,
  delay_wdata,
  delay_rdata,
  delay_locked,

  // reset
  rst,

  // drp interface
  up_clk,
  up_rstn,
  up_drp_sel,
  up_drp_wr,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,
  up_drp_locked
);

  // parameters
  parameter DEVICE_TYPE = 0;                  // 0 - 7Series / 1 - 6Series
  parameter IO_DELAY_GROUP = "dev_if_delay_group";
  parameter OR_STATUS = 0;

  // buffer type based on the target device
  localparam DDR_OR_SDR_N = 1;

  // IO definitions

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [13:0]  adc_data_in_p;
  input   [13:0]  adc_data_in_n;
  input           adc_data_or_p;
  input           adc_data_or_n;

  output          adc_clk;
  input           adc_rst;
  output  [27:0]  adc_data_a;
  output          adc_or_a;
  output  [27:0]  adc_data_b;
  output          adc_or_b;
  output          adc_status;

  input           delay_clk;
  input           delay_rst;
  input   [14:0]  delay_dload;
  input   [74:0]  delay_wdata;
  output  [74:0]  delay_rdata;
  output          delay_locked;

  input           rst;

  input           up_clk;
  input           up_rstn;
  input           up_drp_sel;
  input           up_drp_wr;
  input   [11:0]  up_drp_addr;
  input   [31:0]  up_drp_wdata;
  output  [31:0]  up_drp_rdata;
  output          up_drp_ready;
  output          up_drp_locked;

  // internal registers

  reg             adc_status    = 'd0;
  reg             adc_status_m1 = 'd0;

  // internal signals

  wire            adc_clk_in;
  wire            adc_div_clk;
  wire  [ 1:0]    adc_data_or_a_s;
  wire  [ 1:0]    adc_data_or_b_s;
  wire            loaden_s;
  wire  [ 7:0]    phase_s;


  genvar          l_inst;

  // adc_clk is 1:2 of the sampling clock
  // f_max = 250 MHz

  assign  adc_clk = adc_div_clk;

  // data interface

  ad_serdes_in #(
    .DEVICE_TYPE(DEVICE_TYPE),
    .IODELAY_CTRL(1),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .DDR_OR_SDR_N(DDR_OR_SDR_N),
    .DATA_WIDTH(14))
  i_adc_data (
    .rst(adc_rst),
    .clk(adc_clk_in),
    .div_clk(adc_div_clk),
    .loaden(loaden_s),
    .phase(phase_s),
    .locked(1'b0),
    .data_s0(adc_data_b[27:14]),
    .data_s1(adc_data_a[27:14]),
    .data_s2(adc_data_b[13: 0]),
    .data_s3(adc_data_a[13: 0]),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_in_p(adc_data_in_p[13:0]),
    .data_in_n(adc_data_in_n[13:0]),
    .up_clk (up_clk),
    .up_dld (delay_dload[13:0]),
    .up_dwdata (delay_wdata[69:0]),
    .up_drdata (delay_rdata[69:0]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked));

  generate if (OR_STATUS == 1) begin

    ad_serdes_in #(
      .DEVICE_TYPE(DEVICE_TYPE),
      .IODELAY_CTRL(0),
      .IODELAY_GROUP(IO_DELAY_GROUP),
      .DDR_OR_SDR_N(DDR_OR_SDR_N),
      .DATA_WIDTH(1))
    i_adc_or (
      .rst(adc_rst),
      .clk(adc_clk_in),
      .div_clk(adc_div_clk),
      .loaden(loaden_s),
      .phase(phase_s),
      .locked(1'b0),
      .data_s0(adc_data_or_b_s[1]),
      .data_s1(adc_data_or_a_s[1]),
      .data_s2(adc_data_or_b_s[0]),
      .data_s3(adc_data_or_a_s[0]),
      .data_s4(),
      .data_s5(),
      .data_s6(),
      .data_s7(),
      .data_in_p(adc_data_or_p),
      .data_in_n(adc_data_or_n),
      .up_clk (up_clk),
      .up_dld (delay_dload[14]),
      .up_dwdata (delay_wdata[74:70]),
      .up_drdata (delay_rdata[74:70]),
      .delay_clk(delay_clk),
      .delay_rst(delay_rst),
      .delay_locked());

    assign adc_or_a = adc_data_or_a_s[0] | adc_data_or_a_s[1];
    assign adc_or_b = adc_data_or_b_s[0] | adc_data_or_b_s[1];

  end else begin

    assign adc_or_a = 1'b0;
    assign adc_or_b = 1'b0;

  end
  endgenerate

  // clock input buffers and MMCM_OR_BUFR_N

  ad_serdes_clk #(
    .DEVICE_TYPE (DEVICE_TYPE),
    .MMCM_CLKIN_PERIOD (2),
    .MMCM_VCO_DIV (6),
    .MMCM_VCO_MUL (12),
    .MMCM_CLK0_DIV (2),
    .MMCM_CLK1_DIV (4))
  i_serdes_clk (
    .rst (rst),
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk_in),
    .div_clk (adc_div_clk),
    .out_clk (),
    .loaden (loaden_s),
    .phase (phase_s),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked));

  // adc status: adc is up, if both the MMCM_OR_BUFR_N and DELAY blocks are up
  always @(posedge adc_div_clk) begin
    if(adc_rst == 1'b1) begin
      adc_status_m1 <= 1'b0;
      adc_status <= 1'b0;
    end else begin
      adc_status_m1 <= up_drp_locked;
      adc_status <= adc_status_m1;
    end
  end

endmodule
