// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

module axi_pulsar_lvds #(
  parameter ID = 0,
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,
  parameter IO_DELAY_GROUP = "adc_if_delay_group",
  parameter IODELAY_CTRL = 1,
  parameter DELAY_REFCLK_FREQUENCY = 200,
  parameter USERPORTS_DISABLE = 0,
  parameter DATAFORMAT_DISABLE = 0,
  parameter ADC_INIT_DELAY = 0,
  parameter ADC_DATA_WIDTH = 16,
  parameter BITS_PER_SAMPLE = 32
) (
  input         delay_clk,

  // adc interface

  input         ref_clk,
  input         clk_gate,
  input         dco_p,
  input         dco_n,
  input         d_p,
  input         d_n,

  // dma interface

  output        adc_valid,
  output [BITS_PER_SAMPLE-1:0] adc_data,
  input         adc_dovf,

  // axi interface

  input         s_axi_aclk,
  input         s_axi_aresetn,
  input         s_axi_awvalid,
  input  [15:0] s_axi_awaddr,
  output        s_axi_awready,
  input         s_axi_wvalid,
  input  [31:0] s_axi_wdata,
  input  [ 3:0] s_axi_wstrb,
  output        s_axi_wready,
  output        s_axi_bvalid,
  output [ 1:0] s_axi_bresp,
  input         s_axi_bready,
  input         s_axi_arvalid,
  input  [15:0] s_axi_araddr,
  output        s_axi_arready,
  output        s_axi_rvalid,
  output [ 1:0] s_axi_rresp,
  output [31:0] s_axi_rdata,
  input         s_axi_rready,
  input  [ 2:0] s_axi_awprot,
  input  [ 2:0] s_axi_arprot
);

  // internal signals

  wire [(ADC_DATA_WIDTH-1):0] adc_data_s;
  wire        adc_or_s;
  wire [ 1:0] up_dld_s;
  wire [ 9:0] up_dwdata_s;
  wire [ 9:0] up_drdata_s;
  wire        delay_locked_s;
  wire        up_status_pn_err_s;
  wire        up_status_pn_oos_s;
  wire        up_status_or_s;
  wire        up_rreq_s;
  wire [13:0] up_raddr_s;
  wire [31:0] up_rdata_s[0:2];
  wire        up_rack_s[0:2];
  wire        up_wack_s[0:2];
  wire        up_wreq_s;
  wire [13:0] up_waddr_s;
  wire [31:0] up_wdata_s;

  // internal registers

  reg         up_wack  = 'd0;
  reg  [31:0] up_rdata = 'd0;
  reg         up_rack  = 'd0;

  // internal signals

  wire        adc_rst;
  wire        adc_clk;
  wire        adc_enable;
  wire        up_clk;
  wire        up_rstn;
  wire        delay_rst;
  wire        adc_valid_ch_s;
  wire [(ADC_DATA_WIDTH-1):0] adc_data_ch_s;

  // signal name changes

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign adc_clk = ref_clk;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (!up_rstn) begin
      up_rdata <= 32'd0;
      up_rack <= 1'd0;
      up_wack <= 1'd0;
    end else begin
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2];
      up_rack <= up_rack_s[0] | up_rack_s[1] | up_rack_s[2];
      up_wack <= up_wack_s[0] | up_wack_s[1] | up_wack_s[2];
    end
  end

  // main (device interface)

  axi_pulsar_lvds_if #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IO_DELAY_GROUP (IO_DELAY_GROUP),
    .DELAY_REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY),
    .IODELAY_CTRL (IODELAY_CTRL),
    .ADC_DATA_WIDTH (ADC_DATA_WIDTH)
  ) axi_pulsar_lvds_if_inst (
    .up_clk(up_clk),
    .up_dld(up_dld_s),
    .up_dwdata(up_dwdata_s),
    .up_drdata(up_drdata_s),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked_s),
    .clk(ref_clk),
    .clk_gate(clk_gate),
    .dco_p(dco_p),
    .dco_n(dco_n),
    .d_p(d_p),
    .d_n(d_n),
    .adc_valid(adc_valid_ch_s),
    .adc_data(adc_data_ch_s));

  // channel

  axi_pulsar_lvds_channel #(
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .ADC_DATA_WIDTH (ADC_DATA_WIDTH),
    .BITS_PER_SAMPLE (BITS_PER_SAMPLE)
  ) i_channel (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_data_in (adc_data_ch_s),
    .adc_valid_in (adc_valid_ch_s),
    .adc_enable (adc_enable),
    .adc_valid (adc_valid),
    .adc_data (adc_data),
    .up_adc_pn_err (up_status_pn_err_s),
    .up_adc_pn_oos (up_status_pn_oos_s),
    .up_adc_or (up_status_or_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  // adc delay control

  up_delay_cntrl #(
    .INIT_DELAY (ADC_INIT_DELAY),
    .DATA_WIDTH (2),
    .BASE_ADDRESS (6'h02)
  ) i_delay_cntrl (
    .core_rst (1'b0),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_s),
    .up_dld (up_dld_s),
    .up_dwdata (up_dwdata_s),
    .up_drdata (up_drdata_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

  // common processor control

  up_adc_common #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .CONFIG (0),
    .COMMON_ID (6'h00),
    .DRP_DISABLE (6'h00),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .GPIO_DISABLE (0),
    .START_CODE_DISABLE (0)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (delay_locked_s),
    .adc_sync_status (1'd0),
    .adc_status_ovf (adc_dovf),
    .adc_clk_ratio (32'b1),
    .adc_start_code (),
    .adc_sref_sync (),
    .adc_sync (),
    .adc_ext_sync_arm(),
    .adc_ext_sync_disarm(),
    .adc_ext_sync_manual_req(),
    .adc_num_lanes (),
    .adc_custom_control(),
    .adc_crc_enable (),
    .adc_sdr_ddr_n (),
    .adc_symb_op (),
    .adc_symb_8_16b (),
    .up_pps_rcounter (32'd0),
    .up_pps_status (1'd0),
    .up_pps_irq_mask (),
    .up_adc_r1_mode (),
    .up_adc_ce (),
    .up_status_pn_err (up_status_pn_err_s),
    .up_status_pn_oos (up_status_pn_oos_s),
    .up_status_or (up_status_or_s),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (32'b0),
    .up_drp_ready (1'b0),
    .up_drp_locked (1'b1),
    .adc_config_wr (),
    .adc_config_ctrl (),
    .adc_config_rd ('d0),
    .adc_ctrl_status ('d0),
    .up_usr_chanmax_out (),
    .up_usr_chanmax_in (8'd1),
    .up_adc_gpio_in (32'd0),
    .up_adc_gpio_out (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  // up bus interface

  up_axi i_up_axi (
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
