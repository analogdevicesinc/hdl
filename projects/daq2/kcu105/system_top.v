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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  sys_rst,
  sys_clk_p,
  sys_clk_n,
  sys_125m_clk_p,
  sys_125m_clk_n,

  uart_sin,
  uart_sout,

  ddr4_act_n,
  ddr4_addr,
  ddr4_ba,
  ddr4_bg,
  ddr4_ck_p,
  ddr4_ck_n,
  ddr4_cke,
  ddr4_cs_n,
  ddr4_dm_n,
  ddr4_dq,
  ddr4_dqs_p,
  ddr4_dqs_n,
  ddr4_odt,
  ddr4_par,
  ddr4_reset_n,

  mdio_mdc,
  mdio_mdio,
  phy_rst_n,
  phy_rx_p,
  phy_rx_n,
  phy_tx_p,
  phy_tx_n,

  fan_pwm,
  pwr_good,

  gpio_led,
  gpio_sw,

  iic_rstn,
  iic_scl,
  iic_sda,

  hdmi_out_clk,
  hdmi_hsync,
  hdmi_vsync,
  hdmi_data_e,
  hdmi_data,

  spdif,

  rx_ref_clk_p,
  rx_ref_clk_n,
  rx_sysref_p,
  rx_sysref_n,
  rx_sync_p,
  rx_sync_n,
  rx_data_p,
  rx_data_n,
  
  tx_ref_clk_p,
  tx_ref_clk_n,
  tx_sysref_p,
  tx_sysref_n,
  tx_sync_p,
  tx_sync_n,
  tx_data_p,
  tx_data_n,
  
  adc_fdb,
  adc_fda,
  dac_irq,
  clkd_status,
  
  adc_pd,
  dac_txen,
  dac_reset,
  clkd_pd,
  clkd_sync,
  clkd_reset,
 
  spi_csn_clk,
  spi_csn_dac,
  spi_csn_adc,
  spi_clk,
  spi_sdio);

  input           sys_rst;
  input           sys_clk_p;
  input           sys_clk_n;
  input           sys_125m_clk_p;
  input           sys_125m_clk_n;

  input           uart_sin;
  output          uart_sout;

  output          ddr4_act_n;
  output  [16:0]  ddr4_addr;
  output  [ 1:0]  ddr4_ba;
  output  [ 0:0]  ddr4_bg;
  output          ddr4_ck_p;
  output          ddr4_ck_n;
  output  [ 0:0]  ddr4_cke;
  output  [ 0:0]  ddr4_cs_n;
  inout   [ 7:0]  ddr4_dm_n;
  inout   [63:0]  ddr4_dq;
  inout   [ 7:0]  ddr4_dqs_p;
  inout   [ 7:0]  ddr4_dqs_n;
  output  [ 0:0]  ddr4_odt;
  output          ddr4_par;
  output          ddr4_reset_n;

  output          mdio_mdc;
  inout           mdio_mdio;
  output          phy_rst_n;
  input           phy_rx_p;
  input           phy_rx_n;
  output          phy_tx_p;
  output          phy_tx_n;

  output          fan_pwm;
  output          pwr_good;

  inout   [ 7:0]  gpio_led;
  inout   [ 8:0]  gpio_sw;

  output          iic_rstn;
  inout           iic_scl;
  inout           iic_sda;

  output          hdmi_out_clk;
  output          hdmi_hsync;
  output          hdmi_vsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;

  output          spdif;

  input           rx_ref_clk_p;
  input           rx_ref_clk_n;
  input           rx_sysref_p;
  input           rx_sysref_n;
  output          rx_sync_p;
  output          rx_sync_n;
  input   [ 3:0]  rx_data_p;
  input   [ 3:0]  rx_data_n;
  
  input           tx_ref_clk_p;
  input           tx_ref_clk_n;
  input           tx_sysref_p;
  input           tx_sysref_n;
  input           tx_sync_p;
  input           tx_sync_n;
  output  [ 3:0]  tx_data_p;
  output  [ 3:0]  tx_data_n;
  
  inout           adc_fdb;
  inout           adc_fda;
  inout           dac_irq;
  inout   [ 1:0]  clkd_status;
  
  inout           adc_pd;
  inout           dac_txen;
  inout           dac_reset;
  inout           clkd_pd;
  inout           clkd_sync;
  inout           clkd_reset;
  
  output          spi_csn_clk;
  output          spi_csn_dac;
  output          spi_csn_adc;
  output          spi_clk;
  inout           spi_sdio;
  
  // internal registers

  reg     [31:0]  sys_reset_m = 'd0;
  reg             sys_cpu_rst = 'd0;
  reg             sys_cpu_rstn = 'd0;

  // internal signals

  wire            mdm_reset;
  wire            mig_reset;
  wire            mig_ready;
  wire            sys_cpu_clk;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire            tx_sync;
  wire    [ 2:0]  spi_csn;
  wire            spi_mosi;
  wire            spi_miso;
  wire    [ 5:0]  gpio_ctl_i;
  wire    [ 5:0]  gpio_ctl_o;
  wire    [ 5:0]  gpio_ctl_t;
  wire    [ 4:0]  gpio_status_i;
  wire    [ 4:0]  gpio_status_o;
  wire    [ 4:0]  gpio_status_t;

  // assignments

  assign spi_csn_adc = spi_csn[2];
  assign spi_csn_dac = spi_csn[1];
  assign spi_csn_clk = spi_csn[0];

  // default logic

  assign fan_pwm = 1'b1;
  assign pwr_good = 1'b1;

  // assign sys_reset_req = mdm_reset | mig_reset | ~mig_ready;
  // assign sys_reset_req = mdm_reset;
  assign sys_reset_req = 1'b0;

  always @(posedge sys_cpu_clk) begin
    if (sys_reset_req == 1'b1) begin
      sys_reset_m <= {32{1'b1}};
    end else begin
      sys_reset_m <= {sys_reset_m[30:0], 1'b0};
    end
    sys_cpu_rst <= sys_reset_m[31];
    sys_cpu_rstn <= ~sys_reset_m[31];
  end

  // instantiations

  IBUFDS_GTE3 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS_GTE3 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  daq2_spi i_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  IOBUF i_iobuf_gpio_adc_pd (
    .I (gpio_ctl_o[5]),
    .O (gpio_ctl_i[5]),
    .T (gpio_ctl_t[5]),
    .IO (adc_pd));

  IOBUF i_iobuf_gpio_dac_txen (
    .I (gpio_ctl_o[4]),
    .O (gpio_ctl_i[4]),
    .T (gpio_ctl_t[4]),
    .IO (dac_txen));

  IOBUF i_iobuf_gpio_dac_reset (
    .I (gpio_ctl_o[3]),
    .O (gpio_ctl_i[3]),
    .T (gpio_ctl_t[3]),
    .IO (dac_reset));

  IOBUF i_iobuf_gpio_clkd_pd (
    .I (gpio_ctl_o[2]),
    .O (gpio_ctl_i[2]),
    .T (gpio_ctl_t[2]),
    .IO (clkd_pd));

  IOBUF i_iobuf_gpio_clkd_sync (
    .I (gpio_ctl_o[1]),
    .O (gpio_ctl_i[1]),
    .T (gpio_ctl_t[1]),
    .IO (clkd_sync));

  IOBUF i_iobuf_gpio_clkd_reset (
    .I (gpio_ctl_o[0]),
    .O (gpio_ctl_i[0]),
    .T (gpio_ctl_t[0]),
    .IO (clkd_reset));

  IOBUF i_iobuf_gpio_adc_fdb (
    .I (gpio_status_o[4]),
    .O (gpio_status_i[4]),
    .T (gpio_status_t[4]),
    .IO (adc_fdb));

  IOBUF i_iobuf_gpio_adc_fda (
    .I (gpio_status_o[3]),
    .O (gpio_status_i[3]),
    .T (gpio_status_t[3]),
    .IO (adc_fda));

  IOBUF i_iobuf_gpio_dac_irq (
    .I (gpio_status_o[2]),
    .O (gpio_status_i[2]),
    .T (gpio_status_t[2]),
    .IO (dac_irq));

  IOBUF i_iobuf_gpio_clkd_status_1 (
    .I (gpio_status_o[1]),
    .O (gpio_status_i[1]),
    .T (gpio_status_t[1]),
    .IO (clkd_status[1]));

  IOBUF i_iobuf_gpio_clkd_status_0 (
    .I (gpio_status_o[0]),
    .O (gpio_status_i[0]),
    .T (gpio_status_t[0]),
    .IO (clkd_status[0]));

  system_wrapper i_system_wrapper (
    .c0_ddr4_act_n (ddr4_act_n),
    .c0_ddr4_adr (ddr4_addr),
    .c0_ddr4_ba (ddr4_ba),
    .c0_ddr4_bg (ddr4_bg),
    .c0_ddr4_ck_c (ddr4_ck_n),
    .c0_ddr4_ck_t (ddr4_ck_p),
    .c0_ddr4_cke (ddr4_cke),
    .c0_ddr4_cs_n (ddr4_cs_n),
    .c0_ddr4_dm_n (ddr4_dm_n),
    .c0_ddr4_dq (ddr4_dq),
    .c0_ddr4_dqs_c (ddr4_dqs_n),
    .c0_ddr4_dqs_t (ddr4_dqs_p),
    .c0_ddr4_odt (ddr4_odt),
    .c0_ddr4_par (ddr4_par),
    .c0_ddr4_reset_n (ddr4_reset_n),
    .gpio_ctl_i (gpio_ctl_i),
    .gpio_ctl_o (gpio_ctl_o),
    .gpio_ctl_t (gpio_ctl_t),
    .gpio_lcd_tri_io (),
    .gpio_led_tri_io (gpio_led),
    .gpio_status_i (gpio_status_i),
    .gpio_status_o (gpio_status_o),
    .gpio_status_t (gpio_status_t),
    .gpio_sw_tri_io (gpio_sw),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .iic_rstn (iic_rstn),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .mdm_reset (mdm_reset),
    .mig_ready (mig_ready),
    .mig_reset (mig_reset),
    .phy_rst_n (phy_rst_n),
    .phy_sd (1'b1),
    .sgmii_rxn (phy_rx_n),
    .sgmii_rxp (phy_rx_p),
    .sgmii_txn (phy_tx_n),
    .sgmii_txp (phy_tx_p),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .spdif (spdif),
    .sys_125m_clk_n (sys_125m_clk_n),
    .sys_125m_clk_p (sys_125m_clk_p),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_cpu_clk (sys_cpu_clk),
    .sys_cpu_rst (sys_cpu_rst),
    .sys_cpu_rstn (sys_cpu_rstn),
    .sys_rst (sys_rst),
    .tx_data_n (tx_data_n),
    .tx_data_p (tx_data_p),
    .tx_ref_clk (tx_ref_clk),
    .tx_sync (tx_sync),
    .tx_sysref (tx_sysref),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .unc_int4 (1'b0));

endmodule

// ***************************************************************************
// ***************************************************************************
