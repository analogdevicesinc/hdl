// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

/*
 * SPI slave that buffers ADC samples in an asynchronous FIFO and streams them
 * out to an external SPI master. The SPI pins are oversampled in the system
 * clock domain (Mode 3, MSB-first, DATA_WIDTH bits per transfer).
 */

module spi_slave #(
  parameter DATA_WIDTH = 32,
  parameter ADDRESS_WIDTH = 1
) (

  // data write interface

  input                       data_clk,
  input                       data_rst,
  input   [DATA_WIDTH-1:0]    data,
  input                       data_valid,

  // system clock / reset

  input                       clk,
  input                       resetn,

  // external SPI slave interface

  input                       spi_cs,
  input                       spi_sclk,
  output                      spi_miso,
  output                      data_ready_n
);

  // internal signals

  wire  [DATA_WIDTH-1:0]      m_axis_data;
  wire                        m_axis_valid;
  reg                         m_axis_ready = 1'b0;

  wire  [1:0]                 spi_sync;
  wire                        cs_sync;
  wire                        sclk_sync;

  // reset to 0 to match the synchronizer output and avoid a phantom edge
  reg                         cs_d = 1'b0;
  reg                         sclk_d = 1'b0;

  reg   [DATA_WIDTH-1:0]      shift_reg = {DATA_WIDTH{1'b0}};
  reg                         miso_reg = 1'b0;

  // edge / level detection

  wire                        cs_active;
  wire                        cs_fall;
  wire                        sclk_fall;

  assign cs_active = ~cs_sync;             // CS is active low
  assign cs_fall   = cs_d & ~cs_sync;      // CS asserted (high -> low)
  assign sclk_fall = sclk_d & ~sclk_sync;  // SCK leading edge for Mode 3

  assign spi_miso     = miso_reg;
  // asserted (low) whenever a word is available to read
  assign data_ready_n = ~m_axis_valid;

  // synchronize the asynchronous SPI pins into the system clock domain

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_spi_sync (
    .in_bits ({spi_sclk, spi_cs}),
    .out_resetn (resetn),
    .out_clk (clk),
    .out_bits (spi_sync));

  assign cs_sync   = spi_sync[0];
  assign sclk_sync = spi_sync[1];

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      cs_d   <= 1'b0;
      sclk_d <= 1'b0;
    end else begin
      cs_d   <= cs_sync;
      sclk_d <= sclk_sync;
    end
  end

  // SPI slave shift logic (Mode 3): one CS-framed transfer shifts out one
  // FIFO word, MSB first

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      shift_reg <= {DATA_WIDTH{1'b0}};
      miso_reg  <= 1'b0;
      m_axis_ready <= 1'b0;
    end else begin
      m_axis_ready <= 1'b0;
      if (cs_fall) begin
        shift_reg <= m_axis_data;
        miso_reg  <= m_axis_data[DATA_WIDTH-1];
        m_axis_ready <= m_axis_valid;
      end else if (cs_active & sclk_fall) begin
        miso_reg  <= shift_reg[DATA_WIDTH-1];
        shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};
      end
    end
  end

  // asynchronous sample FIFO: write side = data domain, read side = system clock

  util_axis_fifo #(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDRESS_WIDTH (ADDRESS_WIDTH),
    .ASYNC_CLK (1),
    .M_AXIS_REGISTERED (1),
    .TLAST_EN (0),
    .TKEEP_EN (0)
  ) i_fifo (
    .m_axis_aclk (clk),
    .m_axis_aresetn (resetn),
    .m_axis_ready (m_axis_ready),
    .m_axis_valid (m_axis_valid),
    .m_axis_data (m_axis_data),
    .m_axis_tkeep (),
    .m_axis_tlast (),
    .m_axis_level (),
    .m_axis_empty (),
    .m_axis_almost_empty (),
    .s_axis_aclk (data_clk),
    .s_axis_aresetn (~data_rst),
    .s_axis_ready (),
    .s_axis_valid (data_valid),
    .s_axis_data (data),
    .s_axis_tkeep ({(DATA_WIDTH/8){1'b1}}),
    .s_axis_tlast (1'b0),
    .s_axis_room (),
    .s_axis_full (),
    .s_axis_almost_full ());

endmodule
