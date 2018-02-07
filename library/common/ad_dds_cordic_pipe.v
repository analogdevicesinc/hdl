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

  parameter DW = 16,
  parameter DELAY_DW = 1,
  parameter SHIFT = 0) (

  // interface

                      input                            clk,
  (* keep = "TRUE" *) input                            dir,
  (* keep = "TRUE" *) input      signed [    DW-1:0] dataa_x,
  (* keep = "TRUE" *) input      signed [    DW-1:0] dataa_y,
  (* keep = "TRUE" *) input      signed [    DW-1:0] dataa_z,
  (* keep = "TRUE" *) input      signed [    DW-1:0] datab_x,
  (* keep = "TRUE" *) input      signed [    DW-1:0] datab_y,
  (* keep = "TRUE" *) input      signed [    DW-1:0] datab_z,
  (* keep = "TRUE" *) output reg signed [    DW-1:0] result_x,
  (* keep = "TRUE" *) output reg signed [    DW-1:0] result_y,
  (* keep = "TRUE" *) output reg signed [    DW-1:0] result_z,
                      output     signed [    DW-1:0] sgn_shift_x,
                      output     signed [    DW-1:0] sgn_shift_y,
                      input             [DELAY_DW:1] data_delay_in,
                      output            [DELAY_DW:1] data_delay_out
  );

  // internal registers

  reg   [DELAY_DW:1] data_delay = 'd0;

  // stage rotation

  always @(posedge clk)
    begin
    case(dir)
      1'b0: begin
        result_x <= dataa_x - datab_y;
        result_y <= dataa_y + datab_x;
        result_z <= dataa_z - datab_z;
      end
      1'b1: begin
        result_x <= dataa_x + datab_y;
        result_y <= dataa_y - datab_x;
        result_z <= dataa_z + datab_z;
      end
    endcase
  end

  // stage shift

  assign sgn_shift_x = result_x >>> SHIFT + 1;
  assign sgn_shift_y = result_y >>> SHIFT + 1;

  generate
    if (DELAY_DW > 1) begin
      always @(posedge clk)
      begin
        data_delay <= data_delay_in;
      end
    end
  endgenerate

  assign data_delay_out = data_delay;

endmodule