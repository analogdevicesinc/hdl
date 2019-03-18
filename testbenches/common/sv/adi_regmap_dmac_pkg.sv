// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

/* Auto generated Register Map */
/* Mon Mar  4 13:51:35 2019 */

package adi_regmap_dmac_pkg;
  import adi_regmap_pkg::*;


/* DMA Controller (axi_dmac) */

  const reg_t dmac_VERSION = '{ 'h0000, "VERSION" , '{
    "VERSION_MAJOR": '{ 31, 16, RO, 'h04 },
    "VERSION_MINOR": '{ 15, 8, RO, 'h02 },
    "VERSION_PATCH": '{ 7, 0, RO, 'h61 }}};
  const reg_t dmac_PERIPHERAL_ID = '{ 'h0004, "PERIPHERAL_ID" , '{
    "PERIPHERAL_ID": '{ 31, 0, RO, 0 }}};
  const reg_t dmac_SCRATCH = '{ 'h0008, "SCRATCH" , '{
    "SCRATCH": '{ 31, 0, RW, 'h00000000 }}};
  const reg_t dmac_IDENTIFICATION = '{ 'h000c, "IDENTIFICATION" , '{
    "IDENTIFICATION": '{ 31, 0, RO, 'h444D4143 }}};
  const reg_t dmac_IRQ_MASK = '{ 'h0080, "IRQ_MASK" , '{
    "TRANSFER_COMPLETED": '{ 1, 1, RW, 'h1 },
    "TRANSFER_QUEUED": '{ 0, 0, RW, 'h1 }}};
  const reg_t dmac_IRQ_PENDING = '{ 'h0084, "IRQ_PENDING" , '{
    "TRANSFER_COMPLETED": '{ 1, 1, RW1C, 'h0 },
    "TRANSFER_QUEUED": '{ 0, 0, RW1C, 'h0 }}};
  const reg_t dmac_IRQ_SOURCE = '{ 'h0088, "IRQ_SOURCE" , '{
    "TRANSFER_COMPLETED": '{ 1, 1, RW1C, 'h0 },
    "TRANSFER_QUEUED": '{ 0, 0, RW1C, 'h0 }}};
  const reg_t dmac_CONTROL = '{ 'h0400, "CONTROL" , '{
    "PAUSE": '{ 1, 1, RW, 'h0 },
    "ENABLE": '{ 0, 0, RW, 'h0 }}};
  const reg_t dmac_TRANSFER_ID = '{ 'h0404, "TRANSFER_ID" , '{
    "TRANSFER_ID": '{ 4, 0, RO, 'h00 }}};
  const reg_t dmac_TRANSFER_SUBMIT = '{ 'h0408, "TRANSFER_SUBMIT" , '{
    "TRANSFER_SUBMIT": '{ 0, 0, RW, 'h00 }}};
  const reg_t dmac_FLAGS = '{ 'h040c, "FLAGS" , '{
    "CYCLIC": '{ 0, 0, RW, 0 },
    "TLAST": '{ 1, 1, RW, 'h1 },
    "PARTIAL_REPORTING_EN": '{ 2, 2, RW, 'h0 },
    "FRAME_LOCK_EN": '{ 3, 3, RW, 'h0 }}};
  const reg_t dmac_DEST_ADDRESS = '{ 'h0410, "DEST_ADDRESS" , '{
    "DEST_ADDRESS": '{ 31, 0, RW, 'h00000000 }}};
  const reg_t dmac_SRC_ADDRESS = '{ 'h0414, "SRC_ADDRESS" , '{
    "SRC_ADDRESS": '{ 31, 0, RW, 'h00000000 }}};
  const reg_t dmac_X_LENGTH = '{ 'h0418, "X_LENGTH" , '{
    "X_LENGTH": '{ 23, 0, RW, 0 }}};
  const reg_t dmac_Y_LENGTH = '{ 'h041c, "Y_LENGTH" , '{
    "Y_LENGTH": '{ 23, 0, RW, 'h000000 }}};
  const reg_t dmac_DEST_STRIDE = '{ 'h0420, "DEST_STRIDE" , '{
    "DEST_STRIDE": '{ 23, 0, RW, 'h000000 }}};
  const reg_t dmac_SRC_STRIDE = '{ 'h0424, "SRC_STRIDE" , '{
    "SRC_STRIDE": '{ 23, 0, RW, 'h000000 }}};
  const reg_t dmac_TRANSFER_DONE = '{ 'h0428, "TRANSFER_DONE" , '{
    "TRANSFER_0_DONE": '{ 0, 0, RO, 'h0 },
    "TRANSFER_1_DONE": '{ 1, 1, RO, 'h0 },
    "TRANSFER_2_DONE": '{ 2, 2, RO, 'h0 },
    "TRANSFER_3_DONE": '{ 3, 3, RO, 'h0 },
    "PARTIAL_TRANSFER_DONE": '{ 31, 31, RO, 'h0 }}};
  const reg_t dmac_ACTIVE_TRANSFER_ID = '{ 'h042c, "ACTIVE_TRANSFER_ID" , '{
    "ACTIVE_TRANSFER_ID": '{ 4, 0, RO, 'h00 }}};
  const reg_t dmac_STATUS = '{ 'h0430, "STATUS" , '{
    "RESERVED": '{ 31, 0, RO, 'h00 }}};
  const reg_t dmac_CURRENT_DEST_ADDRESS = '{ 'h0434, "CURRENT_DEST_ADDRESS" , '{
    "CURRENT_DEST_ADDRESS": '{ 31, 0, RO, 'h00 }}};
  const reg_t dmac_CURRENT_SRC_ADDRESS = '{ 'h0438, "CURRENT_SRC_ADDRESS" , '{
    "CURRENT_SRC_ADDRESS": '{ 31, 0, RO, 'h00 }}};
  const reg_t dmac_TRANSFER_PROGRESS = '{ 'h0448, "TRANSFER_PROGRESS" , '{
    "TRANSFER_PROGRESS": '{ 23, 0, RO, 'h000000 }}};
  const reg_t dmac_PARTIAL_TRANSFER_LENGTH = '{ 'h044c, "PARTIAL_TRANSFER_LENGTH" , '{
    "PARTIAL_LENGTH": '{ 31, 0, RO, 'h000000 }}};
  const reg_t dmac_PARTIAL_TRANSFER_ID = '{ 'h0450, "PARTIAL_TRANSFER_ID" , '{
    "PARTIAL_TRANSFER_ID": '{ 1, 0, RO, 'h0 }}};
  const reg_t dmac_FRAME_LOCK_CONFIG = '{ 'h0454, "FRAME_LOCK_CONFIG" , '{
    "FLOCK_NUMFRAMES": '{ 5, 0, RW, 'h00 },
    "FLOCK_FRAMEDISTANCE": '{ 20, 16, RW, 'h00 }}};
  const reg_t dmac_FRAME_LOCK_STRIDE = '{ 'h0458, "FRAME_LOCK_STRIDE" , '{
    "FLOCK_FRAMESTRIDE": '{ 31, 0, RW, 'h00 }}};

endpackage
