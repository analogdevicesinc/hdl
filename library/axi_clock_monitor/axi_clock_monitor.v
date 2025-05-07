// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
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

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   ID = 0,
  parameter   NUM_OF_CLOCKS = 1,
  parameter   DIV_RATE = 1
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
  localparam [7:0] DIV_VALUE = (DIV_RATE == 4'd1) ? "1" :
                               (DIV_RATE == 4'd2) ? "2" :
                               (DIV_RATE == 4'd3) ? "3" :
                               (DIV_RATE == 4'd4) ? "4" :
                               (DIV_RATE == 4'd5) ? "5" :
                               (DIV_RATE == 4'd6) ? "6" :
                               (DIV_RATE == 4'd7) ? "7" :
                               (DIV_RATE == 4'd8) ? "8" : "0";
  localparam  SEVEN_SERIES    = 1;
  localparam  ULTRASCALE      = 2;
  localparam  ULTRASCALE_PLUS = 3;

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
  wire         clock          [0:15];
  wire [20:0]  clk_mon_count  [0:15];
  wire         clock_div      [0:15];
  wire [7:0]   div_rate_s;
  wire [13:0]  up_waddr_i_s;
  wire [31:0]  up_wdata_i_s;
  wire         up_wack_o_s;
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
        case (up_raddr_i_s[4:0])
          /* Standard registers */
          5'h00: up_rdata_int <= PCORE_VERSION;
          5'h01: up_rdata_int <= ID;

          /* Core configuration */
          5'h02: up_rdata_int <= {14'h00, div_rate_s};
          5'h03: up_rdata_int <= NUM_OF_CLOCKS;
          5'h04: up_rdata_int <= {31'h00, up_reset_core};

          /* Clock ratios registers*/
          5'h10: up_rdata_int <= {11'h00, clk_mon_count[ 0]};
          5'h11: up_rdata_int <= {11'h00, clk_mon_count[ 1]};
          5'h12: up_rdata_int <= {11'h00, clk_mon_count[ 2]};
          5'h13: up_rdata_int <= {11'h00, clk_mon_count[ 3]};
          5'h14: up_rdata_int <= {11'h00, clk_mon_count[ 4]};
          5'h15: up_rdata_int <= {11'h00, clk_mon_count[ 5]};
          5'h16: up_rdata_int <= {11'h00, clk_mon_count[ 6]};
          5'h17: up_rdata_int <= {11'h00, clk_mon_count[ 7]};
          5'h18: up_rdata_int <= {11'h00, clk_mon_count[ 8]};
          5'h19: up_rdata_int <= {11'h00, clk_mon_count[ 9]};
          5'h1a: up_rdata_int <= {11'h00, clk_mon_count[10]};
          5'h1b: up_rdata_int <= {11'h00, clk_mon_count[11]};
          5'h1c: up_rdata_int <= {11'h00, clk_mon_count[12]};
          5'h1d: up_rdata_int <= {11'h00, clk_mon_count[13]};
          5'h1e: up_rdata_int <= {11'h00, clk_mon_count[14]};
          5'h1f: up_rdata_int <= {11'h00, clk_mon_count[15]};

          default: up_rdata_int <= 'h00;
        endcase
      end
    end
  end

  // clock monitors

  assign div_rate_s = (FPGA_TECHNOLOGY == SEVEN_SERIES || FPGA_TECHNOLOGY ==  ULTRASCALE || FPGA_TECHNOLOGY ==  ULTRASCALE_PLUS) ?   DIV_RATE : 8'b1;

  generate
    for (n = 0; n < NUM_OF_CLOCKS; n = n + 1) begin: clk_mon
      if(FPGA_TECHNOLOGY == SEVEN_SERIES) begin
        BUFR #(
          .BUFR_DIVIDE(DIV_VALUE),
          .SIM_DEVICE("7SERIES")
        ) BUFR_inst (
          .CLR(1'b0),
          .CE(1'b1),
          .I(clock[n]),
          .O(clock_div[n]));
      end else if(FPGA_TECHNOLOGY == ULTRASCALE || FPGA_TECHNOLOGY == ULTRASCALE_PLUS) begin
        BUFGCE_DIV #(
          .BUFGCE_DIVIDE(DIV_RATE),
          .IS_CE_INVERTED(1'b0),
          .IS_CLR_INVERTED(1'b0),
          .IS_I_INVERTED(1'b0)
        ) i_div_clk_buf (
          .O(clock_div[n]),
          .CE(1'b1),
          .CLR(1'b0),
          .I(clock[n]));
      end else begin
        assign clock_div[n] = clock[n];
      end
      up_clock_mon #(
        .TOTAL_WIDTH(21)
      ) i_clock_mon (
        .up_rstn(~up_reset_core),
        .up_clk(up_clk),
        .up_d_count(clk_mon_count[n]),
        .d_rst(1'b0),
        .d_clk(clock_div[n]));
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
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_i_s),
    .up_wdata (up_wdata_i_s),
    .up_wack (up_wack_o_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_i_s),
    .up_rdata (up_rdata_o_s),
    .up_rack (up_rack_o_s));

endmodule
