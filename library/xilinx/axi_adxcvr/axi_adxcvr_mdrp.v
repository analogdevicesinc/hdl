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

`timescale 1ns/1ps

module axi_adxcvr_mdrp (

  input           up_rstn,
  input           up_clk,

  input   [ 7:0]  up_sel,
  input           up_enb,
  output          up_enb_out,
  input   [15:0]  up_rdata_in,
  input           up_ready_in,
  input   [15:0]  up_rdata,
  input           up_ready,
  output  [15:0]  up_rdata_out,
  output          up_ready_out);

  // parameters

  parameter   integer XCVR_ID = 0;
  parameter   integer NUM_OF_LANES = 8;

  // internal registers

  reg     [15:0]  up_rdata_int = 'd0;
  reg             up_ready_int = 'd0;
  reg             up_ready_mi = 'd0;
  reg     [15:0]  up_rdata_i = 'd0;
  reg             up_ready_i = 'd0;
  reg     [15:0]  up_rdata_m = 'd0;
  reg             up_ready_m = 'd0;

  // internal signals

  wire            up_ready_s;
  wire    [15:0]  up_rdata_mi_s;
  wire            up_ready_mi_s;

  // disable if not selected

  assign up_rdata_out = up_rdata_int;
  assign up_ready_out = up_ready_int;

  assign up_enb_out = (up_sel == 8'hff || up_sel == XCVR_ID) ? up_enb : 1'b0;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata_int <= 16'd0;
      up_ready_int <= 1'b0;
    end else begin
      case (up_sel)
        8'hff: begin
          up_rdata_int <= up_rdata_mi_s;
          up_ready_int <= up_ready_mi_s & ~up_ready_mi;
        end
        XCVR_ID: begin
          up_rdata_int <= up_rdata;
          up_ready_int <= up_ready;
        end
        default: begin
          up_rdata_int <= up_rdata_in;
          up_ready_int <= up_ready_in;
        end
      endcase
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_ready_mi <= 1'b0;
    end else begin
      up_ready_mi <= up_ready_mi_s;
    end
  end

  assign up_rdata_mi_s = up_rdata_m | up_rdata_i;
  assign up_ready_mi_s = up_ready_m & up_ready_i;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata_i <= 16'd0;
      up_ready_i <= 1'b0;
    end else begin
      if (up_ready_in == 1'b1) begin
        up_rdata_i <= up_rdata_in;
        up_ready_i <= 1'b1;
      end else if (up_enb == 1'b1) begin
        up_rdata_i <= 16'd0;
        up_ready_i <= 1'b0;
      end
    end
  end

  generate
  if (XCVR_ID < NUM_OF_LANES) begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata_m <= 16'd0;
      up_ready_m <= 1'b0;
    end else begin
      if (up_ready == 1'b1) begin
        up_rdata_m <= up_rdata;
        up_ready_m <= 1'b1;
      end else if (up_enb == 1'b1) begin
        up_rdata_m <= 16'd0;
        up_ready_m <= 1'b0;
      end
    end
  end
  end else begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata_m <= 16'd0;
      up_ready_m <= 1'b0;
    end else begin
      up_rdata_m <= 16'd0;
      up_ready_m <= 1'b1;
    end
  end
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

