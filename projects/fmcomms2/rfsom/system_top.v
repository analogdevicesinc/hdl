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

  DDR_addr,
  DDR_ba,
  DDR_cas_n,
  DDR_ck_n,
  DDR_ck_p,
  DDR_cke,
  DDR_cs_n,
  DDR_dm,
  DDR_dq,
  DDR_dqs_n,
  DDR_dqs_p,
  DDR_odt,
  DDR_ras_n,
  DDR_reset_n,
  DDR_we_n,

  ETH1_MDC,
  ETH1_MDIO,
  ETH1_RGMII_rxclk,
  ETH1_RGMII_rxctl,
  ETH1_RGMII_rxdata,
  ETH1_RGMII_txclk,
  ETH1_RGMII_txctl,
  ETH1_RGMII_txdata,

  FIXED_IO_ddr_vrn,
  FIXED_IO_ddr_vrp,
  FIXED_IO_mio,
  FIXED_IO_ps_clk,
  FIXED_IO_ps_porb,
  FIXED_IO_ps_srstb,

  UART0_rxd,
  UART0_txd,

  hdmi_out_clk,
  hdmi_vsync,
  hdmi_hsync,
  hdmi_data_e,
  hdmi_data,

  spdif,

  i2s_mclk,
  i2s_bclk,
  i2s_lrclk,
  i2s_sdata_out,
  i2s_sdata_in,

  iic_scl,
  iic_sda,

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

  gpio_clksel,
  gpio_txnrx,
  gpio_enable,
  gpio_resetb,
  gpio_sync,
  gpio_en_agc,
  gpio_ctl,
  gpio_status,

  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso);


  inout   [14:0]  DDR_addr;
  inout   [ 2:0]  DDR_ba;
  inout           DDR_cas_n;
  inout           DDR_ck_n;
  inout           DDR_ck_p;
  inout           DDR_cke;
  inout           DDR_cs_n;
  inout   [ 3:0]  DDR_dm;
  inout   [31:0]  DDR_dq;
  inout   [ 3:0]  DDR_dqs_n;
  inout   [ 3:0]  DDR_dqs_p;
  inout           DDR_odt;
  inout           DDR_ras_n;
  inout           DDR_reset_n;
  inout           DDR_we_n;

  output          ETH1_MDC;
  inout           ETH1_MDIO;
  input           ETH1_RGMII_rxclk;
  input           ETH1_RGMII_rxctl;
  input   [ 3:0]  ETH1_RGMII_rxdata;
  output          ETH1_RGMII_txclk;
  output          ETH1_RGMII_txctl;
  output  [ 3:0]  ETH1_RGMII_txdata;

  inout           FIXED_IO_ddr_vrn;
  inout           FIXED_IO_ddr_vrp;
  inout   [53:0]  FIXED_IO_mio;
  inout           FIXED_IO_ps_clk;
  inout           FIXED_IO_ps_porb;
  inout           FIXED_IO_ps_srstb;

  input           UART0_rxd;
  output          UART0_txd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;

  output          spdif;

  output          i2s_mclk;
  output          i2s_bclk;
  output          i2s_lrclk;
  output          i2s_sdata_out;
  input           i2s_sdata_in;

  inout   [ 1:0]  iic_scl;
  inout   [ 1:0]  iic_sda;

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

  inout           gpio_clksel;
  inout           gpio_txnrx;
  inout           gpio_enable;
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

  wire    [49:0]  gpio_i;
  wire    [49:0]  gpio_o;
  wire    [49:0]  gpio_t;
  wire    [15:0]  ps_intrs;
  wire    [ 1:0]  iic_scl_i;
  wire    [ 1:0]  iic_scl_o;
  wire            iic_scl_t;
  wire    [ 1:0]  iic_sda_i;
  wire    [ 1:0]  iic_sda_o;
  wire            iic_sda_t;

  // instantiations

  ad_iobuf #(.DATA_WIDTH(18)) i_iobuf (
    .dt (gpio_t[49:32]),
    .di (gpio_o[49:32]),
    .do (gpio_i[49:32]),
    .dio({  gpio_clksel,
            gpio_txnrx,
            gpio_enable,
            gpio_resetb,
            gpio_sync,
            gpio_en_agc,
            gpio_ctl,
            gpio_status}));

  ad_iobuf #(.DATA_WIDTH(2)) i_iobuf_iic_scl (
    .dt ({iic_scl_t, iic_scl_t}),
    .di (iic_scl_o),
    .do (iic_scl_i),
    .dio(iic_scl));

  ad_iobuf #(.DATA_WIDTH(2)) i_iobuf_iic_sda (
    .dt ({iic_sda_t, iic_sda_t}),
    .di (iic_sda_o),
    .do (iic_sda_i),
    .dio(iic_sda));

  system_wrapper i_system_wrapper (
    .DDR_addr (DDR_addr),
    .DDR_ba (DDR_ba),
    .DDR_cas_n (DDR_cas_n),
    .DDR_ck_n (DDR_ck_n),
    .DDR_ck_p (DDR_ck_p),
    .DDR_cke (DDR_cke),
    .DDR_cs_n (DDR_cs_n),
    .DDR_dm (DDR_dm),
    .DDR_dq (DDR_dq),
    .DDR_dqs_n (DDR_dqs_n),
    .DDR_dqs_p (DDR_dqs_p),
    .DDR_odt (DDR_odt),
    .DDR_ras_n (DDR_ras_n),
    .DDR_reset_n (DDR_reset_n),
    .DDR_we_n (DDR_we_n),
    .ETH1_125MCLK (),
    .ETH1_25MCLK (),
    .ETH1_2M5CLK (),
    .ETH1_CLOCK_SPEED (),
    .ETH1_DUPLEX_STATUS (),
    .ETH1_INTN (1'b1),
    .ETH1_LINK_STATUS (),
    .ETH1_MDIO_mdc (ETH1_MDC),
    .ETH1_REFCLK (),
    .ETH1_RGMII_rd (ETH1_RGMII_rxdata),
    .ETH1_RGMII_rx_ctl (ETH1_RGMII_rxctl),
    .ETH1_RGMII_rxc (ETH1_RGMII_rxclk),
    .ETH1_RGMII_td (ETH1_RGMII_txdata),
    .ETH1_RGMII_tx_ctl (ETH1_RGMII_txctl),
    .ETH1_RGMII_txc (ETH1_RGMII_txclk),
    .ETH1_SPEED_MODE (),
    .FIXED_IO_ddr_vrn (FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp (FIXED_IO_ddr_vrp),
    .FIXED_IO_mio (FIXED_IO_mio),
    .FIXED_IO_ps_clk (FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb (FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb (FIXED_IO_ps_srstb),
    .GPIO_I (gpio_i),
    .GPIO_O (gpio_o),
    .GPIO_T (gpio_t),
    .UART_0_rxd (UART0_rxd),
    .UART_0_txd (UART0_txd),
    .ad9361_adc_dma_irq (ps_intrs[13]),
    .ad9361_dac_dma_irq (ps_intrs[12]),
    .eth1_mdio_mdio_io (ETH1_MDIO),
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
    .iic_mux_scl_I (iic_scl_i),
    .iic_mux_scl_O (iic_scl_o),
    .iic_mux_scl_T (iic_scl_t),
    .iic_mux_sda_I (iic_sda_i),
    .iic_mux_sda_O (iic_sda_o),
    .iic_mux_sda_T (iic_sda_t),
    .otg_vbusoc (1'b0),
    .ps_intr_0 (ps_intrs[0]),
    .ps_intr_1 (ps_intrs[1]),
    .ps_intr_10 (ps_intrs[10]),
    .ps_intr_11 (ps_intrs[11]),
    .ps_intr_12 (ps_intrs[12]),
    .ps_intr_13 (ps_intrs[13]),
    .ps_intr_2 (ps_intrs[2]),
    .ps_intr_3 (ps_intrs[3]),
    .ps_intr_4 (ps_intrs[4]),
    .ps_intr_5 (ps_intrs[5]),
    .ps_intr_6 (ps_intrs[6]),
    .ps_intr_7 (ps_intrs[7]),
    .ps_intr_8 (ps_intrs[8]),
    .ps_intr_9 (ps_intrs[9]),
    .rx_clk_in_n (rx_clk_in_n),
    .rx_clk_in_p (rx_clk_in_p),
    .rx_data_in_n (rx_data_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .spdif (spdif),
    .spi_csn_i (1'b1),
    .spi_csn_o (spi_csn),
    .spi_miso_i (spi_miso),
    .spi_mosi_i (1'b0),
    .spi_mosi_o (spi_mosi),
    .spi_sclk_i (1'b0),
    .spi_sclk_o (spi_clk),
    .spi_udc_clk_i (1'b0),
    .spi_udc_clk_o (),
    .spi_udc_csn_i (1'b1),
    .spi_udc_csn_rx_o (),
    .spi_udc_csn_tx_o (),
    .spi_udc_miso_i (1'b0),
    .spi_udc_mosi_i (1'b0),
    .spi_udc_mosi_o (),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_data_out_n (tx_data_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_frame_out_p (tx_frame_out_p));

endmodule

// ***************************************************************************
// ***************************************************************************
