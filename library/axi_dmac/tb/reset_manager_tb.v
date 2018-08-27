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

module dmac_reset_manager_tb;
  parameter VCD_FILE = {`__FILE__,"cd"};

  `define TIMEOUT 1000000
  `include "tb_base.v"


  reg clk_a = 1'b0;
  reg clk_b = 1'b0;
  reg clk_c = 1'b0;

  reg [5:0] resetn_shift = 'h0;

  reg [10:0] counter = 'h00;

  reg ctrl_enable = 1'b0;
  reg ctrl_pause = 1'b0;

  always #10 clk_a <= ~clk_a;
  always #3 clk_b <= ~clk_b;
  always #7 clk_c <= ~clk_c;

  always @(posedge clk_a) begin
    counter <= counter + 1'b1;
    if (counter == 'h60 || counter == 'h150 || counter == 'h185) begin
      ctrl_enable <= 1'b1;
    end else if (counter == 'h100 || counter == 'h110 || counter == 'h180) begin
      ctrl_enable <= 1'b0;
    end

    if (counter == 'h160) begin
      ctrl_pause = 1'b1;
    end else if (counter == 'h190) begin
      ctrl_pause = 1'b0;
    end
  end

  reg [15:0] req_enabled_shift;
  wire req_enable;
  wire req_enabled = req_enabled_shift[15];

  reg [15:0] dest_enabled_shift;
  wire dest_enable;
  wire dest_enabled = dest_enabled_shift[15];

  reg [15:0] src_enabled_shift;
  wire src_enable;
  wire src_enabled = src_enabled_shift[15];


  always @(posedge clk_a) begin
    req_enabled_shift <= {req_enabled_shift[14:0],req_enable};
  end

  always @(posedge clk_b) begin
    dest_enabled_shift <= {dest_enabled_shift[14:0],dest_enable};
  end

  always @(posedge clk_c) begin
    src_enabled_shift <= {src_enabled_shift[14:0],src_enable};
  end

  axi_dmac_reset_manager i_reset_manager (
    .clk(clk_a),
    .resetn(resetn),

    .ctrl_pause(ctrl_pause),
    .ctrl_enable(ctrl_enable),

    .req_enable(req_enable),
    .req_enabled(req_enabled),

    .dest_clk(clk_b),
    .dest_ext_resetn(1'b0),
    .dest_enable(dest_enable),
    .dest_enabled(dest_enabled),

    .src_clk(clk_c),
    .src_ext_resetn(1'b0),
    .src_enable(src_enable),
    .src_enabled(src_enabled)
  );

endmodule
