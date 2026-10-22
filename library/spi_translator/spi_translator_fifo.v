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
 * Single-clock FIFO with commit and rollback on the write side.
 *
 * Writes advance a speculative write pointer and are invisible to the reader
 * until commit publishes them. rollback discards everything written since the
 * last commit. clear empties the FIFO. A rollback or clear in the same cycle
 * as a write wins over it.
 *
 * s_full and s_room account for uncommitted entries, so a writer that
 * respects them never overwrites data the reader has not taken yet.
 */

module spi_translator_fifo #(
  parameter DATA_WIDTH = 8,
  parameter ADDRESS_WIDTH = 9
) (
  input                       clk,
  input                       resetn,
  input                       clear,

  // write side

  input                       s_valid,
  input   [DATA_WIDTH-1:0]    s_data,
  output                      s_full,
  output  [ADDRESS_WIDTH:0]   s_room,
  input                       commit,
  input                       rollback,

  // read side

  output                      m_valid,
  output  [DATA_WIDTH-1:0]    m_data,
  input                       m_ready
);

  localparam [ADDRESS_WIDTH:0] DEPTH = 2**ADDRESS_WIDTH;

  reg   [ADDRESS_WIDTH:0]     wr_ptr = 'h0;
  reg   [ADDRESS_WIDTH:0]     commit_ptr = 'h0;
  reg   [ADDRESS_WIDTH:0]     rd_ptr = 'h0;
  reg                         q_valid = 1'b0;

  wire  [ADDRESS_WIDTH:0]     used;
  wire                        wr;
  wire                        rd;

  // entries already read into the output register no longer occupy memory
  assign used   = wr_ptr - rd_ptr;
  assign s_full = (used == DEPTH);
  assign s_room = DEPTH - used;

  assign wr = s_valid & ~s_full & ~rollback & ~clear;
  assign rd = (rd_ptr != commit_ptr) && (~q_valid || m_ready);

  assign m_valid = q_valid;

  always @(posedge clk) begin
    if (resetn == 1'b0 || clear == 1'b1) begin
      wr_ptr <= 'h0;
      commit_ptr <= 'h0;
    end else begin
      if (rollback) begin
        wr_ptr <= commit_ptr;
      end else if (wr) begin
        wr_ptr <= wr_ptr + 1'b1;
      end
      if (commit && ~rollback) begin
        commit_ptr <= wr ? wr_ptr + 1'b1 : wr_ptr;
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0 || clear == 1'b1) begin
      rd_ptr <= 'h0;
      q_valid <= 1'b0;
    end else begin
      if (rd) begin
        rd_ptr <= rd_ptr + 1'b1;
        q_valid <= 1'b1;
      end else if (m_ready) begin
        q_valid <= 1'b0;
      end
    end
  end

  // the registered memory output is the FIFO output; it only changes on a read
  ad_mem #(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDRESS_WIDTH (ADDRESS_WIDTH)
  ) i_mem (
    .clka (clk),
    .wea (wr),
    .addra (wr_ptr[ADDRESS_WIDTH-1:0]),
    .dina (s_data),
    .clkb (clk),
    .reb (rd),
    .addrb (rd_ptr[ADDRESS_WIDTH-1:0]),
    .doutb (m_data));

endmodule
