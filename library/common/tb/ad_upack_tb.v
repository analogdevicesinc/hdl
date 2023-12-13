// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module ad_upack_tb;
  parameter VCD_FILE = "ad_upack_tb.vcd";

  parameter I_W = 6;   // Width of input channel
  parameter O_W = 4;   // Width of output channel
  parameter UNIT_W = 8;
  parameter VECT_W = 1024*8;  // Multiple of 8

  `include "tb_base.v"

  reg [I_W*UNIT_W-1 : 0]  idata;
  wire [O_W*UNIT_W-1 : 0] odata;
  reg                     ivalid = 'b0;
  reg [VECT_W-1:0] input_vector;
  reg [VECT_W-1:0] output_vector;

  integer i=0;
  integer j=0;

  ad_upack #(
    .I_W(I_W),
    .O_W(O_W),
    .UNIT_W(UNIT_W)
  ) DUT (
    .clk(clk),
    .reset(reset),
    .idata(idata),
    .iready(iready),
    .ivalid(ivalid),
    .odata(odata),
    .ovalid(ovalid));

  task test(input no_random);
  begin
    @(posedge clk);
    i = 0;
    j = 0;
    while (i < VECT_W/(I_W*UNIT_W)) begin
      @(posedge clk);
      if (iready & (($urandom % 2 == 0) | no_random)) begin
        idata <= input_vector[i*(I_W*UNIT_W) +: (I_W*UNIT_W)];
        ivalid <= 1'b1;
        i = i + 1;
      end else begin
        idata <= 'bx;
        ivalid <= 1'b0;
      end
    end
    @(posedge clk);
    idata <= 'bx;
    ivalid <= 1'b0;

    // Check output vector
    repeat (20) @(posedge clk);
    for (i=0; i<(((VECT_W/(I_W*UNIT_W))*(I_W*UNIT_W))/(O_W*UNIT_W))*(O_W*UNIT_W)/8; i=i+1) begin
      if (input_vector[i*8+:8] !== output_vector[i*8+:8]) begin
        failed <= 1'b1;
        $display("i=%d Expected=%x Found=%x",i,input_vector[i*8+:8],output_vector[i*8+:8]);
      end
    end
  end
  endtask

  initial begin

    @(negedge reset);

    // Test with incremental data
    for (i=0; i<VECT_W/8; i=i+1) begin
      input_vector[i*8+:8] = i[7:0];
      output_vector[i*8+:8] = 'bx;
    end

    test(1);

    do_trigger_reset();
    @(negedge reset);

    // Test with incremental data random timing
    for (i=0; i<VECT_W/8; i=i+1) begin
      input_vector[i*8+:8] = i[7:0];
      output_vector[i*8+:8] = 'bx;
    end

    test(0);

    do_trigger_reset();
    @(negedge reset);

    // Test with randomized data random timing
    for (i=0; i<VECT_W/8; i=i+1) begin
      input_vector[i*8+:8] = $urandom;
    end

    test(0);

  end

  always @(posedge clk) begin
    if (ovalid) begin
      if (j < VECT_W/(O_W*UNIT_W)) begin
        output_vector[j*(O_W*UNIT_W) +: (O_W*UNIT_W)] = odata;
        j = j + 1;
      end
    end
  end

endmodule
