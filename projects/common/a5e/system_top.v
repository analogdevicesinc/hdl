// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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
  input            hps_osc_clk,
  input            sys_resetn,

  // board gpio
  output  [3:0]    fpga_led,
  input   [3:0]    fpga_dipsw,
  input   [3:0]    fpga_btn,

  // hps-emif
  input            emif_hps_ref_clk,
  output           emif_hps_mem_ck_t,
  output           emif_hps_mem_ck_c,
  output [ 16:0]   emif_hps_mem_a,
  output           emif_hps_mem_act_n,
  output [  1:0]   emif_hps_mem_ba,
  output [  1:0]   emif_hps_mem_bg,
  output           emif_hps_mem_cke,
  output           emif_hps_mem_cs_n,
  output           emif_hps_mem_odt,
  output           emif_hps_mem_reset_n,
  output           emif_hps_mem_par,
  input            emif_hps_mem_alert_n,
  input            emif_hps_oct_rzqin,
  inout  [  3:0]   emif_hps_mem_dqs_t,
  inout  [  3:0]   emif_hps_mem_dqs_c,
  inout  [ 31:0]   emif_hps_mem_dq,

  // hps-sdmmc
  output           hps_sdmmc_clk,
  inout            hps_sdmmc_cmd,
  inout   [ 3:0]   hps_sdmmc_d,

  // hps-emac
  input            hps_emac_rxclk,
  input            hps_emac_rxctl,
  input   [ 3:0]   hps_emac_rxd,
  output           hps_emac_txclk,
  output           hps_emac_txctl,
  output  [ 3:0]   hps_emac_txd,
  output           hps_emac_pps,
  input            hps_emac_pps_trig,
  output           hps_emac_mdc,
  inout            hps_emac_mdio,

  // usb31
  input            usb31_io_vbus_det,
  input            usb31_io_flt_bar,
  output           usb31_io_usb_ctrl,
  input            usb31_io_usb31_id,
  input            usb31_phy_refclk_p,
  input            usb31_phy_rx_serial_n,
  input            usb31_phy_rx_serial_p,
  output           usb31_phy_tx_serial_n,
  output           usb31_phy_tx_serial_p,

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

  // hps-gpio
  inout            hps_gpio0_io0,
  inout            hps_gpio0_io1,
  inout            hps_gpio0_io11,
  inout            hps_gpio1_io3,
  inout            hps_gpio1_io4
);

  // internal signals
  wire  [63:0]  gpio_i;
  wire  [63:0]  gpio_o;
  wire          ninit_done;
  wire          sys_reset_n;
  wire          h2f_reset;
  wire [ 1:0]   usb31_io_usb_ctrl_s;
  wire          pma_cu_clk;
  wire          refclk_fail_stat;

  // Board GPIOs
  assign fpga_led      = gpio_o[3:0];
  assign gpio_i[ 3: 0] = gpio_o[3:0];
  assign gpio_i[ 7: 4] = fpga_dipsw;
  assign gpio_i[11: 8] = fpga_btn;

  // Unused GPIOs
  assign gpio_i[31:12] = gpio_o[31:12];
  assign gpio_i[63:32] = gpio_o[63:32];

  assign sys_reset_n   = sys_resetn & ~h2f_reset & ~ninit_done;

  assign usb31_io_usb_ctrl = usb31_io_usb_ctrl_s[1];

  system_bd i_system_bd (
    .sys_clk_clk                                             (sys_clk),
    .sys_hps_io_hps_osc_clk                                  (hps_osc_clk),

    .sys_rst_reset_n                                         (sys_resetn),
    .rst_ninit_done                                          (ninit_done),
    .h2f_reset_reset                                         (h2f_reset),
    .h2f_warm_reset_handshake_reset_req                      (),
    .h2f_warm_reset_handshake_reset_ack                      (),

    .f2h_irq1_in_irq                                         ('h0),
    .pr_rom_data_nc_rom_data                                 ('h0),
    .o_pma_cu_clk_clk                                        (pma_cu_clk),
    .i_refclk_bus_out_refclk_bus_out                         (1'h0),
    .o_shoreline_refclk_fail_stat_shoreline_refclk_fail_stat (refclk_fail_stat),

    .hps_emif_mem_0_mem_cke                                  (emif_hps_mem_cke),
    .hps_emif_mem_0_mem_odt                                  (emif_hps_mem_odt),
    .hps_emif_mem_0_mem_cs_n                                 (emif_hps_mem_cs_n),
    .hps_emif_mem_0_mem_a                                    (emif_hps_mem_a),
    .hps_emif_mem_0_mem_ba                                   (emif_hps_mem_ba),
    .hps_emif_mem_0_mem_bg                                   (emif_hps_mem_bg),
    .hps_emif_mem_0_mem_act_n                                (emif_hps_mem_act_n),
    .hps_emif_mem_0_mem_par                                  (emif_hps_mem_par),
    .hps_emif_mem_0_mem_dq                                   (emif_hps_mem_dq),
    .hps_emif_mem_0_mem_dqs_t                                (emif_hps_mem_dqs_t),
    .hps_emif_mem_0_mem_dqs_c                                (emif_hps_mem_dqs_c),
    .hps_emif_mem_0_mem_alert_n                              (emif_hps_mem_alert_n),
    .hps_emif_mem_ck_0_mem_ck_t                              (emif_hps_mem_ck_t),
    .hps_emif_mem_ck_0_mem_ck_c                              (emif_hps_mem_ck_c),
    .hps_emif_mem_reset_n_mem_reset_n                        (emif_hps_mem_reset_n),
    .hps_emif_oct_0_oct_rzqin                                (emif_hps_oct_rzqin),
    .hps_emif_ref_clk_0_clk                                  (emif_hps_ref_clk),

    .sys_hps_io_sdmmc_data0                                  (hps_sdmmc_d[0]),
    .sys_hps_io_sdmmc_data1                                  (hps_sdmmc_d[1]),
    .sys_hps_io_sdmmc_data2                                  (hps_sdmmc_d[2]),
    .sys_hps_io_sdmmc_data3                                  (hps_sdmmc_d[3]),
    .sys_hps_io_sdmmc_cclk                                   (hps_sdmmc_clk),
    .sys_hps_io_sdmmc_cmd                                    (hps_sdmmc_cmd),

    .sys_hps_io_usb1_clk                                     (hps_usb_clk),
    .sys_hps_io_usb1_stp                                     (hps_usb_stp),
    .sys_hps_io_usb1_dir                                     (hps_usb_dir),
    .sys_hps_io_usb1_nxt                                     (hps_usb_nxt),
    .sys_hps_io_usb1_data0                                   (hps_usb_d[0]),
    .sys_hps_io_usb1_data1                                   (hps_usb_d[1]),
    .sys_hps_io_usb1_data2                                   (hps_usb_d[2]),
    .sys_hps_io_usb1_data3                                   (hps_usb_d[3]),
    .sys_hps_io_usb1_data4                                   (hps_usb_d[4]),
    .sys_hps_io_usb1_data5                                   (hps_usb_d[5]),
    .sys_hps_io_usb1_data6                                   (hps_usb_d[6]),
    .sys_hps_io_usb1_data7                                   (hps_usb_d[7]),

    .sys_hps_io_emac2_tx_clk                                 (hps_emac_txclk),
    .sys_hps_io_emac2_tx_ctl                                 (hps_emac_txctl),
    .sys_hps_io_emac2_rx_clk                                 (hps_emac_rxclk),
    .sys_hps_io_emac2_rx_ctl                                 (hps_emac_rxctl),
    .sys_hps_io_emac2_txd0                                   (hps_emac_txd[0]),
    .sys_hps_io_emac2_txd1                                   (hps_emac_txd[1]),
    .sys_hps_io_emac2_txd2                                   (hps_emac_txd[2]),
    .sys_hps_io_emac2_txd3                                   (hps_emac_txd[3]),
    .sys_hps_io_emac2_rxd0                                   (hps_emac_rxd[0]),
    .sys_hps_io_emac2_rxd1                                   (hps_emac_rxd[1]),
    .sys_hps_io_emac2_rxd2                                   (hps_emac_rxd[2]),
    .sys_hps_io_emac2_rxd3                                   (hps_emac_rxd[3]),
    .sys_hps_io_emac2_pps                                    (hps_emac_pps),
    .sys_hps_io_emac2_pps_trig                               (hps_emac_pps_trig),

    .sys_hps_io_mdio2_mdio                                   (hps_emac_mdio),
    .sys_hps_io_mdio2_mdc                                    (hps_emac_mdc),

    .sys_hps_io_uart0_tx                                     (hps_uart_tx),
    .sys_hps_io_uart0_rx                                     (hps_uart_rx),

    .sys_hps_io_i3c1_sda                                     (hps_i2c_sda),
    .sys_hps_io_i3c1_scl                                     (hps_i2c_scl),

    .sys_hps_io_jtag_tck                                     (hps_jtag_tck),
    .sys_hps_io_jtag_tms                                     (hps_jtag_tms),
    .sys_hps_io_jtag_tdo                                     (hps_jtag_tdo),
    .sys_hps_io_jtag_tdi                                     (hps_jtag_tdi),

    .usb31_io_vbus_det                                       (usb31_io_vbus_det),
    .usb31_io_flt_bar                                        (usb31_io_flt_bar),
    .usb31_io_usb_ctrl                                       (usb31_io_usb_ctrl_s),
    .usb31_io_usb31_id                                       (usb31_io_usb31_id),

    .usb31_phy_pma_cpu_clk_clk                               (pma_cu_clk),
    .usb31_phy_refclk_p_clk                                  (usb31_phy_refclk_p),
    .usb31_phy_rx_serial_n_i_rx_serial_n                     (usb31_phy_rx_serial_n),
    .usb31_phy_rx_serial_p_i_rx_serial_p                     (usb31_phy_rx_serial_p),
    .usb31_phy_tx_serial_n_o_tx_serial_n                     (usb31_phy_tx_serial_n),
    .usb31_phy_tx_serial_p_o_tx_serial_p                     (usb31_phy_tx_serial_p),

    .sys_hps_io_gpio0                                        (hps_gpio0_io0),
    .sys_hps_io_gpio1                                        (hps_gpio0_io1),
    .sys_hps_io_gpio11                                       (hps_gpio0_io11),
    .sys_hps_io_gpio27                                       (hps_gpio1_io3),
    .sys_hps_io_gpio28                                       (hps_gpio1_io4),

    .sys_gpio_bd_in_port                                     (gpio_i[31:0]),
    .sys_gpio_bd_out_port                                    (gpio_o[31:0]),
    .sys_gpio_in_export                                      (gpio_i[63:32]),
    .sys_gpio_out_export                                     (gpio_o[63:32]),

    .sys_spi_MISO                                            (1'b0),
    .sys_spi_MOSI                                            (),
    .sys_spi_SCLK                                            (),
    .sys_spi_SS_n                                            ()
  );

endmodule
