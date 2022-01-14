// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
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
timescale 1 ps / 1 ps

module system_top
   (ap1302_rst_b,
    ap1302_standby,
    fan_en_b,
    iic_scl_io,
    iic_sda_io,
    lrclk_rx,
    lrclk_tx,
    mclk_out_rx,
    mclk_out_tx,
    mipi_phy_if_clk_n,
    mipi_phy_if_clk_p,
    mipi_phy_if_data_n,
    mipi_phy_if_data_p,
    sclk_rx,
    sclk_tx,
    sdata_rx,
    sdata_tx);
  output [0:0]ap1302_rst_b;
  output [0:0]ap1302_standby;
  output [0:0]fan_en_b;
  inout iic_scl_io;
  inout iic_sda_io;
  output lrclk_rx;
  output lrclk_tx;
  output mclk_out_rx;
  output mclk_out_tx;
  input mipi_phy_if_clk_n;
  input mipi_phy_if_clk_p;
  input [0:0]mipi_phy_if_data_n;
  input [0:0]mipi_phy_if_data_p;
  output sclk_rx;
  output sclk_tx;
  input sdata_rx;
  output sdata_tx;

  wire [0:0]ap1302_rst_b;
  wire [0:0]ap1302_standby;
  wire [0:0]fan_en_b;
  wire iic_scl_i;
  wire iic_scl_io;
  wire iic_scl_o;
  wire iic_scl_t;
  wire iic_sda_i;
  wire iic_sda_io;
  wire iic_sda_o;
  wire iic_sda_t;
  wire lrclk_rx;
  wire lrclk_tx;
  wire mclk_out_rx;
  wire mclk_out_tx;
  wire mipi_phy_if_clk_n;
  wire mipi_phy_if_clk_p;
  wire [0:0]mipi_phy_if_data_n;
  wire [0:0]mipi_phy_if_data_p;
  wire sclk_rx;
  wire sclk_tx;
  wire sdata_rx;
  wire sdata_tx;

  design_1 design_1_i
       (.ap1302_rst_b(ap1302_rst_b),
        .ap1302_standby(ap1302_standby),
        .fan_en_b(fan_en_b),
        .iic_scl_i(iic_scl_i),
        .iic_scl_o(iic_scl_o),
        .iic_scl_t(iic_scl_t),
        .iic_sda_i(iic_sda_i),
        .iic_sda_o(iic_sda_o),
        .iic_sda_t(iic_sda_t),
        .lrclk_rx(lrclk_rx),
        .lrclk_tx(lrclk_tx),
        .mclk_out_rx(mclk_out_rx),
        .mclk_out_tx(mclk_out_tx),
        .mipi_phy_if_clk_n(mipi_phy_if_clk_n),
        .mipi_phy_if_clk_p(mipi_phy_if_clk_p),
        .mipi_phy_if_data_n(mipi_phy_if_data_n),
        .mipi_phy_if_data_p(mipi_phy_if_data_p),
        .sclk_rx(sclk_rx),
        .sclk_tx(sclk_tx),
        .sdata_rx(sdata_rx),
        .sdata_tx(sdata_tx));
  IOBUF iic_scl_iobuf
       (.I(iic_scl_o),
        .IO(iic_scl_io),
        .O(iic_scl_i),
        .T(iic_scl_t));
  IOBUF iic_sda_iobuf
       (.I(iic_sda_o),
        .IO(iic_sda_io),
        .O(iic_sda_i),
        .T(iic_sda_t));
endmodule
// ***************************************************************************
// ***************************************************************************
