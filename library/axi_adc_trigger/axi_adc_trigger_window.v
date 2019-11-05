// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2019 (c) Analog Devices, Inc. All rights reserved.
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
//      of this repository (LICENSE_GPl2), and also online at:
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

module axi_adc_trigger_window #(

  // parameters

  parameter SIGN_BITS = 2) (

  // interface

  input                 clk,

  input       [15:0]    data_a,
  input       [15:0]    data_b,
  input                 data_valid_a,
  input                 data_valid_b,

  input       [15:0]    limit_l1,
  input       [15:0]    limit_l2,
  input       [15:0]    hysteresis_l1,
  input       [15:0]    hysteresis_l2,

  input       [15:0]    cnt_start,
  input       [15:0]    cnt_stop,

  input       [11:0]    window_trigger_config,

  input       [31:0]    window_limit1,
  input       [31:0]    window_limit2,

  output      [31:0]    read_window_cnt,
  output reg            trigger_out
  );

  localparam DW = 15 - SIGN_BITS;

  // internal signals

  wire         [ 0:0]   mux_sel_l1_data;
  wire         [ 0:0]   mux_sel_l2_data;
  wire         [ 1:0]   function_l1;
  wire         [ 1:0]   function_l2;
  wire         [ 1:0]   window_cnt_function;

  wire signed  [DW:0]   data_l1_cmp;
  wire signed  [DW:0]   data_l2_cmp;
  wire signed  [DW:0]   limit_l1_cmp;
  wire signed  [DW:0]   limit_l2_cmp;

  wire                  comp_low_l1_s;         // signal is over the limit
  wire                  comp_low_l2_s;         // signal is over the limit
  wire                  passthrough_high_l1_s; // trigger when rising through the limit
  wire                  passthrough_low_l1_s;  // trigger when falling thorough the limit
  wire                  passthrough_high_l2_s; // trigger when rising through the limit
  wire                  passthrough_low_l2_s;  // trigger when falling thorough the limit

  wire                  start_cnt_in;
  wire                  stop_cnt_in;
  wire                  auto_reset_window_cnt;
  wire                  rst_at_new_start_pulse;

  reg                   trigger_l1;
  reg                   trigger_l2;
  reg                   comp_high_l1;       // signal is over the limit
  reg                   comp_high_l2;       // signal is over the limit
  reg                   old_comp_high_l1;   // t + 1 version of comp_high_l1
  reg                   old_comp_high_l2;   // t + 1 version of comp_high_l2
  reg                   first_l1_h_trigger; // valid hysteresis range on passthrough high trigger limit
  reg                   first_l1_l_trigger; // valid hysteresis range on passthrough low trigger limit
  reg signed [DW:0]     hyst_l1_high_limit;
  reg signed [DW:0]     hyst_l1_low_limit;
  reg                   first_l2_h_trigger; // valid hysteresis range on passthrough high trigger limit
  reg                   first_l2_l_trigger; // valid hysteresis range on passthrough low trigger limit
  reg signed [DW:0]     hyst_l2_high_limit;
  reg signed [DW:0]     hyst_l2_low_limit;

  reg                   start_cnt_d = 1'd0;
  reg                   stop_cnt_d = 1'd0;
  reg        [15:0]     start_cnt = 16'd0;
  reg        [15:0]     stop_cnt = 16'd0;
  reg        [31:0]     window_cnt = 32'd0;
  reg        [31:0]     window_cnt_m = 32'd0;

  reg                   start_window_cnt = 1'd0;
  reg                   stop_window_cnt = 1'd0;
  reg                   run_window_cnt = 1'd0;
  reg                   window_cnt_pass_first = 1'd0;
  reg                   window_cnt_pass_second = 1'd0;
  reg                   auto_reset = 1'd0;

  // window trigger config
  assign mux_sel_l1_data = window_trigger_config[0];
  assign mux_sel_l2_data = window_trigger_config[1];
  assign function_l1 = window_trigger_config[4:2];
  assign function_l2 = window_trigger_config[7:5];
  assign window_cnt_function = window_trigger_config[10:8];
  assign rst_at_new_start_pulse = window_trigger_config[11];

  // ????????????????????????
  // window cnt run on sample rate or clock
  // ????????????????????????

  // trigger Ln muxes
  assign data_l1_cmp   = mux_sel_l1_data ? data_b[DW:0] : data_a[DW:0];
  assign data_l2_cmp   = mux_sel_l2_data ? data_b[DW:0] : data_a[DW:0];

  assign limit_l1_cmp  = limit_l1[DW:0];
  assign limit_l2_cmp  = limit_l2[DW:0];

  // trigger L1
  always @(posedge clk) begin
    if ((data_valid_a == 1'b1) | (data_valid_b == 1'b1)) begin
      hyst_l1_high_limit <= limit_l1_cmp + hysteresis_l1[DW:0];
      hyst_l1_low_limit  <= limit_l1_cmp - hysteresis_l1[DW:0];

      if (data_l1_cmp >= limit_l1_cmp) begin
        comp_high_l1 <= 1'b1;
        first_l1_h_trigger <= passthrough_high_l1_s ? 0 : first_l1_h_trigger;
        if (data_l1_cmp > hyst_l1_high_limit) begin
          first_l1_l_trigger <= 1'b1;
        end
      end else begin
        comp_high_l1 <= 1'b0;
        first_l1_l_trigger <= (passthrough_low_l1_s) ? 0 : first_l1_l_trigger;
        if (data_l1_cmp < hyst_l1_low_limit) begin
          first_l1_h_trigger <= 1'b1;
        end
      end
      old_comp_high_l1 <= comp_high_l1;
    end
  end

  assign passthrough_high_l1_s = !old_comp_high_l1 & comp_high_l1 & first_l1_h_trigger;
  assign passthrough_low_l1_s = old_comp_high_l1 & !comp_high_l1 & first_l1_l_trigger;
  assign comp_low_l1_s = !comp_high_l1;

  always @(*) begin
    case(function_l1)
      2'h0: trigger_l1 = comp_low_l1_s;
      2'h1: trigger_l1 = comp_high_l1;
      2'h2: trigger_l1 = passthrough_high_l1_s;
      2'h3: trigger_l1 = passthrough_low_l1_s;
      default: trigger_l1 = comp_low_l1_s;
    endcase
  end

  // trigger L2
  always @(posedge clk) begin
    if ((data_valid_a == 1'b1) | (data_valid_b == 1'b1)) begin
      hyst_l2_high_limit <= limit_l2_cmp + hysteresis_l2[DW:0];
      hyst_l2_low_limit  <= limit_l2_cmp - hysteresis_l2[DW:0];

      if (data_l2_cmp >= limit_l2_cmp) begin
        comp_high_l2 <= 1'b1;
        first_l2_h_trigger <= (passthrough_high_l2_s == 1) ? 0 : first_l2_h_trigger;
        if (data_l2_cmp > hyst_l2_high_limit) begin
          first_l2_l_trigger <= 1'b1;
        end
      end else begin
        comp_high_l2 <= 1'b0;
        first_l2_l_trigger <= (passthrough_low_l2_s == 1) ? 0 : first_l2_l_trigger;
        if (data_l2_cmp < hyst_l2_low_limit) begin
          first_l2_h_trigger <= 1'b1;
        end
      end
      old_comp_high_l2 <= comp_high_l2;
    end
  end

  assign passthrough_high_l2_s = !old_comp_high_l2 & comp_high_l2 & first_l2_h_trigger;
  assign passthrough_low_l2_s = old_comp_high_l2 & !comp_high_l2 & first_l2_l_trigger;
  assign comp_low_l2_s = !comp_high_l2;

  always @(*) begin
    case(function_l2)
      2'h0: trigger_l2 = comp_low_l2_s;
      2'h1: trigger_l2 = comp_high_l2;
      2'h2: trigger_l2 = passthrough_high_l2_s;
      2'h3: trigger_l2 = passthrough_low_l2_s;
      default: trigger_l2 = comp_low_l2_s;
    endcase
  end

  // N start stop pulse for delay counters

  always @(posedge clk) begin
    if ((data_valid_a == 1'b1) | (data_valid_b == 1'b1)) begin
      start_cnt_d <= trigger_l1;
      stop_cnt_d <= trigger_l2;
    end
  end

  // one clock cycle pulse
  assign start_cnt_in = ~start_cnt_d & trigger_l1;
  assign stop_cnt_in =  ~stop_cnt_d  & trigger_l2;

  // start
  always @(posedge clk) begin
    if ((data_valid_a == 1'b1) | (data_valid_b == 1'b1)) begin
      if ((start_cnt == 15'd0) & (!run_window_cnt | rst_at_new_start_pulse) & start_cnt_in) begin
        start_cnt <= cnt_start;
        start_window_cnt <= start_cnt_in;
      end else if (!(start_cnt == 15'd0) & (start_cnt_in)) begin
        start_cnt <= start_cnt - 15'd1;
      end else begin
        start_window_cnt <= 1'b0;
      end

      // stop
      if ((stop_cnt == 15'd0) & run_window_cnt & stop_cnt_in) begin
        stop_cnt <= cnt_stop;
        stop_window_cnt <= stop_cnt_in;
      end else if (!(stop_cnt == 15'd0) & stop_cnt_in) begin
        stop_cnt <= stop_cnt - 15'd1;
      end else begin
        stop_window_cnt <= 0;
      end
    end
  end

  // window counter
  always @(posedge clk) begin
    if ((data_valid_a == 1'b1) | (data_valid_b == 1'b1)) begin
      if ((start_window_cnt & (!run_window_cnt | rst_at_new_start_pulse)) | auto_reset_window_cnt ) begin
        run_window_cnt <= ~auto_reset_window_cnt;
        window_cnt <= 32'd0;
        window_cnt_pass_first <= 1'b0;
        window_cnt_pass_second <= 1'b0;
      end else if (stop_window_cnt | (window_cnt == 32'hffffffff)) begin
        window_cnt_m <= window_cnt;
        run_window_cnt <= 1'b0;
      end else if(run_window_cnt) begin
        window_cnt <= window_cnt + 1;
      end else begin
        window_cnt_m <= window_cnt_m;
      end

      // stop window counter
      if ((window_cnt > window_limit1) & window_limit1 != 0) begin
        window_cnt_pass_first <= 1'b1;
      end
      if ((window_cnt > window_limit2) & window_limit2 != 0) begin
        window_cnt_pass_second <= 1'b1;
      end

      // window trigger function
      case(window_cnt_function)
        // expect pulses wider than the limit
        2'h0: begin
              trigger_out = window_cnt_pass_first & stop_window_cnt;
              auto_reset = stop_window_cnt;
        end
        // expect pulses shorter than the limit
        2'h1: begin
              trigger_out = ~window_cnt_pass_first & stop_window_cnt;
              auto_reset = window_cnt_pass_first;
        end
        // window trigger in range (>= <=), when trigger is received
        2'h2: begin
              trigger_out =  window_cnt_pass_first & ~window_cnt_pass_second & stop_window_cnt;
              auto_reset  = 1'b0;
        end
        default: begin
                 trigger_out = 1'b0;
                 auto_reset  = 1'b0;
                 end
      endcase
    end
  end

  assign read_window_cnt = window_cnt_m;
  assign auto_reset_window_cnt = trigger_out | auto_reset;

endmodule

// ***************************************************************************
// ***************************************************************************
