// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module up_clock_mon (

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  output  reg [31:0]      up_d_count,

  // device interface

  input                   d_rst,
  input                   d_clk);

  // internal registers

  reg     [15:0]  up_count = 'd1;
  reg             up_count_run = 'd0;
  reg             up_count_running_m1 = 'd0;
  reg             up_count_running_m2 = 'd0;
  reg             up_count_running_m3 = 'd0;
  reg             d_count_run_m1 = 'd0;
  reg             d_count_run_m2 = 'd0;
  reg             d_count_run_m3 = 'd0;
  reg     [32:0]  d_count = 'd0;

  // internal signals

  wire            up_count_capture_s;
  wire            d_count_reset_s;

  // processor reference

  // Capture on the falling edge of running
  assign up_count_capture_s = up_count_running_m3 == 1'b1 && up_count_running_m2 == 1'b0;

  always @(negedge up_rstn or posedge up_clk) begin
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

  always @(negedge up_rstn or posedge up_clk) begin
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
        up_d_count <= d_count;
      end else if (up_count == 'h00 && up_count_running_m3 == 1'b0) begin
        up_d_count <= 'h00;
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_count_run == 1'b0) begin
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
      if (d_count[32] == 1'b0) begin
        d_count <= d_count + 1'b1;
      end else begin
        d_count <= {33{1'b1}};
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
