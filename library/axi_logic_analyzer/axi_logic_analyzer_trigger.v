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

module axi_logic_analyzer_trigger (

  input                 clk,
  input                 reset,

  input       [15:0]    data,
  input                 data_valid,
  input       [ 1:0]    trigger,

  input       [17:0]    edge_detect_enable,
  input       [17:0]    rise_edge_enable,
  input       [17:0]    fall_edge_enable,
  input       [17:0]    low_level_enable,
  input       [17:0]    high_level_enable,

  input                 trigger_logic,

  output  reg           trigger_out);

  reg     [ 17:0]   data_m1 = 'd0;
  reg     [ 17:0]   low_level = 'd0;
  reg     [ 17:0]   high_level = 'd0;
  reg     [ 17:0]   edge_detect = 'd0;
  reg     [ 17:0]   rise_edge = 'd0;
  reg     [ 17:0]   fall_edge = 'd0;
  reg     [ 31:0]   delay_count = 'd0;

  reg              trigger_active;
  reg              trigger_active_d1;
  reg              trigger_active_d2;

  always @(posedge clk) begin
    if (data_valid == 1'b1) begin
      trigger_active_d1 <= trigger_active;
      trigger_active_d2 <= trigger_active_d1;
      trigger_out <= trigger_active_d2;
    end
  end

  // trigger logic:
  // 0 OR
  // 1 AND

  always @(*) begin
    case (trigger_logic)
      0: trigger_active = |((edge_detect & edge_detect_enable) |
                            (rise_edge & rise_edge_enable) |
                            (fall_edge & fall_edge_enable) |
                            (low_level & low_level_enable) |
                            (high_level & high_level_enable));
      1: trigger_active = &((edge_detect | ~edge_detect_enable) &
                            (rise_edge | ~rise_edge_enable) &
                            (fall_edge | ~fall_edge_enable) &
                            (low_level | ~low_level_enable) &
                            (high_level | ~high_level_enable));
      default: trigger_active = 1'b1;
    endcase
  end

  // internal signals

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_m1 <= 'd0;
      edge_detect <= 'd0;
      rise_edge <= 'd0;
      fall_edge <= 'd0;
      low_level <= 'd0;
      high_level <= 'd0;
    end else begin
      if (data_valid == 1'b1) begin
        data_m1 <= {trigger, data} ;
        edge_detect <= data_m1 ^ {trigger, data};
        rise_edge <= (data_m1 ^ {trigger, data} ) & {trigger, data};
        fall_edge <= (data_m1 ^ {trigger, data}) & ~{trigger, data};
        low_level <= ~{trigger, data};
        high_level <= {trigger, data};
      end
    end
  end


endmodule

// ***************************************************************************
// ***************************************************************************
