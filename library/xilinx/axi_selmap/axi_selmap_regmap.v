// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module axi_selmap_regmap #(
  parameter            DATA_WIDTH = 8,
  parameter            CORE_MAGIC = 32'h73656C6D // selm
) (
  input                        device_ready,
  input                        done,
  output                       reset,

  output      [DATA_WIDTH-1:0] data,
  output                       data_written,
  output                       csi_b,
  output                       program_b,

  // processor interface
  input                        up_rstn,
  input                        up_clk,
  input                        up_wreq,
  input       [13:0]           up_waddr,
  input       [31:0]           up_wdata,
  output reg                   up_wack,
  input                        up_rreq,
  input       [13:0]           up_raddr,
  output reg  [31:0]           up_rdata,
  output reg                   up_rack
);

  // internal registers

  reg     [31:0]           up_scratch = 'd0;
  reg                      up_reset = 1'b1;
  reg     [DATA_WIDTH-1:0] up_data;
  reg                      up_data_written;
  reg                      up_csi_b;
  reg                      up_program_b;
  reg    [31:0]            up_byte_counter;

  always @(posedge up_clk) begin
    if (!up_rstn || !up_reset) begin
      up_scratch <= 'd0;
      up_reset <= 1'b1;
      up_data <= 'd0;
      up_data_written <= 1'b0;
      up_csi_b <= 1'b1;
      up_program_b <= 1'b1;
      up_byte_counter <= 'd0;
    end else begin
      up_wack <= up_wreq;
      up_data_written <= 1'b0;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h1)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h2)) begin
        up_reset <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h3)) begin
        up_program_b <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h5)) begin
        up_csi_b <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h6)) begin
        if (!up_data_written) begin
          up_data <= up_wdata[DATA_WIDTH-1:0];
          up_data_written <= 1'b1;
          up_byte_counter <= up_byte_counter + 1'd1;
        end
      end
    end
  end

  always @(posedge up_clk) begin
    if (!up_rstn || !up_reset) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          14'h0: up_rdata <= CORE_MAGIC;
          14'h1: up_rdata <= up_scratch;
          14'h2: up_rdata <= up_reset;
          14'h3: up_rdata <= up_program_b;
          14'h4: up_rdata <= device_ready;
          14'h5: up_rdata <= up_csi_b;
          14'h6: up_rdata <= up_data;
          14'h7: up_rdata <= up_byte_counter;
          14'h8: up_rdata <= done;
          default: up_rdata <= 0;
         endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  assign reset = up_reset;

  assign data = up_data;
  assign data_written = up_data_written;
  assign csi_b = up_csi_b;
  assign program_b = up_program_b;

endmodule
