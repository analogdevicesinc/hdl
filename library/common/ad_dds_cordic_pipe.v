// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

module ad_dds_cordic_pipe#(

  // parameters

  // Range = N/A
  parameter P_DW = 16,
  // Range = N/A
  parameter D_DW = 16,
  // Range = N/A
  parameter DELAY_DW = 1,
  // Range = 0-(DW - 1)
  parameter SHIFT = 0
) (

  // Interface

                      input                          clk,
  (* keep = "TRUE" *) input                          dir,
  (* keep = "TRUE" *) input             [  D_DW-1:0] dataa_x,
  (* keep = "TRUE" *) input             [  D_DW-1:0] dataa_y,
  (* keep = "TRUE" *) input             [  P_DW-1:0] dataa_z,
  (* keep = "TRUE" *) input             [  P_DW-1:0] datab_z,
  (* keep = "TRUE" *) output reg        [  D_DW-1:0] result_x,
  (* keep = "TRUE" *) output reg        [  D_DW-1:0] result_y,
  (* keep = "TRUE" *) output reg        [  P_DW-1:0] result_z,
                      input             [DELAY_DW:1] data_delay_in,
                      output            [DELAY_DW:1] data_delay_out
);

  // Registers Declarations

  reg   [DELAY_DW:1] data_delay = 'd0;

  // Wires Declarations

  wire  [  D_DW-1:0]  sgn_shift_x;
  wire  [  D_DW-1:0]  sgn_shift_y;
  wire                dir_inv = ~dir;

  // Sign shift

  assign sgn_shift_x = {{SHIFT{dataa_x[D_DW-1]}}, dataa_x[D_DW-1:SHIFT]};
  assign sgn_shift_y = {{SHIFT{dataa_y[D_DW-1]}}, dataa_y[D_DW-1:SHIFT]};

  // Stage rotation

  always @(posedge clk) begin
    result_x <= dataa_x + ({D_DW{dir_inv}} ^ sgn_shift_y) + dir_inv;
    result_y <= dataa_y + ({D_DW{dir}}     ^ sgn_shift_x) + dir;
    result_z <= dataa_z + ({P_DW{dir_inv}} ^     datab_z) + dir_inv;
  end

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
