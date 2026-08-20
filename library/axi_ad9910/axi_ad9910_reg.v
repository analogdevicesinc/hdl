// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns / 1ps

module axi_ad9910_reg #(

  // parameters

  parameter         ID = 0,
  parameter [ 7:0]  FPGA_TECHNOLOGY = 0,
  parameter [ 7:0]  FPGA_FAMILY = 0,
  parameter [ 7:0]  SPEED_GRADE = 0,
  parameter [ 7:0]  DEV_PACKAGE = 0,
  parameter         CONFIG = 0,
  parameter         MEASURE_CLKS_EN = 0
) (

  // sync clock domain
  input             sync_clk,
  output            reset_sync_cd,
  output            drctl_toggle_en,
  output            drctl_init,
  output            drhold,
  output     [ 2:0] profile,
  input      [ 5:0] irq_int,
  output     [ 5:0] irq_mask,
  output     [ 5:0] irq_clear,
  output     [ 1:0] irq_monitor_config,
  output     [ 5:0] trig_out_mask,
  output     [ 1:0] trig_config,
  output     [ 1:0] ramp_config,

  // parallel clk domain
  input             pd_clk,
  output            reset_pd,
  output            sd_ext_sync_disarm,
  output            sd_ext_sync_arm,
  output            pd_ext_sync_disarm,
  output            pd_ext_sync_arm,
  output            transfer_trig_mode,
  output            enable_p_if,
  output            load_new_rate,
  output     [31:0] update_rate,
  output     [ 1:0] f_cfg,

  output     [31:0] delay_bst_ramp_delay,
  output     [31:0] drctl_period,
  output     [31:0] drctl_width,

  output     [31:0] burst_delay,
  output     [19:0] ramp_bursts,
  output     [31:0] irq_start_interval,
  output     [31:0] irq_stop_interval,
  output     [31:0] trig_out_start_interval,
  output     [31:0] trig_out_stop_interval,
  output     [31:0] monitor_max_period,

  // processor interface

  input             up_rstn,
  input             up_clk,
  input             up_wreq,
  input      [13:0] up_waddr,
  input      [31:0] up_wdata,
  output reg        up_wack,
  input             up_rreq,
  input      [13:0] up_raddr,
  output reg [31:0] up_rdata,
  output reg        up_rack
);

  // local parameters

  localparam  VERSION = 32'h00090262;

  // internal registers

  reg [31:0]  up_scratch = 'd0;
  reg         up_reset = 'd0;
  reg         up_ext_sync_disarm = 'd1;
  reg         up_ext_sync_arm = 'd0;
  reg         up_drctl_toggle_en = 'd0;
  reg         up_drctl_init = 'd0;
  reg         up_drhold = 'd0;
  reg [ 2:0]  up_profile = 'd0;
  reg         up_transfer_trig_mode = 'd0;
  reg         up_enable_p_if = 'd0;
  reg         up_load_new_rate = 'd0;
  reg [31:0]  up_par_update_rate = 'd0;
  reg [ 1:0]  up_f_cfg = 'd0;
  reg [ 5:0]  up_irq_mask = 'd0;
  reg [ 5:0]  up_irq_clear = 'd0;
  reg [ 1:0]  up_irq_monitor_config = 'd0;
  reg [ 5:0]  up_trig_out_mask = 'd0;
  reg [ 1:0]  up_trig_config = 'd0;
  reg [ 1:0]  up_ramp_config = 'd0;

  reg [31:0]  up_delay_bst_ramp_delay = 'd0;
  reg [31:0]  up_drctl_period = 'd0;
  reg [31:0]  up_drctl_width = 'd0;
  reg [31:0]  up_burst_delay = 'd0;
  reg [19:0]  up_ramp_bursts = 'd0;
  reg [31:0]  up_irq_start_interval = 'd0;
  reg [31:0]  up_irq_stop_interval = 'd0;
  reg [31:0]  up_trig_start_interval = 'd0;
  reg [31:0]  up_trig_stop_interval = 'd0;
  reg [31:0]  up_monitor_max_period = 'd0;

  // internal signals

  wire        up_reset_s;
  wire        resetn_pd;
  wire        resetn_sync_cd;
  wire [31:0] up_sync_clk_count_s;
  wire [31:0] up_pd_clk_count_s;
  wire        up_cntrl_xfer_sd_done_s;
  wire        up_cntrl_xfer_pd_done_s;
  wire [ 5:0] up_irq_int_s;
  wire        overwrite_reset_cnt_done;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_reset <= 'd1;
      up_ext_sync_disarm <= 'd1;
      up_ext_sync_arm <= 'd0;
      up_drctl_toggle_en <= 'd0;
      up_drctl_init <= 'd0;
      up_drhold <= 'd0;
      up_profile <= 'd0;
      up_transfer_trig_mode <= 'd0;
      up_enable_p_if <= 'd0;
      up_load_new_rate <= 'd0;
      up_par_update_rate <= 'd0;
      up_f_cfg <= 'd0;
      up_irq_mask <= 'd0;
      up_irq_clear <= 'd0;
      up_irq_monitor_config <= 'd0;
      up_trig_out_mask <= 'd0;
      up_trig_config <= 'd0;
      up_ramp_config <= 'd0;
      up_delay_bst_ramp_delay <= 'd0;
      up_drctl_period <= 'd0;
      up_drctl_width <= 'd0;
      up_burst_delay <= 'd0;
      up_ramp_bursts <= 'd0;
      up_irq_start_interval <= 'd0;
      up_irq_stop_interval <= 'd0;
      up_trig_start_interval <= 'd0;
      up_trig_stop_interval <= 'd0;
      up_monitor_max_period <= 'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h2)) begin
        up_scratch <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h10)) begin
        up_reset <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h11)) begin
        up_irq_mask <= up_wdata[5:0];
      end
      if ((|up_irq_clear == 1'h1) && (up_cntrl_xfer_sd_done_s == 1'b1)) begin
        up_irq_clear <= 'd0;
      end else if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h12)) begin
        up_irq_clear <= up_wdata[5:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h13)) begin
        up_irq_monitor_config <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h014)) begin
        up_trig_out_mask <= up_wdata[21:16];
        up_trig_config <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h15)) begin
        {up_ext_sync_disarm, up_ext_sync_arm} <= up_wdata[1:0];
      end

      // linear ramp gen config
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h21)) begin
        {up_drctl_toggle_en,
         up_drctl_init,
         up_drhold} <= up_wdata[3:1];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h22)) begin
        up_profile <= up_wdata[2:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h23)) begin
        up_drctl_period <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h24)) begin
        up_drctl_width <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h25)) begin
        up_delay_bst_ramp_delay <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h26)) begin
        up_ramp_bursts <= up_wdata[19:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h27)) begin
        up_burst_delay <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h28)) begin
        up_ramp_config <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h29)) begin
        up_monitor_max_period <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h2a)) begin
        up_irq_start_interval <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h2b)) begin
        up_irq_stop_interval <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h2c)) begin
        up_trig_start_interval <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h2d)) begin
        up_trig_stop_interval <= up_wdata;
      end
      // parallel if config
      if ((up_load_new_rate == 1'h1) && (up_cntrl_xfer_pd_done_s == 1'b1)) begin
        up_load_new_rate <= 1'b0;
      end else if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h41)) begin
        {up_transfer_trig_mode,
         up_enable_p_if,
         up_load_new_rate} <= up_wdata[2:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h42)) begin
        up_par_update_rate <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[6:0] == 7'h43)) begin
        up_f_cfg <= up_wdata[1:0];
      end
    end
  end

  assign up_reset_s = up_reset;

  // processor read interface

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          // common
          7'h00: up_rdata <= VERSION;
          7'h01: up_rdata <= ID;
          7'h02: up_rdata <= up_scratch;
          7'h03: up_rdata <= CONFIG;
          7'h07: up_rdata <= {FPGA_TECHNOLOGY,FPGA_FAMILY,SPEED_GRADE,DEV_PACKAGE}; // [8,8,8,8]
          7'h10: up_rdata <= {31'd0, up_reset};
          7'h11: up_rdata <= {26'd0, up_irq_mask};
          7'h12: up_rdata <= {25'd0, up_irq_int_s}; // W1C through up_irq_clear
          7'h13: up_rdata <= {30'd0, up_irq_monitor_config};
          7'h14: up_rdata <= {10'd0, up_trig_out_mask, 14'd0, up_trig_config};
          7'h15: up_rdata <= {30'd0, up_ext_sync_disarm,
                                     up_ext_sync_arm};
          // linear ramp gen config
          7'h20: up_rdata <= up_sync_clk_count_s;
          7'h21: up_rdata <= {28'd0, up_drctl_toggle_en,
                                     up_drctl_init,
                                     up_drhold, 1'b0};
          7'h22: up_rdata <= {29'd0, up_profile};
          7'h23: up_rdata <= up_drctl_period;
          7'h24: up_rdata <= up_drctl_width;
          7'h25: up_rdata <= up_delay_bst_ramp_delay; // delay before start
          7'h26: up_rdata <= {12'd0, up_ramp_bursts};
          7'h27: up_rdata <= up_burst_delay;
          7'h28: up_rdata <= {30'd0, up_ramp_config};
          7'h29: up_rdata <= up_monitor_max_period;
          7'h2a: up_rdata <= up_irq_start_interval;
          7'h2b: up_rdata <= up_irq_stop_interval;
          7'h2c: up_rdata <= up_trig_start_interval;
          7'h2d: up_rdata <= up_trig_stop_interval;
          // parallel if config
          7'h40: up_rdata <= up_pd_clk_count_s;
          7'h41: up_rdata <= {29'd0, up_transfer_trig_mode,
                                     up_enable_p_if,
                                     up_load_new_rate};
          7'h42: up_rdata <= up_par_update_rate;
          7'h43: up_rdata <= {30'd0, up_f_cfg};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // resets

  ad_rst i_sync_cd_rst_reg (
    .rst_async(up_reset_s),
    .clk(sync_clk),
    .rstn(resetn_sync_cd),
    .rst(reset_sync_cd));

  ad_rst i_pd_cd_rst_reg (
    .rst_async(up_reset),
    .clk(pd_clk),
    .rstn(resetn_pd),
    .rst(reset_pd));

  up_xfer_status #(
    .DATA_WIDTH(6)
  ) i_xfer_status_sd (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status (up_irq_int_s),
    .d_rst (reset_sync_cd),
    .d_clk (sync_clk),
    .d_data_status (irq_int));

  // sync cd control signals

  up_xfer_cntrl #(
    .DATA_WIDTH(340)
  ) i_xfer_cntrl_sd (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({up_drctl_toggle_en,       // 1
                     up_drctl_init,            // 1
                     up_drhold,                // 1
                     up_profile,               // 3
                     up_irq_mask,              // 6
                     up_irq_clear,             // 6
                     up_irq_monitor_config,    // 2
                     up_trig_out_mask,         // 6
                     up_ext_sync_disarm,       // 1
                     up_ext_sync_arm,          // 1
                     up_trig_config,           // 2
                     up_ramp_config,           // 2
                     up_delay_bst_ramp_delay,  // 32
                     up_drctl_period,          // 32
                     up_drctl_width,           // 32
                     up_burst_delay,           // 32
                     up_ramp_bursts,           // 20
                     up_irq_start_interval,    // 32
                     up_irq_stop_interval,     // 32
                     up_trig_start_interval,   // 32
                     up_trig_stop_interval,    // 32
                     up_monitor_max_period}),  // 32
    .up_xfer_done (up_cntrl_xfer_sd_done_s),
    .d_rst (reset_sync_cd),
    .d_clk (sync_clk),
    .d_data_cntrl ({drctl_toggle_en,         // 1
                    drctl_init,              // 1
                    drhold,                  // 1
                    profile,                 // 3
                    irq_mask,                // 6
                    irq_clear,               // 6
                    irq_monitor_config,      // 2
                    trig_out_mask,           // 6
                    sd_ext_sync_disarm,      // 1
                    sd_ext_sync_arm,         // 1
                    trig_config,             // 2
                    ramp_config,             // 2
                    delay_bst_ramp_delay,    // 32
                    drctl_period,            // 32
                    drctl_width,             // 32
                    burst_delay,             // 32
                    ramp_bursts,             // 20
                    irq_start_interval,      // 32
                    irq_stop_interval,       // 32
                    trig_out_start_interval, // 32
                    trig_out_stop_interval,  // 32
                    monitor_max_period}));   // 32

  // pd cd control signals

  up_xfer_cntrl #(
    .DATA_WIDTH(39)
  ) i_xfer_cntrl_pd (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({up_ext_sync_disarm,      // 1
                     up_ext_sync_arm,         // 1
                     up_transfer_trig_mode,   // 1
                     up_enable_p_if,          // 1
                     up_load_new_rate,        // 1
                     up_par_update_rate,      // 32
                     up_f_cfg}),              // 2
    .up_xfer_done (up_cntrl_xfer_pd_done_s),
    .d_rst (reset_pd),
    .d_clk (pd_clk),
    .d_data_cntrl ({pd_ext_sync_disarm,     // 1
                    pd_ext_sync_arm,        // 1
                    transfer_trig_mode,     // 1
                    enable_p_if,            // 1
                    load_new_rate,          // 1
                    update_rate,            // 32
                    f_cfg}));               // 2

  // debug

  generate
    if (MEASURE_CLKS_EN) begin
      // sync clock monitor

      up_clock_mon i_sync_clock_mon (
        .up_rstn (up_rstn),
        .up_clk (up_clk),
        .up_d_count (up_sync_clk_count_s),
        .d_rst (reset_sync_cd),
        .d_clk (sync_clk));

      // parallel domain clock monitor

      up_clock_mon i_pd_clock_mon (
        .up_rstn (up_rstn),
        .up_clk (up_clk),
        .up_d_count (up_pd_clk_count_s),
        .d_rst (reset_pd),
        .d_clk (pd_clk));
    end else begin
      assign up_sync_clk_count_s = 'd0;
      assign up_pd_clk_count_s = 'd0;
    end
  endgenerate

endmodule
