// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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
//
// Register map (word offsets - multiply by 4 for the AXI byte address)
//
//  word | name              | type   | description
//  -----+-------------------+--------+----------------------------------------
//  0x00 | VERSION           | RO     | CORE_VERSION
//  0x01 | PERIPHERAL_ID     | RO     | ID parameter
//  0x02 | SCRATCH           | RW     |
//  0x03 | IDENTIFICATION    | RO     | CORE_MAGIC ("SLIP" = 0x534C4950)
//  0x10 | RSTN              | RW     | [0]=soft_reset (1=assert; default 0)
//  0x11 | CONTROL           | RW     | [0]=CLR_FRAME_COUNT strobe (self-clear)
//       |                   |        | [1]=CLR_EVENTS strobe (self-clear)
//       |                   |        | [2]=CLR_ENV_MAX strobe (self-clear)
//       |                   |        | [3]=DETECT_EN level (default 1)
//       |                   |        | [4]=AUTO_CLR_ON_IDLE level (default 1)
//       |                   |        | [5]=DC_BYPASS level (default 0)
//  0x12 | STATUS            | RO     | [0]=stream_active, [1]=overflow,
//       |                   |        | [2]=detect_en
//  0x13 | FRAME_COUNT       | RO     | accepted sample beats this capture
//  0x14 | CONFIG            | RW     | [3:0]=window log2 (default 6)
//       |                   |        | [12:8]=data MSB position (default 23)
//  0x15 | ODR_COUNT         | RO     | ODR pulses this capture. Equal to
//       |                   |        | FRAME_COUNT unless the capture path
//       |                   |        | missed an ODR period; the difference is
//       |                   |        | the number of frames not delivered.
//  0x1E | IRQ_PENDING       | RW1C   | [0]=pair0 event, [1]=pair1 event
//  0x1F | IRQ_MASK          | RW     | 1=enabled
//
// Per comparator pair n (n = 0,1), base word 0x20 + n*0x10:
//
//  +0x0 | CHAN_SEL          | RW     | [2:0]=channel A, [6:4]=channel B
//  +0x1 | THRESHOLD         | RW     | delta-envelope detection threshold
//  +0x2 | ENV               | RO     | envelope of the last completed window
//  +0x3 | ENV_MAX           | RO     | running maximum of ENV since clear
//  +0x4 | EVENT_COUNT       | RO     | detections since last clear
//  +0x5 | EVENT_FRAME_FIRST | RO     | FRAME_COUNT at the first detection
//  +0x6 | EVENT_FRAME_LAST  | RO     | FRAME_COUNT at the most recent detection
//  +0x7 | EVENT_ENV         | RO     | ENV at the most recent detection
//  +0x8 | EVENT_CORR        | RO     | signed correlation, sign = direction of k
//  +0x9 | EVENT_ODR_FIRST   | RO     | ODR_COUNT at the first detection, i.e.
//       |                   |        | ODR periods from the start of the
//       |                   |        | capture to the first slip
//
// A detection is reported when the window it lands in closes, so the frame and
// ODR counts are late by up to 2**WIN_LOG2 periods (64 by default, 48 us at
// 1.33 MSPS).
//
// ***************************************************************************
`timescale 1ns/100ps

module ad7134_slip_detect_regmap #(
  parameter        ID = 0,
  parameter [31:0] CORE_MAGIC = 0,
  parameter [31:0] CORE_VERSION = 0,
  parameter [ 3:0] WIN_LOG2_DEFAULT = 4'd6,
  parameter [ 4:0] MSB_POS_DEFAULT = 5'd23,
  parameter [ 5:0] PAIR0_CHAN_DEFAULT = 6'h20,
  parameter [ 5:0] PAIR1_CHAN_DEFAULT = 6'h08,
  parameter [31:0] THRESHOLD_DEFAULT = 32'h00100000
) (
  // sample stream clock domain

  input                   ext_clk,
  output                  ext_resetn,

  // configuration (ext_clk domain, after CDC)

  output                  detect_en,
  output                  auto_clr_on_idle,
  output                  dc_bypass,
  output      [ 3:0]      win_log2,
  output      [ 4:0]      msb_pos,
  output      [ 5:0]      chan_sel_0,
  output      [ 5:0]      chan_sel_1,
  output      [31:0]      threshold_0,
  output      [31:0]      threshold_1,

  // self-clearing strobes (ext_clk domain, one cycle)

  output                  clr_frame_count,
  output                  clr_events,
  output                  clr_env_max,

  // status from the ext_clk domain

  input       [31:0]      frame_count,
  input       [31:0]      odr_count,
  input                   stream_active,
  input                   overflow,

  input       [31:0]      env_0,
  input       [31:0]      env_max_0,
  input       [31:0]      event_count_0,
  input       [31:0]      event_frame_first_0,
  input       [31:0]      event_odr_first_0,
  input       [31:0]      event_frame_last_0,
  input       [31:0]      event_env_0,
  input       [31:0]      event_corr_0,

  input       [31:0]      env_1,
  input       [31:0]      env_max_1,
  input       [31:0]      event_count_1,
  input       [31:0]      event_frame_first_1,
  input       [31:0]      event_odr_first_1,
  input       [31:0]      event_frame_last_1,
  input       [31:0]      event_env_1,
  input       [31:0]      event_corr_1,

  // detection pulses from the ext_clk domain

  input                   evt_0,
  input                   evt_1,

  // interrupt to the PS

  output                  irq,

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

  // -------------------------------------------------------------------------
  // up_clk-domain registers
  // -------------------------------------------------------------------------

  reg     [31:0]  up_scratch          = 32'd0;
  reg             up_soft_reset       = 1'b0;
  reg             up_clr_frame_count  = 1'b0;    // self-clearing strobe
  reg             up_clr_events       = 1'b0;    // self-clearing strobe
  reg             up_clr_env_max      = 1'b0;    // self-clearing strobe
  reg             up_detect_en        = 1'b1;
  reg             up_auto_clr_on_idle = 1'b1;
  reg             up_dc_bypass        = 1'b0;
  reg     [ 3:0]  up_win_log2         = WIN_LOG2_DEFAULT;
  reg     [ 4:0]  up_msb_pos          = MSB_POS_DEFAULT;
  reg     [ 5:0]  up_chan_sel_0       = PAIR0_CHAN_DEFAULT;
  reg     [ 5:0]  up_chan_sel_1       = PAIR1_CHAN_DEFAULT;
  reg     [31:0]  up_threshold_0      = THRESHOLD_DEFAULT;
  reg     [31:0]  up_threshold_1      = THRESHOLD_DEFAULT;
  reg     [ 1:0]  up_irq_pending      = 2'd0;
  reg     [ 1:0]  up_irq_mask         = 2'd0;

  // status mirrored into the up_clk domain (driven by sync_data below)

  wire    [31:0]  up_frame_count;
  wire    [31:0]  up_odr_count;
  wire            up_stream_active;
  wire            up_overflow;

  wire    [31:0]  up_env_0;
  wire    [31:0]  up_env_max_0;
  wire    [31:0]  up_event_count_0;
  wire    [31:0]  up_event_frame_first_0;
  wire    [31:0]  up_event_odr_first_0;
  wire    [31:0]  up_event_frame_last_0;
  wire    [31:0]  up_event_env_0;
  wire    [31:0]  up_event_corr_0;

  wire    [31:0]  up_env_1;
  wire    [31:0]  up_env_max_1;
  wire    [31:0]  up_event_count_1;
  wire    [31:0]  up_event_frame_first_1;
  wire    [31:0]  up_event_odr_first_1;
  wire    [31:0]  up_event_frame_last_1;
  wire    [31:0]  up_event_env_1;
  wire    [31:0]  up_event_corr_1;

  wire    [ 1:0]  up_event_pulse;

  // -------------------------------------------------------------------------
  // Write path
  // -------------------------------------------------------------------------

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wack             <= 1'b0;
      up_scratch          <= 32'd0;
      up_soft_reset       <= 1'b0;
      up_detect_en        <= 1'b1;
      up_auto_clr_on_idle <= 1'b1;
      up_dc_bypass        <= 1'b0;
      up_win_log2         <= WIN_LOG2_DEFAULT;
      up_msb_pos          <= MSB_POS_DEFAULT;
      up_chan_sel_0       <= PAIR0_CHAN_DEFAULT;
      up_chan_sel_1       <= PAIR1_CHAN_DEFAULT;
      up_threshold_0      <= THRESHOLD_DEFAULT;
      up_threshold_1      <= THRESHOLD_DEFAULT;
      up_irq_mask         <= 2'd0;
      up_clr_frame_count  <= 1'b0;
      up_clr_events       <= 1'b0;
      up_clr_env_max      <= 1'b0;
    end else begin
      up_wack <= up_wreq;

      // strobes default to 0 every cycle (self-clearing)
      up_clr_frame_count <= 1'b0;
      up_clr_events      <= 1'b0;
      up_clr_env_max     <= 1'b0;

      if (up_wreq == 1'b1) begin
        case (up_waddr)
          14'h02: up_scratch <= up_wdata;
          14'h10: up_soft_reset <= up_wdata[0];
          14'h11: begin
            up_clr_frame_count  <= up_wdata[0];
            up_clr_events       <= up_wdata[1];
            up_clr_env_max      <= up_wdata[2];
            up_detect_en        <= up_wdata[3];
            up_auto_clr_on_idle <= up_wdata[4];
            up_dc_bypass        <= up_wdata[5];
          end
          14'h14: begin
            up_win_log2 <= up_wdata[3:0];
            up_msb_pos  <= up_wdata[12:8];
          end
          14'h1f: up_irq_mask    <= up_wdata[1:0];
          14'h20: up_chan_sel_0  <= {up_wdata[6:4], up_wdata[2:0]};
          14'h21: up_threshold_0 <= up_wdata;
          14'h30: up_chan_sel_1  <= {up_wdata[6:4], up_wdata[2:0]};
          14'h31: up_threshold_1 <= up_wdata;
          default: ;
        endcase
      end
    end
  end

  // IRQ_PENDING: RW1C, set by the detection pulses from the ext_clk domain.
  // Set wins over clear so an event landing in the same cycle as the clearing
  // write is never lost.

  integer i;
  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_irq_pending <= 2'd0;
    end else begin
      for (i = 0; i < 2; i = i + 1) begin
        if (up_event_pulse[i])
          up_irq_pending[i] <= 1'b1;
        else if (up_wreq && up_waddr == 14'h1e && up_wdata[i])
          up_irq_pending[i] <= 1'b0;
      end
    end
  end

  assign irq = |(up_irq_pending & up_irq_mask);

  // -------------------------------------------------------------------------
  // Read path
  // -------------------------------------------------------------------------

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rack  <= 1'b0;
      up_rdata <= 32'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          14'h00: up_rdata <= CORE_VERSION;
          14'h01: up_rdata <= ID;
          14'h02: up_rdata <= up_scratch;
          14'h03: up_rdata <= CORE_MAGIC;
          14'h10: up_rdata <= {31'd0, up_soft_reset};
          14'h11: up_rdata <= {26'd0,
                               up_dc_bypass,
                               up_auto_clr_on_idle,
                               up_detect_en,
                               3'd0};               // strobes always read 0
          14'h12: up_rdata <= {29'd0,
                               up_detect_en,
                               up_overflow,
                               up_stream_active};
          14'h13: up_rdata <= up_frame_count;
          14'h14: up_rdata <= {19'd0, up_msb_pos, 4'd0, up_win_log2};
          14'h15: up_rdata <= up_odr_count;
          14'h1e: up_rdata <= {30'd0, up_irq_pending};
          14'h1f: up_rdata <= {30'd0, up_irq_mask};
          14'h20: up_rdata <= {25'd0, up_chan_sel_0[5:3], 1'd0, up_chan_sel_0[2:0]};
          14'h21: up_rdata <= up_threshold_0;
          14'h22: up_rdata <= up_env_0;
          14'h23: up_rdata <= up_env_max_0;
          14'h24: up_rdata <= up_event_count_0;
          14'h25: up_rdata <= up_event_frame_first_0;
          14'h26: up_rdata <= up_event_frame_last_0;
          14'h27: up_rdata <= up_event_env_0;
          14'h28: up_rdata <= up_event_corr_0;
          14'h29: up_rdata <= up_event_odr_first_0;
          14'h30: up_rdata <= {25'd0, up_chan_sel_1[5:3], 1'd0, up_chan_sel_1[2:0]};
          14'h31: up_rdata <= up_threshold_1;
          14'h32: up_rdata <= up_env_1;
          14'h33: up_rdata <= up_env_max_1;
          14'h34: up_rdata <= up_event_count_1;
          14'h35: up_rdata <= up_event_frame_first_1;
          14'h36: up_rdata <= up_event_frame_last_1;
          14'h37: up_rdata <= up_event_env_1;
          14'h38: up_rdata <= up_event_corr_1;
          14'h39: up_rdata <= up_event_odr_first_1;
          default: up_rdata <= 32'd0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // -------------------------------------------------------------------------
  // CDC: up_clk -> ext_clk
  // -------------------------------------------------------------------------

  ad_rst i_ext_rst (
    .rst_async (up_soft_reset | ~up_rstn),
    .clk (ext_clk),
    .rstn (ext_resetn),
    .rst ());

  sync_data #(
    .NUM_OF_BITS (88),
    .ASYNC_CLK (1)
  ) i_sync_levels_to_ext (
    .in_clk (up_clk),
    .in_data ({up_threshold_1,
               up_threshold_0,
               up_chan_sel_1,
               up_chan_sel_0,
               up_msb_pos,
               up_win_log2,
               up_dc_bypass,
               up_auto_clr_on_idle,
               up_detect_en}),
    .out_clk (ext_clk),
    .out_data ({threshold_1,
                threshold_0,
                chan_sel_1,
                chan_sel_0,
                msb_pos,
                win_log2,
                dc_bypass,
                auto_clr_on_idle,
                detect_en}));

  sync_event #(
    .NUM_OF_EVENTS (3),
    .ASYNC_CLK (1)
  ) i_sync_strobes (
    .in_clk (up_clk),
    .in_event ({up_clr_env_max, up_clr_events, up_clr_frame_count}),
    .out_clk (ext_clk),
    .out_event ({clr_env_max, clr_events, clr_frame_count}));

  // -------------------------------------------------------------------------
  // CDC: ext_clk -> up_clk
  // -------------------------------------------------------------------------

  // sync_data latches the whole vector into cdc_hold on a single in_clk edge,
  // so each group is handed over as one coherent snapshot. Keeping all result
  // words of a pair in one instance is what guarantees EVENT_FRAME_LAST,
  // EVENT_ENV and EVENT_CORR always describe the same detection, and keeping
  // frame_count next to odr_count is what makes their difference a meaningful
  // dropped-frame count rather than two independently skewed reads.

  sync_data #(
    .NUM_OF_BITS (66),
    .ASYNC_CLK (1)
  ) i_sync_global_to_up (
    .in_clk (ext_clk),
    .in_data ({overflow,
               stream_active,
               odr_count,
               frame_count}),
    .out_clk (up_clk),
    .out_data ({up_overflow,
                up_stream_active,
                up_odr_count,
                up_frame_count}));

  sync_data #(
    .NUM_OF_BITS (256),
    .ASYNC_CLK (1)
  ) i_sync_pair0_to_up (
    .in_clk (ext_clk),
    .in_data ({event_odr_first_0,
               event_corr_0,
               event_env_0,
               event_frame_last_0,
               event_frame_first_0,
               event_count_0,
               env_max_0,
               env_0}),
    .out_clk (up_clk),
    .out_data ({up_event_odr_first_0,
                up_event_corr_0,
                up_event_env_0,
                up_event_frame_last_0,
                up_event_frame_first_0,
                up_event_count_0,
                up_env_max_0,
                up_env_0}));

  sync_data #(
    .NUM_OF_BITS (256),
    .ASYNC_CLK (1)
  ) i_sync_pair1_to_up (
    .in_clk (ext_clk),
    .in_data ({event_odr_first_1,
               event_corr_1,
               event_env_1,
               event_frame_last_1,
               event_frame_first_1,
               event_count_1,
               env_max_1,
               env_1}),
    .out_clk (up_clk),
    .out_data ({up_event_odr_first_1,
                up_event_corr_1,
                up_event_env_1,
                up_event_frame_last_1,
                up_event_frame_first_1,
                up_event_count_1,
                up_env_max_1,
                up_env_1}));

  sync_event #(
    .NUM_OF_EVENTS (2),
    .ASYNC_CLK (1)
  ) i_sync_events_to_up (
    .in_clk (ext_clk),
    .in_event ({evt_1, evt_0}),
    .out_clk (up_clk),
    .out_event (up_event_pulse));

endmodule
