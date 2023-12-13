// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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

module up_tpl_common #(

  // parameters
  parameter COMMON_ID = 2'h0,   // Offset of regmap
  parameter NUM_PROFILES = 1 // Number of JESD profiles
) (
  input [NUM_PROFILES*8-1: 0] jesd_m,
  input [NUM_PROFILES*8-1: 0] jesd_l,
  input [NUM_PROFILES*8-1: 0] jesd_s,
  input [NUM_PROFILES*8-1: 0] jesd_f,
  input [NUM_PROFILES*8-1: 0] jesd_n,
  input [NUM_PROFILES*8-1: 0] jesd_np,

  output reg [$clog2(NUM_PROFILES):0] up_profile_sel = 'h0,

  // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [10:0]  up_waddr,
  input       [31:0]  up_wdata,
  output              up_wack,
  input               up_rreq,
  input       [10:0]  up_raddr,
  output      [31:0]  up_rdata,
  output              up_rack
);

  // internal registers
  reg             up_rack_int = 'd0;
  reg             up_wack_int = 'd0;
  reg     [31:0]  up_rdata_int = 'd0;

  // internal signals
  wire            up_wreq_s;
  wire            up_rreq_s;
  reg     [31:0]  up_rdata_jesd_params;

  // decode block select

  assign up_wreq_s = (up_waddr[10:7] == {COMMON_ID,1'b1}) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[10:7] == {COMMON_ID,1'b1}) ? up_rreq : 1'b0;

  // processor write interface

  assign up_wack = up_wack_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack_int <= 'd0;
      up_profile_sel <= 'd0;
    end else begin
      up_wack_int <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[6:0] == 7'h00)) begin
        up_profile_sel <= up_wdata[$clog2(NUM_PROFILES):0];
      end
    end
  end

  // processor read interface

  assign up_rack = up_rack_int;
  assign up_rdata = up_rdata_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
    end else begin
      up_rack_int <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[6:0])
          7'h00: up_rdata_int <= up_profile_sel;
          7'h01: up_rdata_int <= NUM_PROFILES;
          default: up_rdata_int <= up_rdata_jesd_params;
        endcase
      end else begin
        up_rdata_int <= 32'd0;
      end
    end
  end

  integer i;
  always @(*) begin
    for (i=0; i<NUM_PROFILES; i = i + 1) begin:jesd_param
      up_rdata_jesd_params = 0;
      if (up_rreq_s == 1'b1) begin
        if (up_raddr[6:0] == 7'h10 + {i[5:0],1'b0}) begin
          up_rdata_jesd_params = {jesd_f[i*8+:8], jesd_s[i*8+:8],
                                  jesd_l[i*8+:8], jesd_m[i*8+:8]};
        end
        if (up_raddr[6:0] == 7'h11 + {i[5:0],1'b0}) begin
          up_rdata_jesd_params = {16'b0,jesd_np[i*8+:8], jesd_n[i*8+:8]};
        end
      end
    end
  end

endmodule
