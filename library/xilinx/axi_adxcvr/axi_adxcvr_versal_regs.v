// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

module axi_adxcvr_versal_regs #(
  parameter   integer XCVR_TYPE = 0,
  parameter   integer NUM_OF_LANES = 8,
  parameter   integer NUM_RATES = 1,
  parameter  [255:0]  LANE_RATES_KHZ = 256'd0,
  parameter  [ 31:0]  REF_CLK_KHZ = 32'd0,
  parameter   integer NUM_OF_QUADS = 0,
  parameter  [255:0]  LANE_SLOTS = 256'h1f1e1d1c_1b1a1918_17161514_13121110_0f0e0d0c_0b0a0908_07060504_03020100
) (
  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [ 9:0]  up_waddr,
  input       [31:0]  up_wdata,
  input               up_rreq,
  input       [ 9:0]  up_raddr,
  output      [31:0]  up_rdata,
  output              up_pg_n,

  output      [ 7:0]  up_qm_enb,
  output     [127:0]  up_qm_addr,
  output      [ 7:0]  up_qm_wr,
  output     [255:0]  up_qm_wdata,
  input      [255:0]  up_qm_rdata,
  input       [ 7:0]  up_qm_ready,
  input       [ 7:0]  up_qm_slverr,
  input       [ 7:0]  up_qm_powergood
);

  // quads the lanes' slots span (ad_xcvrcon); 0 for the packed lanes
  localparam  integer QUADS = (NUM_OF_QUADS > 0) ? NUM_OF_QUADS : (NUM_OF_LANES + 3) / 4;
  localparam  [ 3:0]  NUM_OF_QUADS_W = QUADS;
  localparam  [ 3:0]  NUM_RATES_W = NUM_RATES;
  localparam  [ 7:0]  QUAD_MASK = (9'd1 << QUADS) - 1'b1;
  // eye scan, LPM and TX diffctrl exist on GTY/GTYP only (AM002); GTM lacks them
  localparam  [ 2:0]  CAPS = ((XCVR_TYPE == 11) || (XCVR_TYPE == 12)) ? 3'b111 : 3'b000;
  localparam  [31:0]  SYNTH_VERSAL = {12'd0, 1'b1, CAPS, 4'd0, NUM_OF_QUADS_W, 4'd0, NUM_RATES_W};

  generate
  if (XCVR_TYPE >= 11) begin : g_versal

    reg     [ 3:0]  up_qsel = 4'd0;
    reg     [15:0]  up_qaddr = 16'd0;
    reg             up_qwr = 1'b0;
    reg     [31:0]  up_qwdata = 32'd0;
    reg             up_qbusy = 1'b0;
    reg             up_qslverr = 1'b0;
    reg     [31:0]  up_qrdata = 32'd0;
    reg     [ 7:0]  up_qm_enb_int = 8'd0;
    reg     [31:0]  up_rdata_int = 32'd0;

    always @(negedge up_rstn or posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        up_qsel <= 4'd0;
        up_qaddr <= 16'd0;
        up_qwr <= 1'b0;
        up_qwdata <= 32'd0;
        up_qbusy <= 1'b0;
        up_qslverr <= 1'b0;
        up_qrdata <= 32'd0;
        up_qm_enb_int <= 8'd0;
      end else begin
        up_qm_enb_int <= 8'd0;
        if (up_wreq == 1'b1 && up_waddr == 10'h013 && up_qbusy == 1'b0) begin
          up_qsel <= up_wdata[3:0];
        end
        if (up_wreq == 1'b1 && up_waddr == 10'h015) begin
          up_qwdata <= up_wdata;
        end
        if (up_wreq == 1'b1 && up_waddr == 10'h014 && up_qbusy == 1'b0) begin
          up_qaddr <= up_wdata[15:0];
          up_qwr <= up_wdata[28];
          if (up_qsel < QUADS) begin
            up_qm_enb_int[up_qsel] <= 1'b1;
            up_qbusy <= 1'b1;
            up_qslverr <= 1'b0;
          end else begin
            up_qslverr <= 1'b1;
            up_qrdata <= 32'd0;
          end
        end else if (up_qbusy == 1'b1 && up_qm_ready[up_qsel] == 1'b1) begin
          up_qbusy <= 1'b0;
          up_qrdata <= up_qm_rdata[up_qsel*32 +: 32];
          up_qslverr <= up_qm_slverr[up_qsel];
        end
      end
    end

    always @(negedge up_rstn or posedge up_clk) begin
      if (up_rstn == 1'b0) begin
        up_rdata_int <= 32'd0;
      end else if (up_rreq == 1'b1) begin
        case (up_raddr)
          10'h00a: up_rdata_int <= SYNTH_VERSAL;
          10'h013: up_rdata_int <= {28'd0, up_qsel};
          10'h014: up_rdata_int <= {3'd0, up_qwr, 12'd0, up_qaddr};
          10'h015: up_rdata_int <= up_qwdata;
          10'h016: up_rdata_int <= {14'd0, up_qslverr, up_qbusy, 16'd0};
          10'h017: up_rdata_int <= up_qrdata;
          10'h070: up_rdata_int <= LANE_RATES_KHZ[ 31:  0];
          10'h071: up_rdata_int <= LANE_RATES_KHZ[ 63: 32];
          10'h072: up_rdata_int <= LANE_RATES_KHZ[ 95: 64];
          10'h073: up_rdata_int <= LANE_RATES_KHZ[127: 96];
          10'h074: up_rdata_int <= LANE_RATES_KHZ[159:128];
          10'h075: up_rdata_int <= LANE_RATES_KHZ[191:160];
          10'h076: up_rdata_int <= LANE_RATES_KHZ[223:192];
          10'h077: up_rdata_int <= LANE_RATES_KHZ[255:224];
          10'h078: up_rdata_int <= REF_CLK_KHZ;
          10'h079: up_rdata_int <= LANE_SLOTS[ 31:  0];
          10'h07a: up_rdata_int <= LANE_SLOTS[ 63: 32];
          10'h07b: up_rdata_int <= LANE_SLOTS[ 95: 64];
          10'h07c: up_rdata_int <= LANE_SLOTS[127: 96];
          10'h07d: up_rdata_int <= LANE_SLOTS[159:128];
          10'h07e: up_rdata_int <= LANE_SLOTS[191:160];
          10'h07f: up_rdata_int <= LANE_SLOTS[223:192];
          10'h080: up_rdata_int <= LANE_SLOTS[255:224];
          default: up_rdata_int <= 32'd0;
        endcase
      end else begin
        up_rdata_int <= 32'd0;
      end
    end

    assign up_rdata = up_rdata_int;
    assign up_pg_n = ~&(up_qm_powergood | ~QUAD_MASK);
    assign up_qm_enb = up_qm_enb_int;
    assign up_qm_addr = {8{up_qaddr}};
    assign up_qm_wr = {8{up_qwr}};
    assign up_qm_wdata = {8{up_qwdata}};

  end else begin : g_no_versal

    assign up_rdata = 32'd0;
    assign up_pg_n = 1'b0;
    assign up_qm_enb = 8'd0;
    assign up_qm_addr = 128'd0;
    assign up_qm_wr = 8'd0;
    assign up_qm_wdata = 256'd0;

  end
  endgenerate

endmodule
