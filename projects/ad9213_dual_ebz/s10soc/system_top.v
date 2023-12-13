// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

  // ad9213_a JESD204B high-speed interface

  input             rx_ref_a_clk0,
  input             rx_ref_a_clk1,
  input             rx_device_clk_0,
  input   [ 15:0]   rx_serial_data_a,
  output            rx_sync_a,
  input             rx_sysref_a,

  // ad9213_b JESD204B high-speed interface

  input             rx_ref_b_clk0,
  input             rx_ref_b_clk1,
  input   [ 15:0]   rx_serial_data_b,
  output            rx_sync_b,

  // configuration interfaces

  inout            ad9213_dual_sdio,
  output           ad9213_dual_sclk,
  output  [  1:0]  ad9213_dual_csn,

  inout   [  4:0]  ad9213_a_gpio,
  inout   [  4:0]  ad9213_b_gpio,

  output           ad9213_a_rst,
  output           ad9213_b_rst,

  output           ltc6952_csn,
  output           ltc6946_csn,
  output           ltc_sclk,
  output           ltc_sdi,
  input            ltc6952_sdo,
  input            ltc6946_sdo,

  output           adf4377_sclk,
  inout            adf4377_sdio,
  output  [  1:0]  adf4377_csn
);

  // internal signals

  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire              spi_mosi_s;
  wire              spi_miso_s;
  wire              ninit_done_s;
  wire              h2f_reset_s;
  wire              sys_resetn_s;
  wire              ltc_sdo_s;
  wire              adf4377_sdi_s;
  wire              adf4377_sdo_s;
  wire    [511:0]   adc_data_0;
  wire    [511:0]   adc_data_1;
  wire    [511:0]   link_data_0;
  wire    [511:0]   link_data_1;
  wire    [1023:0]  adc_data;
  wire              adc_enable_0;
  wire              adc_enable_1;
  wire              adc_valid;
  wire    [  1:0]   ltc_csn;
  wire              adc_swap;

  reg               adc_valid_d1;
  reg     [1023:0]  adc_data_d1;
  reg     [511:0]   adc_data_0_d1;
  reg     [511:0]   adc_data_1_d1;
  reg     [511:0]   adc_data_0_swap;
  reg     [511:0]   adc_data_1_swap;
  reg               adc_swap_d1;
  reg               adc_swap_d2;

  // motherboard-gpio

  assign gpio_i[3:0]   = fpga_gpio_dpsw;
  assign gpio_i[7:4]   = fpga_gpio_btn;
  assign gpio_i[31:8]  = gpio_o[31:8];
  assign fpga_gpio_led = gpio_o[11:8];

  // assignments

  assign adc_swap      = gpio_o[34];
  assign ad9213_a_rst  = gpio_o[32];
  assign ad9213_b_rst  = gpio_o[33];
  assign gpio_i[63:32] = gpio_o[63:32];
  assign ltc6952_csn   = ltc_csn[0];
  assign ltc6946_csn   = ltc_csn[1];

  // instantiations

  ad_3w_spi #(
    .NUM_OF_SLAVES(2)
  ) i_ad_3w_spi_ad9213_dual (
    .spi_csn (ad9213_dual_csn),
    .spi_clk (ad9213_dual_sclk),
    .spi_mosi (spi_mosi_s),
    .spi_miso (spi_miso_s),
    .spi_sdio (ad9213_dual_sdio),
    .spi_dir ());

  ad_3w_spi #(
    .NUM_OF_SLAVES(2)
  ) i_ad_3w_spi_adf4377 (
    .spi_csn (adf4377_csn),
    .spi_clk (adf4377_sclk),
    .spi_mosi (adf4377_sdi_s),
    .spi_miso (adf4377_sdo_s),
    .spi_sdio (adf4377_sdio),
    .spi_dir ());

  // SDO line (MISO) switching for the two ltc
  assign ltc_sdo_s = (ltc_csn == 2'b10) ? ltc6952_sdo :
                     (ltc_csn == 2'b01) ? ltc6946_sdo : 1'b0;

  // system reset is a combination of external reset, HPS reset and S10 init
  // done reset
  assign sys_resetn_s = fpga_resetn & ~h2f_reset_s & ~ninit_done_s;

  genvar i;
  for (i = 0; i < 512; i = i + 16) begin
    assign adc_data[(2*i)+31:(2*i)] ={adc_data_1_swap[i+15:i],adc_data_0_swap[i+15:i]};
  end

  always @(posedge rx_device_clk_0) begin
    adc_swap_d1 <= adc_swap;
    adc_swap_d2 <= adc_swap_d1;

    if (adc_swap_d2 == 1'b0) begin
      adc_data_0_swap <= adc_data_0;
      adc_data_1_swap <= adc_data_1;
    end else begin
      adc_data_0_swap <= adc_data_1;
      adc_data_1_swap <= adc_data_0;
    end

    adc_data_0_d1 <= adc_data_0;
    adc_data_1_d1 <= adc_data_1;

    case ({adc_enable_1,adc_enable_0})
      2'b01: adc_data_d1 <= {adc_data_0,adc_data_0_d1};
      2'b10: adc_data_d1 <= {adc_data_1,adc_data_1_d1};
      2'b11: adc_data_d1 <= adc_data;
      default: adc_data_d1 <= adc_data_d1;
    endcase
    case ({adc_enable_1,adc_enable_0})
      2'b01: adc_valid_d1 <= ~adc_valid_d1;
      2'b10: adc_valid_d1 <= ~adc_valid_d1;
      2'b11: adc_valid_d1<= adc_valid;
      default: adc_valid_d1 <= adc_valid;
    endcase
  end

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
    // Link to TPL connections
    .ad9213_rx_0_link_data_data           ( link_data_0 ),
    .ad9213_rx_0_link_data_valid          ( link_valid_0 ),
    .ad9213_rx_1_link_data_data           ( link_data_1 ),
    .ad9213_rx_1_link_data_valid          ( link_valid_1 ),
    .axi_ad9213_dual_tpl_link_data_data   ( {link_data_1,link_data_0} ),
    .axi_ad9213_dual_tpl_link_data_valid  ( link_valid_1&link_valid_0 ),
    .axi_ad9213_dual_tpl_link_data_ready  (),
    // TPL connections to PACK
    .axi_ad9213_dual_tpl_adc_ch_0_enable  ( adc_enable_0 ),
    .axi_ad9213_dual_tpl_adc_ch_0_valid   ( adc_valid ),
    .axi_ad9213_dual_tpl_adc_ch_0_data    ( adc_data_0 ),
    .axi_ad9213_dual_tpl_adc_ch_1_enable  ( adc_enable_1 ),
    .axi_ad9213_dual_tpl_adc_ch_1_valid   (),
    .axi_ad9213_dual_tpl_adc_ch_1_data    ( adc_data_1 ),
    // PACK to ADC FIFO
    .ad9213_adcfifo_if_adc_wr_valid       ( adc_valid_d1 ),
    .ad9213_adcfifo_if_adc_wdata_data     ( adc_data_d1 ),
    // SPI interface for the two ad9213
    .sys_spi_MISO                         ( spi_miso_s ),
    .sys_spi_MOSI                         ( spi_mosi_s ),
    .sys_spi_SCLK                         ( ad9213_dual_sclk ),
    .sys_spi_SS_n                         ( ad9213_dual_csn ),
    // SPI interface for the ltc
    .ltc_spi_MISO                         ( ltc_sdo_s ),
    .ltc_spi_MOSI                         ( ltc_sdi ),
    .ltc_spi_SCLK                         ( ltc_sclk ),
    .ltc_spi_SS_n                         ( ltc_csn ),
    // SPI interface for the ADF4377
    .adf4377_spi_MISO                     ( adf4377_sdo_s ),
    .adf4377_spi_MOSI                     ( adf4377_sdi_s ),
    .adf4377_spi_SCLK                     ( adf4377_sclk ),
    .adf4377_spi_SS_n                     ( adf4377_csn ),
    // JESD204B high-speed interface
    .rx_ref_clk_0_clk                       ( rx_ref_a_clk0 ),
    .ad9213_rx_0_serial_data_rx_serial_data ( rx_serial_data_a ),
    .rx_sysref_0_export                     ( rx_sysref_a ),
    .rx_sync_0_export                       ( rx_sync_a ),
    .rx_ref_clk_1_clk                       ( rx_ref_b_clk0 ),
    .ad9213_rx_1_serial_data_rx_serial_data ( rx_serial_data_b ),
    .rx_sysref_1_export                     ( rx_sysref_a ),
    .rx_sync_1_export                       ( rx_sync_b ),
    .rx_device_clk_clk                      ( rx_device_clk_0 ),
    // ad9213_a|b gpio
    .ad9213_dual_pio_export                 ( {ad9213_b_gpio, ad9213_a_gpio} ));

endmodule
