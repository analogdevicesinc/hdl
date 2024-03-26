// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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

`ifndef WORD_COMMAND_V
`define WORD_COMMAND_V

`define CMDW_HEADER_WIDTH 4

`define CMDW_NOP                   5'd00
`define CMDW_START                 5'd01
`define CMDW_BCAST_7E_W0           5'd02
`define CMDW_MSG_SR                5'd03
`define CMDW_TARGET_ADDR_OD        5'd04
`define CMDW_TARGET_ADDR_PP        5'd05
`define CMDW_MSG_TX                5'd06
`define CMDW_MSG_RX                5'd07
`define CMDW_CCC_OD                5'd08
`define CMDW_CCC_PP                5'd09
`define CMDW_STOP_OD               5'd10
`define CMDW_STOP_PP               5'd11
`define CMDW_BCAST_7E_W1           5'd12
`define CMDW_DAA_DEV_CHAR          5'd13
`define CMDW_DYN_ADDR              5'd14
`define CMDW_IBI_MDB               5'd15
`define CMDW_SR                    5'd16
`define CMDW_I2C_TX                5'd17
`define CMDW_I2C_RX                5'd18

`endif
