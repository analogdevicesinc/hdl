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
 * Execution side of the bridge: the transactional CMD and SDO FIFOs that feed
 * spi_engine_execution, and the response FIFO it returns into.
 *
 * The decoder writes each frame into the CMD and SDO FIFOs and commits it to
 * both in the same cycle, so the engine only ever sees complete, checked
 * frames. The engine takes a TRANSFER from the CMD FIFO before it asks for
 * that transfer's SDO bytes, so the two streams need no further ordering.
 * Further frames queue behind the one executing, as long as there is room.
 *
 * SDI bytes from the engine are queued in the response FIFO; the engine is
 * back-pressured when it is full. The decoder reads it for FETCH; the reads
 * are speculative and only released by the commit of the FETCH frame, so a
 * FETCH in a rejected frame returns the same bytes when retried.
 *
 * SYNC ids are not queued: last_sync holds the id of the last SYNC the engine
 * executed, as in axi_spi_engine. The engine only reaches a SYNC once the
 * transfers before it are done and their SDI bytes are in the response FIFO,
 * so when last_sync shows a message's id, its whole response can be fetched.
 * resp_level counts the SDI bytes queued and not yet released.
 *
 * FLUSH empties all three FIFOs and resets the engine, which deasserts every
 * downstream chip select. last_sync is kept, so the host can tell which
 * messages ran before the flush.
 *
 * status, readable in the STATUS register:
 *   [7]   BUSY      committed work pending, or the engine not idle
 *   [6]   RESP_RDY  nothing left to execute and SDI bytes waiting: the
 *                   response of everything sent so far can be fetched
 *   [5:3] ERR       sticky frame errors from the decoder, cleared by FLUSH:
 *                   [5] truncated, [4] overflow, [3] bad instruction
 *   [2:0] CREDIT    free space, in eighths of the fuller of the CMD and SDO
 *                   FIFOs, saturated at 7
 */

module spi_translator_execution #(
  parameter CMD_FIFO_ADDRESS_WIDTH = 8,
  parameter SDO_FIFO_ADDRESS_WIDTH = 8,
  parameter RESP_FIFO_ADDRESS_WIDTH = 8
) (
  input                               clk,
  input                               resetn,

  input                               flush,

  // CMD and SDO FIFO write side, from the decoder

  input                               cmd_we,
  input       [15:0]                  cmd_wdata,
  output                              cmd_full,
  output      [CMD_FIFO_ADDRESS_WIDTH:0] cmd_room,

  input                               sdo_we,
  input       [7:0]                   sdo_wdata,
  output                              sdo_full,
  output      [SDO_FIFO_ADDRESS_WIDTH:0] sdo_room,

  input                               commit,
  input                               rollback,

  // status

  input       [2:0]                   err,
  output      [7:0]                   status,

  // response FIFO read side, released together with the CMD/SDO commit

  output                              resp_valid,
  output      [7:0]                   resp_data,
  input                               resp_ready,
  output      [RESP_FIFO_ADDRESS_WIDTH:0] resp_level,
  output      [7:0]                   last_sync,

  // SPI Engine control interface

  input                               cmd_ready,
  output                              cmd_valid,
  output      [15:0]                  cmd,

  input                               sdo_data_ready,
  output                              sdo_data_valid,
  output      [7:0]                   sdo_data,

  output                              sdi_data_ready,
  input                               sdi_data_valid,
  input       [7:0]                   sdi_data,

  output                              sync_ready,
  input                               sync_valid,
  input       [7:0]                   sync_data,

  output                              spi_resetn
);

  reg                         abort = 1'b0;
  reg   [3:0]                 rst_count = 4'h0;

  wire                        resp_s_full;
  wire  [RESP_FIFO_ADDRESS_WIDTH:0] resp_s_room;

  reg   [7:0]                 last_sync_reg = 8'h00;

  wire                        busy;
  wire                        sdi_rdy;
  wire  [3:0]                 cmd_eighths;
  wire  [3:0]                 sdo_eighths;
  wire  [3:0]                 eighths;
  wire  [2:0]                 credit;

  // pending work: committed entries not yet taken, or the engine not idle
  assign busy = cmd_valid | sdo_data_valid | ~cmd_ready;

  assign sdi_rdy = (resp_level != 'h0);

  assign cmd_eighths = cmd_room[CMD_FIFO_ADDRESS_WIDTH:CMD_FIFO_ADDRESS_WIDTH-3];
  assign sdo_eighths = sdo_room[SDO_FIFO_ADDRESS_WIDTH:SDO_FIFO_ADDRESS_WIDTH-3];
  assign eighths     = (cmd_eighths < sdo_eighths) ? cmd_eighths : sdo_eighths;
  assign credit      = eighths[3] ? 3'd7 : eighths[2:0];

  assign status = {busy, ~busy & sdi_rdy, err, credit};

  assign spi_resetn = resetn && (rst_count == 4'h0);

  // flush resets the engine for a few cycles, which deasserts all its CS

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      abort <= 1'b0;
      rst_count <= 4'h0;
    end else begin
      abort <= flush;
      if (flush) begin
        rst_count <= 4'hf;
      end else if (rst_count != 4'h0) begin
        rst_count <= rst_count - 1'b1;
      end
    end
  end

  spi_translator_fifo #(
    .DATA_WIDTH (16),
    .ADDRESS_WIDTH (CMD_FIFO_ADDRESS_WIDTH)
  ) i_cmd_fifo (
    .clk (clk),
    .resetn (resetn),
    .clear (abort),
    .s_valid (cmd_we),
    .s_data (cmd_wdata),
    .s_full (cmd_full),
    .s_room (cmd_room),
    .commit (commit),
    .rollback (rollback),
    .m_valid (cmd_valid),
    .m_data (cmd),
    .m_ready (cmd_ready));

  spi_translator_fifo #(
    .DATA_WIDTH (8),
    .ADDRESS_WIDTH (SDO_FIFO_ADDRESS_WIDTH)
  ) i_sdo_fifo (
    .clk (clk),
    .resetn (resetn),
    .clear (abort),
    .s_valid (sdo_we),
    .s_data (sdo_wdata),
    .s_full (sdo_full),
    .s_room (sdo_room),
    .commit (commit),
    .rollback (rollback),
    .m_valid (sdo_data_valid),
    .m_data (sdo_data),
    .m_ready (sdo_data_ready));

  // responses: SDI bytes only; SYNC ids update last_sync and never wait

  assign sdi_data_ready = ~resp_s_full;
  assign sync_ready     = 1'b1;

  assign resp_level = (2**RESP_FIFO_ADDRESS_WIDTH) - resp_s_room;
  assign last_sync  = last_sync_reg;

  spi_translator_fifo #(
    .DATA_WIDTH (8),
    .ADDRESS_WIDTH (RESP_FIFO_ADDRESS_WIDTH),
    .READ_TXN (1)
  ) i_resp_fifo (
    .clk (clk),
    .resetn (resetn),
    .clear (abort),
    .s_valid (sdi_data_valid),
    .s_data (sdi_data),
    .s_full (resp_s_full),
    .s_room (resp_s_room),
    .commit (commit),
    .rollback (rollback),
    .m_valid (resp_valid),
    .m_data (resp_data),
    .m_ready (resp_ready));

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      last_sync_reg <= 8'h00;
    end else if (sync_valid) begin
      last_sync_reg <= sync_data;
    end
  end

endmodule
