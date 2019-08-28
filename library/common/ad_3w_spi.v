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

//
// A 4-wire to 3-wire SPI converter, supporting maximum 8 slaves.
// The expected transfer format is defined in ADI_SPI technical specification
// (https://wiki.analog.com/_media/resources/technical-guides/adispi_rev_1p0_customer.pdf)
//
// 16 bit instruction followed by N x 8 bits of data; the MSB bit of the
// instruction defines the direction of the SDIO during data transfer. (READ
// is 1 and WRITE is 0)
//

module ad_3w_spi #(

  parameter NUM_OF_SLAVES=8) (

  input       [NUM_OF_SLAVES-1:0] spi_csn,
  input                           spi_clk,
  input                           spi_mosi,
  output                          spi_miso,

  inout                           spi_sdio,
  output                          spi_dir);

  // internal registers

  reg     [ 5:0]  spi_count = 'd0;
  reg             spi_rd_wr_n = 'd0;
  reg             spi_enable = 'd0;

  // internal signals

  wire            spi_csn_s;
  wire            spi_enable_s;

  // check on rising edge and change on falling edge

  assign spi_csn_s = & spi_csn;
  assign spi_dir = ~spi_enable_s;
  assign spi_enable_s = spi_enable & ~spi_csn_s;

  always @(posedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s == 1'b1) begin
      spi_count <= 6'd0;
      spi_rd_wr_n <= 1'd0;
    end else begin
      spi_count <= (spi_count < 6'h3f) ? spi_count + 1'b1 : spi_count;
      if (spi_count == 6'd0) begin
        spi_rd_wr_n <= spi_mosi;
      end
    end
  end

  always @(negedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s == 1'b1) begin
      spi_enable <= 1'b0;
    end else begin
      if (spi_count == 6'd16) begin
        spi_enable <= spi_rd_wr_n;
      end
    end
  end

  // io butter

  assign spi_miso = spi_sdio;
  assign spi_sdio = (spi_enable_s == 1'b1) ? 1'bz : spi_mosi;

endmodule

// ***************************************************************************
// ***************************************************************************
