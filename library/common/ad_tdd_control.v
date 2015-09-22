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

  tdd_enable,
  tdd_secondary,
  tdd_tx_only,
  tdd_rx_only,
  tdd_burst_count,
  tdd_counter_init,
  tdd_frame_length,
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

  input           tdd_enable;
  input           tdd_secondary;
  input           tdd_tx_only;
  input           tdd_rx_only;
  input  [ 7:0]   tdd_burst_count;
  input  [23:0]   tdd_counter_init;
  input  [23:0]   tdd_frame_length;
  input  [23:0]   tdd_vco_rx_on_1;
  input  [23:0]   tdd_vco_rx_off_1;
  input  [23:0]   tdd_vco_tx_on_1;
  input  [23:0]   tdd_vco_tx_off_1;
  input  [23:0]   tdd_rx_on_1;
  input  [23:0]   tdd_rx_off_1;
  input  [23:0]   tdd_tx_on_1;
  input  [23:0]   tdd_tx_off_1;
  input  [23:0]   tdd_tx_dp_on_1;
  input  [23:0]   tdd_tx_dp_off_1;
  input  [23:0]   tdd_vco_rx_on_2;
  input  [23:0]   tdd_vco_rx_off_2;
  input  [23:0]   tdd_vco_tx_on_2;
  input  [23:0]   tdd_vco_tx_off_2;
  input  [23:0]   tdd_rx_on_2;
  input  [23:0]   tdd_rx_off_2;
  input  [23:0]   tdd_tx_on_2;
  input  [23:0]   tdd_tx_off_2;
  input  [23:0]   tdd_tx_dp_on_2;
  input  [23:0]   tdd_tx_dp_off_2;

  output          tdd_tx_dp_en;       // initiate vco tx2rx switch
  output          tdd_rx_vco_en;      // initiate vco rx2tx switch
  output          tdd_tx_vco_en;      // power up RF Rx
  output          tdd_rx_rf_en;       // power up RF Tx
  output          tdd_tx_rf_en;       // enable Tx datapath

  output [23:0]   tdd_counter_status;

  // tdd control related

  reg             tdd_tx_dp_en = 1'b0;
  reg             tdd_rx_vco_en = 1'b0;
  reg             tdd_tx_vco_en = 1'b0;
  reg             tdd_rx_rf_en = 1'b0;
  reg             tdd_tx_rf_en = 1'b0;

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
  reg             counter_at_tdd_tx_on_2 = 1'b0;
  reg             counter_at_tdd_tx_off_2 = 1'b0;
  reg             counter_at_tdd_tx_dp_on_2 = 1'b0;
  reg             counter_at_tdd_tx_dp_off_2 = 1'b0;

  reg             tdd_enable_d = 1'h0;
  reg             tdd_last_burst = 1'b0;

  // internal signals

  wire   [23:0]   tdd_tx_dp_on_1_s;
  wire   [23:0]   tdd_tx_dp_on_2_s;
  wire   [23:0]   tdd_tx_dp_off_1_s;
  wire   [23:0]   tdd_tx_dp_off_2_s;
  wire            tdd_endof_frame;
  wire            tdd_endof_burst;
  wire            tdd_txrx_only_en_s;

  assign  tdd_counter_status = tdd_counter;

  // ***************************************************************************
  // tdd counter (state machine)
  // ***************************************************************************

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      tdd_cstate <= OFF;
      tdd_enable_d <= 0;
    end else begin
      tdd_cstate <= tdd_cstate_next;
      tdd_enable_d <= tdd_enable;
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
        if((tdd_enable == 1'b1) && (tdd_enable_d == 1'b0)) begin
          tdd_cstate_next <= ON;
        end
      end
    endcase
  end

  assign tdd_endof_frame = (tdd_counter == tdd_frame_length) ? 1'b1 : 1'b0;
  assign tdd_endof_burst = ((tdd_last_burst == 1'b1) && (tdd_counter == tdd_frame_length)) ? 1'b1 : 1'b0;

  // tdd free running counter
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      tdd_counter <= tdd_counter_init;
    end else begin
      if (tdd_cstate == ON) begin
        tdd_counter <= (tdd_counter < tdd_frame_length) ? tdd_counter + 1 : 24'b0;
      end else begin
        tdd_counter <= tdd_counter_init;
      end
    end
  end

  // tdd burst counter
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      tdd_burst_counter <= tdd_burst_count;
    end else begin
      if (tdd_cstate == ON) begin
        tdd_burst_counter <= ((tdd_burst_counter > 0) && (tdd_endof_frame == 1'b1)) ? tdd_burst_counter - 1 : tdd_burst_counter;
      end else begin
        tdd_burst_counter <= tdd_burst_count;
      end
      tdd_last_burst <= (tdd_burst_counter == 6'b1) ? 1'b1 : 1'b0;
    end
  end

  // ***************************************************************************
  // generate control signals
  // ***************************************************************************

  // start/stop rx vco
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_rx_on_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_vco_rx_on_1) begin
      counter_at_tdd_vco_rx_on_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_vco_rx_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_rx_on_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_vco_rx_on_2)) begin
      counter_at_tdd_vco_rx_on_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_vco_rx_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_rx_off_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_vco_rx_off_1) begin
      counter_at_tdd_vco_rx_off_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_vco_rx_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_rx_off_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_vco_rx_off_2)) begin
      counter_at_tdd_vco_rx_off_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_vco_rx_off_2 <= 1'b0;
    end
  end

  // start/stop tx vco
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_tx_on_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_vco_tx_on_1) begin
      counter_at_tdd_vco_tx_on_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_vco_tx_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_tx_on_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_vco_tx_on_2)) begin
      counter_at_tdd_vco_tx_on_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_vco_tx_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_tx_off_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_vco_tx_off_1) begin
      counter_at_tdd_vco_tx_off_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_vco_tx_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_vco_tx_off_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_vco_tx_off_2)) begin
      counter_at_tdd_vco_tx_off_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_vco_tx_off_2 <= 1'b0;
    end
  end

  // start/stop rx rf path
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_on_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_rx_on_1) begin
      counter_at_tdd_rx_on_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_rx_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_on_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_rx_on_2)) begin
      counter_at_tdd_rx_on_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_rx_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_off_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_rx_off_1) begin
      counter_at_tdd_rx_off_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_rx_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_rx_off_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_rx_off_2)) begin
      counter_at_tdd_rx_off_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_rx_off_2 <= 1'b0;
    end
  end

  // start/stop tx rf path
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_on_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_tx_on_1) begin
      counter_at_tdd_tx_on_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_tx_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_on_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_tx_on_2)) begin
      counter_at_tdd_tx_on_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_tx_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_off_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_tx_off_1) begin
      counter_at_tdd_tx_off_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_tx_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_off_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_tx_off_2)) begin
      counter_at_tdd_tx_off_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_tx_off_2 <= 1'b0;
    end
  end

  // start/stop tx data path
  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_dp_on_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_tx_dp_on_1_s) begin
      counter_at_tdd_tx_dp_on_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_tx_dp_on_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_dp_on_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_tx_dp_on_2_s)) begin
      counter_at_tdd_tx_dp_on_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_tx_dp_on_2 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_dp_off_1 <= 1'b0;
    end else
    if(tdd_counter == tdd_tx_dp_off_1_s) begin
      counter_at_tdd_tx_dp_off_1 <= 1'b1;
    end
    else begin
      counter_at_tdd_tx_dp_off_1 <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      counter_at_tdd_tx_dp_off_2 <= 1'b0;
    end else
    if((tdd_secondary == 1'b1) && (tdd_counter == tdd_tx_dp_off_2_s)) begin
      counter_at_tdd_tx_dp_off_2 <= 1'b1;
    end
    else begin
      counter_at_tdd_tx_dp_off_2 <= 1'b0;
    end
  end

  // internal datapath delay compensation

  ad_addsub #(
    .A_WIDTH(24),
    .CONST_VALUE(11),
    .ADD_SUB(1)
  ) i_tx_dp_on_1_comp (
    .clk(clk),
    .A(tdd_tx_dp_on_1),
    .Amax(tdd_frame_length),
    .out(tdd_tx_dp_on_1_s),
    .CE(1)
  );

  ad_addsub #(
    .A_WIDTH(24),
    .CONST_VALUE(11),
    .ADD_SUB(1)
  ) i_tx_dp_on_2_comp (
    .clk(clk),
    .A(tdd_tx_dp_on_2),
    .Amax(tdd_frame_length),
    .out(tdd_tx_dp_on_2_s),
    .CE(1)
  );

  ad_addsub #(
    .A_WIDTH(24),
    .CONST_VALUE(11),
    .ADD_SUB(1)
  ) i_tx_dp_off_1_comp (
    .clk(clk),
    .A(tdd_tx_dp_off_1),
    .Amax(tdd_frame_length),
    .out(tdd_tx_dp_off_1_s),
    .CE(1)
  );

  ad_addsub #(
    .A_WIDTH(24),
    .CONST_VALUE(11),
    .ADD_SUB(1)
  ) i_tx_dp_off_2_comp (
    .clk(clk),
    .A(tdd_tx_dp_off_2),
    .Amax(tdd_frame_length),
    .out(tdd_tx_dp_off_2_s),
    .CE(1)
  );

  // output logic

  assign tdd_txrx_only_en_s = tdd_tx_only ^ tdd_rx_only;

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_rx_vco_en <= 1'b0;
    end
    else if((tdd_cstate == OFF) || (counter_at_tdd_vco_rx_off_1 == 1'b1) || (counter_at_tdd_vco_rx_off_2 == 1'b1)) begin
      tdd_rx_vco_en <= 1'b0;
    end
    else if((tdd_cstate == ON) && ((counter_at_tdd_vco_rx_on_1 == 1'b1) || (counter_at_tdd_vco_rx_on_2 == 1'b1))) begin
      tdd_rx_vco_en <= 1'b1;
    end
    else if((tdd_cstate == ON) && (tdd_txrx_only_en_s == 1'b1)) begin
      tdd_rx_vco_en <= tdd_rx_only;
    end
    else begin
      tdd_rx_vco_en <= tdd_rx_vco_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_tx_vco_en <= 1'b0;
    end
    else if((tdd_cstate == OFF) || (counter_at_tdd_vco_tx_off_1 == 1'b1) || (counter_at_tdd_vco_tx_off_2 == 1'b1)) begin
      tdd_tx_vco_en <= 1'b0;
    end
    else if((tdd_cstate == ON) && ((counter_at_tdd_vco_tx_on_1 == 1'b1) || (counter_at_tdd_vco_tx_on_2 == 1'b1))) begin
      tdd_tx_vco_en <= 1'b1;
    end
    else if((tdd_cstate == ON) && (tdd_txrx_only_en_s == 1'b1)) begin
      tdd_tx_vco_en <= tdd_tx_only;
    end
    else begin
      tdd_tx_vco_en <= tdd_tx_vco_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_rx_rf_en <= 1'b0;
    end
    else if((tdd_cstate == OFF) || (counter_at_tdd_rx_off_1 == 1'b1) || (counter_at_tdd_rx_off_2 == 1'b1)) begin
      tdd_rx_rf_en <= 1'b0;
    end
    else if((tdd_cstate == ON) && ((counter_at_tdd_rx_on_1 == 1'b1) || (counter_at_tdd_rx_on_2 == 1'b1))) begin
      tdd_rx_rf_en <= 1'b1;
    end
    else if((tdd_cstate == ON) && (tdd_txrx_only_en_s == 1'b1)) begin
      tdd_rx_rf_en <= tdd_rx_only;
    end
    else begin
      tdd_rx_rf_en <= tdd_rx_rf_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_tx_rf_en <= 1'b0;
    end
    else if((tdd_cstate == OFF) || (counter_at_tdd_tx_off_1 == 1'b1) || (counter_at_tdd_tx_off_2 == 1'b1)) begin
      tdd_tx_rf_en <= 1'b0;
    end
    else if((tdd_cstate == ON) && ((counter_at_tdd_tx_on_1 == 1'b1) || (counter_at_tdd_tx_on_2 == 1'b1))) begin
      tdd_tx_rf_en <= 1'b1;
    end
    else if((tdd_cstate == ON) && (tdd_txrx_only_en_s == 1'b1)) begin
      tdd_tx_rf_en <= tdd_tx_only;
    end
    else begin
      tdd_tx_rf_en <= tdd_tx_rf_en;
    end
  end

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_tx_dp_en <= 1'b0;
    end
    else if((tdd_cstate == OFF) || (counter_at_tdd_tx_dp_off_1 == 1'b1) || (counter_at_tdd_tx_dp_off_2 == 1'b1)) begin
      tdd_tx_dp_en <= 1'b0;
    end
    else if((tdd_cstate == ON) && ((counter_at_tdd_tx_dp_on_1 == 1'b1) || (counter_at_tdd_tx_dp_on_2 == 1'b1))) begin
      tdd_tx_dp_en <= 1'b1;
    end
    else if((tdd_cstate == ON) && (tdd_txrx_only_en_s == 1'b1)) begin
      tdd_tx_dp_en <= tdd_tx_only;
    end
    else begin
      tdd_tx_dp_en <= tdd_tx_dp_en;
    end
  end

endmodule

