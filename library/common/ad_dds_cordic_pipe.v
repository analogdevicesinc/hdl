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
// freedoms and responsabilities that he or she has by using this source/core.
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

module ad_dds_cordic_pipe#(

  // parameters

  // Range = N/A
  parameter DW = 16,
  // Range = N/A
  parameter DELAY_DW = 1,
  // Range = 0-(DW - 1)
  parameter SHIFT = 0) (

  // Interface

                      input                          clk,
  (* keep = "TRUE" *) input                          dir,
  (* keep = "TRUE" *) input             [    DW-1:0] dataa_x,
  (* keep = "TRUE" *) input             [    DW-1:0] dataa_y,
  (* keep = "TRUE" *) input             [    DW-1:0] dataa_z,
  (* keep = "TRUE" *) input             [    DW-1:0] datab_x,
  (* keep = "TRUE" *) input             [    DW-1:0] datab_y,
  (* keep = "TRUE" *) input             [    DW-1:0] datab_z,
  (* keep = "TRUE" *) output reg        [    DW-1:0] result_x,
  (* keep = "TRUE" *) output reg        [    DW-1:0] result_y,
  (* keep = "TRUE" *) output reg        [    DW-1:0] result_z,
                      output     signed [    DW-1:0] sgn_shift_x,
                      output     signed [    DW-1:0] sgn_shift_y,
                      input             [DELAY_DW:1] data_delay_in,
                      output            [DELAY_DW:1] data_delay_out);

  // Registers Declarations

  reg   [DELAY_DW:1] data_delay = 'd0;

  // Wires Declarations

  wire dir_inv = ~dir;

  // Stage rotation

  always @(posedge clk) begin
    result_x <= dataa_x + ({DW{dir_inv}} ^ datab_y) + dir_inv;
    result_y <= dataa_y + ({DW{dir}}     ^ datab_x) + dir;
    result_z <= dataa_z + ({DW{dir_inv}} ^ datab_z) + dir_inv;
  end

  // Stage shift

  assign sgn_shift_x = {{SHIFT{result_x[DW-1]}}, result_x[DW-1:SHIFT]};
  assign sgn_shift_y = {{SHIFT{result_y[DW-1]}}, result_y[DW-1:SHIFT]};

  // Delay data (if used)

  generate
    if (DELAY_DW > 1) begin
      always @(posedge clk) begin
        data_delay <= data_delay_in;
      end
    end
  endgenerate

  assign data_delay_out = data_delay;

endmodule
