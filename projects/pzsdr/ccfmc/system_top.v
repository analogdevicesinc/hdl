// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  ddr_addr,
  ddr_ba,
  ddr_cas_n,
  ddr_ck_n,
  ddr_ck_p,
  ddr_cke,
  ddr_cs_n,
  ddr_dm,
  ddr_dq,
  ddr_dqs_n,
  ddr_dqs_p,
  ddr_odt,
  ddr_ras_n,
  ddr_reset_n,
  ddr_we_n,

  eth1_mdc,
  eth1_mdio,
  eth1_rgmii_rxclk,
  eth1_rgmii_rxctl,
  eth1_rgmii_rxdata,
  eth1_rgmii_txclk,
  eth1_rgmii_txctl,
  eth1_rgmii_txdata,

  fixed_io_ddr_vrn,
  fixed_io_ddr_vrp,
  fixed_io_mio,
  fixed_io_ps_clk,
  fixed_io_ps_porb,
  fixed_io_ps_srstb,

  hdmi_out_clk,
  hdmi_vsync,
  hdmi_hsync,
  hdmi_data_e,
  hdmi_data,
  hdmi_pd,
  hdmi_intn,

  spdif,
  spdif_in,

  i2s_mclk,
  i2s_bclk,
  i2s_lrclk,
  i2s_sdata_out,
  i2s_sdata_in,

  iic_scl,
  iic_sda,

  gpio_bd,

  fmc_prstn,
  fmc_clk0_p,
  fmc_clk0_n,
  fmc_clk1_p,
  fmc_clk1_n,
  fmc_la_p,
  fmc_la_n,
  pmod0,
  cam_gpio,
  sfp_gpio,

  fmc_gt_ref_clk_p,
  fmc_gt_ref_clk_n,
  fmc_gt_tx_p,
  fmc_gt_tx_n,
  fmc_gt_rx_p,
  fmc_gt_rx_n,
  ad9517_gt_ref_clk_p,
  ad9517_gt_ref_clk_n,
  sfp_gt_tx_p,
  sfp_gt_tx_n,
  sfp_gt_rx_p,
  sfp_gt_rx_n,

  ad9517_csn,
  ad9517_clk,
  ad9517_mosi,
  ad9517_miso,
  ad9517_pdn,
  ad9517_ref_sel,
  ad9517_ld,
  ad9517_status,

  rx_clk_in_p,
  rx_clk_in_n,
  rx_frame_in_p,
  rx_frame_in_n,
  rx_data_in_p,
  rx_data_in_n,
  tx_clk_out_p,
  tx_clk_out_n,
  tx_frame_out_p,
  tx_frame_out_n,
  tx_data_out_p,
  tx_data_out_n,

  enable,
  txnrx,

  gpio_rf0,
  gpio_rf1,
  gpio_rf2,
  gpio_rf3,
  gpio_rfpwr_enable,
  gpio_clksel,
  gpio_resetb,
  gpio_sync,
  gpio_en_agc,
  gpio_ctl,
  gpio_status,

  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso);


  inout   [14:0]  ddr_addr;
  inout   [ 2:0]  ddr_ba;
  inout           ddr_cas_n;
  inout           ddr_ck_n;
  inout           ddr_ck_p;
  inout           ddr_cke;
  inout           ddr_cs_n;
  inout   [ 3:0]  ddr_dm;
  inout   [31:0]  ddr_dq;
  inout   [ 3:0]  ddr_dqs_n;
  inout   [ 3:0]  ddr_dqs_p;
  inout           ddr_odt;
  inout           ddr_ras_n;
  inout           ddr_reset_n;
  inout           ddr_we_n;

  output          eth1_mdc;
  inout           eth1_mdio;
  input           eth1_rgmii_rxclk;
  input           eth1_rgmii_rxctl;
  input   [ 3:0]  eth1_rgmii_rxdata;
  output          eth1_rgmii_txclk;
  output          eth1_rgmii_txctl;
  output  [ 3:0]  eth1_rgmii_txdata;

  inout           fixed_io_ddr_vrn;
  inout           fixed_io_ddr_vrp;
  inout   [53:0]  fixed_io_mio;
  inout           fixed_io_ps_clk;
  inout           fixed_io_ps_porb;
  inout           fixed_io_ps_srstb;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;
  output          hdmi_pd;
  input           hdmi_intn;

  output          spdif;
  input           spdif_in;

  output          i2s_mclk;
  output          i2s_bclk;
  output          i2s_lrclk;
  output          i2s_sdata_out;
  input           i2s_sdata_in;

  inout           iic_scl;
  inout           iic_sda;

  inout   [11:0]  gpio_bd;

  input           fmc_prstn;
  input           fmc_clk0_p;
  input           fmc_clk0_n;
  input           fmc_clk1_p;
  input           fmc_clk1_n;
  inout   [33:0]  fmc_la_p;
  inout   [33:0]  fmc_la_n;
  inout   [ 7:0]  pmod0;
  input   [33:0]  cam_gpio;
  input   [ 6:0]  sfp_gpio;

  input           fmc_gt_ref_clk_p;
  input           fmc_gt_ref_clk_n;
  output          fmc_gt_tx_p;
  output          fmc_gt_tx_n;
  input           fmc_gt_rx_p;
  input           fmc_gt_rx_n;
  input           ad9517_gt_ref_clk_p;
  input           ad9517_gt_ref_clk_n;
  output          sfp_gt_tx_p;
  output          sfp_gt_tx_n;
  input           sfp_gt_rx_p;
  input           sfp_gt_rx_n;

  output          ad9517_csn;
  output          ad9517_clk;
  output          ad9517_mosi;
  input           ad9517_miso;
  inout           ad9517_pdn;
  inout           ad9517_ref_sel;
  inout           ad9517_ld;
  inout           ad9517_status;

  input           rx_clk_in_p;
  input           rx_clk_in_n;
  input           rx_frame_in_p;
  input           rx_frame_in_n;
  input   [ 5:0]  rx_data_in_p;
  input   [ 5:0]  rx_data_in_n;
  output          tx_clk_out_p;
  output          tx_clk_out_n;
  output          tx_frame_out_p;
  output          tx_frame_out_n;
  output  [ 5:0]  tx_data_out_p;
  output  [ 5:0]  tx_data_out_n;

  output          enable;
  output          txnrx;

  inout           gpio_rf0;
  inout           gpio_rf1;
  inout           gpio_rf2;
  inout           gpio_rf3;
  inout           gpio_rfpwr_enable;
  inout           gpio_clksel;
  inout           gpio_resetb;
  inout           gpio_sync;
  inout           gpio_en_agc;
  inout   [ 3:0]  gpio_ctl;
  inout   [ 7:0]  gpio_status;

  output          spi_csn;
  output          spi_clk;
  output          spi_mosi;
  input           spi_miso;


  // internal signals

  wire    [ 1:0]  spi_csn_s;
  wire            spi_clk_s;
  wire            spi_mosi_s;
  wire            spi_miso_s;
  wire            fmc_clk0_s;
  wire            fmc_clk0;
  wire    [31:0]  up_clk0_count;
  wire            fmc_clk1_s;
  wire            fmc_clk1;
  wire    [31:0]  up_clk1_count;
  wire            fmc_gt_ref_clk;
  wire            ad9517_gt_ref_clk;
  wire    [31:0]  gpio_0_0_i;
  wire    [31:0]  gpio_0_0_o;
  wire    [31:0]  gpio_0_0_t;
  wire    [31:0]  gpio_0_1_i;
  wire    [31:0]  gpio_0_1_o;
  wire    [31:0]  gpio_0_1_t;
  wire    [31:0]  gpio_1_0_i;
  wire    [31:0]  gpio_1_0_o;
  wire    [31:0]  gpio_1_0_t;
  wire    [31:0]  gpio_1_1_i;
  wire    [31:0]  gpio_1_1_o;
  wire    [31:0]  gpio_1_1_t;
  wire    [31:0]  gpio_3_1_o;
  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire            tdd_sync_i;
  wire            tdd_sync_o;
  wire            tdd_sync_t;

  // assignments

  assign hdmi_pd = 1'b0;
  assign spi_csn = spi_csn_s[0];
  assign spi_clk = spi_clk_s;
  assign spi_mosi = spi_mosi_s;
  assign ad9517_csn = spi_csn_s[1];
  assign ad9517_clk = spi_clk_s;
  assign ad9517_mosi = spi_mosi_s;
  assign spi_miso_s = (~spi_csn_s[0] & spi_miso) | (~spi_csn_s[1] & ad9517_miso); 

  // instantiations

  IBUFDS i_ibufds_clk0 (
    .I (fmc_clk0_p),
    .IB (fmc_clk0_n),
    .O (fmc_clk0_s));

  BUFG i_bufg_clk0 (
    .I (fmc_clk0_s),
    .O (fmc_clk0));

  up_clock_mon i_clk0_mon (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_d_count (up_clk0_count),
    .d_rst (up_rst),
    .d_clk (fmc_clk0));

  IBUFDS i_ibufds_clk1 (
    .I (fmc_clk1_p),
    .IB (fmc_clk1_n),
    .O (fmc_clk1_s));

  BUFG i_bufg_clk1 (
    .I (fmc_clk1_s),
    .O (fmc_clk1));

  up_clock_mon i_clk1_mon (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_d_count (up_clk1_count),
    .d_rst (up_rst),
    .d_clk (fmc_clk1));

  IBUFDS_GTE2 i_ibufds_ref_clk_0 (
    .CEB (1'd0),
    .I (fmc_gt_ref_clk_p),
    .IB (fmc_gt_ref_clk_n),
    .O (fmc_gt_ref_clk),
    .ODIV2 ());

  IBUFDS_GTE2 i_ibufds_ref_clk_1 (
    .CEB (1'd0),
    .I (ad9517_gt_ref_clk_p),
    .IB (ad9517_gt_ref_clk_n),
    .O (ad9517_gt_ref_clk),
    .ODIV2 ());

  assign gpio_0_1_i[31:27] = 'd0;
  assign gpio_1_1_i[31:26] = 'd0;
  assign up_pn_err_clr = gpio_3_1_o[1];
  assign up_pn_oos_clr = gpio_3_1_o[0];
  assign gpio_tdd_sync_t = (gpio_3_1_o[4] == 1'b1) ? gpio_1_1_t[2] : tdd_sync_t;
  assign gpio_tdd_sync_o = (gpio_3_1_o[4] == 1'b1) ? gpio_1_1_o[2] : tdd_sync_o;
  assign tdd_sync_i = (gpio_3_1_o[4] == 1'b0) ? gpio_tdd_sync_i : 1'b0;
  assign gpio_1_1_i[2] = (gpio_3_1_o[4] == 1'b1) ? gpio_tdd_sync_i : 1'b0;

  ad_iobuf #(.DATA_WIDTH(59)) i_iobuf_pmod0_fmc_p (
    .dio_t ({gpio_0_1_t[26:0], gpio_0_0_t[31:0]}),
    .dio_i ({gpio_0_1_o[26:0], gpio_0_0_o[31:0]}),
    .dio_o ({gpio_0_1_i[26:0], gpio_0_0_i[31:0]}),
    .dio_p ({ sfp_gpio[3:0],
              cam_gpio[16:0],
              pmod0[3],
              pmod0[2],
              pmod0[1],
              pmod0[0],
              fmc_la_n[16:0],
              fmc_la_p[16:0]}));

  ad_iobuf #(.DATA_WIDTH(58)) i_iobuf_pmod1_fmc_n (
    .dio_t ({gpio_1_1_t[25:3], gpio_tdd_sync_t, gpio_1_1_t[1:0], gpio_1_0_t[31:0]}),
    .dio_i ({gpio_1_1_o[25:3], gpio_tdd_sync_o, gpio_1_1_o[1:0], gpio_1_0_o[31:0]}),
    .dio_o ({gpio_1_1_i[25:3], gpio_tdd_sync_i, gpio_1_1_i[1:0], gpio_1_0_i[31:0]}),
    .dio_p ({ sfp_gpio[6:4],
              cam_gpio[33:17],
              pmod0[7],
              pmod0[6],
              pmod0[5],
              pmod0[4],
              fmc_la_n[33:17],
              fmc_la_p[33:17]}));


  ad_iobuf #(.DATA_WIDTH(25)) i_iobuf (
    .dio_t ({gpio_t[60:51], gpio_t[46:32]}),
    .dio_i ({gpio_o[60:51], gpio_o[46:32]}),
    .dio_o ({gpio_i[60:51], gpio_i[46:32]}),
    .dio_p ({ ad9517_pdn,         // 60:60
              ad9517_ref_sel,     // 59:59
              ad9517_ld,          // 58:58
              ad9517_status,      // 57:57
              gpio_rf0,           // 56:56
              gpio_rf1,           // 55:55
              gpio_rf2,           // 54:54
              gpio_rf3,           // 53:53
              gpio_rfpwr_enable,  // 52:52
              gpio_clksel,        // 51:51
              gpio_resetb,        // 46:46
              gpio_sync,          // 45:45
              gpio_en_agc,        // 44:44
              gpio_ctl,           // 43:40
              gpio_status}));     // 39:32

  ad_iobuf #(.DATA_WIDTH(12)) i_iobuf_bd (
    .dio_t (gpio_t[11:0]),
    .dio_i (gpio_o[11:0]),
    .dio_o (gpio_i[11:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
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
    .eth1_125mclk (),
    .eth1_25mclk (),
    .eth1_2m5clk (),
    .eth1_clock_speed (),
    .eth1_duplex_status (),
    .eth1_intn (1'b1),
    .eth1_link_status (),
    .eth1_mdio_mdc (eth1_mdc),
    .eth1_mdio_mdio_io (eth1_mdio),
    .eth1_refclk (),
    .eth1_rgmii_rd (eth1_rgmii_rxdata),
    .eth1_rgmii_rx_ctl (eth1_rgmii_rxctl),
    .eth1_rgmii_rxc (eth1_rgmii_rxclk),
    .eth1_rgmii_td (eth1_rgmii_txdata),
    .eth1_rgmii_tx_ctl (eth1_rgmii_txctl),
    .eth1_rgmii_txc (eth1_rgmii_txclk),
    .eth1_speed_mode (),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .fmc_gt_ref_clk0 (fmc_gt_ref_clk),
    .fmc_gt_ref_clk1 (ad9517_gt_ref_clk),
    .fmc_gt_rx_n (fmc_gt_rx_n),
    .fmc_gt_rx_p (fmc_gt_rx_p),
    .fmc_gt_tx_n (fmc_gt_tx_n),
    .fmc_gt_tx_p (fmc_gt_tx_p),
    .gpio_0_0_i (gpio_0_0_i),
    .gpio_0_0_o (gpio_0_0_o),
    .gpio_0_0_t (gpio_0_0_t),
    .gpio_0_1_i (gpio_0_1_i),
    .gpio_0_1_o (gpio_0_1_o),
    .gpio_0_1_t (gpio_0_1_t),
    .gpio_1_0_i (gpio_1_0_i),
    .gpio_1_0_o (gpio_1_0_o),
    .gpio_1_0_t (gpio_1_0_t),
    .gpio_1_1_i (gpio_1_1_i),
    .gpio_1_1_o (gpio_1_1_o),
    .gpio_1_1_t (gpio_1_1_t),
    .gpio_2_0_i (up_clk0_count),
    .gpio_2_0_o (),
    .gpio_2_0_t (),
    .gpio_2_1_i (up_clk1_count),
    .gpio_2_1_o (),
    .gpio_2_1_t (),
    .gpio_3_0_i ({31'd0, fmc_prstn}),
    .gpio_3_0_o (),
    .gpio_3_0_t (),
    .gpio_3_1_i ({30'd0, up_pn_err, up_pn_oos}),
    .gpio_3_1_o (gpio_3_1_o),
    .gpio_3_1_t (),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
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
    .ps_intr_00 (1'b0),
    .ps_intr_01 (1'b0),
    .ps_intr_02 (1'b0),
    .ps_intr_03 (1'b0),
    .ps_intr_04 (1'b0),
    .ps_intr_05 (1'b0),
    .ps_intr_06 (1'b0),
    .ps_intr_07 (1'b0),
    .ps_intr_08 (1'b0),
    .ps_intr_09 (1'b0),
    .ps_intr_10 (1'b0),
    .ps_intr_11 (1'b0),
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

// ***************************************************************************
// ***************************************************************************
