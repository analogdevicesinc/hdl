// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

module data_offload_regmap #(

  parameter ID = 0,
  parameter [ 0:0] MEM_TYPE = 1'b0,
  parameter MEM_SIZE_LOG2 = 10,
  parameter TX_OR_RXN_PATH = 0,
  parameter AUTO_BRINGUP = 0,
  parameter HAS_BYPASS = 1
) (

  // microprocessor interface
  input                   up_clk,
  input                   up_rstn,

  input                   up_rreq,
  output reg              up_rack,
  input       [13:0]      up_raddr,
  output reg  [31:0]      up_rdata,
  input                   up_wreq,
  output reg              up_wack,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,

  // source clock domain
  input                   src_clk,

  // destination clock domain
  input                   dst_clk,

  // resets for all clock domains
  output reg              src_sw_resetn,
  output reg              dst_sw_resetn,

  // status bit from the memory controller
  input                   ddr_calib_done,

  // bypass control
  output                  src_bypass,
  output                  dst_bypass,
  output                  oneshot,

  // synchronization
  output                  sync,
  output      [ 1:0]      sync_config,

  output      [MEM_SIZE_LOG2-1:0] src_transfer_length,
  output      [MEM_SIZE_LOG2-1:0] dst_transfer_length,

  // FSM control and status
  input       [ 4:0]      src_fsm_status,
  input       [ 3:0]      dst_fsm_status,

  input                   src_overflow,
  input                   dst_underflow
);

  // local parameters

  localparam [31:0] CORE_VERSION = 32'h00010061;  // 1.00.a
  localparam [31:0] CORE_MAGIC = 32'h44414F46;    // DAOF

  localparam [33:0] MEM_SIZE = 1 << MEM_SIZE_LOG2;

  // internal registers

  reg   [31:0]  up_scratch = 'd0;
  reg           up_sw_resetn = 'd0;
  reg           up_bypass = 'd0;
  reg           up_sync = 'd0;
  reg   [ 1:0]  up_sync_config = 'd0;
  reg           up_oneshot = 1'b0;
  reg   [MEM_SIZE_LOG2-1:0]  up_transfer_length = 'd0;
  reg           up_src_overflow = 1'b0;
  reg           up_dst_underflow = 1'b0;

  //internal signals

  wire          up_ddr_calib_done_s;
  wire  [ 4:0]  up_wr_fsm_status_s;
  wire  [ 3:0]  up_rd_fsm_status_s;
  wire          src_sw_resetn_s;
  wire          dst_sw_resetn_s;
  wire  [33:0]  src_transfer_length_s;
  wire          up_src_overflow_set_s;
  wire          up_dst_underflow_set_s;

  // write interface
  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_wack <= up_wreq;
      up_scratch <= 'd0;
      up_sw_resetn <= AUTO_BRINGUP;
      up_oneshot <= ~TX_OR_RXN_PATH;
      up_bypass <= 'd0;
      up_sync <= 'd0;
      up_sync_config <= 'd0;
      up_transfer_length <= {MEM_SIZE_LOG2{1'b1}};
      up_src_overflow <= 1'b0;
      up_dst_underflow <= 1'b0;
    end else begin
      up_wack <= up_wreq;
      /* Scratch Register */
      if ((up_wreq == 1'b1) && (up_waddr[13:0] == 14'h02)) begin
        up_scratch <= up_wdata;
      end
      /* Transfer Length Register */
      if ((up_wreq == 1'b1) && (up_waddr[13:0] == 14'h07)) begin
        up_transfer_length <= {up_wdata[MEM_SIZE_LOG2-7:0], {6{1'b1}}};
      end
      /* Memory interface status register */
      if ((up_wreq == 1'b1) && (up_waddr[13:0] == 14'h20) && up_wdata[4]) begin
        up_src_overflow <= 1'b0;
      end else if (up_src_overflow_set_s) begin
        up_src_overflow <= 1'b1;
      end
      if ((up_wreq == 1'b1) && (up_waddr[13:0] == 14'h20) && up_wdata[5]) begin
        up_dst_underflow <= 1'b0;
      end else if (up_dst_underflow_set_s) begin
        up_dst_underflow <= 1'b1;
      end
      /* Reset Offload Register */
      if ((up_wreq == 1'b1) && (up_waddr[13:0] == 14'h21)) begin
        up_sw_resetn <= up_wdata[0];
      end
      /* Control Register */
      if ((up_wreq == 1'b1) && (up_waddr[13:0] == 14'h22)) begin
        up_oneshot <= up_wdata[1];
        up_bypass <= up_wdata[0] & HAS_BYPASS;
      end
      /* SYNC Offload Register - self cleared, one pulse signal */
      if ((up_wreq == 1'b1) && (up_waddr[13:0] == 14'h40)) begin
        up_sync <= up_wdata[0];
      end else begin
        up_sync <= 1'b0;
      end
      /* SYNC RX Configuration Register */
      if ((up_wreq == 1'b1) && (up_waddr[13:0] == 14'h41)) begin
        up_sync_config <= up_wdata[1:0];
      end
    end
  end

  //read interface for common registers
  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rack <= 1'b0;
      up_rdata <= 32'b0;
    end else begin
      up_rack <= up_rreq;
      case(up_raddr)

        /* Version Register */
        14'h000:  up_rdata <= {
                          CORE_VERSION[31:16], /* MAJOR */
                          CORE_VERSION[15: 8], /* MINOR */
                          CORE_VERSION[ 7: 0]  /* PATCH */
        };
        /* Peripheral ID Register */
        14'h001:  up_rdata <= ID;

        /* Peripheral ID Register */
        14'h002:  up_rdata <= up_scratch;

        /* Identification Register */
        14'h003:  up_rdata <= CORE_MAGIC;

        /* Configuration Register */
        14'h004:  up_rdata <= {
                          29'b0,
           /*   2   */    HAS_BYPASS[0],
           /*   1   */    TX_OR_RXN_PATH[0],
           /*   0   */    MEM_TYPE[0]
        };
        /* Configuration Storage Unit Size LSB Register */
        14'h005:  up_rdata <= MEM_SIZE[31:0];

        /* Configuration Storage Unit Size MSB Register */
        14'h006:  up_rdata <= {
                          30'b0,
           /* 00-01 */    MEM_SIZE[33:32]
        };

        /* Configuration data transfer length */
        14'h007:  up_rdata <= {
                          {32-(MEM_SIZE_LOG2-6){1'b0}},
                          up_transfer_length[MEM_SIZE_LOG2-1:6]
        };

        /* 0x08-0x1f reserved for future use */

        /* Memory Physical Interface Status */
        14'h020:  up_rdata <= {
                          26'b0,
                          up_dst_underflow,
                          up_src_overflow,
                          3'b0,
           /*   0   */    up_ddr_calib_done_s
        };
        /* Reset Offload Register */
        14'h021:  up_rdata <= {
                          31'b0,
           /*   0   */    up_sw_resetn
        };
        /* Control Register */
        14'h022:  up_rdata <= {
                          30'b0,
           /*   1   */    up_oneshot,
           /*   0   */    up_bypass
        };
        /* 0x24-0x3f reserved for future use */

        /* SYNC Offload Register */
        14'h040:  up_rdata <= {
                          31'b0,
           /*   0   */    up_sync
        };
        /* SYNC RX Configuration Register */
        14'h041:  up_rdata <= {
                          30'b0,
           /* 00-01 */    up_sync_config
        };
        /* 0x42-0x7f reserved for future use */

        /* FMS Debug Register */
        14'h080:  up_rdata <= {
                          20'b0,
           /* 11-08 */    up_rd_fsm_status_s,
                          3'b0,
           /* 04-00 */    up_wr_fsm_status_s
        };

        default: up_rdata <= 32'h00000000;
      endcase
    end
  end /* read interface */

  // Clock Domain Crossing Logic for reset, control and status signals

  sync_data #(
    .NUM_OF_BITS (4),
    .ASYNC_CLK (1)
  ) i_dst_fsm_status (
    .in_clk (dst_clk),
    .in_data (dst_fsm_status),
    .out_clk (up_clk),
    .out_data (up_rd_fsm_status_s));

  sync_data #(
    .NUM_OF_BITS (5),
    .ASYNC_CLK (1)
  ) i_src_fsm_status (
    .in_clk (src_clk),
    .in_data (src_fsm_status),
    .out_clk (up_clk),
    .out_data (up_wr_fsm_status_s));

  generate
  if (TX_OR_RXN_PATH) begin : sync_tx_path

    sync_data #(
      .NUM_OF_BITS (3),
      .ASYNC_CLK (1)
    ) i_sync_xfer_control (
      .in_clk (up_clk),
      .in_data ({up_sync_config,
                 up_sync}),
      .out_clk (dst_clk),
      .out_data ({sync_config,
                  sync}));

  end else begin : sync_rx_path

    sync_data #(
      .NUM_OF_BITS (3),
      .ASYNC_CLK (1)
    ) i_sync_xfer_control (
      .in_clk (up_clk),
      .in_data ({up_sync_config,
                 up_sync}),
      .out_clk (src_clk),
      .out_data ({sync_config,
                  sync}));

  end
  endgenerate

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_src_xfer_control (
    .in_bits ({ up_sw_resetn, up_bypass }),
    .out_clk (src_clk),
    .out_resetn (1'b1),
    .out_bits ({ src_sw_resetn_s, src_bypass }));

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_dst_xfer_control (
    .in_bits ({ up_sw_resetn, up_bypass }),
    .out_clk (dst_clk),
    .out_resetn (1'b1),
    .out_bits ({ dst_sw_resetn_s, dst_bypass }));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_ddr_calib_done_sync (
    .in_bits (ddr_calib_done),
    .out_clk (up_clk),
    .out_resetn (1'b1),
    .out_bits (up_ddr_calib_done_s));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_dst_oneshot_sync (
    .in_bits (up_oneshot),
    .out_clk (dst_clk),
    .out_resetn (1'b1),
    .out_bits (oneshot));

  sync_data #(
    .NUM_OF_BITS (MEM_SIZE_LOG2),
    .ASYNC_CLK (1)
  ) i_sync_src_transfer_length (
    .in_clk (up_clk),
    .in_data (up_transfer_length),
    .out_clk (src_clk),
    .out_data (src_transfer_length));

  sync_data #(
    .NUM_OF_BITS (MEM_SIZE_LOG2),
    .ASYNC_CLK (1)
  ) i_sync_dst_transfer_length (
    .in_clk (up_clk),
    .in_data (up_transfer_length),
    .out_clk (dst_clk),
    .out_data (dst_transfer_length));

  always @(posedge src_clk) begin
    src_sw_resetn <= src_sw_resetn_s;
  end

  always @(posedge dst_clk) begin
    dst_sw_resetn <= dst_sw_resetn_s;
  end

  generate if (TX_OR_RXN_PATH == 0) begin
    sync_event #(
      .NUM_OF_EVENTS (1),
      .ASYNC_CLK (1)
    ) i_wr_overflow_sync (
      .in_clk (src_clk),
      .in_event (src_overflow),
      .out_clk (up_clk),
      .out_event (up_src_overflow_set_s));
    assign up_dst_underflow_set_s = 1'b0;
  end else begin
    sync_event #(
      .NUM_OF_EVENTS (1),
      .ASYNC_CLK (1)
    ) i_rd_underflow_sync (
      .in_clk (dst_clk),
      .in_event (dst_underflow),
      .out_clk (up_clk),
      .out_event (up_dst_underflow_set_s));
    assign up_src_overflow_set_s = 1'b0;
  end
  endgenerate

endmodule
