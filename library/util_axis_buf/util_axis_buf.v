// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
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

module util_axis_buf #(
  parameter          DATA_WIDTH = 32
) (
  input                        m_axis_aclk,
  input                        m_axis_aresetn,
  
  // slave axi stream interface
  input                        s_axis_valid,
  input   [ DATA_WIDTH-1:0]    s_axis_data,
  output                       s_axis_ready,
  input                        s_axis_last,
  input   [DATA_WIDTH/8-1:0]   s_axis_keep,
  
  // master axi stream interface
  output                       m_axis_valid,
  output   [ DATA_WIDTH-1:0]   m_axis_data,
  input                        m_axis_ready,
  output                       m_axis_last,
  output   [DATA_WIDTH/8-1:0]  m_axis_keep
);

  // internal registers

  reg [ DATA_WIDTH-1:0] axis_data_dly;
  reg axis_valid_dly;
  reg axis_last_dly;
  reg [DATA_WIDTH/8-1:0] axis_keep_dly;

  // signal assignments

  assign m_axis_data = axis_data_dly;
  assign m_axis_valid = axis_valid_dly;
  assign m_axis_last = axis_last_dly;
  assign m_axis_keep = axis_keep_dly;
  assign s_axis_ready = ((axis_valid_dly == 1'b1) && (m_axis_ready == 1'b1)) || (axis_valid_dly == 1'b0);

  // buffering of AXI Valid, Last, Keep and Data signals

  always @(posedge m_axis_aclk or negedge m_axis_aresetn) begin
    if (m_axis_aresetn == 1'b0) begin
      axis_data_dly <= {DATA_WIDTH{1'b0}};
      axis_valid_dly <= 1'b0;
      axis_last_dly <= 1'b0;
      axis_keep_dly <= {DATA_WIDTH/8{1'b0}};
    end else begin
      // If we are transferring right now the data from the buffer, or if there is no data in the buffer
      if ( ((axis_valid_dly == 1'b1) && (m_axis_ready == 1'b1)) || (axis_valid_dly == 1'b0) ) begin
        axis_data_dly <= s_axis_data;
        axis_valid_dly <= s_axis_valid;
        axis_last_dly <= s_axis_last;
        axis_keep_dly <= s_axis_keep;
      end
    end
  end

endmodule
