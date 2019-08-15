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

module util_tia_chsel #(

  parameter DATA_WIDTH = 32) (

  input                        clk,

  input                        adc_tia_chsel_en,
  output      [DATA_WIDTH-1:0] adc_data_tia_chsel,

  input       [ 7:0]           tia_chsel);

  (* keep = "TRUE" *)reg         [DATA_WIDTH-1:0] adc_data_tia_chsel_int;

  genvar i;
  generate
    for (i=0; i<DATA_WIDTH/16; i=i+1) begin : gen_tia_chsel_samples
      always @(posedge clk) begin
        if (adc_tia_chsel_en)
          adc_data_tia_chsel_int[i*16+:16] <= {8'h0, tia_chsel};
      end
    end
  endgenerate
  assign adc_data_tia_chsel = adc_data_tia_chsel_int;

endmodule
