// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory of
//      the repository (LICENSE_GPL2), and at: <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// PN monitors

`timescale 1ns/100ps

module axi_ad9643_pnmon (

  // adc interface

  input                   adc_clk,
  input       [13:0]      adc_data,

  // pn out of sync and error

  output                  adc_pn_oos,
  output                  adc_pn_err,
  input       [ 3:0]      adc_pnseq_sel);

  // internal registers

  reg             adc_valid_in = 'd0;
  reg     [27:0]  adc_pn_data_in = 'd0;
  reg     [29:0]  adc_pn_data_pn = 'd0;

  // internal signals

  wire    [27:0]  adc_pn_data_in_s;
  wire    [29:0]  adc_pn_data_pn_s;

  // PN23 function

  function [29:0] pn23;
    input [29:0] din;
    reg   [29:0] dout;
    begin
      dout[29] = din[22] ^ din[17];
      dout[28] = din[21] ^ din[16];
      dout[27] = din[20] ^ din[15];
      dout[26] = din[19] ^ din[14];
      dout[25] = din[18] ^ din[13];
      dout[24] = din[17] ^ din[12];
      dout[23] = din[16] ^ din[11];
      dout[22] = din[15] ^ din[10];
      dout[21] = din[14] ^ din[ 9];
      dout[20] = din[13] ^ din[ 8];
      dout[19] = din[12] ^ din[ 7];
      dout[18] = din[11] ^ din[ 6];
      dout[17] = din[10] ^ din[ 5];
      dout[16] = din[ 9] ^ din[ 4];
      dout[15] = din[ 8] ^ din[ 3];
      dout[14] = din[ 7] ^ din[ 2];
      dout[13] = din[ 6] ^ din[ 1];
      dout[12] = din[ 5] ^ din[ 0];
      dout[11] = din[ 4] ^ din[22] ^ din[17];
      dout[10] = din[ 3] ^ din[21] ^ din[16];
      dout[ 9] = din[ 2] ^ din[20] ^ din[15];
      dout[ 8] = din[ 1] ^ din[19] ^ din[14];
      dout[ 7] = din[ 0] ^ din[18] ^ din[13];
      dout[ 6] = din[22] ^ din[12];
      dout[ 5] = din[21] ^ din[11];
      dout[ 4] = din[20] ^ din[10];
      dout[ 3] = din[19] ^ din[ 9];
      dout[ 2] = din[18] ^ din[ 8];
      dout[ 1] = din[17] ^ din[ 7];
      dout[ 0] = din[16] ^ din[ 6];
      pn23 = dout;
    end
  endfunction

  // PN9 function

  function [29:0] pn9;
    input [29:0] din;
    reg   [29:0] dout;
    begin
      dout[29] = din[ 8] ^ din[ 4];
      dout[28] = din[ 7] ^ din[ 3];
      dout[27] = din[ 6] ^ din[ 2];
      dout[26] = din[ 5] ^ din[ 1];
      dout[25] = din[ 4] ^ din[ 0];
      dout[24] = din[ 3] ^ din[ 8] ^ din[ 4];
      dout[23] = din[ 2] ^ din[ 7] ^ din[ 3];
      dout[22] = din[ 1] ^ din[ 6] ^ din[ 2];
      dout[21] = din[ 0] ^ din[ 5] ^ din[ 1];
      dout[20] = din[ 8] ^ din[ 0];
      dout[19] = din[ 7] ^ din[ 8] ^ din[ 4];
      dout[18] = din[ 6] ^ din[ 7] ^ din[ 3];
      dout[17] = din[ 5] ^ din[ 6] ^ din[ 2];
      dout[16] = din[ 4] ^ din[ 5] ^ din[ 1];
      dout[15] = din[ 3] ^ din[ 4] ^ din[ 0];
      dout[14] = din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[13] = din[ 1] ^ din[ 2] ^ din[ 7] ^ din[ 3];
      dout[12] = din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[11] = din[ 8] ^ din[ 0] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[10] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 0];
      dout[ 9] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 8] ^ din[ 4];
      dout[ 8] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[ 7] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[ 6] = din[ 3] ^ din[ 8] ^ din[ 5] ^ din[ 1];
      dout[ 5] = din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 0];
      dout[ 4] = din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 4];
      dout[ 3] = din[ 0] ^ din[ 2] ^ din[ 5] ^ din[ 7] ^ din[ 3];
      dout[ 2] = din[ 8] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[ 1] = din[ 7] ^ din[ 0] ^ din[ 5] ^ din[ 1];
      dout[ 0] = din[ 6] ^ din[ 8] ^ din[ 0];
      pn9 = dout;
    end
  endfunction

  // pn sequence select

  assign adc_pn_data_in_s = {adc_pn_data_in[13:0], ~adc_data[13], adc_data[12:0]};
  assign adc_pn_data_pn_s = (adc_pn_oos == 1'b0) ? adc_pn_data_pn :
                            { adc_pn_data_pn[29], adc_pn_data_in[27:14],
                              adc_pn_data_pn[14], adc_pn_data_in[13: 0]};

  always @(posedge adc_clk) begin
    adc_valid_in <= ~adc_valid_in;
    adc_pn_data_in <= adc_pn_data_in_s;
    if (adc_valid_in == 1'b1) begin
      if (adc_pnseq_sel == 4'd0) begin
        adc_pn_data_pn <= pn9(adc_pn_data_pn_s);
      end else begin
        adc_pn_data_pn <= pn23(adc_pn_data_pn_s);
      end
    end
  end

  // pn oos & pn err

  ad_pnmon #(.DATA_WIDTH(30)) i_pnmon (
    .adc_clk (adc_clk),
    .adc_valid_in (adc_valid_in),
    .adc_data_in ({ adc_pn_data_pn[29], adc_pn_data_in[27:14],
                    adc_pn_data_pn[14], adc_pn_data_in[13: 0]}),
    .adc_data_pn (adc_pn_data_pn),
    .adc_pn_oos (adc_pn_oos),
    .adc_pn_err (adc_pn_err));

endmodule

// ***************************************************************************
// ***************************************************************************

