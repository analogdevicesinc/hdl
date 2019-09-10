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

module system_top (


  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  input                   rx_ref_clk_p,
  input                   rx_ref_clk_n,
  input                   rx_device_clk_p,
  input                   rx_device_clk_n,
  output                  rx_sync0_p,
  output                  rx_sync0_n,
  output                  rx_sync1_p,
  output                  rx_sync1_n,
  input                   rx_sysref_p,
  input                   rx_sysref_n,
  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,

  inout                   adc_fdb,
  inout                   adc_fda,
  inout                   adc_pdwn,

  // DAQ board's ADC SPI

  output                  spi_adc_csn,
  output                  spi_adc_clk,
  output                  spi_adc_mosi,
  input                   spi_adc_miso,

  // DAQ board's clock chip

  output                  spi_clkgen_csn,
  output                  spi_clkgen_clk,
  output                  spi_clkgen_mosi,
  input                   spi_clkgen_miso,

  // DAQ board's vco chip

  output                  spi_vco_csn,
  output                  spi_vco_clk,
  output                  spi_vco_mosi,

  // AFE board's DAC

  inout                   afe_dac_sda,
  inout                   afe_dac_scl,
  output                  afe_dac_clr_n,
  output                  afe_dac_load,

  // AFE board's ADC

  output                  afe_adc_sclk,
  output                  afe_adc_scn,
  input                   afe_adc_sdi,
  output                  afe_adc_convst,

  // Laser driver differential line

  output                  laser_driver_p,
  output                  laser_driver_n,

  output                  laser_driver_en_n,
  input                   laser_driver_otw_n,

  // GPIO's for the laser board

  inout       [13:0]      laser_gpio,

  // Vref selects for AFE board

  output      [ 7:0]      tia_chsel

);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  wire            rx_ref_clk;
  wire            rx_sync;
  wire            rx_sysref;
  wire            rx_device_clk;
  wire            laser_driver;

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sync0 (
    .I (rx_sync),
    .O (rx_sync0_p),
    .OB (rx_sync0_n));

  OBUFDS i_obufds_rx_sync1 (
    .I (rx_sync),
    .O (rx_sync1_p),
    .OB (rx_sync1_n));

  IBUFGDS i_rx_device_clk (
    .I (rx_device_clk_p),
    .IB (rx_device_clk_n),
    .O (rx_device_clk));

  IBUFDS i_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  // laser driver

  OBUFDS i_obufds_laser_driver (
    .I (laser_driver),
    .O (laser_driver_p),
    .OB (laser_driver_n));

  // GPIO connections to the FMC connector

  ad_iobuf #(.DATA_WIDTH(20)) i_fmc_iobuf (
    .dio_t ({gpio_t[51:38], 3'b0, gpio_t[34:32]}),
    .dio_i ({gpio_o[51:32]}),
    .dio_o ({gpio_i[51:32]}),
    .dio_p ({
              laser_gpio,       // 51:38
              afe_adc_convst,   // 37    - output only
              afe_dac_load,     // 36    - output only
              afe_dac_clr_n,    // 35    - output only
              adc_pdwn,         // 34
              adc_fdb,          // 33
              adc_fda           // 32
            }));

  assign gpio_bd_o     = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[94:52] = gpio_o[94:52];

  // block design instance

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk (rx_ref_clk),
    .rx_device_clk (rx_device_clk),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (rx_sysref),
    .laser_driver (laser_driver),
    .laser_driver_en_n (laser_driver_en_n),
    .laser_driver_otw_n (laser_driver_otw_n),
    .tia_chsel (tia_chsel),
    .iic_dac_scl_io (afe_dac_scl),
    .iic_dac_sda_io (afe_dac_sda),
    .spi0_sclk (spi_adc_clk),
    .spi0_csn (spi_adc_csn),
    .spi0_miso (spi_adc_miso),
    .spi0_mosi (spi_adc_mosi),
    .spi1_sclk (spi_clkgen_clk),
    .spi1_csn (spi_clkgen_csn),
    .spi1_miso (spi_clkgen_miso),
    .spi1_mosi (spi_clkgen_mosi),
    .spi_vco_csn_i (1'b1),
    .spi_vco_csn_o (spi_vco_csn),
    .spi_vco_clk_i (1'b0),
    .spi_vco_clk_o (spi_vco_clk),
    .spi_vco_sdo_i (1'b0),
    .spi_vco_sdo_o (spi_vco_mosi),
    .spi_vco_sdi_i (1'b0),
    .spi_afe_adc_csn_i (1'b1),
    .spi_afe_adc_csn_o (afe_adc_scn),
    .spi_afe_adc_clk_i (1'b0),
    .spi_afe_adc_clk_o (afe_adc_sclk),
    .spi_afe_adc_sdo_i (1'b0),
    .spi_afe_adc_sdo_o (),
    .spi_afe_adc_sdi_i (afe_adc_sdi));

endmodule
