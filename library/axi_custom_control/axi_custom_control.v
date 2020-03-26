// ***************************************************************************
// ***************************************************************************
// Copyright 2020 (c) Analog Devices, Inc. All rights reserved.
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

module axi_custom_control #(

  // parameters

  // 0x100 < ADDR_OFFSET < 0x3F00
  parameter ADDR_OFFSET = 32'h800,
  parameter N_CONTROL_REG = 4,
  parameter N_STATUS_REG = 4) (

  // interface

  input                 clk,

  input       [31:0]    reg_status_0,
  input       [31:0]    reg_status_1,
  input       [31:0]    reg_status_2,
  input       [31:0]    reg_status_3,
  input       [31:0]    reg_status_4,
  input       [31:0]    reg_status_5,
  input       [31:0]    reg_status_6,
  input       [31:0]    reg_status_7,
  input       [31:0]    reg_status_8,
  input       [31:0]    reg_status_9,
  input       [31:0]    reg_status_10,
  input       [31:0]    reg_status_11,
  input       [31:0]    reg_status_12,
  input       [31:0]    reg_status_13,
  input       [31:0]    reg_status_14,
  input       [31:0]    reg_status_15,

  output      [31:0]    reg_control_0,
  output      [31:0]    reg_control_1,
  output      [31:0]    reg_control_2,
  output      [31:0]    reg_control_3,
  output      [31:0]    reg_control_4,
  output      [31:0]    reg_control_5,
  output      [31:0]    reg_control_6,
  output      [31:0]    reg_control_7,
  output      [31:0]    reg_control_8,
  output      [31:0]    reg_control_9,
  output      [31:0]    reg_control_10,
  output      [31:0]    reg_control_11,
  output      [31:0]    reg_control_12,
  output      [31:0]    reg_control_13,
  output      [31:0]    reg_control_14,
  output      [31:0]    reg_control_15,

  // axi interface

  input                 s_axi_aclk,
  input                 s_axi_aresetn,
  input                 s_axi_awvalid,
  input       [ 6:0]    s_axi_awaddr,
  input       [ 2:0]    s_axi_awprot,
  output                s_axi_awready,
  input                 s_axi_wvalid,
  input       [31:0]    s_axi_wdata,
  input       [ 3:0]    s_axi_wstrb,
  output                s_axi_wready,
  output                s_axi_bvalid,
  output      [ 1:0]    s_axi_bresp,
  input                 s_axi_bready,
  input                 s_axi_arvalid,
  input       [ 6:0]    s_axi_araddr,
  input       [ 2:0]    s_axi_arprot,
  output                s_axi_arready,
  output                s_axi_rvalid,
  output      [31:0]    s_axi_rdata,
  output      [ 1:0]    s_axi_rresp,
  input                 s_axi_rready);

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  axi_custom_control_reg #(
    .ADDR_OFFSET (ADDR_OFFSET),
    .N_CONTROL_REG (N_CONTROL_REG),
    .N_STATUS_REG (N_STATUS_REG))
  custom_control_registers (
    .clk(clk),
    .reg_status_0  (reg_status_0),
    .reg_status_1  (reg_status_1),
    .reg_status_2  (reg_status_2),
    .reg_status_3  (reg_status_3),
    .reg_status_4  (reg_status_4),
    .reg_status_5  (reg_status_5),
    .reg_status_6  (reg_status_6),
    .reg_status_7  (reg_status_7),
    .reg_status_8  (reg_status_8),
    .reg_status_9  (reg_status_9),
    .reg_status_10 (reg_status_10),
    .reg_status_11 (reg_status_11),
    .reg_status_12 (reg_status_12),
    .reg_status_13 (reg_status_13),
    .reg_status_14 (reg_status_14),
    .reg_status_15 (reg_status_15),

    .reg_control_0  (reg_control_0),
    .reg_control_1  (reg_control_1),
    .reg_control_2  (reg_control_2),
    .reg_control_3  (reg_control_3),
    .reg_control_4  (reg_control_4),
    .reg_control_5  (reg_control_5),
    .reg_control_6  (reg_control_6),
    .reg_control_7  (reg_control_7),
    .reg_control_8  (reg_control_8),
    .reg_control_9  (reg_control_9),
    .reg_control_10 (reg_control_10),
    .reg_control_11 (reg_control_11),
    .reg_control_12 (reg_control_12),
    .reg_control_13 (reg_control_13),
    .reg_control_14 (reg_control_14),
    .reg_control_15 (reg_control_15),

    // bus interface

    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

 up_axi #(
    .AXI_ADDRESS_WIDTH(7)
 ) i_up_axi (
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
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
