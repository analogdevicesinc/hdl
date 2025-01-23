// ***************************************************************************
// ***************************************************************************
// Copyright 2025 (c) Analog Devices, Inc. All rights reserved.
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

module system_top #(
    parameter TX_NUM_LINKS = 1,
    parameter RX_NUM_LINKS = 1,
    parameter ASYMMETRIC_A_B_MODE = 1
  ) (

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
  output [ 0:0] ddr4_cs_n,
  inout  [ 7:0] ddr4_dm_n,
  inout  [63:0] ddr4_dq,
  inout  [ 7:0] ddr4_dqs_p,
  inout  [ 7:0] ddr4_dqs_n,
  output [ 0:0] ddr4_odt,
  output        ddr4_reset_n,

  output        mdio_mdc,
  inout         mdio_mdio,
  input         phy_clk_p,
  input         phy_clk_n,
  output        phy_rst_n,
  input         phy_rx_p,
  input         phy_rx_n,
  output        phy_tx_p,
  output        phy_tx_n,

  inout  [16:0] gpio_bd,

  output        iic_rstn,
  inout         iic_scl,
  inout         iic_sda,

  // FMC HPC+ IOs
  output  [11:0] srxa_p,
  output  [11:0] srxa_n,

  output  [11:0] srxb_p,
  output  [11:0] srxb_n,

  input   [11:0] stxa_p,
  input   [11:0] stxa_n,

  input   [11:0] stxb_p,
  input   [11:0] stxb_n,

  inout  [30:15] gpio,
  inout          aux_gpio,

  output         syncinb_a0_p,
  output         syncinb_a0_n,
  output         syncinb_b0_p,
  output         syncinb_b0_n,
  inout          syncinb_a1_p_gpio,
  inout          syncinb_a1_n_gpio,
  inout          syncinb_b1_p_gpio,
  inout          syncinb_b1_n_gpio,

  input          syncoutb_a0_p,
  input          syncoutb_a0_n,
  input          syncoutb_b0_p,
  input          syncoutb_b0_n,
  inout          syncoutb_a1_p_gpio,
  inout          syncoutb_a1_n_gpio,
  inout          syncoutb_b1_p_gpio,
  inout          syncoutb_b1_n_gpio,

  input  [ 2:0]  ref_clk_p,
  input  [ 2:0]  ref_clk_n,
  input          ref_clk_replica_p,
  input          ref_clk_replica_n,
  // input          ads10_ref_clk_p,
  // input          ads10_ref_clk_n,

  output         sysref_a_p,
  output         sysref_a_n,
  output         sysref_b_p,
  output         sysref_b_n,
  input          sysref_p,
  input          sysref_n,
  input          sysref_in_p,
  input          sysref_in_n,

  output         spi2_sclk,
  inout          spi2_sdio,
  input          spi2_sdo,
  output [ 5:0]  spi2_cs,

  output         dut_sdio,
  input          dut_sdo,
  output         dut_sclk,
  output         dut_csb,

  input  [ 1:0]  clk_m2c_p,
  input  [ 1:0]  clk_m2c_n,

  output         hsci_ckin_p,
  output         hsci_ckin_n,
  output         hsci_din_p,
  output         hsci_din_n,
  input          hsci_cko_p,
  input          hsci_cko_n,
  input          hsci_do_p,
  input          hsci_do_n,

  output [ 1:0]  trig_a,
  output [ 1:0]  trig_b,

  input          trig_in,
  output         resetb
);

  localparam      CLK_FWD_PAT = 8'h55;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  wire            spi_clk;
  wire    [ 7:0]  spi_csn;
  wire            spi_sdo;
  wire            spi_sdio;
  wire            hmc7044_sdo;

  wire            apollo_spi_clk;
  wire    [ 7:0]  apollo_spi_csn;
  wire            apollo_spi_sdo;
  wire            apollo_spi_sdio;

  // wire    [ 5:0]  ref_clk_loc;
  wire            ref_clk;
  wire            ref_clk_replica;
  wire            sysref;
  wire            sysref_loc;
  wire    [TX_NUM_LINKS-1:0]  tx_syncin;
  wire    [RX_NUM_LINKS-1:0]  rx_syncout;

  wire            clkin0;
  wire            clkin1;
  wire            clkin2;
  wire            clkin3;
  wire            tx_device_clk;
  wire            rx_device_clk;
  wire            tx_b_device_clk;
  wire            rx_b_device_clk;

  wire            tmp_sync;

  wire            pll_inclk;
  wire            hsci_pll_reset;
  wire            hsci_pclk;
  wire            hsci_pll_locked;
  wire            hsci_vtc_rdy_bsc_tx;
  wire            hsci_dly_rdy_bsc_tx;
  wire            hsci_vtc_rdy_bsc_rx;
  wire            hsci_dly_rdy_bsc_rx;
  wire            hsci_rst_seq_done;

  wire            selectio_clk_in;
  wire    [ 7:0]  hsci_menc_clk;
  wire    [ 7:0]  hsci_data_in;
  wire    [ 7:0]  hsci_data_out;

  // wire            trig_rstn;
  // wire            trig;
  assign iic_rstn = 1'b1;

  // instantiations

  IBUFDS_GTE4 i_ibufds_ref_clk (
    .CEB (1'd0),
    .I (ref_clk_p[0]),
    .IB (ref_clk_n[0]),
    .O (ref_clk),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_ref_clk_replica (
    .CEB (1'd0),
    .I (ref_clk_replica_p),
    .IB (ref_clk_replica_n),
    .O (ref_clk_replica),
    .ODIV2 ());

  IBUFDS i_ibufds_sysref_in (
    .I (sysref_in_p),
    .IB (sysref_in_n),
    .O (sysref));

  OBUFDS i_obufds_sysref_a (
    .I (1'b0),
    .O (sysref_a_p),
    .OB (sysref_a_n));

  OBUFDS i_obufds_sysref_b (
    .I (1'b0),
    .O (sysref_b_p),
    .OB (sysref_b_n));

  IBUFDS i_ibufds_sysref_ext (
    .I (sysref_p),
    .IB (sysref_n),
    .O ());

  IBUFDS i_ibufds_rx_device_clk (
    .I (clk_m2c_p[0]),
    .IB (clk_m2c_n[0]),
    .O (clkin0));

  IBUFDS i_ibufds_tx_device_clk (
    .I (clk_m2c_p[1]),
    .IB (clk_m2c_n[1]),
    .O (clkin1));

  IBUFDS_GTE4 i_ibufds_rx_b_device_clk (
    .I (ref_clk_p[1]),
    .IB (ref_clk_n[1]),
    .CEB(1'b0),
    .ODIV2 (clkin2));

  IBUFDS_GTE4 i_ibufds_tx_b_device_clk (
    .I (ref_clk_p[2]),
    .IB (ref_clk_n[2]),
    .CEB(1'b0),
    .ODIV2 (clkin3));

  IBUFDS i_ibufds_syncin0 (
    .I (syncoutb_a0_p),
    .IB (syncoutb_a0_n),
    .O (tx_syncin[0]));

  OBUFDS i_obufds_syncout0 (
    .I (rx_syncout[0]),
    .O (syncinb_a0_p),
    .OB (syncinb_a0_n));

  IBUFDS i_ibufds_syncin1 (
    .I (syncoutb_b0_p),
    .IB (syncoutb_b0_n),
    .O (tx_syncin[1]));

  OBUFDS i_obufds_syncout1 (
    .I (rx_syncout[1]),
    .O (syncinb_b0_p),
    .OB (syncinb_b0_n));

  BUFG i_rx_device_clk (
    .I (clkin0),
    .O (rx_device_clk));

  BUFG i_tx_device_clk (
    .I (clkin1),
    .O (tx_device_clk));

  BUFG_GT i_rx_b_device_clk (
    .I (clkin2),
    .O (rx_b_device_clk));

  BUFG_GT i_tx_b_device_clk (
    .I (clkin3),
    .O (tx_b_device_clk));

  BUFG i_selectio_clk_in(
    .I (selectio_clk_in),
    .O (pll_inclk));
  // spi

  assign spi2_cs[5:0] = spi_csn[5:0];
  assign spi2_sclk    = spi_clk;

  ad9084_fmca_ebz_spi #(
    .NUM_OF_SLAVES(2)
  ) i_spi (
    .spi_csn (spi_csn[1:0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_sdio),
    .spi_miso (spi_sdo),
    .spi_miso_in (spi2_sdo),
    .spi_sdio (spi2_sdio));

  assign dut_csb  = apollo_spi_csn[0];
  assign dut_sclk = apollo_spi_clk;
  assign dut_sdio = apollo_spi_sdio;

  assign apollo_spi_sdo = ~apollo_spi_csn[0] ? dut_sdo : 1'b0;

  // gpios

  ad_iobuf #(.DATA_WIDTH(17)) i_iobuf (
    .dio_t (gpio_t[48:32]),
    .dio_i (gpio_o[48:32]),
    .dio_o (gpio_i[48:32]),
    .dio_p ({aux_gpio,         // 48
             gpio[30:15]}));   // 47-32

  assign gpio_i[53] = trig_in;

  assign trig_a[0]  = gpio_o[58];
  assign trig_a[1]  = gpio_o[59];
  assign trig_b[0]  = gpio_o[60];
  assign trig_b[1]  = gpio_o[61];
  assign resetb     = gpio_o[62];

  ad_iobuf #(.DATA_WIDTH(17)) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:54] = gpio_o[63:54];
  assign gpio_i[31:17] = gpio_o[31:17];

  generate
    if (ASYMMETRIC_A_B_MODE == 1)
      assign sysref_loc = sysref;
    else
      assign sysref_loc = 0;
  endgenerate

  // trigger_generator trig_i (
  //   .sysref     (sysref),
  //   .device_clk (rx_device_clk),
  //   .gpio       (aux_gpio),
  //   .rstn       (trig_rstn),
  //   .trigger    (trig)
  // );

  hsci_phy_top hsci_phy_top(
    .pll_inclk       (pll_inclk),
    .hsci_pll_reset  (hsci_pll_reset),

    .hsci_pclk       (hsci_pclk),
    .hsci_mosi_d_p   (hsci_din_p),
    .hsci_mosi_d_n   (hsci_din_n),

    .hsci_miso_d_p   (hsci_do_p),
    .hsci_miso_d_n   (hsci_do_n),

    .hsci_pll_locked (hsci_pll_locked),

    .hsci_mosi_clk_p (hsci_ckin_p),
    .hsci_mosi_clk_n (hsci_ckin_n),

    .hsci_miso_clk_p (hsci_cko_p),
    .hsci_miso_clk_n (hsci_cko_n),

    .hsci_menc_clk   (hsci_menc_clk),
    .hsci_mosi_data  (hsci_data_out),
    .hsci_miso_data  (hsci_data_in),

    .vtc_rdy_bsc_tx  (hsci_vtc_rdy_bsc_tx),
    .dly_rdy_bsc_tx  (hsci_dly_rdy_bsc_tx),
    .vtc_rdy_bsc_rx  (hsci_vtc_rdy_bsc_rx),
    .dly_rdy_bsc_rx  (hsci_dly_rdy_bsc_rx),
    .rst_seq_done    (hsci_rst_seq_done)
 );

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
    .phy_rst_n (phy_rst_n),
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
    .spi_sdi_i (spi_sdo),
    .spi_sdo_i (spi_sdio),
    .spi_sdo_o (spi_sdio),

    .apollo_spi_clk_i (apollo_spi_clk),
    .apollo_spi_clk_o (apollo_spi_clk),
    .apollo_spi_csn_i (apollo_spi_csn),
    .apollo_spi_csn_o (apollo_spi_csn),
    .apollo_spi_sdi_i (apollo_spi_sdo),
    .apollo_spi_sdo_i (apollo_spi_sdio),
    .apollo_spi_sdo_o (apollo_spi_sdio),

    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    // FMC HPC+
    // quad 125
    .tx_data_0_n  (srxa_n[10]),
    .tx_data_0_p  (srxa_p[10]),
    .tx_data_1_n  (srxa_n[8]),
    .tx_data_1_p  (srxa_p[8]),
    .tx_data_2_n  (srxa_n[9]),
    .tx_data_2_p  (srxa_p[9]),
    .tx_data_3_n  (srxa_n[11]),
    .tx_data_3_p  (srxa_p[11]),
    // quad 126
    .tx_data_4_n  (srxa_n[5]),
    .tx_data_4_p  (srxa_p[5]),
    .tx_data_5_n  (srxa_n[1]),
    .tx_data_5_p  (srxa_p[1]),
    .tx_data_6_n  (srxa_n[3]),
    .tx_data_6_p  (srxa_p[3]),
    .tx_data_7_n  (srxa_n[7]),
    .tx_data_7_p  (srxa_p[7]),
    // quad 127
    .tx_data_8_n  (srxa_n[4]),
    .tx_data_8_p  (srxa_p[4]),
    .tx_data_9_n  (srxa_n[6]),
    .tx_data_9_p  (srxa_p[6]),
    .tx_data_10_n (srxa_n[2]),
    .tx_data_10_p (srxa_p[2]),
    .tx_data_11_n (srxa_n[0]),
    .tx_data_11_p (srxa_p[0]),

    // quad 120
    .tx_data_12_n (srxb_n[4]),
    .tx_data_12_p (srxb_p[4]),
    .tx_data_13_n (srxb_n[6]),
    .tx_data_13_p (srxb_p[6]),
    .tx_data_14_n (srxb_n[2]),
    .tx_data_14_p (srxb_p[2]),
    .tx_data_15_n (srxb_n[0]),
    .tx_data_15_p (srxb_p[0]),
    // quad 121
    .tx_data_16_n (srxb_n[1]),
    .tx_data_16_p (srxb_p[1]),
    .tx_data_17_n (srxb_n[7]),
    .tx_data_17_p (srxb_p[7]),
    .tx_data_18_n (srxb_n[10]),
    .tx_data_18_p (srxb_p[10]),
    .tx_data_19_n (srxb_n[3]),
    .tx_data_19_p (srxb_p[3]),
    // quad 122
    .tx_data_20_n (srxb_n[5]),
    .tx_data_20_p (srxb_p[5]),
    .tx_data_21_n (srxb_n[8]),
    .tx_data_21_p (srxb_p[8]),
    .tx_data_22_n (srxb_n[9]),
    .tx_data_22_p (srxb_p[9]),
    .tx_data_23_n (srxb_n[11]),
    .tx_data_23_p (srxb_p[11]),

    // quad 125
    .rx_data_0_n  (stxa_n[7]),
    .rx_data_0_p  (stxa_p[7]),
    .rx_data_1_n  (stxa_n[5]),
    .rx_data_1_p  (stxa_p[5]),
    .rx_data_2_n  (stxa_n[1]),
    .rx_data_2_p  (stxa_p[1]),
    .rx_data_3_n  (stxa_n[2]),
    .rx_data_3_p  (stxa_p[2]),
    // quad 126
    .rx_data_4_n  (stxa_n[11]),
    .rx_data_4_p  (stxa_p[11]),
    .rx_data_5_n  (stxa_n[3]),
    .rx_data_5_p  (stxa_p[3]),
    .rx_data_6_n  (stxa_n[8]),
    .rx_data_6_p  (stxa_p[8]),
    .rx_data_7_n  (stxa_n[9]),
    .rx_data_7_p  (stxa_p[9]),
    // quad 127
    .rx_data_8_n  (stxa_n[10]),
    .rx_data_8_p  (stxa_p[10]),
    .rx_data_9_n  (stxa_n[6]),
    .rx_data_9_p  (stxa_p[6]),
    .rx_data_10_n (stxa_n[4]),
    .rx_data_10_p (stxa_p[4]),
    .rx_data_11_n (stxa_n[0]),
    .rx_data_11_p (stxa_p[0]),

    // quad 120
    .rx_data_12_n (stxb_n[10]),
    .rx_data_12_p (stxb_p[10]),
    .rx_data_13_n (stxb_n[6]),
    .rx_data_13_p (stxb_p[6]),
    .rx_data_14_n (stxb_n[4]),
    .rx_data_14_p (stxb_p[4]),
    .rx_data_15_n (stxb_n[0]),
    .rx_data_15_p (stxb_p[0]),
    // quad 121
    .rx_data_16_n (stxb_n[3]),
    .rx_data_16_p (stxb_p[3]),
    .rx_data_17_n (stxb_n[2]),
    .rx_data_17_p (stxb_p[2]),
    .rx_data_18_n (stxb_n[5]),
    .rx_data_18_p (stxb_p[5]),
    .rx_data_19_n (stxb_n[7]),
    .rx_data_19_p (stxb_p[7]),
    // quad 122
    .rx_data_20_n (stxb_n[8]),
    .rx_data_20_p (stxb_p[8]),
    .rx_data_21_n (stxb_n[1]),
    .rx_data_21_p (stxb_p[1]),
    .rx_data_22_n (stxb_n[11]),
    .rx_data_22_p (stxb_p[11]),
    .rx_data_23_n (stxb_n[9]),
    .rx_data_23_p (stxb_p[9]),

    .ref_clk_q0 (ref_clk_replica),
    .ref_clk_q1 (ref_clk_replica),
    .ref_clk_q2 (ref_clk_replica),
    .ref_clk_q3 (ref_clk),
    .ref_clk_q4 (ref_clk),
    .ref_clk_q5 (ref_clk),

    .rx_device_clk (rx_device_clk),
    .tx_device_clk (tx_device_clk),
    .rx_b_device_clk (rx_b_device_clk),
    .tx_b_device_clk (tx_b_device_clk),

    // .rx_device_clk_rstn(trig_rstn),

    .selectio_clk_in (selectio_clk_in),
    .hsci_menc_clk (hsci_menc_clk),
    .hsci_data_out (hsci_data_out),
    .hsci_data_in (hsci_data_in),
    .hsci_pclk (hsci_pclk),
    .hsci_pll_reset (hsci_pll_reset),
    .hsci_rst_seq_done(hsci_rst_seq_done),
    .hsci_pll_locked (hsci_pll_locked),
    .hsci_vtc_rdy_bsc_tx (hsci_vtc_rdy_bsc_tx),
    .hsci_dly_rdy_bsc_tx (hsci_dly_rdy_bsc_tx),
    .hsci_vtc_rdy_bsc_rx (hsci_vtc_rdy_bsc_rx),
    .hsci_dly_rdy_bsc_rx (hsci_dly_rdy_bsc_rx),

    .rx_sync_0 (rx_syncout),
    .tx_sync_0 (tx_syncin),
    .rx_sysref_0 (sysref),
    .tx_sysref_0 (sysref),
    .rx_sysref_12 (sysref_loc),
    .tx_sysref_12 (sysref_loc)
  );

endmodule

// ***************************************************************************
// ***************************************************************************
