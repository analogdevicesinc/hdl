// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module up_xfer_status #(

  parameter     DATA_WIDTH = 8
) (

  // up interface

  input                       up_rstn,
  input                       up_clk,
  output  [(DATA_WIDTH-1):0]  up_data_status,

  // device interface

  input                       d_rst,
  input                       d_clk,
  input   [(DATA_WIDTH-1):0]  d_data_status
);

  // internal registers

  wire                        d_xfer_state;
  reg     [ 5:0]              d_xfer_count = 'd0;
  reg                         d_xfer_toggle = 'd0;
  reg     [(DATA_WIDTH-1):0]  d_xfer_data = 'd0;
  reg     [(DATA_WIDTH-1):0]  d_acc_data = 'd0;
  wire                        up_xfer_toggle;
  reg                         up_xfer_toggle_d;
  reg     [(DATA_WIDTH-1):0]  up_data_status_int = 'd0;
  wire    [(DATA_WIDTH-1):0]  up_data_status_int_cdc;

  // internal signals

  wire                        d_xfer_enable_s;
  wire                        up_xfer_toggle_s;

  // device status transfer

  assign d_xfer_enable_s = d_xfer_state ^ d_xfer_toggle;

  always @(posedge d_clk or posedge d_rst) begin
    if (d_rst == 1'b1) begin
      d_xfer_count <= 'd0;
      d_xfer_toggle <= 'd0;
      d_xfer_data <= 'd0;
      d_acc_data <= 'd0;
    end else begin
      d_xfer_count <= d_xfer_count + 1'd1;
      if ((d_xfer_count == 6'd1) && (d_xfer_enable_s == 1'b0)) begin
        d_xfer_toggle <= ~d_xfer_toggle;
        d_xfer_data <= d_acc_data;
      end
      if ((d_xfer_count == 6'd1) && (d_xfer_enable_s == 1'b0)) begin
        d_acc_data <= d_data_status;
      end else begin
        d_acc_data <= d_acc_data | d_data_status;
      end
    end
  end

  assign up_data_status = up_data_status_int;
  assign up_xfer_toggle_s = up_xfer_toggle_d ^ up_xfer_toggle;

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_xfer_toggle_d <= 'd0;
      up_data_status_int <= 'd0;
    end else begin
      up_xfer_toggle_d <= up_xfer_toggle;
      if (up_xfer_toggle_s == 1'b1) begin
        up_data_status_int <= up_data_status_int_cdc;
      end
    end
  end

  sync_bits #(
    .SYNC_STAGES (3)
  ) i_sync_up_xfer_state (
    .in_bits(d_xfer_toggle),
    .out_clk(up_clk),
    .out_resetn(up_rstn),
    .out_bits(up_xfer_toggle));

  sync_bits #(
    .SYNC_STAGES (3)
  ) i_sync_up_xfer_toggle (
    .in_bits(up_xfer_toggle),
    .out_clk(d_clk),
    .out_resetn(~d_rst),
    .out_bits(d_xfer_state));

  sync_bits #(
    .NUM_OF_BITS (DATA_WIDTH)
  ) i_sync_up_xfer_data (
    .in_bits(d_xfer_data),
    .out_clk(up_clk),
    .out_resetn(up_rstn),
    .out_bits(up_data_status_int_cdc));

endmodule
