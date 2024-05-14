// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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

  // clock and resets
  input            sys_clk,
  input            hps_io_ref_clk,
  input            sys_resetn,

  // board gpio
  input   [12:0]   fpga_gpio,
  input            fpga_sgpio_sync,
  input            fpga_sgpio_clk,
  input            fpga_sgpi,
  output           fpga_sgpo,

  // hps-emif
  input            emif_hps_pll_ref_clk,
  output           emif_hps_mem_clk_p,
  output           emif_hps_mem_clk_n,
  output  [16:0]   emif_hps_mem_a,
  output  [ 1:0]   emif_hps_mem_ba,
  output           emif_hps_mem_bg,
  output           emif_hps_mem_cke,
  output           emif_hps_mem_cs_n,
  output           emif_hps_mem_odt,
  output           emif_hps_mem_reset_n,
  output           emif_hps_mem_act_n,
  output           emif_hps_mem_par,
  input            emif_hps_mem_alert_n,
  inout   [ 8:0]   emif_hps_mem_dqs_p,
  inout   [ 8:0]   emif_hps_mem_dqs_n,
  inout   [ 8:0]   emif_hps_mem_dbi_n,
  inout   [71:0]   emif_hps_mem_dq,
  input            emif_hps_oct_rzq,

  // hps-emac
  input            hps_emac_rxclk,
  input            hps_emac_rxctl,
  input   [ 3:0]   hps_emac_rxd,
  output           hps_emac_txclk,
  output           hps_emac_txctl,
  output  [ 3:0]   hps_emac_txd,
  output           hps_emac_mdc,
  inout            hps_emac_mdio,

  // hps-sdio
  output           hps_sdio_clk,
  inout            hps_sdio_cmd,
  inout   [ 3:0]   hps_sdio_d,

  // hps-usb
  input            hps_usb_clk,
  input            hps_usb_dir,
  input            hps_usb_nxt,
  output           hps_usb_stp,
  inout   [ 7:0]   hps_usb_d,

  // hps-uart
  input            hps_uart_rx,
  output           hps_uart_tx,

  // hps-i2c
  inout            hps_i2c_sda,
  inout            hps_i2c_scl,

  // hps-jtag
  input            hps_jtag_tck,
  input            hps_jtag_tms,
  output           hps_jtag_tdo,
  input            hps_jtag_tdi,

  // hps-OOBE daughter card peripherals
  inout            hps_gpio_eth_irq,
  inout            hps_gpio_usb_oci,
  inout   [ 1:0]   hps_gpio_btn,
  inout   [ 2:0]   hps_gpio_led
);

  // internal signals
  wire  [63:0]  gpio_i;
  wire  [63:0]  gpio_o;
  wire  [ 7:0]  fpga_dipsw;
  wire  [ 7:0]  fpga_led;
  wire          nconf_done;
  wire          ninit_done;
  wire          sys_reset_n;
  wire          h2f_reset;
  wire  [43:0]  stm_hw_events;

  // Board GPIOs
  assign fpga_led      = gpio_o[7:0];
  assign gpio_i[ 7: 0] = gpio_o[7:0];
  assign gpio_i[15: 8] = fpga_dipsw;
  assign gpio_i[17:16] = fpga_gpio[ 1:0]; // push buttons
  assign gpio_i[28:18] = fpga_gpio[12:2];

  // Unused GPIOs
  assign gpio_i[31:29] = gpio_o[31:29];
  assign gpio_i[63:32] = gpio_o[63:32];

  assign sys_reset_n   = sys_resetn & ~h2f_reset & ~ninit_done;
  assign stm_hw_events = {14'b0, fpga_led, fpga_dipsw, fpga_gpio[1:0]};

  gpio_slave i_gpio_slave (
    .reset_n (sys_reset_n),
    .clk     (fpga_sgpio_clk),
    .sync    (fpga_sgpio_sync),
    .miso    (fpga_sgpo),
    .mosi    (fpga_sgpi),
    .leds    (fpga_led),
    .dipsw   (fpga_dipsw));

  system_bd i_system_bd (
    .sys_clk_clk            (sys_clk),
    .sys_hps_io_hps_osc_clk (hps_io_ref_clk),

    .sys_rst_reset_n      (sys_reset_n),
    .rst_ninit_done       (ninit_done),
    .sys_gpio_bd_in_port  (gpio_i[31: 0]),
    .sys_gpio_bd_out_port (gpio_o[31: 0]),
    .sys_gpio_in_export   (gpio_i[63:32]),
    .sys_gpio_out_export  (gpio_o[63:32]),

    .emif_hps_ddr_mem_ck      (emif_hps_mem_clk_p),
    .emif_hps_ddr_mem_ck_n    (emif_hps_mem_clk_n),
    .emif_hps_ddr_mem_a       (emif_hps_mem_a),
    .emif_hps_ddr_mem_act_n   (emif_hps_mem_act_n),
    .emif_hps_ddr_mem_ba      (emif_hps_mem_ba),
    .emif_hps_ddr_mem_bg      (emif_hps_mem_bg),
    .emif_hps_ddr_mem_cke     (emif_hps_mem_cke),
    .emif_hps_ddr_mem_cs_n    (emif_hps_mem_cs_n),
    .emif_hps_ddr_mem_odt     (emif_hps_mem_odt),
    .emif_hps_ddr_mem_reset_n (emif_hps_mem_reset_n),
    .emif_hps_ddr_mem_par     (emif_hps_mem_par),
    .emif_hps_ddr_mem_alert_n (emif_hps_mem_alert_n),
    .emif_hps_ddr_mem_dqs     (emif_hps_mem_dqs_p),
    .emif_hps_ddr_mem_dqs_n   (emif_hps_mem_dqs_n),
    .emif_hps_ddr_mem_dq      (emif_hps_mem_dq),
    .emif_hps_ddr_mem_dbi_n   (emif_hps_mem_dbi_n),
    .emif_hps_oct_rzqin       (emif_hps_oct_rzq),
    .emif_hps_pll_ref_clk     (emif_hps_pll_ref_clk),

    .sys_hps_io_EMAC0_TX_CLK (hps_emac_txclk),
    .sys_hps_io_EMAC0_TX_CTL (hps_emac_txctl),
    .sys_hps_io_EMAC0_TXD0   (hps_emac_txd[0]),
    .sys_hps_io_EMAC0_TXD1   (hps_emac_txd[1]),
    .sys_hps_io_EMAC0_TXD2   (hps_emac_txd[2]),
    .sys_hps_io_EMAC0_TXD3   (hps_emac_txd[3]),
    .sys_hps_io_EMAC0_RX_CLK (hps_emac_rxclk),
    .sys_hps_io_EMAC0_RX_CTL (hps_emac_rxctl),
    .sys_hps_io_EMAC0_RXD0   (hps_emac_rxd[0]),
    .sys_hps_io_EMAC0_RXD1   (hps_emac_rxd[1]),
    .sys_hps_io_EMAC0_RXD2   (hps_emac_rxd[2]),
    .sys_hps_io_EMAC0_RXD3   (hps_emac_rxd[3]),
    .sys_hps_io_EMAC0_MDIO   (hps_emac_mdio),
    .sys_hps_io_EMAC0_MDC    (hps_emac_mdc),

    .sys_hps_io_SDMMC_CCLK (hps_sdio_clk),
    .sys_hps_io_SDMMC_CMD  (hps_sdio_cmd),
    .sys_hps_io_SDMMC_D0   (hps_sdio_d[0]),
    .sys_hps_io_SDMMC_D1   (hps_sdio_d[1]),
    .sys_hps_io_SDMMC_D2   (hps_sdio_d[2]),
    .sys_hps_io_SDMMC_D3   (hps_sdio_d[3]),

    .sys_hps_io_USB0_CLK   (hps_usb_clk),
    .sys_hps_io_USB0_STP   (hps_usb_stp),
    .sys_hps_io_USB0_DIR   (hps_usb_dir),
    .sys_hps_io_USB0_NXT   (hps_usb_nxt),
    .sys_hps_io_USB0_DATA0 (hps_usb_d[0]),
    .sys_hps_io_USB0_DATA1 (hps_usb_d[1]),
    .sys_hps_io_USB0_DATA2 (hps_usb_d[2]),
    .sys_hps_io_USB0_DATA3 (hps_usb_d[3]),
    .sys_hps_io_USB0_DATA4 (hps_usb_d[4]),
    .sys_hps_io_USB0_DATA5 (hps_usb_d[5]),
    .sys_hps_io_USB0_DATA6 (hps_usb_d[6]),
    .sys_hps_io_USB0_DATA7 (hps_usb_d[7]),

    .sys_hps_io_UART0_RX (hps_uart_rx),
    .sys_hps_io_UART0_TX (hps_uart_tx),

    .sys_hps_io_I2C1_SDA (hps_i2c_sda),
    .sys_hps_io_I2C1_SCL (hps_i2c_scl),

    .sys_hps_io_jtag_tck (hps_jtag_tck),
    .sys_hps_io_jtag_tms (hps_jtag_tms),
    .sys_hps_io_jtag_tdo (hps_jtag_tdo),
    .sys_hps_io_jtag_tdi (hps_jtag_tdi),
    //Terminate the CS_JTAG.
    .sys_hps_h2f_cs_ntrst (1'b1),
    .sys_hps_h2f_cs_tck   (1'b1),
    .sys_hps_h2f_cs_tdi   (1'b1),
    .sys_hps_h2f_cs_tdo   (),
    .sys_hps_h2f_cs_tdoen (),
    .sys_hps_h2f_cs_tms   (1'b1),

    .sys_hps_io_gpio1_io0  (hps_gpio_eth_irq),
    .sys_hps_io_gpio1_io1  (hps_gpio_usb_oci),
    .sys_hps_io_gpio1_io4  (hps_gpio_btn[0]),
    .sys_hps_io_gpio1_io5  (hps_gpio_btn[1]),
    .sys_hps_io_gpio1_io19 (hps_gpio_led[1]),
    .sys_hps_io_gpio1_io20 (hps_gpio_led[0]),
    .sys_hps_io_gpio1_io21 (hps_gpio_led[2]),

    .h2f_reset_reset (h2f_reset),

    .sys_hps_f2h_stm_hwevents (stm_hw_events),

    .sys_spi_MISO (1'b0),
    .sys_spi_MOSI (),
    .sys_spi_SCLK (),
    .sys_spi_SS_n ());

endmodule
