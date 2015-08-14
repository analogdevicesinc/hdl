// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_xcvr_rx_rst (

  // clock, reset and pll locked

  rx_clk,
  rx_rstn,
  rx_sw_rstn,
  rx_pll_locked,

  // xcvr status and reset
                                              
  rx_cal_busy,
  rx_cdr_locked,
  rx_analog_reset,
  rx_digital_reset,
  rx_ready,
  rx_rst_state);

  // parameters

  parameter   NUM_OF_LANES = 4;
  parameter   RX_CAL_DONE_COUNT_WIDTH = 8;
  parameter   RX_CDR_LOCKED_COUNT_WIDTH = 8;
  parameter   RX_ANALOG_RESET_COUNT_WIDTH = 5;
  parameter   RX_DIGITAL_RESET_COUNT_WIDTH = 12;

  localparam  RX_RESET_FSM_INIT   = 4'h0;
  localparam  RX_RESET_FSM_ARST0  = 4'h1;
  localparam  RX_RESET_FSM_ARST1  = 4'h2;
  localparam  RX_RESET_FSM_ARST2  = 4'h3;
  localparam  RX_RESET_FSM_ARST3  = 4'h4;
  localparam  RX_RESET_FSM_ARSTD  = 4'h5;
  localparam  RX_RESET_FSM_DRST0  = 4'h6;
  localparam  RX_RESET_FSM_DRST1  = 4'h7;
  localparam  RX_RESET_FSM_DRST2  = 4'h8;
  localparam  RX_RESET_FSM_DRST3  = 4'h9;
  localparam  RX_RESET_FSM_DRSTD  = 4'ha;
  localparam  RX_RESET_FSM_IDLE   = 4'hb;

  // clock, reset and pll locked

  input                                       rx_clk;
  input                                       rx_rstn;
  input                                       rx_sw_rstn;
  input                                       rx_pll_locked;

  // xcvr status and reset
                                              
  input   [NUM_OF_LANES-1:0]                  rx_cal_busy;
  input   [NUM_OF_LANES-1:0]                  rx_cdr_locked;
  output  [NUM_OF_LANES-1:0]                  rx_analog_reset;
  output  [NUM_OF_LANES-1:0]                  rx_digital_reset;
  output                                      rx_ready;
  output  [  3:0]                             rx_rst_state;

  // internal registers

  reg     [  2:0]                             rx_rst_req_m = 'd0;
  reg                                         rx_rst_req = 'd0;
  reg     [RX_CAL_DONE_COUNT_WIDTH:0]         rx_cal_done_cnt = 'd0;
  reg     [RX_CDR_LOCKED_COUNT_WIDTH:0]       rx_cdr_locked_cnt = 'd0;
  reg     [RX_ANALOG_RESET_COUNT_WIDTH:0]     rx_analog_reset_cnt = 'd0;
  reg     [RX_DIGITAL_RESET_COUNT_WIDTH:0]    rx_digital_reset_cnt = 'd0;
  reg     [  3:0]                             rx_rst_state = 'd0;
  reg     [NUM_OF_LANES-1:0]                  rx_analog_reset = 'd0;
  reg     [NUM_OF_LANES-1:0]                  rx_digital_reset = 'd0;
  reg                                         rx_ready = 'd0;

  // internal signals

  wire                                        rx_rst_req_s;
  wire                                        rx_cal_busy_s;
  wire                                        rx_cal_done_s;
  wire                                        rx_cal_done_valid_s;
  wire                                        rx_cdr_locked_s;
  wire                                        rx_cdr_locked_valid_s;
  wire                                        rx_analog_reset_s;
  wire                                        rx_analog_reset_valid_s;
  wire                                        rx_digital_reset_s;
  wire                                        rx_digital_reset_valid_s;

  // reset request

  assign rx_rst_req_s = ~(rx_rstn & rx_sw_rstn & rx_pll_locked);

  always @(posedge rx_clk) begin
    rx_rst_req_m <= {rx_rst_req_m[1:0], rx_rst_req_s};
    rx_rst_req <= rx_rst_req_m[2];
  end

  // cal busy check width

  assign rx_cal_busy_s = | rx_cal_busy;
  assign rx_cal_done_s = ~rx_cal_busy_s;
  assign rx_cal_done_valid_s = rx_cal_done_cnt[RX_CAL_DONE_COUNT_WIDTH];

  always @(posedge rx_clk) begin
    if (rx_cal_done_s == 1'd0) begin
      rx_cal_done_cnt <= 'd0;
    end else if (rx_cal_done_cnt[RX_CAL_DONE_COUNT_WIDTH] == 1'b0) begin
      rx_cal_done_cnt <= rx_cal_done_cnt + 1'b1;
    end
  end

  // cdr locked check width

  assign rx_cdr_locked_s = | rx_cdr_locked;
  assign rx_cdr_locked_valid_s = rx_cdr_locked_cnt[RX_CDR_LOCKED_COUNT_WIDTH];

  always @(posedge rx_clk) begin
    if (rx_cdr_locked_s == 1'd0) begin
      rx_cdr_locked_cnt <= 'd0;
    end else if (rx_cdr_locked_cnt[RX_CDR_LOCKED_COUNT_WIDTH] == 1'b0) begin
      rx_cdr_locked_cnt <= rx_cdr_locked_cnt + 1'b1;
    end
  end

  // analog reset width

  assign rx_analog_reset_s = | rx_analog_reset;
  assign rx_analog_reset_valid_s = rx_analog_reset_cnt[RX_ANALOG_RESET_COUNT_WIDTH];

  always @(posedge rx_clk) begin
    if (rx_analog_reset_s == 1'd0) begin
      rx_analog_reset_cnt <= 'd0;
    end else if (rx_analog_reset_cnt[RX_ANALOG_RESET_COUNT_WIDTH] == 1'b0) begin
      rx_analog_reset_cnt <= rx_analog_reset_cnt + 1'b1;
    end
  end

  // digital reset width

  assign rx_digital_reset_s = | rx_digital_reset;
  assign rx_digital_reset_valid_s = rx_digital_reset_cnt[RX_DIGITAL_RESET_COUNT_WIDTH];

  always @(posedge rx_clk) begin
    if (rx_digital_reset_s == 1'd0) begin
      rx_digital_reset_cnt <= 'd0;
    end else if (rx_digital_reset_cnt[RX_DIGITAL_RESET_COUNT_WIDTH] == 1'b0) begin
      rx_digital_reset_cnt <= rx_digital_reset_cnt + 1'b1;
    end
  end

  // state machine

  always @(posedge rx_clk) begin
    if (rx_rst_req == 1'b1) begin
      rx_rst_state <= RX_RESET_FSM_INIT;
    end else begin
      case (rx_rst_state)
        RX_RESET_FSM_INIT: begin
          rx_rst_state <= RX_RESET_FSM_ARST0;
        end
        RX_RESET_FSM_ARST0: begin
          if ((rx_cal_done_valid_s == 1'b1) && (rx_analog_reset_valid_s == 1'b1)) begin
            rx_rst_state <= RX_RESET_FSM_ARST1;
          end else begin
            rx_rst_state <= RX_RESET_FSM_ARST0;
          end
        end
        RX_RESET_FSM_ARST1: begin
          rx_rst_state <= RX_RESET_FSM_ARST2;
        end
        RX_RESET_FSM_ARST2: begin
          rx_rst_state <= RX_RESET_FSM_ARST3;
        end
        RX_RESET_FSM_ARST3: begin
          rx_rst_state <= RX_RESET_FSM_ARSTD;
        end
        RX_RESET_FSM_ARSTD: begin
          rx_rst_state <= RX_RESET_FSM_DRST0;
        end
        RX_RESET_FSM_DRST0: begin
          if ((rx_cdr_locked_valid_s == 1'b1) && (rx_digital_reset_valid_s == 1'b1)) begin
            rx_rst_state <= RX_RESET_FSM_DRST1;
          end else begin
            rx_rst_state <= RX_RESET_FSM_DRST0;
          end
        end
        RX_RESET_FSM_DRST1: begin
          rx_rst_state <= RX_RESET_FSM_DRST2;
        end
        RX_RESET_FSM_DRST2: begin
          rx_rst_state <= RX_RESET_FSM_DRST3;
        end
        RX_RESET_FSM_DRST3: begin
          rx_rst_state <= RX_RESET_FSM_DRSTD;
        end
        RX_RESET_FSM_DRSTD: begin
          rx_rst_state <= RX_RESET_FSM_IDLE;
        end
        RX_RESET_FSM_IDLE: begin
          rx_rst_state <= RX_RESET_FSM_IDLE;
        end
        default: begin
          rx_rst_state <= RX_RESET_FSM_INIT;
        end
      endcase
    end
  end
  
  // output signals

  always @(posedge rx_clk) begin
    if (rx_rst_state == RX_RESET_FSM_INIT) begin
      rx_analog_reset <= {{NUM_OF_LANES{1'b1}}};
    end else if (rx_rst_state == RX_RESET_FSM_ARSTD) begin
      rx_analog_reset <= {{NUM_OF_LANES{1'b0}}};
    end
    if (rx_rst_state == RX_RESET_FSM_INIT) begin
      rx_digital_reset <= {{NUM_OF_LANES{1'b1}}};
    end else if (rx_rst_state == RX_RESET_FSM_DRSTD) begin
      rx_digital_reset <= {{NUM_OF_LANES{1'b0}}};
    end
    if (rx_rst_state == RX_RESET_FSM_IDLE) begin
      rx_ready <= 1'b1;
    end else begin
      rx_ready <= 1'b0;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
