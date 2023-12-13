// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns / 1ps

module sysid_rom #(
  parameter ROM_WIDTH = 32,
  parameter ROM_ADDR_BITS = 6,
  parameter PATH_TO_FILE = "path_to_mem_init_file"
) (
  input                             clk,
  input        [ROM_ADDR_BITS-1:0]  rom_addr,
  output  reg  [ROM_WIDTH-1:0]      rom_data
);

  reg [ROM_WIDTH-1:0] lut_rom [(2**ROM_ADDR_BITS)-1:0];

  initial begin
    $readmemh(PATH_TO_FILE, lut_rom, 0, (2**ROM_ADDR_BITS)-1);
  end

  always @(posedge clk) begin
    rom_data = lut_rom[rom_addr];
  end

endmodule
