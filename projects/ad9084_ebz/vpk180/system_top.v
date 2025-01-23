// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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


module system_top #(
    parameter TX_NUM_LINKS = 1,
    parameter RX_NUM_LINKS = 1,
    parameter ASYMMETRIC_A_B_MODE = 0
  ) (

  input           sys_clk_n,
  input           sys_clk_p,

  output  [ 5:0]  ch0_lpddr4_trip1_ca_a,
  output  [ 5:0]  ch0_lpddr4_trip1_ca_b,
  output          ch0_lpddr4_trip1_ck_c_a,
  output          ch0_lpddr4_trip1_ck_c_b,
  output          ch0_lpddr4_trip1_ck_t_a,
  output          ch0_lpddr4_trip1_ck_t_b,
  output          ch0_lpddr4_trip1_cke_a,
  output          ch0_lpddr4_trip1_cke_b,
  output          ch0_lpddr4_trip1_cs_a,
  output          ch0_lpddr4_trip1_cs_b,
  inout   [ 1:0]  ch0_lpddr4_trip1_dmi_a,
  inout   [ 1:0]  ch0_lpddr4_trip1_dmi_b,
  inout   [15:0]  ch0_lpddr4_trip1_dq_a,
  inout   [15:0]  ch0_lpddr4_trip1_dq_b,
  inout   [ 1:0]  ch0_lpddr4_trip1_dqs_c_a,
  inout   [ 1:0]  ch0_lpddr4_trip1_dqs_c_b,
  inout   [ 1:0]  ch0_lpddr4_trip1_dqs_t_a,
  inout   [ 1:0]  ch0_lpddr4_trip1_dqs_t_b,
  output          ch0_lpddr4_trip1_reset_n,
  output  [ 5:0]  ch1_lpddr4_trip1_ca_a,
  output  [ 5:0]  ch1_lpddr4_trip1_ca_b,
  output          ch1_lpddr4_trip1_ck_c_a,
  output          ch1_lpddr4_trip1_ck_c_b,
  output          ch1_lpddr4_trip1_ck_t_a,
  output          ch1_lpddr4_trip1_ck_t_b,
  output          ch1_lpddr4_trip1_cke_a,
  output          ch1_lpddr4_trip1_cke_b,
  output          ch1_lpddr4_trip1_cs_a,
  output          ch1_lpddr4_trip1_cs_b,
  inout   [ 1:0]  ch1_lpddr4_trip1_dmi_a,
  inout   [ 1:0]  ch1_lpddr4_trip1_dmi_b,
  inout   [15:0]  ch1_lpddr4_trip1_dq_a,
  inout   [15:0]  ch1_lpddr4_trip1_dq_b,
  inout   [ 1:0]  ch1_lpddr4_trip1_dqs_c_a,
  inout   [ 1:0]  ch1_lpddr4_trip1_dqs_c_b,
  inout   [ 1:0]  ch1_lpddr4_trip1_dqs_t_a,
  inout   [ 1:0]  ch1_lpddr4_trip1_dqs_t_b,
  output          ch1_lpddr4_trip1_reset_n,

  // GPIOs
  output  [ 3:0]  gpio_led,
  input   [ 3:0]  gpio_dip_sw,
  input   [ 1:0]  gpio_pb,

  // FMC HPC+ IOs

  output [ 7:0] srx_p,
  output [ 7:0] srx_n,
  input  [ 7:0] stx_p,
  input  [ 7:0] stx_n,


  inout  [30:15] gpio,
  inout          aux_gpio,

  output         syncinb_a0_p,
  output         syncinb_a0_n,
  output         syncinb_b0_p,
  output         syncinb_b0_n,
  inout          syncinb_a1_p_gpio,
  inout          syncinb_a1_n_gpio,
  inout          syncinb_b1_p_gpio,
  inout          syncinb_b1_n_gpio,

  input          syncoutb_a0_p,
  input          syncoutb_a0_n,
  input          syncoutb_b0_p,
  input          syncoutb_b0_n,
  inout          syncoutb_a1_p_gpio,
  inout          syncoutb_a1_n_gpio,
  inout          syncoutb_b1_p_gpio,
  inout          syncoutb_b1_n_gpio,

  input          ref_clk_p,
  input          ref_clk_n,

  output         sysref_a_p,
  output         sysref_a_n,
  output         sysref_b_p,
  output         sysref_b_n,
  input          sysref_p,
  input          sysref_n,
  input          sysref_in_p,
  input          sysref_in_n,

  output         spi2_sclk,
  inout          spi2_sdio,
  input          spi2_sdo,
  output [ 5:0]  spi2_cs,

  output         dut_sdio,
  input          dut_sdo,
  output         dut_sclk,
  output         dut_csb,

  input  [ 1:0]  clk_m2c_p,
  input  [ 1:0]  clk_m2c_n,

  output         hsci_ckin_p,
  output         hsci_ckin_n,
  output         hsci_din_p,
  output         hsci_din_n,
  input          hsci_cko_p,
  input          hsci_cko_n,
  input          hsci_do_p,
  input          hsci_do_n,

  output [ 1:0]  trig_a,
  output [ 1:0]  trig_b,

  input          trig_in,
  output         resetb
);

  localparam SYNC_W = (ASYMMETRIC_A_B_MODE == 1)? 2 : RX_NUM_LINKS;

  // internal signals

  wire    [95:0]  gpio_i;
  wire    [95:0]  gpio_o;
  wire    [95:0]  gpio_t;

  wire            spi_clk;
  wire    [ 7:0]  spi_csn;
  wire            spi_sdo;
  wire            spi_sdio;
  wire            hmc7044_sdo;

  wire            apollo_spi_clk;
  wire    [ 7:0]  apollo_spi_csn;
  wire            apollo_spi_sdo;
  wire            apollo_spi_sdio;

  wire              ref_clk;
  wire              sysref;
  wire [SYNC_W-1:0] tx_syncin;
  wire [SYNC_W-1:0] rx_syncout;

  wire            clkin0;
  wire            clkin1;
  wire            tx_device_clk;
  wire            rx_device_clk;

  wire            intf_rdy;
  wire            fifo_empty;
  wire            fifo_rd_en;
  wire    [ 7:0]  hsci_data_out;
  wire    [ 7:0]  data_from_fabric;
  wire    [ 7:0]  data_to_fabric;
  wire    [ 7:0]  hsci_data_in;

  wire gt_reset;
  wire rx_reset_pll_and_datapath;
  wire tx_reset_pll_and_datapath;
  wire rx_reset_datapath;
  wire tx_reset_datapath;
  wire rx_resetdone;
  wire tx_resetdone;
  wire gt_b_reset;
  wire rx_b_reset_pll_and_datapath;
  wire tx_b_reset_pll_and_datapath;
  wire rx_b_reset_datapath;
  wire tx_b_reset_datapath;
  wire rx_b_resetdone;
  wire tx_b_resetdone;
  wire gt_powergood;

  wire [7:0] rx_data_p_loc;
  wire [7:0] rx_data_n_loc;
  wire [7:0] tx_data_p_loc;
  wire [7:0] tx_data_n_loc;

  // instantiations

  IBUFDS_GTE5 i_ibufds_ref_clk (
    .CEB (1'b0),
    .I (ref_clk_p),
    .IB (ref_clk_n),
    .O (ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_sysref_in (
    .I (sysref_in_p),
    .IB (sysref_in_n),
    .O (sysref));

  OBUFDS i_obufds_sysref_a (
    .I (1'b0),
    .O (sysref_a_p),
    .OB (sysref_a_n));

  OBUFDS i_obufds_sysref_b (
    .I (1'b0),
    .O (sysref_b_p),
    .OB (sysref_b_n));

  IBUFDS i_ibufds_sysref_ext (
    .I (sysref_p),
    .IB (sysref_n),
    .O ());

  IBUFDS i_ibufds_rx_device_clk (
    .I (clk_m2c_p[0]),
    .IB (clk_m2c_n[0]),
    .O (clkin0));

  IBUFDS i_ibufds_tx_device_clk (
    .I (clk_m2c_p[1]),
    .IB (clk_m2c_n[1]),
    .O (clkin1));

  IBUFDS i_ibufds_syncin0 (
    .I (syncoutb_a0_p),
    .IB (syncoutb_a0_n),
    .O (tx_syncin[0]));

  OBUFDS i_obufds_syncout0 (
    .I (rx_syncout[0]),
    .O (syncinb_a0_p),
    .OB (syncinb_a0_n));

  IBUFDS i_ibufds_syncin1 (
    .I (syncoutb_b0_p),
    .IB (syncoutb_b0_n),
    .O (tx_syncin[1]));

  OBUFDS i_obufds_syncout1 (
    .I (rx_syncout[1]),
    .O (syncinb_b0_p),
    .OB (syncinb_b0_n));

  BUFG i_rx_device_clk (
    .I (clkin0),
    .O (rx_device_clk));

  BUFG i_tx_device_clk (
    .I (clkin1),
    .O (tx_device_clk));

  // spi
  assign spi2_cs[5:0] = spi_csn[5:0];
  assign spi2_sclk    = spi_clk;

  ad9084_ebz_spi #(
    .NUM_OF_SLAVES(2)
  ) i_spi (
    .spi_csn (spi_csn[1:0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_sdio),
    .spi_miso (spi_sdo),
    .spi_miso_in (spi2_sdo),
    .spi_sdio (spi2_sdio));

  assign dut_csb  = apollo_spi_csn[0];
  assign dut_sclk = apollo_spi_clk;
  assign dut_sdio = apollo_spi_sdio;

  assign apollo_spi_sdo = ~apollo_spi_csn[0] ? dut_sdo : 1'b0;

  // gpios
  /* Board GPIOS. Buttons, LEDs, etc... */
  assign gpio_led    = gpio_o[3:0];
  assign gpio_i[3:0] = gpio_o[3:0];
  assign gpio_i[7:4] = gpio_dip_sw;
  assign gpio_i[9:8] = gpio_pb;

  ad_iobuf #(.DATA_WIDTH(17)) i_iobuf (
    .dio_t (gpio_t[48:32]),
    .dio_i (gpio_o[48:32]),
    .dio_o (gpio_i[48:32]),
    .dio_p ({aux_gpio,         // 48
             gpio[30:15]}));   // 47-32

  assign gpio_i[53] = trig_in;

  assign trig_a[0]  = gpio_o[58];
  assign trig_a[1]  = gpio_o[59];
  assign trig_b[0]  = gpio_o[60];
  assign trig_b[1]  = gpio_o[61];
  assign resetb     = gpio_o[62];

  assign gpio_i[64] = rx_resetdone;
  assign gpio_i[65] = tx_resetdone;
  assign gpio_i[66] = rx_resetdone & tx_resetdone;
  assign gt_reset   = gpio_o[67];
  assign rx_reset_pll_and_datapath = gpio_o[68];
  assign tx_reset_pll_and_datapath = gpio_o[69];
  assign rx_reset_datapath = gpio_o[70];
  assign tx_reset_datapath = gpio_o[71];

  assign gpio_i[72] = rx_b_resetdone;
  assign gpio_i[73] = tx_b_resetdone;
  assign gpio_i[74] = rx_b_resetdone & tx_b_resetdone;
  assign gt_b_reset = gpio_o[75];
  assign rx_b_reset_pll_and_datapath = gpio_o[76];
  assign tx_b_reset_pll_and_datapath = gpio_o[77];
  assign rx_b_reset_datapath = gpio_o[78];
  assign tx_b_reset_datapath = gpio_o[79];

  ad_iobuf #(.DATA_WIDTH(17)) i_iobuf_bd (
    .dio_t (gpio_t[26:10]),
    .dio_i (gpio_o[26:10]),
    .dio_o (gpio_i[26:10]),
    .dio_p (gpio_bd));

  assign gpio_i[95:80] = gpio_o[95:80];
  assign gpio_i[62:54] = gpio_o[62:54];
  assign gpio_i[31:27] = gpio_o[31:27];

  assign fifo_rd_en = ~fifo_empty & intf_rdy;
  assign data_from_fabric = {hsci_data_out[0], hsci_data_out[1], hsci_data_out[2], hsci_data_out[3], hsci_data_out[4], hsci_data_out[5], hsci_data_out[6], hsci_data_out[7]};
  assign hsci_data_in = (intf_rdy) ? {data_to_fabric[0], data_to_fabric[1], data_to_fabric[2], data_to_fabric[3], data_to_fabric[4], data_to_fabric[5], data_to_fabric[6], data_to_fabric[7]} : 8'h0;

  system_wrapper i_system_wrapper (
    .lpddr4_clk1_clk_n (sys_clk_n),
    .lpddr4_clk1_clk_p (sys_clk_p),

    .ch0_lpddr4_trip1_ca_a (ch0_lpddr4_trip1_ca_a),
    .ch0_lpddr4_trip1_ca_b (ch0_lpddr4_trip1_ca_b),
    .ch0_lpddr4_trip1_ck_c_a (ch0_lpddr4_trip1_ck_c_a),
    .ch0_lpddr4_trip1_ck_c_b (ch0_lpddr4_trip1_ck_c_b),
    .ch0_lpddr4_trip1_ck_t_a (ch0_lpddr4_trip1_ck_t_a),
    .ch0_lpddr4_trip1_ck_t_b (ch0_lpddr4_trip1_ck_t_b),
    .ch0_lpddr4_trip1_cke_a (ch0_lpddr4_trip1_cke_a),
    .ch0_lpddr4_trip1_cke_b (ch0_lpddr4_trip1_cke_b),
    .ch0_lpddr4_trip1_cs_a (ch0_lpddr4_trip1_cs_a),
    .ch0_lpddr4_trip1_cs_b (ch0_lpddr4_trip1_cs_b),
    .ch0_lpddr4_trip1_dmi_a (ch0_lpddr4_trip1_dmi_a),
    .ch0_lpddr4_trip1_dmi_b (ch0_lpddr4_trip1_dmi_b),
    .ch0_lpddr4_trip1_dq_a (ch0_lpddr4_trip1_dq_a),
    .ch0_lpddr4_trip1_dq_b (ch0_lpddr4_trip1_dq_b),
    .ch0_lpddr4_trip1_dqs_c_a (ch0_lpddr4_trip1_dqs_c_a),
    .ch0_lpddr4_trip1_dqs_c_b (ch0_lpddr4_trip1_dqs_c_b),
    .ch0_lpddr4_trip1_dqs_t_a (ch0_lpddr4_trip1_dqs_t_a),
    .ch0_lpddr4_trip1_dqs_t_b (ch0_lpddr4_trip1_dqs_t_b),
    .ch0_lpddr4_trip1_reset_n (ch0_lpddr4_trip1_reset_n),
    .ch1_lpddr4_trip1_ca_a (ch1_lpddr4_trip1_ca_a),
    .ch1_lpddr4_trip1_ca_b (ch1_lpddr4_trip1_ca_b),
    .ch1_lpddr4_trip1_ck_c_a (ch1_lpddr4_trip1_ck_c_a),
    .ch1_lpddr4_trip1_ck_c_b (ch1_lpddr4_trip1_ck_c_b),
    .ch1_lpddr4_trip1_ck_t_a (ch1_lpddr4_trip1_ck_t_a),
    .ch1_lpddr4_trip1_ck_t_b (ch1_lpddr4_trip1_ck_t_b),
    .ch1_lpddr4_trip1_cke_a (ch1_lpddr4_trip1_cke_a),
    .ch1_lpddr4_trip1_cke_b (ch1_lpddr4_trip1_cke_b),
    .ch1_lpddr4_trip1_cs_a (ch1_lpddr4_trip1_cs_a),
    .ch1_lpddr4_trip1_cs_b (ch1_lpddr4_trip1_cs_b),
    .ch1_lpddr4_trip1_dmi_a (ch1_lpddr4_trip1_dmi_a),
    .ch1_lpddr4_trip1_dmi_b (ch1_lpddr4_trip1_dmi_b),
    .ch1_lpddr4_trip1_dq_a (ch1_lpddr4_trip1_dq_a),
    .ch1_lpddr4_trip1_dq_b (ch1_lpddr4_trip1_dq_b),
    .ch1_lpddr4_trip1_dqs_c_a (ch1_lpddr4_trip1_dqs_c_a),
    .ch1_lpddr4_trip1_dqs_c_b (ch1_lpddr4_trip1_dqs_c_b),
    .ch1_lpddr4_trip1_dqs_t_a (ch1_lpddr4_trip1_dqs_t_a),
    .ch1_lpddr4_trip1_dqs_t_b (ch1_lpddr4_trip1_dqs_t_b),
    .ch1_lpddr4_trip1_reset_n (ch1_lpddr4_trip1_reset_n),
    .spi0_csn  (spi_csn),
    .spi0_miso (spi_sdo),
    .spi0_mosi (spi_sdio),
    .spi0_sclk (spi_clk),

    .apollo_spi_clk_i (apollo_spi_clk),
    .apollo_spi_clk_o (apollo_spi_clk),
    .apollo_spi_csn_i (apollo_spi_csn),
    .apollo_spi_csn_o (apollo_spi_csn),
    .apollo_spi_sdi_i (apollo_spi_sdo),
    .apollo_spi_sdo_i (apollo_spi_sdio),
    .apollo_spi_sdo_o (apollo_spi_sdio),

    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio2_i (gpio_i[95:64]),
    .gpio2_o (gpio_o[95:64]),
    .gpio2_t (gpio_t[95:64]),

    // FMC HPC
    // Apollo A-side
    .tx_0_p (tx_data_p_loc[3:0]),
    .tx_0_n (tx_data_n_loc[3:0]),
    .rx_0_p (rx_data_p_loc[3:0]),
    .rx_0_n (rx_data_n_loc[3:0]),
    // Apollo B-Side
    .tx_1_p (tx_data_p_loc[7:4]),
    .tx_1_n (tx_data_n_loc[7:4]),
    .rx_1_p (rx_data_p_loc[7:4]),
    .rx_1_n (rx_data_n_loc[7:4]),

    .gt_powergood (gt_powergood),
    .gt_reset (gt_reset & gt_powergood),
    .gt_reset_rx_datapath (rx_reset_datapath),
    .gt_reset_tx_datapath (tx_reset_datapath),
    .gt_reset_rx_pll_and_datapath (rx_reset_pll_and_datapath),
    .gt_reset_tx_pll_and_datapath (tx_reset_pll_and_datapath),
    .rx_resetdone (rx_resetdone),
    .tx_resetdone (tx_resetdone),

    .gt_b_reset (gt_b_reset & gt_powergood),
    .gt_b_reset_rx_datapath (rx_b_reset_datapath),
    .gt_b_reset_tx_datapath (tx_b_reset_datapath),
    .gt_b_reset_rx_pll_and_datapath (rx_b_reset_pll_and_datapath),
    .gt_b_reset_tx_pll_and_datapath (tx_b_reset_pll_and_datapath),
    .rx_b_resetdone (rx_b_resetdone),
    .tx_b_resetdone (tx_b_resetdone),

    .ref_clk_a (ref_clk),
    .ref_clk_b (ref_clk),
    .rx_device_clk (rx_device_clk),
    .tx_device_clk (tx_device_clk),
    .rx_b_device_clk (rx_device_clk),
    .tx_b_device_clk (tx_device_clk),

    .data_in_p (hsci_do_p),
    .data_in_n (hsci_do_n),
    .clk_in_p (hsci_cko_p),
    .clk_in_n (hsci_cko_n),
    .data_out_p (hsci_din_p),
    .data_out_n (hsci_din_n),
    .clk_out_p (hsci_ckin_p),
    .clk_out_n (hsci_ckin_n),
    .intf_rdy (intf_rdy),
    .fifo_empty (fifo_empty),
    .fifo_rd_en (fifo_rd_en),
    .hsci_data_out (hsci_data_out),
    .hsci_data_in (hsci_data_in),
    .data_from_fabric (data_from_fabric),
    .data_to_fabric (data_to_fabric),

    .rx_sync_0 (rx_syncout[0]),
    .tx_sync_0 (tx_syncin[0]),
    .rx_sync_12 (rx_syncout[1]),
    .tx_sync_12 (tx_syncin[1]),
    .rx_sysref_0 (sysref),
    .tx_sysref_0 (sysref),
    .rx_sysref_12 (sysref),
    .tx_sysref_12 (sysref)
  );

  assign rx_data_p_loc = stx_p;
  assign rx_data_n_loc = stx_n;
  assign srx_p         = tx_data_p_loc;
  assign srx_n         = tx_data_n_loc;

endmodule
