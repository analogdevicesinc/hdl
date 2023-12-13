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

module axi_logic_analyzer_trigger (

  input                 clk,
  input                 reset,

  input       [15:0]    data,
  input                 data_valid,
  input       [ 1:0]    trigger_i,
  input                 trigger_in,

  input       [17:0]    edge_detect_enable,
  input       [17:0]    rise_edge_enable,
  input       [17:0]    fall_edge_enable,
  input       [17:0]    low_level_enable,
  input       [17:0]    high_level_enable,

  input       [ 6:0]    trigger_logic,

  output  reg           trigger_out,
  output  reg           trigger_out_adc
);

  reg     [  1:0]   ext_t_m = 'd0;
  reg     [  1:0]   ext_t_low_level_hold = 'd0;
  reg     [  1:0]   ext_t_high_level_hold = 'd0;
  reg     [  1:0]   ext_t_edge_detect_hold = 'd0;
  reg     [  1:0]   ext_t_rise_edge_hold = 'd0;
  reg     [  1:0]   ext_t_fall_edge_hold = 'd0;
  reg               ext_t_low_level_ack = 'd0;
  reg               ext_t_high_level_ack = 'd0;
  reg               ext_t_edge_detect_ack = 'd0;
  reg               ext_t_rise_edge_ack = 'd0;
  reg               ext_t_fall_edge_ack = 'd0;
  reg     [ 15:0]   data_m1 = 'd0;
  reg     [ 15:0]   low_level = 'd0;
  reg     [ 15:0]   high_level = 'd0;
  reg     [ 15:0]   edge_detect = 'd0;
  reg     [ 15:0]   rise_edge = 'd0;
  reg     [ 15:0]   fall_edge = 'd0;
  reg     [ 15:0]   low_level_m = 'd0;
  reg     [ 15:0]   high_level_m = 'd0;
  reg     [ 15:0]   edge_detect_m = 'd0;
  reg     [ 15:0]   rise_edge_m = 'd0;
  reg     [ 15:0]   fall_edge_m = 'd0;

  reg               trigger_active;
  reg               trigger_active_mux;
  reg               trigger_active_d1;

  always @(posedge clk) begin
    if (data_valid == 1'b1) begin
      trigger_active_d1 <= trigger_active_mux;
      trigger_out <= trigger_active_d1;
      trigger_out_adc <= trigger_active_mux;
    end
  end

  // trigger logic:
  // 0 OR
  // 1 AND

  always @(posedge clk) begin
    if (data_valid == 1'b1) begin
      case (trigger_logic[0])
        0: trigger_active = |(({ext_t_edge_detect_hold, edge_detect_m} & edge_detect_enable) |
                              ({ext_t_rise_edge_hold,   rise_edge_m}   & rise_edge_enable) |
                              ({ext_t_fall_edge_hold,   fall_edge_m}   & fall_edge_enable) |
                              ({ext_t_low_level_hold,   low_level_m}   & low_level_enable) |
                              ({ext_t_high_level_hold , high_level_m}  & high_level_enable));
        1: trigger_active = &(({ext_t_edge_detect_hold, edge_detect_m} | ~edge_detect_enable) &
                              ({ext_t_rise_edge_hold,   rise_edge_m}   | ~rise_edge_enable) &
                              ({ext_t_fall_edge_hold,   fall_edge_m}   | ~fall_edge_enable) &
                              ({ext_t_low_level_hold,   low_level_m}   | ~low_level_enable) &
                              ({ext_t_high_level_hold , high_level_m}  | ~high_level_enable));
        default: trigger_active = 1'b1;
      endcase
    end
  end

  always @(*) begin
    case (trigger_logic[6:4])
      3'd0: trigger_active_mux = trigger_active;
      3'd1: trigger_active_mux = trigger_in;
      3'd2: trigger_active_mux = trigger_active & trigger_in;
      3'd3: trigger_active_mux = trigger_active | trigger_in;
      3'd4: trigger_active_mux = trigger_active ^ trigger_in;
      3'd7: trigger_active_mux = 1'b0; // trigger disable
      default: trigger_active_mux = 1'b0;
    endcase
  end

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
        data_m1 <=  data;
        edge_detect <=  data_m1 ^ data;
        rise_edge   <= (data_m1 ^ data) & data;
        fall_edge   <= (data_m1 ^ data) & ~data;
        low_level   <= ~data;
        high_level  <= data;

        edge_detect_m <= edge_detect;
        rise_edge_m   <= rise_edge;
        fall_edge_m   <= fall_edge;
        low_level_m   <= low_level;
        high_level_m  <= high_level;
      end
    end
  end

  // external trigger detect

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      ext_t_m <= 'd0;
      ext_t_edge_detect_hold <= 'd0;
      ext_t_rise_edge_hold <= 'd0;
      ext_t_fall_edge_hold <= 'd0;
      ext_t_low_level_hold <= 'd0;
      ext_t_high_level_hold <= 'd0;
    end else begin
      ext_t_m <=  trigger_i;

      ext_t_edge_detect_hold <= ext_t_edge_detect_ack ? 2'b0 :
                                (ext_t_m ^ trigger_i) | ext_t_edge_detect_hold;
      ext_t_rise_edge_hold   <= ext_t_rise_edge_ack   ? 2'b0 :
                                ((ext_t_m ^ trigger_i) & trigger_i) | ext_t_rise_edge_hold;
      ext_t_fall_edge_hold   <= ext_t_fall_edge_ack   ? 2'b0 :
                                ((ext_t_m ^ trigger_i) & ~trigger_i) | ext_t_fall_edge_hold;
      ext_t_low_level_hold   <= ext_t_low_level_ack   ? 2'b0 :
                                (~trigger_i) | ext_t_low_level_hold;
      ext_t_high_level_hold  <= ext_t_high_level_ack  ? 2'b0 :
                                (trigger_i) | ext_t_high_level_hold;

      ext_t_edge_detect_ack <= data_valid & ( |ext_t_edge_detect_hold);
      ext_t_rise_edge_ack   <= data_valid & ( |ext_t_rise_edge_hold);
      ext_t_fall_edge_ack   <= data_valid & ( |ext_t_fall_edge_hold);
      ext_t_low_level_ack   <= data_valid & ( |ext_t_low_level_hold);
      ext_t_high_level_ack  <= data_valid & ( |ext_t_high_level_hold);
    end
  end

endmodule
