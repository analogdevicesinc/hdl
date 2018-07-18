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

module up_delay_cntrl #(

  // parameters

  parameter   DISABLE = 0,
  parameter   INIT_DELAY = 0,
  parameter   DATA_WIDTH = 8,
  parameter   BASE_ADDRESS = 6'h02) (

  // delay interface

  input                           delay_clk,
  output                          delay_rst,
  input                           delay_locked,

  // io interface

  output  [(DATA_WIDTH-1):0]      up_dld,
  output  [((DATA_WIDTH*5)-1):0]  up_dwdata,
  input   [((DATA_WIDTH*5)-1):0]  up_drdata,

  // processor interface

  input                           up_rstn,
  input                           up_clk,
  input                           up_wreq,
  input   [13:0]                  up_waddr,
  input   [31:0]                  up_wdata,
  output                          up_wack,
  input                           up_rreq,
  input   [13:0]                  up_raddr,
  output  [31:0]                  up_rdata,
  output                          up_rack);

  generate
  if (DISABLE == 1) begin
  assign up_wack = 1'd0;
  assign up_rack = 1'd0;
  assign up_rdata = 32'd0;

  assign up_dld = 'd0;
  assign up_dwdata = 'd0;

  assign delay_rst = 1'd0;

  end else begin
  // internal registers

  reg                             up_preset = 'd0;
  reg                             up_wack_int = 'd0;
  reg                             up_rack_int = 'd0;
  reg     [31:0]                  up_rdata_int = 'd0;
  reg                             up_dlocked_m1 = 'd0;
  reg                             up_dlocked_m2 = 'd0;
  reg                             up_dlocked_m3 = 'd0;
  reg                             up_dlocked = 'd0;
  reg     [(DATA_WIDTH-1):0]      up_dld_int = 'd0;
  reg     [((DATA_WIDTH*5)-1):0]  up_dwdata_int = 'd0;

  // internal signals

  wire                            up_wreq_s;
  wire                            up_rreq_s;
  wire    [ 4:0]                  up_rdata_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata4_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata3_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata2_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata1_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata0_s;
  wire    [(DATA_WIDTH-1):0]      up_dld_s;
  wire    [((DATA_WIDTH*5)-1):0]  up_dwdata_s;
  wire    [(DATA_WIDTH-1):0]      up_dinit_s;
  wire    [((DATA_WIDTH*5)-1):0]  up_dinitdata_s;
  wire                            delay_rst_s;

  // variables

  genvar                          n;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == BASE_ADDRESS) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == BASE_ADDRESS) ? up_rreq : 1'b0;
  assign up_rdata_s[4] = | up_drdata4_s;
  assign up_rdata_s[3] = | up_drdata3_s;
  assign up_rdata_s[2] = | up_drdata2_s;
  assign up_rdata_s[1] = | up_drdata1_s;
  assign up_rdata_s[0] = | up_drdata0_s;

  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_drd
  assign up_drdata4_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+4)] : 1'd0;
  assign up_drdata3_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+3)] : 1'd0;
  assign up_drdata2_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+2)] : 1'd0;
  assign up_drdata1_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+1)] : 1'd0;
  assign up_drdata0_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+0)] : 1'd0;
  end

  // processor interface

  assign up_wack = up_wack_int;
  assign up_rack = up_rack_int;
  assign up_rdata = up_rdata_int;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_preset <= 1'd1;
      up_wack_int <= 'd0;
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
      up_dlocked_m1 <= 'd0;
      up_dlocked_m2 <= 'd0;
      up_dlocked_m3 <= 'd0;
      up_dlocked <= 'd0;
    end else begin
      up_preset <= 1'd0;
      up_wack_int <= up_wreq_s;
      up_rack_int <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        if (up_dlocked == 1'b0) begin
          up_rdata_int <= 32'hffffffff;
        end else begin
          up_rdata_int <= {27'd0, up_rdata_s};
        end
      end else begin
        up_rdata_int <= 32'd0;
      end
      up_dlocked_m1 <= delay_locked;
      up_dlocked_m2 <= up_dlocked_m1;
      up_dlocked_m3 <= up_dlocked_m2;
      up_dlocked <= up_dlocked_m3;
    end
  end

  // init delay values (after delay locked)

  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_dinit
  assign up_dinit_s[n] = up_dlocked_m2 & ~up_dlocked_m3;
  assign up_dinitdata_s[((n*5)+4):(n*5)] = INIT_DELAY;
  end

  // write does not hold- read back what goes into effect.

  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_dwr
  assign up_dld_s[n] = (up_waddr[7:0] == n) ? up_wreq_s : 1'b0;
  assign up_dwdata_s[((n*5)+4):(n*5)] = (up_waddr[7:0] == n) ?
    up_wdata[4:0] : up_dwdata_int[((n*5)+4):(n*5)];
  end

  assign up_dld = up_dld_int;
  assign up_dwdata = up_dwdata_int;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dld_int <= 'd0;
      up_dwdata_int <= 'd0;
    end else begin
      up_dld_int <= up_dld_s | up_dinit_s;
      if ((up_dlocked_m2 == 1'b1) && (up_dlocked_m3 == 1'b0)) begin
        up_dwdata_int <= up_dinitdata_s;
      end else if (up_wreq_s == 1'b1) begin
        up_dwdata_int <= up_dwdata_s;
      end
    end
  end

  // resets

  assign delay_rst = delay_rst_s;

  ad_rst i_delay_rst_reg (
    .rst_async (up_preset),
    .clk (delay_clk),
    .rstn (),
    .rst (delay_rst_s));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
