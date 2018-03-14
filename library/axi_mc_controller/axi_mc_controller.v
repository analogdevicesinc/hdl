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

module axi_mc_controller
(
  input           ref_clk,       // 100 MHz
  input           ctrl_data_clk,

// physical interface

  output          fmc_en_o,
  output          pwm_ah_o,
  output          pwm_al_o,
  output          pwm_bh_o,
  output          pwm_bl_o,
  output          pwm_ch_o,
  output          pwm_cl_o,
  output  [3:0]   gpo_o,

//  controller connections

  input           pwm_a_i,
  input           pwm_b_i,
  input           pwm_c_i,

// interconnection with other modules

  output[1:0]     sensors_o,
  input [2:0]     position_i,

// axi interface

  input           s_axi_aclk,
  input           s_axi_aresetn,
  input           s_axi_awvalid,
  input   [15:0]  s_axi_awaddr,
  output          s_axi_awready,
  input           s_axi_wvalid,
  input   [31:0]  s_axi_wdata,
  input   [3:0]   s_axi_wstrb,
  output          s_axi_wready,
  output          s_axi_bvalid,
  output  [1:0]   s_axi_bresp,
  input           s_axi_bready,
  input           s_axi_arvalid,
  input   [15:0]  s_axi_araddr,
  output          s_axi_arready,
  output          s_axi_rvalid,
  output  [1:0]   s_axi_rresp,
  output  [31:0]  s_axi_rdata,
  input           s_axi_rready,
  input   [ 2:0]  s_axi_awprot,
  input   [ 2:0]  s_axi_arprot

);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
// internal registers

reg     [31:0]  up_rdata     = 'd0;
reg             up_wack      = 'd0;
reg             up_rack      = 'd0;
reg             pwm_gen_clk  = 'd0;

//------------------------------------------------------------------------------
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------
// internal clocks & resets

wire            adc_rst;
wire            up_rstn;
wire            up_clk;

// internal signals

wire            up_rreq_s;
wire            up_wreq_s;
wire    [13:0]  up_raddr_s;
wire    [13:0]  up_waddr_s;
wire    [31:0]  up_wdata_s;
wire    [31:0]  up_control_rdata_s;
wire            up_control_wack_s;
wire            up_control_rack_s;
wire            run_s;
wire            star_delta_s;
wire            dir_s;
wire    [10:0]  pwm_open_s;
wire    [10:0]  pwm_s;
wire            dpwm_ah_s;
wire            dpwm_al_s;
wire            dpwm_bh_s;
wire            dpwm_bl_s;
wire            dpwm_ch_s;
wire            dpwm_cl_s;
wire            foc_ctrl_s;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// signal name changes

assign up_clk         = s_axi_aclk;
assign up_rstn        = s_axi_aresetn;

assign adc_clk_o      = ctrl_data_clk;

assign ctrl_rst_o     = !run_s;

// monitor signals

assign fmc_en_o       = run_s;
assign pwm_s          = pwm_open_s ;

assign pwm_ah_o = foc_ctrl_s ? !pwm_a_i : dpwm_ah_s;
assign pwm_al_o = foc_ctrl_s ? pwm_a_i : dpwm_al_s;
assign pwm_bh_o = foc_ctrl_s ? !pwm_b_i : dpwm_bh_s;
assign pwm_bl_o = foc_ctrl_s ? pwm_b_i : dpwm_bl_s;
assign pwm_ch_o = foc_ctrl_s ? !pwm_c_i : dpwm_ch_s;
assign pwm_cl_o = foc_ctrl_s ? pwm_c_i : dpwm_cl_s;

// clock generation

always @(posedge ref_clk)
begin
  pwm_gen_clk <= ~pwm_gen_clk; // generate 50 MHz clk
end

// processor read interface

always @(negedge up_rstn or posedge up_clk) begin
    if(up_rstn == 0) begin
        up_rdata  <= 'd0;
        up_wack   <= 'd0;
        up_rack   <= 'd0;
    end else begin
        up_rdata  <= up_control_rdata_s ;
        up_rack   <= up_control_rack_s ;
        up_wack   <= up_control_wack_s ;
    end
end

// main (device interface)

motor_driver
#( .PWM_BITS(11))
motor_driver_inst(
    .clk_i(ctrl_data_clk),
    .pwm_clk_i(pwm_gen_clk),
    .rst_n_i(up_rstn) ,
    .run_i(run_s),
    .star_delta_i(star_delta_s),
    .dir_i(dir_s),
    .position_i(position_i),
    .pwm_duty_i(pwm_s),
    .AH_o(dpwm_ah_s),
    .BH_o(dpwm_bh_s),
    .CH_o(dpwm_ch_s),
    .AL_o(dpwm_al_s),
    .BL_o(dpwm_bl_s),
    .CL_o(dpwm_cl_s));

control_registers control_reg_inst(
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_control_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_control_rdata_s),
    .up_rack (up_control_rack_s),

    .run_o(run_s),
    .break_o(),
    .dir_o(dir_s),
    .star_delta_o(star_delta_s),
    .sensors_o(sensors_o),
    .kp_o(),
    .ki_o(),
    .kd_o(),
    .kp1_o(),
    .ki1_o(),
    .kd1_o(),
    .gpo_o(gpo_o),
    .reference_speed_o(),
    .oloop_matlab_o(foc_ctrl_s),
    .err_i(32'h0),
    .calibrate_adcs_o(),
    .pwm_open_o(pwm_open_s));

// up bus interface

up_axi i_up_axi(
        .up_rstn(up_rstn),
        .up_clk(up_clk),
        .up_axi_awvalid(s_axi_awvalid),
        .up_axi_awaddr(s_axi_awaddr),
        .up_axi_awready(s_axi_awready),
        .up_axi_wvalid(s_axi_wvalid),
        .up_axi_wdata(s_axi_wdata),
        .up_axi_wstrb(s_axi_wstrb),
        .up_axi_wready(s_axi_wready),
        .up_axi_bvalid(s_axi_bvalid),
        .up_axi_bresp(s_axi_bresp),
        .up_axi_bready(s_axi_bready),
        .up_axi_arvalid(s_axi_arvalid),
        .up_axi_araddr(s_axi_araddr),
        .up_axi_arready(s_axi_arready),
        .up_axi_rvalid(s_axi_rvalid),
        .up_axi_rresp(s_axi_rresp),
        .up_axi_rdata(s_axi_rdata),
        .up_axi_rready(s_axi_rready),
        .up_wreq (up_wreq_s),
        .up_waddr (up_waddr_s),
        .up_wdata (up_wdata_s),
        .up_wack (up_wack),
        .up_rreq (up_rreq_s),
        .up_raddr (up_raddr_s),
        .up_rdata (up_rdata),
        .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
