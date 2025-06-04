// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL(Verilog or VHDL) components. The individual modules are
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
//      of this repository(LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository(LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad408x #(
  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group"
) (

  // ADC interface

  input                   dclk_in_p,
  input                   dclk_in_n,

  input                   data_a_in_p,
  input                   data_a_in_n,
  input                   data_b_in_p,
  input                   data_b_in_n,

  input                   cnv_in_p,
  input                   cnv_in_n,

  input                   sync_n,
  input                   filter_data_ready_n,

  // output data interface

  output                  adc_clk,
  output      [ 31:0]     adc_data,
  output                  adc_valid,
  input                   adc_dovf,
  output                  adc_enable,
  output                  adc_rst,
  // delay interface

  input                   delay_clk,

  // AXI interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input         [15:0]    s_axi_awaddr,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input         [31:0]    s_axi_wdata,
  input         [ 3:0]    s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output        [ 1:0]    s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input         [15:0]    s_axi_araddr,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output        [ 1:0]    s_axi_rresp,
  output        [31:0]    s_axi_rdata,
  input                   s_axi_rready,
  input         [ 2:0]    s_axi_awprot,
  input         [ 2:0]    s_axi_arprot
);

  localparam DELAY_CTRL_NUM_LANES = 2;
  localparam DELAY_CTRL_DRP_WIDTH = 5;

  // internal signals

  wire  [DELAY_CTRL_DRP_WIDTH*DELAY_CTRL_NUM_LANES-1:0]  up_dwdata;
  wire  [DELAY_CTRL_DRP_WIDTH*DELAY_CTRL_NUM_LANES-1:0]  up_drdata;
  wire  [DELAY_CTRL_NUM_LANES-1:0]                       up_dld;

  wire    [7:0]    adc_custom_control_s;
  wire   [ 4:0]    adc_num_lanes;
  wire             bitslip_enable;
  wire             filter_enable;
  wire             delay_locked;
  wire             sync_status;
  wire             adc_clk_s;
  wire             adc_rst_s;
  wire             delay_rst;
  wire             self_sync;

  wire             up_rstn;
  wire             up_clk;
  wire   [13:0]    up_waddr_s;
  wire   [13:0]    up_raddr_s;
  wire             up_sel_s;
  wire             up_wr_s;
  wire   [13:0]    up_addr_s;
  wire   [31:0]    up_wdata_s;
  wire   [31:0]    up_rdata_s  [0:2];
  wire             up_rack_s   [0:2];
  wire             up_wack_s   [0:2];

  reg    [31:0]    up_rdata_r;
  reg              up_rack_r;
  reg              up_wack_r;
  reg    [31:0]    up_rdata = 'd0;
  reg              up_rack  = 'd0;
  reg              up_wack  = 'd0;

  integer j;

  assign adc_clk = adc_clk_s;
  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign adc_rst = adc_rst_s;
  assign self_sync     = adc_custom_control_s[1];
  assign filter_enable = adc_custom_control_s[0];

  always @(*) begin
    up_rdata_r = 'h00;
    up_rack_r = 'h00;
    up_wack_r = 'h00;
    for(j = 0; j < 3; j=j+1) begin
      up_rack_r = up_rack_r | up_rack_s[j];
      up_wack_r = up_wack_r | up_wack_s[j];
      up_rdata_r = up_rdata_r | up_rdata_s[j];
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if(up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_rdata <= up_rdata_r;
      up_rack <= up_rack_r;
      up_wack <= up_wack_r;
    end
  end

  up_adc_channel #(
    .CHANNEL_ID(0)
  ) ad408x_channel_0 (
    .adc_clk(adc_clk_s),
    .adc_rst(adc_rst_s),
    .adc_enable(adc_enable),
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
    .adc_or(),
    .adc_read_data(),
    .adc_status_header('b0),
    .adc_crc_err('b0),
    .up_adc_crc_err(),
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
    .adc_usr_datatype_total_bits(8'd32),
    .adc_usr_datatype_bits(8'd32),
    .adc_usr_decimation_m(16'd1),
    .adc_usr_decimation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq_s),
    .up_waddr(up_waddr_s),
    .up_wdata(up_wdata_s),
    .up_wack(up_wack_s[0]),
    .up_rreq(up_rreq_s),
    .up_raddr(up_raddr_s),
    .up_rdata(up_rdata_s[0]),
    .up_rack(up_rack_s[0]));

  up_adc_common #(
    .ID(ID)
  ) i_up_adc_common (
    .mmcm_rst(),
    .adc_clk(adc_clk_s),
    .adc_rst(adc_rst_s),
    .adc_r1_mode(),
    .adc_pin_mode(),
    .adc_status('h00),
    .adc_sync_status(sync_status),
    .adc_status_ovf(adc_dovf),
    .adc_custom_control(adc_custom_control_s),
    .adc_clk_ratio(32'd2),
    .adc_start_code(),
    .adc_sref_sync(),
    .adc_sync(bitslip_enable),
    .adc_num_lanes(adc_num_lanes),
    .up_pps_rcounter(32'b0),
    .up_pps_status(1'b0),
    .up_pps_irq_mask(),
    .up_adc_ce(),
    .up_status_pn_err(1'b0),
    .up_status_pn_oos(1'b0),
    .up_status_or(1'b0),
    .up_drp_sel(),
    .up_drp_wr(),
    .up_drp_addr(),
    .up_drp_wdata(),
    .up_drp_rdata(32'd0),
    .up_drp_ready(1'd0),
    .up_drp_locked(1'd1),
    .adc_config_wr(),
    .adc_config_ctrl(),
    .adc_config_rd('d0),
    .adc_ctrl_status('d0),
    .up_usr_chanmax_out(),
    .up_usr_chanmax_in(1),
    .up_adc_gpio_in(32'b0),
    .up_adc_gpio_out(),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq_s),
    .up_waddr(up_waddr_s),
    .up_wdata(up_wdata_s),
    .up_wack(up_wack_s[1]),
    .up_rreq(up_rreq_s),
    .up_raddr(up_raddr_s),
    .up_rdata(up_rdata_s[1]),
    .up_rack(up_rack_s[1]));

 // ad4080 interface module

  ad408x_phy #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .IO_DELAY_GROUP(IO_DELAY_GROUP),
    .IODELAY_CTRL(1)
  ) ad408x_interface (
    .dclk_in_n(dclk_in_n),
    .dclk_in_p(dclk_in_p),
    .data_a_in_n(data_a_in_n),
    .data_a_in_p(data_a_in_p),
    .data_b_in_n(data_b_in_n),
    .data_b_in_p(data_b_in_p),
    .cnv_in_p(cnv_in_p),
    .cnv_in_n(cnv_in_n),
    .num_lanes(adc_num_lanes),
    .self_sync(self_sync),
    .up_clk(up_clk),
    .up_adc_dld(up_dld),
    .up_adc_dwdata(up_dwdata),
    .up_adc_drdata(up_drdata),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked),
    .adc_rst(adc_rst_s),
    .adc_clk(adc_clk_s),
    .adc_data(adc_data),
    .adc_valid(adc_valid),
    .bitslip_enable(bitslip_enable),
    .sync_status(sync_status),
    .filter_enable(filter_enable),
    .filter_rdy_n(filter_data_ready_n),
    .sync_n(sync_n));

  // adc delay control

  up_delay_cntrl #(
    .DATA_WIDTH(DELAY_CTRL_NUM_LANES),
    .DRP_WIDTH(DELAY_CTRL_DRP_WIDTH),
    .BASE_ADDRESS(6'h02)
  ) i_delay_cntrl (
    .core_rst(1'b0),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked),
    .up_dld(up_dld),
    .up_dwdata(up_dwdata),
    .up_drdata(up_drdata),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq_s),
    .up_waddr(up_waddr_s),
    .up_wdata(up_wdata_s),
    .up_wack(up_wack_s[2]),
    .up_rreq(up_rreq_s),
    .up_raddr(up_raddr_s),
    .up_rdata(up_rdata_s[2]),
    .up_rack(up_rack_s[2]));

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
    .up_wreq(up_wreq_s),
    .up_waddr(up_waddr_s),
    .up_wdata(up_wdata_s),
    .up_wack(up_wack),
    .up_rreq(up_rreq_s),
    .up_raddr(up_raddr_s),
    .up_rdata(up_rdata),
    .up_rack(up_rack));

endmodule
