// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

// A simple asymetric memory. The write and read memory space must have the same size.
// 2^A_ADDRESS_WIDTH * A_DATA_WIDTH == 2^B_ADDRESS_WIDTH * B_DATA_WIDTH

`timescale 1ns/100ps

module ad_mem_asym #(

  parameter   A_ADDRESS_WIDTH =  8,
  parameter   A_DATA_WIDTH = 256,
  parameter   B_ADDRESS_WIDTH =   10,
  parameter   B_DATA_WIDTH =  64,
  parameter   CASCADE_HEIGHT = -1
) (
  input                             clka,
  input                             wea,
  input       [A_ADDRESS_WIDTH-1:0] addra,
  input       [A_DATA_WIDTH-1:0]    dina,

  input                             clkb,
  input                             reb,
  input       [B_ADDRESS_WIDTH-1:0] addrb,
  output  reg [B_DATA_WIDTH-1:0]    doutb
);

  `define max(a,b) {(a) > (b) ? (a) : (b)}
  `define min(a,b) {(a) < (b) ? (a) : (b)}

  function integer clog2;
    input integer value;
    begin
      if (value < 2)
        clog2 = value;
      else begin
        value = value - 1;
        for (clog2 = 0; value > 0; clog2 = clog2 + 1)
          value = value >> 1;
      end
    end
  endfunction

  localparam  MEM_ADDRESS_WIDTH = `max(A_ADDRESS_WIDTH, B_ADDRESS_WIDTH);
  localparam  MIN_WIDTH = `min(A_DATA_WIDTH, B_DATA_WIDTH);
  localparam  MAX_WIDTH = `max(A_DATA_WIDTH, B_DATA_WIDTH);
  localparam  MEM_DATA_WIDTH = MIN_WIDTH;
  localparam  MEM_SIZE = 2 ** MEM_ADDRESS_WIDTH;
  localparam  MEM_RATIO = MAX_WIDTH / MIN_WIDTH;
  localparam  MEM_RATIO_LOG2 = clog2(MEM_RATIO);

  // internal registers

  (* ram_style = "block", cascade_height = CASCADE_HEIGHT *)
  reg      [MEM_DATA_WIDTH-1:0]    m_ram[0:MEM_SIZE-1];

  //---------------------------------------------------------------------------
  // write interface
  //---------------------------------------------------------------------------

  // write data width is narrower than read data width
  generate if (A_DATA_WIDTH <= B_DATA_WIDTH) begin
    always @(posedge clka) begin
      if (wea == 1'b1) begin
        m_ram[addra] <= dina;
      end
    end
  end
  endgenerate

  // write data width is wider than read data width
  generate if (A_DATA_WIDTH > B_DATA_WIDTH) begin
    always @(posedge clka) begin : memwrite
      integer i;
      reg [MEM_RATIO_LOG2-1:0] lsb;
      for (i = 0; i < MEM_RATIO; i = i + 1) begin : awrite
        lsb = i;
        if (wea) begin
          m_ram[{addra, lsb}] <= dina[i * MIN_WIDTH +: MIN_WIDTH];
        end
      end
    end
  end
  endgenerate

  //---------------------------------------------------------------------------
  // read interface
  //---------------------------------------------------------------------------

  // read data width is narrower than write data width
  generate if (A_DATA_WIDTH >= B_DATA_WIDTH) begin
    always @(posedge clkb) begin
      if (reb == 1'b1) begin
        doutb <= m_ram[addrb];
      end
    end
  end
  endgenerate

  // read data width is wider than write data width
  generate if (A_DATA_WIDTH < B_DATA_WIDTH) begin
    always @(posedge clkb) begin : memread
      integer i;
      reg [MEM_RATIO_LOG2-1:0] lsb;
      for (i = 0; i < MEM_RATIO; i = i + 1) begin : aread
        lsb = i;
        if (reb == 1'b1) begin
          doutb[i*MIN_WIDTH +: MIN_WIDTH] <= m_ram[{addrb, lsb}];
        end
      end
    end
  end
  endgenerate

endmodule
