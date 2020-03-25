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

  parameter ADDR_OFFSET = 0x800 ) (    // 0x100 < ADDR_OFFSET < 0x3F00

  input              clk,
  
  input      [31:0]  reg_status_0,
  input      [31:0]  reg_status_1,
  input      [31:0]  reg_status_2,
  input      [31:0]  reg_status_3,
  output     [31:0]  reg_control_0,
  output     [31:0]  reg_control_1,
  output     [31:0]  reg_control_2,
  output     [31:0]  reg_control_3,

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

  reg     [31:0]  up_reg_status_0 = 32'h0;
  reg     [31:0]  up_reg_status_1 = 32'h0;
  reg     [31:0]  up_reg_status_2 = 32'h0;
  reg     [31:0]  up_reg_status_3 = 32'h0;
  reg     [31:0]  up_reg_control_0 = 32'h0;
  reg     [31:0]  up_reg_control_1 = 32'h0;
  reg     [31:0]  up_reg_control_2 = 32'h0;
  reg     [31:0]  up_reg_control_3 = 32'h0;
  
  wire   up_wreq_s;
  wire   up_rreq_s;
   
  assign up_wreq_s = (up_waddr[13:7] == {ADDR_OFFSET[13:8],1'b0}) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:7] == {ADDR_OFFSET[13:8],1'b0}) ? up_rreq : 1'b0;
  
  // processor write interface  

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
	  up_reg_status_0 <= 'd0;
      up_reg_status_1 <= 'd0;
      up_reg_status_2 <= 'd0;
      up_reg_status_3 <= 'd0;
      up_reg_control_0 <= 'd0;
      up_reg_control_1 <= 'd0;
      up_reg_control_2 <= 'd0;
      up_reg_control_3 <= 'd0;
     
    end else begin
      up_wack <= up_wreq_s;
	  if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h0)) begin
        up_reg_status_0 <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
        up_reg_status_1 <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h2)) begin
        up_reg_status_2 <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h3)) begin
        up_reg_status_3 <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h10)) begin
        up_reg_control_0 <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h11)) begin
        up_reg_control_1 <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h12)) begin
        up_reg_control_2 <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h13)) begin
        up_reg_control_3 <= up_wdata;
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
        case (up_raddr[4:0])
          5'h0: up_rdata <= up_reg_status_0;
          5'h1: up_rdata <= up_reg_status_1;
          5'h2: up_rdata <= up_reg_status_2;
          5'h3: up_rdata <= up_reg_status_3;
          5'h10: up_rdata <= up_reg_control_0;
          5'h11: up_rdata <= up_reg_control_1;
          5'h12: up_rdata <= up_reg_control_2;
          5'h13: up_rdata <= up_reg_control_3;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end
  
   // adc control & status

   up_xfer_cntrl #(.DATA_WIDTH(128)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_reg_control_0,         // 32
                      up_reg_control_1,         // 32      
                      up_reg_control_2,         // 32     
                      up_reg_control_3}),       // 32

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_cntrl ({  reg_control_0,            // 32
                      reg_control_1,            // 32      
                      reg_control_2,            // 32     
                      reg_control_3}));         // 32

  up_xfer_status #(.DATA_WIDTH(128)) i_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({ up_reg_status_0,         // 32  
                       up_reg_status_1,	        // 32
                       up_reg_status_2,         // 32  
                       up_reg_status_3}),       // 32

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_status ({ reg_status_0,             // 32  
                      reg_status_1,	            // 32
                      reg_status_2,             // 32  
                      reg_status_3}));          // 32					  
                     
endmodule

// ***************************************************************************
// ***************************************************************************

