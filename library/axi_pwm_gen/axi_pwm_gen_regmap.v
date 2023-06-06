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

module axi_pwm_gen_regmap #(

  parameter  ID = 0,
  parameter  CORE_MAGIC = 0,
  parameter  CORE_VERSION = 0,
  parameter  ASYNC_CLK_EN = 1,
  parameter  N_PWMS = 3,
  parameter  PULSE_0_WIDTH = 7,
  parameter  PULSE_1_WIDTH = 7,
  parameter  PULSE_2_WIDTH = 7,
  parameter  PULSE_3_WIDTH = 7,
  parameter  PULSE_0_PERIOD = 10,
  parameter  PULSE_1_PERIOD = 10,
  parameter  PULSE_2_PERIOD = 10,
  parameter  PULSE_3_PERIOD = 10,
  parameter  PULSE_0_EXT_SYNC = 0,
  parameter  PULSE_0_OFFSET = 0,
  parameter  PULSE_1_OFFSET = 0,
  parameter  PULSE_2_OFFSET = 0,
  parameter  PULSE_3_OFFSET = 0
) (

  // external clock

  input                   ext_clk,

  // control and status signals

  output                  clk_out,
  output                  pwm_gen_resetn,
  output     [127:0]      pwm_width,
  output     [127:0]      pwm_period,
  output     [127:0]      pwm_offset,
  output                  load_config,

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output reg              up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output reg  [31:0]      up_rdata,
  output reg              up_rack
);

  // internal registers

  reg     [31:0]  up_scratch = 'd0;
  reg     [31:0]  up_pwm_width_0 = PULSE_0_WIDTH;
  reg     [31:0]  up_pwm_width_1 = PULSE_1_WIDTH;
  reg     [31:0]  up_pwm_width_2 = PULSE_2_WIDTH;
  reg     [31:0]  up_pwm_width_3 = PULSE_3_WIDTH;
  reg     [31:0]  up_pwm_period_0 = PULSE_0_PERIOD;
  reg     [31:0]  up_pwm_period_1 = PULSE_1_PERIOD;
  reg     [31:0]  up_pwm_period_2 = PULSE_2_PERIOD;
  reg     [31:0]  up_pwm_period_3 = PULSE_3_PERIOD;
  reg     [31:0]  up_pwm_offset_0 = PULSE_0_OFFSET;
  reg     [31:0]  up_pwm_offset_1 = PULSE_1_OFFSET;
  reg     [31:0]  up_pwm_offset_2 = PULSE_2_OFFSET;
  reg     [31:0]  up_pwm_offset_3 = PULSE_3_OFFSET;
  reg             up_load_config = 1'b0;
  reg             up_reset = 1'b1;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_pwm_width_0 <= PULSE_0_WIDTH;
      up_pwm_width_1 <= PULSE_1_WIDTH;
      up_pwm_width_2 <= PULSE_2_WIDTH;
      up_pwm_width_3 <= PULSE_3_WIDTH;
      up_pwm_period_0 <= PULSE_0_PERIOD;
      up_pwm_period_1 <= PULSE_1_PERIOD;
      up_pwm_period_2 <= PULSE_2_PERIOD;
      up_pwm_period_3 <= PULSE_3_PERIOD;
      up_pwm_offset_0 <= PULSE_0_OFFSET;
      up_pwm_offset_1 <= PULSE_1_OFFSET;
      up_pwm_offset_2 <= PULSE_2_OFFSET;
      up_pwm_offset_3 <= PULSE_3_OFFSET;
      up_load_config <= 1'b0;
      up_reset <= 1'b1;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h2)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h4)) begin
        up_reset <= up_wdata[0];
        up_load_config <= up_wdata[1];
      end else begin
        up_load_config <= 1'b0;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h10)) begin
        up_pwm_period_0 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h11)) begin
        up_pwm_width_0 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h12)) begin
        up_pwm_offset_0 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h13)) begin
        up_pwm_period_1 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h14)) begin
        up_pwm_width_1 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h15)) begin
        up_pwm_offset_1 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h16)) begin
        up_pwm_period_2 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h17)) begin
        up_pwm_width_2 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h18)) begin
        up_pwm_offset_2 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h19)) begin
        up_pwm_period_3 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h1a)) begin
        up_pwm_width_3 <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h1b)) begin
        up_pwm_offset_3 <= up_wdata;
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          14'h0: up_rdata <= CORE_VERSION;
          14'h1: up_rdata <= ID;
          14'h2: up_rdata <= up_scratch;
          14'h3: up_rdata <= CORE_MAGIC;
          14'h4: up_rdata <= up_reset;
          14'h5: up_rdata <= N_PWMS;
          14'h10: up_rdata <= up_pwm_period_0;
          14'h11: up_rdata <= up_pwm_width_0;
          14'h12: up_rdata <= up_pwm_offset_0;
          14'h13: up_rdata <= up_pwm_period_1;
          14'h14: up_rdata <= up_pwm_width_1;
          14'h15: up_rdata <= up_pwm_offset_1;
          14'h16: up_rdata <= up_pwm_period_2;
          14'h17: up_rdata <= up_pwm_width_2;
          14'h18: up_rdata <= up_pwm_offset_2;
          14'h19: up_rdata <= up_pwm_period_3;
          14'h1a: up_rdata <= up_pwm_width_3;
          14'h1b: up_rdata <= up_pwm_offset_3;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  generate
  if (ASYNC_CLK_EN) begin : counter_external_clock

    assign clk_out = ext_clk;

    ad_rst i_d_rst_reg (
      .rst_async (up_reset),
      .clk (clk_out),
      .rstn (pwm_gen_resetn),
      .rst ());

    sync_data #(
      .NUM_OF_BITS (128),
      .ASYNC_CLK (1)
    ) i_pwm_period_sync (
      .in_clk (up_clk),
      .in_data ({up_pwm_period_3,
                 up_pwm_period_2,
                 up_pwm_period_1,
                 up_pwm_period_0}),
      .out_clk (clk_out),
      .out_data (pwm_period));

    sync_data #(
      .NUM_OF_BITS (128),
      .ASYNC_CLK (1)
    ) i_pwm_width_sync (
      .in_clk (up_clk),
      .in_data ({up_pwm_width_3,
                 up_pwm_width_2,
                 up_pwm_width_1,
                 up_pwm_width_0}),
      .out_clk (clk_out),
      .out_data (pwm_width));

    sync_data #(
      .NUM_OF_BITS (128),
      .ASYNC_CLK (1)
    ) i_pwm_offset_sync (
      .in_clk (up_clk),
      .in_data ({up_pwm_offset_3,
                 up_pwm_offset_2,
                 up_pwm_offset_1,
                 up_pwm_offset_0}),
      .out_clk (clk_out),
      .out_data (pwm_offset));

    sync_event #(
      .NUM_OF_EVENTS (1),
      .ASYNC_CLK (1)
    ) i_load_config_sync (
      .in_clk (up_clk),
      .in_event (up_load_config),
      .out_clk (clk_out),
      .out_event (load_config));

  end else begin : counter_sys_clock        // counter is running on system clk

    assign clk_out = up_clk;
    assign pwm_gen_resetn = ~up_reset;
    assign pwm_period = {up_pwm_period_3, up_pwm_period_2, up_pwm_period_1, up_pwm_period_0};
    assign pwm_width = {up_pwm_width_3, up_pwm_width_2, up_pwm_width_1, up_pwm_width_0};
    assign pwm_offset = {up_pwm_offset_3, up_pwm_offset_2, up_pwm_offset_1, up_pwm_offset_0};
    assign load_config = up_load_config;

  end
  endgenerate

endmodule
