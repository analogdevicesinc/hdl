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

module axi_ad9434_pnmon (

  // adc interface
  input                   adc_clk,
  input       [47:0]      adc_data,

  // pn interface
  input       [ 3:0]      adc_pnseq_sel,
  output                  adc_pn_err,
  output                  adc_pn_oos);

  // internal registers
  reg     [47:0]  adc_pn_data_pn = 'd0;

  // internal signals
  wire    [47:0]  adc_pn_data_pn_s;

  wire    [47:0]  adc_data_inv_s;

  // prbs pn9 function
  function [47:0] pn9;
    input [47:0] din;
    reg   [47:0] dout;
    begin
      dout[47] = din[8] ^ din[4];
      dout[46] = din[7] ^ din[3];
      dout[45] = din[6] ^ din[2];
      dout[44] = din[5] ^ din[1];
      dout[43] = din[4] ^ din[0];
      dout[42] = din[3] ^ din[8] ^ din[4];
      dout[41] = din[2] ^ din[7] ^ din[3];
      dout[40] = din[1] ^ din[6] ^ din[2];
      dout[39] = din[0] ^ din[5] ^ din[1];
      dout[38] = din[8] ^ din[0];
      dout[37] = din[7] ^ din[8] ^ din[4];
      dout[36] = din[6] ^ din[7] ^ din[3];
      dout[35] = din[5] ^ din[6] ^ din[2];
      dout[34] = din[4] ^ din[5] ^ din[1];
      dout[33] = din[3] ^ din[4] ^ din[0];
      dout[32] = din[2] ^ din[3] ^ din[8] ^ din[4];
      dout[31] = din[1] ^ din[2] ^ din[7] ^ din[3];
      dout[30] = din[0] ^ din[1] ^ din[6] ^ din[2];
      dout[29] = din[8] ^ din[0] ^ din[4] ^ din[5] ^ din[1];
      dout[28] = din[7] ^ din[8] ^ din[3] ^ din[0];
      dout[27] = din[6] ^ din[7] ^ din[2] ^ din[8] ^ din[4];
      dout[26] = din[5] ^ din[6] ^ din[1] ^ din[7] ^ din[3];
      dout[25] = din[4] ^ din[5] ^ din[0] ^ din[6] ^ din[2];
      dout[24] = din[3] ^ din[8] ^ din[5] ^ din[1];
      dout[23] = din[2] ^ din[4] ^ din[7] ^ din[0];
      dout[22] = din[1] ^ din[3] ^ din[6] ^ din[8] ^ din[4];
      dout[21] = din[0] ^ din[2] ^ din[5] ^ din[7] ^ din[3];
      dout[20] = din[8] ^ din[1] ^ din[6] ^ din[2];
      dout[19] = din[7] ^ din[0] ^ din[5] ^ din[1];
      dout[18] = din[6] ^ din[8] ^ din[0];
      dout[17] = din[5] ^ din[7] ^ din[8] ^ din[4];
      dout[16] = din[4] ^ din[6] ^ din[7] ^ din[3];
      dout[15] = din[3] ^ din[5] ^ din[6] ^ din[2];
      dout[14] = din[2] ^ din[4] ^ din[5] ^ din[1];
      dout[13] = din[1] ^ din[3] ^ din[4] ^ din[0];
      dout[12] = din[0] ^ din[2] ^ din[3] ^ din[8] ^ din[4];
      dout[11] = din[8] ^ din[1] ^ din[2] ^ din[4] ^ din[7] ^ din[3];
      dout[10] = din[7] ^ din[0] ^ din[1] ^ din[3] ^ din[6] ^ din[2];
      dout[9]  = din[6] ^ din[8] ^ din[0] ^ din[2] ^ din[4] ^ din[5] ^ din[1];
      dout[8]  = din[5] ^ din[7] ^ din[8] ^ din[1] ^ din[3] ^ din[0];
      dout[7]  = din[6] ^ din[7] ^ din[0] ^ din[2] ^ din[8];
      dout[6]  = din[5] ^ din[6] ^ din[8] ^ din[1] ^ din[4] ^ din[7];
      dout[5]  = din[4] ^ din[5] ^ din[7] ^ din[0] ^ din[3] ^ din[6];
      dout[4]  = din[3] ^ din[6] ^ din[8] ^ din[2] ^ din[5];
      dout[3]  = din[2] ^ din[4] ^ din[5] ^ din[7] ^ din[1];
      dout[2]  = din[1] ^ din[4] ^ din[3] ^ din[6] ^ din[0];
      dout[1]  = din[0] ^ din[3] ^ din[2] ^ din[5] ^ din[8] ^ din[4];
      dout[0]  = din[8] ^ din[2] ^ din[1] ^ din[7] ^ din[3];
      pn9 = dout;
    end
  endfunction

  // prbs pn23 function
  function [47:0] pn23;
    input [47:0] din;
    reg   [47:0] dout;
    begin
      dout[47] = din[22] ^ din[17];
      dout[46] = din[21] ^ din[16];
      dout[45] = din[20] ^ din[15];
      dout[44] = din[19] ^ din[14];
      dout[43] = din[18] ^ din[13];
      dout[42] = din[17] ^ din[12];
      dout[41] = din[16] ^ din[11];
      dout[40] = din[15] ^ din[10];
      dout[39] = din[14] ^ din[9];
      dout[38] = din[13] ^ din[8];
      dout[37] = din[12] ^ din[7];
      dout[36] = din[11] ^ din[6];
      dout[35] = din[10] ^ din[5];
      dout[34] = din[9]  ^ din[4];
      dout[33] = din[8]  ^ din[3];
      dout[32] = din[7]  ^ din[2];
      dout[31] = din[6]  ^ din[1];
      dout[30] = din[5]  ^ din[0];
      dout[29] = din[4]  ^ din[22] ^ din[17];
      dout[28] = din[3]  ^ din[21] ^ din[16];
      dout[27] = din[2]  ^ din[20] ^ din[15];
      dout[26] = din[1]  ^ din[19] ^ din[14];
      dout[25] = din[0]  ^ din[18] ^ din[13];
      dout[24] = din[22] ^ din[12];
      dout[23] = din[21] ^ din[11];
      dout[22] = din[20] ^ din[10];
      dout[21] = din[19] ^ din[9];
      dout[20] = din[18] ^ din[8];
      dout[19] = din[17] ^ din[7];
      dout[18] = din[16] ^ din[6];
      dout[17] = din[15] ^ din[5];
      dout[16] = din[14] ^ din[4];
      dout[15] = din[13] ^ din[3];
      dout[14] = din[12] ^ din[2];
      dout[13] = din[11] ^ din[1];
      dout[12] = din[10] ^ din[0];
      dout[11] = din[9]  ^ din[22] ^ din[17];
      dout[10] = din[8]  ^ din[21] ^ din[16];
      dout[9]  = din[7]  ^ din[20] ^ din[15];
      dout[8]  = din[6]  ^ din[19] ^ din[14];
      dout[7]  = din[5]  ^ din[18] ^ din[13];
      dout[6]  = din[4]  ^ din[17] ^ din[12];
      dout[5]  = din[3]  ^ din[16] ^ din[11];
      dout[4]  = din[2]  ^ din[15] ^ din[10];
      dout[3]  = din[1]  ^ din[14] ^ din[9];
      dout[2]  = din[0]  ^ din[13] ^ din[8];
      dout[1]  = din[22] ^ din[12] ^ din[17] ^ din[7];
      dout[0]  = din[21] ^ din[11] ^ din[16] ^ din[6];
      pn23 = dout;
    end
  endfunction

  // pn sequence selection
  assign adc_data_inv_s = {adc_data[11:0], adc_data[23:12], adc_data[35:24], adc_data[47:36]};
  assign adc_pn_data_pn_s = (adc_pn_oos == 1'b1) ? adc_data_inv_s : adc_pn_data_pn;

  always @(posedge adc_clk) begin
    if(adc_pnseq_sel == 4'b0) begin
      adc_pn_data_pn <= pn9(adc_pn_data_pn_s);
    end else begin
      adc_pn_data_pn <= pn23(adc_pn_data_pn_s);
    end
  end

  // pn oos & pn err
  ad_pnmon #(.DATA_WIDTH(48)) i_pnmon (
    .adc_clk (adc_clk),
    .adc_valid_in (1'b1),
    .adc_data_in (adc_data_inv_s),
    .adc_data_pn (adc_pn_data_pn),
    .adc_pn_oos (adc_pn_oos),
    .adc_pn_err (adc_pn_err));

endmodule
