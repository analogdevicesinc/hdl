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

`timescale 1ns/100ps

module up_clkgen #(

  parameter         ID = 0,
  parameter [ 7:0]  FPGA_TECHNOLOGY = 0,
  parameter [ 7:0]  FPGA_FAMILY = 0,
  parameter [ 7:0]  SPEED_GRADE = 0,
  parameter [ 7:0]  DEV_PACKAGE = 0,
  parameter [15:0]  FPGA_VOLTAGE = 0) (

  // mmcm reset

  output                  mmcm_rst,

  // clock selection

  output                  clk_sel,

  // drp interface

  output  reg             up_drp_sel,
  output  reg             up_drp_wr,
  output  reg [11:0]      up_drp_addr,
  output  reg [15:0]      up_drp_wdata,
  input       [15:0]      up_drp_rdata,
  input                   up_drp_ready,
  input                   up_drp_locked,

  // bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output  reg             up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output  reg [31:0]      up_rdata,
  output  reg             up_rack);

  localparam  PCORE_VERSION = 32'h00050063;

  // internal registers

  reg             up_mmcm_preset = 'd0;
  reg     [31:0]  up_scratch = 'd0;
  reg             up_mmcm_resetn = 'd0;
  reg             up_resetn = 'd0;
  reg             up_drp_status = 'd0;
  reg             up_drp_rwn = 'd0;
  reg     [15:0]  up_drp_rdata_hold = 'd0;
  reg             up_clk_sel = 'd0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == 6'h00) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == 6'h00) ? up_rreq : 1'b0;

  assign clk_sel = ~up_clk_sel;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_mmcm_preset <= 1'd1;
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_mmcm_resetn <= 'd0;
      up_resetn <= 'd0;
      up_drp_sel <= 'd0;
      up_drp_wr <= 'd0;
      up_drp_status <= 'd0;
      up_drp_rwn <= 'd0;
      up_drp_addr <= 'd0;
      up_drp_wdata <= 'd0;
      up_drp_rdata_hold <= 'd0;
      up_clk_sel <= 'd0;
    end else begin
      up_mmcm_preset <= ~up_mmcm_resetn;
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h10)) begin
        up_mmcm_resetn <= up_wdata[1];
        up_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h11)) begin
        up_clk_sel <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h1c)) begin
        up_drp_sel <= 1'b1;
        up_drp_wr <= ~up_wdata[28];
      end else begin
        up_drp_sel <= 1'b0;
        up_drp_wr <= 1'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h1c)) begin
        up_drp_status <= 1'b1;
      end else if (up_drp_ready == 1'b1) begin
        up_drp_status <= 1'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h1c)) begin
        up_drp_rwn <= up_wdata[28];
        up_drp_addr <= up_wdata[27:16];
        up_drp_wdata <= up_wdata[15:0];
      end
      if (up_drp_ready == 1'b1) begin
        up_drp_rdata_hold <= up_drp_rdata;
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[7:0])
          8'h00: up_rdata <= PCORE_VERSION;
          8'h01: up_rdata <= ID;
          8'h02: up_rdata <= up_scratch;
          8'h07: up_rdata <= {FPGA_TECHNOLOGY,FPGA_FAMILY,SPEED_GRADE,DEV_PACKAGE}; // [8,8,8,8]
          8'h10: up_rdata <= {30'd0, up_mmcm_resetn, up_resetn};
          8'h11: up_rdata <= {31'd0, up_clk_sel};
          8'h17: up_rdata <= {31'd0, up_drp_locked};
          8'h1c: up_rdata <= {3'd0, up_drp_rwn, up_drp_addr, up_drp_wdata};
          8'h1d: up_rdata <= {14'd0, up_drp_locked, up_drp_status, up_drp_rdata_hold};
          8'h50: up_rdata <= {16'd0, FPGA_VOLTAGE}; // mV
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // resets

  ad_rst i_mmcm_rst_reg (.rst_async(up_mmcm_preset), .clk(up_clk), .rstn(), .rst(mmcm_rst));

endmodule

// ***************************************************************************
// ***************************************************************************
