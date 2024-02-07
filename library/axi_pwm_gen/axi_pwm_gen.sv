// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2024 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/100ps

module axi_pwm_gen #(

  parameter  ID = 0,
  parameter  ASYNC_CLK_EN = 1,
  parameter  N_PWMS = 1,
  parameter  PWM_EXT_SYNC = 0,
  parameter  EXT_ASYNC_SYNC = 0,
  parameter  PULSE_0_WIDTH = 7,
  parameter  PULSE_1_WIDTH = 7,
  parameter  PULSE_2_WIDTH = 7,
  parameter  PULSE_3_WIDTH = 7,
  parameter  PULSE_4_WIDTH = 7,
  parameter  PULSE_5_WIDTH = 7,
  parameter  PULSE_6_WIDTH = 7,
  parameter  PULSE_7_WIDTH = 7,
  parameter  PULSE_8_WIDTH = 7,
  parameter  PULSE_9_WIDTH = 7,
  parameter  PULSE_10_WIDTH = 7,
  parameter  PULSE_11_WIDTH = 7,
  parameter  PULSE_12_WIDTH = 7,
  parameter  PULSE_13_WIDTH = 7,
  parameter  PULSE_14_WIDTH = 7,
  parameter  PULSE_15_WIDTH = 7,
  parameter  PULSE_0_PERIOD = 10,
  parameter  PULSE_1_PERIOD = 10,
  parameter  PULSE_2_PERIOD = 10,
  parameter  PULSE_3_PERIOD = 10,
  parameter  PULSE_4_PERIOD = 10,
  parameter  PULSE_5_PERIOD = 10,
  parameter  PULSE_6_PERIOD = 10,
  parameter  PULSE_7_PERIOD = 10,
  parameter  PULSE_8_PERIOD = 10,
  parameter  PULSE_9_PERIOD = 10,
  parameter  PULSE_10_PERIOD = 10,
  parameter  PULSE_11_PERIOD = 10,
  parameter  PULSE_12_PERIOD = 10,
  parameter  PULSE_13_PERIOD = 10,
  parameter  PULSE_14_PERIOD = 10,
  parameter  PULSE_15_PERIOD = 10,
  parameter  PULSE_0_OFFSET = 0,
  parameter  PULSE_1_OFFSET = 0,
  parameter  PULSE_2_OFFSET = 0,
  parameter  PULSE_3_OFFSET = 0,
  parameter  PULSE_4_OFFSET = 0,
  parameter  PULSE_5_OFFSET = 0,
  parameter  PULSE_6_OFFSET = 0,
  parameter  PULSE_7_OFFSET = 0,
  parameter  PULSE_8_OFFSET = 0,
  parameter  PULSE_9_OFFSET = 0,
  parameter  PULSE_10_OFFSET = 0,
  parameter  PULSE_11_OFFSET = 0,
  parameter  PULSE_12_OFFSET = 0,
  parameter  PULSE_13_OFFSET = 0,
  parameter  PULSE_14_OFFSET = 0,
  parameter  PULSE_15_OFFSET = 0
) (

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready,
  input                   ext_clk,
  input                   ext_sync,

  output                  pwm_0,
  output                  pwm_1,
  output                  pwm_2,
  output                  pwm_3,
  output                  pwm_4,
  output                  pwm_5,
  output                  pwm_6,
  output                  pwm_7,
  output                  pwm_8,
  output                  pwm_9,
  output                  pwm_10,
  output                  pwm_11,
  output                  pwm_12,
  output                  pwm_13,
  output                  pwm_14,
  output                  pwm_15
);

  // local parameters

  localparam        PWMS = N_PWMS-1;
  localparam [31:0] CORE_VERSION = {16'h0002,     /* MAJOR */
                                     8'h00,       /* MINOR */
                                     8'h00};      /* PATCH */
  localparam [31:0] CORE_MAGIC = 32'h601a3471;    // PLSG
  localparam reg [31:0] PULSE_WIDTH_G[15:0] = '{PULSE_0_WIDTH,
                                                PULSE_1_WIDTH,
                                                PULSE_2_WIDTH,
                                                PULSE_3_WIDTH,
                                                PULSE_4_WIDTH,
                                                PULSE_5_WIDTH,
                                                PULSE_6_WIDTH,
                                                PULSE_7_WIDTH,
                                                PULSE_8_WIDTH,
                                                PULSE_9_WIDTH,
                                                PULSE_10_WIDTH,
                                                PULSE_11_WIDTH,
                                                PULSE_12_WIDTH,
                                                PULSE_13_WIDTH,
                                                PULSE_14_WIDTH,
                                                PULSE_15_WIDTH};

  localparam reg [31:0] PULSE_PERIOD_G[0:15] = '{PULSE_0_PERIOD,
                                                 PULSE_1_PERIOD,
                                                 PULSE_2_PERIOD,
                                                 PULSE_3_PERIOD,
                                                 PULSE_4_PERIOD,
                                                 PULSE_5_PERIOD,
                                                 PULSE_6_PERIOD,
                                                 PULSE_7_PERIOD,
                                                 PULSE_8_PERIOD,
                                                 PULSE_9_PERIOD,
                                                 PULSE_10_PERIOD,
                                                 PULSE_11_PERIOD,
                                                 PULSE_12_PERIOD,
                                                 PULSE_13_PERIOD,
                                                 PULSE_14_PERIOD,
                                                 PULSE_15_PERIOD};

  localparam reg [31:0] PULSE_OFFSET_G[0:15] = '{PULSE_0_OFFSET,
                                                 PULSE_1_OFFSET,
                                                 PULSE_2_OFFSET,
                                                 PULSE_3_OFFSET,
                                                 PULSE_4_OFFSET,
                                                 PULSE_5_OFFSET,
                                                 PULSE_6_OFFSET,
                                                 PULSE_7_OFFSET,
                                                 PULSE_8_OFFSET,
                                                 PULSE_9_OFFSET,
                                                 PULSE_10_OFFSET,
                                                 PULSE_11_OFFSET,
                                                 PULSE_12_OFFSET,
                                                 PULSE_13_OFFSET,
                                                 PULSE_14_OFFSET,
                                                 PULSE_15_OFFSET};

  // internal registers

  reg [PWMS:0]    sync;
  reg   [31:0]    offset_cnt = 32'd0;
  reg             offset_alignment = 1'b0;
  reg             pause_cnt_d = 1'b0;

  // internal signals

  wire            clk;
  wire            up_clk;
  wire            up_rstn;
  wire            up_rreq_s;
  wire            up_wack_s;
  wire            up_rack_s;
  wire   [ 13:0]  up_raddr_s;
  wire   [ 31:0]  up_rdata_s;
  wire            up_wreq_s;
  wire   [ 13:0]  up_waddr_s;
  wire   [ 31:0]  up_wdata_s;
  wire   [ 15:0]  pwm;
  wire   [ 31:0]  pwm_width_s[0:PWMS];
  wire   [ 31:0]  pwm_period_s[0:PWMS];
  wire   [ 31:0]  pwm_offset_s[0:PWMS];
  wire   [ 15:0]  pwm_armed;
  wire            load_config_s;
  wire            pwm_gen_resetn;
  wire            ext_sync_s;
  wire            pause_cnt;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  axi_pwm_gen_regmap #(
    .ID (ID),
    .ASYNC_CLK_EN (ASYNC_CLK_EN),
    .CORE_MAGIC (CORE_MAGIC),
    .CORE_VERSION (CORE_VERSION),
    .N_PWMS (PWMS),
    .PULSE_WIDTH_G (PULSE_WIDTH_G),
    .PULSE_PERIOD_G (PULSE_PERIOD_G),
    .PULSE_OFFSET_G (PULSE_OFFSET_G)
  ) i_regmap (
    .ext_clk (ext_clk),
    .clk_out (clk),
    .pwm_gen_resetn (pwm_gen_resetn),
    .pwm_width (pwm_width_s),
    .pwm_period (pwm_period_s),
    .pwm_offset (pwm_offset_s),
    .load_config (load_config_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  // external sync

  generate

    reg ext_sync_m0 = 1'b1;
    reg ext_sync_m1 = 1'b1;

    if (EXT_ASYNC_SYNC) begin
      always @(posedge clk) begin
        if (pwm_gen_resetn == 1'b0) begin
          ext_sync_m0 <=  1'b1;
          ext_sync_m1 <=  1'b1;
        end else begin
          ext_sync_m0 <= (PWM_EXT_SYNC == 1) ? ext_sync : 0;
          ext_sync_m1 <= ext_sync_m0;
        end
      end
      assign ext_sync_s = ext_sync_m1;
    end else begin
      assign ext_sync_s = (PWM_EXT_SYNC == 1) ? ext_sync : 0;
    end

  endgenerate

  // offset counter

  always @(posedge clk) begin
    if (offset_alignment ==  1'b1 || pwm_gen_resetn == 1'b0) begin
      offset_cnt <= 32'd0;
    end else begin
      offset_cnt <= offset_cnt + 1'b1;
    end

    if (pwm_gen_resetn == 1'b0) begin
      offset_alignment <= 1'b0;
    end else begin
      // when using external sync an offset alignment can be done only
      // after all pwm counters are paused(load_config)/reseated
      offset_alignment <= (load_config_s == 1'b1) ? 1'b1 :
                          offset_alignment &
                          (ext_sync_s ? 1'b1 : !pause_cnt);
    end
  end

  assign pause_cnt = ((pwm_armed[0]  |
                       pwm_armed[1]  |
                       pwm_armed[2]  |
                       pwm_armed[3]  |
                       pwm_armed[4]  |
                       pwm_armed[5]  |
                       pwm_armed[6]  |
                       pwm_armed[7]  |
                       pwm_armed[8]  |
                       pwm_armed[9]  |
                       pwm_armed[10] |
                       pwm_armed[11] |
                       pwm_armed[12] |
                       pwm_armed[13] |
                       pwm_armed[14] |
                       pwm_armed[15] ) ? 1'b1 : 1'b0);
  genvar i;
  generate
    for (i = 0; i <= 15; i = i + 1) begin: pwm_cnt
      if (i <= PWMS) begin
        axi_pwm_gen_1  #(
          .PULSE_WIDTH (PULSE_WIDTH_G[i]),
          .PULSE_PERIOD (PULSE_PERIOD_G[i])
        ) i_axi_pwm_gen_1 (
          .clk (clk),
          .rstn (pwm_gen_resetn),
          .pulse_width (pwm_width_s[i]),
          .pulse_period (pwm_period_s[i]),
          .load_config (load_config_s),
          .sync (sync[i]),
          .pulse (pwm[i]),
          .pulse_armed (pwm_armed[i]));
        always @(posedge clk) begin
          if (pwm_gen_resetn == 1'b0) begin
            sync[i] <= 1'b1;
          end else begin
            sync[i] <= (offset_cnt == pwm_offset_s[i]) ? offset_alignment : 1'b1;
          end
        end
      end else begin
       assign pwm[i] = 1'b0;
       assign pwm_armed[i] = 1'b0;
      end
    end
  endgenerate

  assign pwm_0 =  pwm[0];
  assign pwm_1 =  pwm[1];
  assign pwm_2 =  pwm[2];
  assign pwm_3 =  pwm[3];
  assign pwm_4 =  pwm[4];
  assign pwm_5 =  pwm[5];
  assign pwm_6 =  pwm[6];
  assign pwm_7 =  pwm[7];
  assign pwm_8 =  pwm[8];
  assign pwm_9 =  pwm[9];
  assign pwm_10 = pwm[10];
  assign pwm_11 = pwm[11];
  assign pwm_12 = pwm[12];
  assign pwm_13 = pwm[13];
  assign pwm_14 = pwm[14];
  assign pwm_15 = pwm[15];

  up_axi #(
    .AXI_ADDRESS_WIDTH(16)
  ) i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

endmodule
