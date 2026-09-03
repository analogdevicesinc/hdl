// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2023 The Regents of the University of California
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * ethernet_vck190 - Corundum MAC wrapper for the AMD Versal AI Core VCK190
 * (MRMAC over GTY). This is the GTY sibling of ethernet_vpk180 (MRMAC over GTM):
 * byte-identical RTL (the GT-family-agnostic mrmac_gty_wrapper), the GTM/GTY
 * choice lives entirely in the block design (mrmac_0 + gtwiz + mrmac_versal_glue).
 *
 * This is the Versal analog of ethernet_vcu118. It presents the SAME
 * fpga_core-facing MAC contract that ethernet_vcu118 does (axis_eth_tx/rx +
 * flow-control + PTP + eth clocks/resets + ctrl_reg), so corundum.tcl wires it
 * to corundum_core with the identical board-independent connect block.
 *
 * Difference from VCU118: the MAC/PHY is the AMD Versal MRMAC HARD IP, which
 * cannot be packaged inside an RTL IP (it must be a block-design cell built
 * beside a GT wizard + clocking). So instead of the hand-written
 * cmac_gty_wrapper, the port is driven by a mrmac_gty_wrapper MAC-shim
 * (MODE="1x100G") whose MRMAC-facing pins are EXPOSED OUTWARD as plain ports
 * (mrmac_tx_axis_*, mrmac_rx_axis_*, user clocks, status). The VCK190 branch of
 * corundum.tcl instantiates mrmac_0 + gtwiz_versal + mrmac_versal_glue beside
 * this cell and connects those pins pin-to-pin.
 *
 * Mode: 1x100GE - one MRMAC, one bonded CAUI-4 100G port, 384-bit SEGMENTED
 * (6x64) on the MRMAC side and 512-bit on the fpga_core side. So PORT_COUNT=1,
 * one mrmac_gty_wrapper, and one mqnic_port_map_mac_axis maps the single MAC to
 * the single core port. (The 4x25GE variant is recoverable from git history.)
 *
 * PTP width contract (do NOT change without re-checking the RX slice below):
 * the shim presents a FIXED rx_axis_tuser[80:0] = {ptp_ts[79:0], err}, exactly
 * like cmac_gty_wrapper. This module slices AXIS_RX_USER_WIDTH bits out of that
 * 81-bit field, mirroring ethernet_vcu118 line-for-line, so PTP_TS_WIDTH must
 * stay <= 80 and AXIS_RX_USER_WIDTH <= 81. The VCK190 config uses the proven
 * VCU118 combination (PTP_TS_FMT_TOD=0, PTP_TS_WIDTH=48, AXIS_RX_USER_WIDTH=49).
 *
 * ctrl_reg: this wrapper carries one rb_drp register block PER PORT, the same as
 * ethernet_vcu118.v does for its QSFP cages, at RB_BASE_ADDR 0x1000 + 0x40. It is
 * how software reaches the MAC's DRP-style control bus. corundum_vck190_cfg.tcl
 * must set RB_NEXT_PTR=0x00001000 for the core's chain to point here (it does);
 * with RB_NEXT_PTR=0 the chain terminates in the core and these blocks are
 * unreachable regardless of wiring.
 *
 * The board-management blocks ethernet_vcu118.v also carries (I2C / QSPI /
 * XCVR-GPIO / fpga_boot) are deliberately NOT here: on Versal those peripherals
 * belong to the CIPS in the consumer block design, not to this wrapper.
 */

`timescale 1ns/100ps

module ethernet_vck190 #(
  // Board configuration
  parameter TDMA_BER_ENABLE = 0,

  // Structural configuration
  // QSFP_CNT = number of MRMAC hard IPs / physical cages (1). PORT_COUNT = number
  // of MAC ports (1 for 1x100GE). One mrmac_gty_wrapper shim per PORT.
  parameter QSFP_CNT = 1,
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,
  parameter SCHED_PER_IF = PORTS_PER_IF,
  parameter PORT_MASK = 0,
  parameter PORT_COUNT = IF_COUNT*PORTS_PER_IF,

  // Interface configuration
  parameter PTP_TS_FMT_TOD = 0,
  parameter PTP_TS_WIDTH = PTP_TS_FMT_TOD ? 96 : 48,
  parameter TX_TAG_WIDTH = 16,

  // MRMAC PTP systemtimer / timestamp width (PG314). Used only on the
  // MRMAC-facing PTP ports; the fpga_core side stays at PTP_TS_WIDTH.
  parameter MRMAC_TS_WIDTH = 55,

  // Scheduler configuration
  parameter TDMA_INDEX_WIDTH = 6,

  // Interface configuration
  parameter PTP_TS_ENABLE = 1,

  // AXI lite interface configuration (control)
  parameter AXIL_CTRL_DATA_WIDTH = 32,
  parameter AXIL_CTRL_ADDR_WIDTH = 24,
  parameter AXIL_CTRL_STRB_WIDTH = (AXIL_CTRL_DATA_WIDTH/8),

  // AXI lite interface configuration (application control)
  parameter AXIL_IF_CTRL_ADDR_WIDTH = AXIL_CTRL_ADDR_WIDTH-$clog2(IF_COUNT),
  parameter AXIL_CSR_ADDR_WIDTH = AXIL_IF_CTRL_ADDR_WIDTH-5-$clog2((SCHED_PER_IF+4+7)/8),

  // Ethernet interface configuration
  parameter ETH_RX_CLK_FROM_TX = 0,
  parameter ETH_RS_FEC_ENABLE = 0,
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_TX_USER_WIDTH = TX_TAG_WIDTH + 1,
  parameter AXIS_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1
) (
  /*
  * Clock and reset signals (Corundum core clock domain)
  */
  input  wire                                     clk,
  input  wire                                     rst,

  /*
  * Control registers (register-block bus from corundum_core). This wrapper hosts
  * one rb_drp block per port at RB_BASE_ADDR 0x1000+0x40; see the header. The
  * wait/ack/rd_data outputs are OR-aggregated from those blocks, and each block
  * only responds inside its own address window.
  */
  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]           ctrl_reg_wr_addr,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]          ctrl_reg_wr_data,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0]          ctrl_reg_wr_strb,
  input  wire                                     ctrl_reg_wr_en,
  output wire                                     ctrl_reg_wr_wait,
  output wire                                     ctrl_reg_wr_ack,
  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]           ctrl_reg_rd_addr,
  input  wire                                     ctrl_reg_rd_en,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]          ctrl_reg_rd_data,
  output wire                                     ctrl_reg_rd_wait,
  output wire                                     ctrl_reg_rd_ack,

  /*
  * Ethernet (fpga_core-facing MAC datapath - identical to ethernet_vcu118)
  */
  output wire [PORT_COUNT-1:0]                    eth_tx_clk,
  output wire [PORT_COUNT-1:0]                    eth_tx_rst,

  output wire [PORT_COUNT-1:0]                    eth_tx_ptp_clk,
  output wire [PORT_COUNT-1:0]                    eth_tx_ptp_rst,
  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       eth_tx_ptp_ts,
  input  wire [PORT_COUNT-1:0]                    eth_tx_ptp_ts_step,

  input  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]    axis_eth_tx_tdata,
  input  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]    axis_eth_tx_tkeep,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_tvalid,
  output wire [PORT_COUNT-1:0]                    axis_eth_tx_tready,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_tlast,
  input  wire [PORT_COUNT*AXIS_TX_USER_WIDTH-1:0] axis_eth_tx_tuser,

  output wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       axis_eth_tx_ptp_ts,
  output wire [PORT_COUNT*TX_TAG_WIDTH-1:0]       axis_eth_tx_ptp_ts_tag,
  output wire [PORT_COUNT-1:0]                    axis_eth_tx_ptp_ts_valid,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_ptp_ts_ready,

  input  wire [PORT_COUNT-1:0]                    eth_tx_enable,
  output wire [PORT_COUNT-1:0]                    eth_tx_status,
  input  wire [PORT_COUNT-1:0]                    eth_tx_lfc_en,
  input  wire [PORT_COUNT-1:0]                    eth_tx_lfc_req,
  input  wire [PORT_COUNT*8-1:0]                  eth_tx_pfc_en,
  input  wire [PORT_COUNT*8-1:0]                  eth_tx_pfc_req,

  output wire [PORT_COUNT-1:0]                    eth_rx_clk,
  output wire [PORT_COUNT-1:0]                    eth_rx_rst,

  output wire [PORT_COUNT-1:0]                    eth_rx_ptp_clk,
  output wire [PORT_COUNT-1:0]                    eth_rx_ptp_rst,
  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       eth_rx_ptp_ts,
  input  wire [PORT_COUNT-1:0]                    eth_rx_ptp_ts_step,

  output wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]    axis_eth_rx_tdata,
  output wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]    axis_eth_rx_tkeep,
  output wire [PORT_COUNT-1:0]                    axis_eth_rx_tvalid,
  input  wire [PORT_COUNT-1:0]                    axis_eth_rx_tready,
  output wire [PORT_COUNT-1:0]                    axis_eth_rx_tlast,
  output wire [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0] axis_eth_rx_tuser,

  input  wire [PORT_COUNT-1:0]                    eth_rx_enable,
  output wire [PORT_COUNT-1:0]                    eth_rx_status,
  input  wire [PORT_COUNT-1:0]                    eth_rx_lfc_en,
  output wire [PORT_COUNT-1:0]                    eth_rx_lfc_req,
  input  wire [PORT_COUNT-1:0]                    eth_rx_lfc_ack,
  input  wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_en,
  output wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_req,
  input  wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_ack,

  /*
  * MRMAC-facing side (plain ports - wired to the mrmac_0 hard-IP cell in the
  * VCK190 block design by corundum.tcl via mrmac_versal_glue). One bonded 100G
  * port carried as a 384-bit SEGMENTED word (6x64) with a single handshake.
  */
  // MRMAC user clocks / reset-done gated resets (from the BD clocking)
  input  wire [PORT_COUNT-1:0]                    mrmac_tx_axi_clk,
  input  wire [PORT_COUNT-1:0]                    mrmac_rx_axi_clk,
  input  wire [PORT_COUNT-1:0]                    mrmac_tx_reset_in,
  input  wire [PORT_COUNT-1:0]                    mrmac_rx_reset_in,

  // TX AXIS: shim -> MRMAC (6x64b = 384b data + 6x11b = 66b tkeep_user per port)
  output wire [PORT_COUNT*384-1:0]                mrmac_tx_axis_tdata,
  output wire [PORT_COUNT*66-1:0]                 mrmac_tx_axis_tkeep_user,
  output wire [PORT_COUNT-1:0]                    mrmac_tx_axis_tvalid,
  input  wire [PORT_COUNT-1:0]                    mrmac_tx_axis_tready,
  output wire [PORT_COUNT-1:0]                    mrmac_tx_axis_tlast,

  // RX AXIS: MRMAC -> shim (valid-only)
  input  wire [PORT_COUNT*384-1:0]                mrmac_rx_axis_tdata,
  input  wire [PORT_COUNT*66-1:0]                 mrmac_rx_axis_tkeep_user,
  input  wire [PORT_COUNT-1:0]                    mrmac_rx_axis_tvalid,
  input  wire [PORT_COUNT-1:0]                    mrmac_rx_axis_tlast,

  // MRMAC status / control
  input  wire [PORT_COUNT-1:0]                    mrmac_stat_rx_status,
  output wire [PORT_COUNT-1:0]                    mrmac_ctl_tx_enable,
  output wire [PORT_COUNT-1:0]                    mrmac_ctl_rx_enable,
  output wire [PORT_COUNT-1:0]                    mrmac_rx_fifo_overflow,

  // MRMAC-facing flow control (pause) -> the mrmac_0 BD cell via the glue.
  // Packed [PORT_COUNT*9-1:0]: per port, bit 8 = link pause (lfc), [7:0] = PFC.
  output wire [PORT_COUNT*9-1:0]                  mrmac_ctl_tx_pause_enable,
  output wire [PORT_COUNT*9-1:0]                  mrmac_ctl_tx_pause_req,
  output wire [PORT_COUNT*9-1:0]                  mrmac_ctl_rx_pause_enable,
  output wire [PORT_COUNT*9-1:0]                  mrmac_ctl_rx_pause_ack,
  input  wire [PORT_COUNT*9-1:0]                  mrmac_stat_rx_pause_req,

  /*
  * MRMAC-facing PTP (plain packed ports -> the mrmac_0 BD cell via the glue).
  * All in the MRMAC ts-clk domain (tied to the AXIS clock in the BD). See
  * mrmac_gty_wrapper for the per-port semantics; here they are packed
  * [PORT_COUNT*W-1:0] (port 0 in the low bits), mirroring the AXIS ports.
  */
  // RX: MRMAC captures a per-frame timestamp (valid at RX SOP).
  input  wire [PORT_COUNT*MRMAC_TS_WIDTH-1:0]     mrmac_rx_ptp_tstamp,
  // TX: 2-step timestamp request (op + tag) and the completion return.
  output wire [PORT_COUNT*2-1:0]                  mrmac_tx_ptp_1588op,
  output wire [PORT_COUNT*16-1:0]                 mrmac_tx_ptp_tag_field,
  input  wire [PORT_COUNT*MRMAC_TS_WIDTH-1:0]     mrmac_tx_ptp_tstamp,
  input  wire [PORT_COUNT*16-1:0]                 mrmac_tx_ptp_tstamp_tag,
  input  wire [PORT_COUNT-1:0]                    mrmac_tx_ptp_tstamp_valid,
  // System-timer discipline (drive MRMAC's internal PTP timer to Corundum time).
  output wire [PORT_COUNT*MRMAC_TS_WIDTH-1:0]     mrmac_tx_ptp_systemtimer,
  output wire [PORT_COUNT-1:0]                    mrmac_tx_ptp_st_sync,
  output wire [PORT_COUNT-1:0]                    mrmac_tx_ptp_st_overwrite,
  output wire [PORT_COUNT*MRMAC_TS_WIDTH-1:0]     mrmac_rx_ptp_systemtimer,
  output wire [PORT_COUNT-1:0]                    mrmac_rx_ptp_st_sync,
  output wire [PORT_COUNT-1:0]                    mrmac_rx_ptp_st_overwrite
);

  // MRMAC 1x100G segmented per-port geometry: the FULL packed per-port widths of
  // the shim's mrmac_tx/rx_axis_tdata (6x64b = 384b) and tkeep_user (6x11b = 66b).
  localparam MRMAC_PORT_DATA_W  = 384;
  localparam MRMAC_PORT_KUSER_W = 66;

  genvar n;

  initial begin
    if (AXIS_DATA_WIDTH != 512) begin
      $error("Error: ethernet_vck190 requires AXIS_DATA_WIDTH=512 (1x100GE segmented) (instance %m)");
      $finish;
    end
    if (AXIS_RX_USER_WIDTH > 81) begin
      $error("Error: AXIS_RX_USER_WIDTH exceeds the shim's 81-bit rx_axis_tuser field (instance %m)");
      $finish;
    end
  end

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // ctrl_reg: register blocks living in THIS wrapper (mirrors ethernet_vcu118.v)
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // One rb_drp per port, exactly as ethernet_vcu118.v does for its QSFP cages
  // (ethernet_vcu118.v:598-645). This is the software path to the MAC's DRP-style
  // control bus: the driver walks the register-block chain, finds this block, and
  // reads/writes MAC control and statistics through it.
  //
  // WHY THIS EXISTS AND WHAT REPLACED IT. Earlier this section was a never-ack
  // terminator, on the reasoning that corundum_core ended the chain (RB_NEXT_PTR=0) so
  // nothing could reach here. That was self-consistent but it meant the wrapper had NO
  // register interface at all -- the one piece of ethernet_vcu118.v that
  // ethernet_vck190.v was missing. corundum_vck190_cfg.tcl now sets
  // RB_NEXT_PTR=0x00001000 (the VCU118 value) so the core's chain points at
  // RB_BASE_ADDR below, and this block answers.
  //
  // ACK DISCIPLINE, and it is the trap here: the wrapper's wait/ack/rd_data are OR'd
  // with corundum_core's own upstream, so a block that acks an address it does not own
  // CORRUPTS a core access. rb_drp only acks inside its own RB_BASE_ADDR window, and
  // the aggregation below starts from a registered 0 and ORs the per-port results --
  // the same structure as ethernet_vcu118.v:406-424. Do not simplify it to a constant.
  localparam RB_BASE_ADDR = 16'h1000;

  // Per-port DRP register-block window, 0x20 apart. RB_NEXT_PTR chains block n to
  // block n+1; the LAST port must terminate the chain with 0, or software walks off
  // the end into an address nothing acks and the walk hangs. VCU118 chains
  // unconditionally (it always has 4 QSFP cages and a block after them); at
  // PORT_COUNT=1 the "next" would be a block that does not exist, hence the guard.
  localparam RB_DRP_BASE = RB_BASE_ADDR + 16'h40;

  wire [PORT_COUNT-1:0]                          drp_rb_reg_wr_wait;
  wire [PORT_COUNT-1:0]                          drp_rb_reg_wr_ack;
  wire [PORT_COUNT*AXIL_CTRL_DATA_WIDTH-1:0]     drp_rb_reg_rd_data;
  wire [PORT_COUNT-1:0]                          drp_rb_reg_rd_wait;
  wire [PORT_COUNT-1:0]                          drp_rb_reg_rd_ack;

  // Per-port DRP buses to the MAC shims.
  //
  // NOTE ON drp_clk/drp_rst: these are INPUTS to rb_drp, not outputs -- rb_drp has a
  // genuine CDC handshake inside (rb_flag/drp_flag synchronizers, rb_drp.v:180-212) so
  // the DRP side can run in its own domain. They must therefore be DRIVEN, and here
  // both rb_drp and the shim's responder run on the same core clk, so both sides get
  // clk/rst directly rather than through a per-port wire. Declaring them as undriven
  // wires and passing them to both instances (as an earlier revision of this file did)
  // leaves the DRP state machine unclocked: register reads of the block header still
  // work, so a walk looks healthy, but no access ever reaches the MAC. Caught by a
  // standalone probe of rb_drp, not by elaboration -- it elaborates clean either way.
  wire [PORT_COUNT*24-1:0]     mac_drp_addr;
  wire [PORT_COUNT*16-1:0]     mac_drp_di;
  wire [PORT_COUNT-1:0]        mac_drp_en;
  wire [PORT_COUNT-1:0]        mac_drp_we;
  wire [PORT_COUNT*16-1:0]     mac_drp_do;
  wire [PORT_COUNT-1:0]        mac_drp_rdy;

  reg  ctrl_reg_wr_wait_cmb;
  reg  ctrl_reg_wr_ack_cmb;
  reg  [AXIL_CTRL_DATA_WIDTH-1:0] ctrl_reg_rd_data_cmb;
  reg  ctrl_reg_rd_wait_cmb;
  reg  ctrl_reg_rd_ack_cmb;

  assign ctrl_reg_wr_wait = ctrl_reg_wr_wait_cmb;
  assign ctrl_reg_wr_ack  = ctrl_reg_wr_ack_cmb;
  assign ctrl_reg_rd_data = ctrl_reg_rd_data_cmb;
  assign ctrl_reg_rd_wait = ctrl_reg_rd_wait_cmb;
  assign ctrl_reg_rd_ack  = ctrl_reg_rd_ack_cmb;

  integer k;

  always @* begin
    // Start from all-zero (VCU118 starts from registered defaults it also uses for its
    // board-control registers; this wrapper has none of those, so 0 is the base) and
    // OR in every port's block. Only the block that owns the address will assert.
    ctrl_reg_wr_wait_cmb = 1'b0;
    ctrl_reg_wr_ack_cmb  = 1'b0;
    ctrl_reg_rd_data_cmb = {AXIL_CTRL_DATA_WIDTH{1'b0}};
    ctrl_reg_rd_wait_cmb = 1'b0;
    ctrl_reg_rd_ack_cmb  = 1'b0;

    for (k = 0; k < PORT_COUNT; k = k + 1) begin
      ctrl_reg_wr_wait_cmb = ctrl_reg_wr_wait_cmb | drp_rb_reg_wr_wait[k];
      ctrl_reg_wr_ack_cmb  = ctrl_reg_wr_ack_cmb  | drp_rb_reg_wr_ack[k];
      ctrl_reg_rd_data_cmb = ctrl_reg_rd_data_cmb |
                             drp_rb_reg_rd_data[k*AXIL_CTRL_DATA_WIDTH +: AXIL_CTRL_DATA_WIDTH];
      ctrl_reg_rd_wait_cmb = ctrl_reg_rd_wait_cmb | drp_rb_reg_rd_wait[k];
      ctrl_reg_rd_ack_cmb  = ctrl_reg_rd_ack_cmb  | drp_rb_reg_rd_ack[k];
    end
  end

  generate

    for (n = 0; n < PORT_COUNT; n = n + 1) begin : drp

      // DRP_INFO is the block's self-describing header: {type, version, addr_bits,
      // data_bits} = {0x09, 0x03, 24, 16}, byte-identical to VCU118
      // (ethernet_vcu118.v:605) because the DRP bus geometry is the same 24/16 on both
      // -- mrmac_gty_wrapper takes drp_addr[23:0]/drp_di[15:0] exactly as
      // cmac_gty_wrapper does.
      rb_drp #(
        .DRP_ADDR_WIDTH(24),
        .DRP_DATA_WIDTH(16),
        .DRP_INFO({8'h09, 8'h03, 8'd2, 8'd4}),
        .REG_ADDR_WIDTH(AXIL_CSR_ADDR_WIDTH),
        .REG_DATA_WIDTH(AXIL_CTRL_DATA_WIDTH),
        .REG_STRB_WIDTH(AXIL_CTRL_STRB_WIDTH),
        .RB_BASE_ADDR(RB_DRP_BASE + n*16'h20),
        .RB_NEXT_PTR(n == PORT_COUNT-1 ? 0 : RB_DRP_BASE + (n+1)*16'h20)
      ) mac_rb_drp_inst (
        .clk(clk),
        .rst(rst),

        /*
         * Register interface
         */
        .reg_wr_addr(ctrl_reg_wr_addr),
        .reg_wr_data(ctrl_reg_wr_data),
        .reg_wr_strb(ctrl_reg_wr_strb),
        .reg_wr_en(ctrl_reg_wr_en),
        .reg_wr_wait(drp_rb_reg_wr_wait[n +: 1]),
        .reg_wr_ack(drp_rb_reg_wr_ack[n +: 1]),
        .reg_rd_addr(ctrl_reg_rd_addr),
        .reg_rd_en(ctrl_reg_rd_en),
        .reg_rd_data(drp_rb_reg_rd_data[n*AXIL_CTRL_DATA_WIDTH +: AXIL_CTRL_DATA_WIDTH]),
        .reg_rd_wait(drp_rb_reg_rd_wait[n +: 1]),
        .reg_rd_ack(drp_rb_reg_rd_ack[n +: 1]),

        /*
         * DRP
         */
        .drp_clk(clk),
        .drp_rst(rst),
        .drp_addr(mac_drp_addr[n*24 +: 24]),
        .drp_di(mac_drp_di[n*16 +: 16]),
        .drp_en(mac_drp_en[n +: 1]),
        .drp_we(mac_drp_we[n +: 1]),
        .drp_do(mac_drp_do[n*16 +: 16]),
        .drp_rdy(mac_drp_rdy[n +: 1])
      );

    end

  endgenerate

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // Per-port MAC-shim <-> port-map buses (Corundum MAC-wrapper contract)
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // These carry the same signals cmac_gty_wrapper presents in ethernet_vcu118,
  // packed [PORT_COUNT*W-1:0] (port 0 in the low bits) for mqnic_port_map.

  // TX (port_map -> shim), plus shim TX-PTP completion return
  wire [PORT_COUNT-1:0]                 mac_tx_clk;
  wire [PORT_COUNT-1:0]                 mac_tx_rst;
  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0] mac_tx_axis_tdata;
  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0] mac_tx_axis_tkeep;
  wire [PORT_COUNT-1:0]                 mac_tx_axis_tvalid;
  wire [PORT_COUNT-1:0]                 mac_tx_axis_tready;
  wire [PORT_COUNT-1:0]                 mac_tx_axis_tlast;
  wire [PORT_COUNT*(16+1)-1:0]          mac_tx_axis_tuser;   // shim tx tuser: {tag[15:0], err}

  wire [PORT_COUNT*80-1:0]              mac_tx_ptp_time;     // shim tx_ptp_time (80b) <- real Corundum PHC, zero-extended in `recon
  wire [PORT_COUNT*80-1:0]              mac_tx_ptp_ts;       // shim tx_ptp_ts   (80b) -> back to the core
  wire [PORT_COUNT*16-1:0]              mac_tx_ptp_ts_tag;
  wire [PORT_COUNT-1:0]                 mac_tx_ptp_ts_valid;

  wire [PORT_COUNT-1:0]                 mac_tx_enable;
  wire [PORT_COUNT-1:0]                 mac_tx_lfc_en;
  wire [PORT_COUNT-1:0]                 mac_tx_lfc_req;
  wire [PORT_COUNT*8-1:0]               mac_tx_pfc_en;
  wire [PORT_COUNT*8-1:0]               mac_tx_pfc_req;

  // RX (shim -> port_map)
  wire [PORT_COUNT-1:0]                 mac_rx_clk;
  wire [PORT_COUNT-1:0]                 mac_rx_rst;
  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0] mac_rx_axis_tdata;
  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0] mac_rx_axis_tkeep;
  wire [PORT_COUNT-1:0]                 mac_rx_axis_tvalid;
  wire [PORT_COUNT-1:0]                 mac_rx_axis_tlast;
  wire [PORT_COUNT*(80+1)-1:0]          mac_rx_axis_tuser;   // shim rx tuser: {ptp_ts[79:0], err}

  wire [PORT_COUNT-1:0]                 mac_rx_ptp_clk;
  wire [PORT_COUNT-1:0]                 mac_rx_ptp_rst;
  wire [PORT_COUNT*80-1:0]              mac_rx_ptp_time;     // shim rx_ptp_time (80b) <- real Corundum PHC, zero-extended in `recon

  wire [PORT_COUNT-1:0]                 mac_rx_enable;
  wire [PORT_COUNT-1:0]                 mac_rx_status;
  wire [PORT_COUNT-1:0]                 mac_rx_lfc_en;
  wire [PORT_COUNT-1:0]                 mac_rx_lfc_req;
  wire [PORT_COUNT-1:0]                 mac_rx_lfc_ack;
  wire [PORT_COUNT*8-1:0]               mac_rx_pfc_en;
  wire [PORT_COUNT*8-1:0]               mac_rx_pfc_req;
  wire [PORT_COUNT*8-1:0]               mac_rx_pfc_ack;

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // MAC shim: one mrmac_gty_wrapper (MODE="1x100G") for the single bonded port
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  generate

    for (n = 0; n < PORT_COUNT; n = n + 1) begin : mac

      mrmac_gty_wrapper #(
        .MODE("1x100G"),
        .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH)
      ) mrmac_gty_wrapper_inst (
        /*
        * MRMAC user clocks / resets (from BD)
        */
        .tx_axi_clk(mrmac_tx_axi_clk[n +: 1]),
        .rx_axi_clk(mrmac_rx_axi_clk[n +: 1]),
        .tx_reset_in(mrmac_tx_reset_in[n +: 1]),
        .rx_reset_in(mrmac_rx_reset_in[n +: 1]),

        /*
        * fpga_core-facing side -> port-map MAC side
        */
        .tx_clk(mac_tx_clk[n +: 1]),
        .tx_rst(mac_tx_rst[n +: 1]),

        .tx_axis_tdata(mac_tx_axis_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
        .tx_axis_tkeep(mac_tx_axis_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
        .tx_axis_tvalid(mac_tx_axis_tvalid[n +: 1]),
        .tx_axis_tready(mac_tx_axis_tready[n +: 1]),
        .tx_axis_tlast(mac_tx_axis_tlast[n +: 1]),
        .tx_axis_tuser(mac_tx_axis_tuser[n*(16+1) +: (16+1)]),

        .tx_ptp_time(mac_tx_ptp_time[n*80 +: 80]),
        .tx_ptp_ts(mac_tx_ptp_ts[n*80 +: 80]),
        .tx_ptp_ts_tag(mac_tx_ptp_ts_tag[n*16 +: 16]),
        .tx_ptp_ts_valid(mac_tx_ptp_ts_valid[n +: 1]),

        .tx_enable(mac_tx_enable[n +: 1]),
        .tx_lfc_en(mac_tx_lfc_en[n +: 1]),
        .tx_lfc_req(mac_tx_lfc_req[n +: 1]),
        .tx_pfc_en(mac_tx_pfc_en[n*8 +: 8]),
        .tx_pfc_req(mac_tx_pfc_req[n*8 +: 8]),

        .rx_clk(mac_rx_clk[n +: 1]),
        .rx_rst(mac_rx_rst[n +: 1]),

        .rx_axis_tdata(mac_rx_axis_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
        .rx_axis_tkeep(mac_rx_axis_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
        .rx_axis_tvalid(mac_rx_axis_tvalid[n +: 1]),
        .rx_axis_tlast(mac_rx_axis_tlast[n +: 1]),
        .rx_axis_tuser(mac_rx_axis_tuser[n*(80+1) +: (80+1)]),

        .rx_ptp_clk(mac_rx_ptp_clk[n +: 1]),
        .rx_ptp_rst(mac_rx_ptp_rst[n +: 1]),
        .rx_ptp_time(mac_rx_ptp_time[n*80 +: 80]),

        .rx_enable(mac_rx_enable[n +: 1]),
        .rx_status(mac_rx_status[n +: 1]),
        .rx_lfc_en(mac_rx_lfc_en[n +: 1]),
        .rx_lfc_req(mac_rx_lfc_req[n +: 1]),
        .rx_lfc_ack(mac_rx_lfc_ack[n +: 1]),
        .rx_pfc_en(mac_rx_pfc_en[n*8 +: 8]),
        .rx_pfc_req(mac_rx_pfc_req[n*8 +: 8]),
        .rx_pfc_ack(mac_rx_pfc_ack[n*8 +: 8]),

        /*
        * DRP-style control bus, driven by this port's rb_drp register block above.
         * mrmac_gty_wrapper's responder currently acks in one cycle and reads back 0
         * (mrmac_gty_wrapper.v:816-829) -- enough that a register walk completes
         * instead of hanging, but the MAC control/stats behind it are not yet decoded.
         * That decode is the remaining work on this path; the plumbing is now real.
        */
        .drp_clk(clk),
        .drp_rst(rst),
        .drp_addr(mac_drp_addr[n*24 +: 24]),
        .drp_di(mac_drp_di[n*16 +: 16]),
        .drp_en(mac_drp_en[n +: 1]),
        .drp_we(mac_drp_we[n +: 1]),
        .drp_do(mac_drp_do[n*16 +: 16]),
        .drp_rdy(mac_drp_rdy[n +: 1]),

        /*
        * MRMAC-facing side (to the mrmac_0 BD cell)
        */
        .mrmac_tx_axis_tdata(mrmac_tx_axis_tdata[n*MRMAC_PORT_DATA_W +: MRMAC_PORT_DATA_W]),
        .mrmac_tx_axis_tkeep_user(mrmac_tx_axis_tkeep_user[n*MRMAC_PORT_KUSER_W +: MRMAC_PORT_KUSER_W]),
        .mrmac_tx_axis_tvalid(mrmac_tx_axis_tvalid[n +: 1]),
        .mrmac_tx_axis_tready(mrmac_tx_axis_tready[n +: 1]),
        .mrmac_tx_axis_tlast(mrmac_tx_axis_tlast[n +: 1]),

        .mrmac_rx_axis_tdata(mrmac_rx_axis_tdata[n*MRMAC_PORT_DATA_W +: MRMAC_PORT_DATA_W]),
        .mrmac_rx_axis_tkeep_user(mrmac_rx_axis_tkeep_user[n*MRMAC_PORT_KUSER_W +: MRMAC_PORT_KUSER_W]),
        .mrmac_rx_axis_tvalid(mrmac_rx_axis_tvalid[n +: 1]),
        .mrmac_rx_axis_tlast(mrmac_rx_axis_tlast[n +: 1]),

        .mrmac_stat_rx_status(mrmac_stat_rx_status[n +: 1]),
        .ctl_tx_enable(mrmac_ctl_tx_enable[n +: 1]),
        .ctl_rx_enable(mrmac_ctl_rx_enable[n +: 1]),

        /*
        * MRMAC-facing flow control (pause, 9-bit {lfc, pfc} per port)
        */
        .mrmac_ctl_tx_pause_enable(mrmac_ctl_tx_pause_enable[n*9 +: 9]),
        .mrmac_ctl_tx_pause_req(mrmac_ctl_tx_pause_req[n*9 +: 9]),
        .mrmac_ctl_rx_pause_enable(mrmac_ctl_rx_pause_enable[n*9 +: 9]),
        .mrmac_ctl_rx_pause_ack(mrmac_ctl_rx_pause_ack[n*9 +: 9]),
        .mrmac_stat_rx_pause_req(mrmac_stat_rx_pause_req[n*9 +: 9]),

        /*
        * MRMAC-facing PTP (to the mrmac_0 BD cell via the glue)
        */
        .mrmac_rx_ptp_tstamp(mrmac_rx_ptp_tstamp[n*MRMAC_TS_WIDTH +: MRMAC_TS_WIDTH]),
        .mrmac_tx_ptp_1588op(mrmac_tx_ptp_1588op[n*2 +: 2]),
        .mrmac_tx_ptp_tag_field(mrmac_tx_ptp_tag_field[n*16 +: 16]),
        .mrmac_tx_ptp_tstamp(mrmac_tx_ptp_tstamp[n*MRMAC_TS_WIDTH +: MRMAC_TS_WIDTH]),
        .mrmac_tx_ptp_tstamp_tag(mrmac_tx_ptp_tstamp_tag[n*16 +: 16]),
        .mrmac_tx_ptp_tstamp_valid(mrmac_tx_ptp_tstamp_valid[n +: 1]),
        .mrmac_tx_ptp_systemtimer(mrmac_tx_ptp_systemtimer[n*MRMAC_TS_WIDTH +: MRMAC_TS_WIDTH]),
        .mrmac_tx_ptp_st_sync(mrmac_tx_ptp_st_sync[n +: 1]),
        .mrmac_tx_ptp_st_overwrite(mrmac_tx_ptp_st_overwrite[n +: 1]),
        .mrmac_rx_ptp_systemtimer(mrmac_rx_ptp_systemtimer[n*MRMAC_TS_WIDTH +: MRMAC_TS_WIDTH]),
        .mrmac_rx_ptp_st_sync(mrmac_rx_ptp_st_sync[n +: 1]),
        .mrmac_rx_ptp_st_overwrite(mrmac_rx_ptp_st_overwrite[n +: 1]),

        .rx_fifo_overflow(mrmac_rx_fifo_overflow[n +: 1]));

    end

  endgenerate

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // PTP / RX-user reconciliation
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // These carry the REAL Corundum PTP time. The chain is:
  //   corundum_core's ptp_clock (the PHC software steers)
  //     -> core tx_ptp_ts_96 / rx_ptp_ts_96
  //     -> mqnic_port_map_mac_axis mac_tx_ptp_ts_96 / mac_rx_ptp_ts_96   (below)
  //     -> mac_tx_ptp_time_int / mac_rx_ptp_time_int                     (here)
  //     -> shim tx_ptp_time / rx_ptp_time
  //     -> mrmac_ptp_ts_cvt (80b Corundum -> 55b MRMAC) -> mrmac_ptp_sync -> MRMAC
  // Nothing here is a placeholder; the earlier "(deferred)" notes were stale.
  //
  // ZERO-EXTENSION IS REQUIRED, AND THIS IS WHERE VCU118 MUST NOT BE COPIED BLINDLY.
  // The shim's PTP ports are a fixed 80 bits (CMAC-faithful) while the port map uses
  // PTP_TS_WIDTH, which is 48 in this config (PTP_TS_FMT_TOD=0 -> the "rel" format:
  // ns in [47:16], fns16 in [15:0]; see ptp_clock.v:176-177). ethernet_vcu118.v:657
  // assigns only the low PTP_TS_WIDTH bits of its 80-bit vector and leaves [79:48]
  // UNDRIVEN. On VCU118 that is harmless: CMAC's ctl_tx_systemtimerin simply ignores
  // the high bits.
  //
  // On MRMAC it is NOT harmless. mrmac_ptp_ts_cvt right-shifts the 80-bit value by 8
  // and keeps bits [54:0] (mrmac_ptp_ts_cvt.v:85-86), so undriven [79:48] propagate
  // into the systemtimer's high nanoseconds -- and that value is LOADED into MRMAC's
  // PTP timer through the st_sync handshake rather than being ignored. In simulation
  // that is X in the timer; in hardware it is whatever those nets float to. Either way
  // the timestamps MRMAC returns are garbage in the upper ns field while looking
  // plausible in the low bits.
  //
  // So zero-extend explicitly. The high bits are genuinely zero in meaning: the rel
  // format's ns field is only PTP_TS_WIDTH-16 bits wide and wraps there, exactly as
  // mrmac_ptp_ts_cvt's header describes.
  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]     mac_tx_ptp_time_int;   // port_map -> shim
  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]     mac_tx_ptp_ts_int;     // shim -> port_map
  wire [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0] mac_rx_axis_tuser_int; // shim -> port_map
  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]     mac_rx_ptp_time_int;   // port_map -> shim

  // Guard the slice direction: everything below assumes the Corundum field is no
  // WIDER than the shim's 80-bit port. PTP_TS_FMT_TOD=1 would make it 96 and silently
  // truncate the ToD seconds field, which would be a much subtler failure.
  initial begin
    if (PTP_TS_WIDTH > 80) begin
      $error("Error: PTP_TS_WIDTH=%0d exceeds the shim's 80-bit PTP field; PTP_TS_FMT_TOD=1 (96-bit ToD) is not supported by this wrapper (instance %m)", PTP_TS_WIDTH);
      $finish;
    end
  end

  generate

  for (n = 0; n < PORT_COUNT; n = n + 1) begin : recon
    // Zero-extend Corundum -> shim (the fix described above).
    assign mac_tx_ptp_time[n*80 +: 80] =
        {{(80-PTP_TS_WIDTH){1'b0}}, mac_tx_ptp_time_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]};
    assign mac_rx_ptp_time[n*80 +: 80] =
        {{(80-PTP_TS_WIDTH){1'b0}}, mac_rx_ptp_time_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]};

    // Shim -> Corundum: plain low-bit slice. Correct in this direction because the
    // shim's own converter already produced a value in Corundum's rel format with
    // zeros above it (mrmac_ptp_ts_cvt g_widen), so the discarded bits are zero.
    assign mac_tx_ptp_ts_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]       = mac_tx_ptp_ts[n*80 +: PTP_TS_WIDTH];

    assign mac_rx_axis_tuser_int[n*AXIS_RX_USER_WIDTH +: AXIS_RX_USER_WIDTH] = mac_rx_axis_tuser[n*81 +: AXIS_RX_USER_WIDTH];
  end

  endgenerate

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // Port map: four MACs <-> IF_COUNT x PORTS_PER_IF core ports
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  mqnic_port_map_mac_axis #(
    .MAC_COUNT(PORT_COUNT),
    .PORT_MASK(PORT_MASK),
    .PORT_GROUP_SIZE(1),

    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),

    .PORT_COUNT(PORT_COUNT),

    .PTP_TS_WIDTH(PTP_TS_WIDTH),
    .PTP_TAG_WIDTH(TX_TAG_WIDTH),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_TX_USER_WIDTH(AXIS_TX_USER_WIDTH),
    .AXIS_RX_USER_WIDTH(AXIS_RX_USER_WIDTH)
  ) mqnic_port_map_mac_axis_inst (
    // towards MAC (the four shims)
    .mac_tx_clk(mac_tx_clk),
    .mac_tx_rst(mac_tx_rst),

    .mac_tx_ptp_clk({PORT_COUNT{1'b0}}),
    .mac_tx_ptp_rst({PORT_COUNT{1'b0}}),
    .mac_tx_ptp_ts_96(mac_tx_ptp_time_int),
    .mac_tx_ptp_ts_step(),

    .m_axis_mac_tx_tdata(mac_tx_axis_tdata),
    .m_axis_mac_tx_tkeep(mac_tx_axis_tkeep),
    .m_axis_mac_tx_tvalid(mac_tx_axis_tvalid),
    .m_axis_mac_tx_tready(mac_tx_axis_tready),
    .m_axis_mac_tx_tlast(mac_tx_axis_tlast),
    .m_axis_mac_tx_tuser(mac_tx_axis_tuser),

    .s_axis_mac_tx_ptp_ts(mac_tx_ptp_ts_int),
    .s_axis_mac_tx_ptp_ts_tag(mac_tx_ptp_ts_tag),
    .s_axis_mac_tx_ptp_ts_valid(mac_tx_ptp_ts_valid),
    .s_axis_mac_tx_ptp_ts_ready(),

    .mac_tx_enable(mac_tx_enable),
    .mac_tx_status({PORT_COUNT{1'b1}}),
    .mac_tx_lfc_en(mac_tx_lfc_en),
    .mac_tx_lfc_req(mac_tx_lfc_req),
    .mac_tx_pfc_en(mac_tx_pfc_en),
    .mac_tx_pfc_req(mac_tx_pfc_req),

    .mac_rx_clk(mac_rx_clk),
    .mac_rx_rst(mac_rx_rst),

    .mac_rx_ptp_clk(mac_rx_ptp_clk),
    .mac_rx_ptp_rst(mac_rx_ptp_rst),
    .mac_rx_ptp_ts_96(mac_rx_ptp_time_int),
    .mac_rx_ptp_ts_step(),

    .s_axis_mac_rx_tdata(mac_rx_axis_tdata),
    .s_axis_mac_rx_tkeep(mac_rx_axis_tkeep),
    .s_axis_mac_rx_tvalid(mac_rx_axis_tvalid),
    .s_axis_mac_rx_tready(),
    .s_axis_mac_rx_tlast(mac_rx_axis_tlast),
    .s_axis_mac_rx_tuser(mac_rx_axis_tuser_int),

    .mac_rx_enable(mac_rx_enable),
    .mac_rx_status(mac_rx_status),
    .mac_rx_lfc_en(mac_rx_lfc_en),
    .mac_rx_lfc_req(mac_rx_lfc_req),
    .mac_rx_lfc_ack(mac_rx_lfc_ack),
    .mac_rx_pfc_en(mac_rx_pfc_en),
    .mac_rx_pfc_req(mac_rx_pfc_req),
    .mac_rx_pfc_ack(mac_rx_pfc_ack),

    // towards datapath (fpga_core-facing - the ethernet_vck190 ports)
    .tx_clk(eth_tx_clk),
    .tx_rst(eth_tx_rst),

    .tx_ptp_clk(eth_tx_ptp_clk),
    .tx_ptp_rst(eth_tx_ptp_rst),
    .tx_ptp_ts_96(eth_tx_ptp_ts),
    .tx_ptp_ts_step(eth_tx_ptp_ts_step),

    .s_axis_tx_tdata(axis_eth_tx_tdata),
    .s_axis_tx_tkeep(axis_eth_tx_tkeep),
    .s_axis_tx_tvalid(axis_eth_tx_tvalid),
    .s_axis_tx_tready(axis_eth_tx_tready),
    .s_axis_tx_tlast(axis_eth_tx_tlast),
    .s_axis_tx_tuser(axis_eth_tx_tuser),

    .m_axis_tx_ptp_ts(axis_eth_tx_ptp_ts),
    .m_axis_tx_ptp_ts_tag(axis_eth_tx_ptp_ts_tag),
    .m_axis_tx_ptp_ts_valid(axis_eth_tx_ptp_ts_valid),
    .m_axis_tx_ptp_ts_ready(axis_eth_tx_ptp_ts_ready),

    .tx_enable(eth_tx_enable),
    .tx_status(eth_tx_status),
    .tx_lfc_en(eth_tx_lfc_en),
    .tx_lfc_req(eth_tx_lfc_req),
    .tx_pfc_en(eth_tx_pfc_en),
    .tx_pfc_req(eth_tx_pfc_req),

    .rx_clk(eth_rx_clk),
    .rx_rst(eth_rx_rst),

    .rx_ptp_clk(eth_rx_ptp_clk),
    .rx_ptp_rst(eth_rx_ptp_rst),
    .rx_ptp_ts_96(eth_rx_ptp_ts),
    .rx_ptp_ts_step(eth_rx_ptp_ts_step),

    .m_axis_rx_tdata(axis_eth_rx_tdata),
    .m_axis_rx_tkeep(axis_eth_rx_tkeep),
    .m_axis_rx_tvalid(axis_eth_rx_tvalid),
    .m_axis_rx_tready(axis_eth_rx_tready),
    .m_axis_rx_tlast(axis_eth_rx_tlast),
    .m_axis_rx_tuser(axis_eth_rx_tuser),

    .rx_enable(eth_rx_enable),
    .rx_status(eth_rx_status),
    .rx_lfc_en(eth_rx_lfc_en),
    .rx_lfc_req(eth_rx_lfc_req),
    .rx_lfc_ack(eth_rx_lfc_ack),
    .rx_pfc_en(eth_rx_pfc_en),
    .rx_pfc_req(eth_rx_pfc_req),
    .rx_pfc_ack(eth_rx_pfc_ack));

endmodule
