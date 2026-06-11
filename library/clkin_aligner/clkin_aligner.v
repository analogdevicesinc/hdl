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
`timescale 1ns/100ps

module clkin_aligner #(
  parameter        ID = 0,
  parameter [15:0] STARTUP_CYCLES_DEFAULT = 16'd36,
  parameter [15:0] EDGE_TARGET_DEFAULT    = 16'd146
) (
  // AXI-Lite

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

  // peripheral clock and gated output

/* (* mark_debug = "true" *) */  input                   clk_in,
/* (* mark_debug = "true" *) */  output                  clk_out,

  // interrupt

/* (* mark_debug = "true" *) */  output                  irq,

  // ODR re-registration (Sequence.txt §F.10 — ODR transitions on
  // XTAL2_CLKIN falling edges)

/* (* mark_debug = "true" *) */  input                   odr_in,
/* (* mark_debug = "true" *) */  output                  odr_out
);

  // local parameters

  localparam [31:0] CORE_VERSION = {16'h0000, 8'h01, 8'h00};   // 0.1.0
  localparam [31:0] CORE_MAGIC   = 32'h434C4B41;               // "CLKA"

  // up_axi <-> regmap

  wire            up_clk;
  wire            up_rstn;
  wire            up_wreq;
  wire    [13:0]  up_waddr;
  wire    [31:0]  up_wdata;
  wire            up_wack;
  wire            up_rreq;
  wire    [13:0]  up_raddr;
  wire    [31:0]  up_rdata;
  wire            up_rack;

  // control strobes / config (clk_in domain, after CDC inside regmap)

  wire            ext_resetn;
/* (* mark_debug = "true" *) */  wire            startup_fire;
/* (* mark_debug = "true" *) */  wire            arm_stop_at_align;
/* (* mark_debug = "true" *) */  wire            resume_strobe;
  wire            gate_force_off;
  wire            gate_force_on;
  wire    [15:0]  startup_cycles;
  wire    [15:0]  edge_target;

  // status / counters from clk_in domain

  wire    [15:0]  edge_count;
/* (* mark_debug = "true" *) */  wire    [ 4:0]  div32_cnt;
/* (* mark_debug = "true" *) */  wire            clk_div32;
/* (* mark_debug = "true" *) */  wire            gate_active;
  wire            startup_done;
  wire            stopped_low;
  wire            armed;
  wire            edge_target_hit;

  // events to regmap (one-cycle pulses in clk_in domain)

/* (* mark_debug = "true" *) */  wire            evt_edge_target_reached;
/* (* mark_debug = "true" *) */  wire            evt_stop_at_align_done;
/* (* mark_debug = "true" *) */  wire            evt_startup_done;

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // ---------------------------------------------------------------
  // AXI-Lite glue
  // ---------------------------------------------------------------

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
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  // ---------------------------------------------------------------
  // Register map (handles CDC between up_clk and clk_in)
  // ---------------------------------------------------------------

  clkin_aligner_regmap #(
    .ID (ID),
    .CORE_MAGIC (CORE_MAGIC),
    .CORE_VERSION (CORE_VERSION),
    .STARTUP_CYCLES_DEFAULT (STARTUP_CYCLES_DEFAULT),
    .EDGE_TARGET_DEFAULT (EDGE_TARGET_DEFAULT)
  ) i_regmap (
    .ext_clk (clk_in),
    .ext_resetn (ext_resetn),
    .startup_fire (startup_fire),
    .arm_stop_at_align (arm_stop_at_align),
    .resume_strobe (resume_strobe),
    .gate_force_off (gate_force_off),
    .gate_force_on (gate_force_on),
    .startup_cycles (startup_cycles),
    .edge_target (edge_target),
    .edge_count (edge_count),
    .div32_cnt (div32_cnt),
    .clk_div32 (clk_div32),
    .gate_active (gate_active),
    .startup_done (startup_done),
    .stopped_low (stopped_low),
    .armed (armed),
    .edge_target_hit (edge_target_hit),
    .evt_edge_target_reached (evt_edge_target_reached),
    .evt_stop_at_align_done (evt_stop_at_align_done),
    .evt_startup_done (evt_startup_done),
    .irq (irq),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  // ===============================================================
  // Datapath — clk_in domain
  // ===============================================================

  // ---------------- FSM state ----------------
  // State encoding kept simple; one-hot is unnecessary for 5 states.

  localparam [2:0] ST_IDLE        = 3'd0;
  localparam [2:0] ST_STARTUP     = 3'd1;
  localparam [2:0] ST_ARMED       = 3'd2;
  localparam [2:0] ST_STOPPED_LOW = 3'd3;
  localparam [2:0] ST_RUNNING     = 3'd4;

/* (* mark_debug = "true" *) */  reg [2:0]  state = ST_IDLE;
/* (* mark_debug = "true" *) */  reg [15:0] startup_cnt = 16'd0;
/* (* mark_debug = "true" *) */  reg [15:0] edge_cnt    = 16'd0;
/* (* mark_debug = "true" *) */  reg [ 4:0] div32_q     = 5'd0;
/* (* mark_debug = "true" *) */  reg        gate_en_req;       // combinational
/* (* mark_debug = "true" *) */  reg        gate_en_neg = 1'b1; // negedge-registered enable for BUFGCE

  // /32 phase counter: increments on every delivered clk_in posedge
  // (i.e. when the gate is open). Initial value chosen so that
  // clk_div32 = HIGH for cnt 0..15, LOW for 16..31.

  // Sequence.txt §E.5: when STARTUP_FIRE arrives in IDLE, prime the
  // counter to 31 so that after the 36-cycle startup the post-§E
  // reading is (31+36) mod 32 = 3 with clk_div32 = HIGH.
  always @(posedge clk_in) begin
    if (!ext_resetn) begin
      div32_q <= 5'd0;
    end else if (state == ST_IDLE && startup_fire) begin
      div32_q <= 5'd31;
    end else if (gate_en_neg) begin
      div32_q <= div32_q + 5'd1;
    end
  end

  assign clk_div32 = ~div32_q[4];

  // detect negedge of clk_div32 (i.e. div32_q transitions 15 -> 16)

  reg clk_div32_d = 1'b1;
  always @(posedge clk_in) begin
    if (!ext_resetn) clk_div32_d <= 1'b1;
    else if (gate_en_neg) clk_div32_d <= clk_div32;
  end
  wire clk_div32_negedge = clk_div32_d & ~clk_div32 & gate_en_neg;

  // edge counter: counts delivered clk_in posedges since last RESUME.

  always @(posedge clk_in) begin
    if (!ext_resetn) begin
      edge_cnt <= 16'd0;
    end else if (resume_strobe) begin
      edge_cnt <= 16'd0;
    end else if (gate_en_neg && state == ST_RUNNING && edge_cnt != 16'hFFFF) begin
      edge_cnt <= edge_cnt + 16'd1;
    end
  end

  // FSM
  //
  // Default = ST_IDLE with gate ON: matches today's behaviour
  // (un-loaded driver still gets a 48 MHz clock to the ADC).

  reg evt_startup_done_r;
  reg evt_stop_at_align_done_r;
  reg evt_edge_target_reached_r;

  always @(posedge clk_in) begin
    if (!ext_resetn) begin
      state                     <= ST_IDLE;
      startup_cnt               <= 16'd0;
      evt_startup_done_r        <= 1'b0;
      evt_stop_at_align_done_r  <= 1'b0;
      evt_edge_target_reached_r <= 1'b0;
    end else begin
      evt_startup_done_r        <= 1'b0;
      evt_stop_at_align_done_r  <= 1'b0;
      evt_edge_target_reached_r <= 1'b0;

      case (state)
        ST_IDLE: begin
          if (startup_fire) begin
            startup_cnt <= startup_cycles;
            state       <= ST_STARTUP;
          end else if (arm_stop_at_align) begin
            state <= ST_ARMED;
          end else if (resume_strobe) begin
            state <= ST_RUNNING;
          end
        end

        ST_STARTUP: begin
          // startup_cnt must advance only on DELIVERED pulses (gate_en_neg),
          // in lockstep with div32_q. GATE_FORCE_OFF is a level (sync_data CDC)
          // while STARTUP_FIRE is a strobe (sync_event CDC), so the gate can
          // stay closed for a few clk_in cycles after the FSM enters STARTUP.
          // An ungated countdown would race ahead of delivery and stop short,
          // giving 33-35 pulses (DIV32 0x100-0x102) instead of 36 (0x103).
          if (gate_en_neg) begin
            if (startup_cnt == 16'd1) begin
              state              <= ST_STOPPED_LOW;
              evt_startup_done_r <= 1'b1;
            end
            if (startup_cnt != 16'd0)
              startup_cnt <= startup_cnt - 16'd1;
          end
        end

        ST_ARMED: begin
          if (clk_div32_negedge) begin
            state                    <= ST_STOPPED_LOW;
            evt_stop_at_align_done_r <= 1'b1;
          end
        end

        ST_STOPPED_LOW: begin
          if (resume_strobe)
            state <= ST_RUNNING;
        end

        ST_RUNNING: begin
          if (gate_en_neg && edge_cnt + 16'd1 == edge_target)
            evt_edge_target_reached_r <= 1'b1;
          if (arm_stop_at_align)
            state <= ST_ARMED;
        end

        default: state <= ST_IDLE;
      endcase
    end
  end

  // ---------------- gate enable logic ----------------
  // gate_en_req is combinational; gate_en_neg is registered on
  // negedge clk_in to guarantee BUFGCE.CE only changes while clk_in
  // is LOW (Xilinx requirement to avoid runt pulses).

  always @* begin
    if (gate_force_off)
      gate_en_req = 1'b0;
    else if (gate_force_on)
      gate_en_req = 1'b1;
    else case (state)
      ST_IDLE:        gate_en_req = 1'b1;
      ST_STARTUP:     gate_en_req = (startup_cnt != 16'd0);
      ST_ARMED:       gate_en_req = 1'b1;
      ST_STOPPED_LOW: gate_en_req = 1'b0;
      ST_RUNNING:     gate_en_req = 1'b1;
      default:        gate_en_req = 1'b1;
    endcase
  end

  always @(negedge clk_in) begin
    if (!ext_resetn) gate_en_neg <= 1'b1;
    else             gate_en_neg <= gate_en_req;
  end

  // ---------------- gate (Xilinx BUFGCE) ----------------

  BUFGCE i_gate (
    .I  (clk_in),
    .CE (gate_en_neg),
    .O  (clk_out));

  // ---------------- ODR posedge re-registration (experiment: NOT Sequence.txt §F.10) ----------------
  // EXPERIMENT BUILD: ODR is re-registered on the RISING edge of clk_in,
  // deliberately violating Sequence.txt §F.10 (which requires falling-edge
  // alignment). This parks the chip-internal CLKIN-vs-ODR mismatch at the
  // TCLK/2 boundary (AD7134_2.png worst case) to measure the resulting
  // inter-chip rung distribution vs the negedge baseline.

  /* (* mark_debug = "true" *) */ reg odr_pos = 1'b0;
  always @(posedge clk_in) begin
    odr_pos <= odr_in;
  end
  assign odr_out = odr_pos;

  // ---------------- status / outputs ----------------

  assign edge_count       = edge_cnt;
  assign div32_cnt        = div32_q;
  assign gate_active      = gate_en_neg;
  assign startup_done     = (state != ST_STARTUP);
  assign stopped_low      = (state == ST_STOPPED_LOW);
  assign armed            = (state == ST_ARMED);
  assign edge_target_hit  = (state == ST_RUNNING) && (edge_cnt >= edge_target);

  assign evt_startup_done        = evt_startup_done_r;
  assign evt_stop_at_align_done  = evt_stop_at_align_done_r;
  assign evt_edge_target_reached = evt_edge_target_reached_r;

endmodule
