// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

// One registered APB stage: the request is registered towards the master
// port and the response is registered towards the slave port. The slave port
// holds pready low (wait states) until the forwarded transfer completes.

module util_apb_pipe_stage #(
  parameter   ADDRESS_WIDTH = 32,
  parameter   DATA_WIDTH = 32
) (

  input                           clk,
  input                           resetn,

  // apb slave port

  input       [ADDRESS_WIDTH-1:0] s_apb_paddr,
  input                           s_apb_psel,
  input                           s_apb_penable,
  input                           s_apb_pwrite,
  input       [DATA_WIDTH-1:0]    s_apb_pwdata,
  output  reg [DATA_WIDTH-1:0]    s_apb_prdata = 'd0,
  output                          s_apb_pready,
  output                          s_apb_pslverr,

  // apb master port

  output  reg [ADDRESS_WIDTH-1:0] m_apb_paddr = 'd0,
  output                          m_apb_psel,
  output                          m_apb_penable,
  output  reg                     m_apb_pwrite = 'd0,
  output  reg [DATA_WIDTH-1:0]    m_apb_pwdata = 'd0,
  input       [DATA_WIDTH-1:0]    m_apb_prdata,
  input                           m_apb_pready,
  input                           m_apb_pslverr
);

  localparam  [ 1:0]  STATE_IDLE = 2'd0;
  localparam  [ 1:0]  STATE_SETUP = 2'd1;
  localparam  [ 1:0]  STATE_ACCESS = 2'd2;
  localparam  [ 1:0]  STATE_RESPONSE = 2'd3;

  // internal registers

  reg         [ 1:0]  state = STATE_IDLE;
  reg                 pslverr = 1'b0;

  // master port controls and slave port response

  assign m_apb_psel = (state == STATE_SETUP) || (state == STATE_ACCESS);
  assign m_apb_penable = (state == STATE_ACCESS);

  assign s_apb_pready = (state == STATE_RESPONSE);
  assign s_apb_pslverr = (state == STATE_RESPONSE) & pslverr;

  // the request is taken in the setup phase of the slave port, the slave port
  // keeps the request stable until pready

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      state <= STATE_IDLE;
    end else begin
      case (state)
        STATE_IDLE: begin
          if ((s_apb_psel == 1'b1) && (s_apb_penable == 1'b0)) begin
            state <= STATE_SETUP;
          end
        end
        STATE_SETUP: begin
          state <= STATE_ACCESS;
        end
        STATE_ACCESS: begin
          if (m_apb_pready == 1'b1) begin
            state <= STATE_RESPONSE;
          end
        end
        default: begin
          state <= STATE_IDLE;
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if ((state == STATE_IDLE) && (s_apb_psel == 1'b1) && (s_apb_penable == 1'b0)) begin
      m_apb_paddr <= s_apb_paddr;
      m_apb_pwrite <= s_apb_pwrite;
      m_apb_pwdata <= s_apb_pwdata;
    end
  end

  always @(posedge clk) begin
    if ((state == STATE_ACCESS) && (m_apb_pready == 1'b1)) begin
      s_apb_prdata <= m_apb_prdata;
      pslverr <= m_apb_pslverr;
    end
  end

endmodule
