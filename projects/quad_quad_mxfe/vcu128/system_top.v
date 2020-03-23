// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps


module system_top  (

  input         sys_rst,
  input         sys_clk_p,
  input         sys_clk_n,

  input         uart_sin,
  output        uart_sout,

  output        ddr4_act_n,
  output [16:0] ddr4_addr,
  output [ 1:0] ddr4_ba,
  output [ 0:0] ddr4_bg,
  output        ddr4_ck_p,
  output        ddr4_ck_n,
  output [ 0:0] ddr4_cke,
  output [ 1:0] ddr4_cs_n,
  inout  [ 8:0] ddr4_dm_n,
  inout  [71:0] ddr4_dq,
  inout  [ 8:0] ddr4_dqs_p,
  inout  [ 8:0] ddr4_dqs_n,
  output [ 0:0] ddr4_odt,
  output        ddr4_reset_n,

  output        mdio_mdc,
  inout         mdio_mdio,
  input         phy_clk_p,
  input         phy_clk_n,
  input         phy_rx_p,
  input         phy_rx_n,
  output        phy_tx_p,
  output        phy_tx_n,
  input         phy_dummy_port_in,

  inout   [7:0] gpio_bd,

  inout         iic_scl,
  inout         iic_sda,

  // FMC HPC IOs
  input         device_clk_n,
  input         device_clk_p,
  input         sysref_n,
  input         sysref_p,

  output [15:0] c2m_0_n,
  output [15:0] c2m_0_p,
  input  [15:0] m2c_0_n,
  input  [15:0] m2c_0_p,
  output  [3:0] qmxfe_0_sync_inb_n,
  output  [3:0] qmxfe_0_sync_inb_p,
  input   [3:0] qmxfe_0_sync_outb_n,
  input   [3:0] qmxfe_0_sync_outb_p,
  input   [3:0] qmxfe_0_ref_clk_n,
  input   [3:0] qmxfe_0_ref_clk_p,

  output [15:0] c2m_1_n,
  output [15:0] c2m_1_p,
  input  [15:0] m2c_1_n,
  input  [15:0] m2c_1_p,
  output  [3:0] qmxfe_1_sync_inb_n,
  output  [3:0] qmxfe_1_sync_inb_p,
  input   [3:0] qmxfe_1_sync_outb_n,
  input   [3:0] qmxfe_1_sync_outb_p,
  input   [3:0] qmxfe_1_ref_clk_n,
  input   [3:0] qmxfe_1_ref_clk_p,

  output [15:0] c2m_2_n,
  output [15:0] c2m_2_p,
  input  [15:0] m2c_2_n,
  input  [15:0] m2c_2_p,
  output  [3:0] qmxfe_2_sync_inb_n,
  output  [3:0] qmxfe_2_sync_inb_p,
  input   [3:0] qmxfe_2_sync_outb_n,
  input   [3:0] qmxfe_2_sync_outb_p,
  input   [3:0] qmxfe_2_ref_clk_n,
  input   [3:0] qmxfe_2_ref_clk_p,

  output [15:0] c2m_3_n,
  output [15:0] c2m_3_p,
  input  [15:0] m2c_3_n,
  input  [15:0] m2c_3_p,
  output  [3:0] qmxfe_3_sync_inb_n,
  output  [3:0] qmxfe_3_sync_inb_p,
  input   [3:0] qmxfe_3_sync_outb_n,
  input   [3:0] qmxfe_3_sync_outb_p,
  input   [3:0] qmxfe_3_ref_clk_n,
  input   [3:0] qmxfe_3_ref_clk_p


);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 7:0]  spi_csn;
  wire            spi_mosi;
  wire            spi_miso;


  // quad mxfe signals
  wire            device_clk_ds;
  wire            device_clk;
  wire            sysref_io;

  wire    [3:0]   tx_syncin_0;
  wire    [3:0]   rx_syncout_0;
  wire    [3:0]   ref_clk_0;

  wire    [3:0]   tx_syncin_1;
  wire    [3:0]   rx_syncout_1;
  wire    [3:0]   ref_clk_1;

  wire    [3:0]   tx_syncin_2;
  wire    [3:0]   rx_syncout_2;
  wire    [3:0]   ref_clk_2;

  wire    [3:0]   tx_syncin_3;
  wire    [3:0]   rx_syncout_3;
  wire    [3:0]   ref_clk_3;

  // instantiations
  genvar i;
  generate
  // QMXFE 0
  for(i=0;i<=3;i=i+1) begin : qmxfe_0_buffers

    IBUFDS_GTE4 i_ibufds_ref_clk (
      .CEB (1'd0),
      .I (qmxfe_0_ref_clk_p[i]),
      .IB (qmxfe_0_ref_clk_n[i]),
      .O (ref_clk_0[i]),
      .ODIV2 ());

    IBUFDS i_ibufds_syncin (
      .I (qmxfe_0_sync_outb_p[i]),
      .IB (qmxfe_0_sync_outb_n[i]),
      .O (tx_syncin_0[i]));

    OBUFDS i_obufds_syncout (
      .I (rx_syncout_0[i]),
      .O (qmxfe_0_sync_inb_p[i]),
      .OB (qmxfe_0_sync_inb_n[i]));

  end
  // QMXFE 1
  for(i=0;i<=3;i=i+1) begin : qmxfe_1_buffers

    IBUFDS_GTE4 i_ibufds_ref_clk (
      .CEB (1'd0),
      .I (qmxfe_1_ref_clk_p[i]),
      .IB (qmxfe_1_ref_clk_n[i]),
      .O (ref_clk_1[i]),
      .ODIV2 ());

    IBUFDS i_ibufds_syncin (
      .I (qmxfe_1_sync_outb_p[i]),
      .IB (qmxfe_1_sync_outb_n[i]),
      .O (tx_syncin_1[i]));

    OBUFDS i_obufds_syncout (
      .I (rx_syncout_1[i]),
      .O (qmxfe_1_sync_inb_p[i]),
      .OB (qmxfe_1_sync_inb_n[i]));

  end
  // QMXFE 2
  for(i=0;i<=3;i=i+1) begin : qmxfe_2_buffers

    IBUFDS_GTE4 i_ibufds_ref_clk (
      .CEB (1'd0),
      .I (qmxfe_2_ref_clk_p[i]),
      .IB (qmxfe_2_ref_clk_n[i]),
      .O (ref_clk_2[i]),
      .ODIV2 ());

    IBUFDS i_ibufds_syncin (
      .I (qmxfe_2_sync_outb_p[i]),
      .IB (qmxfe_2_sync_outb_n[i]),
      .O (tx_syncin_2[i]));

    OBUFDS i_obufds_syncout (
      .I (rx_syncout_2[i]),
      .O (qmxfe_2_sync_inb_p[i]),
      .OB (qmxfe_2_sync_inb_n[i]));

  end
  // QMXFE 3
  for(i=0;i<=3;i=i+1) begin : qmxfe_3_buffers

    IBUFDS_GTE4 i_ibufds_ref_clk (
      .CEB (1'd0),
      .I (qmxfe_3_ref_clk_p[i]),
      .IB (qmxfe_3_ref_clk_n[i]),
      .O (ref_clk_3[i]),
      .ODIV2 ());

    IBUFDS i_ibufds_syncin (
      .I (qmxfe_3_sync_outb_p[i]),
      .IB (qmxfe_3_sync_outb_n[i]),
      .O (tx_syncin_3[i]));

    OBUFDS i_obufds_syncout (
      .I (rx_syncout_3[i]),
      .O (qmxfe_3_sync_inb_p[i]),
      .OB (qmxfe_3_sync_inb_n[i]));

  end
  endgenerate

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref_io));

  IBUFDS i_ibufds_device_clk (
    .I (device_clk_p),
    .IB (device_clk_n),
    .O (device_clk_ds));

  BUFG i_device_clk (
    .I (device_clk_ds),
    .O (device_clk)
  );

  // Capture SYSREF one time with the device clock and distribute it to all
  // JESD link layer components.
  // This path is timed with input delay constraint as a source synchronous
  // interface, while distribution paths are timed with device clock.
  // This path should not be metastable, the link layer adds enough delays so the signal
  // can be distributed to all SLRs and meet timing.
  reg sysref = 1'b0;
  always @(posedge device_clk) begin
    sysref <= sysref_io;
  end

  // spi

  assign spi_miso = 1'b0;


  // gpios

  ad_iobuf #(.DATA_WIDTH(8)) i_iobuf_bd (
    .dio_t (gpio_t[7:0]),
    .dio_i (gpio_o[7:0]),
    .dio_o (gpio_i[7:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:8] = gpio_o[63:8];

  system_wrapper i_system_wrapper (
    .sys_rst (sys_rst),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .ddr4_act_n (ddr4_act_n),
    .ddr4_adr (ddr4_addr),
    .ddr4_ba (ddr4_ba),
    .ddr4_bg (ddr4_bg),
    .ddr4_ck_c (ddr4_ck_n),
    .ddr4_ck_t (ddr4_ck_p),
    .ddr4_cke (ddr4_cke),
    .ddr4_cs_n (ddr4_cs_n),
    .ddr4_dm_n (ddr4_dm_n),
    .ddr4_dq (ddr4_dq),
    .ddr4_dqs_c (ddr4_dqs_n),
    .ddr4_dqs_t (ddr4_dqs_p),
    .ddr4_odt (ddr4_odt),
    .ddr4_reset_n (ddr4_reset_n),
    .phy_sd (1'b1),
    .phy_dummy_port_in (phy_dummy_port_in),
    .sgmii_rxn (phy_rx_n),
    .sgmii_rxp (phy_rx_p),
    .sgmii_txn (phy_tx_n),
    .sgmii_txp (phy_tx_p),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .sgmii_phyclk_clk_n (phy_clk_n),
    .sgmii_phyclk_clk_p (phy_clk_p),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    // DUMMY FMC ports

    // QUAD 1 signals

    // rx quad 1
    .rx_data_0_n  (m2c_0_n[0]),
    .rx_data_0_p  (m2c_0_p[0]),
    .rx_data_1_n  (m2c_0_n[1]),
    .rx_data_1_p  (m2c_0_p[1]),
    .rx_data_2_n  (m2c_0_n[2]),
    .rx_data_2_p  (m2c_0_p[2]),
    .rx_data_3_n  (m2c_0_n[3]),
    .rx_data_3_p  (m2c_0_p[3]),
    // rx quad 2
    .rx_data_4_n  (m2c_0_n[4]),
    .rx_data_4_p  (m2c_0_p[4]),
    .rx_data_5_n  (m2c_0_n[5]),
    .rx_data_5_p  (m2c_0_p[5]),
    .rx_data_6_n  (m2c_0_n[6]),
    .rx_data_6_p  (m2c_0_p[6]),
    .rx_data_7_n  (m2c_0_n[7]),
    .rx_data_7_p  (m2c_0_p[7]),
    // rx quad 3
    .rx_data_8_n  (m2c_0_n[8]),
    .rx_data_8_p  (m2c_0_p[8]),
    .rx_data_9_n  (m2c_0_n[9]),
    .rx_data_9_p  (m2c_0_p[9]),
    .rx_data_10_n (m2c_0_n[10]),
    .rx_data_10_p (m2c_0_p[10]),
    .rx_data_11_n (m2c_0_n[11]),
    .rx_data_11_p (m2c_0_p[11]),
    // rx quad 4
    .rx_data_12_n (m2c_0_n[12]),
    .rx_data_12_p (m2c_0_p[12]),
    .rx_data_13_n (m2c_0_n[13]),
    .rx_data_13_p (m2c_0_p[13]),
    .rx_data_14_n (m2c_0_n[14]),
    .rx_data_14_p (m2c_0_p[14]),
    .rx_data_15_n (m2c_0_n[15]),
    .rx_data_15_p (m2c_0_p[15]),
    // tx quad 1
    .tx_data_0_n  (c2m_0_n[0]),
    .tx_data_0_p  (c2m_0_p[0]),
    .tx_data_1_n  (c2m_0_n[1]),
    .tx_data_1_p  (c2m_0_p[1]),
    .tx_data_2_n  (c2m_0_n[2]),
    .tx_data_2_p  (c2m_0_p[2]),
    .tx_data_3_n  (c2m_0_n[3]),
    .tx_data_3_p  (c2m_0_p[3]),
    // tx quad 2
    .tx_data_4_n  (c2m_0_n[4]),
    .tx_data_4_p  (c2m_0_p[4]),
    .tx_data_5_n  (c2m_0_n[5]),
    .tx_data_5_p  (c2m_0_p[5]),
    .tx_data_6_n  (c2m_0_n[6]),
    .tx_data_6_p  (c2m_0_p[6]),
    .tx_data_7_n  (c2m_0_n[7]),
    .tx_data_7_p  (c2m_0_p[7]),
    // tx quad 3
    .tx_data_8_n  (c2m_0_n[8]),
    .tx_data_8_p  (c2m_0_p[8]),
    .tx_data_9_n  (c2m_0_n[9]),
    .tx_data_9_p  (c2m_0_p[9]),
    .tx_data_10_n (c2m_0_n[10]),
    .tx_data_10_p (c2m_0_p[10]),
    .tx_data_11_n (c2m_0_n[11]),
    .tx_data_11_p (c2m_0_p[11]),
    // tx quad 4
    .tx_data_12_n (c2m_0_n[12]),
    .tx_data_12_p (c2m_0_p[12]),
    .tx_data_13_n (c2m_0_n[13]),
    .tx_data_13_p (c2m_0_p[13]),
    .tx_data_14_n (c2m_0_n[14]),
    .tx_data_14_p (c2m_0_p[14]),
    .tx_data_15_n (c2m_0_n[15]),
    .tx_data_15_p (c2m_0_p[15]),

    .ref_clk_0_q0 (ref_clk_0[0]),
    .ref_clk_0_q1 (ref_clk_0[1]),
    .ref_clk_0_q2 (ref_clk_0[2]),
    .ref_clk_0_q3 (ref_clk_0[3]),
    .rx_sync_0 (rx_syncout_0),
    .tx_sync_0 (tx_syncin_0),
    .rx_sysref_0 (sysref),
    .tx_sysref_0 (sysref),

    // QUAD 1 signals

    // rx quad 1
    .rx_data_1_0_n  (m2c_1_n[0]),
    .rx_data_1_0_p  (m2c_1_p[0]),
    .rx_data_1_1_n  (m2c_1_n[1]),
    .rx_data_1_1_p  (m2c_1_p[1]),
    .rx_data_1_2_n  (m2c_1_n[2]),
    .rx_data_1_2_p  (m2c_1_p[2]),
    .rx_data_1_3_n  (m2c_1_n[3]),
    .rx_data_1_3_p  (m2c_1_p[3]),
    // rx quad 2
    .rx_data_1_4_n  (m2c_1_n[4]),
    .rx_data_1_4_p  (m2c_1_p[4]),
    .rx_data_1_5_n  (m2c_1_n[5]),
    .rx_data_1_5_p  (m2c_1_p[5]),
    .rx_data_1_6_n  (m2c_1_n[6]),
    .rx_data_1_6_p  (m2c_1_p[6]),
    .rx_data_1_7_n  (m2c_1_n[7]),
    .rx_data_1_7_p  (m2c_1_p[7]),
    // rx quad 3
    .rx_data_1_8_n  (m2c_1_n[8]),
    .rx_data_1_8_p  (m2c_1_p[8]),
    .rx_data_1_9_n  (m2c_1_n[9]),
    .rx_data_1_9_p  (m2c_1_p[9]),
    .rx_data_1_10_n (m2c_1_n[10]),
    .rx_data_1_10_p (m2c_1_p[10]),
    .rx_data_1_11_n (m2c_1_n[11]),
    .rx_data_1_11_p (m2c_1_p[11]),
    // rx quad 4
    .rx_data_1_12_n (m2c_1_n[12]),
    .rx_data_1_12_p (m2c_1_p[12]),
    .rx_data_1_13_n (m2c_1_n[13]),
    .rx_data_1_13_p (m2c_1_p[13]),
    .rx_data_1_14_n (m2c_1_n[14]),
    .rx_data_1_14_p (m2c_1_p[14]),
    .rx_data_1_15_n (m2c_1_n[15]),
    .rx_data_1_15_p (m2c_1_p[15]),
    // tx quad 1
    .tx_data_1_0_n  (c2m_1_n[0]),
    .tx_data_1_0_p  (c2m_1_p[0]),
    .tx_data_1_1_n  (c2m_1_n[1]),
    .tx_data_1_1_p  (c2m_1_p[1]),
    .tx_data_1_2_n  (c2m_1_n[2]),
    .tx_data_1_2_p  (c2m_1_p[2]),
    .tx_data_1_3_n  (c2m_1_n[3]),
    .tx_data_1_3_p  (c2m_1_p[3]),
    // tx quad 2
    .tx_data_1_4_n  (c2m_1_n[4]),
    .tx_data_1_4_p  (c2m_1_p[4]),
    .tx_data_1_5_n  (c2m_1_n[5]),
    .tx_data_1_5_p  (c2m_1_p[5]),
    .tx_data_1_6_n  (c2m_1_n[6]),
    .tx_data_1_6_p  (c2m_1_p[6]),
    .tx_data_1_7_n  (c2m_1_n[7]),
    .tx_data_1_7_p  (c2m_1_p[7]),
    // tx quad 3
    .tx_data_1_8_n  (c2m_1_n[8]),
    .tx_data_1_8_p  (c2m_1_p[8]),
    .tx_data_1_9_n  (c2m_1_n[9]),
    .tx_data_1_9_p  (c2m_1_p[9]),
    .tx_data_1_10_n (c2m_1_n[10]),
    .tx_data_1_10_p (c2m_1_p[10]),
    .tx_data_1_11_n (c2m_1_n[11]),
    .tx_data_1_11_p (c2m_1_p[11]),
    // tx quad 4
    .tx_data_1_12_n (c2m_1_n[12]),
    .tx_data_1_12_p (c2m_1_p[12]),
    .tx_data_1_13_n (c2m_1_n[13]),
    .tx_data_1_13_p (c2m_1_p[13]),
    .tx_data_1_14_n (c2m_1_n[14]),
    .tx_data_1_14_p (c2m_1_p[14]),
    .tx_data_1_15_n (c2m_1_n[15]),
    .tx_data_1_15_p (c2m_1_p[15]),

    .ref_clk_1_q0 (ref_clk_1[0]),
    .ref_clk_1_q1 (ref_clk_1[1]),
    .ref_clk_1_q2 (ref_clk_1[2]),
    .ref_clk_1_q3 (ref_clk_1[3]),
    .rx_sync_1_0 (rx_syncout_1),
    .tx_sync_1_0 (tx_syncin_1),
    .rx_sysref_1_0 (sysref),
    .tx_sysref_1_0 (sysref),
    // QUAD 2 signals

    // rx quad 1
    .rx_data_2_0_n  (m2c_2_n[0]),
    .rx_data_2_0_p  (m2c_2_p[0]),
    .rx_data_2_1_n  (m2c_2_n[1]),
    .rx_data_2_1_p  (m2c_2_p[1]),
    .rx_data_2_2_n  (m2c_2_n[2]),
    .rx_data_2_2_p  (m2c_2_p[2]),
    .rx_data_2_3_n  (m2c_2_n[3]),
    .rx_data_2_3_p  (m2c_2_p[3]),
    // rx quad 2
    .rx_data_2_4_n  (m2c_2_n[4]),
    .rx_data_2_4_p  (m2c_2_p[4]),
    .rx_data_2_5_n  (m2c_2_n[5]),
    .rx_data_2_5_p  (m2c_2_p[5]),
    .rx_data_2_6_n  (m2c_2_n[6]),
    .rx_data_2_6_p  (m2c_2_p[6]),
    .rx_data_2_7_n  (m2c_2_n[7]),
    .rx_data_2_7_p  (m2c_2_p[7]),
    // rx quad 3
    .rx_data_2_8_n  (m2c_2_n[8]),
    .rx_data_2_8_p  (m2c_2_p[8]),
    .rx_data_2_9_n  (m2c_2_n[9]),
    .rx_data_2_9_p  (m2c_2_p[9]),
    .rx_data_2_10_n (m2c_2_n[10]),
    .rx_data_2_10_p (m2c_2_p[10]),
    .rx_data_2_11_n (m2c_2_n[11]),
    .rx_data_2_11_p (m2c_2_p[11]),
    // rx quad 4
    .rx_data_2_12_n (m2c_2_n[12]),
    .rx_data_2_12_p (m2c_2_p[12]),
    .rx_data_2_13_n (m2c_2_n[13]),
    .rx_data_2_13_p (m2c_2_p[13]),
    .rx_data_2_14_n (m2c_2_n[14]),
    .rx_data_2_14_p (m2c_2_p[14]),
    .rx_data_2_15_n (m2c_2_n[15]),
    .rx_data_2_15_p (m2c_2_p[15]),
    // tx quad 1
    .tx_data_2_0_n  (c2m_2_n[0]),
    .tx_data_2_0_p  (c2m_2_p[0]),
    .tx_data_2_1_n  (c2m_2_n[1]),
    .tx_data_2_1_p  (c2m_2_p[1]),
    .tx_data_2_2_n  (c2m_2_n[2]),
    .tx_data_2_2_p  (c2m_2_p[2]),
    .tx_data_2_3_n  (c2m_2_n[3]),
    .tx_data_2_3_p  (c2m_2_p[3]),
    // tx quad 2
    .tx_data_2_4_n  (c2m_2_n[4]),
    .tx_data_2_4_p  (c2m_2_p[4]),
    .tx_data_2_5_n  (c2m_2_n[5]),
    .tx_data_2_5_p  (c2m_2_p[5]),
    .tx_data_2_6_n  (c2m_2_n[6]),
    .tx_data_2_6_p  (c2m_2_p[6]),
    .tx_data_2_7_n  (c2m_2_n[7]),
    .tx_data_2_7_p  (c2m_2_p[7]),
    // tx quad 3
    .tx_data_2_8_n  (c2m_2_n[8]),
    .tx_data_2_8_p  (c2m_2_p[8]),
    .tx_data_2_9_n  (c2m_2_n[9]),
    .tx_data_2_9_p  (c2m_2_p[9]),
    .tx_data_2_10_n (c2m_2_n[10]),
    .tx_data_2_10_p (c2m_2_p[10]),
    .tx_data_2_11_n (c2m_2_n[11]),
    .tx_data_2_11_p (c2m_2_p[11]),
    // tx quad 4
    .tx_data_2_12_n (c2m_2_n[12]),
    .tx_data_2_12_p (c2m_2_p[12]),
    .tx_data_2_13_n (c2m_2_n[13]),
    .tx_data_2_13_p (c2m_2_p[13]),
    .tx_data_2_14_n (c2m_2_n[14]),
    .tx_data_2_14_p (c2m_2_p[14]),
    .tx_data_2_15_n (c2m_2_n[15]),
    .tx_data_2_15_p (c2m_2_p[15]),

    .ref_clk_2_q0 (ref_clk_2[0]),
    .ref_clk_2_q1 (ref_clk_2[1]),
    .ref_clk_2_q2 (ref_clk_2[2]),
    .ref_clk_2_q3 (ref_clk_2[3]),
    .rx_sync_2_0 (rx_syncout_2),
    .tx_sync_2_0 (tx_syncin_2),
    .rx_sysref_2_0 (sysref),
    .tx_sysref_2_0 (sysref),

    // QUAD 3 signals

    // rx quad 1
    .rx_data_3_0_n  (m2c_3_n[0]),
    .rx_data_3_0_p  (m2c_3_p[0]),
    .rx_data_3_1_n  (m2c_3_n[1]),
    .rx_data_3_1_p  (m2c_3_p[1]),
    .rx_data_3_2_n  (m2c_3_n[2]),
    .rx_data_3_2_p  (m2c_3_p[2]),
    .rx_data_3_3_n  (m2c_3_n[3]),
    .rx_data_3_3_p  (m2c_3_p[3]),
    // rx quad 2
    .rx_data_3_4_n  (m2c_3_n[4]),
    .rx_data_3_4_p  (m2c_3_p[4]),
    .rx_data_3_5_n  (m2c_3_n[5]),
    .rx_data_3_5_p  (m2c_3_p[5]),
    .rx_data_3_6_n  (m2c_3_n[6]),
    .rx_data_3_6_p  (m2c_3_p[6]),
    .rx_data_3_7_n  (m2c_3_n[7]),
    .rx_data_3_7_p  (m2c_3_p[7]),
    // rx quad 3
    .rx_data_3_8_n  (m2c_3_n[8]),
    .rx_data_3_8_p  (m2c_3_p[8]),
    .rx_data_3_9_n  (m2c_3_n[9]),
    .rx_data_3_9_p  (m2c_3_p[9]),
    .rx_data_3_10_n (m2c_3_n[10]),
    .rx_data_3_10_p (m2c_3_p[10]),
    .rx_data_3_11_n (m2c_3_n[11]),
    .rx_data_3_11_p (m2c_3_p[11]),
    // rx quad 4
    .rx_data_3_12_n (m2c_3_n[12]),
    .rx_data_3_12_p (m2c_3_p[12]),
    .rx_data_3_13_n (m2c_3_n[13]),
    .rx_data_3_13_p (m2c_3_p[13]),
    .rx_data_3_14_n (m2c_3_n[14]),
    .rx_data_3_14_p (m2c_3_p[14]),
    .rx_data_3_15_n (m2c_3_n[15]),
    .rx_data_3_15_p (m2c_3_p[15]),
    // tx quad 1
    .tx_data_3_0_n  (c2m_3_n[0]),
    .tx_data_3_0_p  (c2m_3_p[0]),
    .tx_data_3_1_n  (c2m_3_n[1]),
    .tx_data_3_1_p  (c2m_3_p[1]),
    .tx_data_3_2_n  (c2m_3_n[2]),
    .tx_data_3_2_p  (c2m_3_p[2]),
    .tx_data_3_3_n  (c2m_3_n[3]),
    .tx_data_3_3_p  (c2m_3_p[3]),
    // tx quad 2
    .tx_data_3_4_n  (c2m_3_n[4]),
    .tx_data_3_4_p  (c2m_3_p[4]),
    .tx_data_3_5_n  (c2m_3_n[5]),
    .tx_data_3_5_p  (c2m_3_p[5]),
    .tx_data_3_6_n  (c2m_3_n[6]),
    .tx_data_3_6_p  (c2m_3_p[6]),
    .tx_data_3_7_n  (c2m_3_n[7]),
    .tx_data_3_7_p  (c2m_3_p[7]),
    // tx quad 3
    .tx_data_3_8_n  (c2m_3_n[8]),
    .tx_data_3_8_p  (c2m_3_p[8]),
    .tx_data_3_9_n  (c2m_3_n[9]),
    .tx_data_3_9_p  (c2m_3_p[9]),
    .tx_data_3_10_n (c2m_3_n[10]),
    .tx_data_3_10_p (c2m_3_p[10]),
    .tx_data_3_11_n (c2m_3_n[11]),
    .tx_data_3_11_p (c2m_3_p[11]),
    // tx quad 4
    .tx_data_3_12_n (c2m_3_n[12]),
    .tx_data_3_12_p (c2m_3_p[12]),
    .tx_data_3_13_n (c2m_3_n[13]),
    .tx_data_3_13_p (c2m_3_p[13]),
    .tx_data_3_14_n (c2m_3_n[14]),
    .tx_data_3_14_p (c2m_3_p[14]),
    .tx_data_3_15_n (c2m_3_n[15]),
    .tx_data_3_15_p (c2m_3_p[15]),

    .ref_clk_3_q0 (ref_clk_3[0]),
    .ref_clk_3_q1 (ref_clk_3[1]),
    .ref_clk_3_q2 (ref_clk_3[2]),
    .ref_clk_3_q3 (ref_clk_3[3]),
    .rx_sync_3_0 (rx_syncout_3),
    .tx_sync_3_0 (tx_syncin_3),
    .rx_sysref_3_0 (sysref),
    .tx_sysref_3_0 (sysref),

    .device_clk (device_clk)

   );


endmodule

// ***************************************************************************
// ***************************************************************************
