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
// Receive HDMI, hdmi embedded syncs data in, video dma data out.

`timescale 1ns/100ps

module axi_hdmi_rx_es #(

  parameter   DATA_WIDTH = 32) (

  // hdmi interface

  input                   hdmi_clk,
  input       [(DATA_WIDTH-1):0]  hdmi_data,
  output  reg             hdmi_vs_de,
  output  reg             hdmi_hs_de,
  output  reg [(DATA_WIDTH-1):0]  hdmi_data_de);

  localparam  BYTE_WIDTH = DATA_WIDTH/8;

  // internal registers

  reg     [(DATA_WIDTH-1):0]  hdmi_data_d = 'd0;
  reg                         hdmi_hs_de_rcv_d = 'd0;
  reg                         hdmi_vs_de_rcv_d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_2d = 'd0;
  reg                         hdmi_hs_de_rcv_2d = 'd0;
  reg                         hdmi_vs_de_rcv_2d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_3d = 'd0;
  reg                         hdmi_hs_de_rcv_3d = 'd0;
  reg                         hdmi_vs_de_rcv_3d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_4d = 'd0;
  reg                         hdmi_hs_de_rcv_4d = 'd0;
  reg                         hdmi_vs_de_rcv_4d = 'd0;
  reg     [ 1:0]              hdmi_preamble_cnt = 'd0;
  reg                         hdmi_hs_de_rcv = 'd0;
  reg                         hdmi_vs_de_rcv = 'd0;

  // internal signals

  wire    [(DATA_WIDTH-1):0]  hdmi_ff_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_00_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_b6_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_9d_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_ab_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_80_s;

  // es constants

  assign hdmi_ff_s = {BYTE_WIDTH{8'hff}};
  assign hdmi_00_s = {BYTE_WIDTH{8'h00}};
  assign hdmi_b6_s = {BYTE_WIDTH{8'hb6}};
  assign hdmi_9d_s = {BYTE_WIDTH{8'h9d}};
  assign hdmi_ab_s = {BYTE_WIDTH{8'hab}};
  assign hdmi_80_s = {BYTE_WIDTH{8'h80}};

  // delay to get rid of eav's 4 bytes

  always @(posedge hdmi_clk) begin
    hdmi_data_d <= hdmi_data;
    hdmi_hs_de_rcv_d <= hdmi_hs_de_rcv;
    hdmi_vs_de_rcv_d <= hdmi_vs_de_rcv;
    hdmi_data_2d <= hdmi_data_d;
    hdmi_hs_de_rcv_2d <= hdmi_hs_de_rcv_d;
    hdmi_vs_de_rcv_2d <= hdmi_vs_de_rcv_d;
    hdmi_data_3d <= hdmi_data_2d;
    hdmi_hs_de_rcv_3d <= hdmi_hs_de_rcv_2d;
    hdmi_vs_de_rcv_3d <= hdmi_vs_de_rcv_2d;
    hdmi_data_4d <= hdmi_data_3d;
    hdmi_hs_de_rcv_4d <= hdmi_hs_de_rcv_3d;
    hdmi_vs_de_rcv_4d <= hdmi_vs_de_rcv_3d;
    hdmi_data_de  <= hdmi_data_4d;
    hdmi_hs_de <= hdmi_hs_de_rcv & hdmi_hs_de_rcv_4d;
    hdmi_vs_de <= hdmi_vs_de_rcv & hdmi_vs_de_rcv_4d;
  end

  // check for sav and eav and generate the corresponding enables

  always @(posedge hdmi_clk) begin
    if ((hdmi_data == hdmi_ff_s) || (hdmi_data == hdmi_00_s)) begin
      hdmi_preamble_cnt <= hdmi_preamble_cnt + 1'b1;
    end else begin
      hdmi_preamble_cnt <= 'd0;
    end
    if (hdmi_preamble_cnt == 3'b11) begin
      if ((hdmi_data == hdmi_b6_s) || (hdmi_data == hdmi_9d_s)) begin
        hdmi_hs_de_rcv <= 1'b0;
      end else if ((hdmi_data == hdmi_ab_s) || (hdmi_data == hdmi_80_s)) begin
        hdmi_hs_de_rcv <= 1'b1;
      end
      if (hdmi_data == hdmi_b6_s) begin
        hdmi_vs_de_rcv <= 1'b0;
      end else if (hdmi_data == hdmi_9d_s) begin
        hdmi_vs_de_rcv <= 1'b1;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
