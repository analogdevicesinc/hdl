// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module bitslip (
  input             clk,
  input             reset,

  input             bitslip,
  input      [65:0] data_in,

  output            bitslip_done,
  output reg [65:0] data_out
);

  reg  [65:0] buff_r;
  reg  [ 6:0] shift_cnt;
  reg  [ 3:0] bitslip_sleep;
  wire [65:0] ignore;
  wire [65:0] data_shifted;
  wire        bitslip_s;

  always @(posedge clk) begin
    buff_r <= data_in;
  end

  always @(posedge clk) begin
    if (reset) begin
      bitslip_sleep <= 'd0;
    end else if (~bitslip_sleep[3]) begin
      bitslip_sleep <= bitslip_sleep + 1'b1;
    end else if (bitslip && bitslip_sleep[3]) begin
      bitslip_sleep <= 'd0;
    end
  end

  assign bitslip_s = bitslip & bitslip_sleep[3];

  always @(posedge clk) begin
    if (reset) begin
      shift_cnt <= 'd0;
    end else if (bitslip_s) begin
      if (shift_cnt >= 65) begin
        shift_cnt <= 'd0;
      end else begin
        shift_cnt <= shift_cnt + 1'b1;
      end
    end
  end

  assign {ignore, data_shifted} = {data_in, buff_r} >> shift_cnt;

  always @(posedge clk) begin
    data_out <= data_shifted;
  end

  assign bitslip_done = ~bitslip_sleep[3];

endmodule
