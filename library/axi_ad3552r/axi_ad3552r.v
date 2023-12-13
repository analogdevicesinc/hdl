// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad3552r #(

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DDS_DISABLE = 0,
  parameter   DDS_TYPE = 1,
  parameter   DDS_CORDIC_DW = 16,
  parameter   DDS_CORDIC_PHASE_DW = 16
) (

  // DAC INTERFACE

  input                   dac_clk,

  input       [31:0]      dma_data,
  input                   valid_in_dma,
  input                   valid_in_dma_sec,
  output                  dac_data_ready,

  input       [15:0]      data_in_a,
  input       [15:0]      data_in_b,
  input                   valid_in_a,
  input                   valid_in_b,

  output                  dac_sclk,
  output                  dac_csn,
  input       [ 3:0]      sdio_i,
  output      [ 3:0]      sdio_o,
  output                  sdio_t,

  // sync transfer between 2 DAC'S

  input                   external_sync,
  output                  sync_ext_device,

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
  input                   s_axi_rready
);

  // internal clocks and resets

  wire              dac_rst_s;
  wire              up_clk;
  wire              up_rstn;

  // internal signals

  wire              up_wreq_s;
  wire    [13:0]    up_waddr_s;
  wire    [31:0]    up_wdata_s;
  wire              up_wack_s;
  wire              up_rreq_s;
  wire    [13:0]    up_raddr_s;
  wire    [31:0]    up_rdata_s;
  wire              up_rack_s;

  wire    [ 7:0]    address;
  wire    [23:0]    data_read;
  wire    [23:0]    data_write;
  wire              ddr_sdr_n;
  wire              symb_8_16b;
  wire              transfer_data;
  wire              stream;
  wire    [31:0]    dac_data;
  wire              dac_valid;
  wire              if_busy;
  wire              dac_ext_sync_arm;

  // signal name changes

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // device interface
  axi_ad3552r_if axi_ad3552r_interface (
    .clk_in(dac_clk),
    .reset_in(dac_rst_s),
    .dac_data(dac_data),
    .dac_data_valid(dac_valid),
    .dac_data_valid_ext(valid_in_dma_sec),
    .dac_data_ready(dac_data_ready),
    .address(address),
    .data_read(data_read),
    .data_write(data_write),
    .sdr_ddr_n(sdr_ddr_n),
    .symb_8_16b(symb_8_16b),
    .transfer_data(transfer_data),
    .stream(stream),
    .if_busy(if_busy),
    .external_sync(external_sync),
    .external_sync_arm(dac_ext_sync_arm),
    .sync_ext_device(sync_ext_device),
    .sclk(dac_sclk),
    .csn(dac_csn),
    .sdio_i(sdio_i),
    .sdio_o(sdio_o),
    .sdio_t(sdio_t));

  // core
  axi_ad3552r_core #(
    .ID(ID),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .DDS_DISABLE(DDS_DISABLE),
    .DDS_TYPE(DDS_TYPE),
    .DDS_CORDIC_DW(DDS_CORDIC_DW),
    .DDS_CORDIC_PHASE_DW(DDS_CORDIC_PHASE_DW)
  ) axi_ad3552r_up_core (
    .dac_clk(dac_clk),
    .dac_rst(dac_rst_s),
    .adc_data_in_a(data_in_a),
    .adc_data_in_b(data_in_b),
    .dma_data(dma_data),
    .adc_valid_in_a(valid_in_a),
    .adc_valid_in_b(valid_in_b),
    .valid_in_dma(valid_in_dma),
    .dac_data_ready(dac_data_ready),
    .dac_data(dac_data),
    .dac_valid(dac_valid),
    .address(address),
    .data_read(data_read),
    .data_write(data_write),
    .sdr_ddr_n(sdr_ddr_n),
    .symb_8_16b(symb_8_16b),
    .transfer_data(transfer_data),
    .stream(stream),
    .dac_ext_sync_arm(dac_ext_sync_arm),
    .if_busy(if_busy),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq_s),
    .up_waddr(up_waddr_s),
    .up_wdata(up_wdata_s),
    .up_wack(up_wack_s),
    .up_rreq(up_rreq_s),
    .up_raddr(up_raddr_s),
    .up_rdata(up_rdata_s),
    .up_rack(up_rack_s));

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
    .up_wack(up_wack_s),
    .up_rreq(up_rreq_s),
    .up_raddr(up_raddr_s),
    .up_rdata(up_rdata_s),
    .up_rack(up_rack_s));
endmodule
