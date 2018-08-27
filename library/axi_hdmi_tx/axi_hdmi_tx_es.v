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
// Transmit HDMI, video dma data in, hdmi separate syncs data out.

`timescale 1ns/100ps

module axi_hdmi_tx_es #(

  parameter   DATA_WIDTH = 32) (

  // hdmi interface

  input                   hdmi_clk,
  input                   hdmi_hs_de,
  input                   hdmi_vs_de,
  input       [(DATA_WIDTH-1):0]  hdmi_data_de,
  output  reg [(DATA_WIDTH-1):0]  hdmi_data);

  localparam  BYTE_WIDTH = DATA_WIDTH/8;

  // internal registers

  reg                         hdmi_hs_de_d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_d = 'd0;
  reg                         hdmi_hs_de_2d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_2d = 'd0;
  reg                         hdmi_hs_de_3d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_3d = 'd0;
  reg                         hdmi_hs_de_4d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_4d = 'd0;
  reg                         hdmi_hs_de_5d = 'd0;
  reg     [(DATA_WIDTH-1):0]  hdmi_data_5d = 'd0;

  // internal wires

  wire    [(DATA_WIDTH-1):0]  hdmi_sav_s;
  wire    [(DATA_WIDTH-1):0]  hdmi_eav_s;

  // hdmi embedded sync insertion

  assign hdmi_sav_s = (hdmi_vs_de == 1) ? {BYTE_WIDTH{8'h80}} : {BYTE_WIDTH{8'hab}};
  assign hdmi_eav_s = (hdmi_vs_de == 1) ? {BYTE_WIDTH{8'h9d}} : {BYTE_WIDTH{8'hb6}};

  always @(posedge hdmi_clk) begin
    hdmi_hs_de_d <= hdmi_hs_de;
    case ({hdmi_hs_de_4d, hdmi_hs_de_3d, hdmi_hs_de_2d,
      hdmi_hs_de_d, hdmi_hs_de})
      5'b11000: hdmi_data_d <= {BYTE_WIDTH{8'h00}};
      5'b11100: hdmi_data_d <= {BYTE_WIDTH{8'h00}};
      5'b11110: hdmi_data_d <= {BYTE_WIDTH{8'hff}};
      5'b10000: hdmi_data_d <= hdmi_eav_s;
      default: hdmi_data_d <= hdmi_data_de;
    endcase
    hdmi_hs_de_2d <= hdmi_hs_de_d;
    hdmi_data_2d <= hdmi_data_d;
    hdmi_hs_de_3d <= hdmi_hs_de_2d;
    hdmi_data_3d <= hdmi_data_2d;
    hdmi_hs_de_4d <= hdmi_hs_de_3d;
    hdmi_data_4d <= hdmi_data_3d;
    hdmi_hs_de_5d <= hdmi_hs_de_4d;
    hdmi_data_5d <= hdmi_data_4d;
    case ({hdmi_hs_de_5d, hdmi_hs_de_4d, hdmi_hs_de_3d,
      hdmi_hs_de_2d, hdmi_hs_de_d})
      5'b00111: hdmi_data <= {BYTE_WIDTH{8'h00}};
      5'b00011: hdmi_data <= {BYTE_WIDTH{8'h00}};
      5'b00001: hdmi_data <= {BYTE_WIDTH{8'hff}};
      5'b01111: hdmi_data <= hdmi_sav_s;
      default:  hdmi_data <= hdmi_data_5d;
    endcase
  end

endmodule

// ***************************************************************************
// ***************************************************************************
