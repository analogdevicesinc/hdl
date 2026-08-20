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

`timescale 1ns/100ps

module axi_ad9910 #(

  parameter       FPGA_TECHNOLOGY = 0,
  parameter       FPGA_FAMILY = 0,
  parameter       SPEED_GRADE = 0,
  parameter       DEV_PACKAGE = 0,
  parameter       MEASURE_CLKS_EN = 0,
  parameter       DELAY_REFCLK_FREQ = 200,
  parameter       IODELAY_ENABLE = 1,
  parameter       ID = 0
) (

  input                   ext_sync,
  output reg              irq,
  output reg              trig_out,

  // clocks

  input                   delay_clk,

  // DDS control interface
  input                   sync_clk,
  output                  drctl,
  output                  drhold,
  input                   drover,
  input                   ram_swp_ovr,
  output  [ 2:0]          profile,

  // DDS data interface

  input                   pd_clk_in,
  output      [ 1:0]      f_o,
  output      [15:0]      db_o,
  output                  tx_enable,

  // DMA interface

  input                   s_axis_aclk,
  input                   s_axis_aresetn,
  input                   s_axis_tvalid,
  input                   s_axis_tlast,
  input       [15:0]      s_axis_tdata,
  output                  s_axis_tready,

  // AXI Slave Memory Map

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
  input                   s_axi_rready
);

  // localparam
  localparam IDLE_LOW = 0;
  localparam TRANS_HIGH = 1;
  localparam IDLE_HIGH = 2;
  localparam TRANS_LOW = 3;

  parameter         CONFIG = {{31{1'b0}}, MEASURE_CLKS_EN[0]};

  // internal registers

  reg                     up_wack = 1'b0;
  reg                     up_rack = 1'b0;
  reg     [31:0]          up_rdata = 32'b0;
  reg                     drctl_init = 'b0;
  reg     [ 5:0]          irq_int = 'b0;

  reg                     drover_m2 = 1'd0;
  reg                     drover_m1 = 1'd0;
  reg                     wait_for_start = 1'b0;
  reg                     ramp_period_active = 1'b0;
  reg                     end_phase = 1'b0;
  reg                     end_burst_phase = 1'b0;
  reg     [31:0]          ramp_period_cnt = 'd0;

  // added missing registers
  reg     [31:0]          ref_cnt = 'd0;
  reg     [31:0]          irq_start_match = 'd0;
  reg     [31:0]          irq_stop_match = 'd0;
  reg                     irq_start_match_en = 1'b0;
  reg                     irq_stop_match_en = 1'b0;
  reg                     run_ref_cnt = 1'b0;
  reg                     run_ref_cnt_d = 1'b0;
  reg                     stop_ref_cnt = 1'b0;
  reg                     monitor_period = 1'b0;
  reg                     monitor_burst_delay = 1'b0;
  reg                     monitor_max_period = 1'b0;
  reg     [19:0]          n_periods_cnt = 'd0;
  reg                     n_periods_active = 1'b0;
  reg                     n_periods_last = 1'b0;
  reg                     bursts_complete = 1'b0;
  reg                     end_period_d = 1'b0;
  reg     [15:0]          burst_delay_cnt_hi = 'd0;
  reg     [15:0]          burst_delay_cnt_lo = 'd0;
  reg                     burst_delay_active = 1'b0;
  reg                     burst_delay = 1'b0;
  reg                     burst_delay_d = 1'b0;
  reg                     transfer_m1 = 1'b0;
  reg                     transfer_m2 = 1'b0;
  reg                     ramp_start_trig_en_d = 1'b0;
  reg                     ready_to_start = 1'b0;
  // trigger related counters and status
  reg     [31:0]          trig_ref_cnt = 'd0;
  reg     [31:0]          trig_out_start_match = 'd0;
  reg     [31:0]          trig_out_stop_match = 'd0;
  reg                     trig_out_start_match_en = 1'b0;
  reg                     trig_out_stop_match_en = 1'b0;
  reg                     run_trig_ref_cnt = 1'b0;
  reg                     run_trig_ref_cnt_d = 1'b0;
  reg                     stop_trig_ref_cnt = 1'b0;
  reg                     trigger_period = 1'b0;
  reg                     trigger_burst_delay = 1'b0;
  reg                     trigger_max_period = 1'b0;
  reg                     trig_out_interval_start = 1'b0;
  reg                     trig_out_interval_stop = 1'b0;
  reg     [ 5:0]          trig_out_int = 'd0;
  reg     [ 1:0]          ramp_sm = 'd0;
  reg                     stop_event = 1'b0;
  reg     [31:0]          wait_for_start_cnt = 'd0;
  reg                     wait_for_start_d = 1'b0;
  reg                     irq_interval_start = 1'b0;
  reg                     irq_interval_stop = 1'b0;
  reg                     reset_stop_event = 1'b0;
  reg                     burst_stop_en = 1'b0;
  reg                     period_stop_en = 1'b0;
  reg                     drctl_init_d = 1'd0;
  reg                     drctl_toggle_en_d1 = 1'd0;
  reg                     drctl_toggle_en_d2 = 1'd0;
  reg     [31:0]          drctl_period_d = 'd0;
  reg     [31:0]          drctl_width_d = 'd0;
  reg     [31:0]          drctl_period_n1 = 'd0;
  reg     [31:0]          drctl_width_n1 = 'd0;
  reg     [31:0]          active_drctl_period_n1 = 'd0;
  reg     [31:0]          active_drctl_width_n1 = 'd0;
  reg     [15:0]          drctl_width_cnt_hi = 'd0;
  reg     [15:0]          drctl_width_cnt_lo = 'd0;
  reg                     drctl_width_active = 1'b0;
  reg                     drctl_period_one_d = 1'b0;
  reg                     drctl_period_nonzero_d = 1'b0;
  reg                     drctl_width_nonzero_d = 1'b0;
  reg                     drctl_width_gt_one_d = 1'b0;
  reg                     active_drctl_period_one = 1'b0;
  reg                     active_drctl_period_nonzero = 1'b0;
  reg                     active_drctl_width_nonzero = 1'b0;
  reg                     active_drctl_width_gt_one = 1'b0;
  reg                     period_done_pending = 1'b0;
  reg                     end_burst_period_pending = 1'b0;
  reg                     delay_at_period_done_pending = 1'b0;
  reg                     reload_period_pending = 1'b0;
  reg     [31:0]          burst_delay_val = 'd0;
  reg     [19:0]          ramp_bursts_val =  'd0;
  reg                     load_burst_cfg = 1'b0;
  reg     [31:0]          delay_bst_ramp_delay_val = 'd0;
  reg     [31:0]          ref_max_val;
  reg     [31:0]          irq_start_interval;
  reg     [31:0]          irq_stop_interval;
  reg     [31:0]          trig_out_start_interval;
  reg     [31:0]          trig_out_stop_interval;

  reg                     reset_overwrite = 'd0;
  reg                     auto_ramp_mode_update_d = 1'b0;
  reg     [ 2:0]          ovr_interval_cnt = 'd0;

  // internal signals

  wire                    up_clk;
  wire                    up_rstn;
  wire                    up_rreq_s;
  wire    [13:0]          up_raddr_s;
  wire                    up_wreq_s;
  wire    [13:0]          up_waddr_s;
  wire    [31:0]          up_wdata_s;
  wire    [31:0]          up_rdata_s[0:1];
  wire    [ 1:0]          up_rack_s;
  wire    [ 1:0]          up_wack_s;

  wire                    delay_rst;
  wire                    delay_locked;

  wire    [18:0]          up_dld;
  wire    [94:0]          up_dwdata;
  wire    [94:0]          up_drdata;

  wire                    reset_sync_cd;
  wire                    drctl_toggle_en_s;
  wire                    drctl_init_s;

  wire                    pd_clk_s;
  wire                    reset_pd_s;
  wire                    sd_ext_sync_disarm_s;
  wire                    sd_ext_sync_arm_s;
  wire                    pd_ext_sync_disarm_s;
  wire                    pd_ext_sync_arm_s;
  wire                    transfer_trig_mode_s;
  wire                    enable_p_if_s;
  wire                    load_new_rate_s;
  wire    [31:0]          update_rate_in_s;
  wire    [ 1:0]          irq_monitor_config_s;
  wire    [ 1:0]          ramp_config_s;
  wire    [ 1:0]          trigger_config_s;
  wire                    transfer_trigger_armed;

  wire    [31:0]          delay_bst_ramp_delay_s;
  wire    [31:0]          burst_delay_val_s;
  wire    [19:0]          ramp_bursts_s;
  wire    [31:0]          irq_start_interval_s;
  wire    [31:0]          irq_stop_interval_s;
  wire    [31:0]          ref_max_val_s;
  wire    [31:0]          drctl_period_s;
  wire    [31:0]          drctl_width_s;
  wire    [31:0]          trig_out_start_interval_s;
  wire    [31:0]          trig_out_stop_interval_s;

  wire    [ 5:0]          irq_mask_s;
  wire    [ 5:0]          irq_clear_s;
  wire    [ 5:0]          trig_out_mask_s;
  wire                    auto_ramp_mode_update;

  wire                    end_burst_delay;
  wire                    end_period;
  wire                    end_burst_period;
  wire                    start_event;
  wire                    burst_irq;
  wire                    start_drctl_period;
  wire                    drctl_period_restart;
  wire                    toggle_run_ready;
  wire                    terminal_lookahead;
  wire                    terminal_end_burst;
  wire                    terminal_delay;
  wire                    terminal_stop;
  wire                    terminal_reload;
  wire                    start_burst_delay_period;
  wire    [31:0]          burst_delay_cnt;
  wire    [31:0]          drctl_width_cnt;
  wire                    drctl_width_last;

  // defaults

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  assign auto_ramp_mode_update = (drctl_toggle_en_d1 ^ drctl_toggle_en_s) |
                                 drctl_toggle_en_d1 &
                                 ((drctl_period_d != drctl_period_s) |
                                 (drctl_width_d != drctl_width_s));

  always @(posedge sync_clk) begin
    if (reset_sync_cd) begin
      drctl_init_d <= 1'd0;
      drctl_toggle_en_d1 <= 1'd0;
      drctl_toggle_en_d2 <= 1'd0;
      drctl_period_d <= 'd0;
      drctl_period_n1 <= 'd0;
      drctl_width_d <= 'd0;
      drctl_width_n1 <= 'd0;
      active_drctl_period_n1 <= 'd0;
      active_drctl_width_n1 <= 'd0;
      drctl_period_one_d <= 1'b0;
      drctl_period_nonzero_d <= 1'b0;
      drctl_width_nonzero_d <= 1'b0;
      drctl_width_gt_one_d <= 1'b0;
      active_drctl_period_one <= 1'b0;
      active_drctl_period_nonzero <= 1'b0;
      active_drctl_width_nonzero <= 1'b0;
      active_drctl_width_gt_one <= 1'b0;
      auto_ramp_mode_update_d <= 1'b0;
      reset_overwrite <= 1'd0;
      ovr_interval_cnt <= 3'd0;
    end else begin
      drctl_init_d <= drctl_init_s;
      drctl_toggle_en_d1 <= drctl_toggle_en_s;
      drctl_toggle_en_d2 <= drctl_toggle_en_d1;
      drctl_period_d <= drctl_period_s;
      drctl_width_d <= drctl_width_s;
      drctl_period_n1 <= drctl_period_s - 1'b1;
      drctl_width_n1 <= drctl_width_s - 1'b1;
      drctl_period_one_d <= (drctl_period_s == 32'd1);
      drctl_period_nonzero_d <= |drctl_period_s;
      drctl_width_nonzero_d <= |drctl_width_s;
      drctl_width_gt_one_d <= drctl_width_s > 32'd1;
      if (reset_overwrite || period_done_pending) begin
        active_drctl_period_n1 <= drctl_period_n1;
        active_drctl_width_n1 <= drctl_width_n1;
        active_drctl_period_one <= drctl_period_one_d;
        active_drctl_period_nonzero <= drctl_period_nonzero_d;
        active_drctl_width_nonzero <= drctl_width_nonzero_d;
        active_drctl_width_gt_one <= drctl_width_gt_one_d;
      end
      auto_ramp_mode_update_d <= auto_ramp_mode_update;
      if (auto_ramp_mode_update_d == 1'b1) begin
        reset_overwrite <= 1'b1;
        ovr_interval_cnt <= 3'h7;
      end else if (ovr_interval_cnt != 'd0) begin
        reset_overwrite <= 1'b1;
        ovr_interval_cnt <= ovr_interval_cnt - 1'd1;
      end else begin
        reset_overwrite <= 1'b0;
        ovr_interval_cnt <= 3'd0;
      end
    end
  end

  // reference cnt for ramp operations
  always @(posedge sync_clk) begin
    if (reset_sync_cd | reset_overwrite) begin
      ref_cnt <= 'd0;
      irq_start_match <= 'd0;
      irq_stop_match <= 'd0;
      irq_start_match_en <= 1'b0;
      irq_stop_match_en <= 1'b0;
      run_ref_cnt <= 'd0;
      run_ref_cnt_d <= 'd0;
      stop_ref_cnt <= 1'b0;
      irq_interval_start <= 1'b0;
      irq_interval_stop <= 1'b0;
    end else begin
      run_ref_cnt_d <= run_ref_cnt;
      // start counter
      if (stop_ref_cnt) begin
        run_ref_cnt <= 'd0;
      end else if (monitor_period) begin
        run_ref_cnt <= (run_ref_cnt | end_period_d);
      end else if (monitor_burst_delay) begin
        run_ref_cnt <= (run_ref_cnt | bursts_complete);
      end else if (monitor_max_period) begin
        run_ref_cnt <= (run_ref_cnt | start_event);
      end

      // run and stop counter
      if (end_period_d & !monitor_max_period) begin
        ref_cnt <= 'd0;
        stop_ref_cnt <= 1'b1;
      end else if (end_burst_delay & !monitor_max_period) begin
        ref_cnt <= 'd0;
        stop_ref_cnt <= 1'b1;
      end else if (!run_ref_cnt_d & run_ref_cnt) begin
        ref_cnt <= ref_max_val_s;
        irq_start_match <= irq_start_interval;
        irq_stop_match <= irq_stop_interval;
        irq_start_match_en <= |irq_start_interval;
        irq_stop_match_en <= |irq_stop_interval;
        stop_ref_cnt <= 1'b0;
      end else if (run_ref_cnt & (ref_cnt == 32'd1)) begin
        ref_cnt <= 'd0;
        stop_ref_cnt <= 1'b1;
      end else begin
        stop_ref_cnt <= stop_ref_cnt;
        if (run_ref_cnt & |ref_cnt) begin
          ref_cnt <= ref_cnt - 1'b1;
        end
      end
      irq_interval_start <= irq_start_match_en && (ref_cnt == irq_start_match);
      irq_interval_stop <= irq_stop_match_en && (ref_cnt == irq_stop_match);
    end
  end

  // monitor interval (interrupt)
  // - period
  // - burst delay
  // - max_period
  always @(posedge sync_clk) begin
    monitor_period <= (irq_monitor_config_s[1:0] == 2'd0) ? 1'b1 : 1'b0;
    monitor_burst_delay <= (irq_monitor_config_s[1:0] == 2'd1) ? 1'b1 : 1'b0;
    monitor_max_period <= (irq_monitor_config_s[1:0] == 2'd2) ? 1'b1 : 1'b0;
  end

  always @(posedge sync_clk) begin
    if (reset_sync_cd) begin
      ref_max_val <= 'd0;
      irq_start_interval <= 'd0;
      irq_stop_interval <= 'd0;
      trig_out_start_interval <= 'd0;
      trig_out_stop_interval <= 'd0;
    end else begin
      ref_max_val <= ref_max_val_s;
      irq_start_interval <= irq_start_interval_s;
      irq_stop_interval <= irq_stop_interval_s;
      trig_out_start_interval <= trig_out_start_interval_s;
      trig_out_stop_interval <= trig_out_stop_interval_s;
    end
  end

  // trigger cnt for ramp operations
  always @(posedge sync_clk) begin
    if (reset_sync_cd | reset_overwrite) begin
      trig_ref_cnt <= 'd0;
      trig_out_start_match <= 'd0;
      trig_out_stop_match <= 'd0;
      trig_out_start_match_en <= 1'b0;
      trig_out_stop_match_en <= 1'b0;
      run_trig_ref_cnt <= 'd0;
      run_trig_ref_cnt_d <= 'd0;
      stop_trig_ref_cnt <= 1'b0;
      trig_out_interval_start <= 1'b0;
      trig_out_interval_stop <= 1'b0;
    end else begin
      run_trig_ref_cnt_d <= run_trig_ref_cnt;
      // start counter
      if (stop_trig_ref_cnt) begin
        run_trig_ref_cnt <= 'd0;
      end else if (trigger_period) begin
        run_trig_ref_cnt <= (run_trig_ref_cnt | end_period_d);
      end else if (trigger_burst_delay) begin
        run_trig_ref_cnt <= (run_trig_ref_cnt | bursts_complete);
      end else if (trigger_max_period) begin
        run_trig_ref_cnt <= (run_trig_ref_cnt | start_event);
      end

      // run and stop counter
      if (end_period_d & !trigger_max_period) begin
        trig_ref_cnt <= 'd0;
        stop_trig_ref_cnt <= 1'b1;
      end else if (end_burst_delay & !trigger_max_period) begin
        trig_ref_cnt <= 'd0;
        stop_trig_ref_cnt <= 1'b1;
      end else if (!run_trig_ref_cnt_d & run_trig_ref_cnt) begin
        trig_ref_cnt <= ref_max_val;
        trig_out_start_match <= trig_out_start_interval;
        trig_out_stop_match <= trig_out_stop_interval;
        trig_out_start_match_en <= |trig_out_start_interval;
        trig_out_stop_match_en <= |trig_out_stop_interval;
        stop_trig_ref_cnt <= 1'b0;
      end else if (run_trig_ref_cnt & (trig_ref_cnt == 32'd1)) begin
        trig_ref_cnt <= 'd0;
        stop_trig_ref_cnt <= 1'b1;
      end else begin
        stop_trig_ref_cnt <= stop_trig_ref_cnt;
        if (run_trig_ref_cnt & |trig_ref_cnt) begin
          trig_ref_cnt <= trig_ref_cnt - 1'b1;
        end
      end
      trig_out_interval_start <= trig_out_start_match_en && (trig_ref_cnt == trig_out_start_match);
      trig_out_interval_stop  <= trig_out_stop_match_en && (trig_ref_cnt == trig_out_stop_match);
    end
  end

  // external trigger interval
  // - period
  // - burst delay
  // - max_period
  always @(posedge sync_clk) begin
    trigger_period <= (trigger_config_s[1:0] == 2'd0) ? 1'b1 : 1'b0;
    trigger_burst_delay <= (trigger_config_s[1:0] == 2'd1) ? 1'b1 : 1'b0;
    trigger_max_period <= (trigger_config_s[1:0] == 2'd2) ? 1'b1 : 1'b0;
  end

  // passed through x period counter
  always @(posedge sync_clk) begin
    if (reset_sync_cd | reset_overwrite) begin
      end_period_d <= 1'b0;
    end else begin
      end_period_d <= end_period;
    end
  end

  // burst delay
  assign burst_delay_cnt = {burst_delay_cnt_hi, burst_delay_cnt_lo};

  always @(posedge sync_clk) begin
    if (reset_sync_cd | reset_overwrite) begin
      burst_delay_cnt_hi <= burst_delay_val[31:16];
      burst_delay_cnt_lo <= burst_delay_val[15:0];
      burst_delay_active <= 1'b0;
      burst_delay <= 'd0;
      burst_delay_d <= 'd0;
    end else begin
      burst_delay_d <= burst_delay;
      if (start_burst_delay_period) begin
        burst_delay_cnt_hi <= burst_delay_val[31:16];
        burst_delay_cnt_lo <= burst_delay_val[15:0];
        burst_delay_active <= |burst_delay_val;
        burst_delay <= |burst_delay_val;
      end else if (burst_delay_active) begin
        if ((burst_delay_cnt_hi == 16'd0) && (burst_delay_cnt_lo == 16'd1)) begin
          burst_delay_active <= 1'b0;
          burst_delay <= 1'b0;
        end else begin
          if (burst_delay_cnt_lo == 16'd0) begin
            burst_delay_cnt_hi <= burst_delay_cnt_hi - 1'b1;
            burst_delay_cnt_lo <= 16'hffff;
          end else begin
            burst_delay_cnt_lo <= burst_delay_cnt_lo - 1'b1;
          end
          burst_delay <= 1'b1;
        end
      end else begin
        burst_delay <= 1'b0;
      end
    end
  end

  assign end_burst_period = end_burst_phase;
  assign end_burst_delay = burst_delay_d & ~burst_delay;
  assign burst_irq = bursts_complete;

  always @(posedge sync_clk) begin
    reset_stop_event <= (ramp_config_s[1:0] == 2'd0) ? 1'b1 : 1'b0;
    burst_stop_en <= (ramp_config_s[1:0] == 2'd1) ? 1'b1 : 1'b0;
    period_stop_en <= (ramp_config_s[1:0] == 2'd2) ? 1'b1 : 1'b0;
  end

  // external trigger sync
  always @(posedge sync_clk) begin
    if (reset_sync_cd) begin
      transfer_m1 <= 1'b0;
      transfer_m2 <= 1'b0;
    end else begin
      transfer_m1 <= ext_sync;
      transfer_m2 <= transfer_m1;
    end
  end

  util_ext_sync #(
    .ENABLED (1'b1)
  ) i_util_ext_sync (
    .clk (sync_clk),
    .ext_sync_arm (sd_ext_sync_arm_s),
    .ext_sync_disarm (sd_ext_sync_disarm_s),
    .sync_in (ext_sync),
    .sync_armed (transfer_trigger_armed));

  // stop trigger
  always @(posedge sync_clk) begin
    if (reset_sync_cd | reset_overwrite | reset_stop_event) begin
      stop_event <= 'd0;
    end else begin
      if (end_burst_period & burst_stop_en) begin
        stop_event <= 1'd1;
      end else if (end_period & period_stop_en) begin
        stop_event <= 1'd1;
      // stop after period is complete and external_sync is asserted
      end else if (end_period & transfer_m2 & period_stop_en) begin
        stop_event <= 1'd1;
      end
    end
  end

  // ramp mode logic

  // wait for start logic
  always @(posedge sync_clk) begin
    if (reset_sync_cd | reset_overwrite) begin
      wait_for_start <= 1'b1;
      wait_for_start_cnt <= delay_bst_ramp_delay_val;
    end else begin
      if (transfer_trigger_armed) begin
        wait_for_start <= 1'b1;
        wait_for_start_cnt <= delay_bst_ramp_delay_val;
      end else if (wait_for_start_cnt != 32'b0) begin
        wait_for_start <= 1'b1;
        wait_for_start_cnt <= wait_for_start_cnt - 1'b1;
      end else begin
        wait_for_start <= 1'b0;
        wait_for_start_cnt <= 32'b0;
      end
      wait_for_start_d <= wait_for_start;
    end
  end

  assign start_event = wait_for_start_d & ~wait_for_start;

  assign toggle_run_ready = drctl_toggle_en_d2 &&
                            !wait_for_start &&
                            !stop_event &&
                            !burst_delay;
  assign start_drctl_period = toggle_run_ready &&
                              active_drctl_period_nonzero &&
                              !ramp_period_active;
  assign terminal_lookahead = ramp_period_active &&
                              (active_drctl_period_one ||
                              (ramp_period_cnt == 32'd1));
  assign terminal_end_burst = terminal_lookahead &&
                              n_periods_active &&
                              n_periods_last;
  assign terminal_delay = terminal_end_burst &&
                          |burst_delay_val;
  assign terminal_stop = terminal_lookahead &&
                         (period_stop_en ||
                         (terminal_end_burst && burst_stop_en));
  assign terminal_reload = terminal_lookahead &&
                           toggle_run_ready &&
                           active_drctl_period_nonzero &&
                           !terminal_stop &&
                           !terminal_delay;
  assign start_burst_delay_period = delay_at_period_done_pending;
  assign drctl_period_restart = start_drctl_period ||
                                (period_done_pending &&
                                reload_period_pending);
  assign drctl_width_cnt = {drctl_width_cnt_hi, drctl_width_cnt_lo};
  assign drctl_width_last = (drctl_width_cnt_hi == 16'd0) &&
                            (drctl_width_cnt_lo == 16'd1);

  // Programmed DRCTL duty-cycle period counter. In toggle mode the counter
  // loads the full period and the output level is derived from the remaining
  // count, similar to axi_pwm_gen pulse width/period handling.
  always @(posedge sync_clk) begin
    if (reset_sync_cd) begin
      ramp_period_cnt <= 'd0;
      ramp_period_active <= 1'b0;
      end_phase <= 1'b0;
      end_burst_phase <= 1'b0;
      n_periods_cnt <= 'd0;
      n_periods_active <= 1'b0;
      n_periods_last <= 1'b0;
      bursts_complete <= 1'b0;
      period_done_pending <= 1'b0;
      end_burst_period_pending <= 1'b0;
      delay_at_period_done_pending <= 1'b0;
      reload_period_pending <= 1'b0;
      drctl_width_cnt_hi <= 'd0;
      drctl_width_cnt_lo <= 'd0;
      drctl_width_active <= 1'b0;
    end else if (reset_overwrite) begin
      ramp_period_cnt <= 'd0;
      ramp_period_active <= 1'b0;
      end_phase <= 1'b0;
      end_burst_phase <= 1'b0;
      n_periods_cnt <= ramp_bursts_s[19:0];
      n_periods_active <= |ramp_bursts_s[19:0];
      n_periods_last <= (ramp_bursts_s[19:0] == 20'd1);
      bursts_complete <= 1'b0;
      period_done_pending <= 1'b0;
      end_burst_period_pending <= 1'b0;
      delay_at_period_done_pending <= 1'b0;
      reload_period_pending <= 1'b0;
      drctl_width_cnt_hi <= 'd0;
      drctl_width_cnt_lo <= 'd0;
      drctl_width_active <= 1'b0;
    end else begin
      end_phase <= 1'b0;
      end_burst_phase <= 1'b0;
      bursts_complete <= 1'b0;
      period_done_pending <= terminal_lookahead;
      end_burst_period_pending <= terminal_end_burst;
      delay_at_period_done_pending <= terminal_delay;
      reload_period_pending <= terminal_reload;

      if (period_done_pending) begin
        end_phase <= 1'b1;
        end_burst_phase <= end_burst_period_pending;
        bursts_complete <= end_burst_period_pending;
        if (end_burst_period_pending) begin
          n_periods_cnt <= ramp_bursts_val;
          n_periods_active <= |ramp_bursts_val;
          n_periods_last <= (ramp_bursts_val == 20'd1);
        end else if (n_periods_active) begin
          n_periods_cnt <= n_periods_cnt - 1'b1;
          n_periods_last <= (n_periods_cnt == 20'd2);
        end else begin
          n_periods_cnt <= ramp_bursts_val;
          n_periods_active <= |ramp_bursts_val;
          n_periods_last <= (ramp_bursts_val == 20'd1);
        end
      end else if (!n_periods_active) begin
        n_periods_cnt <= ramp_bursts_val;
        n_periods_active <= |ramp_bursts_val;
        n_periods_last <= (ramp_bursts_val == 20'd1);
      end

      if (period_done_pending) begin
        if (reload_period_pending) begin
          ramp_period_cnt <= active_drctl_period_n1;
          ramp_period_active <= 1'b1;
        end else begin
          ramp_period_cnt <= 'd0;
          ramp_period_active <= 1'b0;
        end
      end else if (start_drctl_period) begin
        ramp_period_cnt <= active_drctl_period_n1;
        ramp_period_active <= 1'b1;
      end else if (ramp_period_active) begin
        ramp_period_cnt <= ramp_period_cnt - 1'b1;
      end

      if (drctl_period_restart) begin
        drctl_width_cnt_hi <= active_drctl_width_n1[31:16];
        drctl_width_cnt_lo <= active_drctl_width_n1[15:0];
        drctl_width_active <= active_drctl_width_gt_one;
      end else if (drctl_width_active) begin
        if (drctl_width_last) begin
          drctl_width_active <= 1'b0;
        end else begin
          if (drctl_width_cnt_lo == 16'd0) begin
            drctl_width_cnt_hi <= drctl_width_cnt_hi - 1'b1;
            drctl_width_cnt_lo <= 16'hffff;
          end else begin
            drctl_width_cnt_lo <= drctl_width_cnt_lo - 1'b1;
          end
        end
      end
    end
  end

  assign end_period = end_phase;

  // load a new burst config logic
  always @(posedge sync_clk) begin
    if (reset_sync_cd) begin
      ramp_bursts_val <=  'd0;
      burst_delay_val <= 'd0;
      load_burst_cfg <= 1'b0;
    end else if (reset_overwrite) begin
      ramp_bursts_val <= ramp_bursts_s[19:0];
      burst_delay_val <= burst_delay_val_s;
      load_burst_cfg <= 1'b0;
    end else begin
      load_burst_cfg <= (end_period &&
                         !(|ramp_bursts_val && |burst_delay_val) &&
                         (|ramp_bursts_s && |burst_delay_val_s)) ||
                         bursts_complete;
      if (load_burst_cfg) begin
        ramp_bursts_val <= ramp_bursts_s[19:0];
        burst_delay_val <= burst_delay_val_s; // -3 sync_clk for SW
      end
    end
  end

  always @(posedge sync_clk) begin
    if (reset_sync_cd) begin
      delay_bst_ramp_delay_val <= 'd0;
    end else begin
      if (end_period_d | reset_overwrite) begin
        delay_bst_ramp_delay_val <= delay_bst_ramp_delay_s;
      end
    end
  end

  // In toggle mode, each period starts with DRCTL high for drctl_width cycles
  // and completes with DRCTL low for the remaining period cycles.
  always @(posedge sync_clk) begin
    if (reset_sync_cd | reset_overwrite) begin
      drctl_init <= 1'b0;
      ramp_sm <= IDLE_LOW;
    end else begin
      if (drctl_toggle_en_d1) begin
        if (active_drctl_period_one) begin
          drctl_init <= ~drctl_init;
          ramp_sm <= ~drctl_init ? TRANS_HIGH : TRANS_LOW;
        end else if (active_drctl_width_nonzero) begin
          if (start_drctl_period) begin
            drctl_init <= 1'b1;
            ramp_sm <= TRANS_HIGH;
          end else if (period_done_pending) begin
            if (reload_period_pending) begin
              drctl_init <= 1'b1;
              ramp_sm <= TRANS_HIGH;
            end else begin
              drctl_init <= 1'b0;
              ramp_sm <= IDLE_LOW;
            end
          end else if (ramp_period_active) begin
            drctl_init <= drctl_width_active;
            ramp_sm <= drctl_width_active ? TRANS_HIGH : TRANS_LOW;
          end else begin
            drctl_init <= 1'b0;
            ramp_sm <= IDLE_LOW;
          end
        end else begin
          drctl_init <= 1'b0;
          ramp_sm <= IDLE_LOW;
        end
      end else begin
        if (transfer_trigger_armed == 1'b0) begin
          drctl_init <= drctl_init_s;
          ramp_sm <= drctl_init_d ? IDLE_HIGH : IDLE_LOW;
        end
      end
    end
  end

  assign drctl = drctl_init;

  always @(posedge sync_clk) begin
    drover_m1 <= drover;
    drover_m2 <= drover_m1;
  end
  // interrupt logic

  always @(posedge sync_clk) begin
    irq_int <= {irq_interval_start,
                irq_interval_stop,
                1'b0,
                drover_m2,
                burst_irq,
                ram_swp_ovr} | irq_int & ~irq_clear_s;
    irq <= |(irq_int & irq_mask_s);
  end

  // interrupt logic

  always @(posedge sync_clk) begin
    trig_out_int <= {trig_out_interval_start,
                     trig_out_interval_stop,
                     1'b0,
                     drover_m2,
                     burst_irq,
                     ram_swp_ovr};
    trig_out <= |(trig_out_int & trig_out_mask_s);
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= |up_wack_s;
      up_rack <= |up_rack_s;
      up_rdata <= up_rdata_s[0] |
                  up_rdata_s[1];
    end
  end

  axi_ad9910_if #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .DELAY_REFCLK_FREQ (DELAY_REFCLK_FREQ),
    .IODELAY_ENABLE (IODELAY_ENABLE)
  ) i_ad9910_interface (
    .trig_transfer_ext (ext_sync),
    .pd_clk_in (pd_clk_in),
    .sync_clk (sync_clk),
    .pd_clk_out (pd_clk_s),
    .reset_pd (reset_pd_s),
    .ext_sync_disarm (pd_ext_sync_disarm_s),
    .ext_sync_arm (pd_ext_sync_arm_s),
    .transfer_trig_mode (transfer_trig_mode_s),
    .enable_if (enable_p_if_s),
    .load_new_rate (load_new_rate_s),
    .update_rate_in (update_rate_in_s),
    .db_o (db_o),
    .tx_enable (tx_enable),
    .s_axis_aclk (s_axis_aclk),
    .s_axis_aresetn (s_axis_aresetn),
    .s_axis_tvalid (s_axis_tvalid),
    .s_axis_tlast (s_axis_tlast),
    .s_axis_tdata (s_axis_tdata),
    .s_axis_tready (s_axis_tready),
    .up_clk (up_clk),
    .up_dld (up_dld),
    .up_dwdata (up_dwdata),
    .up_drdata (up_drdata),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  up_delay_cntrl #(
    .DATA_WIDTH(19),
    .BASE_ADDRESS(6'h02)
  ) i_delay_cntrl (
    .core_rst (1'b0),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked),
    .up_dld (up_dld),
    .up_dwdata (up_dwdata),
    .up_drdata (up_drdata),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  axi_ad9910_reg #(
    .ID(ID),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .CONFIG(CONFIG),
    .MEASURE_CLKS_EN(MEASURE_CLKS_EN)
  ) i_axi_ad9910_regmap (

    // sync clock domain
    .sync_clk (sync_clk),
    .reset_sync_cd (reset_sync_cd),
    .drctl_toggle_en (drctl_toggle_en_s),
    .drctl_init (drctl_init_s),
    .drhold (drhold),
    .profile (profile),
    .irq_int (irq_int),
    .irq_mask (irq_mask_s),
    .irq_clear (irq_clear_s),
    .irq_monitor_config (irq_monitor_config_s),
    .trig_out_mask (trig_out_mask_s),
    .sd_ext_sync_disarm (sd_ext_sync_disarm_s),
    .sd_ext_sync_arm (sd_ext_sync_arm_s),
    .trig_config (trigger_config_s),
    .ramp_config (ramp_config_s),
    .delay_bst_ramp_delay (delay_bst_ramp_delay_s),
    .drctl_period (drctl_period_s),
    .drctl_width (drctl_width_s),
    .burst_delay (burst_delay_val_s),
    .ramp_bursts (ramp_bursts_s),
    .irq_start_interval (irq_start_interval_s),
    .irq_stop_interval (irq_stop_interval_s),
    .trig_out_start_interval (trig_out_start_interval_s),
    .trig_out_stop_interval (trig_out_stop_interval_s),
    .monitor_max_period (ref_max_val_s),

    // parallel clk domain
    .pd_clk (pd_clk_s),
    .reset_pd (reset_pd_s),
    .pd_ext_sync_disarm (pd_ext_sync_disarm_s),
    .pd_ext_sync_arm (pd_ext_sync_arm_s),
    .transfer_trig_mode (transfer_trig_mode_s),
    .enable_p_if (enable_p_if_s),
    .load_new_rate (load_new_rate_s),
    .update_rate (update_rate_in_s),
    .f_cfg (f_o),

    // processor interface
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  // up bus interface

  up_axi #(
    .AXI_ADDRESS_WIDTH (16)
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
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule
