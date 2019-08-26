// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2019 (c) Analog Devices, Inc. All rights reserved.
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

module axi_laser_driver #(

  parameter       ID = 0,
  parameter [0:0] ASYNC_CLK_EN = 1,
  parameter       PULSE_WIDTH = 7,
  parameter       PULSE_PERIOD = 10 )(

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready,

  // external clock and control/status signals

  input                   ext_clk,
  output                  driver_en_n,
  output                  driver_pulse,
  input                   driver_otw_n,
  output                  driver_dp_reset,
  output reg  [ 7:0]      tia_chsel,

  // interrupt

  output                  irq);

  // internal signals

  reg             up_wack = 1'b0;
  reg             up_rack = 1'b0;
  reg     [31:0]  up_rdata = 32'b0;
  reg             driver_pulse_int_d = 1'b0;
  reg     [ 1:0]  sequence_counter = 2'b00;

  // internal signals

  wire            clk;
  wire            up_clk;
  wire            up_rstn;
  wire            up_rreq_s;
  wire            up_rack_ld_s;
  wire            up_rack_pwm_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_rdata_ld_s;
  wire    [31:0]  up_rdata_pwm_s;
  wire            up_wreq_s;
  wire            up_wack_ld_s;
  wire            up_wack_pwm_s;
  wire    [13:0]  up_waddr_s;
  wire    [31:0]  up_wdata_s;
  wire    [31:0]  pulse_width_s;
  wire    [31:0]  pulse_period_s;
  wire            load_config_s;
  wire            pulse_gen_resetn;
  wire    [31:0]  pulse_counter_s;
  wire            driver_pulse_int_s;
  wire    [31:0]  up_ext_clk_count_s;
  wire            sequence_en_s;
  wire            auto_sequence_s;
  wire    [31:0]  sequence_offset_s;
  wire    [ 1:0]  auto_seq0_s;
  wire    [ 1:0]  auto_seq1_s;
  wire    [ 1:0]  auto_seq2_s;
  wire    [ 1:0]  auto_seq3_s;
  wire    [ 7:0]  manual_select_s;

  // local parameters

  localparam [31:0] CORE_VERSION = {16'h0001,     /* MAJOR */
                                     8'h00,       /* MINOR */
                                     8'h61};      /* PATCH */ // 1.00.a
  localparam [31:0] CORE_MAGIC = 32'h4C534452;    // LSDR

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // register maps

  axi_pulse_gen_regmap #(
    .ID (ID),
    .CORE_MAGIC (CORE_MAGIC),
    .CORE_VERSION (CORE_VERSION),
    .ASYNC_CLK_EN (ASYNC_CLK_EN),
    .PULSE_WIDTH (PULSE_WIDTH),
    .PULSE_PERIOD (PULSE_PERIOD))
  i_pwm_regmap (
    .ext_clk (ext_clk),
    .clk_out (clk),
    .pulse_gen_resetn (pulse_gen_resetn),
    .pulse_width (pulse_width_s),
    .pulse_period (pulse_period_s),
    .load_config (load_config_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_pwm_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_pwm_s),
    .up_rack (up_rack_pwm_s));

  axi_laser_driver_regmap #(
    .ID (ID),
    .LASER_DRIVER_ID (1))
  i_laser_driver_regmap (
    .clk (clk),
    .driver_en_n (driver_en_n),
    .driver_otw_n (driver_otw_n),
    .pulse (driver_pulse_int_s),
    .up_ext_clk_count (up_ext_clk_count_s),
    .irq (irq),
    .sequence_en (sequence_en_s),
    .auto_sequence (auto_sequence_s),
    .sequence_offset (sequence_offset_s),
    .auto_seq0 (auto_seq0_s),
    .auto_seq1 (auto_seq1_s),
    .auto_seq2 (auto_seq2_s),
    .auto_seq3 (auto_seq3_s),
    .manual_select (manual_select_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_ld_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_ld_s),
    .up_rack (up_rack_ld_s));

  // read interface merge

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= up_wack_ld_s | up_wack_pwm_s;
      up_rack <= up_rack_ld_s | up_rack_pwm_s;
      up_rdata <= up_rdata_ld_s | up_rdata_pwm_s;
    end
  end

  // generic PWM generator's

  util_pulse_gen  #(
    .PULSE_WIDTH(PULSE_WIDTH),
    .PULSE_PERIOD(PULSE_PERIOD))
  i_laser_driver_pulse (
    .clk (clk),
    .rstn (pulse_gen_resetn),
    .pulse_width (pulse_width_s),
    .pulse_period (pulse_period_s),
    .load_config (load_config_s),
    .pulse (driver_pulse_int_s),
    .pulse_counter (pulse_counter_s));

  // data path reset generation
  // this logic will generate a reset signal right before the generated pulse
  // in order to use it for resetting the cpack module, to synchronize it to
  // the driver pulse
  always @(posedge clk) begin
      driver_pulse_int_d <= driver_pulse_int_s;
  end
  assign driver_dp_reset = driver_pulse_int_s & ~driver_pulse_int_d;
  assign driver_pulse = driver_pulse_int_d;

  // clock monitor for the external clock

  up_clock_mon i_clock_mon (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_d_count (up_ext_clk_count_s),
    .d_rst (~pulse_gen_resetn),
    .d_clk (ext_clk));

  // TIA sequencer

  always @(posedge clk) begin
    if (sequence_en_s == 1'b0) begin
      sequence_counter <= 2'b00;
    end else begin
      if (pulse_counter_s == sequence_offset_s) begin
        if (auto_sequence_s) begin
          sequence_counter <= sequence_counter + 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (sequence_en_s == 1'b0) begin
      tia_chsel <= 8'h00;
    end else begin
      if (pulse_counter_s == sequence_offset_s) begin
        if (auto_sequence_s) begin
          case (sequence_counter)
            2'b00   : tia_chsel <= {auto_seq0_s, auto_seq0_s, auto_seq0_s, auto_seq0_s};
            2'b01   : tia_chsel <= {auto_seq1_s, auto_seq1_s, auto_seq1_s, auto_seq1_s};
            2'b10   : tia_chsel <= {auto_seq2_s, auto_seq2_s, auto_seq2_s, auto_seq2_s};
            2'b11   : tia_chsel <= {auto_seq3_s, auto_seq3_s, auto_seq3_s, auto_seq3_s};
            default : tia_chsel <= 8'h00;
          endcase
        end else begin
          tia_chsel <= manual_select_s;
        end
      end
    end
  end

  // AXI Memory Mapped Wrapper

  up_axi #(
    .AXI_ADDRESS_WIDTH(16))
  i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule
