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

module ad_pps_receiver (
  input                 clk,
  input                 rst,
  input                 gps_pps,

  input                 up_clk,
  input                 up_rstn,
  output  reg [31:0]    up_pps_rcounter,
  output  reg           up_pps_status,
  input                 up_irq_mask,
  output  reg           up_irq);

  // *************************************************************************
  // 1PPS reception and reporting counter implementation
  // Note: this module should run on the core clock
  // *************************************************************************

  reg   [ 2:0]    gps_pps_m = 3'b0;
  reg   [ 2:0]    up_pps_m = 3'b0;
  reg             up_pps_status_m = 1'b0;
  reg             pps_toggle = 1'b0;
  reg   [31:0]    free_rcounter = 32'b0;
  reg   [31:0]    pps_rcounter = 32'b0;
  reg             pps_status = 1'b0;

  wire            pps_posedge_s;
  wire            up_pps_posedge_s;

  // gps_pps is asynchronous from the clk

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      gps_pps_m <= 3'b0;
    end else begin
      gps_pps_m <= {gps_pps_m[1:0], gps_pps};
    end
  end
  assign pps_posedge_s = ~gps_pps_m[2] & gps_pps_m[1];

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      free_rcounter <= 32'b0;
      pps_rcounter <= 32'b0;
      pps_status <= 1'b1;
    end else if (pps_posedge_s == 1'b1) begin
      free_rcounter <= 32'b0;
      pps_rcounter <= free_rcounter;
      pps_status <= 1'b0;
    end else begin
      free_rcounter <= free_rcounter + 32'b1;
      if (free_rcounter[28] == 1'b1) begin
        pps_status <= 1'b1;
      end
    end
  end

  // up_tdd_pps_rcounter CDC

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      pps_toggle <= 1'b0;
    end else if (pps_posedge_s == 1'b1) begin
      pps_toggle <= ~pps_toggle;
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_pps_m <= 3'b0;
      up_pps_rcounter <= 1'b0;
      up_pps_status_m <= 1'b1;
      up_pps_status <= 1'b1;
    end else begin
      up_pps_m <= {up_pps_m[1:0], pps_toggle};
      up_pps_status_m <= pps_status;
      up_pps_status <= up_pps_status_m;
      if ((up_pps_m[2] ^ up_pps_m[1]) == 1'b1) begin
        up_pps_rcounter <= pps_rcounter;
      end
    end
  end
  assign up_pps_posedge_s = ~up_pps_m[2] & up_pps_m[1];

  // IRQ generation

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_irq <= 1'b0;
    end else begin
      up_irq <= up_pps_posedge_s & ~up_irq_mask;
    end
  end

endmodule
