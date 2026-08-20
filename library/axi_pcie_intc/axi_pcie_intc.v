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

/*
 * MSI/MSI-X request gate for Xilinx PCIe endpoints (XDMA/QDMA usr_irq).
 *
 * Peripheral IRQ pins are levels; wiring them straight to usr_irq_req loses
 * interrupts that arrive while an earlier one is still asserted. This module
 * implements the PG195-required handshake: req[v] stays high until the host
 * clears the PENDING register (W1C), then holds low for REARM_CYCLES before
 * resampling the sources.
 *
 * Per-vector logic (no delivery state machine):
 *   PENDING == 0, rearm elapsed : PENDING <= intr_<v> & ENABLE  (resample)
 *   PENDING != 0                : PENDING <= PENDING & ~wdata   (host W1C)
 *   req[v]                       = (PENDING != 0)
 *
 * PENDING is a snapshot, not a live accumulator — prevents wedging under load.
 * RAW register gives the live unmasked view. usr_irq_ack feeds the sticky
 * DELIVERED register for diagnostics only.
 *
 * NUM_VECTORS <= 16, SRC_PER_VEC <= 32. Ports intr_0..intr_15 are fixed at
 * sixteen; unused ports above NUM_VECTORS are hidden by IP-XACT packaging.
 */

`timescale 1ns/100ps

module axi_pcie_intc #(

  // Number of usr_irq_req lines, i.e. MSI/MSI-X vectors. Must match the
  // endpoint's xdma_num_usr_irq. Also the number of intr_<v> ports in use.
  parameter NUM_VECTORS = 1,
  // Interrupt sources aggregated onto each vector, i.e. the width of every
  // intr_<v> port. 1 means no aggregation.
  parameter SRC_PER_VEC = 1,
  // Whether the intr_<v> ports are asynchronous to s_axi_aclk.
  parameter ASYNC_INTR = 1,
  // Cycles req[v] is held low before the level is resampled.
  parameter REARM_CYCLES = 4
) (

  // axi interface

  input                                 s_axi_aclk,
  input                                 s_axi_aresetn,
  input                                 s_axi_awvalid,
  input   [15:0]                        s_axi_awaddr,
  input   [ 2:0]                        s_axi_awprot,
  output                                s_axi_awready,
  input                                 s_axi_wvalid,
  input   [31:0]                        s_axi_wdata,
  input   [ 3:0]                        s_axi_wstrb,
  output                                s_axi_wready,
  output                                s_axi_bvalid,
  output  [ 1:0]                        s_axi_bresp,
  input                                 s_axi_bready,
  input                                 s_axi_arvalid,
  input   [15:0]                        s_axi_araddr,
  input   [ 2:0]                        s_axi_arprot,
  output                                s_axi_arready,
  output                                s_axi_rvalid,
  output  [ 1:0]                        s_axi_rresp,
  output  [31:0]                        s_axi_rdata,
  input                                 s_axi_rready,

  // Level-sensitive interrupt sources, one port per vector (SRC_PER_VEC wide).
  // All sixteen declared (Verilog-2001 cannot parameterize port count); unused
  // ports above NUM_VECTORS are hidden by IP-XACT packaging.

  input   [SRC_PER_VEC-1:0]             intr_0,
  input   [SRC_PER_VEC-1:0]             intr_1,
  input   [SRC_PER_VEC-1:0]             intr_2,
  input   [SRC_PER_VEC-1:0]             intr_3,
  input   [SRC_PER_VEC-1:0]             intr_4,
  input   [SRC_PER_VEC-1:0]             intr_5,
  input   [SRC_PER_VEC-1:0]             intr_6,
  input   [SRC_PER_VEC-1:0]             intr_7,
  input   [SRC_PER_VEC-1:0]             intr_8,
  input   [SRC_PER_VEC-1:0]             intr_9,
  input   [SRC_PER_VEC-1:0]             intr_10,
  input   [SRC_PER_VEC-1:0]             intr_11,
  input   [SRC_PER_VEC-1:0]             intr_12,
  input   [SRC_PER_VEC-1:0]             intr_13,
  input   [SRC_PER_VEC-1:0]             intr_14,
  input   [SRC_PER_VEC-1:0]             intr_15,

  // endpoint user interrupt handshake, synchronous to s_axi_aclk

  output  [NUM_VECTORS-1:0]             usr_irq_req,
  input   [NUM_VECTORS-1:0]             usr_irq_ack
);

  localparam          AXI_ADDRESS_WIDTH = 16;
  localparam  [31:0]  CORE_VERSION      = {16'h0001,     /* MAJOR */
                                             8'h00,      /* MINOR */
                                             8'h00};     /* PATCH */
  localparam  [31:0]  CORE_MAGIC        = 32'h50494e54;  // PINT

  localparam  [ 7:0]  NUM_VECTORS_C     = NUM_VECTORS;
  localparam  [ 7:0]  SRC_PER_VEC_C     = SRC_PER_VEC;

  localparam          RCW               = $clog2(REARM_CYCLES+1);
  localparam  [RCW-1:0] REARM_LOAD      = REARM_CYCLES - 1;

  // internal registers

  reg     [31:0]                    up_scratch = 'd0;
  reg     [NUM_VECTORS-1:0]         up_delivered = 'd0;
  reg                               up_wack = 'd0;
  reg                               up_rack = 'd0;
  reg     [31:0]                    up_rdata_int = 'd0;

  // internal signals

  wire                              up_clk;
  wire                              up_rstn;
  wire                              up_wreq_s;
  wire    [13:0]                    up_waddr_s;
  wire    [31:0]                    up_wdata_s;
  wire                              up_rreq_s;
  wire    [13:0]                    up_raddr_s;

  wire                              up_wglb_s;
  wire                              up_wvec_s;
  wire    [ 3:0]                    up_wvec_idx_s;
  wire    [ 2:0]                    up_wvec_reg_s;
  wire                              up_rglb_s;
  wire                              up_rvec_s;
  wire    [ 3:0]                    up_rvec_idx_s;
  wire    [ 2:0]                    up_rvec_reg_s;

  wire    [NUM_VECTORS*SRC_PER_VEC-1:0] intr_int;
  wire    [NUM_VECTORS*SRC_PER_VEC-1:0] intr_s;
  wire    [NUM_VECTORS*32-1:0]      up_vec_rdata_s;
  wire    [NUM_VECTORS-1:0]         up_delivered_clr_s;
  wire    [NUM_VECTORS-1:0]         req_s;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // Guarded: unused ports above NUM_VECTORS are not elaborated.

  generate
  if (NUM_VECTORS >  0) begin: g_in_0  assign intr_int[ 0*SRC_PER_VEC +: SRC_PER_VEC] = intr_0;  end
  if (NUM_VECTORS >  1) begin: g_in_1  assign intr_int[ 1*SRC_PER_VEC +: SRC_PER_VEC] = intr_1;  end
  if (NUM_VECTORS >  2) begin: g_in_2  assign intr_int[ 2*SRC_PER_VEC +: SRC_PER_VEC] = intr_2;  end
  if (NUM_VECTORS >  3) begin: g_in_3  assign intr_int[ 3*SRC_PER_VEC +: SRC_PER_VEC] = intr_3;  end
  if (NUM_VECTORS >  4) begin: g_in_4  assign intr_int[ 4*SRC_PER_VEC +: SRC_PER_VEC] = intr_4;  end
  if (NUM_VECTORS >  5) begin: g_in_5  assign intr_int[ 5*SRC_PER_VEC +: SRC_PER_VEC] = intr_5;  end
  if (NUM_VECTORS >  6) begin: g_in_6  assign intr_int[ 6*SRC_PER_VEC +: SRC_PER_VEC] = intr_6;  end
  if (NUM_VECTORS >  7) begin: g_in_7  assign intr_int[ 7*SRC_PER_VEC +: SRC_PER_VEC] = intr_7;  end
  if (NUM_VECTORS >  8) begin: g_in_8  assign intr_int[ 8*SRC_PER_VEC +: SRC_PER_VEC] = intr_8;  end
  if (NUM_VECTORS >  9) begin: g_in_9  assign intr_int[ 9*SRC_PER_VEC +: SRC_PER_VEC] = intr_9;  end
  if (NUM_VECTORS > 10) begin: g_in_10 assign intr_int[10*SRC_PER_VEC +: SRC_PER_VEC] = intr_10; end
  if (NUM_VECTORS > 11) begin: g_in_11 assign intr_int[11*SRC_PER_VEC +: SRC_PER_VEC] = intr_11; end
  if (NUM_VECTORS > 12) begin: g_in_12 assign intr_int[12*SRC_PER_VEC +: SRC_PER_VEC] = intr_12; end
  if (NUM_VECTORS > 13) begin: g_in_13 assign intr_int[13*SRC_PER_VEC +: SRC_PER_VEC] = intr_13; end
  if (NUM_VECTORS > 14) begin: g_in_14 assign intr_int[14*SRC_PER_VEC +: SRC_PER_VEC] = intr_14; end
  if (NUM_VECTORS > 15) begin: g_in_15 assign intr_int[15*SRC_PER_VEC +: SRC_PER_VEC] = intr_15; end
  endgenerate

  // Per-bit two-flop synchronizer for independent level sources.

  sync_bits #(
    .NUM_OF_BITS(NUM_VECTORS*SRC_PER_VEC),
    .ASYNC_CLK(ASYNC_INTR)
  ) i_intr_sync (
    .in_bits(intr_int),
    .out_resetn(up_rstn),
    .out_clk(up_clk),
    .out_bits(intr_s));

  up_axi #(
    .AXI_ADDRESS_WIDTH(AXI_ADDRESS_WIDTH)
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
    .up_rdata (up_rdata_int),
    .up_rack (up_rack));

  // Global regs: words 0x00-0x0f. Per-vector regs at 0x200 + v*0x20:
  //   +0x00 ENABLE (rw), +0x04 PENDING (w1c), +0x0c RAW (ro), +0x10 STATUS (ro)

  assign up_wglb_s = (up_waddr_s[13:4] == 10'h000);
  assign up_wvec_s = (up_waddr_s[13:7] ==  7'h01);
  assign up_wvec_idx_s = up_waddr_s[6:3];
  assign up_wvec_reg_s = up_waddr_s[2:0];

  assign up_rglb_s = (up_raddr_s[13:4] == 10'h000);
  assign up_rvec_s = (up_raddr_s[13:7] ==  7'h01);
  assign up_rvec_idx_s = up_raddr_s[6:3];
  assign up_rvec_reg_s = up_raddr_s[2:0];

  // global register writes

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_wglb_s == 1'b1)) begin
        case (up_waddr_s[3:0])
          4'h2: up_scratch <= up_wdata_s;
          default: begin end
        endcase
      end
    end
  end

  // Sticky DELIVERED register (diagnostic only, w1c at global +0x18).

  assign up_delivered_clr_s = ((up_wreq_s == 1'b1) && (up_wglb_s == 1'b1) &&
                               (up_waddr_s[3:0] == 4'h6)) ?
                              up_wdata_s[NUM_VECTORS-1:0] : {NUM_VECTORS{1'b0}};

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_delivered <= 'd0;
    end else begin
      up_delivered <= (up_delivered | usr_irq_ack) & ~up_delivered_clr_s;
    end
  end

  // per-vector request gate

  genvar v;
  generate
  for (v = 0; v < NUM_VECTORS; v = v + 1) begin: g_vector

    reg     [SRC_PER_VEC-1:0] enable = 'd0;
    reg     [SRC_PER_VEC-1:0] pending = 'd0;
    reg     [RCW-1:0]         rearm_cnt = 'd0;
    reg                       req = 'd0;

    wire    [SRC_PER_VEC-1:0] src_s;
    wire    [SRC_PER_VEC-1:0] armed_s;
    wire    [SRC_PER_VEC-1:0] acked_s;
    wire                      wr_s;
    wire                      ack_wr_s;
    wire                      rd_s;
    wire                      rearming_s;
    wire    [31:0]            rd_enable_s;
    wire    [31:0]            rd_pending_s;
    wire    [31:0]            rd_raw_s;
    wire    [31:0]            rd_status_s;

    assign src_s = intr_s[v*SRC_PER_VEC +: SRC_PER_VEC];
    assign armed_s = src_s & enable;
    assign acked_s = pending & ~up_wdata_s[SRC_PER_VEC-1:0];

    assign wr_s = up_wreq_s & up_wvec_s & (up_wvec_idx_s == v);
    // PENDING is W1C at the same address it reads back from.
    assign ack_wr_s = wr_s & (up_wvec_reg_s == 3'h1);
    assign rd_s = up_rvec_s & (up_rvec_idx_s == v);

    assign rearming_s = (rearm_cnt != {RCW{1'b0}});

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        enable <= 'd0;
      end else if ((wr_s == 1'b1) && (up_wvec_reg_s == 3'h0)) begin
        enable <= up_wdata_s[SRC_PER_VEC-1:0];
      end
    end

    // Three mutually exclusive arms: active, rearming, resample.

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        pending <= 'd0;
        rearm_cnt <= 'd0;
      end else if (pending != {SRC_PER_VEC{1'b0}}) begin
        if (ack_wr_s == 1'b1) begin
          pending <= acked_s;
          if (acked_s == {SRC_PER_VEC{1'b0}}) begin
            rearm_cnt <= REARM_LOAD;
          end
        end
      end else if (rearming_s == 1'b1) begin
        rearm_cnt <= rearm_cnt - 1'b1;
      end else begin
        pending <= armed_s;         // a no-op while nothing is armed
      end
    end

    // Registered output; low time is REARM_CYCLES.

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        req <= 1'b0;
      end else begin
        req <= (pending != {SRC_PER_VEC{1'b0}});
      end
    end

    assign req_s[v] = req;

    assign rd_enable_s = enable;
    assign rd_pending_s = pending;
    assign rd_raw_s = src_s;
    assign rd_status_s = {29'h0, up_delivered[v], rearming_s, req};

    assign up_vec_rdata_s[v*32 +: 32] =
      (rd_s == 1'b0) ? 32'h0 :
      (up_rvec_reg_s == 3'h0) ? rd_enable_s :
      (up_rvec_reg_s == 3'h1) ? rd_pending_s :
      (up_rvec_reg_s == 3'h3) ? rd_raw_s :
      (up_rvec_reg_s == 3'h4) ? rd_status_s : 32'h0;

  end
  endgenerate

  assign usr_irq_req = req_s;

  // global register reads

  integer i;
  reg [31:0] up_vec_rdata_or;

  always @(*) begin
    up_vec_rdata_or = 32'h0;
    for (i = 0; i < NUM_VECTORS; i = i + 1) begin
      up_vec_rdata_or = up_vec_rdata_or | up_vec_rdata_s[i*32 +: 32];
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rack <= 'd0;
      up_rdata_int <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b0) begin
        up_rdata_int <= 32'h0;
      end else if (up_rvec_s == 1'b1) begin
        up_rdata_int <= up_vec_rdata_or;
      end else if (up_rglb_s == 1'b1) begin
        case (up_raddr_s[3:0])
          4'h0: up_rdata_int <= CORE_VERSION;
          4'h1: up_rdata_int <= 32'h0;
          4'h2: up_rdata_int <= up_scratch;
          4'h3: up_rdata_int <= CORE_MAGIC;
          4'h4: up_rdata_int <= {16'h0, SRC_PER_VEC_C, NUM_VECTORS_C};
          4'h6: up_rdata_int <= up_delivered;
          default: up_rdata_int <= 32'h0;
        endcase
      end else begin
        up_rdata_int <= 32'h0;
      end
    end
  end

endmodule
