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
 * Instruction class 3'b111 (cmd[14:12]) is reserved for the bridge itself
 * and is never forwarded to the engine:
 *
 *   0x70xx  NOP
 *   0x71aa  CTRL_W to register aa, followed by one data byte
 *   0x72xx  FLUSH
 *
 * Instructions are written to the CMD FIFO and SDO bytes to the SDO FIFO as
 * they arrive. Both FIFOs are transactional: the frame is committed to them
 * together only after CS deasserts and the whole frame has checked out, and
 * rolled back otherwise. A rejected frame is dropped as a unit, so nothing
 * from it reaches a downstream device. Register writes and FLUSH also take
 * effect only at the end of a good frame.
 *
 * A frame is rejected, and the matching sticky err bit set, when it:
 *   [0] uses a reserved encoding (bit 15, class 101/110, an unknown bridge
 *       op, reserved TRANSFER or WRITE fields), selects more than one target
 *       in a CHIPSELECT, sets a word length outside 1..8, or carries more
 *       than one CTRL_W
 *   [1] does not fit in the room left in the CMD or SDO FIFO
 *   [2] ends inside an instruction or its SDO data
 * FLUSH clears err.
 *
 * Only 8-bit SDO words are supported: the engine is built with
 * DATA_WIDTH = 8, so each SDO word is one byte.
 */

module spi_translator_decoder (
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

  // register file

  output  reg                         reg_wr_en,
  output  reg [7:0]                   reg_wr_addr,
  output  reg [7:0]                   reg_wr_data,

  output  reg                         flush_req,
  output  reg [3:0]                   err
);

  localparam [1:0] S_HI  = 2'd0;
  localparam [1:0] S_LO  = 2'd1;
  localparam [1:0] S_SDO = 2'd2;
  localparam [1:0] S_REG = 2'd3;

  localparam [2:0] CMD_TRANSFER   = 3'b000;
  localparam [2:0] CMD_CHIPSELECT = 3'b001;
  localparam [2:0] CMD_WRITE      = 3'b010;
  localparam [2:0] CMD_MISC       = 3'b011;
  localparam [2:0] CMD_CS_INV     = 3'b100;
  localparam [2:0] CMD_BRIDGE     = 3'b111;

  localparam [3:0] BR_NOP    = 4'h0;
  localparam [3:0] BR_CTRL_W = 4'h1;
  localparam [3:0] BR_FLUSH  = 4'h2;

  localparam ERR_INSTR = 0;
  localparam ERR_OVF   = 1;

  reg   [1:0]                 state = S_HI;
  reg   [7:0]                 hi = 8'h00;
  reg   [8:0]                 sdo_left = 9'h000;
  reg                         seen = 1'b0;
  reg   [1:0]                 frame_err = 2'b00;
  reg                         reg_pending = 1'b0;
  reg   [7:0]                 reg_addr = 8'h00;
  reg   [7:0]                 reg_data = 8'h00;
  reg                         flush_pending = 1'b0;

  wire                        byte_in;
  wire  [2:0]                 inst;
  wire  [3:0]                 sel;
  wire                        sel_ok;
  wire                        is_bridge;
  wire                        cmd_ok;
  wire                        store_cmd;
  wire                        store_sdo;
  wire                        no_room;
  wire                        done;
  wire  [2:0]                 end_err;

  assign byte_in = rx_valid & frame_active;
  assign inst    = hi[6:4];

  // targets a CHIPSELECT pulls low; at most one of the four is allowed
  assign sel    = ~rx_data[3:0];
  assign sel_ok = (sel & (sel - 1'b1)) == 4'h0;

  // checks on the instruction {hi, rx_data}, evaluated on its second byte
  assign is_bridge = (inst == CMD_BRIDGE);
  assign cmd_ok = ~hi[7] && (
    (inst == CMD_TRANSFER   && hi[3:2] == 2'b00) ||
    (inst == CMD_CHIPSELECT && sel_ok) ||
    (inst == CMD_WRITE      && hi[3] == 1'b0 && hi[2:0] <= 3'b100 &&
                               (hi[2:0] != 3'b010 || (rx_data != 8'h00 && rx_data <= 8'd8))) ||
    (inst == CMD_MISC) ||
    (inst == CMD_CS_INV) ||
    (is_bridge && hi[3:0] <= BR_FLUSH && ~(hi[3:0] == BR_CTRL_W && reg_pending)));

  // engine instructions go to the CMD FIFO, their SDO bytes to the SDO FIFO;
  // nothing more is written once the frame has failed
  assign store_cmd = byte_in && frame_err == 2'b00 && state == S_LO && cmd_ok && ~is_bridge;
  assign store_sdo = byte_in && frame_err == 2'b00 && state == S_SDO;
  assign no_room   = (store_cmd & cmd_full) | (store_sdo & sdo_full);

  assign cmd_we    = store_cmd & ~cmd_full;
  assign cmd_wdata = {hi, rx_data};
  assign sdo_we    = store_sdo & ~sdo_full;
  assign sdo_wdata = rx_data;
  assign done      = frame_end;

  assign end_err   = {state != S_HI, frame_err};

  always @(posedge clk) begin
    if (resetn == 1'b0 || frame_start == 1'b1) begin
      state <= S_HI;
      seen <= 1'b0;
      frame_err <= 2'b00;
      reg_pending <= 1'b0;
      flush_pending <= 1'b0;
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
            if (hi[3:0] == BR_CTRL_W) begin
              reg_addr <= rx_data;
              state <= S_REG;
            end
            if (hi[3:0] == BR_FLUSH) begin
              flush_pending <= 1'b1;
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
          reg_data <= rx_data;
          reg_pending <= 1'b1;
          state <= S_HI;
        end
      endcase

      if (no_room) begin
        frame_err[ERR_OVF] <= 1'b1;
      end
    end
  end

  // frame completion

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      commit <= 1'b0;
      rollback <= 1'b0;
      reg_wr_en <= 1'b0;
      flush_req <= 1'b0;
      err <= 4'h0;
    end else begin
      commit <= 1'b0;
      rollback <= 1'b0;
      reg_wr_en <= 1'b0;
      flush_req <= 1'b0;
      if (done && seen) begin
        if (end_err != 3'h0) begin
          rollback <= 1'b1;
          err <= err | end_err;
        end else if (flush_pending) begin
          rollback <= 1'b1;
          flush_req <= 1'b1;
          err <= 4'h0;
        end else begin
          commit <= 1'b1;
          reg_wr_en <= reg_pending;
          reg_wr_addr <= reg_addr;
          reg_wr_data <= reg_data;
        end
      end
    end
  end

endmodule
