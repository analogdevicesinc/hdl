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
 * Routes the instruction stream of spi_translator_slave to one of NUM_OF_ENGINES
 * spi_engine_execution instances at a time.
 *
 * The engine is chosen by the bridge instruction SELECT (0xC0ee, engine ee),
 * which the decoder queues in the CMD FIFO like an engine instruction. The
 * interconnect consumes it and never forwards it; every other instruction and
 * every SDO byte goes to the selected engine, and SDI bytes and SYNC ids come
 * from it. Engine 0 is selected after reset; resetn is the translator's
 * spi_resetn, so FLUSH returns to engine 0 as well.
 *
 * The decoder only accepts a SELECT that names an existing engine and leaves no
 * chip select asserted on the previous one; it is not checked again here.
 *
 * An engine reports idle before the last SDI word of a read has left its
 * SDI_DELAY / ECHO_SCLK pipeline. To keep that word with its own engine and
 * its own message, the interconnect counts the SDI words still due: a TRANSFER
 * with its read bit set (cmd[9]) adds n + 1 = cmd[7:0] + 1, each word handed to
 * the translator removes one. No instruction, SELECT included, is taken while
 * words are due. Hence
 *   - a SELECT only switches once the old engine has delivered everything;
 *   - a SYNC only executes once the SDI words before it are queued, so
 *     SYNC_ID never runs ahead of the response FIFO;
 *   - s_cmd_ready stays low meanwhile, so the translator's BUSY stays set and
 *     RESP_RDY cannot rise early.
 * The cost is a few clk cycles between a read TRANSFER and the next
 * instruction.
 *
 * Ports for engines NUM_OF_ENGINES and above are unused: their outputs are
 * held low and their inputs ignored.
 */

module spi_translator_interconnect #(
  parameter NUM_OF_ENGINES = 1
) (
  input                       clk,
  input                       resetn,

  // from spi_translator_slave

  output                      s_cmd_ready,
  input                       s_cmd_valid,
  input       [15:0]          s_cmd_data,

  output                      s_sdo_ready,
  input                       s_sdo_valid,
  input       [7:0]           s_sdo_data,

  input                       s_sdi_ready,
  output                      s_sdi_valid,
  output      [7:0]           s_sdi_data,

  input                       s_sync_ready,
  output                      s_sync_valid,
  output      [7:0]           s_sync_data,

  // engine 0

  input                       m0_cmd_ready,
  output                      m0_cmd_valid,
  output      [15:0]          m0_cmd_data,

  input                       m0_sdo_ready,
  output                      m0_sdo_valid,
  output      [7:0]           m0_sdo_data,

  output                      m0_sdi_ready,
  input                       m0_sdi_valid,
  input       [7:0]           m0_sdi_data,

  output                      m0_sync_ready,
  input                       m0_sync_valid,
  input       [7:0]           m0_sync_data,

  // engine 1

  input                       m1_cmd_ready,
  output                      m1_cmd_valid,
  output      [15:0]          m1_cmd_data,

  input                       m1_sdo_ready,
  output                      m1_sdo_valid,
  output      [7:0]           m1_sdo_data,

  output                      m1_sdi_ready,
  input                       m1_sdi_valid,
  input       [7:0]           m1_sdi_data,

  output                      m1_sync_ready,
  input                       m1_sync_valid,
  input       [7:0]           m1_sync_data,

  // engine 2

  input                       m2_cmd_ready,
  output                      m2_cmd_valid,
  output      [15:0]          m2_cmd_data,

  input                       m2_sdo_ready,
  output                      m2_sdo_valid,
  output      [7:0]           m2_sdo_data,

  output                      m2_sdi_ready,
  input                       m2_sdi_valid,
  input       [7:0]           m2_sdi_data,

  output                      m2_sync_ready,
  input                       m2_sync_valid,
  input       [7:0]           m2_sync_data,

  // engine 3

  input                       m3_cmd_ready,
  output                      m3_cmd_valid,
  output      [15:0]          m3_cmd_data,

  input                       m3_sdo_ready,
  output                      m3_sdo_valid,
  output      [7:0]           m3_sdo_data,

  output                      m3_sdi_ready,
  input                       m3_sdi_valid,
  input       [7:0]           m3_sdi_data,

  output                      m3_sync_ready,
  input                       m3_sync_valid,
  input       [7:0]           m3_sync_data,

  // engine 4

  input                       m4_cmd_ready,
  output                      m4_cmd_valid,
  output      [15:0]          m4_cmd_data,

  input                       m4_sdo_ready,
  output                      m4_sdo_valid,
  output      [7:0]           m4_sdo_data,

  output                      m4_sdi_ready,
  input                       m4_sdi_valid,
  input       [7:0]           m4_sdi_data,

  output                      m4_sync_ready,
  input                       m4_sync_valid,
  input       [7:0]           m4_sync_data,

  // engine 5

  input                       m5_cmd_ready,
  output                      m5_cmd_valid,
  output      [15:0]          m5_cmd_data,

  input                       m5_sdo_ready,
  output                      m5_sdo_valid,
  output      [7:0]           m5_sdo_data,

  output                      m5_sdi_ready,
  input                       m5_sdi_valid,
  input       [7:0]           m5_sdi_data,

  output                      m5_sync_ready,
  input                       m5_sync_valid,
  input       [7:0]           m5_sync_data,

  // engine 6

  input                       m6_cmd_ready,
  output                      m6_cmd_valid,
  output      [15:0]          m6_cmd_data,

  input                       m6_sdo_ready,
  output                      m6_sdo_valid,
  output      [7:0]           m6_sdo_data,

  output                      m6_sdi_ready,
  input                       m6_sdi_valid,
  input       [7:0]           m6_sdi_data,

  output                      m6_sync_ready,
  input                       m6_sync_valid,
  input       [7:0]           m6_sync_data,

  // engine 7

  input                       m7_cmd_ready,
  output                      m7_cmd_valid,
  output      [15:0]          m7_cmd_data,

  input                       m7_sdo_ready,
  output                      m7_sdo_valid,
  output      [7:0]           m7_sdo_data,

  output                      m7_sdi_ready,
  input                       m7_sdi_valid,
  input       [7:0]           m7_sdi_data,

  output                      m7_sync_ready,
  input                       m7_sync_valid,
  input       [7:0]           m7_sync_data,

  // engine 8

  input                       m8_cmd_ready,
  output                      m8_cmd_valid,
  output      [15:0]          m8_cmd_data,

  input                       m8_sdo_ready,
  output                      m8_sdo_valid,
  output      [7:0]           m8_sdo_data,

  output                      m8_sdi_ready,
  input                       m8_sdi_valid,
  input       [7:0]           m8_sdi_data,

  output                      m8_sync_ready,
  input                       m8_sync_valid,
  input       [7:0]           m8_sync_data,

  // engine 9

  input                       m9_cmd_ready,
  output                      m9_cmd_valid,
  output      [15:0]          m9_cmd_data,

  input                       m9_sdo_ready,
  output                      m9_sdo_valid,
  output      [7:0]           m9_sdo_data,

  output                      m9_sdi_ready,
  input                       m9_sdi_valid,
  input       [7:0]           m9_sdi_data,

  output                      m9_sync_ready,
  input                       m9_sync_valid,
  input       [7:0]           m9_sync_data,

  // engine 10

  input                       m10_cmd_ready,
  output                      m10_cmd_valid,
  output      [15:0]          m10_cmd_data,

  input                       m10_sdo_ready,
  output                      m10_sdo_valid,
  output      [7:0]           m10_sdo_data,

  output                      m10_sdi_ready,
  input                       m10_sdi_valid,
  input       [7:0]           m10_sdi_data,

  output                      m10_sync_ready,
  input                       m10_sync_valid,
  input       [7:0]           m10_sync_data,

  // engine 11

  input                       m11_cmd_ready,
  output                      m11_cmd_valid,
  output      [15:0]          m11_cmd_data,

  input                       m11_sdo_ready,
  output                      m11_sdo_valid,
  output      [7:0]           m11_sdo_data,

  output                      m11_sdi_ready,
  input                       m11_sdi_valid,
  input       [7:0]           m11_sdi_data,

  output                      m11_sync_ready,
  input                       m11_sync_valid,
  input       [7:0]           m11_sync_data,

  // engine 12

  input                       m12_cmd_ready,
  output                      m12_cmd_valid,
  output      [15:0]          m12_cmd_data,

  input                       m12_sdo_ready,
  output                      m12_sdo_valid,
  output      [7:0]           m12_sdo_data,

  output                      m12_sdi_ready,
  input                       m12_sdi_valid,
  input       [7:0]           m12_sdi_data,

  output                      m12_sync_ready,
  input                       m12_sync_valid,
  input       [7:0]           m12_sync_data,

  // engine 13

  input                       m13_cmd_ready,
  output                      m13_cmd_valid,
  output      [15:0]          m13_cmd_data,

  input                       m13_sdo_ready,
  output                      m13_sdo_valid,
  output      [7:0]           m13_sdo_data,

  output                      m13_sdi_ready,
  input                       m13_sdi_valid,
  input       [7:0]           m13_sdi_data,

  output                      m13_sync_ready,
  input                       m13_sync_valid,
  input       [7:0]           m13_sync_data,

  // engine 14

  input                       m14_cmd_ready,
  output                      m14_cmd_valid,
  output      [15:0]          m14_cmd_data,

  input                       m14_sdo_ready,
  output                      m14_sdo_valid,
  output      [7:0]           m14_sdo_data,

  output                      m14_sdi_ready,
  input                       m14_sdi_valid,
  input       [7:0]           m14_sdi_data,

  output                      m14_sync_ready,
  input                       m14_sync_valid,
  input       [7:0]           m14_sync_data,

  // engine 15

  input                       m15_cmd_ready,
  output                      m15_cmd_valid,
  output      [15:0]          m15_cmd_data,

  input                       m15_sdo_ready,
  output                      m15_sdo_valid,
  output      [7:0]           m15_sdo_data,

  output                      m15_sdi_ready,
  input                       m15_sdi_valid,
  input       [7:0]           m15_sdi_data,

  output                      m15_sync_ready,
  input                       m15_sync_valid,
  input       [7:0]           m15_sync_data
);

  localparam NUM_OF_PORTS = 16;

  reg   [3:0]                 sel = 4'h0;
  reg   [8:0]                 sdi_pending = 9'h000;

  wire  [NUM_OF_PORTS-1:0]    m_cmd_ready_s;
  wire  [NUM_OF_PORTS-1:0]    m_sdo_ready_s;
  wire  [NUM_OF_PORTS-1:0]    m_sdi_valid_s;
  wire  [7:0]                 m_sdi_data_s [0:NUM_OF_PORTS-1];
  wire  [NUM_OF_PORTS-1:0]    m_sync_valid_s;
  wire  [7:0]                 m_sync_data_s [0:NUM_OF_PORTS-1];

  wire  [NUM_OF_PORTS-1:0]    m_cmd_valid_s;
  wire  [NUM_OF_PORTS-1:0]    m_sdo_valid_s;
  wire  [NUM_OF_PORTS-1:0]    m_sdi_ready_s;
  wire  [NUM_OF_PORTS-1:0]    m_sync_ready_s;

  wire  [NUM_OF_PORTS-1:0]    en;
  wire                        is_select;
  wire                        is_read;
  wire                        cmd_take;
  wire                        sdi_take;

  // one-hot selected engine, never one that is not built
  genvar i;
  generate
    for (i = 0; i < NUM_OF_PORTS; i = i + 1) begin : g_en
      assign en[i] = (i < NUM_OF_ENGINES) && (sel == i);
    end
  endgenerate

  assign is_select = s_cmd_data[15:12] == 4'hc;
  assign is_read   = s_cmd_data[15:12] == 4'h0 && s_cmd_data[9];

  // an instruction is taken when no SDI word is due and, unless it is a
  // SELECT, the selected engine takes it; a SELECT also waits for the engine
  // to be idle
  assign s_cmd_ready = (sdi_pending == 9'h000) && |(m_cmd_ready_s & en);
  assign cmd_take    = s_cmd_valid & s_cmd_ready;

  assign m_cmd_valid_s  = (s_cmd_valid && ~is_select && sdi_pending == 9'h000) ? en : {NUM_OF_PORTS{1'b0}};
  assign m_sdo_valid_s  = s_sdo_valid ? en : {NUM_OF_PORTS{1'b0}};
  assign m_sdi_ready_s  = s_sdi_ready ? en : {NUM_OF_PORTS{1'b0}};
  assign m_sync_ready_s = s_sync_ready ? en : {NUM_OF_PORTS{1'b0}};

  assign s_sdo_ready  = |(m_sdo_ready_s & en);
  assign s_sdi_valid  = |(m_sdi_valid_s & en);
  assign s_sdi_data   = m_sdi_data_s[sel];
  assign s_sync_valid = |(m_sync_valid_s & en);
  assign s_sync_data  = m_sync_data_s[sel];

  assign sdi_take = s_sdi_valid & s_sdi_ready;

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      sel <= 4'h0;
      sdi_pending <= 9'h000;
    end else begin
      if (cmd_take && is_select) begin
        sel <= s_cmd_data[3:0];
      end
      // words are only added while none is due, so never in the same cycle
      // as one is taken
      if (cmd_take && is_read) begin
        sdi_pending <= {1'b0, s_cmd_data[7:0]} + 9'd1;
      end else if (sdi_take && sdi_pending != 9'h000) begin
        sdi_pending <= sdi_pending - 1'b1;
      end
    end
  end

  assign m_cmd_ready_s[0] = m0_cmd_ready;
  assign m_sdo_ready_s[0] = m0_sdo_ready;
  assign m_sdi_valid_s[0] = m0_sdi_valid;
  assign m_sdi_data_s[0] = m0_sdi_data;
  assign m_sync_valid_s[0] = m0_sync_valid;
  assign m_sync_data_s[0] = m0_sync_data;

  assign m0_cmd_valid = m_cmd_valid_s[0];
  assign m0_cmd_data = s_cmd_data;
  assign m0_sdo_valid = m_sdo_valid_s[0];
  assign m0_sdo_data = s_sdo_data;
  assign m0_sdi_ready = m_sdi_ready_s[0];
  assign m0_sync_ready = m_sync_ready_s[0];

  assign m_cmd_ready_s[1] = m1_cmd_ready;
  assign m_sdo_ready_s[1] = m1_sdo_ready;
  assign m_sdi_valid_s[1] = m1_sdi_valid;
  assign m_sdi_data_s[1] = m1_sdi_data;
  assign m_sync_valid_s[1] = m1_sync_valid;
  assign m_sync_data_s[1] = m1_sync_data;

  assign m1_cmd_valid = m_cmd_valid_s[1];
  assign m1_cmd_data = s_cmd_data;
  assign m1_sdo_valid = m_sdo_valid_s[1];
  assign m1_sdo_data = s_sdo_data;
  assign m1_sdi_ready = m_sdi_ready_s[1];
  assign m1_sync_ready = m_sync_ready_s[1];

  assign m_cmd_ready_s[2] = m2_cmd_ready;
  assign m_sdo_ready_s[2] = m2_sdo_ready;
  assign m_sdi_valid_s[2] = m2_sdi_valid;
  assign m_sdi_data_s[2] = m2_sdi_data;
  assign m_sync_valid_s[2] = m2_sync_valid;
  assign m_sync_data_s[2] = m2_sync_data;

  assign m2_cmd_valid = m_cmd_valid_s[2];
  assign m2_cmd_data = s_cmd_data;
  assign m2_sdo_valid = m_sdo_valid_s[2];
  assign m2_sdo_data = s_sdo_data;
  assign m2_sdi_ready = m_sdi_ready_s[2];
  assign m2_sync_ready = m_sync_ready_s[2];

  assign m_cmd_ready_s[3] = m3_cmd_ready;
  assign m_sdo_ready_s[3] = m3_sdo_ready;
  assign m_sdi_valid_s[3] = m3_sdi_valid;
  assign m_sdi_data_s[3] = m3_sdi_data;
  assign m_sync_valid_s[3] = m3_sync_valid;
  assign m_sync_data_s[3] = m3_sync_data;

  assign m3_cmd_valid = m_cmd_valid_s[3];
  assign m3_cmd_data = s_cmd_data;
  assign m3_sdo_valid = m_sdo_valid_s[3];
  assign m3_sdo_data = s_sdo_data;
  assign m3_sdi_ready = m_sdi_ready_s[3];
  assign m3_sync_ready = m_sync_ready_s[3];

  assign m_cmd_ready_s[4] = m4_cmd_ready;
  assign m_sdo_ready_s[4] = m4_sdo_ready;
  assign m_sdi_valid_s[4] = m4_sdi_valid;
  assign m_sdi_data_s[4] = m4_sdi_data;
  assign m_sync_valid_s[4] = m4_sync_valid;
  assign m_sync_data_s[4] = m4_sync_data;

  assign m4_cmd_valid = m_cmd_valid_s[4];
  assign m4_cmd_data = s_cmd_data;
  assign m4_sdo_valid = m_sdo_valid_s[4];
  assign m4_sdo_data = s_sdo_data;
  assign m4_sdi_ready = m_sdi_ready_s[4];
  assign m4_sync_ready = m_sync_ready_s[4];

  assign m_cmd_ready_s[5] = m5_cmd_ready;
  assign m_sdo_ready_s[5] = m5_sdo_ready;
  assign m_sdi_valid_s[5] = m5_sdi_valid;
  assign m_sdi_data_s[5] = m5_sdi_data;
  assign m_sync_valid_s[5] = m5_sync_valid;
  assign m_sync_data_s[5] = m5_sync_data;

  assign m5_cmd_valid = m_cmd_valid_s[5];
  assign m5_cmd_data = s_cmd_data;
  assign m5_sdo_valid = m_sdo_valid_s[5];
  assign m5_sdo_data = s_sdo_data;
  assign m5_sdi_ready = m_sdi_ready_s[5];
  assign m5_sync_ready = m_sync_ready_s[5];

  assign m_cmd_ready_s[6] = m6_cmd_ready;
  assign m_sdo_ready_s[6] = m6_sdo_ready;
  assign m_sdi_valid_s[6] = m6_sdi_valid;
  assign m_sdi_data_s[6] = m6_sdi_data;
  assign m_sync_valid_s[6] = m6_sync_valid;
  assign m_sync_data_s[6] = m6_sync_data;

  assign m6_cmd_valid = m_cmd_valid_s[6];
  assign m6_cmd_data = s_cmd_data;
  assign m6_sdo_valid = m_sdo_valid_s[6];
  assign m6_sdo_data = s_sdo_data;
  assign m6_sdi_ready = m_sdi_ready_s[6];
  assign m6_sync_ready = m_sync_ready_s[6];

  assign m_cmd_ready_s[7] = m7_cmd_ready;
  assign m_sdo_ready_s[7] = m7_sdo_ready;
  assign m_sdi_valid_s[7] = m7_sdi_valid;
  assign m_sdi_data_s[7] = m7_sdi_data;
  assign m_sync_valid_s[7] = m7_sync_valid;
  assign m_sync_data_s[7] = m7_sync_data;

  assign m7_cmd_valid = m_cmd_valid_s[7];
  assign m7_cmd_data = s_cmd_data;
  assign m7_sdo_valid = m_sdo_valid_s[7];
  assign m7_sdo_data = s_sdo_data;
  assign m7_sdi_ready = m_sdi_ready_s[7];
  assign m7_sync_ready = m_sync_ready_s[7];

  assign m_cmd_ready_s[8] = m8_cmd_ready;
  assign m_sdo_ready_s[8] = m8_sdo_ready;
  assign m_sdi_valid_s[8] = m8_sdi_valid;
  assign m_sdi_data_s[8] = m8_sdi_data;
  assign m_sync_valid_s[8] = m8_sync_valid;
  assign m_sync_data_s[8] = m8_sync_data;

  assign m8_cmd_valid = m_cmd_valid_s[8];
  assign m8_cmd_data = s_cmd_data;
  assign m8_sdo_valid = m_sdo_valid_s[8];
  assign m8_sdo_data = s_sdo_data;
  assign m8_sdi_ready = m_sdi_ready_s[8];
  assign m8_sync_ready = m_sync_ready_s[8];

  assign m_cmd_ready_s[9] = m9_cmd_ready;
  assign m_sdo_ready_s[9] = m9_sdo_ready;
  assign m_sdi_valid_s[9] = m9_sdi_valid;
  assign m_sdi_data_s[9] = m9_sdi_data;
  assign m_sync_valid_s[9] = m9_sync_valid;
  assign m_sync_data_s[9] = m9_sync_data;

  assign m9_cmd_valid = m_cmd_valid_s[9];
  assign m9_cmd_data = s_cmd_data;
  assign m9_sdo_valid = m_sdo_valid_s[9];
  assign m9_sdo_data = s_sdo_data;
  assign m9_sdi_ready = m_sdi_ready_s[9];
  assign m9_sync_ready = m_sync_ready_s[9];

  assign m_cmd_ready_s[10] = m10_cmd_ready;
  assign m_sdo_ready_s[10] = m10_sdo_ready;
  assign m_sdi_valid_s[10] = m10_sdi_valid;
  assign m_sdi_data_s[10] = m10_sdi_data;
  assign m_sync_valid_s[10] = m10_sync_valid;
  assign m_sync_data_s[10] = m10_sync_data;

  assign m10_cmd_valid = m_cmd_valid_s[10];
  assign m10_cmd_data = s_cmd_data;
  assign m10_sdo_valid = m_sdo_valid_s[10];
  assign m10_sdo_data = s_sdo_data;
  assign m10_sdi_ready = m_sdi_ready_s[10];
  assign m10_sync_ready = m_sync_ready_s[10];

  assign m_cmd_ready_s[11] = m11_cmd_ready;
  assign m_sdo_ready_s[11] = m11_sdo_ready;
  assign m_sdi_valid_s[11] = m11_sdi_valid;
  assign m_sdi_data_s[11] = m11_sdi_data;
  assign m_sync_valid_s[11] = m11_sync_valid;
  assign m_sync_data_s[11] = m11_sync_data;

  assign m11_cmd_valid = m_cmd_valid_s[11];
  assign m11_cmd_data = s_cmd_data;
  assign m11_sdo_valid = m_sdo_valid_s[11];
  assign m11_sdo_data = s_sdo_data;
  assign m11_sdi_ready = m_sdi_ready_s[11];
  assign m11_sync_ready = m_sync_ready_s[11];

  assign m_cmd_ready_s[12] = m12_cmd_ready;
  assign m_sdo_ready_s[12] = m12_sdo_ready;
  assign m_sdi_valid_s[12] = m12_sdi_valid;
  assign m_sdi_data_s[12] = m12_sdi_data;
  assign m_sync_valid_s[12] = m12_sync_valid;
  assign m_sync_data_s[12] = m12_sync_data;

  assign m12_cmd_valid = m_cmd_valid_s[12];
  assign m12_cmd_data = s_cmd_data;
  assign m12_sdo_valid = m_sdo_valid_s[12];
  assign m12_sdo_data = s_sdo_data;
  assign m12_sdi_ready = m_sdi_ready_s[12];
  assign m12_sync_ready = m_sync_ready_s[12];

  assign m_cmd_ready_s[13] = m13_cmd_ready;
  assign m_sdo_ready_s[13] = m13_sdo_ready;
  assign m_sdi_valid_s[13] = m13_sdi_valid;
  assign m_sdi_data_s[13] = m13_sdi_data;
  assign m_sync_valid_s[13] = m13_sync_valid;
  assign m_sync_data_s[13] = m13_sync_data;

  assign m13_cmd_valid = m_cmd_valid_s[13];
  assign m13_cmd_data = s_cmd_data;
  assign m13_sdo_valid = m_sdo_valid_s[13];
  assign m13_sdo_data = s_sdo_data;
  assign m13_sdi_ready = m_sdi_ready_s[13];
  assign m13_sync_ready = m_sync_ready_s[13];

  assign m_cmd_ready_s[14] = m14_cmd_ready;
  assign m_sdo_ready_s[14] = m14_sdo_ready;
  assign m_sdi_valid_s[14] = m14_sdi_valid;
  assign m_sdi_data_s[14] = m14_sdi_data;
  assign m_sync_valid_s[14] = m14_sync_valid;
  assign m_sync_data_s[14] = m14_sync_data;

  assign m14_cmd_valid = m_cmd_valid_s[14];
  assign m14_cmd_data = s_cmd_data;
  assign m14_sdo_valid = m_sdo_valid_s[14];
  assign m14_sdo_data = s_sdo_data;
  assign m14_sdi_ready = m_sdi_ready_s[14];
  assign m14_sync_ready = m_sync_ready_s[14];

  assign m_cmd_ready_s[15] = m15_cmd_ready;
  assign m_sdo_ready_s[15] = m15_sdo_ready;
  assign m_sdi_valid_s[15] = m15_sdi_valid;
  assign m_sdi_data_s[15] = m15_sdi_data;
  assign m_sync_valid_s[15] = m15_sync_valid;
  assign m_sync_data_s[15] = m15_sync_data;

  assign m15_cmd_valid = m_cmd_valid_s[15];
  assign m15_cmd_data = s_cmd_data;
  assign m15_sdo_valid = m_sdo_valid_s[15];
  assign m15_sdo_data = s_sdo_data;
  assign m15_sdi_ready = m_sdi_ready_s[15];
  assign m15_sync_ready = m_sync_ready_s[15];

endmodule
