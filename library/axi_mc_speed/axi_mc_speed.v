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

module axi_mc_speed
//----------- Ports Declarations -----------------------------------------------
(
// physical interface
    input   [2:0]   position_i,
    output  [2:0]   position_o,
    output  [31:0]  speed_o,
    output          new_speed_o,
    input   [1:0]   hall_bemf_i,

    input           ref_clk,

// axi interface
    input           s_axi_aclk,
    input           s_axi_aresetn,
    input           s_axi_awvalid,
    input   [15:0]  s_axi_awaddr,
    output          s_axi_awready,
    input           s_axi_wvalid,
    input   [31:0]  s_axi_wdata,
    input   [ 3:0]  s_axi_wstrb,
    output          s_axi_wready,
    output          s_axi_bvalid,
    output  [ 1:0]  s_axi_bresp,
    input           s_axi_bready,
    input           s_axi_arvalid,
    input   [15:0]  s_axi_araddr,
    output          s_axi_arready,
    output          s_axi_rvalid,
    output  [ 1:0]  s_axi_rresp,
    output  [31:0]  s_axi_rdata,
    input           s_axi_rready,
    input   [ 2:0]  s_axi_awprot,
    input   [ 2:0]  s_axi_arprot
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg     [31:0]  up_rdata = 'd0;
reg             up_wack = 'd0;
reg             up_rack = 'd0;

//------------------------------------------------------------------------------
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------
// internal clocks & resets
wire            adc_rst;
wire            up_rstn;
wire            up_clk;

// internal signals
wire    [31:0]  speed_data_s;
wire            adc_enable_s;
wire            adc_status_s;
wire            up_rreq_s;
wire            up_wreq_s;
wire    [13:0]  up_waddr_s;
wire    [13:0]  up_raddr_s;
wire    [31:0]  up_wdata_s;
wire    [31:0]  up_adc_common_rdata_s;
wire            up_adc_common_wack_s;
wire            up_adc_common_rack_s;
wire    [31:0]  pid_s;
wire    [ 2:0]  position_s;
wire    [ 2:0]  bemf_s;
wire    [ 2:0]  bemf_delayed_s;
wire            new_speed_s;
wire    [ 2:0]  bemf_multiplex_s;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------
// signal name changes
assign up_clk = s_axi_aclk;
assign up_rstn = s_axi_aresetn;

assign bemf_s = position_s ;
assign position_o       =(hall_bemf_i == 2'b01) ? bemf_delayed_s :  position_s;
assign new_speed_o      = new_speed_s;
assign speed_o          = speed_data_s;

// processor read interface
always @(negedge up_rstn or posedge up_clk)
begin
    if(up_rstn == 0)
    begin
        up_rdata  <= 'd0;
        up_wack   <= 'd0;
        up_rack   <= 'd0;
    end else
    begin
        up_rdata  <= up_adc_common_rdata_s;
        up_wack   <= up_adc_common_wack_s;
        up_rack   <= up_adc_common_rack_s;
    end
end

// HALL sensors debouncers
debouncer
#( .DEBOUNCER_LENGTH(400))
position_0(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(position_i[0]),
    .sig_o(position_s[0]));

debouncer
#( .DEBOUNCER_LENGTH(400))
position_1(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(position_i[1]),
    .sig_o(position_s[1]));

debouncer
#( .DEBOUNCER_LENGTH(400))
position_2(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(position_i[2]),
    .sig_o(position_s[2]));

delay_30_degrees delay_30_degrees_i1(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .offset_i(32'h0),
    .position_i(bemf_s),
    .position_o(bemf_delayed_s));

speed_detector
#(  .AVERAGE_WINDOW(1024),
    .LOG_2_AW(10),
    .SAMPLE_CLK_DECIM(1000))
speed_detector_inst(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .position_i(position_o),
    .new_speed_o(new_speed_s),
    .current_speed_o(),
    .speed_o(speed_data_s));

// common processor control
up_adc_common i_up_adc_common(
  .mmcm_rst(),
  .adc_clk(ref_clk),
  .adc_rst(adc_rst),
  .adc_r1_mode(),
  .adc_ddr_edgesel(),
  .adc_pin_mode(),
  .adc_status(1'b1),
  .adc_sync_status(1'b1),
  .adc_status_ovf(1'b0),
  .adc_clk_ratio(32'd1),
  .adc_start_code(),
  .adc_sref_sync(),
  .adc_sync(),
  .up_pps_rcounter (32'b0),
  .up_pps_status (1'b0),
  .up_adc_ce(),
  .up_status_pn_err(1'b0),
  .up_status_pn_oos(1'b0),
  .up_status_or(1'b0),
  .up_drp_sel(),
  .up_drp_wr(),
  .up_drp_addr(),
  .up_drp_wdata(),
  .up_drp_rdata(16'd0),
  .up_drp_ready(1'b0),
  .up_drp_locked(1'b0),
  .up_usr_chanmax_out(),
  .up_usr_chanmax_in(8'd1),
  .up_adc_gpio_in(32'h0),
  .up_adc_gpio_out(),
  .up_rstn(up_rstn),
  .up_clk(up_clk),
  .up_wreq (up_wreq_s),
  .up_waddr (up_waddr_s),
  .up_wdata (up_wdata_s),
  .up_wack (up_adc_common_wack_s),
  .up_rreq (up_rreq_s),
  .up_raddr (up_raddr_s),
  .up_rdata (up_adc_common_rdata_s),
  .up_rack (up_adc_common_rack_s));

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
