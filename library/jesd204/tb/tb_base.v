// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2019, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

  reg clk = 1'b0;
  reg [3:0] reset_shift = 4'b1111;
  reg trigger_reset = 1'b0;
  wire reset;

  reg failed = 1'b0;

  reg sysref = 1'b0;

  initial
  begin
    $dumpfile (VCD_FILE);
    $dumpvars;
`ifdef TIMEOUT
    #`TIMEOUT
`else
    #100000
`endif
    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

  initial forever #10 clk <= ~clk;
  always @(posedge clk) begin
    if (trigger_reset == 1'b1) begin
      reset_shift <= 3'b111;
    end else begin
      reset_shift <= {reset_shift[2:0],1'b0};
    end
  end

  assign reset = reset_shift[3];

  initial begin
    #1000;
    @(posedge clk) sysref <= 1'b1;
    @(posedge clk) sysref <= 1'b0;
  end

  task do_trigger_reset;
  begin
    @(posedge clk) trigger_reset <= 1'b1;
    @(posedge clk) trigger_reset <= 1'b0;
  end
  endtask
