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

module axi_dacfifo_address_buffer #(

  parameter ADDRESS_WIDTH = 4,
  parameter DATA_WIDTH = 16)(

  input                         clk,
  input                         rst,
  input                         wea,
  input      [DATA_WIDTH-1:0]   din,

  input                         rea,
  output     [DATA_WIDTH-1:0]   dout);

  reg   [ADDRESS_WIDTH-1:0]     waddr;
  reg   [ADDRESS_WIDTH-1:0]     raddr;


  always @(posedge clk) begin
    if (rst == 1'b1) begin
      waddr <= 0;
      raddr <= 0;
    end else begin
      waddr <= (wea == 1'b1) ? waddr + 1'b1 : waddr;
      raddr <= (rea == 1'b1) ? raddr + 1'b1 : raddr;
    end
  end

  ad_mem #(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDRESS_WIDTH (ADDRESS_WIDTH))
  i_mem (
    .clka (clk),
    .wea (wea),
    .addra (waddr),
    .dina (din),
    .clkb (clk),
    .reb (1'b1),
    .addrb (raddr),
    .doutb (dout));

endmodule

