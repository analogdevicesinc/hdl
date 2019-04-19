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

module axi_ad9152 #(

  parameter   ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   DAC_DDS_TYPE = 1,
  parameter   DAC_DDS_CORDIC_DW = 16,
  parameter   DAC_DDS_CORDIC_PHASE_DW = 16,
  parameter   DAC_DATAPATH_DISABLE = 0) (

  // jesd interface
  // tx_clk is (line-rate/40)

  input                   tx_clk,
  output      [127:0]     tx_data,
  output                  tx_valid,
  input                   tx_ready,

  // dma interface

  output                  dac_clk,
  output                  dac_valid_0,
  output                  dac_enable_0,
  input       [ 63:0]     dac_ddata_0,
  output                  dac_valid_1,
  output                  dac_enable_1,
  input       [ 63:0]     dac_ddata_1,
  input                   dac_dunf,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [ 11:0]     s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [ 31:0]     s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [ 11:0]     s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 31:0]     s_axi_rdata,
  output      [ 1:0]      s_axi_rresp,
  input                   s_axi_rready);

  assign dac_clk = tx_clk;

  ad_ip_jesd204_tpl_dac #(
    .ID(ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .NUM_LANES(4),
    .NUM_CHANNELS(2),
    .CONVERTER_RESOLUTION (16),
    .BITS_PER_SAMPLE (16),
    .SAMPLES_PER_FRAME (1),
    .DDS_TYPE (DAC_DDS_TYPE),
    .DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .DATAPATH_DISABLE(DAC_DATAPATH_DISABLE)
  ) i_dac_jesd204 (
    .link_clk (tx_clk),

    .link_valid (tx_valid),
    .link_data (tx_data),
    .link_ready (tx_ready),

    .enable ({dac_enable_1,dac_enable_0}),
    .dac_valid ({dac_valid_1,dac_valid_0}),
    .dac_ddata ({dac_ddata_1,dac_ddata_0}),
    .dac_dunf (dac_dunf),

    .s_axi_aclk (s_axi_aclk),
    .s_axi_aresetn (s_axi_aresetn),
    .s_axi_awvalid (s_axi_awvalid),
    .s_axi_awready (s_axi_awready),
    .s_axi_awaddr (s_axi_awaddr),
    .s_axi_awprot (s_axi_awprot),
    .s_axi_wvalid (s_axi_wvalid),
    .s_axi_wready (s_axi_wready),
    .s_axi_wdata (s_axi_wdata),
    .s_axi_wstrb (s_axi_wstrb),
    .s_axi_bvalid (s_axi_bvalid),
    .s_axi_bready (s_axi_bready),
    .s_axi_bresp (s_axi_bresp),
    .s_axi_arvalid (s_axi_arvalid),
    .s_axi_arready (s_axi_arready),
    .s_axi_araddr (s_axi_araddr),
    .s_axi_arprot (s_axi_arprot),
    .s_axi_rvalid (s_axi_rvalid),
    .s_axi_rready (s_axi_rready),
    .s_axi_rdata (s_axi_rdata),
    .s_axi_rresp (s_axi_rresp)
  );

endmodule
