// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2016-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_up_rx_lane #(
  parameter DATA_PATH_WIDTH = 4
) (
  input up_clk,
  input up_reset_synchronizer,

  input up_rreq,
  input [2:0] up_raddr,
  output reg [31:0] up_rdata,

  input [1:0] up_status_cgs_state,
  input [31:0] up_status_err_statistics_cnt,
  input [2:0] up_status_emb_state,
  input [7:0] up_status_lane_frame_align_err_cnt,

  input core_clk,
  input core_reset,

  input core_ilas_config_valid,
  input [1:0] core_ilas_config_addr,
  input [DATA_PATH_WIDTH*8-1:0] core_ilas_config_data,

  input core_status_ifs_ready,
  input [13:0] core_status_latency
);

  wire [1:0] up_status_ctrl_state;

  wire up_status_ifs_ready;
  reg [13:0] up_status_latency = 'h00;

  wire [31:0] up_ilas_rdata;
  wire up_ilas_ready;

  sync_bits #(
    .NUM_OF_BITS(1)
  ) i_cdc_status_ready (
    .in_bits({
      core_status_ifs_ready
    }),
    .out_clk(up_clk),
    .out_resetn(1'b1),
    .out_bits({
      up_status_ifs_ready
    }));

  always @(posedge up_clk) begin
    if (up_reset_synchronizer == 1'b1) begin
      up_status_latency <= 'h00;
    end else begin
      if (up_status_ifs_ready == 1'b1) begin
        up_status_latency <= core_status_latency;
      end
    end
  end

  always @(*) begin
    if (up_raddr[2] == 1'b1) begin
      if (up_ilas_ready == 1'b1) begin
        up_rdata = up_ilas_rdata;
      end else begin
        up_rdata = 'h00;
      end
    end else begin
      case (up_raddr[1:0])
      2'b00: up_rdata = {
        /* 11-31 */ 21'h0, /* Reserved for future use */
        /* 08-10 */ up_status_emb_state,
        /* 06-07 */ 2'h00,
        /*    05 */ up_ilas_ready,
        /*    04 */ up_status_ifs_ready,
        /* 02-03 */ 2'b00, /* Reserved for future extensions of cgs_state */
        /* 00-01 */ up_status_cgs_state
      };
      2'b01: up_rdata = {
        /* 14-31 */ 18'h00, /* Reserved for future use */
        /* 00-13 */ up_status_latency
      };
      2'b10: up_rdata = {
        /* 00-31 */ up_status_err_statistics_cnt
      };
      2'b11: up_rdata = {
        /* 08-31 */ 24'h0, /* Reserved for future use */
        /* 00-07 */ up_status_lane_frame_align_err_cnt
      };
      default: up_rdata = 'h00;
      endcase
    end
  end

  jesd204_up_ilas_mem #(
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
  ) i_ilas_mem (
    .up_clk(up_clk),

    .up_rreq(up_rreq),
    .up_raddr(up_raddr[1:0]),
    .up_rdata(up_ilas_rdata),
    .up_ilas_ready(up_ilas_ready),

    .core_clk(core_clk),
    .core_reset(core_reset),

    .core_ilas_config_valid(core_ilas_config_valid),
    .core_ilas_config_addr(core_ilas_config_addr),
    .core_ilas_config_data(core_ilas_config_data));

endmodule
