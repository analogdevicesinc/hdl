// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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
  parameter  PULSE_0_PERIOD = 10,
  parameter  PULSE_1_PERIOD = 10,
  parameter  PULSE_2_PERIOD = 10,
  parameter  PULSE_3_PERIOD = 10,
  parameter  PULSE_0_OFFSET = 0,
  parameter  PULSE_1_OFFSET = 0,
  parameter  PULSE_2_OFFSET = 0,
  parameter  PULSE_3_OFFSET = 0
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
  output                  pwm_3
);

  // local parameters

  localparam [31:0] CORE_VERSION = {16'h0001,     /* MAJOR */
                                     8'h00,       /* MINOR */
                                     8'h00};      /* PATCH */
  localparam [31:0] CORE_MAGIC = 32'h601a3471;    // PLSG

  // internal registers

  reg             sync_0 = 1'b0;
  reg             sync_1 = 1'b0;
  reg             sync_2 = 1'b0;
  reg             sync_3 = 1'b0;
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
  wire   [127:0]  pwm_width_s;
  wire   [127:0]  pwm_period_s;
  wire   [127:0]  pwm_offset_s;
  wire   [ 31:0]  pwm_counter[0:3];
  wire            load_config_s;
  wire            pwm_gen_resetn;
  wire            ext_sync_s;
  wire            pause_cnt;
  wire            offset_alignment_ready;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  axi_pwm_gen_regmap #(
    .ID (ID),
    .ASYNC_CLK_EN (ASYNC_CLK_EN),
    .CORE_MAGIC (CORE_MAGIC),
    .CORE_VERSION (CORE_VERSION),
    .N_PWMS (N_PWMS),
    .PULSE_0_WIDTH (PULSE_0_WIDTH),
    .PULSE_1_WIDTH (PULSE_1_WIDTH),
    .PULSE_2_WIDTH (PULSE_2_WIDTH),
    .PULSE_3_WIDTH (PULSE_3_WIDTH),
    .PULSE_0_PERIOD (PULSE_0_PERIOD),
    .PULSE_1_PERIOD (PULSE_1_PERIOD),
    .PULSE_2_PERIOD (PULSE_2_PERIOD),
    .PULSE_3_PERIOD (PULSE_3_PERIOD),
    .PULSE_0_OFFSET (PULSE_0_OFFSET),
    .PULSE_1_OFFSET (PULSE_1_OFFSET),
    .PULSE_2_OFFSET (PULSE_2_OFFSET),
    .PULSE_3_OFFSET (PULSE_3_OFFSET)
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
      pause_cnt_d <= 1'b0;
      offset_alignment <= 1'b0;
    end else begin
      pause_cnt_d <= pause_cnt_d;

      // when using external sync an offset alignment can be done only
      // after all pwm counters are paused(load_config)/reseated
      offset_alignment <= (load_config_s == 1'b1) ? 1'b1 :
                          offset_alignment &
                          (ext_sync_s ? 1'b1 : !offset_alignment_ready);
    end
  end

  assign pause_cnt = ((pwm_counter[0] == 32'd1 ||
                       pwm_counter[1] == 32'd1 ||
                       pwm_counter[2] == 32'd1 ||
                       pwm_counter[3] == 32'd1) ? 1'b1 : 1'b0);
  assign offset_alignment_ready = !pause_cnt_d & pause_cnt;

  axi_pwm_gen_1  #(
    .PULSE_WIDTH (PULSE_0_WIDTH),
    .PULSE_PERIOD (PULSE_0_PERIOD)
  ) i0_axi_pwm_gen_1(
    .clk (clk),
    .rstn (pwm_gen_resetn),
    .pulse_width (pwm_width_s[31:0]),
    .pulse_period (pwm_period_s[31:0]),
    .load_config (load_config_s),
    .sync (sync_0),
    .pulse (pwm_0),
    .pulse_counter (pwm_counter[0]));

  always @(posedge clk) begin
    if (pwm_gen_resetn == 1'b0) begin
      sync_0 <= 1'b1;
    end else begin
      sync_0 <= (offset_cnt == pwm_offset_s[31:0]) ? 1'b0 : 1'b1;
    end
  end

  generate

    if (N_PWMS >= 2) begin
      axi_pwm_gen_1  #(
        .PULSE_WIDTH (PULSE_1_WIDTH),
        .PULSE_PERIOD (PULSE_1_PERIOD)
      ) i1_axi_pwm_gen_1(
        .clk (clk),
        .rstn (pwm_gen_resetn),
        .pulse_width (pwm_width_s[63:32]),
        .pulse_period (pwm_period_s[63:32]),
        .load_config (load_config_s),
        .sync (sync_1),
        .pulse (pwm_1),
        .pulse_counter (pwm_counter[1]));

      always @(posedge clk) begin
        if (pwm_gen_resetn == 1'b0) begin
          sync_1 <= 1'b1;
        end else begin
          sync_1 <= (offset_cnt == pwm_offset_s[63:32]) ? 1'b0 : 1'b1;
        end
      end
    end else begin
      assign pwm_1 = 1'b0;
      assign pwm_counter[1] = 32'd1;
    end

    if (N_PWMS >= 3) begin
      axi_pwm_gen_1  #(
        .PULSE_WIDTH (PULSE_2_WIDTH),
        .PULSE_PERIOD (PULSE_2_PERIOD)
      ) i2_axi_pwm_gen_1(
        .clk (clk),
        .rstn (pwm_gen_resetn),
        .pulse_width (pwm_width_s[95:64]),
        .pulse_period (pwm_period_s[95:64]),
        .load_config (load_config_s),
        .sync (sync_2),
        .pulse (pwm_2),
        .pulse_counter (pwm_counter[2]));

      always @(posedge clk) begin
        if (pwm_gen_resetn == 1'b0) begin
          sync_2 <= 1'b1;
        end else begin
          sync_2 <= (offset_cnt == pwm_offset_s[95:64]) ? 1'b0 : 1'b1;
        end
      end
    end else begin
      assign pwm_2 = 1'b0;
      assign pwm_counter[2] = 32'd1;
    end

    if (N_PWMS >= 4) begin
      axi_pwm_gen_1  #(
        .PULSE_WIDTH (PULSE_3_WIDTH),
        .PULSE_PERIOD (PULSE_3_PERIOD)
      ) i3_axi_pwm_gen_1(
        .clk (clk),
        .rstn (pwm_gen_resetn),
        .pulse_width (pwm_width_s[127:96]),
        .pulse_period (pwm_period_s[127:96]),
        .load_config (load_config_s),
        .sync (sync_3),
        .pulse (pwm_3),
        .pulse_counter (pwm_counter[3]));

      always @(posedge clk) begin
        if (pwm_gen_resetn == 1'b0) begin
          sync_3 <= 1'b1;
        end else begin
          sync_3 <= (offset_cnt == pwm_offset_s[127:96]) ? 1'b0 : 1'b1;
        end
      end
    end else begin
      assign pwm_3 = 1'b0;
      assign pwm_counter[3] = 32'd1;
    end
  endgenerate

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
