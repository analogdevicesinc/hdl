// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module system_top  #(
  parameter NUM_OF_SDI = 2
) (

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  input                   uart_sin,
  output                  uart_sout,

  output                  ddr4_act_n,
  output      [16:0]      ddr4_addr,
  output      [ 1:0]      ddr4_ba,
  output                  ddr4_bg,
  output                  ddr4_ck_p,
  output                  ddr4_ck_n,
  output                  ddr4_cke,
  output                  ddr4_cs_n,
  inout       [ 7:0]      ddr4_dm_n,
  inout       [63:0]      ddr4_dq,
  inout       [ 7:0]      ddr4_dqs_p,
  inout       [ 7:0]      ddr4_dqs_n,
  output                  ddr4_odt,
  output                  ddr4_reset_n,

  output                  mdio_mdc,
  inout                   mdio_mdio,
  input                   phy_clk_p,
  input                   phy_clk_n,
  output                  phy_rst_n,
  input                   phy_rx_p,
  input                   phy_rx_n,
  output                  phy_tx_p,
  output                  phy_tx_n,

  inout       [16:0]      gpio_bd,

  output                  iic_rstn,
  inout                   iic_scl,
  inout                   iic_sda,

  // FMC+ IOs AD9213

  input                   rx_ref_clk_p,
  input                   rx_ref_clk_n,
  input                   rx_ref_clk_replica_p,
  input                   rx_ref_clk_replica_n,
  input       [15:0]      rx_data_p,
  input       [15:0]      rx_data_n,

  input                   glbl_clk_0_p,
  input                   glbl_clk_0_n,

  input                   rx_sysref_p,
  input                   rx_sysref_n,
  output                  rx_sync_p,
  output                  rx_sync_n,

  output                  fpga_sclk,
  inout                   fpga_sdio,
  output                  fpga_csb,

  output                  adf4371_csb,

  output                  hmc7044_sclk,
  inout                   hmc7044_sdio,
  output                  hmc7044_csb,

  inout       [ 4:0]      gpio,

  output                  rstb,
  output                  hmc_sync_req,
  
  // ad463x SPI configuration interface

  input [NUM_OF_SDI-1:0]  ad463x_spi_sdi,
  output                  ad463x_spi_sdo,
  output                  ad463x_spi_sclk,
  output                  ad463x_spi_cs,

  input                   ad463x_echo_sclk,
  output                  ad463x_cnv,
  input                   ad463x_busy,
  inout                   ad463x_resetn
);

  // internal signals
  wire            ext_clk_s;

  wire    [ 1:0]  iic_mux_scl_i_s;
  wire    [ 1:0]  iic_mux_scl_o_s;
  wire            iic_mux_scl_t_s;
  wire    [ 1:0]  iic_mux_sda_i_s;
  wire    [ 1:0]  iic_mux_sda_o_s;
  wire            iic_mux_sda_t_s;
  wire            ad463x_echo_sclk_s;

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  wire            spi_miso;
  wire            spi_mosi;
  wire            hmc7044_miso;
  wire            hmc7044_mosi;
  wire    [ 1:0]  hmc7044_csn;

  wire            rx_ref_clk;
  wire            rx_ref_clk_replica;
  wire            rx_sysref;
  wire            rx_sync;

  assign iic_rstn = 1'b1;
  assign hmc7044_csb = hmc7044_csn[0];
  assign adf4371_csb = hmc7044_csn[1];

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_rx_ref_clk_replica (
    .CEB (1'd0),
    .I (rx_ref_clk_replica_p),
    .IB (rx_ref_clk_replica_n),
    .O (rx_ref_clk_replica),
    .ODIV2 ());

  IBUFDS i_ibufds_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS_GTE4 i_ibufds_glbl_clk_0 (
    .I (glbl_clk_0_p),
    .IB (glbl_clk_0_n),
    .ODIV2 (glbl_clk_0));

  BUFG_GT i_bufg_glbl_clk_0(
    .I (glbl_clk_0),
    .O (glbl_clk_buf));

  ad_iobuf #(
    .DATA_WIDTH(22)
  ) i_iobuf (
    .dio_t (gpio_t[36:32]),
    .dio_i (gpio_o[36:32]),
    .dio_o (gpio_i[36:32]),
    .dio_p ({gpio[4:0],     // 36-32
             gpio_bd}));    // 31-16  

  assign hmc_sync_req = gpio_o[37];
  assign rstb         = gpio_o[38];

  assign gpio_i[63:40] = gpio_o[63:40];
  assign gpio_i[14:0] = gpio_o[14:0];

  ad_3w_spi #(
    .NUM_OF_SLAVES(2)
  ) i_hmc7044_spi (
    .spi_csn (hmc7044_csn[1:0]),
    .spi_clk (hmc7044_sclk),
    .spi_mosi (hmc7044_mosi),
    .spi_miso (hmc7044_miso),
    .spi_sdio (hmc7044_sdio),
    .spi_dir ());

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_ad9213_spi (
    .spi_csn (fpga_csb),
    .spi_clk (fpga_sclk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (fpga_sdio),
    .spi_dir ());

  ad_data_clk #(
    .SINGLE_ENDED (1)
  ) i_echo_sclk (
    .rst (1'b0),
    .locked (),
    .clk_in_p (ad463x_echo_sclk),
    .clk_in_n (1'b0),
    .clk (ad463x_echo_sclk_s));

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_ad463x_gpio_iobuf (
    .dio_t(gpio_t[39]),
    .dio_i(gpio_o[39]),
    .dio_o(gpio_i[39]),
    .dio_p(ad463x_resetn));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iic_mux_scl (
    .dio_t({iic_mux_scl_t_s, iic_mux_scl_t_s}),
    .dio_i(iic_mux_scl_o_s),
    .dio_o(iic_mux_scl_i_s),
    .dio_p(iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iic_mux_sda (
    .dio_t({iic_mux_sda_t_s, iic_mux_sda_t_s}),
    .dio_i(iic_mux_sda_o_s),
    .dio_o(iic_mux_sda_i_s),
    .dio_p(iic_mux_sda));

  system_wrapper i_system_wrapper (
    .sys_rst (sys_rst),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .ddr4_act_n (ddr4_act_n),
    .ddr4_adr (ddr4_addr),
    .ddr4_ba (ddr4_ba),
    .ddr4_bg (ddr4_bg),
    .ddr4_ck_c (ddr4_ck_n),
    .ddr4_ck_t (ddr4_ck_p),
    .ddr4_cke (ddr4_cke),
    .ddr4_cs_n (ddr4_cs_n),
    .ddr4_dm_n (ddr4_dm_n),
    .ddr4_dq (ddr4_dq),
    .ddr4_dqs_c (ddr4_dqs_n),
    .ddr4_dqs_t (ddr4_dqs_p),
    .ddr4_odt (ddr4_odt),
    .ddr4_reset_n (ddr4_reset_n),
    .phy_sd (1'b1),
    .phy_rst_n (phy_rst_n),
    .sgmii_rxn (phy_rx_n),
    .sgmii_rxp (phy_rx_p),
    .sgmii_txn (phy_tx_n),
    .sgmii_txp (phy_tx_p),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .sgmii_phyclk_clk_n (phy_clk_n),
    .sgmii_phyclk_clk_p (phy_clk_p),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .spi_clk_i (fpga_sclk),
    .spi_clk_o (fpga_sclk),
    .spi_csn_i (fpga_csb),
    .spi_csn_o (fpga_csb),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .hmc7044_clk_i (hmc7044_sclk),
    .hmc7044_clk_o (hmc7044_sclk),
    .hmc7044_csn_i (hmc7044_csn),
    .hmc7044_csn_o (hmc7044_csn),
    .hmc7044_sdi_i (hmc7044_miso),
    .hmc7044_sdo_i (hmc7044_mosi),
    .hmc7044_sdo_o (hmc7044_mosi),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
     // FMC+
    .rx_data_0_n  (rx_data_n[1]),
    .rx_data_0_p  (rx_data_p[1]),
    .rx_data_1_n  (rx_data_n[3]),
    .rx_data_1_p  (rx_data_p[3]),
    .rx_data_2_n  (rx_data_n[2]),
    .rx_data_2_p  (rx_data_p[2]),
    .rx_data_3_n  (rx_data_n[4]),
    .rx_data_3_p  (rx_data_p[4]),
    .rx_data_4_n  (rx_data_n[0]),
    .rx_data_4_p  (rx_data_p[0]),
    .rx_data_5_n  (rx_data_n[15]),
    .rx_data_5_p  (rx_data_p[15]),
    .rx_data_6_n  (rx_data_n[8]),
    .rx_data_6_p  (rx_data_p[8]),
    .rx_data_7_n  (rx_data_n[7]),
    .rx_data_7_p  (rx_data_p[7]),
    .rx_data_8_n  (rx_data_n[5]),
    .rx_data_8_p  (rx_data_p[5]),
    .rx_data_9_n  (rx_data_n[6]),
    .rx_data_9_p  (rx_data_p[6]),
    .rx_data_10_n (rx_data_n[10]),
    .rx_data_10_p (rx_data_p[10]),
    .rx_data_11_n (rx_data_n[9]),
    .rx_data_11_p (rx_data_p[9]),
    .rx_data_12_n (rx_data_n[12]),
    .rx_data_12_p (rx_data_p[12]),
    .rx_data_13_n (rx_data_n[14]),
    .rx_data_13_p (rx_data_p[14]),
    .rx_data_14_n (rx_data_n[13]),
    .rx_data_14_p (rx_data_p[13]),
    .rx_data_15_n (rx_data_n[11]),
    .rx_data_15_p (rx_data_p[11]),
    .rx_ref_clk_0 (rx_ref_clk),
    .rx_ref_clk_1 (rx_ref_clk_replica),
    .glbl_clk_0 (glbl_clk_buf),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (rx_sysref),
    .ad463x_spi_sdo (ad463x_spi_sdo),
    .ad463x_spi_sdi (ad463x_spi_sdi),
    .ad463x_spi_cs (ad463x_spi_cs),
    .ad463x_spi_sclk (ad463x_spi_sclk),
    .ad463x_echo_sclk (ad463x_echo_sclk_s),
    .ad463x_busy (ad463x_busy),
    .ad463x_cnv (ad463x_cnv));

endmodule
