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

  gpio_bd_i,
  gpio_bd_o,

  // ad9361-interface

  rx_clk_in,
  rx_frame_in,
  rx_data_in,
  tx_clk_out,
  tx_frame_out,
  tx_data_out,

  enable,
  txnrx,

  gpio_resetb,
  gpio_sync,
  gpio_en_agc,
  gpio_ctl,
  gpio_status,

  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso);


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

  input   [ 10:0]   gpio_bd_i;
  output  [ 15:0]   gpio_bd_o;

  // ad9361-interface

  input             rx_clk_in;
  input             rx_frame_in;
  input   [  5:0]   rx_data_in;
  output            tx_clk_out;
  output            tx_frame_out;
  output  [  5:0]   tx_data_out;
  output            enable;
  output            txnrx;

  output            gpio_resetb;
  output            gpio_sync;
  output            gpio_en_agc;
  output  [  3:0]   gpio_ctl;
  input   [  7:0]   gpio_status;

  output            spi_csn;
  output            spi_clk;
  output            spi_mosi;
  input             spi_miso;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  // conections

  assign gpio_resetb    = gpio_o[46];
  assign gpio_sync      = gpio_o[45];
  assign gpio_en_agc    = gpio_o[44];
  assign gpio_ctl       = gpio_o[43:40];
  assign gpio_i[39:32]  = gpio_status;

  assign gpio_bd_o      = gpio_o[15:0];

  assign gpio_i[31:27]  = gpio_o[31:27];
  assign gpio_i[15: 0]  = gpio_o[15:0];
  assign gpio_i[26:16]  = gpio_bd_i;

  // instantiations

 system_bd i_system_bd (
    .sys_clk_clk (sys_clk),
    .sys_rst_reset_n (sys_resetn),

    .sys_ddr3_cntrl_mem_mem_ck (ddr3_clk_p),
    .sys_ddr3_cntrl_mem_mem_ck_n (ddr3_clk_n),
    .sys_ddr3_cntrl_mem_mem_a (ddr3_a[11:0]),
    .sys_ddr3_cntrl_mem_mem_ba (ddr3_ba),
    .sys_ddr3_cntrl_mem_mem_cke (ddr3_cke),
    .sys_ddr3_cntrl_mem_mem_cs_n (ddr3_cs_n),
    .sys_ddr3_cntrl_mem_mem_odt (ddr3_odt),
    .sys_ddr3_cntrl_mem_mem_reset_n (ddr3_reset_n),
    .sys_ddr3_cntrl_mem_mem_we_n (ddr3_we_n),
    .sys_ddr3_cntrl_mem_mem_ras_n (ddr3_ras_n),
    .sys_ddr3_cntrl_mem_mem_cas_n (ddr3_cas_n),
    .sys_ddr3_cntrl_mem_mem_dqs (ddr3_dqs_p[7:0]),
    .sys_ddr3_cntrl_mem_mem_dqs_n (ddr3_dqs_n[7:0]),
    .sys_ddr3_cntrl_mem_mem_dq (ddr3_dq[63:0]),
    .sys_ddr3_cntrl_mem_mem_dm (ddr3_dm[7:0]),
    .sys_ddr3_cntrl_oct_oct_rzqin (ddr3_rzq),
    .sys_ddr3_cntrl_pll_ref_clk_clk (ddr3_ref_clk),

    .sys_ethernet_mdio_mdc (eth_mdc),
    .sys_ethernet_mdio_mdio_in (eth_mdio_i),
    .sys_ethernet_mdio_mdio_out (eth_mdio_o),
    .sys_ethernet_mdio_mdio_oen (eth_mdio_t),
    .sys_ethernet_ref_clk_clk (eth_ref_clk),
    .sys_ethernet_reset_reset (eth_reset),
    .sys_ethernet_sgmii_rxp_0 (eth_rxd),
    .sys_ethernet_sgmii_txp_0 (eth_txd),

    .sys_gpio_bd_in_port (gpio_i[31:0]),
    .sys_gpio_bd_out_port (gpio_o[31:0]),
    .sys_gpio_in_export (gpio_i[63:32]),
    .sys_gpio_out_export (gpio_o[63:32]),

    .axi_ad9361_device_if_enable (enable),
    .axi_ad9361_device_if_rx_clk_in_p (rx_clk_in),
    .axi_ad9361_device_if_rx_clk_in_n (1'b0),
    .axi_ad9361_device_if_rx_data_in_p (rx_data_in),
    .axi_ad9361_device_if_rx_data_in_n (6'd0),
    .axi_ad9361_device_if_rx_frame_in_p (rx_frame_in),
    .axi_ad9361_device_if_rx_frame_in_n (1'b0),
    .axi_ad9361_device_if_tx_clk_out_p (tx_clk_out),
    .axi_ad9361_device_if_tx_clk_out_n (1'b0),
    .axi_ad9361_device_if_tx_data_out_p (tx_data_out),
    .axi_ad9361_device_if_tx_data_out_n (6'd0),
    .axi_ad9361_device_if_tx_frame_out_p (tx_frame_out),
    .axi_ad9361_device_if_tx_frame_out_n (1'b0),
    .axi_ad9361_device_if_txnrx (txnrx),

    .delay_clk_clk (1'b0),

    .up_enable_up_enable (gpio_o[47]),
    .up_txnrx_up_txnrx (gpio_o[48]));

endmodule


// ***************************************************************************
// ***************************************************************************
