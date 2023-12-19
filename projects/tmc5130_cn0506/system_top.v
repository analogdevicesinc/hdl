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

module system_top(

  // LEDs
  output [23:0] leds_0_to_23,

  // dip_SWs
  input [7:0] dip_sw_1_to_8,

  // uart
  input         rxd_i,
  output        txd_o,

  // SPI
  output        mosi_o,
  output        sclk_o,
  input         miso_i,
  output [0:0]  ssn_o,

  // I2C
  inout         scl_io,
  inout         sda_io,
  
  // MDIO
  output        mdc_fmc_a,
  output        mdc_fmc_b,

  inout         mdio_fmc_a,
  inout         mdio_fmc_b,

  // REF CLK
  input         ref_clk_125_p,

  // PHY A
  input            rgmii_rx_ctl_a,
  input            rgmii_rxc_a,
  output           rgmii_tx_ctl_a,
  output           rgmii_txc_a,
  input    [3:0]   rgmii_rxd_a,
  output   [3:0]   rgmii_txd_a,
  output           rgmii_rstn_a,

  // PHY B
  input            rgmii_rx_ctl_b,
  input            rgmii_rxc_b,
  output           rgmii_tx_ctl_b,
  output           rgmii_txc_b,
  input    [3:0]   rgmii_rxd_b,
  output   [3:0]   rgmii_txd_b,
  output           rgmii_rstn_b,

  // TMC 5130 MOTOR DRIVER
  output            refl_uc,
  output            refr_uc,
  output            drv_enn_cfg6,
  output            enca_dcin_cfg5,
  output            encb_dcen_cfg4,
  output            encn_dco,
  output            swsel,
  output            swn_diag0,
  output            swp_diag1,
  output            ain_ref_sw,
  output            ain_ref_pwm,

  input	            sw_1,
  input	            sw_4,
  input	            sw_5
);

wire [31:0] gpio0_o;
wire [31:0] gpio0_i;
wire [31:0] gpio0_en_o;

wire [31:0] gpio1_o;
wire [31:0] gpio1_i;
wire [31:0] gpio1_en_o;

assign refl_uc        = gpio1_o[0];
assign refr_uc        = gpio1_o[1];
assign drv_enn_cfg6   = gpio1_o[2];
assign enca_dcin_cfg5 = gpio1_o[3];
assign encb_dcen_cfg4 = gpio1_o[4];
assign encn_dco       = gpio1_o[5];
assign swsel          = gpio1_o[6];
assign swn_diag0      = gpio1_o[7];
assign swp_diag1      = gpio1_o[8];
assign ain_ref_sw     = gpio1_o[9];
assign ain_ref_pwm    = gpio1_o[10];

// assign gpio1_i[11]    = sw_1;
assign gpio1_i[12]    = sw_4;
assign gpio1_i[13]    = sw_5;

assign leds_0_to_23 = gpio0_o[23:0];

assign gpio0_i[31:24] = dip_sw_1_to_8;

tmc5130_cn0506_ctpnxe tmc5130_cn0506_ctpnxe_inst (
  .gpio0_o(gpio0_o),
  .gpio0_i(gpio0_i),
  .gpio0_en_o(gpio0_en_o),

  .gpio1_o(gpio1_o),
  .gpio1_i(gpio1_i),
  .gpio1_en_o(gpio1_en_o),

  .scl_io (scl_io),
  .sda_io (sda_io),

  // .rstn_i (1'b1),
  .rstn_i (sw_1),
  
  .ssn_o (ssn_o),
  .mosi_o (mosi_o),
  .sclk_o (sclk_o),
  .miso_i (miso_i),

  .rxd_i (rxd_i),
  .txd_o (txd_o),

  .rgmii_rx_ctl_a(rgmii_rx_ctl_a),
  .rgmii_rxc_a(rgmii_rxc_a),
  .rgmii_tx_ctl_a(rgmii_tx_ctl_a),
  .rgmii_txc_a(rgmii_txc_a),
  .rgmii_rxd_a(rgmii_rxd_a),
  .rgmii_txd_a(rgmii_txd_a),
  .rgmii_rstn_a(rgmii_rstn_a),
  .rgmii_rx_ctl_b(rgmii_rx_ctl_b),
  .rgmii_rxc_b(rgmii_rxc_b),
  .rgmii_tx_ctl_b(rgmii_tx_ctl_b),
  .rgmii_txc_b(rgmii_txc_b),
  .rgmii_rxd_b(rgmii_rxd_b),
  .rgmii_txd_b(rgmii_txd_b),
  .ref_clk_125_p(ref_clk_125_p),
  .rgmii_rstn_b(rgmii_rstn_b),

  .mdc_fmc_a(mdc_fmc_a),
  .mdc_fmc_b(mdc_fmc_b),
  .mdio_fmc_a(mdio_fmc_a),
  .mdio_fmc_b(mdio_fmc_b));

endmodule
