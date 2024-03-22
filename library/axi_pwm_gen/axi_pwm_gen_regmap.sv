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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/100ps

module axi_pwm_gen_regmap #(

  parameter            ID = 0,
  parameter            CORE_MAGIC = 0,
  parameter            CORE_VERSION = 0,
  parameter            ASYNC_CLK_EN = 1,
  parameter            SOFTWARE_BRINGUP = 1,
  parameter            EXT_SYNC_PHASE_ALIGN = 0,
  parameter            FORCE_ALIGN = 0,
  parameter            START_AT_SYNC = 1,
  parameter            N_PWMS = 0,
  parameter reg [31:0] PULSE_WIDTH_G[0:15]  = '{16{32'd0}},
  parameter reg [31:0] PULSE_PERIOD_G[0:15] = '{16{32'd0}},
  parameter reg [31:0] PULSE_OFFSET_G[0:15] = '{16{32'd0}}
) (

  // external clock

  input                   ext_clk,

  // control and status signals

  output                  clk_out,
  output                  pwm_gen_resetn,
  output      [31:0]      pwm_width[0:N_PWMS],
  output      [31:0]      pwm_period[0:N_PWMS],
  output      [31:0]      pwm_offset[0:N_PWMS],
  output                  load_config,
  output                  start_at_sync,
  output                  force_align,
  output                  ext_sync_align,

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
  reg     [31:0]  up_pwm_width[0:N_PWMS] = PULSE_WIDTH_G[0:N_PWMS];
  reg     [31:0]  up_pwm_period[0:N_PWMS] = PULSE_PERIOD_G[0:N_PWMS];
  reg     [31:0]  up_pwm_offset[0:N_PWMS] = PULSE_OFFSET_G[0:N_PWMS];
  reg             up_load_config = 1'b0;
  reg             up_reset = SOFTWARE_BRINGUP[0];
  reg     [ 2:0]  up_control = {EXT_SYNC_PHASE_ALIGN[0],FORCE_ALIGN[0],START_AT_SYNC[0]};

  // internal signals

  wire    [ 2:0]  control;

  assign start_at_sync = control[0];
  assign force_align = control[1];
  assign ext_sync_align = control[2];

  genvar n;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_pwm_width <= PULSE_WIDTH_G[0:N_PWMS];
      up_pwm_period <= PULSE_PERIOD_G[0:N_PWMS];
      up_pwm_offset <= PULSE_OFFSET_G[0:N_PWMS];
      up_load_config <= 1'b0;
      up_reset <= SOFTWARE_BRINGUP[0];
      up_control <= {EXT_SYNC_PHASE_ALIGN[0],FORCE_ALIGN[0],START_AT_SYNC[0]};
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
      if ((up_wreq == 1'b1) && (up_waddr == 14'h6)) begin
        up_control <= up_wdata[2:0];
      end
      for (int i = 0; i <= N_PWMS; i++) begin
        if ((up_wreq == 1'b1) && (up_waddr == 14'h10 + i)) begin
          up_pwm_period[i] <= up_wdata;
        end
        if ((up_wreq == 1'b1) && (up_waddr == 14'h20 + i)) begin
          up_pwm_width[i] <= up_wdata;
        end
        if ((up_wreq == 1'b1) && (up_waddr == 14'h30 + i)) begin
          up_pwm_offset[i] <= up_wdata;
        end
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
        if (up_raddr[13:4] == 10'd0) begin
          case (up_raddr)
            14'h0: up_rdata <= CORE_VERSION;
            14'h1: up_rdata <= ID;
            14'h2: up_rdata <= up_scratch;
            14'h3: up_rdata <= CORE_MAGIC;
            14'h4: up_rdata <= up_reset;
            14'h5: up_rdata <= N_PWMS +1;
            14'h6: up_rdata <= {29'd0, up_control};
            default: up_rdata <= 0;
          endcase
        end else if (up_raddr[3:0] > N_PWMS) begin
          up_rdata <= 32'b0;
        end else if (up_raddr[13:4] == 10'd1) begin
          up_rdata <= up_pwm_period[up_raddr[3:0]];
        end else if (up_raddr[13:4] == 10'd2) begin
          up_rdata <= up_pwm_width[up_raddr[3:0]];
        end else if (up_raddr[13:4] == 10'd3) begin
          up_rdata <= up_pwm_offset[up_raddr[3:0]];
        end
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
      .NUM_OF_BITS (3),
      .ASYNC_CLK (1))
    i_pwm_controls (
      .in_clk (up_clk),
      .in_data (up_control),
      .out_clk (clk_out),
      .out_data (control));

    for (n = 0; n <= N_PWMS; n = n + 1) begin: pwm_cdc
      sync_data #(
        .NUM_OF_BITS (96),
        .ASYNC_CLK (1))
      i_pwm_props (
        .in_clk (up_clk),
        .in_data ({up_pwm_period[n],
                   up_pwm_width[n],
                   up_pwm_offset[n]}),
        .out_clk (clk_out),
        .out_data ({pwm_period[n],
                    pwm_width[n],
                    pwm_offset[n]}));
    end

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
    for (n = 0; n <= N_PWMS; n = n + 1) begin: up_cd
      assign pwm_period[n] = up_pwm_period[n];
      assign pwm_width[n] = up_pwm_width[n];
      assign pwm_offset[n] = up_pwm_offset[n];
    end
    assign load_config = up_load_config;

  end
  endgenerate

endmodule
