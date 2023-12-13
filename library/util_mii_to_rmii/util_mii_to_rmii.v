// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module util_mii_to_rmii #(
  parameter         INTF_CFG = 0,
  parameter         RATE_10_100 = 0
) (

  // MAC to MII(PHY)
  input             mac_tx_en,
  input    [3:0]    mac_txd,
  input             mac_tx_er,
  //MII to MAC
  output            mii_tx_clk,
  output            mii_rx_clk,
  output            mii_col,
  output            mii_crs,
  output            mii_rx_dv,
  output            mii_rx_er,
  output   [3:0]    mii_rxd,
  // RMII to PHY
  output   [1:0]    rmii_txd,
  output            rmii_tx_en,
  // PHY to RMII
  input    [1:0]    phy_rxd,
  input             phy_crs_dv,
  input             phy_rx_er,
  // External
  input             ref_clk,
  input             reset_n
);

  reg                mac_tx_en_r1 = 1'b0;
  reg       [3:0]    mac_txd_r1 = 4'b0;
  reg                mac_tx_er_r1 = 1'b0;
  reg                phy_crs_dv_r1 = 1'b0;
  reg       [1:0]    phy_rxd_r1 = 2'b0;
  reg                phy_rx_er_r1 = 1'b0;
  reg                mii_tx_clk_r1 = 1'b0;
  reg                mii_rx_clk_r1 = 1'b0;
  reg                mii_col_r1 = 1'b0;
  reg                mii_crs_r1 = 1'b0;
  reg                mii_rx_dv_r1 = 1'b0;
  reg                mii_rx_er_r1 = 1'b0;
  reg       [3:0]    mii_rxd_r1 = 4'b0;
  reg       [1:0]    rmii_txd_r1 = 2'b0;
  reg                rmii_tx_en_r1 = 1'b0;
  reg                mac_tx_en_r2 = 1'b0;
  reg       [3:0]    mac_txd_r2 = 4'b0;
  reg                mac_tx_er_r2 = 1'b0;
  reg                phy_crs_dv_r2 = 1'b0;
  reg       [1:0]    phy_rxd_r2 = 2'b0;
  reg                phy_rx_er_r2 = 1'b0;

  wire               mii_tx_clk_r2;
  wire               mii_rx_clk_r2;
  wire               mii_col_r2;
  wire               mii_crs_r2;
  wire               mii_rx_dv_r2;
  wire               mii_rx_er_r2;
  wire      [3:0]    mii_rxd_r2;
  wire      [1:0]    rmii_txd_r2;
  wire               rmii_tx_en_r2;

  //inputs
  always @(posedge ref_clk) begin
    if (!reset_n) begin
      mac_tx_en_r1 <= 1'b0;
      mac_tx_en_r2 <= 1'b0;
      mac_txd_r1 <= 4'b0;
      mac_txd_r2 <= 4'b0;
      mac_tx_er_r1 <= 1'b0;
      mac_tx_er_r2 <= 1'b0;
      phy_crs_dv_r1 <= 1'b0;
      phy_crs_dv_r2 <= 1'b0;
      phy_rxd_r1 <= 2'b0;
      phy_rx_er_r1 <= 1'b0;
      phy_rxd_r2 <= 2'b0;
    end else begin
      mac_tx_en_r1 <= mac_tx_en;
      mac_tx_en_r2 <= mac_tx_en_r1;
      mac_txd_r1 <= mac_txd;
      mac_txd_r2 <= mac_txd_r1;
      mac_tx_er_r1 <= mac_tx_er;
      mac_tx_er_r2 <= mac_tx_er_r1;
      phy_crs_dv_r1 <= phy_crs_dv;
      phy_crs_dv_r2 <= phy_crs_dv_r1;
      phy_rxd_r1 <= phy_rxd;
      phy_rxd_r2 <= phy_rxd_r1;
      phy_rx_er_r1 <= phy_rx_er;
      phy_rx_er_r2 <= phy_rx_er_r1;
    end
  end

  //outputs
  always @(posedge ref_clk) begin
    if (!reset_n) begin
      mii_col_r1 <= 1'b0;
      mii_crs_r1 <= 1'b0;
      mii_rx_dv_r1 <= 1'b0;
      mii_rx_er_r1 <= 1'b0;
      mii_rxd_r1 <= 4'b0;
      rmii_txd_r1 <= 2'b0;
      rmii_tx_en_r1 <= 1'b0;
      mii_tx_clk_r1 <= 1'b0;
      mii_rx_clk_r1 <= 1'b0;
    end else begin
      mii_tx_clk_r1 <= mii_tx_clk_r2;
      mii_rx_clk_r1 <= mii_rx_clk_r2;
      mii_col_r1 <= mii_crs_r2 & mac_tx_en_r2;
      mii_crs_r1 <= mii_crs_r2;
      mii_rx_dv_r1 <= mii_rx_dv_r2;
      mii_rx_er_r1 <= mii_rx_er_r2;
      mii_rxd_r1 <= mii_rxd_r2;
      rmii_txd_r1 <= rmii_txd_r2;
      rmii_tx_en_r1 <= rmii_tx_en_r2;
    end
  end

  assign mii_crs = mii_crs_r1;
  assign mii_col = mii_col_r1;
  assign mii_rx_dv = mii_rx_dv_r1;
  assign mii_rx_er = mii_rx_er_r1;
  assign mii_rxd = mii_rxd_r1;
  assign rmii_txd = rmii_txd_r1;
  assign rmii_tx_en = rmii_tx_en_r1;
  assign mii_rx_clk = mii_rx_clk_r1;
  assign mii_tx_clk = mii_tx_clk_r1;

  mac_phy_link #(
    .RATE_10_100(RATE_10_100)
  ) mac_phy_link_inst (
    .ref_clk(ref_clk),
    .reset_n(reset_n),
    .mac_tx_en(mac_tx_en_r2),
    .mac_txd(mac_txd_r2),
    .mac_tx_er(mac_tx_er_r2),
    .mii_tx_clk(mii_tx_clk_r2),
    .rmii_txd(rmii_txd_r2),
    .rmii_tx_en(rmii_tx_en_r2));

  phy_mac_link #(
    .RATE_10_100(RATE_10_100)
  ) phy_mac_link_inst (
    .ref_clk(ref_clk),
    .reset_n(reset_n),
    .mii_crs(mii_crs_r2),
    .mii_rx_dv(mii_rx_dv_r2),
    .mii_rx_er(mii_rx_er_r2),
    .mii_rxd(mii_rxd_r2),
    .mii_rx_clk(mii_rx_clk_r2),
    .phy_rxd(phy_rxd_r2),
    .phy_crs_dv(phy_crs_dv_r2),
    .phy_rx_er(phy_rx_er_r2));

endmodule
