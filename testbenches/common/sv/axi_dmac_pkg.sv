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

package axi_dmac_pkg;

typedef struct {
  int ID;
  int DMA_DATA_WIDTH_SRC;
  int DMA_DATA_WIDTH_DEST;
  int DMA_LENGTH_WIDTH;
  int DMA_2D_TRANSFER;
  int DMA_2D_TLAST_MODE;
  int ASYNC_CLK_REQ_SRC;
  int ASYNC_CLK_SRC_DEST;
  int ASYNC_CLK_DEST_REQ;
  int AXI_SLICE_DEST;
  int AXI_SLICE_SRC;
  int SYNC_TRANSFER_START;
  int CYCLIC;
  int DMA_AXI_PROTOCOL_DEST;
  int DMA_AXI_PROTOCOL_SRC;
  int DMA_TYPE_DEST;
  int DMA_TYPE_SRC;
  int DMA_AXI_ADDR_WIDTH;
  int MAX_BYTES_PER_BURST;
  int FIFO_SIZE;
  int AXI_ID_WIDTH_SRC;
  int AXI_ID_WIDTH_DEST;
  int DISABLE_DEBUG_REGISTERS;
  int ENABLE_DIAGNOSTICS_IF;
  int ENABLE_FRAME_LOCK;
  int MAX_NUM_FRAMES;
  int USE_EXT_SYNC;
  int HAS_AUTORUN;
} axi_dmac_params_t;

endpackage

