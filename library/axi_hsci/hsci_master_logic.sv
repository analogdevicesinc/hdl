// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

`timescale 1ps / 1ps

module hsci_master_logic #(
  parameter ADDR_WIDTH = 10,
  parameter DATA_WIDTH = 32
)(
  input                             clk,
  input                             srstn,
  input       [ADDR_WIDTH-1:0]      I_rd_addr,
  input                             I_wr_stb,
  input       [ADDR_WIDTH-1:0]      I_wr_addr,
  input       [DATA_WIDTH-1:0]      I_wr_data,
  output reg  [DATA_WIDTH-1:0]      O_read_data,
  input                             hsci_master_regs_pkg::hsci_master_regs_status_t I,
  output                            hsci_master_regs_pkg::hsci_master_regs_regs_t O
);

  import hsci_master_regs_pkg::*;

  localparam NUM_GT_LANE = 16;

  hsci_master_regs_pkg::hsci_master_regs_status_t     I_int;
  hsci_master_regs_pkg::hsci_master_regs_regs_t       O_int;


  // By default I and O members are passed unmodified to the register map
  // Overrides to the default behaviour are below.
  always_comb begin
    I_int = I;

    // Self-clearing spi_master_run
    I_int.hsci_run.sclr = O.hsci_run.data;
  end

  always_comb begin
    O = O_int;
  end

   // Yoda register map
  hsci_master_regs_regs hsci_master_regs_regs(
    .clk         (clk),
    .srstn       (srstn),
    .I_rd_addr   (I_rd_addr),
    .I_wr_stb    (I_wr_stb),
    .I_wr_addr   (I_wr_addr),
    .I_wr_data   (I_wr_data),
    .O_read_data (O_read_data),
    .I           (I_int),
    .O           (O_int)
   );

endmodule
