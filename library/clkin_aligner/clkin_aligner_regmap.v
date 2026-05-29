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
// Register map (word offsets — multiply by 4 for AXI byte address)
//
//  word | name              | type   | description
//  -----+-------------------+--------+----------------------------------------
//  0x00 | VERSION           | RO     | CORE_VERSION
//  0x01 | PERIPHERAL_ID     | RO     | ID parameter
//  0x02 | SCRATCH           | RW     |
//  0x03 | IDENTIFICATION    | RO     | CORE_MAGIC ("CLKA" = 0x434C4B41)
//  0x10 | RSTN              | RW     | [0]=soft_reset (1=assert, 0=release; default 0)
//  0x11 | CONTROL           | RW     | [0]=STARTUP_FIRE strobe (self-clear)
//       |                   |        | [1]=ARM_STOP_AT_ALIGN strobe (self-clear)
//       |                   |        | [2]=RESUME strobe (self-clear)
//       |                   |        | [3]=GATE_FORCE_OFF (level)
//       |                   |        | [4]=GATE_FORCE_ON (level)
//  0x12 | STATUS            | RO     | [0]=gate_active, [1]=startup_done,
//       |                   |        | [2]=stopped_low, [3]=armed,
//       |                   |        | [4]=edge_target_hit
//  0x13 | STARTUP_CYCLES    | RW     | default 36
//  0x14 | EDGE_TARGET       | RW     | default 146
//  0x15 | EDGE_COUNT        | RO     | last counted edges since RESUME
//  0x16 | DIV32_PHASE       | RO     | [4:0]=div32_cnt, [8]=clk_div32 level
//  0x17 | IRQ_PENDING       | RW1C   | [0]=edge_target_reached
//       |                   |        | [1]=stop_at_align_done
//       |                   |        | [2]=startup_done
//  0x18 | IRQ_MASK          | RW     | 1=enabled (matches IRQ_PENDING bit layout)
//
// ***************************************************************************
`timescale 1ns/100ps

module clkin_aligner_regmap #(
  parameter        ID = 0,
  parameter [31:0] CORE_MAGIC = 0,
  parameter [31:0] CORE_VERSION = 0,
  parameter [15:0] STARTUP_CYCLES_DEFAULT = 16'd36,
  parameter [15:0] EDGE_TARGET_DEFAULT    = 16'd146
) (
  // peripheral clock domain (clk_in)

  input                   ext_clk,

  // controls (clk_in domain, after CDC)

  output                  ext_resetn,
  output                  startup_fire,
  output                  arm_stop_at_align,
  output                  resume_strobe,
  output                  gate_force_off,
  output                  gate_force_on,
  output      [15:0]      startup_cycles,
  output      [15:0]      edge_target,

  // status from clk_in domain

  input       [15:0]      edge_count,
  input       [ 4:0]      div32_cnt,
  input                   clk_div32,
  input                   gate_active,
  input                   startup_done,
  input                   stopped_low,
  input                   armed,
  input                   edge_target_hit,

  // events from clk_in domain (one-cycle pulses)

  input                   evt_edge_target_reached,
  input                   evt_stop_at_align_done,
  input                   evt_startup_done,

  // interrupt to PS

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

  reg     [31:0]  up_scratch         = 32'd0;
  reg             up_soft_reset      = 1'b0;
  reg             up_startup_fire    = 1'b0;     // self-clearing strobe
  reg             up_arm_stop        = 1'b0;     // self-clearing strobe
  reg             up_resume          = 1'b0;     // self-clearing strobe
  reg             up_gate_force_off  = 1'b0;
  reg             up_gate_force_on   = 1'b0;
  reg     [15:0]  up_startup_cycles  = STARTUP_CYCLES_DEFAULT;
  reg     [15:0]  up_edge_target     = EDGE_TARGET_DEFAULT;
  reg     [ 2:0]  up_irq_pending     = 3'd0;
  reg     [ 2:0]  up_irq_mask        = 3'd0;

  // status mirrored back into up_clk domain (set further below via sync_data)

  wire    [15:0]  up_edge_count;
  wire    [ 4:0]  up_div32_cnt;
  wire            up_clk_div32;
  wire            up_gate_active;
  wire            up_startup_done;
  wire            up_stopped_low;
  wire            up_armed;
  wire            up_edge_target_hit;

  // events arriving from clk_in domain

  wire    [ 2:0]  up_event_pulse;

  // -------------------------------------------------------------------------
  // Write path
  // -------------------------------------------------------------------------

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wack            <= 1'b0;
      up_scratch         <= 32'd0;
      up_soft_reset      <= 1'b0;
      up_gate_force_off  <= 1'b0;
      up_gate_force_on   <= 1'b0;
      up_startup_cycles  <= STARTUP_CYCLES_DEFAULT;
      up_edge_target     <= EDGE_TARGET_DEFAULT;
      up_irq_mask        <= 3'd0;
      up_startup_fire    <= 1'b0;
      up_arm_stop        <= 1'b0;
      up_resume          <= 1'b0;
    end else begin
      up_wack <= up_wreq;

      // strobes default to 0 every cycle (self-clearing)
      up_startup_fire <= 1'b0;
      up_arm_stop     <= 1'b0;
      up_resume       <= 1'b0;

      if (up_wreq == 1'b1) begin
        case (up_waddr)
          14'h02: up_scratch <= up_wdata;
          14'h10: up_soft_reset <= up_wdata[0];
          14'h11: begin
            up_startup_fire   <= up_wdata[0];
            up_arm_stop       <= up_wdata[1];
            up_resume         <= up_wdata[2];
            up_gate_force_off <= up_wdata[3];
            up_gate_force_on  <= up_wdata[4];
          end
          14'h13: up_startup_cycles <= up_wdata[15:0];
          14'h14: up_edge_target    <= up_wdata[15:0];
          14'h18: up_irq_mask       <= up_wdata[2:0];
          default: ;
        endcase
      end
    end
  end

  // IRQ_PENDING: RW1C, set by event pulses from clk_in domain

  integer i;
  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_irq_pending <= 3'd0;
    end else begin
      for (i = 0; i < 3; i = i + 1) begin
        if (up_event_pulse[i])
          up_irq_pending[i] <= 1'b1;
        else if (up_wreq && up_waddr == 14'h17 && up_wdata[i])
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
          14'h11: up_rdata <= {27'd0,
                               up_gate_force_on,
                               up_gate_force_off,
                               3'd0};               // strobes always read 0
          14'h12: up_rdata <= {27'd0,
                               up_edge_target_hit,
                               up_armed,
                               up_stopped_low,
                               up_startup_done,
                               up_gate_active};
          14'h13: up_rdata <= {16'd0, up_startup_cycles};
          14'h14: up_rdata <= {16'd0, up_edge_target};
          14'h15: up_rdata <= {16'd0, up_edge_count};
          14'h16: up_rdata <= {23'd0, up_clk_div32, 3'd0, up_div32_cnt};
          14'h17: up_rdata <= {29'd0, up_irq_pending};
          14'h18: up_rdata <= {29'd0, up_irq_mask};
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

  // soft reset: combine AXI reset with software soft_reset, sync to ext_clk

  ad_rst i_ext_rst (
    .rst_async (up_soft_reset | ~up_rstn),
    .clk (ext_clk),
    .rstn (ext_resetn),
    .rst ());

  // levels (config + force bits)

  sync_data #(
    .NUM_OF_BITS (34),
    .ASYNC_CLK (1)
  ) i_sync_levels_to_ext (
    .in_clk (up_clk),
    .in_data ({up_gate_force_on,
               up_gate_force_off,
               up_edge_target,
               up_startup_cycles}),
    .out_clk (ext_clk),
    .out_data ({gate_force_on,
                gate_force_off,
                edge_target,
                startup_cycles}));

  // strobes (self-clearing 1-cycle pulses on up_clk)

  sync_event #(
    .NUM_OF_EVENTS (3),
    .ASYNC_CLK (1)
  ) i_sync_strobes (
    .in_clk (up_clk),
    .in_event ({up_resume, up_arm_stop, up_startup_fire}),
    .out_clk (ext_clk),
    .out_event ({resume_strobe, arm_stop_at_align, startup_fire}));

  // -------------------------------------------------------------------------
  // CDC: ext_clk -> up_clk
  // -------------------------------------------------------------------------

  // status / counters (level signals; sync_data is fine)

  sync_data #(
    .NUM_OF_BITS (27),
    .ASYNC_CLK (1)
  ) i_sync_status_to_up (
    .in_clk (ext_clk),
    .in_data ({edge_target_hit,
               armed,
               stopped_low,
               startup_done,
               gate_active,
               clk_div32,
               div32_cnt,
               edge_count}),
    .out_clk (up_clk),
    .out_data ({up_edge_target_hit,
                up_armed,
                up_stopped_low,
                up_startup_done,
                up_gate_active,
                up_clk_div32,
                up_div32_cnt,
                up_edge_count}));

  // event pulses (latched into IRQ_PENDING above)

  sync_event #(
    .NUM_OF_EVENTS (3),
    .ASYNC_CLK (1)
  ) i_sync_events_to_up (
    .in_clk (ext_clk),
    .in_event ({evt_startup_done,
                evt_stop_at_align_done,
                evt_edge_target_reached}),
    .out_clk (up_clk),
    .out_event (up_event_pulse));

endmodule
