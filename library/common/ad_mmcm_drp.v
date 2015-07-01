// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// MMCM with DRP and device specific

`timescale 1ns/100ps

module ad_mmcm_drp (

  // clocks

  clk,
  mmcm_rst,
  mmcm_clk_0,
  mmcm_clk_1,

  // drp interface

  up_clk,
  up_rstn,
  up_drp_sel,
  up_drp_wr,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,
  up_drp_locked);

  // parameters

  parameter   MMCM_DEVICE_TYPE = 0;
  localparam  MMCM_DEVICE_7SERIES = 0;
  localparam  MMCM_DEVICE_VIRTEX6 = 1;

  parameter   MMCM_CLKIN_PERIOD  = 1.667;
  parameter   MMCM_VCO_DIV  = 6;
  parameter   MMCM_VCO_MUL = 12.000;
  parameter   MMCM_CLK0_DIV = 2.000;
  parameter   MMCM_CLK1_DIV = 6;

  // clocks

  input           clk;
  input           mmcm_rst;
  output          mmcm_clk_0;
  output          mmcm_clk_1;

  // drp interface

  input           up_clk;
  input           up_rstn;
  input           up_drp_sel;
  input           up_drp_wr;
  input   [11:0]  up_drp_addr;
  input   [15:0]  up_drp_wdata;
  output  [15:0]  up_drp_rdata;
  output          up_drp_ready;
  output          up_drp_locked;

  // internal registers

  reg     [15:0]  up_drp_rdata = 'd0;
  reg             up_drp_ready = 'd0;
  reg             up_drp_locked_m1 = 'd0;
  reg             up_drp_locked = 'd0;

  // internal signals

  wire            bufg_fb_clk_s;
  wire            mmcm_fb_clk_s;
  wire            mmcm_clk_0_s;
  wire            mmcm_clk_1_s;
  wire            mmcm_locked_s;
  wire    [15:0]  up_drp_rdata_s;
  wire            up_drp_ready_s;

  // drp read and locked

  always @(negedge up_rstn or posedge up_clk) begin
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
  if (MMCM_DEVICE_TYPE == MMCM_DEVICE_VIRTEX6) begin
  MMCM_ADV #(
    .BANDWIDTH ("OPTIMIZED"),
    .CLKOUT4_CASCADE ("FALSE"),
    .CLOCK_HOLD ("FALSE"),
    .COMPENSATION ("ZHOLD"),
    .STARTUP_WAIT ("FALSE"),
    .DIVCLK_DIVIDE (MMCM_VCO_DIV),
    .CLKFBOUT_MULT_F (MMCM_VCO_MUL),
    .CLKFBOUT_PHASE (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F (MMCM_CLK0_DIV),
    .CLKOUT0_PHASE (0.000),
    .CLKOUT0_DUTY_CYCLE (0.500),
    .CLKOUT0_USE_FINE_PS ("FALSE"),
    .CLKOUT1_DIVIDE (MMCM_CLK1_DIV),
    .CLKOUT1_PHASE (0.000),
    .CLKOUT1_DUTY_CYCLE (0.500),
    .CLKOUT1_USE_FINE_PS ("FALSE"),
    .CLKIN1_PERIOD (MMCM_CLKIN_PERIOD),
    .REF_JITTER1 (0.010))
  i_mmcm (
    .CLKIN1 (clk),
    .CLKFBIN (bufg_fb_clk_s),
    .CLKFBOUT (mmcm_fb_clk_s),
    .CLKOUT0 (mmcm_clk_0_s),
    .CLKOUT1 (mmcm_clk_1_s),
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
    .CLKOUT2 (),
    .CLKOUT2B (),
    .CLKOUT3 (),
    .CLKOUT3B (),
    .CLKOUT4 (),
    .CLKOUT5 (),
    .CLKOUT6 (),
    .CLKIN2 (1'b0),
    .CLKINSEL (1'b1),
    .PSCLK (1'b0),
    .PSEN (1'b0),
    .PSINCDEC (1'b0),
    .PSDONE (),
    .CLKINSTOPPED (),
    .CLKFBSTOPPED (),
    .PWRDWN (1'b0),
    .RST (mmcm_rst));
  end

  if (MMCM_DEVICE_TYPE == MMCM_DEVICE_7SERIES) begin
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
    .CLKOUT0_PHASE (0.000),
    .CLKOUT0_DUTY_CYCLE (0.500),
    .CLKOUT0_USE_FINE_PS ("FALSE"),
    .CLKOUT1_DIVIDE (MMCM_CLK1_DIV),
    .CLKOUT1_PHASE (0.000),
    .CLKOUT1_DUTY_CYCLE (0.500),
    .CLKOUT1_USE_FINE_PS ("FALSE"),
    .CLKIN1_PERIOD (MMCM_CLKIN_PERIOD),
    .REF_JITTER1 (0.010))
  i_mmcm (
    .CLKIN1 (clk),
    .CLKFBIN (bufg_fb_clk_s),
    .CLKFBOUT (mmcm_fb_clk_s),
    .CLKOUT0 (mmcm_clk_0_s),
    .CLKOUT1 (mmcm_clk_1_s),
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
    .CLKOUT2 (),
    .CLKOUT2B (),
    .CLKOUT3 (),
    .CLKOUT3B (),
    .CLKOUT4 (),
    .CLKOUT5 (),
    .CLKOUT6 (),
    .CLKIN2 (1'b0),
    .CLKINSEL (1'b1),
    .PSCLK (1'b0),
    .PSEN (1'b0),
    .PSINCDEC (1'b0),
    .PSDONE (),
    .CLKINSTOPPED (),
    .CLKFBSTOPPED (),
    .PWRDWN (1'b0),
    .RST (mmcm_rst));
  end
  endgenerate

  BUFG i_fb_clk_bufg  (.I (mmcm_fb_clk_s),  .O (bufg_fb_clk_s));
  BUFG i_clk_0_bufg   (.I (mmcm_clk_0_s),   .O (mmcm_clk_0)); 
  BUFG i_clk_1_bufg   (.I (mmcm_clk_1_s),   .O (mmcm_clk_1));

endmodule

// ***************************************************************************
// ***************************************************************************
