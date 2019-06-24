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

/*
Interface to FMC connector overview

system_top                     9009_FMC         FMC                           FPGA
                              -------------|--------------------------------|-----
input  ref_clk0_p,   (DNI)   FPGA_REF_CLK+      D4     FMC_HPC_GBTCLK0_M2C_P AD10
input  ref_clk0_n,   (DNI)   FPGA_REF_CLK-      D5     FMC_HPC_GBTCLK0_M2C_N AD9
input  ref_clk1_p,           FPGA_REF_CLK+      B20    FMC_HPC_GBTCLK1_M2C_P AA8
input  ref_clk1_n,           FPGA_REF_CLK-      B21    FMC_HPC_GBTCLK1_M2C_N AA7
input  rx_data_p[0],         SERDOUT0+          A2     FMC_HPC_DP1_M2C_P     AJ8
input  rx_data_n[0],         SERDOUT0-          A3     FMC_HPC_DP1_M2C_N     AJ7
input  rx_data_p[1],         SERDOUT1+          A6     FMC_HPC_DP2_M2C_P     AG8
input  rx_data_n[1],         SERDOUT1-          A7     FMC_HPC_DP2_M2C_N     AG7
input  rx_data_p[2],         SERDOUT2+          C6     FMC_HPC_DP0_M2C_P     AH10
input  rx_data_n[2],         SERDOUT2-          C7     FMC_HPC_DP0_M2C_N     AH9
input  rx_data_p[3],         SERDOUT3+          A10    FMC_HPC_DP3_M2C_P     AE8
input  rx_data_n[3],         SERDOUT3-          A11    FMC_HPC_DP3_M2C_N     AE7
output tx_data_p[0],         SERDIN0+           A22    FMC_HPC_DP1_C2M_P     AK6
output tx_data_n[0],         SERDIN0-           A23    FMC_HPC_DP1_C2M_N     AK5
output tx_data_p[1],         SERDIN3+           A26    FMC_HPC_DP2_C2M_P     AJ4
output tx_data_n[1],         SERDIN3-           A27    FMC_HPC_DP2_C2M_N     AJ3
output tx_data_p[2],         SERDIN2+           C2     FMC_HPC_DP0_C2M_P     AK10
output tx_data_n[2],         SERDIN2-           C3     FMC_HPC_DP0_C2M_N     AK9
output tx_data_p[3],         SERDIN1+           A30    FMC_HPC_DP3_C2M_P     AK2
output tx_data_n[3],         SERDIN1-           A31    FMC_HPC_DP3_C2M_N     AK1
output rx_sync_p,            SYNCINB0+          G9     FMC_HPC_LA03_P        AH19
output rx_sync_n,            SYNCINB0-          G10    FMC_HPC_LA03_N        AJ19
output rx_os_sync_p,         SYNCINB1+          G27    FMC_HPC_LA25_P        T29
output rx_os_sync_n,         SYNCINB1-          G28    FMC_HPC_LA25_N        U29
input  tx_sync_p,            SYNCOUTB0+         H7     FMC_HPC_LA02_P        AK17
input  tx_sync_n,            SYNCOUTB0-         H8     FMC_HPC_LA02_N        AK18
input  tx_sync_1_p,          SYNCOUTB1+         H28    FMC_HPC_LA24_P        T30
input  tx_sync_1_n,          SYNCOUTB1-         H29    FMC_HPC_LA24_N        U30
input  sysref_p,             FPGA_SYSREF+       G6     FMC_HPC_LA00_CC_P     AF20
input  sysref_n,             FPGA_SYSREF-       G7     FMC_HPC_LA00_CC_N     AG20

output sysref_out_p,         FPGA_SYSREF_OUT+   D8     FMC_HPC_LA01_CC_P     AG21
output sysref_out_n,         FPGA_SYSREF_OUT-   D9     FMC_HPC_LA01_CC_N     AH21

output spi_csn_ad9528,       SPI_CS1            D15    FMC_HPC_LA09_N        AE21
output spi_csn_adrv9009,     SPI_CS0            D14    FMC_HPC_LA09_P        AD21
output spi_clk,              SPI_CLK            H13    FMC_HPC_LA07_P        AJ23
output spi_mosi,             SPI_DIN            H14    FMC_HPC_LA07_N        AJ24
input  spi_miso,             SPI_DOUT           G12    FMC_HPC_LA08_P        AF19

inout  ad9528_reset_b,       FMC_CLK_RESETB     D26    FMC_HPC_LA26_P        R28
inout  ad9528_sysref_req,    FMC_SYSREF_REQUEST D27    FMC_HPC_LA26_N        T28
inout  adrv9009_tx1_enable,  TX1_ENABLE         D17    FMC_HPC_LA13_P        AA22
inout  adrv9009_tx2_enable,  TX2_ENABLE         C18    FMC_HPC_LA14_P        AC24
inout  adrv9009_rx1_enable,  RX1_ENABLE         D18    FMC_HPC_LA13_N        AA23
inout  adrv9009_rx2_enable,  RX2_ENABLE         C19    FMC_HPC_LA14_N        AD24
inout  adrv9009_test,        TEST               H16    FMC_HPC_LA11_P        AD23
inout  adrv9009_reset_b,     RESETB             H10    FMC_HPC_LA04_P        AJ20
inout  adrv9009_gpint,       GP_INTERRUPT       H11    FMC_HPC_LA04_N        AK20

inout  adrv9009_gpio_00,     GPIO_0             H19    FMC_HPC_LA15_P        Y22
inout  adrv9009_gpio_01,     GPIO_1             H20    FMC_HPC_LA15_N        Y23
inout  adrv9009_gpio_02,     GPIO_2             G18    FMC_HPC_LA16_P        AA24
inout  adrv9009_gpio_03,     GPIO_3             G19    FMC_HPC_LA16_N        AB24
inout  adrv9009_gpio_04,     GPIO_4             H25    FMC_HPC_LA21_P        W29
inout  adrv9009_gpio_05,     GPIO_5             H26    FMC_HPC_LA21_N        W30
inout  adrv9009_gpio_06,     GPIO_6             C22    FMC_HPC_LA18_CC_P     W25
inout  adrv9009_gpio_07,     GPIO_7             C23    FMC_HPC_LA18_CC_N     W26
inout  adrv9009_gpio_08,     GPIO_8             G25    FMC_HPC_LA22_N        W28
inout  adrv9009_gpio_09,     GPIO_9             H22    FMC_HPC_LA19_P        T24
inout  adrv9009_gpio_10,     GPIO_10            H23    FMC_HPC_LA19_N        T25
inout  adrv9009_gpio_11,     GPIO_11            G21    FMC_HPC_LA20_P        U25
inout  adrv9009_gpio_12,     GPIO_12            G22    FMC_HPC_LA20_N        V26
inout  adrv9009_gpio_13,     GPIO_13            G16    FMC_HPC_LA12_N        AF24
inout  adrv9009_gpio_14,     GPIO_14            G15    FMC_HPC_LA12_P        AF23
inout  adrv9009_gpio_15,     GPIO_15            G24    FMC_HPC_LA22_P        V27
inout  adrv9009_gpio_16,     GPIO_16            C11    FMC_HPC_LA06_N        AH22
inout  adrv9009_gpio_17,     GPIO_17            C10    FMC_HPC_LA06_P        AG22
inout  adrv9009_gpio_18,     GPIO_18            H17    FMC_HPC_LA11_N        AE23
*/

module system_top (

  inout       [14:0]      ddr_addr,
  inout       [ 2:0]      ddr_ba,
  inout                   ddr_cas_n,
  inout                   ddr_ck_n,
  inout                   ddr_ck_p,
  inout                   ddr_cke,
  inout                   ddr_cs_n,
  inout       [ 3:0]      ddr_dm,
  inout       [31:0]      ddr_dq,
  inout       [ 3:0]      ddr_dqs_n,
  inout       [ 3:0]      ddr_dqs_p,
  inout                   ddr_odt,
  inout                   ddr_ras_n,
  inout                   ddr_reset_n,
  inout                   ddr_we_n,

  inout                   fixed_io_ddr_vrn,
  inout                   fixed_io_ddr_vrp,
  inout       [53:0]      fixed_io_mio,
  inout                   fixed_io_ps_clk,
  inout                   fixed_io_ps_porb,
  inout                   fixed_io_ps_srstb,

  inout       [14:0]      gpio_bd,

  output                  hdmi_out_clk,
  output                  hdmi_vsync,
  output                  hdmi_hsync,
  output                  hdmi_data_e,
  output      [23:0]      hdmi_data,

  output                  spdif,

  inout                   iic_scl,
  inout                   iic_sda,

  input                   ref_clk0_p,
  input                   ref_clk0_n,
  input                   ref_clk1_p,
  input                   ref_clk1_n,
  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,
  output      [ 3:0]      tx_data_p,
  output      [ 3:0]      tx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  output                  rx_os_sync_p,
  output                  rx_os_sync_n,
  input                   tx_sync_p,
  input                   tx_sync_n,
  input                   tx_sync_1_p,
  input                   tx_sync_1_n,
  input                   sysref_p,
  input                   sysref_n,

  output                  sysref_out_p,
  output                  sysref_out_n,

  output                  spi_csn_ad9528,
  output                  spi_csn_adrv9009,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   ad9528_reset_b,
  inout                   ad9528_sysref_req,
  inout                   adrv9009_tx1_enable,
  inout                   adrv9009_tx2_enable,
  inout                   adrv9009_rx1_enable,
  inout                   adrv9009_rx2_enable,
  inout                   adrv9009_test,
  inout                   adrv9009_reset_b,
  inout                   adrv9009_gpint,

  inout                   adrv9009_gpio_00,
  inout                   adrv9009_gpio_01,
  inout                   adrv9009_gpio_02,
  inout                   adrv9009_gpio_03,
  inout                   adrv9009_gpio_04,
  inout                   adrv9009_gpio_05,
  inout                   adrv9009_gpio_06,
  inout                   adrv9009_gpio_07,
  inout                   adrv9009_gpio_15,
  inout                   adrv9009_gpio_08,
  inout                   adrv9009_gpio_09,
  inout                   adrv9009_gpio_10,
  inout                   adrv9009_gpio_11,
  inout                   adrv9009_gpio_12,
  inout                   adrv9009_gpio_14,
  inout                   adrv9009_gpio_13,
  inout                   adrv9009_gpio_17,
  inout                   adrv9009_gpio_16,
  inout                   adrv9009_gpio_18,

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  output      [13:0]      ddr3_addr,
  output      [ 2:0]      ddr3_ba,
  output                  ddr3_cas_n,
  output      [ 0:0]      ddr3_ck_n,
  output      [ 0:0]      ddr3_ck_p,
  output      [ 0:0]      ddr3_cke,
  output      [ 0:0]      ddr3_cs_n,
  output      [ 7:0]      ddr3_dm,
  inout       [63:0]      ddr3_dq,
  inout       [ 7:0]      ddr3_dqs_n,
  inout       [ 7:0]      ddr3_dqs_p,
  output      [ 0:0]      ddr3_odt,
  output                  ddr3_ras_n,
  output                  ddr3_reset_n,
  output                  ddr3_we_n);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire            ref_clk0;
  wire            ref_clk1;
  wire            rx_sync;
  wire            rx_os_sync;
  wire            tx_sync;
  wire            tx_sync_1;
  wire            sysref;
  wire            sysref_out;

  assign sysref_out = 0;
  assign gpio_i[63:60] = gpio_o[63:60];
  assign gpio_i[31:15] = gpio_o[31:15];

  // instantiations

  IBUFDS_GTE2 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 ());

  IBUFDS_GTE2 i_ibufds_ref_clk1 (
    .CEB (1'd0),
    .I (ref_clk1_p),
    .IB (ref_clk1_n),
    .O (ref_clk1),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_os_sync (
    .I (rx_os_sync),
    .O (rx_os_sync_p),
    .OB (rx_os_sync_n));

  OBUFDS i_obufds_sysref_out (
    .I (sysref_out),
    .O (sysref_out_p),
    .OB (sysref_out_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_1_p),
    .IB (tx_sync_1_n),
    .O (tx_sync_1));

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  ad_iobuf #(.DATA_WIDTH(28)) i_iobuf (
    .dio_t ({gpio_t[59:32]}),
    .dio_i ({gpio_o[59:32]}),
    .dio_o ({gpio_i[59:32]}),
    .dio_p ({ ad9528_reset_b,       // 59
              ad9528_sysref_req,    // 58
              adrv9009_tx1_enable,  // 57
              adrv9009_tx2_enable,  // 56
              adrv9009_rx1_enable,  // 55
              adrv9009_rx2_enable,  // 54
              adrv9009_test,        // 53
              adrv9009_reset_b,     // 52
              adrv9009_gpint,       // 51
              adrv9009_gpio_00,     // 50
              adrv9009_gpio_01,     // 49
              adrv9009_gpio_02,     // 48
              adrv9009_gpio_03,     // 47
              adrv9009_gpio_04,     // 46
              adrv9009_gpio_05,     // 45
              adrv9009_gpio_06,     // 44
              adrv9009_gpio_07,     // 43
              adrv9009_gpio_15,     // 42
              adrv9009_gpio_08,     // 41
              adrv9009_gpio_09,     // 40
              adrv9009_gpio_10,     // 39
              adrv9009_gpio_11,     // 38
              adrv9009_gpio_12,     // 37
              adrv9009_gpio_14,     // 36
              adrv9009_gpio_13,     // 35
              adrv9009_gpio_17,     // 34
              adrv9009_gpio_16,     // 33
              adrv9009_gpio_18}));  // 32

  ad_iobuf #(.DATA_WIDTH(15)) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .dac_fifo_bypass (gpio_o[60]),
    .adc_fir_filter_active (gpio_o[61]),
    .dac_fir_filter_active (gpio_o[62]),
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_odt (ddr3_odt),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_we_n (ddr3_we_n),
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk_0 (ref_clk1),
    .rx_ref_clk_2 (ref_clk1),
    .rx_sync_0 (rx_sync),
    .rx_sync_2 (rx_os_sync),
    .rx_sysref_0 (sysref),
    .rx_sysref_2 (sysref),
    .spdif (spdif),
    .spi0_clk_i (spi_clk),
    .spi0_clk_o (spi_clk),
    .spi0_csn_0_o (spi_csn_ad9528),
    .spi0_csn_1_o (spi_csn_adrv9009),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi_miso),
    .spi0_sdo_i (spi_mosi),
    .spi0_sdo_o (spi_mosi),
    .spi1_clk_i (1'd0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'd0),
    .spi1_sdo_i (1'd0),
    .spi1_sdo_o (),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst(sys_rst),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_ref_clk_0 (ref_clk1),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref));

endmodule

// ***************************************************************************
// ***************************************************************************
