// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

package axi_time_pkg;

  localparam
    PCORE_VERSION = 32'h00000062,
    PCORE_MAGIC   = 32'h54494D45; // "TIME", big endian

  // register address offset
  localparam
    ADDR_TIME_VERSION        = 8'h00,
    ADDR_TIME_ID             = 8'h01,
    ADDR_TIME_SCRATCH        = 8'h02,
    ADDR_TIME_IDENTIFICATION = 8'h03,
    ADDR_TIME_INTERFACE      = 8'h04,
    ADDR_TIME_CONTROL        = 8'h10,
    ADDR_TIME_STATUS         = 8'h11,
    ADDR_TIME_CNT_OVWR_LOW   = 8'h12,
    ADDR_TIME_CNT_OVWR_HIGH  = 8'h13,
    ADDR_TIME_RX_CAPT_LOW    = 8'h14,
    ADDR_TIME_RX_CAPT_HIGH   = 8'h15,
    ADDR_TIME_RX_TRIG_LOW    = 8'h16,
    ADDR_TIME_RX_TRIG_HIGH   = 8'h17,
    ADDR_TIME_TX_CAPT_LOW    = 8'h18,
    ADDR_TIME_TX_CAPT_HIGH   = 8'h19,
    ADDR_TIME_TX_TRIG_LOW    = 8'h1A,
    ADDR_TIME_TX_TRIG_HIGH   = 8'h1B;

endpackage
