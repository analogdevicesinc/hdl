// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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

module util_extract #(

  parameter  NUM_OF_CHANNELS = 2,
  parameter  DATA_WIDTH = NUM_OF_CHANNELS * 16
) (
  input                         clk,

  input       [DATA_WIDTH-1:0]  data_in,
  input       [DATA_WIDTH-1:0]  data_in_trigger,
  input                         data_valid,

  output      [DATA_WIDTH-1:0]  data_out,
  output reg                    valid_out,
  output reg                    trigger_out
);

  // loop variables

  genvar  n;

  reg trigger_d1;

  wire [15:0] trigger; // 16 maximum channels

  generate
  for (n = 0; n < NUM_OF_CHANNELS; n = n + 1) begin: g_data_out
    assign data_out[(n+1)*16-1:n*16] = {data_in[(n*16)+14],data_in[(n*16)+14:n*16]};
    assign trigger[n] = data_in_trigger[(16*n)+15];
  end
  for (n = NUM_OF_CHANNELS; n < 16; n = n + 1) begin: g_trigger_out
    assign trigger[n] = 1'b0;
  end
  endgenerate

  // compensate delay in the FIFO
  always @(posedge clk) begin
    valid_out  <= data_valid;
    if (data_valid == 1'b1) begin
      trigger_d1  <= |trigger;
      trigger_out <= trigger_d1;
    end
  end

endmodule
