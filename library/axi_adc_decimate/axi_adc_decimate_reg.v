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

module axi_adc_decimate_reg(

  input               clk,

  output      [31:0]  adc_decimation_ratio,
  output      [ 2:0]  adc_filter_mask,

 // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [ 4:0]  up_waddr,
  input       [31:0]  up_wdata,
  output  reg         up_wack,
  input               up_rreq,
  input       [ 4:0]  up_raddr,
  output  reg [31:0]  up_rdata,
  output  reg         up_rack);

  // internal registers

  reg     [31:0]  up_version = 32'h00010000;
  reg     [31:0]  up_scratch = 32'h0;

  reg     [31:0]  up_decimation_ratio = 32'h0;
  reg     [ 2:0]  up_filter_mask  = 32'h0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_decimation_ratio <= 'd0;
      up_filter_mask <= 'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h10)) begin
        up_decimation_ratio <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h11)) begin
        up_filter_mask <= up_wdata[2:0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr[4:0])
          5'h0: up_rdata  <= up_version;
          5'h1: up_rdata  <= up_scratch;
          5'h10: up_rdata <= up_decimation_ratio;
          5'h11: up_rdata <= up_filter_mask;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

   up_xfer_cntrl #(.DATA_WIDTH(35)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_decimation_ratio,  // 32
                      up_filter_mask}),     // 3

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_cntrl ({  adc_decimation_ratio, // 32
                      adc_filter_mask}));   // 3

endmodule

// ***************************************************************************
// ***************************************************************************

