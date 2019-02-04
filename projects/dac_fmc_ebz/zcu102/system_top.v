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

system_top    FMC_EBZ         FMC                            FPGA
              -------------|--------------------------------|-------------------------------------
NC            BR40_EXT_N      B21  FMC_HPC0_GBTCLK1_M2C_C_N  L7     MGTREFCLK0N_228_L7
NC            BR40_EXT_P      B20  FMC_HPC0_GBTCLK1_M2C_C_P  L8     MGTREFCLK0P_228_L8
tx_ref_clk_n  BR40_N          D05  FMC_HPC0_GBTCLK0_M2C_C_N  G7     MGTREFCLK0N_229_G7
tx_ref_clk_p  BR40_P          D04  FMC_HPC0_GBTCLK0_M2C_C_P  G8     MGTREFCLK0P_229_G8
spi_csn_dac   FMC_CS1         H11  FMC_HPC0_LA04_N           AA1    IO_L21N_T3L_N5_AD8N_66_AA1
spi_csn_clk   FMC_CS2         D11  FMC_HPC0_LA05_P           AB3    IO_L20P_T3L_N2_AD1P_66_AB3
spi_miso      FMC_MISO        H10  FMC_HPC0_LA04_P           AA2    IO_L21P_T3L_N4_AD8P_66_AA2
spi_mosi      FMC_MOSI        G10  FMC_HPC0_LA03_N           Y1     IO_L22N_T3U_N7_DBC_AD0N_66_Y1
spi_clk       FMC_SCK         G09  FMC_HPC0_LA03_P           Y2     IO_L22P_T3U_N6_DBC_AD0P_66_Y2
spi_en        FMC_SPI_EN      D12  FMC_HPC0_LA05_N           AC3    IO_L20N_T3L_N3_AD1N_66_AC3

pe_ctrl       FMC_PE_CTRL     H13  FMC_HPC0_LA07_P           U5     IO_L18P_T2U_N10_AD2P_66_U5
txen[0]       FMC_TXEN_0      C10  FMC_HPC0_LA06_P           AC2    IO_L19P_T3L_N0_DBC_AD9P_66_AC2
txen[1]       FMC_TXEN_1      C11  FMC_HPC0_LA06_N           AC1    IO_L19N_T3L_N1_DBC_AD9N_66_AC1

tx_data_p[0]  SERDIN0_N       A38  FMC_HPC0_DP5_C2M_P        P6     MGTHTXP1_228_P6
tx_data_n[0]  SERDIN0_P       A39  FMC_HPC0_DP5_C2M_N        P5     MGTHTXN1_228_P5
tx_data_p[1]  SERDIN1_N       B36  FMC_HPC0_DP6_C2M_P        R4     MGTHTXP0_228_R4
tx_data_n[1]  SERDIN1_P       B37  FMC_HPC0_DP6_C2M_N        R3     MGTHTXN0_228_R3
tx_data_p[2]  SERDIN2_N       A34  FMC_HPC0_DP4_C2M_P        M6     MGTHTXP3_228_M6
tx_data_n[2]  SERDIN2_P       A35  FMC_HPC0_DP4_C2M_N        M5     MGTHTXN3_228_M5
tx_data_p[3]  SERDIN3_N       B32  FMC_HPC0_DP7_C2M_P        N4     MGTHTXP2_228_N4
tx_data_n[3]  SERDIN3_P       B33  FMC_HPC0_DP7_C2M_N        N3     MGTHTXN2_228_N3
tx_data_p[4]  SERDIN4_P       A30  FMC_HPC0_DP3_C2M_P        K6     MGTHTXP0_229_K6
tx_data_n[4]  SERDIN4_N       A31  FMC_HPC0_DP3_C2M_N        K5     MGTHTXN0_229_K5
tx_data_p[5]  SERDIN5_P       A26  FMC_HPC0_DP2_C2M_P        F6     MGTHTXP3_229_F6
tx_data_n[5]  SERDIN5_N       A27  FMC_HPC0_DP2_C2M_N        F5     MGTHTXN3_229_F5
tx_data_p[6]  SERDIN6_P       A22  FMC_HPC0_DP1_C2M_P        H6     MGTHTXP1_229_H6
tx_data_n[6]  SERDIN6_N       A23  FMC_HPC0_DP1_C2M_N        H5     MGTHTXN1_229_H5
tx_data_p[7]  SERDIN7_P       C02  FMC_HPC0_DP0_C2M_P        G4     MGTHTXP2_229_G4
tx_data_n[7]  SERDIN7_N       C03  FMC_HPC0_DP0_C2M_N        G3     MGTHTXN2_229_G3
tx_sync_p[0]  SYNC0_P         D08  FMC_HPC0_LA01_CC_P        AB4    IO_L16P_T2U_N6_QBC_AD3P_66_AB4
tx_sync_n[0]  SYNC0_N         D09  FMC_HPC0_LA01_CC_N        AC4    IO_L16N_T2U_N7_QBC_AD3N_66_AC4
NC            SYNC1_N         H08  FMC_HPC0_LA02_N           V1     IO_L23N_T3U_N9_66_V1
NC            SYNC1_P         H07  FMC_HPC0_LA02_P           V2     IO_L23P_T3U_N8_66_V2
tx_sysref_n   SYSREF2_N       G07  FMC_HPC0_LA00_CC_N        Y3     IO_L13N_T2L_N1_GC_QBC_66_Y3
tx_sysref_p   SYSREF2_P       G06  FMC_HPC0_LA00_CC_P        Y4     IO_L13P_T2L_N0_GC_QBC_66_Y4
*/

module system_top #(
    parameter JESD_L = 4,
    parameter NUM_LINKS = 2,
    parameter DEVICE_CODE = 0
  ) (

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  input           tx_ref_clk_p,
  input           tx_ref_clk_n,
  input           tx_sysref_p,
  input           tx_sysref_n,
  input   [ 1:0]  tx_sync_p,
  input   [ 1:0]  tx_sync_n,
  output  [JESD_L*NUM_LINKS-1:0] tx_data_p,
  output  [JESD_L*NUM_LINKS-1:0] tx_data_n,

  output          spi_csn_dac,
  output          spi_csn_clk,
  output          spi_csn_clk2,
  input           spi_miso,
  output          spi_mosi,
  output          spi_clk,
  output          spi_en,

  inout   [ 4:0]  dac_ctrl,

  output          pmod_spi_clk,
  output          pmod_spi_csn,
  output          pmod_spi_mosi,
  input           pmod_spi_miso,
  inout   [ 3:0]  pmod_gpio
);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  wire    [ 2:0]  spi0_csn;
  wire    [ 2:0]  spi1_csn;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire    [ 1:0]  tx_sync;
  wire    [ 7:0]  tx_data_p_loc;
  wire    [ 7:0]  tx_data_n_loc;
  wire            tx_sysref_loc;

  // spi

  // spi_en is active ...
  //   ... high for AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ,
  //   ... low for AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
  // If you are planning to build a bitstream for just one of those boards you
  // can hardwire the logic level here.
  //
  // assign spi_en = 1'bz;

  //                                        9135/9144/9172    916(1,2,3,4)
  assign spi_csn_dac  = spi0_csn[1];
  assign spi_csn_clk  = spi0_csn[0];    //   HMC7044          AD9508
  assign spi_csn_clk2 = spi0_csn[2];    //   NC               ADF4355

  /* JESD204 clocks and control signals */
  IBUFDS_GTE4 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ()
  );

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref)
  );

  IBUFDS i_ibufds_tx_sync_0 (
    .I (tx_sync_p[0]),
    .IB (tx_sync_n[0]),
    .O (tx_sync[0])
  );

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_p[1]),
    .IB (tx_sync_n[1]),
    .O (tx_sync[1])
  );

  /* FMC GPIOs */
  ad_iobuf #(
    .DATA_WIDTH(6)
  ) i_iobuf (
    .dio_t (gpio_t[21+:6]),
    .dio_i (gpio_o[21+:6]),
    .dio_o (gpio_i[21+:6]),
    .dio_p ({
      spi_en,            /*      26 */
      dac_ctrl           /* 25 - 21 */
    })
  );

  /*
  * Control signals for different FMC boards:
  *
  * dac_ctrl  FMC   9144 like    9162 like       9172 like
  *        0  H13   FMC_TXEN_0   FMC_TXEN_0      FMC_PE_CTRL
  *        1  C10   NC           NC              FMC_TXEN_0
  *        2  C11   NC           NC              FMC_TXEN_1
  *        3  H14   FMC_TXEN_1   NC              NC
  *        4  D15   NC           FMC_HMC849VCTL  NC          
  */

  assign dac_fifo_bypass = gpio_o[40];

  /* PMOD GPIOs 48-51 */
  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_iobuf_pmod (
    .dio_t (gpio_t[48+:4]),
    .dio_i (gpio_o[48+:4]),
    .dio_o (gpio_i[48+:4]),
    .dio_p (pmod_gpio)
  );

  /* PMOD SPI */
  assign pmod_spi_csn = spi1_csn[0];

  /* Board GPIOS. Buttons, LEDs, etc... */
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:52] = gpio_o[94:52];
  assign gpio_i[47:32] = gpio_o[47:32];
  assign gpio_i[31:27] = gpio_o[31:27];
  assign gpio_i[ 7: 0] = gpio_o[7:0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi0_sclk (spi_clk),
    .spi1_csn (spi1_csn),
    .spi1_miso (pmod_spi_miso),
    .spi1_mosi (pmod_spi_mosi),
    .spi1_sclk (pmod_spi_clk),
    .tx_data_0_n (tx_data_n_loc[0]),
    .tx_data_0_p (tx_data_p_loc[0]),
    .tx_data_1_n (tx_data_n_loc[1]),
    .tx_data_1_p (tx_data_p_loc[1]),
    .tx_data_2_n (tx_data_n_loc[2]),
    .tx_data_2_p (tx_data_p_loc[2]),
    .tx_data_3_n (tx_data_n_loc[3]),
    .tx_data_3_p (tx_data_p_loc[3]),
    .tx_data_4_n (tx_data_n_loc[4]),
    .tx_data_4_p (tx_data_p_loc[4]),
    .tx_data_5_n (tx_data_n_loc[5]),
    .tx_data_5_p (tx_data_p_loc[5]),
    .tx_data_6_n (tx_data_n_loc[6]),
    .tx_data_6_p (tx_data_p_loc[6]),
    .tx_data_7_n (tx_data_n_loc[7]),
    .tx_data_7_p (tx_data_p_loc[7]),
    .tx_ref_clk (tx_ref_clk),
    .tx_sync_0 (tx_sync[NUM_LINKS-1:0]),
    .tx_sysref_0 (tx_sysref));

  assign tx_data_p[JESD_L*NUM_LINKS-1:0] = tx_data_p_loc[JESD_L*NUM_LINKS-1:0];
  assign tx_data_n[JESD_L*NUM_LINKS-1:0] = tx_data_n_loc[JESD_L*NUM_LINKS-1:0];

  // AD9161/2/4-FMC-EBZ works only in single link,
  // The FMC connector instead of SYNC1 has SYSREF connected to it
  assign tx_sysref_loc = (DEVICE_CODE == 3) ? tx_sync[1] : tx_sysref;


endmodule

// ***************************************************************************
// ***************************************************************************
