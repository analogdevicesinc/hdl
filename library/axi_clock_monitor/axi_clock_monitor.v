// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_clock_monitor #(

  parameter   ID = 0,
  parameter   NUM_OF_CLOCKS = 1
) (

  // clocks

  input           clock_0,
  input           clock_1,
  input           clock_2,
  input           clock_3,
  input           clock_4,
  input           clock_5,
  input           clock_6,
  input           clock_7,
  input           clock_8,
  input           clock_9,
  input           clock_10,
  input           clock_11,
  input           clock_12,
  input           clock_13,
  input           clock_14,
  input           clock_15,

  output          reset,

  // axi interface

  input           s_axi_aclk,
  input           s_axi_aresetn,
  input           s_axi_awvalid,
  input   [15:0]  s_axi_awaddr,
  input   [ 2:0]  s_axi_awprot,
  output          s_axi_awready,
  input           s_axi_wvalid,
  input   [31:0]  s_axi_wdata,
  input   [ 3:0]  s_axi_wstrb,
  output          s_axi_wready,
  output          s_axi_bvalid,
  output  [ 1:0]  s_axi_bresp,
  input           s_axi_bready,
  input           s_axi_arvalid,
  input   [15:0]  s_axi_araddr,
  input   [ 2:0]  s_axi_arprot,
  output          s_axi_arready,
  output          s_axi_rvalid,
  output  [31:0]  s_axi_rdata,
  output  [ 1:0]  s_axi_rresp,
  input           s_axi_rready
);

  // local parameters

  localparam  PCORE_VERSION = 1;

  // internal registers

  reg          pass = 'd0;
  reg          up_wack_int = 'd0;
  reg          up_rack_int = 'd0;
  reg          up_scratch = 'd0;
  reg          up_reset_core = 'd0;
  reg  [31:0]  up_rdata_int = 'd0;

  // internal signals

  wire         up_clk;
  wire         up_rstn;
  wire         up_wreq_s;
  wire         up_rreq_s;
  wire         up_waddr_s;
  wire         up_raddr_s;

  wire         clock         [0:15];
  wire [20:0]  clk_mon_count [0:15];

  wire         up_wreq_i_s;
  wire [13:0]  up_waddr_i_s;
  wire [31:0]  up_wdata_i_s;
  wire         up_wack_o_s;
  wire         up_rreq_i_s;
  wire [13:0]  up_raddr_i_s;
  wire [31:0]  up_rdata_o_s;
  wire         up_rack_o_s;

  // loop variables

  genvar  n;

  generate
    assign clock[0 ] = clock_0;
    assign clock[1 ] = clock_1;
    assign clock[2 ] = clock_2;
    assign clock[3 ] = clock_3;
    assign clock[4 ] = clock_4;
    assign clock[5 ] = clock_5;
    assign clock[6 ] = clock_6;
    assign clock[7 ] = clock_7;
    assign clock[8 ] = clock_8;
    assign clock[9 ] = clock_9;
    assign clock[10] = clock_10;
    assign clock[11] = clock_11;
    assign clock[12] = clock_12;
    assign clock[13] = clock_13;
    assign clock[14] = clock_14;
    assign clock[15] = clock_15;
  endgenerate

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign reset = up_reset_core;

  // decode block select

  assign up_wreq_s = (up_waddr_i_s[13:8] == ID) ? up_wreq_i_s : 1'b0;
  assign up_rreq_s = (up_raddr_i_s[13:8] == ID) ? up_rreq_i_s : 1'b0;

  // processor write interface

  assign up_wack_o_s = up_wack_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack_int <= 'd0;
      up_reset_core <= 'd0;
    end else begin
      up_wack_int <= up_wreq_s;
      if (up_wreq_s == 1'b1) begin
        case (up_waddr_i_s[7:0])
          8'h004: up_reset_core <= up_wdata_i_s[0];
          default: pass <= 1'h0;
        endcase
      end
    end
  end

  // processor read interface

  assign up_rack_o_s = up_rack_int;
  assign up_rdata_o_s = up_rdata_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
    end else begin
      up_rack_int <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr_i_s)
          /* Standard registers */
          14'h000: up_rdata_int <= PCORE_VERSION;
          14'h001: up_rdata_int <= ID;

          /* Core configuration */
          14'h003: up_rdata_int <= NUM_OF_CLOCKS;
          14'h004: up_rdata_int <= {31'h00, up_reset_core};

          /* Clock ratios registers*/
          14'h010: up_rdata_int <= {11'h00, clk_mon_count[ 0]};
          14'h011: up_rdata_int <= {11'h00, clk_mon_count[ 1]};
          14'h012: up_rdata_int <= {11'h00, clk_mon_count[ 2]};
          14'h013: up_rdata_int <= {11'h00, clk_mon_count[ 3]};
          14'h014: up_rdata_int <= {11'h00, clk_mon_count[ 4]};
          14'h015: up_rdata_int <= {11'h00, clk_mon_count[ 5]};
          14'h016: up_rdata_int <= {11'h00, clk_mon_count[ 6]};
          14'h017: up_rdata_int <= {11'h00, clk_mon_count[ 7]};
          14'h018: up_rdata_int <= {11'h00, clk_mon_count[ 8]};
          14'h019: up_rdata_int <= {11'h00, clk_mon_count[ 9]};
          14'h01a: up_rdata_int <= {11'h00, clk_mon_count[10]};
          14'h01b: up_rdata_int <= {11'h00, clk_mon_count[11]};
          14'h01c: up_rdata_int <= {11'h00, clk_mon_count[12]};
          14'h01d: up_rdata_int <= {11'h00, clk_mon_count[13]};
          14'h01e: up_rdata_int <= {11'h00, clk_mon_count[14]};
          14'h01f: up_rdata_int <= {11'h00, clk_mon_count[15]};

          default: up_rdata_int <= 'h00;
        endcase
      end
    end
  end

  // clock monitors

  generate
    for (n = 0; n < NUM_OF_CLOCKS; n = n + 1) begin: clk_mon
      up_clock_mon #(
        .TOTAL_WIDTH(21)
      ) i_clock_mon (
        .up_rstn(~up_reset_core),
        .up_clk(up_clk),
        .up_d_count(clk_mon_count[n]),
        .d_rst(1'b0),
        .d_clk(clock[n]));
    end
    for (n = NUM_OF_CLOCKS; n < 16; n = n + 1) begin: clk_mon_z
      assign clk_mon_count[n] = 21'd0;
    end
  endgenerate

  // axi interface

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_i_s),
    .up_waddr (up_waddr_i_s),
    .up_wdata (up_wdata_i_s),
    .up_wack (up_wack_o_s),
    .up_rreq (up_rreq_i_s),
    .up_raddr (up_raddr_i_s),
    .up_rdata (up_rdata_o_s),
    .up_rack (up_rack_o_s));

endmodule
