// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

/* This module controls the read and write access to the storage unit. It is
* used for both transmit and receive use cases
*/

module data_offload_fsm #(

  parameter TX_OR_RXN_PATH = 0,
  parameter SYNC_EXT_ADD_INTERNAL_CDC = 1
) (
  input                               up_clk,

  // Control interface for storage for m_storage_axis interface
  output    reg                       wr_request_enable = 1'b0,
  output                              wr_request_valid,
  input                               wr_request_ready,
  input                               wr_response_eot,

  // Control interface for storage for s_storage_axis interface
  output    reg                       rd_request_enable = 1'b0,
  output                              rd_request_valid,
  input                               rd_request_ready,
  input                               rd_response_eot,

  input                               rd_ml_valid,
  output                              rd_ml_ready,

  // Data path gating
  output                              wr_ready,
  output                              rd_ready,
  input                               rd_valid,

  // write control interface
  input                               wr_clk,
  input                               wr_resetn_in,
  input                               wr_bypass,

  // read control interface
  input                               rd_clk,
  input                               rd_resetn_in,
  input                               rd_oneshot,   // 0 - CYCLIC; 1 - ONE_SHOT;

  // Synchronization interface - synchronous to the external DMA clock
  input                               init_req,
  input       [ 1:0]                  sync_config,

  input                               sync_external,
  input                               sync_internal,

  // FSM debug
  output      [ 4:0]                  wr_fsm_state_out,
  output      [ 3:0]                  rd_fsm_state_out
);

  // FSM states

  localparam  WR_STATE_IDLE    = 5'b00001;
  localparam  WR_STATE_PRE_WR  = 5'b00010;
  localparam  WR_STATE_SYNC    = 5'b00100;
  localparam  WR_STATE_WR      = 5'b01000;
  localparam  WR_STATE_WAIT_RD = 5'b10000;

  localparam  WR_BIT_IDLE   = 0;
  localparam  WR_BIT_PRE_WR = 1;
  localparam  WR_BIT_SYNC   = 2;
  localparam  WR_BIT_WR     = 3;

  localparam  RD_STATE_IDLE   = 4'b0001;
  localparam  RD_STATE_PRE_RD = 4'b0010;
  localparam  RD_STATE_SYNC   = 4'b0100;
  localparam  RD_STATE_RD     = 4'b1000;

  localparam  RD_BIT_IDLE   = 0;
  localparam  RD_BIT_PRE_RD = 1;
  localparam  RD_BIT_SYNC   = 2;
  localparam  RD_BIT_RD     = 3;

  // Synchronization options

  localparam  AUTOMATIC = 2'b00;
  localparam  HARDWARE = 2'b01;
  localparam  SOFTWARE = 2'b10;

  // internal registers
  reg rd_cyclic_en = 1'b0;

  // internal signals
  wire    wr_sync_external_s;
  wire    wr_init_req_s;
  wire    wr_rd_response_eot;
  wire    rd_sync_external_s;
  wire    rd_last_eot;
  wire    rd_init_req_s;

  reg [4:0] wr_fsm_state = WR_STATE_IDLE;
  reg [4:0] wr_fsm_next_state;
  reg [3:0] rd_fsm_state = RD_STATE_IDLE;
  reg [3:0] rd_fsm_next_state;
  reg [1:0] rd_outstanding = 2'd0;

  assign wr_fsm_state_out = wr_fsm_state;
  assign rd_fsm_state_out = rd_fsm_state;

  always @(*) begin
    wr_fsm_next_state = wr_fsm_state;
    case (wr_fsm_state)
      WR_STATE_IDLE:
        if (wr_init_req_s & ~wr_bypass) begin
          wr_fsm_next_state = WR_STATE_PRE_WR;
        end
      WR_STATE_PRE_WR:
        if (wr_request_ready) begin
          wr_fsm_next_state = TX_OR_RXN_PATH ? WR_STATE_WR : WR_STATE_SYNC;
        end
      WR_STATE_SYNC:
        case (sync_config)
          AUTOMATIC:
            wr_fsm_next_state = WR_STATE_WR;
          HARDWARE:
            if (wr_sync_external_s) begin
              wr_fsm_next_state = WR_STATE_WR;
            end
          SOFTWARE:
            if (sync_internal) begin
              wr_fsm_next_state = WR_STATE_WR;
            end
          default:
            wr_fsm_next_state = WR_STATE_WR;
        endcase
      WR_STATE_WR:
        if (wr_response_eot) begin
          wr_fsm_next_state = WR_STATE_WAIT_RD;
        end
      WR_STATE_WAIT_RD:
        if (wr_rd_response_eot) begin
          wr_fsm_next_state = WR_STATE_IDLE;
        end
      default:
        wr_fsm_next_state = WR_STATE_IDLE;
    endcase
  end

  always @(posedge wr_clk) begin
    if (wr_resetn_in == 1'b0) begin
      wr_fsm_state <= WR_STATE_IDLE;
    end else begin
      wr_fsm_state <= wr_fsm_next_state;
    end
  end

  always @(*) begin
    rd_fsm_next_state = rd_fsm_state;
    case (rd_fsm_state)
      RD_STATE_IDLE:
        if (rd_ml_valid) begin
          rd_fsm_next_state = RD_STATE_PRE_RD;
        end
      RD_STATE_PRE_RD:
        if (rd_request_ready) begin
          rd_fsm_next_state = TX_OR_RXN_PATH ? RD_STATE_SYNC : RD_STATE_RD;
        end
      RD_STATE_SYNC:
      if (rd_valid) // Wait until storage is valid
        case (sync_config)
          AUTOMATIC:
            rd_fsm_next_state = RD_STATE_RD;
          HARDWARE:
            if (rd_sync_external_s) begin
              rd_fsm_next_state = RD_STATE_RD;
            end
          SOFTWARE:
            if (sync_internal) begin
              rd_fsm_next_state = RD_STATE_RD;
            end
          default:
            rd_fsm_next_state = RD_STATE_RD;
        endcase
      RD_STATE_RD:
        if (rd_last_eot) begin
          rd_fsm_next_state = (rd_cyclic_en == 1'b0)      ? RD_STATE_IDLE :
            (TX_OR_RXN_PATH & (sync_config != AUTOMATIC)) ? RD_STATE_SYNC :
                                                            RD_STATE_RD;
        end
      default:
        rd_fsm_next_state = RD_STATE_IDLE;
    endcase
  end

  always @(posedge rd_clk) begin
    if (rd_resetn_in == 1'b0) begin
      rd_fsm_state <= RD_STATE_IDLE;
    end else begin
      rd_fsm_state <= rd_fsm_next_state;
    end
  end

  always @(posedge rd_clk) begin
    if (rd_resetn_in == 1'b0)
      rd_outstanding <= 2'b0;
    else if (rd_request_ready & rd_request_valid & ~rd_response_eot)
      rd_outstanding <= rd_outstanding + 2'd1;
    else if (~(rd_request_ready & rd_request_valid) & (rd_response_eot & rd_fsm_state[RD_BIT_RD]))
      rd_outstanding <= rd_outstanding - 2'd1;
  end
  assign rd_last_eot = (rd_outstanding == 1) & (rd_response_eot & rd_fsm_state[RD_BIT_RD]) & !(rd_request_ready & rd_request_valid);

  always @(posedge rd_clk) begin
    if (rd_init_req_s) begin
      rd_cyclic_en <= 1'b0;
    end else if (rd_fsm_state[RD_BIT_PRE_RD]) begin
      rd_cyclic_en <= ~rd_oneshot;
    end
  end

  assign rd_ready = rd_fsm_state[RD_BIT_RD];
  assign wr_ready = wr_fsm_state[WR_BIT_WR];

  assign wr_request_valid = wr_fsm_state[WR_BIT_PRE_WR];
  assign rd_request_valid = rd_fsm_state[RD_BIT_PRE_RD] | rd_cyclic_en;

  always @(posedge rd_clk) begin
    if (rd_resetn_in == 1'b0 || (~rd_init_req_s & ~TX_OR_RXN_PATH[0]))
      rd_request_enable <= 1'b0;
    else
      rd_request_enable <= 1'b1;
  end

  always @(posedge wr_clk) begin
    if (wr_resetn_in == 1'b0)
      wr_request_enable <= 1'b0;
    else
      wr_request_enable <= 1'b1;
  end

  assign rd_ml_ready = rd_fsm_state[RD_BIT_IDLE];

  // CDC circuits
  sync_event #(
    .NUM_OF_EVENTS (1),
    .ASYNC_CLK (1)
  ) i_wr_empty_sync (
    .in_clk (rd_clk),
    .in_event (rd_last_eot && rd_fsm_state[RD_BIT_RD]),
    .out_clk (wr_clk),
    .out_event (wr_rd_response_eot));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (TX_OR_RXN_PATH[0])
  ) i_rd_init_req_sync (
    .in_bits (init_req),
    .out_clk (rd_clk),
    .out_resetn (1'b1),
    .out_bits (rd_init_req_s));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (~TX_OR_RXN_PATH[0])
  ) i_wr_init_req_sync (
    .in_bits (init_req),
    .out_clk (wr_clk),
    .out_resetn (1'b1),
    .out_bits (wr_init_req_s));

  // When SYNC_EXT_ADD_INTERNAL_CDC is deasserted, one of these signals will end
  // up being synchronized to the "wrong" clock domain. This shouldn't matter
  // because the incorrectly synchronized signal is guarded by a synthesis constant.
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (SYNC_EXT_ADD_INTERNAL_CDC)
  ) i_sync_wr_sync (
    .in_bits ({ sync_external }),
    .out_clk (wr_clk),
    .out_resetn (1'b1),
    .out_bits ({wr_sync_external_s}));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (SYNC_EXT_ADD_INTERNAL_CDC)
  ) i_sync_rd_sync (
    .in_bits ({ sync_external }),
    .out_clk (rd_clk),
    .out_resetn (1'b1),
    .out_bits ({ rd_sync_external_s }));

endmodule
