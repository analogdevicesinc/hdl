// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
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

`timescale 1ns/1ps

module ad_tdd_control(

  // clock and reset

  clk,
  rst,

  // TDD timming signals

  tdd_start,
  tdd_counter_reset,
  tdd_update_regs,
  tdd_secondary,
  tdd_counter_init,
  tdd_frame_length,
  tdd_burst_en,
  tdd_burst_count,
  tdd_infinite_burst,
  tdd_tx_dp_delay,

  tdd_vco_rx_on_1,
  tdd_vco_rx_off_1,
  tdd_vco_tx_on_1,
  tdd_vco_tx_off_1,

  tdd_rx_on_1,
  tdd_rx_off_1,
  tdd_tx_on_1,
  tdd_tx_off_1,

  tdd_tx_dp_on_1,
  tdd_tx_dp_off_1,

  tdd_vco_rx_on_2,
  tdd_vco_rx_off_2,
  tdd_vco_tx_on_2,
  tdd_vco_tx_off_2,

  tdd_rx_on_2,
  tdd_rx_off_2,
  tdd_tx_on_2,
  tdd_tx_off_2,

  tdd_tx_dp_on_2,
  tdd_tx_dp_off_2,

  // TDD control signals

  tdd_tx_dp_en,
  tdd_rx_vco_en,
  tdd_tx_vco_en,
  tdd_rx_rf_en,
  tdd_tx_rf_en,

  tdd_counter_status);

  // parameters

  localparam      ON = 1;
  localparam      OFF = 0;

  // input/output signals

  input           clk;
  input           rst;

  input           tdd_start;
  input           tdd_secondary;
  input           tdd_counter_reset;
  input           tdd_update_regs;
  input [21:0]    tdd_counter_init;
  input [21:0]    tdd_frame_length;
  input           tdd_burst_en;
  input [ 5:0]    tdd_burst_count;
  input           tdd_infinite_burst;
  input [ 7:0]    tdd_tx_dp_delay;

  input [21:0]    tdd_vco_rx_on_1;
  input [21:0]    tdd_vco_rx_off_1;
  input [21:0]    tdd_vco_tx_on_1;
  input [21:0]    tdd_vco_tx_off_1;

  input [21:0]    tdd_rx_on_1;
  input [21:0]    tdd_rx_off_1;
  input [21:0]    tdd_tx_on_1;
  input [21:0]    tdd_tx_off_1;

  input [21:0]    tdd_tx_dp_on_1;
  input [21:0]    tdd_tx_dp_off_1;

  input [21:0]    tdd_vco_rx_on_2;
  input [21:0]    tdd_vco_rx_off_2;
  input [21:0]    tdd_vco_tx_on_2;
  input [21:0]    tdd_vco_tx_off_2;

  input [21:0]    tdd_rx_on_2;
  input [21:0]    tdd_rx_off_2;
  input [21:0]    tdd_tx_on_2;
  input [21:0]    tdd_tx_off_2;

  input [21:0]    tdd_tx_dp_on_2;
  input [21:0]    tdd_tx_dp_off_2;

  output          tdd_tx_dp_en;       // initiate vco tx2rx switch
  output          tdd_rx_vco_en;      // initiate vco rx2tx switch
  output          tdd_tx_vco_en;      // power up RF Rx
  output          tdd_rx_rf_en;       // power up RF Tx
  output          tdd_tx_rf_en;       // enable Tx datapath

  output [23:0]   tdd_counter_status;

  // tdd control related

  reg             tdd_secondary_d = 1'h0;
  reg             tdd_start_d = 1'h0;
  reg   [21:0]    tdd_counter_init_d = 22'h0;
  reg   [21:0]    tdd_frame_length_d = 22'h0;
  reg             tdd_burst_en_d = 1'h0;
  reg   [ 5:0]    tdd_burst_count_d = 5'h0;
  reg             tdd_infinite_burst_d = 1'h0;
  reg   [ 7:0]    tdd_tx_dp_delay_d = 8'h0;

  reg   [21:0]    tdd_vco_rx_on_1_d = 22'h0;
  reg   [21:0]    tdd_vco_rx_off_1_d = 22'h0;
  reg   [21:0]    tdd_vco_tx_on_1_d = 22'h0;
  reg   [21:0]    tdd_vco_tx_off_1_d = 22'h0;

  reg   [21:0]    tdd_rx_on_1_d = 22'h0;
  reg   [21:0]    tdd_rx_off_1_d = 22'h0;
  reg   [21:0]    tdd_tx_on_1_d = 22'h0;
  reg   [21:0]    tdd_tx_off_1_d = 22'h0;

  reg   [21:0]    tdd_tx_dp_on_1_d = 22'h0;
  reg   [21:0]    tdd_tx_dp_off_1_d = 22'h0;

  reg   [21:0]    tdd_vco_rx_on_2_d = 22'h0;
  reg   [21:0]    tdd_vco_rx_off_2_d = 22'h0;
  reg   [21:0]    tdd_vco_tx_on_2_d = 22'h0;
  reg   [21:0]    tdd_vco_tx_off_2_d = 22'h0;

  reg   [21:0]    tdd_rx_on_2_d = 22'h0;
  reg   [21:0]    tdd_rx_off_2_d = 22'h0;
  reg   [21:0]    tdd_tx_on_2_d = 22'h0;
  reg   [21:0]    tdd_tx_off_2_d = 22'h0;

  reg   [21:0]    tdd_tx_dp_on_2_d = 22'h0;
  reg   [21:0]    tdd_tx_dp_off_2_d = 22'h0;

  reg             tdd_tx_dp_en = 1'b0;
  reg             tdd_rx_vco_en = 1'b0;
  reg             tdd_tx_vco_en = 1'b0;
  reg             tdd_rx_rf_en = 1'b0;
  reg             tdd_tx_rf_en = 1'b0;

  // tdd counter related

  reg   [21:0]    tdd_counter = 22'h0;
  reg   [ 5:0]    tdd_burst_counter = 6'h0;

  reg             tdd_counter_state = OFF;
  reg             tdd_burst_state = OFF;

  assign  tdd_counter_status = tdd_counter;

  // ***************************************************************************
  // all the control registers needs to be updated at the same time
  // ***************************************************************************

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_secondary_d <= 1'h0;
      tdd_start_d <= 1'h0;
      tdd_counter_init_d <= 22'h0;
      tdd_frame_length_d <= 22'h0;
      tdd_burst_en_d <= 1'h0;
      tdd_burst_count_d <= 5'h0;
      tdd_infinite_burst_d <= 1'h0;
      tdd_tx_dp_delay_d <= 8'h0;
      tdd_vco_rx_on_1_d <= 22'h0;
      tdd_vco_rx_on_1_d <= 22'h0;
      tdd_vco_tx_on_1_d <= 22'h0;
      tdd_vco_tx_off_1_d <= 22'h0;
      tdd_rx_on_1_d <= 22'h0;
      tdd_rx_off_1_d <= 22'h0;
      tdd_tx_on_1_d <= 22'h0;
      tdd_tx_off_1_d <= 22'h0;
      tdd_tx_dp_on_1_d <= 22'h0;
      tdd_tx_dp_off_1_d <= 22'h0;
      tdd_vco_rx_on_2_d <= 22'h0;
      tdd_vco_rx_off_2_d <= 22'h0;
      tdd_vco_tx_on_2_d <= 22'h0;
      tdd_vco_tx_off_2_d <= 22'h0;
      tdd_rx_on_2_d <= 22'h0;
      tdd_rx_off_2_d <= 22'h0;
      tdd_tx_on_2_d <= 22'h0;
      tdd_tx_off_2_d <= 22'h0;
      tdd_tx_dp_on_2_d <= 22'h0;
      tdd_tx_dp_off_2_d <= 22'h0;
    end else begin
      //if((tdd_update_regs == 1'b1) && (tdd_counter_state == OFF)) begin
        tdd_secondary_d <= tdd_secondary;
        tdd_start_d <= tdd_start;
        tdd_frame_length_d <= tdd_frame_length;
        tdd_counter_init_d <= tdd_counter_init;
        tdd_burst_en_d <= tdd_burst_en;
        tdd_burst_count_d <= tdd_burst_count;
        tdd_infinite_burst_d <= tdd_infinite_burst;
        tdd_tx_dp_delay_d <= tdd_tx_dp_delay;
        tdd_vco_rx_on_1_d <= tdd_vco_rx_on_1;
        tdd_vco_rx_off_1_d <= tdd_vco_rx_off_1;
        tdd_vco_tx_on_1_d <= tdd_vco_tx_on_1;
        tdd_vco_tx_off_1_d <= tdd_vco_tx_off_1;
        tdd_rx_on_1_d <= tdd_rx_on_1;
        tdd_rx_off_1_d <= tdd_rx_off_1;
        tdd_tx_on_1_d <= tdd_tx_on_1;
        tdd_tx_off_1_d <= tdd_tx_off_1;
        tdd_tx_dp_on_1_d <= tdd_tx_dp_on_1;
        tdd_tx_dp_off_1_d <= tdd_tx_dp_off_1;
        tdd_vco_rx_on_2_d <= tdd_vco_rx_on_2;
        tdd_vco_rx_off_2_d <= tdd_vco_rx_off_2;
        tdd_vco_tx_on_2_d <= tdd_vco_tx_on_2;
        tdd_vco_tx_off_2_d <= tdd_vco_tx_off_2;
        tdd_rx_on_2_d <= tdd_rx_on_2;
        tdd_rx_off_2_d <= tdd_rx_off_2;
        tdd_tx_on_2_d <= tdd_tx_on_2;
        tdd_tx_off_2_d <= tdd_tx_off_2;
        tdd_tx_dp_on_2_d <= tdd_tx_dp_on_2;
        tdd_tx_dp_off_2_d <= tdd_tx_dp_off_2;
      //end
    end
  end

  // ***************************************************************************
  // tdd counter (state machine)
  // ***************************************************************************

  always @(posedge clk) begin

    // sync reset
    if (rst == 1'b1) begin
      tdd_counter <= 24'h0;
      tdd_counter_state <= OFF;
      tdd_burst_state <= OFF;
    end else begin

      // counter reset
      if (tdd_counter_reset == 1'b1) begin
        tdd_counter_state <= OFF;
        tdd_burst_state <= OFF;
      end else

      // start counter, the start pulse should have one clock cycle
      // NOTE: a start pulse during a transaction will reinitialize the counter
      if (tdd_start == 1'b1) begin
        tdd_counter <= tdd_counter_init_d;
        tdd_burst_counter <= tdd_burst_count_d;
        tdd_counter_state <= ON;
        if ((tdd_burst_en_d == 1) &&
            ((tdd_burst_count_d > 0) || (tdd_infinite_burst_d == 1))) begin
          tdd_burst_state <= ON;
        end else begin
          tdd_burst_state <= OFF;
        end
      end else

      // free running counter
      if (tdd_counter_state == ON) begin
        if (tdd_counter == tdd_frame_length_d) begin
          tdd_counter <= 22'h0;
          if ((tdd_burst_state == ON) && ((tdd_burst_counter > 0) || (tdd_infinite_burst_d == 1))) begin
            tdd_burst_counter <= tdd_burst_counter - 1;
            tdd_counter_state <= ON;
          end else begin
            tdd_burst_counter <= 6'h0;
            tdd_counter_state <= OFF;
            tdd_burst_state <= OFF;
          end
        end else begin
          tdd_counter <= tdd_counter + 1;
        end
      end

    end
  end

  // ***************************************************************************
  // generate control signals
  // ***************************************************************************

  // start/stop rx vco
  always @(posedge clk) begin
    if(tdd_counter_state == ON) begin
      if (tdd_counter == (tdd_vco_rx_on_1_d - 1)) begin
        tdd_rx_vco_en <= 1'b1;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_vco_rx_on_2_d - 1))) begin
        tdd_rx_vco_en <= 1'b1;
      end else if (tdd_counter == (tdd_vco_rx_off_1_d - 1)) begin
        tdd_rx_vco_en <= 1'b0;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_vco_rx_off_2_d - 1))) begin
        tdd_rx_vco_en <= 1'b0;
      end
    end else begin
      tdd_rx_vco_en <= 1'b0;
    end
  end

  // start/stop tx vco
  always @(posedge clk) begin
    if(tdd_counter_state == ON) begin
      if (tdd_counter == (tdd_vco_tx_on_1_d - 1)) begin
        tdd_tx_vco_en <= 1'b1;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_vco_tx_on_2_d - 1))) begin
        tdd_tx_vco_en <= 1'b1;
      end else if (tdd_counter == (tdd_vco_tx_off_1_d - 1)) begin
        tdd_tx_vco_en <= 1'b0;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_vco_tx_off_2_d - 1))) begin
        tdd_tx_vco_en <= 1'b0;
      end
    end else begin
      tdd_tx_vco_en <= 1'b0;
    end
  end

  // start/stop rx rf path
  always @(posedge clk) begin
    if(tdd_counter_state == ON) begin
      if (tdd_counter == (tdd_rx_on_1_d - 1)) begin
        tdd_rx_rf_en <= 1'b1;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_rx_on_2_d - 1))) begin
        tdd_rx_rf_en <= 1'b1;
      end else if (tdd_counter == (tdd_rx_off_1_d - 1)) begin
        tdd_rx_rf_en <= 1'b0;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_rx_off_2_d - 1))) begin
        tdd_rx_rf_en <= 1'b0;
      end
    end else begin
      tdd_rx_rf_en <= 1'b0;
    end
  end

  // start/stop tx rf path
  always @(posedge clk) begin
    if(tdd_counter_state == ON) begin
      if (tdd_counter == (tdd_tx_on_1_d - 1)) begin
        tdd_tx_rf_en <= 1'b1;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_tx_on_2_d - 1))) begin
        tdd_tx_rf_en <= 1'b1;
      end else if (tdd_counter == (tdd_tx_off_1_d - 1)) begin
        tdd_tx_rf_en <= 1'b0;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_tx_off_2_d - 1))) begin
        tdd_tx_rf_en <= 1'b0;
      end
    end else begin
      tdd_tx_rf_en <= 1'b0;
    end
  end

  // start/stop tx data path
  always @(posedge clk) begin
    if(tdd_counter_state == ON) begin
      if (tdd_counter == (tdd_tx_dp_on_1_d - tdd_tx_dp_delay_d)) begin
        tdd_tx_dp_en <= 1'b1;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_tx_dp_on_2_d - tdd_tx_dp_delay_d))) begin
        tdd_tx_dp_en <= 1'b1;
      end else if (tdd_counter == (tdd_tx_dp_off_1_d - tdd_tx_dp_delay_d)) begin
        tdd_tx_dp_en <= 1'b0;
      end else if ((tdd_secondary_d == 1'b1) && (tdd_counter == (tdd_tx_dp_off_2_d - tdd_tx_dp_delay_d))) begin
        tdd_tx_dp_en <= 1'b0;
      end
    end else begin
      tdd_tx_dp_en <= 1'b0;
    end
  end

endmodule

