// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_rx_ctrl #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter ENABLE_FRAME_ALIGN_ERR_RESET = 0
) (
  input clk,
  input reset,

  input [NUM_LANES-1:0] cfg_lanes_disable,
  input [NUM_LINKS-1:0] cfg_links_disable,

  input phy_ready,
  output phy_en_char_align,

  output [NUM_LANES-1:0] cgs_reset,
  input [NUM_LANES-1:0] cgs_ready,

  output [NUM_LANES-1:0] ifs_reset,

  input lmfc_edge,
  input [NUM_LANES-1:0] frame_align_err_thresh_met,

  output [NUM_LINKS-1:0] sync,
  output reg latency_monitor_reset,

  output [1:0] status_state,
  output event_data_phase
);

  localparam STATE_RESET = 0;
  localparam STATE_WAIT_FOR_PHY = 1;
  localparam STATE_CGS = 2;
  localparam STATE_SYNCHRONIZED = 3;

  reg [2:0] state = STATE_RESET;
  reg [2:0] next_state = STATE_RESET;

  reg [NUM_LANES-1:0] cgs_rst = {NUM_LANES{1'b1}};
  reg [NUM_LANES-1:0] ifs_rst = {NUM_LANES{1'b1}};
  reg [NUM_LINKS-1:0] sync_n = {NUM_LINKS{1'b1}};
  reg en_align = 1'b0;
  reg state_good = 1'b0;

  reg [7:0] good_counter = 'h00;

  wire [7:0] good_cnt_limit_s;
  wire       good_cnt_limit_reached_s;
  wire       goto_next_state_s;

  assign cgs_reset = cgs_rst;
  assign ifs_reset = ifs_rst;
  assign sync = sync_n;
  assign phy_en_char_align = en_align;

  assign status_state = state;

  always @(posedge clk) begin
    case (state)
    STATE_RESET: begin
      cgs_rst <= {NUM_LANES{1'b1}};
      ifs_rst <= {NUM_LANES{1'b1}};
      sync_n <= {NUM_LINKS{1'b1}};
      latency_monitor_reset <= 1'b1;
    end
    STATE_CGS: begin
      sync_n <= cfg_links_disable;
      cgs_rst <= cfg_lanes_disable;
    end
    STATE_SYNCHRONIZED: begin
      if (lmfc_edge == 1'b1) begin
        sync_n <= {NUM_LINKS{1'b1}};
        ifs_rst <= cfg_lanes_disable;
        latency_monitor_reset <= 1'b0;
      end
    end
    endcase
  end

  always @(*) begin
    case (state)
    STATE_RESET: state_good = 1'b1;
    STATE_WAIT_FOR_PHY: state_good = phy_ready;
    STATE_CGS: state_good = &(cgs_ready | cfg_lanes_disable);
    STATE_SYNCHRONIZED: state_good = ENABLE_FRAME_ALIGN_ERR_RESET ?
                                     &(~frame_align_err_thresh_met | cfg_lanes_disable) :
                                     1'b1;
    default: state_good = 1'b0;
    endcase
  end

  assign good_cnt_limit_s = (state == STATE_CGS) ? 'hff : 'h7;
  assign good_cnt_limit_reached_s = good_counter == good_cnt_limit_s;

  assign goto_next_state_s = good_cnt_limit_reached_s || (state == STATE_SYNCHRONIZED);

  always @(posedge clk) begin
    if (reset) begin
      good_counter <= 'h00;
    end else if (state_good == 1'b1) begin
      if (good_cnt_limit_reached_s) begin
        good_counter <= 'h00;
      end else begin
        good_counter <= good_counter + 1'b1;
      end
    end else begin
      good_counter <= 'h00;
    end
  end

  always @(posedge clk) begin
    case (state)
    STATE_CGS: en_align <= 1'b1;
    default: en_align <= 1'b0;
    endcase
  end

  always @(*) begin
    case (state)
    STATE_RESET: next_state = STATE_WAIT_FOR_PHY;
    STATE_WAIT_FOR_PHY: next_state = STATE_CGS;
    STATE_CGS: next_state = STATE_SYNCHRONIZED;
    default: next_state = state_good ? state : STATE_RESET;
    endcase
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      state <= STATE_RESET;
    end else begin
      if (goto_next_state_s) begin
        state <= next_state;
      end
    end
  end

  assign event_data_phase = state == STATE_CGS &&
                            next_state == STATE_SYNCHRONIZED &&
                            good_cnt_limit_reached_s;

endmodule
