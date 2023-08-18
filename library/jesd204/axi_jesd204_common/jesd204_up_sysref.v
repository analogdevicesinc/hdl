// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2016-2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_up_sysref (
  input up_clk,
  input up_reset,

  input core_clk,

  input device_clk,

  input [11:0] up_raddr,
  output reg [31:0] up_rdata,

  input up_wreq,
  input [11:0] up_waddr,
  input [31:0] up_wdata,

  input up_cfg_is_writeable,

  output reg up_cfg_sysref_oneshot,
  output reg [7:0] up_cfg_lmfc_offset,
  output reg up_cfg_sysref_disable,

  input device_event_sysref_alignment_error,
  input device_event_sysref_edge
);

  reg [1:0] up_sysref_status;
  reg [1:0] up_sysref_status_clear;
  wire [1:0] up_sysref_event;

  sync_event #(
    .NUM_OF_EVENTS(2)
  ) i_cdc_sysref_event (
    .in_clk(device_clk),
    .in_event({
      device_event_sysref_alignment_error,
      device_event_sysref_edge
    }),
    .out_clk(up_clk),
    .out_event(up_sysref_event));

  always @(posedge up_clk) begin
    if (up_reset == 1'b1) begin
      up_sysref_status <= 2'b00;
    end else begin
      up_sysref_status <= (up_sysref_status & ~up_sysref_status_clear) | up_sysref_event;
    end
  end

  always @(*) begin
    case (up_raddr)
      /* JESD SYSREF configuraton */
      12'h040: up_rdata = {
        /* 02-31 */ 30'h00, /* Reserved for future use */
        /*    01 */ up_cfg_sysref_oneshot,
        /*    00 */ up_cfg_sysref_disable
      };
      12'h041: up_rdata = {
        /* 10-31 */ 22'h00, /* Reserved for future use */
        /* 02-09 */ up_cfg_lmfc_offset,
        /* 00-01 */ 2'b00 /* data path alignment for cfg_lmfc_offset */
      };
      12'h042: up_rdata = {
        /* 02-31 */ 30'h00,
        /* 00-01 */ up_sysref_status
      };
      default: up_rdata = 32'h00000000;
    endcase
  end

  always @(posedge up_clk) begin
    if (up_reset == 1'b1) begin
      up_cfg_sysref_oneshot <= 1'b0;
      up_cfg_lmfc_offset <= 'h00;
      up_cfg_sysref_disable <= 1'b0;
    end else if (up_wreq == 1'b1 && up_cfg_is_writeable == 1'b1) begin
      case (up_waddr)
        /* JESD SYSREF configuraton */
        12'h040: begin
          up_cfg_sysref_oneshot <= up_wdata[1];
          up_cfg_sysref_disable <= up_wdata[0];
        end
        12'h041: begin
          /* Must be aligned to data path width */
          up_cfg_lmfc_offset <= up_wdata;
        end
      endcase
    end
  end

  always @(*) begin
    if (up_wreq == 1'b1 && up_waddr == 12'h042) begin
      up_sysref_status_clear = up_wdata[1:0];
    end else begin
      up_sysref_status_clear = 2'b00;
    end
  end

endmodule
