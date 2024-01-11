// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns/1ps

module axi_time_tx #(
  parameter  COUNT_WIDTH = 64,
  parameter  DATA_WIDTH = 64,
  parameter  AXIS_ID = 8,
  parameter  AXIS_DEST = 4
) (

  input  logic                     clk,
  input  logic                     resetn,

  input  logic                     time_enable,
  output logic                     time_running,
  output logic                     time_underrun,

  input  logic [COUNT_WIDTH-1:0]   time_counter,
  output logic [COUNT_WIDTH-1:0]   time_capture,
  input  logic [COUNT_WIDTH-1:0]   time_trigger,

  output logic                     time_capture_valid,
  output logic                     time_trigger_ready,
  input  logic                     time_trigger_valid,

  output logic                     s_axis_ready,
  input  logic                     s_axis_valid,
  input  logic [DATA_WIDTH-1:0]    s_axis_data,
  input  logic [DATA_WIDTH/8-1:0]  s_axis_strb,
  input  logic [DATA_WIDTH/8-1:0]  s_axis_keep,
  input  logic [0:0]               s_axis_user,
  input  logic [AXIS_ID-1:0]       s_axis_id,
  input  logic [AXIS_DEST-1:0]     s_axis_dest,
  input  logic                     s_axis_last,
  input  logic                     s_axis_xfer_req,

  input  logic                     m_axis_ready,
  output logic                     m_axis_valid,
  output logic [DATA_WIDTH-1:0]    m_axis_data,
  output logic [DATA_WIDTH/8-1:0]  m_axis_strb,
  output logic [DATA_WIDTH/8-1:0]  m_axis_keep,
  output logic [0:0]               m_axis_user,
  output logic [AXIS_ID-1:0]       m_axis_id,
  output logic [AXIS_DEST-1:0]     m_axis_dest,
  output logic                     m_axis_last,
  output logic                     m_axis_xfer_req
);

  // Internal registers/wires
  logic                   capture_active;
  logic                   capture_trigger;
  logic                   trigger_active;
  logic                   trigger_init;
  logic                   data_en;

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      trigger_active <= 1'b0;
    end else begin
      if (capture_trigger || time_underrun) begin
        trigger_active <= 1'b0;
      end else begin
        if (trigger_init) begin
          trigger_active <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      time_underrun <= 1'b0;
    end else begin
      if (trigger_init || trigger_active) begin
        time_underrun <= time_counter > time_trigger;
      end else begin
        time_underrun <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      capture_active <= 1'b0;
    end else begin
      if (~s_axis_xfer_req) begin
        capture_active <= 1'b0;
      end else begin
        if (capture_trigger) begin
          capture_active <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      time_running <= 1'b0;
    end else begin
      time_running <= trigger_active | capture_active;
    end
  end

  assign trigger_init = time_enable & time_trigger_valid;
  assign capture_trigger = (trigger_init | trigger_active) & (time_counter == time_trigger);
  assign time_trigger_ready = ~trigger_active;
  assign time_capture_valid = capture_active & ~s_axis_xfer_req;
  assign time_capture = time_counter;
  assign data_en = ~time_enable | capture_active;

  // Multiplex the interface signals
  assign s_axis_ready = m_axis_ready;
  assign m_axis_valid = data_en ? s_axis_valid : 1'b0;
  assign m_axis_data = data_en ? s_axis_data : 'h0;
  assign m_axis_strb = data_en ? s_axis_strb : 'h0;
  assign m_axis_keep = data_en ? s_axis_keep : 'h0;
  assign m_axis_user = data_en ? s_axis_user : 1'b0;
  assign m_axis_id = data_en ? s_axis_id : 'h0;
  assign m_axis_dest = data_en ? s_axis_dest : 'h0;
  assign m_axis_last = data_en ? s_axis_last : 1'b0;
  assign m_axis_xfer_req = s_axis_xfer_req;

endmodule
