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

module axi_adc_decimate_reg(

  input               clk,

  output      [31:0]  adc_decimation_ratio,
  output      [ 2:0]  adc_filter_mask,

  output              adc_correction_enable_a,
  output              adc_correction_enable_b,
  output      [15:0]  adc_correction_coefficient_a,
  output      [15:0]  adc_correction_coefficient_b,

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
  reg     [ 2:0]  up_filter_mask = 32'h0;

  reg     [ 1:0]  up_config = 1'h0;
  reg     [15:0]  up_correction_coefficient_a = 16'h0;
  reg     [15:0]  up_correction_coefficient_b = 16'h0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_decimation_ratio <= 'd0;
      up_filter_mask <= 'd0;
      up_config <= 'd0;
      up_correction_coefficient_a <= 'd0;
      up_correction_coefficient_b <= 'd0;
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
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h12)) begin
        up_config <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h13)) begin
        up_correction_coefficient_a <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h14)) begin
        up_correction_coefficient_b <= up_wdata[15:0];
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
          5'h11: up_rdata <= { 29'h0, up_filter_mask };
          5'h12: up_rdata <= { 30'h0, up_config };
          5'h13: up_rdata <= { 16'h0, up_correction_coefficient_a };
          5'h14: up_rdata <= { 16'h0, up_correction_coefficient_b };
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

   up_xfer_cntrl #(.DATA_WIDTH(69)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_config[1],                 // 1
                      up_config[0],                 // 1
                      up_correction_coefficient_b,  // 16
                      up_correction_coefficient_a,  // 16
                      up_decimation_ratio,          // 32
                      up_filter_mask}),             // 3

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_cntrl ({  adc_correction_enable_b,      // 1
                      adc_correction_enable_a,      // 1
                      adc_correction_coefficient_b, // 16
                      adc_correction_coefficient_a, // 16
                      adc_decimation_ratio,         // 32
                      adc_filter_mask}));           // 3

endmodule

// ***************************************************************************
// ***************************************************************************

