// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad7616_maxis2wrfifo (

  clk,
  rstn,
  sync_in,

  // m_axis interface

  m_axis_data,
  m_axis_ready,
  m_axis_valid,
  m_axis_xfer_req,

  // write fifo interface

  fifo_wr_en,
  fifo_wr_data,
  fifo_wr_sync,
  fifo_wr_xfer_req

);

  parameter   DATA_WIDTH = 16;

  input                     clk;
  input                     rstn;
  input                     sync_in;

  input  [DATA_WIDTH-1:0]   m_axis_data;
  output                    m_axis_ready;
  input                     m_axis_valid;
  output                    m_axis_xfer_req;

  output                    fifo_wr_en;
  output [DATA_WIDTH-1:0]   fifo_wr_data;
  output                    fifo_wr_sync;
  input                     fifo_wr_xfer_req;

  reg                       m_axis_ready = 1'b0;
  reg                       m_axis_xfer_req = 1'b0;
  reg                       fifo_wr_en = 1'b0;
  reg    [DATA_WIDTH-1:0]   fifo_wr_data = 'b0;
  reg                       fifo_wr_sync = 1'b0;

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
