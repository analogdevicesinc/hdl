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

// A simple asymetric memory. The write and read memory space must have the same size.
// 2^A_ADDRESS_WIDTH * A_DATA_WIDTH == 2^B_ADDRESS_WIDTH * B_DATA_WIDTH

`timescale 1ns/100ps

module ad_mem_asym #(

  // parameters

  parameter   A_ADDRESS_WIDTH =  8,
  parameter   A_DATA_WIDTH = 256,
  parameter   B_ADDRESS_WIDTH =   10,
  parameter   B_DATA_WIDTH =  64) (

  // write interface

  input                           clka,
  input                           wea,
  input   [A_ADDRESS_WIDTH-1:0]   addra,
  input   [A_DATA_WIDTH-1:0]      dina,

  // read interface

  input                           clkb,
  input   [B_ADDRESS_WIDTH-1:0]   addrb,
  output  [B_DATA_WIDTH-1:0]      doutb);

  // broken altera-hdl-inference, direct instantiation

  altera_syncram #(
    .lpm_type ("altera_syncram"),
    .operation_mode ("DUAL_PORT"),
    .ram_block_type ("M20K"),
    .widthad_a (A_ADDRESS_WIDTH),
    .width_a (A_DATA_WIDTH),
    .numwords_a (2**A_ADDRESS_WIDTH),
    .widthad_b (B_ADDRESS_WIDTH),
    .width_b (B_DATA_WIDTH),
    .numwords_b (2**B_ADDRESS_WIDTH),
    .intended_device_family ("Arria 10"),
    .clock_enable_input_a ("BYPASS"),
    .clock_enable_input_b ("BYPASS"),
    .clock_enable_output_b ("BYPASS"),
    .address_aclr_b ("NONE"),
    .outdata_aclr_b ("NONE"),
    .outdata_sclr_b ("NONE"),
    .address_reg_b ("CLOCK1"),
    .outdata_reg_b ("CLOCK1"),
    .power_up_uninitialized ("FALSE"),
    .width_byteena_a (1))
  i_alt_mem (
    .aclr0 (1'b0),
    .clock0 (clka),
    .address_a (addra),
    .wren_a (wea),
    .data_a (dina),
    .rden_a (1'b1),
    .q_a (),
    .aclr1 (1'b0),
    .clock1 (clkb),
    .address_b (addrb),
    .wren_b (1'b0),
    .data_b ({B_DATA_WIDTH{1'd0}}),
    .rden_b (1'b1),
    .q_b (doutb),
    .address2_a (1'b1),
    .address2_b (1'b1),
    .addressstall_a (1'b0),
    .addressstall_b (1'b0),
    .byteena_a (1'b1),
    .byteena_b (1'b1),
    .clocken0 (1'b1),
    .clocken1 (1'b1),
    .clocken2 (1'b1),
    .clocken3 (1'b1),
    .eccencbypass (1'b0),
    .eccencparity (8'b0),
    .eccstatus (),
    .sclr (1'b0));

endmodule

// ***************************************************************************
// ***************************************************************************
