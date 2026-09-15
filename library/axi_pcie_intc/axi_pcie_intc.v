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
 * MSI/MSI-X request gate for a Xilinx PCIe endpoint (XDMA/QDMA usr_irq).
 *
 * Peripheral irq pins are levels, and PG195 wants usr_irq_req held until the
 * host has serviced and cleared a register in the user application. SRC_PENDING
 * is that register: one bit per source, write-1-to-clear at the address it reads
 * back from. SRC_CLAIM and VEC_CLAIM are announcing aliases of SRC_PENDING and
 * VEC_PENDING -- the read that hands the host a set is what says the host has
 * taken it on -- so a handler needs no closing write.
 *
 * Sources are flat: one intr[NUM_SOURCES-1:0] array, each bit sampled
 * independently, plus a writable SRC_ROUTE[s] table saying which vector each
 * source is delivered on. No grouping is in the bitstream: the source index is
 * the whole hardware contract -- the concat order feeding intr, and the driver's
 * hwirq -- and which sources share a vector is a runtime decision, made by
 * whoever knows how many vectors the host granted. The table is writable while
 * sources are live; see route_chg_s below. Every source in the array is routed,
 * tie-offs included, so the concat feeding intr is contiguous.
 *
 * The route table is readable the other way round, per vector: VEC_MEMB[v] is
 * the sources routed to v, VEC_PENDING[v] that set intersected with SRC_PENDING.
 * Both are free -- membership is already a comparator per (vector, source) pair,
 * and the intersection already feeds req[v] -- and they mean a dispatcher needs
 * no host-side copy of the route table to keep in step across a move.
 *
 * Per source, three mutually exclusive arms:
 *
 *   PENDING[s] == 0                : PENDING[s] <= intr[s] & ENABLE[s]
 *   PENDING[s] == 1                : PENDING[s] <= ~ack        (host clears)
 *   ENABLE[s] cleared by a write   : PENDING[s] <= 0           (teardown)
 *
 * PENDING[s] is a snapshot taken on the resample, not a live view: a level that
 * rose meanwhile is picked up by the next resample as a fresh request. Sampling
 * is per source, so acking one source does not delay another's resample.
 *
 * The request line belongs to the vector, and at PCIE_TYPE == 0 it is a gate
 * rather than a function of PENDING:
 *
 *   idle, rearm elapsed : req[v] <= |(PENDING & members(v) & ~ANN)
 *   req[v] == 1         : held until ack[v] has been seen, the host has claimed
 *                         the vector, and every source that claim covered has
 *                         been acked, then low for REARM_CYCLES
 *
 * That is the PG195 rule, so usr_irq_ack is in the control path here and must be
 * connected. The ack and the claim are latched while the request is up, so their
 * order does not matter; the drain is not latched, because it has to still be
 * true at the release. A vector holding nothing counts as claimed and drained,
 * so one emptied by a teardown or a re-route releases on its ack alone.
 * VEC_CLEAR[v] releases without the ack, for a message the endpoint never acked.
 *
 * The drain is |(PENDING & members(v) & ANN) -- pending *and* announced, so a
 * source that goes pending after the claim does not hold the request: it belongs
 * to the next pass, delivered by a new edge. It waits out the current pass, and
 * in exchange the host is never handed a set it is already working on.
 *
 * The host does not close the vector by writing to it. The claim read opens the
 * pass and the acks close it, and both are things the handler already does. The
 * read is the only moment hardware can know where the host's snapshot ended, and
 * announcing what it returned is what keeps the resample from delivering it
 * twice.
 *
 * Gating the vector rather than the source is what makes a shared vector work:
 * req[v] has to fall for the hard block to emit again, and a per-source gate
 * cannot drop it while any member is pending. The cost is that req[v] == 1 no
 * longer implies VEC_PENDING[v] != 0 -- a teardown or a re-route can empty an
 * already asserted vector. A dispatcher whose claim read returns zero has
 * nothing to service and nothing to do about it: that read is itself the
 * release.
 *
 * REARM_CYCLES (>= 1) is that low time, PCIE_TYPE == 0 only. One cycle is a
 * legitimate falling edge, but the width the hard block needs to re-trigger is
 * unspecified, so the default is 4. Sources are levels held until their driver
 * clears the condition, so resampling late loses nothing -- which is also what
 * makes the teardown arm safe.
 *
 * NUM_VECTORS <= 16 (the PG195 usr_irq width, and the 4-bit vector index in the
 * register map), NUM_SOURCES <= 32 (one 32-bit register covers every source).
 * SRC_ROUTE[s] resets to 0, so an unprogrammed controller puts every source on
 * vector 0 -- a working configuration, not a broken one. Only
 * $clog2(NUM_VECTORS) bits are stored; for a non-power-of-two NUM_VECTORS a
 * written value at or above NUM_VECTORS matches no vector and is never
 * delivered.
 *
 * PCIE_TYPE == 1 (PS-PCIe) keeps all of the above and replaces only the last
 * step. The ZynqMP PS PCIe controller has no usr_irq_req equivalent -- its four
 * ps_pl_irq_pcie_* ports are outputs, PS->PL mirrors for inbound messages -- so
 * nothing in the PL can ask it to emit an MSI. The core issues the message
 * itself, as one 32-bit AXI4 write of the vector's message data to its message
 * address through the PCIe egress aperture. There is no request line to hold and
 * so no gate: the announcement bits are the whole doorbell and VEC_CLEAR does
 * nothing. The write response takes over usr_irq_ack's role -- OKAY sets
 * DELIVERED, anything else sets ERROR.
 *
 * What arms that write is SRC_ANN, one bit per source: "the host has been told
 * about s on the vector s is currently routed to". A vector asks for a message
 * whenever it holds a pending source that is not yet announced. Three things
 * clear an announcement, and each is a case the doorbell has to cover:
 *
 *   the source stops being pending  -- the ordinary end of a request
 *   a fresh source goes pending     -- a second source joining a vector that is
 *                                      already asserted still owes a message,
 *                                      because a level has no second edge
 *   SRC_ROUTE[s] changes            -- the pending bit moved to another vector,
 *                                      which now owes the message
 *
 * The third is what makes a route writable at any time, including on a source
 * that is enabled and pending: no pending bit moves between vectors without the
 * destination owing a message, so nothing has to be quiesced and SRC_ROUTE and
 * SRC_ENABLE writes have no ordering requirement between them.
 *
 * Two things set an announcement, and both mean told: a launch on the vector
 * (PCIE_TYPE == 1, where the message is itself the announcement), and a claim
 * read covering it (either mode, and the only one at PCIE_TYPE == 0). It is set
 * on launch rather than on the write response, because a posted write's response
 * can return after the host has already acked, and a resample behind that ack
 * must be able to draw its own write.
 *
 * A source going pending between the launch and the claim read is serviced and
 * announced by that read. One going pending in the read's own cycle is in
 * neither -- setting the announcement loses to clearing it -- and draws its own
 * message.
 *
 * A vector issues only once a non-zero address has been programmed and its
 * MSI-X vector control says unmasked; until then the request is *held*, not
 * dropped, so an interrupt that predates that setup is late rather than lost,
 * and mask, rewrite, unmask is a safe update order. Vector control is written
 * last by the table's owner, so it already carries "this vector is live" with
 * the right ordering.
 *
 * The message address is the *host* address and is issued verbatim; the core
 * applies no translation, and neither does whoever programs it. Any PL->host
 * window offset is a synthesis-time property of the design, so it belongs on the
 * path from this master to the endpoint. M_AXI_ADDR_WIDTH is what lets this
 * master match the aperture such a bridge presents.
 */

`timescale 1ns/100ps

module axi_pcie_intc #(

  // Number of usr_irq_req lines, i.e. MSI/MSI-X vectors, and the size of the
  // MSI-X table. Must match the endpoint's xdma_num_usr_irq. A ceiling on how
  // finely sources can be separated, not a grouping: which sources land on which
  // vector is SRC_ROUTE, written at runtime.
  parameter NUM_VECTORS = 1,
  // Width of the intr port. The source index is the contract with software, so
  // it is fixed by the concat order feeding intr, never by the vector count.
  parameter NUM_SOURCES = 1,
  // Whether the intr port is asynchronous to s_axi_aclk.
  parameter ASYNC_INTR = 1,
  // Cycles a source's pending bit is held low after its ack before the level is
  // resampled.
  parameter REARM_CYCLES = 4,
  // Endpoint this core drives:
  //   0  XDMA / AXI-Bridge -- usr_irq_req/ack handshake (PG195)
  //   1  PS-PCIe           -- the core issues the MSI write itself
  parameter PCIE_TYPE = 0,
  // Width of the MSI write master's address. The message address is always
  // programmed as a full 64-bit pair; this only sizes the port, for a master
  // feeding an address bridge whose aperture is narrower than the host address
  // space. Bits at or above it are dropped, so an address that does not fit is a
  // configuration error. The eligibility gate looks at all 64 bits.
  parameter M_AXI_ADDR_WIDTH = 64
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

  // Level-sensitive interrupt sources, flat. Bit s is source s, and that index
  // is the whole contract: what SRC_ENABLE, SRC_PENDING and SRC_ROUTE are
  // indexed by, and what a host driver uses as its hwirq.

  input   [NUM_SOURCES-1:0]             intr,

  // MSI write master, PCIE_TYPE == 1 only. Write-only, one 32-bit beat, no IDs:
  // a single master with one outstanding write needs no tagging. The address is
  // the raw host address at 64 bits, or the aperture of an offset bridge when
  // narrower. Tied off and hidden by the packaging at PCIE_TYPE == 0.

  output                                m_axi_awvalid,
  output  [M_AXI_ADDR_WIDTH-1:0]        m_axi_awaddr,
  output  [ 7:0]                        m_axi_awlen,
  output  [ 2:0]                        m_axi_awsize,
  output  [ 1:0]                        m_axi_awburst,
  output  [ 3:0]                        m_axi_awcache,
  output  [ 2:0]                        m_axi_awprot,
  input                                 m_axi_awready,
  output                                m_axi_wvalid,
  output  [31:0]                        m_axi_wdata,
  output  [ 3:0]                        m_axi_wstrb,
  output                                m_axi_wlast,
  input                                 m_axi_wready,
  input                                 m_axi_bvalid,
  input   [ 1:0]                        m_axi_bresp,
  output                                m_axi_bready,

  // endpoint user interrupt handshake, synchronous to s_axi_aclk.
  // PCIE_TYPE == 0 only.

  output  [NUM_VECTORS-1:0]             usr_irq_req,
  input   [NUM_VECTORS-1:0]             usr_irq_ack
);

  localparam          AXI_ADDRESS_WIDTH = 16;
  // The version software checks before it trusts the layout below. A mismatch
  // means refuse, not degrade: the register map is not versioned field by field,
  // so there is no subset of it to drive blind.
  localparam  [31:0]  CORE_VERSION      = {16'h0001,     /* MAJOR */
                                             8'h00,      /* MINOR */
                                             8'h00};     /* PATCH */
  localparam  [31:0]  CORE_MAGIC        = 32'h494e5443;  // INTC

  localparam  [ 7:0]  NUM_VECTORS_C     = NUM_VECTORS;
  localparam  [ 7:0]  NUM_SOURCES_C     = NUM_SOURCES;
  localparam  [ 7:0]  PCIE_TYPE_C       = PCIE_TYPE;

  // Width of a SRC_ROUTE entry. Floored at 1 so NUM_VECTORS == 1 elaborates.
  localparam          VECW              = (NUM_VECTORS > 1) ?
                                          $clog2(NUM_VECTORS) : 1;

  // Byte offsets of the MSI-X table and PBA within this slave's own aperture,
  // clear of every block the register map uses. What the endpoint advertises is
  // these plus wherever the design maps this slave inside the BAR. Addressed in
  // dwords like the rest, so the decode compares word indices: entry = word[5:2],
  // field = word[1:0], which the table's 256-byte alignment allows.
  localparam  [15:0]  MSXT_OFF          = 'h8000;
  localparam  [15:0]  MSXP_OFF          = 'h8fe0;
  localparam  [13:0]  MSXT_WORD         = MSXT_OFF[15:2];
  localparam  [13:0]  MSXP_WORD         = MSXP_OFF[15:2];

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
  wire                              up_rglb_s;
  wire                              up_rvec_s;
  wire    [ 3:0]                    up_rvec_idx_s;
  wire    [ 2:0]                    up_rvec_reg_s;

  wire                              up_wrt_s;
  wire    [ 4:0]                    up_wrt_idx_s;
  wire                              up_rrt_s;
  wire    [ 4:0]                    up_rrt_idx_s;

  wire                              up_wmsxt_s;
  wire    [ 3:0]                    up_wmsxt_idx_s;
  wire    [ 1:0]                    up_wmsxt_reg_s;
  wire                              up_rmsxt_s;
  wire    [ 3:0]                    up_rmsxt_idx_s;
  wire    [ 1:0]                    up_rmsxt_reg_s;
  wire                              up_rmsxp_s;

  wire                              up_src_en_wr_s;
  wire                              up_src_ack_wr_s;
  wire                              up_src_claim_rd_s;
  wire                              up_vec_clear_wr_s;

  wire    [NUM_SOURCES-1:0]         intr_s;
  wire    [NUM_SOURCES-1:0]         src_enable_s;
  wire    [NUM_SOURCES-1:0]         src_pending_s;
  wire    [NUM_SOURCES-1:0]         src_ann_s;
  wire    [NUM_SOURCES*VECW-1:0]    src_route_s;
  wire    [NUM_SOURCES*32-1:0]      up_rt_rdata_s;

  wire    [NUM_VECTORS*32-1:0]      up_vec_rdata_s;
  wire    [NUM_VECTORS-1:0]         up_delivered_clr_s;
  wire    [NUM_VECTORS-1:0]         vec_pend_s;
  wire    [NUM_VECTORS-1:0]         vec_new_s;
  wire    [NUM_VECTORS-1:0]         vec_owed_s;
  wire    [NUM_VECTORS-1:0]         vec_claim_s;
  wire    [NUM_VECTORS-1:0]         vec_rearm_s;
  wire    [NUM_VECTORS-1:0]         vec_acked_s;
  wire    [NUM_VECTORS-1:0]         vec_svc_s;
  wire    [NUM_VECTORS-1:0]         req_s;

  // Everything mode-dependent crosses between the shared register file and the
  // g_msi/g_usr_irq branch on these, so the per-vector block below reads the
  // same way in both modes.
  //
  // vec_launch_s is one-hot and lives for the single cycle a message is launched
  // on that vector: it turns a launch into an announcement on every source the
  // message stands for.

  wire    [NUM_VECTORS-1:0]         vec_launch_s;
  wire    [NUM_VECTORS-1:0]         delivered_set_s;
  wire    [NUM_VECTORS-1:0]         up_error_s;
  wire    [NUM_VECTORS-1:0]         msi_pend_s;
  wire    [NUM_VECTORS*32-1:0]      msi_addr_lo_s;
  wire    [NUM_VECTORS*32-1:0]      msi_addr_hi_s;
  wire    [NUM_VECTORS*32-1:0]      msi_data_s;
  wire    [NUM_VECTORS*32-1:0]      msxt_rdata_s;
  wire    [NUM_VECTORS-1:0]         msix_pba_s;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // Each source bit is an independent level, so a per-bit two-flop synchronizer
  // is sufficient -- sync_bits' coherency caveat applies to multi-bit values,
  // not to a bundle of unrelated levels. usr_irq_ack shares s_axi_aclk with
  // the endpoint's user clock and is not synchronized.

  sync_bits #(
    .NUM_OF_BITS(NUM_SOURCES),
    .ASYNC_CLK(ASYNC_INTR)
  ) i_intr_sync (
    .in_bits(intr),
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

  // Global registers occupy words 0x00-0x1f (byte 0x000-0x07f):
  //
  //   0x000  VERSION      ro
  //   0x008  SCRATCH      rw
  //   0x00c  MAGIC        ro   "INTC"
  //   0x010  CONFIG       ro   {PCIE_TYPE, NUM_SOURCES, NUM_VECTORS}
  //   0x014  --                reserved
  //   0x018  DELIVERED    w1c  bit per vector, message reached the host
  //   0x01c  ERROR        w1c  bit per vector, BRESP != OKAY  (PCIE_TYPE == 1)
  //   0x020  --                reserved
  //   0x024  --                reserved
  //   0x040  SRC_ENABLE   rw   bit per source, sources sampled on a resample
  //   0x044  SRC_PENDING  rw   bit per source, w1c, the set the host owes acks
  //   0x048  VEC_SVC      ro   bit per vector, claimed, release still pending
  //   0x04c  VEC_CLEAR    wo   bit per vector, release without the ack
  //   0x050  SRC_CLAIM    ro   SRC_PENDING, and the read announces what it
  //                             returns
  //
  // the per-vector blocks words 0x80-0xff (byte 0x200 + v*0x20):
  //
  //   +0x10  STATUS       ro   {serviced, acked, error[v], outstanding,
  //                             delivered[v], rearming, req}
  //   +0x14  VEC_PENDING  ro   bit per source, routed here and pending
  //   +0x18  VEC_MEMB     ro   bit per source, routed here
  //   +0x1c  VEC_CLAIM    ro   VEC_PENDING, and the read announces what it
  //                             returns
  //
  // and the route table words 0x100-0x11f (byte 0x400 + s*4):
  //
  //   SRC_ROUTE[s]        rw   [VECW-1:0]  which vector source s is delivered on
  //
  // The driver reaches these by offset, so a reserved word stays reserved rather
  // than being compacted away: 0x020 and 0x024 published MSXT_OFF and MSXP_OFF,
  // and STATUS keeps its +0x10 offset because +0x00, +0x04 and +0x08 were the
  // per-vector ENABLE, PENDING and RAW.
  //
  // VEC_SVC and VEC_CLEAR are global rather than one more word in each per-vector
  // block: a teardown reaches every vector at once, and VEC_SVC is wanted as a
  // set. VEC_SVC is the vectors whose pending set the host has claimed and whose
  // endpoint ack has not arrived -- the one state that wedges a vector, and the
  // one VEC_CLEAR exists for.
  //
  // SRC_CLAIM and VEC_CLAIM are the announcing aliases of SRC_PENDING and
  // VEC_PENDING: same data, and the read marks every bit it returned as told to
  // the host, which releases the vector and keeps the resample from delivering
  // the set again. A handler reads the alias; a debug read or a poll reads the
  // plain register and disturbs nothing.
  //
  // Where the message goes is in the MSI-X table, the only place it is in either
  // mode: a third block at MSXT_OFF, 16 bytes per vector in the layout the PCIe
  // spec fixes:
  //
  //   +0x00  message address low   rw
  //   +0x04  message address high  rw
  //   +0x08  message data          rw
  //   +0x0c  vector control        rw   bit 0 mask, reset 1, 31:1 ro 0
  //
  // with the Pending Bit Array one read-only dword at MSXP_OFF, bit per vector.
  //
  // One entry per vector because that is what MSI-X needs: each vector carries
  // its own address as well as its own data. Multi-MSI is the degenerate case,
  // the same address in every entry.
  //
  // Both modes write here -- in MSI-X the host does over the BAR, in MSI whoever
  // mirrors config space does over AXI -- and the two writers are mutually
  // exclusive because the modes are. A mirror driving MSI must clear vector
  // control as well, since it resets masked.
  //
  // The storage has to be here because a PS-PCIe endpoint has none to offer: the
  // NWL bridge's egress translations expose only a *source* base, with no
  // destination register, so a host write to the advertised BAR offset is
  // forwarded to AXI like any other.

  assign up_wglb_s = (up_waddr_s[13:5] == 9'h000);
  assign up_wrt_s = (up_waddr_s[13:5] == 9'h008);
  assign up_wrt_idx_s = up_waddr_s[4:0];

  assign up_rglb_s = (up_raddr_s[13:5] == 9'h000);
  assign up_rvec_s = (up_raddr_s[13:7] == 7'h01);
  assign up_rvec_idx_s = up_raddr_s[6:3];
  assign up_rvec_reg_s = up_raddr_s[2:0];
  assign up_rrt_s = (up_raddr_s[13:5] == 9'h008);
  assign up_rrt_idx_s = up_raddr_s[4:0];

  assign up_wmsxt_s = (up_waddr_s[13:6] == MSXT_WORD[13:6]);
  assign up_wmsxt_idx_s = up_waddr_s[5:2];
  assign up_wmsxt_reg_s = up_waddr_s[1:0];

  assign up_rmsxt_s = (up_raddr_s[13:6] == MSXT_WORD[13:6]);
  assign up_rmsxt_idx_s = up_raddr_s[5:2];
  assign up_rmsxt_reg_s = up_raddr_s[1:0];

  // The PBA is one dword whatever NUM_VECTORS is, so it decodes on the whole
  // word address rather than on a block.
  assign up_rmsxp_s = (up_raddr_s == MSXP_WORD);

  assign up_src_en_wr_s = up_wreq_s & up_wglb_s & (up_waddr_s[4:0] == 5'h10);
  // SRC_PENDING is write-1-to-clear at the address it reads back from, as in the
  // rest of this library (axi_dmac's IRQ_PENDING, axi_spi_engine's).
  assign up_src_ack_wr_s = up_wreq_s & up_wglb_s & (up_waddr_s[4:0] == 5'h11);
  assign up_vec_clear_wr_s = up_wreq_s & up_wglb_s & (up_waddr_s[4:0] == 5'h13);
  // The only read in the map with a side effect, so it is qualified by the read
  // request rather than by the address alone.
  assign up_src_claim_rd_s = up_rreq_s & up_rglb_s & (up_raddr_s[4:0] == 5'h14);

  // global register writes

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_wglb_s == 1'b1)) begin
        case (up_waddr_s[4:0])
          5'h02: up_scratch <= up_wdata_s;
          default: begin end
        endcase
      end
    end
  end

  // Sticky record of which vectors a message got out for: usr_irq_ack at
  // PCIE_TYPE == 0, an OKAY write response at PCIE_TYPE == 1. Diagnostic only:
  // it tells a stuck vector apart from one whose message never left.

  assign up_delivered_clr_s = ((up_wreq_s == 1'b1) && (up_wglb_s == 1'b1) &&
                               (up_waddr_s[4:0] == 5'h06)) ?
                              up_wdata_s[NUM_VECTORS-1:0] : {NUM_VECTORS{1'b0}};

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_delivered <= 'd0;
    end else begin
      up_delivered <= (up_delivered | delivered_set_s) & ~up_delivered_clr_s;
    end
  end

  // per-source sampling, route and announcement

  genvar s;
  generate
  for (s = 0; s < NUM_SOURCES; s = s + 1) begin: g_source

    reg                       enable = 1'b0;
    reg                       pending = 1'b0;
    reg                       ann = 1'b0;
    reg     [VECW-1:0]        route = 'd0;

    wire                      armed_s;
    wire                      ack_s;
    wire                      dis_s;
    wire                      route_wr_s;
    wire                      route_chg_s;
    wire                      ann_set_s;

    assign armed_s = intr_s[s] & enable;
    assign ack_s = up_src_ack_wr_s & up_wdata_s[s];
    // "this source is being torn down": the write that clears its enable bit
    // also drops what it owed. Taken from the write rather than from ENABLE
    // reading zero, so it is an event and cannot re-trigger. Safe because a
    // source is a level held until its driver clears the condition, so a discard
    // defers an interrupt rather than losing it.
    assign dis_s = up_src_en_wr_s & ~up_wdata_s[s];

    assign route_wr_s = up_wreq_s & up_wrt_s & (up_wrt_idx_s == s);
    // Only a write that lands the source on a different vector is a routing
    // change: a rewrite of the same value must not disturb a delivery in flight,
    // which is what makes an idempotent SRC_ROUTE write from the driver free.
    assign route_chg_s = route_wr_s & (up_wdata_s[VECW-1:0] != route);

    // Told about: a claim read that covered this source, or a launch on the
    // vector it is currently routed to. The per-vector terms are guarded because
    // a route at or above NUM_VECTORS -- reachable only for a non-power-of-two
    // NUM_VECTORS -- indexes nothing. SRC_CLAIM needs no route: it returns every
    // source.
    assign ann_set_s = up_src_claim_rd_s |
                       ((route < NUM_VECTORS) ?
                        (vec_launch_s[route] | vec_claim_s[route]) : 1'b0);

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        enable <= 1'b0;
      end else if (up_src_en_wr_s == 1'b1) begin
        enable <= up_wdata_s[s];
      end
    end

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        route <= 'd0;
      end else if (route_wr_s == 1'b1) begin
        route <= up_wdata_s[VECW-1:0];
      end
    end

    // The arms are mutually exclusive, which is what makes the snapshot safe
    // without any state to guard it: while pending is set only the host or a
    // teardown can clear it.
    //
    // Nothing delays the resample. A level the host acks and has not cleared at
    // its source goes pending again the cycle after, which is correct -- the
    // device still wants service. The falling edge the hard block needs is the
    // vector's business, so there is no counter here.

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        pending <= 1'b0;
      end else if (dis_s == 1'b1) begin
        pending <= 1'b0;
      end else if (pending == 1'b1) begin
        if (ack_s == 1'b1) begin
          pending <= 1'b0;
        end
      end else begin
        pending <= armed_s;         // a no-op while nothing is armed
      end
    end

    // "the host has been told about this source on the vector it is routed to".
    // Clearing beats setting: a route change in the same cycle as a launch is a
    // launch the new vector did not carry, so the new vector still owes one.

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        ann <= 1'b0;
      end else if ((pending == 1'b0) || (route_chg_s == 1'b1)) begin
        ann <= 1'b0;
      end else if (ann_set_s == 1'b1) begin
        ann <= 1'b1;
      end
    end

    assign src_enable_s[s] = enable;
    assign src_pending_s[s] = pending;
    assign src_ann_s[s] = ann;
    assign src_route_s[s*VECW +: VECW] = route;

    assign up_rt_rdata_s[s*32 +: 32] =
      ((up_rrt_s == 1'b1) && (up_rrt_idx_s == s)) ?
      {{(32-VECW){1'b0}}, route} : 32'h0;

  end
  endgenerate

  // per-vector request

  genvar v;
  genvar m;
  generate
  for (v = 0; v < NUM_VECTORS; v = v + 1) begin: g_vector

    wire    [NUM_SOURCES-1:0] memb_s;
    wire                      rd_s;
    wire    [31:0]            rd_status_s;
    wire    [31:0]            rd_pending_s;
    wire    [31:0]            rd_memb_s;

    // Membership is the route table read the other way round: one comparator per
    // (vector, source) pair, the whole cost of a programmable grouping.
    for (m = 0; m < NUM_SOURCES; m = m + 1) begin: g_memb
      assign memb_s[m] = (src_route_s[m*VECW +: VECW] == v);
    end

    assign vec_pend_s[v] = |(src_pending_s & memb_s);
    // "a source routed here is pending and the host has not been told about it
    // on this vector". Covers a second source joining an already-asserted vector
    // and a pending source arriving by a route write, neither of which is an edge
    // on the vector's request.
    assign vec_new_s[v] = |(src_pending_s & memb_s & ~src_ann_s);
    // The other half of the same intersection: pending and announced, the set the
    // host still owes acks for. A source that went pending after the claim is not
    // announced and so is not in it, which keeps the request to one pass.
    assign vec_owed_s[v] = |(src_pending_s & memb_s & src_ann_s);

    assign rd_s = up_rvec_s & (up_rvec_idx_s == v);
    assign rd_status_s = {25'h0, vec_svc_s[v], vec_acked_s[v], up_error_s[v],
                          msi_pend_s[v], up_delivered[v], vec_rearm_s[v],
                          req_s[v]};

    // Zero-extended by the assignment, so NUM_SOURCES == 32 does not ask for a
    // zero-width replication.
    assign rd_pending_s = src_pending_s & memb_s;
    assign rd_memb_s = memb_s;

    // The claim read of this vector. Qualified by the read request, unlike rd_s:
    // this one announces, so an address decode alone would fire it on whatever
    // else the bus was doing.
    assign vec_claim_s[v] = up_rreq_s & rd_s & (up_rvec_reg_s == 3'h7);

    assign up_vec_rdata_s[v*32 +: 32] =
      (rd_s == 1'b0) ? 32'h0 :
      (up_rvec_reg_s == 3'h4) ? rd_status_s :
      (up_rvec_reg_s == 3'h5) ? rd_pending_s :
      (up_rvec_reg_s == 3'h6) ? rd_memb_s :
      (up_rvec_reg_s == 3'h7) ? rd_pending_s : 32'h0;

    // The request line, registered either way so the endpoint sees a clean
    // output and STATUS reads the same shape in both modes.
    //
    // At PCIE_TYPE == 0 it is gated: up on a pending member, held until the
    // endpoint has acked *and* the host has closed the vector, then down for
    // REARM_CYCLES so the hard block sees a real edge on the next assertion.
    // Both conditions are latched, so their order does not matter, and only while
    // the request is up, so a leftover ack or a late claim read cannot close the
    // next one.

    if (PCIE_TYPE == 0) begin: g_gate

      reg                       asserted = 1'b0;
      reg                       ack_seen = 1'b0;
      reg                       svc_seen = 1'b0;
      reg     [RCW-1:0]         rearm_cnt = 'd0;

      wire                      ack_any_s;
      wire                      claim_s;
      wire                      svc_any_s;
      wire                      clear_s;
      wire                      release_s;
      wire                      rearming_s;

      assign ack_any_s = ack_seen | usr_irq_ack[v];
      // Either alias claims this vector: VEC_CLAIM by index, SRC_CLAIM because
      // the word it returns covers every vector.
      assign claim_s = vec_claim_s[v] | up_src_claim_rd_s;
      // "the host took this vector's set on, and it has finished with it". The
      // claim is latched and the drain is not: the claim is an event, the drain a
      // level that has to still be true at the release. The latch also keeps the
      // claim out of its own drain, since the announcements it sets land on the
      // same edge svc_seen does. A vector holding nothing satisfies both terms,
      // which releases one emptied by a teardown or a re-route.
      assign svc_any_s = (svc_seen & ~vec_owed_s[v]) | ~vec_pend_s[v];
      // The one release that does not wait on the endpoint: a message the
      // endpoint never acked would otherwise hold the vector forever.
      assign clear_s = up_vec_clear_wr_s & up_wdata_s[v];
      assign release_s = asserted & (clear_s | (ack_any_s & svc_any_s));
      assign rearming_s = (rearm_cnt != {RCW{1'b0}});

      always @(posedge up_clk) begin
        if (up_rstn == 1'b0) begin
          asserted <= 1'b0;
          ack_seen <= 1'b0;
          svc_seen <= 1'b0;
          rearm_cnt <= 'd0;
        end else if (release_s == 1'b1) begin
          asserted <= 1'b0;
          ack_seen <= 1'b0;
          svc_seen <= 1'b0;
          rearm_cnt <= REARM_LOAD;
        end else if (asserted == 1'b1) begin
          ack_seen <= ack_any_s;
          // The claim only. svc_any_s falls again while a source of the claimed
          // set is still pending, and latching it would let the first drained
          // cycle stand in for every later one.
          svc_seen <= svc_seen | claim_s;
        end else if (rearming_s == 1'b1) begin
          rearm_cnt <= rearm_cnt - 1'b1;
        end else begin
          // ~ANN, not PENDING: a source the host has already been told about is
          // the host's to finish, and asserting on it again is a second doorbell
          // for work in progress.
          asserted <= vec_new_s[v];
        end
      end

      assign req_s[v] = asserted;
      assign vec_rearm_s[v] = rearming_s;
      assign vec_acked_s[v] = ack_seen;
      assign vec_svc_s[v] = svc_seen;

    end else begin: g_direct

      // Nothing to hold: the message leaves on its own and the announcement bits
      // are the whole doorbell.

      reg                       pend_r = 1'b0;

      always @(posedge up_clk) begin
        if (up_rstn == 1'b0) begin
          pend_r <= 1'b0;
        end else begin
          pend_r <= vec_pend_s[v];
        end
      end

      assign req_s[v] = pend_r;
      assign vec_rearm_s[v] = 1'b0;
      assign vec_acked_s[v] = 1'b0;
      assign vec_svc_s[v] = 1'b0;

    end

  end
  endgenerate

  // Everything that differs between the two endpoints lives here.

  generate
  if (PCIE_TYPE == 1) begin: g_msi

    genvar w;

    reg     [NUM_VECTORS-1:0] error = 'd0;

    reg     [63:0]            awaddr = 'd0;
    reg     [31:0]            wdata = 'd0;
    reg                       awvalid = 'd0;
    reg                       wvalid = 'd0;
    reg                       bwait = 'd0;
    reg     [NUM_VECTORS-1:0] sel = 'd0;

    wire    [NUM_VECTORS-1:0] msi_req_s;
    wire    [NUM_VECTORS-1:0] addr_ok_s;
    wire    [NUM_VECTORS-1:0] eligible_s;
    wire    [NUM_VECTORS-1:0] grant_s;
    wire    [NUM_VECTORS-1:0] error_clr_s;
    wire    [NUM_VECTORS-1:0] msix_mask_s;
    wire                      idle_s;
    wire                      start_s;
    wire                      done_s;
    wire                      okay_s;

    // The one MSI-X table entry per vector, written by whichever of the host and
    // the config space mirror the current mode makes the owner. Vector control
    // resets to masked as the PCIe spec requires, so the post-reset state is
    // safe; addr_ok_s backs it up.

    for (w = 0; w < NUM_VECTORS; w = w + 1) begin: g_msg

      reg [31:0] addr_lo = 'd0;
      reg [31:0] addr_hi = 'd0;
      reg [31:0] data = 'd0;
      reg        vctrl = 1'b1;

      wire       tbl_wr_s;
      wire       tbl_rd_s;

      assign tbl_wr_s = up_wreq_s & up_wmsxt_s & (up_wmsxt_idx_s == w);
      assign tbl_rd_s = up_rmsxt_s & (up_rmsxt_idx_s == w);

      always @(posedge up_clk) begin
        if (up_rstn == 1'b0) begin
          addr_lo <= 'd0;
          addr_hi <= 'd0;
          data <= 'd0;
          vctrl <= 1'b1;
        end else begin
          if (tbl_wr_s == 1'b1) begin
            case (up_wmsxt_reg_s)
              2'h0: addr_lo <= up_wdata_s;
              2'h1: addr_hi <= up_wdata_s;
              2'h2: data <= up_wdata_s;
              2'h3: vctrl <= up_wdata_s[0];
              default: begin end
            endcase
          end
        end
      end

      assign msi_addr_lo_s[w*32 +: 32] = addr_lo;
      assign msi_addr_hi_s[w*32 +: 32] = addr_hi;
      assign msi_data_s[w*32 +: 32] = data;
      assign msix_mask_s[w] = vctrl;

      assign msxt_rdata_s[w*32 +: 32] =
        (tbl_rd_s == 1'b0) ? 32'h0 :
        (up_rmsxt_reg_s == 2'h0) ? addr_lo :
        (up_rmsxt_reg_s == 2'h1) ? addr_hi :
        (up_rmsxt_reg_s == 2'h2) ? data : {31'h0, vctrl};

      // A request with no address programmed would otherwise write to AXI
      // address 0, i.e. into DDR. Held rather than dropped, so the gate opens as
      // soon as the address lands. The test must stay on the *programmed* pair:
      // a downstream window offset makes 0 a live host address, so gating on a
      // transformed value would let an unprogrammed vector write into host
      // memory.

      assign addr_ok_s[w] = ({addr_hi, addr_lo} != 64'h0);

    end

    // The doorbell is a plain function of state, not a register: SRC_ANN holds
    // the memory, and it holds across the outstanding-write window because it is
    // set on launch. Nothing here has to be discarded on teardown -- clearing a
    // source's enable bit clears its pending bit, and the request goes with it.

    assign msi_req_s = vec_new_s;

    // The mask gates issue, not sampling: a pending bit still records that the
    // source fired, so a masked vector's request is held and issues the cycle the
    // host clears the mask.

    assign eligible_s = msi_req_s & ~msix_mask_s & addr_ok_s;

    // The PBA says "a message is owed and the mask is why it has not been sent".
    // It needs no clear: the request drops when the launch announces its
    // sources, and a launch is exactly what unmasking permits.

    assign msix_pba_s = msi_req_s & msix_mask_s;

    // Lowest index first, one outstanding write. Interrupts are rare enough
    // relative to a PCIe write that neither fairness nor pipelining is worth
    // the logic; isolating the low set bit is the whole arbiter.

    assign grant_s = eligible_s & (~eligible_s + 1'b1);

    assign idle_s = ~awvalid & ~wvalid & ~bwait;
    assign start_s = idle_s & (eligible_s != {NUM_VECTORS{1'b0}});
    assign done_s = bwait & m_axi_bvalid;
    assign okay_s = (m_axi_bresp == 2'b00);

    // Announce on launch. idle_s drops in the same cycle the announcements are
    // taken, so the vector cannot launch twice for the same set.
    assign vec_launch_s = (start_s == 1'b1) ? grant_s : {NUM_VECTORS{1'b0}};

    integer j;
    reg [63:0] sel_addr;
    reg [31:0] sel_data;

    always @(*) begin
      sel_addr = 64'h0;
      sel_data = 32'h0;
      for (j = 0; j < NUM_VECTORS; j = j + 1) begin
        if (grant_s[j] == 1'b1) begin
          sel_addr = {msi_addr_hi_s[j*32 +: 32], msi_addr_lo_s[j*32 +: 32]};
          sel_data = msi_data_s[j*32 +: 32];
        end
      end
    end

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        awvalid <= 1'b0;
        wvalid <= 1'b0;
        bwait <= 1'b0;
        sel <= 'd0;
        awaddr <= 'd0;
        wdata <= 'd0;
      end else if (start_s == 1'b1) begin
        awvalid <= 1'b1;
        wvalid <= 1'b1;
        bwait <= 1'b1;
        sel <= grant_s;
        awaddr <= sel_addr;
        wdata <= sel_data;
      end else begin
        if (m_axi_awready == 1'b1) begin
          awvalid <= 1'b0;
        end
        if (m_axi_wready == 1'b1) begin
          wvalid <= 1'b0;
        end
        if (done_s == 1'b1) begin
          bwait <= 1'b0;
        end
      end
    end

    // A write that never reached the host is visible rather than silent: the
    // response splits into DELIVERED and ERROR.

    assign delivered_set_s = (done_s & okay_s) ? sel : {NUM_VECTORS{1'b0}};

    assign error_clr_s = ((up_wreq_s == 1'b1) && (up_wglb_s == 1'b1) &&
                          (up_waddr_s[4:0] == 5'h07)) ?
                         up_wdata_s[NUM_VECTORS-1:0] : {NUM_VECTORS{1'b0}};

    always @(posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        error <= 'd0;
      end else begin
        error <= (error & ~error_clr_s) |
                 ((done_s & ~okay_s) ? sel : {NUM_VECTORS{1'b0}});
      end
    end

    assign up_error_s = error;
    // "a message is owed to the host": still waiting for the bus, or on the bus.
    assign msi_pend_s = msi_req_s | ((bwait == 1'b1) ? sel : {NUM_VECTORS{1'b0}});

    assign m_axi_awvalid = awvalid;
    assign m_axi_awaddr = awaddr[M_AXI_ADDR_WIDTH-1:0];
    assign m_axi_awlen = 8'h00;          // one beat
    assign m_axi_awsize = 3'd2;          // 4 bytes
    assign m_axi_awburst = 2'b01;        // INCR
    assign m_axi_awcache = 4'h0;
    assign m_axi_awprot = 3'b010;        // non-secure data, as the DMACs use
    assign m_axi_wvalid = wvalid;
    assign m_axi_wdata = wdata;
    assign m_axi_wstrb = 4'hf;
    assign m_axi_wlast = 1'b1;
    assign m_axi_bready = bwait;

    assign usr_irq_req = {NUM_VECTORS{1'b0}};

  end else begin: g_usr_irq

    // No message to launch, so nothing announces on one. The claim read is what
    // announces here, and SRC_ANN is what stops the gate from re-delivering a set
    // the host already holds.

    assign vec_launch_s = {NUM_VECTORS{1'b0}};
    assign delivered_set_s = usr_irq_ack;
    assign up_error_s = {NUM_VECTORS{1'b0}};
    assign msi_pend_s = {NUM_VECTORS{1'b0}};
    assign msi_addr_lo_s = {NUM_VECTORS*32{1'b0}};
    assign msi_addr_hi_s = {NUM_VECTORS*32{1'b0}};
    assign msi_data_s = {NUM_VECTORS*32{1'b0}};
    assign msxt_rdata_s = {NUM_VECTORS*32{1'b0}};
    assign msix_pba_s = {NUM_VECTORS{1'b0}};

    assign m_axi_awvalid = 1'b0;
    assign m_axi_awaddr = {M_AXI_ADDR_WIDTH{1'b0}};
    assign m_axi_awlen = 8'h0;
    assign m_axi_awsize = 3'h0;
    assign m_axi_awburst = 2'h0;
    assign m_axi_awcache = 4'h0;
    assign m_axi_awprot = 3'h0;
    assign m_axi_wvalid = 1'b0;
    assign m_axi_wdata = 32'h0;
    assign m_axi_wstrb = 4'h0;
    assign m_axi_wlast = 1'b0;
    assign m_axi_bready = 1'b0;

    assign usr_irq_req = req_s;

  end
  endgenerate

  // global register reads

  integer i;
  integer k;
  reg [31:0] up_vec_rdata_or;
  reg [31:0] up_msxt_rdata_or;
  reg [31:0] up_rt_rdata_or;
  wire [31:0] up_msxp_rdata_s;
  wire [31:0] up_src_enable_s;
  wire [31:0] up_src_pending_s;
  wire [31:0] up_vec_svc_s;

  always @(*) begin
    up_vec_rdata_or = 32'h0;
    up_msxt_rdata_or = 32'h0;
    for (i = 0; i < NUM_VECTORS; i = i + 1) begin
      up_vec_rdata_or = up_vec_rdata_or | up_vec_rdata_s[i*32 +: 32];
      up_msxt_rdata_or = up_msxt_rdata_or | msxt_rdata_s[i*32 +: 32];
    end
  end

  always @(*) begin
    up_rt_rdata_or = 32'h0;
    for (k = 0; k < NUM_SOURCES; k = k + 1) begin
      up_rt_rdata_or = up_rt_rdata_or | up_rt_rdata_s[k*32 +: 32];
    end
  end

  assign up_msxp_rdata_s = {{(32-NUM_VECTORS){1'b0}}, msix_pba_s};

  // Zero-extended by the assignment rather than by a concatenation, so
  // NUM_SOURCES == 32 does not ask for a zero-width replication.
  assign up_src_enable_s = src_enable_s;
  assign up_src_pending_s = src_pending_s;
  // The vectors whose pending set the host has claimed and whose request has not
  // been released yet. VEC_CLEAR latches nothing and reads zero.
  assign up_vec_svc_s = vec_svc_s;

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
      end else if (up_rrt_s == 1'b1) begin
        up_rdata_int <= up_rt_rdata_or;
      end else if (up_rmsxt_s == 1'b1) begin
        up_rdata_int <= up_msxt_rdata_or;
      end else if (up_rmsxp_s == 1'b1) begin
        up_rdata_int <= up_msxp_rdata_s;
      end else if (up_rglb_s == 1'b1) begin
        case (up_raddr_s[4:0])
          5'h00: up_rdata_int <= CORE_VERSION;
          5'h02: up_rdata_int <= up_scratch;
          5'h03: up_rdata_int <= CORE_MAGIC;
          5'h04: up_rdata_int <= {8'h0, PCIE_TYPE_C, NUM_SOURCES_C,
                                  NUM_VECTORS_C};
          5'h06: up_rdata_int <= up_delivered;
          5'h07: up_rdata_int <= up_error_s;
          5'h10: up_rdata_int <= up_src_enable_s;
          5'h11: up_rdata_int <= up_src_pending_s;
          5'h12: up_rdata_int <= up_vec_svc_s;
          5'h14: up_rdata_int <= up_src_pending_s;
          default: up_rdata_int <= 32'h0;
        endcase
      end else begin
        up_rdata_int <= 32'h0;
      end
    end
  end

endmodule
