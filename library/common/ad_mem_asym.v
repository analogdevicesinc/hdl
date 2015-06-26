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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_mem_asym (

  clka,
  wea,
  addra,
  dina,

  clkb,
  addrb,
  doutb);

  parameter   ADDR_WIDTH_A =  10;
  parameter   DATA_WIDTH_A = 256;
  parameter   ADDR_WIDTH_B =   8; 
  parameter   DATA_WIDTH_B =  64;

  localparam  MEM_SIZE_A = 2**ADDR_WIDTH_A;
  localparam  MEM_SIZE_B = 2**ADDR_WIDTH_B;
  localparam  MEM_SIZE = (MEM_SIZE_A > MEM_SIZE_B) ? MEM_SIZE_A : MEM_SIZE_B;
  localparam  MEM_RATIO = DATA_WIDTH_A/DATA_WIDTH_B;

  // write interface

  input                       clka;
  input                       wea;
  input   [ADDR_WIDTH_A-1:0]  addra;
  input   [DATA_WIDTH_A-1:0]  dina;

  // read interface

  input                       clkb;
  input   [ADDR_WIDTH_B-1:0]  addrb;
  output  [DATA_WIDTH_B-1:0]  doutb;

  // internal registers

  reg     [DATA_WIDTH_B-1:0]  m_ram[0:MEM_SIZE-1];
  reg     [DATA_WIDTH_B-1:0]  doutb;

  // write interface

  generate
  if (MEM_RATIO == 2) begin
  always @(posedge clka) begin
    if (wea == 1'b1) begin
      m_ram[{addra, 1'd0}] <= dina[((1*DATA_WIDTH_B)-1):(DATA_WIDTH_B*0)];
      m_ram[{addra, 1'd1}] <= dina[((2*DATA_WIDTH_B)-1):(DATA_WIDTH_B*1)];
    end
  end
  end

  if (MEM_RATIO == 4) begin
  always @(posedge clka) begin
    if (wea == 1'b1) begin
      m_ram[{addra, 2'd0}] <= dina[((1*DATA_WIDTH_B)-1):(DATA_WIDTH_B*0)];
      m_ram[{addra, 2'd1}] <= dina[((2*DATA_WIDTH_B)-1):(DATA_WIDTH_B*1)];
      m_ram[{addra, 2'd2}] <= dina[((3*DATA_WIDTH_B)-1):(DATA_WIDTH_B*2)];
      m_ram[{addra, 2'd3}] <= dina[((4*DATA_WIDTH_B)-1):(DATA_WIDTH_B*3)];
    end
  end
  end

  if (MEM_RATIO == 8) begin
  always @(posedge clka) begin
    if (wea == 1'b1) begin
      m_ram[{addra, 3'd0}] <= dina[((1*DATA_WIDTH_B)-1):(DATA_WIDTH_B*0)];
      m_ram[{addra, 3'd1}] <= dina[((2*DATA_WIDTH_B)-1):(DATA_WIDTH_B*1)];
      m_ram[{addra, 3'd2}] <= dina[((3*DATA_WIDTH_B)-1):(DATA_WIDTH_B*2)];
      m_ram[{addra, 3'd3}] <= dina[((4*DATA_WIDTH_B)-1):(DATA_WIDTH_B*3)];
      m_ram[{addra, 3'd4}] <= dina[((5*DATA_WIDTH_B)-1):(DATA_WIDTH_B*4)];
      m_ram[{addra, 3'd5}] <= dina[((6*DATA_WIDTH_B)-1):(DATA_WIDTH_B*5)];
      m_ram[{addra, 3'd6}] <= dina[((7*DATA_WIDTH_B)-1):(DATA_WIDTH_B*6)];
      m_ram[{addra, 3'd7}] <= dina[((8*DATA_WIDTH_B)-1):(DATA_WIDTH_B*7)];
    end
  end
  end
  endgenerate

  // read interface

  always @(posedge clkb) begin
    doutb <= m_ram[addrb];
  end

endmodule

// ***************************************************************************
// ***************************************************************************
