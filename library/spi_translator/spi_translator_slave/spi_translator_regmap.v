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
 * Bridge register file, 16 addresses. Written through CTRL_W at the end of a
 * good frame, read through CTRL_R.
 *
 *  0x00 VERSION_MAJOR R
 *  0x01 VERSION_MINOR R
 *  0x02 VERSION_PATCH R
 *  0x03 PERIPHERAL_ID R  PERIPHERAL_ID parameter
 *  0x04 SCRATCH     RW
 *  0x05 STATUS      R/W1C status byte, see spi_translator_execution.v; its
 *                        ERR bits are sticky, cleared by FLUSH or by
 *                        writing 1 to them (handled in the decoder)
 *  0x06 SYNC_ID     R    id of the last SYNC executed by the engine
 *  0x07 CMD_ROOM_L  R    free CMD FIFO entries, low byte
 *  0x08 CMD_ROOM_H  R    free CMD FIFO entries, high byte
 *  0x09 SDO_ROOM_L  R    free SDO FIFO bytes, low byte
 *  0x0a SDO_ROOM_H  R    free SDO FIFO bytes, high byte
 *  0x0b SDI_LEVEL_L R    SDI bytes waiting for FETCH, low byte
 *  0x0c SDI_LEVEL_H R    SDI bytes waiting for FETCH, high byte
 *
 *  0x0d GPIO_NUM_L  R    number of GPIOs, low byte; 0 = none
 *  0x0e GPIO_NUM_H  R    number of GPIOs, high byte
 *  0x0f CS_NUM      R    number of downstream chip selects (NUM_OF_CS),
 *                        spread over ceil(CS_NUM / 8) engines
 *
 * The GPIOs themselves are not in the register map:
 * they are written and read one pin at a time by the GPIO instruction, see
 * spi_translator_gpio.v.
 */

module spi_translator_regmap #(
  parameter [7:0] PERIPHERAL_ID = 8'h00,
  parameter NUM_OF_CS = 4,
  parameter NUM_OF_GPIO = 8
) (
  input                       clk,
  input                       resetn,

  input                       wr_en,
  input       [7:0]           wr_addr,
  input       [7:0]           wr_data,
  input       [7:0]           rd_addr,
  output  reg [7:0]           rd_data,

  input       [7:0]           status,
  input       [15:0]          cmd_room,
  input       [15:0]          sdo_room,
  input       [7:0]           last_sync,
  input       [15:0]          sdi_level
);

  localparam [7:0] VERSION_MAJOR = 8'h01;
  localparam [7:0] VERSION_MINOR = 8'h00;
  localparam [7:0] VERSION_PATCH = 8'h00;

  localparam [15:0] GPIO_NUM = NUM_OF_GPIO;
  localparam [7:0]  CS_NUM = NUM_OF_CS;

  reg   [7:0]                 scratch = 8'h00;

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      scratch <= 8'h00;
    end else if (wr_en && wr_addr == 8'h04) begin
      scratch <= wr_data;
    end
  end

  always @(*) begin
    case (rd_addr)
      8'h00:   rd_data = VERSION_MAJOR;
      8'h01:   rd_data = VERSION_MINOR;
      8'h02:   rd_data = VERSION_PATCH;
      8'h03:   rd_data = PERIPHERAL_ID;
      8'h04:   rd_data = scratch;
      8'h05:   rd_data = status;
      8'h06:   rd_data = last_sync;
      8'h07:   rd_data = cmd_room[7:0];
      8'h08:   rd_data = cmd_room[15:8];
      8'h09:   rd_data = sdo_room[7:0];
      8'h0a:   rd_data = sdo_room[15:8];
      8'h0b:   rd_data = sdi_level[7:0];
      8'h0c:   rd_data = sdi_level[15:8];
      8'h0d:   rd_data = GPIO_NUM[7:0];
      8'h0e:   rd_data = GPIO_NUM[15:8];
      8'h0f:   rd_data = CS_NUM;
      default: rd_data = 8'h00;
    endcase
  end

endmodule
