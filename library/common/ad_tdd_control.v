// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

module ad_tdd_control#(

  parameter   integer TX_DATA_PATH_DELAY = 0,
  parameter   integer CONTROL_PATH_DELAY = 0
) (

  // clock and reset

  input                   clk,
  input                   rst,

  // TDD timing signals

  input                   tdd_enable,
  input                   tdd_secondary,
  input                   tdd_tx_only,
  input                   tdd_rx_only,
  input       [ 7:0]      tdd_burst_count,
  input       [23:0]      tdd_counter_init,
  input       [23:0]      tdd_frame_length,
  input       [23:0]      tdd_vco_rx_on_1,
  input       [23:0]      tdd_vco_rx_off_1,
  input       [23:0]      tdd_vco_tx_on_1,
  input       [23:0]      tdd_vco_tx_off_1,
  input       [23:0]      tdd_rx_on_1,
  input       [23:0]      tdd_rx_off_1,
  input       [23:0]      tdd_rx_dp_on_1,
  input       [23:0]      tdd_rx_dp_off_1,
  input       [23:0]      tdd_tx_on_1,
  input       [23:0]      tdd_tx_off_1,
  input       [23:0]      tdd_tx_dp_on_1,
  input       [23:0]      tdd_tx_dp_off_1,
  input       [23:0]      tdd_vco_rx_on_2,
  input       [23:0]      tdd_vco_rx_off_2,
  input       [23:0]      tdd_vco_tx_on_2,
  input       [23:0]      tdd_vco_tx_off_2,
  input       [23:0]      tdd_rx_on_2,
  input       [23:0]      tdd_rx_off_2,
  input       [23:0]      tdd_rx_dp_on_2,
  input       [23:0]      tdd_rx_dp_off_2,
  input       [23:0]      tdd_tx_on_2,
  input       [23:0]      tdd_tx_off_2,
  input       [23:0]      tdd_tx_dp_on_2,
  input       [23:0]      tdd_tx_dp_off_2,
  input                   tdd_sync,

  // TDD control signals

  output  reg             tdd_tx_dp_en,
  output  reg             tdd_rx_dp_en,
  output  reg             tdd_rx_vco_en,
  output  reg             tdd_tx_vco_en,
  output  reg             tdd_rx_rf_en,
  output  reg             tdd_tx_rf_en,

  output      [23:0]      tdd_counter_status
);

  localparam  [ 0:0]      ON = 1;
  localparam  [ 0:0]      OFF = 0;

  // tdd control related

  // tdd counter related

  reg   [23:0]    tdd_counter = 24'h0;
  reg   [ 5:0]    tdd_burst_counter = 6'h0;

  reg             tdd_cstate = OFF;
  reg             tdd_cstate_next = OFF;

  reg             counter_at_tdd_vco_rx_on_1 = 1'b0;
  reg             counter_at_tdd_vco_rx_off_1 = 1'b0;
  reg             counter_at_tdd_vco_tx_on_1 = 1'b0;
  reg             counter_at_tdd_vco_tx_off_1 = 1'b0;
  reg             counter_at_tdd_rx_on_1 = 1'b0;
  reg             counter_at_tdd_rx_off_1 = 1'b0;
  reg             counter_at_tdd_rx_dp_on_1 = 1'b0;
  reg             counter_at_tdd_rx_dp_off_1 = 1'b0;
  reg             counter_at_tdd_tx_on_1 = 1'b0;
  reg             counter_at_tdd_tx_off_1 = 1'b0;
  reg             counter_at_tdd_tx_dp_on_1 = 1'b0;
  reg             counter_at_tdd_tx_dp_off_1 = 1'b0;
  reg             counter_at_tdd_vco_rx_on_2 = 1'b0;
  reg             counter_at_tdd_vco_rx_off_2 = 1'b0;
  reg             counter_at_tdd_vco_tx_on_2 = 1'b0;
  reg             counter_at_tdd_vco_tx_off_2 = 1'b0;
  reg             counter_at_tdd_rx_on_2 = 1'b0;
  reg             counter_at_tdd_rx_off_2 = 1'b0;
  reg             counter_at_tdd_rx_dp_on_2 = 1'b0;
  reg             counter_at_tdd_rx_dp_off_2 = 1'b0;
  reg             counter_at_tdd_tx_on_2 = 1'b0;
  reg             counter_at_tdd_tx_off_2 = 1'b0;
  reg             counter_at_tdd_tx_dp_on_2 = 1'b0;
  reg             counter_at_tdd_tx_dp_off_2 = 1'b0;

  reg             tdd_last_burst = 1'b0;

  reg             tdd_sync_d1 = 1'b0;
  reg             tdd_sync_d2 = 1'b0;
  reg             tdd_sync_d3 = 1'b0;

  reg             tdd_endof_frame = 1'b0;

  // internal signals

  wire   [23:0]   tdd_vco_rx_on_1_s;
  wire   [23:0]   tdd_vco_rx_off_1_s;
  wire   [23:0]   tdd_vco_tx_on_1_s;
  wire   [23:0]   tdd_vco_tx_off_1_s;
  wire   [23:0]   tdd_rx_on_1_s;
  wire   [23:0]   tdd_rx_off_1_s;
  wire   [23:0]   tdd_tx_on_1_s;
  wire   [23:0]   tdd_tx_off_1_s;
  wire   [23:0]   tdd_tx_dp_on_1_s;
  wire   [23:0]   tdd_tx_dp_off_1_s;

  wire   [23:0]   tdd_vco_rx_on_2_s;
  wire   [23:0]   tdd_vco_rx_off_2_s;
  wire   [23:0]   tdd_vco_tx_on_2_s;
  wire   [23:0]   tdd_vco_tx_off_2_s;
  wire   [23:0]   tdd_rx_on_2_s;
  wire   [23:0]   tdd_rx_off_2_s;
  wire   [23:0]   tdd_tx_on_2_s;
  wire   [23:0]   tdd_tx_off_2_s;
  wire   [23:0]   tdd_tx_dp_on_2_s;
  wire   [23:0]   tdd_tx_dp_off_2_s;
  wire            tdd_endof_burst;
  wire            tdd_txrx_only_en_s;

  assign  tdd_counter_status = tdd_counter;

  // synchronization of tdd_sync
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      tdd_sync_d1 <= 1'b0;
      tdd_sync_d2 <= 1'b0;
      tdd_sync_d3 <= 1'b0;
    end else begin
      tdd_sync_d1 <= tdd_sync;
      tdd_sync_d2 <= tdd_sync_d1;
      tdd_sync_d3 <= tdd_sync_d2;
    end
  end

  // ***************************************************************************
  // tdd counter (state machine)
  // ***************************************************************************

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      tdd_cstate <= OFF;
    end else begin
      tdd_cstate <= tdd_cstate_next;
    end
  end

  always @* begin
    tdd_cstate_next <= tdd_cstate;

    case (tdd_cstate)
      ON : begin
        if ((tdd_enable == 1'b0) || (tdd_endof_burst == 1'b1)) begin
          tdd_cstate_next <= OFF;
        end
      end

      OFF : begin
        if(tdd_enable == 1'b1) begin
          tdd_cstate_next <= ((~tdd_sync_d3 & tdd_sync_d2) == 1'b1) ? ON : OFF;
        end
      end
    endcase
  end

  always @(posedge clk) begin
    if (tdd_counter == (tdd_frame_length - 1'b1)) begin
      tdd_endof_frame <= 1'b1;
    end else begin
      tdd_endof_frame <= 1'b0;
    end
  end
  assign tdd_endof_burst = ((tdd_last_burst == 1'b1) && (tdd_endof_frame == 1'b1)) ? 1'b1 : 1'b0;

  // tdd free running counter
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      tdd_counter <= tdd_counter_init;
    end else begin
      if (tdd_cstate == ON) begin
        if ((~tdd_sync_d3 & tdd_sync_d2) == 1'b1) begin
          tdd_counter <= 24'b0;
        end else begin
          tdd_counter <= (tdd_endof_frame == 1'b1) ? 24'b0 : tdd_counter + 1'b1;
        end
      end else begin
        tdd_counter <= tdd_counter_init;
      end
    end
  end

  // tdd burst counter
  always @(posedge clk) begin
    if (tdd_cstate == OFF) begin
      tdd_burst_counter <= tdd_burst_count;
    end else if ((tdd_burst_counter != 0) && (tdd_endof_frame == 1'b1)) begin
      tdd_burst_counter <= tdd_burst_counter - 1'b1;
    end
  end

  always @(posedge clk) begin
    tdd_last_burst <= (tdd_burst_counter == 6'b1) ? 1'b1 : 1'b0;
  end

  // ***************************************************************************
  // generate control signals
  // ***************************************************************************

  // start/stop rx vco
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_rx_on_1 <= 1'b0;
    end else if(tdd_counter == tdd_vco_rx_on_1_s) begin
      counter_at_tdd_vco_rx_on_1 <= 1'b1;
    end else begin
      counter_at_tdd_vco_rx_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_rx_on_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_vco_rx_on_2_s)) begin
      counter_at_tdd_vco_rx_on_2 <= 1'b1;
    end else begin
      counter_at_tdd_vco_rx_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_rx_off_1 <= 1'b0;
    end else if(tdd_counter == tdd_vco_rx_off_1_s) begin
      counter_at_tdd_vco_rx_off_1 <= 1'b1;
    end else begin
      counter_at_tdd_vco_rx_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_rx_off_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_vco_rx_off_2_s)) begin
      counter_at_tdd_vco_rx_off_2 <= 1'b1;
    end else begin
      counter_at_tdd_vco_rx_off_2 <= 1'b0;
    end
  end

  // start/stop tx vco
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_tx_on_1 <= 1'b0;
    end else if(tdd_counter == tdd_vco_tx_on_1_s) begin
      counter_at_tdd_vco_tx_on_1 <= 1'b1;
    end else begin
      counter_at_tdd_vco_tx_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_tx_on_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_vco_tx_on_2_s)) begin
      counter_at_tdd_vco_tx_on_2 <= 1'b1;
    end else begin
      counter_at_tdd_vco_tx_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_tx_off_1 <= 1'b0;
    end else if(tdd_counter == tdd_vco_tx_off_1_s) begin
      counter_at_tdd_vco_tx_off_1 <= 1'b1;
    end else begin
      counter_at_tdd_vco_tx_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_tx_off_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_vco_tx_off_2_s)) begin
      counter_at_tdd_vco_tx_off_2 <= 1'b1;
    end else begin
      counter_at_tdd_vco_tx_off_2 <= 1'b0;
    end
  end

  // start/stop rx rf path
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_on_1 <= 1'b0;
    end else if(tdd_counter == tdd_rx_on_1_s) begin
      counter_at_tdd_rx_on_1 <= 1'b1;
    end else begin
      counter_at_tdd_rx_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_on_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_rx_on_2_s)) begin
      counter_at_tdd_rx_on_2 <= 1'b1;
    end else begin
      counter_at_tdd_rx_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_off_1 <= 1'b0;
    end else if(tdd_counter == tdd_rx_off_1_s) begin
      counter_at_tdd_rx_off_1 <= 1'b1;
    end else begin
      counter_at_tdd_rx_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_off_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_rx_off_2_s)) begin
      counter_at_tdd_rx_off_2 <= 1'b1;
    end else begin
      counter_at_tdd_rx_off_2 <= 1'b0;
    end
  end

  // start/stop tx rf path
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_on_1 <= 1'b0;
    end else if(tdd_counter == tdd_tx_on_1_s) begin
      counter_at_tdd_tx_on_1 <= 1'b1;
    end else begin
      counter_at_tdd_tx_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_on_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_tx_on_2_s)) begin
      counter_at_tdd_tx_on_2 <= 1'b1;
    end else begin
      counter_at_tdd_tx_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_off_1 <= 1'b0;
    end else if(tdd_counter == tdd_tx_off_1_s) begin
      counter_at_tdd_tx_off_1 <= 1'b1;
    end else begin
      counter_at_tdd_tx_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_off_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_tx_off_2_s)) begin
      counter_at_tdd_tx_off_2 <= 1'b1;
    end else begin
      counter_at_tdd_tx_off_2 <= 1'b0;
    end
  end

  // start/stop tx data path
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_dp_on_1 <= 1'b0;
    end else if(tdd_counter == tdd_tx_dp_on_1_s) begin
      counter_at_tdd_tx_dp_on_1 <= 1'b1;
    end else begin
      counter_at_tdd_tx_dp_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_dp_on_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_tx_dp_on_2_s)) begin
      counter_at_tdd_tx_dp_on_2 <= 1'b1;
    end else begin
      counter_at_tdd_tx_dp_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_dp_off_1 <= 1'b0;
    end else if(tdd_counter == tdd_tx_dp_off_1_s) begin
      counter_at_tdd_tx_dp_off_1 <= 1'b1;
    end else begin
      counter_at_tdd_tx_dp_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_dp_off_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_tx_dp_off_2_s)) begin
      counter_at_tdd_tx_dp_off_2 <= 1'b1;
    end else begin
      counter_at_tdd_tx_dp_off_2 <= 1'b0;
    end
  end

  // start/stop rx data path
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_dp_on_1 <= 1'b0;
    end else if(tdd_counter == tdd_rx_dp_on_1) begin
      counter_at_tdd_rx_dp_on_1 <= 1'b1;
    end else begin
      counter_at_tdd_rx_dp_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_dp_on_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_rx_dp_on_2)) begin
      counter_at_tdd_rx_dp_on_2 <= 1'b1;
    end else begin
      counter_at_tdd_rx_dp_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_dp_off_1 <= 1'b0;
    end else if(tdd_counter == tdd_rx_dp_off_1) begin
      counter_at_tdd_rx_dp_off_1 <= 1'b1;
    end else begin
      counter_at_tdd_rx_dp_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_dp_off_2 <= 1'b0;
    end else if((tdd_secondary == 1'b1) && (tdd_counter == tdd_rx_dp_off_2)) begin
      counter_at_tdd_rx_dp_off_2 <= 1'b1;
    end else begin
      counter_at_tdd_rx_dp_off_2 <= 1'b0;
    end
  end

  // control-path delay compensation

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_vco_rx_on_1_comp (
    .clk(clk),
    .A(tdd_vco_rx_on_1),
    .Amax(tdd_frame_length),
    .out(tdd_vco_rx_on_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_vco_rx_off_1_comp (
    .clk(clk),
    .A(tdd_vco_rx_off_1),
    .Amax(tdd_frame_length),
    .out(tdd_vco_rx_off_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_vco_tx_on_1_comp (
    .clk(clk),
    .A(tdd_vco_tx_on_1),
    .Amax(tdd_frame_length),
    .out(tdd_vco_tx_on_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_vco_tx_off_1_comp (
    .clk(clk),
    .A(tdd_vco_tx_off_1),
    .Amax(tdd_frame_length),
    .out(tdd_vco_tx_off_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_rx_on_1_comp (
    .clk(clk),
    .A(tdd_rx_on_1),
    .Amax(tdd_frame_length),
    .out(tdd_rx_on_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_rx_off_1_comp (
    .clk(clk),
    .A(tdd_rx_off_1),
    .Amax(tdd_frame_length),
    .out(tdd_rx_off_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_tx_on_1_comp (
    .clk(clk),
    .A(tdd_tx_on_1),
    .Amax(tdd_frame_length),
    .out(tdd_tx_on_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_tx_off_1_comp (
    .clk(clk),
    .A(tdd_tx_off_1),
    .Amax(tdd_frame_length),
    .out(tdd_tx_off_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_vco_rx_on_2_comp (
    .clk(clk),
    .A(tdd_vco_rx_on_2),
    .Amax(tdd_frame_length),
    .out(tdd_vco_rx_on_2_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_vco_rx_off_2_comp (
    .clk(clk),
    .A(tdd_vco_rx_off_2),
    .Amax(tdd_frame_length),
    .out(tdd_vco_rx_off_2_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_vco_tx_on_2_comp (
    .clk(clk),
    .A(tdd_vco_tx_on_2),
    .Amax(tdd_frame_length),
    .out(tdd_vco_tx_on_2_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_vco_tx_off_2_comp (
    .clk(clk),
    .A(tdd_vco_tx_off_2),
    .Amax(tdd_frame_length),
    .out(tdd_vco_tx_off_2_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_rx_on_2_comp (
    .clk(clk),
    .A(tdd_rx_on_2),
    .Amax(tdd_frame_length),
    .out(tdd_rx_on_2_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_rx_off_2_comp (
    .clk(clk),
    .A(tdd_rx_off_2),
    .Amax(tdd_frame_length),
    .out(tdd_rx_off_2_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_tx_on_2_comp (
    .clk(clk),
    .A(tdd_tx_on_2),
    .Amax(tdd_frame_length),
    .out(tdd_tx_on_2_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(CONTROL_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_tx_off_2_comp (
    .clk(clk),
    .A(tdd_tx_off_2),
    .Amax(tdd_frame_length),
    .out(tdd_tx_off_2_s),
    .CE(1'b1));

  // internal data-path delay compensation

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(TX_DATA_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_tx_dp_on_1_comp (
    .clk(clk),
    .A(tdd_tx_dp_on_1),
    .Amax(tdd_frame_length),
    .out(tdd_tx_dp_on_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(TX_DATA_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_tx_dp_on_2_comp (
    .clk(clk),
    .A(tdd_tx_dp_on_2),
    .Amax(tdd_frame_length),
    .out(tdd_tx_dp_on_2_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(TX_DATA_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_tx_dp_off_1_comp (
    .clk(clk),
    .A(tdd_tx_dp_off_1),
    .Amax(tdd_frame_length),
    .out(tdd_tx_dp_off_1_s),
    .CE(1'b1));

  ad_addsub #(
    .A_DATA_WIDTH(24),
    .B_DATA_VALUE(TX_DATA_PATH_DELAY),
    .ADD_OR_SUB_N(0)
  ) i_tx_dp_off_2_comp (
    .clk(clk),
    .A(tdd_tx_dp_off_2),
    .Amax(tdd_frame_length),
    .out(tdd_tx_dp_off_2_s),
    .CE(1'b1));

  // output logic

  assign tdd_txrx_only_en_s = tdd_tx_only ^ tdd_rx_only;

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_rx_vco_en <= 1'b0;
    end else if((tdd_cstate == OFF) || (counter_at_tdd_vco_rx_off_1 == 1'b1) || (counter_at_tdd_vco_rx_off_2 == 1'b1)) begin
      tdd_rx_vco_en <= 1'b0;
    end else if((tdd_cstate == ON) && ((counter_at_tdd_vco_rx_on_1 == 1'b1) || (counter_at_tdd_vco_rx_on_2 == 1'b1))) begin
      tdd_rx_vco_en <= 1'b1;
    end else if((tdd_cstate == ON) && (tdd_txrx_only_en_s == 1'b1)) begin
      tdd_rx_vco_en <= tdd_rx_only;
    end else begin
      tdd_rx_vco_en <= tdd_rx_vco_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_tx_vco_en <= 1'b0;
    end else if((tdd_cstate == OFF) || (counter_at_tdd_vco_tx_off_1 == 1'b1) || (counter_at_tdd_vco_tx_off_2 == 1'b1)) begin
      tdd_tx_vco_en <= 1'b0;
    end else if((tdd_cstate == ON) && ((counter_at_tdd_vco_tx_on_1 == 1'b1) || (counter_at_tdd_vco_tx_on_2 == 1'b1))) begin
      tdd_tx_vco_en <= 1'b1;
    end else if((tdd_cstate == ON) && (tdd_txrx_only_en_s == 1'b1)) begin
      tdd_tx_vco_en <= tdd_tx_only;
    end else begin
      tdd_tx_vco_en <= tdd_tx_vco_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_rx_rf_en <= 1'b0;
    end else if((tdd_cstate == OFF) || (counter_at_tdd_rx_off_1 == 1'b1) || (counter_at_tdd_rx_off_2 == 1'b1)) begin
      tdd_rx_rf_en <= 1'b0;
    end else if((tdd_cstate == ON) && (tdd_tx_only == 1'b1)) begin
      tdd_rx_rf_en <= 1'b0;
    end else if((tdd_cstate == ON) && ((counter_at_tdd_rx_on_1 == 1'b1) || (counter_at_tdd_rx_on_2 == 1'b1))) begin
      tdd_rx_rf_en <= 1'b1;
    end else begin
      tdd_rx_rf_en <= tdd_rx_rf_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_tx_rf_en <= 1'b0;
    end else if((tdd_cstate == OFF) || (counter_at_tdd_tx_off_1 == 1'b1) || (counter_at_tdd_tx_off_2 == 1'b1)) begin
      tdd_tx_rf_en <= 1'b0;
    end else if((tdd_cstate == ON) && (tdd_rx_only == 1'b1)) begin
      tdd_tx_rf_en <= 1'b0;
    end else if((tdd_cstate == ON) && ((counter_at_tdd_tx_on_1 == 1'b1) || (counter_at_tdd_tx_on_2 == 1'b1))) begin
      tdd_tx_rf_en <= 1'b1;
    end else begin
      tdd_tx_rf_en <= tdd_tx_rf_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_tx_dp_en <= 1'b0;
    end else if((tdd_cstate == OFF) || (counter_at_tdd_tx_dp_off_1 == 1'b1) || (counter_at_tdd_tx_dp_off_2 == 1'b1)) begin
      tdd_tx_dp_en <= 1'b0;
    end else if((tdd_cstate == ON) && (tdd_rx_only == 1'b1)) begin
      tdd_tx_dp_en <= 1'b0;
    end else if((tdd_cstate == ON) && ((counter_at_tdd_tx_dp_on_1 == 1'b1) || (counter_at_tdd_tx_dp_on_2 == 1'b1))) begin
      tdd_tx_dp_en <= 1'b1;
    end else begin
      tdd_tx_dp_en <= tdd_tx_dp_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_rx_dp_en <= 1'b0;
    end else if((tdd_cstate == OFF) || (counter_at_tdd_rx_dp_off_1 == 1'b1) || (counter_at_tdd_rx_dp_off_2 == 1'b1)) begin
      tdd_rx_dp_en <= 1'b0;
    end else if((tdd_cstate == ON) && (tdd_tx_only == 1'b1)) begin
      tdd_rx_dp_en <= 1'b0;
    end else if((tdd_cstate == ON) && ((counter_at_tdd_rx_dp_on_1 == 1'b1) || (counter_at_tdd_rx_dp_on_2 == 1'b1))) begin
      tdd_rx_dp_en <= 1'b1;
    end else begin
      tdd_rx_dp_en <= tdd_rx_dp_en;
    end
  end

endmodule
