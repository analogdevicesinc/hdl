// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
//
// SPDX short identifier: ADIBSD
//
// ***************************************************************************
// ***************************************************************************
//
// Corundum-on-Versal top level for the VCK190 (xcvc1902), MRMAC 1x100GE over GTY.
// GTY sibling of the VPK180 (GTM) top level: identical structure, only the host
// memory differs (VCK190 = DDR4 via the vmk180 carrier, VPK180 = LPDDR4). The
// entire NIC datapath (mqnic_core_axi + MRMAC/GTY companion network) lives inside
// the block design's corundum_hierarchy; this top only carries the physical I/O:
// the CIPS-managed DDR4 and system clock, board GPIO (LEDs/switches/buttons), the
// GT reference clock, and the QSFP GT serial lanes.

`timescale 1ns/100ps

module system_top (

  // System Clock
  input           sys_clk_n,
  input           sys_clk_p,

  // DDR4 (directly connected to NoC, from the board file via CIPS automation)
  output          ddr4_act_n,
  output  [16:0]  ddr4_adr,
  output  [ 1:0]  ddr4_ba,
  output  [ 1:0]  ddr4_bg,
  output          ddr4_ck_c,
  output          ddr4_ck_t,
  output          ddr4_cke,
  output          ddr4_cs_n,
  inout   [ 7:0]  ddr4_dm_n,
  inout   [63:0]  ddr4_dq,
  inout   [ 7:0]  ddr4_dqs_c,
  inout   [ 7:0]  ddr4_dqs_t,
  output          ddr4_odt,
  output          ddr4_reset_n,

  // GPIOs
  output  [ 3:0]  gpio_led,
  input   [ 3:0]  gpio_dip_sw,
  input   [ 1:0]  gpio_pb,

  // QSFP GT Reference Clock (156.25 MHz)
  input           gt_ref_clk_p,
  input           gt_ref_clk_n,

  // QSFP GT Lanes (4 lanes, from the qsfp_serial gt_rtl interface)
  output  [ 3:0]  qsfp_serial_gtx_p,
  output  [ 3:0]  qsfp_serial_gtx_n,
  input   [ 3:0]  qsfp_serial_grx_p,
  input   [ 3:0]  qsfp_serial_grx_n
);

  // Internal signals
  wire    [95:0]  gpio_i;
  wire    [95:0]  gpio_o;
  wire    [95:0]  gpio_t;

  // GPIO directly from board - expose switches/buttons to fabric, drive LEDs.
  assign gpio_i[3:0]  = gpio_dip_sw;
  assign gpio_i[5:4]  = gpio_pb;
  assign gpio_i[95:6] = gpio_o[95:6];

  assign gpio_led = gpio_o[3:0];

  // Block design instance
  system_wrapper i_system_wrapper (
    // System clock (DDR4 DIMM SMA clock, from the vmk180/vck190 carrier)
    .ddr4_dimm1_sma_clk_clk_n (sys_clk_n),
    .ddr4_dimm1_sma_clk_clk_p (sys_clk_p),

    // DDR4
    .ddr4_dimm1_act_n (ddr4_act_n),
    .ddr4_dimm1_adr (ddr4_adr),
    .ddr4_dimm1_ba (ddr4_ba),
    .ddr4_dimm1_bg (ddr4_bg),
    .ddr4_dimm1_ck_c (ddr4_ck_c),
    .ddr4_dimm1_ck_t (ddr4_ck_t),
    .ddr4_dimm1_cke (ddr4_cke),
    .ddr4_dimm1_cs_n (ddr4_cs_n),
    .ddr4_dimm1_dm_n (ddr4_dm_n),
    .ddr4_dimm1_dq (ddr4_dq),
    .ddr4_dimm1_dqs_c (ddr4_dqs_c),
    .ddr4_dimm1_dqs_t (ddr4_dqs_t),
    .ddr4_dimm1_odt (ddr4_odt),
    .ddr4_dimm1_reset_n (ddr4_reset_n),

    // GPIO
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio2_i (gpio_i[95:64]),
    .gpio2_o (gpio_o[95:64]),
    .gpio2_t (gpio_t[95:64]),

    // SPI (directly exposed from CIPS, unused here)
    .spi0_csn (),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),

    // QSFP GT Reference Clock
    .gt_ref_clk_p (gt_ref_clk_p),
    .gt_ref_clk_n (gt_ref_clk_n),

    // QSFP GT Lanes (qsfp_serial gt_rtl interface)
    .qsfp_serial_gtx_p (qsfp_serial_gtx_p),
    .qsfp_serial_gtx_n (qsfp_serial_gtx_n),
    .qsfp_serial_grx_p (qsfp_serial_grx_p),
    .qsfp_serial_grx_n (qsfp_serial_grx_n)
  );

endmodule
