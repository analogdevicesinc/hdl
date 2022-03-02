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

  inout       [14:0]      gpio_bd,

  output                  hdmi_out_clk,
  output                  hdmi_vsync,
  output                  hdmi_hsync,
  output                  hdmi_data_e,
  output      [23:0]      hdmi_data,

  output                  spdif,

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

/*
  output      [13:0]      ddr3_addr,
  output      [ 2:0]      ddr3_ba,
  output                  ddr3_cas_n,
  output      [ 0:0]      ddr3_ck_n,
  output      [ 0:0]      ddr3_ck_p,
  output      [ 0:0]      ddr3_cke,
  output      [ 0:0]      ddr3_cs_n,
  output      [ 7:0]      ddr3_dm,
  inout       [63:0]      ddr3_dq,
  inout       [ 7:0]      ddr3_dqs_n,
  inout       [ 7:0]      ddr3_dqs_p,
  output      [ 0:0]      ddr3_odt,
  output                  ddr3_ras_n,
  output                  ddr3_reset_n,
  output                  ddr3_we_n,
*/

  inout                   iic_scl,
  inout                   iic_sda,

//de aici inlocuiesti tot cu ce ai in constrangeri


  output                  rx_0_clk_p,
  output                  rx_0_clk_n,
  output                  rx_1_clk_p,
  output                  rx_1_clk_n,
  output                  rx_2_clk_p,
  output                  rx_2_clk_n,
  output                  rx_3_clk_p,
  output                  rx_3_clk_n,


  output                  rx_0_cnv_p,
  output                  rx_0_cnv_n,
  output                  rx_1_cnv_p,
  output                  rx_1_cnv_n,
  output                  rx_2_cnv_p,
  output                  rx_2_cnv_n,
  output                  rx_3_cnv_p,
  output                  rx_3_cnv_n,

  input                   rx_0_dco_p,
  input                   rx_0_dco_n,
  input                   rx_1_dco_p,
  input                   rx_1_dco_n,
  input                   rx_2_dco_p,
  input                   rx_2_dco_n,
  input                   rx_3_dco_p,
  input                   rx_3_dco_n,

  input                   rx_0_db_p,
  input                   rx_0_db_n,
  input                   rx_1_db_p,
  input                   rx_1_db_n,
  input                   rx_2_db_p,
  input                   rx_2_db_n,
  input                   rx_3_db_p,
  input                   rx_3_db_n,

  input                   rx_0_da_p,
  input                   rx_0_da_n,
  input                   rx_1_da_p,
  input                   rx_1_da_n,
  input                   rx_2_da_p,
  input                   rx_2_da_n,
  input                   rx_3_da_p,
  input                   rx_3_da_n,


  output                  tx_0_1_cs,
  output                  tx_0_1_sclk,
  inout                   tx_0_1_sdio0,
  inout                   tx_0_1_sdio1,
  inout                   tx_0_1_sdio2,
  inout                   tx_0_1_sdio3,
  output                  tx_2_3_cs,
  output                  tx_2_3_sclk,
  inout                   tx_2_3_sdio0,
  inout                   tx_2_3_sdio1,
  inout                   tx_2_3_sdio2,
  inout                   tx_2_3_sdio3,


  input                   spi_0_miso,
  output                  spi_0_mosi,
  output                  spi_0_sck,
  output                  spi_0_csb0

/*
  output                  fmc_la14_p,
  output                  fmc_la14_n,
  output                  fmc_la30_p,
  output                  fmc_la30_n,
  input                   fmc_la31_p,
  output                  fmc_la31_n,
  output                  fmc_la32_p,
  output                  fmc_la32_n,


  input                   alert_1,
  output                  ladc_1,
  input                   alert_2,
  output                  ldac_2
*/


);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 2:0]  spi0_csn;
  wire            spi0_clk;
  wire            spi0_mosi;
  wire            spi0_miso;
  wire    [ 2:0]  spi1_csn;
  wire            spi1_clk;
  wire            spi1_mosi;
  wire            spi1_miso;
  wire            trig;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire            tx_sync;


  wire            rx_0_cnv_s;
  wire            rx_1_cnv_s;
  wire            rx_2_cnv_s;
  wire            rx_3_cnv_s;

  wire            rx_0_cnv;
  wire            rx_1_cnv;
  wire            rx_2_cnv;
  wire            rx_3_cnv;

  wire            clk_gate;
  wire            sampling_clk_s;

  wire            ltc_0_clk;
  wire            ltc_1_clk;
  wire            ltc_2_clk;
  wire            ltc_3_clk;

  wire   [ 3:0]   tx_0_1_sdio;
  wire   [ 3:0]   tx_2_3_sdio;

  wire   [ 3:0]   tx_0_1_sdt;
  wire   [ 3:0]   tx_0_1_sdo;
  wire   [ 3:0]   tx_0_1_sdi;

  wire   [ 3:0]   tx_2_3_sdt;
  wire   [ 3:0]   tx_2_3_sdo;
  wire   [ 3:0]   tx_2_3_sdi;

  // spi

  assign tx_0_1_sdio[0] = tx_0_1_sdio0;
  assign tx_0_1_sdio[1] = tx_0_1_sdio1;
  assign tx_0_1_sdio[2] = tx_0_1_sdio2;
  assign tx_0_1_sdio[3] = tx_0_1_sdio3;

  assign tx_2_3_sdio[0] = tx_2_3_sdio0;
  assign tx_2_3_sdio[1] = tx_2_3_sdio1;
  assign tx_2_3_sdio[2] = tx_2_3_sdio2;
  assign tx_2_3_sdio[3] = tx_2_3_sdio3;

  assign spi_csn_adc = spi0_csn[2];
  assign spi_csn_dac = spi0_csn[1];
  assign spi_csn_clk = spi0_csn[0];

  // instantiations

//spi stuff

  ad_iobuf #(
  .DATA_WIDTH(4)
  ) i_spi_iobuf0 (
    .dio_t(tx_0_1_sdt),
    .dio_i(tx_0_1_sdo),
    .dio_o(tx_0_1_sdi), 
    .dio_p(tx_0_1_sdio));

  ad_iobuf #(
  .DATA_WIDTH(4)
  ) i_spi_iobuf1 (
    .dio_t(tx_2_3_sdt),
    .dio_i(tx_2_3_sdo),
    .dio_o(tx_2_3_sdi), 
    .dio_p(tx_2_3_sdio));


  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_clk_oddr0 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_0_clk));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_clk_oddr1 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_1_clk));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_clk_oddr2 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_2_clk));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_clk_oddr3 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_3_clk));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_cnv_oddr0 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_0_cnv),
    .D2 (rx_0_cnv),
    .Q (rx_0_cnv_s));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_cnv_oddr1 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_1_cnv),
    .D2 (rx_1_cnv),
    .Q (rx_1_cnv_s));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_cnv_oddr2 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_2_cnv),
    .D2 (rx_2_cnv),
    .Q (rx_2_cnv_s));

  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_cnv_oddr3 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_3_cnv),
    .D2 (rx_3_cnv),
    .Q (rx_3_cnv_s));

  OBUFDS i_tx_data_obuf0 (
    .I (ltc_0_clk),
    .O (rx_0_clk_p),
    .OB (rx_0_clk_n));

  OBUFDS i_tx_data_obuf1 (
    .I (ltc_1_clk),
    .O (rx_1_clk_p),
    .OB (rx_1_clk_n));

  OBUFDS i_tx_data_obuf2 (
    .I (ltc_2_clk),
    .O (rx_2_clk_p),
    .OB (rx_2_clk_n));

  OBUFDS i_tx_data_obuf3 (
    .I (ltc_3_clk),
    .O (rx_3_clk_p),
    .OB (rx_3_clk_n));

  OBUFDS OBUFDS_cnv0 (
    .O(rx_0_cnv_p),
    .OB(rx_0_cnv_n),
    .I(rx_0_cnv_s));

  OBUFDS OBUFDS_cnv1 (
    .O(rx_1_cnv_p),
    .OB(rx_1_cnv_n),
    .I(rx_1_cnv_s));

  OBUFDS OBUFDS_cnv2 (
    .O(rx_2_cnv_p),
    .OB(rx_2_cnv_n),
    .I(rx_2_cnv_s));

  OBUFDS OBUFDS_cnv3 (
    .O(rx_3_cnv_p),
    .OB(rx_3_cnv_n),
    .I(rx_3_cnv_s));


  //assign spi_clk = spi0_clk;


  ad_iobuf #(.DATA_WIDTH(15)) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:44] = gpio_o[63:44];
  assign gpio_i[39] = gpio_o[39];
  assign gpio_i[37] = gpio_o[37];
  assign gpio_i[31:15] = gpio_o[31:15];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .spdif (spdif),
    .spi0_clk_i (spi0_clk),
    .spi0_clk_o (spi0_clk),
    .spi0_csn_0_o (spi0_csn[0]),
    .spi0_csn_1_o (spi0_csn[1]),
    .spi0_csn_2_o (spi0_csn[2]),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi0_miso),
    .spi0_sdo_i (spi0_mosi),
    .spi0_sdo_o (spi0_mosi),
    .spi1_clk_i (spi1_clk),
    .spi1_clk_o (spi1_clk),
    .spi1_csn_0_o (spi1_csn[0]),
    .spi1_csn_1_o (spi1_csn[1]),
    .spi1_csn_2_o (spi1_csn[2]),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b1),
    .spi1_sdo_i (spi1_mosi),
    .spi1_sdo_o (spi1_mosi),
    //.sys_clk_clk_n (sys_clk_n),
    //.sys_clk_clk_p (sys_clk_p),
    //.sys_rst (sys_rst),
    //.ref_clk    (clk_s),
    .rx_0_dco_p   (rx_0_dco_p),
    .rx_0_dco_n   (rx_0_dco_n),
    .rx_0_cnv     (rx_0_cnv),
    .rx_0_da_p    (rx_0_da_p),
    .rx_0_da_n    (rx_0_da_n),
    .rx_0_db_p    (rx_0_db_p),
    .rx_0_db_n    (rx_0_db_n),
    .rx_1_dco_p   (rx_1_dco_p),
    .rx_1_dco_n   (rx_1_dco_n),
    .rx_1_cnv     (rx_1_cnv),
    .rx_1_da_p    (rx_1_da_p),
    .rx_1_da_n    (rx_1_da_n),
    .rx_1_db_p    (rx_1_db_p),
    .rx_1_db_n    (rx_1_db_n),
    .rx_2_dco_p   (rx_2_dco_p),
    .rx_2_dco_n   (rx_2_dco_n),
    .rx_2_cnv     (rx_2_cnv),
    .rx_2_da_p    (rx_2_da_p),
    .rx_2_da_n    (rx_2_da_n),
    .rx_2_db_p    (rx_2_db_p),
    .rx_2_db_n    (rx_2_db_n),
    .rx_3_dco_p   (rx_3_dco_p),
    .rx_3_dco_n   (rx_3_dco_n),
    .rx_3_cnv     (rx_3_cnv),
    .rx_3_da_p    (rx_3_da_p),
    .rx_3_da_n    (rx_3_da_n),
    .rx_3_db_p    (rx_3_db_p),
    .rx_3_db_n    (rx_3_db_n),
///*
    .tx_0_1_cs   (tx_0_1_cs),
    .tx_0_1_sclk (tx_0_1_sclk),
    .tx_0_1_sdi0 (tx_0_1_sdi[0]),
    .tx_0_1_sdi1 (tx_0_1_sdi[1]),
    .tx_0_1_sdi2 (tx_0_1_sdi[2]),
    .tx_0_1_sdi3 (tx_0_1_sdi[3]),
    .tx_0_1_sdo0 (tx_0_1_sdo[0]),
    .tx_0_1_sdo1 (tx_0_1_sdo[1]),
    .tx_0_1_sdo2 (tx_0_1_sdo[2]),
    .tx_0_1_sdo3 (tx_0_1_sdo[3]),
//    .tx_0_1_sdt (tx_0_1_sdt),
///*
    .tx_0_1_sdt0 (tx_0_1_sdt[0]),
    .tx_0_1_sdt1 (tx_0_1_sdt[1]),
    .tx_0_1_sdt2 (tx_0_1_sdt[2]),
    .tx_0_1_sdt3 (tx_0_1_sdt[3]),
//*/
    .tx_2_3_cs   (tx_2_3_cs),
    .tx_2_3_sclk (tx_2_3_sclk),
    .tx_2_3_sdi0 (tx_2_3_sdi[0]),
    .tx_2_3_sdi1 (tx_2_3_sdi[1]),
    .tx_2_3_sdi2 (tx_2_3_sdi[2]),
    .tx_2_3_sdi3 (tx_2_3_sdi[3]),
    .tx_2_3_sdo0 (tx_2_3_sdo[0]),
    .tx_2_3_sdo1 (tx_2_3_sdo[1]),
    .tx_2_3_sdo2 (tx_2_3_sdo[2]),
    .tx_2_3_sdo3 (tx_2_3_sdo[3]),
//    .tx_2_3_sdt (tx_2_3_sdt),
///*
    .tx_2_3_sdt0 (tx_2_3_sdt[0]),
    .tx_2_3_sdt1 (tx_2_3_sdt[1]),
    .tx_2_3_sdt2 (tx_2_3_sdt[2]),
    .tx_2_3_sdt3 (tx_2_3_sdt[3]),
//*/
//*/
/*
    .tx_0_1_cs    (tx_0_1_cs),
    .tx_0_1_sclk  (tx_0_1_sclk),
    .tx_0_1_sdio0 (tx_0_1_sdio[0]),
    .tx_0_1_sdio1 (tx_0_1_sdio[1]),
    .tx_0_1_sdio2 (tx_0_1_sdio[2]),
    .tx_0_1_sdio3 (tx_0_1_sdio[3]),
    .tx_2_3_cs    (tx_2_3_cs),
    .tx_2_3_sclk  (tx_2_3_sclk),
    .tx_2_3_sdio0 (tx_2_3_sdio[0]),
    .tx_2_3_sdio1 (tx_2_3_sdio[1]),
    .tx_2_3_sdio2 (tx_2_3_sdio[2]),
    .tx_2_3_sdio3 (tx_2_3_sdio[3]),
*/
    .sampling_clk(sampling_clk_s)
    );

endmodule

// ***************************************************************************
// ***************************************************************************
