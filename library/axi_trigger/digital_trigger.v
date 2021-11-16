// ***************************************************************************
// ***************************************************************************
// Copyright 2021 (c) Analog Devices, Inc. All rights reserved.
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

module digital_trigger #(

  // parameters

  parameter  [ 9:0]  DW = 10'd16) (

  // IO signals

  input            clk,
  input            rst,

  input            selected,

  input  [DW-1:0]  current_data,
  input  [DW-1:0]  prev_data,

  // masks
  input  [DW-1:0]  edge_detect_enable,
  input  [DW-1:0]  rise_edge_enable,
  input  [DW-1:0]  fall_edge_enable,
  input  [DW-1:0]  low_level_enable,
  input  [DW-1:0]  high_level_enable,

  // condition for internal trigger
  // OR(0) / AND(1): the internal trigger condition
  input            trigger_int_cond,

  output           trigger_out
);

  // internal registers

  reg    [DW-1:0]  edge_detect = 'h0;
  reg    [DW-1:0]  rise_edge = 'h0;
  reg    [DW-1:0]  fall_edge = 'h0;
  reg    [DW-1:0]  low_level = 'h0;
  reg    [DW-1:0]  high_level = 'h0;

  reg    [DW-1:0]  edge_detect_m = 'h0;
  reg    [DW-1:0]  rise_edge_m = 'h0;
  reg    [DW-1:0]  fall_edge_m = 'h0;
  reg    [DW-1:0]  low_level_m = 'h0;
  reg    [DW-1:0]  high_level_m = 'h0;

  reg              int_trigger_active = 'h0;

  // assignments

  // signal name changes
  assign trigger_out = int_trigger_active;

  // detect transition
  always @ (posedge clk) begin
    if (rst == 1'b1) begin
      edge_detect <= 'b0;
      rise_edge   <= 'b0;
      fall_edge   <= 'b0;
      low_level   <= 'b0;
      high_level  <= 'b0;
    end else begin
      if (selected == 1'b1) begin
        edge_detect <=  prev_data ^ current_data;
        rise_edge   <= (prev_data ^ current_data) & current_data;
        fall_edge   <= (prev_data ^ current_data) & ~current_data;
        low_level   <= ~current_data;
        high_level  <=  current_data;

        edge_detect_m <= edge_detect;
        rise_edge_m   <= rise_edge;
        fall_edge_m   <= fall_edge;
        low_level_m   <= low_level;
        high_level_m  <= high_level;
      end
    end
  end

  // based on detected transitions, determine if internal trigger is active
  always @ (*) begin
    if (selected == 1'b1) begin
      case (trigger_int_cond)
        // OR
        0: int_trigger_active = |((edge_detect_m & edge_detect_enable) |
                                  (rise_edge_m   & rise_edge_enable) |
                                  (fall_edge_m   & fall_edge_enable) |
                                  (low_level_m   & low_level_enable) |
                                  (high_level_m  & high_level_enable));
        // AND
        1: int_trigger_active = &((edge_detect_m | ~edge_detect_enable) &
                                  (rise_edge_m   | ~rise_edge_enable) &
                                  (fall_edge_m   | ~fall_edge_enable) &
                                  (low_level_m   | ~low_level_enable) &
                                  (high_level_m  | ~high_level_enable));
      	default: int_trigger_active = 1'b0;
      endcase
    end
    else begin // if channel not selected
      int_trigger_active = 1'b0;
    end
  end
endmodule

// ***************************************************************************
// ***************************************************************************
