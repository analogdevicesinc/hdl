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
 * Upstream frame decoder. A frame (upstream CS assert to deassert) carries a
 * serialized SPI Engine instruction stream:
 *
 *   each instruction    cmd[15:8], then cmd[7:0]
 *   after a TRANSFER    n + 1 SDO bytes when its write bit (cmd[8]) is set;
 *                       nothing follows a read-only TRANSFER
 *
 * Instructions with bit 15 set, which the engine leaves reserved, belong to
 * the bridge itself and are never forwarded to the engine. Their high byte is
 * {1'b1, op[2:0], addr[3:0]}, addr being a register address for CTRL_W and
 * CTRL_R and 0 otherwise:
 *
 *   0x80xx  NOP
 *   0x90nn  FETCH n + 1 response bytes, followed by n + 2 filler bytes
 *   0xAadd  CTRL_W data dd to register a
 *   0xBa00  CTRL_R from register a
 *   0xC0xx  FLUSH
 *
 * Opcodes 5 to 7 are reserved.
 *
 * A reply byte is ready two bytes after the byte that completes its request:
 *
 *   CTRL_R  MOSI [0xBa][0x00][next instruction] the address is known after
 *           MISO [ .. ][turn][data]             the high byte; the low byte
 *                                               is the turnaround
 *
 *   FETCH   MOSI [0x90][ nn ][fill][fill] ... [fill]
 *           MISO [ .. ][ .. ][turn][data 0]   [data n]
 *
 * Like a TRANSFER, FETCH counts n + 1, so one FETCH collects the SDI bytes of
 * one full-length read TRANSFER (up to 256).
 *
 * CTRL_R needs no filler: its data goes out during the first byte of the
 * instruction that follows it, so a CTRL_R that ends a frame must be followed
 * by a NOP. FETCH filler bytes are ignored. All other MISO bytes are 0x00.
 *
 * FETCH reads the response FIFO speculatively, padding with 0x00 when it runs
 * out. The bytes are only released when the frame commits; in a rejected frame
 * they stay queued and a retried FETCH returns them again. The host ends each
 * message that reads with a SYNC and only FETCHes once SYNC_ID shows that id;
 * by then all of the message's SDI bytes are queued.
 *
 * Instructions are written to the CMD FIFO and SDO bytes to the SDO FIFO as
 * they arrive. Both FIFOs are transactional: the frame is committed to them
 * together only after CS deasserts and the whole frame has checked out, and
 * rolled back otherwise. A rejected frame is dropped as a unit, so nothing
 * from it reaches a downstream device.
 *
 * CTRL_W and FLUSH take effect as soon as the instruction is complete, as long
 * as nothing earlier in the frame has failed; they are not undone if the frame
 * is rejected later. Several CTRL_W may be sent in one frame, and a CTRL_R
 * after a CTRL_W reads the new value. A FLUSH discards everything queued
 * before it, including the earlier part of its own frame; the instructions
 * after it are kept and committed normally, so a frame can recover and start
 * again. The FIFOs are cleared two cycles after the FLUSH is decoded, well
 * before the next upstream byte arrives. CTRL_R and FETCH reply during the
 * frame.
 *
 * A frame is rejected, and the matching sticky err bit set, when it:
 *   [0] uses a reserved encoding (engine class 101 to 111, bridge opcode 5
 *       to 7, reserved TRANSFER, WRITE or bridge fields), selects more than
 *       one target in a CHIPSELECT, or sets a word length outside 1..8
 *   [1] does not fit in the room left in the CMD or SDO FIFO
 *   [2] ends inside an instruction, its SDO data or a FETCH's filler bytes
 * FLUSH clears err.
 *
 * A frame may end with a target still selected: the engine then keeps that
 * chip select asserted until a later frame releases it, so one long transfer
 * can be split over several frames, e.g. when translators are cascaded. If a
 * later frame is rejected meanwhile, the target stays selected until the host
 * sends a CHIPSELECT releasing it, or FLUSH.
 *
 * Only 8-bit SDO words are supported: the engine is built with
 * DATA_WIDTH = 8, so each SDO word is one byte.
 */

module spi_translator_decoder #(
  parameter NUM_OF_CS = 4
) (
  input                               clk,
  input                               resetn,

  // SPI slave

  input       [7:0]                   rx_data,
  input                               rx_valid,
  input                               frame_start,
  input                               frame_end,
  input                               frame_active,

  // transactional CMD and SDO FIFOs

  output                              cmd_we,
  output      [15:0]                  cmd_wdata,
  input                               cmd_full,

  output                              sdo_we,
  output      [7:0]                   sdo_wdata,
  input                               sdo_full,

  output  reg                         commit,
  output  reg                         rollback,

  // MISO

  output  reg [7:0]                   tx_data,

  // response FIFO, released by commit

  input                               resp_valid,
  input       [7:0]                   resp_data,
  output                              resp_ready,

  // register file

  output      [7:0]                   reg_rd_addr,
  input       [7:0]                   reg_rd_data,
  output  reg                         reg_wr_en,
  output  reg [7:0]                   reg_wr_addr,
  output  reg [7:0]                   reg_wr_data,

  output  reg                         flush_req,
  output  reg [2:0]                   err
);

  localparam [2:0] S_HI  = 3'd0;
  localparam [2:0] S_LO  = 3'd1;
  localparam [2:0] S_SDO = 3'd2;
  localparam [2:0] S_PAD = 3'd3;

  localparam [2:0] CMD_TRANSFER   = 3'b000;
  localparam [2:0] CMD_CHIPSELECT = 3'b001;
  localparam [2:0] CMD_WRITE      = 3'b010;
  localparam [2:0] CMD_MISC       = 3'b011;
  localparam [2:0] CMD_CS_INV     = 3'b100;

  localparam [2:0] BR_NOP    = 3'd0;
  localparam [2:0] BR_FETCH  = 3'd1;
  localparam [2:0] BR_CTRL_W = 3'd2;
  localparam [2:0] BR_CTRL_R = 3'd3;
  localparam [2:0] BR_FLUSH  = 3'd4;

  localparam ERR_INSTR = 0;
  localparam ERR_OVF   = 1;

  reg   [2:0]                 state = S_HI;
  reg   [7:0]                 hi = 8'h00;
  reg   [8:0]                 sdo_left = 9'h000;
  reg                         seen = 1'b0;
  reg   [1:0]                 frame_err = 2'b00;
  reg   [1:0]                 frame_end_d = 2'b00;
  reg   [8:0]                 pad_left = 9'h000;

  // reply in progress: data bytes still to send
  reg                         rep_fetch = 1'b0;
  reg   [8:0]                 rep_idx = 9'h000;
  reg   [8:0]                 rep_len = 9'h000;

  wire                        byte_in;
  wire  [2:0]                 inst;
  wire  [2:0]                 op;
  wire  [NUM_OF_CS-1:0]       sel;
  wire                        sel_ok;
  wire                        is_bridge;
  wire                        cmd_ok;
  wire                        store_cmd;
  wire                        store_sdo;
  wire                        no_room;
  wire                        done;
  wire  [2:0]                 end_err;
  wire                        br_exec;
  wire                        rep_start_r;
  wire                        rep_start_f;
  wire                        rep_start;
  wire                        rep_data;
  wire  [7:0]                 rep_byte;

  assign byte_in = rx_valid & frame_active;
  assign inst    = hi[6:4];
  assign op      = hi[6:4];

  // targets a CHIPSELECT pulls low; at most one of the NUM_OF_CS is allowed,
  // bits above NUM_OF_CS are not checked
  assign sel    = ~rx_data[NUM_OF_CS-1:0];
  assign sel_ok = (sel & (sel - 1'b1)) == {NUM_OF_CS{1'b0}};

  // checks on the instruction {hi, rx_data}, evaluated on its second byte
  assign is_bridge = hi[7];
  assign cmd_ok = is_bridge ? (
    (op == BR_CTRL_W) ||
    (op == BR_CTRL_R && rx_data == 8'h00) ||
    ((op == BR_NOP || op == BR_FETCH || op == BR_FLUSH) && hi[3:0] == 4'h0)) : (
    (inst == CMD_TRANSFER   && hi[3:2] == 2'b00) ||
    (inst == CMD_CHIPSELECT && sel_ok) ||
    (inst == CMD_WRITE      && hi[3] == 1'b0 && hi[2:0] <= 3'b100 &&
                               (hi[2:0] != 3'b010 || (rx_data != 8'h00 && rx_data <= 8'd8))) ||
    (inst == CMD_MISC) ||
    (inst == CMD_CS_INV));

  // engine instructions go to the CMD FIFO, their SDO bytes to the SDO FIFO;
  // nothing more is written once the frame has failed
  assign store_cmd = byte_in && frame_err == 2'b00 && state == S_LO && cmd_ok && ~is_bridge;
  assign store_sdo = byte_in && frame_err == 2'b00 && state == S_SDO;
  assign no_room   = (store_cmd & cmd_full) | (store_sdo & sdo_full);

  assign cmd_we    = store_cmd & ~cmd_full;
  assign cmd_wdata = {hi, rx_data};
  assign sdo_we    = store_sdo & ~sdo_full;
  assign sdo_wdata = rx_data;

  // reply generation, one byte per received byte; a reply byte loaded here
  // goes out on MISO two bytes later. CTRL_R starts on its high byte, which
  // already carries the address; FETCH on its low byte, which carries n.
  // A register read has no side effect, so the CTRL_R reply may start before
  // its low byte has been checked.

  assign rep_start_r = byte_in && state == S_HI && rx_data[7] && rx_data[6:4] == BR_CTRL_R;
  assign rep_start_f = byte_in && state == S_LO && cmd_ok && is_bridge && op == BR_FETCH;
  assign rep_start   = rep_start_r | rep_start_f;

  // a data byte is produced in this cycle
  assign rep_data = rep_start_r ? 1'b1 :
                    rep_start_f ? 1'b1 :
                                  (state == S_PAD && rep_idx < rep_len);

  assign reg_rd_addr = {4'h0, rx_data[3:0]};

  assign rep_byte = rep_start_r ? reg_rd_data : (resp_valid ? resp_data : 8'h00);

  // FETCH data bytes pop the response FIFO; CTRL_R never does
  assign resp_ready = byte_in && rep_data && resp_valid &&
                      (rep_start_f || (~rep_start && rep_fetch));

  always @(posedge clk) begin
    if (resetn == 1'b0 || frame_start == 1'b1) begin
      tx_data <= 8'h00;
      rep_idx <= 9'h000;
      rep_len <= 9'h000;
      rep_fetch <= 1'b0;
    end else if (byte_in) begin
      tx_data <= rep_data ? rep_byte : 8'h00;
      if (rep_start) begin
        rep_fetch <= rep_start_f;
        rep_len <= rep_start_f ? {1'b0, rx_data} + 9'd1 : 9'h001;
        rep_idx <= 9'h001;
      end else if (state == S_PAD) begin
        rep_idx <= rep_idx + 1'b1;
      end
    end
  end

  // let the last byte of the frame through the slave before closing it
  assign done = frame_end_d[1];

  assign end_err = {state != S_HI, frame_err};

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      frame_end_d <= 2'b00;
    end else begin
      frame_end_d <= {frame_end_d[0], frame_end};
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0 || frame_start == 1'b1) begin
      state <= S_HI;
      seen <= 1'b0;
      frame_err <= 2'b00;
    end else if (byte_in) begin
      seen <= 1'b1;
      case (state)
        S_HI: begin
          hi <= rx_data;
          state <= S_LO;
        end
        S_LO: begin
          state <= S_HI;
          if (~cmd_ok) begin
            frame_err[ERR_INSTR] <= 1'b1;
          end else if (is_bridge) begin
            if (op == BR_FETCH) begin
              pad_left <= {1'b0, rx_data} + 9'd2;
              state <= S_PAD;
            end
          end else begin
            if (inst == CMD_TRANSFER && hi[0] == 1'b1) begin
              sdo_left <= {1'b0, rx_data} + 1'b1;
              state <= S_SDO;
            end
          end
        end
        S_SDO: begin
          sdo_left <= sdo_left - 1'b1;
          if (sdo_left == 9'h001) begin
            state <= S_HI;
          end
        end
        default: begin
          pad_left <= pad_left - 1'b1;
          if (pad_left == 9'h001) begin
            state <= S_HI;
          end
        end
      endcase

      if (no_room) begin
        frame_err[ERR_OVF] <= 1'b1;
      end
    end
  end

  // CTRL_W and FLUSH act at once, unless the frame has already failed: an
  // instruction after an error may be misaligned data
  assign br_exec = byte_in && state == S_LO && cmd_ok && is_bridge &&
                   frame_err == 2'b00;

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      reg_wr_en <= 1'b0;
      reg_wr_addr <= 8'h00;
      reg_wr_data <= 8'h00;
      flush_req <= 1'b0;
    end else begin
      reg_wr_en <= br_exec && op == BR_CTRL_W;
      flush_req <= br_exec && op == BR_FLUSH;
      if (br_exec && op == BR_CTRL_W) begin
        reg_wr_addr <= {4'h0, hi[3:0]};
        reg_wr_data <= rx_data;
      end
    end
  end

  // frame completion; FLUSH clears err

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      commit <= 1'b0;
      rollback <= 1'b0;
      err <= 3'h0;
    end else begin
      commit <= 1'b0;
      rollback <= 1'b0;
      if (flush_req) begin
        err <= 3'h0;
      end
      if (done && seen) begin
        if (end_err != 3'h0) begin
          rollback <= 1'b1;
          err <= err | end_err;
        end else begin
          commit <= 1'b1;
        end
      end
    end
  end

endmodule
