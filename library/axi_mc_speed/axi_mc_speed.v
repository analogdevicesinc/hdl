// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
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

`timescale 1ns/100ps

module axi_mc_speed
#(
    parameter C_S_AXI_MIN_SIZE = 32'hffff,
    parameter MOTOR_CONTROL_REVISION = 2
)
//----------- Ports Declarations -----------------------------------------------
(
// physical interface
    input   [2:0]   position_i,
    input   [2:0]   bemf_i,
    output  [2:0]   position_o,
    output  [31:0]  speed_o,
    output          new_speed_o,
    input   [1:0]   hall_bemf_i,

    input           ref_clk,

  // dma interface

    output          adc_clk_o,
    output          adc_dwr_o,
    output  [31:0]  adc_ddata_o,
    input           adc_dovf_i,
    input           adc_dunf_i,

// axi interface

    input           s_axi_aclk,
    input           s_axi_aresetn,
    input           s_axi_awvalid,
    input   [31:0]  s_axi_awaddr,
    output          s_axi_awready,
    input           s_axi_wvalid,
    input   [31:0]  s_axi_wdata,
    input   [ 3:0]  s_axi_wstrb,
    output          s_axi_wready,
    output          s_axi_bvalid,
    output  [ 1:0]  s_axi_bresp,
    input           s_axi_bready,
    input           s_axi_arvalid,
    input   [31:0]  s_axi_araddr,
    output          s_axi_arready,
    output          s_axi_rvalid,
    output  [ 1:0]  s_axi_rresp,
    output  [31:0]  s_axi_rdata,
    input           s_axi_rready,

// debug signals

    output          adc_mon_valid,
    output  [31:0]  adc_mon_data);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------

reg             adc_valid = 'd0;
reg     [31:0]  adc_data = 'd0;
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

wire            adc_start_s;
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

wire  [ 2:0]  position_s;
wire  [ 2:0]  bemf_s;
wire  [ 2:0]  bemf_delayed_s;
wire          new_speed_s;
wire  [ 2:0]  bemf_multiplex_s;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------
// signal name changes

assign up_clk = s_axi_aclk;
assign up_rstn = s_axi_aresetn;

assign adc_clk_o            = ref_clk;
assign adc_dwr_o            = adc_valid;
assign adc_ddata_o          = adc_data;

// monitor signals

assign adc_mon_valid = new_speed_s;
assign adc_mon_data  = { 20'h0, bemf_multiplex_s, bemf_s, bemf_delayed_s, position_s };

assign bemf_multiplex_s =(MOTOR_CONTROL_REVISION == 2) ? position_i : bemf_i;
assign position_o       =(hall_bemf_i == 2'b01) ? bemf_delayed_s :  position_s;
assign new_speed_o      = new_speed_s;
assign speed_o          = speed_data_s;

// adc channels - dma interface

always @(posedge ref_clk)
begin
    adc_data      <= speed_data_s;
    adc_valid     <= new_speed_s;
end

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
#( .DEBOUNCER_LEN(400))
position_0(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(position_i[0]),
    .sig_o(position_s[0]));

debouncer
#( .DEBOUNCER_LEN(400))
position_1(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(position_i[1]),
    .sig_o(position_s[1]));

debouncer
#( .DEBOUNCER_LEN(400))
position_2(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(position_i[2]),
    .sig_o(position_s[2]));

// BEMF debouncer
debouncer
#( .DEBOUNCER_LEN(400))
bemf_0(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(bemf_multiplex_s[0]),
    .sig_o(bemf_s[0]));

debouncer
#( .DEBOUNCER_LEN(400))
bemf_1(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(bemf_multiplex_s[1]),
    .sig_o(bemf_s[1]));

debouncer
#( .DEBOUNCER_LEN(400))
bemf_2(
    .clk_i(ref_clk),
    .rst_i(adc_rst),
    .sig_i(bemf_multiplex_s[2]),
    .sig_o(bemf_s[2]));

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
  .adc_status_ovf(adc_dovf_i),
  .adc_status_unf(adc_dunf_i),
  .adc_clk_ratio(32'd1),
  .delay_clk(1'b0),
  .delay_rst(),
  .delay_sel(),
  .delay_rwn(),
  .delay_addr(),
  .delay_wdata(),
  .delay_rdata(5'd0),
  .delay_ack_t(1'b0),
  .delay_locked(1'b0),
  .drp_clk(1'd0),
  .drp_rst(),
  .drp_sel(),
  .drp_wr(),
  .drp_addr(),
  .drp_wdata(),
  .drp_rdata(16'd0),
  .drp_ready(1'b0),
  .drp_locked(1'b0),
  .up_usr_chanmax(),
  .adc_usr_chanmax(8'd0),
  .up_adc_gpio_in(),
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
