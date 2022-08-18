// ***************************************************************************
// ***************************************************************************
// Copyright 2022 (c) Analog Devices, Inc. All rights reserved.
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

  output                  pwdn,
  output                  rstb,

  output                  fpga_csb,
  output                  fpga_clk,
  output                  fpga_sdio,
  input                   fpga_sdo,

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

  // AD9528

  output                  fpga_adclk_refsel,

  // SPIs

  output                  spi_bus0_sck,
  output                  spi_bus0_sdi,
  input                   spi_bus0_sdo,
  output                  spi_bus0_cs_4372,
  output                  fpga_bus0_csb_9528,
  output                  fpga_bus0_csb_5752,
  output                  fpga_bus0_rstn,

  output                  spi_bus1_sck,
  output                  spi_bus1_sdi,
  input                   spi_bus1_sdo,
  output                  spi_bus1_csn_dat1,
  output                  spi_bus1_csn_dat2,

  output                  spi_adl5960_1_sck,
  inout                   spi_adl5960_1_sdio,
  output                  spi_adl5960_1_csn1,
  output                  spi_adl5960_1_csn2,
  output                  spi_adl5960_1_csn3,
  output                  spi_adl5960_1_csn4,

  input                   spiad_sdo,
  output                  spiad_sck,
  output                  spiad_sdi,
  output                  spiad_csn,

  output                  fpga_busf_sck,
  output                  fpga_busf_sdi,
  input                   fpga_busf_sdo,
  output                  fpga_busf_csb,
  output                  fpga_busf_sfl,

  output                  gpio_sw_pg,
  output                  gpio_sw1_v1,
  output                  gpio_sw1_v2,
  output                  gpio_sw2,
  output                  gpio_sw3_v1,
  output                  gpio_sw3_v2,
  output                  gpio_sw4_v1,
  output                  gpio_sw4_v2,


  output                  adcscko,
  input                   adcscki,

  output                  adccnv,
  input                   adcbusy,
  input                   adcsdo0,
  input                   adcsdo2,
  input                   adcsdo4,
  input                   adcsdo6,
  output                  adcpd,

  output                  gpio_mix2en,

  output                  adl5960x_sync1);

  // internal signals

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

  wire         [ 3:0]     adcsdo_in;

  wire         [ 2:0]     adc_spi_csn;

  wire         [ 3:0]     spi_bus0_csn;
  wire         [ 1:0]     spi_bus1_csn;

  wire         [ 3:0]     spi_adl5960_1_csn_s;
  wire                    spi_adl5960_1_clk_s;
  wire                    spi_adl5960_1_mosi_s;
  wire                    spi_adl5960_1_miso_s;

  wire         [ 2:0]     spiad_csn_s;

  // assignments

  assign adcsdo_in = {adcsdo6, adcsdo4, adcsdo2, adcsdo0};

  assign spiad_csn = spiad_csn_s[0];

  assign fpga_csb = adc_spi_csn[0];

  assign fpga_bus0_csb_9528 = spi_bus0_csn[2];
  assign fpga_bus0_csb_5752 = spi_bus0_csn[1];
  assign spi_bus0_cs_4372 = spi_bus0_csn[0];

  assign spi_bus1_csn_dat1 = spi_bus1_csn[0];
  assign spi_bus1_csn_dat2 = spi_bus1_csn[1];

  assign spi_adl5960_1_sck = spi_adl5960_1_clk_s;
  assign spi_adl5960_1_csn1 = spi_adl5960_1_csn_s[0];
  assign spi_adl5960_1_csn2 = spi_adl5960_1_csn_s[1];
  assign spi_adl5960_1_csn3 = spi_adl5960_1_csn_s[2];
  assign spi_adl5960_1_csn4 = spi_adl5960_1_csn_s[3];

  // gpios

  assign adcpd = gpio_o[52];

  assign fpga_bus0_rstn = gpio_o[51];
  assign fpga_busf_sfl = gpio_o[50];
  //assign clkd_lvsft_en = gpio_o[49];
  assign gpio_sw_pg = gpio_o[48];

  assign gpio_mix2en = gpio_o[43];
  assign gpio_sw3_v2 = gpio_o[42];
  assign gpio_sw3_v2 = gpio_o[42];
  assign gpio_sw4_v2 = gpio_o[41];
  assign gpio_sw4_v1 = gpio_o[40];
  assign gpio_sw3_v1 = gpio_o[39];
  assign gpio_sw2 = gpio_o[38];
  assign gpio_sw1_v2 = gpio_o[37];
  assign gpio_sw1_v1 = gpio_o[36];
  assign adl5960x_sync1 = gpio_o[35];
  assign fpga_adclk_refsel = gpio_o[34];
  assign rstb = gpio_o[33];
  assign pwdn = gpio_o[32];

  assign gpio_i[94:32] = gpio_o[94:32];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  // instantiations

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
    .NUM_OF_SLAVES(4))
    i_spi_adl5960_1 (
    .spi_csn(spi_adl5960_1_csn_s),
    .spi_clk(spi_adl5960_1_clk_s),
    .spi_mosi(spi_adl5960_1_mosi_s),
    .spi_miso(spi_adl5960_1_miso_s),
    .spi_sdio(spi_adl5960_1_sdio),
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

  // reversed polarity on preliminary schematic
  IBUFDS i_obufds_tx_sync0 (
    .I (sync0_n),
    .IB (sync0_p),
    .O (tx_sync0));

  // reversed polarity on preliminary schematic
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
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk_0 (rx_ref_clk0),
    .rx_core_clk_0 (rx_ref_core_clk0),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (sysref),

    .adcbusy (adcbusy),

    .ad4858_sdpclk (),
    .ad4858_di_sclk (adcscko),
    .ad4858_di_cs (),
    .ad4858_di_sdo (),
    .ad4858_di_sdo_t (),
    .ad4858_di_sdi (adcsdo_in),
    .ad4858_odr (adccnv),

    .tx_data_1_0_n (dac_data_n[0]),
    .tx_data_1_0_p (dac_data_p[0]),
    .tx_data_1_1_n (dac_data_n[1]),
    .tx_data_1_1_p (dac_data_p[1]),
    .tx_data_1_2_n (dac_data_n[2]),
    .tx_data_1_2_p (dac_data_p[2]),
    .tx_data_1_3_n (dac_data_n[3]),
    .tx_data_1_3_p (dac_data_p[3]),
    //.tx_data_1_4_n (dac_data_n[4]),
    //.tx_data_1_4_p (dac_data_p[4]),
    //.tx_data_1_5_n (dac_data_n[5]),
    //.tx_data_1_5_p (dac_data_p[5]),
    //.tx_data_1_6_n (dac_data_n[6]),
    //.tx_data_1_6_p (dac_data_p[6]),
    //.tx_data_1_7_n (dac_data_n[7]),
    //.tx_data_1_7_p (dac_data_p[7]),

    .tx_sysref_1_0 (dac_sysref),
    .tx_sync_1_0 (tx_sync0),
    .tx_ref_clk_0 (tx_ref_clk0),
    ////.tx_sync1 (tx_sync1),

    .spi0_sclk (fpga_clk),
    .spi0_csn (adc_spi_csn),
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

    .spi_bus0_csn_i (spi_bus0_csn),
    .spi_bus0_csn_o (spi_bus0_csn),
    .spi_bus0_clk_i (spi_bus0_sck),
    .spi_bus0_clk_o (spi_bus0_sck),
    .spi_bus0_sdo_i (spi_bus0_sdi),
    .spi_bus0_sdo_o (spi_bus0_sdi),
    .spi_bus0_sdi_i (spi_bus0_sdo),

    .spi_bus1_csn_i (spi_bus1_csn),
    .spi_bus1_csn_o (spi_bus1_csn),
    .spi_bus1_clk_i (spi_bus1_sck),
    .spi_bus1_clk_o (spi_bus1_sck),
    .spi_bus1_sdo_i (spi_bus1_sdi),
    .spi_bus1_sdo_o (spi_bus1_sdi),
    .spi_bus1_sdi_i (spi_bus1_sdo),

    .spi_fmcdac_csn_i (fmcdac_cs1),
    .spi_fmcdac_csn_o (fmcdac_cs1),
    .spi_fmcdac_clk_i (fmcdac_sck),
    .spi_fmcdac_clk_o (fmcdac_sck),
    .spi_fmcdac_sdo_i (fmcdac_mosi),
    .spi_fmcdac_sdo_o (fmcdac_mosi),
    .spi_fmcdac_sdi_i (fmcdac_miso),

    .spi_adl5960_1_csn_i (spi_adl5960_1_csn_s),
    .spi_adl5960_1_csn_o (spi_adl5960_1_csn_s),
    .spi_adl5960_1_clk_i (spi_adl5960_1_clk_s),
    .spi_adl5960_1_clk_o (spi_adl5960_1_clk_s),
    .spi_adl5960_1_sdo_i (spi_adl5960_1_mosi_s),
    .spi_adl5960_1_sdo_o (spi_adl5960_1_mosi_s),
    .spi_adl5960_1_sdi_i (spi_adl5960_1_miso_s)
  );

endmodule

// ***************************************************************************
