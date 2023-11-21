// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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

module system_top (

  input         sys_rst,
  input         sys_clk_p,
  input         sys_clk_n,

  input         uart_sin,
  output        uart_sout,

  output        ddr4_act_n,
  output [16:0] ddr4_addr,
  output [ 1:0] ddr4_ba,
  output        ddr4_bg,
  output        ddr4_ck_p,
  output        ddr4_ck_n,
  output        ddr4_cke,
  output        ddr4_cs_n,
  inout  [ 7:0] ddr4_dm_n,
  inout  [63:0] ddr4_dq,
  inout  [ 7:0] ddr4_dqs_p,
  inout  [ 7:0] ddr4_dqs_n,
  output        ddr4_odt,
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

  // dual_mxfe specific

  output        fpga_vadj,
  output        fan_pwm,
  output        fmc_fan_tach,

  output        adf4377_ce,
  output        adf4377_csb,
  output        adf4377_enclk1,
  output        adf4377_enclk2,
  output        adf4377_sclk,
  output        adf4377_sdio,
  input         adf4377_sdo,

  // reference clock
  input         fpga_clk0_p,
  input         fpga_clk0_n,
  input         fpga_clk0_p_replica,
  input         fpga_clk0_n_replica,

  // was forgotten
  input         fpga_clk1_p,
  input         fpga_clk1_n,

  // rx_device_clk
  input         fpga_clk2_p,
  input         fpga_clk2_n,

  // tx_device_clk
  input         fpga_clk3_p,
  input         fpga_clk3_n,

  // unused so far
  input         fpga_clk4_p,
  input         fpga_clk4_n,

  // sysref for RX
  input         fpga_sysref0_p,
  input         fpga_sysref0_n,

  // sysref for TX
  input         fpga_sysref1_p,
  input         fpga_sysref1_n,

  input  [ 7:0] serdes0_m2c_p,
  input  [ 7:0] serdes0_m2c_n,

  output [ 7:0] serdes0_c2m_p,
  output [ 7:0] serdes0_c2m_n,

  input  [ 7:0] serdes1_m2c_p,
  input  [ 7:0] serdes1_m2c_n,

  output [ 7:0] serdes1_c2m_p,
  output [ 7:0] serdes1_c2m_n,

  // MxFE0: syncin_p[2] (FMC_MXFE0_SYNCIN_P<1>) and [0]
  // MxFE0: syncin_n[0]
  // MxFE1: syncin_p[3] (FMC_MXFE1_SYNCIN_P<1>) and [1]
  // MxFE1: syncin_n[1]
  output [ 3:0] syncin_p,
  output [ 1:0] syncin_n,

  // MxFE0: syncout_p[2] (FMC_MXFE0_SYNCOUT_P<1>) and [0]
  // MxFE0: syncout_n[0]
  // MxFE1: syncout_p[3] (FMC_MXFE1_SYNCOUT_P<1>) and [1]
  // MxFE1: syncout_n[1]
  input  [ 3:0] syncout_p,
  input  [ 1:0] syncout_n,

  output  [8:0] mxfe0_gpio,

  output  [8:0] mxfe1_gpio,

  output        hmc7044_reset,
  output        hmc7044_sclk,
  output        hmc7044_slen,
  input         hmc7044_miso,
  output        hmc7044_mosi,

  input         m0_irq,
  input         m1_irq,

  output  [1:0] mxfe_sclk,
  output  [1:0] mxfe_cs,
  input   [1:0] mxfe_miso,
  output  [1:0] mxfe_mosi,

  output  [1:0] mxfe_reset,
  output  [1:0] mxfe_rx_en0,
  output  [1:0] mxfe_rx_en1,
  output  [1:0] mxfe_tx_en0,
  output  [1:0] mxfe_tx_en1,

  output [22:0] gpio_fmcp_p,
  output [22:0] gpio_fmcp_n
);

  // internal signals

  wire   [127:0]  gpio_i;
  wire   [127:0]  gpio_o;
  wire   [127:0]  gpio_t;

  wire            spi_clk;
  wire     [7:0]  spi_csn;
  wire            spi_mosi;
  wire            spi_miso;

  wire            spi_2_clk;
  wire            spi_2_csn;
  wire            spi_2_mosi;
  wire            spi_2_miso;

  wire            spi_3_clk;
  wire            spi_3_csn;
  wire            spi_3_mosi;
  wire            spi_3_miso;

  wire            ref_clk;

  wire            sysref0;
  wire            sysref1;

  wire     [1:0]  link0_tx_syncin;
  wire     [1:0]  link0_rx_syncout;

  wire            dac_fifo_bypass;

  assign iic_rstn = 1'b1;

  // instantiations

  // Link 0 SYNC single ended lines
  assign syncin_p_0 = link0_rx_syncout[0];
  assign syncin_p_2 = link0_rx_syncout[1];

  assign link0_tx_syncin[0] = syncout_p_0;
  assign link0_tx_syncin[1] = syncout_p_2;

  // REFCLK

  IBUFDS_GTE4 i_ibufds_ref_clk (
    .CEB (1'd0),
    .I (fpga_clk0_p),
    .IB (fpga_clk0_n),
    .O (ref_clk),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_ref_clk_replica (
    .CEB (1'd0),
    .I (fpga_clk0_p_replica),
    .IB (fpga_clk0_n_replica),
    .O (ref_clk_replica),
    .ODIV2 ());

  // SYSREF

  IBUFDS i_ibufds_sysref0 (
    .I (fpga_sysref0_p),
    .IB (fpga_sysref0_n),
    .O (sysref0));

  IBUFDS i_ibufds_sysref1 (
    .I (fpga_sysref1_p),
    .IB (fpga_sysref1_n),
    .O (sysref1));

  // RX

  IBUFDS i_ibufds_rx_device_clk (
    .I (fpga_clk2_p),
    .IB (fpga_clk2_n),
    .O (fpga_clk2));

  BUFG i_rx_device_clk (
    .I (fpga_clk2),
    .O (rx_device_clk));

  // TX

  IBUFDS i_ibufds_tx_device_clk (
    .I (fpga_clk3_p),
    .IB (fpga_clk3_n),
    .O (fpga_clk3));

  BUFG i_tx_device_clk (
    .I (fpga_clk3),
    .O (tx_device_clk));

  // spi

  assign mxfe_cs = spi_csn[1:0];
  assign mxfe_mosi = {2{spi_mosi}};
  assign mxfe_sclk = {2{spi_clk}};

  assign hmc7044_slen = spi_2_csn;
  assign hmc7044_sclk = spi_2_clk;

  assign adf4377_cs = spi_3_csn;
  assign adf4377_sclk = spi_3_clk;

  assign spi_miso = ~spi_csn[0] ? mxfe_miso[0] :
                    ~spi_csn[1] ? mxfe_miso[1] :
                    1'b0;

  // spi_2 - hmc7044

  ad_3w_spi #(
    .NUM_OF_SLAVES (1)
  ) i_spi_hmc7044 (
    .spi_csn (spi_2_csn),
    .spi_clk (spi_2_clk),
    .spi_mosi (spi_2_mosi),
    .spi_miso (spi_2_miso),
    .spi_sdio (hmc7044_miso),
    .spi_dir ());

  // spi_3 - adf4377

  ad_3w_spi #(
    .NUM_OF_SLAVES (1)
  ) i_spi_adf4377 (
    .spi_csn (spi_3_csn),
    .spi_clk (spi_3_clk),
    .spi_mosi (spi_3_mosi),
    .spi_miso (spi_3_miso),
    .spi_sdio (adf4377_sdio),
    .spi_dir ());

  // gpios

  ad_iobuf #(
    .DATA_WIDTH (1)
  ) i_iobuf (
    .dio_t (gpio_t[32]),
    .dio_i (gpio_o[32]),
    .dio_o (gpio_i[32]),
    .dio_p (hmc7044_gpio));

  assign hmc7044_reset = gpio_o[33];

  assign mxfe_reset  = gpio_o[44:41];
  assign mxfe_rx_en0 = gpio_o[48:45];
  assign mxfe_rx_en1 = gpio_o[52:49];
  assign mxfe_tx_en0 = gpio_o[56:53];
  assign mxfe_tx_en1 = gpio_o[60:57];

  assign dac_fifo_bypass = gpio_o[61];

  ad_iobuf #(
    .DATA_WIDTH (17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:33] = gpio_o[63:33];
  assign gpio_i[31:17] = gpio_o[31:17];

  dual_mxfe_gpio_mux i_dual_mxfe_gpio_mux (
    .mxfe0_gpio0 (mxfe0_gpio[0]),
    .mxfe0_gpio1 (mxfe0_gpio[1]),
    .mxfe0_gpio2 (mxfe0_gpio[2]),
    .mxfe0_gpio5 (mxfe0_gpio[3]),
    .mxfe0_gpio6 (mxfe0_gpio[4]),
    .mxfe0_gpio7 (mxfe0_gpio[5]),
    .mxfe0_gpio8 (mxfe0_gpio[6]),
    .mxfe0_gpio9 (mxfe0_gpio[7]),
    .mxfe0_gpio10 (mxfe0_gpio[8]),
    .mxfe0_syncin_1_n (syncin_n_0),
    .mxfe0_syncin_1_p (syncin_p_1),
    .mxfe0_syncout_1_n (syncout_n_0),
    .mxfe0_syncout_1_p (syncout_p_1),

    .mxfe1_gpio0 (mxfe1_gpio[0]),
    .mxfe1_gpio1 (mxfe1_gpio[1]),
    .mxfe1_gpio2 (mxfe1_gpio[2]),
    .mxfe1_gpio5 (mxfe1_gpio[3]),
    .mxfe1_gpio6 (mxfe1_gpio[4]),
    .mxfe1_gpio7 (mxfe1_gpio[5]),
    .mxfe1_gpio8 (mxfe1_gpio[6]),
    .mxfe1_gpio9 (mxfe1_gpio[7]),
    .mxfe1_gpio10 (mxfe1_gpio[8]),
    .mxfe1_syncin_1_n (syncin_n_1),
    .mxfe1_syncin_1_p (syncin_p_3),
    .mxfe1_syncout_1_n (syncout_n_1),
    .mxfe1_syncout_1_p (syncout_p_3),

    .gpio_t (gpio_t[127:64]),
    .gpio_i (gpio_i[127:64]),
    .gpio_o (gpio_o[127:64]));

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
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),

    .spi_2_clk_i (spi_2_clk),
    .spi_2_clk_o (spi_2_clk),
    .spi_2_csn_i (spi_2_csn),
    .spi_2_csn_o (spi_2_csn),
    .spi_2_sdi_i (spi_2_miso),
    .spi_2_sdo_i (spi_2_mosi),
    .spi_2_sdo_o (spi_2_mosi),

    .spi_3_clk_i (spi_3_clk),
    .spi_3_clk_o (spi_3_clk),
    .spi_3_csn_i (spi_3_csn),
    .spi_3_csn_o (spi_3_csn),
    .spi_3_sdi_i (spi_3_miso),
    .spi_3_sdo_i (spi_3_mosi),
    .spi_3_sdo_o (spi_3_mosi),

    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),

    // FMCp

    .gpio_fmcp_p (gpio_fmcp_p),
    .gpio_fmcp_n (gpio_fmcp_n),

    // quads

    // see "RX connect PHY to link Layer" section from ad_dualmxfe_ebz_bd.tcl
    //         serdes0_m2c index ## serdes1_m2c index-8
    // index = { 1 0 6 3 2 7 5 4 ## 15 14 13 12 9 11 10 8 }

    // quad 121
    .rx_data_0_n (serdes0_m2c_n[1]),
    .rx_data_0_p (serdes0_m2c_p[1]),
    .rx_data_1_n (serdes0_m2c_n[0]),
    .rx_data_1_p (serdes0_m2c_p[0]),
    .rx_data_2_n (serdes0_m2c_n[6]),
    .rx_data_2_p (serdes0_m2c_p[6]),
    .rx_data_3_n (serdes0_m2c_n[3]),
    .rx_data_3_p (serdes0_m2c_p[3]),
    // quad 122
    .rx_data_4_n (serdes0_m2c_n[2]),
    .rx_data_4_p (serdes0_m2c_p[2]),
    .rx_data_5_n (serdes0_m2c_n[7]),
    .rx_data_5_p (serdes0_m2c_p[7]),
    .rx_data_6_n (serdes0_m2c_n[5]),
    .rx_data_6_p (serdes0_m2c_p[5]),
    .rx_data_7_n (serdes0_m2c_n[4]),
    .rx_data_7_p (serdes0_m2c_p[4]),
    // quad 125
    // so logic_lane(13) is serdes1_m2c[5]
    .rx_data_8_n  (serdes1_m2c_n[7]),
    .rx_data_8_p  (serdes1_m2c_p[7]),
    .rx_data_9_n  (serdes1_m2c_n[6]),
    .rx_data_9_p  (serdes1_m2c_p[6]),
    .rx_data_10_n (serdes1_m2c_n[5]),
    .rx_data_10_p (serdes1_m2c_p[5]),
    .rx_data_11_n (serdes1_m2c_n[4]),
    .rx_data_11_p (serdes1_m2c_p[4]),
    // quad 126
    .rx_data_12_n (serdes1_m2c_n[1]),
    .rx_data_12_p (serdes1_m2c_p[1]),
    .rx_data_13_n (serdes1_m2c_n[3]),
    .rx_data_13_p (serdes1_m2c_p[3]),
    .rx_data_14_n (serdes1_m2c_n[2]),
    .rx_data_14_p (serdes1_m2c_p[2]),
    .rx_data_15_n (serdes1_m2c_n[0]),
    .rx_data_15_p (serdes1_m2c_p[0]),

    // see "TX connect PHY to link Layer" section from ad_dualmxfe_ebz_bd.tcl
    //         serdes0_m2c index ## serdes1_m2c index-8
    // index = { 4 0 2 3 5 1 7 6 ## 15 9 12 8 10 11 13 14 }

    // quad 121
    .tx_data_0_n (serdes0_c2m_n[4]),
    .tx_data_0_p (serdes0_c2m_p[4]),
    .tx_data_1_n (serdes0_c2m_n[0]),
    .tx_data_1_p (serdes0_c2m_p[0]),
    .tx_data_2_n (serdes0_c2m_n[2]),
    .tx_data_2_p (serdes0_c2m_p[2]),
    .tx_data_3_n (serdes0_c2m_n[3]),
    .tx_data_3_p (serdes0_c2m_p[3]),
    // quad 122
    .tx_data_4_n (serdes0_c2m_n[5]),
    .tx_data_4_p (serdes0_c2m_p[5]),
    .tx_data_5_n (serdes0_c2m_n[1]),
    .tx_data_5_p (serdes0_c2m_p[1]),
    .tx_data_6_n (serdes0_c2m_n[7]),
    .tx_data_6_p (serdes0_c2m_p[7]),
    .tx_data_7_n (serdes0_c2m_n[6]),
    .tx_data_7_p (serdes0_c2m_p[6]),
    // quad 125
    // so logic_lane(8) = serdes1_c2m[1]
    .tx_data_8_n  (serdes1_c2m_n[7]),
    .tx_data_8_p  (serdes1_c2m_p[7]),
    .tx_data_9_n  (serdes1_c2m_n[1]),
    .tx_data_9_p  (serdes1_c2m_p[1]),
    .tx_data_10_n (serdes1_c2m_n[4]),
    .tx_data_10_p (serdes1_c2m_p[4]),
    .tx_data_11_n (serdes1_c2m_n[0]),
    .tx_data_11_p (serdes1_c2m_p[0]),
    // quad 126
    .tx_data_12_n (serdes1_c2m_n[2]),
    .tx_data_12_p (serdes1_c2m_p[2]),
    .tx_data_13_n (serdes1_c2m_n[3]),
    .tx_data_13_p (serdes1_c2m_p[3]),
    .tx_data_14_n (serdes1_c2m_n[5]),
    .tx_data_14_p (serdes1_c2m_p[5]),
    .tx_data_15_n (serdes1_c2m_n[6]),
    .tx_data_15_p (serdes1_c2m_p[6]),

    .ref_clk_q0 (ref_clk),
    .ref_clk_q1 (ref_clk),
    .ref_clk_q2 (ref_clk_replica),
    .ref_clk_q3 (ref_clk_replica),

    .rx_device_clk (rx_device_clk),
    .tx_device_clk (tx_device_clk),

    .rx_sync_0 (link0_rx_syncout),
    .tx_sync_0 (link0_tx_syncin),

    .rx_sysref_0 (sysref0),
    .tx_sysref_0 (sysref1),

    .dac_fifo_bypass (dac_fifo_bypass),

    .gpio2_i (gpio_i[95:64]),
    .gpio2_o (gpio_o[95:64]),
    .gpio2_t (gpio_t[95:64]),
    .gpio3_i (gpio_i[127:96]),
    .gpio3_o (gpio_o[127:96]),
    .gpio3_t (gpio_t[127:96]),

    .ext_sync (sysref));

endmodule
