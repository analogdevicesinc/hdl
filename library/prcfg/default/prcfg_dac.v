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

`timescale 1ns/1ns

module prcfg_dac#(

  parameter   CHANNEL_ID  = 0) (

  input                   clk,

  // control ports
  input       [31:0]      control,
  output      [31:0]      status,

  // FIFO interface
  output  reg             src_dac_enable,
  input       [15:0]      src_dac_data,
  output  reg             src_dac_valid,

  input                   dst_dac_enable,
  output  reg [15:0]      dst_dac_data,
  input                   dst_dac_valid);

  localparam  RP_ID       = 8'hA0;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    src_dac_enable  <= dst_dac_enable;
    dst_dac_data    <= src_dac_data;
    src_dac_valid   <= dst_dac_valid;
  end
endmodule
