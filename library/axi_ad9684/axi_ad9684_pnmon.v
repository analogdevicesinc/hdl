// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad9684_pnmon (

  // adc interface

  input                   adc_clk,
  input       [27:0]      adc_data,

  // pn out of sync and error

  output                  adc_pn_oos,
  output                  adc_pn_err,

  // processor interface PN9 (0x0), PN23 (0x1)

  input       [ 3:0]      adc_pnseq_sel
);

  // internal registers

  reg     [27:0]  adc_pn_data_in = 'd0;
  reg     [27:0]  adc_pn_data_pn = 'd0;

  // internal signals

  wire    [27:0]  adc_pn_data_pn_s;
  wire    [31:0]  adc_pn_data_pn9_s;

  // PN23 function

  function [27:0] pn23;
    input [27:0] din;
    reg   [27:0] dout;
    begin
      dout[27] = din[22] ^ din[17];
      dout[26] = din[21] ^ din[16];
      dout[25] = din[20] ^ din[15];
      dout[24] = din[19] ^ din[14];
      dout[23] = din[18] ^ din[13];
      dout[22] = din[17] ^ din[12];
      dout[21] = din[16] ^ din[11];
      dout[20] = din[15] ^ din[10];
      dout[19] = din[14] ^ din[ 9];
      dout[18] = din[13] ^ din[ 8];
      dout[17] = din[12] ^ din[ 7];
      dout[16] = din[11] ^ din[ 6];
      dout[15] = din[10] ^ din[ 5];
      dout[14] = din[ 9] ^ din[ 4];
      dout[13] = din[ 8] ^ din[ 3];
      dout[12] = din[ 7] ^ din[ 2];
      dout[11] = din[ 6] ^ din[ 1];
      dout[10] = din[ 5] ^ din[ 0];
      dout[ 9] = din[ 4] ^ din[22] ^ din[17];
      dout[ 8] = din[ 3] ^ din[21] ^ din[16];
      dout[ 7] = din[ 2] ^ din[20] ^ din[15];
      dout[ 6] = din[ 1] ^ din[19] ^ din[14];
      dout[ 5] = din[ 0] ^ din[18] ^ din[13];
      dout[ 4] = din[22] ^ din[12];
      dout[ 3] = din[21] ^ din[11];
      dout[ 2] = din[20] ^ din[10];
      dout[ 1] = din[19] ^ din[ 9];
      dout[ 0] = din[18] ^ din[ 8];
      pn23 = dout;
    end
  endfunction

  // PN9 function

  function [31:0] pn9;
    input [27:0] din;
    reg   [31:0] dout;
    begin
      dout[31] = din[ 8] ^ din[ 4];
      dout[30] = din[ 7] ^ din[ 3];
      dout[29] = din[ 6] ^ din[ 2];
      dout[28] = din[ 5] ^ din[ 1];
      dout[27] = din[ 4] ^ din[ 0];
      dout[26] = din[ 3] ^ din[ 8] ^ din[ 4];
      dout[25] = din[ 2] ^ din[ 7] ^ din[ 3];
      dout[24] = din[ 1] ^ din[ 6] ^ din[ 2];
      dout[23] = din[ 0] ^ din[ 5] ^ din[ 1];
      dout[22] = din[ 8] ^ din[ 0];
      dout[21] = din[ 7] ^ din[ 8] ^ din[ 4];
      dout[20] = din[ 6] ^ din[ 7] ^ din[ 3];
      dout[19] = din[ 5] ^ din[ 6] ^ din[ 2];
      dout[18] = din[ 4] ^ din[ 5] ^ din[ 1];
      dout[17] = din[ 3] ^ din[ 4] ^ din[ 0];
      dout[16] = din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[15] = din[ 1] ^ din[ 2] ^ din[ 7] ^ din[ 3];
      dout[14] = din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[13] = din[ 8] ^ din[ 0] ^ din[ 5] ^ din[ 1] ^ din[ 4];
      dout[12] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 0];
      dout[11] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 8] ^ din[ 4];
      dout[10] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[ 9] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[ 8] = din[ 3] ^ din[ 8] ^ din[ 5] ^ din[ 1];
      dout[ 7] = din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 0];
      dout[ 6] = din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 4];
      dout[ 5] = din[ 0] ^ din[ 2] ^ din[ 5] ^ din[ 7] ^ din[ 3];
      dout[ 4] = din[ 8] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[ 3] = din[ 7] ^ din[ 0] ^ din[ 5] ^ din[ 1];
      dout[ 2] = din[ 6] ^ din[ 8] ^ din[ 0];
      dout[ 1] = din[ 5] ^ din[ 7] ^ din[ 8] ^ din[ 4];
      dout[ 0] = din[ 4] ^ din[ 6] ^ din[ 7] ^ din[ 3];
      pn9 = dout;
    end
  endfunction

  // pn sequence select

  assign adc_pn_data_pn_s = (adc_pn_oos == 1'b1) ? adc_pn_data_in : adc_pn_data_pn;
  assign adc_pn_data_pn9_s = pn9(adc_pn_data_pn_s);

  always @(posedge adc_clk) begin
    adc_pn_data_in <= { ~adc_data[13], adc_data[12: 0],
                        ~adc_data[27], adc_data[26:14]};
    if (adc_pnseq_sel == 4'd0) begin
      adc_pn_data_pn <= {adc_pn_data_pn9_s[29:16], adc_pn_data_pn9_s[13:0]};
    end else begin
      adc_pn_data_pn <= pn23(adc_pn_data_pn_s);
    end
  end

  // pn oos & pn err

  ad_pnmon #(
    .DATA_WIDTH(28)
  ) i_pnmon (
    .adc_clk (adc_clk),
    .adc_valid_in (1'b1),
    .adc_data_in (adc_pn_data_in),
    .adc_data_pn (adc_pn_data_pn),
    .adc_pn_oos (adc_pn_oos),
    .adc_pn_err (adc_pn_err));

endmodule
