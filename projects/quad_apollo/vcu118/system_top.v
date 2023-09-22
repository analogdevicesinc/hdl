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

  input         sys_rst,
  input         sys_clk_p,
  input         sys_clk_n,

  input         uart_sin,
  output        uart_sout,

  output        ddr4_act_n,
  output [16:0] ddr4_addr,
  output [ 1:0] ddr4_ba,
  output [ 0:0] ddr4_bg,
  output        ddr4_ck_p,
  output        ddr4_ck_n,
  output [ 0:0] ddr4_cke,
  output [ 0:0] ddr4_cs_n,
  inout  [ 7:0] ddr4_dm_n,
  inout  [63:0] ddr4_dq,
  inout  [ 7:0] ddr4_dqs_p,
  inout  [ 7:0] ddr4_dqs_n,
  output [ 0:0] ddr4_odt,
  output        ddr4_reset_n,

  output        mdio_mdc,
  inout         mdio_mdio,
  input         phy_clk_p,
  input         phy_clk_n,
  output        phy_rst_n,
  input         phy_rx_p,
  input         phy_rx_n,
  output        phy_tx_p,
  output        phy_tx_n,

  inout  [16:0] gpio_bd,

  output        iic_rstn,
  inout         iic_scl,
  inout         iic_sda,

  input         vadj_1v8_pgood,

  // FMCp IOs
  input  [15:0] m2c_p, 
  input  [15:0] m2c_n,
  output [15:0] c2m_p,
  output [15:0] c2m_n,

  input   [2:0] ref_clk_p,
  input   [2:0] ref_clk_n,
  input         ref_clk_replica_p,
  input         ref_clk_replica_n,
  
  input         sysref_m2c_p,
  input         sysref_m2c_n,

  output  [3:0] apollo_sclk,
  inout   [3:0] apollo_sdio,
  output  [3:0] apollo_csb,

  output        art_sclk,
  inout         art_sdio,
  output  [3:0] art_csb,

  output        ltc6953_sclk,  
  output        ltc6953_sdi, 
  input         ltc6953_sdo,  
  output  [1:0] ltc6953_csn,

  output  [3:0] hsci_ckin_p,
  output  [3:0] hsci_ckin_n,
  output  [3:0] hsci_din_p,
  output  [3:0] hsci_din_n,
  input   [3:0] hsci_cko_p,
  input   [3:0] hsci_cko_n,
  input   [3:0] hsci_do_p,
  input   [3:0] hsci_do_n,

  output  [3:0] trig0_a,
  output  [3:0] trig1_a,
  output  [3:0] trig0_b,
  output  [3:0] trig1_b,

  output  [3:0] resetb,
  output  [1:0] txen,
  output  [1:0] rxen,
  input   [3:0] irqa,
  input   [3:0] irqb,
  output  [1:0] txrxn,
  output  [2:0] slice,
  output        txrxwe,
  output  [2:0] fcnsel,
  output  [4:0] profile,
  
  output  [3:0] hpf_b,
  output  [3:0] lpf_b,
  output        admv8913_cs_n,

  output  [5:0] rx_dsa,

  inout   [3:0] gp4,
  inout   [3:0] gp5,

  // PMOD1 for calibration board
  output pmod1_adc_sync_n,
  output pmod1_adc_sdi,
  input  pmod1_adc_sdo,
  output pmod1_adc_sclk,

  output pmod1_5045_v2,
  output pmod1_5045_v1,
  output pmod1_ctrl_ind,
  output pmod1_ctrl_rx_combined
);

  // internal signals

  wire    [127:0] gpio_i;
  wire    [127:0] gpio_o;
  wire    [127:0] gpio_t;

  wire            spi_clk;
  wire    [ 7:0]  spi_csn;
  wire            spi_mosi;
  wire            spi_miso;
  wire    [ 3:0]  apollo_miso;

  wire            spi_2_clk;
  wire    [ 7:0]  spi_2_csn;
  wire            spi_2_mosi;
  wire            spi_2_miso;
  wire            art_miso;

  wire            spi_3_clk;
  wire    [ 7:0]  spi_3_csn;
  wire            spi_3_mosi;
  wire            spi_3_miso;

  wire            ref_clk;
  wire            ref_clk_replica;
  wire            sysref;
  wire    [3:0]   link0_tx_syncin;
  wire    [3:0]   link0_rx_syncout;

  wire            clkin0;
  wire            clkin1;
  wire            rx_device_clk;
  wire            tx_device_clk;

  wire            pll_inclk;
  wire    [ 0:1]  hsci_pll_reset;
  wire    [ 0:1]  hsci_pclk;
  wire    [ 0:1]  hsci_pll_locked;
  wire    [ 0:3]  hsci_vtc_rdy_bsc_tx;
  wire    [ 0:3]  hsci_dly_rdy_bsc_tx;
  wire    [ 0:3]  hsci_vtc_rdy_bsc_rx;
  wire    [ 0:3]  hsci_dly_rdy_bsc_rx;
  wire    [ 0:1]  hsci_rst_seq_done;

  wire            selectio_clk_in;
  wire    [ 7:0]  hsci_data_in  [0:3];
  wire    [ 7:0]  hsci_data_out [0:3];

  wire            trig_rstn;
  wire            trig;

  assign iic_rstn = 1'b1;

  // instantiations

  IBUFDS_GTE4 i_ibufds_ref_clk (
    .CEB (1'd0),
    .I (ref_clk_p[0]),
    .IB (ref_clk_n[0]),
    .O (ref_clk),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_ref_clk_replica (
    .CEB (1'd0),
    .I (ref_clk_replica_p),
    .IB (ref_clk_replica_n),
    .O (ref_clk_replica),
    .ODIV2 ());

  IBUFDS i_ibufds_sysref (
    .I (sysref_m2c_p),
    .IB (sysref_m2c_n),
    .O (sysref));

  IBUFDS_GTE4 i_ibufds_tx_device_clk (
    .I (ref_clk_p[1]),
    .IB (ref_clk_n[1]),
    .CEB(1'b0),
    .ODIV2 (clkin0));

  IBUFDS i_ibufds_rx_device_clk (
    .I (ref_clk_p[2]),
    .IB (ref_clk_n[2]),
    .O (clkin1));

  BUFG_GT i_tx_device_clk (
    .I (clkin0),
    .O (tx_device_clk));

  BUFG i_rx_device_clk (
    .I (clkin1),
    .O (rx_device_clk));

  BUFG i_selectio_clk_in(
    .I (selectio_clk_in),
    .O (pll_inclk));

  // spi

  assign apollo_csb = spi_csn[3:0];
  assign apollo_sclk = {4{spi_clk}};

  assign art_csb = spi_2_csn[3:0];
  assign art_sclk = spi_2_clk;

  assign ltc6953_csn = spi_2_csn[5:4];
  assign ltc6953_sclk = spi_2_clk;
  assign ltc6953_sdi = spi_2_mosi;

  assign pmod1_adc_sync_n = spi_3_csn[0];
  assign pmod1_adc_sdi = spi_3_mosi;
  assign pmod1_adc_sclk = spi_3_clk;

  assign spi_miso = ~spi_csn[0] ? apollo_miso[0] :
                    ~spi_csn[1] ? apollo_miso[1] :
                    ~spi_csn[2] ? apollo_miso[2] :
                    ~spi_csn[3] ? apollo_miso[3] : 1'b0;

  assign spi_2_miso =  |(~spi_2_csn[3:0]) ? art_miso :
                       |(~spi_2_csn[5:4]) ? ltc6953_sdo : 1'b0;

  assign spi_3_miso =  ~pmod1_adc_sync_n ? pmod1_adc_sdo : 1'b0;

  genvar i;
  generate
  for (i=0;i<4;i=i+1) begin : apollo_spi_3w
    ad_3w_spi #(
      .NUM_OF_SLAVES(1)
    ) i_spi_apollo (
      .spi_csn  (spi_csn[i]),
      .spi_clk  (spi_clk),
      .spi_mosi (spi_mosi),
      .spi_miso (apollo_miso[i]),
      .spi_sdio (apollo_sdio[i]),
      .spi_dir  ());
  end
  endgenerate

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_spi_art (
    .spi_csn (&spi_2_csn[3:0]),
    .spi_clk (spi_2_clk),
    .spi_mosi (spi_2_mosi),
    .spi_miso (art_miso),
    .spi_sdio (art_sdio),
    .spi_dir ());

  // gpios

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_iobuf (
    .dio_t (gpio_t[39:32]),
    .dio_i (gpio_o[39:32]),
    .dio_o (gpio_i[39:32]),
    .dio_p ({gp5[3:0],       // 39-36 
             gp4[3:0]}));    // 35-32

  assign gpio_i[43:40] = irqa;
  assign gpio_i[47:44] = irqb;

  assign trig0_a       = {4{trig}};
  assign trig1_a       = {4{trig}};
  assign trig0_b       = {4{trig}};
  assign trig1_b       = {4{trig}};
  assign resetb        = gpio_o[67:64];
  assign txen          = gpio_o[69:68];
  assign rxen          = gpio_o[71:70];
  assign txrxn         = gpio_o[73:72];
  assign slice         = gpio_o[76:74];
  assign txrxwe        = gpio_o[77];
  assign fcnsel        = gpio_o[80:78];
  assign profile       = gpio_o[85:81];
  assign hpf_b         = gpio_o[89:86];
  assign lpf_b         = gpio_o[93:90];
  assign admv8913_cs_n = gpio_o[94];
  assign rx_dsa        = gpio_o[100:95];
  assign pmod1_5045_v2 = gpio_o[101];
  assign pmod1_5045_v1 = gpio_o[102];
  assign pmod1_ctrl_ind = gpio_o[103];
  assign pmod1_ctrl_rx_combined = gpio_o[104];

  ad_iobuf #(
    .DATA_WIDTH(17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[127:105] = gpio_o[127:105];
  assign gpio_i[ 31:17] = gpio_o[ 31:17];

  trigger_generator trig_i (
    .sysref     (sysref),
    .device_clk (rx_device_clk),
    .gpio       (gp4[0]),
    .rstn       (trig_rstn),
    .trigger    (trig)
  );

  hsci_phy_top hsci_phy_top(
    .pll_inclk        (pll_inclk),
    .hsci_pll_reset   (hsci_pll_reset),

    .hsci_pclk        (hsci_pclk),
    .hsci_mosi_d_p    (hsci_din_p),
    .hsci_mosi_d_n    (hsci_din_n),

    .hsci_miso_d_p    (hsci_do_p),
    .hsci_miso_d_n    (hsci_do_n),

    .hsci_pll_locked  (hsci_pll_locked),

    .hsci_mosi_clk_p  (hsci_ckin_p),
    .hsci_mosi_clk_n  (hsci_ckin_n),

    .hsci_miso_clk_p  (hsci_cko_p),
    .hsci_miso_clk_n  (hsci_cko_n),

    .hsci_mosi_data_0 (hsci_data_out[0]),
    .hsci_mosi_data_1 (hsci_data_out[1]),
    .hsci_mosi_data_2 (hsci_data_out[2]),
    .hsci_mosi_data_3 (hsci_data_out[3]),

    .hsci_miso_data_0 (hsci_data_in[0]),
    .hsci_miso_data_1 (hsci_data_in[1]),
    .hsci_miso_data_2 (hsci_data_in[2]),
    .hsci_miso_data_3 (hsci_data_in[3]),

    .vtc_rdy_bsc_tx   (hsci_vtc_rdy_bsc_tx),
    .dly_rdy_bsc_tx   (hsci_dly_rdy_bsc_tx),
    .vtc_rdy_bsc_rx   (hsci_vtc_rdy_bsc_rx),
    .dly_rdy_bsc_rx   (hsci_dly_rdy_bsc_rx),
    .rst_seq_done     (hsci_rst_seq_done)
  );

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
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),

    .spi_2_clk_i (spi_2_clk),
    .spi_2_clk_o (spi_2_clk),
    .spi_2_csn_i (spi_2_csn),
    .spi_2_csn_o (spi_2_csn),
    .spi_2_sdi_i (spi_2_miso),
    .spi_2_sdo_i (spi_2_mosi),
    .spi_2_sdo_o (spi_2_mosi),

    .spi_3_clk_i (spi_3_clk),
    .spi_3_clk_o (spi_3_clk),
    .spi_3_csn_i (spi_3_csn),
    .spi_3_csn_o (spi_3_csn),
    .spi_3_sdi_i (spi_3_miso),
    .spi_3_sdo_i (spi_3_mosi),
    .spi_3_sdo_o (spi_3_mosi),

    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    
    .gpio2_i (gpio_i[95:64]),
    .gpio2_o (gpio_o[95:64]),
    .gpio2_t (gpio_t[95:64]),
    .gpio3_i (gpio_i[127:96]),
    .gpio3_o (gpio_o[127:96]),
    .gpio3_t (gpio_t[127:96]),
    // FMCp
    // quad 121
    .rx_data_0_n (m2c_n[0]),
    .rx_data_0_p (m2c_p[0]),
    .rx_data_1_n (m2c_n[1]),
    .rx_data_1_p (m2c_p[1]),
    .rx_data_2_n (m2c_n[2]),
    .rx_data_2_p (m2c_p[2]),
    .rx_data_3_n (m2c_n[3]),
    .rx_data_3_p (m2c_p[3]),
    // quad 126
    .rx_data_4_n (m2c_n[4]),
    .rx_data_4_p (m2c_p[4]),
    .rx_data_5_n (m2c_n[5]),
    .rx_data_5_p (m2c_p[5]),
    .rx_data_6_n (m2c_n[6]),
    .rx_data_6_p (m2c_p[6]),
    .rx_data_7_n (m2c_n[7]),
    .rx_data_7_p (m2c_p[7]),
    // quad 122
    .rx_data_8_n (m2c_n[8]),
    .rx_data_8_p (m2c_p[8]),
    .rx_data_9_n (m2c_n[9]),
    .rx_data_9_p (m2c_p[9]),
    .rx_data_10_n (m2c_n[10]),
    .rx_data_10_p (m2c_p[10]),
    .rx_data_11_n (m2c_n[11]),
    .rx_data_11_p (m2c_p[11]),
    // quad 125
    .rx_data_12_n (m2c_n[12]),
    .rx_data_12_p (m2c_p[12]),
    .rx_data_13_n (m2c_n[13]),
    .rx_data_13_p (m2c_p[13]),
    .rx_data_14_n (m2c_n[14]),
    .rx_data_14_p (m2c_p[14]),
    .rx_data_15_n (m2c_n[15]),
    .rx_data_15_p (m2c_p[15]),
    // quad 121
    .tx_data_0_n (c2m_n[0]),
    .tx_data_0_p (c2m_p[0]),
    .tx_data_1_n (c2m_n[1]),
    .tx_data_1_p (c2m_p[1]),
    .tx_data_2_n (c2m_n[2]),
    .tx_data_2_p (c2m_p[2]),
    .tx_data_3_n (c2m_n[3]),
    .tx_data_3_p (c2m_p[3]),
    // quad 126
    .tx_data_4_n (c2m_n[4]),
    .tx_data_4_p (c2m_p[4]),
    .tx_data_5_n (c2m_n[5]),
    .tx_data_5_p (c2m_p[5]),
    .tx_data_6_n (c2m_n[6]),
    .tx_data_6_p (c2m_p[6]),
    .tx_data_7_n (c2m_n[7]),
    .tx_data_7_p (c2m_p[7]),
    // quad 122
    .tx_data_8_n (c2m_n[8]),
    .tx_data_8_p (c2m_p[8]),
    .tx_data_9_n (c2m_n[9]),
    .tx_data_9_p (c2m_p[9]),
    .tx_data_10_n (c2m_n[10]),
    .tx_data_10_p (c2m_p[10]),
    .tx_data_11_n (c2m_n[11]),
    .tx_data_11_p (c2m_p[11]),
    // quad 125
    .tx_data_12_n (c2m_n[12]),
    .tx_data_12_p (c2m_p[12]),
    .tx_data_13_n (c2m_n[13]),
    .tx_data_13_p (c2m_p[13]),
    .tx_data_14_n (c2m_n[14]),
    .tx_data_14_p (c2m_p[14]),
    .tx_data_15_n (c2m_n[15]),
    .tx_data_15_p (c2m_p[15]),

    .rx_device_clk_rstn(trig_rstn),

    .selectio_clk_in (selectio_clk_in),

    .hsci_data_out_0       (hsci_data_out[0]),
    .hsci_data_out_1       (hsci_data_out[1]),
    .hsci_data_out_2       (hsci_data_out[2]),
    .hsci_data_out_3       (hsci_data_out[3]),
    .hsci_data_in_0        (hsci_data_in[0]),
    .hsci_data_in_1        (hsci_data_in[1]),
    .hsci_data_in_2        (hsci_data_in[2]),
    .hsci_data_in_3        (hsci_data_in[3]),
    .hsci_pclk_0           (hsci_pclk[0]),
    .hsci_pclk_1           (hsci_pclk[1]),
    .hsci_pll_reset_0      (hsci_pll_reset[0]),
    .hsci_pll_reset_1      (hsci_pll_reset[1]),
    .hsci_rst_seq_done_0   (hsci_rst_seq_done[0]),
    .hsci_rst_seq_done_1   (hsci_rst_seq_done[1]),
    .hsci_pll_locked_0     (hsci_pll_locked[0]),
    .hsci_pll_locked_1     (hsci_pll_locked[1]),
    .hsci_vtc_rdy_bsc_tx_0 (hsci_vtc_rdy_bsc_tx[0]),
    .hsci_vtc_rdy_bsc_tx_1 (hsci_vtc_rdy_bsc_tx[1]),
    .hsci_vtc_rdy_bsc_tx_2 (hsci_vtc_rdy_bsc_tx[2]),
    .hsci_vtc_rdy_bsc_tx_3 (hsci_vtc_rdy_bsc_tx[3]),
    .hsci_dly_rdy_bsc_tx_0 (hsci_dly_rdy_bsc_tx[0]),
    .hsci_dly_rdy_bsc_tx_1 (hsci_dly_rdy_bsc_tx[1]),
    .hsci_dly_rdy_bsc_tx_2 (hsci_dly_rdy_bsc_tx[2]),
    .hsci_dly_rdy_bsc_tx_3 (hsci_dly_rdy_bsc_tx[3]),
    .hsci_vtc_rdy_bsc_rx_0 (hsci_vtc_rdy_bsc_rx[0]),
    .hsci_vtc_rdy_bsc_rx_1 (hsci_vtc_rdy_bsc_rx[1]),
    .hsci_vtc_rdy_bsc_rx_2 (hsci_vtc_rdy_bsc_rx[2]),
    .hsci_vtc_rdy_bsc_rx_3 (hsci_vtc_rdy_bsc_rx[3]),
    .hsci_dly_rdy_bsc_rx_0 (hsci_dly_rdy_bsc_rx[0]),
    .hsci_dly_rdy_bsc_rx_1 (hsci_dly_rdy_bsc_rx[1]),
    .hsci_dly_rdy_bsc_rx_2 (hsci_dly_rdy_bsc_rx[2]),
    .hsci_dly_rdy_bsc_rx_3 (hsci_dly_rdy_bsc_rx[3]),

    .ref_clk_q0 (ref_clk),
    .ref_clk_q1 (ref_clk_replica),
    .ref_clk_q2 (ref_clk),
    .ref_clk_q3 (ref_clk_replica),
    .rx_device_clk (rx_device_clk),
    .tx_device_clk (tx_device_clk),
    // .rx_sync_0 (),
    // .tx_sync_0 (),
    .rx_sysref_0 (sysref),
    .tx_sysref_0 (sysref));

endmodule

