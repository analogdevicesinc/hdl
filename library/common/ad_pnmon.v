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
// PN monitors

`timescale 1ns/100ps

module ad_pnmon (

  // adc interface

  adc_clk,
  adc_valid_in,
  adc_data_in,
  adc_data_pn,

  // pn out of sync and error

  adc_pn_oos,
  adc_pn_err);

  // parameters

  parameter DATA_WIDTH = 16;
  localparam DW = DATA_WIDTH - 1;

  // adc interface

  input           adc_clk;
  input           adc_valid_in;
  input   [DW:0]  adc_data_in;
  input   [DW:0]  adc_data_pn;

  // pn out of sync and error

  output          adc_pn_oos;
  output          adc_pn_err;

  // internal registers

  reg             adc_valid_d = 'd0;
  reg             adc_pn_match_d = 'd0;
  reg             adc_pn_match_z = 'd0;
  reg             adc_pn_err = 'd0;
  reg             adc_pn_oos = 'd0;
  reg     [ 3:0]  adc_pn_oos_count = 'd0;

  // internal signals

  wire            adc_pn_match_d_s;
  wire            adc_pn_match_z_s;
  wire            adc_pn_match_s;
  wire            adc_pn_update_s;
  wire            adc_pn_err_s;

  // make sure data is not 0, sequence will fail.

  assign adc_pn_match_d_s = (adc_data_in == adc_data_pn) ? 1'b1 : 1'b0;
  assign adc_pn_match_z_s = (adc_data_in == 'd0) ? 1'b0 : 1'b1;
  assign adc_pn_match_s = adc_pn_match_d & adc_pn_match_z;
  assign adc_pn_update_s = ~(adc_pn_oos ^ adc_pn_match_s);
  assign adc_pn_err_s = ~(adc_pn_oos | adc_pn_match_s);

  // pn oos and counters (16 to clear and set).

  always @(posedge adc_clk) begin
    adc_valid_d <= adc_valid_in;
    adc_pn_match_d <= adc_pn_match_d_s;
    adc_pn_match_z <= adc_pn_match_z_s;
    if (adc_valid_d == 1'b1) begin
      adc_pn_err <= adc_pn_err_s;
      if ((adc_pn_update_s == 1'b1) && (adc_pn_oos_count >= 15)) begin
        adc_pn_oos <= ~adc_pn_oos;
      end
      if (adc_pn_update_s == 1'b1) begin
        adc_pn_oos_count <= adc_pn_oos_count + 1'b1;
      end else begin
        adc_pn_oos_count <= 'd0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************

