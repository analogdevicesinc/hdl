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

// A simple asymetric memory. The write and read memory space must have the same size.
// 2^A_ADDRESS_WIDTH * A_DATA_WIDTH == 2^B_ADDRESS_WIDTH * B_DATA_WIDTH

`timescale 1ns/100ps

module ad_mem_asym #(

  parameter   A_ADDRESS_WIDTH =  8,
  parameter   A_DATA_WIDTH = 256,
  parameter   B_ADDRESS_WIDTH =   10,
  parameter   B_DATA_WIDTH =  64) (

  input                   clka,
  input                   wea,
  input       [A_ADDRESS_WIDTH-1:0]  addra,
  input       [A_DATA_WIDTH-1:0]  dina,

  input                   clkb,
  input       [B_ADDRESS_WIDTH-1:0]  addrb,
  output  reg [B_DATA_WIDTH-1:0]  doutb);


  localparam  MEM_ADDRESS_WIDTH = (A_ADDRESS_WIDTH > B_ADDRESS_WIDTH) ? A_ADDRESS_WIDTH : B_ADDRESS_WIDTH;
  localparam  MEM_DATA_WIDTH = (A_DATA_WIDTH > B_DATA_WIDTH) ? B_DATA_WIDTH : A_DATA_WIDTH;
  localparam  MEM_SIZE = 2 ** MEM_ADDRESS_WIDTH;
  localparam  MEM_RATIO = (A_DATA_WIDTH > B_DATA_WIDTH) ? A_DATA_WIDTH/B_DATA_WIDTH : B_DATA_WIDTH/A_DATA_WIDTH;
  localparam  MEM_IO_COMP = (A_DATA_WIDTH > B_DATA_WIDTH) ? 1'b1 : 1'b0;

  // internal registers

  reg     [MEM_DATA_WIDTH-1:0]    m_ram[0:MEM_SIZE-1];

  // write interface options

  generate if (MEM_IO_COMP == 0) begin
    always @(posedge clka) begin
      if (wea == 1'b1) begin
        m_ram[addra] <= dina;
      end
    end
  end
  endgenerate

  generate if ((MEM_IO_COMP == 1) && (MEM_RATIO == 2)) begin
    always @(posedge clka) begin
      if (wea == 1'b1) begin
        m_ram[{addra, 1'd0}] <= dina[((1*B_DATA_WIDTH)-1):(B_DATA_WIDTH*0)];
        m_ram[{addra, 1'd1}] <= dina[((2*B_DATA_WIDTH)-1):(B_DATA_WIDTH*1)];
      end
    end
  end
  endgenerate

  generate if ((MEM_IO_COMP == 1) && (MEM_RATIO == 4)) begin
    always @(posedge clka) begin
      if (wea == 1'b1) begin
        m_ram[{addra, 2'd0}] <= dina[((1*B_DATA_WIDTH)-1):(B_DATA_WIDTH*0)];
        m_ram[{addra, 2'd1}] <= dina[((2*B_DATA_WIDTH)-1):(B_DATA_WIDTH*1)];
        m_ram[{addra, 2'd2}] <= dina[((3*B_DATA_WIDTH)-1):(B_DATA_WIDTH*2)];
        m_ram[{addra, 2'd3}] <= dina[((4*B_DATA_WIDTH)-1):(B_DATA_WIDTH*3)];
      end
    end
  end
  endgenerate

  generate if ((MEM_IO_COMP == 1) && (MEM_RATIO == 8)) begin
    always @(posedge clka) begin
      if (wea == 1'b1) begin
        m_ram[{addra, 3'd0}] <= dina[((1*B_DATA_WIDTH)-1):(B_DATA_WIDTH*0)];
        m_ram[{addra, 3'd1}] <= dina[((2*B_DATA_WIDTH)-1):(B_DATA_WIDTH*1)];
        m_ram[{addra, 3'd2}] <= dina[((3*B_DATA_WIDTH)-1):(B_DATA_WIDTH*2)];
        m_ram[{addra, 3'd3}] <= dina[((4*B_DATA_WIDTH)-1):(B_DATA_WIDTH*3)];
        m_ram[{addra, 3'd4}] <= dina[((5*B_DATA_WIDTH)-1):(B_DATA_WIDTH*4)];
        m_ram[{addra, 3'd5}] <= dina[((6*B_DATA_WIDTH)-1):(B_DATA_WIDTH*5)];
        m_ram[{addra, 3'd6}] <= dina[((7*B_DATA_WIDTH)-1):(B_DATA_WIDTH*6)];
        m_ram[{addra, 3'd7}] <= dina[((8*B_DATA_WIDTH)-1):(B_DATA_WIDTH*7)];
      end
    end
  end
  endgenerate

  // read interface options

  generate if ((MEM_IO_COMP == 1) || (MEM_RATIO == 1)) begin
    always @(posedge clkb) begin
      doutb <= m_ram[addrb];
    end
  end
  endgenerate

  generate if ((MEM_IO_COMP == 0) && (MEM_RATIO == 2)) begin
    always @(posedge clkb) begin
      doutb <= {m_ram[{addrb, 1'd1}],
                m_ram[{addrb, 1'd0}]};
    end
  end
  endgenerate

  generate if ((MEM_IO_COMP == 0) && (MEM_RATIO == 4)) begin
    always @(posedge clkb) begin
      doutb <= {m_ram[{addrb, 2'd3}],
                m_ram[{addrb, 2'd2}],
                m_ram[{addrb, 2'd1}],
                m_ram[{addrb, 2'd0}]};
    end
  end
  endgenerate

  generate if ((MEM_IO_COMP == 0) && (MEM_RATIO == 8)) begin
    always @(posedge clkb) begin
      doutb <= {m_ram[{addrb, 3'd7}],
                m_ram[{addrb, 3'd6}],
                m_ram[{addrb, 3'd5}],
                m_ram[{addrb, 3'd4}],
                m_ram[{addrb, 3'd3}],
                m_ram[{addrb, 3'd2}],
                m_ram[{addrb, 3'd1}],
                m_ram[{addrb, 3'd0}]};
    end
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
