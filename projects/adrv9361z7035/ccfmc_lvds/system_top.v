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

module system_top (

  inout   [14:0]  ddr_addr,
  inout   [ 2:0]  ddr_ba,
  inout           ddr_cas_n,
  inout           ddr_ck_n,
  inout           ddr_ck_p,
  inout           ddr_cke,
  inout           ddr_cs_n,
  inout   [ 3:0]  ddr_dm,
  inout   [31:0]  ddr_dq,
  inout   [ 3:0]  ddr_dqs_n,
  inout   [ 3:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  output          eth1_mdc,
  inout           eth1_mdio,
  input           eth1_rgmii_rxclk,
  input           eth1_rgmii_rxctl,
  input   [ 3:0]  eth1_rgmii_rxdata,
  output          eth1_rgmii_txclk,
  output          eth1_rgmii_txctl,
  output  [ 3:0]  eth1_rgmii_txdata,

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [53:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  output          hdmi_out_clk,
  output          hdmi_vsync,
  output          hdmi_hsync,
  output          hdmi_data_e,
  output  [15:0]  hdmi_data,
  output          hdmi_pd,
  input           hdmi_intn,

  output          spdif,
  input           spdif_in,

  output          i2s_mclk,
  output          i2s_bclk,
  output          i2s_lrclk,
  output          i2s_sdata_out,
  input           i2s_sdata_in,

  inout           iic_scl,
  inout           iic_sda,

  inout   [20:0]  gpio_bd,

  output          fan_pwm,
  input           fan_tach,

  input           clk_0_p,
  input           clk_0_n,
  input           clk_1_p,
  input           clk_1_n,

  inout   [31:0]  gpio_lb_00_tri_io,
  inout   [31:0]  gpio_lb_01_tri_io,
  inout   [ 3:0]  gpio_lb_10_tri_io,
  inout   [ 5:0]  gpio_lb_11_tri_io,
  inout   [ 9:0]  gpio_lb_20_tri_io,
  inout   [21:0]  gpio_lb_21_tri_io,

  input           gt_ref_clk_0_p,
  input           gt_ref_clk_0_n,
  input           gt_ref_clk_1_p,
  input           gt_ref_clk_1_n,
  output  [ 1:0]  gt_tx_p,
  output  [ 1:0]  gt_tx_n,
  input   [ 1:0]  gt_rx_p,
  input   [ 1:0]  gt_rx_n,

  output          ad9517_csn,
  output          ad9517_clk,
  output          ad9517_mosi,
  input           ad9517_miso,
  inout           ad9517_pdn,
  inout           ad9517_ref_sel,
  inout           ad9517_ld,
  inout           ad9517_status,

  input           rx_clk_in_p,
  input           rx_clk_in_n,
  input           rx_frame_in_p,
  input           rx_frame_in_n,
  input   [ 5:0]  rx_data_in_p,
  input   [ 5:0]  rx_data_in_n,
  output          tx_clk_out_p,
  output          tx_clk_out_n,
  output          tx_frame_out_p,
  output          tx_frame_out_n,
  output  [ 5:0]  tx_data_out_p,
  output  [ 5:0]  tx_data_out_n,

  output          enable,
  output          txnrx,
  input           clkout_in,
  inout           tdd_sync,

  inout           gpio_rf0,
  output          gpio_rf1,
  output          gpio_rf2,
  input           gpio_rf3,
  input           gpio_rf4,
  inout           gpio_rf5,
  inout           gpio_clksel,
  inout           gpio_resetb,
  inout           gpio_sync,
  inout           gpio_en_agc,
  inout   [ 3:0]  gpio_ctl,
  inout   [ 7:0]  gpio_status,

  output          spi_csn,
  output          spi_clk,
  output          spi_mosi,
  input           spi_miso
);

  // internal signals

  wire    [ 1:0]  spi_csn_s;
  wire            spi_clk_s;
  wire            spi_mosi_s;
  wire            spi_miso_s;
  wire            sys_cpu_clk;
  wire            clk_0;
  wire            clk_1;
  wire            gt_ref_clk_1;
  wire            gt_ref_clk_0;
  wire    [63:0]  gp_out_s;
  wire    [63:0]  gp_in_s;
  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire            tdd_sync_i;
  wire            tdd_sync_o;
  wire            tdd_sync_t;

  wire    [31:0]  gpio_lb_00_i;
  wire    [31:0]  gpio_lb_00_o;
  wire    [31:0]  gpio_lb_00_t;
  wire    [31:0]  gpio_lb_01_i;
  wire    [31:0]  gpio_lb_01_o;
  wire    [31:0]  gpio_lb_01_t;

  wire    [ 3:0]  gpio_lb_10_i;
  wire    [ 3:0]  gpio_lb_10_o;
  wire    [ 3:0]  gpio_lb_10_t;
  wire    [ 5:0]  gpio_lb_11_i;
  wire    [ 5:0]  gpio_lb_11_o;
  wire    [ 5:0]  gpio_lb_11_t;

  wire    [ 9:0]  gpio_lb_20_i;
  wire    [ 9:0]  gpio_lb_20_o;
  wire    [ 9:0]  gpio_lb_20_t;
  wire    [21:0]  gpio_lb_21_i;
  wire    [21:0]  gpio_lb_21_o;
  wire    [21:0]  gpio_lb_21_t;

  // assignments

  assign fan_pwm = 1'b1;
  assign hdmi_pd = 1'b0;
  assign spi_csn = spi_csn_s[0];
  assign spi_clk = spi_clk_s;
  assign spi_mosi = spi_mosi_s;
  assign ad9517_csn = spi_csn_s[1];
  assign ad9517_clk = spi_clk_s;
  assign ad9517_mosi = spi_mosi_s;
  assign spi_miso_s = (~spi_csn_s[0] & spi_miso) | (~spi_csn_s[1] & ad9517_miso);

  // unused gpios

  assign gpio_i[63:61] = gpio_o[63:61];
  assign gpio_i[55:53] = gpio_o[55:53];
  assign gpio_i[50:47] = gpio_o[50:47];
  assign gpio_i[31:21] = gpio_o[31:21];

  // instantiations

  IBUFDS i_ibufds_clk_0 (
    .I (clk_0_p),
    .IB (clk_0_n),
    .O (clk_0));

  IBUFDS i_ibufds_clk_1 (
    .I (clk_1_p),
    .IB (clk_1_n),
    .O (clk_1));

  IBUFDS_GTE2 i_ibufds_gt_ref_clk_0 (
    .CEB (1'd0),
    .I (gt_ref_clk_0_p),
    .IB (gt_ref_clk_0_n),
    .O (gt_ref_clk_0),
    .ODIV2 ());

  IBUFDS_GTE2 i_ibufds_gt_ref_clk_1 (
    .CEB (1'd0),
    .I (gt_ref_clk_1_p),
    .IB (gt_ref_clk_1_n),
    .O (gt_ref_clk_1),
    .ODIV2 ());

  ad_iobuf #(
    .DATA_WIDTH (1)
  ) i_iobuf_tdd_sync (
    .dio_t (tdd_sync_t),
    .dio_i (tdd_sync_o),
    .dio_o (tdd_sync_i),
    .dio_p (tdd_sync));

  // board gpio - 31-0

  ad_iobuf #(
    .DATA_WIDTH (21)
  ) i_iobuf_bd (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p (gpio_bd));

  // rf & ad9517 gpio - 60:56

  ad_iobuf #(
    .DATA_WIDTH (5)
  ) i_iobuf (
    .dio_t (gpio_t[60:56]),
    .dio_i (gpio_o[60:56]),
    .dio_o (gpio_i[60:56]),
    .dio_p ({ ad9517_pdn,         // 60:60
              ad9517_ref_sel,     // 59:59
              ad9517_ld,          // 58:58
              ad9517_status,      // 57:57
              gpio_rf0}));        // 56:56

  // rf & clock-select gpio - 52:51

  ad_iobuf #(
    .DATA_WIDTH (2)
  ) i_iobuf_rf_1 (
    .dio_t (gpio_t[52:51]),
    .dio_i (gpio_o[52:51]),
    .dio_o (gpio_i[52:51]),
    .dio_p ({ gpio_rf5,           // 52:52
              gpio_clksel}));     // 51:51

  // ad9361 gpio - 46:32

  ad_iobuf #(
    .DATA_WIDTH (15)
  ) i_iobuf_ad9361 (
    .dio_t (gpio_t[46:32]),
    .dio_i (gpio_o[46:32]),
    .dio_o (gpio_i[46:32]),
    .dio_p ({ gpio_resetb,        // 46:46
              gpio_sync,          // 45:45
              gpio_en_agc,        // 44:44
              gpio_ctl,           // 43:40
              gpio_status}));     // 39:32

  // ad9361 input protection

  ad_adl5904_rst i_adl5904_rst_a (
    .sys_cpu_clk (sys_cpu_clk),
    .rf_peak_det_n (gpio_rf4),
    .rf_peak_rst (gpio_rf2));

  ad_adl5904_rst i_adl5904_rst_b (
    .sys_cpu_clk (sys_cpu_clk),
    .rf_peak_det_n (gpio_rf3),
    .rf_peak_rst (gpio_rf1));

  ad_iobuf #(
    .DATA_WIDTH (32)
  ) gpio_lb_00_iobuf (
    .dio_t (gpio_lb_00_t),
    .dio_i (gpio_lb_00_o),
    .dio_o (gpio_lb_00_i),
    .dio_p (gpio_lb_00_tri_io));

  ad_iobuf #(
    .DATA_WIDTH (32)
  ) gpio_lb_01_iobuf (
    .dio_t (gpio_lb_01_t),
    .dio_i (gpio_lb_01_o),
    .dio_o (gpio_lb_01_i),
    .dio_p (gpio_lb_01_tri_io));

  ad_iobuf #(
    .DATA_WIDTH(4)
  ) gpio_lb_10_iobuf (
    .dio_t (gpio_lb_10_t),
    .dio_i (gpio_lb_10_o),
    .dio_o (gpio_lb_10_i),
    .dio_p (gpio_lb_10_tri_io));

  ad_iobuf #(
    .DATA_WIDTH (6)
  ) gpio_lb_11_iobuf (
    .dio_t (gpio_lb_11_t),
    .dio_i (gpio_lb_11_o),
    .dio_o (gpio_lb_11_i),
    .dio_p (gpio_lb_11_tri_io));

  ad_iobuf #(
    .DATA_WIDTH (10)
  ) gpio_lb_20_iobuf (
    .dio_t (gpio_lb_20_t),
    .dio_i (gpio_lb_20_o),
    .dio_o (gpio_lb_20_i),
    .dio_p (gpio_lb_20_tri_io));

  ad_iobuf #(
    .DATA_WIDTH (22)
  ) gpio_lb_21_iobuf (
    .dio_t (gpio_lb_21_t),
    .dio_i (gpio_lb_21_o),
    .dio_o (gpio_lb_21_i),
    .dio_p (gpio_lb_21_tri_io));

  // instantiations

  system_wrapper i_system_wrapper (
    .clk_0 (clk_0),
    .clk_1 (clk_1),

    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .enable (enable),

    .eth1_intn (1'b1),
    .eth1_mdio_mdc (eth1_mdc),
    .eth1_mdio_mdio_io (eth1_mdio),
    .eth1_rgmii_rd (eth1_rgmii_rxdata),
    .eth1_rgmii_rx_ctl (eth1_rgmii_rxctl),
    .eth1_rgmii_rxc (eth1_rgmii_rxclk),
    .eth1_rgmii_td (eth1_rgmii_txdata),
    .eth1_rgmii_tx_ctl (eth1_rgmii_txctl),
    .eth1_rgmii_txc (eth1_rgmii_txclk),

    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),

    .gpio_lb_00_i (gpio_lb_00_i),
    .gpio_lb_00_o (gpio_lb_00_o),
    .gpio_lb_00_t (gpio_lb_00_t),
    .gpio_lb_01_i (gpio_lb_01_i),
    .gpio_lb_01_o (gpio_lb_01_o),
    .gpio_lb_01_t (gpio_lb_01_t),
    .gpio_lb_10_i (gpio_lb_10_i),
    .gpio_lb_10_o (gpio_lb_10_o),
    .gpio_lb_10_t (gpio_lb_10_t),
    .gpio_lb_11_i (gpio_lb_11_i),
    .gpio_lb_11_o (gpio_lb_11_o),
    .gpio_lb_11_t (gpio_lb_11_t),
    .gpio_lb_20_i (gpio_lb_20_i),
    .gpio_lb_20_o (gpio_lb_20_o),
    .gpio_lb_20_t (gpio_lb_20_t),
    .gpio_lb_21_i (gpio_lb_21_i),
    .gpio_lb_21_o (gpio_lb_21_o),
    .gpio_lb_21_t (gpio_lb_21_t),

    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),

    .gps_pps (1'b0),
    .gt_ref_clk_0 (gt_ref_clk_0),
    .gt_ref_clk_1 (gt_ref_clk_1),
    .gt_rx_n (gt_rx_n),
    .gt_rx_p (gt_rx_p),
    .gt_tx_n (gt_tx_n),
    .gt_tx_p (gt_tx_p),

    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),

    .i2s_bclk (i2s_bclk),
    .i2s_lrclk (i2s_lrclk),
    .i2s_mclk (i2s_mclk),
    .i2s_sdata_in (i2s_sdata_in),
    .i2s_sdata_out (i2s_sdata_out),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .otg_vbusoc (1'b0),

    .rx_clk_in_n (rx_clk_in_n),
    .rx_clk_in_p (rx_clk_in_p),
    .rx_data_in_n (rx_data_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .spdif (spdif),

    .spi0_clk_i (1'b0),
    .spi0_clk_o (spi_clk_s),
    .spi0_csn_0_o (spi_csn_s[0]),
    .spi0_csn_1_o (spi_csn_s[1]),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi_miso_s),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (spi_mosi_s),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (),
    
    .sys_cpu_clk_out (sys_cpu_clk),
    .tdd_sync_i (tdd_sync_i),
    .tdd_sync_o (tdd_sync_o),
    .tdd_sync_t (tdd_sync_t),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_data_out_n (tx_data_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    .txnrx (txnrx),
    .up_enable (gpio_o[47]),
    .up_txnrx (gpio_o[48]));

endmodule
