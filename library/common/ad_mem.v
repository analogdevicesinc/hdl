// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_mem #(

  parameter       DATA_WIDTH = 16,
  parameter       ADDRESS_WIDTH =  5) (

  input                   clka,
  input                   wea,
  input       [AW:0]      addra,
  input       [DW:0]      dina,

  input                   clkb,
  input       [AW:0]      addrb,
  output  reg [DW:0]      doutb);

  localparam      DW = DATA_WIDTH - 1;
  localparam      AW = ADDRESS_WIDTH - 1;

  (* ram_style = "block" *)
  reg     [DW:0]  m_ram[0:((2**ADDRESS_WIDTH)-1)];

  always @(posedge clka) begin
    if (wea == 1'b1) begin
      m_ram[addra] <= dina;
    end
  end

  always @(posedge clkb) begin
    doutb <= m_ram[addrb];
  end

endmodule

// ***************************************************************************
// ***************************************************************************
