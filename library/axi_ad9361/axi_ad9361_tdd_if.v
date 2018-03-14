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

`timescale 1ns/1ps

module axi_ad9361_tdd_if#(

  parameter       LEVEL_OR_PULSE_N = 0) (

  // clock

  input                   clk,
  input                   rst,

  // control signals from the tdd control

  input                   tdd_rx_vco_en,
  input                   tdd_tx_vco_en,
  input                   tdd_rx_rf_en,
  input                   tdd_tx_rf_en,

  // device interface

  output                  ad9361_txnrx,
  output                  ad9361_enable,

  // interface status

  output      [ 7:0]      ad9361_tdd_status);


  localparam      PULSE_MODE = 0;
  localparam      LEVEL_MODE = 1;

  // internal registers


  reg             tdd_vco_overlap = 1'b0;
  reg             tdd_rf_overlap = 1'b0;

  wire            ad9361_txnrx_s;
  wire            ad9361_enable_s;

  // just one VCO can be enabled at a time
  assign ad9361_txnrx_s = tdd_tx_vco_en & ~tdd_rx_vco_en;

  generate
  if (LEVEL_OR_PULSE_N == PULSE_MODE) begin
    reg  tdd_rx_rf_en_d = 1'b0;
    reg  tdd_tx_rf_en_d = 1'b0;
    always @(posedge clk) begin
      tdd_rx_rf_en_d <= tdd_rx_rf_en;
      tdd_tx_rf_en_d <= tdd_tx_rf_en;
    end
    assign ad9361_enable_s = (tdd_rx_rf_en_d ^ tdd_rx_rf_en) ||
                             (tdd_tx_rf_en_d ^ tdd_tx_rf_en);
  end else
    assign ad9361_enable_s = (tdd_rx_rf_en | tdd_tx_rf_en);
  endgenerate

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

