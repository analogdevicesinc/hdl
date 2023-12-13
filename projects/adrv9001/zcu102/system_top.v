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

  output                  spi_clk,
  output                  spi_dio,
  input                   spi_do,
  output                  spi_en,

  // Device clock
  input                   fpga_ref_clk_n,
  input                   fpga_ref_clk_p,
  // Device clock passed through 9001
  input                   dev_clk_in,

  input                   fpga_mcs_in_n,
  input                   fpga_mcs_in_p,
  output                  dev_mcs_fpga_out_n,
  output                  dev_mcs_fpga_out_p,

  inout                   dgpio_0,
  inout                   dgpio_1,
  inout                   dgpio_2,
  inout                   dgpio_3,
  inout                   dgpio_4,
  inout                   dgpio_5,
  inout                   dgpio_6,
  inout                   dgpio_7,
  inout                   dgpio_8,
  inout                   dgpio_9,
  inout                   dgpio_10,
  inout                   dgpio_11,

  inout                   gp_int,
  inout                   mode,
  inout                   reset_trx,

  input                   rx1_dclk_in_n,
  input                   rx1_dclk_in_p,
  output                  rx1_enable,
  input                   rx1_idata_in_n,
  input                   rx1_idata_in_p,
  input                   rx1_qdata_in_n,
  input                   rx1_qdata_in_p,
  input                   rx1_strobe_in_n,
  input                   rx1_strobe_in_p,

  input                   rx2_dclk_in_n,
  input                   rx2_dclk_in_p,
  output                  rx2_enable,
  input                   rx2_idata_in_n,
  input                   rx2_idata_in_p,
  input                   rx2_qdata_in_n,
  input                   rx2_qdata_in_p,
  input                   rx2_strobe_in_n,
  input                   rx2_strobe_in_p,

  output                  tx1_dclk_out_n,
  output                  tx1_dclk_out_p,
  input                   tx1_dclk_in_n,
  input                   tx1_dclk_in_p,
  output                  tx1_enable,
  output                  tx1_idata_out_n,
  output                  tx1_idata_out_p,
  output                  tx1_qdata_out_n,
  output                  tx1_qdata_out_p,
  output                  tx1_strobe_out_n,
  output                  tx1_strobe_out_p,

  output                  tx2_dclk_out_n,
  output                  tx2_dclk_out_p,
  input                   tx2_dclk_in_n,
  input                   tx2_dclk_in_p,
  output                  tx2_enable,
  output                  tx2_idata_out_n,
  output                  tx2_idata_out_p,
  output                  tx2_qdata_out_n,
  output                  tx2_qdata_out_p,
  output                  tx2_strobe_out_n,
  output                  tx2_strobe_out_p,

  inout                   sm_fan_tach,
  input                   vadj_err,
  output                  platform_status,

  inout                   tdd_sync,

  //debug hdr
  output       [9:0]      proto_hdr
);

  // internal registers
  reg         [  2:0] mcs_sync_m = 'd0;
  reg                 dev_mcs_fpga_in = 1'b0;

  // internal signals
  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire                    gpio_rx1_enable_in;
  wire                    gpio_rx2_enable_in;
  wire                    gpio_tx1_enable_in;
  wire                    gpio_tx2_enable_in;
  wire        [ 2:0]      spi_csn;

  wire fpga_ref_clk;
  wire fpga_mcs_in;
  wire tdd_sync_loc;
  wire tdd_sync_i;
  wire tdd_sync_cntr;

  // instantiations

  IBUFDS i_ibufgs_fpga_ref_clk (
    .I (fpga_ref_clk_p),
    .IB (fpga_ref_clk_n),
    .O (fpga_ref_clk));

  IBUFDS i_ibufgs_fpga_mcs_in (
    .I (fpga_mcs_in_p),
    .IB (fpga_mcs_in_n),
    .O (fpga_mcs_in));

  OBUFDS i_obufds_dev_mcs_fpga_in (
    .I (dev_mcs_fpga_in),
    .O (dev_mcs_fpga_out_p),
    .OB (dev_mcs_fpga_out_n));

  // multi-chip synchronization
  //
  always @(posedge fpga_ref_clk) begin
    mcs_sync_m <= {mcs_sync_m[1:0], gpio_o[53]};
    dev_mcs_fpga_in <= mcs_sync_m[2] & ~mcs_sync_m[1];
  end

  // multi-ssi synchronization
  //
  assign mssi_sync = gpio_o[54];

  assign platform_status = vadj_err;

  ad_iobuf #(
    .DATA_WIDTH(16)
  ) i_iobuf (
    .dio_t ({gpio_t[47:32]}),
    .dio_i ({gpio_o[47:32]}),
    .dio_o ({gpio_i[47:32]}),
    .dio_p ({sm_fan_tach,  // 47
             reset_trx,    // 46
             mode,         // 45
             gp_int,       // 44
             dgpio_11,     // 43
             dgpio_10,     // 42
             dgpio_9,      // 41
             dgpio_8,      // 40
             dgpio_7,      // 39
             dgpio_6,      // 38
             dgpio_5,      // 37
             dgpio_4,      // 36
             dgpio_3,      // 35
             dgpio_2,      // 34
             dgpio_1,      // 33
             dgpio_0 }));  // 32

  assign gpio_rx1_enable_in = gpio_o[48];
  assign gpio_rx2_enable_in = gpio_o[49];
  assign gpio_tx1_enable_in = gpio_o[50];
  assign gpio_tx2_enable_in = gpio_o[51];

  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[ 7: 0];

  assign gpio_i[54:48] = gpio_o[54:48];
  assign gpio_i[55] = vadj_err;
  assign gpio_i[94:56] = gpio_o[94:56];
  assign gpio_i[31:21] = gpio_o[31:21];

  assign spi_en = spi_csn[0];

  assign tdd_sync_loc = gpio_o[56];

  // tdd_sync_loc - local sync signal from a GPIO or other source
  // tdd_sync - external sync

  assign tdd_sync_i = tdd_sync_cntr ? tdd_sync_loc : tdd_sync;
  assign tdd_sync = tdd_sync_cntr ? tdd_sync_loc : 1'bz;

  system_wrapper i_system_wrapper (
    .ref_clk (fpga_ref_clk),
    .mssi_sync (mssi_sync),

    .tx_output_enable (1'b1),

    .rx1_dclk_in_n (rx1_dclk_in_n),
    .rx1_dclk_in_p (rx1_dclk_in_p),
    .rx1_idata_in_n (rx1_idata_in_n),
    .rx1_idata_in_p (rx1_idata_in_p),
    .rx1_qdata_in_n (rx1_qdata_in_n),
    .rx1_qdata_in_p (rx1_qdata_in_p),
    .rx1_strobe_in_n (rx1_strobe_in_n),
    .rx1_strobe_in_p (rx1_strobe_in_p),

    .rx2_dclk_in_n (rx2_dclk_in_n),
    .rx2_dclk_in_p (rx2_dclk_in_p),
    .rx2_idata_in_n (rx2_idata_in_n),
    .rx2_idata_in_p (rx2_idata_in_p),
    .rx2_qdata_in_n (rx2_qdata_in_n),
    .rx2_qdata_in_p (rx2_qdata_in_p),
    .rx2_strobe_in_n (rx2_strobe_in_n),
    .rx2_strobe_in_p (rx2_strobe_in_p),

    .tx1_dclk_out_n (tx1_dclk_out_n),
    .tx1_dclk_out_p (tx1_dclk_out_p),
    .tx1_dclk_in_n (tx1_dclk_in_n),
    .tx1_dclk_in_p (tx1_dclk_in_p),
    .tx1_idata_out_n (tx1_idata_out_n),
    .tx1_idata_out_p (tx1_idata_out_p),
    .tx1_qdata_out_n (tx1_qdata_out_n),
    .tx1_qdata_out_p (tx1_qdata_out_p),
    .tx1_strobe_out_n (tx1_strobe_out_n),
    .tx1_strobe_out_p (tx1_strobe_out_p),

    .tx2_dclk_out_n (tx2_dclk_out_n),
    .tx2_dclk_out_p (tx2_dclk_out_p),
    .tx2_dclk_in_n (tx2_dclk_in_n),
    .tx2_dclk_in_p (tx2_dclk_in_p),
    .tx2_idata_out_n (tx2_idata_out_n),
    .tx2_idata_out_p (tx2_idata_out_p),
    .tx2_qdata_out_n (tx2_qdata_out_n),
    .tx2_qdata_out_p (tx2_qdata_out_p),
    .tx2_strobe_out_n (tx2_strobe_out_n),
    .tx2_strobe_out_p (tx2_strobe_out_p),

    .rx1_enable (rx1_enable),
    .rx2_enable (rx2_enable),
    .tx1_enable (tx1_enable),
    .tx2_enable (tx2_enable),

    .gpio_rx1_enable_in (gpio_rx1_enable_in),
    .gpio_rx2_enable_in (gpio_rx2_enable_in),
    .gpio_tx1_enable_in (gpio_tx1_enable_in),
    .gpio_tx2_enable_in (gpio_tx2_enable_in),

    .tdd_sync (tdd_sync_i),
    .tdd_sync_cntr (tdd_sync_cntr),

    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .spi0_sclk (spi_clk),
    .spi0_csn (spi_csn),
    .spi0_miso (spi_do),
    .spi0_mosi (spi_dio),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),

    // debug
    .adc1_div_clk (proto_hdr[0]),
    .adc2_div_clk (proto_hdr[1]),
    .dac1_div_clk (proto_hdr[2]),
    .dac2_div_clk (proto_hdr[3]));

  assign proto_hdr[9:4] = {'b0};

endmodule
