// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
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

package axi_tdd_pkg;

  typedef enum logic [1:0] {
    IDLE    = 2'b00,
    ARMED   = 2'b01,
    WAITING = 2'b10,
    RUNNING = 2'b11} state_t;

  localparam
    PCORE_VERSION = 32'h00020062,
    PCORE_MAGIC   = 32'h5444444E; // "TDDN", big endian

  // register address offset
  localparam
    ADDR_TDD_VERSION        = 8'h00,
    ADDR_TDD_ID             = 8'h01,
    ADDR_TDD_SCRATCH        = 8'h02,
    ADDR_TDD_IDENTIFICATION = 8'h03,
    ADDR_TDD_INTERFACE      = 8'h04,
    ADDR_TDD_DEF_POLARITY   = 8'h05,
    ADDR_TDD_CONTROL        = 8'h10,
    ADDR_TDD_CH_ENABLE      = 8'h11,
    ADDR_TDD_CH_POLARITY    = 8'h12,
    ADDR_TDD_BURST_COUNT    = 8'h13,
    ADDR_TDD_STARTUP_DELAY  = 8'h14,
    ADDR_TDD_FRAME_LENGTH   = 8'h15,
    ADDR_TDD_SYNC_CNT_LOW   = 8'h16,
    ADDR_TDD_SYNC_CNT_HIGH  = 8'h17,
    ADDR_TDD_STATUS         = 8'h18,
    ADDR_TDD_CH_ON          = 8'h20,
    ADDR_TDD_CH_OFF         = 8'h21;

  // channel offset values
  localparam
    CH0  = 0,
    CH1  = 1,
    CH2  = 2,
    CH3  = 3,
    CH4  = 4,
    CH5  = 5,
    CH6  = 6,
    CH7  = 7,
    CH8  = 8,
    CH9  = 9,
    CH10 = 10,
    CH11 = 11,
    CH12 = 12,
    CH13 = 13,
    CH14 = 14,
    CH15 = 15,
    CH16 = 16,
    CH17 = 17,
    CH18 = 18,
    CH19 = 19,
    CH20 = 20,
    CH21 = 21,
    CH22 = 22,
    CH23 = 23,
    CH24 = 24,
    CH25 = 25,
    CH26 = 26,
    CH27 = 27,
    CH28 = 28,
    CH29 = 29,
    CH30 = 30,
    CH31 = 31;

endpackage
