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
 * Upstream SPI slave, clocked by SCLK.
 *
 * Receive: MOSI is shifted in on the sample edge (rising for modes 0/3,
 * falling for 1/2). On the edge completing a byte, the byte is copied to a
 * holding register and a toggle flipped; only the toggle is synchronized into
 * clk, and the holding register is sampled once it is known stable.
 *
 * Transmit: MISO is launched on the sample edge too, right after the master
 * has sampled the previous bit, so each bit has a full SCLK period to reach
 * the master. On the edge completing a byte the slave loads tx_data as the
 * next byte to send; tx_data is expected to change only in the cycle after
 * rx_valid, so it is stable at every byte boundary.
 *
 * Timing: one SCLK byte must exceed the rx_valid latency plus one clk
 * (about 6 clk).
 */

module spi_translator_slave #(
  parameter DATA_WIDTH = 8,
  parameter CPOL = 1,
  parameter CPHA = 1
) (

  // system clock / reset

  input                       clk,
  input                       resetn,

  // received words and frame events (system clock domain)

  output  [DATA_WIDTH-1:0]    rx_data,
  output                      rx_valid,
  output                      frame_start,
  output                      frame_end,
  output                      frame_active,

  // transmitted words

  input   [DATA_WIDTH-1:0]    tx_data,

  // external SPI slave interface

  input                       spi_cs,
  input                       spi_sclk,
  input                       spi_mosi,
  output                      spi_miso,
  output                      spi_miso_t
);

  localparam BIT_COUNTER_WIDTH = $clog2(DATA_WIDTH);

  // internal signals
  wire cs_rise;
  wire cs_fall;
  wire cs_sync;
  wire tog_sync;
  wire sclk_s;

  reg  [BIT_COUNTER_WIDTH-1:0] bit_cnt = {BIT_COUNTER_WIDTH{1'b0}};
  reg  [DATA_WIDTH-1:0]        sdi_shift = {DATA_WIDTH{1'b0}};
  reg  [DATA_WIDTH-1:0]        sdi_hold = {DATA_WIDTH{1'b0}};
  reg                          sdi_tog = 1'b0;
  reg                          frame_start_reg = 1'b0;
  reg                          frame_end_reg = 1'b0;
  reg                          frame_active_reg = 1'b0;
  reg                          rx_valid_reg = 1'b0;
  reg  [DATA_WIDTH-1:0]        rx_data_reg = {DATA_WIDTH{1'b0}};
  reg                          cs_d = 1'b0;
  reg                          tog_d = 1'b0;
  reg  [DATA_WIDTH-1:0]        tx_shift = {DATA_WIDTH{1'b0}};

  // sample edge: rising for modes 0/3, falling for 1/2
  // (a constant inversion, absorbed into the FF clock input)
  assign sclk_s = (CPOL != CPHA) ? ~spi_sclk : spi_sclk;

  assign cs_fall = cs_d & ~cs_sync;      // CS asserted (high -> low)
  assign cs_rise = ~cs_d & cs_sync;      // CS deasserted (low -> high)

  assign frame_start   = frame_start_reg;
  assign frame_end     = frame_end_reg;
  assign frame_active  = frame_active_reg;
  assign rx_valid      = rx_valid_reg;
  assign rx_data       = rx_data_reg;

  assign spi_miso   = tx_shift[DATA_WIDTH-1];
  assign spi_miso_t = spi_cs;

  always @(posedge sclk_s or posedge spi_cs) begin
    if (spi_cs) begin
      bit_cnt <= {BIT_COUNTER_WIDTH{1'b0}};
      sdi_shift <= {DATA_WIDTH{1'b0}};
    end else begin
      bit_cnt <= bit_cnt + 1'b1;
      sdi_shift <= {sdi_shift[DATA_WIDTH-2:0], spi_mosi};
    end
  end

  always @(posedge sclk_s) begin
    if (bit_cnt == DATA_WIDTH-1) begin
      sdi_hold <= {sdi_shift[DATA_WIDTH-2:0], spi_mosi};
      sdi_tog <= ~sdi_tog;
    end
  end

  // MISO: one tx_data byte per byte boundary

  always @(posedge sclk_s) begin
    if (bit_cnt == DATA_WIDTH-1) begin
      tx_shift <= tx_data;
    end else begin
      tx_shift <= {tx_shift[DATA_WIDTH-2:0], 1'b0};
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      cs_d <= 1'b0;
      tog_d <= 1'b0;
      rx_valid_reg <= 1'b0;
      rx_data_reg <= {DATA_WIDTH{1'b0}};
    end else begin
      cs_d <= cs_sync;
      tog_d <= tog_sync;
      rx_valid_reg <= tog_sync ^ tog_d;
      if (tog_sync ^ tog_d) begin
        rx_data_reg <= sdi_hold;
      end
    end
  end

  // frame tracking; edges are only honoured between CS assert and deassert
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      frame_start_reg <= 1'b0;
      frame_end_reg <= 1'b0;
      frame_active_reg <= 1'b0;
    end else begin
      frame_start_reg <= cs_fall;
      frame_end_reg <= cs_rise & frame_active_reg;
      if (cs_fall) begin
        frame_active_reg <= 1'b1;
      end else if (cs_rise) begin
        frame_active_reg <= 1'b0;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_cs_sync (
    .in_bits (spi_cs),
    .out_clk (clk),
    .out_resetn (resetn),
    .out_bits (cs_sync));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_tog_sync (
    .in_bits (sdi_tog),
    .out_clk (clk),
    .out_resetn (resetn),
    .out_bits (tog_sync));

endmodule
