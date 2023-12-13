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

`timescale 1ns/100ps

module avl_adxcvr_octet_swap #(
  parameter NUM_OF_LANES = 1
) (
  input clk,
  input reset,

  input in_valid,
  output in_ready,
  input [NUM_OF_LANES*32-1:0] in_data,
  input [3:0] in_sof,

  output out_valid,
  input out_ready,
  output [NUM_OF_LANES*32-1:0] out_data,
  output [3:0] out_sof
);

  assign in_ready = out_ready;
  assign out_valid = in_valid;

  generate
    genvar i;
    genvar j;

    for (j = 0; j < 4; j = j + 1) begin: gen_octet
      for (i = 0; i < NUM_OF_LANES; i = i + 1) begin: gen_lane
        assign out_data[i*32+j*8+7:i*32+j*8] = in_data[i*32+(3-j)*8+7:i*32+(3-j)*8];
      end
      assign out_sof[j] = in_sof[3-j];
    end
  endgenerate

endmodule
