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

module axi_ad9361_tdd_if(

  // clock

  clk,
  rst,

  // control signals from the tdd control

  tdd_rx_vco_en,
  tdd_tx_vco_en,
  tdd_rx_rf_en,
  tdd_tx_rf_en,

  // device interface

  ad9361_txnrx,
  ad9361_enable,

  // interface status

  ad9361_tdd_status
);

  // parameters

  parameter       LEVEL_OR_PULSE_N = 0;   // the control signals are edge (pulse) or level sensitive

  localparam      PULSE_MODE = 0;
  localparam      LEVEL_MODE = 1;

  // clock

  input           clk;
  input           rst;

  // control signals from the tdd control

  input           tdd_rx_vco_en;
  input           tdd_tx_vco_en;
  input           tdd_rx_rf_en;
  input           tdd_tx_rf_en;

  // device interface

  output          ad9361_txnrx;
  output          ad9361_enable;

  // interface status

  output  [ 7:0]  ad9361_tdd_status;


  // internal registers

  reg             tdd_rx_rf_en_d = 1'b0;
  reg             tdd_tx_rf_en_d = 1'b0;

  reg             tdd_vco_overlap = 1'b0;
  reg             tdd_rf_overlap = 1'b0;

  wire            ad9361_txnrx_s;
  wire            ad9361_enable_s;

  // just one VCO can be enabled at a time
  assign ad9361_txnrx_s = tdd_tx_vco_en & ~tdd_rx_vco_en;

  always @(posedge clk) begin
    tdd_rx_rf_en_d <= tdd_rx_rf_en;
    tdd_tx_rf_en_d <= tdd_tx_rf_en;
  end

  assign ad9361_enable_s = (LEVEL_OR_PULSE_N == PULSE_MODE) ?
                          ((~tdd_rx_rf_en_d & tdd_rx_rf_en) | (tdd_rx_rf_en_d & ~tdd_rx_rf_en) |
                           (~tdd_tx_rf_en_d & tdd_tx_rf_en) | (tdd_tx_rf_en_d & ~tdd_tx_rf_en)) :
                           (tdd_rx_rf_en | tdd_tx_rf_en);

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_vco_overlap <= 1'b0;
      tdd_rf_overlap <= 1'b0;
    end else begin
      tdd_vco_overlap <= tdd_rx_vco_en & tdd_tx_vco_en;
      tdd_rf_overlap <= tdd_rx_rf_en & tdd_tx_rf_en;
    end
  end

  assign ad9361_tdd_status = {6'b0, tdd_rf_overlap, tdd_vco_overlap};

  assign ad9361_txnrx = ad9361_txnrx_s;
  assign ad9361_enable = ad9361_enable_s;

endmodule

