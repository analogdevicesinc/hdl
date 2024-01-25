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

`ifndef BIT_MOD_CMD_V
`define BIT_MOD_CMD_V

`define MOD_BIT_CMD_WIDTH 4

`define MOD_BIT_CMD_NOP_     3'b000
`define MOD_BIT_CMD_WRITE_   3'b001
`define MOD_BIT_CMD_ACK_IBI_ 3'b010

`define MOD_BIT_CMD_START_   3'b100
`define MOD_BIT_CMD_STOP_    3'b101
`define MOD_BIT_CMD_ACK_SDR_ 3'b110
`define MOD_BIT_CMD_READ_    3'b111

// Stop, read, ack_sdr have PP variants to preserve the PP
// speed-grade, but the they never active drive SDA High.
// T-bit for read:
//  To continue, yield ACK_SDR:
//    Read RX to check if the peripheral wishes to continue.
//  To stop, yield Start, creating a Sr.
// ACK IBI bit:
//  To ACK, yield ACK_IBI.
//  to NACK, yield WRITE_OD_1

`define MOD_BIT_CMD_NOP        {`MOD_BIT_CMD_NOP_,    2'b00}
`define MOD_BIT_CMD_START_OD   {`MOD_BIT_CMD_START_,  2'b00}
`define MOD_BIT_CMD_STOP_OD    {`MOD_BIT_CMD_STOP_,   2'b00}
`define MOD_BIT_CMD_STOP_PP    {`MOD_BIT_CMD_STOP_,   2'b10}
`define MOD_BIT_CMD_WRITE_OD_0 {`MOD_BIT_CMD_WRITE_,  2'b00}
`define MOD_BIT_CMD_WRITE_OD_1 {`MOD_BIT_CMD_WRITE_,  2'b01}
`define MOD_BIT_CMD_WRITE_PP_0 {`MOD_BIT_CMD_WRITE_,  2'b10}
`define MOD_BIT_CMD_WRITE_PP_1 {`MOD_BIT_CMD_WRITE_,  2'b11}
`define MOD_BIT_CMD_READ_OD    {`MOD_BIT_CMD_READ_,   2'b00}
`define MOD_BIT_CMD_READ_PP    {`MOD_BIT_CMD_READ_,   2'b10}
`define MOD_BIT_CMD_ACK_SDR_OD {`MOD_BIT_CMD_ACK_SDR_,2'b00}
`define MOD_BIT_CMD_ACK_SDR_PP {`MOD_BIT_CMD_ACK_SDR_,2'b10}
`define MOD_BIT_CMD_ACK_IBI    {`MOD_BIT_CMD_ACK_IBI_,2'b00}

`endif
