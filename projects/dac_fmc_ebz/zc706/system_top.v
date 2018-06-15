// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
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

module system_top #(
    parameter JESD_L = 4,
    parameter NUM_LINKS = 2,
    parameter DEVICE_CODE = 0
  ) (

  inout       [14:0]      ddr_addr,
  inout       [ 2:0]      ddr_ba,
  inout                   ddr_cas_n,
  inout                   ddr_ck_n,
  inout                   ddr_ck_p,
  inout                   ddr_cke,
  inout                   ddr_cs_n,
  inout       [ 3:0]      ddr_dm,
  inout       [31:0]      ddr_dq,
  inout       [ 3:0]      ddr_dqs_n,
  inout       [ 3:0]      ddr_dqs_p,
  inout                   ddr_odt,
  inout                   ddr_ras_n,
  inout                   ddr_reset_n,
  inout                   ddr_we_n,

  inout                   fixed_io_ddr_vrn,
  inout                   fixed_io_ddr_vrp,
  inout       [53:0]      fixed_io_mio,
  inout                   fixed_io_ps_clk,
  inout                   fixed_io_ps_porb,
  inout                   fixed_io_ps_srstb,

  inout       [14:0]      gpio_bd,

  output                  hdmi_out_clk,
  output                  hdmi_vsync,
  output                  hdmi_hsync,
  output                  hdmi_data_e,
  output      [23:0]      hdmi_data,

  output                  spdif,

  inout                   iic_scl,
  inout                   iic_sda,

  input                   tx_ref_clk_p,
  input                   tx_ref_clk_n,
  input                   tx_sysref_p,
  input                   tx_sysref_n,
  input       [ 1:0]      tx_sync_p,
  input       [ 1:0]      tx_sync_n,
  output      [JESD_L*NUM_LINKS-1:0] tx_data_p,
  output      [JESD_L*NUM_LINKS-1:0] tx_data_n,

  inout       [ 4:0]      dac_ctrl,

  inout                   spi_en,
  output                  spi_csn_dac,
  output                  spi_csn_clk,
  output                  spi_csn_clk2,
  output                  spi_clk,
  input                   spi_miso,
  output                  spi_mosi,

  output                  pmod_spi_clk,
  output                  pmod_spi_csn,
  output                  pmod_spi_mosi,
  input                   pmod_spi_miso,
  inout       [ 3:0]      pmod_gpio
  );

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 2:0]  spi0_csn;
  wire    [ 2:0]  spi1_csn;
  wire            spi1_clk;
  wire            spi1_mosi;
  wire            spi1_miso;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire    [ 1:0]  tx_sync;
  wire    [ 7:0]  tx_data_p_loc;
  wire    [ 7:0]  tx_data_n_loc;
  wire            tx_sysref_loc;

  // spi

  // spi_en is active ...
  //   ... high for AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ,
  //   ... low for AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
  // If you are planning to build a bitstream for just one of those boards you
  // can hardwire the logic level here.
  //
  // assign spi_en = 1'bz;

  //                                        9135/9144/9172    916(1,2,3,4)
  assign spi_csn_dac  = spi0_csn[1];
  assign spi_csn_clk  = spi0_csn[0];    //   HMC7044          AD9508
  assign spi_csn_clk2 = spi0_csn[2];    //   NC               ADF4355

  /* JESD204 clocks and control signals */
  IBUFDS_GTE2 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ()
  );

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref)
  );

  IBUFDS i_ibufds_tx_sync_0 (
    .I (tx_sync_p[0]),
    .IB (tx_sync_n[0]),
    .O (tx_sync[0])
  );

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_p[1]),
    .IB (tx_sync_n[1]),
    .O (tx_sync[1])
  );

  /* FMC GPIOs */
  ad_iobuf #(
    .DATA_WIDTH(6)
  ) i_iobuf (
    .dio_t (gpio_t[21+:6]),
    .dio_i (gpio_o[21+:6]),
    .dio_o (gpio_i[21+:6]),
    .dio_p ({
      spi_en,            /*      26 */
      dac_ctrl           /* 25 - 21 */
    })
  );

  /*
  * Control signals for different FMC boards:
  *
  * dac_ctrl  FMC   9144 like    9162 like       9172 like
  *        0  H13   FMC_TXEN_0   FMC_TXEN_0      FMC_PE_CTRL
  *        1  C10   NC           NC              FMC_TXEN_0
  *        2  C11   NC           NC              FMC_TXEN_1
  *        3  H14   FMC_TXEN_1   NC              NC
  *        4  D15   NC           FMC_HMC849VCTL  NC          
  */

  assign dac_fifo_bypass = gpio_o[40];

  /* PMOD GPIOs 48-51 */
  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_iobuf_pmod (
    .dio_t (gpio_t[48+:4]),
    .dio_i (gpio_o[48+:4]),
    .dio_o (gpio_i[48+:4]),
    .dio_p (pmod_gpio)
  );

  /* PMOD SPI */
  assign pmod_spi_clk = spi1_clk;
  assign pmod_spi_csn = spi1_csn[0];
  assign pmod_spi_mosi = spi1_mosi;
  assign spi1_miso = pmod_spi_miso;

  /* Board GPIOS. Buttons, LEDs, etc... */
  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_bd (
    .dio_t (gpio_t[0+:15]),
    .dio_i (gpio_o[0+:15]),
    .dio_o (gpio_i[0+:15]),
    .dio_p (gpio_bd)
  );

  assign gpio_i[63:52] = gpio_o[63:52];
  assign gpio_i[47:27] = gpio_o[47:27];
  assign gpio_i[20:15] = gpio_o[20:15];

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
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .spdif (spdif),
    .spi0_clk_i (spi_clk),
    .spi0_clk_o (spi_clk),
    .spi0_csn_0_o (spi0_csn[0]),
    .spi0_csn_1_o (spi0_csn[1]),
    .spi0_csn_2_o (spi0_csn[2]),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi_miso),
    .spi0_sdo_i (spi_mosi),
    .spi0_sdo_o (spi_mosi),
    .spi1_clk_i (spi1_clk),
    .spi1_clk_o (spi1_clk),
    .spi1_csn_0_o (spi1_csn[0]),
    .spi1_csn_1_o (spi1_csn[1]),
    .spi1_csn_2_o (spi1_csn[2]),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (spi1_miso),
    .spi1_sdo_i (spi1_mosi),
    .spi1_sdo_o (spi1_mosi),
    .tx_data_0_n (tx_data_n_loc[0]),
    .tx_data_0_p (tx_data_p_loc[0]),
    .tx_data_1_n (tx_data_n_loc[1]),
    .tx_data_1_p (tx_data_p_loc[1]),
    .tx_data_2_n (tx_data_n_loc[2]),
    .tx_data_2_p (tx_data_p_loc[2]),
    .tx_data_3_n (tx_data_n_loc[3]),
    .tx_data_3_p (tx_data_p_loc[3]),
    .tx_data_4_n (tx_data_n_loc[4]),
    .tx_data_4_p (tx_data_p_loc[4]),
    .tx_data_5_n (tx_data_n_loc[5]),
    .tx_data_5_p (tx_data_p_loc[5]),
    .tx_data_6_n (tx_data_n_loc[6]),
    .tx_data_6_p (tx_data_p_loc[6]),
    .tx_data_7_n (tx_data_n_loc[7]),
    .tx_data_7_p (tx_data_p_loc[7]),
    .tx_ref_clk (tx_ref_clk),
    .tx_sync_0 (tx_sync[NUM_LINKS-1:0]),
    .tx_sysref_0 (tx_sysref_loc),
    .dac_fifo_bypass (dac_fifo_bypass));

  assign tx_data_p[JESD_L*NUM_LINKS-1:0] = tx_data_p_loc[JESD_L*NUM_LINKS-1:0];
  assign tx_data_n[JESD_L*NUM_LINKS-1:0] = tx_data_n_loc[JESD_L*NUM_LINKS-1:0];

  // AD9161/2/4-FMC-EBZ works only in single link,
  // The FMC connector instead of SYNC1 has SYSREF connected to it
  assign tx_sysref_loc = (DEVICE_CODE == 3) ? tx_sync[1] : tx_sysref;

endmodule
