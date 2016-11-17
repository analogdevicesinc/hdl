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
  output  [53:0]  gp_out,
  input   [53:0]  gp_in,

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
  inout           gpio_rf1,
  inout           gpio_rf2,
  inout           gpio_rf3,
  inout           gpio_rf4,
  inout           gpio_rfpwr_enable,
  inout           gpio_clksel,
  inout           gpio_resetb,
  inout           gpio_sync,
  inout           gpio_en_agc,
  inout   [ 3:0]  gpio_ctl,
  inout   [ 7:0]  gpio_status,

  output          spi_csn,
  output          spi_clk,
  output          spi_mosi,
  input           spi_miso);

  // internal signals

  wire    [ 1:0]  spi_csn_s;
  wire            spi_clk_s;
  wire            spi_mosi_s;
  wire            spi_miso_s;
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

  // loopback signals

  assign gp_out[53:0] = gp_out_s[53:0];
  assign gp_in_s[63:54] = gp_out_s[63:54];
  assign gp_in_s[53:0] = gp_in[53:0];

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

  ad_iobuf #(.DATA_WIDTH(1)) i_iobuf_tdd_sync (
    .dio_t (tdd_sync_t),
    .dio_i (tdd_sync_o),
    .dio_o (tdd_sync_i),
    .dio_p (tdd_sync));

  // board gpio - 31-0

  assign gpio_i[31:21] = gpio_o[31:21];

  ad_iobuf #(.DATA_WIDTH(21)) i_iobuf_bd (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p (gpio_bd));

  // ad9361 gpio - 63-32

  assign gpio_i[63:62] = gpio_o[63:62];
  assign gpio_i[50:47] = gpio_o[50:47];

  ad_iobuf #(.DATA_WIDTH(26)) i_iobuf (
    .dio_t ({gpio_t[61:51], gpio_t[46:32]}),
    .dio_i ({gpio_o[61:51], gpio_o[46:32]}),
    .dio_o ({gpio_i[61:51], gpio_i[46:32]}),
    .dio_p ({ gpio_rf4,           // 61:61
              ad9517_pdn,         // 60:60
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
    .gp_in_0 (gp_in_s[31:0]),
    .gp_in_1 (gp_in_s[63:32]),
    .gp_out_0 (gp_out_s[31:0]),
    .gp_out_1 (gp_out_s[63:32]),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
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
