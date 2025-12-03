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
  input            mac_tx_en,
  input      [3:0] mac_txd,
  input            mac_tx_er,

  //MII to MAC
  output reg       mii_tx_clk,
  output reg       mii_rx_clk,
  output           mii_col,
  output           mii_crs,
  output           mii_rx_dv,
  output           mii_rx_er,
  output     [3:0] mii_rxd,

  // RMII to PHY
  output reg [1:0] rmii_txd,
  output reg       rmii_tx_en,

  // PHY to RMII
  input      [1:0] phy_rxd,
  input            phy_crs_dv,
  input            phy_rx_er,

  // External
  input            ref_clk,
  input            reset_n
);

  // wires
  wire       mac_tx_en_s;
  wire [3:0] mac_txd_s;
  wire       mac_tx_er_s;

  wire       mii_tx_clk_s;
  wire       mii_rx_clk_s;
  wire       mii_col_s;
  wire       mii_crs_s;
  wire       mii_rx_dv_s;
  wire       mii_rx_er_s;
  wire [3:0] mii_rxd_s;
  wire [1:0] rmii_txd_s;
  wire       rmii_tx_en_s;

  // registers
  reg        mii_col_r;
  reg        mii_crs_r;
  reg        mii_rx_dv_r;
  reg        mii_rx_er_r;
  reg  [3:0] mii_rxd_r;

  // inputs
  sync_bits #(
    .NUM_OF_BITS(6),
    .ASYNC_CLK(1)
  ) i_mac_in_sync (
    .out_clk(ref_clk),
    .out_resetn(resetn),
    .in_bits( {mac_tx_en, mac_txd, mac_tx_er} ),
    .out_bits( {mac_tx_en_s, mac_txd_s, mac_tx_er_s} ));

  //outputs
  always @(posedge ref_clk) begin
    if (!reset_n) begin
      mii_tx_clk <= 1'b0;
      mii_rx_clk <= 1'b0;
      rmii_txd <= 2'b0;
      rmii_tx_en <= 1'b0;

      mii_col_r <= 1'b0;
      mii_crs_r <= 1'b0;
      mii_rx_dv_r <= 1'b0;
      mii_rx_er_r <= 1'b0;
      mii_rxd_r <= 4'b0;
    end else begin
      mii_tx_clk <= mii_tx_clk_s;
      mii_rx_clk <= mii_rx_clk_s;
      rmii_txd <= rmii_txd_s;
      rmii_tx_en <= rmii_tx_en_s;

      mii_col_r <= mii_crs_s && mac_tx_en_s;
      mii_crs_r <= mii_crs_s;
      mii_rx_dv_r <= mii_rx_dv_s;
      mii_rx_er_r <= mii_rx_er_s;
      mii_rxd_r <= mii_rxd_s;
    end
  end

  sync_bits #(
    .NUM_OF_BITS(2),
    .ASYNC_CLK(1)
  ) i_mac_in_sync (
    .out_clk(mii_tx_clk_r),
    .out_resetn(1'b1),
    .in_bits( {mii_col_r, mii_crs_r} ),
    .out_bits( {mii_col, mii_crs} ));

  sync_bits #(
    .NUM_OF_BITS(9),
    .ASYNC_CLK(1)
  ) i_mac_in_sync (
    .out_clk(mii_rx_clk_r),
    .out_resetn(1'b1),
    .in_bits( {mii_rx_dv_r, mii_rx_er_r, mii_rxd_r} ),
    .out_bits( {mii_rx_dv, mii_rx_er, mii_rxd} ));

  mac_phy_link #(
    .RATE_10_100(RATE_10_100)
  ) mac_phy_link_inst (
    .ref_clk(ref_clk),
    .reset_n(reset_n),
    .mac_tx_en(mac_tx_en_s),
    .mac_txd(mac_txd_s),
    .mac_tx_er(mac_tx_er_s),
    .mii_tx_clk(mii_tx_clk_s),
    .rmii_txd(rmii_txd_s),
    .rmii_tx_en(rmii_tx_en_s));

  phy_mac_link #(
    .RATE_10_100(RATE_10_100)
  ) phy_mac_link_inst (
    .ref_clk(ref_clk),
    .reset_n(reset_n),
    .mii_crs(mii_crs_s),
    .mii_rx_dv(mii_rx_dv_s),
    .mii_rx_er(mii_rx_er_s),
    .mii_rxd(mii_rxd_s),
    .mii_rx_clk(mii_rx_clk_s),
    .phy_rxd(phy_rxd),
    .phy_crs_dv(phy_crs_dv),
    .phy_rx_er(phy_rx_er));

endmodule
