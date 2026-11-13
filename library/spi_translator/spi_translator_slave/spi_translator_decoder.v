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
 * {1'b1, op[2:0], field[3:0]}. Opcodes 0 to 3 act on the bridge only
 * (registers, pins), opcodes 4 to 7 on the engine side (routing, responses,
 * reset, commit):
 *
 *   op 0  0x80xx  NOP
 *   op 1  0x9add  CTRL_W data dd to register a
 *   op 2  0xAa00  CTRL_R from register a
 *   op 3  0xB?ii  GPIO of pin ii; high byte {4'hb, rd, sel, value, 1'b0}:
 *                 rd 0 writes value to OUT (sel 0) or DIR (sel 1, 0 = output,
 *                 1 = input); rd 1 (0xB8) replies {5'b0, DIR, OUT, IN}
 *   op 4  0xC0ee  SELECT engine ee for the instructions that follow
 *   op 5  0xD0nn  FETCH n + 1 response bytes, followed by n + 2 filler bytes;
 *                 acknowledges the previous batch
 *         0xD2nn  FETCH retry: read the unacknowledged batch again
 *         0xD100  acknowledge the previous batch only: no read, no filler
 *   op 6  0xE0xx  FLUSH, only as the first instruction of a frame
 *   op 7  0xF000  CHECK, followed by crc[15:8], crc[7:0]; with CRC_EN only
 *
 * CHECK is a bad instruction without CRC_EN, and so is GPIO without GPIOs
 * (GPIO_EN = 0).
 *
 * Every frame starts with a header on MISO: byte 0 is tx_first, the STATUS
 * byte as it was a few clk after the previous frame ended, so its ERR bits
 * tell whether that frame was committed; byte 1 is last_sync at frame start.
 *
 * CRC (CRC_EN = 1): CRC-16/CCITT-FALSE, polynomial 0x1021 MSB first, init
 * 0xffff, no final XOR. Every frame must end with CHECK:
 *
 *   MOSI [..][..] ... [0xf0][0x00][crc_hi ][crc_lo ]
 *   MISO [st][id] ... [ r  ][ r  ][mcrc_hi][mcrc_lo]
 *
 * crc covers the MOSI bytes from byte 0 through CHECK's 0x00. mcrc covers the
 * MISO bytes from byte 0 through the one sent during CHECK's 0x00: CHECK is
 * recognized on its high byte, like CTRL_R, so mcrc goes out during the CRC
 * bytes. A frame passes only if CHECK is its last instruction, complete, and
 * crc matches. MISO bytes outside the header, the replies and mcrc are 0x00.
 *
 * A reply byte is ready two bytes after the byte that completes its request:
 *
 *   CTRL_R  MOSI [0xAa][0x00][next instruction] the address is known after
 *           MISO [ .. ][turn][data]             the high byte; the low byte
 *                                               is the turnaround
 *
 *   FETCH   MOSI [0xD0][ nn ][fill][fill] ... [fill]
 *           MISO [ .. ][ .. ][turn][data 0]   [data n]
 *
 *   GPIO rd MOSI [0xB8][ ii ][next hi][next lo] the index is the low byte,
 *           MISO [ .. ][ .. ][ turn  ][ pin   ] so the reply comes a byte
 *                                               later than for CTRL_R
 *
 * Like a TRANSFER, FETCH counts n + 1, so one FETCH collects the SDI bytes of
 * one full-length read TRANSFER (up to 256). CTRL_R needs no filler: its data
 * goes out during the first byte of the instruction that follows it (a NOP,
 * or CHECK). FETCH filler bytes are ignored.
 *
 * FETCH reads the response FIFO speculatively, padding with 0x00 when it runs
 * out. A rejected frame rewinds its reads. The bytes of a committed FETCH
 * frame form an unacknowledged batch, which stays queued until a later frame
 * with a FETCH or an acknowledge, and no retry, commits; a FETCH retry reads
 * the batch again, e.g. after a bad mcrc. The rewind for a retry starts on its
 * high byte, so the data is back by its low byte.
 *
 * Every frame takes effect as a whole at its commit, or not at all. Its
 * instructions are written to the CMD FIFO and SDO bytes to the SDO FIFO as
 * they arrive; both are transactional, committed together only after CS
 * deasserts and the whole frame has checked out, and rolled back otherwise.
 * Bridge writes are queued the same way: CTRL_W and GPIO writes in a small
 * transactional FIFO (BRIDGE_FIFO_ADDRESS_WIDTH), replayed one per clk after
 * the commit; a CTRL_W clearing err and FLUSH act at the commit itself. A
 * CTRL_R or GPIO read therefore sees the writes of earlier frames only, and
 * GPIO writes are not ordered with the frame's engine instructions. CTRL_R,
 * GPIO reads and FETCH reply during the frame.
 *
 * FLUSH must be the first instruction of its frame. At the commit it discards
 * everything earlier frames queued, resets the engines and clears err; the
 * rest of its own frame is kept and runs once the engine reset is over, so
 * FLUSH, CFG, PRESCALE, CS, ... recovers in one frame.
 *
 * A frame is rejected, and the matching sticky err bit set, when it:
 *   [0] uses a reserved encoding (engine class 101 to 111, CHECK without
 *       CRC_EN, GPIO without GPIOs, FLUSH not first, reserved TRANSFER, WRITE
 *       or bridge fields), selects more than one target or a missing one in a
 *       CHIPSELECT, SELECTs a missing engine or another engine while a chip
 *       select is asserted, or sets a word length outside 1..8
 *   [1] does not fit in the room left in the CMD, SDO or bridge write FIFO
 *   [2] fails integrity: with CRC_EN, it does not end with a complete,
 *       matching CHECK; without, it ends inside an instruction, its SDO data
 *       or a FETCH's filler bytes
 * When [2] is set, [1:0] are not reported for that frame: a damaged frame can
 * look malformed. err is cleared by FLUSH, or bit by bit by a CTRL_W of 1s to
 * STATUS (0x05).
 *
 * Go-back-N: a frame that starts while err is not 0 is rejected as a whole,
 * without adding to err, unless its first instruction resumes: FLUSH, or a
 * CTRL_W to 0x05 writing 1 to every err bit that is set. A host that sees err
 * in a frame header resends from the rejected frame on, starting with the
 * resume; nothing after the rejected frame has run, so the order is kept and
 * a transfer split over frames continues where it stopped.
 *
 * A frame may end with a target still selected: the engine then keeps that
 * chip select asserted until a later frame releases it, so one long transfer
 * can be split over several frames.
 *
 * Engines: the NUM_OF_CS downstream chip selects are spread over
 * NUM_OF_ENGINES = ceil(NUM_OF_CS / 8) engines, 8 each except the last. A
 * slave is numbered {ee, cs[2:0]}: SELECT picks engine ee, and the CHIPSELECT
 * masks that follow pick one of its chip selects. SELECT is queued in the CMD
 * FIFO like an engine instruction, so it takes effect in order with the
 * stream; the interconnect consumes it. After reset and FLUSH, engine 0 is
 * selected. A SELECT is rejected when ee is out of range, or when it names
 * another engine while the selected one still holds a chip select asserted,
 * so at most one slave is active at a time. The decoder tracks the selected
 * engine and whether it holds a chip select as the engines will see them:
 * updated by each instruction stored, kept by the commit and restored by a
 * rollback, and reset by FLUSH.
 *
 * Only 8-bit SDO words are supported: the engine is built with
 * DATA_WIDTH = 8, so each SDO word is one byte.
 */

module spi_translator_decoder #(
  parameter NUM_OF_CS = 4,
  parameter GPIO_EN = 1,
  parameter CRC_EN = 0,
  parameter BRIDGE_FIFO_ADDRESS_WIDTH = 4
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

  // MISO: tx_data for each byte, tx_first for byte 0 of the next frame

  output  reg [7:0]                   tx_data,
  output  reg [7:0]                   tx_first,

  // header sources

  input       [7:0]                   status,
  input       [7:0]                   last_sync,

  // response FIFO; resp_ack goes with commit, resp_retry rewinds

  input                               resp_valid,
  input       [7:0]                   resp_data,
  output                              resp_ready,
  output  reg                         resp_ack,
  output                              resp_retry,

  // register file

  output      [7:0]                   reg_rd_addr,
  input       [7:0]                   reg_rd_data,
  output  reg                         reg_wr_en,
  output  reg [7:0]                   reg_wr_addr,
  output  reg [7:0]                   reg_wr_data,

  // GPIOs

  output  reg                         gpio_wr_en,
  output  reg [7:0]                   gpio_wr_index,
  output  reg                         gpio_wr_sel,
  output  reg                         gpio_wr_value,
  output      [7:0]                   gpio_rd_index,
  input       [7:0]                   gpio_rd_data,

  // FLUSH, in the same cycle as the commit of the frame it starts

  output  reg                         flush_req,
  output  reg [2:0]                   err
);

  localparam [2:0] S_HI  = 3'd0;
  localparam [2:0] S_LO  = 3'd1;
  localparam [2:0] S_SDO = 3'd2;
  localparam [2:0] S_SDI = 3'd3;
  localparam [2:0] S_CRC = 3'd4;

  localparam [2:0] CMD_TRANSFER   = 3'b000;
  localparam [2:0] CMD_CHIPSELECT = 3'b001;
  localparam [2:0] CMD_WRITE      = 3'b010;
  localparam [2:0] CMD_MISC       = 3'b011;
  localparam [2:0] CMD_CS_INV     = 3'b100;

  // bridge side
  localparam [2:0] BR_NOP    = 3'd0;
  localparam [2:0] BR_CTRL_W = 3'd1;
  localparam [2:0] BR_CTRL_R = 3'd2;
  localparam [2:0] BR_GPIO   = 3'd3;
  // engine side
  localparam [2:0] BR_SELECT = 3'd4;
  localparam [2:0] BR_FETCH  = 3'd5;
  localparam [2:0] BR_FLUSH  = 3'd6;
  localparam [2:0] BR_CHECK  = 3'd7;

  localparam [3:0] ADDR_STATUS = 4'h5;

  localparam NUM_OF_ENGINES = (NUM_OF_CS + 7) / 8;
  localparam LAST_CS = NUM_OF_CS - 8 * (NUM_OF_ENGINES - 1);
  localparam [8:0] LAST_MASK = (9'd1 << LAST_CS) - 9'd1;

  localparam ERR_INSTR = 0;
  localparam ERR_OVF   = 1;

  // header snapshot delay after a frame's commit or rollback, so STATUS
  // already shows the frame's work and errors
  localparam [3:0] SNAP_DELAY = 4'd6;

  // CRC-16/CCITT-FALSE, one byte, MSB first
  function [15:0] crc16_byte;
    input [15:0] c;
    input [7:0]  d;
    integer i;
    reg [15:0] r;
    begin
      r = c;
      for (i = 7; i >= 0; i = i - 1) begin
        r = (r[15] ^ d[i]) ? {r[14:0], 1'b0} ^ 16'h1021 : {r[14:0], 1'b0};
      end
      crc16_byte = r;
    end
  endfunction

  reg   [2:0]                 state = S_HI;
  reg   [7:0]                 hi = 8'h00;
  reg   [8:0]                 sdi_left = 9'h000;
  reg   [8:0]                 sdo_left = 9'h000;
  reg                         seen = 1'b0;
  reg   [1:0]                 frame_err = 2'b00;
  reg   [1:0]                 frame_end_d = 2'b00;

  // go-back-N: err was set when the frame started; the first instruction is
  // still to come; it resumed
  reg                         blocked = 1'b0;
  reg                         first = 1'b1;
  reg                         resumed = 1'b0;

  // what the frame does at its commit
  reg                         ack_seen = 1'b0;
  reg                         retry_seen = 1'b0;
  reg                         flush_seen = 1'b0;
  reg   [2:0]                 w1c = 3'h0;

  // CRC
  reg   [15:0]                crc_mosi = 16'hffff;
  reg   [15:0]                crc_miso = 16'hffff;
  reg                         miso_frozen = 1'b0;
  reg   [7:0]                 crc_rx_hi = 8'h00;
  reg                         checked = 1'b0;

  // header snapshot
  reg   [3:0]                 snap_cnt = SNAP_DELAY;

  // selected engine and chip select state, as of the instructions stored so
  // far (eng, cs_open) and as of the last commit (eng_q, cs_open_q)
  reg   [3:0]                 eng = 4'h0;
  reg                         cs_open = 1'b0;
  reg   [3:0]                 eng_q = 4'h0;
  reg                         cs_open_q = 1'b0;

  // reply in progress: data bytes still to send
  reg                         rep_fetch = 1'b0;
  reg   [8:0]                 rep_idx = 9'h000;
  reg   [8:0]                 rep_len = 9'h000;

  wire                        byte_in;
  wire                        instr_in;
  wire  [2:0]                 inst;
  wire  [2:0]                 op;
  wire  [7:0]                 cs_mask;
  wire  [7:0]                 sel;
  wire                        sel_ok;
  wire                        select_ok;
  wire                        fetch_ok;
  wire                        is_bridge;
  wire                        is_w1c;
  wire                        cmd_ok;
  wire                        resume;
  wire                        act;
  wire                        store_cmd;
  wire                        store_sdo;
  wire                        br_exec;
  wire                        bq_we;
  wire                        bq_full;
  wire                        bq_valid;
  wire  [16:0]                bq_data;
  wire                        no_room;
  wire                        done;
  wire                        pass;
  wire                        integ;
  wire  [2:0]                 end_err;
  wire                        check_hi;
  wire                        check_lo;
  wire                        rep_start_r;
  wire                        rep_start_f;
  wire                        rep_start_g;
  wire                        rep_start;
  wire                        rep_data;
  wire  [7:0]                 rep_byte;
  wire  [7:0]                 tx_next;

  assign byte_in  = rx_valid & frame_active;
  assign instr_in = byte_in && state == S_LO;
  assign inst     = hi[6:4];
  assign op       = hi[6:4];

  // targets a CHIPSELECT pulls low; at most one, and only one the selected
  // engine has
  assign cs_mask = (eng == NUM_OF_ENGINES - 1) ? LAST_MASK[7:0] : 8'hff;
  assign sel     = ~rx_data;
  assign sel_ok  = (sel & (sel - 1'b1)) == 8'h00 && (sel & ~cs_mask) == 8'h00;

  // SELECT: an existing engine, and no chip select left asserted elsewhere
  assign select_ok = hi[3:0] == 4'h0 && rx_data < NUM_OF_ENGINES &&
                     (rx_data[3:0] == eng || ~cs_open);

  // FETCH flags in bits 9:8: retry, acknowledge only (no read)
  assign fetch_ok = hi[3:2] == 2'b00 && hi[1:0] != 2'b11 &&
                    (hi[0] == 1'b0 || rx_data == 8'h00);

  // checks on the instruction {hi, rx_data}, evaluated on its second byte
  assign is_bridge = hi[7];
  assign cmd_ok = is_bridge ? (
    (op == BR_CTRL_W) ||
    (op == BR_CTRL_R && rx_data == 8'h00) ||
    (op == BR_GPIO && GPIO_EN != 0 && (hi[3] ? hi[2:0] == 3'b000 : hi[0] == 1'b0)) ||
    (op == BR_SELECT && select_ok) ||
    (op == BR_FETCH && fetch_ok) ||
    (op == BR_FLUSH && hi[3:0] == 4'h0 && first) ||
    (op == BR_CHECK && CRC_EN != 0 && hi[3:0] == 4'h0 && rx_data == 8'h00) ||
    (op == BR_NOP && hi[3:0] == 4'h0)) : (
    (inst == CMD_TRANSFER   && hi[3:2] == 2'b00) ||
    (inst == CMD_CHIPSELECT && sel_ok) ||
    (inst == CMD_WRITE      && hi[3] == 1'b0 && hi[2:0] <= 3'b100) ||
    (inst == CMD_MISC) ||
    (inst == CMD_CS_INV));

  // CTRL_W to STATUS clears the err bits written as 1; STATUS[5:3] is err
  assign is_w1c = op == BR_CTRL_W && hi[3:0] == ADDR_STATUS;

  // a first instruction that lifts the go-back-N block
  assign resume = first && cmd_ok && is_bridge &&
                  (op == BR_FLUSH || (is_w1c && (rx_data[5:3] & err) == err));

  // the frame may still take effect: no error so far, and not blocked
  assign act = frame_err == 2'b00 &&
               ~(blocked && (first ? ~(instr_in && resume) : ~resumed));

  // engine instructions and SELECT go to the CMD FIFO, SDO bytes to the SDO
  // FIFO, CTRL_W and GPIO writes to the bridge FIFO; nothing more is written
  // once the frame has failed
  assign br_exec   = instr_in && act && cmd_ok && is_bridge;
  assign store_cmd = instr_in && act && cmd_ok && (~is_bridge || op == BR_SELECT);
  assign store_sdo = byte_in && act && state == S_SDO;
  assign bq_we     = br_exec && ((op == BR_CTRL_W && ~is_w1c) ||
                                 (op == BR_GPIO && ~hi[3]));
  assign no_room   = (store_cmd & cmd_full) | (store_sdo & sdo_full) |
                     (bq_we & bq_full);

  assign cmd_we    = store_cmd & ~cmd_full;
  assign cmd_wdata = {hi, rx_data};
  assign sdo_we    = store_sdo & ~sdo_full;
  assign sdo_wdata = rx_data;

  // CHECK is recognized on its high byte, so the MISO CRC goes out during
  // its CRC bytes
  assign check_hi = CRC_EN != 0 && byte_in && state == S_HI && rx_data == 8'hf0;
  assign check_lo = CRC_EN != 0 && instr_in && hi == 8'hf0;

  // reply generation, one byte per received byte; a reply byte loaded here
  // goes out on MISO two bytes later. CTRL_R starts on its high byte, which
  // already carries the address; FETCH and GPIO reads on their low byte, which
  // carries n or the GPIO index. A register or pin read has no side effect,
  // so the CTRL_R reply may start before its low byte has been checked.

  assign rep_start_r = byte_in && state == S_HI && rx_data[7] && rx_data[6:4] == BR_CTRL_R;
  assign rep_start_f = instr_in && cmd_ok && is_bridge && op == BR_FETCH && ~hi[0];
  assign rep_start_g = instr_in && cmd_ok && is_bridge && op == BR_GPIO && hi[3];
  assign rep_start   = rep_start_r | rep_start_f | rep_start_g;

  // a data byte is produced in this cycle
  assign rep_data = rep_start ? 1'b1 : (state == S_SDI && rep_idx < rep_len);

  assign reg_rd_addr   = {4'h0, rx_data[3:0]};
  assign gpio_rd_index = rx_data;

  assign rep_byte = rep_start_r ? reg_rd_data :
                    rep_start_g ? gpio_rd_data :
                    (resp_valid ? resp_data : 8'h00);

  assign tx_next = check_hi ? crc_miso[15:8] :
                   check_lo ? crc_miso[7:0] :
                   rep_data ? rep_byte : 8'h00;

  // FETCH data bytes pop the response FIFO; CTRL_R never does
  assign resp_ready = byte_in && rep_data && resp_valid &&
                      (rep_start_f || (~rep_start && rep_fetch));

  // a retry rewinds on its high byte, so the batch is back by its low byte;
  // a frame rejected later rolls the rewind back
  assign resp_retry = byte_in && state == S_HI && rx_data[7:4] == 4'hd && rx_data[1];

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      tx_data <= 8'h00;
      rep_idx <= 9'h000;
      rep_len <= 9'h000;
      rep_fetch <= 1'b0;
      crc_miso <= 16'hffff;
      miso_frozen <= 1'b0;
    end else if (frame_start) begin
      // MISO byte 1 is the SYNC id; bytes 0 and 1 open the MISO CRC
      tx_data <= last_sync;
      rep_idx <= 9'h000;
      rep_len <= 9'h000;
      rep_fetch <= 1'b0;
      crc_miso <= crc16_byte(crc16_byte(16'hffff, tx_first), last_sync);
      miso_frozen <= 1'b0;
    end else if (byte_in) begin
      tx_data <= tx_next;
      if (check_hi) begin
        miso_frozen <= 1'b1;
      end else if (~miso_frozen) begin
        crc_miso <= crc16_byte(crc_miso, tx_next);
      end
      if (rep_start) begin
        rep_fetch <= rep_start_f;
        rep_len <= rep_start_f ? {1'b0, rx_data} + 9'd1 : 9'h001;
        rep_idx <= 9'h001;
      end else if (state == S_SDI) begin
        rep_idx <= rep_idx + 1'b1;
      end
    end
  end

  // let the last byte of the frame through the slave before closing it
  assign done = frame_end_d[1];

  // with CRC_EN the frame must end right after a matching CHECK; a damaged
  // frame reports integrity only
  assign integ   = (CRC_EN != 0) ? ~checked : (state != S_HI);
  assign end_err = integ ? 3'b100 : {1'b0, frame_err};

  // the frame commits
  assign pass = ~(blocked && ~resumed) && end_err == 3'h0;

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
      blocked <= resetn && (err != 3'h0);
      first <= 1'b1;
      resumed <= 1'b0;
      ack_seen <= 1'b0;
      retry_seen <= 1'b0;
      flush_seen <= 1'b0;
      w1c <= 3'h0;
      crc_mosi <= 16'hffff;
      checked <= 1'b0;
    end else if (byte_in) begin
      // the MOSI CRC runs through CHECK's 0x00; a byte after CHECK fails it
      if (state != S_CRC && ~checked) begin
        crc_mosi <= crc16_byte(crc_mosi, rx_data);
      end
      if (checked) begin
        checked <= 1'b0;
      end

      case (state)
        S_HI: begin
          hi <= rx_data;
          state <= S_LO;
        end
        S_LO: begin
          state <= S_HI;
          first <= 1'b0;
          if (first) begin
            resumed <= resume;
          end
          if (~cmd_ok) begin
            frame_err[ERR_INSTR] <= 1'b1;
          end else if (is_bridge) begin
            if (op == BR_FETCH) begin
              if (hi[1]) begin
                retry_seen <= 1'b1;
              end else begin
                ack_seen <= 1'b1;
              end
              if (~hi[0]) begin
                sdi_left <= {1'b0, rx_data} + 9'd2;
                state <= S_SDI;
              end
            end
            if (op == BR_CHECK) begin
              sdi_left <= 9'd2;
              state <= S_CRC;
            end
            if (br_exec && op == BR_FLUSH) begin
              flush_seen <= 1'b1;
            end
            if (br_exec && is_w1c) begin
              w1c <= w1c | rx_data[5:3];
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
        S_SDI: begin
          sdi_left <= sdi_left - 1'b1;
          if (sdi_left == 9'h001) begin
            state <= S_HI;
          end
        end
        S_CRC: begin
          sdi_left <= sdi_left - 1'b1;
          if (sdi_left == 9'h002) begin
            crc_rx_hi <= rx_data;
          end else begin
            checked <= ({crc_rx_hi, rx_data} == crc_mosi);
            state <= S_HI;
          end
        end
        default: begin
          state <= S_HI;
          frame_err[ERR_INSTR] <= 1'b1;
        end
      endcase

      seen <= 1'b1;
      if (no_room) begin
        frame_err[ERR_OVF] <= 1'b1;
      end
    end
  end

  // bridge writes, replayed one per clk once their frame has committed:
  // {is_gpio, address or index, data or {sel, value}}

  spi_translator_fifo #(
    .DATA_WIDTH (17),
    .ADDRESS_WIDTH (BRIDGE_FIFO_ADDRESS_WIDTH)
  ) i_bridge_fifo (
    .clk (clk),
    .resetn (resetn),
    .clear (1'b0),
    .s_valid (bq_we),
    .s_data ((op == BR_GPIO) ? {1'b1, rx_data, 6'h00, hi[2], hi[1]} :
                               {1'b0, 4'h0, hi[3:0], rx_data}),
    .s_full (bq_full),
    .s_room (),
    .commit (commit),
    .rollback (rollback),
    .drop (1'b0),
    .m_valid (bq_valid),
    .m_data (bq_data),
    .m_ready (1'b1),
    .m_level (),
    .rd_ack (1'b0),
    .rd_retry (1'b0));

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      reg_wr_en <= 1'b0;
      reg_wr_addr <= 8'h00;
      reg_wr_data <= 8'h00;
      gpio_wr_en <= 1'b0;
      gpio_wr_index <= 8'h00;
      gpio_wr_sel <= 1'b0;
      gpio_wr_value <= 1'b0;
    end else begin
      reg_wr_en <= bq_valid && ~bq_data[16];
      gpio_wr_en <= bq_valid && bq_data[16];
      if (bq_valid) begin
        reg_wr_addr <= bq_data[15:8];
        reg_wr_data <= bq_data[7:0];
        gpio_wr_index <= bq_data[15:8];
        gpio_wr_sel <= bq_data[1];
        gpio_wr_value <= bq_data[0];
      end
    end
  end

  // engine and chip select tracking. FLUSH resets the engines, which releases
  // every chip select and returns to engine 0: the instructions after it are
  // checked against that, and the commit keeps it.

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      eng <= 4'h0;
      cs_open <= 1'b0;
      eng_q <= 4'h0;
      cs_open_q <= 1'b0;
    end else begin
      if (br_exec && op == BR_FLUSH) begin
        eng <= 4'h0;
        cs_open <= 1'b0;
      end else if (cmd_we) begin
        if (is_bridge) begin
          eng <= rx_data[3:0];
        end else if (inst == CMD_CHIPSELECT) begin
          cs_open <= sel != 8'h00;
        end
      end
      if (commit) begin
        eng_q <= eng;
        cs_open_q <= cs_open;
      end else if (rollback) begin
        eng <= eng_q;
        cs_open <= cs_open_q;
      end
    end
  end

  // frame completion. A blocked frame is rolled back without touching err.
  // At the commit, FLUSH clears err and a CTRL_W to STATUS the bits written
  // as 1.

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      commit <= 1'b0;
      rollback <= 1'b0;
      resp_ack <= 1'b0;
      flush_req <= 1'b0;
      err <= 3'h0;
    end else begin
      commit <= 1'b0;
      rollback <= 1'b0;
      resp_ack <= 1'b0;
      flush_req <= 1'b0;
      if (done && seen) begin
        if (pass) begin
          commit <= 1'b1;
          resp_ack <= ack_seen & ~retry_seen;
          flush_req <= flush_seen;
          err <= flush_seen ? 3'h0 : (err & ~w1c);
        end else begin
          rollback <= 1'b1;
          if (~(blocked && ~resumed)) begin
            err <= err | end_err;
          end
        end
      end
    end
  end

  // frame header: STATUS a few clk after each frame ends, or after reset;
  // not while a frame runs, so byte 0 is stable while CS is low

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      snap_cnt <= SNAP_DELAY;
      tx_first <= 8'h00;
    end else begin
      if (done) begin
        snap_cnt <= SNAP_DELAY;
      end else if (snap_cnt != 4'h0) begin
        snap_cnt <= snap_cnt - 1'b1;
        if (snap_cnt == 4'h1 && ~frame_active) begin
          tx_first <= status;
        end
      end
    end
  end

endmodule
