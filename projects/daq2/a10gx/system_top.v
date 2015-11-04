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
  ddr3_ref_clk,

  // ethernet

  eth_ref_clk,
  eth_rxd,
  eth_txd,
  eth_mdc,
  eth_mdio,
  eth_resetn,
  eth_intn,

  // board gpio

  gpio_bd,

  // lane interface

  rx_ref_clk,
  rx_sysref,
  rx_sync,
  rx_data,
  tx_ref_clk,
  tx_sysref,
  tx_sync,
  tx_data,

  // gpio

  trig,
  adc_fdb,
  adc_fda,
  dac_irq,
  clkd_status,
  adc_pd,
  dac_txen,
  dac_reset,
  clkd_sync,

  // spi

  spi_csn_clk,
  spi_csn_dac,
  spi_csn_adc,
  spi_clk,
  spi_sdio,
  spi_dir);

  // clock and resets

  input             sys_clk;
  input             sys_resetn;

  // ddr3

  output            ddr3_clk_p;
  output            ddr3_clk_n;
  output  [ 14:0]   ddr3_a;
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
  input             ddr3_ref_clk;

  // ethernet

  input             eth_ref_clk;
  input             eth_rxd;
  output            eth_txd;
  output            eth_mdc;
  inout             eth_mdio;
  output            eth_resetn;
  input             eth_intn;

  // board gpio

  inout   [ 26:0]   gpio_bd;

  // lane interface

  input             rx_ref_clk;
  input             rx_sysref;
  output            rx_sync;
  input   [  3:0]   rx_data;
  input             tx_ref_clk;
  input             tx_sysref;
  input             tx_sync;
  output  [  3:0]   tx_data;

  // gpio

  input             trig;
  input             adc_fdb;
  input             adc_fda;
  input             dac_irq;
  input   [  1:0]   clkd_status;
  output            adc_pd;
  output            dac_txen;
  output            dac_reset;
  output            clkd_sync;

  // spi

  output            spi_csn_clk;
  output            spi_csn_dac;
  output            spi_csn_adc;
  output            spi_clk;
  inout             spi_sdio;
  output            spi_dir;

  // internal signals

  wire              eth_reset;
  wire              eth_mdio_i;
  wire              eth_mdio_o;
  wire              eth_mdio_t;
  wire    [ 31:0]   gpio_i;
  wire    [ 31:0]   gpio_o;
  wire              spi_miso_s;
  wire              spi_mosi_s;
  wire    [  7:0]   spi_csn_s;

  // daq2

  assign spi_csn_adc = spi_csn_s[2];
  assign spi_csn_dac = spi_csn_s[1];
  assign spi_csn_clk = spi_csn_s[0];

  daq2_spi i_daq2_spi (
    .spi_csn (spi_csn_s[2:0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi_s),
    .spi_miso (spi_miso_s),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  // board stuff

  assign eth_resetn = ~eth_reset;
  assign eth_mdio_i = eth_mdio;
  assign eth_mdio = (eth_mdio_t == 1'b1) ? 1'bz : eth_mdio_o;

  assign ddr3_a[14:12] = 3'd0;

  assign gpio_i[31:27] = gpio_o[31:27];

  ad_iobuf #(.DATA_WIDTH(27)) i_iobuf_bd (
    .dio_t ({11'h7ff, 16'h0}),
    .dio_i (gpio_o[26:0]),
    .dio_o (gpio_i[26:0]),
    .dio_p (gpio_bd));

  system_bd i_system_bd (
    .a10gx_base_sys_ddr3_cntrl_mem_mem_ck (ddr3_clk_p),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_ck_n (ddr3_clk_n),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_a (ddr3_a[11:0]),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_ba (ddr3_ba),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_cke (ddr3_cke),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_cs_n (ddr3_cs_n),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_odt (ddr3_odt),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_reset_n (ddr3_reset_n),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_we_n (ddr3_we_n),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_ras_n (ddr3_ras_n),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_cas_n (ddr3_cas_n),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_dqs (ddr3_dqs_p[7:0]),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_dqs_n (ddr3_dqs_n[7:0]),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_dq (ddr3_dq[63:0]),
    .a10gx_base_sys_ddr3_cntrl_mem_mem_dm (ddr3_dm[7:0]),
    .a10gx_base_sys_ddr3_cntrl_oct_oct_rzqin (ddr3_rzq),
    .a10gx_base_sys_ddr3_cntrl_pll_ref_clk_clk (ddr3_ref_clk),
    .a10gx_base_sys_ethernet_mdio_mdc (eth_mdc),
    .a10gx_base_sys_ethernet_mdio_mdio_in (eth_mdio_i),
    .a10gx_base_sys_ethernet_mdio_mdio_out (eth_mdio_o),
    .a10gx_base_sys_ethernet_mdio_mdio_oen (eth_mdio_t),
    .a10gx_base_sys_ethernet_ref_clk_clk (eth_ref_clk),
    .a10gx_base_sys_ethernet_reset_reset (eth_reset),
    .a10gx_base_sys_ethernet_sgmii_rxp_0 (eth_rxd),
    .a10gx_base_sys_ethernet_sgmii_txp_0 (eth_txd),
    .a10gx_base_sys_gpio_in_export ({trig, adc_fdb, adc_fda, dac_irq, clkd_status[1], clkd_status[0]}),
    .a10gx_base_sys_gpio_out_export ({adc_pd, dac_txen, dac_reset, clkd_sync}),
    .a10gx_base_sys_gpio_bd_in_port (gpio_i[31:0]),
    .a10gx_base_sys_gpio_bd_out_port (gpio_o[31:0]),
    .a10gx_base_sys_spi_MISO (spi_miso_s),
    .a10gx_base_sys_spi_MOSI (spi_mosi_s),
    .a10gx_base_sys_spi_SCLK (spi_clk),
    .a10gx_base_sys_spi_SS_n (spi_csn_s),
    .daq2_rx_data_rx_serial_data (rx_data),
    .daq2_rx_ref_clk_clk (rx_ref_clk),
    .daq2_rx_sync_rx_sync (rx_sync),
    .daq2_rx_sysref_rx_ext_sysref_in (rx_sysref),
    .daq2_tx_data_tx_serial_data (tx_data),
    .daq2_tx_ref_clk_clk (tx_ref_clk),
    .daq2_tx_sync_tx_sync (tx_sync),
    .daq2_tx_sysref_tx_ext_sysref_in (tx_sysref),
    .sys_clk_clk (sys_clk),
    .sys_reset_reset_n (sys_resetn));

endmodule

// ***************************************************************************
// ***************************************************************************
