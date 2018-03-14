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

`timescale 1ns/100ps

module ad_adl5904_rst (

  input           sys_cpu_clk,
  input           rf_peak_det_n,
  output          rf_peak_rst);

  // internal registers

  reg             rf_peak_det_n_d = 'd0;
  reg             rf_peak_det_enb_d = 'd0;
  reg             rf_peak_rst_enb = 'd0;
  reg             rf_peak_rst_int = 'd0;

  // internal signals

  wire            rf_peak_det_enb_s;
  wire            rf_peak_rst_1_s;
  wire            rf_peak_rst_0_s;

  // adl5904 input protection

  assign rf_peak_rst = rf_peak_rst_int;
  assign rf_peak_det_enb_s = ~(rf_peak_det_n_d & rf_peak_det_n);
  assign rf_peak_rst_1_s = ~rf_peak_det_enb_d & rf_peak_det_enb_s;
  assign rf_peak_rst_0_s = rf_peak_det_enb_d & ~rf_peak_det_enb_s;

  always @(posedge sys_cpu_clk) begin
    rf_peak_det_n_d <= rf_peak_det_n;
    rf_peak_det_enb_d <= rf_peak_det_enb_s;
    if (rf_peak_rst_1_s == 1'b1) begin
      rf_peak_rst_enb <= 1'b1;
    end else if (rf_peak_rst_0_s == 1'b1) begin
      rf_peak_rst_enb <= 1'b0;
    end
    rf_peak_rst_int = ~rf_peak_rst_int & rf_peak_rst_enb;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
