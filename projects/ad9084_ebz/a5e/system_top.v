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

module system_top #(
  // Dummy parameters to workaround critical warning
  parameter JESD_MODE          = "8B10B",
  parameter HSCI_ENABLE        = 0,
  parameter REF_CLK_RATE       = 250,
  parameter DEVICE_CLK_RATE    = 250,
  parameter RX_LANE_RATE       = 10,
  parameter TX_LANE_RATE       = 10,
  parameter RX_JESD_M          = 4,
  parameter RX_JESD_L          = 2,
  parameter RX_JESD_S          = 1,
  parameter RX_JESD_NP         = 16,
  parameter RX_NUM_LINKS       = 2,
  parameter TX_JESD_M          = 4,
  parameter TX_JESD_L          = 2,
  parameter TX_JESD_S          = 1,
  parameter TX_JESD_NP         = 16,
  parameter TX_NUM_LINKS       = 2,
  parameter RX_KS_PER_CHANNEL  = 16,
  parameter TX_KS_PER_CHANNEL  = 16,

  parameter RX_NO_LANES = RX_JESD_L * RX_NUM_LINKS,
  parameter TX_NO_LANES = TX_JESD_L * TX_NUM_LINKS,

  parameter NUM_OF_PHYS = 2,
  parameter PHY_NO_LANES = RX_NO_LANES / NUM_OF_PHYS
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
  inout  [  4:0]   emif_hps_mem_dqs_t,
  inout  [  4:0]   emif_hps_mem_dqs_c,
  inout  [ 39:0]   emif_hps_mem_dq,
  inout  [  4:0]   emif_hps_mem_dbi_n,

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

  input  [PHY_NO_LANES-1:0] rx_data_a_p,
  input  [PHY_NO_LANES-1:0] rx_data_a_n,
  input  [PHY_NO_LANES-1:0] rx_data_b_p,
  input  [PHY_NO_LANES-1:0] rx_data_b_n,
  output [PHY_NO_LANES-1:0] tx_data_a_p,
  output [PHY_NO_LANES-1:0] tx_data_a_n,
  output [PHY_NO_LANES-1:0] tx_data_b_p,
  output [PHY_NO_LANES-1:0] tx_data_b_n,

  input          fpga_refclk_in_a,
  input          fpga_refclk_in_b,
  input          tx_device_clk,
  input          rx_device_clk,
  input          sysref_out,

  input          syncinb_a0,
  input          syncinb_b0,
  inout          syncinb_a1_p_gpio,
  inout          syncinb_a1_n_gpio,

  output         syncoutb_a0,
  output         syncoutb_b0,
  inout          syncoutb_a1_p_gpio,
  inout          syncoutb_a1_n_gpio,

  // gpio
  inout  [30:15] gpio,

  output         spi2_sclk,
  inout          spi2_sdio,
  input          spi2_sdo,
  output [ 5:0]  spi2_cs,

  // apollo spi
  output         dut_sdio,
  input          dut_sdo,
  output         dut_sclk,
  output         dut_csb,

  output [ 1:0]  trig_a,
  output [ 1:0]  trig_b,

  input          trig_in,
  output         resetb
);

  // internal signals
  wire  [63:0]  gpio_i;
  wire  [63:0]  gpio_o;

  wire          sys_cpu_clk;
  wire          ninit_done;
  wire          sys_reset_n;
  wire          h2f_reset;
  wire          h2f_warm_reset_reset_ack;
  wire          h2f_warm_reset_reset_req;
  wire [ 1:0]   usb31_io_usb_ctrl_s;
  wire          pma_cu_clk;

  wire          syspll_clk_a;
  wire          syspll_lock_a;
  wire          syspll_clk_b;
  wire          syspll_lock_b;

  wire          refclk_ready;
  wire          refclk_ready_rx;
  wire          refclk_ready_tx;

  wire          spi_clk;
  wire  [ 7:0]  spi_csn;
  wire          spi_sdo;
  wire          spi_sdio;

  wire          apollo_spi_clk;
  wire  [ 7:0]  apollo_spi_csn;
  wire          apollo_spi_sdo;
  wire          apollo_spi_sdio;

  // GTS reset sequencer
  wire [RX_NO_LANES-1:0]        gts_reset_o_src_rs_grant_src_rs_grant;
  wire [RX_NO_LANES-1:0]        gts_reset_i_src_rs_req_src_rs_req;
  wire [           1:0]         gts_reset_o_pma_cu_clk_clk;
  wire [           9:0]         gts_reset_i_refclk_on_refclk_on;
  wire [           9:0]         gts_reset_i_src_rs_refclk_status_bus_refclk_status_bus_out;
  wire [           7:0]         gts_reset_o_refclk_fail_status_refclk_fail_status;
  wire                          gts_reset_o_refclk_on_ack_refclk_on_ack;
  wire [           9:0]         gts_reset_o_src_rs_refclk_cmd_bus_refclk_cmd_bus_in;

  // PHY A / PHY B <-> reset sequencer
  wire [PHY_NO_LANES-1:0]       jesd204_phy_a_o_src_rs_req_src_rs_req;
  wire [PHY_NO_LANES-1:0]       jesd204_phy_b_o_src_rs_req_src_rs_req;
  wire [           9:0]         jesd204_phy_a_o_refclk_status_bus_out_refclk_status_bus_out;
  wire [           9:0]         jesd204_phy_b_o_refclk_status_bus_out_refclk_status_bus_out;

  // PHY A / PHY B -> link layer
  wire [PHY_NO_LANES-1:0]       jesd204_phy_a_rx_is_lockedtodata_o_rx_is_lockedtodata;
  wire [PHY_NO_LANES-1:0]       jesd204_phy_b_rx_is_lockedtodata_o_rx_is_lockedtodata;
  wire [PHY_NO_LANES-1:0]       phy_a_tx_pll_locked_o_tx_pll_locked;
  wire [PHY_NO_LANES-1:0]       phy_b_tx_pll_locked_o_tx_pll_locked;

  wire                          phy_a_tx_clkout;
  wire                          phy_b_tx_clkout;
//  wire [           4:0]         phy_a_tx_clk_count;
//  wire [           4:0]         phy_b_tx_clk_count;

  // Per-PHY reset status out of axi_adxcvr, already in the sys_clk domain.
  wire [NUM_OF_PHYS-1:0]        rx_phy_reset_done;
  wire [NUM_OF_PHYS-1:0]        rx_phy_ready;
  wire [NUM_OF_PHYS-1:0]        rx_phy_reset_ack;
  wire [NUM_OF_PHYS-1:0]        tx_phy_reset_done;
  wire [NUM_OF_PHYS-1:0]        tx_phy_ready;
  wire [NUM_OF_PHYS-1:0]        tx_phy_reset_ack;

  localparam DBG_STATUS_W = 10 + 4*NUM_OF_PHYS + 4*PHY_NO_LANES;

  wire [DBG_STATUS_W-1:0]       dbg_status_s;

  assign h2f_warm_reset_reset_ack = h2f_warm_reset_reset_req;

  // The reset sequencer covers both PHYs: lanes and refclk request/status buses
  // are concatenated, link A occupying the low half.
  assign gts_reset_i_src_rs_req_src_rs_req = {jesd204_phy_b_o_src_rs_req_src_rs_req,
                                              jesd204_phy_a_o_src_rs_req_src_rs_req};

  /*
   * Only one IP per device side drives o_refclk_status_bus_out into the reset
   * sequencer; the others are left unconnected. PHY B's is deliberately unused.
   */
  assign gts_reset_i_src_rs_refclk_status_bus_refclk_status_bus_out =
    jesd204_phy_a_o_refclk_status_bus_out_refclk_status_bus_out;

//  /*
//   * Debug: whether each bank's GTS serializer clock is running at all. Nothing
//   * else in the design observes phy_*_tx_clkout, so a dead TX clock is
//   * otherwise indistinguishable from a link that never trained.
//   *
//   * WIDTH tracked the width of the gpio_i slots these fed. out_count is
//   * gray-coded: software must decode it before differencing two reads.
//   */
//  clk_monitor #(
//    .WIDTH (5)
//  ) i_phy_a_tx_clk_monitor (
//    .clk (phy_a_tx_clkout),
//    .out_clk (sys_cpu_clk),
//    .out_resetn (sys_reset_n),
//    .out_count (phy_a_tx_clk_count));
//
//  clk_monitor #(
//    .WIDTH (5)
//  ) i_phy_b_tx_clk_monitor (
//    .clk (phy_b_tx_clkout),
//    .out_clk (sys_cpu_clk),
//    .out_resetn (sys_reset_n),
//    .out_count (phy_b_tx_clk_count));

  // Board GPIOs
  assign fpga_led      = gpio_o[3:0];
  assign gpio_i[ 3: 0] = gpio_o[3:0];
  assign gpio_i[ 7: 4] = fpga_dipsw;
  assign gpio_i[11: 8] = fpga_btn;

  // FMC GPIOs
  assign gpio_i[47:32] = gpio[30:15];

  assign trig_a[0]  = gpio_o[58];
  assign trig_a[1]  = gpio_o[59];
  assign trig_b[0]  = gpio_o[60];
  assign trig_b[1]  = gpio_o[61];
  assign resetb     = gpio_o[62];

  assign refclk_ready_rx = gpio_o[56];
  assign refclk_ready_tx = gpio_o[57];

  /*
   * Both adxcvr instances must report their refclk stable: unlike ad9081, the
   * RX and TX refclks are separate inputs on this board.
   */
  assign refclk_ready = refclk_ready_rx && refclk_ready_tx;

//  /*
//   * Debug: per-PHY bring-up status, since the link-layer and axi_adxcvr
//   * registers only expose these AND-ed across both PHYs. The bit order is the
//   * concatenation below.
//   *
//   * The PIOs generate interrupts, so these paths reach the CPU and have to be
//   * synchronized rather than declared false.
//   */
//  sync_bits #(
//    .NUM_OF_BITS(DBG_STATUS_W),
//    .ASYNC_CLK(1)
//  ) i_dbg_status_cdc (
//    .in_bits ({syspll_lock_b,
//               syspll_lock_a,
//               gts_reset_o_refclk_fail_status_refclk_fail_status,
//               tx_phy_reset_ack,
//               rx_phy_reset_ack,
//               tx_phy_ready,
//               rx_phy_ready,
//               phy_b_tx_pll_locked_o_tx_pll_locked,
//               phy_a_tx_pll_locked_o_tx_pll_locked,
//               jesd204_phy_b_rx_is_lockedtodata_o_rx_is_lockedtodata,
//               jesd204_phy_a_rx_is_lockedtodata_o_rx_is_lockedtodata}),
//    .out_clk (sys_cpu_clk),
//    .out_resetn (sys_reset_n),
//    .out_bits (dbg_status_s));
//
//  assign gpio_i[31:12] = dbg_status_s[19:0];
//  assign gpio_i[   54] = dbg_status_s[DBG_STATUS_W-2];
//  assign gpio_i[   53] = dbg_status_s[DBG_STATUS_W-1];
//
//  /* Debug: a count that never changes between two reads means the clock is dead. */
//  assign gpio_i[52:48] = phy_a_tx_clk_count;
//  assign gpio_i[59:55] = phy_b_tx_clk_count;
//  assign gpio_i[61:60] = tx_phy_reset_done;
//  assign gpio_i[63:62] = rx_phy_reset_done;

  // Debug signals above are commented out; the freed inputs read back what
  // software wrote so the PIOs stay driven.
  assign gpio_i[31:12] = gpio_o[31:12];
  assign gpio_i[63:48] = gpio_o[63:48];

  assign sys_reset_n = sys_resetn & ~h2f_reset & ~ninit_done;

  assign usb31_io_usb_ctrl = usb31_io_usb_ctrl_s[1];

  assign spi2_cs[5:0] = spi_csn[5:0];
  assign spi2_sclk    = spi_clk;

  ad_3w_spi #(
    .NUM_OF_SLAVES(3)
  ) i_spi (
    .spi_csn ({spi_csn[4], spi_csn[1:0]}),
    .spi_clk (spi_clk),
    .spi_mosi (spi_sdio),
    .spi_miso (spi_sdo),
    .spi_sdio (spi2_sdio));

  // Apollo SPI
  assign dut_csb  = apollo_spi_csn[0];
  assign dut_sclk = apollo_spi_clk;
  assign dut_sdio = apollo_spi_sdio;

  assign apollo_spi_sdo = ~apollo_spi_csn[0] ? dut_sdo : 1'b0;

  // GTS refclk buffer control state machine
  gts_refclk_reset #(
    .REFCLK_ON_WIDTH   (10),
    .FAIL_STATUS_WIDTH (8)
  ) i_gts_refclk_reset (
    .clk                (sys_cpu_clk),
    .resetn             (sys_reset_n),
    .refclk_ready       (refclk_ready),
    .refclk_on_ack      (gts_reset_o_refclk_on_ack_refclk_on_ack),
    .refclk_fail_status (gts_reset_o_refclk_fail_status_refclk_fail_status),
    .refclk_on          (gts_reset_i_refclk_on_refclk_on));

  system_bd i_system_bd (
    .sys_clk_clk                                                (sys_clk),
    .sys_hps_io_hps_osc_clk                                     (hps_osc_clk),

    .sys_rst_reset_n                                            (sys_reset_n),
    .rst_ninit_done                                             (ninit_done),
    .h2f_reset_reset                                            (h2f_reset),
    .h2f_warm_reset_reset_req                                   (h2f_warm_reset_reset_req),
    .h2f_warm_reset_reset_ack                                   (h2f_warm_reset_reset_ack),

    .f2h_irq1_in_irq                                            (31'h0),
    .pr_rom_data_nc_rom_data                                    ('h0),
    .o_pma_cu_clk_clk                                           (pma_cu_clk),

    .hps_emif_mem_0_mem_cke                                     (emif_hps_mem_cke),
    .hps_emif_mem_0_mem_odt                                     (emif_hps_mem_odt),
    .hps_emif_mem_0_mem_cs_n                                    (emif_hps_mem_cs_n),
    .hps_emif_mem_0_mem_a                                       (emif_hps_mem_a),
    .hps_emif_mem_0_mem_ba                                      (emif_hps_mem_ba),
    .hps_emif_mem_0_mem_bg                                      (emif_hps_mem_bg),
    .hps_emif_mem_0_mem_act_n                                   (emif_hps_mem_act_n),
    .hps_emif_mem_0_mem_par                                     (emif_hps_mem_par),
    .hps_emif_mem_0_mem_dq                                      (emif_hps_mem_dq),
    .hps_emif_mem_0_mem_dqs_t                                   (emif_hps_mem_dqs_t),
    .hps_emif_mem_0_mem_dqs_c                                   (emif_hps_mem_dqs_c),
    .hps_emif_mem_0_mem_alert_n                                 (emif_hps_mem_alert_n),
    .hps_emif_mem_ck_0_mem_ck_t                                 (emif_hps_mem_ck_t),
    .hps_emif_mem_ck_0_mem_ck_c                                 (emif_hps_mem_ck_c),
    .hps_emif_mem_reset_n_mem_reset_n                           (emif_hps_mem_reset_n),
    .hps_emif_oct_0_oct_rzqin                                   (emif_hps_oct_rzqin),
    .hps_emif_ref_clk_0_clk                                     (emif_hps_ref_clk),
    .hps_emif_mem_0_mem_dbi_n                                   (emif_hps_mem_dbi_n),

    .sys_hps_io_sdmmc_data0                                     (hps_sdmmc_d[0]),
    .sys_hps_io_sdmmc_data1                                     (hps_sdmmc_d[1]),
    .sys_hps_io_sdmmc_data2                                     (hps_sdmmc_d[2]),
    .sys_hps_io_sdmmc_data3                                     (hps_sdmmc_d[3]),
    .sys_hps_io_sdmmc_cclk                                      (hps_sdmmc_clk),
    .sys_hps_io_sdmmc_cmd                                       (hps_sdmmc_cmd),

    .sys_hps_io_usb1_clk                                        (hps_usb_clk),
    .sys_hps_io_usb1_stp                                        (hps_usb_stp),
    .sys_hps_io_usb1_dir                                        (hps_usb_dir),
    .sys_hps_io_usb1_nxt                                        (hps_usb_nxt),
    .sys_hps_io_usb1_data0                                      (hps_usb_d[0]),
    .sys_hps_io_usb1_data1                                      (hps_usb_d[1]),
    .sys_hps_io_usb1_data2                                      (hps_usb_d[2]),
    .sys_hps_io_usb1_data3                                      (hps_usb_d[3]),
    .sys_hps_io_usb1_data4                                      (hps_usb_d[4]),
    .sys_hps_io_usb1_data5                                      (hps_usb_d[5]),
    .sys_hps_io_usb1_data6                                      (hps_usb_d[6]),
    .sys_hps_io_usb1_data7                                      (hps_usb_d[7]),

    .sys_hps_io_emac2_tx_clk                                    (hps_emac_txclk),
    .sys_hps_io_emac2_tx_ctl                                    (hps_emac_txctl),
    .sys_hps_io_emac2_rx_clk                                    (hps_emac_rxclk),
    .sys_hps_io_emac2_rx_ctl                                    (hps_emac_rxctl),
    .sys_hps_io_emac2_txd0                                      (hps_emac_txd[0]),
    .sys_hps_io_emac2_txd1                                      (hps_emac_txd[1]),
    .sys_hps_io_emac2_txd2                                      (hps_emac_txd[2]),
    .sys_hps_io_emac2_txd3                                      (hps_emac_txd[3]),
    .sys_hps_io_emac2_rxd0                                      (hps_emac_rxd[0]),
    .sys_hps_io_emac2_rxd1                                      (hps_emac_rxd[1]),
    .sys_hps_io_emac2_rxd2                                      (hps_emac_rxd[2]),
    .sys_hps_io_emac2_rxd3                                      (hps_emac_rxd[3]),
    .sys_hps_io_emac2_pps                                       (hps_emac_pps),
    .sys_hps_io_emac2_pps_trig                                  (hps_emac_pps_trig),

    .sys_hps_io_mdio2_mdio                                      (hps_emac_mdio),
    .sys_hps_io_mdio2_mdc                                       (hps_emac_mdc),

    .sys_hps_io_uart0_tx                                        (hps_uart_tx),
    .sys_hps_io_uart0_rx                                        (hps_uart_rx),

    .sys_hps_io_i3c1_sda                                        (hps_i2c_sda),
    .sys_hps_io_i3c1_scl                                        (hps_i2c_scl),

    .sys_hps_io_jtag_tck                                        (hps_jtag_tck),
    .sys_hps_io_jtag_tms                                        (hps_jtag_tms),
    .sys_hps_io_jtag_tdo                                        (hps_jtag_tdo),
    .sys_hps_io_jtag_tdi                                        (hps_jtag_tdi),

    .usb31_io_vbus_det                                          (usb31_io_vbus_det),
    .usb31_io_flt_bar                                           (usb31_io_flt_bar),
    .usb31_io_usb_ctrl                                          (usb31_io_usb_ctrl_s),
    .usb31_io_usb31_id                                          (usb31_io_usb31_id),

    .usb31_phy_pma_cpu_clk_clk                                  (pma_cu_clk),
    .usb31_phy_refclk_p_clk                                     (usb31_phy_refclk_p),
    .usb31_phy_rx_serial_n_i_rx_serial_n                        (usb31_phy_rx_serial_n),
    .usb31_phy_rx_serial_p_i_rx_serial_p                        (usb31_phy_rx_serial_p),
    .usb31_phy_tx_serial_n_o_tx_serial_n                        (usb31_phy_tx_serial_n),
    .usb31_phy_tx_serial_p_o_tx_serial_p                        (usb31_phy_tx_serial_p),

    .sys_hps_io_gpio0                                           (hps_gpio0_io0),
    .sys_hps_io_gpio1                                           (hps_gpio0_io1),
    .sys_hps_io_gpio11                                          (hps_gpio0_io11),
    .sys_hps_io_gpio27                                          (hps_gpio1_io3),
    .sys_hps_io_gpio28                                          (hps_gpio1_io4),

    .sys_gpio_bd_in_port                                        (gpio_i[31:0]),
    .sys_gpio_bd_out_port                                       (gpio_o[31:0]),
    .sys_gpio_in_export                                         (gpio_i[63:32]),
    .sys_gpio_out_export                                        (gpio_o[63:32]),

    .sys_cpu_clk_clk                                            (sys_cpu_clk),

    // GTS reset sequencer
    .gts_reset_src_rs_priority_src_rs_priority                  (4'h0),
    .gts_reset_i_src_rs_refclk_status_bus_refclk_status_bus_out (gts_reset_i_src_rs_refclk_status_bus_refclk_status_bus_out),
    .gts_reset_o_refclk_fail_status_refclk_fail_status          (gts_reset_o_refclk_fail_status_refclk_fail_status),
    .gts_reset_o_refclk_on_ack_refclk_on_ack                    (gts_reset_o_refclk_on_ack_refclk_on_ack),
    .gts_reset_i_refclk_on_refclk_on                            (gts_reset_i_refclk_on_refclk_on),
    .gts_reset_o_src_rs_refclk_cmd_bus_refclk_cmd_bus_in        (gts_reset_o_src_rs_refclk_cmd_bus_refclk_cmd_bus_in),
    .gts_reset_o_src_rs_grant_src_rs_grant                      (gts_reset_o_src_rs_grant_src_rs_grant),
    .gts_reset_i_src_rs_req_src_rs_req                          (gts_reset_i_src_rs_req_src_rs_req),
    .gts_reset_o_pma_cu_clk_clk                                 (gts_reset_o_pma_cu_clk_clk),

    .jesd204_phy_a_tx_clkout_clk                                 (phy_a_tx_clkout),
    .jesd204_phy_b_tx_clkout_clk                                 (phy_b_tx_clkout),

    // JESD204 PHY A - link A lanes
    .jesd204_phy_a_i_pma_cu_clk_clk                             (gts_reset_o_pma_cu_clk_clk[0]),
    .jesd204_phy_a_i_src_rs_grant_src_rs_grant                  (gts_reset_o_src_rs_grant_src_rs_grant[PHY_NO_LANES-1:0]),
    .jesd204_phy_a_o_src_rs_req_src_rs_req                      (jesd204_phy_a_o_src_rs_req_src_rs_req),
    .jesd204_phy_a_o_refclk_status_bus_out_refclk_status_bus_out (jesd204_phy_a_o_refclk_status_bus_out_refclk_status_bus_out),
    .jesd204_phy_a_i_refclk_cmd_bus_in_refclk_cmd_bus_in        (gts_reset_o_src_rs_refclk_cmd_bus_refclk_cmd_bus_in),

    .jesd204_phy_a_rx_is_lockedtodata_o_rx_is_lockedtodata      (jesd204_phy_a_rx_is_lockedtodata_o_rx_is_lockedtodata),

    .jesd204_phy_a_system_pll_clk_clk                           (syspll_clk_a),
    .jesd204_phy_a_system_pll_lock_o_pll_lock                   (syspll_lock_a),

    .rx_serial_data_a_i_rx_serial_data                          (rx_data_a_p),
    .rx_serial_data_a_n_i_rx_serial_data_n                      (rx_data_a_n),
    .tx_serial_data_a_o_tx_serial_data                          (tx_data_a_p),
    .tx_serial_data_a_n_o_tx_serial_data_n                      (tx_data_a_n),
    .rx_ref_clk_a_clk                                           (fpga_refclk_in_a),
    .tx_ref_clk_a_clk                                           (fpga_refclk_in_a),
    .phy_a_tx_pll_locked_o_tx_pll_locked                        (phy_a_tx_pll_locked_o_tx_pll_locked),

    // JESD204 PHY B - link B lanes
    .jesd204_phy_b_i_pma_cu_clk_clk                             (gts_reset_o_pma_cu_clk_clk[1]),
    .jesd204_phy_b_i_src_rs_grant_src_rs_grant                  (gts_reset_o_src_rs_grant_src_rs_grant[RX_NO_LANES-1:PHY_NO_LANES]),
    .jesd204_phy_b_o_src_rs_req_src_rs_req                      (jesd204_phy_b_o_src_rs_req_src_rs_req),
    .jesd204_phy_b_o_refclk_status_bus_out_refclk_status_bus_out (jesd204_phy_b_o_refclk_status_bus_out_refclk_status_bus_out),
    .jesd204_phy_b_i_refclk_cmd_bus_in_refclk_cmd_bus_in        (gts_reset_o_src_rs_refclk_cmd_bus_refclk_cmd_bus_in),

    .jesd204_phy_b_rx_is_lockedtodata_o_rx_is_lockedtodata      (jesd204_phy_b_rx_is_lockedtodata_o_rx_is_lockedtodata),

    .jesd204_phy_b_system_pll_clk_clk                           (syspll_clk_b),
    .jesd204_phy_b_system_pll_lock_o_pll_lock                   (syspll_lock_b),

    .rx_serial_data_b_i_rx_serial_data                          (rx_data_b_p),
    .rx_serial_data_b_n_i_rx_serial_data_n                      (rx_data_b_n),
    .tx_serial_data_b_o_tx_serial_data                          (tx_data_b_p),
    .tx_serial_data_b_n_o_tx_serial_data_n                      (tx_data_b_n),
    .rx_ref_clk_b_clk                                           (fpga_refclk_in_b),
    .tx_ref_clk_b_clk                                           (fpga_refclk_in_b),
    .phy_b_tx_pll_locked_o_tx_pll_locked                        (phy_b_tx_pll_locked_o_tx_pll_locked),

    .apollo_rx_jesd204_rx_is_lockedtodata_o_rx_is_lockedtodata  ({jesd204_phy_b_rx_is_lockedtodata_o_rx_is_lockedtodata,
                                                                  jesd204_phy_a_rx_is_lockedtodata_o_rx_is_lockedtodata}),

    .rx_phy_status_rx_reset_done                                (rx_phy_reset_done),
    .rx_phy_status_rx_phy_ready                                 (rx_phy_ready),
    .rx_phy_status_rx_phy_reset_ack                             (rx_phy_reset_ack),
    .tx_phy_status_tx_reset_done                                (tx_phy_reset_done),
    .tx_phy_status_tx_phy_ready                                 (tx_phy_ready),
    .tx_phy_status_tx_phy_reset_ack                             (tx_phy_reset_ack),

    .tx_pll_locked_o_tx_pll_locked                              ({phy_b_tx_pll_locked_o_tx_pll_locked,
                                                                  phy_a_tx_pll_locked_o_tx_pll_locked}),

    // GTS system PLL, one per transceiver bank
    .gts_pll_a_o_pll_lock_o_pll_lock                            (syspll_lock_a),
    .gts_pll_a_o_syspll_c0_clk                                  (syspll_clk_a),
    .gts_pll_a_refclk_xcvr_clk                                  (fpga_refclk_in_a),
    .gts_pll_a_i_refclk_rdy_data                                (refclk_ready),

    .gts_pll_b_o_pll_lock_o_pll_lock                            (syspll_lock_b),
    .gts_pll_b_o_syspll_c0_clk                                  (syspll_clk_b),
    .gts_pll_b_refclk_xcvr_clk                                  (fpga_refclk_in_b),
    .gts_pll_b_i_refclk_rdy_data                                (refclk_ready),

    .apollo_rx_data_offload_sync_ext_sync_ext                   (1'b0),
    .apollo_tx_data_offload_sync_ext_sync_ext                   (1'b0),

    // FMC HPC
    .sys_spi_MISO                                               (spi_sdo),
    .sys_spi_MOSI                                               (spi_sdio),
    .sys_spi_SCLK                                               (spi_clk),
    .sys_spi_SS_n                                               (spi_csn),

    .apollo_spi_MISO                                            (apollo_spi_sdo),
    .apollo_spi_MOSI                                            (apollo_spi_sdio),
    .apollo_spi_SCLK                                            (apollo_spi_clk),
    .apollo_spi_SS_n                                            (apollo_spi_csn),

    .tx_sync_export                                             ({syncinb_b0, syncinb_a0}),
    .tx_sysref_export                                           (sysref_out),
    .tx_device_clk_clk                                          (tx_device_clk),

    .rx_sync_export                                             ({syncoutb_b0, syncoutb_a0}),
    .rx_sysref_export                                           (sysref_out),
    .rx_device_clk_clk                                          (rx_device_clk),

    .apollo_gpio_export ({syncinb_a1_n_gpio,  // 19
                          syncinb_a1_p_gpio,  // 18
                          syncoutb_a1_n_gpio, // 17
                          syncoutb_a1_p_gpio, // 16
                          gpio}));            // 15:0

endmodule
