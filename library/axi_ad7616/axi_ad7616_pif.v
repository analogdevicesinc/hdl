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

module axi_ad7616_pif #(

  parameter UP_ADDRESS_WIDTH = 14
) (

  // physical interface

  output                  cs_n,
  output      [15:0]      db_o,
  input       [15:0]      db_i,
  output                  db_t,
  output                  rd_n,
  output                  wr_n,

  // FIFO interface

  output      [15:0]      adc_data,
  output                  adc_valid,
  output  reg             adc_sync,

  // end of convertion

  input                   end_of_conv,
  input       [ 4:0]      burst_length,

  // register access

  input                   clk,
  input                   rstn,
  input                   rd_req,
  input                   wr_req,
  input       [15:0]      wr_data,
  output  reg [15:0]      rd_data,
  output  reg             rd_valid
);

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

  reg                             rd_valid_d = 1'h0;

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
