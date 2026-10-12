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
 * SPI translator: a store-and-forward bridge that lets one upstream chip
 * select reach multiple downstream SPI targets. The upstream side is a SPI
 * slave receiving a serialized SPI Engine instruction stream, see
 * spi_translator_decoder.v for the format; the downstream side replays it into
 * spi_engine_execution (NUM_OF_CS = 4, DATA_WIDTH = 8, NUM_OF_SDIO = 1).
 *
 * SDI bytes and SYNC ids come out on the resp_* stream until the upstream
 * MISO path returns them to the host.
 */

module spi_translator #(
  parameter UP_CPOL = 0,
  parameter UP_CPHA = 0,
  parameter HEADER_CRC_EN = 1,
  parameter CMD_FIFO_ADDRESS_WIDTH = 9,
  parameter SDO_FIFO_ADDRESS_WIDTH = 12,
  parameter RESP_FIFO_ADDRESS_WIDTH = 9
) (
  input                       clk,
  input                       resetn,

  // upstream SPI slave

  input                       sclk,
  input                       sdi,
  output                      sdo,
  output                      sdi_t,
  input                       cs,

  // SPI Engine control interface

  input                       cmd_ready,
  output                      cmd_valid,
  output      [15:0]          cmd,

  input                       sdo_data_ready,
  output                      sdo_data_valid,
  output      [7:0]           sdo_data,

  output                      sdi_data_ready,
  input                       sdi_data_valid,
  input       [7:0]           sdi_data,

  output                      sync_ready,
  input                       sync_valid,
  input       [7:0]           sync_data,

  output                      spi_resetn,

  // responses

  output                      resp_valid,
  output      [7:0]           resp_data,
  input                       resp_ready,

  output                      busy,
  output      [3:0]           err,
  output                      irq
);

  // internal signals

  wire  [7:0]                 rx_data;
  wire                        rx_valid;
  wire                        frame_start;
  wire                        frame_end;
  wire                        frame_active;

  wire                        reg_wr_en;
  wire  [7:0]                 reg_wr_addr;
  wire  [7:0]                 reg_wr_data;
  wire  [7:0]                 reg_rd_data;

  wire                        cmd_we;
  wire  [15:0]                cmd_wdata;
  wire                        cmd_full;
  wire  [CMD_FIFO_ADDRESS_WIDTH:0] cmd_room;
  wire                        sdo_we;
  wire  [7:0]                 sdo_wdata;
  wire                        sdo_full;
  wire  [SDO_FIFO_ADDRESS_WIDTH:0] sdo_room;
  wire                        commit;
  wire                        rollback;

  wire                        flush;
  wire                        crc_en;
  wire  [7:0]                 clk_div;
  wire  [3:0]                 spi_config;

  spi_translator_slave #(
    .DATA_WIDTH (8),
    .ADDRESS_WIDTH (4),
    .ASYNC_CLK (0),
    .CPOL (UP_CPOL),
    .CPHA (UP_CPHA),
    .STATUS_EN (1)
  ) i_spi_slave (
    .clk (clk),
    .resetn (resetn),
    .rx_data (rx_data),
    .rx_valid (rx_valid),
    .frame_start (frame_start),
    .frame_end (frame_end),
    .frame_active (frame_active),
    .spi_sclk (sclk),
    .spi_mosi (sdi),
    .spi_miso (sdo),
    .spi_miso_t (sdi_t),
    .spi_cs (cs));

  spi_translator_decoder i_decoder (
    .clk (clk),
    .resetn (resetn),
    .rx_data (rx_data),
    .rx_valid (rx_valid),
    .frame_start (frame_start),
    .frame_end (frame_end),
    .frame_active (frame_active),
    .cmd_we (cmd_we),
    .cmd_wdata (cmd_wdata),
    .cmd_full (cmd_full),
    .sdo_we (sdo_we),
    .sdo_wdata (sdo_wdata),
    .sdo_full (sdo_full),
    .commit (commit),
    .rollback (rollback),
    .reg_wr_en (reg_wr_en),
    .reg_wr_addr (reg_wr_addr),
    .reg_wr_data (reg_wr_data),
    .flush_req (flush),
    .err (err));

  spi_translator_execution #(
    .CMD_FIFO_ADDRESS_WIDTH (CMD_FIFO_ADDRESS_WIDTH),
    .SDO_FIFO_ADDRESS_WIDTH (SDO_FIFO_ADDRESS_WIDTH),
    .RESP_FIFO_ADDRESS_WIDTH (RESP_FIFO_ADDRESS_WIDTH)
  ) i_exec (
    .clk (clk),
    .resetn (resetn),
    .flush (flush),
    .cmd_we (cmd_we),
    .cmd_wdata (cmd_wdata),
    .cmd_full (cmd_full),
    .cmd_room (cmd_room),
    .sdo_we (sdo_we),
    .sdo_wdata (sdo_wdata),
    .sdo_full (sdo_full),
    .sdo_room (sdo_room),
    .commit (commit),
    .rollback (rollback),
    .busy (busy),
    .resp_valid (resp_valid),
    .resp_data (resp_data),
    .resp_ready (resp_ready),
    .cmd_ready (cmd_ready),
    .cmd_valid (cmd_valid),
    .cmd (cmd),
    .sdo_data_ready (sdo_data_ready),
    .sdo_data_valid (sdo_data_valid),
    .sdo_data (sdo_data),
    .sdi_data_ready (sdi_data_ready),
    .sdi_data_valid (sdi_data_valid),
    .sdi_data (sdi_data),
    .sync_ready (sync_ready),
    .sync_valid (sync_valid),
    .sync_data (sync_data),
    .spi_resetn (spi_resetn));

  spi_translator_regmap #(
    .HEADER_CRC_EN (HEADER_CRC_EN)
  ) i_regmap (
    .clk (clk),
    .resetn (resetn),
    .wr_en (reg_wr_en),
    .wr_addr (reg_wr_addr),
    .wr_data (reg_wr_data),
    .rd_addr (8'h00),
    .rd_data (reg_rd_data),
    .txn_count (8'h00),
    .crc_en (crc_en),
    .clk_div (clk_div),
    .spi_config (spi_config),
    .irq (irq));

endmodule
