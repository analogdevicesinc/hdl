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
 * select reach multiple downstream SPI targets. The upstream side is a SPI slave;
 * the downstream side is a command-stream manager for spi_engine_execution.
 */

module spi_translator #(
  parameter UP_CPOL = 0,
  parameter UP_CPHA = 0,
  parameter HEADER_CRC_EN = 1
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

  output                      irq
);

  // internal signals

  wire  [7:0]                 rx_data;
  wire                        rx_valid;
  wire                        frame_start;
  wire                        frame_end;
  wire                        frame_active;
  wire  [7:0]                 tx_data;
  wire                        tx_valid;
  wire                        tx_ready;

  wire                        reg_wr_en;
  wire  [7:0]                 reg_wr_addr;
  wire  [7:0]                 reg_wr_data;
  wire  [7:0]                 reg_rd_addr;
  wire  [7:0]                 reg_rd_data;

  wire                        payload_we;
  wire  [7:0]                 payload_addr;
  wire  [7:0]                 payload_data;
  wire                        commit;
  wire                        commit_rw;
  wire  [1:0]                 commit_target;
  wire                        commit_long;
  wire  [7:0]                 commit_len;
  wire  [7:0]                 commit_wlen;

  wire                        busy;
  wire  [7:0]                 txn_count;

  wire                        resp_valid;
  wire  [7:0]                 resp_data;
  wire                        resp_ready;
  wire                        resp_rdy;
  wire                        resp_done;

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

  spi_translator_decoder
    i_decoder (
    .clk (clk),
    .resetn (resetn),
    .flush (flush),
    .crc_en (crc_en),
    .rx_data (rx_data),
    .rx_valid (rx_valid),
    .frame_start (frame_start),
    .frame_end (frame_end),
    .frame_active (frame_active),
    .tx_valid (tx_valid),
    .tx_data (tx_data),
    .tx_ready (tx_ready),
    .reg_wr_en (reg_wr_en),
    .reg_wr_addr (reg_wr_addr),
    .reg_wr_data (reg_wr_data),
    .reg_rd_data (reg_rd_data),
    .payload_we (payload_we),
    .payload_addr (payload_addr),
    .payload_data (payload_data),
    .commit (commit),
    .commit_rw (commit_rw),
    .commit_target (commit_target),
    .commit_long (commit_long),
    .commit_len (commit_len),
    .commit_wlen (commit_wlen),
    .resp_rdy (resp_rdy),
    .resp_valid (resp_valid),
    .resp_data (resp_data),
    .resp_ready (resp_ready),
    .resp_done (resp_done),
    .flush_req (flush));

  spi_translator_execution
    i_exec (
    .clk (clk),
    .resetn (resetn),
    .flush (flush),
    .clk_div (clk_div),
    .spi_config (spi_config),
    .payload_we (payload_we),
    .payload_addr (payload_addr),
    .payload_data (payload_data),
    .commit (commit),
    .commit_rw (commit_rw),
    .commit_target (commit_target),
    .commit_long (commit_long),
    .commit_len (commit_len),
    .commit_wlen (commit_wlen),
    .busy (busy),
    .txn_count (txn_count),
    .resp_valid (resp_valid),
    .resp_data (resp_data),
    .resp_ready (resp_ready),
    .resp_rdy (resp_rdy),
    .resp_done (resp_done),
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
    .sync_data (sync_data));

  spi_translator_regmap #(
    .HEADER_CRC_EN (HEADER_CRC_EN)
  ) i_regmap (
    .clk (clk),
    .resetn (resetn),
    .wr_en (reg_wr_en),
    .wr_addr (reg_wr_addr),
    .wr_data (reg_wr_data),
    .rd_addr (reg_rd_addr),
    .rd_data (reg_rd_data),
    .txn_count (txn_count),
    .crc_en (crc_en),
    .clk_div (clk_div),
    .spi_config (spi_config),
    .irq (irq));

endmodule
