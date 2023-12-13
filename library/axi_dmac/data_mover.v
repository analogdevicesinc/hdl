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

module data_mover #(

  parameter ID_WIDTH = 3,
  parameter DATA_WIDTH = 64,
  parameter BEATS_PER_BURST_WIDTH = 4,
  parameter ALLOW_ABORT = 0
) (
  input clk,
  input resetn,

  input [ID_WIDTH-1:0] request_id,
  output [ID_WIDTH-1:0] response_id,
  input eot,

  output rewind_req_valid,
  input rewind_req_ready,
  output [ID_WIDTH+3-1:0] rewind_req_data,

  output reg bl_valid = 'b0,
  input bl_ready,
  output reg [BEATS_PER_BURST_WIDTH-1:0] measured_last_burst_length,

  output block_descr_to_dst,

  output [ID_WIDTH-1:0] source_id,
  output source_eot,

  output xfer_req,

  output s_axi_ready,
  input s_axi_valid,
  input [DATA_WIDTH-1:0] s_axi_data,
  input s_axi_last,
  input s_axi_sync,

  output m_axi_valid,
  output [DATA_WIDTH-1:0] m_axi_data,
  output m_axi_last,
  output m_axi_partial_burst,

  input req_valid,
  output req_ready,
  input [BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,
  input req_sync_transfer_start,
  input req_xlast
);

  localparam BEAT_COUNTER_MAX = {BEATS_PER_BURST_WIDTH{1'b1}};

`include "inc_id.vh"

  reg [BEATS_PER_BURST_WIDTH-1:0] last_burst_length = 'h00;
  reg [BEATS_PER_BURST_WIDTH-1:0] beat_counter = 'h00;
  reg [BEATS_PER_BURST_WIDTH-1:0] beat_counter_minus_one = 'h0;
  reg [ID_WIDTH-1:0] id = 'h00;
  reg [ID_WIDTH-1:0] id_next = 'h00;

  reg pending_burst = 1'b0;
  reg active = 1'b0;
  reg last_eot = 1'b0;
  reg last_non_eot = 1'b0;

  reg needs_sync = 1'b0;
  wire has_sync = ~needs_sync | s_axi_sync;

  wire s_axi_sync_valid = has_sync & s_axi_valid;
  wire transfer_abort_s;

  wire last_load;
  wire last;
  wire early_tlast;

  assign xfer_req = active;

  assign response_id = id;

  assign source_id = id;
  assign source_eot = eot || early_tlast;

  assign last = eot ? last_eot : last_non_eot;

  assign s_axi_ready = (pending_burst & active) & ~transfer_abort_s;
  assign m_axi_valid = s_axi_sync_valid & s_axi_ready;
  assign m_axi_data = s_axi_data;
  assign m_axi_last = last || early_tlast;
  assign m_axi_partial_burst = early_tlast;

  assign block_descr_to_dst = transfer_abort_s;

  generate if (ALLOW_ABORT == 1) begin
    wire programmed_last;

    reg transfer_abort = 1'b0;
    reg req_xlast_d = 1'b0;
    reg [1:0] transfer_id = 2'b0;

    assign programmed_last = (last == 1'b1 && eot == 1'b1 && req_xlast_d == 1'b1);
    /*
     * A 'last' on the external interface indicates the end of an packet. If such a
     * 'last' indicator is observed before the end of the current transfer stop
     * accepting data on the external interface until a new descriptor is
     * received that is the first segment of a transfer.
     */
    always @(posedge clk) begin
      if (resetn == 1'b0) begin
        transfer_abort <= 1'b0;
      end else if (req_valid == 1'b1 && req_ready == 1'b1 && req_xlast_d == 1'b1) begin
        transfer_abort <= 1'b0;
      end else if (m_axi_valid == 1'b1) begin
        if (programmed_last == 1'b1) begin
          transfer_abort <= 1'b0;
        end else if (s_axi_last == 1'b1) begin
          transfer_abort <= 1'b1;
        end
      end
    end

    always @(posedge clk) begin
      if (req_ready == 1'b1 && req_valid == 1'b1) begin
        req_xlast_d <= req_xlast;
      end
    end

    assign transfer_abort_s = transfer_abort;
    assign early_tlast = (s_axi_ready == 1'b1) && (m_axi_valid == 1'b1) &&
                         (s_axi_last == 1'b1) && (programmed_last == 1'b0);

    assign rewind_req_valid = early_tlast;
    assign rewind_req_data = {transfer_id,req_xlast_d,id_next};

    // The width of the id must fit the number of transfers that can be in flight
    // in the burst memory
    always @(posedge clk) begin
      if (resetn == 1'b0) begin
        transfer_id <= 2'b0;
      end else if (req_valid == 1'b1 && req_ready == 1'b1) begin
        transfer_id <= transfer_id + 1'b1;
      end
    end

  end else begin
    assign transfer_abort_s = 1'b0;
    assign early_tlast = 1'b0;
    assign rewind_req_valid = 1'b0;
    assign rewind_req_data = 'h0;
  end endgenerate

  /*
   * If req_sync_transfer_start is set all incoming beats will be skipped until
   * one has s_axi_sync set. This will be the first beat that is passsed through.
   */
  always @(posedge clk) begin
    if (req_ready == 1'b1) begin
      needs_sync <= req_sync_transfer_start;
    end else if (m_axi_valid == 1'b1) begin
      needs_sync <= 1'b0;
    end
  end

  // If we want to support zero delay between transfers we have to assert
  // req_ready on the same cycle on which the last load happens.
  // In case early tlast happens accept the new descriptor only when the rewind
  // request got accepted.
  // In case the data mover is not active accept a new descriptor only when the
  // upstream logic incremented its id (pending_burst is set).
  assign last_load = m_axi_valid && last_eot && eot;
  assign req_ready = (last_load && ~early_tlast) ||
                     ((~active && ~transfer_abort_s) && pending_burst) ||
                     (transfer_abort_s && rewind_req_ready);

  always @(posedge clk) begin
    if (req_ready) begin
      last_eot <= req_last_burst_length == 'h0;
      last_non_eot <= 1'b0;
      beat_counter <= 'h1;
    end else if (m_axi_valid == 1'b1) begin
      last_eot <= beat_counter == last_burst_length;
      last_non_eot <= beat_counter == BEAT_COUNTER_MAX;
      beat_counter <= beat_counter + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (req_ready)
      last_burst_length <= req_last_burst_length;
  end

  always @(posedge clk) begin
    if (req_ready) begin
      beat_counter_minus_one <= 'h0;
    end else if (m_axi_valid == 1'b1) begin
      beat_counter_minus_one <= beat_counter;
    end
  end

  always @(posedge clk) begin
    if (last_load || early_tlast) begin
      bl_valid <= 1'b1;
      measured_last_burst_length <= beat_counter_minus_one;
    end else if (bl_ready) begin
      bl_valid <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      active <= 1'b0;
    end else if (req_valid == 1'b1 && req_ready == 1'b1) begin
      active <= 1'b1;
    end else if (last_load == 1'b1) begin
      active <= 1'b0;
    end
  end

  always @(*)
  begin
    if (m_axi_valid == 1'b1 && (last == 1'b1 || early_tlast == 1'b1))
      id_next <= inc_id(id);
    else
      id_next <= id;
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      id <= 'h0;
    end else begin
      id <= id_next;
    end
  end

  always @(posedge clk) begin
    pending_burst <= id_next != request_id;
  end

endmodule
