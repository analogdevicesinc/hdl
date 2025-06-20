// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

`ifndef I3C_CONTROLLER_REGMAP_V
`define I3C_CONTROLLER_REGMAP_V

`define I3C_REGMAP_VERSION          8'h00
`define I3C_REGMAP_DEVICE_ID        8'h01
`define I3C_REGMAP_SCRATCH          8'h02
`define I3C_REGMAP_ENABLE           8'h10
`define I3C_REGMAP_PID_L            8'h15
`define I3C_REGMAP_PID_H            8'h16
`define I3C_REGMAP_DCR_BCR_DA       8'h17
`define I3C_REGMAP_IRQ_MASK         8'h20
`define I3C_REGMAP_IRQ_PENDING      8'h21
`define I3C_REGMAP_IRQ_SOURCE       8'h22
`define I3C_REGMAP_CMD_FIFO_ROOM    8'h30
`define I3C_REGMAP_CMDR_FIFO_LEVEL  8'h31
`define I3C_REGMAP_SDO_FIFO_ROOM    8'h32
`define I3C_REGMAP_SDI_FIFO_LEVEL   8'h33
`define I3C_REGMAP_IBI_FIFO_LEVEL   8'h34
`define I3C_REGMAP_CMD_FIFO         8'h35
`define I3C_REGMAP_CMDR_FIFO        8'h36
`define I3C_REGMAP_SDO_FIFO         8'h37
`define I3C_REGMAP_SDI_FIFO         8'h38
`define I3C_REGMAP_IBI_FIFO         8'h39
`define I3C_REGMAP_FIFO_STATUS      8'h3a
`define I3C_REGMAP_OPS              8'h40
`define I3C_REGMAP_IBI_CONFIG       8'h50
`define I3C_REGMAP_DEV_CHAR         8'h60
`define I3C_REGMAP_OFFLOAD_CMD_     4'hb
`define I3C_REGMAP_OFFLOAD_SDO_     4'hc

`define I3C_REGMAP_IRQ_WIDTH        7
`define I3C_REGMAP_IRQ_CMDR_PENDING 5
`define I3C_REGMAP_IRQ_IBI_PENDING  6
`define I3C_REGMAP_IRQ_DAA_PENDING  7

`endif
