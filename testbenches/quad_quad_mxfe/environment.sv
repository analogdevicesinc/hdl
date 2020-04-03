`include "utils.svh"
`include "m_axi_sequencer.sv"

`ifndef __ENVIRONMENT_SV__
`define __ENVIRONMENT_SV__

import axi_vip_pkg::*;
import axi4stream_vip_pkg::*;
import `PKGIFY(`TH, `MNG_AXI)::*;

class environment;

  // Agents
  `AGENT(`TH, `MNG_AXI, mst_t) mng_agent;
  // Sequencers
  m_axi_sequencer #(`AGENT(`TH, `MNG_AXI, mst_t)) mng;

  // Register accessors
  bit done = 0;


  //============================================================================
  // Constructor
  //============================================================================
  function new(
    virtual interface axi_vip_if #(`AXI_VIP_IF_PARAMS(`TH, `MNG_AXI)) mng_vip_if
  );

    // Creating the agents
    mng_agent = new("AXI Manager agent", mng_vip_if);

    // Creating the sequencers
    mng = new(mng_agent);

  endfunction

  //============================================================================
  // Start environment
  //   - Connect all the agents to the scoreboard
  //   - Start the agents
  //============================================================================
  task start();
    mng_agent.start_master();

  endtask

  //============================================================================
  // Start the test
  //   - start the scoreboard
  //   - start the sequencers
  //============================================================================
  task test();
    fork

    join_none
  endtask

  //============================================================================
  // Post test subroutine
  //============================================================================
  task post_test();
    // wait until done
    wait_done();
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
  endtask

  //============================================================================
  // Wait until all component are done
  //============================================================================
  task wait_done;
    wait (done == 1);
    //`INFO(("Shutting down"));
  endtask

  //============================================================================
  // Test controller routine
  //============================================================================
  task test_c_run();
    done = 1;
  endtask



endclass

`endif
