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


`timescale 1ns/1ps

`ifndef _UTILS_SVH_
`define _UTILS_SVH_

// Help build agent package name like "<test_harness>_<mng_axi_vip>_0_pkg"
`define PKGIFY(th,vip) th``_``vip``_0_pkg

// Help build agent type like "<test_harness>_<mng_axi_vip>_0_<mst_t>"
`define AGENT(th,vip,agent_type) th``_``vip``_0_``agent_type

// Help build VIP parameter name  e.g. test_harness_dst_axis_vip_0_VIP_DATA_WIDTH
`define GETPARAM(th,vip,param) th``_``vip``_0_``param

`define DMAC_PARAMS(th,vip) th``_``vip``_0_ID, \
                            th``_``vip``_0_DMA_DATA_WIDTH_SRC, \
                            th``_``vip``_0_DMA_DATA_WIDTH_DEST, \
                            th``_``vip``_0_DMA_LENGTH_WIDTH, \
                            th``_``vip``_0_DMA_2D_TRANSFER, \
                            th``_``vip``_0_DMA_2D_TLAST_MODE, \
                            th``_``vip``_0_ASYNC_CLK_REQ_SRC, \
                            th``_``vip``_0_ASYNC_CLK_SRC_DEST, \
                            th``_``vip``_0_ASYNC_CLK_DEST_REQ, \
                            th``_``vip``_0_AXI_SLICE_DEST, \
                            th``_``vip``_0_AXI_SLICE_SRC, \
                            th``_``vip``_0_SYNC_TRANSFER_START, \
                            th``_``vip``_0_CYCLIC, \
                            th``_``vip``_0_DMA_AXI_PROTOCOL_DEST, \
                            th``_``vip``_0_DMA_AXI_PROTOCOL_SRC, \
                            th``_``vip``_0_DMA_TYPE_DEST, \
                            th``_``vip``_0_DMA_TYPE_SRC, \
                            th``_``vip``_0_DMA_AXI_ADDR_WIDTH, \
                            th``_``vip``_0_MAX_BYTES_PER_BURST, \
                            th``_``vip``_0_FIFO_SIZE, \
                            th``_``vip``_0_AXI_ID_WIDTH_SRC, \
                            th``_``vip``_0_AXI_ID_WIDTH_DEST, \
                            th``_``vip``_0_DISABLE_DEBUG_REGISTERS, \
                            th``_``vip``_0_ENABLE_DIAGNOSTICS_IF, \
                            th``_``vip``_0_ENABLE_FRAME_LOCK, \
                            th``_``vip``_0_MAX_NUM_FRAMES, \
                            th``_``vip``_0_USE_EXT_SYNC, \
                            th``_``vip``_0_HAS_AUTORUN

// Help build VIP Interface parameters name
`define AXI_VIP_IF_PARAMS(th,vip)    th``_``vip``_0_VIP_PROTOCOL,\
                                     th``_``vip``_0_VIP_ADDR_WIDTH,\
                                     th``_``vip``_0_VIP_DATA_WIDTH,\
                                     th``_``vip``_0_VIP_DATA_WIDTH,\
                                     th``_``vip``_0_VIP_ID_WIDTH,\
                                     th``_``vip``_0_VIP_ID_WIDTH,\
                                     th``_``vip``_0_VIP_AWUSER_WIDTH,\
                                     th``_``vip``_0_VIP_WUSER_WIDTH,\
                                     th``_``vip``_0_VIP_BUSER_WIDTH,\
                                     th``_``vip``_0_VIP_ARUSER_WIDTH,\
                                     th``_``vip``_0_VIP_RUSER_WIDTH,\
                                     th``_``vip``_0_VIP_SUPPORTS_NARROW,\
                                     th``_``vip``_0_VIP_HAS_BURST,\
                                     th``_``vip``_0_VIP_HAS_LOCK,\
                                     th``_``vip``_0_VIP_HAS_CACHE,\
                                     th``_``vip``_0_VIP_HAS_REGION,\
                                     th``_``vip``_0_VIP_HAS_PROT,\
                                     th``_``vip``_0_VIP_HAS_QOS,\
                                     th``_``vip``_0_VIP_HAS_WSTRB,\
                                     th``_``vip``_0_VIP_HAS_BRESP,\
                                     th``_``vip``_0_VIP_HAS_RRESP,\
                                     th``_``vip``_0_VIP_HAS_ARESETN

`define AXIS_VIP_IF_PARAMS(th,vip)   th``_``vip``_0_VIP_SIGNAL_SET,\
                                     th``_``vip``_0_VIP_DEST_WIDTH,\
                                     th``_``vip``_0_VIP_DATA_WIDTH,\
                                     th``_``vip``_0_VIP_ID_WIDTH,\
                                     th``_``vip``_0_VIP_USER_WIDTH,\
                                     th``_``vip``_0_VIP_USER_BITS_PER_BYTE,\
                                     th``_``vip``_0_VIP_HAS_ARESETN

`define AXI_VIP_PARAM_DECL   int AXI_VIP_PROTOCOL=0,\
                                 AXI_VIP_ADDR_WIDTH=32,\
                                 AXI_VIP_WDATA_WIDTH=32,\
                                 AXI_VIP_RDATA_WIDTH=32,\
                                 AXI_VIP_WID_WIDTH = 0,\
                                 AXI_VIP_RID_WIDTH = 0,\
                                 AXI_VIP_AWUSER_WIDTH=0,\
                                 AXI_VIP_WUSER_WIDTH=0,\
                                 AXI_VIP_BUSER_WIDTH=0,\
                                 AXI_VIP_ARUSER_WIDTH=0,\
                                 AXI_VIP_RUSER_WIDTH=0,\
                                 AXI_VIP_SUPPORTS_NARROW = 1,\
                                 AXI_VIP_HAS_BURST = 1,\
                                 AXI_VIP_HAS_LOCK = 1,\
                                 AXI_VIP_HAS_CACHE= 1,\
                                 AXI_VIP_HAS_REGION = 1,\
                                 AXI_VIP_HAS_PROT= 1,\
                                 AXI_VIP_HAS_QOS= 1,\
                                 AXI_VIP_HAS_WSTRB= 1,\
                                 AXI_VIP_HAS_BRESP= 1,\
                                 AXI_VIP_HAS_RRESP= 1,\
                                 AXI_VIP_HAS_ARESETN = 1

`define AXI_VIP_PARAM_ORDER   AXI_VIP_PROTOCOL,\
                              AXI_VIP_ADDR_WIDTH,\
                              AXI_VIP_WDATA_WIDTH,\
                              AXI_VIP_RDATA_WIDTH,\
                              AXI_VIP_WID_WIDTH,\
                              AXI_VIP_RID_WIDTH,\
                              AXI_VIP_AWUSER_WIDTH,\
                              AXI_VIP_WUSER_WIDTH,\
                              AXI_VIP_BUSER_WIDTH,\
                              AXI_VIP_ARUSER_WIDTH,\
                              AXI_VIP_RUSER_WIDTH,\
                              AXI_VIP_SUPPORTS_NARROW,\
                              AXI_VIP_HAS_BURST,\
                              AXI_VIP_HAS_LOCK,\
                              AXI_VIP_HAS_CACHE,\
                              AXI_VIP_HAS_REGION,\
                              AXI_VIP_HAS_PROT,\
                              AXI_VIP_HAS_QOS,\
                              AXI_VIP_HAS_WSTRB,\
                              AXI_VIP_HAS_BRESP,\
                              AXI_VIP_HAS_RRESP,\
                              AXI_VIP_HAS_ARESETN

`define AXIS_VIP_PARAM_DECL   int AXIS_VIP_INTERFACE_MODE     = 2,\
                                  AXIS_VIP_SIGNAL_SET         = 8'b00000011,\
                                  AXIS_VIP_DATA_WIDTH         = 8,\
                                  AXIS_VIP_ID_WIDTH           = 0,\
                                  AXIS_VIP_DEST_WIDTH         = 0,\
                                  AXIS_VIP_USER_WIDTH         = 0,\
                                  AXIS_VIP_USER_BITS_PER_BYTE = 0,\
                                  AXIS_VIP_HAS_TREADY         = 1,\
                                  AXIS_VIP_HAS_TSTRB          = 0,\
                                  AXIS_VIP_HAS_TKEEP          = 0,\
                                  AXIS_VIP_HAS_TLAST          = 0,\
                                  AXIS_VIP_HAS_ACLKEN         = 0,\
                                  AXIS_VIP_HAS_ARESETN        = 1

`define AXIS_VIP_PARAMS(th,vip) th``_``vip``_0_VIP_INTERFACE_MODE,\
                                th``_``vip``_0_VIP_SIGNAL_SET,\
                                th``_``vip``_0_VIP_DATA_WIDTH,\
                                th``_``vip``_0_VIP_ID_WIDTH,\
                                th``_``vip``_0_VIP_DEST_WIDTH,\
                                th``_``vip``_0_VIP_USER_WIDTH,\
                                th``_``vip``_0_VIP_USER_BITS_PER_BYTE,\
                                th``_``vip``_0_VIP_HAS_TREADY,\
                                th``_``vip``_0_VIP_HAS_TSTRB,\
                                th``_``vip``_0_VIP_HAS_TKEEP,\
                                th``_``vip``_0_VIP_HAS_TLAST,\
                                th``_``vip``_0_VIP_HAS_ACLKEN,\
                                th``_``vip``_0_VIP_HAS_ARESETN

`define AXI 0
`define AXIS 1
`define FIFO 2

`define ERROR(m)  \
  do begin  \
    PrintError($sformatf("[%m] %s \n found in %s:%0d", \
      $sformatf m , `__FILE__, `__LINE__)); \
  end while(0)

`define INFO(m)  \
  do begin  \
    PrintInfo($sformatf(" %s", \
      $sformatf m )); \
  end while(0)

// Info with verbosity option
`define INFOV(m,v)  \
  do begin  \
    PrintInfo($sformatf(" %s", \
      $sformatf m ),v); \
  end while(0)

`define MAX(a,b) ((a > b) ? a : b)
`define MIN(a,b) ((a > b) ? b : a)

`endif
