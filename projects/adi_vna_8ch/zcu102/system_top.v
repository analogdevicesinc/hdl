// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
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
  output                  spare_gpiox,

  // AD9083
  input                   ref_clk0_p,
  input                   ref_clk0_n,

  input                   glblclk_p,
  input                   glblclk_n,

  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,

  output                  rx_sync_p,
  output                  rx_sync_n,

  input                   sysrefadc_p,
  input                   sysrefadc_n,

  output                  pd,
  output                  rstb,

  // AD9173
  output                  fmcdac_sck,
  output                  fmcdac_mosi,
  input                   fmcdac_miso,
  output                  fmcdac_cs1,

  input                   br40_ext_p,
  input                   br40_ext_n,

  input                   sysrefdac_p,
  input                   sysrefdac_n,

  output      [ 3:0]      dac_data_p,
  output      [ 3:0]      dac_data_n,

  input                   sync0_n,
  input                   sync0_p,

  input                   sync1_n,
  input                   sync1_p,

  // SPIs
  // SPI for AD9083
  output                  fpga_csb,
  output                  fpga_sck,
  output                  fpga_sdio,
  input                   fpga_sdo,

  // SPI for AD4696
  output                  spiad_sck,
  input                   spiad_sdo,
  output                  spiad_sdi,
  output                  adcmon_csb,
  output                  adccnv,

  // SPI for ADF4372 and AD9528
  output                  fpga_bus0_sck,
  output                  fpga_bus0_sdi,
  input                   fpga_bus0_sdo,
  output                  fpga_bus0_cs_4372,
  output                  fpga_bus0_cs_9528,

  // SPI for 2 x AD5720 and MAX7301
  output                  fpga_bus1_sck,
  output                  fpga_bus1_sdi,
  input                   fpga_bus1_sdo,
  output                  fpga_bus1_cs1,
  output                  fpga_bus1_cs2,
  output                  fpga_gpio_csb,

  // SPI for ADRF6780SC
  output                  spim_sck,
  output                  spim_mosi,
  input                   spim_miso,
  output                  spim_csb_sig,
  output                  spim_csb_lo,

  // SPI for 8 x ADL5960
  output                  spi_adl5960_sck,
  inout                   spi_adl5960_sdio,
  output                  spi_adl5960_csn1,
  output                  spi_adl5960_csn2,
  output                  spi_adl5960_csn3,
  output                  spi_adl5960_csn4,
  output                  spi_adl5960_csn5,
  output                  spi_adl5960_csn6,
  output                  spi_adl5960_csn7,
  output                  spi_adl5960_csn8,

  // SPI for ADMV8818
  output                  fpga_busf_sck,
  output                  fpga_busf_sdi,
  input                   fpga_busf_sdo,
  output                  fpga_busf_csb,
  output                  fpga_busf_sfl,

  // SPI for AD5664
  output                  ndac_sdi,
  output                  ndac_sck,
  output                  ndac_csb,

  output                  seq_shdnn,
  output                  lmix_rstn,
  output                  smix_rstn,
  output                  adcmon_rstn,
  output                  adl5960x_sync1
);

  // Internal signals
  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;

  wire                    rx_ref_clk0;
  wire                    tx_ref_clk0;
  wire                    rx_sync;
  wire                    sysref;
  wire                    dac_sysref;
  wire                    rx_ref_core_clk0_s;
  wire                    rx_ref_core_clk0;
  wire                    tx_sync0;
  wire                    tx_sync1;

  wire         [ 2:0]     fpga_csn;

  wire         [ 1:0]     fpga_bus0_csn;
  wire         [ 3:0]     fpga_bus1_csn;
  wire         [ 1:0]     spim_csn;

  wire         [ 2:0]     spiad_csn_s;

  wire         [ 7:0]     spi_adl5960_csn_s;
  wire                    spi_adl5960_clk_s;
  wire                    spi_adl5960_mosi_s;
  wire                    spi_adl5960_miso_s;

  // Assignments
  assign fpga_csb = fpga_csn[0];

  assign fpga_bus0_cs_9528 = fpga_bus0_csn[1];
  assign fpga_bus0_cs_4372 = fpga_bus0_csn[0];

  assign fpga_bus1_cs1 = fpga_bus1_csn[0];
  assign fpga_bus1_cs2 = fpga_bus1_csn[1];
  assign fpga_gpio_csb = fpga_bus1_csn[2];

  assign spim_csb_sig = spim_csn[0];
  assign spim_csb_lo = spim_csn[1];

  assign adcmon_csb = spiad_csn_s[0];

  assign spi_adl5960_sck = spi_adl5960_clk_s;
  assign spi_adl5960_csn1 = spi_adl5960_csn_s[0];
  assign spi_adl5960_csn2 = spi_adl5960_csn_s[1];
  assign spi_adl5960_csn3 = spi_adl5960_csn_s[2];
  assign spi_adl5960_csn4 = spi_adl5960_csn_s[3];
  assign spi_adl5960_csn5 = spi_adl5960_csn_s[4];
  assign spi_adl5960_csn6 = spi_adl5960_csn_s[5];
  assign spi_adl5960_csn7 = spi_adl5960_csn_s[6];
  assign spi_adl5960_csn8 = spi_adl5960_csn_s[7];

  // GPIOs
  assign fpga_busf_sfl = gpio_o[50];
  assign spare_gpiox = gpio_o[49];
  assign seq_shdnn = 1'b1;

  assign adccnv = spiad_csn_s[0];
  assign adcmon_rstn = gpio_o[41];
  assign smix_rstn = gpio_o[40];
  assign lmix_rstn = gpio_o[36];
  assign adl5960x_sync1 = gpio_o[35];
  assign rstb = gpio_o[33];
  assign pd = gpio_o[32];

  assign gpio_i[94:32] = gpio_o[94:32];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  // Instantiations
  IBUFDS IBUFDS_inst (
    .O(rx_ref_core_clk0_s),
    .I(glblclk_p),
    .IB(glblclk_n));

  BUFG BUFG_inst (
    .O(rx_ref_core_clk0),
    .I(rx_ref_core_clk0_s));

  IBUFDS_GTE4 i_ibufds_rx_ref_clk0 (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (rx_ref_clk0),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_tx_ref_clk0 (
    .CEB (1'd0),
    .I (br40_ext_p),
    .IB (br40_ext_n),
    .O (tx_ref_clk0),
    .ODIV2 ());

  ad_3w_spi #(
    .NUM_OF_SLAVES(8)
  ) i_spi_adl5960 (
    .spi_csn(spi_adl5960_csn_s),
    .spi_clk(spi_adl5960_clk_s),
    .spi_mosi(spi_adl5960_mosi_s),
    .spi_miso(spi_adl5960_miso_s),
    .spi_sdio(spi_adl5960_sdio),
    .spi_dir());

  IBUFDS i_ibufds_sysref (
    .I (sysrefadc_p),
    .IB (sysrefadc_n),
    .O (sysref));

  IBUFDS i_ibufds_tx_sysref (
    .I (sysrefdac_p),
    .IB (sysrefdac_n),
    .O (dac_sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  // Reversed polarity on preliminary schematic
  IBUFDS i_obufds_tx_sync0 (
    .I (sync0_n),
    .IB (sync0_p),
    .O (tx_sync0));

  // Reversed polarity on preliminary schematic
  IBUFDS i_obufds_tx_sync1 (
    .I (sync1_n),
    .IB (sync1_p),
    .O (tx_sync1));

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_ref_clk_0 (rx_ref_clk0),
    .rx_core_clk_0 (rx_ref_core_clk0),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (sysref),

    .tx_data_1_0_n (dac_data_n[0]),
    .tx_data_1_0_p (dac_data_p[0]),
    .tx_data_1_1_n (dac_data_n[1]),
    .tx_data_1_1_p (dac_data_p[1]),
    .tx_data_1_2_n (dac_data_n[2]),
    .tx_data_1_2_p (dac_data_p[2]),
    .tx_data_1_3_n (dac_data_n[3]),
    .tx_data_1_3_p (dac_data_p[3]),

    .tx_sysref_1_0 (dac_sysref),
    .tx_sync_1_0 (tx_sync0),
    .tx_ref_clk_0 (tx_ref_clk0),

    .spi0_sclk (fpga_sck),
    .spi0_csn (fpga_csn),
    .spi0_miso (fpga_sdo),
    .spi0_mosi (fpga_sdio),

    .spi1_sclk (spiad_sck),
    .spi1_csn (spiad_csn_s),
    .spi1_miso (spiad_sdo),
    .spi1_mosi (spiad_sdi),

    .spi_fpga_busf_csn_i (fpga_busf_csb),
    .spi_fpga_busf_csn_o (fpga_busf_csb),
    .spi_fpga_busf_clk_i (fpga_busf_sck),
    .spi_fpga_busf_clk_o (fpga_busf_sck),
    .spi_fpga_busf_sdo_i (fpga_busf_sdi),
    .spi_fpga_busf_sdo_o (fpga_busf_sdi),
    .spi_fpga_busf_sdi_i (fpga_busf_sdo),

    .fpga_bus0_csn_i (fpga_bus0_csn),
    .fpga_bus0_csn_o (fpga_bus0_csn),
    .fpga_bus0_clk_i (fpga_bus0_sck),
    .fpga_bus0_clk_o (fpga_bus0_sck),
    .fpga_bus0_sdo_i (fpga_bus0_sdi),
    .fpga_bus0_sdo_o (fpga_bus0_sdi),
    .fpga_bus0_sdi_i (fpga_bus0_sdo),

    .fpga_bus1_csn_i (fpga_bus1_csn),
    .fpga_bus1_csn_o (fpga_bus1_csn),
    .fpga_bus1_clk_i (fpga_bus1_sck),
    .fpga_bus1_clk_o (fpga_bus1_sck),
    .fpga_bus1_sdo_i (fpga_bus1_sdi),
    .fpga_bus1_sdo_o (fpga_bus1_sdi),
    .fpga_bus1_sdi_i (fpga_bus1_sdo),

    .spim_csn_i (spim_csn),
    .spim_csn_o (spim_csn),
    .spim_clk_i (spim_sck),
    .spim_clk_o (spim_sck),
    .spim_miso_i (spim_mosi),
    .spim_miso_o (spim_mosi),
    .spim_sdi_i (spim_miso),

    .spi_fmcdac_csn_i (fmcdac_cs1),
    .spi_fmcdac_csn_o (fmcdac_cs1),
    .spi_fmcdac_clk_i (fmcdac_sck),
    .spi_fmcdac_clk_o (fmcdac_sck),
    .spi_fmcdac_sdo_i (fmcdac_mosi),
    .spi_fmcdac_sdo_o (fmcdac_mosi),
    .spi_fmcdac_sdi_i (fmcdac_miso),

    .ndac_spi_csn_i (ndac_csb),
    .ndac_spi_csn_o (ndac_csb),
    .ndac_spi_clk_i (ndac_sck),
    .ndac_spi_clk_o (ndac_sck),
    .ndac_spi_sdo_i (ndac_sdi),
    .ndac_spi_sdo_o (ndac_sdi),
    .ndac_spi_sdi_i (),

    .spi_adl5960_csn_i (spi_adl5960_csn_s),
    .spi_adl5960_csn_o (spi_adl5960_csn_s),
    .spi_adl5960_clk_i (spi_adl5960_clk_s),
    .spi_adl5960_clk_o (spi_adl5960_clk_s),
    .spi_adl5960_sdo_i (spi_adl5960_mosi_s),
    .spi_adl5960_sdo_o (spi_adl5960_mosi_s),
    .spi_adl5960_sdi_i (spi_adl5960_miso_s));

endmodule
