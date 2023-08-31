// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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

module system_top #(
  // Dummy parameters to workaround critical warning
  parameter RX_LANE_RATE       = 10,
  parameter TX_LANE_RATE       = 10,
  parameter RX_JESD_M          = 8,
  parameter RX_JESD_L          = 4,
  parameter RX_JESD_S          = 1,
  parameter RX_JESD_NP         = 16,
  parameter RX_NUM_LINKS       = 1,
  parameter TX_JESD_M          = 8,
  parameter TX_JESD_L          = 4,
  parameter TX_JESD_S          = 1,
  parameter TX_JESD_NP         = 16,
  parameter TX_NUM_LINKS       = 1,
  parameter RX_KS_PER_CHANNEL  = 32,
  parameter TX_KS_PER_CHANNEL  = 32
) (

   // clock and resets
  input            sys_clk,
  input            hps_io_ref_clk,
  // input         refclk_bti, // additional refclk_bti to preserve Etile XCVR
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
  inout   [ 2:0]   hps_gpio_led,

  // FMC HPC IOs

  // lane interface
  input                   clkin6,
  input                   fpga_refclk_in,
  input   [RX_JESD_L-1:0] rx_data,
  output  [TX_JESD_L-1:0] tx_data,
  input                   fpga_syncin_0,
  output                  fpga_syncin_1_n,
  output                  fpga_syncin_1_p,
  output                  fpga_syncout_0,
  output                  fpga_syncout_1_n,
  output                  fpga_syncout_1_p,
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
  inout   [10:0]          gpio,
  inout                   hmc_gpio1,
  output                  hmc_sync,
  input   [1:0]           irqb,
  output                  rstb,
  output  [1:0]           rxen,
  output  [1:0]           txen,

  // New
  // external sysref input
  input                   mgmt_clk,
  input                   in_sysref,
  output  [LINK-1:0]      tx_link_error,
  output  [LINK-1:0]      rx_link_error,
  input   [LINK*L-1:0]    rx_serial_data_p,
  input   [LINK*L-1:0]    rx_serial_data_n,
  output  [LINK*L-1:0]    tx_serial_data_p,
  output  [LINK*L-1:0]    tx_serial_data_n,
  input                   refclk_core,
  input                   spi_MISO,
  output                  spi_MOSI,
  output                  spi_SCLK,
  output  [2:0]           spi_SS_n);

  // internal signals
  wire  [63:0]  gpio_i;
  wire  [63:0]  gpio_o;
  wire  [ 7:0]  fpga_dipsw;
  wire  [ 7:0]  fpga_led;
  wire          sys_reset_n;
  wire  [43:0]  stm_hw_events;
  wire          h2f_reset;
  wire  [ 7:0]  spi_csn_s;

  // Board GPIOs
  assign fpga_led      = gpio_o[7:0];
  assign gpio_i[ 7:0]  = gpio_o[7:0];
  assign gpio_i[15: 8] = fpga_dipsw;
  assign gpio_i[17:16] = fpga_gpio[ 1:0]; // push buttons
  assign gpio_i[28:18] = fpga_gpio[12:2];

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

  assign hmc_sync   = gpio_o[54];
  assign rstb       = gpio_o[55];
  assign rxen[0]    = gpio_o[56];
  assign rxen[1]    = gpio_o[57];
  assign txen[0]    = gpio_o[58];
  assign txen[1]    = gpio_o[59];

  // Unused GPIOs
  assign gpio_i[63:54] = gpio_o[63:54];
  assign gpio_i[43:32] = gpio_o[43:32];
  assign gpio_i[31:29] = gpio_o[31:29];

  // assignmnets
  assign sys_reset_n   = sys_resetn & ~h2f_reset & ~ninit_done;
  assign stm_hw_events = {14'b0, fpga_led, fpga_dipsw, fpga_gpio[1:0]};

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

  gpio_slave i_gpio_slave (
    .reset_n    (sys_reset_n),
    .clk        (fpga_sgpio_clk),
    .sync       (fpga_sgpio_sync),
    .miso       (fpga_sgpo),
    .mosi       (fpga_sgpi),
    .leds       (fpga_led),
    .dipsw      (fpga_dipsw));

  wire txframe_clk;
  wire tx_fclk;
  wire rxframe_clk;
  wire rx_fclk;

  wire [0:0]                                      ed_control_rst_sts_detected0_rst_sts_set_i;
  wire                                            ed_ctrl_out_ip_sysref_mgmtclk;
  wire [3:0]                                      ed_control_tst_err0_tst_error_i;
  wire [0:0]                                      ed_control_rst_sts0_rst_status_i;
  wire                                             edctl_rst_n;

  wire [LINK-1:0]                                  tx_rst;
  wire [LINK-1:0]                                  rx_rst;
  wire [LINK-1:0][(TOTAL_CS)-1:0]                  tx_avst_control;
  wire [LINK-1:0][(TOTAL_CS)-1:0]                  rx_avst_control;
  wire [LINK-1:0]                                  tx_sysref;
  wire [LINK-1:0]                                  rx_sysref;
  wire                                            ed_ctrl_out_ip_sysref;
  wire [LINK-1:0][L-1:0]                           tx_serial_data_p_reordered;
  wire [LINK-1:0][L-1:0]                           tx_serial_data_n_reordered;
  wire [LINK-1:0][L-1:0]                           rx_serial_data_p_reordered;
  wire [LINK-1:0][L-1:0]                           rx_serial_data_n_reordered;
  wire [LINK-1:0]                                  tx_rst_ack_n;
  wire [LINK-1:0]                                  rx_rst_ack_n;
  wire                                             txlink_clk;
  wire                                             rxlink_clk;
  wire                                             ninit_done;
  wire                                             mgmt_rst_in_n;
  wire                                             core_pll_locked_reg2;


  assign ed_control_rst_sts_detected0_rst_sts_set_i = ed_ctrl_out_ip_sysref_mgmtclk;
  assign ed_control_tst_err0_tst_error_i = {cmd_ramp_chk_err_mgmtclk[0], rx_link_error_mgmtclk[0], tx_link_error_mgmtclk[0], rx_patchk_data_error_mgmtclk[0]};
  assign ed_control_rst_sts0_rst_status_i = core_pll_locked_reg2;

  system_bd i_system_bd (
    .rst_ninit_done                           (ninit_done),
    .pr_rom_data_nc_rom_data                  (),
    .ed_control_txframe_clk_clk               (txframe_clk),
    .ed_control_tx_phase_clk                  (tx_fclk),
    .ed_control_rxframe_clk_clk               (rxframe_clk),
    .ed_control_rx_phase_clk                  (rx_fclk),
    .ed_control_in_sysref_export              (in_sysref),
    .ed_control_rst_sts_detected0_rst_sts_set_i_export (ed_control_rst_sts_detected0_rst_sts_set_i),
    .ed_control_tst_err0_tst_error_i_export  (ed_control_tst_err0_tst_error_i),
    .ed_control_rst_sts0_rst_status_i_export (ed_control_rst_sts0_rst_status_i),
    .ed_control_out_ip_sysref_export         (ed_ctrl_out_ip_sysref),
    .edctl_rst_reset_n                       (edctl_rst_n),
    .emif_hps_pll_ref_clk                    (emif_hps_pll_ref_clk),
    .emif_hps_oct_rzqin                      (emif_hps_oct_rzq),
    .emif_hps_ddr_mem_ck                     (emif_hps_mem_clk_p),
    .emif_hps_ddr_mem_ck_n                   (emif_hps_mem_clk_n),
    .emif_hps_ddr_mem_a                      (emif_hps_mem_a),
    .emif_hps_ddr_mem_act_n                  (emif_hps_mem_act_n),
    .emif_hps_ddr_mem_ba                     (emif_hps_mem_ba),
    .emif_hps_ddr_mem_bg                     (emif_hps_mem_bg),
    .emif_hps_ddr_mem_cke                    (emif_hps_mem_cke),
    .emif_hps_ddr_mem_cs_n                   (emif_hps_mem_cs_n),
    .emif_hps_ddr_mem_odt                    (emif_hps_mem_odt),
    .emif_hps_ddr_mem_reset_n                (emif_hps_mem_reset_n),
    .emif_hps_ddr_mem_par                    (emif_hps_mem_par),
    .emif_hps_ddr_mem_alert_n                (emif_hps_mem_alert_n),
    .emif_hps_ddr_mem_dqs                    (emif_hps_mem_dqs_p),
    .emif_hps_ddr_mem_dqs_n                  (emif_hps_mem_dqs_n),
    .emif_hps_ddr_mem_dq                     (emif_hps_mem_dq),
    .emif_hps_ddr_mem_dbi_n                  (emif_hps_mem_dbi_n),
    .fpga_m_master_address                   (),
    .fpga_m_master_readdata                  (),
    .fpga_m_master_read                      (),
    .fpga_m_master_write                     (),
    .fpga_m_master_writedata                 (),
    .fpga_m_master_waitrequest               (),
    .fpga_m_master_readdatavalid             (),
    .fpga_m_master_byteenable                (),
    .j204c_tx_rst_n_reset_n                  (~tx_rst[0]),
    .j204c_txlclk_ctrl_export                (1'b1),
    .j204c_txfclk_ctrl_export                (tx_fclk),
    .j204c_tx_avst_control_export            (tx_avst_control[0]),
    .j204c_tx_sysref_export                  (tx_sysref),
    .j204c_tx_int_irq                        (tx_link_error[0]),
    .j204c_rx_int_irq                        (rx_link_error[0]),
    .j204c_rxlclk_ctrl_export                (1'b1),
    .j204c_rxfclk_ctrl_export                (rx_fclk),
    .j204c_rx_sysref_export                  (rx_sysref),
    .j204c_rx_rst_n_reset_n                  (~rx_rst[0]),
    .j204c_rx_avst_control_export            (rx_avst_control[0]),
    .j204c_tx_serial_data_p_export           (tx_serial_data_p_reordered),
    .j204c_tx_serial_data_n_export           (tx_serial_data_n_reordered),
    .j204c_rx_serial_data_p_export           (rx_serial_data_p_reordered),
    .j204c_rx_serial_data_n_export           (rx_serial_data_n_reordered),
    .j204c_rx_rst_ack_n_export               (rx_rst_ack_n[0]),
    .j204c_tx_rst_ack_n_export               (tx_rst_ack_n[0]),
    .jtag_reset_clk_clk                      (mgmt_clk),
    .jtag_reset_in_reset_reset_n             (~ninit_done),
    .jtag_rst_bridge_out_reset_reset_n       (),
    .mgmt_clk_clk                            (mgmt_clk),
    .mgmt_reset_reset_n                      (mgmt_rst_in_n),
    .mxfe_gpio_export                        ({fpga_syncout_1_n,  // 14
                                               fpga_syncout_1_p,  // 13
                                               fpga_syncin_1_n,   // 12
                                               fpga_syncin_1_p,   // 11
                                               gpio}),            // 10:0
    .pio_control_external_export             (),
    .pio_status_external_export              (),
    .refclk_core_clk                         (refclk_core),
    .rst_seq_0_reset_out3_reset              (tx_rst[0]),
    .rst_seq_1_reset_out2_reset              (rx_rst[0]),
    .rst_seq_0_reset1_dsrt_qual_reset1_dsrt_qual(core_pll_locked_reg2),
    .rst_seq_0_reset2_dsrt_qual_reset2_dsrt_qual(~tx_rst_ack_n[0]),
    .rst_seq_0_av_csr_irq_irq                   (),
    .rst_seq_1_reset0_dsrt_qual_reset0_dsrt_qual(core_pll_locked_reg2),
    .rst_seq_1_reset1_dsrt_qual_reset1_dsrt_qual(~rx_rst_ack_n[0]),
    .rst_seq_1_av_csr_irq_irq                (),
    .rxframe_clk_clk                         (rxframe_clk),
    .rxlink_clk_clk                          (rxlink_clk),
    .spi_0_irq_irq                           (),
    .spi_0_external_MISO                     (spi_MISO),
    .spi_0_external_MOSI                     (spi_MOSI_buf),
    .spi_0_external_SCLK                     (spi_SCLK),
    .spi_0_external_SS_n                     (spi_SS_n),
    .sys_clk_clk                             (sys_clk),
    .sys_rst_reset_n                         (sys_reset_n),
    .sys_gpio_bd_in_port                     (gpio_i[31: 0]),
    .sys_gpio_bd_out_port                    (gpio_o[31: 0]),
    .sys_gpio_in_export                      (gpio_i[63:32]),
    .sys_gpio_out_export                     (gpio_o[63:32]),
    .sys_hps_f2h_stm_hwevents                (stm_hw_events),
    .sys_hps_h2f_cs_ntrst                    (1'b1),
    .sys_hps_h2f_cs_tck                      (1'b1),
    .sys_hps_h2f_cs_tdi                      (1'b1),
    .sys_hps_h2f_cs_tdo                      (),
    .sys_hps_h2f_cs_tdoen                    (),
    .sys_hps_h2f_cs_tms                      (1'b1),
    .sys_hps_io_EMAC0_TX_CLK                 (hps_emac_txclk),
    .sys_hps_io_EMAC0_TXD0                   (hps_emac_txd[0]),
    .sys_hps_io_EMAC0_TXD1                   (hps_emac_txd[1]),
    .sys_hps_io_EMAC0_TXD2                   (hps_emac_txd[2]),
    .sys_hps_io_EMAC0_TXD3                   (hps_emac_txd[3]),
    .sys_hps_io_EMAC0_RX_CTL                 (hps_emac_rxctl),
    .sys_hps_io_EMAC0_TX_CTL                 (hps_emac_txctl),
    .sys_hps_io_EMAC0_RX_CLK                 (hps_emac_rxclk),
    .sys_hps_io_EMAC0_RXD0                   (hps_emac_rxd[0]),
    .sys_hps_io_EMAC0_RXD1                   (hps_emac_rxd[1]),
    .sys_hps_io_EMAC0_RXD2                   (hps_emac_rxd[2]),
    .sys_hps_io_EMAC0_RXD3                   (hps_emac_rxd[3]),
    .sys_hps_io_EMAC0_MDIO                   (hps_emac_mdio),
    .sys_hps_io_EMAC0_MDC                    (hps_emac_mdc),
    .sys_hps_io_SDMMC_CMD                    (hps_sdio_cmd),
    .sys_hps_io_SDMMC_D0                     (hps_sdio_d[0]),
    .sys_hps_io_SDMMC_D1                     (hps_sdio_d[1]),
    .sys_hps_io_SDMMC_D2                     (hps_sdio_d[2]),
    .sys_hps_io_SDMMC_D3                     (hps_sdio_d[3]),
    .sys_hps_io_SDMMC_CCLK                   (hps_sdio_clk),
    .sys_hps_io_USB0_DATA0                   (hps_usb_d[0]),
    .sys_hps_io_USB0_DATA1                   (hps_usb_d[1]),
    .sys_hps_io_USB0_DATA2                   (hps_usb_d[2]),
    .sys_hps_io_USB0_DATA3                   (hps_usb_d[3]),
    .sys_hps_io_USB0_DATA4                   (hps_usb_d[4]),
    .sys_hps_io_USB0_DATA5                   (hps_usb_d[5]),
    .sys_hps_io_USB0_DATA6                   (hps_usb_d[6]),
    .sys_hps_io_USB0_DATA7                   (hps_usb_d[7]),
    .sys_hps_io_USB0_CLK                     (hps_usb_clk),
    .sys_hps_io_USB0_STP                     (hps_usb_stp),
    .sys_hps_io_USB0_DIR                     (hps_usb_dir),
    .sys_hps_io_USB0_NXT                     (hps_usb_nxt),
    .sys_hps_io_UART0_RX                     (hps_uart_rx),
    .sys_hps_io_UART0_TX                     (hps_uart_tx),
    .sys_hps_io_I2C1_SDA                     (hps_i2c_sda),
    .sys_hps_io_I2C1_SCL                     (hps_i2c_scl),
    .sys_hps_io_gpio1_io0                    (hps_gpio_eth_irq),
    .sys_hps_io_gpio1_io1                    (hps_gpio_usb_oci),
    .sys_hps_io_gpio1_io4                    (hps_gpio_btn[0]),
    .sys_hps_io_gpio1_io5                    (hps_gpio_btn[1]),
    .sys_hps_io_jtag_tck                     (hps_jtag_tck),
    .sys_hps_io_jtag_tms                     (hps_jtag_tms),
    .sys_hps_io_jtag_tdo                     (hps_jtag_tdo),
    .sys_hps_io_jtag_tdi                     (hps_jtag_tdi),
    .sys_hps_io_hps_osc_clk                  (hps_io_ref_clk),
    .sys_hps_io_gpio1_io19                   (hps_gpio_led[1]),
    .sys_hps_io_gpio1_io20                   (hps_gpio_led[0]),
    .sys_hps_io_gpio1_io21                   (hps_gpio_led[2]),
    .h2f_reset_reset                         (h2f_reset),
    .sys_spi_MISO                            (spi_miso),
    .sys_spi_MOSI                            (spi_mosi),
    .sys_spi_SCLK                            (spi_clk),
    .sys_spi_SS_n                            (spi_csn_s),
    .systemclk_f_0_refclk_fgt_in_refclk_fgt_6(),
    .txframe_clk_clk                         (txframe_clk),
    .txlink_clk_clk                          (txlink_clk));

  j204c_gdr_bit_synchronizer core_pll_locked_sync (
    .source_clk(1'b0),
    .source_clk_rstn(1'b0),
    .dest_clk(mgmt_clk),
    .dest_clk_rstn(mgmt_rst_in_n),
    .datain(core_pll_locked),
    .dataout(core_pll_locked_reg2)
  );

  generate
  for (i=0; i<LINK; i=i+1) begin: GEN_BLOCK
      assign rx_serial_data_p_reordered[i] = rx_serial_data_p[i*L+L-1:i*L];
      assign rx_serial_data_n_reordered[i] = rx_serial_data_n[i*L+L-1:i*L];
      assign tx_serial_data_p[i*L+L-1:i*L] = tx_serial_data_p_reordered[i];
      assign tx_serial_data_n[i*L+L-1:i*L] = tx_serial_data_n_reordered[i];
    end
  endgenerate
  generate
    for (i=0; i<LINK; i=i+1) begin: GEN_SYSREF
        assign tx_sysref[i] = ed_ctrl_out_ip_sysref;
        assign rx_sysref[i] = ed_ctrl_out_ip_sysref;
    end
  endgenerate

    j204c_gdr_pulse_cdc sysref_sts_sync_inst(
             .source_clk        (txlink_clk),
             .source_clk_rstn   (mgmt_txlinkrst_n),
             .dest_clk          (mgmt_clk),
             .dest_clk_rstn     (mgmt_rst_in_n),
             .datain          (ip_sysref_rise),
             .dataout           (ed_ctrl_out_ip_sysref_mgmtclk)
    );

  `ifndef ALTERA_RESERVED_QIS
  //  for Simulation
    //synchronizer perst_n reset to mgmt_clk
    j204c_gdr_bit_synchronizer edctl_rstn_sync_inst (
      .source_clk(1'b0),
      .source_clk_rstn(1'b0),
      .dest_clk(mgmt_clk),
      .dest_clk_rstn(~ninit_done),
      .datain(1'b1),
      .dataout(edctl_rst_n)
    );
    assign mgmt_rst_in_n = global_rst_n & ~hw_rst & edctl_rst_n;
  `else
  //  only for SYNTHESIS
    j204c_gdr_bit_synchronizer edctl_rstn_sync_inst (
      .source_clk(1'b0),
      .source_clk_rstn(1'b0),
      .dest_clk(mgmt_clk),
      .dest_clk_rstn(~jtag_avmm_rst),
      .datain(1'b1),
      .dataout(edctl_rst_n)
    );
    assign mgmt_rst_in_n = db_global_rst_n & ~hw_rst & edctl_rst_n;
  `endif

  altera_s10_user_rst_clkgate_0 u_j204c_ed_reset (
    .ninit_done   (ninit_done)
  );

endmodule
