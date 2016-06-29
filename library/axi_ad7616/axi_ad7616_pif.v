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

module axi_ad7616_pif (

  // physical interface

  cs_n,
  db_o,
  db_i,
  db_t,
  rd_n,
  wr_n,

  // FIFO interface

  adc_data,
  adc_valid,
  adc_sync,

  // end of convertion

  end_of_conv,
  burst_length,

  // register access

  clk,
  rstn,
  rd_req,
  wr_req,
  wr_data,
  rd_data,
  rd_valid
);

  parameter UP_ADDRESS_WIDTH = 14;

  // IO definitions

  output                          cs_n;
  output  [15:0]                  db_o;
  input   [15:0]                  db_i;
  output                          db_t;
  output                          rd_n;
  output                          wr_n;

  input                           end_of_conv;
  input   [ 4:0]                  burst_length;

  input                           clk;
  input                           rstn;
  input                           rd_req;
  input                           wr_req;
  input   [15:0]                  wr_data;
  output  [15:0]                  rd_data;
  output                          rd_valid;

  output  [15:0]                  adc_data;
  output                          adc_valid;
  output                          adc_sync;

  // state registers

  localparam  [ 2:0]    IDLE = 3'h0,
                        CS_LOW = 3'h1,
                        CNTRL0_LOW = 3'h2,
                        CNTRL0_HIGH = 3'h3,
                        CNTRL1_LOW = 3'h4,
                        CNTRL1_HIGH = 3'h5,
                        CS_HIGH = 3'h6;

  // internal registers

  reg     [ 2:0]                  transfer_state = 3'h0;
  reg     [ 2:0]                  transfer_state_next = 3'h0;
  reg     [ 1:0]                  width_counter = 2'h0;
  reg     [ 4:0]                  burst_counter = 5'h0;

  reg                             wr_req_d = 1'h0;
  reg                             rd_req_d = 1'h0;
  reg                             rd_conv_d = 1'h0;

  reg                             xfer_req_d = 1'h0;

  reg                             adc_sync = 1'h0;
  reg                             rd_valid = 1'h0;
  reg                             rd_valid_d = 1'h0;
  reg     [15:0]                  rd_data = 16'h0;

  // internal wires

  wire                            start_transfer_s;
  wire                            rd_valid_s;

  // FSM state register

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      transfer_state <= 3'h0;
    end else begin
      transfer_state <= transfer_state_next;
    end
  end

  // counters to control the RD_N and WR_N lines

  assign start_transfer_s = end_of_conv | rd_req | wr_req;

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      width_counter <= 2'h0;
    end else begin
      if((transfer_state == CNTRL0_LOW) || (transfer_state == CNTRL0_HIGH) ||
         (transfer_state == CNTRL1_LOW) || (transfer_state == CNTRL1_HIGH))
        width_counter <= width_counter + 1;
      else
        width_counter <= 2'h0;
    end
  end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      burst_counter <= 2'h0;
    end else begin
      if (transfer_state == CS_HIGH)
        burst_counter <= burst_counter + 1;
      else if (transfer_state == IDLE)
        burst_counter <= 5'h0;
    end
  end

  always @(negedge clk) begin
    if (transfer_state == IDLE) begin
      wr_req_d <= wr_req;
      rd_req_d <= rd_req;
      rd_conv_d <= end_of_conv;
    end
  end

  // FSM next state logic

  always @(*) begin
    case (transfer_state)
      IDLE : begin
        transfer_state_next <= (start_transfer_s == 1'b1) ? CS_LOW : IDLE;
      end
      CS_LOW : begin
        transfer_state_next <= CNTRL0_LOW;
      end
      CNTRL0_LOW : begin
        transfer_state_next <= (width_counter != 2'b11) ? CNTRL0_LOW : CNTRL0_HIGH;
      end
      CNTRL0_HIGH : begin
        transfer_state_next <= (width_counter != 2'b11) ? CNTRL0_HIGH :
                               ((wr_req_d == 1'b1) || (rd_req_d == 1'b1)) ? CS_HIGH : CNTRL1_LOW;
      end
      CNTRL1_LOW : begin
        transfer_state_next <= (width_counter != 2'b11) ? CNTRL1_LOW : CNTRL1_HIGH;
      end
      CNTRL1_HIGH : begin
        transfer_state_next <= (width_counter != 2'b11) ? CNTRL1_HIGH : CS_HIGH;
      end
      CS_HIGH : begin
        transfer_state_next <= (burst_length == burst_counter) ? IDLE : CNTRL0_LOW;
      end
      default : begin
        transfer_state_next <= IDLE;
      end
    endcase
  end

  // data valid for the register access and m_axis interface

  assign rd_valid_s = (((transfer_state == CNTRL0_HIGH) || (transfer_state == CNTRL1_HIGH)) &&
                       ((rd_req_d == 1'b1) || (rd_conv_d == 1'b1))) ? 1'b1 : 1'b0;

  // FSM output logic

  assign db_o = wr_data;

  always @(posedge clk) begin
    rd_data <= (rd_valid_s & ~rd_valid_d) ? db_i : rd_data;
    rd_valid_d <= rd_valid_s;
    rd_valid <= rd_valid_s & ~rd_valid_d;
  end

  assign adc_valid = rd_valid;
  assign adc_data = rd_data;

  assign cs_n = (transfer_state == IDLE) ? 1'b1 : 1'b0;
  assign db_t = ~wr_req_d;
  assign rd_n = (((transfer_state == CNTRL0_LOW) && ((rd_conv_d == 1'b1) || rd_req_d == 1'b1)) ||
                  (transfer_state == CNTRL1_LOW)) ? 1'b0 : 1'b1;
  assign wr_n = ((transfer_state == CNTRL0_LOW) && (wr_req_d == 1'b1)) ? 1'b0 : 1'b1;

  // sync will be asserted at the first valid data right after the convertion start

  always @(posedge clk) begin
    if (end_of_conv == 1'b1) begin
      adc_sync <= 1'b1;
    end else if (rd_valid == 1'b1) begin
      adc_sync <= 1'b0;
    end
  end

endmodule

