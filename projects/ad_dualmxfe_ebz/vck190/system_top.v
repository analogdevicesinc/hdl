// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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

module system_top  #(
  parameter TX_JESD_L = 4,
  parameter TX_NUM_LINKS = 1,
  parameter RX_JESD_L = 4,
  parameter RX_NUM_LINKS = 1,
  parameter JESD_MODE = "8B10B",
  parameter GENERATE_LINK_CLK = 1
) (
  //input         sys_clk_n,
  //input         sys_clk_p,
  //output        ddr4_act_n,
  //output [16:0] ddr4_adr,
  //output  [1:0] ddr4_ba,
  //output  [1:0] ddr4_bg,
  //output        ddr4_ck_c,
  //output        ddr4_ck_t,
  //output        ddr4_cke,
  //output        ddr4_cs_n,
  //inout   [7:0] ddr4_dm_n,
  //inout  [63:0] ddr4_dq,
  //inout   [7:0] ddr4_dqs_c,
  //inout   [7:0] ddr4_dqs_t,
  //output        ddr4_odt,
  //output        ddr4_reset_n,
  //// GPIOs
  //output  [3:0] gpio_led,
  //input   [3:0] gpio_dip_sw,
  //input   [1:0] gpio_pb,

  // dual_mxfe specific

  output        fpga_vadj,
  output        fan_pwm,
  output        fmc_fan_tach,

  output        adf4377_ce,
  output        adf4377_csb,
  output        adf4377_enclk1,
  output        adf4377_enclk2,
  output        adf4377_sclk,
  output        adf4377_sdio,
  input         adf4377_sdo,

  // reference clock
  input         fpga_clk0_p,
  input         fpga_clk0_n,

  // was forgotten
  input         fpga_clk1_p,
  input         fpga_clk1_n,

  // rx_device_clk
  input         fpga_clk2_p,
  input         fpga_clk2_n,

  // tx_device_clk
  input         fpga_clk3_p,
  input         fpga_clk3_n,

  // unused so far
  input         fpga_clk4_p,
  input         fpga_clk4_n,

  // sysref for mxfe0
  input         fpga_sysref0_p,
  input         fpga_sysref0_n,

  // sysref for mxfe1
  input         fpga_sysref1_p,
  input         fpga_sysref1_n,

  input  [RX_JESD_L-1:0] serdes0_m2c_p,
  input  [RX_JESD_L-1:0] serdes0_m2c_n,

  output [TX_JESD_L-1:0] serdes0_c2m_p,
  output [TX_JESD_L-1:0] serdes0_c2m_n,

  input  [RX_JESD_L-1:0] serdes1_m2c_p,
  input  [RX_JESD_L-1:0] serdes1_m2c_n,

  output [TX_JESD_L-1:0] serdes1_c2m_p,
  output [TX_JESD_L-1:0] serdes1_c2m_n,

  // mxfe0_sync signals

  output mxfe0_syncin_p_0,
  output mxfe0_syncin_n_0,
  output fmc_mxfe0_syncin_p_1,

  input mxfe0_syncout_p_0,
  input mxfe0_syncout_n_0,
  input fmc_mxfe0_syncout_p_1,

  // mxfe1_sync signals

  output mxfe1_syncin_p_0,
  output mxfe1_syncin_n_1,
  output fmc_mxfe1_syncin_p_1,

  input mxfe1_syncout_p_0,
  input mxfe1_syncout_n_1,
  input fmc_mxfe1_syncout_p_1,

  output  [8:0] mxfe0_gpio,

  output  [8:0] mxfe1_gpio,

  output        hmc7044_reset,
  output        hmc7044_sclk,
  output        hmc7044_slen,
  input         hmc7044_miso,
  output        hmc7044_mosi,

  input         m0_irq,
  input         m1_irq,

  output  [1:0] mxfe_sclk,
  output  [1:0] mxfe_cs,
  input   [1:0] mxfe_miso,
  output  [1:0] mxfe_mosi,

  output  [1:0] mxfe_reset,
  output  [1:0] mxfe_rx_en0,
  output  [1:0] mxfe_rx_en1,
  output  [1:0] mxfe_tx_en0,
  output  [1:0] mxfe_tx_en1,

  output [22:0] gpio_fmcp_p,
  output [22:0] gpio_fmcp_n
);

  // internal signals

  wire    [95:0]  gpio_i;
  wire    [95:0]  gpio_o;
  wire    [95:0]  gpio_t;

  wire    [ 2:0]  spi0_csn;

  wire    [ 2:0]  spi1_csn;
  wire            spi1_mosi;
  wire            spi1_miso;

  wire            sysref;

  wire            tx_device_clk;
  wire            rx_device_clk;
  wire            link_clk;
  wire            rx_sysref;
  wire            tx_sysref;

  wire            gt_powergood;
  wire            ref_clk_odiv;

  // instantiations

  IBUFDS_GTE5 #(
    .REFCLK_HROW_CK_SEL (0)
  ) i_ibufds_ref_clk (
    .CEB (1'b0),
    .I (fpga_clk0_p),
    .IB (fpga_clk0_n),
    .O (ref_clk),
    .ODIV2 (ref_clk_odiv));

  // sysref

  IBUFDS i_ibufds_sysref0 (
    .I (fpga_sysref0_p),
    .IB (fpga_sysref0_n),
    .O (sysref0));

  IBUFDS i_ibufds_sysref1 (
    .I (fpga_sysref1_p),
    .IB (fpga_sysref1_n),
    .O (sysref1));

  // RX

  IBUFDS i_ibufds_rx_device_clk (
    .I (fpga_clk2_p),
    .IB (fpga_clk2_n),
    .O (fpga_clk2));

  BUFG i_rx_device_clk (
    .I (fpga_clk2),
    .O (rx_device_clk));

  // TX

  IBUFDS i_ibufds_tx_device_clk (
    .I (fpga_clk3_p),
    .IB (fpga_clk3_n),
    .O (fpga_clk3));

  BUFG i_tx_device_clk (
    .I (fpga_clk3),
    .O (tx_device_clk));

  // SYNCIN

  IBUFDS i_ibufds_mxfe0_syncin (
    .I (mxfe0_syncin_p_0),
    .IB (mxfe0_syncin_n_0),
    .O (mxfe0_syncin));

  IBUFDS i_ibufds_mxfe1_syncin (
    .I (mxfe1_syncin_p_1),
    .IB (mxfe1_syncin_n_1),
    .O (mxfe1_syncin));

  // SYNCOUT

  OBUFDS i_obufds_mxfe0_syncout (
    .I (mxfe0_syncout),
    .O (mxfe0_syncout_p_0),
    .OB (mxfe0_syncout_n_0));

  OBUFDS i_obufds_mxfe1_syncout (
    .I (mxfe1_syncout),
    .O (mxfe1_syncout_p_1),
    .OB (mxfe1_syncout_n_1));

  assign link_clk = (GENERATE_LINK_CLK == 0)? ref_clk_odiv : 1'b0;

  // spi

  assign spi0_csb   = spi0_csn[0];
  assign spi1_csb   = spi1_csn[0];

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_spi (
    .spi_csn (spi1_csn[0]),
    .spi_clk (spi1_sclk),
    .spi_mosi (spi1_mosi),
    .spi_miso (spi1_miso),
    .spi_sdio (spi1_sdio),
    .spi_dir ());

  // gpios

  ad_iobuf #(
    .DATA_WIDTH(12)
  ) i_iobuf (
    .dio_t (gpio_t[43:32]),
    .dio_i (gpio_o[43:32]),
    .dio_o (gpio_i[43:32]),
    .dio_p ({hmc_gpio1,       // 43
             gpio[10:0]}));   // 42-32

  assign gpio_i[44] = agc0[0];
  assign gpio_i[45] = agc0[1];
  assign gpio_i[46] = agc1[0];
  assign gpio_i[47] = agc1[1];
  assign gpio_i[48] = agc2[0];
  assign gpio_i[49] = agc2[1];
  assign gpio_i[50] = agc3[0];
  assign gpio_i[51] = agc3[1];
  assign gpio_i[52] = irqb[0];
  assign gpio_i[53] = irqb[1];

  assign hmc_sync   = gpio_o[54];
  assign rstb       = gpio_o[55];
  assign rxen[0]    = gpio_o[56];
  assign rxen[1]    = gpio_o[57];
  assign txen[0]    = gpio_o[58];
  assign txen[1]    = gpio_o[59];

  generate
  if (TX_NUM_LINKS > 1 & JESD_MODE == "8B10B") begin
    assign tx_syncin[1] = fpga_syncin_1_p;
  end else begin
    ad_iobuf #(
      .DATA_WIDTH(2)
    ) i_syncin_iobuf (
      .dio_t (gpio_t[61:60]),
      .dio_i (gpio_o[61:60]),
      .dio_o (gpio_i[61:60]),
      .dio_p ({fpga_syncin_1_n,      // 61
               fpga_syncin_1_p}));   // 60
  end

  if (RX_NUM_LINKS > 1 & JESD_MODE == "8B10B") begin
    assign fpga_syncout_1_p = rx_syncout[1];
    assign fpga_syncout_1_n = 0;
  end else begin
    ad_iobuf #(
      .DATA_WIDTH(2)
    ) i_syncout_iobuf (
      .dio_t (gpio_t[63:62]),
      .dio_i (gpio_o[63:62]),
      .dio_o (gpio_i[63:62]),
      .dio_p ({fpga_syncout_1_n,      // 63
               fpga_syncout_1_p}));   // 62
  end
  endgenerate

  /* Board GPIOS. Buttons, LEDs, etc... */
  assign gpio_led     = gpio_o[3:0];
  assign gpio_i[3:0]  = gpio_o[3:0];
  assign gpio_i[7: 4] = gpio_dip_sw;
  assign gpio_i[9: 8] = gpio_pb;

  // Unused GPIOs
  assign gpio_i[59:54] = gpio_o[59:54];
  assign gpio_i[94:64] = gpio_o[94:64];
  assign gpio_i[31:10] = gpio_o[31:10];

  system_wrapper i_system_wrapper (
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio2_i (gpio_i[95:64]),
    .gpio2_o (gpio_o[95:64]),
    .gpio2_t (gpio_t[95:64]),
    .ddr4_dimm1_sma_clk_clk_n (sys_clk_n),
    .ddr4_dimm1_sma_clk_clk_p (sys_clk_p),
    .ddr4_dimm1_act_n (ddr4_act_n),
    .ddr4_dimm1_adr (ddr4_adr),
    .ddr4_dimm1_ba (ddr4_ba),
    .ddr4_dimm1_bg (ddr4_bg),
    .ddr4_dimm1_ck_c (ddr4_ck_c),
    .ddr4_dimm1_ck_t (ddr4_ck_t),
    .ddr4_dimm1_cke (ddr4_cke),
    .ddr4_dimm1_cs_n (ddr4_cs_n),
    .ddr4_dimm1_dm_n (ddr4_dm_n),
    .ddr4_dimm1_dq (ddr4_dq),
    .ddr4_dimm1_dqs_c (ddr4_dqs_c),
    .ddr4_dimm1_dqs_t (ddr4_dqs_t),
    .ddr4_dimm1_odt (ddr4_odt),
    .ddr4_dimm1_reset_n (ddr4_reset_n),
    .spi0_csn  (spi0_csn),
    .spi0_miso (spi0_miso),
    .spi0_mosi (spi0_mosi),
    .spi0_sclk (spi0_sclk),
    .spi1_csn  (spi1_csn),
    .spi1_miso (spi1_miso),
    .spi1_mosi (spi1_mosi),
    .spi1_sclk (spi1_sclk),
    // FMC HPC
    .rx_0_p (rx_data_p_loc[3:0]),
    .rx_0_n (rx_data_n_loc[3:0]),
    .tx_0_p (tx_data_p_loc[3:0]),
    .tx_0_n (tx_data_n_loc[3:0]),
    .rx_1_p (rx_data_p_loc[7:4]),
    .rx_1_n (rx_data_n_loc[7:4]),
    .tx_1_p (tx_data_p_loc[7:4]),
    .tx_1_n (tx_data_n_loc[7:4]),

    .gt_powergood (gt_powergood),
    .gt_reset (~gt_powergood | ~rstb),
    .ref_clk_q0 (ref_clk),
    .ref_clk_q1 (ref_clk),
    .link_clk   (link_clk),

    .rx_device_clk (rx_device_clk),
    .tx_device_clk (tx_device_clk),
    .rx_sync_0 (rx_syncout),
    .tx_sync_0 (tx_syncin),
    .rx_sysref_0 (sysref),
    .tx_sysref_0 (sysref));

  // assign rx_data_p_loc[RX_JESD_L*RX_NUM_LINKS-1:0] = rx_data_p[RX_JESD_L*RX_NUM_LINKS-1:0];
  // assign rx_data_n_loc[RX_JESD_L*RX_NUM_LINKS-1:0] = rx_data_n[RX_JESD_L*RX_NUM_LINKS-1:0];

  // assign tx_data_p[TX_JESD_L*TX_NUM_LINKS-1:0] = tx_data_p_loc[TX_JESD_L*TX_NUM_LINKS-1:0];
  // assign tx_data_n[TX_JESD_L*TX_NUM_LINKS-1:0] = tx_data_n_loc[TX_JESD_L*TX_NUM_LINKS-1:0];

endmodule
