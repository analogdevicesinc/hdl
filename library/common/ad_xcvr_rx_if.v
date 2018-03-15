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

module ad_xcvr_rx_if (

  // jesd interface

  input                   rx_clk,
  input       [ 3:0]      rx_ip_sof,
  input       [31:0]      rx_ip_data,
  output  reg             rx_sof,
  output  reg [31:0]      rx_data);


  // internal registers

  reg     [31:0]  rx_ip_data_d = 'd0;
  reg     [ 3:0]  rx_ip_sof_hold = 'd0;
  reg     [ 3:0]  rx_ip_sof_d = 'd0;

  // dword may contain more than one frame per clock

  always @(posedge rx_clk) begin
    rx_ip_data_d <= rx_ip_data;
    rx_ip_sof_d <= rx_ip_sof;
    if (rx_ip_sof != 4'h0) begin
      rx_ip_sof_hold <= rx_ip_sof;
    end
    rx_sof <= |rx_ip_sof_d;
    if (rx_ip_sof_hold[0] == 1'b1) begin
      rx_data <= rx_ip_data;
    end else if (rx_ip_sof_hold[1] == 1'b1) begin
      rx_data <= {rx_ip_data[ 7:0], rx_ip_data_d[31: 8]};
    end else if (rx_ip_sof_hold[2] == 1'b1) begin
      rx_data <= {rx_ip_data[15:0], rx_ip_data_d[31:16]};
    end else if (rx_ip_sof_hold[3] == 1'b1) begin
      rx_data <= {rx_ip_data[23:0], rx_ip_data_d[31:24]};
    end else begin
      rx_data <= 32'd0;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
