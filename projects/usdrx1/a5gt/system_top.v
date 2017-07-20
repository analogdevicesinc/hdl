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

  input             sys_clk,
  input             sys_resetn,

  // ddr3

  output            ddr3_clk_p,
  output            ddr3_clk_n,
  output  [ 13:0]   ddr3_a,
  output  [  2:0]   ddr3_ba,
  output            ddr3_cke,
  output            ddr3_cs_n,
  output            ddr3_odt,
  output            ddr3_reset_n,
  output            ddr3_we_n,
  output            ddr3_ras_n,
  output            ddr3_cas_n,
  inout   [  7:0]   ddr3_dqs_p,
  inout   [  7:0]   ddr3_dqs_n,
  inout   [ 63:0]   ddr3_dq,
  output  [  7:0]   ddr3_dm,
  input             ddr3_rzq,

  // ethernet

  input             eth_rx_clk,
  input   [  3:0]   eth_rx_data,
  input             eth_rx_cntrl,
  output            eth_tx_clk_out,
  output  [  3:0]   eth_tx_data,
  output            eth_tx_cntrl,
  output            eth_mdc,
  input             eth_mdio_i,
  output            eth_mdio_o,
  output            eth_mdio_t,
  output            eth_phy_resetn,

  // board gpio

  output  [ 15:0]   gpio_bd_o,
  input   [ 10:0]   gpio_bd_i,

  // lane interface

  input             ref_clk,
  input   [  7:0]   rx_data,
  output            rx_sync,
  output            rx_sysref,

  // spi

  output            spi_fout_enb_clk,
  output            spi_fout_enb_mlo,
  output            spi_fout_enb_rst,
  output            spi_fout_enb_sync,
  output            spi_fout_enb_sysref,
  output            spi_fout_enb_trig,
  output            spi_fout_clk,
  output            spi_fout_sdio,
  output  [  3:0]   spi_afe_csn,
  output            spi_afe_clk,
  inout             spi_afe_sdio,
  output            spi_clk_csn,
  output            spi_clk_clk,
  inout             spi_clk_sdio,

  // gpio

  output            clk_resetn,
  output            clk_syncn,
  input             clk_status,
  output            afe_rst,
  output            afe_trig,
  output            afe_pdn,
  output            afe_stby,
  output  [ 13:0]   dac_data,
  output            dac_sleep,
  output            amp_disbn,
  output            prc_sck,
  output            prc_cnv,
  input             prc_sdo_i,
  input             prc_sdo_q);

  // internal registers

  reg     [  3:0]   phy_rst_cnt = 0;
  reg               phy_rst_reg = 0;

  // internal signals

  wire              sys_125m_clk;
  wire              sys_25m_clk;
  wire              sys_2m5_clk;
  wire              sys_cpu_clk;
  wire              sys_cpu_mem_resetn;
  wire              sys_cpu_resetn;
  wire              sys_pll_locked;
  wire              eth_tx_clk;
  wire              eth_tx_mode_1g;
  wire              eth_tx_mode_10m_100m_n;
  wire              rx_clk;
  wire    [ 31:0]   rx_ch_wr;
  wire    [511:0]   rx_ch_wdata;
  wire              rx_ch_wovf;
  wire              rx_ch_sync;
  wire    [  3:0]   rx_ch_raddr;
  wire    [  3:0]   rx_ip_sof;
  wire    [255:0]   rx_ip_data;
  wire    [  7:0]   spi_csn_s;
  wire              spi_clk;
  wire              spi_mosi;
  wire              spi_miso;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;

  // sys reset

  assign sys_cpu_resetn = sys_resetn & sys_cpu_mem_resetn & sys_pll_locked;

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

  // gpio

  assign gpio_i[63:57] = gpio_o[63:57];
  assign amp_disbn = gpio_o[56];

  assign gpio_i[55:40] = gpio_o[55:40];
  assign dac_sleep = gpio_o[54];
  assign dac_data = gpio_o[53:40];

  assign gpio_i[39:36] = gpio_o[39:36];
  assign afe_stby = gpio_o[39];
  assign afe_pdn = gpio_o[38];
  assign afe_trig = gpio_o[37];
  assign afe_rst = gpio_o[36];

  assign gpio_i[35:35] = clk_status;
  assign gpio_i[34:32] = gpio_o[34:32];
  assign clk_sync = gpio_o[34];
  assign clk_resetn = gpio_o[33];

  // gpio (bd)

  assign gpio_i[31:11] = gpio_o[31:11];
  assign gpio_i[10: 0] = gpio_bd_i;

  assign gpio_bd_o = gpio_o[26:11];

  // sysref

  ad_sysref_gen i_sysref (
    .core_clk (rx_clk),
    .sysref_en (gpio_o[60]),
    .sysref_out (rx_sysref));

  // spi (fanout buffers)

  assign spi_fout_enb_clk     = 1'b0;
  assign spi_fout_enb_mlo     = 1'b0;
  assign spi_fout_enb_rst     = 1'b0;
  assign spi_fout_enb_sync    = 1'b0;
  assign spi_fout_enb_sysref  = 1'b0;
  assign spi_fout_enb_trig    = 1'b0;
  assign spi_fout_clk         = 1'b0;
  assign spi_fout_sdio        = 1'b0;

  // spi (adc)

  assign prc_sck = 1'b0;
  assign prc_cnv = 1'b0;

  // spi (main)

  assign spi_afe_csn = spi_csn_s[ 4: 1];
  assign spi_clk_csn = spi_csn_s[ 0: 0];
  assign spi_afe_clk = spi_clk;
  assign spi_clk_clk = spi_clk;

  // instantiations

  usdrx1_spi i_spi (
    .spi_afe_csn (spi_csn_s[4:1]),
    .spi_clk_csn (spi_csn_s[0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_afe_sdio (spi_afe_sdio),
    .spi_clk_sdio (spi_clk_sdio));

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
    .rx_ch_wdata_data (rx_ch_wdata),
    .rx_ch_wovf_ovf (rx_ch_wovf),
    .rx_ch_wr_valid (&rx_ch_wr),
    .rx_core_ch_0_enable (),
    .rx_core_ch_0_valid (rx_ch_wr[7:0]),
    .rx_core_ch_0_data (rx_ch_wdata[127:0]),
    .rx_core_ch_1_enable (),
    .rx_core_ch_1_valid (rx_ch_wr[15:8]),
    .rx_core_ch_1_data (rx_ch_wdata[255:128]),
    .rx_core_ch_2_enable (),
    .rx_core_ch_2_valid (rx_ch_wr[23:16]),
    .rx_core_ch_2_data (rx_ch_wdata[383:256]),
    .rx_core_ch_3_enable (),
    .rx_core_ch_3_valid (rx_ch_wr[31:24]),
    .rx_core_ch_3_data (rx_ch_wdata[511:384]),
    .rx_core_clk_clk (rx_clk),
    .rx_core_ovf_0_ovf (rx_ch_wovf),
    .rx_core_ovf_1_ovf (rx_ch_wovf),
    .rx_core_ovf_2_ovf (rx_ch_wovf),
    .rx_core_ovf_3_ovf (rx_ch_wovf),
    .rx_core_sync_0_sync_in (1'b0),
    .rx_core_sync_0_sync_out (rx_ch_sync),
    .rx_core_sync_0_raddr_in (4'd0),
    .rx_core_sync_0_raddr_out (rx_ch_raddr),
    .rx_core_sync_1_sync_in (rx_ch_sync),
    .rx_core_sync_1_sync_out (),
    .rx_core_sync_1_raddr_in (rx_ch_raddr),
    .rx_core_sync_1_raddr_out (),
    .rx_core_sync_2_sync_in (rx_ch_sync),
    .rx_core_sync_2_sync_out (),
    .rx_core_sync_2_raddr_in (rx_ch_raddr),
    .rx_core_sync_2_raddr_out (),
    .rx_core_sync_3_sync_in (rx_ch_sync),
    .rx_core_sync_3_sync_out (),
    .rx_core_sync_3_raddr_in (rx_ch_raddr),
    .rx_core_sync_3_raddr_out (),
    .rx_core_unf_0_unf (1'd0),
    .rx_core_unf_1_unf (1'd0),
    .rx_core_unf_2_unf (1'd0),
    .rx_core_unf_3_unf (1'd0),
    .rx_data_0_rx_serial_data (rx_data[0]),
    .rx_data_1_rx_serial_data (rx_data[1]),
    .rx_data_2_rx_serial_data (rx_data[2]),
    .rx_data_3_rx_serial_data (rx_data[3]),
    .rx_data_4_rx_serial_data (rx_data[4]),
    .rx_data_5_rx_serial_data (rx_data[5]),
    .rx_data_6_rx_serial_data (rx_data[6]),
    .rx_data_7_rx_serial_data (rx_data[7]),
    .rx_ip_data_data (rx_ip_data),
    .rx_ip_data_valid (),
    .rx_ip_data_ready (1'b1),
    .rx_ip_data_0_data (rx_ip_data[63:0]),
    .rx_ip_data_0_valid (1'b1),
    .rx_ip_data_0_ready (),
    .rx_ip_data_1_data (rx_ip_data[127:64]),
    .rx_ip_data_1_valid (1'b1),
    .rx_ip_data_1_ready (),
    .rx_ip_data_2_data (rx_ip_data[191:128]),
    .rx_ip_data_2_valid (1'b1),
    .rx_ip_data_2_ready (),
    .rx_ip_data_3_data (rx_ip_data[255:192]),
    .rx_ip_data_3_valid (1'b1),
    .rx_ip_data_3_ready (),
    .rx_ip_sof_export (rx_ip_sof),
    .rx_ip_sof_0_export (rx_ip_sof),
    .rx_ip_sof_1_export (rx_ip_sof),
    .rx_ip_sof_2_export (rx_ip_sof),
    .rx_ip_sof_3_export (rx_ip_sof),
    .rx_ref_clk_clk (ref_clk),
    .rx_sync_export (rx_sync),
    .rx_sysref_export (rx_sysref),
    .sys_125m_clk_clk (sys_125m_clk),
    .sys_25m_clk_clk (sys_25m_clk),
    .sys_2m5_clk_clk (sys_2m5_clk),
    .sys_clk_clk (sys_cpu_clk),
    .sys_cpu_clk_clk (sys_cpu_clk),
    .sys_cpu_reset_reset_n (sys_cpu_mem_resetn),
    .sys_ddr3_cntrl_mem_mem_a (ddr3_a),
    .sys_ddr3_cntrl_mem_mem_ba (ddr3_ba),
    .sys_ddr3_cntrl_mem_mem_ck (ddr3_clk_p),
    .sys_ddr3_cntrl_mem_mem_ck_n (ddr3_clk_n),
    .sys_ddr3_cntrl_mem_mem_cke (ddr3_cke),
    .sys_ddr3_cntrl_mem_mem_cs_n (ddr3_cs_n),
    .sys_ddr3_cntrl_mem_mem_dm (ddr3_dm),
    .sys_ddr3_cntrl_mem_mem_ras_n (ddr3_ras_n),
    .sys_ddr3_cntrl_mem_mem_cas_n (ddr3_cas_n),
    .sys_ddr3_cntrl_mem_mem_we_n (ddr3_we_n),
    .sys_ddr3_cntrl_mem_mem_reset_n (ddr3_reset_n),
    .sys_ddr3_cntrl_mem_mem_dq (ddr3_dq),
    .sys_ddr3_cntrl_mem_mem_dqs (ddr3_dqs_p),
    .sys_ddr3_cntrl_mem_mem_dqs_n (ddr3_dqs_n),
    .sys_ddr3_cntrl_mem_mem_odt (ddr3_odt),
    .sys_ddr3_cntrl_oct_rzqin (ddr3_rzq),
    .sys_ethernet_mdio_mdc (eth_mdc),
    .sys_ethernet_mdio_mdio_in (eth_mdio_i),
    .sys_ethernet_mdio_mdio_out (eth_mdio_o),
    .sys_ethernet_mdio_mdio_oen (eth_mdio_t),
    .sys_ethernet_rgmii_rgmii_in (eth_rx_data),
    .sys_ethernet_rgmii_rgmii_out (eth_tx_data),
    .sys_ethernet_rgmii_rx_control (eth_rx_cntrl),
    .sys_ethernet_rgmii_tx_control (eth_tx_cntrl),
    .sys_ethernet_rx_clk_clk (eth_rx_clk),
    .sys_ethernet_status_set_10 (),
    .sys_ethernet_status_set_1000 (),
    .sys_ethernet_status_eth_mode (eth_tx_mode_1g),
    .sys_ethernet_status_ena_10 (eth_tx_mode_10m_100m_n),
    .sys_ethernet_tx_clk_clk (eth_tx_clk),
    .sys_gpio_bd_in_port (gpio_i[31:0]),
    .sys_gpio_bd_out_port (gpio_o[31:0]),
    .sys_gpio_in_export (gpio_i[63:32]),
    .sys_gpio_out_export (gpio_o[63:32]),
    .sys_pll_locked_export (sys_pll_locked),
    .sys_ref_clk_clk (sys_clk),
    .sys_ref_rst_reset_n (sys_resetn),
    .sys_rst_reset_n (sys_cpu_resetn),
    .sys_spi_MISO (spi_miso),
    .sys_spi_MOSI (spi_mosi),
    .sys_spi_SCLK (spi_clk),
    .sys_spi_SS_n (spi_csn_s));

endmodule

// ***************************************************************************
// ***************************************************************************
