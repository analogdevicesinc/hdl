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
  parameter RX_JESD_L          = 4,
  parameter RX_JESD_S          = 1,
  parameter RX_JESD_NP         = 16,
  parameter RX_NUM_LINKS       = 1,
  parameter TX_JESD_M          = 4,
  parameter TX_JESD_L          = 4,
  parameter TX_JESD_S          = 1,
  parameter TX_JESD_NP         = 16,
  parameter TX_NUM_LINKS       = 1,
  parameter RX_KS_PER_CHANNEL  = 16,
  parameter TX_KS_PER_CHANNEL  = 16,

  parameter RX_NO_LANES = RX_JESD_L * RX_NUM_LINKS,
  parameter TX_NO_LANES = TX_JESD_L * TX_NUM_LINKS,

  parameter NUM_OF_PHYS = 2,
  parameter PHY_NO_LANES = RX_NO_LANES / NUM_OF_PHYS
) (

  // clock and resets
  input            sys_clk,
  input            sys_resetn,

  // board gpio
  output  [3:0]    fpga_led,
  input   [3:0]    fpga_dipsw,
  input   [3:0]    fpga_btn,

  // emif
  input            emif_ref_clk,
  output           emif_mem_ck_t,
  output           emif_mem_ck_c,
  output [ 16:0]   emif_mem_a,
  output           emif_mem_act_n,
  output [  1:0]   emif_mem_ba,
  output [  1:0]   emif_mem_bg,
  output           emif_mem_cke,
  output           emif_mem_cs_n,
  output           emif_mem_odt,
  output           emif_mem_reset_n,
  output           emif_mem_par,
  input            emif_mem_alert_n,
  input            emif_oct_rzqin,
  inout  [  4:0]   emif_mem_dqs_t,
  inout  [  4:0]   emif_mem_dqs_c,
  inout  [ 39:0]   emif_mem_dq,
  inout  [  4:0]   emif_mem_dbi_n,


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
  input          sysref_in,

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
  wire          pma_cu_clk;

  wire          syspll_clk_a;
  wire          syspll_lock_a;
  wire          syspll_clk_b;
  wire          syspll_lock_b;

  wire          refclk_ready;
  wire          refclk_ready_1;
  wire          refclk_ready_0;

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

  // Per-PHY reset status out of axi_adxcvr, already in the sys_clk domain.
  wire [NUM_OF_PHYS-1:0]        rx_phy_reset_done;
  wire [NUM_OF_PHYS-1:0]        rx_phy_ready;
  wire [NUM_OF_PHYS-1:0]        rx_phy_reset_ack;
  wire [NUM_OF_PHYS-1:0]        tx_phy_reset_done;
  wire [NUM_OF_PHYS-1:0]        tx_phy_ready;
  wire [NUM_OF_PHYS-1:0]        tx_phy_reset_ack;

  localparam DBG_STATUS_W = 10 + 4*NUM_OF_PHYS + 4*PHY_NO_LANES;

  wire [DBG_STATUS_W-1:0]       dbg_status_s;

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


  // Board GPIOs
  assign fpga_led      = gpio_o[3:0];
  assign gpio_i[ 3: 0] = gpio_o[3:0];
  assign gpio_i[ 7: 4] = fpga_dipsw;
  assign gpio_i[11: 8] = fpga_btn;

  // FMC GPIOs
  assign gpio_i[47:32] = gpio[30:15];
  assign gpio_i[   53] = trig_in;

  assign trig_a[0]  = gpio_o[58];
  assign trig_a[1]  = gpio_o[59];
  assign trig_b[0]  = gpio_o[60];
  assign trig_b[1]  = gpio_o[61];
  assign resetb     = gpio_o[62];

  assign refclk_ready_1 = gpio_o[56];
  assign refclk_ready_0 = gpio_o[57];

  /*
   * Both adxcvr instances must report their refclk stable: unlike ad9081, the
   * RX and TX refclks are separate inputs on this board.
   */
  assign refclk_ready = refclk_ready_1 && refclk_ready_0;

//  /*
//   * Per-PHY link bring-up status, read back through sys_gpio_bd (gpio_i[31:0])
//   * and sys_gpio_in (gpio_i[63:32]). The link-layer and axi_adxcvr registers
//   * only expose these signals after an AND/OR across both PHYs, which hides
//   * which transceiver bank failed.
//   *
//   *   [13:12] phy_a rx_is_lockedtodata     [19:18] phy_b tx_pll_locked
//   *   [15:14] phy_b rx_is_lockedtodata     [   20] phy_a rx_ready
//   *   [17:16] phy_a tx_pll_locked          [   21] phy_b rx_ready
//   *   [   22] phy_a tx_ready               [   24] phy_a rx_reset_ack
//   *   [   23] phy_b tx_ready               [   25] phy_b rx_reset_ack
//   *   [   26] phy_a tx_reset_ack           [   27] phy_b tx_reset_ack
//   *   [31:28] refclk_fail_status[3:0]      [51:48] refclk_fail_status[7:4]
//   *   [   54] gts_pll locked
//   *
//   * These come from the PHY and GTS sequencer clock domains. The PIOs generate
//   * interrupts, so the paths reach the CPU and must be synchronized rather than
//   * declared false.
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
//  assign gpio_i[51:48] = dbg_status_s[23:20];
//  assign gpio_i[   54] = dbg_status_s[DBG_STATUS_W-2];
//  assign gpio_i[   55] = dbg_status_s[DBG_STATUS_W-1];

  // Debug signals above are commented out; the freed inputs read back what
  // software wrote so the PIOs stay driven.
  assign gpio_i[31:12] = gpio_o[31:12];
  assign gpio_i[51:48] = gpio_o[51:48];
  assign gpio_i[55:54] = gpio_o[55:54];

  // Unused GPIOs
  assign gpio_i[63:56] = gpio_o[63:56];
  assign gpio_i[   52] = gpio_o[52];

  assign sys_reset_n = sys_resetn & ~ninit_done;


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
    // No TDD in this project: the offload FSM must not see an external sync.
    .apollo_rx_data_offload_sync_ext_sync_ext                   (1'b0),
    .apollo_tx_data_offload_sync_ext_sync_ext                   (1'b0),

    .sys_clk_clk                                                (sys_clk),

    .sys_rst_reset_n                                            (sys_reset_n),
    .rst_ninit_done                                             (ninit_done),

    .pr_rom_data_nc_rom_data                                    ('h0),
    .o_pma_cu_clk_clk                                           (pma_cu_clk),

    .emif_mem_0_mem_cke                                         (emif_mem_cke),
    .emif_mem_0_mem_odt                                         (emif_mem_odt),
    .emif_mem_0_mem_cs_n                                        (emif_mem_cs_n),
    .emif_mem_0_mem_a                                           (emif_mem_a),
    .emif_mem_0_mem_ba                                          (emif_mem_ba),
    .emif_mem_0_mem_bg                                          (emif_mem_bg),
    .emif_mem_0_mem_act_n                                       (emif_mem_act_n),
    .emif_mem_0_mem_par                                         (emif_mem_par),
    .emif_mem_0_mem_dq                                          (emif_mem_dq),
    .emif_mem_0_mem_dqs_t                                       (emif_mem_dqs_t),
    .emif_mem_0_mem_dqs_c                                       (emif_mem_dqs_c),
    .emif_mem_0_mem_alert_n                                     (emif_mem_alert_n),
    .emif_mem_0_mem_dbi_n                                       (emif_mem_dbi_n),
    .emif_mem_ck_0_mem_ck_t                                     (emif_mem_ck_t),
    .emif_mem_ck_0_mem_ck_c                                     (emif_mem_ck_c),
    .emif_mem_reset_n_mem_reset_n                               (emif_mem_reset_n),
    .emif_oct_0_oct_rzqin                                       (emif_oct_rzqin),
    .emif_ref_clk_0_clk                                         (emif_ref_clk),

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

    // GTS system PLL
    // GTS system PLL, one per transceiver bank
    .gts_pll_a_o_pll_lock_o_pll_lock                            (syspll_lock_a),
    .gts_pll_a_o_syspll_c0_clk                                  (syspll_clk_a),
    .gts_pll_a_refclk_xcvr_clk                                  (fpga_refclk_in_a),
    .gts_pll_a_i_refclk_rdy_data                                (refclk_ready),

    .gts_pll_b_o_pll_lock_o_pll_lock                            (syspll_lock_b),
    .gts_pll_b_o_syspll_c0_clk                                  (syspll_clk_b),
    .gts_pll_b_refclk_xcvr_clk                                  (fpga_refclk_in_b),
    .gts_pll_b_i_refclk_rdy_data                                (refclk_ready),

    // FMC HPC
    .sys_spi_MISO                                               (spi_sdo),
    .sys_spi_MOSI                                               (spi_sdio),
    .sys_spi_SCLK                                               (spi_clk),
    .sys_spi_SS_n                                               (spi_csn),

    .apollo_spi_MISO                                            (apollo_spi_sdo),
    .apollo_spi_MOSI                                            (apollo_spi_sdio),
    .apollo_spi_SCLK                                            (apollo_spi_clk),
    .apollo_spi_SS_n                                            (apollo_spi_csn),

    /*
     * Bit 0 of the sync vectors is the side-B pin: with the opposite order the
     * link layer's per-link SYNC~ reaches the wrong Apollo framer (link 0 goes
     * INIT while Apollo reports A0 deasserted and B0 asserted).
     */
    .tx_sync_export                                             ({syncinb_a0, syncinb_b0}),
    .tx_sysref_export                                           (sysref_in),
    .tx_device_clk_clk                                          (tx_device_clk),

    .rx_sync_export                                             ({syncoutb_a0, syncoutb_b0}),
    .rx_sysref_export                                           (sysref_in),
    .rx_device_clk_clk                                          (rx_device_clk),

    .apollo_gpio_export ({syncinb_a1_n_gpio,  // 19
                          syncinb_a1_p_gpio,  // 18
                          syncoutb_a1_n_gpio, // 17
                          syncoutb_a1_p_gpio, // 16
                          gpio}));            // 15:0

endmodule
