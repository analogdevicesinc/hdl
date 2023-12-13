// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

module system_top (

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

  input         vadj_1v8_pgood,

  // FMCp IOs

  output  [3:0] adf4371_cs,
  output        adf4371_sclk,
  inout         adf4371_sdio,

  output        adrf5020_ctrl,

  input   [2:0] fpga_clk_m2c_n,
  input   [2:0] fpga_clk_m2c_p,
  input         fpga_clk_m2c_0_replica_n,
  input         fpga_clk_m2c_0_replica_p,
  output        fpga_sysref_c2m_n,
  output        fpga_sysref_c2m_p,
  input         fpga_sysref_m2c_n,
  input         fpga_sysref_m2c_p,

  output [15:0] c2m_n,
  output [15:0] c2m_p,
  input  [15:0] m2c_n,
  input  [15:0] m2c_p,

  output        mxfe_syncin_0_p,
  output        mxfe_syncin_2_p,
  output        mxfe_syncin_4_p,
  output        mxfe_syncin_6_p,

  input         mxfe_syncout_0_p,
  input         mxfe_syncout_2_p,
  input         mxfe_syncout_4_p,
  input         mxfe_syncout_6_p,

  // Sync pins used as GPIOs
  // MxFE0 GPIOs
  inout         mxfe_syncin_0_n,
  inout         mxfe_syncin_1_p,
  inout         mxfe_syncout_0_n,
  inout         mxfe_syncout_1_p,
  inout  [8:0]  mxfe0_gpio,
  // MxFE1 GPIOs
  inout         mxfe_syncin_1_n,
  inout         mxfe_syncin_3_p,
  inout         mxfe_syncout_1_n,
  inout         mxfe_syncout_3_p,
  inout  [8:0]  mxfe1_gpio,
  // MxFE2 GPIOs
  inout         mxfe_syncin_2_n,
  inout         mxfe_syncin_5_p,
  inout         mxfe_syncout_2_n,
  inout         mxfe_syncout_5_p,
  inout  [8:0]  mxfe2_gpio,
  // MxFE3 GPIOs
  inout         mxfe_syncin_3_n,
  inout         mxfe_syncin_7_p,
  inout         mxfe_syncout_3_n,
  inout         mxfe_syncout_7_p,
  inout  [8:0]  mxfe3_gpio,

  inout         hmc7043_gpio,
  output        hmc7043_reset,
  output        hmc7043_sclk,
  inout         hmc7043_sdata,
  output        hmc7043_slen,

  output  [4:1] hmc425a_v,

  output  [3:0] mxfe_sclk,
  output  [3:0] mxfe_cs,
  input   [3:0] mxfe_miso,
  output  [3:0] mxfe_mosi,

  output  [3:0] mxfe_reset,
  output  [3:0] mxfe_rx_en0,
  output  [3:0] mxfe_rx_en1,
  output  [3:0] mxfe_tx_en0,
  output  [3:0] mxfe_tx_en1,

  // PMOD1 for calibration board
  output pmod1_adc_sync_n,
  output pmod1_adc_sdi,
  input  pmod1_adc_sdo,
  output pmod1_adc_sclk,

  output pmod1_5045_v2,
  output pmod1_5045_v1,
  output pmod1_ctrl_ind,
  output pmod1_ctrl_rx_combined
);

  // internal signals

  wire    [127:0]  gpio_i;
  wire    [127:0]  gpio_o;
  wire    [127:0]  gpio_t;

  wire            spi_clk;
  wire    [ 7:0]  spi_csn;
  wire            spi_mosi;
  wire            spi_miso;
  wire            spi_4371_miso;
  wire            spi_hmc_miso;

  wire            spi_2_clk;
  wire    [ 7:0]  spi_2_csn;
  wire            spi_2_mosi;
  wire            spi_2_miso;

  wire            spi_3_clk;
  wire    [ 7:0]  spi_3_csn;
  wire            spi_3_mosi;
  wire            spi_3_miso;

  wire            ref_clk;
  wire            sysref;
  wire    [3:0]   link0_tx_syncin;
  wire    [3:0]   link0_rx_syncout;

  wire            fpga_clk_m2c_4;
  wire            device_clk;

  wire            ext_sync_at_sysref;

  reg             ext_sync_ms = 1'b0;
  reg             ext_sync_noms = 1'b0;
  reg             ext_sync_noms_d1 = 1'b0;

  assign iic_rstn = 1'b1;

  // instantiations

  // Link 0 SYNC single ended lines
  assign mxfe_syncin_0_p = link0_rx_syncout[0];
  assign mxfe_syncin_2_p = link0_rx_syncout[1];
  assign mxfe_syncin_4_p = link0_rx_syncout[2];
  assign mxfe_syncin_6_p = link0_rx_syncout[3];

  assign link0_tx_syncin[0] = mxfe_syncout_0_p;
  assign link0_tx_syncin[1] = mxfe_syncout_2_p;
  assign link0_tx_syncin[2] = mxfe_syncout_4_p;
  assign link0_tx_syncin[3] = mxfe_syncout_6_p;

  IBUFDS_GTE4 i_ibufds_ref_clk (
    .CEB (1'd0),
    .I (fpga_clk_m2c_p[0]),
    .IB (fpga_clk_m2c_n[0]),
    .O (ref_clk),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_ref_clk_replica (
    .CEB (1'd0),
    .I (fpga_clk_m2c_0_replica_p),
    .IB (fpga_clk_m2c_0_replica_n),
    .O (ref_clk_replica),
    .ODIV2 ());

  IBUFDS i_ibufds_sysref (
    .I (fpga_sysref_m2c_p),
    .IB (fpga_sysref_m2c_n),
    .O (sysref));

  OBUFDS i_obufds_sysref (
    .O (fpga_sysref_c2m_p),
    .OB (fpga_sysref_c2m_n),
    .I (sysref));

  IBUFDS i_ibufds_rx_device_clk (
    .I (fpga_clk_m2c_p[1]),
    .IB (fpga_clk_m2c_n[1]),
    .O (fpga_clk_m2c_1));

  BUFG i_rx_device_clk (
    .I (fpga_clk_m2c_1),
    .O (rx_device_clk));

  IBUFDS i_ibufds_tx_device_clk (
    .I (fpga_clk_m2c_p[2]),
    .IB (fpga_clk_m2c_n[2]),
    .O (fpga_clk_m2c_2));

  BUFG i_tx_device_clk (
    .I (fpga_clk_m2c_2),
    .O (tx_device_clk));

  // spi

  assign mxfe_cs = spi_csn[3:0];
  assign mxfe_mosi = {4{spi_mosi}};
  assign mxfe_sclk = {4{spi_clk}};

  assign adf4371_cs = spi_2_csn[3:0];
  assign adf4371_sclk = spi_2_clk;

  assign hmc7043_slen = spi_2_csn[4];
  assign hmc7043_sclk = spi_2_clk;

  assign pmod1_adc_sync_n = spi_3_csn[0];
  assign pmod1_adc_sdi = spi_3_mosi;
  assign pmod1_adc_sclk = spi_3_clk;

  assign spi_miso = ~spi_csn[0] ? mxfe_miso[0] :
                    ~spi_csn[1] ? mxfe_miso[1] :
                    ~spi_csn[2] ? mxfe_miso[2] :
                    ~spi_csn[3] ? mxfe_miso[3] :
                    1'b0;

  assign spi_2_miso =  |(~spi_2_csn[3:0]) ? spi_4371_miso :
                         ~spi_2_csn[4]    ? spi_hmc_miso :
                          1'b0;

  assign spi_3_miso =  ~pmod1_adc_sync_n ? pmod1_adc_sdo : 1'b0;

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_spi_hmc (
    .spi_csn (spi_2_csn[4]),
    .spi_clk (spi_2_clk),
    .spi_mosi (spi_2_mosi),
    .spi_miso (spi_hmc_miso),
    .spi_sdio (hmc7043_sdata),
    .spi_dir ());

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_spi_4371 (
    .spi_csn (&spi_2_csn[3:0]),
    .spi_clk (spi_2_clk),
    .spi_mosi (spi_2_mosi),
    .spi_miso (spi_4371_miso),
    .spi_sdio (adf4371_sdio),
    .spi_dir ());

  // gpios

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_iobuf (
    .dio_t (gpio_t[32:32]),
    .dio_i (gpio_o[32:32]),
    .dio_o (gpio_i[32:32]),
    .dio_p ({hmc7043_gpio})); // 32

  assign hmc7043_reset = gpio_o[33];
  assign adrf5020_ctrl = gpio_o[34];
  assign hmc425a_v     = gpio_o[38:35];
  assign mxfe_reset    = gpio_o[44:41];
  assign mxfe_rx_en0   = gpio_o[48:45];
  assign mxfe_rx_en1   = gpio_o[52:49];
  assign mxfe_tx_en0   = gpio_o[56:53];
  assign mxfe_tx_en1   = gpio_o[60:57];

  assign dac_fifo_bypass  = gpio_o[61];

  ad_iobuf #(
    .DATA_WIDTH(17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:33] = gpio_o[63:33];
  assign gpio_i[31:17] = gpio_o[31:17];

  quad_mxfe_gpio_mux i_quad_mxfe_gpio_mux (
    .mxfe0_gpio0 (mxfe0_gpio[0]),
    .mxfe0_gpio1 (mxfe0_gpio[1]),
    .mxfe0_gpio2 (mxfe0_gpio[2]),
    .mxfe0_gpio5 (mxfe0_gpio[3]),
    .mxfe0_gpio6 (mxfe0_gpio[4]),
    .mxfe0_gpio7 (mxfe0_gpio[5]),
    .mxfe0_gpio8 (mxfe0_gpio[6]),
    .mxfe0_gpio9 (mxfe0_gpio[7]),
    .mxfe0_gpio10 (mxfe0_gpio[8]),
    .mxfe0_syncin_1_n (mxfe_syncin_0_n),
    .mxfe0_syncin_1_p (mxfe_syncin_1_p),
    .mxfe0_syncout_1_n (mxfe_syncout_0_n),
    .mxfe0_syncout_1_p (mxfe_syncout_1_p),

    .mxfe1_gpio0 (mxfe1_gpio[0]),
    .mxfe1_gpio1 (mxfe1_gpio[1]),
    .mxfe1_gpio2 (mxfe1_gpio[2]),
    .mxfe1_gpio5 (mxfe1_gpio[3]),
    .mxfe1_gpio6 (mxfe1_gpio[4]),
    .mxfe1_gpio7 (mxfe1_gpio[5]),
    .mxfe1_gpio8 (mxfe1_gpio[6]),
    .mxfe1_gpio9 (mxfe1_gpio[7]),
    .mxfe1_gpio10 (mxfe1_gpio[8]),
    .mxfe1_syncin_1_n (mxfe_syncin_1_n),
    .mxfe1_syncin_1_p (mxfe_syncin_3_p),
    .mxfe1_syncout_1_n (mxfe_syncout_1_n),
    .mxfe1_syncout_1_p (mxfe_syncout_3_p),

    .mxfe2_gpio0 (mxfe2_gpio[0]),
    .mxfe2_gpio1 (mxfe2_gpio[1]),
    .mxfe2_gpio2 (mxfe2_gpio[2]),
    .mxfe2_gpio5 (mxfe2_gpio[3]),
    .mxfe2_gpio6 (mxfe2_gpio[4]),
    .mxfe2_gpio7 (mxfe2_gpio[5]),
    .mxfe2_gpio8 (mxfe2_gpio[6]),
    .mxfe2_gpio9 (mxfe2_gpio[7]),
    .mxfe2_gpio10 (mxfe2_gpio[8]),
    .mxfe2_syncin_1_n (mxfe_syncin_2_n),
    .mxfe2_syncin_1_p (mxfe_syncin_5_p),
    .mxfe2_syncout_1_n (mxfe_syncout_2_n),
    .mxfe2_syncout_1_p (mxfe_syncout_5_p),

    .mxfe3_gpio0 (mxfe3_gpio[0]),
    .mxfe3_gpio1 (mxfe3_gpio[1]),
    .mxfe3_gpio2 (mxfe3_gpio[2]),
    .mxfe3_gpio5 (mxfe3_gpio[3]),
    .mxfe3_gpio6 (mxfe3_gpio[4]),
    .mxfe3_gpio7 (mxfe3_gpio[5]),
    .mxfe3_gpio8 (mxfe3_gpio[6]),
    .mxfe3_gpio9 (mxfe3_gpio[7]),
    .mxfe3_gpio10 (mxfe3_gpio[8]),
    .mxfe3_syncin_1_n (mxfe_syncin_3_n),
    .mxfe3_syncin_1_p (mxfe_syncin_7_p),
    .mxfe3_syncout_1_n (mxfe_syncout_3_n),
    .mxfe3_syncout_1_p (mxfe_syncout_7_p),

    .gpio_t(gpio_t[127:64]),
    .gpio_i(gpio_i[127:64]),
    .gpio_o(gpio_o[127:64]));

  assign pmod1_5045_v2 = gpio_o[120];
  assign pmod1_5045_v1 = gpio_o[121];
  assign pmod1_ctrl_ind = gpio_o[122];
  assign pmod1_ctrl_rx_combined = gpio_o[123];

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
    // quad 121
    .rx_data_0_n (m2c_n[10]), // {10 15 8 4 11 9 14 13 12 3 1 2 6 0 7 5}
    .rx_data_0_p (m2c_p[10]),
    .rx_data_1_n (m2c_n[15]),
    .rx_data_1_p (m2c_p[15]),
    .rx_data_2_n (m2c_n[8]),
    .rx_data_2_p (m2c_p[8]),
    .rx_data_3_n (m2c_n[4]),
    .rx_data_3_p (m2c_p[4]),
    // quad 122
    .rx_data_4_n (m2c_n[11]),
    .rx_data_4_p (m2c_p[11]),
    .rx_data_5_n (m2c_n[9]),
    .rx_data_5_p (m2c_p[9]),
    .rx_data_6_n (m2c_n[14]),
    .rx_data_6_p (m2c_p[14]),
    .rx_data_7_n (m2c_n[13]),
    .rx_data_7_p (m2c_p[13]),
    // quad 125
    .rx_data_8_n (m2c_n[12]),
    .rx_data_8_p (m2c_p[12]),
    .rx_data_9_n (m2c_n[3]),
    .rx_data_9_p (m2c_p[3]),
    .rx_data_10_n (m2c_n[1]),
    .rx_data_10_p (m2c_p[1]),
    .rx_data_11_n (m2c_n[2]),
    .rx_data_11_p (m2c_p[2]),
    // quad 126
    .rx_data_12_n (m2c_n[6]),
    .rx_data_12_p (m2c_p[6]),
    .rx_data_13_n (m2c_n[0]),
    .rx_data_13_p (m2c_p[0]),
    .rx_data_14_n (m2c_n[7]),
    .rx_data_14_p (m2c_p[7]),
    .rx_data_15_n (m2c_n[5]),
    .rx_data_15_p (m2c_p[5]),
    // quad 121
    .tx_data_0_n (c2m_n[12]), // {12 14 10 4 11 9 8 3 1 2 13 15 6 0 7 5}
    .tx_data_0_p (c2m_p[12]),
    .tx_data_1_n (c2m_n[14]),
    .tx_data_1_p (c2m_p[14]),
    .tx_data_2_n (c2m_n[10]),
    .tx_data_2_p (c2m_p[10]),
    .tx_data_3_n (c2m_n[4]),
    .tx_data_3_p (c2m_p[4]),
    // quad 122
    .tx_data_4_n (c2m_n[11]),
    .tx_data_4_p (c2m_p[11]),
    .tx_data_5_n (c2m_n[9]),
    .tx_data_5_p (c2m_p[9]),
    .tx_data_6_n (c2m_n[8]),
    .tx_data_6_p (c2m_p[8]),
    .tx_data_7_n (c2m_n[3]),
    .tx_data_7_p (c2m_p[3]),
    // quad 125
    .tx_data_8_n (c2m_n[1]),
    .tx_data_8_p (c2m_p[1]),
    .tx_data_9_n (c2m_n[2]),
    .tx_data_9_p (c2m_p[2]),
    .tx_data_10_n (c2m_n[13]),
    .tx_data_10_p (c2m_p[13]),
    .tx_data_11_n (c2m_n[15]),
    .tx_data_11_p (c2m_p[15]),
    // quad 126
    .tx_data_12_n (c2m_n[6]),
    .tx_data_12_p (c2m_p[6]),
    .tx_data_13_n (c2m_n[0]),
    .tx_data_13_p (c2m_p[0]),
    .tx_data_14_n (c2m_n[7]),
    .tx_data_14_p (c2m_p[7]),
    .tx_data_15_n (c2m_n[5]),
    .tx_data_15_p (c2m_p[5]),
    .ref_clk_q0 (ref_clk),
    .ref_clk_q1 (ref_clk),
    .ref_clk_q2 (ref_clk_replica),
    .ref_clk_q3 (ref_clk_replica),
    .rx_device_clk (rx_device_clk),
    .tx_device_clk (tx_device_clk),
    .rx_sync_0 (link0_rx_syncout),
    .tx_sync_0 (link0_tx_syncin),
    .rx_sysref_0 (sysref),
    .tx_sysref_0 (sysref),
    .dac_fifo_bypass (dac_fifo_bypass),
    .gpio2_i (gpio_i[95:64]),
    .gpio2_o (gpio_o[95:64]),
    .gpio2_t (gpio_t[95:64]),
    .gpio3_i (gpio_i[127:96]),
    .gpio3_o (gpio_o[127:96]),
    .gpio3_t (gpio_t[127:96]),
    .ext_sync (sysref));

  assign link1_rx_syncout = 4'b1111;

endmodule
