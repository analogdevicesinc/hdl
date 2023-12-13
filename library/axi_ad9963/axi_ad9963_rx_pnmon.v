// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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
// PN monitors

`timescale 1ns/100ps

module axi_ad9963_rx_pnmon (

  // adc interface

  input           adc_clk,
  input           adc_valid,
  input   [11:0]  adc_data,

  // pn out of sync and error

  input   [ 3:0]  adc_pnseq_sel,
  output          adc_pn_oos,
  output          adc_pn_err
);

  // internal registers

  reg     [23:0]  adc_pn_data_in = 'd0;
  reg     [23:0]  adc_pn_data_pn = 'd0;

  // internal signals

  wire    [31:0]  adc_pn_data_pn_s;

  // bit reversal function

  function [11:0] brfn;
    input [11:0] din;
    reg   [11:0] dout;
    begin
      dout[11] = din[ 0];
      dout[10] = din[ 1];
      dout[ 9] = din[ 2];
      dout[ 8] = din[ 3];
      dout[ 7] = din[ 4];
      dout[ 6] = din[ 5];
      dout[ 5] = din[ 6];
      dout[ 4] = din[ 7];
      dout[ 3] = din[ 8];
      dout[ 2] = din[ 9];
      dout[ 1] = din[10];
      dout[ 0] = din[11];
      brfn = dout;
    end
  endfunction

  // standard prbs functions

  function [23:0] pn23;
    input [23:0] din;
    reg   [23:0] dout;
    begin
      dout = {din[22:0], din[22] ^ din[17]};
      pn23 = dout;
    end
  endfunction

  // standard, runs on 24bit

  assign adc_pn_data_pn_s = (adc_pn_oos == 1'b1) ? adc_pn_data_in : adc_pn_data_pn;

  always @(posedge adc_clk) begin
    if(adc_valid == 1'b1) begin
      adc_pn_data_in <= {adc_pn_data_in[22:11], adc_data};
      adc_pn_data_pn <= pn23(adc_pn_data_pn_s);
    end
  end

  // pn oos & pn err

  ad_pnmon #(
    .DATA_WIDTH(24)
  ) i_pnmon (
    .adc_clk (adc_clk),
    .adc_valid_in (adc_valid),
    .adc_data_in (adc_pn_data_in),
    .adc_data_pn (adc_pn_data_pn),
    .adc_pattern_has_zero (1'b0),
    .adc_pn_oos (adc_pn_oos),
    .adc_pn_err (adc_pn_err));

endmodule
