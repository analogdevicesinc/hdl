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

  input                   rx_ref_clk_a_p,
  input                   rx_ref_clk_a_n,
  input                   rx_device_clk_a_p,
  input                   rx_device_clk_a_n,
  output                  rx_sync0_a_p,
  output                  rx_sync0_a_n,
  output                  rx_sync1_a_p,
  output                  rx_sync1_a_n,
  input                   rx_sysref_a_p,
  input                   rx_sysref_a_n,
  input       [ 3:0]      rx_data_a_p,
  input       [ 3:0]      rx_data_a_n,

  inout                   adc_fdb_a,
  inout                   adc_fda_a,
  inout                   adc_pdwn_a,

  // DAQ board's ADC SPI

  output                  spi_adc_csn_a,
  output                  spi_adc_clk_a,
  output                  spi_adc_mosi_a,
  input                   spi_adc_miso_a,

  // DAQ board's clock chip

  output                  spi_clkgen_csn_a,
  output                  spi_clkgen_clk_a,
  output                  spi_clkgen_mosi_a,
  input                   spi_clkgen_miso_a,

  // DAQ board's vco chip

  output                  spi_vco_csn_a,
  output                  spi_vco_clk_a,
  output                  spi_vco_mosi_a,

  // AFE board's DAC

  inout                   afe_dac_sda_a,
  inout                   afe_dac_scl_a,
  output                  afe_dac_clr_n_a,
  output                  afe_dac_load_a,

  // AFE board's ADC

  output                  afe_adc_sclk_a,
  output                  afe_adc_scn_a,
  input                   afe_adc_sdi_a,
  output                  afe_adc_convst_a,

  // Laser driver differential line

  output                  laser_driver_a_p,
  output                  laser_driver_a_n,

  output                  laser_driver_en_a_n,
  input                   laser_driver_otw_a_n,

  // GPIO's for the laser board

  inout       [13:0]      laser_gpio_a,

  // Vref selects for AFE board

  output      [ 7:0]      tia_chsel_a,

  input                   rx_ref_clk_b_p,
  input                   rx_ref_clk_b_n,
  input                   rx_device_clk_b_p,
  input                   rx_device_clk_b_n,
  output                  rx_sync0_b_p,
  output                  rx_sync0_b_n,
  output                  rx_sync1_b_p,
  output                  rx_sync1_b_n,
  input                   rx_sysref_b_p,
  input                   rx_sysref_b_n,
  input       [ 3:0]      rx_data_b_p,
  input       [ 3:0]      rx_data_b_n,

  inout                   adc_fdb_b,
  inout                   adc_fda_b,
  inout                   adc_pdwn_b,

  // DAQ board's ADC SPI

  output                  spi_adc_csn_b,
  output                  spi_adc_clk_b,
  output                  spi_adc_mosi_b,
  input                   spi_adc_miso_b,

  // DAQ board's clock chip

  output                  spi_clkgen_csn_b,
  output                  spi_clkgen_clk_b,
  output                  spi_clkgen_mosi_b,
  input                   spi_clkgen_miso_b,

  // DAQ board's vco chip

  output                  spi_vco_csn_b,
  output                  spi_vco_clk_b,
  output                  spi_vco_mosi_b,

  // AFE board's DAC

  inout                   afe_dac_sda_b,
  inout                   afe_dac_scl_b,
  output                  afe_dac_clr_n_b,
  output                  afe_dac_load_b,

  // AFE board's ADC

  output                  afe_adc_sclk_b,
  output                  afe_adc_scn_b,
  input                   afe_adc_sdi_b,
  output                  afe_adc_convst_b,

  // Laser driver differential line

  output                  laser_driver_b_p,
  output                  laser_driver_b_n,

  output                  laser_driver_en_b_n,
  input                   laser_driver_otw_b_n,

  // GPIO's for the laser board

  // four line is disconnected, to have ports for ADC SPI and there
  // are lines which are not connected to the FPGA
  inout       [ 9:0]      laser_gpio_b,

  // Vref selects for AFE board

  output      [ 7:0]      tia_chsel_b

);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;

  wire            rx_ref_clk_a;
  wire            rx_sync_a;
  wire            rx_sysref_a;
  wire            rx_device_clk_a;

  wire            rx_ref_clk_b;
  wire            rx_sync_b;
  wire            rx_sysref_b;
  wire            rx_device_clk_b;

  wire            laser_driver_s;
  wire            laser_driver_en_n_s;
  wire            laser_driver_otw_n_s;
  wire   [ 7:0]   tia_chsel_s;

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk_a (
    .CEB (1'd0),
    .I (rx_ref_clk_a_p),
    .IB (rx_ref_clk_a_n),
    .O (rx_ref_clk_a),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sync0_a (
    .I (rx_sync_a),
    .O (rx_sync0_a_p),
    .OB (rx_sync0_a_n));

  OBUFDS i_obufds_rx_sync1_a (
    .I (rx_sync_a),
    .O (rx_sync1_a_p),
    .OB (rx_sync1_a_n));

  IBUFGDS i_rx_device_clk_a (
    .I (rx_device_clk_a_p),
    .IB (rx_device_clk_a_n),
    .O (rx_device_clk_a));

  IBUFDS i_rx_sysref_a (
    .I (rx_sysref_a_p),
    .IB (rx_sysref_a_n),
    .O (rx_sysref_a));

  // laser driver

  OBUFDS i_obufds_laser_driver_a (
    .I (laser_driver_s),
    .O (laser_driver_a_p),
    .OB (laser_driver_a_n));

  IBUFDS_GTE4 i_ibufds_rx_ref_clk_b (
    .CEB (1'd0),
    .I (rx_ref_clk_b_p),
    .IB (rx_ref_clk_b_n),
    .O (rx_ref_clk_b),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sync0_b (
    .I (rx_sync_b),
    .O (rx_sync0_b_p),
    .OB (rx_sync0_b_n));

  OBUFDS i_obufds_rx_sync1_b (
    .I (rx_sync_b),
    .O (rx_sync1_b_p),
    .OB (rx_sync1_b_n));

  IBUFGDS i_rx_device_clk_b (
    .I (rx_device_clk_b_p),
    .IB (rx_device_clk_b_n),
    .O (rx_device_clk_b));

  IBUFDS i_rx_sysref_b (
    .I (rx_sysref_b_p),
    .IB (rx_sysref_b_n),
    .O (rx_sysref_b));

  // laser driver

  OBUFDS i_obufds_laser_driver_b (
    .I (laser_driver_s),
    .O (laser_driver_b_p),
    .OB (laser_driver_b_n));

  // GPIO connections to the FMC connector

  ad_iobuf #(.DATA_WIDTH(36)) i_fmc_iobuf (
    .dio_t ({gpio_t[67:58], 3'b0, gpio_t[54:38], 3'b0, gpio_t[34:32]}),
    .dio_i ({gpio_o[67:32]}),
    .dio_o ({gpio_i[67:32]}),
    .dio_p ({
              laser_gpio_b,       // 67:58
              afe_adc_convst_b,   // 57    - output only
              afe_dac_load_b,     // 56    - output only
              afe_dac_clr_n_b,    // 55    - output only
              adc_pdwn_b,         // 54
              adc_fdb_b,          // 53
              adc_fda_b,          // 52
              laser_gpio_a,       // 51:38
              afe_adc_convst_a,   // 37    - output only
              afe_dac_load_a,     // 36    - output only
              afe_dac_clr_n_a,    // 35    - output only
              adc_pdwn_a,         // 34
              adc_fdb_a,          // 33
              adc_fda_a           // 32
            }));

  assign gpio_bd_o = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;

  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[94:72] = gpio_o[94:72];

  assign laser_driver_en_a_n = laser_driver_en_n_s;
  assign laser_driver_en_b_n = laser_driver_en_n_s;
  assign laser_driver_otw_n_s = laser_driver_otw_a_n | laser_driver_otw_b_n;
  assign tia_chsel_a = tia_chsel_s;
  assign tia_chsel_b = tia_chsel_s;

  // block design instance

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    // LIDAR_A
    .rx_data_0_n (rx_data_a_n[0]),
    .rx_data_0_p (rx_data_a_p[0]),
    .rx_data_1_n (rx_data_a_n[1]),
    .rx_data_1_p (rx_data_a_p[1]),
    .rx_data_2_n (rx_data_a_n[2]),
    .rx_data_2_p (rx_data_a_p[2]),
    .rx_data_3_n (rx_data_a_n[3]),
    .rx_data_3_p (rx_data_a_p[3]),
    .rx_ref_clk_a (rx_ref_clk_a),
    .rx_device_clk_a (rx_device_clk_a),
    .rx_sync_0 (rx_sync_a),
    .rx_sysref_0 (rx_sysref_a),
    .laser_driver_a (laser_driver_s),
    .laser_driver_en_a_n (laser_driver_en_n_s),
    .laser_driver_otw_a_n (laser_driver_otw_n_s),
    .tia_chsel_a (tia_chsel_s),
    .iic_dac_a_scl_io (afe_dac_scl_a),
    .iic_dac_a_sda_io (afe_dac_sda_a),
    .spi0_sclk (spi_adc_clk_a),
    .spi0_csn (spi_adc_csn_a),
    .spi0_miso (spi_adc_miso_a),
    .spi0_mosi (spi_adc_mosi_a),
    .spi1_sclk (spi_clkgen_clk_a),
    .spi1_csn (spi_clkgen_csn_a),
    .spi1_miso (spi_clkgen_miso_a),
    .spi1_mosi (spi_clkgen_mosi_a),
    .spi_vco_csn_a_i (1'b1),
    .spi_vco_csn_a_o (spi_vco_csn_a),
    .spi_vco_clk_a_i (1'b0),
    .spi_vco_clk_a_o (spi_vco_clk_a),
    .spi_vco_sdo_a_i (1'b0),
    .spi_vco_sdo_a_o (spi_vco_mosi_a),
    .spi_vco_sdi_a_i (1'b0),
    .spi_afe_adc_csn_a_i (1'b1),
    .spi_afe_adc_csn_a_o (afe_adc_scn_a),
    .spi_afe_adc_clk_a_i (1'b0),
    .spi_afe_adc_clk_a_o (afe_adc_sclk_a),
    .spi_afe_adc_sdo_a_i (1'b0),
    .spi_afe_adc_sdo_a_o (),
    .spi_afe_adc_sdi_a_i (afe_adc_sdi_a),
    // LIDAR_B
    .rx_data_1_0_n (rx_data_b_n[0]),
    .rx_data_1_0_p (rx_data_b_p[0]),
    .rx_data_1_1_n (rx_data_b_n[1]),
    .rx_data_1_1_p (rx_data_b_p[1]),
    .rx_data_1_2_n (rx_data_b_n[2]),
    .rx_data_1_2_p (rx_data_b_p[2]),
    .rx_data_1_3_n (rx_data_b_n[3]),
    .rx_data_1_3_p (rx_data_b_p[3]),
    .rx_ref_clk_b (rx_ref_clk_b),
    .rx_device_clk_b (rx_device_clk_b),
    .rx_sync_1_0 (rx_sync_b),
    .rx_sysref_1_0 (rx_sysref_b),
    .iic_dac_b_scl_io (afe_dac_scl_b),
    .iic_dac_b_sda_io (afe_dac_sda_b),
    .spi_adc_csn_b_i (1'b1),
    .spi_adc_csn_b_o (spi_adc_csn_b),
    .spi_adc_clk_b_i (1'b0),
    .spi_adc_clk_b_o (spi_adc_clk_b),
    .spi_adc_sdo_b_i (1'b0),
    .spi_adc_sdo_b_o (spi_adc_mosi_b),
    .spi_adc_sdi_b_i (spi_adc_miso_b),
    .spi_clkgen_csn_b_i (1'b1),
    .spi_clkgen_csn_b_o (spi_clkgen_csn_b),
    .spi_clkgen_clk_b_i (1'b0),
    .spi_clkgen_clk_b_o (spi_clkgen_clk_b),
    .spi_clkgen_sdo_b_i (1'b0),
    .spi_clkgen_sdo_b_o (spi_clkgen_mosi_b),
    .spi_clkgen_sdi_b_i (spi_clkgen_miso_b),
    .spi_vco_csn_b_i (1'b1),
    .spi_vco_csn_b_o (spi_vco_csn_b),
    .spi_vco_clk_b_i (1'b0),
    .spi_vco_clk_b_o (spi_vco_clk_b),
    .spi_vco_sdo_b_i (1'b0),
    .spi_vco_sdo_b_o (spi_vco_mosi_b),
    .spi_vco_sdi_b_i (1'b0),
    .spi_afe_adc_csn_b_i (1'b1),
    .spi_afe_adc_csn_b_o (afe_adc_scn_b),
    .spi_afe_adc_clk_b_i (1'b0),
    .spi_afe_adc_clk_b_o (afe_adc_sclk_b),
    .spi_afe_adc_sdo_b_i (1'b0),
    .spi_afe_adc_sdo_b_o (),
    .spi_afe_adc_sdi_b_i (afe_adc_sdi_b)
  );

endmodule
