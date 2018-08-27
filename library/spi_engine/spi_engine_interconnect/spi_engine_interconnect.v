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

module spi_engine_interconnect #(

  parameter DATA_WIDTH = 8,                   // Valid data widths values are 8/16/24/32
  parameter NUM_OF_SDI = 1 ) (

  input clk,
  input resetn,

  output m_cmd_valid,
  input m_cmd_ready,
  output [15:0] m_cmd_data,

  output m_sdo_valid,
  input m_sdo_ready,
  output [(DATA_WIDTH-1):0] m_sdo_data,

  input m_sdi_valid,
  output m_sdi_ready,
  input [(NUM_OF_SDI * DATA_WIDTH-1):0] m_sdi_data,

  input m_sync_valid,
  output m_sync_ready,
  input [7:0] m_sync,


  input s0_cmd_valid,
  output s0_cmd_ready,
  input [15:0] s0_cmd_data,

  input s0_sdo_valid,
  output s0_sdo_ready,
  input [(DATA_WIDTH-1):0] s0_sdo_data,

  output s0_sdi_valid,
  input s0_sdi_ready,
  output [(NUM_OF_SDI * DATA_WIDTH-1):0] s0_sdi_data,

  output s0_sync_valid,
  input s0_sync_ready,
  output [7:0] s0_sync,


  input s1_cmd_valid,
  output s1_cmd_ready,
  input [15:0] s1_cmd_data,

  input s1_sdo_valid,
  output s1_sdo_ready,
  input [(DATA_WIDTH-1):0] s1_sdo_data,

  output s1_sdi_valid,
  input s1_sdi_ready,
  output [(NUM_OF_SDI * DATA_WIDTH-1):0] s1_sdi_data,

  output s1_sync_valid,
  input s1_sync_ready,
  output [7:0] s1_sync
);

reg s_active = 1'b0;

reg idle = 1'b1;

`define spi_engine_interconnect_mux(s0, s1) (idle == 1'b1 ? 1'b0 : (s_active == 1'b0 ? s0 : s1))

assign m_cmd_data   = s_active == 1'b0 ? s0_cmd_data : s1_cmd_data;
assign m_cmd_valid  = `spi_engine_interconnect_mux(s0_cmd_valid, s1_cmd_valid);
assign s0_cmd_ready = `spi_engine_interconnect_mux(m_cmd_ready, 1'b0);
assign s1_cmd_ready = `spi_engine_interconnect_mux(1'b0, m_cmd_ready);

assign m_sdo_data   = s_active == 1'b0 ? s0_sdo_data : s1_sdo_data;
assign m_sdo_valid  = `spi_engine_interconnect_mux(s0_sdo_valid, s1_sdo_valid);
assign s0_sdo_ready = `spi_engine_interconnect_mux(m_sdo_ready, 1'b0);
assign s1_sdo_ready = `spi_engine_interconnect_mux(1'b0, m_sdo_ready);

assign s0_sdi_data  = m_sdi_data;
assign s1_sdi_data  = m_sdi_data;
assign m_sdi_ready  = `spi_engine_interconnect_mux(s0_sdi_ready, s1_sdi_ready);
assign s0_sdi_valid = `spi_engine_interconnect_mux(m_sdi_valid, 1'b0);
assign s1_sdi_valid = `spi_engine_interconnect_mux(1'b0, m_sdi_valid);

assign s0_sync       = m_sync;
assign s1_sync       = m_sync;
assign m_sync_ready  = `spi_engine_interconnect_mux(s0_sync_ready, s1_sync_ready);
assign s0_sync_valid = `spi_engine_interconnect_mux(m_sync_valid, 1'b0);
assign s1_sync_valid = `spi_engine_interconnect_mux(1'b0, m_sync_valid);

always @(posedge clk) begin
  if (idle == 1'b1) begin
    if (s0_cmd_valid)
      s_active <= 1'b0;
    else if (s1_cmd_valid)
      s_active <= 1'b1;
  end
end

always @(posedge clk) begin
  if (resetn == 1'b0) begin
    idle = 1'b1;
  end else begin
    if (m_sync_valid == 1'b1 && m_sync_ready == 1'b1) begin
      idle <= 1'b1;
    end else if (s0_cmd_valid == 1'b1 || s1_cmd_valid == 1'b1) begin
      idle <= 1'b0;
    end
  end
end

endmodule
