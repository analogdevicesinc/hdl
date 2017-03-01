// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
    .data_b ('d0),
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
