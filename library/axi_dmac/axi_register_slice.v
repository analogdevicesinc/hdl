// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module axi_register_slice #(

  parameter DATA_WIDTH = 32,
  parameter FORWARD_REGISTERED = 0,
  parameter BACKWARD_REGISTERED = 0
) (
  input clk,
  input resetn,

  input s_axi_valid,
  output s_axi_ready,
  input [DATA_WIDTH-1:0] s_axi_data,

  output m_axi_valid,
  input m_axi_ready,
  output [DATA_WIDTH-1:0] m_axi_data
);

  /*
   s_axi_data  -> bwd_data     -> fwd_data(1)  -> m_axi_data
   s_axi_valid -> bwd_valid    -> fwd_valid(1) -> m_axi_valid
   s_axi_ready <- bwd_ready(2) <- fwd_ready <- m_axi_ready

   (1) FORWARD_REGISTERED inserts a set of FF before m_axi_data and m_axi_valid
   (2) BACKWARD_REGISTERED insters a FF before s_axi_ready
  */

  wire [DATA_WIDTH-1:0] bwd_data_s;
  wire bwd_valid_s;
  wire bwd_ready_s;
  wire [DATA_WIDTH-1:0] fwd_data_s;
  wire fwd_valid_s;
  wire fwd_ready_s;

  generate if (FORWARD_REGISTERED == 1) begin
    reg fwd_valid = 1'b0;
    reg [DATA_WIDTH-1:0] fwd_data = 'h00;

    assign fwd_ready_s = ~fwd_valid | m_axi_ready;
    assign fwd_valid_s = fwd_valid;
    assign fwd_data_s = fwd_data;

    always @(posedge clk) begin
      if (~fwd_valid | m_axi_ready)
        fwd_data <= bwd_data_s;
    end

    always @(posedge clk) begin
      if (resetn == 1'b0) begin
        fwd_valid <= 1'b0;
      end else begin
        if (bwd_valid_s)
          fwd_valid <= 1'b1;
        else if (m_axi_ready)
          fwd_valid <= 1'b0;
      end
    end
  end else begin
    assign fwd_data_s = bwd_data_s;
    assign fwd_valid_s = bwd_valid_s;
    assign fwd_ready_s = m_axi_ready;
  end
  endgenerate

  generate if (BACKWARD_REGISTERED == 1) begin
    reg bwd_ready = 1'b1;
    reg [DATA_WIDTH-1:0] bwd_data = 'h00;

    assign bwd_valid_s = ~bwd_ready | s_axi_valid;
    assign bwd_data_s = bwd_ready ? s_axi_data : bwd_data;
    assign bwd_ready_s = bwd_ready;

    always @(posedge clk) begin
      if (bwd_ready)
        bwd_data <= s_axi_data;
    end

    always @(posedge clk) begin
      if (resetn == 1'b0) begin
        bwd_ready <= 1'b1;
      end else begin
        if (fwd_ready_s)
          bwd_ready <= 1'b1;
        else if (s_axi_valid)
          bwd_ready <= 1'b0;
      end
    end
  end else begin
    assign bwd_valid_s = s_axi_valid;
    assign bwd_data_s = s_axi_data;
    assign bwd_ready_s = fwd_ready_s;
  end endgenerate

  assign m_axi_data = fwd_data_s;
  assign m_axi_valid = fwd_valid_s;
  assign s_axi_ready = bwd_ready_s;

endmodule
