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

`timescale 1ns/100ps

module mac_phy_link #(
  parameter RATE_10_100 = 0
) (
  input              ref_clk,
  input    [3:0]     mac_txd,
  input              reset_n,
  input              mac_tx_en,
  input              mac_tx_er,
  output             rmii_tx_en,
  output   [1:0]     rmii_txd,
  output             mii_tx_clk
);

  wire              dibit_sample;
  wire    [3:0]     num_w;
  wire              tx_dibit;
  wire    [4:0]     reg_count_w;

  reg     [3:0]     mac_txd_r = 4'b0;
  reg               mac_tx_en_r = 1'b0;
  reg               mac_tx_er_r = 1'b0;
  reg               mii_tx_clk_10_100_r = 1'b0;
  reg     [3:0]     num_r = 4'b0;
  reg     [1:0]     rmii_txd_r = 2'b0;
  reg               rmii_tx_en_r = 1'b0;
  reg               rising_tx_clk_r0 = 1'b0;
  reg               rising_tx_clk_r1 = 1'b0;
  reg     [4:0]     reg_count = 5'b0;

  localparam        DIV_REF_CLK = RATE_10_100 ? 10 : 1;

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      num_r <= 0;
      mii_tx_clk_10_100_r <= 1'b0;
    end else if (num_w == DIV_REF_CLK) begin
      num_r <= 0;
      mii_tx_clk_10_100_r <= ~mii_tx_clk_10_100_r;
      if (!mii_tx_clk_10_100_r) begin
        rising_tx_clk_r0 <= 1'b1;
        rising_tx_clk_r1 <= rising_tx_clk_r0;
      end else begin
        rising_tx_clk_r0 <= 1'b0;
        rising_tx_clk_r1 <= rising_tx_clk_r0;
      end
      rising_tx_clk_r1 <= rising_tx_clk_r0;
    end else begin
      num_r <= num_w;
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      mac_txd_r <= 4'b0;
      mac_tx_en_r <= 1'b0;
      mac_tx_er_r <= 1'b0;
    end else begin
      if (dibit_sample == 1'b1) begin
        mac_txd_r <= mac_txd;
        mac_tx_en_r <= mac_tx_en;
        mac_tx_er_r <= mac_tx_er;
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      rmii_txd_r <= 2'b0;
      rmii_tx_en_r <= 1'b0;
    end else begin
      if (!tx_dibit) begin
        rmii_txd_r[0] <= mac_txd_r[0] ^ mac_tx_er_r;
        rmii_txd_r[1] <= mac_txd_r[1] | mac_tx_er_r;
        rmii_tx_en_r <= mac_tx_en_r;
      end else begin
        rmii_txd_r[0] <= mac_txd_r[2] ^ mac_tx_er_r;
        rmii_txd_r[1] <= mac_txd_r[3] | mac_tx_er_r;
        rmii_tx_en_r <= mac_tx_en_r;
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      reg_count <= 1'b0;
    end else begin
      if (reg_count_w == 5'b10011) begin
        reg_count <= 1'b0;
      end else begin
        reg_count <= reg_count + 1;
      end
    end
  end

  assign dibit_sample = RATE_10_100 ? ((reg_count_w == 5'b01001) ? 1'b1 : 1'b0) : rising_tx_clk_r1;
  assign num_w = num_r + 1;
  assign mii_tx_clk = mii_tx_clk_10_100_r;
  assign reg_count_w = reg_count;
  assign rmii_txd = rmii_txd_r;
  assign rmii_tx_en = rmii_tx_en_r;
  assign tx_dibit = ~mii_tx_clk;

endmodule
