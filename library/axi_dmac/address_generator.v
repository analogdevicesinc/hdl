// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module address_generator #(

  parameter ID_WIDTH = 3,
  parameter DMA_DATA_WIDTH = 64,
  parameter DMA_ADDR_WIDTH = 32,
  parameter BEATS_PER_BURST_WIDTH = 4,
  parameter BYTES_PER_BEAT_WIDTH = $clog2(DMA_DATA_WIDTH/8),
  parameter LENGTH_WIDTH = 8,
  parameter [3:0] AXI_AXCACHE = 4'b0011,
  parameter [2:0] AXI_AXPROT = 3'b000
) (
  input                        clk,
  input                        resetn,

  input                        req_valid,
  output reg                   req_ready,
  input [DMA_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH] req_address,

  output reg [ID_WIDTH-1:0]  id,
  input [ID_WIDTH-1:0]       request_id,

  input                             bl_valid,
  output reg                        bl_ready,
  input [BEATS_PER_BURST_WIDTH-1:0] measured_last_burst_length,

  input                        eot,

  input                        enable,
  output reg                   enabled,

  input                           addr_ready,
  output reg                      addr_valid,
  output     [DMA_ADDR_WIDTH-1:0] addr,
  output     [LENGTH_WIDTH-1:0]   len,
  output     [ 2:0]               size,
  output     [ 1:0]               burst,
  output     [ 2:0]               prot,
  output     [ 3:0]               cache
);

  localparam MAX_BEATS_PER_BURST = {1'b1,{BEATS_PER_BURST_WIDTH{1'b0}}};
  localparam MAX_LENGTH = {BEATS_PER_BURST_WIDTH{1'b1}};

`include "inc_id.vh"

  assign burst = 2'b01;
  assign prot = AXI_AXPROT;
  assign cache = AXI_AXCACHE;
  assign size = DMA_DATA_WIDTH == 1024 ? 3'b111 :
                DMA_DATA_WIDTH ==  512 ? 3'b110 :
                DMA_DATA_WIDTH ==  256 ? 3'b101 :
                DMA_DATA_WIDTH ==  128 ? 3'b100 :
                DMA_DATA_WIDTH ==   64 ? 3'b011 :
                DMA_DATA_WIDTH ==   32 ? 3'b010 :
                DMA_DATA_WIDTH ==   16 ? 3'b001 : 3'b000;

  reg [LENGTH_WIDTH-1:0] length = 'h0;
  reg [DMA_ADDR_WIDTH-BYTES_PER_BEAT_WIDTH-1:0] address = 'h00;
  reg [BEATS_PER_BURST_WIDTH-1:0] last_burst_len = 'h00;
  assign addr = {address, {BYTES_PER_BEAT_WIDTH{1'b0}}};
  assign len = length;

  reg addr_valid_d1;
  reg last = 1'b0;

  // If we already asserted addr_valid we have to wait until it is accepted before
  // we can disable the address generator.
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      enabled <= 1'b0;
    end else if (enable == 1'b1) begin
      enabled <= 1'b1;
    end else if (addr_valid == 1'b0) begin
      enabled <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (bl_valid == 1'b1 && bl_ready == 1'b1) begin
      last_burst_len <= measured_last_burst_length;
    end
  end

  always @(posedge clk) begin
    if (addr_valid == 1'b0) begin
      last <= eot;
      if (eot == 1'b1) begin
        length <= last_burst_len;
      end else begin
        length <= MAX_LENGTH;
      end
    end
  end

  always @(posedge clk) begin
    if (req_ready == 1'b1) begin
      address <= req_address;
    end else if (addr_valid == 1'b1 && addr_ready == 1'b1) begin
      address <= address + MAX_BEATS_PER_BURST;
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      bl_ready <= 1'b1;
    end else begin
      if (bl_ready == 1'b1) begin
        bl_ready <= ~bl_valid;
      end else if (addr_valid == 1'b0 && eot == 1'b1) begin
        // assert bl_ready only when the addr_valid asserts in the next cycle
        if (id != request_id && enable == 1'b1) begin
          bl_ready <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      req_ready <= 1'b1;
      addr_valid <= 1'b0;
    end else begin
      if (req_ready == 1'b1) begin
        req_ready <= ~req_valid;
      end else if (addr_valid == 1'b1 && addr_ready == 1'b1) begin
        addr_valid <= 1'b0;
        req_ready <= last;
      end else if (id != request_id && enable == 1'b1) begin
        // if eot wait until the last_burst_len gets synced over
        if (eot == 1'b0 || (eot == 1'b1 && bl_ready == 1'b0)) begin
          addr_valid <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    addr_valid_d1 <= addr_valid;
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      id <= 'h0;
    end else if (addr_valid == 1'b1 && addr_valid_d1 == 1'b0) begin
      id <= inc_id(id);
    end
  end

endmodule
