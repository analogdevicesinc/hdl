// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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

//  EBZ_signal                FMCp_PORT      FMCp_PIN  FPGA_PIN  FPGA_PORT       FPGA_IO
//  FMC_GBTCLK0_M2C_P         GBTCLK0_M2C_P  D4        AK38      rx_ref_clk_0_p  MGTREFCLK0P_121
//  FMC_GBTCLK0_M2C_N         GBTCLK0_M2C_N  D5        AK39      rx_ref_clk_0_n  MGTREFCLK0N_121
//  FMC_DP0_M2C_P             DP0_M2C_P      C6        AR45      rx_data_p[0]    MGTYRXP0_121
//  FMC_DP0_M2C_N             DP0_M2C_N      C7        AR46      rx_data_n[0]    MGTYRXN0_121
//  FMC_DP1_M2C_P             DP1_M2C_P      A2        AN45      rx_data_p[1]    MGTYRXP1_121
//  FMC_DP1_M2C_N             DP1_M2C_N      A3        AN46      rx_data_n[1]    MGTYRXN1_121
//  FMC_DP2_M2C_P             DP2_M2C_P      A6        AL45      rx_data_p[2]    MGTYRXP2_121
//  FMC_DP2_M2C_N             DP2_M2C_N      A7        AL46      rx_data_n[2]    MGTYRXN2_121
//  FMC_DP3_M2C_P             DP3_M2C_P      A10       AJ45      rx_data_p[3]    MGTYRXP3_121
//  FMC_DP3_M2C_N             DP3_M2C_N      A11       AJ46      rx_data_n[3]    MGTYRXN3_121
//  FMC_DP4_M2C_P             DP4_M2C_P      A14       W45       rx_data_p[4]    MGTYRXP0_126
//  FMC_DP4_M2C_N             DP4_M2C_N      A15       W46       rx_data_n[4]    MGTYRXN0_126
//  FMC_DP5_M2C_P             DP5_M2C_P      A18       U45       rx_data_p[5]    MGTYRXP1_126
//  FMC_DP5_M2C_N             DP5_M2C_N      A19       U46       rx_data_n[5]    MGTYRXN1_126
//  FMC_DP6_M2C_P             DP6_M2C_P      B16       R45       rx_data_p[6]    MGTYRXP2_126
//  FMC_DP6_M2C_N             DP6_M2C_N      B17       R46       rx_data_n[6]    MGTYRXN2_126
//  FMC_DP7_M2C_P             DP7_M2C_P      B12       N45       rx_data_p[7]    MGTYRXP3_126
//  FMC_DP7_M2C_N             DP7_M2C_N      B13       N46       rx_data_n[7]    MGTYRXN3_126
//  FMC_GBTCLK0_M2C_P         GBTCLK0_M2C_P  D4        V38       rx_ref_clk_1_p  MGTREFCLK0P_126
//  FMC_GBTCLK0_M2C_N         GBTCLK0_M2C_N  D5        V39       rx_ref_clk_1_n  MGTREFCLK0N_126
//  FMC_DP8_M2C_P             DP8_M2C_P      B8        AG45      rx_data_p[8]    MGTYRXP0_122
//  FMC_DP8_M2C_N             DP8_M2C_N      B9        AG46      rx_data_n[8]    MGTYRXN0_122
//  FMC_DP9_M2C_P             DP9_M2C_P      B4        AF43      rx_data_p[9]    MGTYRXP1_122
//  FMC_DP9_M2C_N             DP9_M2C_N      B5        AF44      rx_data_n[9]    MGTYRXN1_122
//  FMC_DP10_M2C_P            DP10_M2C_P     Y10       AE45      rx_data_p[10]   MGTYRXP2_122
//  FMC_DP10_M2C_N            DP10_M2C_N     Y11       AE46      rx_data_n[10]   MGTYRXN2_122
//  FMC_DP11_M2C_P            DP11_M2C_P     Z12       AD43      rx_data_p[11]   MGTYRXP3_122
//  FMC_DP11_M2C_N            DP11_M2C_N     Z13       AD44      rx_data_n[11]   MGTYRXN3_122
//  FMC_DP12_M2C_P            DP12_M2C_P     Y14       AC45      rx_data_p[12]   MGTYRXP0_125
//  FMC_DP12_M2C_N            DP12_M2C_N     Y15       AC46      rx_data_n[12]   MGTYRXN0_125
//  FMC_DP13_M2C_P            DP13_M2C_P     Z16       AB43      rx_data_p[13]   MGTYRXP1_125
//  FMC_DP13_M2C_N            DP13_M2C_N     Z17       AB44      rx_data_n[13]   MGTYRXN1_125
//  FMC_DP14_M2C_P            DP14_M2C_P     Y18       AA45      rx_data_p[14]   MGTYRXP2_125
//  FMC_DP14_M2C_N            DP14_M2C_N     Y19       AA46      rx_data_n[14]   MGTYRXN2_125
//  FMC_DP15_M2C_P            DP15_M2C_P     Y22       Y43       rx_data_p[15]   MGTYRXP3_125
//  FMC_DP15_M2C_N            DP15_M2C_N     Y23       Y44       rx_data_n[15]   MGTYRXN3_125
//  FMC_GBTCLK2_M2C_P         GBTCLK2_M2C_P  L12       AF38      glbl_clk_0_p    MGTREFCLK0P_122
//  FMC_GBTCLK2_M2C_N         GBTCLK2_M2C_N  L13       AF39      glbl_clk_0_n    MGTREFCLK0N_122
//  FMC_LA02_P                LA02_P         H7        AJ32      rx_sysref_0_p   IO_L14P_T2L_N2_GC_43
//  FMC_LA02_N                LA02_N         H8        AK32      rx_sysref_0_n   IO_L14N_T2L_N3_GC_43
//  FMC_LA04_P                LA04_P         H10       AR37      rx_sync_0_p     IO_L6P_T0U_N10_AD6P_43
//  FMC_LA04_N                LA04_N         H11       AT37      rx_sync_0_n     IO_L6N_T0U_N11_AD6N_43
//  FMC_LA01_P                LA01_P_CC      D8        AL30      glbl_clk_1_p    IO_L16P_T2U_N6_QBC_AD3P_43
//  FMC_LA01_N                LA01_N_CC      D9        AL31      glbl_clk_1_n    IO_L16N_T2U_N7_QBC_AD3N_43
//  FMC_LA03_P                LA03_P         G9        AT39      rx_sysref_1_p   IO_L4P_T0U_N6_DBC_AD7P_43
//  FMC_LA03_N                LA03_N         G10       AT40      rx_sysref_1_n   IO_L4N_T0U_N7_DBC_AD7N_43
//  FMC_LA05_P                LA05_P         D11       AP38      rx_sync_1_p     IO_L1P_T0L_N0_DBC_43
//  FMC_LA05_N                LA05_N         D12       AR38      rx_sync_1_n     IO_L1N_T0L_N1_DBC_43
//  SCLK_FROM_FPGA            LA06_P         C10       AT35      spi_clk         IO_L2P_T0L_N2_43
//  SDIO_FROM_FPGA            LA06_N         C11       AT36      spi_sdio        IO_L2N_T0L_N3_43
//  HMC7044_CSB_FROM_FPGA     LA07_P         H13       AP36      spi_csn_clk     IO_L5P_T0U_N8_AD14P_43
//  ADC0_CSB_FROM_FPGA        LA07_N         H14       AP37      spi_csn_adc0    IO_L5N_T0U_N9_AD14N_43
//  ADC1_CSB_FROM_FPGA        LA08_P         G12       AK29      spi_csn_adc1    IO_L18P_T2U_N10_AD2P_43
//  DUTA_FDA_TO_FPGA          LA09_N         D15       AK33      adc0_fda        IO_L19N_T3L_N1_DBC_AD9N_43
//  DUTA_FDB_TO_FPGA          LA10_N         C15       AR35      adc0_fdb        IO_L3N_T0L_N5_AD15N_43
//  DUTA_GPIO_A1_TO_FPGA      LA11_N         H17       AJ31      adc0_gpio_a1    IO_L17N_T2U_N9_AD10N_43
//  DUTA_GPIO_B1_TO_FPGA      LA12_N         G16       AH34      adc0_gpio_b1    IO_L21N_T3L_N5_AD8N_43
//  DUTA_PDWN_TO_FPGA         LA08_N         G13       AK30      adc0_pdwn       IO_L18N_T2U_N11_AD2N_43
//  DUTB_FDA_TO_FPGA          LA10_P         C14       AP35      adc1_fda        IO_L3P_T0L_N4_AD15P_43
//  DUTB_FDB_TO_FPGA          LA11_P         H16       AJ30      adc1_fdb        IO_L17P_T2U_N8_AD10P_43
//  DUTB_GPIO_A1_TO_FPGA      LA12_P         G15       AH33      adc1_gpio_a1    IO_L21P_T3L_N4_AD8P_43
//  DUTB_GPIO_B1_TO_FPGA      LA13_P         D17       AJ35      adc1_gpio_b1    IO_L20P_T3L_N2_AD1P_43
//  DUTB_PDWN_TO_FPGA         LA09_P         D14       AJ33      adc1_pdwn       IO_L19P_T3L_N0_DBC_AD9P_43
//  HMC7044_SYNC_REQ_TO_FPGA  LA13_N         D18       AJ36      hmc_sync_req    IO_L20N_T3L_N3_AD1N_43

module system_top (

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  input                   uart_sin,
  output                  uart_sout,

  output                  ddr4_act_n,
  output      [16:0]      ddr4_addr,
  output      [ 1:0]      ddr4_ba,
  output      [ 0:0]      ddr4_bg,
  output                  ddr4_ck_p,
  output                  ddr4_ck_n,
  output      [ 0:0]      ddr4_cke,
  output      [ 0:0]      ddr4_cs_n,
  inout       [ 7:0]      ddr4_dm_n,
  inout       [63:0]      ddr4_dq,
  inout       [ 7:0]      ddr4_dqs_p,
  inout       [ 7:0]      ddr4_dqs_n,
  output      [ 0:0]      ddr4_odt,
  output                  ddr4_reset_n,

  output                  mdio_mdc,
  inout                   mdio_mdio,
  input                   phy_clk_p,
  input                   phy_clk_n,
  output                  phy_rst_n,
  input                   phy_rx_p,
  input                   phy_rx_n,
  output                  phy_tx_p,
  output                  phy_tx_n,

  inout       [16:0]      gpio_bd,

  output                  iic_rstn,
  inout                   iic_scl,
  inout                   iic_sda,

  // FMC+ IOs

  input                   rx_ref_clk_0_p,
  input                   rx_ref_clk_0_n,
  input                   rx_ref_clk_1_p,
  input                   rx_ref_clk_1_n,
  input       [15:0]      rx_data_p,
  input       [15:0]      rx_data_n,

  input                   glbl_clk_0_p,
  input                   glbl_clk_0_n,
  input                   rx_sysref_0_p,
  input                   rx_sysref_0_n,
  output                  rx_sync_0_p,
  output                  rx_sync_0_n,

  input                   glbl_clk_1_p,
  input                   glbl_clk_1_n,
  input                   rx_sysref_1_p,
  input                   rx_sysref_1_n,
  output                  rx_sync_1_p,
  output                  rx_sync_1_n,

  output                  spi_clk,
  inout                   spi_sdio,
  output                  spi_csn_clk,
  output                  spi_csn_adc0,
  output                  spi_csn_adc1,

  inout                   adc0_fda,
  inout                   adc0_fdb,
  inout                   adc0_gpio_a1,
  inout                   adc0_gpio_b1,
  inout                   adc0_pdwn,

  inout                   adc1_fda,
  inout                   adc1_fdb,
  inout                   adc1_gpio_a1,
  inout                   adc1_gpio_b1,
  inout                   adc1_pdwn,

  inout                   hmc_sync_req
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 7:0]  spi_csn;
  wire            spi_mosi;
  wire            spi_miso;
  wire            trig;
  wire            rx_ref_clk_0;
  wire            rx_ref_clk_1;
  wire            rx_sysref;
  wire            rx_sync;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire            tx_sync;

  assign iic_rstn = 1'b1;

  // spi

  assign spi_csn_clk  = spi_csn[0];
  assign spi_csn_adc0 = spi_csn[1];
  assign spi_csn_adc1 = spi_csn[2];

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk_0 (
    .CEB (1'd0),
    .I (rx_ref_clk_0_p),
    .IB (rx_ref_clk_0_n),
    .O (rx_ref_clk_0),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_rx_ref_clk_1 (
    .CEB (1'd0),
    .I (rx_ref_clk_1_p),
    .IB (rx_ref_clk_1_n),
    .O (rx_ref_clk_1),
    .ODIV2 ());

  IBUFDS i_ibufds_rx_sysref_0 (
    .I (rx_sysref_0_p),
    .IB (rx_sysref_0_n),
    .O (rx_sysref_0));

  IBUFDS i_ibufds_rx_sysref_1 (
    .I (rx_sysref_1_p),
    .IB (rx_sysref_1_n),
    .O (rx_sysref_1));

  OBUFDS i_obufds_rx_sync_0 (
    .I (rx_sync_0),
    .O (rx_sync_0_p),
    .OB (rx_sync_0_n));

  OBUFDS i_obufds_rx_sync_1 (
    .I (rx_sync_1),
    .O (rx_sync_1_p),
    .OB (rx_sync_1_n));

  IBUFDS_GTE4 #(
    .REFCLK_HROW_CK_SEL(2'b00)
  ) i_ibufds_glbl_clk_0 (
    .I (glbl_clk_0_p),
    .IB (glbl_clk_0_n),
    .ODIV2 (glbl_clk_0));

  BUFG_GT i_bufg(
    .I (glbl_clk_0),
    .O (glbl_clk_buf));

  daq3_spi i_spi (
    .spi_csn (spi_csn[2:0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio),
    .spi_dir ());

  ad_iobuf #(
    .DATA_WIDTH(11)
  ) i_iobuf (
    .dio_t (gpio_t[42:32]),
    .dio_i (gpio_o[42:32]),
    .dio_o (gpio_i[42:32]),
    .dio_p ({ adc0_fda,         // 42
              adc0_fdb,         // 41
              adc1_fda,         // 40
              adc1_fdb,         // 39
              adc0_gpio_a1,     // 38
              adc1_gpio_a1,     // 37
              adc0_gpio_b1,     // 36
              adc1_gpio_b1,     // 35
              adc0_pdwn,        // 34
              adc1_pdwn,        // 33
              hmc_sync_req}));  // 32

  ad_iobuf #(
    .DATA_WIDTH(17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:43] = gpio_o[63:43];
  assign gpio_i[31:17] = gpio_o[31:17];

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
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    // FMC+
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_data_4_n (rx_data_n[4]),
    .rx_data_4_p (rx_data_p[4]),
    .rx_data_5_n (rx_data_n[5]),
    .rx_data_5_p (rx_data_p[5]),
    .rx_data_6_n (rx_data_n[6]),
    .rx_data_6_p (rx_data_p[6]),
    .rx_data_7_n (rx_data_n[7]),
    .rx_data_7_p (rx_data_p[7]),
    .rx_data_1_0_n (rx_data_n[8]),
    .rx_data_1_0_p (rx_data_p[8]),
    .rx_data_1_1_n (rx_data_n[9]),
    .rx_data_1_1_p (rx_data_p[9]),
    .rx_data_1_2_n (rx_data_n[10]),
    .rx_data_1_2_p (rx_data_p[10]),
    .rx_data_1_3_n (rx_data_n[11]),
    .rx_data_1_3_p (rx_data_p[11]),
    .rx_data_1_4_n (rx_data_n[12]),
    .rx_data_1_4_p (rx_data_p[12]),
    .rx_data_1_5_n (rx_data_n[13]),
    .rx_data_1_5_p (rx_data_p[13]),
    .rx_data_1_6_n (rx_data_n[14]),
    .rx_data_1_6_p (rx_data_p[14]),
    .rx_data_1_7_n (rx_data_n[15]),
    .rx_data_1_7_p (rx_data_p[15]),

    .rx_ref_clk_0 (rx_ref_clk_0),
    .rx_ref_clk_1 (rx_ref_clk_1),
    .glbl_clk_0 (glbl_clk_buf),
    .rx_sync_0 (rx_sync_0),
    .rx_sync_1_0 (rx_sync_1),
    .rx_sysref_0 (rx_sysref_0),
    .rx_sysref_1_0 (rx_sysref_0));

endmodule
