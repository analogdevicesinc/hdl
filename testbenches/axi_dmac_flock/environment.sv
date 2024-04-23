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
`include "dmac_api.sv"
`include "m_axi_sequencer.sv"
`include "s_axi_sequencer.sv"
`include "m_axis_sequencer.sv"
`include "s_axis_sequencer.sv"
`include "scoreboard.sv"

`ifndef __ENVIRONMENT_SV__
`define __ENVIRONMENT_SV__

import axi_vip_pkg::*;
import axi4stream_vip_pkg::*;
import `PKGIFY(test_harness, master_dma)::*;
import `PKGIFY(test_harness, slave_dma)::*;
import `PKGIFY(test_harness, mng_axi_vip)::*;
import `PKGIFY(test_harness, ddr_axi_vip)::*;
import `PKGIFY(test_harness, src_axis_vip)::*;
import `PKGIFY(test_harness, dst_axis_vip)::*;
`ifdef HAS_VDMA
import `PKGIFY(test_harness, ref__axis_vip)::*;
import `PKGIFY(test_harness, ref_dst_axis_vip)::*;
`endif

class environment;

  // Agents
  `AGENT(test_harness, mng_axi_vip, mst_t) mng_agent;
  `AGENT(test_harness, ddr_axi_vip, slv_mem_t) ddr_axi_agent;
  `AGENT(test_harness, src_axis_vip, mst_t) src_axis_agent;
  `AGENT(test_harness, dst_axis_vip, slv_t) dst_axis_agent;
  `ifdef HAS_VDMA
  `AGENT(test_harness, ref__axis_vip, mst_t) ref_src_axis_agent;
  `AGENT(test_harness, ref_dst_axis_vip, slv_t) ref_dst_axis_agent;
  `endif
  // Sequencers
  m_axi_sequencer #(`AGENT(test_harness, mng_axi_vip, mst_t)) mng;
  s_axi_sequencer #(`AGENT(test_harness, ddr_axi_vip, slv_mem_t)) ddr_axi_seq;
  m_axis_sequencer #(`AGENT(test_harness, src_axis_vip, mst_t),
                     `AXIS_VIP_PARAMS(test_harness, src_axis_vip)
                    ) src_axis_seq;
  s_axis_sequencer #(`AGENT(test_harness, dst_axis_vip, slv_t)) dst_axis_seq;
  `ifdef HAS_VDMA
  m_axis_sequencer #(`AGENT(test_harness, ref__axis_vip, mst_t),
                     `AXIS_VIP_PARAMS(test_harness, ref__axis_vip)
                    ) ref_src_axis_seq;
  s_axis_sequencer #(`AGENT(test_harness, ref_dst_axis_vip, slv_t)) ref_dst_axis_seq;
  `endif

  // Register accessors
  dmac_api m_dmac_api;
  dmac_api s_dmac_api;

  dma_transfer_group trans_q[$];
  bit done = 0;

  scoreboard scrb;

  //============================================================================
  // Constructor
  //============================================================================
  function new(
    virtual interface axi_vip_if #(`AXI_VIP_IF_PARAMS(test_harness, mng_axi_vip)) mng_vip_if,
    virtual interface axi_vip_if #(`AXI_VIP_IF_PARAMS(test_harness, ddr_axi_vip)) ddr_vip_if,
  `ifdef HAS_VDMA
    virtual interface axi4stream_vip_if #(`AXIS_VIP_IF_PARAMS(test_harness, ref__axis_vip)) ref_src_axis_vip_if,
    virtual interface axi4stream_vip_if #(`AXIS_VIP_IF_PARAMS(test_harness, ref_dst_axis_vip)) ref_dst_axis_vip_if,
  `endif
    virtual interface axi4stream_vip_if #(`AXIS_VIP_IF_PARAMS(test_harness, src_axis_vip)) src_axis_vip_if,
    virtual interface axi4stream_vip_if #(`AXIS_VIP_IF_PARAMS(test_harness, dst_axis_vip)) dst_axis_vip_if
  );

    // Creating the agents
    mng_agent = new("AXI Manager agent", mng_vip_if);
    ddr_axi_agent = new("AXI DDR stub agent", ddr_vip_if);
    src_axis_agent = new("Src AXI stream agent", src_axis_vip_if);
    dst_axis_agent = new("Dest AXI stream agent", dst_axis_vip_if);
  `ifdef HAS_VDMA
    ref_src_axis_agent = new("Ref Src AXI stream agent", ref_src_axis_vip_if);
    ref_dst_axis_agent = new("Ref Dest AXI stream agent", ref_dst_axis_vip_if);
  `endif

    // Creating the sequencers
    mng = new(mng_agent);
    ddr_axi_seq = new(ddr_axi_agent);
    src_axis_seq = new(src_axis_agent);
    dst_axis_seq = new(dst_axis_agent);
  `ifdef HAS_VDMA
    ref_src_axis_seq = new(ref_src_axis_agent);
    ref_dst_axis_seq = new(ref_dst_axis_agent);
  `endif

    // Creating the register accessors
    m_dmac_api = new(mng,
             'h44A00000,
             {`DMAC_PARAMS(test_harness, master_dma)}
            );
    s_dmac_api = new(mng,
             'h44A10000,
             {`DMAC_PARAMS(test_harness, slave_dma)}
            );

    scrb = new;

  endfunction

  //============================================================================
  // Start environment
  //   - Connect all the agents to the scoreboard
  //   - Start the agents
  //============================================================================
  task start();
    scrb.connect(
      src_axis_agent.monitor.item_collected_port,
      dst_axis_agent.monitor.item_collected_port
    );

    mng_agent.start_master();
    ddr_axi_agent.start_slave();
    src_axis_agent.start_master();
    dst_axis_agent.start_slave();
  `ifdef HAS_VDMA
    ref_src_axis_agent.start_master();
    ref_dst_axis_agent.start_slave();
  `endif

    // stop monitor on DDR model
    ddr_axi_agent.monitor.item_collected_port.clr_enabled();

  endtask

  //============================================================================
  // Start the test
  //   - start the scoreboard
  //   - start the sequencers
  //============================================================================
  task test();
    fork
      src_axis_seq.run();
      `ifdef HAS_VDMA
      ref_src_axis_seq.run();
      `endif
      // DEST AXIS does not have to run, scoreboard connects and
      // gathers packets from the agent
      //  dst_axis_seq.run();
      scrb.run();
      test_c_run();
    join_none
  endtask

  //============================================================================
  // Post test subroutine
  //============================================================================
  task post_test();
    // wait until done
    wait_done();
    scrb.shutdown();
  endtask

  //============================================================================
  // Run subroutine
  //============================================================================
  task run;
    test();
    post_test();
  endtask

  //============================================================================
  // Stop subroutine
  //============================================================================
  task stop;
    mng_agent.stop_master();
    ddr_axi_agent.stop_slave();
    src_axis_agent.stop_master();
    dst_axis_agent.stop_slave();
  `ifdef HAS_VDMA
    ref_src_axis_agent.stop_master();
    ref_dst_axis_agent.stop_slave();
  `endif
  endtask

  //============================================================================
  // Wait until all component are done
  //============================================================================
  task wait_done;
    do
      wait (done == 1);
    while (trans_q.size()!=0);
    //`INFO(("Shutting down"));
  endtask

  //============================================================================
  // Test controller routine
  //============================================================================
  task test_c_run();
    done = 1;
  endtask

  //============================================================================
  // Interface to the test env
  //============================================================================
  function void queue_trans_g(dma_transfer_group tg);
    trans_q.push_back(tg);
  endfunction

endclass

`endif
