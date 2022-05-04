// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2022 (c) Analog Devices, Inc. All rights reserved.
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
  parameter RX_JESD_M          = 16,
  parameter RX_JESD_L          = 4,
  parameter RX_JESD_S          = 1,
  parameter RX_JESD_NP         = 16,
  parameter RX_NUM_LINKS       = 4,
  parameter TX_JESD_M          = 16,
  parameter TX_JESD_L          = 4,
  parameter TX_JESD_S          = 1,
  parameter TX_JESD_NP         = 16,
  parameter TX_NUM_LINKS       = 4,
  parameter RX_KS_PER_CHANNEL  = 16,
  parameter TX_KS_PER_CHANNEL  = 16
) (

  // clock and resets

  input             sys_clk,
  input             fpga_resetn,
  input             hps_ref_clk,

  // hps-ddr4 (72)

  input             hps_ddr_ref_clk,
  input             hps_ddr_rzq,
  output  [ 16:0]   hps_ddr_a,
  output  [  0:0]   hps_ddr_act_n,
  input   [  0:0]   hps_ddr_alert_n,
  output  [  1:0]   hps_ddr_ba,
  output  [  0:0]   hps_ddr_bg,
  output  [  0:0]   hps_ddr_ck,
  output  [  0:0]   hps_ddr_ck_n,
  output  [  0:0]   hps_ddr_cke,
  output  [  0:0]   hps_ddr_odt,
  output  [  0:0]   hps_ddr_par,
  output  [  0:0]   hps_ddr_cs_n,
  output  [  0:0]   hps_ddr_reset_n,
  inout   [  8:0]   hps_ddr_dqs_p,
  inout   [  8:0]   hps_ddr_dqs_n,
  inout   [  8:0]   hps_ddr_dbi_n,
  inout   [ 71:0]   hps_ddr_dq,

  // hps-ethernet

  input   [  0:0]   hps_emac_rx_clk,
  input   [  0:0]   hps_emac_rx_ctl,
  input   [  3:0]   hps_emac_rx,
  output  [  0:0]   hps_emac_tx_clk,
  output  [  0:0]   hps_emac_tx_ctl,
  output  [  3:0]   hps_emac_tx,
  output  [  0:0]   hps_emac_mdc,
  inout   [  0:0]   hps_emac_mdio,

  // hps-usb

  input   [  0:0]   hps_usb_clk,
  input   [  0:0]   hps_usb_dir,
  input   [  0:0]   hps_usb_nxt,
  output  [  0:0]   hps_usb_stp,
  inout   [  7:0]   hps_usb_data,

  // hps-uart

  input   [  0:0]   hps_uart_rx,
  output  [  0:0]   hps_uart_tx,

  // hps-i2c (shared w fmc-a, fmc-b)

  inout   [  0:0]   hps_i2c_sda,
  inout   [  0:0]   hps_i2c_scl,

  // fpga-gpio motherboard (led/dpsw/button)

  input   [  3:0]   fpga_gpio_dpsw,
  input   [  3:0]   fpga_gpio_btn,
  output  [  3:0]   fpga_gpio_led,

  // sdmmc-interface

  output            hps_sdmmc_clk,
  inout             hps_sdmmc_cmd,
  inout   [  3:0]   hps_sdmmc_data,

  // jtag-interface

  input             hps_jtag_tck,
  input             hps_jtag_tms,
  output            hps_jtag_tdo,
  input             hps_jtag_tdi,

  // hps-OOBE daughter card peripherals

  inout             hps_gpio_eth_irq,
  inout             hps_gpio_usb_oci,
  inout   [  1:0]   hps_gpio_btn,
  inout   [  2:0]   hps_gpio_led,

  // FMCp IOs

  output  [  3:0]  adf4371_cs,
  inout            adf4371_sdio,
  output           adf4371_sclk,

  output           adrf5020_ctrl,

  input   [  2:0]  fpga_clk_m2c,
  output           fpga_sysref_c2m,
  input            fpga_sysref_m2c,

  output  [ 15:0]  c2m,
  input   [ 15:0]  m2c,

  output           mxfe_syncin_0_p,
  output           mxfe_syncin_2_p,
  output           mxfe_syncin_4_p,
  output           mxfe_syncin_6_p,

  input            mxfe_syncout_0_p,
  input            mxfe_syncout_2_p,
  input            mxfe_syncout_4_p,
  input            mxfe_syncout_6_p,

  // Sync pins used as GPIOs
  // MxFE0 GPIOs

  inout            mxfe_syncin_0_n,
  inout            mxfe_syncin_1_p,
  inout            mxfe_syncout_0_n,
  inout            mxfe_syncout_1_p,
  inout   [  8:0]  mxfe0_gpio,

  // MxFE1 GPIOs

  inout            mxfe_syncin_1_n,
  inout            mxfe_syncin_3_p,
  inout            mxfe_syncout_1_n,
  inout            mxfe_syncout_3_p,
  inout   [  8:0]  mxfe1_gpio,
  
  // MxFE2 GPIOs

  inout            mxfe_syncin_2_n,
  inout            mxfe_syncin_5_p,
  inout            mxfe_syncout_2_n,
  inout            mxfe_syncout_5_p,
  inout   [  8:0]  mxfe2_gpio,

  // MxFE3 GPIOs

  inout            mxfe_syncin_3_n,
  inout            mxfe_syncin_7_p,
  inout            mxfe_syncout_3_n,
  inout            mxfe_syncout_7_p,
  inout   [  8:0]  mxfe3_gpio,

  inout            hmc7043_gpio,
  output           hmc7043_reset,
  output           hmc7043_sclk,
  inout            hmc7043_sdata,
  output           hmc7043_slen,

  output  [  4:1]  hmc425a_v,

  output  [  3:0]  mxfe_sclk,
  output  [  3:0]  mxfe_cs,
  input   [  3:0]  mxfe_miso,
  output  [  3:0]  mxfe_mosi,

  output  [  3:0]  mxfe_reset,
  output  [  3:1]  mxfe_rx_en0,
  output  [  3:1]  mxfe_rx_en1,
  output  [  3:0]  mxfe_tx_en0,
  output  [  3:0]  mxfe_tx_en1

);

  // internal signals

  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;

  wire    [ 63:0]   gpio2_i;
  wire    [ 63:0]   gpio2_o;
  wire    [ 63:0]   gpio2_t;
  
  wire              spi_clk;
  wire    [  7:0]   spi_csn;
  wire              spi_mosi;
  wire              spi_miso;
  wire              spi_4371_miso;
  wire              spi_hmc_miso;

  wire              spi_2_clk;
  wire    [  7:0]   spi_2_csn;
  wire              spi_2_mosi;
  wire              spi_2_miso;

  wire              ninit_done_s;
  wire              h2f_reset_s;
  wire              sys_resetn_s;

  wire    [  3:0]   link0_rx_syncout;
  wire    [  3:0]   link0_tx_syncin;

  // motherboard-gpio

  assign gpio_i[3:0]   = fpga_gpio_dpsw;
  assign gpio_i[7:4]   = fpga_gpio_btn;
  assign gpio_i[31:8]  = gpio_o[31:8];
  assign fpga_gpio_led = gpio_o[11:8];

  // IO gpio assignments

  assign hmc7043_gpio  = gpio_o[32];
  assign hmc7043_reset = gpio_o[33];
  assign adrf5020_ctrl = gpio_o[34];
  assign hmc425a_v     = gpio_o[38:35];
  assign mxfe_reset    = gpio_o[44:41];
  assign mxfe_rx_en0   = gpio_o[47:45];
  assign mxfe_rx_en1   = gpio_o[50:48];
  assign mxfe_tx_en0   = gpio_o[54:51];
  assign mxfe_tx_en1   = gpio_o[58:55];
  assign gpio_i[63:32] = gpio_o[63:32];

  // Initialize gpio2_t with 0 to bypass ad_iobuf instances used in quad_mxfe_gpio_mux

  assign gpio2_t = 64'h0000000000000000;

  // Link 0 SYNC single ended lines

  assign mxfe_syncin_0_p = link0_rx_syncout[0];
  assign mxfe_syncin_2_p = link0_rx_syncout[1];
  assign mxfe_syncin_4_p = link0_rx_syncout[2];
  assign mxfe_syncin_6_p = link0_rx_syncout[3];

  assign link0_tx_syncin[0] = mxfe_syncout_0_p;
  assign link0_tx_syncin[1] = mxfe_syncout_2_p;
  assign link0_tx_syncin[2] = mxfe_syncout_4_p;
  assign link0_tx_syncin[3] = mxfe_syncout_6_p;

  // instantiations

  // spi

  assign mxfe_cs = spi_csn[3:0];
  assign mxfe_mosi = {4{spi_mosi}};
  assign mxfe_sclk = {4{spi_clk}};

  assign adf4371_cs = spi_2_csn[3:0];
  assign adf4371_sclk = spi_2_clk;

  assign hmc7043_slen = spi_2_csn[4];
  assign hmc7043_sclk = spi_2_clk;

  assign spi_miso = ~spi_csn[0] ? mxfe_miso[0] :
                    ~spi_csn[1] ? mxfe_miso[1] :
                    ~spi_csn[2] ? mxfe_miso[2] :
                    ~spi_csn[3] ? mxfe_miso[3] :
                    1'b0;

  assign spi_2_miso = | (~spi_2_csn[3:0]) ? spi_4371_miso :
                         ~spi_2_csn[4]    ? spi_hmc_miso :
                          1'b0;

  ad_3w_spi #(.NUM_OF_SLAVES(1)) i_spi_hmc (
    .spi_csn (spi_2_csn[4]),
    .spi_clk (spi_2_clk),
    .spi_mosi (spi_2_mosi),
    .spi_miso (spi_hmc_miso),
    .spi_sdio (hmc7043_sdata),
    .spi_dir ());

  ad_3w_spi #(.NUM_OF_SLAVES(1)) i_spi_4371 (
    .spi_csn (&spi_2_csn[3:0]),
    .spi_clk (spi_2_clk),
    .spi_mosi (spi_2_mosi),
    .spi_miso (spi_4371_miso),
    .spi_sdio (adf4371_sdio),
    .spi_dir ());
  
  // quad_mxfe_gpio_mux

  quad_mxfe_gpio_mux i_quad_mxfe_gpio_mux (
    .mxfe0_gpio0 (mxfe0_gpio[0]),
    .mxfe0_gpio1 (mxfe0_gpio[1]),
    .mxfe0_gpio2 (mxfe0_gpio[2]),
    .mxfe0_gpio5 (mxfe0_gpio[3]),
    .mxfe0_gpio6 (mxfe0_gpio[4]),
    .mxfe0_gpio7 (mxfe0_gpio[5]),
    .mxfe0_gpio8 (mxfe0_gpio[6]),
    .mxfe0_gpio9 (mxfe0_gpio[7]),
    .mxfe0_gpio10 (mxfe0_gpio[8]),
    .mxfe0_syncin_1_n (mxfe_syncin_0_n),
    .mxfe0_syncin_1_p (mxfe_syncin_1_p),
    .mxfe0_syncout_1_n (mxfe_syncout_0_n),
    .mxfe0_syncout_1_p (mxfe_syncout_1_p),

    .mxfe1_gpio0 (mxfe1_gpio[0]),
    .mxfe1_gpio1 (mxfe1_gpio[1]),
    .mxfe1_gpio2 (mxfe1_gpio[2]),
    .mxfe1_gpio5 (mxfe1_gpio[3]),
    .mxfe1_gpio6 (mxfe1_gpio[4]),
    .mxfe1_gpio7 (mxfe1_gpio[5]),
    .mxfe1_gpio8 (mxfe1_gpio[6]),
    .mxfe1_gpio9 (mxfe1_gpio[7]),
    .mxfe1_gpio10 (mxfe1_gpio[8]),
    .mxfe1_syncin_1_n (mxfe_syncin_1_n),
    .mxfe1_syncin_1_p (mxfe_syncin_3_p),
    .mxfe1_syncout_1_n (mxfe_syncout_1_n),
    .mxfe1_syncout_1_p (mxfe_syncout_3_p),

    .mxfe2_gpio0 (mxfe2_gpio[0]),
    .mxfe2_gpio1 (mxfe2_gpio[1]),
    .mxfe2_gpio2 (mxfe2_gpio[2]),
    .mxfe2_gpio5 (mxfe2_gpio[3]),
    .mxfe2_gpio6 (mxfe2_gpio[4]),
    .mxfe2_gpio7 (mxfe2_gpio[5]),
    .mxfe2_gpio8 (mxfe2_gpio[6]),
    .mxfe2_gpio9 (mxfe2_gpio[7]),
    .mxfe2_gpio10 (mxfe2_gpio[8]),
    .mxfe2_syncin_1_n (mxfe_syncin_2_n),
    .mxfe2_syncin_1_p (mxfe_syncin_5_p),
    .mxfe2_syncout_1_n (mxfe_syncout_2_n),
    .mxfe2_syncout_1_p (mxfe_syncout_5_p),

    .mxfe3_gpio0 (mxfe3_gpio[0]),
    .mxfe3_gpio1 (mxfe3_gpio[1]),
    .mxfe3_gpio2 (mxfe3_gpio[2]),
    .mxfe3_gpio5 (mxfe3_gpio[3]),
    .mxfe3_gpio6 (mxfe3_gpio[4]),
    .mxfe3_gpio7 (mxfe3_gpio[5]),
    .mxfe3_gpio8 (mxfe3_gpio[6]),
    .mxfe3_gpio9 (mxfe3_gpio[7]),
    .mxfe3_gpio10 (mxfe3_gpio[8]),
    .mxfe3_syncin_1_n (mxfe_syncin_3_n),
    .mxfe3_syncin_1_p (mxfe_syncin_7_p),
    .mxfe3_syncout_1_n (mxfe_syncout_3_n),
    .mxfe3_syncout_1_p (mxfe_syncout_7_p),
    
    .gpio_t(gpio2_t),
    .gpio_i(gpio2_i),
    .gpio_o(gpio2_o)
  );

  // system reset is a combination of external reset, HPS reset and S10 init
  // done reset
  assign sys_resetn_s = fpga_resetn & ~h2f_reset_s & ~ninit_done_s;

  system_bd i_system_bd (
    .sys_clk_clk                          ( sys_clk ),
    .sys_rst_reset_n                      ( sys_resetn_s ),
    .h2f_reset_reset                      ( h2f_reset_s ),
    .rst_ninit_done_ninit_done            ( ninit_done_s ),
    .sys_gpio_bd_in_port                  ( gpio_i[31: 0] ),
    .sys_gpio_bd_out_port                 ( gpio_o[31: 0] ),
    .sys_gpio_in_export                   ( gpio_i[63:32] ),
    .sys_gpio_out_export                  ( gpio_o[63:32] ),
    .sys_hps_io_hps_io_phery_emac0_TX_CLK ( hps_emac_tx_clk ),
    .sys_hps_io_hps_io_phery_emac0_TXD0   ( hps_emac_tx[0] ),
    .sys_hps_io_hps_io_phery_emac0_TXD1   ( hps_emac_tx[1] ),
    .sys_hps_io_hps_io_phery_emac0_TXD2   ( hps_emac_tx[2] ),
    .sys_hps_io_hps_io_phery_emac0_TXD3   ( hps_emac_tx[3] ),
    .sys_hps_io_hps_io_phery_emac0_RX_CTL ( hps_emac_rx_ctl ),
    .sys_hps_io_hps_io_phery_emac0_TX_CTL ( hps_emac_tx_ctl ),
    .sys_hps_io_hps_io_phery_emac0_RX_CLK ( hps_emac_rx_clk ),
    .sys_hps_io_hps_io_phery_emac0_RXD0   ( hps_emac_rx[0] ),
    .sys_hps_io_hps_io_phery_emac0_RXD1   ( hps_emac_rx[1] ),
    .sys_hps_io_hps_io_phery_emac0_RXD2   ( hps_emac_rx[2] ),
    .sys_hps_io_hps_io_phery_emac0_RXD3   ( hps_emac_rx[3] ),
    .sys_hps_io_hps_io_phery_emac0_MDIO   ( hps_emac_mdio ),
    .sys_hps_io_hps_io_phery_emac0_MDC    ( hps_emac_mdc ),
    .sys_hps_io_hps_io_phery_sdmmc_CMD    ( hps_sdmmc_cmd ),
    .sys_hps_io_hps_io_phery_sdmmc_D0     ( hps_sdmmc_data[0]),
    .sys_hps_io_hps_io_phery_sdmmc_D1     ( hps_sdmmc_data[1]),
    .sys_hps_io_hps_io_phery_sdmmc_D2     ( hps_sdmmc_data[2]),
    .sys_hps_io_hps_io_phery_sdmmc_D3     ( hps_sdmmc_data[3]),
    .sys_hps_io_hps_io_phery_sdmmc_CCLK   ( hps_sdmmc_clk ),
    .sys_hps_io_hps_io_phery_usb0_DATA0   ( hps_usb_data[0] ),
    .sys_hps_io_hps_io_phery_usb0_DATA1   ( hps_usb_data[1] ),
    .sys_hps_io_hps_io_phery_usb0_DATA2   ( hps_usb_data[2] ),
    .sys_hps_io_hps_io_phery_usb0_DATA3   ( hps_usb_data[3] ),
    .sys_hps_io_hps_io_phery_usb0_DATA4   ( hps_usb_data[4] ),
    .sys_hps_io_hps_io_phery_usb0_DATA5   ( hps_usb_data[5] ),
    .sys_hps_io_hps_io_phery_usb0_DATA6   ( hps_usb_data[6] ),
    .sys_hps_io_hps_io_phery_usb0_DATA7   ( hps_usb_data[7] ),
    .sys_hps_io_hps_io_phery_usb0_CLK     ( hps_usb_clk ),
    .sys_hps_io_hps_io_phery_usb0_STP     ( hps_usb_stp ),
    .sys_hps_io_hps_io_phery_usb0_DIR     ( hps_usb_dir ),
    .sys_hps_io_hps_io_phery_usb0_NXT     ( hps_usb_nxt ),
    .sys_hps_io_hps_io_phery_uart0_RX     ( hps_uart_rx ),
    .sys_hps_io_hps_io_phery_uart0_TX     ( hps_uart_tx ),
    .sys_hps_io_hps_io_phery_i2c1_SDA     ( hps_i2c_sda ),
    .sys_hps_io_hps_io_phery_i2c1_SCL     ( hps_i2c_scl ),
    .sys_hps_io_hps_io_gpio_gpio1_io0     ( hps_gpio_eth_irq ),
    .sys_hps_io_hps_io_gpio_gpio1_io1     ( hps_gpio_usb_oci ),
    .sys_hps_io_hps_io_gpio_gpio1_io4     ( hps_gpio_btn[0] ),
    .sys_hps_io_hps_io_gpio_gpio1_io5     ( hps_gpio_btn[1] ),
    .sys_hps_io_hps_io_jtag_tck           ( hps_jtag_tck ),
    .sys_hps_io_hps_io_jtag_tms           ( hps_jtag_tms ),
    .sys_hps_io_hps_io_jtag_tdo           ( hps_jtag_tdo ),
    .sys_hps_io_hps_io_jtag_tdi           ( hps_jtag_tdi ),
    .sys_hps_io_hps_io_hps_ocs_clk        ( hps_ref_clk ),
    .sys_hps_io_hps_io_gpio_gpio1_io19    ( hps_gpio_led[1] ),
    .sys_hps_io_hps_io_gpio_gpio1_io20    ( hps_gpio_led[0] ),
    .sys_hps_io_hps_io_gpio_gpio1_io21    ( hps_gpio_led[2] ),
    .sys_hps_ddr_ref_clk_clk              ( hps_ddr_ref_clk ),
    .sys_hps_ddr_oct_oct_rzqin            ( hps_ddr_rzq ),
    .sys_hps_ddr_mem_ck                   ( hps_ddr_ck ),
    .sys_hps_ddr_mem_ck_n                 ( hps_ddr_ck_n ),
    .sys_hps_ddr_mem_a                    ( hps_ddr_a ),
    .sys_hps_ddr_mem_act_n                ( hps_ddr_act_n ),
    .sys_hps_ddr_mem_ba                   ( hps_ddr_ba ),
    .sys_hps_ddr_mem_bg                   ( hps_ddr_bg ),
    .sys_hps_ddr_mem_cke                  ( hps_ddr_cke ),
    .sys_hps_ddr_mem_cs_n                 ( hps_ddr_cs_n ),
    .sys_hps_ddr_mem_odt                  ( hps_ddr_odt ),
    .sys_hps_ddr_mem_reset_n              ( hps_ddr_reset_n ),
    .sys_hps_ddr_mem_par                  ( hps_ddr_par ),
    .sys_hps_ddr_mem_alert_n              ( hps_ddr_alert_n ),
    .sys_hps_ddr_mem_dqs                  ( hps_ddr_dqs_p ),
    .sys_hps_ddr_mem_dqs_n                ( hps_ddr_dqs_n ),
    .sys_hps_ddr_mem_dq                   ( hps_ddr_dq ),
    .sys_hps_ddr_mem_dbi_n                ( hps_ddr_dbi_n ),
    // SPI interface for the mxfe
    .sys_spi_MISO                         ( spi_miso ),
    .sys_spi_MOSI                         ( spi_mosi ),
    .sys_spi_SCLK                         ( spi_clk ),
    .sys_spi_SS_n                         ( spi_csn ),
    // SPI interface for the HMC7043 and ADF4371
    .spi_2_MISO                           ( spi_2_miso ),
    .spi_2_MOSI                           ( spi_2_mosi ),
    .spi_2_SCLK                           ( spi_2_clk ),
    .spi_2_SS_n                           ( spi_2_csn ),
    // JESD204B high-speed interface
    .tx_serial_data_tx_serial_data        ( {c2m[15],c2m[13],c2m[2],c2m[1],c2m[3],c2m[8],c2m[9],c2m[11],c2m[5],c2m[7],c2m[0],c2m[6],c2m[4],c2m[10],c2m[14],c2m[12]} ),
    .tx_ref_clk_clk                       ( fpga_clk_m2c[0] ),
    .tx_sync_export                       ( link0_tx_syncin ),
    .tx_sysref_export                     ( fpga_sysref_m2c ),
    .tx_device_clk_clk                    ( fpga_clk_m2c[2] ),
    .rx_serial_data_rx_serial_data        ( {m2c[2],m2c[1],m2c[3],m2c[12],m2c[13],m2c[14],m2c[9],m2c[11],m2c[5],m2c[7],m2c[0],m2c[6],m2c[4],m2c[8],m2c[15],m2c[10]} ),
    .rx_ref_clk_clk                       ( fpga_clk_m2c[0] ),
    .rx_sync_export                       ( link0_rx_syncout ),
    .rx_sysref_export                     ( fpga_sysref_m2c ),
    .rx_device_clk_clk                    ( fpga_clk_m2c[1] ),
    // Quad MxFE gpio
    .mxfe_pio1_in_port                    ( gpio2_i[31: 0] ),
    .mxfe_pio1_out_port                   ( gpio2_o[31: 0] ),
    .mxfe_pio2_in_port                    ( gpio2_i[63: 32] ),
    .mxfe_pio2_out_port                   ( gpio2_o[63: 32] ));

endmodule

// ***************************************************************************
// ***************************************************************************
