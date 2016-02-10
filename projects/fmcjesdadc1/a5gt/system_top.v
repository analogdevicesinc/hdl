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

  ddr3_clk_p,
  ddr3_clk_n,
  ddr3_a,
  ddr3_ba,
  ddr3_cke,
  ddr3_cs_n,
  ddr3_odt,
  ddr3_reset_n,
  ddr3_we_n,
  ddr3_ras_n,
  ddr3_cas_n,
  ddr3_dqs_p,
  ddr3_dqs_n,
  ddr3_dq,
  ddr3_dm,
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

  gpio_bd,

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

  output            ddr3_clk_p;
  output            ddr3_clk_n;
  output  [ 13:0]   ddr3_a;
  output  [  2:0]   ddr3_ba;
  output            ddr3_cke;
  output            ddr3_cs_n;
  output            ddr3_odt;
  output            ddr3_reset_n;
  output            ddr3_we_n;
  output            ddr3_ras_n;
  output            ddr3_cas_n;
  inout   [  7:0]   ddr3_dqs_p;
  inout   [  7:0]   ddr3_dqs_n;
  inout   [ 63:0]   ddr3_dq;
  output  [  7:0]   ddr3_dm;
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

  output  [ 26:0]   gpio_bd;

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

  reg     [  3:0]   phy_rst_cnt = 0;
  reg               phy_rst_reg = 0;

  // internal clocks and resets

  wire              sys_125m_clk;
  wire              sys_25m_clk;
  wire              sys_2m5_clk;
  wire              eth_tx_clk;
  wire              rx_clk;

  // internal signals

  wire              sys_pll_locked;
  wire              eth_tx_mode_1g;
  wire              eth_tx_mode_10m_100m_n;
  wire              spi_mosi;
  wire              spi_miso;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;

  // ethernet transmit clock

  assign eth_tx_clk = (eth_tx_mode_1g == 1'b1) ? sys_125m_clk :
    (eth_tx_mode_10m_100m_n == 1'b0) ? sys_25m_clk : sys_2m5_clk;

  assign eth_phy_resetn = phy_rst_reg;

  always@ (posedge eth_mdc) begin
    phy_rst_cnt <= phy_rst_cnt + 4'd1;
    if (phy_rst_cnt == 4'h0) begin
      phy_rst_reg <= sys_pll_locked;
    end
  end

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  ad_iobuf #(.DATA_WIDTH(27)) i_iobuf_bd (
    .dio_t ({11'h7ff, 16'h0}),
    .dio_i (gpio_o[26:0]),
    .dio_o (gpio_i[26:0]),
    .dio_p (gpio_bd));

  altddio_out #(.width(1)) i_eth_tx_clk_out (
    .aset (1'b0),
    .sset (1'b0),
    .sclr (1'b0),
    .oe (1'b1),
    .oe_out (),
    .datain_h (1'b1),
    .datain_l (1'b0),
    .outclocken (1'b1),
    .aclr (~sys_pll_locked),
    .outclock (eth_tx_clk),
    .dataout (eth_tx_clk_out));

  system_bd i_system_bd (
    .a5gt_base_sys_ddr3_oct_rzqin (ddr3_rzq),
    .a5gt_base_sys_ddr3_phy_mem_a (ddr3_a),
    .a5gt_base_sys_ddr3_phy_mem_ba (ddr3_ba),
    .a5gt_base_sys_ddr3_phy_mem_ck (ddr3_clk_p),
    .a5gt_base_sys_ddr3_phy_mem_ck_n (ddr3_clk_n),
    .a5gt_base_sys_ddr3_phy_mem_cke (ddr3_cke),
    .a5gt_base_sys_ddr3_phy_mem_cs_n (ddr3_cs_n),
    .a5gt_base_sys_ddr3_phy_mem_dm (ddr3_dm),
    .a5gt_base_sys_ddr3_phy_mem_ras_n (ddr3_ras_n),
    .a5gt_base_sys_ddr3_phy_mem_cas_n (ddr3_cas_n),
    .a5gt_base_sys_ddr3_phy_mem_we_n (ddr3_we_n),
    .a5gt_base_sys_ddr3_phy_mem_reset_n (ddr3_reset_n),
    .a5gt_base_sys_ddr3_phy_mem_dq (ddr3_dq),
    .a5gt_base_sys_ddr3_phy_mem_dqs (ddr3_dqs_p),
    .a5gt_base_sys_ddr3_phy_mem_dqs_n (ddr3_dqs_n),
    .a5gt_base_sys_ddr3_phy_mem_odt (ddr3_odt),
    .a5gt_base_sys_125m_clk_clk (sys_125m_clk),
    .a5gt_base_sys_25m_clk_clk (sys_25m_clk),
    .a5gt_base_sys_2m5_clk_clk (sys_2m5_clk),
    .a5gt_base_sys_ethernet_mdio_mdc (eth_mdc),
    .a5gt_base_sys_ethernet_mdio_mdio_in (eth_mdio_i),
    .a5gt_base_sys_ethernet_mdio_mdio_out (eth_mdio_o),
    .a5gt_base_sys_ethernet_mdio_mdio_oen (eth_mdio_t),
    .a5gt_base_sys_ethernet_rgmii_rgmii_in (eth_rx_data),
    .a5gt_base_sys_ethernet_rgmii_rgmii_out (eth_tx_data),
    .a5gt_base_sys_ethernet_rgmii_rx_control (eth_rx_cntrl),
    .a5gt_base_sys_ethernet_rgmii_tx_control (eth_tx_cntrl),
    .a5gt_base_sys_ethernet_rx_clk_clk (eth_rx_clk),
    .a5gt_base_sys_ethernet_status_set_10 (),
    .a5gt_base_sys_ethernet_status_set_1000 (),
    .a5gt_base_sys_ethernet_status_eth_mode (eth_tx_mode_1g),
    .a5gt_base_sys_ethernet_status_ena_10 (eth_tx_mode_10m_100m_n),
    .a5gt_base_sys_ethernet_tx_clk_clk (eth_tx_clk),
    .a5gt_base_sys_gpio_in_port (gpio_i[63:32]),
    .a5gt_base_sys_gpio_out_port (gpio_o[63:32]),
    .a5gt_base_sys_gpio_bd_in_port (gpio_i[31:0]),
    .a5gt_base_sys_gpio_bd_out_port (gpio_o[31:0]),
    .a5gt_base_sys_pll_locked_export (sys_pll_locked),
    .a5gt_base_sys_spi_MISO (spi_miso),
    .a5gt_base_sys_spi_MOSI (spi_mosi),
    .a5gt_base_sys_spi_SCLK (spi_clk),
    .a5gt_base_sys_spi_SS_n (spi_csn),
    .rx_data_rx_serial_data (rx_data),
    .rx_ref_clk_clk (ref_clk),
    .rx_sync_rx_sync (rx_sync),
    .rx_sysref_rx_ext_sysref_out (rx_sysref),
    .sys_clk_clk (sys_clk),
    .sys_reset_reset_n (sys_resetn));

endmodule

// ***************************************************************************
// ***************************************************************************
