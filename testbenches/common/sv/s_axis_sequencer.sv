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

`ifndef __S_AXIS_SEQUENCER_SV__
`define __S_AXIS_SEQUENCER_SV__

import axi4stream_vip_pkg::*;
import logger_pkg::*;

class s_axis_sequencer #(type T);

    T agent;
    xil_axi4stream_data_byte byte_stream [$];

  function new(T agent);
    this.agent = agent;
  endfunction

  task user_gen_tready();
    axi4stream_ready_gen tready_gen;
    tready_gen = agent.driver.create_ready("tready");
    tready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_RANDOM);
    tready_gen.set_low_time(1);
    tready_gen.set_high_time(2);
    agent.driver.send_tready(tready_gen);
  endtask

  // Get transfer from the monitor and serialize data into a byte stream
  // Assumption: all bytes from beat are valid (no position or null bytes)
  task get_transfer();

    axi4stream_monitor_transaction mytrans;
    xil_axi4stream_data_beat  data_beat;

    agent.monitor.item_collected_port.get(mytrans);

    //$display(mytrans.convert2string);

    data_beat = mytrans.get_data_beat();

    for (int i=0; i<mytrans.get_data_width()/8; i++) begin
      byte_stream.push_back(data_beat[i*8+:8]);
    end
  endtask;

  task verify_byte(bit [7:0] refdata);
    bit [7:0] data;
    if (byte_stream.size() == 0) begin
      `ERROR(("Byte steam empty !!!"));
    end else begin
      data = byte_stream.pop_front();
      if (data !== refdata) begin
        `ERROR(("Unexpected data received. Expected: %0h Found: %0h Left : %0d", refdata, data, byte_stream.size()));
      end
    end
  endtask

  task run();
    while (1) begin
      if (agent.monitor.item_collected_port.get_item_cnt() >= 1)
        get_transfer();
      else
        #1;
    end
  endtask

endclass

`endif
