// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

module daq1_spi (

  input                   spi_csn,
  input                   spi_clk,
  input                   spi_mosi,
  output                  spi_miso,

  inout                   spi_sdio);

  // device address

  localparam  [ 7:0]  SPI_SEL_AD9684  = 8'h80;
  localparam  [ 7:0]  SPI_SEL_AD9122  = 8'h81;
  localparam  [ 7:0]  SPI_SEL_AD9523  = 8'h82;
  localparam  [ 7:0]  SPI_SEL_CPLD    = 8'h83;

  // internal registers

  reg     [ 5:0]  spi_count = 6'b0;
  reg             spi_rd_wr_n = 1'b0;
  reg             spi_enable = 1'b0;
  reg     [ 7:0]  spi_device_addr = 8'b0;

  // internal signals

  wire            spi_enable_s;

  // check on rising edge and change on falling edge

  assign spi_enable_s = spi_enable & ~spi_csn;

  always @(posedge spi_clk or posedge spi_csn) begin
    if (spi_csn == 1'b1) begin
      spi_count <= 6'b0000000;
      spi_rd_wr_n <= 1'b0;
      spi_device_addr <= 8'b00000000;
    end else begin
      spi_count <= (spi_count < 6'h3f) ? spi_count + 1'b1 : spi_count;
      if (spi_count <= 6'd7) begin
        spi_device_addr <= {spi_device_addr[6:0], spi_mosi};
      end
      if (spi_count == 6'd8) begin
        spi_rd_wr_n <= spi_mosi;
      end
    end
  end

  always @(negedge spi_clk or posedge spi_csn) begin
    if (spi_csn == 1'b1) begin
      spi_enable <= 1'b0;
    end else begin
      if (((spi_device_addr == SPI_SEL_AD9684) && (spi_count == 6'd24)) ||
          ((spi_device_addr == SPI_SEL_AD9122) && (spi_count == 6'd16)) ||
          ((spi_device_addr == SPI_SEL_AD9523) && (spi_count == 6'd24)) ||
          ((spi_device_addr == SPI_SEL_CPLD)   && (spi_count == 6'd16))) begin
        spi_enable <= spi_rd_wr_n;
      end
    end
  end

  // io logic

  assign spi_miso = spi_sdio;
  assign spi_sdio = (spi_enable_s == 1'b1) ? 1'bz : spi_mosi;

endmodule

// ***************************************************************************
// ***************************************************************************
