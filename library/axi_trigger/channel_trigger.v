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

module channel_trigger #(

  // parameters

  parameter  [ 9:0]  DW = 10'd16,
  parameter          CHANNEL_TRIGGER = 0) (

  // IO ports

  input              clk,
  input              rst,

  input              selected,

  input  [DW-1:0]  current_data,
  input  [DW-1:0]  limit,

  input  [  31:0]    hysteresis,

  // masks
  input  [DW-1:0]  edge_detect_enable,
  input  [DW-1:0]  rise_edge_enable,
  input  [DW-1:0]  fall_edge_enable,
  input  [DW-1:0]  low_level_enable,
  input  [DW-1:0]  high_level_enable,

  // condition for internal trigger
  // OR(0) / AND(1): the internal trigger condition
  input              trigger_int_cond,

  // condition for the internal analog triggering;
  // comparison between the probe and the limit
  // 0 - lower than the limit
  // 1 - higher than the limit
  // 2 - passing through high limit
  // 3 - passing through low limit
  input    [ 1:0]    trigger_adc_rel,

  // type of triggering to be applied on input
  // 0 - analog triggering
  // 1 - digital triggering
  // 2 - disable
  input    [  1:0]  trigger_type,

  output             trigger_out
);

  // local parameters

  localparam DIGITAL_TRIGGER = 1;
  localparam ANALOG_TRIGGER = 0;

  // internal wires

  wire               trigger_out_adc;
  wire               trigger_out_dig;

  // internal registers

  reg    [DW-1 : 0]  prev_data = 'h0;

  reg                int_trigger_active = 'h0;
  reg                trigger_out_int = 'h0;

  // assignments

  // signal name changes
  assign trigger_out = trigger_out_int;

  // delay signals
  always @ (posedge clk) begin
    if (rst == 1'b1) begin
      prev_data <= 'b0;
    end else begin
      if (selected == 1'b1) begin
        prev_data <= current_data;
      end
    end
  end

  // choose if analog or digital trigger
  always @ (*) begin
    case (trigger_type)
      1'd0: trigger_out_int = trigger_out_adc;
      1'd1: trigger_out_int = trigger_out_dig;
      default: trigger_out_int = 1'b0; // disable
    endcase
  end

  generate
    if (CHANNEL_TRIGGER == DIGITAL_TRIGGER) begin
      // digital trigger
      digital_trigger #(
        .DW (DW)
      ) digital_data_triggering (
        .clk (clk),
        .rst (rst),
        .current_data (current_data),
        .prev_data(prev_data),
        .selected (selected),
        .edge_detect_enable (edge_detect_enable),
        .rise_edge_enable (rise_edge_enable),
        .fall_edge_enable (fall_edge_enable),
        .low_level_enable (low_level_enable),
        .high_level_enable (high_level_enable),
        .trigger_int_cond (trigger_int_cond),
        .trigger_out (trigger_out_dig)
      );
    end
    if (CHANNEL_TRIGGER == ANALOG_TRIGGER) begin
      // adc trigger
      adc_trigger #(
        .DW (DW)
      ) analog_data_triggering (
        .clk (clk),
        .rst (rst),
        .data (current_data),
        .limit (limit),
        .hysteresis (hysteresis),
        .selected (selected),
        .trigger_adc_rel (trigger_adc_rel),
        .trigger_out (trigger_out_adc)
      );
    end
  endgenerate

  //
  my_ila i_ila (
    .clk(clk),
    .probe0(selected),
    .probe1(trigger_out_adc),
    .probe2(current_data),
    .probe3(limit));
  //

endmodule

// ***************************************************************************
// ***************************************************************************
