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

module axi_ad9361_cmos_if #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   DAC_IODELAY_ENABLE = 0,
  parameter   CLK_DESKEW = 0,
  parameter   USE_SSI_CLK = 1,

  // Dummy parameters, required keep the code consistency(used on Xilinx)
  parameter   IO_DELAY_GROUP = "dev_if_delay_group",
  parameter   DELAY_REFCLK_FREQUENCY = 0) (

  // physical interface (receive)

  input               rx_clk_in,
  input               rx_frame_in,
  input   [11:0]      rx_data_in,

  // physical interface (transmit)

  output              tx_clk_out,
  output              tx_frame_out,
  output  [11:0]      tx_data_out,

  // ensm control

  output              enable,
  output              txnrx,

  // clock (common to both receive and transmit)

  input               rst,
  input               clk,
  output              l_clk,

  // receive data path interface

  output              adc_valid,
  output  [47:0]      adc_data,
  output              adc_status,
  input               adc_r1_mode,
  input               adc_ddr_edgesel,

  // transmit data path interface

  input               dac_valid,
  input   [47:0]      dac_data,
  input               dac_clksel,
  input               dac_r1_mode,

  // tdd interface

  input               tdd_enable,
  input               tdd_txnrx,
  input               tdd_mode,

  // delay interface

  input               mmcm_rst,
  input               up_clk,
  input               up_rstn,
  input               up_enable,
  input               up_txnrx,
  input   [12:0]      up_adc_dld,
  input   [64:0]      up_adc_dwdata,
  output  [64:0]      up_adc_drdata,
  input   [15:0]      up_dac_dld,
  input   [79:0]      up_dac_dwdata,
  output  [79:0]      up_dac_drdata,
  input               delay_clk,
  input               delay_rst,
  output              delay_locked,

  // drp interface

  input               up_drp_sel,
  input               up_drp_wr,
  input   [11:0]      up_drp_addr,
  input   [31:0]      up_drp_wdata,
  output  [31:0]      up_drp_rdata,
  output              up_drp_ready,
  output              up_drp_locked);

  // cmos is not supported on intel platforms yet.

  assign tx_clk_out = 1'd0;
  assign tx_frame_out = 1'd0;
  assign tx_data_out = 12'd0;
  assign enable = 1'd0;
  assign txnrx = 1'd0;
  assign l_clk = 1'd0;
  assign adc_valid = 1'd0;
  assign adc_data = 48'd0;
  assign adc_status = 1'd0;
  assign up_adc_drdata = 65'd0;
  assign up_dac_drdata = 80'd0;
  assign delay_locked = 1'd0;
  assign up_drp_rdata = 32'd0;
  assign up_drp_ready = 1'd0;
  assign up_drp_locked = 1'd0;

endmodule

// ***************************************************************************
// ***************************************************************************
