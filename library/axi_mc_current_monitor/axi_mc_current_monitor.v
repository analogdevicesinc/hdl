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

module axi_mc_current_monitor (

// physical interface

    input           adc_ia_dat_i,
    output          adc_enable_ia,
    input           adc_ib_dat_i,
    output          adc_enable_ib,
    input           adc_vbus_dat_i,
    output          adc_enable_vbus,
    output          adc_enable_stub,
    output          adc_clk_o,

    input           ref_clk,
    input           adc_clk_i,

    output [15:0]   ia_o,
    output [15:0]   ib_o,
    output [15:0]   vbus_o,
    output          i_ready_o,

  // axi interface

    input           s_axi_aclk,
    input           s_axi_aresetn,
    input           s_axi_awvalid,
    input   [31:0]  s_axi_awaddr,
    output          s_axi_awready,
    input           s_axi_wvalid,
    input   [31:0]  s_axi_wdata,
    input   [3:0]   s_axi_wstrb,
    output          s_axi_wready,
    output          s_axi_bvalid,
    output  [1:0]   s_axi_bresp,
    input           s_axi_bready,
    input           s_axi_arvalid,
    input   [31:0]  s_axi_araddr,
    output          s_axi_arready,
    output          s_axi_rvalid,
    output  [1:0]   s_axi_rresp,
    output  [31:0]  s_axi_rdata,
    input           s_axi_rready
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------

reg     [31:0]  up_rdata        = 'd0;
reg             up_wack         = 'd0;
reg             up_rack         = 'd0;

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
wire    [13:0]  up_waddr_s;
wire    [13:0]  up_raddr_s;
wire    [31:0]  up_wdata_s;
wire    [31:0]  up_adc_common_rdata_s;
wire            up_adc_common_ack_s;
wire    [31:0]  up_rdata_0_s;
wire    [31:0]  up_rdata_1_s;
wire    [31:0]  up_rdata_2_s;
wire    [31:0]  up_rdata_3_s;
wire            up_rack_0_s;
wire            up_rack_1_s;
wire            up_rack_2_s;
wire            up_rack_3_s;
wire            up_wack_0_s;
wire            up_wack_1_s;
wire            up_wack_2_s;
wire            up_wack_3_s;

wire            adc_status_a_s;
wire    [15:0]  adc_data_ia_s ;
wire            data_rd_ready_ia_s;
wire            adc_status_b_s;
wire    [15:0]  adc_data_ib_s;
wire            adc_status_vbus_s;
wire    [15:0]  adc_data_vbus_s;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// signal name changes

assign up_clk               = s_axi_aclk;
assign up_rstn              = s_axi_aresetn;

// current outputs

assign i_ready_o  = data_rd_ready_ia_s;

assign ia_o    = adc_data_ia_s ;
assign ib_o    = adc_data_ib_s ;
assign vbus_o  = adc_data_vbus_s;

// adc clock

assign adc_clk_o  = adc_clk_i;

// processor read interface

always @(negedge up_rstn or posedge up_clk)
begin
    if(up_rstn == 0)
    begin
        up_rdata  <= 'd0;
        up_rack   <= 'd0;
        up_wack   <= 'd0;
    end
    else
    begin
        up_rdata  <= up_adc_common_rdata_s | up_rdata_0_s | up_rdata_1_s | up_rdata_2_s |up_rdata_3_s  ;
        up_rack   <= up_adc_common_rack_s | up_rack_0_s | up_rack_1_s | up_rack_2_s | up_rack_3_s ;
        up_wack   <= up_adc_common_wack_s | up_wack_0_s | up_wack_1_s | up_wack_2_s | up_wack_3_s;
    end
end

// adc interfaces

ad7401 ia_if(
    .fpga_clk_i(ref_clk),
    .adc_clk_i(adc_clk_o),
    .reset_i(adc_rst),
    .adc_status_o(adc_status_a_s),
    .data_o(adc_data_ia_s),
    .data_rd_ready_o(data_rd_ready_ia_s),
    .adc_mdata_i(adc_ia_dat_i));

ad7401 ib_if(
    .fpga_clk_i(ref_clk),
    .adc_clk_i(adc_clk_o),
    .reset_i(adc_rst),
    .adc_status_o(adc_status_b_s),
    .data_o(adc_data_ib_s),
    .data_rd_ready_o(),
    .adc_mdata_i(adc_ib_dat_i));

ad7401 vbus_if(
    .fpga_clk_i(ref_clk),
    .adc_clk_i(adc_clk_o),
    .reset_i(adc_rst),
    .adc_status_o(adc_status_vbus_s),
    .data_o(adc_data_vbus_s),
    .data_rd_ready_o(),
    .adc_mdata_i(adc_vbus_dat_i));

up_adc_channel #(.PCORE_ADC_CHID(0)) i_up_adc_channel_ia(
    .adc_clk(adc_clk_o),
    .adc_rst(adc_rst),
    .adc_enable(adc_enable_ia),
    .adc_iqcor_enb(),
    .adc_dcfilt_enb(),
    .adc_dfmt_se(),
    .adc_dfmt_type(),
    .adc_dfmt_enable(),
    .adc_dcfilt_offset(),
    .adc_dcfilt_coeff(),
    .adc_iqcor_coeff_1(),
    .adc_iqcor_coeff_2(),
    .adc_pnseq_sel(),
    .adc_data_sel(),
    .adc_pn_err(1'b0),
    .adc_pn_oos(1'b0),
    .adc_or(1'b0),
    .up_adc_pn_err(),
    .up_adc_pn_oos(),
    .up_adc_or(),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_decimation_m(),
    .up_usr_decimation_n(),
    .adc_usr_datatype_be(1'b0),
    .adc_usr_datatype_signed(1'b1),
    .adc_usr_datatype_shift(8'd0),
    .adc_usr_datatype_total_bits(8'd16),
    .adc_usr_datatype_bits(8'd16),
    .adc_usr_decimation_m(16'd1),
    .adc_usr_decimation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_0_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_0_s),
    .up_rack (up_rack_0_s));

up_adc_channel #(.PCORE_ADC_CHID(1)) i_up_adc_channel_ib(
    .adc_clk(adc_clk_o),
    .adc_rst(adc_rst),
    .adc_enable(adc_enable_ib),
    .adc_iqcor_enb(),
    .adc_dcfilt_enb(),
    .adc_dfmt_se(),
    .adc_dfmt_type(),
    .adc_dfmt_enable(),
    .adc_dcfilt_offset(),
    .adc_dcfilt_coeff(),
    .adc_iqcor_coeff_1(),
    .adc_iqcor_coeff_2(),
    .adc_pnseq_sel(),
    .adc_data_sel(),
    .adc_pn_err(1'b0),
    .adc_pn_oos(1'b0),
    .adc_or(1'b0),
    .up_adc_pn_err(),
    .up_adc_pn_oos(),
    .up_adc_or(),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_decimation_m(),
    .up_usr_decimation_n(),
    .adc_usr_datatype_be(1'b0),
    .adc_usr_datatype_signed(1'b1),
    .adc_usr_datatype_shift(8'd0),
    .adc_usr_datatype_total_bits(8'd16),
    .adc_usr_datatype_bits(8'd16),
    .adc_usr_decimation_m(16'd1),
    .adc_usr_decimation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_1_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_1_s),
    .up_rack (up_rack_1_s));

up_adc_channel #(.PCORE_ADC_CHID(2)) i_up_adc_channel_vbus(
    .adc_clk(adc_clk_o),
    .adc_rst(adc_rst),
    .adc_enable(adc_enable_vbus),
    .adc_iqcor_enb(),
    .adc_dcfilt_enb(),
    .adc_dfmt_se(),
    .adc_dfmt_type(),
    .adc_dfmt_enable(),
    .adc_dcfilt_offset(),
    .adc_dcfilt_coeff(),
    .adc_iqcor_coeff_1(),
    .adc_iqcor_coeff_2(),
    .adc_pnseq_sel(),
    .adc_data_sel(),
    .adc_pn_err(1'b0),
    .adc_pn_oos(1'b0),
    .adc_or(1'b0),
    .up_adc_pn_err(),
    .up_adc_pn_oos(),
    .up_adc_or(),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_decimation_m(),
    .up_usr_decimation_n(),
    .adc_usr_datatype_be(1'b0),
    .adc_usr_datatype_signed(1'b1),
    .adc_usr_datatype_shift(8'd0),
    .adc_usr_datatype_total_bits(8'd16),
    .adc_usr_datatype_bits(8'd16),
    .adc_usr_decimation_m(16'd1),
    .adc_usr_decimation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_2_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_2_s),
    .up_rack (up_rack_2_s));

up_adc_channel #(.PCORE_ADC_CHID(3)) i_up_adc_channel_stub(
    .adc_clk(adc_clk_o),
    .adc_rst(adc_rst),
    .adc_enable(adc_enable_stub),
    .adc_iqcor_enb(),
    .adc_dcfilt_enb(),
    .adc_dfmt_se(),
    .adc_dfmt_type(),
    .adc_dfmt_enable(),
    .adc_dcfilt_offset(),
    .adc_dcfilt_coeff(),
    .adc_iqcor_coeff_1(),
    .adc_iqcor_coeff_2(),
    .adc_pnseq_sel(),
    .adc_data_sel(),
    .adc_pn_err(1'b0),
    .adc_pn_oos(1'b0),
    .adc_or(1'b0),
    .up_adc_pn_err(),
    .up_adc_pn_oos(),
    .up_adc_or(),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_decimation_m(),
    .up_usr_decimation_n(),
    .adc_usr_datatype_be(1'b0),
    .adc_usr_datatype_signed(1'b1),
    .adc_usr_datatype_shift(8'd0),
    .adc_usr_datatype_total_bits(8'd16),
    .adc_usr_datatype_bits(8'd16),
    .adc_usr_decimation_m(16'd1),
    .adc_usr_decimation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_3_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_3_s),
    .up_rack (up_rack_3_s));

// common processor control

up_adc_common i_up_adc_common(
    .mmcm_rst(),
    .adc_clk(adc_clk_o),
    .adc_rst(adc_rst),
    .adc_r1_mode(),
    .adc_ddr_edgesel(),
    .adc_pin_mode(),
    .adc_status(1'b1),
    .adc_sync_status(1'b1),
    .adc_status_ovf(1'b0),
    .adc_status_unf(1'b0),
    .adc_clk_ratio(32'd1),
    .adc_start_code(),
    .adc_sync(),

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

    .up_usr_chanmax(),
    .adc_usr_chanmax(8'd3),
    .up_adc_gpio_in(32'h0),
    .up_adc_gpio_out(),

    .up_rstn (up_rstn),
    .up_clk (up_clk),
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
