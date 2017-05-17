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

module axi_gpreg_io #(

  parameter   ID = 0) (

  // gpio

  output  reg [31:0]      up_gp_ioenb,
  output  reg [31:0]      up_gp_out,
  input       [31:0]      up_gp_in,

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


  // internal registers

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:4] == ID) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:4] == ID) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_gp_ioenb <= {32{1'b1}};
      up_gp_out <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_gp_ioenb <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_gp_out <= up_wdata;
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
        case (up_raddr[3:0])
          4'b0000: up_rdata <= up_gp_ioenb;
          4'b0001: up_rdata <= up_gp_out;
          4'b0010: up_rdata <= up_gp_in;
          default: up_rdata <= 32'd0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
