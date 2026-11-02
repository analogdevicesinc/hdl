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

`timescale 1ns / 1ps

// APB variant of axi_sysid with the same register map.

module apb_sysid #(
  parameter ROM_WIDTH = 32,
  parameter ROM_ADDR_BITS = 9
) (

  // apb interface

  input           s_axi_aclk,
  input           s_axi_aresetn,
  input   [15:0]  s_apb_paddr,
  input           s_apb_penable,
  output  [31:0]  s_apb_prdata,
  output          s_apb_pready,
  input           s_apb_psel,
  output          s_apb_pslverr,
  input   [31:0]  s_apb_pwdata,
  input           s_apb_pwrite,

  input   [ROM_WIDTH-1:0]           sys_rom_data,
  input   [ROM_WIDTH-1:0]           pr_rom_data,
  output  [ROM_ADDR_BITS-1:0]       rom_addr
);

  localparam  [31:0]  CORE_VERSION         = {16'h0001,     /* MAJOR */
                                                8'h01,      /* MINOR */
                                                8'h61};     /* PATCH */
  localparam  [31:0]  CORE_MAGIC           = 32'h53594944;  // SYID

  reg                             up_wack = 'd0;
  reg   [31:0]                    up_rdata_s = 'd0;
  reg                             up_rack_s = 'd0;
  reg                             up_rreq_s_d = 'd0;
  reg   [31:0]                    up_scratch = 'd0;

  wire                            up_clk;
  wire                            up_rstn;
  wire                            up_rreq_s;
  wire  [(ROM_ADDR_BITS+1):0]     up_raddr_s;
  wire                            up_wreq_s;
  wire  [(ROM_ADDR_BITS+1):0]     up_waddr_s;
  wire  [31:0]                    up_wdata_s;
  wire  [31:0]                    rom_data_s;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  assign rom_addr = up_raddr_s [ROM_ADDR_BITS-1:0];
  assign rom_data_s = (up_raddr_s [ROM_ADDR_BITS + 1'h1: ROM_ADDR_BITS] == 2'h1) ? sys_rom_data :
                    (up_raddr_s [ROM_ADDR_BITS + 1'h1: ROM_ADDR_BITS] == 2'h2) ? pr_rom_data : 'h0;

  up_apb #(
    .APB_ADDRESS_WIDTH (ROM_ADDR_BITS+4)
  ) i_up_apb (
    .up_apb_presetn (up_rstn),
    .up_apb_clk (up_clk),
    .up_apb_paddr (s_apb_paddr[ROM_ADDR_BITS+3:0]),
    .up_apb_penable (s_apb_penable),
    .up_apb_prdata (s_apb_prdata),
    .up_apb_pready (s_apb_pready),
    .up_apb_pselx (s_apb_psel),
    .up_apb_pslverr (s_apb_pslverr),
    .up_apb_pwdata (s_apb_pwdata),
    .up_apb_pwrite (s_apb_pwrite),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  //delaying data read with 1 tck to compensate for the ROM latency
  always @(posedge up_clk) begin
    up_rreq_s_d <= up_rreq_s;
  end

  //apb registers read
  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rack_s <= 'd0;
      up_rdata_s <= 'd0;
    end else begin
      up_rack_s <= up_rreq_s_d;
      if (up_rreq_s_d == 1'b1) begin
        case (up_raddr_s)
          8'h00: up_rdata_s <= CORE_VERSION;
          8'h01: up_rdata_s <= 0;
          8'h02: up_rdata_s <= up_scratch;
          8'h03: up_rdata_s <= CORE_MAGIC;
          8'h10: up_rdata_s <= ROM_ADDR_BITS;
          default: begin
            up_rdata_s <= rom_data_s;
          end
        endcase
      end else begin
        up_rdata_s <= 32'd0;
      end
    end
  end

  //apb registers write
  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h02)) begin
        up_scratch <= up_wdata_s;
      end
    end
  end

endmodule
