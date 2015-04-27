// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
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

module util_dacfifo (


  // FIFO read interface
  rd_fifo_clk,             // should be connected to a lower system clock
  rd_fifo_rst,
  rd_fifo_en,
  rd_fifo_valid,
  rd_fifo_data,
  rd_fifo_underflow,
  rd_fifo_xfer_req,

  // AXIS Slave interface (connection with DMAC)

  s_axis_aclk,
  s_axis_aresetn,
  s_axis_ready,
  s_axis_valid,
  s_axis_data,
  s_axis_last,

  // FIFO write interface (connection with upack/DAC)

  wr_fifo_clk,             // should be connected to the dac clock
  wr_fifo_valid,
  wr_fifo_sync,
  wr_fifo_data
);

  // parameters
  parameter       RD_INTERFACE_MODE = 0;

  // depth of the FIFO
  parameter       FIFO_WADDR_WIDTH = 6;

  // read/write interface data width
  parameter       FIFO_RDATA_WIDTH = 64;      // should be less or equal to FIFO_WDATA_WIDTH
  parameter       FIFO_WDATA_WIDTH = 128;

  // local parameters

  // supported ratios with the write interface are 1:1, 1:2, 1:4, 1:8
  localparam      IF_RATIO = FIFO_WDATA_WIDTH/FIFO_RDATA_WIDTH;

  // FSM state definitions
  localparam      IDLE = 0;
  localparam      READ = 1;

  // interface type definitions
  localparam      RD_FIFO_IF = 0;
  localparam      S_AXIS_IF = 1;

  // port definitions

  // RD FIFO interface
  input                                         rd_fifo_clk;
  input                                         rd_fifo_rst;
  output                                        rd_fifo_en;
  input                                         rd_fifo_valid;
  input   [(FIFO_RDATA_WIDTH-1):0]              rd_fifo_data;
  input                                         rd_fifo_underflow;
  input                                         rd_fifo_xfer_req;

  // Slave AXI Stream interface
  input                                         s_axis_aclk;
  input                                         s_axis_aresetn;
  input                                         s_axis_valid;
  input   [(FIFO_RDATA_WIDTH-1):0]              s_axis_data;
  input                                         s_axis_last;
  output                                        s_axis_ready;

  // WR FIFO interface
  input                                         wr_fifo_clk;
  input                                         wr_fifo_valid;
  input                                         wr_fifo_sync;
  output  [(FIFO_WDATA_WIDTH-1):0]              wr_fifo_data;

  // internal registers

  reg     [FIFO_WADDR_WIDTH-1:0]                fifo_waddr = 'h0;
  reg     [(FIFO_RDATA_WIDTH*IF_RATIO)-1:0]     fifo_rdata = 'h0;

  reg     [FIFO_WDATA_WIDTH-1:0]                wr_fifo_data = 'h0;
  reg                                           rd_en = 1'b0;

  reg                                           fifo_ren = 1'b0;
  reg     [FIFO_WADDR_WIDTH-1:0]                fifo_maxraddr = {FIFO_WADDR_WIDTH{1'b1}};
  reg     [FIFO_WADDR_WIDTH-1:0]                fifo_raddr = 'h0;
  reg     [FIFO_WADDR_WIDTH-1:0]                fifo_raddr_ff = 'h0;

  reg     [ 2:0]                                fifo_rdata_count = 3'h0;

  reg                                           fifo_state = IDLE;
  reg                                           fifo_next_state = IDLE;

  // internal wires

  // common read interface
  wire                                          rd_clk;
  wire                                          rd_rst;
  wire                                          rd_ready;   // or could be rd_en
  wire     [FIFO_RDATA_WIDTH-1:0]               rd_data;
  wire                                          rd_valid;

  wire    [FIFO_WDATA_WIDTH-1:0]                fifo_wdata_s;

  // define the common read interface
  generate if (RD_INTERFACE_MODE == RD_FIFO_IF) begin

    assign  rd_clk        = rd_fifo_clk;
    assign  rd_rst        = rd_fifo_rst;
    assign  rd_data       = rd_fifo_data;
    assign  rd_valid      = rd_fifo_valid;

    assign  rd_fifo_en    = rd_ready;

  end else begin // if (RD_INTERFACE_MODE == S_AXIS_IF)

    assign  rd_clk        = s_axis_aclk;
    assign  rd_rst        = ~s_axis_aresetn;
    assign  rd_data       = s_axis_data;
    assign  rd_valid      = s_axis_valid;

    assign  s_axis_ready  = rd_ready;

  end
  endgenerate

  // **** Define FIFO state machine ****

  // in <IDLE> the FIFO writes data into DAC
  // in <READ> the FIFO is loaded with data through the S_AXIS interface,
  // the FIFO write interface sending NULLs to the DAC during the read process

  always @(posedge rd_clk) begin
    if(rd_rst == 1) begin
      fifo_state <= IDLE;
    end else begin
      fifo_state <= fifo_next_state;
    end
  end

  // next state logic
  generate if (RD_INTERFACE_MODE == RD_FIFO_IF) begin

    always @(rd_valid or rd_fifo_xfer_req) begin
      case (fifo_state)
        IDLE: begin
          if((rd_valid == 1) && (rd_fifo_xfer_req == 1))
            fifo_next_state <= READ;
        end
        READ: begin
          if(rd_fifo_xfer_req == 0)
            fifo_next_state <= IDLE;
        end
      endcase
    end

  end else begin // if (RD_INTERFACE_MODE == S_AXIS_IF)

    always @(rd_valid or s_axis_last) begin
      case (fifo_state)
        IDLE: begin
          if(rd_valid == 1)
            fifo_next_state <= READ;
        end
        READ: begin
          if((rd_valid == 1) && (s_axis_last == 1))
            fifo_next_state <= IDLE;
        end
      endcase
    end

  end
  endgenerate

  // FIFO is always ready to accept data from memory
  assign rd_ready = 1;

  // adjust the RD data width to the WR data width
  generate if (IF_RATIO > 1) begin

    always @(posedge rd_clk) begin
      if(s_axis_valid == 1) begin
        fifo_rdata <= {s_axis_data, fifo_rdata[((IF_RATIO * FIFO_RDATA_WIDTH)-1):FIFO_RDATA_WIDTH]};
        fifo_rdata_count <= (fifo_rdata_count  < (IF_RATIO - 1)) ? (fifo_rdata_count + 1) : 3'h0;
      end
    end

  end else begin

    always @(posedge rd_clk) begin
      if(s_axis_valid == 1) begin
        fifo_rdata <= s_axis_data;
      end
      fifo_rdata_count <= 3'b0;
    end

  end
  endgenerate

  // generate address for the incoming data
  always @(posedge rd_clk) begin
    if(fifo_state == IDLE) begin
      fifo_raddr <= 'b0;
    end else begin
      fifo_raddr <= (fifo_ren == 1) ? (fifo_raddr + 1) : fifo_raddr;
    end
    fifo_raddr_ff <= fifo_raddr;
  end

  // save the last valid address

  generate if (RD_INTERFACE_MODE == RD_FIFO_IF) begin

    always @(posedge rd_clk) begin
      if(rd_fifo_xfer_req == 0) begin
        fifo_maxraddr <= fifo_raddr;
      end
    end

  end else begin // if (RD_INTERFACE_MODE == S_AXIS_IF)

    always @(posedge rd_clk) begin
      if((rd_valid == 1) && (s_axis_last == 1)) begin
        fifo_maxraddr <= fifo_raddr;
      end
    end

  end
  endgenerate

  // generate wren for the incoming data
  always @(posedge rd_clk) begin
    fifo_ren <= (fifo_rdata_count == (IF_RATIO - 1)) ? rd_valid : 1'b0;
  end

  // write interface, FIFO writes data to DAC when its state is IDLE
  always @(posedge wr_fifo_clk) begin
    if(fifo_state == IDLE) begin
      fifo_waddr <= (fifo_waddr < fifo_maxraddr) ? (fifo_waddr + 1) : 'b0;
    end else begin
      fifo_waddr <= 'b0;
    end
    wr_fifo_data <= fifo_wdata_s;
  end

  // memory instantiation
  ad_mem #(
    .ADDR_WIDTH (FIFO_WADDR_WIDTH),
    .DATA_WIDTH (FIFO_WDATA_WIDTH))
  i_mem_fifo (
    .clka (rd_clk),
    .wea (fifo_ren),
    .addra (fifo_raddr_ff),
    .dina (fifo_rdata),
    .clkb (wr_fifo_clk),
    .addrb (fifo_waddr),
    .doutb (fifo_wdata_s));

endmodule
