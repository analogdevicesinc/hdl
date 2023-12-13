// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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
// ADC DIGITAL OUTPUT RANDOMIZE DECODE

`timescale 1ns/100ps

module axi_adaq8092_rand_decode (

  // data interface

  input       [27:0]      adc_data,
  input                   adc_clk,
  input                   adc_rand_enb,
  output      [27:0]      adc_data_decoded
);

  // internal register

  reg [27:0] adc_data_decoded_s;

  integer i;

  assign adc_data_decoded = adc_rand_enb ? adc_data_decoded_s : adc_data ;

  // DATA DECODING

  always @(posedge adc_clk) begin
    for (i = 1; i <= 13; i = i + 1) begin
      adc_data_decoded_s[i] = adc_data[i] ^ adc_data[0];
    end
    for (i = 15; i <= 27; i = i + 1) begin
      adc_data_decoded_s[i] = adc_data[i] ^ adc_data[14];
    end

    adc_data_decoded_s[0] = adc_data[0];
    adc_data_decoded_s[14] = adc_data[14];
  end

endmodule
