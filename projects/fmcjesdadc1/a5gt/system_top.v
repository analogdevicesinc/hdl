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

  // clock and resets

  sys_clk,
  sys_resetn,

  // ddr3

  ddr3_a,
  ddr3_ba,
  ddr3_clk_p,
  ddr3_clk_n,
  ddr3_cke,
  ddr3_cs_n,
  ddr3_dm,
  ddr3_ras_n,
  ddr3_cas_n,
  ddr3_we_n,
  ddr3_reset_n,
  ddr3_dq,
  ddr3_dqs_p,
  ddr3_dqs_n,
  ddr3_odt,
  ddr3_rzq,

  // ethernet

  eth_rx_clk,
  eth_rx_data,
  eth_rx_cntrl,
  eth_tx_clk_out,
  eth_tx_data,
  eth_tx_cntrl,
  eth_mdc,
  eth_mdio_i,
  eth_mdio_o,
  eth_mdio_t,
  eth_phy_resetn,

  // board gpio

  led_grn,
  led_red,
  push_buttons,
  dip_switches,

  // lane interface

  ref_clk,
  rx_data,
  rx_sync,
  rx_sysref,

  // spi

  spi_csn,
  spi_clk,
  spi_sdio);

  // clock and resets

  input             sys_clk;
  input             sys_resetn;

  // ddr3

  output  [ 13:0]   ddr3_a;
  output  [  2:0]   ddr3_ba;
  output            ddr3_clk_p;
  output            ddr3_clk_n;
  output            ddr3_cke;
  output            ddr3_cs_n;
  output  [  7:0]   ddr3_dm;
  output            ddr3_ras_n;
  output            ddr3_cas_n;
  output            ddr3_we_n;
  output            ddr3_reset_n;
  inout   [ 63:0]   ddr3_dq;
  inout   [  7:0]   ddr3_dqs_p;
  inout   [  7:0]   ddr3_dqs_n;
  output            ddr3_odt;
  input             ddr3_rzq;

  // ethernet

  input             eth_rx_clk;
  input   [  3:0]   eth_rx_data;
  input             eth_rx_cntrl;
  output            eth_tx_clk_out;
  output  [  3:0]   eth_tx_data;
  output            eth_tx_cntrl;
  output            eth_mdc;
  input             eth_mdio_i;
  output            eth_mdio_o;
  output            eth_mdio_t;
  output            eth_phy_resetn;

  // board gpio

  output  [  7:0]   led_grn;
  output  [  7:0]   led_red;
  input   [  2:0]   push_buttons;
  input   [  7:0]   dip_switches;

  // lane interface

  input             ref_clk;
  input   [  3:0]   rx_data;
  output            rx_sync;
  output            rx_sysref;

  // spi

  output            spi_csn;
  output            spi_clk;
  inout             spi_sdio;

  // internal registers

  reg               rx_sysref_m1 = 'd0;
  reg               rx_sysref_m2 = 'd0;
  reg               rx_sysref_m3 = 'd0;
  reg               rx_sysref = 'd0;
  reg     [  3:0]   phy_rst_cnt = 0;
  reg               phy_rst_reg = 0;


  // internal clocks and resets

  wire              sys_125m_clk;
  wire              sys_25m_clk;
  wire              sys_2m5_clk;
  wire              eth_tx_clk;
  wire              rx_clk;

  // internal signals

  wire              sys_pll_locked_s;
  wire              eth_tx_reset_s;
  wire              eth_tx_mode_1g_s;
  wire              eth_tx_mode_10m_100m_n_s;
  wire              spi_mosi;
  wire              spi_miso;
  wire    [  3:0]   rx_ip_sof_s;
  wire    [127:0]   rx_ip_data_s;
  wire    [127:0]   rx_data_s;
  wire              rx_sw_rstn_s;
  wire              rx_sysref_s;
  wire              rx_err_s;
  wire              rx_ready_s;
  wire    [  3:0]   rx_rst_state_s;
  wire              rx_lane_aligned_s;
  wire    [  3:0]   rx_analog_reset_s;
  wire    [  3:0]   rx_digital_reset_s;
  wire    [  3:0]   rx_cdr_locked_s;
  wire    [  3:0]   rx_cal_busy_s;
  wire              rx_pll_locked_s;
  wire    [ 15:0]   rx_xcvr_status_s;

  // ethernet transmit clock

  assign eth_tx_clk = (eth_tx_mode_1g_s == 1'b1) ? sys_125m_clk :
    (eth_tx_mode_10m_100m_n_s == 1'b0) ? sys_25m_clk : sys_2m5_clk;

  assign eth_phy_resetn = phy_rst_reg;

  always@ (posedge eth_mdc) begin
    phy_rst_cnt <= phy_rst_cnt + 4'd1;
    if (phy_rst_cnt == 4'h0) begin
      phy_rst_reg <= sys_pll_locked_s;
    end
  end

  altddio_out #(.width(1)) i_eth_tx_clk_out (
    .aset (1'b0),
    .sset (1'b0),
    .sclr (1'b0),
    .oe (1'b1),
    .oe_out (),
    .datain_h (1'b1),
    .datain_l (1'b0),
    .outclocken (1'b1),
    .aclr (eth_tx_reset_s),
    .outclock (eth_tx_clk),
    .dataout (eth_tx_clk_out));

  assign eth_tx_reset_s = ~sys_pll_locked_s;

  always @(posedge rx_clk) begin
    rx_sysref_m1 <= rx_sysref_s;
    rx_sysref_m2 <= rx_sysref_m1;
    rx_sysref_m3 <= rx_sysref_m2;
    rx_sysref <= rx_sysref_m2 & ~rx_sysref_m3;
  end

  genvar n;
  generate
  for (n = 0; n < 4; n = n + 1) begin: g_align_1
  ad_jesd_align i_jesd_align (
    .rx_clk (rx_clk),
    .rx_ip_sof (rx_ip_sof_s),
    .rx_ip_data (rx_ip_data_s[n*32+31:n*32]),
    .rx_data (rx_data_s[n*32+31:n*32]));
  end
  endgenerate

  sld_signaltap #(
    .sld_advanced_trigger_entity ("basic,1,"),
    .sld_data_bits (130),
    .sld_data_bit_cntr_bits (8),
    .sld_enable_advanced_trigger (0),
    .sld_mem_address_bits (10),
    .sld_node_crc_bits (32),
    .sld_node_crc_hiword (10311),
    .sld_node_crc_loword (14297),
    .sld_node_info (1076736),
    .sld_ram_block_type ("AUTO"),
    .sld_sample_depth (1024),
    .sld_storage_qualifier_gap_record (0),
    .sld_storage_qualifier_mode ("OFF"),
    .sld_trigger_bits (2),
    .sld_trigger_in_enabled (0),
    .sld_trigger_level (1),
    .sld_trigger_level_pipeline (1))
    i_signaltap (
      .acq_clk (rx_clk),
      .acq_data_in ({ rx_sysref,
                      rx_sync,
                      rx_ip_data_s}),
      .acq_trigger_in ({rx_sysref, rx_sync}));



  assign rx_xcvr_status_s[15:15] = 1'd0;
  assign rx_xcvr_status_s[14:14] = rx_sync;
  assign rx_xcvr_status_s[13:13] = rx_ready_s;
  assign rx_xcvr_status_s[12:12] = rx_pll_locked_s;
  assign rx_xcvr_status_s[11: 8] = rx_rst_state_s;
  assign rx_xcvr_status_s[ 7: 4] = rx_cdr_locked_s;
  assign rx_xcvr_status_s[ 3: 0] = rx_cal_busy_s;

  ad_xcvr_rx_rst #(.NUM_OF_LANES (4)) i_xcvr_rx_rst (
    .rx_clk (rx_clk),
    .rx_rstn (sys_resetn),
    .rx_sw_rstn (rx_sw_rstn_s),
    .rx_pll_locked (rx_pll_locked_s),
    .rx_cal_busy (rx_cal_busy_s),
    .rx_cdr_locked (rx_cdr_locked_s),
    .rx_analog_reset (rx_analog_reset_s),
    .rx_digital_reset (rx_digital_reset_s),
    .rx_ready (rx_ready_s),
    .rx_rst_state (rx_rst_state_s));

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  system_bd i_system_bd (
    .sys_clk_clk (sys_clk),
    .sys_reset_reset_n (sys_resetn),
    .sys_125m_clk_clk (sys_125m_clk),
    .sys_25m_clk_clk (sys_25m_clk),
    .sys_2m5_clk_clk (sys_2m5_clk),
    .sys_ddr3_phy_mem_a (ddr3_a),
    .sys_ddr3_phy_mem_ba (ddr3_ba),
    .sys_ddr3_phy_mem_ck (ddr3_clk_p),
    .sys_ddr3_phy_mem_ck_n (ddr3_clk_n),
    .sys_ddr3_phy_mem_cke (ddr3_cke),
    .sys_ddr3_phy_mem_cs_n (ddr3_cs_n),
    .sys_ddr3_phy_mem_dm (ddr3_dm),
    .sys_ddr3_phy_mem_ras_n (ddr3_ras_n),
    .sys_ddr3_phy_mem_cas_n (ddr3_cas_n),
    .sys_ddr3_phy_mem_we_n (ddr3_we_n),
    .sys_ddr3_phy_mem_reset_n (ddr3_reset_n),
    .sys_ddr3_phy_mem_dq (ddr3_dq),
    .sys_ddr3_phy_mem_dqs (ddr3_dqs_p),
    .sys_ddr3_phy_mem_dqs_n (ddr3_dqs_n),
    .sys_ddr3_phy_mem_odt (ddr3_odt),
    .sys_ddr3_oct_rzqin (ddr3_rzq),
    .sys_ethernet_tx_clk_clk (eth_tx_clk),
    .sys_ethernet_rx_clk_clk (eth_rx_clk),
    .sys_ethernet_status_set_10 (),
    .sys_ethernet_status_set_1000 (),
    .sys_ethernet_status_eth_mode (eth_tx_mode_1g_s),
    .sys_ethernet_status_ena_10 (eth_tx_mode_10m_100m_n_s),
    .sys_ethernet_rgmii_rgmii_in (eth_rx_data),
    .sys_ethernet_rgmii_rgmii_out (eth_tx_data),
    .sys_ethernet_rgmii_rx_control (eth_rx_cntrl),
    .sys_ethernet_rgmii_tx_control (eth_tx_cntrl),
    .sys_ethernet_mdio_mdc (eth_mdc),
    .sys_ethernet_mdio_mdio_in (eth_mdio_i),
    .sys_ethernet_mdio_mdio_out (eth_mdio_o),
    .sys_ethernet_mdio_mdio_oen (eth_mdio_t),
    .sys_gpio_in_export ({rx_xcvr_status_s, 5'd0, push_buttons, dip_switches}),
    .sys_gpio_out_export ({14'd0, rx_sw_rstn_s, rx_sysref_s, led_grn, led_red}),
    .sys_spi_MISO (spi_miso),
    .sys_spi_MOSI (spi_mosi),
    .sys_spi_SCLK (spi_clk),
    .sys_spi_SS_n (spi_csn),
    .axi_ad9250_0_xcvr_clk_clk (rx_clk),
    .axi_ad9250_0_xcvr_data_data (rx_data_s[63:0]),
    .axi_ad9250_1_xcvr_clk_clk (rx_clk),
    .axi_ad9250_1_xcvr_data_data (rx_data_s[127:64]),
    .sys_jesd204b_s1_rx_link_data (rx_ip_data_s),
    .sys_jesd204b_s1_rx_link_valid (),
    .sys_jesd204b_s1_rx_link_ready (1'b1),
    .sys_jesd204b_s1_lane_aligned_all_export (rx_lane_aligned_s),
    .sys_jesd204b_s1_sysref_export (rx_sysref),
    .sys_jesd204b_s1_rx_ferr_export (rx_err_s),
    .sys_jesd204b_s1_lane_aligned_export (rx_lane_aligned_s),
    .sys_jesd204b_s1_sync_n_export (rx_sync),
    .sys_jesd204b_s1_rx_sof_export (rx_ip_sof_s),
    .sys_jesd204b_s1_rx_xcvr_data_rx_serial_data (rx_data),
    .sys_jesd204b_s1_rx_analogreset_rx_analogreset (rx_analog_reset_s),
    .sys_jesd204b_s1_rx_digitalreset_rx_digitalreset (rx_digital_reset_s),
    .sys_jesd204b_s1_locked_rx_is_lockedtodata (rx_cdr_locked_s),
    .sys_jesd204b_s1_rx_cal_busy_rx_cal_busy (rx_cal_busy_s),
    .sys_jesd204b_s1_ref_clk_clk (ref_clk),
    .sys_jesd204b_s1_rx_clk_clk (rx_clk),
    .sys_jesd204b_s1_pll_locked_export (rx_pll_locked_s),
    .sys_pll_locked_export (sys_pll_locked_s));

endmodule

// ***************************************************************************
// ***************************************************************************
