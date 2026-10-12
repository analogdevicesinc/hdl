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
 * SDI bytes and SYNC ids from the engine are queued, in the order the engine
 * produces them, in the response FIFO. The engine is back-pressured when the
 * FIFO is full. FLUSH empties all three FIFOs and resets the engine, which
 * deasserts every downstream chip select.
 */

module spi_translator_execution #(
  parameter CMD_FIFO_ADDRESS_WIDTH = 9,
  parameter SDO_FIFO_ADDRESS_WIDTH = 12,
  parameter RESP_FIFO_ADDRESS_WIDTH = 9
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

  output                              busy,

  // response stream

  output                              resp_valid,
  output      [7:0]                   resp_data,
  input                               resp_ready,

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

  wire                        resp_s_valid;
  wire                        resp_s_ready;
  wire  [7:0]                 resp_s_data;

  // pending work: committed entries not yet taken, or the engine not idle
  assign busy = cmd_valid | sdo_data_valid | ~cmd_ready;

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

  // responses: SDI bytes take precedence over a SYNC id in the same cycle

  assign resp_s_valid   = sdi_data_valid | sync_valid;
  assign resp_s_data    = sdi_data_valid ? sdi_data : sync_data;
  assign sdi_data_ready = resp_s_ready;
  assign sync_ready     = resp_s_ready & ~sdi_data_valid;

  util_axis_fifo #(
    .DATA_WIDTH (8),
    .ADDRESS_WIDTH (RESP_FIFO_ADDRESS_WIDTH),
    .ASYNC_CLK (0),
    .M_AXIS_REGISTERED (1),
    .TLAST_EN (0),
    .TKEEP_EN (0)
  ) i_resp_fifo (
    .m_axis_aclk (clk),
    .m_axis_aresetn (resetn & ~abort),
    .m_axis_ready (resp_ready),
    .m_axis_valid (resp_valid),
    .m_axis_data (resp_data),
    .m_axis_tkeep (),
    .m_axis_tlast (),
    .m_axis_level (),
    .m_axis_empty (),
    .m_axis_almost_empty (),
    .s_axis_aclk (clk),
    .s_axis_aresetn (resetn & ~abort),
    .s_axis_ready (resp_s_ready),
    .s_axis_valid (resp_s_valid),
    .s_axis_data (resp_s_data),
    .s_axis_tkeep (1'b1),
    .s_axis_tlast (1'b0),
    .s_axis_room (),
    .s_axis_full (),
    .s_axis_almost_full ());

endmodule
