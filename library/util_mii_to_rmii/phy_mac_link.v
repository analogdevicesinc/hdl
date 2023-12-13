// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module phy_mac_link  #(
  parameter RATE_10_100 = 0
) (
  input             ref_clk,
  input             reset_n,
  input   [1:0]     phy_rxd,
  input             phy_crs_dv,
  input             phy_rx_er,
  output  [3:0]     mii_rxd,
  output            mii_rx_dv,
  output            mii_rx_er,
  output            mii_crs,
  output            mii_col,
  output            mii_rx_clk
);

  wire              clk_phase_res;
  wire              data_valid_w;
  wire              dibit_sample;
  wire              eopack_w;
  wire    [3:0]     num_w;
  wire    [3:0]     reg_count_w;
  wire              sopack_w;

  reg               mii_rx_clk_10_100_r = 1'b0;
  reg     [3:0]     num_r = 4'b0;
  reg     [3:0]     reg_count = 4'b0;

  reg               clk_phase_r = 1'b0;
  reg               data_valid = 1'b0;
  reg               data_valid_d = 1'b0;
  reg     [1:0]     eopack_r = 2'b0;
  reg               nibble_valid = 1'b0;
  reg     [1:0]     sopack_r = 2'b0;

  reg     [3:0]     mii_rxd_r0 = 4'b0;
  reg     [3:0]     mii_rxd_r1 = 4'b0;
  reg     [3:0]     mii_rxd_r2 = 4'b0;

  reg               mii_rx_er_r0 = 1'b0;
  reg               mii_rx_er_r1 = 1'b0;
  reg               mii_rx_er_r2 = 1'b0;

  reg               mii_rx_dv_r0 = 1'b0;
  reg               mii_rx_dv_r1 = 1'b0;
  reg               mii_rx_dv_r2 = 1'b0;
  reg               mii_rx_dv_r3 = 1'b0;

  localparam        DIV_REF_CLK = RATE_10_100 ? 10 : 1;

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      num_r <= 0;
      mii_rx_clk_10_100_r <= 1'b0;
    end else if (num_w == DIV_REF_CLK) begin
      num_r <= 0;
      mii_rx_clk_10_100_r <= ~mii_rx_clk_10_100_r;
    end else begin
      num_r <= num_w;
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      mii_rxd_r0 <= 4'b0;
      mii_rxd_r1 <= 4'b0;
      mii_rxd_r2 <= 4'b0;
    end else begin
      if (RATE_10_100) begin
        if (dibit_sample) begin
          mii_rxd_r0[3:2] <= phy_rxd;
          mii_rxd_r0[1:0] <= mii_rxd_r0[3:2];
          if (nibble_valid | sopack_w) begin
            mii_rxd_r1 <= mii_rxd_r0;
          end
          mii_rxd_r2 <= mii_rxd_r1;
        end
      end else begin
        mii_rxd_r0[3:2] <= phy_rxd;
        mii_rxd_r0[1:0] <= mii_rxd_r0[3:2];
        if (nibble_valid | sopack_w) begin
          mii_rxd_r1 <= mii_rxd_r0;
        end
        mii_rxd_r2 <= mii_rxd_r1;
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      mii_rx_er_r0 <= 1'b0;
      mii_rx_er_r1 <= 1'b0;
      mii_rx_er_r2 <= 1'b0;
    end else begin
      if (RATE_10_100) begin
        if (dibit_sample) begin
          mii_rx_er_r0 <= phy_rx_er;
          mii_rx_er_r1 <= mii_rx_er_r0;
          mii_rx_er_r2 <= mii_rx_er_r1;
        end
      end else begin
        mii_rx_er_r0 <= phy_rx_er;
        mii_rx_er_r1 <= mii_rx_er_r0;
        mii_rx_er_r2 <= mii_rx_er_r1;
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      mii_rx_dv_r0 <= 1'b0;
      mii_rx_dv_r1 <= 1'b0;
      mii_rx_dv_r2 <= 1'b0;
      mii_rx_dv_r3 <= 1'b0;
    end else begin
      if (RATE_10_100) begin
        if (dibit_sample) begin
          mii_rx_dv_r0 <= phy_crs_dv;
          mii_rx_dv_r1 <= mii_rx_dv_r0;
          mii_rx_dv_r2 <= mii_rx_dv_r1;
          mii_rx_dv_r3 <= mii_rx_dv_r2;
        end
      end else begin
        mii_rx_dv_r0 <= phy_crs_dv;
        mii_rx_dv_r1 <= mii_rx_dv_r0;
        mii_rx_dv_r2 <= mii_rx_dv_r1;
        mii_rx_dv_r3 <= mii_rx_dv_r2;
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n || eopack_w) begin
      sopack_r[1:0] <= 2'b0;
    end else begin
      if (RATE_10_100) begin
        if (dibit_sample) begin
          sopack_r[1] <= sopack_r[0];
        end
        if (dibit_sample && (mii_rxd_r0[3:2] == 2'b01) && (mii_rx_dv_r0 == 1'b1) && (sopack_w == 1'b0)) begin
          sopack_r[0] <= 1'b1;
        end
      end else begin
        sopack_r[1] <= sopack_r[0];
        if ((mii_rxd_r0[3:2] == 2'b01) && (mii_rx_dv_r0 == 1'b1) && (sopack_w == 1'b0)) begin
          sopack_r[0] <= 1'b1;
        end
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n || sopack_w) begin
      eopack_r[1:0] <= 2'b0;
    end else begin
      if (RATE_10_100) begin
        if (dibit_sample) begin
          eopack_r[1] <= eopack_r[0];
        end
        if (dibit_sample && (mii_rx_dv_r0 == 1'b0) && (mii_rx_dv_r1 == 1'b0) && (eopack_w == 1'b0)) begin
          eopack_r[0] <= 1'b1;
        end
      end else begin
        eopack_r[1] <= eopack_r[0];
        if ((mii_rx_dv_r0 == 1'b0) && (mii_rx_dv_r1 == 1'b0) && (eopack_w == 1'b0)) begin
          eopack_r[0] <= 1'b1;
        end
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      data_valid <= 1'b0;
    end else begin
      if (RATE_10_100) begin
        if (dibit_sample && sopack_w) begin
          data_valid <= 1'b1;
        end else if (dibit_sample && eopack_w) begin
          data_valid <= 1'b0;
        end
      end else begin
        if (sopack_w) begin
          data_valid <= 1'b1;
        end else if (eopack_w) begin
          data_valid <= 1'b0;
        end
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      data_valid_d <= 1'b0;
    end else begin
      data_valid_d <= data_valid;
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      clk_phase_r <= 1'b0;
      nibble_valid <= 1'b0;
    end else begin
      if (sopack_w) begin
        clk_phase_r <= mii_rx_clk;
        nibble_valid <=  1'b0;
      end else begin
        if (RATE_10_100) begin
          if (dibit_sample) begin
            nibble_valid <= ~nibble_valid;
          end
        end else begin
          nibble_valid <= ~nibble_valid;
        end
      end
    end
  end

  always @(posedge ref_clk) begin
    if (!reset_n) begin
      reg_count <= 1'b0;
    end else begin
      if (reg_count_w == 4'b1001) begin
        reg_count <= 1'b0;
      end else begin
        reg_count <= reg_count + 1;
      end
    end
  end

  assign clk_phase_res = clk_phase_r;
  assign data_valid_w = RATE_10_100 ? data_valid : (clk_phase_res ? data_valid : data_valid_d);
  assign dibit_sample = (reg_count_w == 4'b0101) ? 1'b1 : 1'b0;
  assign eopack_w = eopack_r[0] & (!eopack_r[1]);
  assign mii_crs = mii_rx_dv_r0;
  assign mii_rxd = RATE_10_100 ? (mii_rx_dv ? mii_rxd_r1 : 4'b0) : (mii_rx_dv ? (clk_phase_res ? mii_rxd_r1 : mii_rxd_r2) : 4'b0);
  assign mii_rx_clk = mii_rx_clk_10_100_r;
  assign mii_rx_dv = data_valid_w ? 1'b1 : 1'b0;
  assign mii_rx_er = mii_rx_er_r2;
  assign num_w = num_r + 1;
  assign reg_count_w = reg_count;
  assign sopack_w = sopack_r[0] & (!sopack_r[1]);

endmodule
