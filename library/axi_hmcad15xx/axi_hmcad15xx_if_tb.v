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

`timescale 1ns/100ps

module axi_hmcad15xx_if_tb;
  parameter VCD_FILE = "axi_hmcad15xx_if_tb.vcd";

  `define TIMEOUT 9000
  `include "../common/tb/tb_base.v"

   wire [7:0] adc_data_0;
   wire [7:0] adc_data_1;
   wire [7:0] adc_data_2;
   wire [7:0] adc_data_3;


  reg              clk_in_p        = 1'b0;
  reg              clk_in_n        = 1'b0;

  reg             fclk_p        = 1'b0;
  reg             fclk_n        = 1'b0;

  reg [7:0]   data_in_p = 'b0;
  reg [7:0]   data_in_n = 'b0;



  always #2 clk_in_p <= ~clk_in_p;
  always    clk_in_n <= ~clk_in_p;
  always #8 fclk_p <= ~fclk_p;
  always    fclk_n <= ~fclk_p;

  initial begin


  end

  // data is circullary shifted at every sampling edge

  axi_hmcad15xx_if # (
    .NUM_CHANNELS(4)
  )
  axi_hmcad15xx_if_inst (
    .clk_in_p(clk_in_p),
    .clk_in_n(clk_in_n),
    .fclk_p(fclk_p),
    .fclk_n(fclk_n),
    .data_in_p(data_in_p),
    .data_in_n(data_in_n),
    .adc_clk(adc_clk),
    .adc_valid(adc_valid),
    .adc_data_0(adc_data_0),
    .adc_data_1(adc_data_1),
    .adc_data_2(adc_data_2),
    .adc_data_3(adc_data_3),
    .up_clk(up_clk),
    .up_dld(up_dld),
    .up_dwdata(up_dwdata),
    .up_drdata(up_drdata),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked)
  );

endmodule
