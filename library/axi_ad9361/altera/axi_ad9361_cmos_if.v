// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory of
//      the repository (LICENSE_GPL2), and at: <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9361_cmos_if #(

  parameter   DEVICE_TYPE = 0,
  parameter   DAC_IODELAY_ENABLE = 0,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group") (

  // physical interface (receive)

  input                   rx_clk_in,
  input                   rx_frame_in,
  input       [11:0]      rx_data_in,

  // physical interface (transmit)

  output                  tx_clk_out,
  output                  tx_frame_out,
  output      [11:0]      tx_data_out,

  // ensm control

  output                  enable,
  output                  txnrx,

  // clock (common to both receive and transmit)

  input                   rst,
  input                   clk,
  output                  l_clk,

  // receive data path interface

  output                  adc_valid,
  output      [47:0]      adc_data,
  output                  adc_status,
  input                   adc_r1_mode,
  input                   adc_ddr_edgesel,

  // transmit data path interface

  input                   dac_valid,
  input       [47:0]      dac_data,
  input                   dac_clksel,
  input                   dac_r1_mode,

  // tdd interface

  input                   tdd_enable,
  input                   tdd_txnrx,
  input                   tdd_mode,

  // delay interface

  input                   mmcm_rst,
  input                   up_clk,
  input                   up_enable,
  input                   up_txnrx,
  input       [12:0]      up_adc_dld,
  input       [64:0]      up_adc_dwdata,
  output      [64:0]      up_adc_drdata,
  input       [15:0]      up_dac_dld,
  input       [79:0]      up_dac_dwdata,
  output      [79:0]      up_dac_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked);

  // cmos is not supported on altera platforms yet.

  assign tx_clk_out = 'd0;
  assign tx_frame_out = 'd0;
  assign tx_data_out = 'd0;
  assign enable = 'd0;
  assign txnrx = 'd0;
  assign l_clk = 'd0;
  assign adc_valid = 'd0;
  assign adc_data = 'd0;
  assign adc_status = 'd0;
  assign up_adc_drdata = 'd0;
  assign up_dac_drdata = 'd0;
  assign delay_locked = 'd0;

endmodule

// ***************************************************************************
// ***************************************************************************
