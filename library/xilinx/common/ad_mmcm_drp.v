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
// MMCM_OR_BUFR_N with DRP and device specific

`timescale 1ns/100ps

module ad_mmcm_drp #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   MMCM_CLKIN_PERIOD  = 1.667,
  parameter   MMCM_CLKIN2_PERIOD  = 1.667,
  parameter   MMCM_VCO_DIV  = 6,
  parameter   MMCM_VCO_MUL = 12.000,
  parameter   MMCM_CLK0_DIV = 2.000,
  parameter   MMCM_CLK0_PHASE = 0.000,
  parameter   MMCM_CLK1_DIV = 6,
  parameter   MMCM_CLK1_PHASE = 0.000,
  parameter   MMCM_CLK2_DIV = 2.000,
  parameter   MMCM_CLK2_PHASE = 0.000) (

  // clocks

  input                   clk,
  input                   clk2,
  input                   clk_sel,
  input                   mmcm_rst,
  output                  mmcm_clk_0,
  output                  mmcm_clk_1,
  output                  mmcm_clk_2,

  // drp interface

  input                   up_clk,
  input                   up_rstn,
  input                   up_drp_sel,
  input                   up_drp_wr,
  input       [11:0]      up_drp_addr,
  input       [15:0]      up_drp_wdata,
  output  reg [15:0]      up_drp_rdata,
  output  reg             up_drp_ready,
  output  reg             up_drp_locked);

  localparam  SEVEN_SERIES = 1;
  localparam  ULTRASCALE = 2;
  localparam  ULTRASCALE_PLUS = 3;


  // internal registers

  reg             up_drp_locked_m1 = 'd0;

  // internal signals

  wire            bufg_fb_clk_s;
  wire            mmcm_fb_clk_s;
  wire            mmcm_clk_0_s;
  wire            mmcm_clk_1_s;
  wire            mmcm_clk_2_s;
  wire            mmcm_locked_s;
  wire    [15:0]  up_drp_rdata_s;
  wire            up_drp_ready_s;

  // drp read and locked

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_drp_rdata <= 'd0;
      up_drp_ready <= 'd0;
      up_drp_locked_m1 <= 1'd0;
      up_drp_locked <= 1'd0;
    end else begin
      up_drp_rdata <= up_drp_rdata_s;
      up_drp_ready <= up_drp_ready_s;
      up_drp_locked_m1 <= mmcm_locked_s;
      up_drp_locked <= up_drp_locked_m1;
    end
  end

  // instantiations

  generate
  if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
    MMCME2_ADV #(
      .BANDWIDTH ("OPTIMIZED"),
      .CLKOUT4_CASCADE ("FALSE"),
      .COMPENSATION ("ZHOLD"),
      .STARTUP_WAIT ("FALSE"),
      .DIVCLK_DIVIDE (MMCM_VCO_DIV),
      .CLKFBOUT_MULT_F (MMCM_VCO_MUL),
      .CLKFBOUT_PHASE (0.000),
      .CLKFBOUT_USE_FINE_PS ("FALSE"),
      .CLKOUT0_DIVIDE_F (MMCM_CLK0_DIV),
      .CLKOUT0_PHASE (MMCM_CLK0_PHASE),
      .CLKOUT0_DUTY_CYCLE (0.500),
      .CLKOUT0_USE_FINE_PS ("FALSE"),
      .CLKOUT1_DIVIDE (MMCM_CLK1_DIV),
      .CLKOUT1_PHASE (MMCM_CLK1_PHASE),
      .CLKOUT1_DUTY_CYCLE (0.500),
      .CLKOUT1_USE_FINE_PS ("FALSE"),
      .CLKOUT2_DIVIDE (MMCM_CLK2_DIV),
      .CLKOUT2_PHASE (MMCM_CLK2_PHASE),
      .CLKOUT2_DUTY_CYCLE (0.500),
      .CLKOUT2_USE_FINE_PS ("FALSE"),
      .CLKIN1_PERIOD (MMCM_CLKIN_PERIOD),
      .CLKIN2_PERIOD (MMCM_CLKIN2_PERIOD),
      .REF_JITTER1 (0.010))
    i_mmcm (
      .CLKIN1 (clk),
      .CLKFBIN (bufg_fb_clk_s),
      .CLKFBOUT (mmcm_fb_clk_s),
      .CLKOUT0 (mmcm_clk_0_s),
      .CLKOUT1 (mmcm_clk_1_s),
      .CLKOUT2 (mmcm_clk_2_s),
      .LOCKED (mmcm_locked_s),
      .DCLK (up_clk),
      .DEN (up_drp_sel),
      .DADDR (up_drp_addr[6:0]),
      .DWE (up_drp_wr),
      .DI (up_drp_wdata),
      .DO (up_drp_rdata_s),
      .DRDY (up_drp_ready_s),
      .CLKFBOUTB (),
      .CLKOUT0B (),
      .CLKOUT1B (),
      .CLKOUT2B (),
      .CLKOUT3 (),
      .CLKOUT3B (),
      .CLKOUT4 (),
      .CLKOUT5 (),
      .CLKOUT6 (),
      .CLKIN2 (clk2),
      .CLKINSEL (clk_sel),
      .PSCLK (1'b0),
      .PSEN (1'b0),
      .PSINCDEC (1'b0),
      .PSDONE (),
      .CLKINSTOPPED (),
      .CLKFBSTOPPED (),
      .PWRDWN (1'b0),
      .RST (mmcm_rst));

      BUFG i_fb_clk_bufg  (.I (mmcm_fb_clk_s),  .O (bufg_fb_clk_s));
      BUFG i_clk_0_bufg   (.I (mmcm_clk_0_s),   .O (mmcm_clk_0));
      BUFG i_clk_1_bufg   (.I (mmcm_clk_1_s),   .O (mmcm_clk_1));
      BUFG i_clk_2_bufg   (.I (mmcm_clk_2_s),   .O (mmcm_clk_2));

  end else if (FPGA_TECHNOLOGY == ULTRASCALE) begin
    MMCME3_ADV #(
      .BANDWIDTH ("OPTIMIZED"),
      .CLKOUT4_CASCADE ("FALSE"),
      .COMPENSATION ("AUTO"),
      .STARTUP_WAIT ("FALSE"),

      .DIVCLK_DIVIDE (MMCM_VCO_DIV),
      .CLKFBOUT_MULT_F (MMCM_VCO_MUL),
      .CLKFBOUT_PHASE (0.000),
      .CLKFBOUT_USE_FINE_PS ("FALSE"),
      .CLKOUT0_DIVIDE_F (MMCM_CLK0_DIV),
      .CLKOUT0_PHASE (MMCM_CLK0_PHASE),
      .CLKOUT0_DUTY_CYCLE (0.500),
      .CLKOUT0_USE_FINE_PS ("FALSE"),
      .CLKOUT1_DIVIDE (MMCM_CLK1_DIV),
      .CLKOUT1_PHASE (MMCM_CLK1_PHASE),
      .CLKOUT1_DUTY_CYCLE (0.500),
      .CLKOUT1_USE_FINE_PS ("FALSE"),
      .CLKOUT2_DIVIDE (MMCM_CLK2_DIV),
      .CLKOUT2_PHASE (MMCM_CLK2_PHASE),
      .CLKOUT2_DUTY_CYCLE (0.500),
      .CLKOUT2_USE_FINE_PS ("FALSE"),
      .CLKIN1_PERIOD (MMCM_CLKIN_PERIOD),
      .CLKIN2_PERIOD (MMCM_CLKIN2_PERIOD),
      .REF_JITTER1 (0.010))
    i_mmcme3 (
      .CLKIN1 (clk),
      .CLKFBIN (bufg_fb_clk_s),
      .CLKFBOUT (mmcm_fb_clk_s),
      .CLKOUT0 (mmcm_clk_0_s),
      .CLKOUT1 (mmcm_clk_1_s),
      .CLKOUT2 (mmcm_clk_2_s),
      .LOCKED (mmcm_locked_s),
      .DCLK (up_clk),
      .DEN (up_drp_sel),
      .DADDR (up_drp_addr[6:0]),
      .DWE (up_drp_wr),
      .DI (up_drp_wdata),
      .DO (up_drp_rdata_s),
      .DRDY (up_drp_ready_s),
      .CLKFBOUTB (),
      .CLKOUT0B (),
      .CLKOUT1B (),
      .CLKOUT2B (),
      .CLKOUT3 (),
      .CLKOUT3B (),
      .CLKOUT4 (),
      .CLKOUT5 (),
      .CLKOUT6 (),
      .CLKIN2 (clk2),
      .CLKINSEL (clk_sel),
      .PSCLK (1'b0),
      .PSEN (1'b0),
      .PSINCDEC (1'b0),
      .PSDONE (),
      .CLKINSTOPPED (),
      .CLKFBSTOPPED (),
      .PWRDWN (1'b0),
      .CDDCREQ (1'b0),
      .CDDCDONE (),
      .RST (mmcm_rst));

      BUFG i_fb_clk_bufg  (.I (mmcm_fb_clk_s),  .O (bufg_fb_clk_s));
      BUFG i_clk_0_bufg   (.I (mmcm_clk_0_s),   .O (mmcm_clk_0));
      BUFG i_clk_1_bufg   (.I (mmcm_clk_1_s),   .O (mmcm_clk_1));
      BUFG i_clk_2_bufg   (.I (mmcm_clk_2_s),   .O (mmcm_clk_2));

  end else if (FPGA_TECHNOLOGY == ULTRASCALE_PLUS) begin
    MMCME4_ADV #(
      .BANDWIDTH ("OPTIMIZED"),
      .CLKOUT4_CASCADE ("FALSE"),
      .COMPENSATION ("AUTO"),
      .STARTUP_WAIT ("FALSE"),

      .DIVCLK_DIVIDE (MMCM_VCO_DIV),
      .CLKFBOUT_MULT_F (MMCM_VCO_MUL),
      .CLKFBOUT_PHASE (0.000),
      .CLKFBOUT_USE_FINE_PS ("FALSE"),
      .CLKOUT0_DIVIDE_F (MMCM_CLK0_DIV),
      .CLKOUT0_PHASE (MMCM_CLK0_PHASE),
      .CLKOUT0_DUTY_CYCLE (0.500),
      .CLKOUT0_USE_FINE_PS ("FALSE"),
      .CLKOUT1_DIVIDE (MMCM_CLK1_DIV),
      .CLKOUT1_PHASE (MMCM_CLK1_PHASE),
      .CLKOUT1_DUTY_CYCLE (0.500),
      .CLKOUT1_USE_FINE_PS ("FALSE"),
      .CLKOUT2_DIVIDE (MMCM_CLK2_DIV),
      .CLKOUT2_PHASE (MMCM_CLK2_PHASE),
      .CLKOUT2_DUTY_CYCLE (0.500),
      .CLKOUT2_USE_FINE_PS ("FALSE"),
      .CLKIN1_PERIOD (MMCM_CLKIN_PERIOD),
      .CLKIN2_PERIOD (MMCM_CLKIN2_PERIOD)
    ) i_mmcme4 (
      .CLKIN1 (clk),
      .CLKFBIN (bufg_fb_clk_s),
      .CLKFBOUT (mmcm_fb_clk_s),
      .CLKOUT0 (mmcm_clk_0_s),
      .CLKOUT1 (mmcm_clk_1_s),
      .CLKOUT2 (mmcm_clk_2_s),
      .LOCKED (mmcm_locked_s),
      .DCLK (up_clk),
      .DEN (up_drp_sel),
      .DADDR (up_drp_addr[6:0]),
      .DWE (up_drp_wr),
      .DI (up_drp_wdata),
      .DO (up_drp_rdata_s),
      .DRDY (up_drp_ready_s),
      .CLKFBOUTB (),
      .CLKOUT0B (),
      .CLKOUT1B (),
      .CLKOUT2B (),
      .CLKOUT3 (),
      .CLKOUT3B (),
      .CLKOUT4 (),
      .CLKOUT5 (),
      .CLKOUT6 (),
      .CLKIN2 (clk2),
      .CLKINSEL (clk_sel),
      .PSCLK (1'b0),
      .PSEN (1'b0),
      .PSINCDEC (1'b0),
      .PSDONE (),
      .CLKINSTOPPED (),
      .CLKFBSTOPPED (),
      .PWRDWN (1'b0),
      .CDDCREQ (1'b0),
      .CDDCDONE (),
      .RST (mmcm_rst));

      BUFG i_fb_clk_bufg  (.I (mmcm_fb_clk_s),  .O (bufg_fb_clk_s));
      BUFG i_clk_0_bufg   (.I (mmcm_clk_0_s),   .O (mmcm_clk_0));
      BUFG i_clk_1_bufg   (.I (mmcm_clk_1_s),   .O (mmcm_clk_1));
      BUFG i_clk_2_bufg   (.I (mmcm_clk_2_s),   .O (mmcm_clk_2));

  end
  endgenerate


endmodule

// ***************************************************************************
// ***************************************************************************
