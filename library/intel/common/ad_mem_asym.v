// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

// Intel-specific asymmetric memory using altera_syncram.
// The write and read memory space must have the same size.
// 2^A_ADDRESS_WIDTH * A_DATA_WIDTH == 2^B_ADDRESS_WIDTH * B_DATA_WIDTH

`timescale 1ns/100ps

module ad_mem_asym #(
  parameter   A_ADDRESS_WIDTH = 8,
  parameter   A_DATA_WIDTH = 256,
  parameter   B_ADDRESS_WIDTH = 10,
  parameter   B_DATA_WIDTH = 64,
  parameter   CASCADE_HEIGHT = 0
) (
  input                             clka,
  input                             wea,
  input       [A_ADDRESS_WIDTH-1:0] addra,
  input       [A_DATA_WIDTH-1:0]    dina,

  input                             clkb,
  input                             reb,
  input       [B_ADDRESS_WIDTH-1:0] addrb,
  output      [B_DATA_WIDTH-1:0]    doutb
);

  localparam NUMWORDS_A = 2**A_ADDRESS_WIDTH;
  localparam NUMWORDS_B = 2**B_ADDRESS_WIDTH;

  altera_syncram #(
    .address_aclr_b         ("NONE"),
    .address_reg_b          ("CLOCK1"),
    .clock_enable_input_a   ("BYPASS"),
    .clock_enable_input_b   ("BYPASS"),
    .clock_enable_output_b  ("BYPASS"),
    .enable_force_to_zero   ("FALSE"),
    .lpm_type               ("altera_syncram"),
    .numwords_a             (NUMWORDS_A),
    .numwords_b             (NUMWORDS_B),
    .operation_mode         ("DUAL_PORT"),
    .outdata_aclr_b         ("NONE"),
    .outdata_sclr_b         ("NONE"),
    .outdata_reg_b          ("UNREGISTERED"),
    .power_up_uninitialized ("FALSE"),
    .rdcontrol_reg_b        ("CLOCK1"),
    .widthad_a              (A_ADDRESS_WIDTH),
    .widthad_b              (B_ADDRESS_WIDTH),
    .width_a                (A_DATA_WIDTH),
    .width_b                (B_DATA_WIDTH),
    .width_byteena_a        (1)
  ) i_mem (
    .address_a      (addra),
    .address_b      (addrb),
    .clock0         (clka),
    .clock1         (clkb),
    .data_a         (dina),
    .rden_b         (reb),
    .wren_a         (wea),
    .q_b            (doutb),
    .aclr0          (1'b0),
    .aclr1          (1'b0),
    .address2_a     (1'b1),
    .address2_b     (1'b1),
    .addressstall_a (1'b0),
    .addressstall_b (1'b0),
    .byteena_a      (1'b1),
    .byteena_b      (1'b1),
    .clocken0       (1'b1),
    .clocken1       (1'b1),
    .clocken2       (1'b1),
    .clocken3       (1'b1),
    .data_b         ({B_DATA_WIDTH{1'b1}}),
    .eccencbypass   (1'b0),
    .eccencparity   (8'b0),
    .eccstatus      (),
    .q_a            (),
    .rden_a         (1'b1),
    .sclr           (1'b0),
    .wren_b         (1'b0)
  );

endmodule
