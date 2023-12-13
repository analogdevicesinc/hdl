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
// dc filter- y(n) = c*x(n) + (1-c)*y(n-1)
// NOT IMPLEMENTED

`timescale 1ps/1ps

module ad_dcfilter #(

  // data path disable

  parameter   DISABLE = 0
) (

  // data interface

  input               clk,
  input               valid,
  input       [15:0]  data,
  output reg          valid_out,
  output reg  [15:0]  data_out,

  // control interface

  input           dcfilt_enb,
  input   [15:0]  dcfilt_coeff,
  input   [15:0]  dcfilt_offset
);

  // internal registers

  reg             valid_d = 'd0;
  reg     [15:0]  data_d = 'd0;
  reg             valid_2d = 'd0;
  reg     [15:0]  data_2d = 'd0;

  // internal signals

  wire    [47:0]  dc_offset_s;

  always @(posedge clk) begin
    valid_d <= valid;
    if (valid == 1'b1) begin
      data_d <= data + dcfilt_offset;
    end
    valid_2d <= valid_d;
    data_2d  <= data_d;
    valid_out <= valid_2d;
    data_out  <= data_2d;
  end

endmodule
