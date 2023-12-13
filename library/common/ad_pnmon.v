// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module ad_pnmon #(

  parameter DATA_WIDTH = 16,
  parameter OOS_THRESHOLD = 16,
  parameter ALLOW_ZERO_MASKING = 0
) (

  // adc interface

  input                       adc_clk,
  input                       adc_valid_in,
  input   [(DATA_WIDTH-1):0]  adc_data_in,
  input   [(DATA_WIDTH-1):0]  adc_data_pn,

  input                       adc_pattern_has_zero,

  // pn out of sync and error

  output                      adc_pn_oos,
  output                      adc_pn_err
);

  localparam CNT_W = $clog2(OOS_THRESHOLD);

  // internal registers

  reg                         adc_valid_d = 'd0;
  reg                         adc_pn_match_d = 'd0;
  reg                         adc_pn_match_z = 'd0;
  reg                         adc_pn_oos_int = 'd0;
  reg                         adc_pn_err_int = 'd0;
  reg  [CNT_W-1:0]            adc_pn_oos_count = 'd0;
  reg                         adc_valid_zero_d = 'b0;

  // internal signals

  wire                        adc_pn_match_d_s;
  wire                        adc_pn_match_z_s;
  wire                        adc_pn_match_s;
  wire                        adc_pn_update_s;
  wire                        adc_pn_err_s;
  wire                        adc_valid_zero;

  // make sure data is not 0, sequence will fail.

  assign adc_pn_match_d_s = (adc_data_in == adc_data_pn) ? 1'b1 : 1'b0;
  assign adc_pn_match_z_s = (adc_data_in == 'd0) ? 1'b1 : 1'b0;
  assign adc_pn_match_s = adc_pn_match_d & ~adc_pn_match_z;
  assign adc_pn_update_s = ~(adc_pn_oos_int ^ adc_pn_match_s);

  // Ignore sporadic zeros in middle of pattern if not out of sync
  // but OOS_THRESHOLD consecutive zeros would assert out of sync.
  assign adc_valid_zero = ALLOW_ZERO_MASKING & adc_pattern_has_zero &
                          ~adc_pn_oos_int & adc_pn_match_z_s;
  assign adc_pn_err_s = ~(adc_pn_oos_int | adc_pn_match_s | adc_valid_zero_d);

  // pn oos and counters (16 to clear and set).

  assign adc_pn_oos = adc_pn_oos_int;
  assign adc_pn_err = adc_pn_err_int;

  always @(posedge adc_clk) begin
    adc_valid_d <= adc_valid_in;
    adc_pn_match_d <= adc_pn_match_d_s;
    adc_pn_match_z <= adc_pn_match_z_s;
    adc_valid_zero_d <= adc_valid_zero;
    if (adc_valid_d == 1'b1) begin
      adc_pn_err_int <= adc_pn_err_s;
      if ((adc_pn_update_s == 1'b1) && (adc_pn_oos_count >= OOS_THRESHOLD-1)) begin
        adc_pn_oos_int <= ~adc_pn_oos_int;
      end
      if (adc_pn_update_s == 1'b1) begin
        adc_pn_oos_count <= adc_pn_oos_count + 1'b1;
      end else begin
        adc_pn_oos_count <= 'd0;
      end
    end
  end

endmodule
