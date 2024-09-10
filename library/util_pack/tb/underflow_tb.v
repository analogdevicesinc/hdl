// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

module underflow_tb;
  parameter VCD_FILE = {"underflow_tb.vcd"};
  parameter NUM_OF_CHANNELS = 8;
  parameter SAMPLES_PER_CHANNEL = 4;

  `include "tb_base.v"

  initial
  begin
    #1500000
    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

  localparam NUM_OF_PORTS = SAMPLES_PER_CHANNEL * NUM_OF_CHANNELS;

  reg fifo_rd_en = 1'b1;
  wire [NUM_OF_PORTS*8-1:0] fifo_rd_data;
  wire fifo_rd_valid;
  wire fifo_rd_underflow;

  reg s_axis_valid = 1'b1;
  wire s_axis_ready;
  reg [NUM_OF_PORTS*8-1:0] s_axis_data = {NUM_OF_PORTS*8{1'b1}};

  reg [NUM_OF_CHANNELS-1:0] enable = {NUM_OF_CHANNELS{1'b1}};
  integer counter = 0;

  always @(posedge clk) begin
    if (fifo_rd_underflow == 1'b1 && fifo_rd_data != 'h00) begin
      failed <= 1'b1;
    end
    if (fifo_rd_valid == 1'b1 && fifo_rd_data != {NUM_OF_PORTS*8{1'b1}}) begin
      failed <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      counter <= 0;
      s_axis_valid <= 1'b1;
    end else begin
      if (s_axis_valid == 1'b0) begin
        if (counter == 8) begin
          s_axis_valid <= 1'b1;
        end
        counter <= counter + 1;
      end else if (s_axis_ready == 1'b1) begin
        s_axis_valid <= 1'b0;
        counter <= 0;
      end
    end
  end

  always @(posedge clk) begin
    fifo_rd_en <= $random & 1;
  end

  util_upack2_impl #(
    .NUM_OF_CHANNELS(NUM_OF_CHANNELS),
    .SAMPLES_PER_CHANNEL(SAMPLES_PER_CHANNEL),
    .SAMPLE_DATA_WIDTH(8)
  ) i_unpack (
    .clk(clk),
    .reset(reset),

    .enable(enable),

    .fifo_rd_en({NUM_OF_CHANNELS{fifo_rd_en}}),
    .fifo_rd_data(fifo_rd_data),
    .fifo_rd_valid(fifo_rd_valid),
    .fifo_rd_underflow(fifo_rd_underflow),

    .s_axis_valid(s_axis_valid),
    .s_axis_ready(s_axis_ready),
    .s_axis_data(s_axis_data));

endmodule
