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

module up_xfer_cntrl #(

  parameter     DATA_WIDTH = 8
) (

  // up interface

  input                       up_rstn,
  input                       up_clk,
  input   [(DATA_WIDTH-1):0]  up_data_cntrl,
  output                      up_xfer_done,

  // device interface

  input                       d_rst,
  input                       d_clk,
  output  [(DATA_WIDTH-1):0]  d_data_cntrl
);

  // internal registers

  wire                        up_xfer_state;
  reg     [ 5:0]              up_xfer_count = 'd0;
  reg                         up_xfer_done_int = 'd0;
  reg                         up_xfer_toggle = 'd0;
  reg     [(DATA_WIDTH-1):0]  up_xfer_data = 'd0;
  wire                        d_xfer_toggle;
  reg                         d_xfer_toggle_d;
  reg     [(DATA_WIDTH-1):0]  d_data_cntrl_int = 'd0;
  wire    [(DATA_WIDTH-1):0]  d_data_cntrl_int_cdc;

  // internal signals

  wire                        up_xfer_enable_s;
  wire                        d_xfer_toggle_s;

  // device control transfer

  assign up_xfer_done = up_xfer_done_int;
  assign up_xfer_enable_s = up_xfer_state ^ up_xfer_toggle;

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_xfer_toggle <= 'd0;
      up_xfer_count <= 'd0;
      up_xfer_done_int <= 'd0;
      up_xfer_data <= 'd0;
    end else begin
      up_xfer_toggle <= ~up_xfer_toggle;
      up_xfer_count <= up_xfer_count + 1'd1;
      up_xfer_done_int <= (up_xfer_count == 6'd0) ? ~up_xfer_enable_s : 1'b0;
      if ((up_xfer_count == 6'd1) && (up_xfer_enable_s == 1'b0)) begin
        up_xfer_data <= up_data_cntrl;
      end
    end
  end

  assign d_data_cntrl = d_data_cntrl_int;
  assign d_xfer_toggle_s = d_xfer_toggle_d ^ d_xfer_toggle;

  always @(posedge d_clk or posedge d_rst) begin
    if (d_rst == 1'b1) begin
      d_xfer_toggle_d <= 'd0;
      d_data_cntrl_int <= 'd0;
    end else begin
      d_xfer_toggle_d <= d_xfer_toggle;
      if (d_xfer_toggle_s == 1'b1) begin
        d_data_cntrl_int <= d_data_cntrl_int_cdc;
      end
    end
  end

  sync_bits #(
    .SYNC_STAGES (3)
  ) i_sync_up_xfer_state (
    .in_bits(d_xfer_toggle),
    .out_clk(up_clk),
    .out_resetn(up_rstn),
    .out_bits(up_xfer_state));

  sync_bits #(
    .SYNC_STAGES (3)
  ) i_sync_up_xfer_toggle (
    .in_bits(up_xfer_toggle),
    .out_clk(d_clk),
    .out_resetn(~d_rst),
    .out_bits(d_xfer_toggle));

  sync_bits #(
    .NUM_OF_BITS (DATA_WIDTH)
  ) i_sync_up_xfer_data (
    .in_bits(up_xfer_data),
    .out_clk(d_clk),
    .out_resetn(~d_rst),
    .out_bits(d_data_cntrl_int_cdc));

endmodule
