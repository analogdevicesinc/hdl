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

`timescale 1ns/100ps

// DE25-Nano carrier template.
//
// Minimal top level for the de25nano carrier, exposing only the board signals
// the carrier system (de25nano_system_qsys.tcl) actually connects: the 50 MHz
// fabric clock, the HPS oscillator, SD card and UART, the HPS LPDDR4 EMIF (A) and the fabric LPDDR4 EMIF (B). Copy this file into a project and add the project
// specific ports and system_bd connections there - see
// projects/cn0540/de25nano/system_top.v for a worked example.
//
// Port names match projects/common/de25nano/de25nano_system_assign.tcl, and the
// system_bd port names match the wrapper generated into
// system_bd/synth/system_bd.v.

module system_top (

  // clock and resets

  input            CLOCK0_50,
  input            CLOCK1_50,
  input            CLOCK2_50,

  // hps

  input            HPS_CLK_25,
  
  //  KEY
//  input    [ 1: 0]   KEY,
  
  // SW
//  input    [ 3: 0]   SW,
  
  // LED
//  output   [ 7: 0]   LED,
  
  // hps-lpddr4
  output wire        LPDDR4A_CK,
  output wire        LPDDR4A_CK_n,
  output wire        LPDDR4A_CKE,
  output wire        LPDDR4A_RESET_n,
  input  wire        LPDDR4A_RZQ,
  input  wire        LPDDR4A_REFCLK_p,
  inout  wire [ 3:0] LPDDR4A_DQS,
  inout  wire [ 3:0] LPDDR4A_DQS_n, 
  inout  wire [31:0] LPDDR4A_DQ,
  output wire        LPDDR4A_CS_n,
  output wire [ 5:0] LPDDR4A_CA,
  inout  wire [ 3:0] LPDDR4A_DM,

  // hps-sd

  output           HPS_SD_CLK,
  inout            HPS_SD_CMD,
  inout  [ 3:0]    HPS_SD_DATA,

  // hps-uart

  input            HPS_UART_RX,
  output           HPS_UART_TX,

  // hps-enet (EMAC0, RGMII)

  output           HPS_ENET_MDC,
  inout            HPS_ENET_MDIO,
  input            HPS_ENET_RX_CLK,
  input            HPS_ENET_RX_CTL,
  input  [ 3:0]    HPS_ENET_RX_DATA,
  output           HPS_ENET_TX_CLK,
  output           HPS_ENET_TX_CTL,
  output [ 3:0]    HPS_ENET_TX_DATA,

  // hps-usb (USB0, ULPI)

  input            HPS_USB_CLK,
  inout  [ 7:0]    HPS_USB_DATA,
  input            HPS_USB_DIR,
  input            HPS_USB_NXT,
  output           HPS_USB_STP,

  // hps-i2c (I2C1)

  inout            HPS_I2C_SCL,
  inout            HPS_I2C_SDA,

  // hps-gpio (GPIO1: IO16 KEY, IO17 LED)

  inout            HPS_KEY,
  inout            HPS_LED
);

wire                   init_done_n;
wire                   system_reset_n;

assign                 system_reset_n = ~init_done_n;


system_bd i_system_bd (
    .sys_clk_clk (CLOCK2_50),

    .sys_rst_reset_n (system_reset_n),
    .rst_ninit_done_ninit_done (init_done_n),

    // hps resets
    .h2f_reset_reset (),

    // hps dedicated i/o
    .sys_hps_io_hps_osc_clk (HPS_CLK_25),
    
    // hps lpddr4
    .emif_hps_ref_clk_clk (LPDDR4A_REFCLK_p),
    .emif_hps_mem_mem_cs (LPDDR4A_CS_n),
    .emif_hps_mem_mem_ca (LPDDR4A_CA),
    .emif_hps_mem_mem_cke (LPDDR4A_CKE),
    .emif_hps_mem_mem_dq (LPDDR4A_DQ),
    .emif_hps_mem_mem_dqs_t (LPDDR4A_DQS),
    .emif_hps_mem_mem_dqs_c (LPDDR4A_DQS_n),
    .emif_hps_mem_mem_dmi (LPDDR4A_DM),
    .emif_hps_mem_ck_mem_ck_t (LPDDR4A_CK),
    .emif_hps_mem_ck_mem_ck_c (LPDDR4A_CK_n),
    .emif_hps_mem_reset_n_mem_reset_n (LPDDR4A_RESET_n),
    .emif_hps_oct_oct_rzqin (LPDDR4A_RZQ),

    // hps sd
    .sys_hps_io_sdmmc_cclk (HPS_SD_CLK),
    .sys_hps_io_sdmmc_cmd (HPS_SD_CMD),
    .sys_hps_io_sdmmc_data0 (HPS_SD_DATA[0]),
    .sys_hps_io_sdmmc_data1 (HPS_SD_DATA[1]),
    .sys_hps_io_sdmmc_data2 (HPS_SD_DATA[2]),
    .sys_hps_io_sdmmc_data3 (HPS_SD_DATA[3]),

    // hps uart
    .sys_hps_io_uart1_rx (HPS_UART_RX),
    .sys_hps_io_uart1_tx (HPS_UART_TX),

    // hps enet
    .sys_hps_io_emac0_tx_clk (HPS_ENET_TX_CLK),
    .sys_hps_io_emac0_tx_ctl (HPS_ENET_TX_CTL),
    .sys_hps_io_emac0_rx_clk (HPS_ENET_RX_CLK),
    .sys_hps_io_emac0_rx_ctl (HPS_ENET_RX_CTL),
    .sys_hps_io_emac0_txd0 (HPS_ENET_TX_DATA[0]),
    .sys_hps_io_emac0_txd1 (HPS_ENET_TX_DATA[1]),
    .sys_hps_io_emac0_txd2 (HPS_ENET_TX_DATA[2]),
    .sys_hps_io_emac0_txd3 (HPS_ENET_TX_DATA[3]),
    .sys_hps_io_emac0_rxd0 (HPS_ENET_RX_DATA[0]),
    .sys_hps_io_emac0_rxd1 (HPS_ENET_RX_DATA[1]),
    .sys_hps_io_emac0_rxd2 (HPS_ENET_RX_DATA[2]),
    .sys_hps_io_emac0_rxd3 (HPS_ENET_RX_DATA[3]),
    .sys_hps_io_mdio0_mdio (HPS_ENET_MDIO),
    .sys_hps_io_mdio0_mdc (HPS_ENET_MDC),

    // hps usb
    .sys_hps_io_usb0_clk (HPS_USB_CLK),
    .sys_hps_io_usb0_stp (HPS_USB_STP),
    .sys_hps_io_usb0_dir (HPS_USB_DIR),
    .sys_hps_io_usb0_nxt (HPS_USB_NXT),
    .sys_hps_io_usb0_data0 (HPS_USB_DATA[0]),
    .sys_hps_io_usb0_data1 (HPS_USB_DATA[1]),
    .sys_hps_io_usb0_data2 (HPS_USB_DATA[2]),
    .sys_hps_io_usb0_data3 (HPS_USB_DATA[3]),
    .sys_hps_io_usb0_data4 (HPS_USB_DATA[4]),
    .sys_hps_io_usb0_data5 (HPS_USB_DATA[5]),
    .sys_hps_io_usb0_data6 (HPS_USB_DATA[6]),
    .sys_hps_io_usb0_data7 (HPS_USB_DATA[7]),

    // hps i2c
    .sys_hps_io_i2c1_sda (HPS_I2C_SDA),
    .sys_hps_io_i2c1_scl (HPS_I2C_SCL),

    // hps gpio
    .sys_hps_io_gpio40 (HPS_KEY),
    .sys_hps_io_gpio41 (HPS_LED)
);

endmodule
