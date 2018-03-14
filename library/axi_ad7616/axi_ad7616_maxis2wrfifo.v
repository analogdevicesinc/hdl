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

module axi_ad7616_maxis2wrfifo #(

  parameter   DATA_WIDTH = 16) (

  input                   clk,
  input                   rstn,
  input                   sync_in,

  // m_axis interface

  input       [DATA_WIDTH-1:0]  m_axis_data,
  output  reg             m_axis_ready,
  input                   m_axis_valid,
  output  reg             m_axis_xfer_req,

  // write fifo interface

  output  reg             fifo_wr_en,
  output  reg [DATA_WIDTH-1:0]  fifo_wr_data,
  output  reg             fifo_wr_sync,
  input                   fifo_wr_xfer_req
);


  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      m_axis_ready <= 1'b0;
      m_axis_xfer_req <= 1'b0;
      fifo_wr_data <= 'b0;
      fifo_wr_en <= 1'b0;
      fifo_wr_sync <= 1'b0;
    end else begin
      m_axis_ready <= 1'b1;
      m_axis_xfer_req <= fifo_wr_xfer_req;
      fifo_wr_data <= m_axis_data;
      fifo_wr_en <= m_axis_valid;
      if (sync_in == 1'b1) begin
        fifo_wr_sync <= 1'b1;
      end else if ((m_axis_valid == 1'b1) &&
                   (fifo_wr_sync == 1'b1)) begin
        fifo_wr_sync <= 1'b0;
      end
    end
  end

endmodule
