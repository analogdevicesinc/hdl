// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module up_clock_mon #(
  parameter TOTAL_WIDTH = 32
) (

  // processor interface

  input                              up_rstn,
  input                              up_clk,
  output  reg [TOTAL_WIDTH-1:0]      up_d_count,

  // device interface

  input                              d_rst,
  input                              d_clk
);

  // internal registers

  reg     [15:0]           up_count = 'd1;
  reg                      up_count_run = 'd0;
  reg                      up_count_running_m1 = 'd0;
  reg                      up_count_running_m2 = 'd0;
  reg                      up_count_running_m3 = 'd0;
  reg                      d_count_run_m1 = 'd0;
  reg                      d_count_run_m2 = 'd0;
  reg                      d_count_run_m3 = 'd0;
  reg     [TOTAL_WIDTH:0]  d_count = 'd0;

  // internal signals

  wire                     up_count_capture_s;
  wire                     d_count_reset_s;

  // processor reference

  // Capture on the falling edge of running
  assign up_count_capture_s = up_count_running_m3 == 1'b1 && up_count_running_m2 == 1'b0;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_count_running_m1 <= 1'b0;
      up_count_running_m2 <= 1'b0;
      up_count_running_m3 <= 1'b0;
    end else begin
      up_count_running_m1 <= d_count_run_m3;
      up_count_running_m2 <= up_count_running_m1;
      up_count_running_m3 <= up_count_running_m2;
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_d_count <= 'd0;
      up_count_run <= 1'b0;
    end else begin
      if (up_count_running_m3 == 1'b0) begin
        up_count_run <= 1'b1;
      end else if (up_count == 'h00) begin
        up_count_run <= 1'b0;
      end

      if (up_count_capture_s == 1'b1) begin
        up_d_count <= d_count[TOTAL_WIDTH-1:0];
      end else if (up_count == 'h00 && up_count_run != up_count_running_m3) begin
        up_d_count <= 'h00;
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_count_run == 1'b0 && up_count_running_m3 == 1'b0) begin
      up_count <= 'h01;
    end else begin
      up_count <= up_count + 1'b1;
    end
  end

  // device free running

  // Reset on the rising edge of run
  assign d_count_reset_s = d_count_run_m3 == 1'b0 && d_count_run_m2 == 1'b1;

  always @(posedge d_clk or posedge d_rst) begin
    if (d_rst == 1'b1) begin
      d_count_run_m1 <= 1'b0;
      d_count_run_m2 <= 1'b0;
      d_count_run_m3 <= 1'b0;
    end else begin
      d_count_run_m1 <= up_count_run;
      d_count_run_m2 <= d_count_run_m1;
      d_count_run_m3 <= d_count_run_m2;
    end
  end

  always @(posedge d_clk) begin
    if (d_count_reset_s == 1'b1) begin
      d_count <= 'h00;
    end else if (d_count_run_m3 == 1'b1) begin
      if (d_count[TOTAL_WIDTH] == 1'b0) begin
        d_count <= d_count + 1'b1;
      end else begin
        d_count <= {TOTAL_WIDTH+1{1'b1}};
      end
    end
  end

endmodule
