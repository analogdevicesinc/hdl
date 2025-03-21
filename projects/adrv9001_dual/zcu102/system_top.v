// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
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

module system_top (

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  inout                   iic_scl,
  inout                   iic_sda,

  inout                   adrv1_dgpio_0,
  inout                   adrv1_dgpio_1,
  inout                   adrv1_dgpio_2,
  inout                   adrv1_dgpio_3,
  inout                   adrv1_dgpio_4,
  inout                   adrv1_dgpio_5,
  inout                   adrv1_dgpio_6,
  inout                   adrv1_dgpio_7,
  inout                   adrv1_dgpio_8,
  inout                   adrv1_dgpio_9,
  inout                   adrv1_dgpio_10,
  inout                   adrv1_dgpio_11,

  inout                   adrv1_gp_int,
  inout                   adrv1_mode,
  inout                   adrv1_reset_trx,

  inout                   adrv1_sm_fan_tach,
  //inout                   adrv1_tdd_sync,

  inout                   adrv2_dgpio_0,
  inout                   adrv2_dgpio_1,
  inout                   adrv2_dgpio_2,
  inout                   adrv2_dgpio_3,
  inout                   adrv2_dgpio_4,
  inout                   adrv2_dgpio_5,
  inout                   adrv2_dgpio_6,
  inout                   adrv2_dgpio_7,
  inout                   adrv2_dgpio_8,
  inout                   adrv2_dgpio_9,
  inout                   adrv2_dgpio_10,
  inout                   adrv2_dgpio_11,

  inout                   adrv2_gp_int,
  inout                   adrv2_mode,
  inout                   adrv2_reset_trx,

  inout                   adrv2_sm_fan_tach,
  //inout                   adrv2_tdd_sync,

  input                   adrv1_vadj_err,
  output                  adrv1_platform_status,


  input                   adrv1_fpga_mcs_in_n,
  input                   adrv1_fpga_mcs_in_p,
  output                  adrv1_dev_mcs_fpga_out_n,
  output                  adrv1_dev_mcs_fpga_out_p,
  output                  adrv2_dev_mcs_fpga_out_n,
  output                  adrv2_dev_mcs_fpga_out_p,

  // Device clock
  input                   adrv1_fpga_ref_clk_n,
  input                   adrv1_fpga_ref_clk_p,
  input                   adrv2_fpga_ref_clk_n,
  input                   adrv2_fpga_ref_clk_p,

  input                   adrv1_reset_n,
  input                   adrv1_rx1_dclk_out_n,
  input                   adrv1_rx1_dclk_out_p,
  input                   adrv1_rx1_strobe_out_n,
  input                   adrv1_rx1_strobe_out_p,
  input                   adrv1_rx1_idata_out_n,
  input                   adrv1_rx1_idata_out_p,
  input                   adrv1_rx1_qdata_out_n,
  input                   adrv1_rx1_qdata_out_p,
  input                   adrv2_rx1_dclk_out_n,
  input                   adrv2_rx1_dclk_out_p,
  input                   adrv2_rx1_strobe_out_n,
  input                   adrv2_rx1_strobe_out_p,
  input                   adrv2_rx1_idata_out_n,
  input                   adrv2_rx1_idata_out_p,
  input                   adrv2_rx1_qdata_out_n,
  input                   adrv2_rx1_qdata_out_p,
  input                   adrv2_reset_n,

  input                   adrv1_tx1_dclk_out_n,
  input                   adrv1_tx1_dclk_out_p,
  output                  adrv1_tx1_strobe_in_n,
  output                  adrv1_tx1_strobe_in_p,
  output                  adrv1_tx1_idata_in_n,
  output                  adrv1_tx1_idata_in_p,
  output                  adrv1_tx1_qdata_in_n,
  output                  adrv1_tx1_qdata_in_p,
  output                  adrv1_tx1_dclk_in_n,
  output                  adrv1_tx1_dclk_in_p,
  input                   adrv2_tx1_dclk_out_n,
  input                   adrv2_tx1_dclk_out_p,
  output                  adrv2_tx1_strobe_in_n,
  output                  adrv2_tx1_strobe_in_p,
  output                  adrv2_tx1_idata_in_n,
  output                  adrv2_tx1_idata_in_p,
  output                  adrv2_tx1_qdata_in_n,
  output                  adrv2_tx1_qdata_in_p,
  output                  adrv2_tx1_dclk_in_n,
  output                  adrv2_tx1_dclk_in_p,

  input                   adrv1_devclk_out,
  input                   adrv1_rx2_dclk_out_n,
  input                   adrv1_rx2_dclk_out_p,
  input                   adrv1_rx2_strobe_out_n,
  input                   adrv1_rx2_strobe_out_p,
  input                   adrv1_rx2_idata_out_n,
  input                   adrv1_rx2_idata_out_p,
  input                   adrv1_rx2_qdata_out_n,
  input                   adrv1_rx2_qdata_out_p,
  input                   adrv2_rx2_dclk_out_n,
  input                   adrv2_rx2_dclk_out_p,
  input                   adrv2_rx2_strobe_out_n,
  input                   adrv2_rx2_strobe_out_p,
  input                   adrv2_rx2_idata_out_n,
  input                   adrv2_rx2_idata_out_p,
  input                   adrv2_rx2_qdata_out_n,
  input                   adrv2_rx2_qdata_out_p,

  input                   adrv1_tx2_dclk_out_n,
  input                   adrv1_tx2_dclk_out_p,
  output                  adrv1_tx2_strobe_in_n,
  output                  adrv1_tx2_strobe_in_p,
  output                  adrv1_tx2_idata_in_n,
  output                  adrv1_tx2_idata_in_p,
  output                  adrv1_tx2_qdata_in_n,
  output                  adrv1_tx2_qdata_in_p,
  output                  adrv1_tx2_dclk_in_n,
  output                  adrv1_tx2_dclk_in_p,
  input                   adrv2_tx2_dclk_out_n,
  input                   adrv2_tx2_dclk_out_p,
  output                  adrv2_tx2_strobe_in_n,
  output                  adrv2_tx2_strobe_in_p,
  output                  adrv2_tx2_idata_in_n,
  output                  adrv2_tx2_idata_in_p,
  output                  adrv2_tx2_qdata_in_n,
  output                  adrv2_tx2_qdata_in_p,
  output                  adrv2_tx2_dclk_in_n,
  output                  adrv2_tx2_dclk_in_p,

  output                  adrv1_spi_en,
  output                  adrv1_spi_clk,
  output                  adrv1_spi_dio,
  input                   adrv1_spi_do,
  output                  adrv1_tx2_en,
  output                  adrv1_tx1_en,
  output                  adrv1_rx2_en,
  output                  adrv1_rx1_en,

  output                  adrv2_spi_en,
  output                  adrv2_spi_clk,
  output                  adrv2_spi_dio,
  input                   adrv2_spi_do,
  output                  adrv2_tx2_en,
  output                  adrv2_tx1_en,
  output                  adrv2_rx2_en,
  output                  adrv2_rx1_en

);

  // internal signals
  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire                    gpio_rx1_enable_in;
  wire                    gpio_rx2_enable_in;
  wire                    gpio_tx1_enable_in;
  wire                    gpio_tx2_enable_in;
  wire        [ 2:0]      adrv1_spi_csn;
  wire        [ 2:0]      adrv2_spi_csn;

  wire                    adrv1_fpga_ref_clk;
  wire                    adrv2_fpga_ref_clk;
  wire                    adrv1_fpga_mcs_in;
  wire                    tdd_sync_loc;
  wire                    tdd_sync_i;
  wire                    tdd_sync_cntr;

  // instantiations

  IBUFDS i_ibufgs_adrv1_fpga_ref_clk (
    .I (adrv1_fpga_ref_clk_p),
    .IB (adrv1_fpga_ref_clk_n),
    .O (adrv1_fpga_ref_clk));

  IBUFDS i_ibufgs_adrv2_fpga_ref_clk (
    .I (adrv2_fpga_ref_clk_p),
    .IB (adrv2_fpga_ref_clk_n),
    .O (adrv2_fpga_ref_clk));

  IBUFDS i_ibufgs_fpga_mcs_in (
    .I (adrv1_fpga_mcs_in_p),
    .IB (adrv1_fpga_mcs_in_n),
    .O (adrv1_fpga_mcs_in));

  OBUFDS i_obufds_adrv1_dev_mcs_fpga_in (
    .I (adrv1_dev_mcs_fpga_in),
    .O (adrv1_dev_mcs_fpga_out_p),
    .OB (adrv1_dev_mcs_fpga_out_n));

  OBUFDS i_obufds_adrv2_dev_mcs_fpga_in (
    .I (adrv2_dev_mcs_fpga_in),
    .O (adrv2_dev_mcs_fpga_out_p),
    .OB (adrv2_dev_mcs_fpga_out_n));

  // to do add MCS support
  assign mssi_sync = gpio_o[54];

  assign adrv1_platform_status = adrv1_vadj_err;

  // hpc 0
  ad_iobuf #(
    .DATA_WIDTH(16)
  ) i_iobuf_adrv1 (
    .dio_t ({gpio_t[47:32]}),
    .dio_i ({gpio_o[47:32]}),
    .dio_o ({gpio_i[47:32]}),
    .dio_p ({adrv1_sm_fan_tach,  // 47
             adrv1_reset_trx,    // 46
             adrv1_mode,         // 45
             adrv1_gp_int,       // 44
             adrv1_dgpio_11,     // 43
             adrv1_dgpio_10,     // 42
             adrv1_dgpio_9,      // 41
             adrv1_dgpio_8,      // 40
             adrv1_dgpio_7,      // 39
             adrv1_dgpio_6,      // 38
             adrv1_dgpio_5,      // 37
             adrv1_dgpio_4,      // 36
             adrv1_dgpio_3,      // 35
             adrv1_dgpio_2,      // 34
             adrv1_dgpio_1,      // 33
             adrv1_dgpio_0 }));  // 32

  assign adrv1_gpio_rx1_enable_in = gpio_o[48];
  assign adrv1_gpio_rx2_enable_in = gpio_o[49];
  assign adrv1_gpio_tx1_enable_in = gpio_o[50];
  assign adrv1_gpio_tx2_enable_in = gpio_o[51];

  // hpc1
  ad_iobuf #(
    .DATA_WIDTH(16)
  ) i_iobuf_adrv2 (
    .dio_t ({gpio_t[72:57]}),
    .dio_i ({gpio_o[72:57]}),
    .dio_o ({gpio_i[72:57]}),
    .dio_p ({adrv1_sm_fan_tach,  // 72
             adrv1_reset_trx,    // 71
             adrv1_mode,         // 70
             adrv1_gp_int,       // 69
             adrv1_dgpio_11,     // 68
             adrv1_dgpio_10,     // 67
             adrv1_dgpio_9,      // 66
             adrv1_dgpio_8,      // 65
             adrv1_dgpio_7,      // 64
             adrv1_dgpio_6,      // 63
             adrv1_dgpio_5,      // 62
             adrv1_dgpio_4,      // 61
             adrv1_dgpio_3,      // 60
             adrv1_dgpio_2,      // 59
             adrv1_dgpio_1,      // 58
             adrv1_dgpio_0 }));  // 57

  assign adrv2_gpio_rx1_enable_in = gpio_o[73];
  assign adrv2_gpio_rx2_enable_in = gpio_o[74];
  assign adrv2_gpio_tx1_enable_in = gpio_o[75];
  assign adrv2_gpio_tx2_enable_in = gpio_o[76];

  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[ 7: 0];

  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[56] = gpio_o[56];
  assign gpio_i[54:48] = gpio_o[54:48];
  assign gpio_i[55] = adrv1_vadj_err;
  assign gpio_i[94:73] = gpio_o[94:73];

  assign adrv1_spi_en = adrv1_spi_csn[0];
  assign adrv2_spi_en = adrv2_spi_csn[0];

  //assign tdd_sync_loc = gpio_o[56];

  // tdd_sync_loc - local sync signal from a GPIO or other source
  // tdd_sync - external sync

  //assign tdd_sync_i = tdd_sync_cntr ? tdd_sync_loc : tdd_sync;
  //assign tdd_sync = tdd_sync_cntr ? tdd_sync_loc : 1'bz;

  system_wrapper i_system_wrapper (
    .adrv1_ref_clk (adrv1_fpga_ref_clk),
    .adrv1_fpga_mcs_in (adrv1_fpga_mcs_in),
    .mssi_sync (mssi_sync),

    .tx_output_enable (1'b1),

    .adrv1_rx1_dclk_in_n (adrv1_rx1_dclk_out_n),
    .adrv1_rx1_dclk_in_p (adrv1_rx1_dclk_out_p),
    .adrv1_rx1_strobe_in_n (adrv1_rx1_strobe_out_n),
    .adrv1_rx1_strobe_in_p (adrv1_rx1_strobe_out_p),
    .adrv1_rx1_idata_in_n (adrv1_rx1_idata_out_n),
    .adrv1_rx1_idata_in_p (adrv1_rx1_idata_out_p),
    .adrv1_rx1_qdata_in_n (adrv1_rx1_qdata_out_n),
    .adrv1_rx1_qdata_in_p (adrv1_rx1_qdata_out_p),
    .adrv2_rx1_dclk_in_n (adrv2_rx1_dclk_out_n),
    .adrv2_rx1_dclk_in_p (adrv2_rx1_dclk_out_p),
    .adrv2_rx1_strobe_in_n (adrv2_rx1_strobe_out_n),
    .adrv2_rx1_strobe_in_p (adrv2_rx1_strobe_out_p),
    .adrv2_rx1_idata_in_n (adrv2_rx1_idata_out_n),
    .adrv2_rx1_idata_in_p (adrv2_rx1_idata_out_p),
    .adrv2_rx1_qdata_in_n (adrv2_rx1_qdata_out_n),
    .adrv2_rx1_qdata_in_p (adrv2_rx1_qdata_out_p),

    .adrv1_tx1_dclk_in_n (adrv1_tx1_dclk_out_n),
    .adrv1_tx1_dclk_in_p (adrv1_tx1_dclk_out_p),
    .adrv1_tx1_strobe_out_n (adrv1_tx1_strobe_in_n),
    .adrv1_tx1_strobe_out_p (adrv1_tx1_strobe_in_p),
    .adrv1_tx1_idata_out_n (adrv1_tx1_idata_in_n),
    .adrv1_tx1_idata_out_p (adrv1_tx1_idata_in_p),
    .adrv1_tx1_qdata_out_n (adrv1_tx1_qdata_in_n),
    .adrv1_tx1_qdata_out_p (adrv1_tx1_qdata_in_p),
    .adrv1_tx1_dclk_out_n (adrv1_tx1_dclk_in_n),
    .adrv1_tx1_dclk_out_p (adrv1_tx1_dclk_in_p),
    .adrv2_tx1_dclk_in_n (adrv2_tx1_dclk_out_n),
    .adrv2_tx1_dclk_in_p (adrv2_tx1_dclk_out_p),
    .adrv2_tx1_strobe_out_n (adrv2_tx1_strobe_in_n),
    .adrv2_tx1_strobe_out_p (adrv2_tx1_strobe_in_p),
    .adrv2_tx1_idata_out_n (adrv2_tx1_idata_in_n),
    .adrv2_tx1_idata_out_p (adrv2_tx1_idata_in_p),
    .adrv2_tx1_qdata_out_n (adrv2_tx1_qdata_in_n),
    .adrv2_tx1_qdata_out_p (adrv2_tx1_qdata_in_p),
    .adrv2_tx1_dclk_out_n (adrv2_tx1_dclk_in_n),
    .adrv2_tx1_dclk_out_p (adrv2_tx1_dclk_in_p),

     //.adrv1_devclk_out (adrv1_devclk_out),
    .adrv1_rx2_dclk_in_n (adrv1_rx2_dclk_out_n),
    .adrv1_rx2_dclk_in_p (adrv1_rx2_dclk_out_p),
    .adrv1_rx2_strobe_in_n (adrv1_rx2_strobe_out_n),
    .adrv1_rx2_strobe_in_p (adrv1_rx2_strobe_out_p),
    .adrv1_rx2_idata_in_n (adrv1_rx2_idata_out_n),
    .adrv1_rx2_idata_in_p (adrv1_rx2_idata_out_p),
    .adrv1_rx2_qdata_in_n (adrv1_rx2_qdata_out_n),
    .adrv1_rx2_qdata_in_p (adrv1_rx2_qdata_out_p),
    .adrv2_rx2_dclk_in_n (adrv2_rx2_dclk_out_n),
    .adrv2_rx2_dclk_in_p (adrv2_rx2_dclk_out_p),
    .adrv2_rx2_strobe_in_n (adrv2_rx2_strobe_out_n),
    .adrv2_rx2_strobe_in_p (adrv2_rx2_strobe_out_p),
    .adrv2_rx2_idata_in_n (adrv2_rx2_idata_out_n),
    .adrv2_rx2_idata_in_p (adrv2_rx2_idata_out_p),
    .adrv2_rx2_qdata_in_n (adrv2_rx2_qdata_out_n),
    .adrv2_rx2_qdata_in_p (adrv2_rx2_qdata_out_p),

    .adrv1_tx2_dclk_in_n (adrv1_tx2_dclk_out_n),
    .adrv1_tx2_dclk_in_p (adrv1_tx2_dclk_out_p),
    .adrv1_tx2_strobe_out_n (adrv1_tx2_strobe_in_n),
    .adrv1_tx2_strobe_out_p (adrv1_tx2_strobe_in_p),
    .adrv1_tx2_idata_out_n (adrv1_tx2_idata_in_n),
    .adrv1_tx2_idata_out_p (adrv1_tx2_idata_in_p),
    .adrv1_tx2_qdata_out_n (adrv1_tx2_qdata_in_n),
    .adrv1_tx2_qdata_out_p (adrv1_tx2_qdata_in_p),
    .adrv1_tx2_dclk_out_n (adrv1_tx2_dclk_in_n),
    .adrv1_tx2_dclk_out_p (adrv1_tx2_dclk_in_p),
    .adrv2_tx2_dclk_in_n (adrv2_tx2_dclk_out_n),
    .adrv2_tx2_dclk_in_p (adrv2_tx2_dclk_out_p),
    .adrv2_tx2_strobe_out_n (adrv2_tx2_strobe_in_n),
    .adrv2_tx2_strobe_out_p (adrv2_tx2_strobe_in_p),
    .adrv2_tx2_idata_out_n (adrv2_tx2_idata_in_n),
    .adrv2_tx2_idata_out_p (adrv2_tx2_idata_in_p),
    .adrv2_tx2_qdata_out_n (adrv2_tx2_qdata_in_n),
    .adrv2_tx2_qdata_out_p (adrv2_tx2_qdata_in_p),
    .adrv2_tx2_dclk_out_n (adrv2_tx2_dclk_in_n),
    .adrv2_tx2_dclk_out_p (adrv2_tx2_dclk_in_p),

    .adrv1_rx1_enable (adrv1_rx1_en),
    .adrv1_rx2_enable (adrv1_rx2_en),
    .adrv1_tx1_enable (adrv1_tx1_en),
    .adrv1_tx2_enable (adrv1_tx2_en),
    .adrv2_rx1_enable (adrv2_rx1_en),
    .adrv2_rx2_enable (adrv2_rx2_en),
    .adrv2_tx1_enable (adrv2_tx1_en),
    .adrv2_tx2_enable (adrv2_tx2_en),

    .adrv1_gpio_rx1_enable_in (adrv1_gpio_rx1_enable_in),
    .adrv1_gpio_rx2_enable_in (adrv1_gpio_rx2_enable_in),
    .adrv1_gpio_tx1_enable_in (adrv1_gpio_tx1_enable_in),
    .adrv1_gpio_tx2_enable_in (adrv1_gpio_tx2_enable_in),
    .adrv2_gpio_rx1_enable_in (adrv2_gpio_rx1_enable_in),
    .adrv2_gpio_rx2_enable_in (adrv2_gpio_rx2_enable_in),
    .adrv2_gpio_tx1_enable_in (adrv2_gpio_tx1_enable_in),
    .adrv2_gpio_tx2_enable_in (adrv2_gpio_tx2_enable_in),

    //.tdd_sync (tdd_sync_i),
    //.tdd_sync_cntr (tdd_sync_cntr),

    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .spi0_sclk (adrv1_spi_clk),
    .spi0_csn  (adrv1_spi_csn),
    .spi0_miso (adrv1_spi_do),
    .spi0_mosi (adrv1_spi_dio),
    .spi1_sclk (adrv2_spi_clk),
    .spi1_csn  (adrv2_spi_csn),
    .spi1_miso (adrv2_spi_do),
    .spi1_mosi (adrv2_spi_dio));

endmodule
