// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

// SPI-slave data helper.
//
// Buffers ADC samples in an asynchronous FIFO and streams them out over a plain
// SPI-slave interface to an external SPI master. The write side runs in the ADC
// clock domain; if the FIFO is full the incoming beat is dropped (overflow =
// lose samples). The read side is an oversampled SPI slave running entirely in
// the system clock domain: the external SCK/CS/MOSI pins are treated as
// asynchronous data, synchronized with 2-FF chains, and their edges detected on
// the system clock. This avoids using SCK as a real clock and keeps the FIFO
// read port in a single clock domain.
//
// SPI format: Mode 3 (CPOL=1, CPHA=1), MSB-first, DATA_WIDTH bits per transfer.
// The master watches data_ready_n (active low, = FIFO not-empty), asserts CS,
// then clocks out one word. data_ready_n is asserted (low) whenever a word is
// available.

module spi_slave #(
  parameter DATA_WIDTH = 32,
  parameter ADDRESS_WIDTH = 1
) (

  // ADC write interface (ADC clock domain)

  input                       adc_clk,
  input                       adc_rst,
  input   [DATA_WIDTH-1:0]    adc_data,
  input                       adc_valid,

  // system clock / reset (SPI read side)

  input                       clk,
  input                       resetn,

  // external SPI-slave interface (asynchronous to clk)

  input                       spi_cs,
  input                       spi_sclk,
  input                       spi_mosi,
  output                      spi_miso,
  output                      data_ready_n
);

  // internal signals

  wire  [DATA_WIDTH-1:0]      m_axis_data;
  wire                        m_axis_valid;
  wire                        m_axis_empty;
  reg                         m_axis_ready = 1'b0;

  wire  [2:0]                 spi_sync;
  wire                        cs_sync;
  wire                        sclk_sync;
  wire                        mosi_sync;

  // cs_d/sclk_d reset to 0 to match the synchronizer output reset value
  // (sync_bits stages reset to 0). If these reset to 1 while cs_sync/sclk_sync
  // reset to 0, the first clock after resetn deasserts sees a phantom
  // cs_fall (= cs_d & ~cs_sync = 1 & 1), which would spuriously pop/drop a
  // buffered FIFO word and glitch MISO at startup. Resetting to 0 keeps the
  // edge detectors quiet until the real pin levels propagate through the sync.
  reg                         cs_d = 1'b0;
  reg                         sclk_d = 1'b0;

  reg   [DATA_WIDTH-1:0]      shift_reg = {DATA_WIDTH{1'b0}};
  reg                         miso_reg = 1'b0;

  // edge / level detection in the system clock domain

  wire                        cs_active;
  wire                        cs_fall;
  wire                        sclk_fall;

  assign cs_active = ~cs_sync;             // CS is active low
  assign cs_fall   = cs_d & ~cs_sync;      // CS asserted (high -> low)
  assign sclk_fall = sclk_d & ~sclk_sync;  // SCK leading edge for Mode 3

  assign spi_miso     = miso_reg;
  // data_ready_n is driven from m_axis_valid, not m_axis_empty: with
  // M_AXIS_REGISTERED=1 the FIFO holds one beat in an output register that
  // m_axis_empty (which only tracks the internal RAM) does not count. Using
  // m_axis_valid means data_ready_n is asserted (low) whenever a word is
  // actually available to read -- including the final buffered word.
  assign data_ready_n = ~m_axis_valid;

  // synchronize the asynchronous SPI pins into the system clock domain

  sync_bits #(
    .NUM_OF_BITS (3),
    .ASYNC_CLK (1)
  ) i_spi_sync (
    .in_bits ({spi_mosi, spi_sclk, spi_cs}),
    .out_resetn (resetn),
    .out_clk (clk),
    .out_bits (spi_sync));

  assign cs_sync   = spi_sync[0];
  assign sclk_sync = spi_sync[1];
  assign mosi_sync = spi_sync[2];

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      // reset to 0 to match the synchronizer output (which resets to 0),
      // so no phantom cs_fall/sclk_fall is generated on reset release.
      cs_d   <= 1'b0;
      sclk_d <= 1'b0;
    end else begin
      cs_d   <= cs_sync;
      sclk_d <= sclk_sync;
    end
  end

  // SPI-slave shift logic (Mode 3: shift MISO out on the SCK falling edge,
  // master samples on the rising edge). One CS-framed transfer pops and shifts
  // out one FIFO word, MSB first.

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      shift_reg <= {DATA_WIDTH{1'b0}};
      miso_reg  <= 1'b0;
      m_axis_ready <= 1'b0;
    end else begin
      m_axis_ready <= 1'b0;
      if (cs_fall) begin
        // CS asserted: latch the head word and pop it from the FIFO.
        shift_reg <= m_axis_data;
        miso_reg  <= m_axis_data[DATA_WIDTH-1];
        m_axis_ready <= m_axis_valid;
      end else if (cs_active & sclk_fall) begin
        miso_reg  <= shift_reg[DATA_WIDTH-1];
        shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};
      end
    end
  end

  // asynchronous sample FIFO: write side = ADC domain, read side = system clock

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
    .m_axis_empty (m_axis_empty),
    .m_axis_almost_empty (),
    .s_axis_aclk (adc_clk),
    .s_axis_aresetn (~adc_rst),
    .s_axis_ready (),
    .s_axis_valid (adc_valid),
    .s_axis_data (adc_data),
    .s_axis_tkeep ({(DATA_WIDTH/8){1'b1}}),
    .s_axis_tlast (1'b0),
    .s_axis_room (),
    .s_axis_full (),
    .s_axis_almost_full ());

endmodule
