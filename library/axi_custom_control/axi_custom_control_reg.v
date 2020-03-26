// ***************************************************************************
// ***************************************************************************
// Copyright 2020 (c) Analog Devices, Inc. All rights reserved.
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

module axi_custom_control_reg #(

  // 0x100 < ADDR_OFFSET < 0x3F00
  parameter ADDR_OFFSET = 32'h800,
  parameter N_CONTROL_REG = 4,
  parameter N_STATUS_REG = 4) (

  input              clk,

  input       [31:0]    reg_status_0,
  input       [31:0]    reg_status_1,
  input       [31:0]    reg_status_2,
  input       [31:0]    reg_status_3,
  input       [31:0]    reg_status_4,
  input       [31:0]    reg_status_5,
  input       [31:0]    reg_status_6,
  input       [31:0]    reg_status_7,
  input       [31:0]    reg_status_8,
  input       [31:0]    reg_status_9,
  input       [31:0]    reg_status_10,
  input       [31:0]    reg_status_11,
  input       [31:0]    reg_status_12,
  input       [31:0]    reg_status_13,
  input       [31:0]    reg_status_14,
  input       [31:0]    reg_status_15,

  output      [31:0]    reg_control_0,
  output      [31:0]    reg_control_1,
  output      [31:0]    reg_control_2,
  output      [31:0]    reg_control_3,
  output      [31:0]    reg_control_4,
  output      [31:0]    reg_control_5,
  output      [31:0]    reg_control_6,
  output      [31:0]    reg_control_7,
  output      [31:0]    reg_control_8,
  output      [31:0]    reg_control_9,
  output      [31:0]    reg_control_10,
  output      [31:0]    reg_control_11,
  output      [31:0]    reg_control_12,
  output      [31:0]    reg_control_13,
  output      [31:0]    reg_control_14,
  output      [31:0]    reg_control_15,

  // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [16:0]  up_waddr,
  input       [31:0]  up_wdata,
  output reg          up_wack,
  input               up_rreq,
  input       [16:0]  up_raddr,
  output reg  [31:0]  up_rdata,
  output reg          up_rack);

  // internal registers

  genvar i;
  genvar j;

  generate

  reg     [31:0]  up_reg_control [N_STATUS_REG-1:0];

  wire    [31:0]  up_reg_status_s [N_STATUS_REG-1:0];
  wire    [31:0]  reg_status_s [N_STATUS_REG-1:0];
  wire    [31:0]  reg_control_s [N_STATUS_REG-1:0];

  wire   up_wreq_s;
  wire   up_rreq_s;

  assign up_wreq_s = (up_waddr[13:7] == {ADDR_OFFSET[13:8],1'b0}) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:7] == {ADDR_OFFSET[13:8],1'b0}) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
    end
  end

  for (j=0; j<N_CONTROL_REG; j=j+1) begin: reset
    always @(negedge up_rstn or posedge up_clk) begin
      if (up_rstn == 0) begin
        up_reg_control[j] <= 32'd0;
      end else begin
        if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h10+j)) begin
          up_reg_control[j] <= up_wdata;
        end
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
        if (up_raddr[4] == 0) begin
          if (up_raddr < N_STATUS_REG) begin
            up_rdata <= reg_status_s[up_raddr];
          end else begin
            up_rdata <= 32'b0;
          end
        end else begin
          if (up_raddr < N_CONTROL_REG) begin
            up_rdata <= up_reg_control[up_raddr[3:0]];
          end else begin
            up_rdata <= 32'b0;
          end
        end
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // adc control & status

  for (i=0; i<16; i=i+1) begin
    assign reg_status_s[0]  = reg_status_0;
    if (i>=1) begin
      assign reg_status_s[1]  = reg_status_1;
    end else begin
      assign reg_status_s[1]  = 32'd0;
    end
    if (i>=2) begin
      assign reg_status_s[2]  = reg_status_2;
    end else begin
      assign reg_status_s[2]  = 32'd0;
    end
    if (i>=3) begin
      assign reg_status_s[3]  = reg_status_3;
    end else begin
      assign reg_status_s[3]  = 32'd0;
    end
    if (i>=4) begin
      assign reg_status_s[4]  = reg_status_4;
    end else begin
      assign reg_status_s[4]  = 32'd0;
    end
    if (i>=5) begin
      assign reg_status_s[5]  = reg_status_5;
    end else begin
      assign reg_status_s[5]  = 32'd0;
    end
    if (i>=6) begin
      assign reg_status_s[6]  = reg_status_6;
    end else begin
      assign reg_status_s[6]  = 32'd0;
    end
    if (i>=7) begin
      assign reg_status_s[7]  = reg_status_7;
    end else begin
      assign reg_status_s[7]  = 32'd0;
    end
    if (i>=8) begin
      assign reg_status_s[8]  = reg_status_8;
    end else begin
      assign reg_status_s[8]  = 32'd0;
    end
    if (i>=9) begin
      assign reg_status_s[9]  = reg_status_9;
    end else begin
      assign reg_status_s[9]  = 32'd0;
    end
    if (i>=10) begin
      assign reg_status_s[10] = reg_status_10;
    end else begin
      assign reg_status_s[10] = 32'd0;
    end
    if (i>=11) begin
      assign reg_status_s[11] = reg_status_11;
    end else begin
      assign reg_status_s[11] = 32'd0;
    end
    if (i>=12) begin
      assign reg_status_s[12] = reg_status_12;
    end else begin
      assign reg_status_s[12] = 32'd0;
    end
    if (i>=13) begin
      assign reg_status_s[13] = reg_status_13;
    end else begin
      assign reg_status_s[13] = 32'd0;
    end
    if (i>=14) begin
      assign reg_status_s[14] = reg_status_14;
    end else begin
      assign reg_status_s[14] = 32'd0;
    end
    if (i==15) begin
      assign reg_status_s[15] = reg_status_15;
    end else begin
      assign reg_status_s[15] = 32'd0;
    end

    up_xfer_status #(.DATA_WIDTH(32)) i_xfer_status (
      .up_rstn (up_rstn),
      .up_clk (up_clk),
      .up_data_status (up_reg_status_s[i]),

      .up_xfer_done (),
      .d_rst (1'b0),
      .d_clk (clk),
      .d_data_status (reg_status_s[i]));
  end

  for (j=0; j<16; j=j+1) begin
    assign reg_control_0  = reg_control_s[0];
	  if (j>=1) begin
      assign reg_control_1  = reg_control_s[1];
    end else begin
      assign reg_control_1  = 32'd0;
    end
	  if (j>=2) begin
      assign reg_control_2  = reg_control_s[2];
    end else begin
      assign reg_control_2  = 32'd0;
    end
	  if (j>=3) begin
      assign reg_control_3  = reg_control_s[3];
    end else begin
      assign reg_control_3  = 32'd0;
    end
	  if (j>=4) begin
      assign reg_control_4  = reg_control_s[4];
    end else begin
      assign reg_control_4  = 32'd0;
    end
	  if (j>=5) begin
      assign reg_control_5  = reg_control_s[5];
    end else begin
      assign reg_control_5  = 32'd0;
    end
	  if (j>=6) begin
      assign reg_control_6  = reg_control_s[6];
    end else begin
      assign reg_control_6  = 32'd0;
    end
	  if (j>=7) begin
      assign reg_control_7  = reg_control_s[7];
    end else begin
      assign reg_control_7  = 32'd0;
    end
	  if (j>=8) begin
      assign reg_control_8  = reg_control_s[8];
    end else begin
      assign reg_control_8  = 32'd0;
    end
	  if (j>=9) begin
      assign reg_control_9  = reg_control_s[9];
    end else begin
      assign reg_control_9  = 32'd0;
    end
	  if (j>=10) begin
      assign reg_control_10 = reg_control_s[10];
    end else begin
      assign reg_control_10  = 32'd0;
    end
	  if (j>=11) begin
      assign reg_control_11 = reg_control_s[11];
    end else begin
      assign reg_control_11  = 32'd0;
    end
	  if (j>=12) begin
      assign reg_control_12 = reg_control_s[12];
    end else begin
      assign reg_control_12  = 32'd0;
    end
	  if (j>=13) begin
      assign reg_control_13 = reg_control_s[13];
    end else begin
      assign reg_control_13  = 32'd0;
    end
	  if (j>=14) begin
      assign reg_control_14 = reg_control_s[14];
    end else begin
      assign reg_control_14  = 32'd0;
    end
	  if (j==15) begin
      assign reg_control_15 = reg_control_s[15];
    end else begin
      assign reg_control_15  = 32'd0;
    end

    up_xfer_cntrl #(.DATA_WIDTH(32)) i_xfer_cntrl (
      .up_rstn (up_rstn),
      .up_clk (up_clk),
      .up_data_cntrl (up_reg_control[i]),

      .up_xfer_done (),
      .d_rst (1'b0),
      .d_clk (clk),
      .d_data_cntrl (reg_control_s[i]));

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

