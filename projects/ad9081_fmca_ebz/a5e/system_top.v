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

module system_top #(
  // Dummy parameters to workaround critical warning
  parameter JESD_MODE          = "8B10B",
  parameter RX_LANE_RATE       = 10,
  parameter TX_LANE_RATE       = 10,
  parameter REF_CLK_RATE       = 375,
  parameter DEVICE_CLK_RATE    = 375,
  parameter RX_JESD_M          = 8,
  parameter RX_JESD_L          = 8,
  parameter RX_JESD_S          = 1,
  parameter RX_JESD_NP         = 16,
  parameter RX_NUM_LINKS       = 1,
  parameter TX_JESD_M          = 8,
  parameter TX_JESD_L          = 8,
  parameter TX_JESD_S          = 1,
  parameter TX_JESD_NP         = 16,
  parameter TX_NUM_LINKS       = 1,
  parameter RX_KS_PER_CHANNEL  = 32,
  parameter TX_KS_PER_CHANNEL  = 32
) (

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
  inout            hps_gpio1_io4,

  // FMC HPC IOs

  // lane interface
  input                   clkin6,
  input                   clkin10,
  input                   fpga_refclk_in,
  input   [RX_JESD_L-1:0] rx_data,
  output  [TX_JESD_L-1:0] tx_data,
  input   [RX_JESD_L-1:0] rx_data_n,
  output  [TX_JESD_L-1:0] tx_data_n,
  input                   fpga_syncin_0,
  input                   fpga_syncin_1_n,
  input                   fpga_syncin_1_p,
  output                  fpga_syncout_0,
  input                   fpga_syncout_1_n,
  input                   fpga_syncout_1_p,
  input                   sysref2,

  // spi
  output                  spi0_csb,
  input                   spi0_miso,
  output                  spi0_mosi,
  output                  spi0_sclk,
  output                  spi1_csb,
  output                  spi1_sclk,
  inout                   spi1_sdio,

  // gpio
  input   [1:0]           agc0,
  input   [1:0]           agc1,
  input   [1:0]           agc2,
  input   [1:0]           agc3,
  input   [10:0]          gpio,
  inout                   hmc_gpio1,
  output                  hmc_sync,
  input   [1:0]           irqb,
  output                  rstb,
  output  [1:0]           rxen,
  output  [1:0]           txen
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
  wire          refclk_rdy_data;
  wire          syspll_c0_clk;

  wire  [ 7:0]  spi_csn_s;
  wire          spi_clk;
  wire          spi_mosi;

  // Board GPIOs
  assign fpga_led      = gpio_o[3:0];
  assign gpio_i[ 3: 0] = gpio_o[3:0];
  assign gpio_i[ 7: 4] = fpga_dipsw;
  assign gpio_i[11: 8] = fpga_btn;

  // HMC GPIOs
  assign gpio_i[44] = agc0[0];
  assign gpio_i[45] = agc0[1];
  assign gpio_i[46] = agc1[0];
  assign gpio_i[47] = agc1[1];
  assign gpio_i[48] = agc2[0];
  assign gpio_i[49] = agc2[1];
  assign gpio_i[50] = agc3[0];
  assign gpio_i[51] = agc3[1];
  assign gpio_i[52] = irqb[0];
  assign gpio_i[53] = irqb[1];

  assign hmc_gpio1  = gpio_o[43];
  assign hmc_sync   = gpio_o[54];
  assign rstb       = gpio_o[55];
  assign rxen[0]    = gpio_o[56];
  assign rxen[1]    = gpio_o[57];
  assign txen[0]    = gpio_o[58];
  assign txen[1]    = gpio_o[59];

  // Unused GPIOs
  assign gpio_i[63:54] = gpio_o[63:54];
  assign gpio_i[43:32] = gpio_o[43:32];
  assign gpio_i[31:12] = gpio_o[31:12];

  // assignmnets
  assign sys_reset_n    = sys_resetn & ~h2f_reset & ~ninit_done;

  assign usb31_io_usb_ctrl = usb31_io_usb_ctrl_s[1];

  assign spi0_csb = spi_csn_s[0];
  assign spi1_csb = spi_csn_s[1];

  assign spi0_sclk = spi_clk;
  assign spi1_sclk = spi_clk;

  assign spi0_mosi = spi_mosi;

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_spi_hmc (
    .spi_csn (spi_csn_s[1]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_hmc_miso),
    .spi_sdio (spi1_sdio),
    .spi_dir ());

  assign spi_miso = ~spi_csn_s[0] ? spi0_miso :
                    ~spi_csn_s[1] ? spi_hmc_miso :
                    1'b0;

  system_bd i_system_bd (
    .sys_clk_clk                                             (sys_clk),
    .sys_hps_io_hps_osc_clk                                  (hps_osc_clk),

    .sys_rst_reset_n                                         (sys_resetn),
    .rst_ninit_done                                          (ninit_done),
    .h2f_reset_reset                                         (h2f_reset),

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

    .gts_reset_src_rs_priority_src_rs_priority               ('h0),

    // FMC HPC
    .sys_spi_MISO                                            (spi_miso),
    .sys_spi_MOSI                                            (spi_mosi),
    .sys_spi_SCLK                                            (spi_clk),
    .sys_spi_SS_n                                            (spi_csn_s),
    .tx_serial_data_o_tx_serial_data                         (tx_data[TX_JESD_L-1:0]),
    .tx_serial_data_n_o_tx_serial_data_n                     (tx_data_n[TX_JESD_L-1:0]),
    .tx_ref_clk_clk                                          (fpga_refclk_in),
    .tx_sync_export                                          (fpga_syncin_0),
    .tx_sysref_export                                        (sysref2),
    .tx_device_clk_clk                                       (clkin6),
    .rx_serial_data_i_rx_serial_data                         (rx_data[RX_JESD_L-1:0]),
    .rx_serial_data_n_i_rx_serial_data_n                     (rx_data_n[RX_JESD_L-1:0]),
    .rx_ref_clk_clk                                          (fpga_refclk_in),
    .rx_sync_export                                          (fpga_syncout_0),
    .rx_sysref_export                                        (sysref2),
    .rx_device_clk_clk                                       (clkin10),
    .mxfe_gpio_export                                        ({fpga_syncout_1_n,  // 14
                                                               fpga_syncout_1_p,  // 13
                                                               fpga_syncin_1_n,   // 12
                                                               fpga_syncin_1_p,   // 11
                                                               gpio}));           // 10:0

endmodule
