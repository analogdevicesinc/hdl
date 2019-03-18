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

`include "utils.svh"
`include "adi_regmap_dmac_pkg.sv"
`include "dma_trans.sv"
`include "reg_accessor.sv"

`ifndef __DMAC_API_SV__
`define __DMAC_API_SV__

import logger_pkg::*;
import adi_regmap_dmac_pkg::*;
import adi_regmap_pkg::*;

class dmac_api;

  reg_accessor mng;

  int DMAC_BA;
  // DMAC parameters
  axi_dmac_params_t p;

  function new(reg_accessor mng,
               int DMAC_BA,
               axi_dmac_params_t p);
    this.mng = mng;
    this.DMAC_BA = DMAC_BA;
    this.p = p;
  endfunction

  task enable_dma();
    mng.RegWrite32( DMAC_BA + GetAddrs(dmac_CONTROL),
                              SetField(dmac_CONTROL, "ENABLE", 1));
  endtask

  task disable_dma();
    mng.RegWrite32( DMAC_BA + GetAddrs(dmac_CONTROL),
                              SetField(dmac_CONTROL, "ENABLE", 0));
  endtask

  task wait_transfer_submission;
    bit [31:0] regData = 'h0;
    bit timeout;

    regData = 'h0;
    timeout = 0;
    fork
      begin
        do
          mng.RegRead32( DMAC_BA + GetAddrs(dmac_TRANSFER_SUBMIT), regData);
        while (GetField(dmac_TRANSFER_SUBMIT,
                        "TRANSFER_SUBMIT",
                        regData) != 0);
        `INFO(("Ready for submission "));
      end
      begin
        #2ms;
        timeout = 1;
      end
    join_any
    if (timeout) begin
       `ERROR(("Waiting transfer submission TIMEOUT !!!"));
    end
  endtask

  task transfer_start;
    mng.RegWrite32( DMAC_BA + GetAddrs(dmac_TRANSFER_SUBMIT),
                              SetField(dmac_TRANSFER_SUBMIT, "TRANSFER_SUBMIT", 1));
    `INFO(("Transfer start"));
  endtask

  task wait_transfer_done(input bit [3:0] transfer_id,
                          input bit partial_segment = 0,
                          input int segment_length = 0,
                          input int timeut_in_us = 2000);
    bit [31:0] regData = 'h0;
    bit timeout;
    int segment_length_found,id_found;
    bit partial_info_available;

    regData = 'h0;
    timeout = 0;
    fork
      begin
        while (~regData[transfer_id]) begin
          mng.RegRead32( DMAC_BA + GetAddrs(dmac_TRANSFER_DONE), regData);
        end
        `INFO(("Transfer id %0d DONE",transfer_id));

        partial_info_available = GetField(dmac_TRANSFER_DONE,
                                          "PARTIAL_TRANSFER_DONE",
                                          regData);

        if (partial_segment == 1) begin
          if (partial_info_available != 1) begin
            `ERROR(("Partial transfer info availability not set for ID %0d", transfer_id));
          end

          `INFO(("Found partial data info for ID  %0d",transfer_id));
          mng.RegRead32( DMAC_BA + GetAddrs(dmac_PARTIAL_TRANSFER_LENGTH), regData);
          segment_length_found = GetField(dmac_PARTIAL_TRANSFER_LENGTH,
                                          "PARTIAL_LENGTH",
                                           regData);
          if (segment_length_found != segment_length) begin
            `ERROR(("Partial transfer length does not match Expected %0d Found %0d",
                    segment_length, segment_length_found));
          end else begin
            `INFO(("Found partial data info length is %0d",segment_length));
          end
          mng.RegRead32( DMAC_BA + GetAddrs(dmac_PARTIAL_TRANSFER_ID), regData);
          id_found = GetField(dmac_PARTIAL_TRANSFER_ID,
                              "PARTIAL_TRANSFER_ID",
                              regData);

          if (id_found != transfer_id) begin
            `ERROR(("Partial transfer ID does not match Expected %0d Found %0d",
                    transfer_id ,id_found));
          end
        end

      end
      begin
        repeat (timeut_in_us) begin
          #1us;
        end
        timeout = 1;
      end
    join_any
    if (timeout) begin
       `ERROR(("Waiting transfer done TIMEOUT !!!"));
    end
  endtask

  task transfer_id_get(output bit [3:0] transfer_id);
    mng.RegRead32( DMAC_BA + GetAddrs(dmac_TRANSFER_ID), transfer_id);
    `INFO(("Found transfer ID = %0d", transfer_id));
  endtask

  task submit_transfer(dma_segment t,
                       output int next_transfer_id);

    dma_2d_segment t_2d;
    dma_flocked_2d_segment t_fl_2d;
    int bus_max_width = `MAX(p.DMA_DATA_WIDTH_SRC, p.DMA_DATA_WIDTH_DEST)/8;
    int partial_reporting_en = 1;
    int flock_en = 0;

    wait_transfer_submission();
    `INFO((" Submitting up a segment of : "));
    t.print();
    `INFO((" --------------------------"));

    if (t.length % bus_max_width > 0) begin
      `ERROR(("Transfer length (%0d) must be multiple of largest interface (%0d)", t.length, bus_max_width));
    end
    if (p.DMA_TYPE_SRC == 0) begin
      mng.RegWrite32( DMAC_BA + GetAddrs(dmac_SRC_ADDRESS),
                                SetField(dmac_SRC_ADDRESS, "SRC_ADDRESS", t.src_addr));
    end
    if (p.DMA_TYPE_DEST == 0) begin
      mng.RegWrite32( DMAC_BA + GetAddrs(dmac_DEST_ADDRESS),
                                SetField(dmac_DEST_ADDRESS, "DEST_ADDRESS", t.dst_addr));
    end
    mng.RegWrite32( DMAC_BA + GetAddrs(dmac_X_LENGTH),
                              SetField(dmac_X_LENGTH, "X_LENGTH", t.length-1));

    if (p.DMA_2D_TRANSFER == 1) begin
      if (!$cast(t_2d,t)) begin
        // Write the default values for 2D regs for non-2D transcactions
        t_2d = new();
        t_2d.ylength = 1;
        t_2d.src_stride = 0;
        t_2d.dst_stride = 0;
      end
      mng.RegWrite32( DMAC_BA + GetAddrs(dmac_Y_LENGTH),
                                SetField(dmac_Y_LENGTH, "Y_LENGTH", t_2d.ylength-1));
      if (p.DMA_TYPE_SRC == 0) begin
        mng.RegWrite32( DMAC_BA + GetAddrs(dmac_SRC_STRIDE),
                                  SetField(dmac_SRC_STRIDE, "SRC_STRIDE", t_2d.src_stride));
      end
      if (p.DMA_TYPE_DEST == 0) begin
        mng.RegWrite32( DMAC_BA + GetAddrs(dmac_DEST_STRIDE),
                                  SetField(dmac_DEST_STRIDE, "DEST_STRIDE", t_2d.dst_stride));
      end
    end

    if ($cast(t_fl_2d,t)) begin
      flock_en = t_fl_2d.flock_en;
      mng.RegWrite32( DMAC_BA + GetAddrs(dmac_FRAME_LOCK_CONFIG),
                                SetField(dmac_FRAME_LOCK_CONFIG, "FLOCK_NUMFRAMES", t_fl_2d.num_of_buffers) |
                                t_fl_2d.flock_mode << 8 |
                                t_fl_2d.flock_wait_master << 9 |
                                SetField(dmac_FRAME_LOCK_CONFIG, "FLOCK_FRAMEDISTANCE", t_fl_2d.frame_distance-1)
                                );
      mng.RegWrite32( DMAC_BA + GetAddrs(dmac_FRAME_LOCK_STRIDE),
                                SetField(dmac_FRAME_LOCK_STRIDE, "FLOCK_FRAMESTRIDE", t_fl_2d.frame_stride)
                                );
    end

    mng.RegWrite32( DMAC_BA + GetAddrs(dmac_FLAGS),
                              SetField(dmac_FLAGS, "FRAME_LOCK_EN", flock_en) |
                              SetField(dmac_FLAGS, "PARTIAL_REPORTING_EN", partial_reporting_en) |
                              SetField(dmac_FLAGS, "CYCLIC", t.cyclic) |
                              SetField(dmac_FLAGS, "TLAST", t.last)
                              );

    transfer_id_get(next_transfer_id);
    transfer_start();


  endtask : submit_transfer;
endclass

`endif
