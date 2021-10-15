// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
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

/* This module controls the read and write access to the storage unit. It is
* used for both transmit and receive use cases
*/

module data_offload_fsm #(

  parameter TX_OR_RXN_PATH = 0,
  parameter WR_ADDRESS_WIDTH = 4,
  parameter WR_DATA_WIDTH = 128,
  parameter RD_ADDRESS_WIDTH = 4,
  parameter RD_DATA_WIDTH = 128,
  parameter SYNC_EXT_ADD_INTERNAL_CDC = 1) (

  input                               up_clk,

  // write control interface
  input                               wr_clk,
  input                               wr_resetn_in,
  output  reg                         wr_resetn_out,
  input                               wr_valid_in,
  output                              wr_valid_out,
  output                              wr_ready,
  output  reg [WR_ADDRESS_WIDTH-1:0]  wr_addr,
  input                               wr_last,
  input       [WR_DATA_WIDTH/8-1:0]   wr_tkeep,

  // read control interface
  input                               rd_clk,
  input                               rd_resetn_in,
  output  reg                         rd_resetn_out,
  input                               rd_ready,
  output  reg                         rd_valid = 1'b0,
  output  reg [RD_ADDRESS_WIDTH-1:0]  rd_addr,
  output                              rd_last,
  output  reg [RD_DATA_WIDTH/8-1:0]   rd_tkeep,
  input                               rd_oneshot,   // 0 - CYCLIC; 1 - ONE_SHOT;

  // Synchronization interface - synchronous to the device clock (ADC or DAC)
  input                               init_req,
  output                              init_ack,
  input       [ 1:0]                  sync_config,

  input                               sync_external,
  input                               sync_internal,

  // FSM debug
  output      [ 1:0]                  wr_fsm_state,
  output      [ 1:0]                  rd_fsm_state,
  output  reg [63:0]                  sample_count

  );

  // FSM states

  localparam  WR_IDLE = 2'b00;
  localparam  WR_SYNC = 2'b01;
  localparam  WR_WRITE_TO_MEM = 2'b11;
  localparam  WR_WAIT_TO_END = 2'b10;

  localparam  RD_IDLE = 2'b00;
  localparam  RD_SYNC = 2'b01;
  localparam  RD_READ_FROM_MEM = 2'b11;

  // Synchronization options

  localparam  AUTOMATIC = 2'b00;
  localparam  HARDWARE = 2'b01;
  localparam  SOFTWARE = 2'b10;

  // helper parameters for last address, tkeep conversion
  localparam  LSB = (WR_ADDRESS_WIDTH > RD_ADDRESS_WIDTH) ? WR_ADDRESS_WIDTH - RD_ADDRESS_WIDTH :
                                                            RD_ADDRESS_WIDTH - WR_ADDRESS_WIDTH;
  localparam  POW2_LSB = 1 << LSB;

  // internal registers

  reg [WR_ADDRESS_WIDTH-1:0]  wr_last_addr;
  reg [WR_DATA_WIDTH/8-1:0]   wr_last_keep;

  reg [RD_DATA_WIDTH/8-1:0]   rd_tkeep_last;
  reg [RD_ADDRESS_WIDTH-1:0]  rd_last_addr;
  reg                         rd_isempty;
  reg                         rd_init_req_d;
  reg                         wr_init_req_d;
  reg                         wr_ready_d;

  // internal signals

  wire                        wr_almost_full;
  wire                        wr_init_req_s;
  wire                        wr_init_req_pos_s;
  wire                        wr_init_ack_s;
  wire                        rd_isfull_s;
  wire                        wr_isempty_s;
  wire                        rd_empty_s;
  wire                        rd_wr_last_s;
  wire                        rd_init_req_s;
  wire                        rd_init_req_neg_s;
  wire                        rd_init_ack_s;
  wire [WR_ADDRESS_WIDTH-1:0] rd_wr_last_addr_s;
  wire [WR_DATA_WIDTH/8-1:0]  rd_wr_last_tkeep_s;
  wire                        wr_sync_external_s;
  wire                        rd_sync_external_s;
  wire                        wr_oneshot;

  (* DONT_TOUCH = "TRUE" *) reg [1:0] wr_fsm_state = 2'b00;
  (* DONT_TOUCH = "TRUE" *) reg [1:0] rd_fsm_state = 2'b00;

  // Mealy state machine for write control
  always @(posedge wr_clk) begin
    if (wr_resetn_in == 1'b0) begin
      wr_fsm_state <= WR_IDLE;
    end else begin
      case (wr_fsm_state)

          WR_IDLE: begin
            if (wr_init_req_s) begin
              wr_fsm_state <= (TX_OR_RXN_PATH) ? WR_WRITE_TO_MEM : WR_SYNC;
            end else begin
              wr_fsm_state <= WR_IDLE;
            end
          end

          WR_SYNC: begin
            // do not lock the FSM if something goes wrong
            if (TX_OR_RXN_PATH) begin
              wr_fsm_state <= WR_WRITE_TO_MEM;
            end else begin // SOURCE_IS_BACK_END
              case (sync_config)
                AUTOMATIC: begin
                  wr_fsm_state <= WR_WRITE_TO_MEM;
                end
                HARDWARE: begin
                  if (wr_sync_external_s) begin
                    wr_fsm_state <= WR_WRITE_TO_MEM;
                  end
                end
                SOFTWARE: begin
                  if (sync_internal) begin
                    wr_fsm_state <= WR_WRITE_TO_MEM;
                  end
                end
                default: begin
                  wr_fsm_state <= WR_WRITE_TO_MEM;
                end
              endcase
            end
          end

          WR_WRITE_TO_MEM: begin
            if ((wr_full || wr_last) && wr_valid_out) begin
              wr_fsm_state <= WR_WAIT_TO_END;
            end else begin
              wr_fsm_state <= WR_WRITE_TO_MEM;
            end
          end

          WR_WAIT_TO_END: begin
            if (wr_isempty_s && (wr_oneshot || wr_init_req_s)) begin
              wr_fsm_state <= WR_IDLE;
            end else begin
              wr_fsm_state <= WR_WAIT_TO_END;
            end
          end

          default: wr_fsm_state <= WR_IDLE;
      endcase

    end
  end

  // the initialization interface (init_req) is edge sensitive
  always @(posedge wr_clk) begin
    wr_init_req_d <= wr_init_req_s;
  end
  assign wr_init_req_pos_s = ~wr_init_req_d & wr_init_req_s;

  // status bits
  assign wr_almost_full = (wr_addr == {{(WR_ADDRESS_WIDTH-1){1'b1}}, 1'b0}) ? 1'b1 : 1'b0;
  assign wr_full = &wr_addr;

  // generate INIT acknowledge signal in WRITE domain (in case of ADCs)
  assign wr_init_ack_s = (wr_fsm_state == WR_SYNC) ? 1'b1 : 1'b0;

  // write address generation
  always @(posedge wr_clk) begin
    if ((wr_resetn_in == 1'b0) || (wr_fsm_state == WR_IDLE)) begin
      wr_addr <= 'b0;
    end else begin
      if (wr_valid_out) begin
        wr_addr <=  wr_addr + 1'b1;
      end
    end
  end

  // reset the storage unit's FMS before each transfer
  always @(posedge wr_clk) begin
    if ((wr_resetn_in == 1'b0) || (wr_fsm_state == WR_IDLE)) begin
      wr_resetn_out <= 1'b0;
    end else begin
      wr_resetn_out <= 1'b1;
    end
  end

  always @(posedge wr_clk) begin
    if (wr_resetn_in == 1'b0) begin
      wr_last_addr <= {WR_ADDRESS_WIDTH{1'b1}};
    end else begin
      wr_last_addr <= (wr_valid_out) ? wr_addr : wr_last_addr;
    end
  end

  always @(posedge wr_clk) begin
    if (wr_resetn_in == 1'b0) begin
      wr_last_keep <= {WR_DATA_WIDTH/8{1'b1}};
    end else begin
      if (wr_last) begin
        // if the SOURCE is at back-end, the interface is FIFO, set the tkeep
        // to its default
        wr_last_keep <= (TX_OR_RXN_PATH) ? wr_tkeep : {WR_DATA_WIDTH/8{1'b1}};
      end
    end
  end

  always @(posedge wr_clk) begin
    wr_ready_d <= wr_ready && !(wr_valid_in && wr_last);
  end

  // flush out the DMA if the transfer is bigger than the storage size
  assign wr_ready = ((wr_fsm_state == WR_WRITE_TO_MEM) ||
                     (TX_OR_RXN_PATH && ((wr_fsm_state == WR_WAIT_TO_END) && wr_ready_d))) ? 1'b1 : 1'b0;

  // write control
  assign wr_valid_out = (wr_fsm_state == WR_WRITE_TO_MEM) & wr_valid_in;

  // sample counter for debug purposes, the value of the counter resets at
  // every new incoming request

  always @(posedge wr_clk) begin
    if (wr_init_req_pos_s == 1'b1) begin
      sample_count <= 64'b0;
    end else begin
      if (wr_ready && wr_valid_in) begin
        sample_count <= sample_count + 1'b1;
      end
    end
  end

  // Mealy state machine for read control
  always @(posedge rd_clk) begin
    if (rd_resetn_in == 1'b0) begin
      rd_fsm_state <= RD_IDLE;
    end else begin
      case (rd_fsm_state)

        RD_IDLE: begin
          if (((!TX_OR_RXN_PATH) & rd_isfull_s) || (rd_wr_last_s)) begin
            if (TX_OR_RXN_PATH) begin
              rd_fsm_state <= RD_SYNC;
            end else begin
              rd_fsm_state <= RD_READ_FROM_MEM;
            end
          end else begin
            rd_fsm_state <= RD_IDLE;
          end
        end

        RD_SYNC : begin
          // do not lock the FSM if something goes wrong
          if (!TX_OR_RXN_PATH) begin
            rd_fsm_state <= RD_READ_FROM_MEM;
          end else begin // TX_OR_RXN_PATH
            case (sync_config)
              AUTOMATIC: begin
                rd_fsm_state <= RD_READ_FROM_MEM;
              end
              HARDWARE: begin
                if (rd_sync_external_s) begin
                  rd_fsm_state <= RD_READ_FROM_MEM;
                end
              end
              SOFTWARE: begin
                if (sync_internal) begin
                  rd_fsm_state <= RD_READ_FROM_MEM;
                end
              end
              default: begin
                rd_fsm_state <= RD_READ_FROM_MEM;
              end
            endcase
          end
        end

        // read until empty or next init_req
        RD_READ_FROM_MEM : begin
          if (rd_empty_s && rd_ready) begin
            if (rd_init_req_s || (rd_oneshot && rd_last)) begin
              rd_fsm_state <= RD_IDLE;
            end else if (TX_OR_RXN_PATH && sync_config && (!rd_oneshot)) begin
              rd_fsm_state <= RD_SYNC;
            end else begin
              rd_fsm_state <= RD_READ_FROM_MEM;
            end
          end else begin
            rd_fsm_state <= RD_READ_FROM_MEM;
          end
        end

        default : rd_fsm_state <= RD_IDLE;
      endcase
    end
  end

  // the initialization interface (init_req) is edge sensitive
  // TODO: This should be redefined! Will work only of init_req is active
  // during the whole DMA transfer (use xfer_req for driving init_req)
  always @(posedge rd_clk) begin
    rd_init_req_d <= rd_init_req_s;
  end
  assign rd_init_req_neg_s = rd_init_req_d & ~rd_init_req_s;

  // generate INIT acknowledge signal in WRITE domain (in case of ADCs)
  assign rd_init_ack_s = (rd_fsm_state == RD_SYNC) ? 1'b1 : 1'b0;

  // Reset the storage unit's FSM before each transfer
  always @(posedge rd_clk) begin
    if ((rd_resetn_in == 1'b0) || (rd_fsm_state == RD_IDLE)) begin
      rd_resetn_out <= 1'b0;
    end else begin
      rd_resetn_out <= 1'b1;
    end
  end

  // read address generation
  always @(posedge rd_clk) begin
    if (rd_fsm_state != RD_READ_FROM_MEM) begin
      rd_addr <= 'b0;
    end else begin
      if (rd_valid) begin
        if (rd_oneshot)
          rd_addr <= (rd_last_addr == rd_addr) ? rd_addr : rd_addr + 1'b1;
        else
          rd_addr <= (rd_last_addr == rd_addr) ? {RD_ADDRESS_WIDTH{1'b0}} : rd_addr + 1'b1;
      end
    end
  end

  assign rd_empty_s = (rd_addr == rd_last_addr) ? 1'b1 : 1'b0;
  assign rd_last = rd_oneshot & rd_empty_s;
  always @(posedge rd_clk) begin
    if (rd_resetn_in == 1'b0) begin
      rd_isempty <= 1'b0;
    end else begin
      rd_isempty <= rd_empty_s;
    end
  end

  always @(posedge rd_clk) begin
    if (rd_resetn_in == 1'b0) begin
      rd_valid <= 1'b0;
    end else begin
      if ((rd_ready) && (rd_fsm_state == RD_READ_FROM_MEM) && !(rd_valid && rd_last && rd_oneshot)) begin
        rd_valid <= 1'b1;
      end else begin
        rd_valid <= 1'b0;
      end
    end
  end

  // CDC circuits

  sync_event #(
    .NUM_OF_EVENTS (1),
    .ASYNC_CLK (1))
  i_wr_empty_sync (
    .in_clk (rd_clk),
    .in_event (rd_isempty),
    .out_clk (wr_clk),
    .out_event (wr_isempty_s)
  );

  sync_event #(
    .NUM_OF_EVENTS (1),
    .ASYNC_CLK(1))
  i_rd_full_sync (
    .in_clk (wr_clk),
    .in_event (wr_almost_full),
    .out_clk (rd_clk),
    .out_event (rd_isfull_s)
  );

  sync_event #(
    .NUM_OF_EVENTS (1),
    .ASYNC_CLK (1))
  i_rd_wr_last_sync (
    .in_clk (wr_clk),
    .in_event ((wr_last & wr_valid_in)),
    .out_clk (rd_clk),
    .out_event (rd_wr_last_s)
  );

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1))
  i_wr_oneshot_sync (
    .in_bits (rd_oneshot),
    .out_clk (wr_clk),
    .out_resetn (1'b1),
    .out_bits (wr_oneshot)
  );


  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1))
  i_rd_init_req_sync (
    .in_bits (init_req),
    .out_clk (rd_clk),
    .out_resetn (1'b1),
    .out_bits (rd_init_req_s)
  );

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1))
  i_wr_init_req_sync (
    .in_bits (init_req),
    .out_clk (wr_clk),
    .out_resetn (1'b1),
    .out_bits (wr_init_req_s)
  );

  generate if (TX_OR_RXN_PATH == 0) begin : adc_init_sync

    sync_event #(
      .NUM_OF_EVENTS (1),
      .ASYNC_CLK (1))
    i_rd_init_ack_sync (
      .in_clk (wr_clk),
      .in_event (wr_init_ack_s),
      .out_clk (rd_clk),
      .out_event (init_ack)
    );

  end else begin : dac_init_sync

    sync_event #(
      .NUM_OF_EVENTS (1),
      .ASYNC_CLK (1))
    i_wr_init_ack_sync (
      .in_clk (rd_clk),
      .in_event (rd_init_ack_s),
      .out_clk (wr_clk),
      .out_event (init_ack)
    );

  end
  endgenerate

  // convert write address and last/keep to read address and last/keep

  sync_bits #(
    .NUM_OF_BITS (WR_ADDRESS_WIDTH),
    .ASYNC_CLK (1))
  i_rd_last_address (
    .in_bits (wr_last_addr),
    .out_clk (rd_clk),
    .out_resetn (1'b1),
    .out_bits (rd_wr_last_addr_s)
  );

  sync_bits #(
    .NUM_OF_BITS (WR_DATA_WIDTH/8),
    .ASYNC_CLK (1))
  i_rd_last_keep (
    .in_bits (wr_last_keep),
    .out_clk (rd_clk),
    .out_resetn (1'b1),
    .out_bits (rd_wr_last_tkeep_s)
  );

  // upsizing - WR_DATA_WIDTH < RD_DATA_WIDTH
  generate if (WR_ADDRESS_WIDTH > RD_ADDRESS_WIDTH) begin

    always @(posedge rd_clk) begin
      rd_last_addr <= rd_wr_last_addr_s[WR_ADDRESS_WIDTH-1 : LSB];
    end

    // the read tkeep will be wider than the write tkeep, and its value
    // depends on when the write tlast was asserted
    always @(posedge rd_clk) begin :tkeep_gen
      integer i;
      for (i = 0; i < POW2_LSB; i = i + 1) begin : a_tkeep
        if (rd_last_addr[LSB-1:0] < i)
          rd_tkeep_last[(i+1)*WR_DATA_WIDTH/8-1 -: WR_DATA_WIDTH/8] <= {WR_DATA_WIDTH/8{1'b0}};
        else
          rd_tkeep_last[(i+1)*WR_DATA_WIDTH/8-1 -: WR_DATA_WIDTH/8] <= (i == 0) ? rd_wr_last_tkeep_s : {WR_DATA_WIDTH/8{1'b1}};
      end
    end

  end else if (WR_ADDRESS_WIDTH < RD_ADDRESS_WIDTH) begin // downsizing - WR_DATA_WIDTH > RD_DATA_WIDTH or equal

    always @(posedge rd_clk) begin
      rd_tkeep_last <= rd_wr_last_tkeep_s[RD_DATA_WIDTH/8-1 : 0];
      rd_last_addr <= {rd_wr_last_addr_s, {LSB{1'b1}}};
    end

  end else begin

    always @(posedge rd_clk) begin
      rd_tkeep_last <= rd_wr_last_tkeep_s;
      rd_last_addr <= rd_wr_last_addr_s;
    end

  end
  endgenerate

  always @(posedge rd_clk) begin
    if (rd_fsm_state == RD_IDLE) begin
      rd_tkeep <= {(RD_DATA_WIDTH/8){1'b1}};
    end else begin
      if (rd_empty_s && rd_ready)
        rd_tkeep <= rd_tkeep_last;
      else if (rd_ready)
        rd_tkeep <= {(RD_DATA_WIDTH/8){1'b1}};
      end
  end

  // When SYNC_EXT_ADD_INTERNAL_CDC is deasserted, one of these signals will end
  // up being synchronized to the "wrong" clock domain. This shouldn't matter
  // because the incorrectly synchronized signal is guarded by a synthesis constant.
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (SYNC_EXT_ADD_INTERNAL_CDC))
  i_sync_wr_sync (
    .in_bits ({ sync_external }),
    .out_clk (wr_clk),
    .out_resetn (1'b1),
    .out_bits ({ wr_sync_external_s })
  );

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (SYNC_EXT_ADD_INTERNAL_CDC))
  i_sync_rd_sync (
    .in_bits ({ sync_external }),
    .out_clk (rd_clk),
    .out_resetn (1'b1),
    .out_bits ({ rd_sync_external_s })
  );

endmodule

