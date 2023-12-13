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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top  #(
  parameter RX_JESD_L = 8,
  parameter RX_NUM_LINKS = 1,
  parameter JESD_MODE = "64B66B"
) (
  input                                 sys_clk_n,
  input                                 sys_clk_p,
  output                                ddr4_act_n,
  output  [16:0]                        ddr4_adr,
  output  [ 1:0]                        ddr4_ba,
  output  [ 1:0]                        ddr4_bg,
  output                                ddr4_ck_c,
  output                                ddr4_ck_t,
  output                                ddr4_cke,
  output                                ddr4_cs_n,
  inout   [ 7:0]                        ddr4_dm_n,
  inout   [63:0]                        ddr4_dq,
  inout   [ 7:0]                        ddr4_dqs_c,
  inout   [ 7:0]                        ddr4_dqs_t,
  output                                ddr4_odt,
  output                                ddr4_reset_n,
  // GPIOs
  output  [ 3:0]                        gpio_led,
  input   [ 3:0]                        gpio_dip_sw,
  input   [ 1:0]                        gpio_pb,

  // FMC HPC IOs
  input   [ 1:0]                        agc0,
  input   [ 1:0]                        agc1,
  input   [ 1:0]                        agc2,
  input   [ 1:0]                        agc3,
  input                                 clkin10_n,
  input                                 clkin10_p,
  input                                 fpga_refclk_in_n,
  input                                 fpga_refclk_in_p,
  input   [RX_JESD_L*RX_NUM_LINKS-1:0]  rx_data_n,
  input   [RX_JESD_L*RX_NUM_LINKS-1:0]  rx_data_p,
  output                                fpga_syncout_0_n,
  output                                fpga_syncout_0_p,
  inout                                 fpga_syncout_1_n,
  inout                                 fpga_syncout_1_p,
  inout   [10:0]                        gpio,
  inout                                 hmc_gpio1,
  output                                hmc_sync,
  input   [ 1:0]                        irqb,
  output                                rstb,
  output  [ 1:0]                        rxen,
  output                                spi0_csb,
  input                                 spi0_miso,
  output                                spi0_mosi,
  output                                spi0_sclk,
  output                                spi1_csb,
  output                                spi1_sclk,
  inout                                 spi1_sdio,
  input                                 sysref2_n,
  input                                 sysref2_p
);

  // internal signals

  wire  [95:0]              gpio_i;
  wire  [95:0]              gpio_o;
  wire  [95:0]              gpio_t;

  wire  [ 2:0]              spi0_csn;

  wire  [ 2:0]              spi1_csn;
  wire                      spi1_mosi;
  wire                      spi1_miso;

  wire                      sysref;
  wire  [RX_NUM_LINKS-1:0]  rx_syncout;

  wire  [ 7:0]              rx_data_p_loc;
  wire  [ 7:0]              rx_data_n_loc;

  wire                      clkin10;
  wire                      rx_device_clk;

  // instantiations
  IBUFDS_GTE5 i_ibufds_ref_clk (
    .CEB (1'd0),
    .I (fpga_refclk_in_p),
    .IB (fpga_refclk_in_n),
    .O (ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_sysref (
    .I (sysref2_p),
    .IB (sysref2_n),
    .O (sysref));

  IBUFDS i_ibufds_rx_device_clk (
    .I (clkin10_p),
    .IB (clkin10_n),
    .O (clkin10));

  OBUFDS i_obufds_syncout_0 (
    .I (rx_syncout[0]),
    .O (fpga_syncout_0_p),
    .OB (fpga_syncout_0_n));

  BUFG i_rx_device_clk (
    .I (clkin10),
    .O (rx_device_clk));

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

  generate
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
  assign gpio_led = gpio_o[3:0];
  assign gpio_i[3:0] = gpio_o[3:0];
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
    .spi0_csn (spi0_csn),
    .spi0_miso (spi0_miso),
    .spi0_mosi (spi0_mosi),
    .spi0_sclk (spi0_sclk),
    .spi1_csn (spi1_csn),
    .spi1_miso (spi1_miso),
    .spi1_mosi (spi1_mosi),
    .spi1_sclk (spi1_sclk),
    // FMC HPC
    .GT_Serial_0_0_grx_p (rx_data_p_loc[3:0]),
    .GT_Serial_0_0_grx_n (rx_data_n_loc[3:0]),
    .GT_Serial_1_0_grx_p (rx_data_p_loc[7:4]),
    .GT_Serial_1_0_grx_n (rx_data_n_loc[7:4]),

    .gt_reset (~rstb),
    .ref_clk_q0 (ref_clk),
    .ref_clk_q1 (ref_clk),

    .rx_device_clk (rx_device_clk),
    .rx_sync_0 (rx_syncout),
    .rx_sysref_0 (sysref));

  assign rx_data_p_loc[RX_JESD_L*RX_NUM_LINKS-1:0] = rx_data_p[RX_JESD_L*RX_NUM_LINKS-1:0];
  assign rx_data_n_loc[RX_JESD_L*RX_NUM_LINKS-1:0] = rx_data_n[RX_JESD_L*RX_NUM_LINKS-1:0];

endmodule
