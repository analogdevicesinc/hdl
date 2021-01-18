// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad463x_data_capture_tb ();

  parameter VCD_FILE = {`__FILE__,"cd"};

  // set to one to increase verbosity
  localparam DEBUG = 1;
  localparam PASSED = 1;
  localparam FAILED = 0;

  localparam DDR_EN = 0;
  localparam NUM_OF_LANES = 1;
  localparam TRANSFER_CYCLE = 120;
  localparam TRANSFER_PERIOD = 40;

  reg clk = 1'b0;
  reg [NUM_OF_LANES-1:0] data_in = {NUM_OF_LANES{1'b0}};
  reg m_axis_ready = 1'b1;
  reg csn_clk = 1;

  wire csn;
  wire echo_sclk;
  wire m_axis_valid;
  wire [(NUM_OF_LANES *32)-1:0] m_axis_data;

  //---------------------------------------------------------------------------
  // test bench regs and wires
  //---------------------------------------------------------------------------

  reg echo_sclk_int = 0;
  integer csn_counter = 0;

  //---------------------------------------------------------------------------
  // VCD dump
  //---------------------------------------------------------------------------

  initial begin
    $dumpfile (VCD_FILE);
    $dumpvars;
  end

  //---------------------------------------------------------------------------
  // clock generation
  //---------------------------------------------------------------------------

  always #5  clk = ~clk;
  always #10 echo_sclk_int = ~echo_sclk_int;

  //---------------------------------------------------------------------------
  // chis select generation
  //---------------------------------------------------------------------------

  always @(negedge clk) begin
    if (csn_counter == TRANSFER_CYCLE-1)
      csn_counter = 0;
    else
      csn_counter++;
  end
  assign csn = (csn_counter < TRANSFER_CYCLE - TRANSFER_PERIOD) ? 1'b1 : 1'b0;

  assign echo_sclk = ~csn & echo_sclk_int;

  // CSN for DUT must be synchronous to clk
  always @(posedge clk) begin
    csn_clk <= csn;
  end
  //---------------------------------------------------------------------------
  // device BFM - MISO (SDO) generation
  //---------------------------------------------------------------------------

  reg csn_d = 0;
  always @(posedge clk) begin
    csn_d <= csn;
  end

  reg [19:0] data_serial[NUM_OF_LANES-1:0];

  // SDR
  initial begin
    while (1) begin
     @(posedge echo_sclk or negedge csn);
     if (csn_d) begin
       for (int i=0; i<NUM_OF_LANES; i=i+1)
         data_serial[i] <= $urandom();
     end else begin
       for (int i=0; i<NUM_OF_LANES; i=i+1) begin
         data_in[i] <= data_serial[i][19];
         data_serial[i] <= data_serial[i] << 1;
       end
     end

    end
  end

  //---------------------------------------------------------------------------
  // Monitors
  //---------------------------------------------------------------------------

  bit [31:0] mon_data_src[$];
  bit [31:0] mon_data_snk[$];

  // source - expected data
  initial begin
    while (1) begin
      @(negedge csn_clk);
      for (int i=0; i<NUM_OF_LANES; i++) begin
        mon_data_src.push_front(data_serial[i]);
      end
    end
  end

  // sink - received data
  initial begin
    while (1) begin
      @(posedge clk) #1;
      if (m_axis_valid) begin
        for (int i=0; i<NUM_OF_LANES; i++) begin
          mon_data_snk.push_front(m_axis_data[32*i+:32]);
        end
      end
    end
  end

  //---------------------------------------------------------------------------
  // Scoreboard
  //---------------------------------------------------------------------------

  event end_of_sim;
  bit tb_status = PASSED; // not guilty until proven
  initial begin

    @end_of_sim;
    $display("Scoreboard results...");
    check_xfer_queue("SCOREBOARD", mon_data_src, mon_data_snk);

  end


  //---------------------------------------------------------------------------
  // test bench
  //---------------------------------------------------------------------------

  initial begin
    csn_counter = 0;

    // time of the simulation
    #10000;

    @(posedge m_axis_valid) #20; // WARNING this can block the sim

    ->end_of_sim;
    #0
    print_status(tb_status);

    $finish;
  end

  //--------------------------------------------------------------------------
  // Helper functions
  //--------------------------------------------------------------------------

  function print_queue(string queue_name, bit [31:0] queue[$]);
  begin
    $display("======================================");
    $display("Printing %s...", queue_name);
    for(int i=0; i<queue.size(); i++)
      $display("INFO %s[%d] = 0x%h", queue_name, i, queue[i]);
      $display("======================================");
    end
  endfunction

  function check_xfer_queue(string xfer_name, bit [31:0] exp[$], bit [31:0] rec[$]);
  begin
    if (exp.size() != rec.size()) begin
      $display("ERROR %s  Source and sink number of transfers mismatch! SRC=%d - SNK=%d", xfer_name, exp.size(), rec.size());
      if (DEBUG) begin
        print_queue({"expected_", xfer_name}, exp);
        print_queue({"received_", xfer_name}, rec);
      end
      tb_status = FAILED;
    end else begin
      while(exp.size()) begin
        if(exp[$] != rec[$]) begin
          $display("ERROR %s transfer mismatch: rec 0x%h - exp 0x%h", xfer_name, rec[$], exp[$]);
          tb_status = FAILED;
        end
        exp.pop_back();
        rec.pop_back();
      end
    end
  end
  endfunction
  function print_status(bit tb_status);
  begin
    if (tb_status == PASSED) begin
      $display(" #####   #####   ######  ###### ");
      $display(" #    # #     # #       #       ");
      $display(" #    # #     # #       #       ");
      $display(" #####  #######  #####   #####  ");
      $display(" #      #     #       #       # ");
      $display(" #      #     #       #       # ");
      $display(" #      #     # ######  ######  ");
    end else begin
      $display(" #####   #####  ### #       ");
      $display(" #      #     #  #  #       ");
      $display(" #      #     #  #  #       ");
      $display(" #####  #######  #  #       ");
      $display(" #      #     #  #  #       ");
      $display(" #      #     #  #  #       ");
      $display(" #      #     # ### ####### ");
    end
  end
  endfunction

  //---------------------------------------------------------------------------
  // DUT instance
  //---------------------------------------------------------------------------

  ad463x_data_capture #(
    .DDR_EN (DDR_EN),
    .NUM_OF_LANES (NUM_OF_LANES))
  i_dut (
    .clk (clk),
    .csn (csn_clk),
    .echo_sclk (echo_sclk),
    .data_in (data_in),
    .m_axis_data (m_axis_data),
    .m_axis_valid (m_axis_valid),
    .m_axis_ready (m_axis_ready)
  );

endmodule
