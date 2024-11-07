// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
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

module axi_adxcvr_up #(

  // parameters

  parameter   integer ID = 0,
  parameter   [ 7:0]  FPGA_TECHNOLOGY = 0,
  parameter   [ 7:0]  FPGA_FAMILY = 0,
  parameter   [ 7:0]  SPEED_GRADE = 0,
  parameter   [ 7:0]  DEV_PACKAGE = 0,
  parameter   [15:0]  FPGA_VOLTAGE = 0,
  parameter   integer XCVR_TYPE = 0,
  parameter   integer TX_OR_RX_N = 0,
  parameter   integer NUM_OF_LANES = 4,
  parameter           READY_W = (FPGA_TECHNOLOGY != 105) ?  NUM_OF_LANES : 1
) (
  // xcvr, lane-pll and ref-pll are shared

  output                        up_rst,
  input                         up_pll_locked,
  input                         up_rx_lockedtodata,
  input   [READY_W-1:0]         up_ready,
  input   [READY_W-1:0]         up_reset_ack,

  // bus interface

  input                         up_rstn,
  input                         up_clk,
  input                         up_wreq,
  input   [ 9:0]                up_waddr,
  input   [31:0]                up_wdata,
  output                        up_wack,
  input                         up_rreq,
  input   [ 9:0]                up_raddr,
  output  [31:0]                up_rdata,
  output                        up_rack
);

  // parameters

  localparam  [31:0]  VERSION = 32'h00110161;

  // internal registers

  reg                           up_wreq_d = 'd0;
  reg     [31:0]                up_scratch = 'd0;
  reg                           up_resetn = 'd0;
  reg                           up_status_int = 'd0;
  reg                           up_rreq_d = 'd0;
  reg     [31:0]                up_rdata_d = 'd0;

  // internal signals

  wire                          up_all_ready_s;
  wire    [31:0]                up_status_32_s;
  wire    [31:0]                up_rparam_s;

  wire                          up_pll_locked_s;
  wire                          up_rx_lockedtodata_s;
  wire                          up_ready_s;

  // defaults

  assign up_wack = up_wreq_d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wreq_d <= 'd0;
      up_scratch <= 'd0;
    end else begin
      up_wreq_d <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 10'h002)) begin
        up_scratch <= up_wdata;
      end
    end
  end

  // reset-controller

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_resetn <= 'd0;
    end else begin
      if ((up_wreq == 1'b1) && (up_waddr == 10'h004)) begin
        up_resetn <= up_wdata[0];
      end
    end
  end

  generate if (FPGA_TECHNOLOGY == 105) begin
    sync_bits #(
      .NUM_OF_BITS (3),
      .ASYNC_CLK (1)
    ) i_sync_input_ctrl (
      .in_bits ({up_ready, up_pll_locked, up_rx_lockedtodata}),
      .out_resetn (1'b1),
      .out_clk (up_clk),
      .out_bits({up_ready_s, up_pll_locked_s, up_rx_lockedtodata_s}));
  end else begin
    assign up_ready_s = up_ready;
    assign up_pll_locked_s = up_pll_locked;
    assign up_rx_lockedtodata_s = up_rx_lockedtodata;
  end
  endgenerate

  assign up_all_ready_s = & up_status_32_s[(NUM_OF_LANES-1):0];
  assign up_status_32_s[31:(NUM_OF_LANES+1)] = 'd0;
  assign up_status_32_s[NUM_OF_LANES] = FPGA_TECHNOLOGY == 105 ? TX_OR_RX_N ? up_pll_locked_s : up_rx_lockedtodata_s :
                                                                 up_pll_locked_s;
  assign up_status_32_s[(NUM_OF_LANES-1):0] = FPGA_TECHNOLOGY == 105 ? {NUM_OF_LANES{up_ready_s}} : up_ready_s;

  generate if (FPGA_TECHNOLOGY == 105) begin
    wire up_reset_ack_s;
    reg  up_rst_d;

    sync_bits #(
      .NUM_OF_BITS (1),
      .ASYNC_CLK (1)
    ) i_sync_reset_ack (
      .in_bits (up_reset_ack),
      .out_resetn (1'b1),
      .out_clk (up_clk),
      .out_bits(up_reset_ack_s));

    always @(negedge up_rstn or posedge up_clk) begin
      if (up_rstn == 0) begin
        up_rst_d <= 1'b1;
      end else if (up_resetn == 1'b0) begin
        up_rst_d <= 1'b1;
      end else if (up_reset_ack_s) begin
        up_rst_d <= 1'b0;
      end
    end
    assign up_rst = up_rst_d;
  end else begin
    reg [3:0] up_rst_cnt = 'd8;

    always @(negedge up_rstn or posedge up_clk) begin
      if (up_rstn == 0) begin
        up_rst_cnt <= 4'h8;
      end else begin
        if (up_resetn == 1'b0) begin
          up_rst_cnt <= 4'h8;
        end else if (up_rst_cnt[3] == 1'b1) begin
          up_rst_cnt <= up_rst_cnt + 1'b1;
        end
      end
    end
    assign up_rst = up_rst_cnt[3];
  end
  endgenerate

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_int <= 1'b0;
    end else begin
      if (up_resetn == 1'b0) begin
        up_status_int <= 1'b0;
      end else if (up_all_ready_s) begin
        up_status_int <= 1'b1;
      end
    end
  end

  // Specific to Intel

  assign up_rparam_s[31:28] = 8'd0;
  assign up_rparam_s[27:24] = XCVR_TYPE[3:0];

  // Specific to Xilinx

  assign up_rparam_s[23:16] = 8'd0;

  // generic

  assign up_rparam_s[15: 9] = 7'd0;
  assign up_rparam_s[ 8: 8] = (TX_OR_RX_N == 0) ? 1'b0 : 1'b1;
  assign up_rparam_s[ 7: 0] = NUM_OF_LANES[7:0];

  // read interface

  assign up_rack = up_rreq_d;
  assign up_rdata = up_rdata_d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rreq_d <= 'd0;
      up_rdata_d <= 'd0;
    end else begin
      up_rreq_d <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          10'h000: up_rdata_d <= VERSION;
          10'h001: up_rdata_d <= ID;
          10'h002: up_rdata_d <= up_scratch;
          10'h004: up_rdata_d <= {31'd0, up_resetn};
          10'h005: up_rdata_d <= {31'd0, up_status_int};
          10'h006: up_rdata_d <= up_status_32_s;
          10'h007: up_rdata_d <= {FPGA_TECHNOLOGY,FPGA_FAMILY,SPEED_GRADE,DEV_PACKAGE}; // [8,8,8,8]
          10'h009: up_rdata_d <= up_rparam_s;
          10'h050: up_rdata_d <= {16'd0, FPGA_VOLTAGE};  // mV
          default: up_rdata_d <= 32'd0;
        endcase
      end else begin
        up_rdata_d <= 32'd0;
      end
    end
  end

endmodule
